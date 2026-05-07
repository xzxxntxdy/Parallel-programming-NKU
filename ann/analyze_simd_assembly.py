#!/usr/bin/env python3
import csv
import re
from pathlib import Path


ASM_PATH = Path("files/analysis/main_O2.s")
OUT_CSV = Path("files/analysis/assembly_instruction_counts.csv")
OUT_MD = Path("files/analysis/simd_assembly_summary.md")


PATTERNS = [
    ("neon_fmla_or_vmla", r"\b(fmla|vmla)\b"),
    ("float_mul", r"\b(fmul|mul)\b"),
    ("float_add", r"\b(fadd|add)\b"),
    ("vector_load_ld1", r"\bld1\b"),
    ("load_ldr", r"\bldr\b"),
    ("prefetch_prfm", r"\bprfm\b"),
    ("horizontal_add", r"\b(addv|faddp)\b"),
    ("branch", r"\b(b|bl|blr|cbz|cbnz|b\.eq|b\.ne|b\.lt|b\.gt|b\.le|b\.ge)\b"),
]


def count_patterns(text):
    return [(name, len(re.findall(pattern, text))) for name, pattern in PATTERNS]


def main():
    if not ASM_PATH.exists():
        raise SystemExit(f"missing {ASM_PATH}; run the g++ -S command first")
    OUT_CSV.parent.mkdir(parents=True, exist_ok=True)
    text = ASM_PATH.read_text(errors="ignore")
    counts = count_patterns(text)

    with OUT_CSV.open("w", newline="") as fout:
        writer = csv.writer(fout)
        writer.writerow(["pattern", "static_count"])
        writer.writerows(counts)

    with OUT_MD.open("w") as fout:
        fout.write("# SIMD Assembly Static Summary\n\n")
        fout.write("This file is generated from `files/analysis/main_O2.s` and is a static assembly scan, not a runtime perf counter result.\n\n")
        fout.write("| pattern | static count |\n")
        fout.write("|---|---:|\n")
        for name, count in counts:
            fout.write(f"| {name} | {count} |\n")
        fout.write("\nNotes:\n\n")
        fout.write("- `prefetch_prfm` confirms whether the compiler emitted ARM prefetch instructions for the prefetch variants.\n")
        fout.write("- `neon_fmla_or_vmla`, `vector_load_ld1`, and `horizontal_add` are used as coarse evidence that packed NEON code is present.\n")
        fout.write("- Runtime `cycles`, `instructions`, CPI and cache-miss rates still require `perf stat` on a platform where direct profiling is allowed.\n")

    print(f"wrote {OUT_CSV}")
    print(f"wrote {OUT_MD}")


if __name__ == "__main__":
    main()
