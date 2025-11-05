# Ebuild *DEPENDs support matrix for this overlay

| Support level        | Quality      | Meaning                                                                                                  |
| ---                  | ---          | ---                                                                                                      |
| Fully supported      | Best         | Tested, fully compatible                                                                                 |
| Mostly supported     | Better       | Tested and partially compatible                                                                          |
| Partially supported  | Good         | May be tested and partially compatible                                                                   |
| Available            | Good to poor | **Not tested**, partially compatible, ebuild may be unfinished, Work in Progress (WIP)                   |
| Deprecated           | Best to poor | Phased out for removal and may be actively removed, may have security issues                             |
| Planned              | -            | To be added to maximize interoperability between platforms and app features                              |
| WIP                  | Poor         | Work In Progress.  Ebuild still in development.                                                          |
| EOL                  | Poor         | No longer compatible and may be removed, may have security issues that are practically impossible to fix |
| Not supported        | Poor         | Dropped support or no effort to add support by overlay, may have security issues, untested               |

| Type of release      | Supported on overlay?                 | 
| ---                  | ---                                   |
| Stable               | Yes                                   |
| LTS                  | Yes                                   |
| Beta                 | Generally no, with exceptions         |
| Alpha                | No                                    |
| Preview              | No                                    |
| Live (latest commit) | Yes                                   |
| Live snapshot        | Yes                                   |

* Using beta, alpha, preview versions, or enabling the debug USE flag may lead
  to information disclosure when the debug dump or crash report contains
  sensitive information.

The LIBC support below reflects the upstream projects CI (Continuous
Integration) images trend, but it may change if microarchitecture references
exist in build files.

| LIBC                 | Arch     | Ebuild level of support     | Distro or CI image correspondence                                      |
| ---                  | ----     | ---                         | ---                                                                    |
| glibc                | 64-bit   | Generally supported         | D12 (2.36), D13 (2.41), U22 (2.35), U24 (2.39)                         |
| glibc                | 32-bit   | Deprecated*                 | D12 (2.36), D13 (2.41), U22 (2.35), U24 (2.39)                         |
| glibc                | alpha    | Not supported               |                                                                        |
| glibc >= 3.40        | amd64    | Fully supported             | D12 (2.36), D13 (2.41), F41 (2.40), F42 (2.41), U22 (2.35), U24 (2.39) |
| glibc                | arm      | Not supported               | D12 (2.36), D13 (2.41), U24 (2.39)  U24 (2.39)                         |
| glibc                | arm64    | Available                   | D12 (2.36), D13 (2.41), U22 (2.35), U24 (2.39)                         |
| glibc                | hppa     | Not supported               | D12 (2.36), D13 (2.41), U22 (2.35), U24 (2.39)                         |
| glibc                | loong    | Available                   |             D13 (2.41),             U24 (2.39)                         |
| glibc                | mips64   | Available                   | D12 (2.36), D13 (2.40), U22 (2.35), U24 (2.39)                         |
| glibc                | mips     | Available                   | D12 (2.36), D13 (2.40), U22 (2.35), U24 (2.39)                         |
| glibc                | ppc      | Not supported               | D12 (2.36), D13 (2.41), U22 (2.35), U24 (2.39)                         |
| glibc                | ppc64    | Available                   | D12 (2.36), D13 (2.41), U22 (2.35), U24 (2.39)                         |
| glibc                | riscv    | Available                   | D12 (2.36), D13 (2.41), U22 (2.35), U24 (2.39)                         |
| glibc                | s390x    | Available                   | D12 (2.36), D13 (2.41), U22 (2.35), U24 (2.39)                         |
| glibc                | sparc64  | Available                   | D12 (2.36), D13 (2.41), U22 (2.35), U24 (2.39)                         |
| glibc                | x86      | Not supported               | D12 (2.36), D13 (2.41), U22 (2.35), U24 (2.39)                         |
| musl >= 1.2.3        | *        | Available                   | D12 (1.2.3), D13 (1.2.5), U22 (1.2.2), U24 (1.2.4)                     |

* Using 32-bit may increase the chances of high-critical vulnerabilities.  Examples:
  - ASLR effectiveness on 32-bit is estimated to be 10-20% or 20-50% and can lead to increased privilege escalation, data tampering, information disclosure
  - Transient execution CPU vulnerabilities (Meltdown, Spectre v2, MDS, TAA, SCSB, FPVI, BHI, Retbleed) may lead to information disclosure if unpatched or partially patched for 32-bit
  - V8 Sandbox (64-bit supported only, protects against memory corruption, if not used may lead to code execution, privilege escalation, data tampering, information disclosure)

| Compiler                        | Ebuild level of support               | Distro or CI image correspondence     |
| ---                             | ---                                   | ---                                   |
| Clang <= 17                     | Not supported                         | D12 (14.0), U22 (14.0)                |
| Clang 18                        | Fully supported                       | U24 (18.0)                            |
| Clang 19                        | Supported                             | D13 (19.0), F41 (19.1.7)              |
| Clang 20                        | Available                             | F42 (20.1.3)                          |
| Clang 21                        | Not supported                         |                                       |
| Clang 22                        | Not supported                         |                                       |
| Cython 0.29.37.1                | Fully supported                       | D12 (0.29.32), U22 (0.29)             |
| Cython 3.0.12                   | Fully Supported                       | D13 (3.0.11), U24 (3.0.8)             |
| Cython 3.1.0                    | Fully supported                       |                                       |
| GCC 11                          | Fully supported                       | U22 (11.2)                            |
| GCC 12                          | Fully supported                       | D12 (12.2)                            |
| GCC 13                          | Fully supported                       | U24 (13.2)                            |
| GCC 14                          | Partially Supported                   | D13 (14.2), F41 (14.2.1), F40 (14.0)  |
| GCC 15                          | Fully supported                       | F42 (15.1.1)                          |
| GCC 16			  | Not Supported                         |                                       |
| Rust 1.63.0                     | Not supported                         | D12 (1.63.0)                          |
| Rust 1.74.0                     | Partially supported                   |                                       |
| Rust 1.75.0                     | Available                             | U22 (1.75.0), U24 (1.75.0)            |
| Rust 1.85.0                     | Available                             | D13 (1.85.0)                          |
| Rust 1.86.0                     | Fully supported                       | F41 (1.86.0), F42 (1.86.0)            |
| Rust 1.89.0                     | Available                             |                                       |
| Rust-9999 (1.89.0-nightly)      | Partially supported                   |                                       |

| `-std=c++<ver>` or CXX_STANDARD | LTS or rolling compiler?         | Compiler status for C++ standard | C++ standard library status for C++ standard |
| ---                             | ---                              | ---                              | ---                                          |
| c++98                           | LTS                              | ?                                | ?                                            |
| c++03                           | LTS                              | ?                                | ?                                            |
| c++11                           | LTS                              | Incomplete                       | Done                                         |
| c++14                           | LTS                              | Done                             | Done                                         |
| c++17                           | LTS                              | Done                             | GCC (Done), LLVM (Incomplete)                |
| c++20                           | Rolling                          | Incomplete                       | GCC (Done), LLVM (Incomplete)                |
| c++23                           | Rolling                          | Incomplete                       | Incomplete                                   |
| c++26                           | Rolling                          | Incomplete                       | Incomplete                                   |

| LTS or rolling compiler?        | Default C++ standard             | GCC default | Clang default | Overlay USE flags [5]         | Distro correspondance   | Overlay CPU or GPU acceleration support                  |
| ---                             | ---                              | ---         | ---           | ---                           | ---                     | ---                                                      |
| LTS                             | gnu++17 (c++17 & GNU extension)  | 11          | 14            | gcc_slot_11_5                 | U22                     | CUDA 12.6, CUDA 12.8, CUDA 12.9, CPU [3]                 |
| LTS                             | gnu++17 (c++17 & GNU extension)  | 12          | 14            | gcc_slot_12_5                 | D12                     | CUDA 12.6, CUDA 12.8, CUDA 12.9, CPU [3]                 |
| LTS                             | gnu++17 (c++17 & GNU extension)  | 13          | 18            | gcc_slot_13_4, llvm_slot_18   | U24                     | CUDA 12.6, CUDA 12.8, CUDA 12.9, CPU                     |
| LTS                             | gnu++17 (c++17 & GNU extension)  | 14          | 19            | gcc_slot_14_3, llvm_slot_19   | D13                     | CUDA 12.8, CUDA 12.9, ROCm 6.4, ROCm 7.0, CPU            |
| LTS                             | gnu++17 (c++17 & GNU extension)  | 13          | 19            | gcc_slot_13_4, llvm_slot_19   | G23 [1]                 | CUDA 12.8, CUDA 12.9, ROCm 6.4, ROCm 7.0, CPU            |
| Rolling                         | gnu++17 (c++17 & GNU extension)  | 14          | 20            | gcc_slot_14_3, llvm_slot_20   | G23 [2]                 | CUDA 12.8, CUDA 12.9, CPU [3]                            |
| Rolling                         | gnu++17 (c++17 & GNU extension)  | 15          | 20            | gcc_slot_15_2, llvm_slot_20   | F42                     | CPU only                                                 |
| Rolling                         | gnu++17 (c++17 & GNU extension)  | 15          | 21            | gcc_slot_15_2, llvm_slot_21   | F43                     | CPU only                                                 |
| Rolling                         | gnu++17 (c++17 & GNU extension)  | 16          |               | gcc_slot_16_1                 |                         | CPU only                                                 |
| Rolling                         | gnu++17 (c++17 & GNU extension)  |             | 22            | llvm_slot_22                  |                         | CPU only                                                 |

* [1] This overlay's current default.  Similar to U24 which makes LLVM 19 available.
* [2] The latest stable for this distro.
* [3] GPU acceleration only available with GCC built packages
* [4] GPU acceleration only available with LLVM built packages
* [5] The GCC USE flags add the minor version because GCC 9 has multiple
      GLIBCXX_ versions, but the GCC USE flags may later be simplified on major
      update.

* This overlay prefers users use one of the LTS combos to avoid issues.
* The default C++ standard can be found at:
  GCC:    gcc/c-family/c-opts.cc in c_common_init_options()
  Clang:  clang/lib/Basic/LangStandards.cpp in clang::getDefaultLanguageStandard()
* LTS compilers have the libstdc++ GLIBCXX_ versioned symbols, GPU stack
  compatibility, practically complete version of the C++ standard on both the
  *C++ compiler* and *C++ standard library*, and ensure that the userland is
  built for compatibility for C++ prebuilt LTS binaries.  Currently, C++ 17 is
  the default for both GCC and Clang and is the default for most open source
  C++ projects in 2025.  A LTS compiler should be used as the systemwide
  default to maximize performance and compatibility.
* The rolling compilers have the up-to-date implementation of the
  C++ standard, increased feature coverage of the standard,
  usually have the minimum required feature set to build most projects for that
  standard on this overlay.  The minimum GCC/Clang version used per rolling
  standard in this overlay minimizes incomplete coverage to avoid missing
  support errors.  The consequences of using the rolling compiler as the
  systemwide default is that it will lock out access for GPU acceleration which
  is orders of magnitude faster than CPU in certain use case scenarios.  The
  typical use case for using rolling compilers it to take advantage of the
  gimmicks of newer CPUs instruction sets or access to newer microarchitectures
  at the cost of access to faster GPU AI inference or processing.  Rolling
  should not be used in packages where GPU is an option.
* Ebuild testing and development defaults on this overlay are currently
  set to GCC 13, Clang 19 for LTS; GCC 15, Clang 20 for rolling.
* CUDA 11.8 is not recommended because of version inconsistency between
  distro's cuDNN ebuild and pyTorch version recommendations.  This CUDA version
  is limited to using GCC 11 only on this overlay.
* GCC 12 or 13 are recommended for CUDA 12.8 for maximum compatibility coverage
  for using Blender, Ollama (LLM), pyTorch (ML) and to closely align with D12
  or U24.
* GCC 13 is recommended for ROCm 6.4 for maximum compatibility coverage for
  example with pyTorch (ML), TensorFlow (ML), Ollama (LLM), Blender and to
  closely align with U24.
* GCC 15 is not supported as a LTS compiler because it breaks -fvtable-verify,
  which lowers security.  GCC 15 is supported as a rolling compiler for non
  LTS (C++ 20 or newer) packages (e.g. Hyprland).  The developers of Hyprland
  have build files that reference a rolling distro.  This is partly why the
  counterpart to LTS is called a rolling compiler on this overlay.
* GCC is preferred but Clang is recommended as the fallback compiler.
* Clang 18, 19 are alternative LTS compilers on this overlay, but the
  corresponding libc++ 18 or 19 used as the alternative C++ standard library
  is still feature incomplete and not recommended as the systemwide default.
* libstdc++ is the assumed default C++ standard library in this overlay.
  The alternative libc++ as a systemwide default has not been tested for
  these ebuilds.
* Vendored Clang `22.0.0git` and vendored Rust (`<rust-ver>-dev`) from the
  chromium-toolchain package are only supported on Chromium for proper Rust SSP.
* =dev-lang/rust-bin-9999 is recommended for SSP, sanitizers, and as default to
  be used in security-critical packages.
* rust-bin older supported stable (1.74.0, 1.75.0) and rust-bin latest stable
  (1.86.0) are recommended as fallbacks for non security-critical packages.

| Python               | Ebuild level of support               | Distro or CI image correspondence                              |
| ---                  | ---                                   | ---                                                            |
| 3.10 and earlier     | Not supported (EOL) [1]               | U22 (EOL Apr 2027)                                             |
| 3.11                 | Mostly supported                      | D12 (EOL Jun 2026)                                             |
| 3.12                 | Partially supported                   | U24 (EOL Apr 2029)                                             |
| 3.13                 | Available                             | D13 (EOL Aug 2028), F41 (EOL Nov 2025), F42 (EOL May 2026)     |
| 3.13t [3]            | Not supported                         |                                                                |
| 3.14 and later [3]   | Not supported                         |                                                                |
| pypy3 [2][3]         | Not supported                         |                                                                |
| pypy3_11 [3]         | Not supported                         |                                                                |

* [1] Not supported due to [python-utils-r1.eclass](https://github.com/gentoo/gentoo/blob/master/eclass/python-utils-r1.eclass#L44)
      EOL restrictions, but not [EOL upstream](https://devguide.python.org/versions/).
      Forced PYTHON_COMPAT bumps (to Python 3.11 or any future minimum version
      bumps) may introduce DoS vulnerabilities (e.g. crash) or incompatibilities.
* [2] [Python 3.10](https://projects.gentoo.org/python/guide/basic.html#python-compat)
* [3] Not widely tested with CI.

| Platform                            | Ebuild level of support               | Distro or CI image correspondence                        |
| ---                                 | ---                                   | ---                                                      |
| CUDA 11.8                           | Not supported                         | D12, F35, U18, U20, U22                                  |
| CUDA 12.3                           | Not supported                         | D10, D11, D12, F37, U20, U22                             |
| CUDA 12.4                           | Not supported                         | D10, D11, D12, F39, U20, U22                             |
| CUDA 12.5                           | Not supported                         | D10, D11, D12, F39, U20, U22, U24                        |
| CUDA 12.6                           | Available                             | D11, D12, F39, U20, U22, U24                             |
| CUDA 12.8                           | Available                             | D12, F41, U20, U22, U24                                  |
| CUDA 12.9                           | Available                             | D12, F41, U20, U22, U24                                  |
| CUDA 13.0                           | Not supported                         | D12, F42, U22, U24                                       |
| Electron (amd64)                    | Fully supported                       |                                                          |
| Electron (arm64)                    | Not supported                         |                                                          |
| Electron (armv7)                    | Not supported                         |                                                          |
| Electron (x86)                      | Not supported                         |                                                          |
| gRPC 1.30.2 [3]                     | Fully supported                       | U22 (1.30.2)                                             |
| gRPC 1.51.3 [3]                     | Fully supported                       | D12 (1.51.1), D13 (1.51.1), U24 (1.51.1)                 |
| gRPC 1.71.2 [3]                     | Fully supported                       |                                                          |
| gRPC >= 1.75.1 (3)                  | Fully supported                       |                                                          |
| GTK 2 (4)                           | Not Supported                         |                                                          |
| GTK 3                               | Fully supported                       |                                                          |
| GTK 4                               | Fully supported                       |                                                          |
| OpenGL <= 4.6                       | Fully supported                       |                                                          |
| OpenCL <= 2.0                       | Fully supported                       |                                                          |
| Ollama 0.12 (CPU)                   | Available                             |                                                          |
| Ollama 0.12 (ROCm 6.3)              | Not supported                         |                                                          |
| Ollama 0.12 (CUDA 11.8)             | Not supported                         |                                                          |
| Ollama 0.12 (CUDA 12.8)             | Available                             |                                                          |
| GCC OpenMP (CPU)                    | Fully supported                       |                                                          |
| LLVM OpenMP (CPU)                   | Fully supported                       |                                                          |
| LLVM OpenMP offload (CUDA)          | Available                             |                                                          |
| LLVM OpenMP offload (ROCm)          | Not Supported                         |                                                          |
| ROCm OpenMP offload (2)             | WIP                                   |                                                          |
| DPC++ OpenMP offload                | Not Supported                         |                                                          |
| OpenRC                              | Fully supported                       |                                                          |
| Protobuf-cpp 3 [3]                  | Fully supported                       | D12 (3.21.12), F41 (3.19.6), F42 (3.19.6), U24 (3.21.12) |
| Protobuf-cpp 5 [3]                  | Fully supported                       |                                                          |
| Protobuf-cpp 6 [3]                  | Fully supported                       |                                                          |
| PyTorch <= 2.7                      | Not supported                         |                                                          |
| PyTorch 2.8 (CPU)                   | Available                             |                                                          |
| PyTorch 2.8 (CUDA 12.6, 12.8, 12.9) | Available                             |                                                          |
| PyTorch 2.8 (ROCm 6.4)              | Available                             |                                                          |
| PyTorch 2.9 (CPU)                   | Available                             |                                                          |
| PyTorch 2.9 (CUDA 12.6, 12.8, 13.0) | Available                             |                                                          |
| PyTorch 2.9 (ROCm 6.4)              | Available                             |                                                          |
| Qt 5.x [4][5]                       | Not supported, but available          |                                                          |
| Qt 6.x                              | Fully supported                       |                                                          |
| ROCm 6.4                            | WIP                                   | D12, U22, U24                                            |
| ROCm 7.0                            | WIP                                   | D12, D13, U22, U24                                       |
| SYCL                                | Not supported                         |                                                          |
| systemd                             | Partially supported                   |                                                          |
| TensorFlow 2.17 (CPU)               | WIP                                   |                                                          |
| TensorFlow 2.17 (CUDA 12.3)         | WIP                                   |                                                          |
| TensorFlow 2.20 (CPU)               | WIP                                   |                                                          |
| TensorFlow 2.20 (CUDA 12.5)         | WIP                                   |                                                          |
| TensorFlow 2.20 (ROCm 6.4)          | WIP                                   |                                                          |
| Vulkan                              | Fully supported                       |                                                          |
| Wayland                             | Fully supported                       |                                                          |
| X                                   | Fully supported                       |                                                          |

* [2] Via llvm-roc-libomp
* [3] Multislotted on this overlay.  Multiple versions can be installed at the same time.
* [4] Backporting security patches is likely to be incomplete.  No hardened
      ebuilds will be provided.  You must either keep a local ebuild fork
      with cflags-hardened changes or add per-package hardening CFLAGS (e.g.
      Retpoline, CET) for UI toolkit packages that have a password UI widget,
      or for packages that process untrusted data or process sensitive data.
* [5] No extra libstdc++ versioned symbol consistency verification via
      `gcc_slot_<x>`.  You are responsible for ensuring the default GCC is set
      to the proper default when building Qt5 packages to avoid linking issues.
      Manually set the default LTS compiler for C++ 17 and older C++ projects.
      Manually set the default rolling compiler for C++ 20 and newer C++ projects.
      If no C++ standard stated, assume LTS.  The Qt5 based project will state
      in the build files either `-std=c++<ver>` or `-std=gnu++<ver>` or
      `CMAKE_CXX_STANDARD`.
* Due to the lack of GPU access, the requirements are the exact major.minor
  version requirements for GPU, Machine Learning (ML), and Large Language Model
  (LLM) ebuild packages in this overlay for increased chances of
  reproducibility.

Gentoo Prefix is not supported and deprecated on this overlay.

The support status depends on the ebuild contributors ability to test and patch.
