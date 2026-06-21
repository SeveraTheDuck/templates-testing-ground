# C++ recipes for templates-testing-ground (imported by the root justfile).

project := "templates-testing-ground"

# static analysis: clang-tidy over the dev compile database
tidy: (build "dev")
    run-clang-tidy -p build/dev -extra-arg=-fgnuc-version=16 -quiet

# default preset for build / test
preset := "dev"

# configure dev: generates compile_commands.json + version.hpp for clangd
warmup:
    cmake --preset dev

# configure + build a preset (default: dev)
build preset=preset:
    cmake --preset {{ preset }}
    cmake --build --preset {{ preset }}

# build + run the unit tests for a preset (default: dev)
test preset=preset: (build preset)
    ctest --preset {{ preset }}

# run a subset of tests by name regex (default: all)
test-filter regex=".*" preset=preset: (build preset)
    ctest --preset {{ preset }} -R {{ regex }}

# build dev + run the executable
run *args: (build "dev")
    ./build/dev/source/{{ project }}/{{ project }} {{ args }}

# remove all build directories
clean:
    rm -rf build

# build the profile preset + record a flamegraph for a workload
# usage: just profile greeting  ->  build/profile/workloads/<project>_greeting_workload
profile workload: (build "profile")
    profiling/scripts/run.sh build/profile/workloads/{{ project }}_{{ workload }}_workload

# build the coverage preset (compiler-pinned) + print a source-level summary
# coverage is the only recipe that pins the compiler: its source of truth is
# Clang (llvm-cov) for clang/both, gcov/gcovr for gcc -- so it cannot reuse the
# ambient (build) path and wraps an explicit nix develop shell instead.
coverage:
    nix develop .#clang -c bash -c 'cmake --preset coverage && cmake --build --preset coverage && coverage/scripts/report.sh'

