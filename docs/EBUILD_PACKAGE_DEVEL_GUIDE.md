# Overlay ebuild style guidelines and quality assurance (QA) for this overlay

Ebuild coding styles

| Subject                               | Answer                                             |
| ---                                   | ---                                                |
| Distro style supported                | Y, for ebuilds originally from the distro overlay  |
| oiledmachine-overlay style supported  | Y                                                  |

Distro ebuild example

```bash
# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://codeberg.org/gentoo/gentoo.git"
	inherit git-r3
fi

DESCRIPTION="An example of Larry the Cow's package"
HOMEPAGE="https://www.gentoo.org"
LICENSE="GPL-2+"
IUSE="cowpen zlib"
RDEPEND="
	sys-libs/glibc
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gcc
"
PATCHES=(
	"${FILESDIR}"/${PN}-1.0.0-hardcoded-fixes.patch
)

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_prepare() {
	default
	if zlib; then
		# This is a comment.
		eapply "${FILESDIR}"/${PN}-1.0.0-hardcoded-fixes.patch"
	fi
}

pkg_postinst() {
	ewarn "The data center stole Larry the Cow's water!"
	if ! use cowpen; then
		ewarn
		ewarn "Security Notice"
		ewarn
		ewarn "Larry the Cow has escaped!"
		ewarn
	fi
}

```

oiledmachine-overlay style example

```bash
# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/orsonteodoro/oiledmachine-overlay.git"
	FALLBACK_COMMIT="8bc1b6e21ab588a3bc755a8d8dde1dd9c3d08a1b"
	IUSE+=" fallback-commit"
	inherit git-r3
else
	S="${WORKDIR}/${P}"
fi

DESCRIPTION="An example of Larry the Cow's package"
HOMEPAGE="https://www.gentoo.org"
LICENSE="GPL-2+"
IUSE="cowpen zlib"
RDEPEND="
	sys-libs/glibc
	zlib? (
		sys-libs/zlib
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	sys-devel/gcc
"
PATCHES=(
	"${FILESDIR}/${PN}-1.0.0-hardcoded-fixes.patch"
)

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_prepare() {
	default
	if zlib ; then
	# This is a comment.
		eapply "${FILESDIR}/${PN}-1.0.0-hardcoded-fixes.patch"
	fi
}

pkg_postinst() {
ewarn "The data center stole Larry The Cows water!"
	if ! use cowpen ; then
ewarn
ewarn "Security Notice"
ewarn
ewarn "Larry the Cow has escaped!"
ewarn
	fi
}

```

C defaults

| Subject                 | Answer                                             |
| ---                     | ---                                                |
| Default C               | -std=gnu17                                         |
| Acceptable LTS C        | -std=gnu17                                         |
| Acceptable rolling C    | -std=gnu20, -std=gnu23                             |
| Default C compiler      | GCC                                                |
| Default C linker        | BFD                                                |
| Autotools vs CMake      | CMake                                              |
| CMake vs Meson          | Any                                                |
| CMake vs Bazel          | CMake                                              |
| Ninja vs Make           | Ninja                                              |

C++ defaults

| Subject                     | Answer                                                                |
| ---                         | ---                                                                   |
| Default C++                 | -std=gnu++17                                                          |
| Acceptable rolling C++      | -std=gnu++20, -std=gnu++23, -std=c++20, -std=c++23                    |
| Acceptable LTS C++          | -std=gnu++17, -std=gnu++11, -std=c++17, -std=c++11                    |
| Acceptable LTS linking      | LTS app with only LTS libs; LTS lib with LTS lib                      |
| Acceptable rolling linking  | Rolling app with LTS lib or rolling lib; rolling lib with rolling lib |
| Default C++ compiler        | GCC                                                                   |
| Default C++ linker          | BFD                                                                   |
| Autotools vs CMake          | CMake                                                                 |
| CMake vs Meson              | Any                                                                   |
| CMake vs Bazel              | CMake                                                                 |
| Ninja vs Make               | Ninja                                                                 |

Python defaults

| Subject                                    | Answer                                                                                                |
| ---                                        | ---                                                                                                   |
| Default Python                             | python3_12                                                                                            |
| Acceptable rolling Python slots            | python3_14                                                                                            |
| Acceptable LTS Python slots                | python3_{11..13}                                                                                      |
| Acceptable multislot Python                | python3_{11..14}                                                                                      |
| Acceptable single slot Python              | python3_{11..14}                                                                                      |
| Acceptable slot paring                     | The Python app slot must pair with same Python slot for dependencies down to the leaf packages        |
| Are binary packages allowed?               | Allowed with restrictions but only if that is the only option or difficult to package                 |
| Default Python interpreter                 | CPython                                                                                               |
| Python slot precedence                     | App's setup.py, CI's .github/*.yaml, Dockerfile, lib's setup.py, CI image default Python slot         |
| pypy3_11 support                           | Y if specified in setup.py                                                                            |
| Must use slotted Cython                    | Y, forcing untested newer versions may result in undefined behavior or miscompilation vulnerabilities |
| Hacks are allowed? (using Cython over Zig) | If the package uses security-critical assumptions or processes untrusted data, it is disallowed.      |

Rust defaults

| Subject                                | Answer                                                     |
| ---                                    | ---                                                        |
| Default LTS Rust                       | Rust 1.91.1                                                |
| Default rolling Rust                   | Rust 1.95.0                                                |
| What is a rolling or LTS Rust package? | Determined by most recent Rust slot needed for Cargo.lock. |
|                                        | LTS if <= 1.91.1                                           |
|                                        | Rolling if > 1.91.1                                        |
| Acceptable LTS Rust for non C++        | Rust 1.91.1                                                |
| Acceptable rolling Rust for non C++    | Rust 1.95.0                                                |
| Acceptable Rust for LLVM 22 for C++    | Rust 1.95.0                                                |
| Acceptable Rust for LLVM 21 for C++    | Rust 1.94.1                                                |
| Acceptable Rust for LLVM 20 for C++    | Rust 1.90.0                                                |
| Acceptable Rust for LLVM 19 for C++    | Rust 1.85.1                                                |
| Acceptable Rust for LLVM 18 for C++    | Rust 1.81.0                                                |
| Acceptable Rust for LLVM 17 for C++    | Rust 1.77.2                                                |
| Use 1 pinned Rust slot                 | Y                                                          |
| A Cargo.lock should be generated       | Y                                                          |
| Offline install                        | Y                                                          |

JS default

| Subject                                 | Answer                                                        |
| ---                                     | ---                                                           |
| Default slot                            | Use the one that is associated with that release              |
| Fallback slot:  .github/*.yaml          | See .yaml file for Node version, the tested slot is preferred |
| Fallback slot:  Dockerfile              | Use the same major version for Node                           |
| Fallback slot:  .nvmrc                  | Use the same major version for Node                           |
| Fallback slot:  @types/node in lockfile | Use the same major version for Node                           |
| Fallback slot:  Unknown default slot    | Use the oldest upstream supported LTS (20)                    |
| npm vs Yarn vs pnpm                     | Use the one that is the default by the project                |
| Bun vs Node                             | Force Node but if no hard dependence on Bun.  Bun requires SSE4.2 but Node can run on older hardware. |
| Use 1 pinned Node slot                  | Y                                                             |
| Lockfile(s) should be generated         | Y                                                             |
| Offline install                         | Y cached in distfiles                                         |

Feature QA

| Subject                                                          | Answer                                                                                                                      |
| ---                                                              | ---                                                                                                                         |
| USE defaults for actively patented non-free codecs               | OFF                                                                                                                         |
| USE defaults for security risk features                          | Hard disable if catastrophic, OFF if harm or loss implied                                                                   |
| USE defaults for LTS using rolling dependency                    | ON if security-critical feature (e.g. sandbox) in app package bumped to rolling, OFF for LTS libs linking to rolling libs   |
| USE defaults fallback                                            | Should match upstream with exceptions                                                                                       |
| Default bloat spectrum if no defaults listed                     | Minimal install with optional USE flags                                                                                     |
| Wayland or X11                                                   | Both should be supported if able to run on either                                                                           |
| Hard USE appropriateness                                         | Only use if catastropic or last option, do not abuse it                                                                     |
| Custom USE flags or custom config options patches allowed?       | Y                                                                                                                           |
| Forcing defaults is okay or no effort for adding USE flags okay? | The quality is frowned upon but is acceptable sometimes for small packages but increases bloat, increases build time, increases the attack surface, or possibly hard codes paths.  Users should be able to consent to the attack surface risk but not forced unconsensually to have the risk. |

Slotting QA

| Subject                                                         | Answer                                                                        |
| ---                                                             | ---                                                                           |
| Compilers and interpreters must be slotted                      | Y                                                                             |
| Poison pilled versioning must be slotted                        | Y                                                                             |
| LTS must be slotted                                             | Y                                                                             |
| `:<SLOT>` needs slot operator :=                                | Y                                                                             |
| C++ only header packages needs slot operator :=                 | Y                                                                             |
| Any variation of ${LIBCXX_USEDEP} or ${LIBSTDCXX_USEDEP} needs slot operator :=  | Y                                                            |
| Explicit `<category>/<name>[static-libs]` needs slot operator :=  | Y                                                                           |

Version QA

| Subject                                                  | Answer                                                                        |
| ---                                                      | ---                                                                           |
| Live ebuilds policy                                      | As needed, delete if unused                                                   |
| Snapshots vs live                                        | Snapshots or live ebuild with fallback commit                                 |
| Tagged vs untagged                                       | Tagged                                                                        |
| *DEPENDs version sourcing precedence                     | Build files, CI files, Dockerfile, CI distro versions                         |
| *DEPENDs version writing preference-precedence           | Slot-comparison, slot, comparison, none                                       |
| Latest vs min tiebreaker for writing *DEPENDs            | It's situational.                                                             |
|                                                          | For unslotted if different versions encountered, use latest versions if security-critical packages; otherwise, use the oldest version. |
|                                                          | For C/C++ slotted when LTS and rolling are involved, add all slots >= minimum slot for compilers, and either 1 slot or n conditional slots for libraries. |
|                                                          | For JS, pin only one slot for compiler and build system, and use the C/C++ rules as fallback. |
|                                                          | For Python, slots are based on as needed and/or allowed by setup.py.          |
| All used live dependences timestamps should be verified for recentness | Y (WIP, TODO:  add new eclass) for security reasons             |
| The distro IDs (e.g. A3.23, D12, D13, G23, N25, U22, U24, F44) should be documented? | Y for *DEPENDs requirements, proper LTS or rolling compiler alignment, release pruning |

Security QA

| Subject                                                       | Answer                                                                                                                                            |
| ---                                                           | ---                                                                                                                                               |
| Untrusted meaning                                             | Processes untrusted data                                                                                                                          |
| Trusted meaning                                               | Never trust, always verify                                                                                                                        |
| Untrusted packages example                                    | Network packages, codec packages, sound/image processing, parsers, web packages                                                                   |
| Critically secure examples                                    | Memory allocators, password managers, web browsers                                                                                                |
| Low level vulnerabilities monitored                           | Double free, deadlock, format string, heap overflow, integer overflow, memory leak, miscompilation, null pointer dereference, ROP gadgets, speculative execution, stack overflow, uninitialized memory, use after free, use after return, type confusion |
| High level vulnerabilities monitored                          | Container/sandbox escapes, inappropriate configuration, inappropriate file permissions, prototype pollution, injection, path traversal, ToCToU, unsanitized input, unclassified/unseen, zero-click, zero-day |
| Daemons must run as limited user/group                        | Y                                                                                                                                                 |
| Hardened by default                                           | Y                                                                                                                                                 |
| Required Clang CFI                                            | For web browsers only (planned)                                                                                                                   |
| SSP-strong required                                           | Y for untrusted data                                                                                                                              |
| Default SSP level                                             | -fstack-protector-strong                                                                                                                          |
| Default _FORTIFY_SOURCE level                                 | 3                                                                                                                                                 |
| Default linker flags                                          | Full Relro                                                                                                                                        |
| Ciphersuite default                                           | Post quantum era first and default ON, followed by legacy                                                                                         | 
| Default asymmetric                                            | Post-quantum lattice/hash first (ML-KEM, ML-DSA), followed by legacy elliptical (RSA, ECDH, ECDSA)                                                |
| Default symmetric block                                       | Post-quantum AES-256, followed by legacy AES-128                                                                                                  |
| Default symmetric stream                                      | Post-quantum AES-256 (GCM/CTR); followed by legacy AES-CTR (desktop/server)                                                                       |
| Acceptable symmetric stream                                   | Post-quantum AES-256 (GCM/CTR), Chacha20 (256-bit); followed by legacy AES-CTR (desktop/server), Chacha20 (256-bit, mobile)                       |
| Default hash                                                  | Post-quantum SHA-256, followed by legacy SHA-256                                                                                                  |
| Default KDF                                                   | Post-quantum Argon2id, followed by legacy PBKDF2                                                                                                  |
| Default CSRNG                                                 | Post-quantum PQC (AES-256, SHA-3) or QRNG; followed by legacy DRNG (CPU Jitter, HW ocsillator, AES-CTR, SHA-256)                                  |
| Q-Day estimated arrival                                       | Year 2029 (3-4 years from now)                                                                                                                    |
| www-apps require permissions sanitization                     | Y                                                                                                                                                 |
| Default security-critical optimization level                  | -O2                                                                                                                                               |
| Appropriate security-critical optimization level              | -O1 to -O2                                                                                                                                        |
| Fallback default optimization level                           | -O0 (unset) but can be overwritten by user typically -O2                                                                                          |
| Untrusted data require {c,rust}flags-hardened                 | Y                                                                                                                                                 |
| Security-critical packages require {c,rust}flags-hardened     | Y                                                                                                                                                 |
| Keys/passwords require Retpoline with {c,rust}flags-hardened  | Y                                                                                                                                                 |
| PII require Retpoline with {c,rust}flags-hardened             | Y (Secrets may flow through the same data paths and packages)                                                                                     |
| Lockfiles should be security scanned and transparent          | Y                                                                                                                                                 |
| Feature abuse (e.g. an AI agent that can make malware)        | The feature must be disabled or made optional instead of unconditional opt-in                                                                     |
| Container packages allowed?                                   | Y                                                                                                                                                 |
| Existing package may be replaced with containerized ebuild?   | N unless community approves                                                                                                                       |
| User inside container                                         | Must be a limited user if daemonized, cannot use pre-existing UID of real users                                                                   |
| Telemetry                                                     | Default off, default opt-out                                                                                                                      |
| Data breach detection support (password check remotely)       | Default off, default opt-out, patching may be required to optionalize                                                                             |
| Binary packages                                               | Allowed with restrictions that only if it is either the only option, source package/maintenance issue, or heavy compilation cost                  |
| Ebuild EOL pruning                                            | If the older versions are necessary for bootstrapping, it should not be deleted.  Otherwise, you're stuck with a compromised trojanized prebuilt. |
| Hacks are allowed? (using a degraded compiler, using Cython over Zig) | If the package uses security-critical assumptions or processes untrusted data, it is disallowed.                                          |

Userspace mitigation comparison

| Flag                                | Mitigated                                                                                          | Distro(s) | oiledmachine-overlay |
| ---                                 | ---                                                                                                | ---       | ---                  | 
| -C overflow-checks=on (Rust)        | Integer overflow/underflow, zero-click attack, production                                          | N         | Y                    |
| -C target-feature=+retpoline (Rust) | Speculative execution, information disclosure                                                      | N         | Y                    |
| -fno-delete-null-pointer-checks     | Undefined behavior, information-disclosure, code execution                                         | N         | Y                    |
| -fstack-protector-strong            | Stack overflow                                                                                     | Y         | Y                    |
| -fstack-clash-protection            | Stack clash attack, privilege escalation (unpriv to priv)                                          | Y         | Y                    |
| -fstrict-flex-arrays=3              | Heap overflow                                                                                      | N         | Y                    |
| -ftrivial-auto-var-init=zero        | Uninitalized memory, information disclosure                                                        | N         | Y                    |
| -fwrapv                             | Undefined behavior, integer overflow, buffer overflow, out-of-bounds access, privilege escalation  | N         | Y                    |
| -fzero-call-used-regs=all           | ROP gadgets, information disclosure, speculative execution side-channel                            | N         | Y                    |
| -mfunction-return=thunk (GCC)       | Speculative execution (RSB), information disclosure                                                | N         | Y                    |
| -mharden-sls=all                    | Speculative execution (SLS), information disclosure                                                | N         | Y                    |
| -mindirect-branch=thunk (GCC)       | Speculative execution (BTB), information disclosure                                                | N         | Y                    |
| -mretpoline (Clang)                 | Speculative execution, information disclosure                                                      | N         | Y                    |
| -Wl,-z,relro,-z,now (Full Relro)    | Data tampering, code execution                                                                     | Y         | Y                    |
| _FORTIFY_SOURCE=3                   | Stack overflow (weak), heap overflow (strong), out-of-bounds access (weak)                         | Y         | Y                    |

Robustness QA

| Subject                                                  | Answer                                                                        |
| ---                                                      | ---                                                                           |
| The package must work after being merged                 | Y                                                                             |
| If ebuilds do not work, how about KEYWORDS?              | Commented out                                                                 |
| Minimum uptime (kernel, during testing)                  | 60 days                                                                       |
| Minimum uptime (kernel, during production)               | 30 days                                                                       |
| Number of expected/actual crashes in 30 days             | 0                                                                             |
| Unfinished features?                                     | Disable USE flag, disable configuration, or disable code                      |
| Hard coded paths?                                        | Allowed if no compatibility, no multilib, no slot issue                       |

Performance QA

| Subject                                                  | Answer                                                                        |
| ---                                                      | ---                                                                           |
| Minimum FPS                                              | 25 FPS (Motion picture FPS)                                                   |
| Minimum uptime (kernel, during testing)                  | 60 days                                                                       |
| Minimum uptime (kernel, during production)               | 30 days                                                                       |
| Maximum ebuild completion time                           | 36 hours                                                                      |
| Runtime thrashing                                        | Disallowed                                                                    |
| Build time severe thrashing                              | Only allowed for web browser or AI/ML packages                                |
| Maximum install + merge time allowed                     | 1 hour                                                                        |

LICENCE variable QA

| Subject                                                                                               | Answer                                                 |
| ---                                                                                                   | ---                                                    |
| AI models require licenses and acceptable use AI ethics disclosure                                    | Y                                                      |
| Telemetry usage require privacy policy and data retention disclosure                                  | Y                                                      |
| Services require terms of use disclosure                                                              | Y                                                      |
| Patent licenses must be disclosed                                                                     | Y                                                      |
| The `custom` placeholder is allowed                                                                   | Y                                                      |
| Copyright notices must be saved (with lcnr or full source install)                                    | Y                                                      |
| Actively patented non-free codecs require `patent_status_nonfree` USE flag and free alternative(s) if possible | Y                                                      |
| Full disclosure                                                                                       | Y if possible                                          |
| License identifier precedence                                                                         | Distro, SPDX, license name, package name, link, custom |

AI disclosure

| Subject                                                                                               | Answer                           |
| ---                                                                                                   | ---                              |
| Your use of AI code generation must be disclosed                                                      | Y                                |
| Your use of AI synthetic data must be disclosed                                                       | Y                                |
| Your use of AI inference must be disclosed                                                            | Y                                |
| Your use of AI in patches or assets must be disclosed                                                 | Y                                |
| The oiledmachine-overlay accepts AI submissions                                                       | Y                                |
| The distro overlay stance of AI submissions on their servers                                          | Banned                           |
