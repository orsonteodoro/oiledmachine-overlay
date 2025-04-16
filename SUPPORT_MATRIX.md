# Ebuild *DEPENDs support matrix for this overlay

| Support level        | Quality      | Meaning                                                                                                  |
| ---                  | ---          | ---                                                                                                      |
| Fully supported      | Best         | Tested, fully compatible                                                                                 |
| Mostly supported     | Better       | Tested and partially compatible                                                                          |
| Partially supported  | Good         | May be tested and partially compatible                                                                   |
| Available            | Good to poor | Not tested, partially compatible, ebuild may be unfinished, Work in Progress (WIP)                       |
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

| Python               | Level of support                      |
| ---                  | ---                                   |
| 3.9 and earlier      | Not supported (EOL)                   |
| 3.10                 | Fully supported                       |
| 3.11                 | Mostly supported                      |
| 3.12                 | Partially supported                   |
| 3.13                 | Partially supported                   |
| 3.13t                | Not supported                         |
| 3.14 and later       | Not supported                         |
| pypy3                | Available                             |
| pypy3_11             | Not supported                         |

The LIBC support below reflects the upstream projects CI (Continuous
Integration) images trend, but it may change if microarchitecture references
exist in build files.

| LIBC                 | Arch    | Level of support            |
| ---                  | ----    | ---                         |
| glibc                | 64-bit  | Generally supported         |
| glibc                | 32-bit  | Deprecated                  |
| glibc                | alpha   | Not supported               |
| glibc >= 3.38        | amd64   | Fully supported             |
| glibc                | arm     | Not supported               |
| glibc                | arm64   | Available                   |
| glibc                | hppa    | Not supported               |
| glibc                | loong   | Available                   |
| glibc                | ppc     | Not supported               |
| glibc                | ppc64   | Available                   |
| glibc                | riscv   | Available                   |
| glibc                | sparc   | Available                   |
| glibc                | x86     | Not supported               |
| musl                 | *       | Available                   |

| Platform             | Level of support                      |
| ---                  | ---                                   |
| CUDA                 | Available                             |
| Electron (amd64)     | Fully supported                       |
| Electron (arm64)     | Not supported                         |
| Electron (x86)       | Not supported                         |
| gRPC 1.49 - 1.54     | Fully supported                       |
| gRPC 1.55 - 1.62     | Available                             |
| gRPC >= 1.63         | Available                             |
| GTK+3                | Fully supported                       |
| GTK 4                | Fully supported                       |
| OpenGL <= 4.6        | Fully supported                       |
| OpenCL <= 2.0        | Fully supported                       |
| Ollama               | Fully supported                       |
| OpenMP (CPU)         | Fully supported                       |
| OpenMP (GPU)         | Available                             |
| OpenRC               | Fully supported                       |
| Protobuf 3           | Fully supported                       |
| Protobuf 4           | Available                             |
| Protobuf 5           | Available                             |
| PyTorch              | Fully supported                       |
| Qt 5.x               | Available                             |
| Qt 6.x               | Fully supported                       |
| ROCm                 | Available                             |
| SYCL                 | Available                             |
| systemd              | Partially supported                   |
| TensorFlow           | Available                             |
| Vulkan               | Fully supported                       |
| Wayland              | Fully supported                       |
| X                    | Fully supported                       |

Gentoo Prefix is not supported and deprecated on this overlay.

The support status depends on the ebuild contributors.
