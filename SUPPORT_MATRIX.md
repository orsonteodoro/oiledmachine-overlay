# Ebuild *DEPENDs support matrix for this overlay

| Support level        | Quality      | Meaning                                                                                                  |
| ---                  | ---          | ---                                                                                                      |
| Fully supported      | Best         | Tested, fully compatible                                                                                 |
| Mostly supported     | Better       | Tested and partially compatible                                                                          |
| Partially supported  | Good         | May be tested and partially compatible                                                                   |
| Available            | Good to poor | **Not tested**, partially compatible, ebuild may be unfinished, Work in Progress (WIP)                   |
| Deprecated           | Best to poor | Phased out for removal and may be actively removed, may have security issues                             |
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

| Python               | Level of support                      | Distro correspondance   |
| ---                  | ---                                   | ---                     |
| 3.10 and earlier     | Not supported (EOL)*                  | U22 (EOL Apr 2027)      |
| 3.11                 | Mostly supported                      | D12 (EOL Jun 2026)      |
| 3.12                 | Partially supported                   | U24 (EOL Apr 2029)      |
| 3.13                 | Available                             |                         |
| 3.13t                | Not supported                         |                         |
| 3.14 and later       | Not supported                         |                         |
| pypy3                | Available                             |                         |
| pypy3_11             | Not supported                         |                         |

* Not supported due to [python-utils-r1.eclass](https://github.com/gentoo/gentoo/blob/master/eclass/python-utils-r1.eclass#L44)
  EOL restrictions, but not [EOL upstream](https://devguide.python.org/versions/).
  Forced PYTHON_COMPAT bumps (to Python 3.11 or any future minimum version
  bumps) may introduce DoS vulnerabilities (e.g. crash) or incompatibilities.

The LIBC support below reflects the upstream projects CI (Continuous
Integration) images trend, but it may change if microarchitecture references
exist in build files.

| LIBC                 | Arch     | Level of support            | Distro correspondance    |
| ---                  | ----     | ---                         | ---                      |
| glibc                | 64-bit   | Generally supported         | D12 (2.36), U24 (2.39)   |
| glibc                | 32-bit   | Deprecated*                 | D12 (2.36), U24 (2.39)   |
| glibc                | alpha    | Not supported               |                          |
| glibc >= 3.40        | amd64    | Fully supported             | D12 (2.36), U24 (2.39)   |
| glibc                | arm      | Not supported               | D12 (2.36), U24 (2.39)   |
| glibc                | arm64    | Available                   | D12 (2.36), U24 (2.39)   |
| glibc                | hppa     | Not supported               |                          |
| glibc                | loong    | Available                   |                          |
| glibc                | mips64   | Available                   | D12 (2.36)               |
| glibc                | mips     | Available                   | D12 (2.36)               |
| glibc                | ppc      | Not supported               |                          |
| glibc                | ppc64    | Available                   |             U24 (2.39)   |
| glibc                | riscv    | Available                   |             U24 (2.39)   |
| glibc                | s390x    | Available                   | D12 (2.36), U24 (2.39)   |
| glibc                | sparc    | Available                   |                          |
| glibc                | x86      | Not supported               | D12 (2.36), U24 (2.39)   |
| musl                 | *        | Available                   | D12 (1.2.3), U24 (1.2.4) |

* Using 32-bit may increase the chances of high-critical vulnerabilities.  Examples:
  - ASLR effectiveness on 32-bit is estimated to be 10-20% or 20-50% and can lead to increased privilege escalation, data tampering, information disclosure
  - Transient execution CPU vulnerabilities (Meltdown, Spectre v2, MDS, TAA, SCSB, FPVI, BHI, Retbleed) that may lead to information disclosure that are unpatched or partially patched for 32-bit
  - V8 Sandbox (64-bit supported only, protects against memory corruption, if not used may lead to code execution, privilege escalation, data tampering, information disclosure)

| Platform                        | Level of support                      | Distro correspondance        |
| ---                             | ---                                   | ---                          |
| CUDA                            | Available                             | D12 (11.8), U24 (12.0)       |
| Electron (amd64)                | Fully supported                       |                              |
| Electron (arm64)                | Not supported                         |                              |
| Electron (x86)                  | Not supported                         |                              |
| gRPC 1.49 - 1.54                | Fully supported                       | D12 (1.51.1), U24 (1.51.1)   |
| gRPC 1.55 - 1.62                | Available                             |                              |
| gRPC >= 1.63                    | Available                             |                              |
| GTK+3                           | Fully supported                       |                              |
| GTK 4                           | Fully supported                       |                              |
| OpenGL <= 4.6                   | Fully supported                       |                              |
| OpenCL <= 2.0                   | Fully supported                       |                              |
| Ollama                          | Fully supported                       |                              |
| OpenMP (CPU)                    | Fully supported                       |                              |
| OpenMP (GPU)                    | Available                             |                              |
| OpenRC                          | Fully supported                       |                              |
| Protobuf 3                      | Fully supported                       | D12 (3.21.12), U24 (3.21.12) |
| Protobuf 4                      | Available                             |                              |
| Protobuf 5                      | Available                             |                              |
| PyTorch                         | Fully supported                       |                              |
| Qt 5.x                          | Available                             |                              |
| Qt 6.x                          | Fully supported                       |                              |
| ROCm >= 6.2                     | Available                             | D12 (5.2.3), U24 (5.7.0)     |
| SYCL                            | Available                             |                              |
| systemd                         | Partially supported                   |                              |
| TensorFlow >= 2.14 (CPU)        | Available                             |                              |
| TensorFlow >= 2.18 (ROCm  6.2)  | Available                             |                              |
| TensorFlow == 2.14 (CUDA 11.8)  | Available                             |                              |
| TensorFlow == 2.16 (CUDA 12.3)  | Available                             |                              |
| TensorFlow == 2.17 (CUDA 12.3)  | Available                             |                              |
| TensorFlow == 2.18 (CUDA 12.5)  | Available                             |                              |
| Vulkan                          | Fully supported                       |                              |
| Wayland                         | Fully supported                       |                              |
| X                               | Fully supported                       |                              |

Gentoo Prefix is not supported and deprecated on this overlay.

The support status depends on the ebuild contributors ability to test and patch.
