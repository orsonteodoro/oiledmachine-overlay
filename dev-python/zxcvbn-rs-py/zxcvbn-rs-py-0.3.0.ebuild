# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

inherit secure-version

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data"
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="maturin"
PYTHON_COMPAT=( "python3_"{10..14} ) # U22 supports up to 3.11, gnome-misc/secrets supports 12-14
RUST_MAX_VER="${RUST_LLVM_23_PV}"
RUST_MIN_VER="${RUST_LLVM_23_PV}"
RUSTFLAGS_HARDENED_USE_CASES="security-critical sensitive-data"

declare -A GIT_CRATES=(
)

DISABLED_CRATES="
zxcvbn-rs-py-0.3.0
"
# pyo3@0.27.1 must be a pinned version.
# From "./convert-cargo-lock.sh 0.3.0 0.3.0"
CRATES="
aho-corasick-1.1.5
android_system_properties-0.1.6
autocfg-1.5.1
bit-set-0.8.0
bit-vec-0.8.0
bumpalo-3.20.4
cc-1.11.3
cfg-if-1.0.5
chrono-0.4.45
core-foundation-sys-0.8.7
darling-0.20.11
darling_core-0.20.11
darling_macro-0.20.11
deranged-0.5.9
derive_builder-0.20.2
derive_builder_core-0.20.2
derive_builder_macro-0.20.2
either-1.19.0
fancy-regex-0.18.0
find-msvc-tools-0.1.15
fnv-1.0.7
futures-core-0.3.34
futures-task-0.3.34
futures-util-0.3.34
heck-0.5.0
iana-time-zone-0.1.65
iana-time-zone-haiku-0.1.2
ident_case-1.0.1
indoc-2.0.8
itertools-0.14.0
js-sys-0.3.107
lazy_static-1.5.1
libc-0.2.191
log-0.4.35
memchr-2.8.3
memoffset-0.9.1
num-conv-0.2.2
num-traits-0.2.19
once_cell-1.21.4
pin-project-lite-0.2.18
portable-atomic-1.15.0
powerfmt-0.2.1
proc-macro2-1.0.107
pyo3-0.27.2
pyo3-build-config-0.27.2
pyo3-ffi-0.27.2
pyo3-macros-0.27.2
pyo3-macros-backend-0.27.2
quote-1.0.47
regex-1.13.2
regex-automata-0.4.19
regex-syntax-0.8.12
rustversion-1.0.23
serde_core-1.0.229
serde_derive-1.0.229
shlex-2.0.1
slab-0.4.12
strsim-0.11.1
syn-2.0.119
syn-3.0.10
target-lexicon-0.13.6
time-0.3.55
time-core-0.1.9
unicode-ident-1.0.27
unindent-0.2.4
wasm-bindgen-0.2.130
wasm-bindgen-macro-0.2.130
wasm-bindgen-macro-support-0.2.130
wasm-bindgen-shared-0.2.130
web-sys-0.3.107
windows-core-0.62.2
windows-implement-0.60.2
windows-interface-0.59.3
windows-link-0.2.1
windows-result-0.4.1
windows-strings-0.5.1
zxcvbn-3.1.1
"

inherit cargo cflags-hardened distutils-r1 pypi rust rustflags-hardened

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
SLOT="0"
IUSE+="
ebuild_revision_12
"
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
	cflags-hardened_append		# For *-sys crates
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
