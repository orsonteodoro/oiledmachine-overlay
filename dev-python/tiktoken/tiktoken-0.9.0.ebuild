# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# To update lockfile:
# cargo update

GENERATE_LOCKFILE=${GENERATE_LOCKFILE:-0}

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
LLVM_COMPAT=( 17 )
PYTHON_COMPAT=( "python3_"{10..13} )
RUST_MAX_VER="1.74.1" # Inclusive.  Corresponds to llvm 17
RUST_MIN_VER="1.74.1" # Corresponds to llvm 17
RUST_NEEDS_LLVM=1

CRATES="
aho-corasick-1.1.3
autocfg-1.5.0
bit-set-0.5.3
bit-vec-0.6.3
bstr-1.12.0
cfg-if-1.0.1
fancy-regex-0.13.0
heck-0.5.0
indoc-2.0.6
libc-0.2.174
memchr-2.7.5
memoffset-0.9.1
once_cell-1.21.3
portable-atomic-1.11.1
proc-macro2-1.0.95
pyo3-0.24.2
pyo3-build-config-0.24.2
pyo3-ffi-0.24.2
pyo3-macros-0.24.2
pyo3-macros-backend-0.24.2
quote-1.0.40
regex-1.11.1
regex-automata-0.4.9
regex-syntax-0.8.5
rustc-hash-1.1.0
serde-1.0.219
serde_derive-1.0.219
syn-2.0.104
target-lexicon-0.13.2
unicode-ident-1.0.18
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
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
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
