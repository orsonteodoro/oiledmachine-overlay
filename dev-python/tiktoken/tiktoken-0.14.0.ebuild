# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# To update lockfile:
# cargo update

GENERATE_LOCKFILE=${GENERATE_LOCKFILE:-0}

inherit secure-version

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
LLVM_COMPAT=( ${RUST_LLVM_ROLLING_SLOT} )
PYTHON_COMPAT=( "python3_"{10..14} )
RUST_MAX_VER="${RUST_LLVM_ROLLING_PV}"
RUST_MIN_VER="${RUST_LLVM_ROLLING_PV}"
RUST_NEEDS_LLVM=1
RUSTFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"

DISABLE_CRATES="
tiktoken-0.14.0
"

CRATES="
aho-corasick-1.1.5
bit-set-0.8.0
bit-vec-0.8.0
bstr-1.14.0
fancy-regex-0.19.2
heck-0.5.0
libc-0.2.191
memchr-2.8.3
once_cell-1.21.4
portable-atomic-1.15.0
proc-macro2-1.0.107
pyo3-0.29.3
pyo3-build-config-0.29.3
pyo3-ffi-0.29.3
pyo3-macros-0.29.3
pyo3-macros-backend-0.29.3
quote-1.0.47
regex-1.13.2
regex-automata-0.4.19
regex-syntax-0.8.12
rustc-hash-2.1.3
serde_core-1.0.229
serde_derive-1.0.229
syn-2.0.119
syn-3.0.10
target-lexicon-0.13.6
unicode-ident-1.0.27
"

inherit cargo distutils-r1 rust rustflags-hardened

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
$(cargo_crate_uris ${CRATES})
https://github.com/openai/tiktoken/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="tiktoken is a fast BPE tokeniser for use with OpenAI's models"
HOMEPAGE="
	https://github.com/openai/tiktoken
	https://pypi.org/project/tiktoken
"
LICENSE="
	MIT
"
RESTRICT="mirror test" # Untested
SLOT="0"
IUSE+=" blobfile dev ebuild_revision_6"
RDEPEND+="
	>=dev-python/regex-2022.1.18[${PYTHON_USEDEP}]
	>=dev-python/requests-2.26.0[${PYTHON_USEDEP}]
	blobfile? (
		>=dev-python/blobfile-3[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-62.4[${PYTHON_USEDEP}]
	>=dev-python/setuptools-rust-1.5.2[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
"
DOCS=()

_lockfile_gen_unpack() {
	unpack "${P}.tar.gz"
	#die # For lockfile update
	cd "${S}" || die
einfo "Generating lockfile"
	rm Cargo.lock
	cargo generate-lockfile || die "Failed to update Cargo.lock"

einfo "Fixing vulnerabilities"

	die
}

_production_unpack() {
	unpack "${P}.tar.gz"
#	die # For lockfile update
}

pkg_setup() {
	python_setup
	rust_pkg_setup
}

src_unpack() {
	if [[ "${GENERATE_LOCKFILE}" == "1" ]] ; then
		_lockfile_gen_unpack
	else
		_production_unpack
	fi
	cargo_src_unpack
	if [[ "${GENERATE_LOCKFILE}" != "1" ]] ; then
		cp -vaT \
			"${FILESDIR}/${PV}" \
			"${S}" \
			|| die
	fi
}

src_configure() {
	rustflags-hardened_append
	distutils-r1_src_configure
}

src_compile() {
	cargo_src_compile
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install
}

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
