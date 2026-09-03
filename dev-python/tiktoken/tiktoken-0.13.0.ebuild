# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# To update lockfile:
# cargo update

GENERATE_LOCKFILE=${GENERATE_LOCKFILE:-0}

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
LLVM_COMPAT=( 21 )
PYTHON_COMPAT=( "python3_"{10..14} )
RUST_MAX_VER="1.93.1"
RUST_MIN_VER="1.93.1" # LLVM 21.1
RUST_NEEDS_LLVM=1

DISABLE_CRATES="
tiktoken-0.13.0
"

CRATES="
aho-corasick-1.1.5
bit-set-0.8.0
bit-vec-0.8.0
bstr-1.13.1
fancy-regex-0.17.0
heck-0.5.0
libc-0.2.189
memchr-2.8.3
once_cell-1.21.4
portable-atomic-1.15.0
proc-macro2-1.0.107
pyo3-0.28.3
pyo3-build-config-0.28.3
pyo3-ffi-0.28.3
pyo3-macros-0.28.3
pyo3-macros-backend-0.28.3
quote-1.0.47
regex-1.13.1
regex-automata-0.4.18
regex-syntax-0.8.11
rustc-hash-2.1.3
serde_core-1.0.229
serde_derive-1.0.229
syn-2.0.119
syn-3.0.3
target-lexicon-0.13.5
unicode-ident-1.0.24
"

inherit cargo distutils-r1 rust

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
SLOT=0
IUSE+=" blobfile dev ebuild_revision_5"
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
	#die # For lockfile update
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
