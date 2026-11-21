# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit secure-version

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="maturin"
PYTHON_COMPAT=( "python3_"{11..14} )
RUST_MAX_VER="${RUST_LLVM_ROLLING_PV}"
RUST_MIN_VER="${RUST_LLVM_ROLLING_PV}"
RUSTFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"

declare -A GIT_CRATES=(
)

DISABLED_CRATES="
tokenizers-python-0.23.3
"

# From "./convert-cargo-lock.sh 0.23.3"
CRATES="
ahash-0.8.12
aho-corasick-1.1.5
anstream-1.0.0
anstyle-1.0.14
anstyle-parse-1.0.0
anstyle-query-1.1.5
anstyle-wincon-3.0.11
autocfg-1.5.1
base64-0.13.1
bitflags-2.13.2
bumpalo-3.20.4
castaway-0.2.4
cc-1.11.3
cfg-if-1.0.5
colorchoice-1.0.5
compact_str-0.9.1
console-0.16.6
crossbeam-deque-0.8.8
crossbeam-epoch-0.9.21
crossbeam-utils-0.8.23
daachorse-3.0.3
darling-0.20.11
darling_core-0.20.11
darling_macro-0.20.11
dary_heap-0.3.9
derive_builder-0.20.2
derive_builder_core-0.20.2
derive_builder_macro-0.20.2
either-1.19.0
encode_unicode-1.0.0
env_filter-2.1.0
env_logger-0.11.12
errno-0.3.15
esaxx-rs-0.1.10
fastrand-2.5.0
find-msvc-tools-0.1.15
fnv-1.0.7
futures-channel-0.3.34
futures-core-0.3.34
futures-macro-0.3.34
futures-task-0.3.34
futures-util-0.3.34
getrandom-0.3.4
getrandom-0.4.3
heck-0.5.0
ident_case-1.0.1
indicatif-0.18.6
is_terminal_polyfill-1.70.2
itertools-0.14.0
itoa-1.0.19
jiff-1.0.1
jiff-core-1.0.1
jiff-static-1.0.1
js-sys-0.3.107
libc-0.2.191
linux-raw-sys-0.12.1
log-0.4.35
macro_rules_attribute-0.2.3
macro_rules_attribute-proc_macro-0.2.3
matrixmultiply-0.3.11
memchr-2.8.3
minimal-lexical-0.2.1
mio-1.2.5
monostate-0.1.18
monostate-impl-0.1.18
ndarray-0.16.1
ndarray-0.17.2
nom-7.1.3
num-complex-0.4.6
num-integer-0.1.47
numpy-0.29.0
num-traits-0.2.19
once_cell-1.21.4
once_cell_polyfill-1.70.2
onig-6.5.3
onig_sys-69.9.3
paste-1.0.15
pastey-0.2.3
pin-project-lite-0.2.18
pkg-config-0.3.34
portable-atomic-1.15.0
portable-atomic-util-0.2.8
ppv-lite86-0.2.21
proc-macro2-1.0.107
pyo3-0.29.3
pyo3-async-runtimes-0.29.0
pyo3-build-config-0.29.3
pyo3-ffi-0.29.3
pyo3-macros-0.29.3
pyo3-macros-backend-0.29.3
quote-1.0.47
rand-0.9.5
rand_chacha-0.9.0
rand_core-0.9.5
rawpointer-0.2.1
rayon-1.12.0
rayon-cond-0.4.0
rayon-core-1.13.0
r-efi-5.3.0
r-efi-6.0.0
regex-1.13.2
regex-automata-0.4.19
regex-syntax-0.8.12
rustc-hash-2.1.3
rustix-1.1.6
rustversion-1.0.23
ryu-1.0.23
serde-1.0.229
serde_core-1.0.229
serde_derive-1.0.229
serde_json-1.0.154
shlex-2.0.1
signal-hook-registry-1.4.8
slab-0.4.12
smallvec-1.16.6
spm_precompiled-0.1.4
static_assertions-1.1.0
strsim-0.11.1
syn-2.0.119
syn-3.0.10
target-lexicon-0.13.6
tempfile-3.27.0
thiserror-2.0.21
thiserror-impl-2.0.21
tokenizers-0.23.2
tokio-1.54.1
tokio-macros-2.7.2
unicode_categories-0.1.1
unicode-ident-1.0.27
unicode-normalization-alignments-0.1.12
unicode-segmentation-1.13.3
unicode-width-0.2.3
unit-prefix-0.5.2
utf8parse-0.2.2
version_check-0.9.5
wasi-0.11.1+wasi-snapshot-preview1
wasip2-1.0.4+wasi-0.2.12
wasm-bindgen-0.2.130
wasm-bindgen-macro-0.2.130
wasm-bindgen-macro-support-0.2.130
wasm-bindgen-shared-0.2.130
web-time-1.1.0
windows-link-0.2.1
windows-sys-0.61.2
wit-bindgen-0.57.1
zerocopy-0.8.63
zerocopy-derive-0.8.63
zmij-1.0.23
"

inherit cargo cflags-hardened distutils-r1 lcnr pypi rustflags-hardened

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
https://github.com/huggingface/tokenizers/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
$(cargo_crate_uris ${CRATES})
"

DESCRIPTION="💥 Fast State-of-the-Art Tokenizers optimized for Research and Production"
HOMEPAGE="
	https://github.com/huggingface/tokenizers
	https://pypi.org/project/tokenizers
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0"
# Upstream uses lto
IUSE+="
dev doc lto test
ebuild_revision_1
"
REQUIRED_USE="
	dev? (
		test
	)
"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-util/maturin-1.0[${PYTHON_USEDEP}]
	<dev-util/maturin-2.0[${PYTHON_USEDEP}]

	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
		dev-python/setuptools-rust[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/datasets[${PYTHON_USEDEP}]
		dev-python/ruff[${PYTHON_USEDEP}]
		dev-python/ty[${PYTHON_USEDEP}]
		virtual/numpy[${PYTHON_USEDEP}]
	)

"
DOCS=( "README.md" )

src_unpack() {
	unpack ${A}
#	die
	cargo_src_unpack
	cp -aT \
		"${FILESDIR}/${PV}"* \
		"${S}" \
		|| die
}

src_configure() {
	export CARGO_TERM_VERBOSE="true"
	cargo_src_configure
	local lto=$(usex lto "true" "false")
	sed -i \
		-e "s|lto = true|lto = ${lto}|g" \
		"bindings/node/Cargo.toml" \
		|| die
	cflags-hardened_append		# For *-sys crates
	rustflags-hardened_append
}

python_compile() {
	local pypv="${EPYTHON}"
	pypv="${pypv/./}"
	pypv="${pypv/python/}"

	sed -i \
		-r -e "s|abi3-py[0-9]+|abi3-py${pypv}|g" \
		"${S}/bindings/python/Cargo.toml" \
		|| die

	export PYTHON_SYS_EXECUTABLE="${PYTHON}"

	cd "${S}/bindings/python" || die
	export BUILD_DIR="${WORKDIR}/${PN}-${PV}/bindings/python"
	distutils-r1_python_compile

	rm -rf "${WORKDIR}/${PN}-${PV}-${EPYTHON/./_}/install/"* || true

	local wheel_path=$(realpath "${WORKDIR}/${PN}-${PV}/bindings/python/target/wheels/${PN}-${PV}-cp${pypv}-abi3-linux_"*".whl")
	einfo "wheel_path=${wheel_path}"
	local d="${WORKDIR}/${PN}-${PV}-${EPYTHON/./_}/install"
	distutils_wheel_install "${d}" \
		"${wheel_path}"

	# Unbreak die check
	mkdir -p "${d}/usr/bin"
	touch "${d}/usr/bin/"{"${EPYTHON}","python3","python","pyvenv.cfg"}
	mv "${d}/usr/bin/pyvenv.cfg" "${d}/usr/bin/../pyvenv.cfg" || die
}

python_install() {
	distutils-r1_python_install
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"

	LCNR_SOURCE="${WORKDIR}/cargo_home/gentoo"
	LCNR_TAG="third_party"
        lcnr_install_files
}

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
