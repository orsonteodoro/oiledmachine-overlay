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
PYTHON_COMPAT=( "python3_"{10..13} )
RUST_MAX_VER="1.91.1"
RUST_MIN_VER="1.91.1" # LLVM 21.1
RUST_NEEDS_LLVM=1

DISABLE_CRATES="
tiktoken-0.12.0
"

CRATES="
aho-corasick-1.1.4
autocfg-1.5.0
bit-set-0.5.3
bit-vec-0.6.3
bstr-1.12.1
fancy-regex-0.13.0
heck-0.5.0
indoc-2.0.7
libc-0.2.186
memchr-2.8.0
memoffset-0.9.1
once_cell-1.21.4
portable-atomic-1.13.1
proc-macro2-1.0.106
pyo3-0.26.0
pyo3-build-config-0.26.0
pyo3-ffi-0.26.0
pyo3-macros-0.26.0
pyo3-macros-backend-0.26.0
quote-1.0.45
regex-1.12.3
regex-automata-0.4.14
regex-syntax-0.8.10
rustc-hash-2.1.2
rustversion-1.0.22
serde-1.0.228
serde_core-1.0.228
serde_derive-1.0.228
syn-2.0.117
target-lexicon-0.13.5
unicode-ident-1.0.24
unindent-0.2.4
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
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" blobfile dev ebuild_revision_2"
RDEPEND+="
	>=dev-python/regex-2022.1.18[${PYTHON_USEDEP}]
	>=dev-python/requests-2.26.0[${PYTHON_USEDEP}]
	blobfile? (
		>=dev-python/blobfile-2[${PYTHON_USEDEP}]
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

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
