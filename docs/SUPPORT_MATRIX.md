# Ebuild *DEPENDs support matrix for this overlay

| Support level        | Quality      | Meaning                                                                                                  |
| ---                  | ---          | ---                                                                                                      |
| Fully supported      | Best         | Tested, fully compatible                                                                                 |
| Mostly supported     | Better       | Tested and partially compatible                                                                          |
| Partially supported  | Good         | May be tested and partially compatible                                                                   |
| Limited support      | Good         | Tested but restricted for use for a few select packages (e.g. bootstrapping)                             |
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
| Live (snapshot)      | Yes                                   |

* Using beta, alpha, preview versions, or enabling the debug USE flag may lead
  to information disclosure when the debug dump or crash report contains
  sensitive information.

The LIBC support below reflects the upstream projects CI/CD (Continuous
Integration and Continuous Deployment) images trend, but it may change if
microarchitecture references exist in build files.

| LIBC                 | Arch     | Ebuild level of support     | Distro or CI/CD image correspondence                                                                                                 |
| ---                  | ----     | ---                         | ---                                                                                                                                  |
| glibc                | 64-bit   | Generally supported         | D12 (2.36), D13 (2.41), F43 (2.42), F44 (2.43), F45 (2.44), G (2.43), Nunstable (2.44), U22 (2.35), U24 (2.39), U26 (2.43)           |
| glibc                | 32-bit   | Deprecated*                 | D12 (2.36), D13 (2.41), G (2.43), U22 (2.35), U24 (2.39), U26 (2.43)                                                                 |
| glibc                | alpha    | Not supported               |                                                                                                                                      |
| glibc >= 3.43        | amd64    | Fully supported             | D12 (2.36), D13 (2.41), F43 (2.42), F44 (2.43), F45 (2.44), G (2.43), Nunstable (2.44), U22 (2.35), U24 (2.39), U26 (2.43)           |
| glibc                | arm      | Not supported               | D12 (2.36), D13 (2.41), G (2.43),   U24 (2.39)  U24 (2.39), U26 (2.43)                                                               |
| glibc                | arm64    | Available                   | D12 (2.36), D13 (2.41), G (2.43),   U22 (2.35), U24 (2.39), U26 (2.43)                                                               |
| glibc                | hppa     | Not supported               | D12 (2.36), D13 (2.41), U22 (2.35), U24 (2.39)                                                                                       |
| glibc                | loong    | Available                   |             D13 (2.41),             U24 (2.39)                                                                                       |
| glibc                | mips64   | Available                   | D12 (2.36), D13 (2.40), U22 (2.35), U24 (2.39)                                                                                       |
| glibc                | mips     | Available                   | D12 (2.36), D13 (2.40), U22 (2.35), U24 (2.39)                                                                                       |
| glibc                | ppc      | Not supported               | D12 (2.36), D13 (2.41), G (2.43),   U22 (2.35), U24 (2.39)                                                                           |
| glibc                | ppc64    | Available                   | D12 (2.36), D13 (2.41), G (2.43),   U22 (2.35), U24 (2.39), U26 (2.43)                                                               |
| glibc                | riscv    | Available                   | D12 (2.36), D13 (2.41), G (2.43),   U22 (2.35), U24 (2.39), U26 (2.43)                                                               |
| glibc                | s390x    | Available                   | D12 (2.36), D13 (2.41), U22 (2.35), U24 (2.39), U26 (2.43)                                                                           |
| glibc                | sparc64  | Available                   | D12 (2.36), D13 (2.41), U22 (2.35), U24 (2.39)                                                                                       |
| glibc                | x86      | Not supported               | D12 (2.36), D13 (2.41), G (2.43), U22 (2.35), U24 (2.39), U26 (2.43)                                                                 |
| musl >= 1.2.6        | *        | Available                   | D12 (1.2.3), D13 (1.2.5), F43 (1.2.5), F44 (1.2.5), F45 (1.2.6), G (1.2.6), Nunstable (1.2.6), U22 (1.2.2), U24 (1.2.4), U26 (1.2.5) |

* Using 32-bit may increase the chances of high-critical vulnerabilities.  Examples:
  - ASLR effectiveness on 32-bit is estimated to be 10-20% or 20-50% and can lead to increased privilege escalation, data tampering, information disclosure
  - Transient execution CPU vulnerabilities (Meltdown, Spectre v2, MDS, TAA, SCSB, FPVI, BHI, Retbleed) may lead to information disclosure if unpatched or partially patched for 32-bit
  - V8 Sandbox (64-bit supported only, protects against memory corruption, if not used may lead to code execution, privilege escalation, data tampering, information disclosure)

This overlay primarily supports the distro's latest stable release (G) for libc.
However, if the distro does not backport security fixes, this overlay may force
the use of the current upstream release.

| Libc flavor                       | Last update since Nov 2026 |
| ---                               | ---                        |
| glibc 2.44 (upstream)             | 3m ago                     |
| glibc 2.44 (w/distro patches, G~) | 3w ago                     |
| glibc 2.43 (upstream)             | 9m ago                     |
| glibc 2.43 (w/distro patches, G)  | 3w ago                     |
| glibc 2.43 (w/distro patches, G~) | 3w ago                     |
| musl 1.2.6 (upstream)             | 8m ago                     |
| musl 1.2.6 (w/distro patches, G)  | 3w ago                     |

Compilers and interpreters used in this overlay

| Compiler [3a]                     | Ebuild level of support [3b]          | Distro or CI/CD image correspondence                                                   | Last update since Nov 2026  |
| ---                               | ---                                   | ---                                                                                    | ---                         |
| Clang <= 21                       | Not supported                         | D13 (21.1.8), F43 (21.1.8), G (21.1.8), Nunstable (21.1.8), U26 (21.1.8)               | 11m ago                     |
| Clang 22 [D]                      | Fully supported                       | D12 (22.1.8), D13 (22.1.8), F44 (22.1.8), G (22.1.8), U26 (22.1.2)                     | 5m ago                      |
| Clang 23                          | Available                             | F45 (23.1.5), G~ (23.1.5)                                                              | 3d ago                      |
| Clang 24                          | Limited support                       | G**                                                                                    | Now                         |
| Cython 0.29.37.1 [4]              | Deprecated, limited [4]               | D12 (0.29.32), U22 (0.29), Nunstable (0.29.37)                                         | 3y ago                      |
| Cython 3.0.12 [4]                 | Deprecated, limited [4]               | D13 (3.0.11), U24 (3.0.8)                                                              | 1y ago                      |
| Cython 3.1.0 [4]                  | Deprecated, limited [4]               | F43 (3.1.3), U26 (3.1.6)                                                               | 11m ago                     |
| Cython 3.2.0 [LTS]                | Available                             | F44 (3.2.4), F45 (3.2.8), G (3.2.8), Nunstable (3.2.5)                                 | 4m ago                      |
| Cython 3.3.0 [RSC][D]             | Available                             | G~ (3.3.1), Nunstable (3.3.0)                                                          | 3w ago                      |
| GCC <= 10                         | Not supported                         |                                                                                        | 3y ago                      |
| GCC 11 [1]                        | Limited [1]                           | U22 (11.2), G (11.5.0)                                                                 | 2y ago                      |
| GCC 12                            | Not supported                         | D12 (12.2), G (12.5.0)                                                                 | 1y ago                      |
| GCC 13                            | Not supported                         | U24 (13.2), G (13.4.1_p20260603)                                                       | 2m ago                      |
| GCC 14                            | Available                             | D13 (14.2), G (14.3.1_p20260604)                                                       | 5m ago                      |
| GCC 15 [D]                        | Fully supported                       | F43 (15.3.1), G (15.3.0), U26 (15.2.0)                                                 | 5m ago                      |
| GCC 16			    | Available                             | F45 (16.2.1), G (16.2.1_p20260926), Nunstable (16.2.0)                                 | 3m ago                      |
| GCC 17                            | Available but not supported           | G**                                                                                    | Now                         |
| Node.js <= 20                     | Not supported                         | D13 (20.19.2)                                                                          | 8m ago                      |
| Node.js 22                        | Available                             | F43 (22.22.1), F45 (22.23.1), Nunstable (22.23.5), U26 (22.22.1)                       | 1w ago                      |
| Node.js 24 [D]                    | Fully supported                       | F43 (24.14.1), F44 (24.18.0), F45 (24.18.0), Nunstable (24.22.2)                       | 1w ago                      |
| Node.js 26                        | Available                             | Nunstable (26.13.1)                                                                    | 1w ago                      |
| PyPy:2.7                          | Not supported                         | F43 (7.3.23), F44 (7.3.23), F45 (7.3.23), G (8.0.1), Nunstable (7.3.19)                | 1m ago                      |
| PyPy:3.9                          | Not supported                         | D12 (7.3.11)                                                                           | 2y ago                      |
| PyPy:3.10                         | Not supported                         | Nunstable (7.3.19)                                                                     | 1y ago                      |
| PyPy:3.11                         | Available                             | D13 (7.3.19), F43 (8.0.0), F44 (8.0.0), F45 (8.0.0), G (8.0.1), Nunstable (7.3.20)     | 1m ago                      |
| PyPy:3.12                         | Available                             | F45 (8.0.0), G (8.0.1)                                                                 | 1m ago                      |
| Python 3.9 and earlier            | Not supported [5][8]                  |                                                                                        | 1y ago                      |
| Python 3.10                       | Not supported [5][8]                  | U22 (3.10.6), G (3.10.22)                                                              | 2m ago                      |
| Python 3.11 [9]                   | Available [4][5][9]                   | D12 (3.11.2), G (3.11.18)                                                              | 1m ago                      |
| Python 3.12 [D]                   | Fully supported [10]                  | G (3.12.16), U24 (3.12.3)                                                              | 1m ago                      |
| Python 3.13                       | Partially supported                   | D13 (3.13.5), G (3.13.18_p1), Nunstable (3.14.10)                                      | 1m ago                      |
| Python >= 3.13t [7][11]           | Not supported                         |                                                                                        | 1m ago                      |
| Python 3.14                       | Available                             | F43 (3.14.10), F44 (3.14.10), G (3.14.10_p1), U26 (3.14.3)                             | 1m ago                      |
| Python 3.15                       | Available                             | F45 (3.15.2_p1), G~ (3.15.2)                                                           | 1m ago                      |
| Python 3.16 [7]                   | Not supported                         | G**                                                                                    | 2w ago                      |
| Rust <= 1.98.0                    | Not supported                         |                                                                                        | 3m ago                      |
| Rust 1.98.1 [LTS]                 | Fully supported                       | G (1.98.1)                                                                             | 3m ago                      |
| Rust 1.99.0                       | Not supported                         |                                                                                        | 2m ago                      |
| Rust 1.99.1                       | Available                             | F43 (1.99.1), F44 (1.99.1), G~ (1.99.0), Nunstable (1.99.1)                            | 1m ago                      |
| Rust 1.100.0 [RSC]                | Fully supported                       | F45 (1.100.1)                                                                          | 1w ago                      |
| Rust-9999 (1.102.0-nightly) [LSC] | Limited support                       | G**                                                                                    | Now or 2w ago               |

[D] Current default slots on this overlay.

[1] Only Godot allowed for video game porting into extended LTS distros
(e.g. D12, U22, U24).

[3a] The oldest slot is typically LTS and the newest slot is typically rolling.

[3b] For compilers in general, slots are only supported if a tagged released was
made within 6 months and not EOL for security reasons.  6 months was chosen
primarily to barely meet AI stack support.

Trade-offs for compiler slot retention:

| Slot retention window | Costs                                                                               | Benefits                                                                                        |
| ---                   | ---                                                                                 | ---                                                                                             |
| 6 months (current)    | 1 month remediation deadline not met, rebuilds as slots drop                        | Full machine learning support, performance-critical                                             |
| 3 months              | Only Vulkan supported, rebuilds as slots drop, 1 month remediation deadline not met | Quicker and partial mitigation against accumulated/backlogged miscompilation vulnerabilities    |
| 1 month               | Only Vulkan supported, rebuilds as slots drop, frequent rebuilds                    | 1 month remediation deadline met, security-critical                                             |

The slot retention rule for compilers may change.

The default slot retention window is the fallback choice.  The slot retention
window is adjusted per ebuild to more security-critical if possible for high
risk packages.  Sometimes, it is not possible to get the ideal pairing and a
practical solution is required to complete objectives -- no future build time
issues, systemwide update completion.  For example if a package uses C++17
(LTS), the package that uses LLVM_SLOT and C++ may be forced to use [LTS] for
Rust expecially if the package is a library only or a hybrid package that is
both app and library.

[4] Support is limited for problematic packages without AI assistant that cannot
be updated to use the RSC compiler.

[5] Available but not fully supported because the PYTHON_COMPAT removal of
    affected versions by eager FAFO removal from distro and community overlays.
    This overlay may fork affected packages for AI stack stability.  Forced
    PYTHON_COMPAT bumps (to Python 3.12 or any future minimum version bumps)
    may introduce DoS vulnerabilities (e.g. crash, broken boot/login),
    degraded security (3FA -> 2FA), or incompatibilities.

    DISCLAIMER:  This overlay may delete Python based security-critical
    components without warning associated with eager distro EOL restriction
    and upstream not updating their releases to use the latest CI test images.
    If the package (e.g. Howdy or Python based PAM package) is using a
    D12/U18/U20/U22 CI/CD image or testing with older CI/CD images, this overlay may
    immediately delete the package or dependencies associated with it which
    can cause an init or boot issues.  The developer or contributors may
    choose not to apply patches because it is unpaid free labor to fix any
    issue, stress relief, or an alternative to replace it exists.  It is a
    common practice by the distro overlay to delete ebuilds for EOL packages
    or defunct projects.

[7] Not widely tested with CI/CD.

[8] The oiledmachine-overlay is actively dropping support for 3.10 and older.

[9] This slot is EOL on the distro overlay but not on the oiledmachine-overlay.

[10] Typically the older Python slots are feature complete and have less update
friction.  Recommendations for Python support for Machine Learning (ML) on this
overlay:
- Python 3.12 - For performance-critical, ML (ROCm/CUDA), Blender 4.5, Open WebUI [LLMs], LocalAI [LLMs, AI generated imagery/videos]
- Python 3.13 - For performance-critical, ML (ROCm/CUDA), Blender 5.2/5.3
- Python 3.14 - For performance-critical, ML (ROCm/CUDA)
- Python 3.15 - For security-critical
- Python 3.16 - For developers to fix Python

[11] Freethreading is not supported in this overlay as security mitigation
against race conditions, Time of Check to Time of Use (ToCToU), data
race, deadlock vulnerabilities.

For non C/C++ langages (e.g. Python or JS) the Rust slot rules for version
pinning are as follows:

- Web browsers will use the Live Security-Critical [LSC] Rust compiler.
- Network facing packages will use the Rolling Security-Critical [RSC] Rust compiler.
- Non-network facing packages that are security-critical will use the Rolling Security-Critical [RSC] Rust compiler.
- Balanced or performance-critical will use the [LTS] Rust compiler if able to do so.
- If a package cannot use the [LTS] Rust compiler but requires > 1.98.1, it will use the [RSC] Rust compiler instead.

Packages are pinned to a particular Rust slot for reproducible reasons and to
reduce Rust slot verification code creep.

The May 2026 Rust rules on this overlay for the non C/C++ languages scenario
addresses a security issue possibility (e.g. miscompilation slots from outdated
bootstrap slots causing errors or vulnerabilities which could lead to the worst
case RCE [Remote Code Execution]).

The Nov 2026 Rust rules on this overlay for pinning are to ensure that network
facing and security-critical packages appropriately use the security-critical
Rust compiler slot.  The 1 month policy is to mitigate miscompilation RCE or
memory corruption miscompilation that leads to RCE or other critical
vulnerability possibilities similar to eMudhra intermediate certificate store
compromise where 15 days is the remediation standard for lower scoring critical
severity or lower scoring RCEs.  In comparison, CISA uses 3 or 14 days
remediation deadline for KEV.  The recommendations are to be as close as
possible to the remediation practices during the
[2026 Black October](https://en.wikipedia.org/wiki/Black_October_(information_security))
to reduce the accumulation of miscompilation vulnerabilities.  rust-bin contains
both the Rust side and vendored LLVM/LLD side, so the 1 month policy will reduce
vulnerabilities on both sides.

For C/C++ the Rust slot rules for version pinning are as follows:

| LLVM slot          | Rust slot  | Allowed in network facing? [1] | Allowed to be used in security-critical? [1] | Last update since Nov 2026?   |
| ---                | ---        | ---                            | ---                                          | ---                           |
| 23 (Live)          | 9999 [2]   | Y                              | Y                                            | 2 weeks ago to now            |
| 23 (Rolling)       | 1.99.1     | Y                              | Y                                            | 1 month ago                   |
| 22 (LTS)           | 1.98.1     | N                              | N                                            | 3 months ago                  |

* [1] - Only allowed in these contexts if within 1 month of tagged release.
* [2] - With timestamp verification associated with latest [version](https://github.com/rust-lang/rust/blob/main/src/version)

In this context, the meanings are LTS distros, rolling distros,
and projects that depend on live explicitly.

For Rust live, this slot is limited to the following packages
that test using live explicitly:

- Chromium
- Firefox ESR 153
- Firefox rapid release
- SpiderMonkey 153

The version ranges are matching to avoid multiple LLVM versions loaded issues.

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

Language defaults comparison

| LTS or rolling compiler? | GCC C++ [6][7] | Clang C++ [6][7] | GCC C [6][7] | Clang C [6][7] | GCC         | Clang         | Overlay USE flags [5]                | Distro correspondance   | Hardware acceleration support [8][9]                                    |
| ---                      | ---            | ---              | ---          | ---            | ---         | ---           | ---                                  | ---                     | ----                                                                    |
| LTS                      | gnu++17        | gnu++17          | gnu17        | gnu17          | 14          | 19            | gcc_slot_14_2, llvm_slot_19          | D13                     | SIMD, CUDA 13.4, ROCm 10.2, Vulkan                                      |
| Rolling                  | gnu++17        | gnu++17          | gnu23        | gnu17          | 15          | 21            | gcc_slot_15_3, llvm_slot_21          | F43                     | SIMD, CUDA 13.4, Vulkan                                                 |
| LTS                      | gnu++17        | gnu++17          | gnu23        | gnu17          | 15          | 21            | gcc_slot_15_2, llvm_slot_21          | U26                     | SIMD, CUDA 13.4, ROCm 10.2, Vulkan                                      |
| Rolling                  | gnu++17        | gnu++17          | gnu23        | gnu17          | 15          | 22            | gcc_slot_15_3, llvm_slot_22 [1]      | G [2a]                  | SIMD, CUDA 13.4, ROCm 10.2, Vulkan                                      |
| Rolling                  | gnu++20        | gnu++17          | gnu23        | gnu17          | 16          | 22            | gcc_slot_16_2, llvm_slot_22          | F44, G [2b]             | SIMD, CUDA 13.4, Vulkan                                                 |
| Rolling                  | gnu++20        | gnu++17          | gnu23        | gnu17          | 16          | 23            | gcc_slot_16_2, llvm_slot_23          | F45                     | SIMD, Vulkan                                                            |


* [1] This is the current oiledmachine-overlay's default combo for LTS.
* [2a] The latest stable KEYWORDS for full GPU support (CUDA/ROCm).
* [2b] The latest stable KEYWORDS for any slots, biased in favor of CUDA.
* [3] CUDA GPU acceleration is only available with GCC built packages on this
      overlay for this GCC & Clang compiler combo.  llvm_slot_14 is hypothetical
      and not supported on this overlay.
* [4] Same as HIP-Clang
* [5] The GCC USE flags add the minor version because GCC 9 has multiple
      GLIBCXX_ versions, but the GCC USE flags may later be simplified on major
      update.
* [6] gnu++17 is c++17 with GNU extensions.  gnu17 is C17 with GNU extensions.
* [7] GCC / LLVM.  Users need to avoid mixing the two different editions to
      prevent ODR violations or mismatched signatures.
* [8] Full ROCm support is based on the GCC slot because of prebuilt binaries.
* [9] Examples of typical use or capabilities:
  - SIMD:  Audio/image processing, 3D transforms
  - CUDA:  Machine learning (ML), LLM inference, raytracing in 3D editors or CGI movies, computer vision (CV), academic research
  - ROCm:  Machine learning (ML), LLM interence, cryptocurrency mining
  - Vulkan:  Gaming graphics (e.g. raytracing, particle systems, post-processing, procedural rendering), AI upscaling, video remastering, LLM inference

* This overlay prefers users use one of the LTS combos to avoid issues.
* The default C++ standard can be found at:
  - GCC:    gcc/c-family/c-opts.cc in c_common_init_options()
  - Clang:  clang/lib/Basic/LangStandards.cpp in clang::getDefaultLanguageStandard() for LLVM 15 and newer
            clang/lib/Frontend/CompilerInvocation.cpp in CompilerInvocation::setLangDefaults() for LLVM 14
* A LTS package in this overlay is a package that explicitly states in the build
  files that it is c++17 or C17 or earlier.  A majority of packages in this
  overlay are LTS packages.
* A rolling package in this overlay is a package that explicitly states in the
  build files that it is c++20 or C20 or newer.  Hyprland is an
  example.  The developers of Hyprland have build files that reference a rolling
  distro.  This is partly why the counterpart to LTS is called a rolling
  compiler on this overlay.  A few packages in this overlay require to switch
  to GCC 15 or LLVM 20 or newer are considered rolling packages.
* In this overlay, rolling packages get paired with rolling compilers.  LTS
  packages get paired with LTS compilers.  This is why the gcc_slot_ and
  llvm_slot_ USE flags and corresponding verify steps are provided to
  avoid linker issues and backtracking to miscategorized LTS/rolling packages.
* A package without explicit C or C++ standard will fallback to the compiler
  default mentioned in the C++ standard or C standard columns above.
* The following stable compilers USE flags may be used in c++17 or earlier packages:
  - gcc_slot_14_4 (D13)
  - gcc_slot_15_3 (U26)
  - llvm_slot_22 (D13, U26)
* The following rolling compilers USE flags may be used c++20 or newer packages:
  - gcc_slot_16_2 (F44, F45)
  - llvm_slot_22 (F44)
  - llvm_slot_23 (F45)
* The following live compilers USE flags may be used in web browsers targeting c++20 in Firefox rapid or c++23 in Chromium:
  - llvm_slot_24
* Use only 1 GCC slot per LTS, rolling, live to avoid symbol issues.
* The USE flags provide verification and build consistency.
* The CC/CXX changes resolve an ambiguous choice between selecting a GCC build
  or a Clang build when both sets are used.
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
  typical use cases for using rolling compilers it to take advantage of the
  gimmicks of newer CPUs instruction sets or access to newer microarchitectures
  at the cost of access to faster GPU AI inference or processing.  Rolling
  should not be used in packages where GPU is an option.
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
  which lowers security.
* GCC is preferred but Clang is recommended as the fallback compiler.
* Clang 18, 19 are alternative LTS compilers on this overlay, but the
  corresponding libc++ 18 or 19 used as the alternative C++ standard library
  is still feature incomplete and not recommended as the systemwide default.
* libstdc++ is the assumed default C++ standard library in this overlay.
  The alternative libc++ as a systemwide default has not been tested for
  these ebuilds.
* =dev-lang/rust-bin-9999 is recommended for SSP, sanitizers, and as default to
  be used in security-critical packages.
* rust-bin older supported stable (1.74.0, 1.75.0) and rust-bin latest stable
  (1.86.0) are recommended as fallbacks for non security-critical packages.

Pairing rules and support

| Pairing                                                              | Allowed? | Reason                                                                                                                                                                          | Examples                                       |
| ---                                                                  | ---      | ---                                                                                                                                                                             | ---                                            |
| Lib A (C++17, GCC13) + Lib B (C++17, GCC13) + App (C++17, GCC13)     | Y        | All the same C++ version and GCC slot, the most consistent and reliable build                                                                                                   | Firefox ESR 140, enterprise LTS packages       |
| Lib A (C++17, GCC13) + Lib B (C++20, GCC13) + App (C++23, LLVM23)    | Y        | The app has highest C++ version AND no library GCC/LLVM slot is greater than it                                                                                                 | Chromium, Hyprland, rolling FAFO packages      |
| Lib A (C++26, GCC16) depends on Lib B (C++17, GCC13)                 | Y        | The depender library A meets the >= C++ version of the dependee B library.  A rolling lib (C++20 or later) can link to LTS lib(s), but typically not in the opposite direction. | Hyprland libraries (e.g. hyprgraphics)         |
| Lib A (C++17, GCC13) depends on Lib B (C++17, GCC13)                 | Y        | All the same C++ version and same GCC slot                                                                                                                                      | gtkmm, qtbase:6                                |
| Lib A (C++17, GCC13) depends on Lib B (C++17, GCC14)                 | N        | All the same C++ version and only 1 GCC slot allowed for LTS (C++17 or earlier)                                                                                                 |                                                |
| Lib A (C++17, GCC13) depends on Lib B (C++20, GCC13)                 | N        | The dependee B library C++ version typically cannot exceed the depender A library C++ version                                                                                   |                                                |
| Lib A (C++14, GCC13) depends on Lib B (C++17, GCC13)                 | Y        | The exception, it is allowed if using the same GCC compiler slot.  LTS lib with LTS lib is allowed.                                                                             | Boost links to ICU                             |

* Security note:  FAFO or breaking the rules may cause undefined behavior (UB) or memory corruption.


| Platform                             | Ebuild level of support                 | Distro or CI/CD image correspondence                                    |
| ---                                  | ---                                     | ---                                                                     |
| CUDA <=13.3                          | Not supported                           | D12, D13, F44, U22, U24, U26                                            |
| CUDA 13.4                            | Available                               | D12, D13, F44, G~, U22, U24, U26                                        |
| Electron (amd64)                     | Fully supported                         |                                                                         |
| Electron (arm64)                     | Available (WIP)                         |                                                                         |
| Electron (armv7)                     | Not supported                           |                                                                         |
| Electron (x86)                       | Not supported                           |                                                                         |
| gRPC 1.30.2 [3]                      | Fully supported                         | U22 (1.30.2)                                                            |
| gRPC 1.48.4                          | Not supported                           | F43 (1.48.4), F44 (1.48.4), F45 (1.48.4)                                |
| gRPC 1.51.3 [3]                      | Fully supported                         | D12 (1.51.1), D13 (1.51.1), U24 (1.51.1), U26 (1.51.1)                  |
| gRPC 1.71.2 [3]                      | Fully supported                         |                                                                         |
| gRPC >= 1.75.1 [3]                   | Fully supported                         | Nunstable (1.81.4)                                                      |
| GTK 2 [4]                            | Not Supported                           |                                                                         |
| GTK 3 live                           | Fully supported                         |                                                                         |
| GTK 4 live                           | Fully supported                         |                                                                         |
| gtkmm 2                              | Not supported                           |                                                                         |
| gtkmm 3                              | Not supported                           |                                                                         |
| gtkmm 4                              | Fully supported                         |                                                                         |
| LocalAI (llama.cpp with CPU)         | Fully supported                         |                                                                         |
| LocalAI (llama.cpp with ROCm 7.0)    | WIP                                     |                                                                         |
| LocalAI (llama.cpp with CUDA 12.4)   | Not supported                           |                                                                         |
| LocalAI (llama.cpp with Vulkan)      | Fully supported                         |                                                                         |
| OpenGL <= 4.6                        | Fully supported                         |                                                                         |
| OpenCL <= 2.0                        | Fully supported                         |                                                                         |
| Ollama live (CPU)                    | Fully supported                         |                                                                         |
| Ollama live (ROCm)                   | Not supported                           |                                                                         |
| Ollama live (CUDA)                   | Available                               |                                                                         |
| Ollama live (Vulkan)                 | Fully supported                         |                                                                         |
| GCC OpenMP (CPU)                     | Fully supported                         |                                                                         |
| LLVM OpenMP (CPU)                    | Fully supported                         |                                                                         |
| LLVM OpenMP offload (CUDA)           | Available                               |                                                                         |
| LLVM OpenMP offload (ROCm)           | Not Supported                           |                                                                         |
| ROCm OpenMP offload [2]              | WIP                                     |                                                                         |
| DPC++ OpenMP offload                 | Not Supported                           |                                                                         |
| OpenRC                               | Fully supported                         |                                                                         |
| Protobuf-cpp 3 [3]                   | Fully supported                         | D12 (3.21.12), D13 (3.21.12), F43 (3.19.6), F44 (3.19.6), U24 (3.21.12), U26 (3.21.12) |
| Protobuf-cpp 5 [3]                   | Fully supported                         |                                                                         |
| Protobuf-cpp 6 [3]                   | Fully supported                         | F45 (6.33.5)                                                            |
| Protobuf-cpp 7                       | Not supported                           | Nunstable (7.36.2)                                                      |
| PyTorch <= 2.13                      | Not supported                           |                                                                         |
| PyTorch 2.13 (CPU)                   | WIP                                     |                                                                         |
| PyTorch 2.13 (CUDA 12.6, 12.8, 13.x) | WIP                                     |                                                                         |
| PyTorch 2.13 (ROCm 6.4)              | WIP                                     |                                                                         |
| Qt 5.x [4][5]                        | Not supported, removing support         |                                                                         |
| Qt 6.x live                          | Fully supported                         |                                                                         |
| ROCm <= 7.14                         | Not supported                           | D12, D13, U22, U24, U26                                                 |
| ROCm 10.2                            | In planning / WIP                       | D12, D13, U22, U24, U26                                                 |
| SYCL                                 | Not supported                           |                                                                         |
| systemd                              | Partially supported                     |                                                                         |
| Tauri 1.x                            | Not supported                           |                                                                         |
| Tauri 2.x                            | Supported                               |                                                                         |
| TensorFlow 2.17 (CPU)                | WIP                                     |                                                                         |
| TensorFlow 2.17 (CUDA 12.3)          | Not supported                           |                                                                         |
| TensorFlow 2.20 (CPU)                | WIP                                     |                                                                         |
| TensorFlow 2.20 (CUDA 12.5)          | Not supported                           |                                                                         |
| TensorFlow 2.20 (ROCm 6.4)           | WIP                                     |                                                                         |
| Vulkan                               | Fully supported                         |                                                                         |
| Wayland                              | Fully supported                         |                                                                         |
| X                                    | Fully supported                         |                                                                         |

* [2] Via llvm-roc-libomp
* [3] Multislotted on this overlay to allow LTS and rolling packages to
      coexist without resorting to containerization or separate LTS and rolling
      partitions.
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
* [6] Requires local repo/ebuild or community overlay
* Due to the lack of GPU access or GPU dev testers, the requirements are the
  exact major.minor version requirements for GPU, Machine Learning (ML), and
  Large Language Model (LLM) ebuild packages in this overlay for increased
  chances of reproducibility.

Gentoo Prefix is not supported and deprecated on this overlay.

The support status depends on the ebuild contributors ability to test, patch,
and verify.

USE flags support

| USE flag  | Ebuild level of support |
| ---       | ---                     |
| split-usr | Fully supported [1]     |

[1] To test if you are using split-usr do `ls -id /bin /usr/bin` if the id is
not the same it is split.  Usually the AI will tell you to give up because the
AI, the Wiki, and the devs who are pro systemd are all compromised with
enterprise Linux marketing slop.  The distro does provide split-usr stage 3
images in the "Stages (advanced)" section of their downloads page.

Unsupported or rejected projects/ebuilds

| Topic                                                                                    | Overlay response                                                | Reason                                                                                                                                             |
| ---                                                                                      | ---                                                             | ---                                                                                                                                                |
| Security code audit refusal (human, AI, algorithmic code scanner)                        | Hard mask or ebuild removal                                     | Possibly threat actor involvement/evasion or contain a state level 0-day (e.g. [Vault 7](https://en.wikipedia.org/wiki/Vault_7#Commentary) or equivalent) or criminal malware                          |
| AI [security audit] refusal with no commit history of security fixes in memory unsafe language with at risk use cases | Hard mask or ebuild removal        | Unaudited, may contain at worst malicious code or a state level 0-day (e.g. Vault 7 or equivalent)                                                 |
| Projects with commit messages/code not in English                                        | Ebuild removal                                                  | Difficult to security audit or fix                                                                                                                 |
| Projects without commit messages                                                         | Ebuild removal                                                  | Difficult to security audit, determine, or verify if the release is secure independently and if effort is made by upstream to secure their product |
| Projects with weak/opposite/dodging remediation                                          | Package hard mask, USE flag mask, security warnings, or removal | High cost/risk if exploited, same inappropriate security policy in different parts of the code                                                     |
| Projects associated with the military industrial complex                                 | Security warnings or removal                                    | May contain state level threat actor(s) or at worst spyware/malware/backdoor or used as a decentralized attack primitive                           |
| Remote attestation (e.g. anti-cheat support)                                             | Nothing                                                         | The distro doesn't have an attestation server or is not registered for anti-cheat.                                                                 |

Overlay compatibility with open source projects

| Abbreviations | Meaning          | Supported open source projects? [1][2]                    |
| ---           | ---              | ---                                                       |
| A             | Arch Linux       | Yes (e.g. projects on GitHub)                             |
| Aedge         | Alpine edge      | Limited (e.g. WIP Chromium based musl)                    |
| D12           | Debian 12        | No                                                        |
| D13           | Debian 13        | Yes (e.g. projects on GitHub)                             |
| Dsid          | Debian Sid       | Limited (e.g. ca-certificates, WIP Chromium based ppc64)  |
| F43           | Fedora 43        | Limited but deprecated                                    |
| F44           | Fedora 44        | Yes (e.g. projects on freedesktop.org, GitLab)            |
| F45           | Fedora 45        | Yes (e.g. projects on freedesktop.org, GitLab)            |
| Frawhide      | Fedora rawhide   | Available but no projects                                 |
| G             | Gentoo stable    | Yes (e.g. Portage, Genkernel)                             |
| G~            | Gentoo unstable  | Limited (e.g. Genkernel)                                  |
| G**           | Gentoo live      | Limited                                                   |
| N26           | NixOS stable     | Available but no projects                                 |
| Nunstable     | NixOS unstable   | Limited (e.g. Hyprland, scx)                              |
| S15           | Slackware 15     | Nope, no projects                                         |
| U24           | Ubuntu 24 LTS    | No                                                        |
| U26           | Ubuntu 26 LTS    | Yes (e.g. projects on GitHub)                             |
| Utenacious    | Ubuntu tenacious | Available but no projects                                 |

* [1] Compatibility is focused on C/C++, and fully compatible with Rust and Go,
but limited compatibility for Python and other languages.
* [2] Mostly based on CI/CD or Dockerfile images, CI/CD logs or configuration, or version control branches
