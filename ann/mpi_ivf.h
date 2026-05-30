#pragma once

#include "mpi_common.h"

#include <numeric>

namespace mpi_ann {

struct LocalIVFIndex {
    size_t n = 0;
    size_t dim = 0;
    int nlist = 0;
    uint32_t global_begin = 0;
    std::vector<float> centroids;
    std::vector<std::vector<uint32_t> > lists;
    std::vector<int> assignment;
};

inline int nearest_centroid(const float* x,
                            const std::vector<float>& centroids,
                            int nlist,
                            size_t dim,
                            ann::SearchMethod kernel) {
    int best = 0;
    float best_dist = std::numeric_limits<float>::infinity();
    for (int c = 0; c < nlist; ++c) {
        float dist = ann::ip_distance(centroids.data() + static_cast<size_t>(c) * dim,
                                      x, dim, kernel);
        if (dist < best_dist) {
            best_dist = dist;
            best = c;
        }
    }
    return best;
}

inline void build_local_ivf(const std::vector<float>& local_base,
                            size_t dim,
                            uint32_t global_begin,
                            int nlist,
                            int iters,
                            ann::SearchMethod kernel,
                            LocalIVFIndex& index) {
    index.n = dim ? local_base.size() / dim : 0;
    index.dim = dim;
    index.nlist = std::max(1, std::min<int>(nlist, static_cast<int>(std::max<size_t>(1, index.n))));
    index.global_begin = global_begin;
    index.centroids.assign(static_cast<size_t>(index.nlist) * dim, 0.0f);
    index.assignment.assign(index.n, 0);
    index.lists.assign(index.nlist, std::vector<uint32_t>());
    if (index.n == 0 || dim == 0) return;

    for (int c = 0; c < index.nlist; ++c) {
        size_t src = std::min(index.n - 1, static_cast<size_t>(c) * index.n / index.nlist);
        std::memcpy(index.centroids.data() + static_cast<size_t>(c) * dim,
                    local_base.data() + src * dim,
                    dim * sizeof(float));
    }

    std::vector<int> counts(index.nlist, 0);
    std::vector<double> sums(static_cast<size_t>(index.nlist) * dim, 0.0);
    for (int iter = 0; iter < iters; ++iter) {
        std::fill(counts.begin(), counts.end(), 0);
        std::fill(sums.begin(), sums.end(), 0.0);
        for (size_t i = 0; i < index.n; ++i) {
            const float* x = local_base.data() + i * dim;
            int c = nearest_centroid(x, index.centroids, index.nlist, dim, kernel);
            index.assignment[i] = c;
            counts[c]++;
            double* sum = sums.data() + static_cast<size_t>(c) * dim;
            for (size_t d = 0; d < dim; ++d) sum[d] += x[d];
        }
        for (int c = 0; c < index.nlist; ++c) {
            if (counts[c] == 0) continue;
            float inv = 1.0f / static_cast<float>(counts[c]);
            float* centroid = index.centroids.data() + static_cast<size_t>(c) * dim;
            const double* sum = sums.data() + static_cast<size_t>(c) * dim;
            for (size_t d = 0; d < dim; ++d) centroid[d] = static_cast<float>(sum[d] * inv);
        }
    }

    for (size_t i = 0; i < index.n; ++i) {
        int c = index.assignment[i];
        index.lists[c].push_back(static_cast<uint32_t>(i));
    }
}

inline void top_probe_ids(const LocalIVFIndex& index,
                          const float* query,
                          int nprobe,
                          ann::SearchMethod kernel,
                          std::vector<int>& probe_ids) {
    int np = std::max(1, std::min(nprobe, index.nlist));
    std::vector<std::pair<float, int> > dists(index.nlist);
    for (int c = 0; c < index.nlist; ++c) {
        float dist = ann::ip_distance(index.centroids.data() + static_cast<size_t>(c) * index.dim,
                                      query, index.dim, kernel);
        dists[c] = std::make_pair(dist, c);
    }
    if (np < index.nlist) {
        std::nth_element(dists.begin(), dists.begin() + np, dists.end());
        dists.resize(np);
    }
    std::sort(dists.begin(), dists.end());
    probe_ids.resize(dists.size());
    for (size_t i = 0; i < dists.size(); ++i) probe_ids[i] = dists[i].second;
}

inline std::priority_queue<std::pair<float, uint32_t> >
search_local_ivf(const LocalIVFIndex& index,
                 const std::vector<float>& local_base,
                 const float* query,
                 size_t k,
                 int nprobe,
                 ann::SearchMethod kernel,
                 size_t* visited = nullptr) {
    std::priority_queue<std::pair<float, uint32_t> > heap;
    if (index.n == 0) return heap;
    std::vector<int> probes;
    top_probe_ids(index, query, nprobe, kernel, probes);
    size_t count = 0;
    for (int cid : probes) {
        const std::vector<uint32_t>& list = index.lists[cid];
        count += list.size();
        for (uint32_t local_id : list) {
            float dist = ann::ip_distance(local_base.data() + static_cast<size_t>(local_id) * index.dim,
                                          query, index.dim, kernel);
            push_topk(heap, dist, index.global_begin + local_id, k);
        }
    }
    if (visited) *visited = count;
    return heap;
}

inline void search_local_ivf_batch(const LocalIVFIndex& index,
                                   const std::vector<float>& local_base,
                                   const std::vector<float>& query,
                                   size_t nq,
                                   size_t k,
                                   int nprobe,
                                   ann::SearchMethod kernel,
                                   int threads,
                                   const std::string& thread_model,
                                   std::vector<float>& local_dist,
                                   std::vector<uint32_t>& local_ids,
                                   double& avg_candidates) {
    local_dist.assign(nq * k, std::numeric_limits<float>::infinity());
    local_ids.assign(nq * k, kInvalidId);
    std::vector<size_t> visited(nq, 0);
    parallel_for_queries(nq, threads, thread_model, [&](size_t qi) {
        std::priority_queue<std::pair<float, uint32_t> > heap =
            search_local_ivf(index, local_base, query.data() + qi * index.dim,
                             k, nprobe, kernel, &visited[qi]);
        heap_to_fixed_arrays(heap, k, local_dist.data() + qi * k, local_ids.data() + qi * k);
    });
    size_t sum = 0;
    for (size_t v : visited) sum += v;
    avg_candidates = nq ? static_cast<double>(sum) / static_cast<double>(nq) : 0.0;
}

inline void search_local_flat_batch(const std::vector<float>& local_base,
                                    size_t dim,
                                    uint32_t global_begin,
                                    const std::vector<float>& query,
                                    size_t nq,
                                    size_t k,
                                    ann::SearchMethod kernel,
                                    int threads,
                                    const std::string& thread_model,
                                    std::vector<float>& local_dist,
                                    std::vector<uint32_t>& local_ids) {
    size_t local_n = dim ? local_base.size() / dim : 0;
    local_dist.assign(nq * k, std::numeric_limits<float>::infinity());
    local_ids.assign(nq * k, kInvalidId);
    parallel_for_queries(nq, threads, thread_model, [&](size_t qi) {
        std::priority_queue<std::pair<float, uint32_t> > heap;
        const float* q = query.data() + qi * dim;
        for (size_t i = 0; i < local_n; ++i) {
            float dist = ann::ip_distance(local_base.data() + i * dim, q, dim, kernel);
            push_topk(heap, dist, global_begin + static_cast<uint32_t>(i), k);
        }
        heap_to_fixed_arrays(heap, k, local_dist.data() + qi * k, local_ids.data() + qi * k);
    });
}

}  // namespace mpi_ann
