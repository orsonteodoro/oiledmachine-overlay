# Overlay ebuild style guidelines and quality assurance (QA) for this overlay

Ebuild coding styles

| Subject                               | Answer                                             |
| ---                                   | ---                                                |
| Distro style supported                | Y, for ebuilds originally from the distro overlay  |
| Oiledmachine-overlay style supported  | Y                                                  |

Distro ebuild style example

```bash
# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8

if [[ ${PV} =~ *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/orsonteodoro/oiledmachine-overlay.git"
	inherit git-r3
fi

DESCRIPTION="An example of Larry The Cow's package"
HOMEPAGE="https://www.gentoo.org"
LICENSE="GPL-2+"
IUSE="cowpen"
RDEPEND="
	sys-libs/glibc
	zlib? ( sys-libs/zlib )
"
DDEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gcc
"
PATCHES="
	"${FILESDIR}"/${PN}-1.0.0-hardcoded-fixes.patch
"

src_unpack() {
	if [[ ${PV} =~ 9999 ]] ; then
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
	einfo "The datacenter stole Larry The Cows water!"
	if ! use cowpen ; then
		einfo
		einfo "Security Notice"
		einfo
		einfo "Larry The Cow has escaped!"
		einfo
	fi
}

```

Oiledmachine-overlay style example

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

DESCRIPTION="An example of Larry The Cow's package"
HOMEPAGE="https://www.gentoo.org"
LICENSE="GPL-2+"
IUSE="cowpen"
RDEPEND="
	sys-libs/glibc
	zlib? (
		sys-libs/zlib
	)
"
DDEPEND="
	${RDEPEND}
"
BDEPEND="
	sys-devel/gcc
"
PATCHES="
	"${FILESDIR}/${PN}-1.0.0-hardcoded-fixes.patch"
"

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
einfo "The datacenter stole Larry The Cows water!"
	if ! use cowpen ; then
einfo
einfo "Security Notice"
einfo
einfo "Larry the cow has escaped!"
einfo
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

| Subject                 | Answer                                             |
| ---                     | ---                                                |
| Default C++             | -std=gnu++17                                       |
| Acceptable rolling C++  | -std=gnu++20, -std=gnu++23                         |
| Acceptable LTS C++      | -std=gnu++17, -std=gnu++11, -std=c++17, -std=c++11 |

Python defaults

| Subject                          | Answer                                             |
| ---                              | ---                                                |
| Default Python                   | python3_12                                         |
| Acceptable rolling Python slots  | python3_14                                         |
| Acceptable LTS Python slots      | python3_{11..13}                                   |
| Acceptable rolling Python slots  | python3_14                                         |
| Acceptable multislot Python      | python3_{11..14}                                   |
| Acceptable single slot Python    | python3_{11..14}                                   |

Rust defaults

| Subject                             | Answer                                             |
| ---                                 | ---                                                |
| Default LTS Rust                    | Rust 1.91.1                                        |
| Default rolling Rust                | Rust 1.95.0                                        |
| What is rolling or LTS Rust package | Based on Cargo.lock                                |
| Acceptable LTS Rust for non C++     | Rust 1.91.1                                        |
| Acceptable rolling Rust for non C++ | Rust 1.95.0                                        |
| Acceptable Rust for LLVM 22 for C++ | Rust 1.95.0                                        |
| Acceptable Rust for LLVM 21 for C++ | Rust 1.94.1                                        |
| Acceptable Rust for LLVM 20 for C++ | Rust 1.90.0                                        |
| Acceptable Rust for LLVM 19 for C++ | Rust 1.85.1                                        |
| Acceptable Rust for LLVM 18 for C++ | Rust 1.81.0                                        |
| Acceptable Rust for LLVM 17 for C++ | Rust 1.77.2                                        |

Security QA

| Subject                                                       | Answer                                                                                              |
| ---                                                           | ---                                                                                                 |
| Untrusted meaning                                             | Processes untrusted data                                                                            |
| Trusted meaning                                               | Never trust, always verify                                                                          |
| Untrusted packages example                                    | Network packages, codec packages, sound/image processing, parsers, web packages                     |
| Critically secure examples                                    | Memory allocators, password managers, web browsers                                                  |
| Low level vulnerabilities                                     | Use-after-free, stack overflow, heap overflow, integer overflow                                     |
| High level vulnerabilities                                    | Inappropriate configuration, access control, container/sandbox escapes                              |
| Untrusted packages require compiler hardening                 | Y                                                                                                   |
| Daemons must run as limited user/group                        | Y                                                                                                   |
| Hardened by default                                           | Y                                                                                                   |
| Required Clang CFI                                            | For web browsers only (planned)                                                                     |
| SSP-strong Required                                           | Y, for untrusted data                                                                               |
| Default SSP level                                             | -fstack-protector-strong                                                                            |
| Default _FORTIFY_SOURCE level                                 | 3                                                                                                   |
| Default linker flags                                          | Full Relro                                                                                          |
| Ciphersuite default                                           | Post quantum era first and default ON, followed by legacy                                           |
| Default asymmetric                                            | Post-quantum lattice/hash first (ML-KEM, ML-DSA), followed by legacy elliptical (RSA, ECDH, ECDSA)  |
| Default symmetrical block                                     | Post-quantum AES-256, followed by legacy AES-128                                                    |
| Default hash                                                  | Post-quantum SHA-256, followed by legacy SHA-256                                                    |
| Default KDF                                                   | Post-quantum Argon2id, followed by legacy PBKDF2                                                    |
| Q-Day estimate                                                | Year 2029 (3-4 years from now)                                                                      |
| www-apps require permissions sanitization                     | Y                                                                                                   |
| Default security-critical optimization level                  | -O2                                                                                                 |
| Appropriate security-critical optimization level              | -O1 to -O2                                                                                          |
| Fallback default optimization level                           | -O0 (unset)                                                                                         |
| Untrusted data require cflags-hardened                        | Y                                                                                                   |
| Keys/passwords require Retpoline with cflags-hardened         | Y                                                                                                   |
| Security-critical packages require cflags-hardened            | Y                                                                                                   |
| Untrusted data require rustflags-hardened?                    | Y                                                                                                   |
| Security-critical require rustflags-hardened?                 | Y                                                                                                   |
| Keys/passwords require Retpoline with rustflags-hardened?     | Y                                                                                                   |

Robustness QA

| Subject                                                  | Answer                                                                                        |
| ---                                                      | ---                                                                                           |
| Ebuilds must work when merged                            | Y                                                                                             |
| If ebuilds do not work, how about KEYWORDS?              | Disabled                                                                                      |
| Minimum server uptime                                    | 60 days                                                                                       |

Performance QA

| Subject                                                  | Answer                                                                                        |
| ---                                                      | ---                                                                                           |
| Minimum FPS                                              | 25 FPS (Motion picture FPS)                                                                   |
| Minimum server uptime                                    | 60 days                                                                                       |
| Maximum ebuild completion time                           | 36 hours                                                                                      |
| Runtime thrashing                                        | Disallowed                                                                                    |
| Build time severe thrashing                              | Only allowed for web browser or AI/ML packages                                                |
