# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="maturin"
PYTHON_COMPAT=( "python3_"{10..14} )
RUST_MAX_VER="1.91.1"
RUST_MIN_VER="1.91.1" # LLVM 21.1
RUSTFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"

declare -A GIT_CRATES=(
)

DISABLED_CRATES="
tokenizers-python-0.23.1
"

# From "./convert-cargo-lock.sh 0.23.1"
CRATES="
adler2-2.0.1
ahash-0.8.12
aho-corasick-1.1.4
anes-0.1.6
anstream-1.0.0
anstyle-1.0.14
anstyle-parse-1.0.0
anstyle-query-1.1.5
anstyle-wincon-3.0.11
anyhow-1.0.102
assert_approx_eq-1.1.0
atomic-waker-1.1.2
autocfg-1.5.1
base64-0.13.1
base64-0.22.1
bitflags-2.12.1
bit-set-0.8.0
bit-vec-0.8.0
bumpalo-3.20.3
byteorder-1.5.0
bytes-1.11.1
cast-0.3.0
castaway-0.2.4
cc-1.2.63
cfg_aliases-0.2.1
cfg-if-1.0.4
ciborium-0.2.2
ciborium-io-0.2.2
ciborium-ll-0.2.2
clap-4.6.1
clap_builder-4.6.0
clap_lex-1.1.0
colorchoice-1.0.5
compact_str-0.9.1
console-0.15.11
console-0.16.3
crc32fast-1.5.0
criterion-0.6.0
criterion-plot-0.5.0
crossbeam-deque-0.8.6
crossbeam-epoch-0.9.18
crossbeam-utils-0.8.21
crunchy-0.2.4
daachorse-1.0.1
darling-0.20.11
darling_core-0.20.11
darling_macro-0.20.11
dary_heap-0.3.9
derive_builder-0.20.2
derive_builder_core-0.20.2
derive_builder_macro-0.20.2
dirs-6.0.0
dirs-sys-0.5.0
displaydoc-0.2.6
either-1.16.0
encode_unicode-1.0.0
env_filter-1.0.1
env_logger-0.11.10
equivalent-1.0.2
errno-0.3.14
esaxx-rs-0.1.10
fancy-regex-0.17.0
fastrand-2.4.1
find-msvc-tools-0.1.9
flate2-1.1.9
fnv-1.0.7
foldhash-0.1.5
form_urlencoded-1.2.2
futures-channel-0.3.32
futures-core-0.3.32
futures-io-0.3.32
futures-macro-0.3.32
futures-sink-0.3.32
futures-task-0.3.32
futures-util-0.3.32
getrandom-0.2.17
getrandom-0.3.4
getrandom-0.4.2
half-2.7.1
hashbrown-0.15.5
hashbrown-0.17.1
heck-0.5.0
hf-hub-0.4.3
http-1.4.1
httparse-1.10.1
http-body-1.0.1
http-body-util-0.1.3
hyper-1.10.1
hyper-rustls-0.27.9
hyper-util-0.1.20
icu_collections-2.2.0
icu_locale_core-2.2.0
icu_normalizer-2.2.0
icu_normalizer_data-2.2.0
icu_properties-2.2.0
icu_properties_data-2.2.0
icu_provider-2.2.0
id-arena-2.3.0
ident_case-1.0.1
idna-1.1.0
idna_adapter-1.2.2
indexmap-2.14.0
indicatif-0.17.11
indicatif-0.18.4
ipnet-2.12.0
is_terminal_polyfill-1.70.2
itertools-0.10.5
itertools-0.13.0
itertools-0.14.0
itoa-1.0.18
jiff-0.2.28
jiff-static-0.2.28
js-sys-0.3.99
lazy_static-1.5.0
leb128fmt-0.1.0
libc-0.2.186
libredox-0.1.17
linux-raw-sys-0.12.1
litemap-0.8.2
log-0.4.32
lru-slab-0.1.2
macro_rules_attribute-0.2.2
macro_rules_attribute-proc_macro-0.2.2
matrixmultiply-0.3.10
memchr-2.8.1
minimal-lexical-0.2.1
miniz_oxide-0.8.9
mio-1.2.1
monostate-0.1.18
monostate-impl-0.1.18
ndarray-0.16.1
ndarray-0.17.2
nom-7.1.3
nu-ansi-term-0.50.3
number_prefix-0.4.0
num-complex-0.4.6
num-integer-0.1.46
numpy-0.28.0
num-traits-0.2.19
once_cell-1.21.4
once_cell_polyfill-1.70.2
onig-6.5.3
onig_sys-69.9.3
oorandom-11.1.5
option-ext-0.2.0
paste-1.0.15
percent-encoding-2.3.2
pin-project-lite-0.2.17
pkg-config-0.3.33
plotters-0.3.7
plotters-backend-0.3.7
plotters-svg-0.3.7
portable-atomic-1.13.1
portable-atomic-util-0.2.7
potential_utf-0.1.5
ppv-lite86-0.2.21
prettyplease-0.2.37
proc-macro2-1.0.106
pyo3-0.28.2
pyo3-async-runtimes-0.28.0
pyo3-build-config-0.28.2
pyo3-ffi-0.28.2
pyo3-macros-0.28.2
pyo3-macros-backend-0.28.2
quinn-0.11.9
quinn-proto-0.11.14
quinn-udp-0.5.14
quote-1.0.45
rand-0.9.4
rand_chacha-0.9.0
rand_core-0.9.5
rawpointer-0.2.1
rayon-1.12.0
rayon-cond-0.4.0
rayon-core-1.13.0
redox_users-0.5.2
r-efi-5.3.0
r-efi-6.0.0
regex-1.12.3
regex-automata-0.4.14
regex-syntax-0.8.10
reqwest-0.12.28
ring-0.17.14
rustc-hash-2.1.2
rustix-1.1.4
rustls-0.23.40
rustls-pki-types-1.14.1
rustls-webpki-0.103.13
rustversion-1.0.22
ryu-1.0.23
same-file-1.0.6
semver-1.0.28
serde-1.0.228
serde_core-1.0.228
serde_derive-1.0.228
serde_json-1.0.150
serde_urlencoded-0.7.1
sharded-slab-0.1.7
shlex-2.0.1
signal-hook-registry-1.4.8
simd-adler32-0.3.9
slab-0.4.12
smallvec-1.15.1
socket2-0.6.4
socks-0.3.4
spm_precompiled-0.1.4
stable_deref_trait-1.2.1
static_assertions-1.1.0
strsim-0.11.1
subtle-2.6.1
syn-2.0.117
sync_wrapper-1.0.2
synstructure-0.13.2
target-lexicon-0.13.5
tempfile-3.27.0
thiserror-2.0.18
thiserror-impl-2.0.18
thread_local-1.1.9
tinystr-0.8.3
tinytemplate-1.2.1
tinyvec-1.11.0
tinyvec_macros-0.1.1
tokenizers-0.23.1
tokio-1.52.3
tokio-macros-2.7.0
tokio-rustls-0.26.4
tokio-util-0.7.18
tower-0.5.3
tower-http-0.6.11
tower-layer-0.3.3
tower-service-0.3.3
tracing-0.1.44
tracing-attributes-0.1.31
tracing-core-0.1.36
tracing-log-0.2.0
tracing-subscriber-0.3.23
try-lock-0.2.5
unicode_categories-0.1.1
unicode-ident-1.0.24
unicode-normalization-alignments-0.1.12
unicode-segmentation-1.13.3
unicode-width-0.2.2
unicode-xid-0.2.6
unit-prefix-0.5.2
untrusted-0.9.0
ureq-2.12.1
url-2.5.8
utf8_iter-1.0.4
utf8parse-0.2.2
valuable-0.1.1
version_check-0.9.5
walkdir-2.5.0
want-0.3.1
wasi-0.11.1+wasi-snapshot-preview1
wasip2-1.0.3+wasi-0.2.9
wasip3-0.4.0+wasi-0.3.0-rc-2026-01-06
wasm-bindgen-0.2.122
wasm-bindgen-futures-0.4.72
wasm-bindgen-macro-0.2.122
wasm-bindgen-macro-support-0.2.122
wasm-bindgen-shared-0.2.122
wasm-encoder-0.244.0
wasm-metadata-0.244.0
wasmparser-0.244.0
wasm-streams-0.4.2
webpki-roots-0.26.11
webpki-roots-1.0.7
web-sys-0.3.99
web-time-1.1.0
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.11
winapi-x86_64-pc-windows-gnu-0.4.0
windows_aarch64_gnullvm-0.52.6
windows_aarch64_gnullvm-0.53.1
windows_aarch64_msvc-0.52.6
windows_aarch64_msvc-0.53.1
windows_i686_gnu-0.52.6
windows_i686_gnu-0.53.1
windows_i686_gnullvm-0.52.6
windows_i686_gnullvm-0.53.1
windows_i686_msvc-0.52.6
windows_i686_msvc-0.53.1
windows-link-0.2.1
windows-sys-0.52.0
windows-sys-0.59.0
windows-sys-0.60.2
windows-sys-0.61.2
windows-targets-0.52.6
windows-targets-0.53.5
windows_x86_64_gnu-0.52.6
windows_x86_64_gnu-0.53.1
windows_x86_64_gnullvm-0.52.6
windows_x86_64_gnullvm-0.53.1
windows_x86_64_msvc-0.52.6
windows_x86_64_msvc-0.53.1
wit-bindgen-0.51.0
wit-bindgen-0.57.1
wit-bindgen-core-0.51.0
wit-bindgen-rust-0.51.0
wit-bindgen-rust-macro-0.51.0
wit-component-0.244.0
wit-parser-0.244.0
writeable-0.6.3
yoke-0.8.3
yoke-derive-0.8.2
zerocopy-0.8.50
zerocopy-derive-0.8.50
zerofrom-0.1.8
zerofrom-derive-0.1.7
zeroize-1.8.2
zerotrie-0.2.4
zerovec-0.11.6
zerovec-derive-0.11.3
zmij-1.0.21
"

inherit cargo distutils-r1 lcnr pypi rustflags-hardened

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
SLOT="0/"$(ver_cut "1-2" "${PV}")
# Upstream uses lto
IUSE+=" dev doc lto test"
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
	>=dev-python/maturin-1.0[${PYTHON_USEDEP}]
	<dev-python/maturin-2.0[${PYTHON_USEDEP}]

	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
		dev-python/setuptools-rust[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/datasets[${PYTHON_USEDEP}]
		dev-python/ruff[${PYTHON_USEDEP}]
		dev-python/ty[${PYTHON_USEDEP}]
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
