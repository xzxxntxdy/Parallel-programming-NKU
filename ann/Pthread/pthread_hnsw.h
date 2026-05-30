#pragma once

#include "pthread_benchmark.h"
#include "pthread_common.h"
#include "pthread_ivf.h"
#include "hnswlib/hnswlib/hnswlib.h"

#include <future>
#include <memory>

using namespace ann;
using namespace hnswlib;
using namespace pthread_ann;

// ============================================================
// HNSW advanced pthread/openmp/std-thread experiments
// ============================================================

inline void hnsw_heap_to_ann_queue(
    std::priority_queue<std::pair<float, labeltype> > raw,
    std::priority_queue<std::pair<float, uint32_t> >& out) {
    while (!raw.empty()) {
        std::pair<float, labeltype> r = raw.top();
        raw.pop();
        out.push(std::make_pair(r.first, static_cast<uint32_t>(r.second)));
    }
}

inline void hnsw_internal_heap_to_ann_queue(
    const HierarchicalNSW<float>& hnsw,
    std::priority_queue<std::pair<float, hnswlib::tableint>,
                        std::vector<std::pair<float, hnswlib::tableint> >,
                        HierarchicalNSW<float>::CompareByFirst> raw,
    std::priority_queue<std::pair<float, uint32_t> >& out,
    size_t k) {
    while (!raw.empty()) {
        std::pair<float, hnswlib::tableint> r = raw.top();
        raw.pop();
        push_heap_topk(out, r.first, static_cast<uint32_t>(hnsw.getExternalLabel(r.second)), k);
    }
}

inline void build_hnsw_index(const float* base,
                             size_t n,
                             size_t dim,
                             size_t M,
                             size_t ef_construction,
                             InnerProductSpace& ipspace,
                             HierarchicalNSW<float>& hnsw) {
    (void)dim;
    hnsw.addPoint(base, 0);
    for (size_t i = 1; i < n; ++i) {
        hnsw.addPoint(base + i * dim, i);
    }
    hnsw.setEf(ef_construction);
}

inline void hnsw_query_stdthread(const HierarchicalNSW<float>& hnsw,
                                 const float* query,
                                 const int* gt,
                                 size_t nq,
                                 size_t dim,
                                 size_t k,
                                 size_t gt_d,
                                 size_t ef,
                                 int nthreads,
                                 double& avg_lat,
                                 double& avg_rec) {
    if (nthreads <= 0) nthreads = 1;
    const_cast<HierarchicalNSW<float>&>(hnsw).setEf(ef);
    std::vector<float> recs(nq, 0.0f);
    std::vector<std::thread> threads(nthreads);

    struct Arg {
        int tid, nt;
        const HierarchicalNSW<float>* hnsw;
        const float* query;
        const int* gt;
        size_t nq, dim, k, gt_d;
        std::vector<float>* recs;
    };
    std::vector<Arg> args(nthreads);
    auto worker = [](void* ptr) -> void* {
        Arg* a = static_cast<Arg*>(ptr);
        for (size_t qi = a->tid; qi < a->nq; qi += a->nt) {
            std::priority_queue<std::pair<float, uint32_t> > converted;
            hnsw_heap_to_ann_queue(
                a->hnsw->searchKnn(a->query + qi * a->dim, a->k),
                converted);
            (*a->recs)[qi] = calc_recall_k(converted, a->gt, a->gt_d, qi, a->k);
        }
        return NULL;
    };

    long long t0 = now_us();
    for (int t = 0; t < nthreads; ++t) {
        args[t] = {t, nthreads, &hnsw, query, gt, nq, dim, k, gt_d, &recs};
        threads[t] = std::thread(worker, &args[t]);
    }
    for (int t = 0; t < nthreads; ++t) threads[t].join();
    long long t1 = now_us();
    avg_lat = (t1 - t0) / 1000.0 / std::max<size_t>(1, nq);
    avg_rec = mean_float(recs);
}

inline void hnsw_query_async(const HierarchicalNSW<float>& hnsw,
                             const float* query,
                             const int* gt,
                             size_t nq,
                             size_t dim,
                             size_t k,
                             size_t gt_d,
                             size_t ef,
                             int ntasks,
                             double& avg_lat,
                             double& avg_rec) {
    if (ntasks <= 0) ntasks = 1;
    const_cast<HierarchicalNSW<float>&>(hnsw).setEf(ef);
    std::vector<float> recs(nq, 0.0f);
    std::vector<std::future<void> > futures;
    futures.reserve(ntasks);
    long long t0 = now_us();
    for (int task = 0; task < ntasks; ++task) {
        futures.push_back(std::async(std::launch::async, [&, task]() {
            for (size_t qi = static_cast<size_t>(task); qi < nq; qi += ntasks) {
                std::priority_queue<std::pair<float, uint32_t> > converted;
                hnsw_heap_to_ann_queue(hnsw.searchKnn(query + qi * dim, k), converted);
                recs[qi] = calc_recall_k(converted, gt, gt_d, qi, k);
            }
        }));
    }
    for (size_t i = 0; i < futures.size(); ++i) futures[i].get();
    long long t1 = now_us();
    avg_lat = (t1 - t0) / 1000.0 / std::max<size_t>(1, nq);
    avg_rec = mean_float(recs);
}

inline void hnsw_multi_entry_layer0(const HierarchicalNSW<float>& hnsw,
                                    const float* query,
                                    const int* gt,
                                    size_t nq,
                                    size_t dim,
                                    size_t k,
                                    size_t gt_d,
                                    size_t ef,
                                    int entries,
                                    double& avg_lat,
                                    double& avg_rec) {
    if (entries <= 0) entries = 1;
    size_t count = const_cast<HierarchicalNSW<float>&>(hnsw).getCurrentElementCount();
    if (count == 0) {
        avg_lat = 0.0;
        avg_rec = 0.0;
        return;
    }
    std::vector<std::vector<std::priority_queue<std::pair<float, uint32_t> > > >
        local(entries, std::vector<std::priority_queue<std::pair<float, uint32_t> > >(nq));
    std::vector<std::thread> threads(entries);

    struct Arg {
        int eid, entries;
        const HierarchicalNSW<float>* hnsw;
        const float* query;
        size_t nq, dim, k, ef, count;
        std::vector<std::priority_queue<std::pair<float, uint32_t> > >* out;
    };
    std::vector<Arg> args(entries);
    auto worker = [](void* ptr) -> void* {
        Arg* a = static_cast<Arg*>(ptr);
        hnswlib::tableint entry =
            static_cast<hnswlib::tableint>((static_cast<size_t>(a->eid) * a->count) /
                                           static_cast<size_t>(a->entries));
        if (entry >= a->count) entry = static_cast<hnswlib::tableint>(a->count - 1);
        for (size_t qi = 0; qi < a->nq; ++qi) {
            auto raw = a->hnsw->searchBaseLayerST<true>(
                entry, a->query + qi * a->dim, std::max(a->ef, a->k));
            hnsw_internal_heap_to_ann_queue(*a->hnsw, raw, (*a->out)[qi], a->k);
        }
        return NULL;
    };

    long long t0 = now_us();
    for (int e = 0; e < entries; ++e) {
        args[e] = {e, entries, &hnsw, query, nq, dim, k, ef, count, &local[e]};
        threads[e] = std::thread(worker, &args[e]);
    }
    for (int e = 0; e < entries; ++e) threads[e].join();

    std::vector<float> recs(nq, 0.0f);
    for (size_t qi = 0; qi < nq; ++qi) {
        std::priority_queue<std::pair<float, uint32_t> > merged;
        for (int e = 0; e < entries; ++e) {
            while (!local[e][qi].empty()) {
                std::pair<float, uint32_t> r = local[e][qi].top();
                local[e][qi].pop();
                push_heap_topk(merged, r.first, r.second, k);
            }
        }
        recs[qi] = calc_recall_k(merged, gt, gt_d, qi, k);
    }
    long long t1 = now_us();
    avg_lat = (t1 - t0) / 1000.0 / std::max<size_t>(1, nq);
    avg_rec = mean_float(recs);
}

inline void hnsw_layer0_edge_partition(const HierarchicalNSW<float>& hnsw,
                                       const float* query,
                                       const int* gt,
                                       size_t nq,
                                       size_t dim,
                                       size_t k,
                                       size_t gt_d,
                                       size_t ef,
                                       int partitions,
                                       double& avg_lat,
                                       double& avg_rec) {
    if (partitions <= 0) partitions = 1;
    size_t count = const_cast<HierarchicalNSW<float>&>(hnsw).getCurrentElementCount();
    if (count == 0) {
        avg_lat = 0.0;
        avg_rec = 0.0;
        return;
    }

    hnswlib::tableint entry = hnsw.enterpoint_node_;
    if (entry >= count) entry = 0;
    std::vector<std::vector<std::priority_queue<std::pair<float, uint32_t> > > >
        local(partitions, std::vector<std::priority_queue<std::pair<float, uint32_t> > >(nq));
    std::vector<std::thread> threads(partitions);

    struct Arg {
        int pid, partitions;
        const HierarchicalNSW<float>* hnsw;
        hnswlib::tableint entry;
        const float* query;
        size_t nq, dim, k, ef, count;
        std::vector<std::priority_queue<std::pair<float, uint32_t> > >* out;
    };
    std::vector<Arg> args(partitions);
    auto worker = [](void* ptr) -> void* {
        Arg* a = static_cast<Arg*>(ptr);
        for (size_t qi = 0; qi < a->nq; ++qi) {
            const float* q = a->query + qi * a->dim;
            std::vector<unsigned char> visited(a->count, 0);
            typedef std::priority_queue<
                std::pair<float, hnswlib::tableint>,
                std::vector<std::pair<float, hnswlib::tableint> >,
                HierarchicalNSW<float>::CompareByFirst> TopQueue;
            TopQueue top_candidates;
            std::priority_queue<std::pair<float, hnswlib::tableint> > candidate_set;

            float entry_dist = a->hnsw->fstdistfunc_(
                q, a->hnsw->getDataByInternalId(a->entry),
                a->hnsw->dist_func_param_);
            float lower_bound = entry_dist;
            top_candidates.emplace(entry_dist, a->entry);
            candidate_set.emplace(-entry_dist, a->entry);
            visited[a->entry] = 1;

            while (!candidate_set.empty()) {
                std::pair<float, hnswlib::tableint> current = candidate_set.top();
                float candidate_dist = -current.first;
                if (candidate_dist > lower_bound && top_candidates.size() >= a->ef) break;
                candidate_set.pop();

                int* data = reinterpret_cast<int*>(
                    a->hnsw->get_linklist0(current.second));
                size_t degree = a->hnsw->getListCount(
                    reinterpret_cast<hnswlib::linklistsizeint*>(data));
                for (size_t j = 0; j < degree; ++j) {
                    if (static_cast<int>(j % static_cast<size_t>(a->partitions)) != a->pid) {
                        continue;
                    }
                    hnswlib::tableint candidate_id =
                        static_cast<hnswlib::tableint>(*(data + 1 + j));
                    if (candidate_id >= a->count || visited[candidate_id]) continue;
                    visited[candidate_id] = 1;
                    float dist = a->hnsw->fstdistfunc_(
                        q, a->hnsw->getDataByInternalId(candidate_id),
                        a->hnsw->dist_func_param_);
                    if (top_candidates.size() < a->ef || dist < lower_bound) {
                        candidate_set.emplace(-dist, candidate_id);
                        top_candidates.emplace(dist, candidate_id);
                        if (top_candidates.size() > a->ef) top_candidates.pop();
                        if (!top_candidates.empty()) lower_bound = top_candidates.top().first;
                    }
                }
            }
            hnsw_internal_heap_to_ann_queue(*a->hnsw, top_candidates, (*a->out)[qi], a->k);
        }
        return NULL;
    };

    long long t0 = now_us();
    for (int p = 0; p < partitions; ++p) {
        args[p] = {p, partitions, &hnsw, entry, query, nq, dim, k, ef, count, &local[p]};
        threads[p] = std::thread(worker, &args[p]);
    }
    for (int p = 0; p < partitions; ++p) threads[p].join();

    std::vector<float> recs(nq, 0.0f);
    for (size_t qi = 0; qi < nq; ++qi) {
        std::priority_queue<std::pair<float, uint32_t> > merged;
        for (int p = 0; p < partitions; ++p) {
            merge_topk(merged, local[p][qi], k);
        }
        recs[qi] = calc_recall_k(merged, gt, gt_d, qi, k);
    }
    long long t1 = now_us();
    avg_lat = (t1 - t0) / 1000.0 / std::max<size_t>(1, nq);
    avg_rec = mean_float(recs);
}

inline void hnsw_layer0_point_partition(const float* base,
                                        const float* query,
                                        const int* gt,
                                        size_t base_n,
                                        size_t nq,
                                        size_t dim,
                                        size_t k,
                                        size_t gt_d,
                                        int partitions,
                                        double& avg_lat,
                                        double& avg_rec) {
    if (partitions <= 0) partitions = 1;
    std::vector<std::vector<std::priority_queue<std::pair<float, uint32_t> > > >
        local(partitions, std::vector<std::priority_queue<std::pair<float, uint32_t> > >(nq));
    std::vector<std::thread> threads(partitions);

    struct Arg {
        int pid, partitions;
        const float* base;
        const float* query;
        size_t base_n, nq, dim, k;
        std::vector<std::priority_queue<std::pair<float, uint32_t> > >* out;
    };
    std::vector<Arg> args(partitions);
    auto worker = [](void* ptr) -> void* {
        Arg* a = static_cast<Arg*>(ptr);
        size_t begin = static_cast<size_t>(a->pid) * a->base_n /
                       static_cast<size_t>(a->partitions);
        size_t end = static_cast<size_t>(a->pid + 1) * a->base_n /
                     static_cast<size_t>(a->partitions);
        for (size_t qi = 0; qi < a->nq; ++qi) {
            const float* q = a->query + qi * a->dim;
            std::priority_queue<std::pair<float, uint32_t> >& heap = (*a->out)[qi];
            for (size_t id = begin; id < end; ++id) {
                float dist = ip_distance(a->base + id * a->dim, q, a->dim,
                                         kManualNeonUnroll4);
                push_heap_topk(heap, dist, static_cast<uint32_t>(id), a->k);
            }
        }
        return NULL;
    };

    long long t0 = now_us();
    for (int p = 0; p < partitions; ++p) {
        args[p] = {p, partitions, base, query, base_n, nq, dim, k, &local[p]};
        threads[p] = std::thread(worker, &args[p]);
    }
    for (int p = 0; p < partitions; ++p) threads[p].join();

    std::vector<float> recs(nq, 0.0f);
    for (size_t qi = 0; qi < nq; ++qi) {
        std::priority_queue<std::pair<float, uint32_t> > merged;
        for (int p = 0; p < partitions; ++p) {
            merge_topk(merged, local[p][qi], k);
        }
        recs[qi] = calc_recall_k(merged, gt, gt_d, qi, k);
    }
    long long t1 = now_us();
    avg_lat = (t1 - t0) / 1000.0 / std::max<size_t>(1, nq);
    avg_rec = mean_float(recs);
}

struct IvfHnswIndex {
    IVFIndex ivf;
    size_t dim;
    int nlist;
    int M;
    int ef_construction;
    std::vector<std::unique_ptr<InnerProductSpace> > spaces;
    std::vector<std::unique_ptr<HierarchicalNSW<float> > > graphs;
};

inline void build_ivf_hnsw_index(const float* base,
                                 size_t n,
                                 size_t dim,
                                 int nlist,
                                 int M,
                                 int ef_construction,
                                 int kmeans_iters,
                                 IvfHnswIndex& out) {
    out.dim = dim;
    out.nlist = nlist;
    out.M = M;
    out.ef_construction = ef_construction;
    build_ivf_index(base, n, dim, nlist, out.ivf, kmeans_iters);
    out.spaces.clear();
    out.graphs.clear();
    out.spaces.resize(nlist);
    out.graphs.resize(nlist);
    for (int cid = 0; cid < nlist; ++cid) {
        const std::vector<uint32_t>& ids = out.ivf.lists[cid];
        if (ids.empty()) continue;
        out.spaces[cid].reset(new InnerProductSpace(static_cast<int>(dim)));
        out.graphs[cid].reset(new HierarchicalNSW<float>(
            out.spaces[cid].get(), ids.size(), M, ef_construction));
        for (size_t i = 0; i < ids.size(); ++i) {
            uint32_t id = ids[i];
            out.graphs[cid]->addPoint(base + static_cast<size_t>(id) * dim, id);
        }
        out.graphs[cid]->setEf(ef_construction);
    }
}

inline void ivf_hnsw_query_parallel(const IvfHnswIndex& index,
                                    const float* query,
                                    const int* gt,
                                    size_t nq,
                                    size_t k,
                                    size_t gt_d,
                                    int nprobe,
                                    size_t ef,
                                    int nthreads,
                                    double& avg_lat,
                                    double& avg_rec) {
    if (nthreads <= 0) nthreads = 1;
    std::vector<float> recs(nq, 0.0f);
    std::vector<std::thread> threads(nthreads);

    struct Arg {
        int tid, nt;
        const IvfHnswIndex* index;
        const float* query;
        const int* gt;
        size_t nq, k, gt_d, ef;
        int nprobe;
        std::vector<float>* recs;
    };
    std::vector<Arg> args(nthreads);
    auto worker = [](void* ptr) -> void* {
        Arg* a = static_cast<Arg*>(ptr);
        for (size_t qi = a->tid; qi < a->nq; qi += a->nt) {
            std::vector<int> probes;
            ivf_select_probe_ids(a->index->ivf,
                                 a->query + qi * a->index->dim,
                                 a->nprobe,
                                 probes);
            std::priority_queue<std::pair<float, uint32_t> > merged;
            for (size_t pi = 0; pi < probes.size(); ++pi) {
                int cid = probes[pi];
                if (cid < 0 || cid >= a->index->nlist || !a->index->graphs[cid]) continue;
                const HierarchicalNSW<float>& graph = *a->index->graphs[cid];
                const_cast<HierarchicalNSW<float>&>(graph).setEf(a->ef);
                std::priority_queue<std::pair<float, uint32_t> > local;
                hnsw_heap_to_ann_queue(
                    graph.searchKnn(a->query + qi * a->index->dim, a->k),
                    local);
                while (!local.empty()) {
                    std::pair<float, uint32_t> r = local.top();
                    local.pop();
                    push_heap_topk(merged, r.first, r.second, a->k);
                }
            }
            (*a->recs)[qi] = calc_recall_k(merged, a->gt, a->gt_d, qi, a->k);
        }
        return NULL;
    };

    long long t0 = now_us();
    for (int t = 0; t < nthreads; ++t) {
        args[t] = {t, nthreads, &index, query, gt, nq, k, gt_d, ef,
                   nprobe, &recs};
        threads[t] = std::thread(worker, &args[t]);
    }
    for (int t = 0; t < nthreads; ++t) threads[t].join();
    long long t1 = now_us();
    avg_lat = (t1 - t0) / 1000.0 / std::max<size_t>(1, nq);
    avg_rec = mean_float(recs);
}
