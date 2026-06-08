#pragma once

#include "gpu_dataset.h"

#include <cstring>
#include <numeric>

namespace gpu_ann {

struct IvfIndex {
    size_t n = 0;
    size_t dim = 0;
    int nlist = 0;
    std::vector<float> centroids;
    std::vector<std::vector<int> > lists;
};

inline int nearest_centroid(const float* x,
                            const std::vector<float>& centroids,
                            int nlist,
                            size_t dim) {
    int best = 0;
    float best_score = -std::numeric_limits<float>::infinity();
    for (int c = 0; c < nlist; ++c) {
        float score = inner_product_cpu(x, centroids.data() + static_cast<size_t>(c) * dim, dim);
        if (score > best_score) {
            best_score = score;
            best = c;
        }
    }
    return best;
}

inline IvfIndex build_ivf(const std::vector<float>& base,
                          size_t nbase,
                          size_t dim,
                          int requested_nlist,
                          int iters) {
    IvfIndex index;
    index.n = nbase;
    index.dim = dim;
    index.nlist = std::max(1, std::min<int>(requested_nlist, static_cast<int>(std::max<size_t>(1, nbase))));
    index.centroids.assign(static_cast<size_t>(index.nlist) * dim, 0.0f);
    index.lists.assign(index.nlist, std::vector<int>());
    if (nbase == 0 || dim == 0) return index;

    for (int c = 0; c < index.nlist; ++c) {
        size_t src = std::min(nbase - 1, static_cast<size_t>(c) * nbase / index.nlist);
        std::memcpy(index.centroids.data() + static_cast<size_t>(c) * dim,
                    base.data() + src * dim,
                    dim * sizeof(float));
    }

    std::vector<int> assignment(nbase, 0);
    std::vector<int> counts(index.nlist, 0);
    std::vector<double> sums(static_cast<size_t>(index.nlist) * dim, 0.0);
    for (int iter = 0; iter < iters; ++iter) {
        std::fill(counts.begin(), counts.end(), 0);
        std::fill(sums.begin(), sums.end(), 0.0);
        for (size_t i = 0; i < nbase; ++i) {
            const float* x = base.data() + i * dim;
            int c = nearest_centroid(x, index.centroids, index.nlist, dim);
            assignment[i] = c;
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

    for (size_t i = 0; i < nbase; ++i) {
        index.lists[assignment[i]].push_back(static_cast<int>(i));
    }
    return index;
}

inline std::vector<int> top_probe_ids(const IvfIndex& index,
                                      const float* query,
                                      int nprobe) {
    int np = std::max(1, std::min(nprobe, index.nlist));
    std::vector<std::pair<float, int> > scored(index.nlist);
    for (int c = 0; c < index.nlist; ++c) {
        float score = inner_product_cpu(query, index.centroids.data() + static_cast<size_t>(c) * index.dim, index.dim);
        scored[c] = std::make_pair(score, c);
    }
    if (np < index.nlist) {
        std::nth_element(scored.begin(), scored.begin() + np, scored.end(),
                         [](const std::pair<float, int>& a, const std::pair<float, int>& b) {
                             return a.first > b.first;
                         });
        scored.resize(np);
    }
    std::sort(scored.begin(), scored.end(), [](const std::pair<float, int>& a,
                                               const std::pair<float, int>& b) {
        if (a.first != b.first) return a.first > b.first;
        return a.second < b.second;
    });
    std::vector<int> probes;
    probes.reserve(scored.size());
    for (const auto& item : scored) probes.push_back(item.second);
    return probes;
}

inline std::vector<int> collect_ivf_candidates(const IvfIndex& index,
                                               const float* query,
                                               int nprobe) {
    std::vector<int> probes = top_probe_ids(index, query, nprobe);
    size_t total = 0;
    for (int cid : probes) total += index.lists[cid].size();
    std::vector<int> ids;
    ids.reserve(total);
    for (int cid : probes) {
        const std::vector<int>& list = index.lists[cid];
        ids.insert(ids.end(), list.begin(), list.end());
    }
    return ids;
}

}  // namespace gpu_ann
