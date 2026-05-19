# AI Assistance Appendix

This project used a generative AI coding assistant to help inspect the SIMD
implementation, split the Pthread code into modules, design the benchmark
matrix, add HNSW/IVF-HNSW advanced experiments, rewrite plotting logic, and
prepare cross-platform run commands.

For the final report appendix, include the exported conversation transcript
covering:

- migration of SIMD code and results into `ann/simd`;
- design of the Pthread + SIMD experiment matrix;
- selection criterion change to minimum latency at `recall@100 >= 0.95`;
- restoration of overwritten non-HNSW results;
- HNSW intra-query and IVF-HNSW advanced experiment implementation;
- plotting cleanup to standalone, paper-style figures only;
- x86 local result regeneration and ARM/accelerator command preparation.

The generated code and results should still be treated as student-owned work:
the report should explain which suggestions were accepted, what was measured
locally, and which platform-specific commands remain to be run on ARM or
accelerator machines.
