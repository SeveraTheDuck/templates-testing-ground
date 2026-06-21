# templates-testing-ground

A testing ground for my template-* series projects


<!-- === templates-base badges === -->
[![CI](https://github.com/SeveraTheDuck/templates-testing-ground/actions/workflows/ci.yaml/badge.svg)](https://github.com/SeveraTheDuck/templates-testing-ground/actions/workflows/ci.yaml)
[![Release](https://img.shields.io/github/v/release/SeveraTheDuck/templates-testing-ground)](https://github.com/SeveraTheDuck/templates-testing-ground/releases)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSES/MIT.txt)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://conventionalcommits.org)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com)
<!-- === end templates-base badges === -->
<!-- === templates-lang-cpp badges === -->
[![CI C++](https://github.com/SeveraTheDuck/templates-testing-ground/actions/workflows/ci-cpp.yaml/badge.svg)](https://github.com/SeveraTheDuck/templates-testing-ground/actions/workflows/ci-cpp.yaml)
[![codecov](https://codecov.io/gh/SeveraTheDuck/templates-testing-ground/graph/badge.svg)](https://codecov.io/gh/SeveraTheDuck/templates-testing-ground)
[![C++26](https://img.shields.io/badge/C%2B%2B-26-blue.svg)](https://en.cppreference.com/w/cpp)
<!-- === end templates-lang-cpp badges === -->

## Development

This project builds with a pinned toolchain provided entirely through Nix — you
do not install compilers or CMake yourself.

### Prerequisites

- [Nix](https://nixos.org/download) with flakes enabled
- [direnv](https://direnv.net) (recommended, for automatic shell activation)

### Environment

With direnv, the dev shell loads automatically:

```bash
direnv allow
```

This enters the `gcc` dev shell. The default shell is a tooling shell; builds use the pinned per-compiler shells.

Without direnv, enter a shell explicitly:

```bash
nix develop .#clang   # Clang 22

nix develop .#gcc     # GCC 16
```

### Build & test

```bash
just warmup        # configure dev, generate compile_commands.json for clangd
just build         # configure + build (default preset: dev)
just test          # build + run unit tests
just run           # build + run the executable
```

Build or test a specific preset:

```bash
just build release
just test dev-asan
```

Run a subset of tests by name:

```bash
just test-filter <regex>
```

Sanitizer presets are available: `dev-asan` (ASan + UBSan) and `dev-tsan` (TSan).

### Static analysis & formatting

```bash
just tidy          # clang-tidy over the dev compile database
just fmt           # format all sources (treefmt)
```

### Coverage

```bash
just coverage      # build instrumented, run tests, print a source-level summary
```

Coverage is collected with llvm-cov (source-based) and uploaded to Codecov on pull requests.

### Profiling

```bash
just profile <workload>    # build the profile preset, record a flamegraph
```

Workloads live in `workloads/`; recorded data and flamegraphs are written under
`profiling/results/`.

### Custom build options

Project-local compile options go in `cmake/UserOptions.cmake`. This file is
yours — it is created once and never overwritten by template updates. For flags
that only apply to this project's own code:

```cmake
target_compile_options(project_options INTERFACE -fyour-flag)
```

For flags that consumers of the library must also use:

```cmake
target_compile_options(templates-testing-ground PUBLIC -fyour-flag)
```

## Using this library

### With Nix

Add this flake as an input and use its package output:

```nix
inputs.templates-testing-ground.url = "github:SeveraTheDuck/templates-testing-ground";
# packages.${system}.default carries the installed library + CMake config
```

### With CMake (any toolchain, no Nix required)

Build and install into a prefix:

```bash
cmake -B build -D templates-testing-ground_ENABLE_INSTALL=ON
cmake --build build
cmake --install build --prefix <prefix>
```

Then consume it from another project:

```cmake
find_package(templates-testing-ground CONFIG REQUIRED)
target_link_libraries(your_target PRIVATE severa::templates-testing-ground)
```

The installed package is toolchain-agnostic, but being a static library it is
ABI-sensitive: link it with a standard library compatible with the one it was
built against.

## Updating from template

```bash
copier update --trust -a .copier/answers.cpp.yaml
```

<!-- TODO: document centralised template rollout via the dedicated repository -->

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSES/MIT.txt) © Alexander Antipov
