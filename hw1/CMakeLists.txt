cmake_minimum_required(VERSION 3.16)

project(hw1_cpu_arch C)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_C_FLAGS_DEBUG "-O0 -g3 -fno-omit-frame-pointer")
set(CMAKE_C_FLAGS_RELEASE "-O3 -DNDEBUG -g -fno-omit-frame-pointer")
set(CMAKE_C_FLAGS_RELWITHDEBINFO "-O2 -DNDEBUG -g -fno-omit-frame-pointer")

add_compile_options(-Wall -Wextra -Wpedantic)

add_executable(bench_cpu_arch
    src/benchmark_main.c
    src/common.c
    src/matvec_naive.c
    src/matvec_cache_opt.c
    src/matvec_unroll.c
    src/matvec_extreme.c
    src/sum_naive.c
    src/sum_superscalar.c
    src/sum_unroll.c
    src/sum_extreme.c
)

target_include_directories(bench_cpu_arch PRIVATE include)
target_compile_definitions(bench_cpu_arch PRIVATE _POSIX_C_SOURCE=200809L BUILD_MODE_NAME=\"${CMAKE_BUILD_TYPE}\")
target_link_libraries(bench_cpu_arch PRIVATE m)

set_target_properties(bench_cpu_arch PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}"
)
