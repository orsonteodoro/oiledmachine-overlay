# Ebuild *DEPENDs support matrix

| Support level        | Quality      | Meaning                                                                        |
| ---                  | ---          | ---                                                                            |
| EOL                  | Poor         | No longer compatible and may be removed, may have security issues              |
| Deprecated           | Best to poor | Phased out for removal and may be actively removed, may have security issues   |
| Fully supported      | Best         | Tested, fully compatible                                                       |
| Mostly supported     | Better       | Tested and partially compatible                                                |
| Partially supported  | Good to poor | May be tested and partially compatible                                         |
| Available            | Good to poor | Not tested, partially compatible, ebuild may be unfinished                     |

| Python            | Level of support                         |
| ---               | ---                                      |
| 3.9 and earlier   | Not supported (EOL)                      |
| 3.10              | Fully supported                          |
| 3.11              | Mostly supported                         |
| 3.12              | Partially supported                      |
| 3.13              | Partially supported                      |
| 3.13t             | Not supported                            |
| 3.14 and later    | Not supported                            |
| pypy3             | Available but not supported              |
| pypy3_11          | Not supported                            |

| LIBC              | Arch    | Level of support               |
| ---               | ----    | ---                            |
| glibc             | 64-bit  | Generally supported            |
| glibc             | 32-bit  | Deprecated                     |
| glibc             | alpha   | Not supported                  |
| glibc >= 3.38     | amd64   | Fully supported                |
| glibc             | arm     | Not supported                  |
| glibc             | arm64   | Available but not supported    |
| glibc             | hppa    | Not supported                  |
| glibc             | loong   | Available but not supported    |
| glibc             | ppc     | Not supported                  |
| glibc             | ppc64   | Available but not supported    |
| glibc             | riscv   | Available but not supported    |
| glibc             | sparc   | Not supported                  |
| glibc             | x86     | Not supported                  |
| musl              | *       | Available                      |

| Platform          | Level of support                         |
| ---               | ---                                      |
| CUDA              | Available                                |
| Electron (amd64)  | Fully supported                          |
| Electron (arm64)  | Not supported                            |
| Electron (x86)    | Not supported                            |
| gRPC 1.49 - 1.54  | Fully supported                          |
| gRPC 1.55 - 1.62  | Available                                |
| gRPC >= 1.63      | Available                                |
| GTK+3             | Fully supported                          |
| GTK 4             | Fully supported                          |
| OpenGL <= 4.6     | Fully supported                          |
| OpenCL <= 2.0     | Fully supported                          |
| Ollama            | Fully supported                          |
| Prefix            | Not supported                            |
| Protobuf 3        | Fully supported                          |
| Protobuf 4        | Available                                |
| Protobuf 5        | Available                                |
| Pytorch           | Fully supported                          |
| Qt 5.x            | Not supported                            |
| Qt 6.x            | Fully supported                          |
| ROCm              | Available                                |
| TensorFlow        | Partially supported                      |
| Vulkan            | Fully supported                          |
| Wayland           | Fully supported                          |
| X                 | Fully supported                          |

Gentoo Prefix is not supported and deprecated on this overlay.

The support status depends on the ebuild contributors.
