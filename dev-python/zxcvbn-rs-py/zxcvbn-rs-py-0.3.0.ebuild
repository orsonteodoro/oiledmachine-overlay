# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="maturin"
PYTHON_COMPAT=( "python3_"{10..14} ) # U22 supports up to 3.11, gnome-misc/secrets supports 12-14
RUST_MAX_VER="1.88.0"
RUST_MIN_VER="1.88.0"
RUSTFLAGS_HARDENED_USE_CASES="security-critical sensitive-data"

declare -A GIT_CRATES=(
)

DISABLED_CRATES="
zxcvbn-rs-py-0.3.0
"
# pyo3@0.27.1 must be a pinned version.
# From "./convert-cargo-lock.sh 0.3.0 0.3.0"
CRATES="
aho-corasick-1.1.4
android_system_properties-0.1.5
autocfg-1.5.0
bit-set-0.5.3
bit-vec-0.6.3
bumpalo-3.19.0
cc-1.2.48
cfg-if-1.0.4
chrono-0.4.42
core-foundation-sys-0.8.7
darling-0.20.11
darling_core-0.20.11
darling_macro-0.20.11
deranged-0.5.5
derive_builder-0.20.2
derive_builder_core-0.20.2
derive_builder_macro-0.20.2
either-1.15.0
fancy-regex-0.13.0
find-msvc-tools-0.1.5
fnv-1.0.7
heck-0.5.0
iana-time-zone-0.1.64
iana-time-zone-haiku-0.1.2
ident_case-1.0.1
indoc-2.0.7
itertools-0.13.0
js-sys-0.3.83
lazy_static-1.5.0
libc-0.2.177
log-0.4.28
memchr-2.7.6
memoffset-0.9.1
num-conv-0.1.0
num-traits-0.2.19
once_cell-1.21.3
portable-atomic-1.11.1
powerfmt-0.2.0
proc-macro2-1.0.103
pyo3-0.27.1
pyo3-build-config-0.27.1
pyo3-ffi-0.27.1
pyo3-macros-0.27.1
pyo3-macros-backend-0.27.1
quote-1.0.42
regex-1.12.2
regex-automata-0.4.13
regex-syntax-0.8.8
rustversion-1.0.22
serde-1.0.228
serde_core-1.0.228
serde_derive-1.0.228
shlex-1.3.0
strsim-0.11.1
syn-2.0.111
target-lexicon-0.13.3
time-0.3.44
time-core-0.1.6
unicode-ident-1.0.22
unindent-0.2.4
wasm-bindgen-0.2.106
wasm-bindgen-macro-0.2.106
wasm-bindgen-macro-support-0.2.106
wasm-bindgen-shared-0.2.106
web-sys-0.3.83
windows-core-0.62.2
windows-implement-0.60.2
windows-interface-0.59.3
windows-link-0.2.1
windows-result-0.4.1
windows-strings-0.5.1
zxcvbn-3.1.0
"

inherit cargo distutils-r1 pypi rust rustflags-hardened

KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~s390 ~x86"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
$(cargo_crate_uris ${CRATES})
https://github.com/fief-dev/zxcvbn-rs-py/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Python bindings for zxcvbn-rs, the Rust implementation of zxcvbn"
HOMEPAGE="
	https://github.com/fief-dev/zxcvbn-rs-py
	https://pypi.org/project/zxcvbn-rs-py
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+=" ebuild_revision_5"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"

# No longer supported by distro
#	>=dev-python/mkdocstrings-0.18[${PYTHON_USEDEP},python(+)]
#	dev-python/mkdocs-material[${PYTHON_USEDEP}]
BDEPEND+="
	dev-python/black[${PYTHON_USEDEP}]
	dev-python/mypy[${PYTHON_USEDEP}]
	dev-python/pip[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-util/maturin[${PYTHON_USEDEP}]
	dev-util/ruff
"
DOCS=( "README.md" )

pkg_setup() {
	rust_pkg_setup
}

src_configure() {
	export CARGO_TERM_VERBOSE="true"
	rustflags-hardened_append
}

src_unpack() {
	unpack ${A}
#	die
	cargo_src_unpack
	cp -aT \
		"${FILESDIR}/${PV}"* \
		"${S}" \
		|| die
}

python_compile() {
	cargo_src_compile
	S="${WORKDIR}/${PN}-${PV}" \
	distutils-r1_python_compile
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
