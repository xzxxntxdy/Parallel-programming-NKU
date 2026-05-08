#include <vector>
#include <cstring>
#include <string>
#include <iostream>
#include <fstream>
#include <set>
#include <chrono>
#include <iomanip>
#include <sstream>
#include <cstdlib>
#include <cerrno>
#include <cstdint>
#include <cmath>
#include <condition_variable>
#include <deque>
#include <memory>
#include <mutex>
#include <thread>
#include <sys/time.h>
#include <sys/stat.h>
#include <omp.h>
#include "hnswlib/hnswlib/hnswlib.h"
#include "flat_scan.h"
#include "ann_search.h"
#include "ann_quant.h"
// 可以自行添加需要的头文件

using namespace hnswlib;

template<typename T>
T *LoadData(std::string data_path, size_t& n, size_t& d)
{
    std::ifstream fin;
    fin.open(data_path, std::ios::in | std::ios::binary);
    fin.read((char*)&n,4);
    fin.read((char*)&d,4);
    T* data = new T[n*d];
    int sz = sizeof(T);
    for(int i = 0; i < n; ++i){
        fin.read(((char*)data + i*d*sz), d*sz);
    }
    fin.close();

    std::cerr<<"load data "<<data_path<<"\n";
    std::cerr<<"dimension: "<<d<<"  number:"<<n<<"  size_per_element:"<<sizeof(T)<<"\n";

    return data;
}

struct SearchResult
{
    float recall;
    int64_t latency; // 单位us
    int64_t coarse_latency; // 单位us，仅 SQ/PQ 使用
    int64_t rerank_latency; // 单位us，仅 SQ/PQ 使用
    int64_t encode_latency; // 单位us，仅 SDC 使用
    int64_t lut_latency; // 单位us，仅 ADC/FastScan 使用
    int64_t scan_latency; // 单位us，查表扫描
    int64_t select_latency; // 单位us，top-p/top-k 选择
};

struct KernelSpec
{
    std::string name;
    std::string family;
    ann::SearchMethod flat_method;
    size_t prefetch_distance;
    int pq_m;
    int pq_p;
    int sq_p;
    int fs_block;
    bool valid;

    KernelSpec() : family(""), flat_method(ann::kManualNeon), prefetch_distance(16),
                   pq_m(0), pq_p(0), sq_p(0), fs_block(32), valid(false) {}
};

double mean_double(const std::vector<double>& values)
{
    double sum = 0.0;
    for(size_t i = 0; i < values.size(); ++i) {
        sum += values[i];
    }
    return values.empty() ? 0.0 : sum / values.size();
}

double stddev_double(const std::vector<double>& values)
{
    if(values.size() < 2) {
        return 0.0;
    }
    double m = mean_double(values);
    double acc = 0.0;
    for(size_t i = 0; i < values.size(); ++i) {
        double diff = values[i] - m;
        acc += diff * diff;
    }
    return std::sqrt(acc / (values.size() - 1));
}

std::string get_files_dir()
{
    struct stat st;
    if(stat("files", &st) == 0 && S_ISDIR(st.st_mode)) {
        return "files";
    }
    const char* home = std::getenv("HOME");
    if(home && home[0]) {
        return std::string(home) + "/files";
    }
    return "files";
}

void ensure_dir(const std::string& path)
{
    if(path.empty()) {
        return;
    }
    if(mkdir(path.c_str(), 0755) != 0 && errno != EEXIST) {
        std::cerr << "warning: failed to create dir " << path << "\n";
    }
}

int64_t now_us()
{
    const unsigned long Converter = 1000 * 1000;
    struct timeval val;
    gettimeofday(&val, NULL);
    return val.tv_sec * Converter + val.tv_usec;
}

float calc_recall(std::priority_queue<std::pair<float, uint32_t> > res,
                  int* test_gt,
                  size_t test_gt_d,
                  size_t query_id,
                  size_t k)
{
    std::set<uint32_t> gtset;
    for(size_t j = 0; j < k; ++j) {
        int t = test_gt[j + query_id * test_gt_d];
        gtset.insert(static_cast<uint32_t>(t));
    }

    size_t acc = 0;
    while(res.size()) {
        uint32_t x = res.top().second;
        if(gtset.find(x) != gtset.end()) {
            ++acc;
        }
        res.pop();
    }
    return static_cast<float>(acc) / k;
}

int method_unroll(ann::SearchMethod method)
{
    if(method == ann::kManualNeonUnroll2) {
        return 2;
    }
    if(method == ann::kManualNeonUnroll4 ||
       method == ann::kManualNeonUnroll4PrefetchHeap ||
       method == ann::kManualNeonUnroll4PrefetchFixedTopK) {
        return 4;
    }
    return 1;
}

int method_prefetch(ann::SearchMethod method)
{
    if(method == ann::kManualNeonUnroll4PrefetchHeap ||
       method == ann::kManualNeonUnroll4PrefetchFixedTopK) {
        return 16;
    }
    return 0;
}

const char* method_topk(ann::SearchMethod method)
{
    return method == ann::kManualNeonUnroll4PrefetchFixedTopK ? "fixed-array" : "heap";
}

SearchResult run_method(float* base,
                        float* test_query,
                        int* test_gt,
                        size_t base_number,
                        size_t vecdim,
                        size_t test_gt_d,
                        size_t query_count,
                        size_t k,
                        ann::SearchMethod method,
                        size_t prefetch_distance = 16)
{
    float avg_recall = 0.0f;
    int64_t total_latency = 0;

    for(size_t i = 0; i < query_count; ++i) {
        int64_t t0 = now_us();
        auto res = ann::flat_search_method(base, test_query + i * vecdim,
                                           base_number, vecdim, k, method,
                                           prefetch_distance);
        int64_t t1 = now_us();
        total_latency += (t1 - t0);
        avg_recall += calc_recall(res, test_gt, test_gt_d, i, k);
    }

    SearchResult result;
    result.recall = avg_recall / query_count;
    result.latency = total_latency / static_cast<int64_t>(query_count);
    result.coarse_latency = 0;
    result.rerank_latency = 0;
    result.encode_latency = 0;
    result.lut_latency = 0;
    result.scan_latency = 0;
    result.select_latency = 0;
    return result;
}

SearchResult run_sq8_method(const ann::SQ8Index& index,
                            float* base,
                            float* test_query,
                            int* test_gt,
                            size_t test_gt_d,
                            size_t query_count,
                            size_t p,
                            size_t k)
{
    float avg_recall = 0.0f;
    int64_t total_latency = 0;
    int64_t total_coarse = 0;
    int64_t total_rerank = 0;

    for(size_t i = 0; i < query_count; ++i) {
        ann::QuantTiming timing;
        int64_t t0 = now_us();
        auto res = ann::sq8_search_rerank_timed(index, base, test_query + i * index.d,
                                                p, k, &timing);
        int64_t t1 = now_us();
        total_latency += (t1 - t0);
        total_coarse += timing.coarse_us;
        total_rerank += timing.rerank_us;
        avg_recall += calc_recall(res, test_gt, test_gt_d, i, k);
    }

    SearchResult result;
    result.recall = avg_recall / query_count;
    result.latency = total_latency / static_cast<int64_t>(query_count);
    result.coarse_latency = total_coarse / static_cast<int64_t>(query_count);
    result.rerank_latency = total_rerank / static_cast<int64_t>(query_count);
    result.encode_latency = 0;
    result.lut_latency = 0;
    result.scan_latency = result.coarse_latency;
    result.select_latency = 0;
    return result;
}

SearchResult run_sq8_u8simd_method(const ann::SQ8Index& index,
                                   float* base,
                                   float* test_query,
                                   int* test_gt,
                                   size_t test_gt_d,
                                   size_t query_count,
                                   size_t p,
                                   size_t k)
{
    float avg_recall = 0.0f;
    int64_t total_latency = 0;
    int64_t total_coarse = 0;
    int64_t total_rerank = 0;

    for(size_t i = 0; i < query_count; ++i) {
        ann::QuantTiming timing;
        int64_t t0 = now_us();
        auto res = ann::sq8_search_rerank_u8simd_timed(index, base,
                                                       test_query + i * index.d,
                                                       p, k, &timing);
        int64_t t1 = now_us();
        total_latency += (t1 - t0);
        total_coarse += timing.coarse_us;
        total_rerank += timing.rerank_us;
        avg_recall += calc_recall(res, test_gt, test_gt_d, i, k);
    }

    SearchResult result;
    result.recall = avg_recall / query_count;
    result.latency = total_latency / static_cast<int64_t>(query_count);
    result.coarse_latency = total_coarse / static_cast<int64_t>(query_count);
    result.rerank_latency = total_rerank / static_cast<int64_t>(query_count);
    result.encode_latency = 0;
    result.lut_latency = 0;
    result.scan_latency = result.coarse_latency;
    result.select_latency = 0;
    return result;
}

SearchResult run_pq_method(const ann::PQIndex& index,
                           float* base,
                           float* test_query,
                           int* test_gt,
                           size_t test_gt_d,
                           size_t query_count,
                           size_t p,
                           size_t k)
{
    float avg_recall = 0.0f;
    int64_t total_latency = 0;
    int64_t total_coarse = 0;
    int64_t total_rerank = 0;

    for(size_t i = 0; i < query_count; ++i) {
        ann::QuantTiming timing;
        int64_t t0 = now_us();
        auto res = ann::pq_adc_search_rerank_timed(index, base, test_query + i * index.d,
                                                   p, k, &timing);
        int64_t t1 = now_us();
        total_latency += (t1 - t0);
        total_coarse += timing.coarse_us;
        total_rerank += timing.rerank_us;
        avg_recall += calc_recall(res, test_gt, test_gt_d, i, k);
    }

    SearchResult result;
    result.recall = avg_recall / query_count;
    result.latency = total_latency / static_cast<int64_t>(query_count);
    result.coarse_latency = total_coarse / static_cast<int64_t>(query_count);
    result.rerank_latency = total_rerank / static_cast<int64_t>(query_count);
    result.encode_latency = 0;
    result.lut_latency = 0;
    result.scan_latency = result.coarse_latency;
    result.select_latency = 0;
    return result;
}

SearchResult run_pq_select_method(const ann::PQIndex& index,
                                  float* base,
                                  float* test_query,
                                  int* test_gt,
                                  size_t test_gt_d,
                                  size_t query_count,
                                  size_t p,
                                  size_t k)
{
    float avg_recall = 0.0f;
    int64_t total_latency = 0;
    int64_t total_coarse = 0;
    int64_t total_rerank = 0;
    int64_t total_lut = 0;
    int64_t total_scan = 0;
    int64_t total_select = 0;

    for(size_t i = 0; i < query_count; ++i) {
        ann::QuantTiming timing;
        int64_t t0 = now_us();
        auto res = ann::pq_adc_search_rerank_select_timed(index, base,
                                                          test_query + i * index.d,
                                                          p, k, &timing);
        int64_t t1 = now_us();
        total_latency += (t1 - t0);
        total_coarse += timing.coarse_us;
        total_rerank += timing.rerank_us;
        total_lut += timing.lut_us;
        total_scan += timing.scan_us;
        total_select += timing.select_us;
        avg_recall += calc_recall(res, test_gt, test_gt_d, i, k);
    }

    SearchResult result;
    result.recall = avg_recall / query_count;
    result.latency = total_latency / static_cast<int64_t>(query_count);
    result.coarse_latency = total_coarse / static_cast<int64_t>(query_count);
    result.rerank_latency = total_rerank / static_cast<int64_t>(query_count);
    result.encode_latency = 0;
    result.lut_latency = total_lut / static_cast<int64_t>(query_count);
    result.scan_latency = total_scan / static_cast<int64_t>(query_count);
    result.select_latency = total_select / static_cast<int64_t>(query_count);
    return result;
}

SearchResult run_pq_sdc_method(const ann::PQIndex& index,
                               const std::vector<float>& sdc_table,
                               float* base,
                               float* test_query,
                               int* test_gt,
                               size_t test_gt_d,
                               size_t query_count,
                               size_t p,
                               size_t k)
{
    float avg_recall = 0.0f;
    int64_t total_latency = 0;
    int64_t total_coarse = 0;
    int64_t total_rerank = 0;
    int64_t total_encode = 0;
    int64_t total_scan = 0;
    int64_t total_select = 0;

    for(size_t i = 0; i < query_count; ++i) {
        ann::QuantTiming timing;
        int64_t t0 = now_us();
        auto res = ann::pq_sdc_search_rerank_select_timed(index, sdc_table, base,
                                                          test_query + i * index.d,
                                                          p, k, &timing);
        int64_t t1 = now_us();
        total_latency += (t1 - t0);
        total_coarse += timing.coarse_us;
        total_rerank += timing.rerank_us;
        total_encode += timing.encode_us;
        total_scan += timing.scan_us;
        total_select += timing.select_us;
        avg_recall += calc_recall(res, test_gt, test_gt_d, i, k);
    }

    SearchResult result;
    result.recall = avg_recall / query_count;
    result.latency = total_latency / static_cast<int64_t>(query_count);
    result.coarse_latency = total_coarse / static_cast<int64_t>(query_count);
    result.rerank_latency = total_rerank / static_cast<int64_t>(query_count);
    result.encode_latency = total_encode / static_cast<int64_t>(query_count);
    result.lut_latency = 0;
    result.scan_latency = total_scan / static_cast<int64_t>(query_count);
    result.select_latency = total_select / static_cast<int64_t>(query_count);
    return result;
}

struct PipelineEncodedItem
{
    size_t qid;
    std::vector<uint8_t> qcode;
    int64_t encode_us;
};

struct PipelineScannedItem
{
    size_t qid;
    std::vector<std::pair<float, uint32_t> > coarse;
    int64_t encode_us;
    int64_t scan_us;
    int64_t select_us;
};

template <typename T>
class BlockingQueue
{
public:
    explicit BlockingQueue(size_t cap) : capacity_(cap == 0 ? 1 : cap), closed_(false) {}

    void push(const std::shared_ptr<T>& item) {
        std::unique_lock<std::mutex> lock(mu_);
        not_full_.wait(lock, [this]() { return closed_ || queue_.size() < capacity_; });
        if(closed_) {
            return;
        }
        queue_.push_back(item);
        not_empty_.notify_one();
    }

    bool pop(std::shared_ptr<T>& item) {
        std::unique_lock<std::mutex> lock(mu_);
        not_empty_.wait(lock, [this]() { return closed_ || !queue_.empty(); });
        if(queue_.empty()) {
            return false;
        }
        item = queue_.front();
        queue_.pop_front();
        not_full_.notify_one();
        return true;
    }

    void close() {
        std::unique_lock<std::mutex> lock(mu_);
        closed_ = true;
        not_empty_.notify_all();
        not_full_.notify_all();
    }

private:
    size_t capacity_;
    bool closed_;
    std::deque<std::shared_ptr<T> > queue_;
    std::mutex mu_;
    std::condition_variable not_empty_;
    std::condition_variable not_full_;
};

std::shared_ptr<PipelineScannedItem>
scan_sdc_encoded_item(const ann::PQIndex& index,
                      const std::vector<float>& sdc_table,
                      const PipelineEncodedItem& encoded,
                      size_t p,
                      size_t k)
{
    size_t select_count = p == 0 ? k : std::min(p, index.n);
    std::shared_ptr<PipelineScannedItem> out(new PipelineScannedItem());
    out->qid = encoded.qid;
    out->encode_us = encoded.encode_us;
    out->coarse.resize(index.n);

    int64_t scan_t0 = now_us();
    for(size_t i = 0; i < index.n; ++i) {
        const uint8_t* code = &index.codes[i * static_cast<size_t>(index.m)];
        float dot = 0.0f;
        for(int part = 0; part < index.m; ++part) {
            size_t offset = static_cast<size_t>(part) * index.ks * index.ks;
            dot += sdc_table[offset + static_cast<size_t>(encoded.qcode[part]) * index.ks + code[part]];
        }
        out->coarse[i] = std::make_pair(1.0f - dot, static_cast<uint32_t>(i));
    }
    int64_t scan_t1 = now_us();

    int64_t select_t0 = now_us();
    if(select_count < out->coarse.size()) {
        std::nth_element(out->coarse.begin(),
                         out->coarse.begin() + static_cast<std::ptrdiff_t>(select_count),
                         out->coarse.end());
    }
    int64_t select_t1 = now_us();
    out->scan_us = scan_t1 - scan_t0;
    out->select_us = select_t1 - select_t0;
    return out;
}

SearchResult run_pq_sdc_pipeline_method(const ann::PQIndex& index,
                                        const std::vector<float>& sdc_table,
                                        float* base,
                                        float* test_query,
                                        int* test_gt,
                                        size_t test_gt_d,
                                        size_t query_count,
                                        size_t p,
                                        size_t k,
                                        size_t queue_capacity,
                                        int stages)
{
    if(stages <= 1) {
        return run_pq_sdc_method(index, sdc_table, base, test_query, test_gt,
                                 test_gt_d, query_count, p, k);
    }

    float avg_recall = 0.0f;
    int64_t total_encode = 0;
    int64_t total_scan = 0;
    int64_t total_select = 0;
    int64_t total_rerank = 0;
    std::mutex stats_mu;
    BlockingQueue<PipelineEncodedItem> encode_q(queue_capacity);
    BlockingQueue<PipelineScannedItem> scan_q(queue_capacity);

    int64_t wall_t0 = now_us();
    std::thread encoder([&]() {
        for(size_t i = 0; i < query_count; ++i) {
            std::shared_ptr<PipelineEncodedItem> item(new PipelineEncodedItem());
            item->qid = i;
            int64_t t0 = now_us();
            ann::pq_encode_query(index, test_query + i * index.d, item->qcode);
            int64_t t1 = now_us();
            item->encode_us = t1 - t0;
            encode_q.push(item);
        }
        encode_q.close();
    });

    std::thread scanner([&]() {
        std::shared_ptr<PipelineEncodedItem> item;
        while(encode_q.pop(item)) {
            std::shared_ptr<PipelineScannedItem> scanned =
                scan_sdc_encoded_item(index, sdc_table, *item, p, k);
            if(stages == 2) {
                int64_t rerank_t0 = now_us();
                std::priority_queue<std::pair<float, uint32_t> > res =
                    p == 0 ? ann::coarse_pairs_to_result(scanned->coarse, k)
                           : ann::rerank_candidate_pairs(scanned->coarse, std::min(p, index.n),
                                                         base, test_query + scanned->qid * index.d,
                                                         index.d, k);
                int64_t rerank_t1 = now_us();
                float recall = calc_recall(res, test_gt, test_gt_d, scanned->qid, k);
                std::lock_guard<std::mutex> lock(stats_mu);
                avg_recall += recall;
                total_encode += scanned->encode_us;
                total_scan += scanned->scan_us;
                total_select += scanned->select_us;
                total_rerank += p == 0 ? 0 : (rerank_t1 - rerank_t0);
            } else {
                scan_q.push(scanned);
            }
        }
        if(stages == 3) {
            scan_q.close();
        }
    });

    std::thread reranker;
    if(stages == 3) {
        reranker = std::thread([&]() {
            std::shared_ptr<PipelineScannedItem> scanned;
            while(scan_q.pop(scanned)) {
                int64_t rerank_t0 = now_us();
                std::priority_queue<std::pair<float, uint32_t> > res =
                    p == 0 ? ann::coarse_pairs_to_result(scanned->coarse, k)
                           : ann::rerank_candidate_pairs(scanned->coarse, std::min(p, index.n),
                                                         base, test_query + scanned->qid * index.d,
                                                         index.d, k);
                int64_t rerank_t1 = now_us();
                float recall = calc_recall(res, test_gt, test_gt_d, scanned->qid, k);
                std::lock_guard<std::mutex> lock(stats_mu);
                avg_recall += recall;
                total_encode += scanned->encode_us;
                total_scan += scanned->scan_us;
                total_select += scanned->select_us;
                total_rerank += p == 0 ? 0 : (rerank_t1 - rerank_t0);
            }
        });
    }

    encoder.join();
    scanner.join();
    if(stages == 3) {
        reranker.join();
    }
    int64_t wall_t1 = now_us();

    SearchResult result;
    result.recall = avg_recall / query_count;
    result.latency = (wall_t1 - wall_t0) / static_cast<int64_t>(query_count);
    result.coarse_latency = (total_encode + total_scan + total_select) /
                            static_cast<int64_t>(query_count);
    result.rerank_latency = total_rerank / static_cast<int64_t>(query_count);
    result.encode_latency = total_encode / static_cast<int64_t>(query_count);
    result.lut_latency = 0;
    result.scan_latency = total_scan / static_cast<int64_t>(query_count);
    result.select_latency = total_select / static_cast<int64_t>(query_count);
    return result;
}

SearchResult run_pq_adc_fastscan_method(const ann::PQIndex& index,
                                        const ann::PQFastScanIndex& fast,
                                        float* base,
                                        float* test_query,
                                        int* test_gt,
                                        size_t test_gt_d,
                                        size_t query_count,
                                        size_t p,
                                        size_t k,
                                        double* avg_lut_mae = NULL)
{
    float avg_recall = 0.0f;
    int64_t total_latency = 0;
    int64_t total_coarse = 0;
    int64_t total_rerank = 0;
    int64_t total_lut = 0;
    int64_t total_scan = 0;
    int64_t total_select = 0;
    double total_mae = 0.0;

    for(size_t i = 0; i < query_count; ++i) {
        ann::QuantTiming timing;
        float mae = 0.0f;
        int64_t t0 = now_us();
        auto res = ann::pq_adc_fastscan_search_rerank_timed(index, fast, base,
                                                            test_query + i * index.d,
                                                            p, k, &timing, &mae);
        int64_t t1 = now_us();
        total_latency += (t1 - t0);
        total_coarse += timing.coarse_us;
        total_rerank += timing.rerank_us;
        total_lut += timing.lut_us;
        total_scan += timing.scan_us;
        total_select += timing.select_us;
        total_mae += mae;
        avg_recall += calc_recall(res, test_gt, test_gt_d, i, k);
    }

    if(avg_lut_mae) {
        *avg_lut_mae = total_mae / query_count;
    }
    SearchResult result;
    result.recall = avg_recall / query_count;
    result.latency = total_latency / static_cast<int64_t>(query_count);
    result.coarse_latency = total_coarse / static_cast<int64_t>(query_count);
    result.rerank_latency = total_rerank / static_cast<int64_t>(query_count);
    result.encode_latency = 0;
    result.lut_latency = total_lut / static_cast<int64_t>(query_count);
    result.scan_latency = total_scan / static_cast<int64_t>(query_count);
    result.select_latency = total_select / static_cast<int64_t>(query_count);
    return result;
}

SearchResult run_pq_sdc_fastscan_method(const ann::PQIndex& index,
                                        const ann::PQFastScanIndex& fast,
                                        const std::vector<float>& sdc_table,
                                        float* base,
                                        float* test_query,
                                        int* test_gt,
                                        size_t test_gt_d,
                                        size_t query_count,
                                        size_t p,
                                        size_t k,
                                        double* avg_lut_mae = NULL)
{
    float avg_recall = 0.0f;
    int64_t total_latency = 0;
    int64_t total_coarse = 0;
    int64_t total_rerank = 0;
    int64_t total_encode = 0;
    int64_t total_lut = 0;
    int64_t total_scan = 0;
    int64_t total_select = 0;
    double total_mae = 0.0;

    for(size_t i = 0; i < query_count; ++i) {
        ann::QuantTiming timing;
        float mae = 0.0f;
        int64_t t0 = now_us();
        auto res = ann::pq_sdc_fastscan_search_rerank_timed(index, fast, sdc_table, base,
                                                            test_query + i * index.d,
                                                            p, k, &timing, &mae);
        int64_t t1 = now_us();
        total_latency += (t1 - t0);
        total_coarse += timing.coarse_us;
        total_rerank += timing.rerank_us;
        total_encode += timing.encode_us;
        total_lut += timing.lut_us;
        total_scan += timing.scan_us;
        total_select += timing.select_us;
        total_mae += mae;
        avg_recall += calc_recall(res, test_gt, test_gt_d, i, k);
    }

    if(avg_lut_mae) {
        *avg_lut_mae = total_mae / query_count;
    }
    SearchResult result;
    result.recall = avg_recall / query_count;
    result.latency = total_latency / static_cast<int64_t>(query_count);
    result.coarse_latency = total_coarse / static_cast<int64_t>(query_count);
    result.rerank_latency = total_rerank / static_cast<int64_t>(query_count);
    result.encode_latency = total_encode / static_cast<int64_t>(query_count);
    result.lut_latency = total_lut / static_cast<int64_t>(query_count);
    result.scan_latency = total_scan / static_cast<int64_t>(query_count);
    result.select_latency = total_select / static_cast<int64_t>(query_count);
    return result;
}

KernelSpec parse_kernel_spec(const std::string& name)
{
    KernelSpec spec;
    spec.name = name;
    spec.valid = true;

    if(name == "flat-scalar") {
        spec.family = "flat";
        spec.flat_method = ann::kScalarNoVec;
    } else if(name == "flat-auto") {
        spec.family = "flat";
        spec.flat_method = ann::kAutoVectorized;
    } else if(name == "flat-neon") {
        spec.family = "flat";
        spec.flat_method = ann::kManualNeon;
    } else if(name == "flat-unroll2") {
        spec.family = "flat";
        spec.flat_method = ann::kManualNeonUnroll2;
    } else if(name == "flat-unroll4") {
        spec.family = "flat";
        spec.flat_method = ann::kManualNeonUnroll4;
    } else if(name == "flat-fixed") {
        spec.family = "flat";
        spec.flat_method = ann::kManualNeonUnroll4PrefetchFixedTopK;
        spec.prefetch_distance = 16;
    } else if(name.find("flat-pf") == 0) {
        spec.family = "flat";
        spec.flat_method = ann::kManualNeonUnroll4PrefetchHeap;
        spec.prefetch_distance = static_cast<size_t>(std::atoi(name.substr(7).c_str()));
        if(spec.prefetch_distance == 0) {
            spec.prefetch_distance = 16;
        }
    } else if(name.find("pq-m") == 0 || name.find("pqsel-m") == 0) {
        spec.family = name.find("pqsel-m") == 0 ? "pqsel" : "pq";
        size_t prefix_len = spec.family == "pqsel" ? 7 : 4;
        size_t ppos = name.find("-p");
        if(ppos == std::string::npos) {
            spec.valid = false;
            return spec;
        }
        spec.pq_m = std::atoi(name.substr(prefix_len, ppos - prefix_len).c_str());
        spec.pq_p = std::atoi(name.substr(ppos + 2).c_str());
        if(spec.pq_m <= 0 || spec.pq_p <= 0) {
            spec.valid = false;
        }
    } else if(name.find("sdc-m") == 0 || name.find("fsadc-m") == 0 ||
              name.find("fssdc-m") == 0) {
        if(name.find("sdc-m") == 0) {
            spec.family = "sdc";
        } else if(name.find("fsadc-m") == 0) {
            spec.family = "fsadc";
        } else {
            spec.family = "fssdc";
        }
        size_t prefix_len = spec.family == "sdc" ? 5 : 7;
        size_t ppos = name.find("-p");
        if(ppos == std::string::npos) {
            spec.valid = false;
            return spec;
        }
        size_t bend = name.find("-b", ppos + 2);
        spec.pq_m = std::atoi(name.substr(prefix_len, ppos - prefix_len).c_str());
        spec.pq_p = std::atoi(name.substr(ppos + 2, bend == std::string::npos ? std::string::npos : bend - (ppos + 2)).c_str());
        if(bend != std::string::npos) {
            spec.fs_block = std::atoi(name.substr(bend + 2).c_str());
        }
        if(spec.pq_m <= 0 || spec.pq_p < 0 || spec.fs_block <= 0) {
            spec.valid = false;
        }
    } else if(name.find("sq8-p") == 0) {
        spec.family = "sq8";
        spec.sq_p = std::atoi(name.substr(5).c_str());
        if(spec.sq_p <= 0) {
            spec.valid = false;
        }
    } else if(name.find("sq8u8-p") == 0) {
        spec.family = "sq8u8";
        spec.sq_p = std::atoi(name.substr(7).c_str());
        if(spec.sq_p <= 0) {
            spec.valid = false;
        }
    } else {
        spec.valid = false;
    }
    return spec;
}

SearchResult run_kernel_spec(const KernelSpec& spec,
                             float* base,
                             float* test_query,
                             int* test_gt,
                             size_t base_number,
                             size_t vecdim,
                             size_t test_gt_d,
                             size_t query_count,
                             size_t k,
                             double& build_time_sec)
{
    build_time_sec = 0.0;
    if(spec.family == "flat") {
        return run_method(base, test_query, test_gt, base_number, vecdim, test_gt_d,
                          query_count, k, spec.flat_method, spec.prefetch_distance);
    }
    if(spec.family == "sq8" || spec.family == "sq8u8") {
        ann::SQ8Index index;
        int64_t t0 = now_us();
        ann::build_sq8_index(base, base_number, vecdim, index);
        build_time_sec = (now_us() - t0) / 1000000.0;
        if(spec.family == "sq8") {
            return run_sq8_method(index, base, test_query, test_gt, test_gt_d,
                                  query_count, static_cast<size_t>(spec.sq_p), k);
        }
        return run_sq8_u8simd_method(index, base, test_query, test_gt, test_gt_d,
                                     query_count, static_cast<size_t>(spec.sq_p), k);
    }
    if(spec.family == "pq" || spec.family == "pqsel" ||
       spec.family == "sdc" || spec.family == "fsadc" || spec.family == "fssdc") {
        ann::PQIndex index;
        std::vector<float> sdc_table;
        ann::PQFastScanIndex fast_index;
        const int pq_ks = 256;
        const int pq_train_sample = 2048;
        const int pq_iters = 10;
        int64_t t0 = now_us();
        ann::build_pq_index(base, base_number, vecdim, spec.pq_m, pq_ks,
                            pq_train_sample, pq_iters, index);
        build_time_sec = (now_us() - t0) / 1000000.0;
        if(spec.family == "pq") {
            return run_pq_method(index, base, test_query, test_gt, test_gt_d,
                                 query_count, static_cast<size_t>(spec.pq_p), k);
        }
        if(spec.family == "pqsel") {
            return run_pq_select_method(index, base, test_query, test_gt, test_gt_d,
                                        query_count, static_cast<size_t>(spec.pq_p), k);
        }
        if(spec.family == "sdc" || spec.family == "fssdc") {
            ann::build_pq_sdc_table(index, sdc_table);
        }
        if(spec.family == "fsadc" || spec.family == "fssdc") {
            ann::build_pq_fastscan_index(index, spec.fs_block, fast_index);
        }
        if(spec.family == "sdc") {
            return run_pq_sdc_method(index, sdc_table, base, test_query, test_gt,
                                     test_gt_d, query_count,
                                     static_cast<size_t>(spec.pq_p), k);
        }
        if(spec.family == "fsadc") {
            return run_pq_adc_fastscan_method(index, fast_index, base, test_query,
                                              test_gt, test_gt_d, query_count,
                                              static_cast<size_t>(spec.pq_p), k);
        }
        return run_pq_sdc_fastscan_method(index, fast_index, sdc_table, base,
                                          test_query, test_gt, test_gt_d,
                                          query_count,
                                          static_cast<size_t>(spec.pq_p), k);
    }

    SearchResult empty;
    empty.recall = 0.0f;
    empty.latency = 0;
    empty.coarse_latency = 0;
    empty.rerank_latency = 0;
    empty.encode_latency = 0;
    empty.lut_latency = 0;
    empty.scan_latency = 0;
    empty.select_latency = 0;
    return empty;
}

void append_kernel_experiment(const std::string& path,
                              const KernelSpec& spec,
                              size_t query_count,
                              size_t repeat,
                              const std::vector<double>& latencies,
                              const std::vector<double>& recalls,
                              const std::vector<double>& coarse,
                              const std::vector<double>& rerank,
                              double build_time_sec)
{
    struct stat st;
    bool exists = stat(path.c_str(), &st) == 0 && st.st_size > 0;
    std::ofstream fout(path.c_str(), std::ios::out | std::ios::app);
    if(!fout.is_open()) {
        std::cerr << "warning: failed to append " << path << "\n";
        return;
    }
    if(!exists) {
        fout << "timestamp_us,kernel,family,Q,repeat,latency_ms_mean,latency_ms_std,"
             << "recall_mean,recall_std,coarse_ms_mean,rerank_ms_mean,build_time_sec\n";
    }
    fout << now_us() << ","
         << spec.name << ","
         << spec.family << ","
         << query_count << ","
         << repeat << ","
         << std::fixed << std::setprecision(6) << mean_double(latencies) << ","
         << std::setprecision(6) << stddev_double(latencies) << ","
         << std::setprecision(6) << mean_double(recalls) << ","
         << std::setprecision(6) << stddev_double(recalls) << ","
         << std::setprecision(6) << mean_double(coarse) << ","
         << std::setprecision(6) << mean_double(rerank) << ","
         << std::setprecision(6) << build_time_sec << "\n";
}

void append_kernel_stage_experiment(const std::string& path,
                                    const KernelSpec& spec,
                                    size_t query_count,
                                    size_t repeat,
                                    const std::vector<double>& latencies,
                                    const std::vector<double>& recalls,
                                    const std::vector<double>& encode,
                                    const std::vector<double>& lut,
                                    const std::vector<double>& scan,
                                    const std::vector<double>& select,
                                    const std::vector<double>& rerank,
                                    double build_time_sec)
{
    struct stat st;
    bool exists = stat(path.c_str(), &st) == 0 && st.st_size > 0;
    std::ofstream fout(path.c_str(), std::ios::out | std::ios::app);
    if(!fout.is_open()) {
        std::cerr << "warning: failed to append " << path << "\n";
        return;
    }
    if(!exists) {
        fout << "timestamp_us,kernel,family,Q,repeat,latency_ms_mean,recall_mean,"
             << "encode_ms_mean,lut_ms_mean,scan_ms_mean,select_ms_mean,rerank_ms_mean,"
             << "build_time_sec,block_size\n";
    }
    fout << now_us() << ","
         << spec.name << ","
         << spec.family << ","
         << query_count << ","
         << repeat << ","
         << std::fixed << std::setprecision(6) << mean_double(latencies) << ","
         << std::setprecision(6) << mean_double(recalls) << ","
         << std::setprecision(6) << mean_double(encode) << ","
         << std::setprecision(6) << mean_double(lut) << ","
         << std::setprecision(6) << mean_double(scan) << ","
         << std::setprecision(6) << mean_double(select) << ","
         << std::setprecision(6) << mean_double(rerank) << ","
         << std::setprecision(6) << build_time_sec << ","
         << spec.fs_block << "\n";
}

int run_kernel_mode(const std::string& kernel_name,
                    float* base,
                    float* test_query,
                    int* test_gt,
                    size_t base_number,
                    size_t vecdim,
                    size_t test_number,
                    size_t test_gt_d,
                    size_t k,
                    size_t query_count,
                    size_t repeat)
{
    KernelSpec spec = parse_kernel_spec(kernel_name);
    if(!spec.valid) {
        std::cerr << "unknown kernel: " << kernel_name << "\n";
        std::cerr << "examples: flat-neon, flat-unroll4, flat-pf4, pq-m16-p500, "
                  << "pqsel-m16-p2000, sdc-m16-p1000, fsadc-m16-p2000-b32, "
                  << "fssdc-m16-p1000-b32, sq8-p1000, sq8u8-p1000\n";
        return 2;
    }
    query_count = std::min(query_count, test_number);
    if(query_count == 0) {
        query_count = std::min(test_number, static_cast<size_t>(100));
    }
    if(repeat == 0) {
        repeat = 1;
    }

    std::vector<double> latencies;
    std::vector<double> recalls;
    std::vector<double> coarse;
    std::vector<double> rerank;
    std::vector<double> encode;
    std::vector<double> lut;
    std::vector<double> scan;
    std::vector<double> select;
    double build_time_sec = 0.0;

    ann::SQ8Index sq_index;
    ann::PQIndex pq_index;
    ann::PQFastScanIndex fast_index;
    std::vector<float> sdc_table;
    if(spec.family == "sq8" || spec.family == "sq8u8") {
        int64_t t0 = now_us();
        ann::build_sq8_index(base, base_number, vecdim, sq_index);
        build_time_sec = (now_us() - t0) / 1000000.0;
    } else if(spec.family == "pq" || spec.family == "pqsel" ||
              spec.family == "sdc" || spec.family == "fsadc" ||
              spec.family == "fssdc") {
        int64_t t0 = now_us();
        ann::build_pq_index(base, base_number, vecdim, spec.pq_m, 256, 2048, 10, pq_index);
        build_time_sec = (now_us() - t0) / 1000000.0;
        if(spec.family == "sdc" || spec.family == "fssdc") {
            ann::build_pq_sdc_table(pq_index, sdc_table);
        }
        if(spec.family == "fsadc" || spec.family == "fssdc") {
            ann::build_pq_fastscan_index(pq_index, spec.fs_block, fast_index);
        }
    }

    if(spec.family == "flat") {
        run_method(base, test_query, test_gt, base_number, vecdim, test_gt_d,
                   std::min(query_count, static_cast<size_t>(5)), k,
                   spec.flat_method, spec.prefetch_distance);
    } else if(spec.family == "sq8") {
        run_sq8_method(sq_index, base, test_query, test_gt, test_gt_d,
                       std::min(query_count, static_cast<size_t>(5)),
                       static_cast<size_t>(spec.sq_p), k);
    } else if(spec.family == "sq8u8") {
        run_sq8_u8simd_method(sq_index, base, test_query, test_gt, test_gt_d,
                              std::min(query_count, static_cast<size_t>(5)),
                              static_cast<size_t>(spec.sq_p), k);
    } else if(spec.family == "pq") {
        run_pq_method(pq_index, base, test_query, test_gt, test_gt_d,
                      std::min(query_count, static_cast<size_t>(5)),
                      static_cast<size_t>(spec.pq_p), k);
    } else if(spec.family == "pqsel") {
        run_pq_select_method(pq_index, base, test_query, test_gt, test_gt_d,
                             std::min(query_count, static_cast<size_t>(5)),
                             static_cast<size_t>(spec.pq_p), k);
    } else if(spec.family == "sdc") {
        run_pq_sdc_method(pq_index, sdc_table, base, test_query, test_gt, test_gt_d,
                          std::min(query_count, static_cast<size_t>(5)),
                          static_cast<size_t>(spec.pq_p), k);
    } else if(spec.family == "fsadc") {
        run_pq_adc_fastscan_method(pq_index, fast_index, base, test_query, test_gt,
                                   test_gt_d, std::min(query_count, static_cast<size_t>(5)),
                                   static_cast<size_t>(spec.pq_p), k);
    } else if(spec.family == "fssdc") {
        run_pq_sdc_fastscan_method(pq_index, fast_index, sdc_table, base, test_query,
                                   test_gt, test_gt_d,
                                   std::min(query_count, static_cast<size_t>(5)),
                                   static_cast<size_t>(spec.pq_p), k);
    }

    for(size_t run = 0; run < repeat; ++run) {
        SearchResult r;
        if(spec.family == "flat") {
            r = run_method(base, test_query, test_gt, base_number, vecdim, test_gt_d,
                           query_count, k, spec.flat_method, spec.prefetch_distance);
        } else if(spec.family == "sq8") {
            r = run_sq8_method(sq_index, base, test_query, test_gt, test_gt_d,
                               query_count, static_cast<size_t>(spec.sq_p), k);
        } else if(spec.family == "sq8u8") {
            r = run_sq8_u8simd_method(sq_index, base, test_query, test_gt, test_gt_d,
                                      query_count, static_cast<size_t>(spec.sq_p), k);
        } else if(spec.family == "pq") {
            r = run_pq_method(pq_index, base, test_query, test_gt, test_gt_d,
                              query_count, static_cast<size_t>(spec.pq_p), k);
        } else if(spec.family == "pqsel") {
            r = run_pq_select_method(pq_index, base, test_query, test_gt, test_gt_d,
                                     query_count, static_cast<size_t>(spec.pq_p), k);
        } else if(spec.family == "sdc") {
            r = run_pq_sdc_method(pq_index, sdc_table, base, test_query, test_gt,
                                  test_gt_d, query_count,
                                  static_cast<size_t>(spec.pq_p), k);
        } else if(spec.family == "fsadc") {
            r = run_pq_adc_fastscan_method(pq_index, fast_index, base, test_query,
                                           test_gt, test_gt_d, query_count,
                                           static_cast<size_t>(spec.pq_p), k);
        } else {
            r = run_pq_sdc_fastscan_method(pq_index, fast_index, sdc_table, base,
                                           test_query, test_gt, test_gt_d,
                                           query_count,
                                           static_cast<size_t>(spec.pq_p), k);
        }
        latencies.push_back(r.latency / 1000.0);
        recalls.push_back(r.recall);
        coarse.push_back(r.coarse_latency / 1000.0);
        rerank.push_back(r.rerank_latency / 1000.0);
        encode.push_back(r.encode_latency / 1000.0);
        lut.push_back(r.lut_latency / 1000.0);
        scan.push_back(r.scan_latency / 1000.0);
        select.push_back(r.select_latency / 1000.0);
        std::cerr << "kernel run " << (run + 1) << "/" << repeat
                  << " " << spec.name
                  << " latency_ms=" << latencies.back()
                  << " recall=" << recalls.back() << "\n";
    }

    std::string files_dir = get_files_dir();
    ensure_dir(files_dir);
    ensure_dir(files_dir + "/results");
    append_kernel_experiment(files_dir + "/results/kernel_experiments.csv",
                             spec, query_count, repeat,
                             latencies, recalls, coarse, rerank, build_time_sec);
    append_kernel_stage_experiment(files_dir + "/results/kernel_stage_experiments.csv",
                                   spec, query_count, repeat,
                                   latencies, recalls, encode, lut, scan, select,
                                   rerank, build_time_sec);

    std::cout << "kernel: " << spec.name << "\n";
    std::cout << "queries: " << query_count << "\n";
    std::cout << "repeat: " << repeat << "\n";
    std::cout << "latency_ms_mean: " << mean_double(latencies) << "\n";
    std::cout << "latency_ms_std: " << stddev_double(latencies) << "\n";
    std::cout << "recall_mean: " << mean_double(recalls) << "\n";
    std::cout << "recall_std: " << stddev_double(recalls) << "\n";
    std::cout << "coarse_ms_mean: " << mean_double(coarse) << "\n";
    std::cout << "encode_ms_mean: " << mean_double(encode) << "\n";
    std::cout << "lut_ms_mean: " << mean_double(lut) << "\n";
    std::cout << "scan_ms_mean: " << mean_double(scan) << "\n";
    std::cout << "select_ms_mean: " << mean_double(select) << "\n";
    std::cout << "rerank_ms_mean: " << mean_double(rerank) << "\n";
    std::cout << "build_time_sec_last: " << build_time_sec << "\n";
    return 0;
}

void write_result_row(std::ofstream& fout,
                      const std::string& method,
                      const char* platform,
                      size_t n,
                      size_t d,
                      size_t q,
                      size_t k,
                      int m,
                      int ks,
                      int p,
                      int unroll,
                      int prefetch,
                      const char* topk,
                      int run_id,
                      const SearchResult& r,
                      double index_size_mb,
                      double build_time_sec)
{
    fout << method << ","
         << platform << ","
         << n << ","
         << d << ","
         << q << ","
         << k << ","
         << m << ","
         << ks << ","
         << p << ","
         << unroll << ","
         << prefetch << ","
         << topk << ","
         << run_id << ","
         << std::fixed << std::setprecision(6) << r.latency / 1000.0 << ","
         << std::setprecision(6) << r.recall << ","
         << std::setprecision(6) << index_size_mb << ","
         << std::setprecision(6) << build_time_sec << ","
         << std::setprecision(6) << r.coarse_latency / 1000.0 << ","
         << std::setprecision(6) << r.rerank_latency / 1000.0 << ","
         << 0 << ","
         << 0 << ","
         << 0 << ","
         << 0 << ","
         << 0 << "\n";
}

void write_alignment_report(const std::string& files_dir,
                            const float* base,
                            const float* test_query,
                            size_t base_number,
                            size_t vecdim)
{
    ensure_dir(files_dir + "/results");
    std::ofstream fout((files_dir + "/results/alignment_report.md").c_str(),
                       std::ios::out | std::ios::trunc);
    if(!fout.is_open()) {
        return;
    }

    uintptr_t base_addr = reinterpret_cast<uintptr_t>(base);
    uintptr_t query_addr = reinterpret_cast<uintptr_t>(test_query);
    size_t stride_bytes = vecdim * sizeof(float);
    fout << "# SIMD Alignment Report\n\n";
    fout << "This file is generated by `main.cc` during `bash test.sh 1 1`.\n\n";
    fout << "| item | value |\n";
    fout << "|---|---:|\n";
    fout << "| base address mod 16 | " << (base_addr % 16) << " |\n";
    fout << "| base address mod 32 | " << (base_addr % 32) << " |\n";
    fout << "| base address mod 64 | " << (base_addr % 64) << " |\n";
    fout << "| query address mod 16 | " << (query_addr % 16) << " |\n";
    fout << "| query address mod 32 | " << (query_addr % 32) << " |\n";
    fout << "| query address mod 64 | " << (query_addr % 64) << " |\n";
    fout << "| vector stride bytes | " << stride_bytes << " |\n";
    fout << "| stride mod 16 | " << (stride_bytes % 16) << " |\n";
    fout << "| stride mod 32 | " << (stride_bytes % 32) << " |\n";
    fout << "| stride mod 64 | " << (stride_bytes % 64) << " |\n";
    fout << "| base vectors checked | " << base_number << " |\n\n";
    fout << "The NEON aligned-hint benchmark uses 16-byte alignment checks and falls back "
         << "to the safe unaligned NEON path if either pointer is not aligned.\n";
}

void write_simd_benchmark(float* base,
                          float* test_query,
                          int* test_gt,
                          size_t base_number,
                          size_t vecdim,
                          size_t test_number,
                          size_t test_gt_d,
                          size_t k)
{
    std::string files_dir = get_files_dir();
    ensure_dir(files_dir);
    ensure_dir(files_dir + "/results");
    ensure_dir(files_dir + "/indices");
    write_alignment_report(files_dir, base, test_query, base_number, vecdim);

    std::string csv_path = files_dir + "/results/simd_results.csv";
    std::ofstream fout(csv_path.c_str(), std::ios::out | std::ios::trunc);
    if(!fout.is_open()) {
        std::cerr << "warning: failed to open " << csv_path << "\n";
        return;
    }

    const char* platform =
#if defined(__aarch64__)
        "ARM-aarch64-NEON";
#elif defined(__ARM_NEON) || defined(__ARM_NEON__)
        "ARM-NEON";
#elif defined(__AVX__)
        "x86-AVX";
#elif defined(__SSE__)
        "x86-SSE";
#else
        "Unknown";
#endif

    fout << "method,platform,N,d,Q,k,M,Ks,p,unroll,prefetch,topk,run_id,"
         << "latency_ms,recall,index_size_mb,build_time_sec,coarse_ms,rerank_ms,cycles,instructions,"
         << "cpi,l1_miss_rate,llc_miss_rate\n";

    ann::SearchMethod methods[] = {
        ann::kScalarNoVec,
        ann::kAutoVectorized,
#if defined(__AVX__)
        ann::kManualAvx,
#elif defined(__SSE__)
        ann::kManualSse,
#endif
#if defined(__ARM_NEON) || defined(__ARM_NEON__) || defined(__aarch64__)
        ann::kManualNeon,
        ann::kManualNeonAligned,
        ann::kManualNeonUnroll2,
        ann::kManualNeonUnroll4,
        ann::kManualNeonUnroll4PrefetchHeap,
        ann::kManualNeonUnroll4PrefetchFixedTopK
#endif
    };
    const size_t method_count = sizeof(methods) / sizeof(methods[0]);
    const size_t benchmark_queries = std::min(test_number, static_cast<size_t>(100));
    const int repeat = 5;
    double index_size_mb = static_cast<double>(base_number) * vecdim * sizeof(float) / 1000000.0;

    for(size_t m = 0; m < method_count; ++m) {
        for(int run = 1; run <= repeat; ++run) {
            SearchResult r = run_method(base, test_query, test_gt,
                                        base_number, vecdim, test_gt_d,
                                        benchmark_queries, k, methods[m]);
            write_result_row(fout, ann::method_name(methods[m]), platform,
                             base_number, vecdim, benchmark_queries, k,
                             0, 0, 0,
                             method_unroll(methods[m]),
                             method_prefetch(methods[m]),
                             method_topk(methods[m]),
                             run, r, index_size_mb, 0.0);
        }
    }

#if defined(__ARM_NEON) || defined(__ARM_NEON__) || defined(__aarch64__)
    int prefetch_values[] = {4, 8, 16, 32, 64};
    for(size_t pi = 0; pi < sizeof(prefetch_values) / sizeof(prefetch_values[0]); ++pi) {
        int pf = prefetch_values[pi];
        for(int run = 1; run <= repeat; ++run) {
            SearchResult r = run_method(base, test_query, test_gt,
                                        base_number, vecdim, test_gt_d,
                                        benchmark_queries, k,
                                        ann::kManualNeonUnroll4PrefetchHeap,
                                        static_cast<size_t>(pf));
            std::ostringstream name;
            name << "Flat-NEON-Unroll4-Prefetch-d" << pf;
            write_result_row(fout, name.str(), platform,
                             base_number, vecdim, benchmark_queries, k,
                             0, 0, 0, 4, pf, "heap", run,
                             r, index_size_mb, 0.0);
        }
    }
#endif

    const size_t quant_queries = std::min(test_number, static_cast<size_t>(20));
    int sq_p_values[] = {100, 200, 500, 1000, 2000, 5000, 10000};
    ann::SQ8Index sq8_index;
    int64_t sq_build_t0 = now_us();
    ann::build_sq8_index(base, base_number, vecdim, sq8_index);
    double sq_build_sec = (now_us() - sq_build_t0) / 1000000.0;
    if(!ann::save_sq8_index(sq8_index, files_dir + "/indices/sq8.index")) {
        std::cerr << "warning: failed to save SQ8 index\n";
    }
    for(size_t pi = 0; pi < sizeof(sq_p_values) / sizeof(sq_p_values[0]); ++pi) {
        int p = sq_p_values[pi];
        for(int run = 1; run <= repeat; ++run) {
            SearchResult r = run_sq8_method(sq8_index, base, test_query, test_gt,
                                            test_gt_d, quant_queries, p, k);
            std::ostringstream name;
            name << "SQ8-rerank-p" << p;
            write_result_row(fout, name.str(), platform, base_number, vecdim,
                             quant_queries, k, 0, 0, p, 1, 0, "heap", run,
                             r, ann::sq8_index_size_mb(sq8_index), sq_build_sec);
        }
    }
    for(size_t pi = 0; pi < sizeof(sq_p_values) / sizeof(sq_p_values[0]); ++pi) {
        int p = sq_p_values[pi];
        for(int run = 1; run <= repeat; ++run) {
            SearchResult r = run_sq8_u8simd_method(sq8_index, base, test_query, test_gt,
                                                   test_gt_d, quant_queries, p, k);
            std::ostringstream name;
            name << "SQ8-U8SIMD-rerank-p" << p;
            write_result_row(fout, name.str(), platform, base_number, vecdim,
                             quant_queries, k, 0, 0, p, 1, 0, "heap", run,
                             r, ann::sq8_index_size_mb(sq8_index), sq_build_sec);
        }
    }

    int pq_m_values[] = {8, 12, 16};
    int pq_p_values[] = {100, 500, 1000, 2000, 5000};
    const int pq_ks = 256;
    const int pq_train_sample = 2048;
    const int pq_iters = 10;
    for(size_t mi = 0; mi < sizeof(pq_m_values) / sizeof(pq_m_values[0]); ++mi) {
        int pq_m = pq_m_values[mi];
        ann::PQIndex pq_index;
        int64_t pq_build_t0 = now_us();
        ann::build_pq_index(base, base_number, vecdim, pq_m, pq_ks,
                            pq_train_sample, pq_iters, pq_index);
        double pq_build_sec = (now_us() - pq_build_t0) / 1000000.0;
        std::ostringstream index_path;
        index_path << files_dir << "/indices/pq_M" << pq_m << "_Ks" << pq_ks << ".index";
        if(!ann::save_pq_index(pq_index, index_path.str())) {
            std::cerr << "warning: failed to save PQ index M=" << pq_m << "\n";
        }
        for(size_t pi = 0; pi < sizeof(pq_p_values) / sizeof(pq_p_values[0]); ++pi) {
            int p = pq_p_values[pi];
            for(int run = 1; run <= repeat; ++run) {
                SearchResult r = run_pq_method(pq_index, base, test_query, test_gt,
                                               test_gt_d, quant_queries, p, k);
                std::ostringstream name;
                name << "PQ-ADC-M" << pq_m << "-p" << p;
                write_result_row(fout, name.str(), platform, base_number, vecdim,
                                 quant_queries, k, pq_m, pq_ks, p, 1, 0,
                                 "heap", run, r,
                                 ann::pq_index_size_mb(pq_index), pq_build_sec);
            }
        }

        std::vector<float> sdc_table;
        ann::build_pq_sdc_table(pq_index, sdc_table);
        int sdc_p_values[] = {0, 100, 500, 1000, 2000, 5000};
        for(size_t pi = 0; pi < sizeof(sdc_p_values) / sizeof(sdc_p_values[0]); ++pi) {
            int p = sdc_p_values[pi];
            for(int run = 1; run <= repeat; ++run) {
                SearchResult r = run_pq_sdc_method(pq_index, sdc_table, base, test_query,
                                                   test_gt, test_gt_d, quant_queries,
                                                   static_cast<size_t>(p), k);
                std::ostringstream name;
                if(p == 0) {
                    name << "PQ-SDC-M" << pq_m << "-coarse";
                } else {
                    name << "PQ-SDC-M" << pq_m << "-p" << p;
                }
                write_result_row(fout, name.str(), platform, base_number, vecdim,
                                 quant_queries, k, pq_m, pq_ks, p, 1, 0,
                                 p == 0 ? "coarse-only" : "nth-rerank", run, r,
                                 ann::pq_index_size_mb(pq_index), pq_build_sec);
            }
        }

        if(pq_m == 16) {
            ann::PQFastScanIndex fast_index;
            ann::build_pq_fastscan_index(pq_index, 32, fast_index);
            double fast_index_mb = ann::pq_index_size_mb(pq_index) +
                                   static_cast<double>(fast_index.codes.size()) / 1000000.0;
            int fs_p_values[] = {500, 1000, 2000};
            for(size_t pi = 0; pi < sizeof(fs_p_values) / sizeof(fs_p_values[0]); ++pi) {
                int p = fs_p_values[pi];
                for(int run = 1; run <= repeat; ++run) {
                    SearchResult r = run_pq_adc_fastscan_method(pq_index, fast_index,
                                                                base, test_query, test_gt,
                                                                test_gt_d, quant_queries,
                                                                static_cast<size_t>(p), k);
                    std::ostringstream name;
                    name << "FastScan-ADC-M" << pq_m << "-p" << p;
                    write_result_row(fout, name.str(), platform, base_number, vecdim,
                                     quant_queries, k, pq_m, pq_ks, p, 1, 0,
                                     "u8lut-block32", run, r, fast_index_mb, pq_build_sec);
                }
            }
            for(size_t pi = 0; pi < sizeof(fs_p_values) / sizeof(fs_p_values[0]); ++pi) {
                int p = fs_p_values[pi];
                for(int run = 1; run <= repeat; ++run) {
                    SearchResult r = run_pq_sdc_fastscan_method(pq_index, fast_index,
                                                                sdc_table, base, test_query,
                                                                test_gt, test_gt_d,
                                                                quant_queries,
                                                                static_cast<size_t>(p), k);
                    std::ostringstream name;
                    name << "FastScan-SDC-M" << pq_m << "-p" << p;
                    write_result_row(fout, name.str(), platform, base_number, vecdim,
                                     quant_queries, k, pq_m, pq_ks, p, 1, 0,
                                     "u8lut-block32", run, r, fast_index_mb, pq_build_sec);
                }
            }

            int pipeline_batches[] = {1, 4, 8, 16, 32, 64};
            const int pipeline_p = 1000;
            for(size_t bi = 0; bi < sizeof(pipeline_batches) / sizeof(pipeline_batches[0]); ++bi) {
                int batch = pipeline_batches[bi];
                for(int run = 1; run <= repeat; ++run) {
                    SearchResult r = run_pq_sdc_pipeline_method(pq_index, sdc_table,
                                                                base, test_query, test_gt,
                                                                test_gt_d, quant_queries,
                                                                pipeline_p, k,
                                                                static_cast<size_t>(batch), 2);
                    std::ostringstream name;
                    name << "SDC-Pipeline2-M" << pq_m << "-p" << pipeline_p
                         << "-b" << batch;
                    write_result_row(fout, name.str(), platform, base_number, vecdim,
                                     quant_queries, k, pq_m, pq_ks, pipeline_p, 1, 0,
                                     "pipeline2", run, r,
                                     ann::pq_index_size_mb(pq_index), pq_build_sec);
                }
            }
            for(size_t bi = 0; bi < sizeof(pipeline_batches) / sizeof(pipeline_batches[0]); ++bi) {
                int batch = pipeline_batches[bi];
                for(int run = 1; run <= repeat; ++run) {
                    SearchResult r = run_pq_sdc_pipeline_method(pq_index, sdc_table,
                                                                base, test_query, test_gt,
                                                                test_gt_d, quant_queries,
                                                                pipeline_p, k,
                                                                static_cast<size_t>(batch), 3);
                    std::ostringstream name;
                    name << "SDC-Pipeline3-M" << pq_m << "-p" << pipeline_p
                         << "-b" << batch;
                    write_result_row(fout, name.str(), platform, base_number, vecdim,
                                     quant_queries, k, pq_m, pq_ks, pipeline_p, 1, 0,
                                     "pipeline3", run, r,
                                     ann::pq_index_size_mb(pq_index), pq_build_sec);
                }
            }
        }
    }

    fout.close();
    std::cerr << "wrote SIMD benchmark csv: " << csv_path << "\n";
}

void build_index(float* base, size_t base_number, size_t vecdim)
{
    const int efConstruction = 150; // 为防止索引构建时间过长，efc建议设置200以下
    const int M = 16; // M建议设置为16以下

    HierarchicalNSW<float> *appr_alg;
    InnerProductSpace ipspace(vecdim);
    appr_alg = new HierarchicalNSW<float>(&ipspace, base_number, M, efConstruction);

    appr_alg->addPoint(base, 0);
    #pragma omp parallel for
    for(int i = 1; i < base_number; ++i) {
        appr_alg->addPoint(base + 1ll*vecdim*i, i);
    }

    char path_index[1024] = "files/hnsw.index";
    appr_alg->saveIndex(path_index);
}


int main(int argc, char *argv[])
{
    size_t test_number = 0, base_number = 0;
    size_t test_gt_d = 0, vecdim = 0;

    std::string data_path = "/anndata/"; 
    auto test_query = LoadData<float>(data_path + "DEEP100K.query.fbin", test_number, vecdim);
    auto test_gt = LoadData<int>(data_path + "DEEP100K.gt.query.100k.top100.bin", test_number, test_gt_d);
    auto base = LoadData<float>(data_path + "DEEP100K.base.100k.fbin", base_number, vecdim);
    // 只测试前2000条查询
    test_number = 2000;

    const size_t k = 10;

    bool final_only = argc >= 2 && std::string(argv[1]) == "--final-only";

    if(argc >= 2 && std::string(argv[1]) == "--kernel") {
        std::string kernel_name = argc >= 3 ? argv[2] : "flat-neon";
        size_t query_count = argc >= 4 ? static_cast<size_t>(std::atoi(argv[3])) : 200;
        size_t repeat = argc >= 5 ? static_cast<size_t>(std::atoi(argv[4])) : 5;
        return run_kernel_mode(kernel_name, base, test_query, test_gt,
                               base_number, vecdim, test_number, test_gt_d,
                               k, query_count, repeat);
    }

    std::vector<SearchResult> results;
    results.resize(test_number);

    const int final_m2 = 32;        // Ks=16 × 32 SQs = 16B code (same as v2 M=16 Ks=256)
    const int final_p = 500;        // Ks=16 coarse is precise enough at p=500
    ann::PQ4Index final_idx;
    int64_t final_build_t0 = now_us();
    ann::build_pq4_index(base, base_number, vecdim, final_m2, 2048, 10, final_idx);
    double final_build_sec = (now_us() - final_build_t0) / 1000000.0;
    std::cerr << "final ANN path: FastScan-v3-M" << final_m2
              << "-Ks16-p" << final_p
              << " build_time_sec=" << final_build_sec << "\n";

    // 查询测试代码
    for(int i = 0; i < test_number; ++i) {
        const unsigned long Converter = 1000 * 1000;
        struct timeval val;
        int ret = gettimeofday(&val, NULL);

        ann::QuantTiming timing;
        auto res = ann::pq4_scan_search(final_idx, base, test_query + i*vecdim,
                                         final_p, k, &timing, NULL);

        struct timeval newVal;
        ret = gettimeofday(&newVal, NULL);
        int64_t diff = (newVal.tv_sec * Converter + newVal.tv_usec) - (val.tv_sec * Converter + val.tv_usec);

        std::set<uint32_t> gtset;
        for(int j = 0; j < k; ++j){
            int t = test_gt[j + i*test_gt_d];
            gtset.insert(t);
        }

        size_t acc = 0;
        while (res.size()) {   
            int x = res.top().second;
            if(gtset.find(x) != gtset.end()){
                ++acc;
            }
            res.pop();
        }
        float recall = (float)acc/k;

        results[i] = {recall, diff};
    }

    float avg_recall = 0, avg_latency = 0;
    for(int i = 0; i < test_number; ++i) {
        avg_recall += results[i].recall;
        avg_latency += results[i].latency;
    }

    // 浮点误差可能导致一些精确算法平均recall不是1
    std::cout << "average recall: "<<avg_recall / test_number<<"\n";
    std::cout << "average latency (us): "<<avg_latency / test_number<<"\n";

    if(!final_only) {
        write_simd_benchmark(base, test_query, test_gt,
                             base_number, vecdim, test_number, test_gt_d, k);
    }
    return 0;
}
