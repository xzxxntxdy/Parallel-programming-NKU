#pragma once

#include "mpi_ivf.h"
#include "hnswlib/hnswlib/hnswlib.h"

#include <memory>

namespace mpi_ann {

struct LocalHNSWIndex {
    size_t n = 0;
    size_t dim = 0;
    uint32_t global_begin = 0;
    std::unique_ptr<hnswlib::InnerProductSpace> space;
    std::unique_ptr<hnswlib::HierarchicalNSW<float> > hnsw;
};

inline void build_local_hnsw(const std::vector<float>& local_base,
                             size_t dim,
                             uint32_t global_begin,
                             size_t m,
                             size_t ef_construction,
                             LocalHNSWIndex& index) {
    index.n = dim ? local_base.size() / dim : 0;
    index.dim = dim;
    index.global_begin = global_begin;
    index.space.reset(new hnswlib::InnerProductSpace(static_cast<int>(dim)));
    if (index.n == 0) return;
    index.hnsw.reset(new hnswlib::HierarchicalNSW<float>(
        index.space.get(), index.n, m, ef_construction));
    for (size_t i = 0; i < index.n; ++i) {
        index.hnsw->addPoint(local_base.data() + i * dim,
                             static_cast<hnswlib::labeltype>(global_begin + i));
    }
    index.hnsw->setEf(ef_construction);
}

inline std::priority_queue<std::pair<float, uint32_t> >
search_local_hnsw(LocalHNSWIndex& index,
                  const float* query,
                  size_t k,
                  size_t ef) {
    std::priority_queue<std::pair<float, uint32_t> > out;
    if (!index.hnsw) return out;
    (void)ef;
    std::priority_queue<std::pair<float, hnswlib::labeltype> > raw =
        index.hnsw->searchKnn(query, k);
    while (!raw.empty()) {
        out.push(std::make_pair(raw.top().first, static_cast<uint32_t>(raw.top().second)));
        raw.pop();
    }
    return out;
}

inline void search_local_hnsw_batch(LocalHNSWIndex& index,
                                    const std::vector<float>& query,
                                    size_t nq,
                                    size_t k,
                                    size_t ef,
                                    int threads,
                                    const std::string& thread_model,
                                    std::vector<float>& local_dist,
                                    std::vector<uint32_t>& local_ids) {
    local_dist.assign(nq * k, std::numeric_limits<float>::infinity());
    local_ids.assign(nq * k, kInvalidId);
    if (index.hnsw) index.hnsw->setEf(ef);
    parallel_for_queries(nq, threads, thread_model, [&](size_t qi) {
        std::priority_queue<std::pair<float, uint32_t> > heap =
            search_local_hnsw(index, query.data() + qi * index.dim, k, ef);
        heap_to_fixed_arrays(heap, k, local_dist.data() + qi * k, local_ids.data() + qi * k);
    });
}

struct ClusterHNSW {
    std::vector<uint32_t> local_ids;
    std::unique_ptr<hnswlib::HierarchicalNSW<float> > hnsw;
};

struct LocalIVFHNSWIndex {
    LocalIVFIndex ivf;
    std::unique_ptr<hnswlib::InnerProductSpace> space;
    std::vector<ClusterHNSW> clusters;
    size_t m = 16;
    size_t ef_construction = 100;
};

inline void build_local_ivf_hnsw(const std::vector<float>& local_base,
                                 size_t dim,
                                 uint32_t global_begin,
                                 int nlist,
                                 int kmeans_iters,
                                 size_t m,
                                 size_t ef_construction,
                                 ann::SearchMethod kernel,
                                 LocalIVFHNSWIndex& index) {
    build_local_ivf(local_base, dim, global_begin, nlist, kmeans_iters, kernel, index.ivf);
    index.space.reset(new hnswlib::InnerProductSpace(static_cast<int>(dim)));
    index.m = m;
    index.ef_construction = ef_construction;
    index.clusters.clear();
    index.clusters.resize(index.ivf.nlist);
    for (int cid = 0; cid < index.ivf.nlist; ++cid) {
        ClusterHNSW& cluster = index.clusters[cid];
        cluster.local_ids = index.ivf.lists[cid];
        if (cluster.local_ids.empty()) continue;
        cluster.hnsw.reset(new hnswlib::HierarchicalNSW<float>(
            index.space.get(), cluster.local_ids.size(), m, ef_construction));
        for (size_t i = 0; i < cluster.local_ids.size(); ++i) {
            uint32_t local_id = cluster.local_ids[i];
            cluster.hnsw->addPoint(local_base.data() + static_cast<size_t>(local_id) * dim,
                                   static_cast<hnswlib::labeltype>(global_begin + local_id));
        }
        cluster.hnsw->setEf(ef_construction);
    }
}

inline std::priority_queue<std::pair<float, uint32_t> >
search_local_ivf_hnsw(LocalIVFHNSWIndex& index,
                      const float* query,
                      size_t k,
                      int nprobe,
                      size_t ef,
                      ann::SearchMethod kernel,
                      size_t* visited_clusters = nullptr) {
    std::priority_queue<std::pair<float, uint32_t> > out;
    (void)ef;
    std::vector<int> probes;
    top_probe_ids(index.ivf, query, nprobe, kernel, probes);
    size_t used = 0;
    for (int cid : probes) {
        ClusterHNSW& cluster = index.clusters[cid];
        if (!cluster.hnsw) continue;
        used++;
        std::priority_queue<std::pair<float, hnswlib::labeltype> > raw =
            cluster.hnsw->searchKnn(query, k);
        while (!raw.empty()) {
            push_topk(out, raw.top().first, static_cast<uint32_t>(raw.top().second), k);
            raw.pop();
        }
    }
    if (visited_clusters) *visited_clusters = used;
    return out;
}

inline void search_local_ivf_hnsw_batch(LocalIVFHNSWIndex& index,
                                        const std::vector<float>& query,
                                        size_t nq,
                                        size_t k,
                                        int nprobe,
                                        size_t ef,
                                        ann::SearchMethod kernel,
                                        int threads,
                                        const std::string& thread_model,
                                        std::vector<float>& local_dist,
                                        std::vector<uint32_t>& local_ids,
                                        double& avg_clusters) {
    local_dist.assign(nq * k, std::numeric_limits<float>::infinity());
    local_ids.assign(nq * k, kInvalidId);
    for (ClusterHNSW& cluster : index.clusters) {
        if (cluster.hnsw) cluster.hnsw->setEf(ef);
    }
    std::vector<size_t> used(nq, 0);
    parallel_for_queries(nq, threads, thread_model, [&](size_t qi) {
        std::priority_queue<std::pair<float, uint32_t> > heap =
            search_local_ivf_hnsw(index, query.data() + qi * index.ivf.dim,
                                  k, nprobe, ef, kernel, &used[qi]);
        heap_to_fixed_arrays(heap, k, local_dist.data() + qi * k, local_ids.data() + qi * k);
    });
    size_t sum = 0;
    for (size_t v : used) sum += v;
    avg_clusters = nq ? static_cast<double>(sum) / static_cast<double>(nq) : 0.0;
}

}  // namespace mpi_ann
