# Ebuild *DEPENDs support matrix for this overlay

| Support level        | Quality      | Meaning                                                                                                  |
| ---                  | ---          | ---                                                                                                      |
| Fully supported      | Best         | Tested, fully compatible                                                                                 |
| Mostly supported     | Better       | Tested and partially compatible                                                                          |
| Partially supported  | Good         | May be tested and partially compatible                                                                   |
| Available            | Good to poor | **Not tested**, partially compatible, ebuild may be unfinished, Work in Progress (WIP)                   |
| Deprecated           | Best to poor | Phased out for removal and may be actively removed, may have security issues                             |
| Planned              | -            | To be added to maximize interoperability between platforms and app features                              |
| EOL                  | Poor         | No longer compatible and may be removed, may have security issues that are practically impossible to fix |
| Not supported        | Poor         | Dropped support by overlay, may have security issues, untested                                           |

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

| LIBC                 | Arch     | Level of support            | Distro or CI image correspondence              |
| ---                  | ----     | ---                         | ---                                            |
| glibc                | 64-bit   | Generally supported         | D12 (2.36), U24 (2.39)                         |
| glibc                | 32-bit   | Deprecated*                 | D12 (2.36), U24 (2.39)                         |
| glibc                | alpha    | Not supported               |                                                |
| glibc >= 3.40        | amd64    | Fully supported             | D12 (2.36), F41 (2.40), F42 (2.41), U24 (2.39) |
| glibc                | arm      | Not supported               | D12 (2.36), U24 (2.39)                         |
| glibc                | arm64    | Available                   | D12 (2.36), U24 (2.39)                         |
| glibc                | hppa     | Not supported               |                                                |
| glibc                | loong    | Available                   |                                                |
| glibc                | mips64   | Available                   | D12 (2.36)                                     |
| glibc                | mips     | Available                   | D12 (2.36)                                     |
| glibc                | ppc      | Not supported               |                                                |
| glibc                | ppc64    | Available                   |             U24 (2.39)                         |
| glibc                | riscv    | Available                   |             U24 (2.39)                         |
| glibc                | s390x    | Available                   | D12 (2.36), U24 (2.39)                         |
| glibc                | sparc    | Available                   |                                                |
| glibc                | x86      | Not supported               | D12 (2.36), U24 (2.39)                         |
| musl >= 1.2.3        | *        | Available                   | D12 (1.2.3), U24 (1.2.4)                       |

* Using 32-bit may increase the chances of high-critical vulnerabilities.  Examples:
  - ASLR effectiveness on 32-bit is estimated to be 10-20% or 20-50% and can lead to increased privilege escalation, data tampering, information disclosure
  - Transient execution CPU vulnerabilities (Meltdown, Spectre v2, MDS, TAA, SCSB, FPVI, BHI, Retbleed) may lead to information disclosure if unpatched or partially patched for 32-bit
  - V8 Sandbox (64-bit supported only, protects against memory corruption, if not used may lead to code execution, privilege escalation, data tampering, information disclosure)

| Compiler                        | Level of support                      | Distro or CI image correspondence  |
| ---                             | ---                                   | ---                                |
| Clang 14                        | Not supported                         | D12 (14.0)                         |
| Clang 18                        | Fully supported                       | U24 (18.0)                         |
| Clang 19                        | Supported                             | F41 (19.1.7)                       |
| Clang 20                        | Available                             | F42 (20.1.3), A(20)                |
| Clang 21                        | Not supported                         |                                    |
| Cython 0.29.37.1                | Fully supported                       | D12 (0.29.32)                      |
| Cython 3.0.12                   | Fully Supported                       | U24 (3.0.8)                        |
| Cython 3.1.0                    | Fully supported                       |                                    |
| GCC 12                          | Fully supported                       | D12 (12.2)                         |
| GCC 13                          | Partially Supported                   | U24 (13.2)                         |
| GCC 14                          | Partially Supported                   | F41 (14.2.1), F40 (14.0)           |
| GCC 15                          | Not Supported                         | F42 (15.1.1), A(15.2)              |
| GCC 16			  | Not Supported                         |                                    |
| Rust 1.63.0                     | Not supported                         | D12 (1.63.0)                       |
| Rust 1.74.0                     | Partially supported                   |                                    |
| Rust 1.75.0                     | Available                             | U24 (1.75.0)                       |
| Rust 1.86.0                     | Fully supported                       | F41 (1.86.0), F42 (1.86.0)         |
| Rust 1.89.0                     | Available                             | A (1.89.0)                         |
| Rust-9999 (1.89.0-nightly)      | Partially supported                   |                                    |

* GCC 13 is recommended for ROCm 6.2 when using pyTorch (ML), TensorFlow (ML), Ollama (LLM), Blender.
* GCC 12 is recommended for CUDA 11.8 when using pyTorch (ML), TensorFlow (ML), Ollama (LLM).
* GCC 13 is recommended for CUDA 12.8 when using Blender, Ollama (LLM).  This is to align closely with U24.
* GCC 15 is not supported in this overlay because of -fvtable-verify, prebuilt GPU libraries limits on
  maximium supported GCC version, and the decrease in feature completeness such has reduced hardening or
  reduced features like in shareware.
* The entire @world needs to be built with the same GCC version to avoid build time symbol version problems for GPU support.
* What it means for CUDA users is that if you want your AI girlfriend (LLM) to have hardware accelerated speech recognition stick to GCC 12 and CUDA 11.8.
* GCC is preferred but Clang 18 is recommended as fallback.
* Vendored Clang `21.0.0git` and vendored Rust (`<rust-ver>-dev`) from the chromium-toolchain package are only supported on Chromium for proper Rust SSP.
* rust-bin 9999 is recommended for SSP, sanitizers, and as default to be used in security-critical packages.
* rust-bin older supported stable (1.74.0, 1.75.0) and rust-bin latest stable (1.86.0) are recommended as fallbacks for non security-critical packages.
* Due to the lack of GPU access, the requirements are the exact major.minor version requirements for this overlay and ML/LLM libraries for increased chances of reproducibility.

| Python               | Level of support                      | Distro or CI image correspondence          |
| ---                  | ---                                   | ---                                        |
| 3.10 and earlier     | Not supported (EOL)*                  | U22 (EOL Apr 2027)                         |
| 3.11                 | Mostly supported                      | D12 (EOL Jun 2026)                         |
| 3.12                 | Partially supported                   | U24 (EOL Apr 2029), A(Rolling)             |
| 3.13                 | Available                             | F41 (EOL Nov 2025), F42 (EOL May 2026)     |
| 3.13t                | Not supported                         |                                            |
| 3.14 and later       | Not supported                         |                                            |
| pypy3                | Available                             |                                            |
| pypy3_11             | Not supported                         |                                            |

* Not supported due to [python-utils-r1.eclass](https://github.com/gentoo/gentoo/blob/master/eclass/python-utils-r1.eclass#L44)
  EOL restrictions, but not [EOL upstream](https://devguide.python.org/versions/).
  Forced PYTHON_COMPAT bumps (to Python 3.11 or any future minimum version
  bumps) may introduce DoS vulnerabilities (e.g. crash) or incompatibilities.

| Platform                          | Level of support                      | Distro or CI image correspondence                        |
| ---                               | ---                                   | ---                                                      |
| CUDA 11.8                         | Available                             | D12 (11.8)                                               |
| CUDA 12.8                         | Planned                               | U24 (12.0)                                               |
| Electron (amd64)                  | Fully supported                       |                                                          |
| Electron (arm64)                  | Not supported                         |                                                          |
| Electron (armv7)                  | Not supported                         |                                                          |
| Electron (x86)                    | Not supported                         |                                                          |
| gRPC 1.49 - 1.54                  | Fully supported                       | D12 (1.51.1), F41 (1.48.4), F42 (1.48.4), U24 (1.51.1)   |
| gRPC 1.55 - 1.62                  | Available                             |                                                          |
| gRPC >= 1.63                      | Available                             |                                                          |
| GTK 2 (4)                         | Not Supported                         |                                                          |
| GTK 3                             | Fully supported                       |                                                          |
| GTK 4                             | Fully supported                       |                                                          |
| OpenGL <= 4.6                     | Fully supported                       |                                                          |
| OpenCL <= 2.0                     | Fully supported                       |                                                          |
| Ollama >= 0.3 (CPU)               | Fully supported                       |                                                          |
| Ollama >= 0.3 (CUDA 11.8)         | Available                             |                                                          |
| Ollama 0.3, 0.4 (ROCm 6.1)        | Not Supported                         |                                                          |
| Ollama 0.3, 0.4 (CUDA 12.4)       | Available                             |                                                          |
| Ollama 0.5, 0.6, 0.7 (ROCm 6.3)   | Planned                               |                                                          |
| Ollama 0.5, 0.6, 0.7 (CUDA 12.8)  | Available                             |                                                          |
| GCC OpenMP (CPU)                  | Fully supported                       |                                                          |
| LLVM OpenMP (CPU)                 | Fully supported                       |                                                          |
| LLVM OpenMP offload (CUDA)        | Available                             |                                                          |
| LLVM OpenMP offload (ROCm)        | Not Supported                         |                                                          |
| ROCm OpenMP offload               | Available                             |                                                          |
| DPC++ OpenMP offload              | Planned                               |                                                          |
| OpenMP (ROCm)                     | Available                             |                                                          |
| OpenRC                            | Fully supported                       |                                                          |
| Protobuf 3                        | Fully supported                       | D12 (3.21.12), F41 (3.19.6), F42 (3.19.6), U24 (3.21.12) |
| Protobuf 4                        | Available                             |                                                          |
| Protobuf 5                        | Available                             |                                                          |
| PyTorch 1.13.x                    | Not supported                         | D12 (1.13.1)                                             |
| PyTorch >= 2.0 (CPU)              | Fully supported                       |                                                          |
| PyTorch >= 2.0 (CUDA 11.8)        | Available                             |                                                          |
| PyTorch 2.4 (CPU)                 | Available                             | F41 (2.4.0)                                              |
| PyTorch 2.5 (CPU)                 | Fully Supported                       | F42 (2.5.1)                                              |
| PyTorch 2.5 (CUDA 12.4)           | Available                             |                                                          |
| PyTorch 2.5 (ROCm 6.2)            | Available                             |                                                          |
| PyTorch 2.7 (CUDA 12.8)           | Planned                               |                                                          |
| PyTorch 2.7 (ROCm 6.3)            | Planned                               |                                                          |
| Qt 5.x (4)                        | Not supported, but available          |                                                          |
| Qt 6.x                            | Fully supported                       |                                                          |
| ROCm 6.2                          | Available                             | F41 (6.2.1) (3), U24 (>= 6.2.0) (1)                      |
| ROCm 6.3                          | Planned                               | D12 (>= 6.3.1) (2), F42 (6.3.1) (3)                      |
| SYCL                              | Not supported                         |                                                          |
| systemd                           | Partially supported                   |                                                          |
| TensorFlow >= 2.14 (CPU)          | Fully supported                       |                                                          |
| TensorFlow 2.14 (CUDA 11.8)       | Available                             |                                                          |
| TensorFlow 2.16 (CUDA 12.3)       | Available                             |                                                          |
| TensorFlow 2.17 (CUDA 12.3)       | Available                             |                                                          |
| TensorFlow 2.18 (CUDA 12.5)       | Available                             |                                                          |
| TensorFlow 2.18 (ROCm  6.2)       | Available                             |                                                          |
| Vulkan                            | Fully supported                       |                                                          |
| Wayland                           | Fully supported                       |                                                          |
| X                                 | Fully supported                       |                                                          |

* (1) U24 uses Python 3.12 for ROCm support
* (2) D12 uses Python 3.11 for ROCm support
* (3) F41, F42 uses Python 3.13 for ROCm support
* (4) Backporting security patches is likely to be incomplete.  No hardened
      ebuilds will be provided.  You must either keep a local ebuild fork
      with cflags-hardened changes or add per-package hardening CFLAGS (e.g.
      Retpoline, CET) for UI toolkit packages that have a password UI widget,
      or for packages that process untrusted data or process sensitive data.

Gentoo Prefix is not supported and deprecated on this overlay.

The support status depends on the ebuild contributors ability to test and patch.
