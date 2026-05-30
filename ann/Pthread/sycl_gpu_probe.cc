#include <sycl/sycl.hpp>
#include <iostream>
#include <vector>

int main() {
    sycl::queue q(sycl::default_selector_v);
    std::cout << q.get_device().get_info<sycl::info::device::name>() << std::endl;
    const int n = 1024;
    std::vector<int> a(n);
    for (int i = 0; i < n; ++i) a[i] = i;
    {
        sycl::buffer<int, 1> buf(a.data(), sycl::range<1>(n));
        q.submit([&](sycl::handler& h) {
            sycl::accessor acc(buf, h, sycl::read_write);
            h.parallel_for(sycl::range<1>(n), [=](sycl::id<1> idx) {
                int i = idx[0];
                acc[i] += 1;
            });
        }).wait();
    }
    long long s = 0;
    for (int i = 0; i < n; ++i) s += a[i];
    std::cout << s << std::endl;
    return s == 524800 ? 0 : 3;
}
