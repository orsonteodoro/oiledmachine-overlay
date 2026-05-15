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
	if [[ ${PV} == *9999* ]] ; then
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_prepare() {
	if zlib ; then
		# This is a comment.
		eapply "${FILESDIR}"/${PN}-1.0.0-fixes.patch
	fi
}

pkg_postinst() {
	ewarn "The datacenter stole Larry the Cow's water!"
	if ! use cowpen ; then
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
	if zlib ; then
	# This is a comment.
		eapply "${FILESDIR}/${PN}-1.0.0-fixes.patch"
	fi
}

pkg_postinst() {
ewarn "The datacenter stole Larry The Cows water!"
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

C++ defaults

| Subject                     | Answer                                             |
| ---                         | ---                                                |
| Default C++                 | -std=gnu++17                                       |
| Acceptable rolling C++      | -std=gnu++20, -std=gnu++23                         |
| Acceptable LTS C++          | -std=gnu++17, -std=gnu++11, -std=c++17, -std=c++11 |
| Acceptable LTS linking      | LTS app with only LTS libs                         |
| Acceptable rolling linking  | Rolling app with LTS lib or rolling lib            |

Python defaults

| Subject                          | Answer                                                               |
| ---                              | ---                                                                  |
| Default Python                   | python3_12                                                           |
| Acceptable rolling Python slots  | python3_14                                                           |
| Acceptable LTS Python slots      | python3_{11..13}                                                     |
| Acceptable multislot Python      | python3_{11..14}                                                     |
| Acceptable single slot Python    | python3_{11..14}                                                     |
| Acceptable slot paring           | The Python app slot must pair with same Python slot for dependencies |
| Are binary packages allowed?     | Y but only if that is the only option                                |

Rust defaults

| Subject                                | Answer                                                    |
| ---                                    | ---                                                       |
| Default LTS Rust                       | Rust 1.91.1                                               |
| Default rolling Rust                   | Rust 1.95.0                                               |
| What is a rolling or LTS Rust package? | Determined by most recent Rust slot needed for Cargo.lock |
| Acceptable LTS Rust for non C++        | Rust 1.91.1                                               |
| Acceptable rolling Rust for non C++    | Rust 1.95.0                                               |
| Acceptable Rust for LLVM 22 for C++    | Rust 1.95.0                                               |
| Acceptable Rust for LLVM 21 for C++    | Rust 1.94.1                                               |
| Acceptable Rust for LLVM 20 for C++    | Rust 1.90.0                                               |
| Acceptable Rust for LLVM 19 for C++    | Rust 1.85.1                                               |
| Acceptable Rust for LLVM 18 for C++    | Rust 1.81.0                                               |
| Acceptable Rust for LLVM 17 for C++    | Rust 1.77.2                                               |

Feature QA

| Subject                                                       | Answer                                                                                                                      |
| ---                                                           | ---                                                                                                                         |
| Default USE flags enablement                                  | Should match upstream with exceptions                                                                                       |
| Default bloat spectrum if no defaults listed                  | Minimal install with optional USE flags                                                                                     |

Security QA

| Subject                                                       | Answer                                                                                                                      |
| ---                                                           | ---                                                                                                                         |
| Untrusted meaning                                             | Processes untrusted data                                                                                                    |
| Trusted meaning                                               | Never trust, always verify                                                                                                  |
| Untrusted packages example                                    | Network packages, codec packages, sound/image processing, parsers, web packages                                             |
| Critically secure examples                                    | Memory allocators, password managers, web browsers                                                                          |
| Low level vulnerabilities                                     | Use-after-free, stack overflow, heap overflow, integer overflow                                                             |
| High level vulnerabilities                                    | Inappropriate configuration, access control bypass, container/sandbox escapes                                               |
| Untrusted packages require compiler hardening                 | Y                                                                                                                           |
| Daemons must run as limited user/group                        | Y                                                                                                                           |
| Hardened by default                                           | Y                                                                                                                           |
| Required Clang CFI                                            | For web browsers only (planned)                                                                                             |
| SSP-strong required                                           | Y, for untrusted data                                                                                                       |
| Default SSP level                                             | -fstack-protector-strong                                                                                                    |
| Default _FORTIFY_SOURCE level                                 | 3                                                                                                                           |
| Default linker flags                                          | Full Relro                                                                                                                  |
| Ciphersuite default                                           | Post quantum era first and default ON, followed by legacy                                                                   | 
| Default asymmetric                                            | Post-quantum lattice/hash first (ML-KEM, ML-DSA), followed by legacy elliptical (RSA, ECDH, ECDSA)                          |
| Default symmetric block                                       | Post-quantum AES-256, followed by legacy AES-128                                                                            |
| Default symmetric stream                                      | Post-quantum AES-256 (GCM/CTR); followed by legacy AES-CTR (desktop/server)                                                 |
| Acceptable symmetric stream                                   | Post-quantum AES-256 (GCM/CTR), Chacha20 (256-bit); followed by legacy AES-CTR (desktop/server), Chacha20 (256-bit, mobile) |
| Default hash                                                  | Post-quantum SHA-256, followed by legacy SHA-256                                                                            |
| Default KDF                                                   | Post-quantum Argon2id, followed by legacy PBKDF2                                                                            |
| Default CSRNG                                                 | Post-quantum PQC (AES-256, SHA-3) or QRNG; followed by legacy DRNG (CPU Jitter, HW ocsillator, AES-CTR, SHA-256)            |
| Q-Day estimate                                                | Year 2029 (3-4 years from now)                                                                                              |
| www-apps require permissions sanitization                     | Y                                                                                                                           |
| Default security-critical optimization level                  | -O2                                                                                                                         |
| Appropriate security-critical optimization level              | -O1 to -O2                                                                                                                  |
| Fallback default optimization level                           | -O0 (unset) but can be overwritten by user typically -O2                                                                    |
| Untrusted data require {c,rust}flags-hardened                 | Y                                                                                                                           |
| Security-critical packages require {c,rust}flags-hardened     | Y                                                                                                                           |
| Keys/passwords require Retpoline with {c,rust}flags-hardened  | Y                                                                                                                           |
| PII require Retpoline with {c,rust}flags-hardened             | Y (Secrets may flow through the same data paths and packages)                                                               |
| Lockfiles should be security scanned and transparent          | Y                                                                                                                           |
| Feature abuse (e.g. an AI agent that can make malware)        | The feature must be disabled or made optional instead of unconditional opt-in                                               |
| Container packages allowed?                                   | Y                                                                                                                           |
| Existing package may be replaced with containerized ebuild?   | N unless community approves                                                                                                 |
| User inside container                                         | Must be a limited user if daemonized, cannot use pre-existing UID of real users                                             |
| Telemetry                                                     | Default off, default opt-out                                                                                                |
| Data breach support (password check remotely)                 | Default off, default opt-out, patching may be required to optionalize                                                       |

Robustness QA

| Subject                                                  | Answer                                                                                        |
| ---                                                      | ---                                                                                           |
| Ebuilds must work when merged                            | Y                                                                                             |
| If ebuilds do not work, how about KEYWORDS?              | Disabled                                                                                      |
| Minimum uptime (kernel, during testing)                  | 60 days                                                                                       |
| Minimum uptime (kernel, during production)               | 30 days                                                                                       |
| Number of expected/actual crashes in 30 days             | 0                                                                                             |
| Unfinished features?                                     | Disable USE flag, disable configuration, or disable code                                      |

Performance QA

| Subject                                                  | Answer                                                                                        |
| ---                                                      | ---                                                                                           |
| Minimum FPS                                              | 25 FPS (Motion picture FPS)                                                                   |
| Minimum uptime (kernel, during testing)                  | 60 days                                                                                       |
| Minimum uptime (kernel, during production)               | 30 days                                                                                       |
| Maximum ebuild completion time                           | 36 hours                                                                                      |
| Runtime thrashing                                        | Disallowed                                                                                    |
| Build time severe thrashing                              | Only allowed for web browser or AI/ML packages                                                |

LICENCE variable QA

| Subject                                                                                               | Answer                                                                                        |
| ---                                                                                                   | ---                                                                                           |
| AI models require licenses and acceptable use AI ethics disclosure                                    | Y                                                                                             |
| Telemetry usage require privacy policy and data retention disclosure                                  | Y                                                                                             |
| Services require terms of use disclosure                                                              | Y                                                                                             |
| Patent licenses must be disclosed                                                                     | Y                                                                                             |
| The `custom` placeholder is allowed                                                                   | Y                                                                                             |
| Copyright notices must be saved (with lcnr or full source install)                                    | Y                                                                                             |
| Actively patented codecs require `patent_status_nonfree` USE flag and free alternative(s) if possible | Y                                                                                             |
