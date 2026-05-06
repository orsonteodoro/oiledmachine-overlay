# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Protobuf version:  https://github.com/pinecone-io/python-sdk/blob/v9.0.0/.github/workflows/dev-publish.yml#L20
# Upstream uses 28.3 (slot 5)

DISTUTILS_USE_PEP517="maturin"
PYTHON_COMPAT=( "python3_"{10..12} )
RUST_MAX_VER="1.91.1"
RUST_MIN_VER="1.91.1"

ABSEIL_CPP_SLOT="20240722"
PROTOBUF_CPP_SLOT="5"
PROTOBUF_PYTHON_SLOT="${PROTOBUF_PYTHON_SLOT_5}"

inherit abseil-cpp cargo distutils-r1 protobuf pypi

declare -A GIT_CRATES=(
)

DISABLED_CRATES="
pinecone-grpc-9.0.0
"
# From "./convert-cargo-lock.sh 9.0.0 9.0.0
CRATES="
aho-corasick-1.1.4
anyhow-1.0.102
async-trait-0.1.89
atomic-waker-1.1.2
autocfg-1.5.0
axum-0.8.9
axum-core-0.5.6
base64-0.22.1
bitflags-2.11.1
bumpalo-3.20.2
bytes-1.11.1
cc-1.2.61
cfg-if-1.0.4
core-foundation-0.10.1
core-foundation-sys-0.8.7
either-1.15.0
equivalent-1.0.2
errno-0.3.14
fastrand-2.4.1
find-msvc-tools-0.1.9
fixedbitset-0.5.7
fnv-1.0.7
foldhash-0.1.5
futures-channel-0.3.32
futures-core-0.3.32
futures-sink-0.3.32
futures-task-0.3.32
futures-util-0.3.32
getrandom-0.2.17
getrandom-0.3.4
getrandom-0.4.2
h2-0.4.14
hashbrown-0.15.5
hashbrown-0.17.0
heck-0.5.0
http-1.4.0
httparse-1.10.1
http-body-1.0.1
http-body-util-0.1.3
httpdate-1.0.3
hyper-1.9.0
hyper-timeout-0.5.2
hyper-util-0.1.20
id-arena-2.3.0
indexmap-2.14.0
indoc-2.0.7
itertools-0.14.0
itoa-1.0.18
js-sys-0.3.97
leb128fmt-0.1.0
libc-0.2.186
linux-raw-sys-0.12.1
log-0.4.29
matchit-0.8.4
memchr-2.8.0
memoffset-0.9.1
mime-0.3.17
mio-1.2.0
multimap-0.10.1
once_cell-1.21.4
openssl-probe-0.2.1
percent-encoding-2.3.2
petgraph-0.7.1
pin-project-1.1.12
pin-project-internal-1.1.12
pin-project-lite-0.2.17
portable-atomic-1.13.1
ppv-lite86-0.2.21
prettyplease-0.2.37
proc-macro2-1.0.106
prost-0.13.5
prost-build-0.13.5
prost-derive-0.13.5
prost-types-0.13.5
pyo3-0.24.2
pyo3-build-config-0.24.2
pyo3-ffi-0.24.2
pyo3-macros-0.24.2
pyo3-macros-backend-0.24.2
quote-1.0.45
rand-0.9.4
rand_chacha-0.9.0
rand_core-0.9.5
r-efi-5.3.0
r-efi-6.0.0
regex-1.12.3
regex-automata-0.4.14
regex-syntax-0.8.10
ring-0.17.14
rustix-1.1.4
rustls-0.23.40
rustls-native-certs-0.8.3
rustls-pki-types-1.14.1
rustls-webpki-0.103.13
rustversion-1.0.22
schannel-0.1.29
security-framework-3.7.0
security-framework-sys-2.17.0
semver-1.0.28
serde-1.0.228
serde_core-1.0.228
serde_derive-1.0.228
serde_json-1.0.149
shlex-1.3.0
slab-0.4.12
smallvec-1.15.1
socket2-0.5.10
socket2-0.6.3
subtle-2.6.1
syn-2.0.117
sync_wrapper-1.0.2
target-lexicon-0.13.5
tempfile-3.27.0
tokio-1.52.2
tokio-macros-2.7.0
tokio-rustls-0.26.4
tokio-stream-0.1.18
tokio-util-0.7.18
tonic-0.13.1
tonic-build-0.13.1
tower-0.5.3
tower-layer-0.3.3
tower-service-0.3.3
tracing-0.1.44
tracing-attributes-0.1.31
tracing-core-0.1.36
try-lock-0.2.5
unicode-ident-1.0.24
unicode-xid-0.2.6
unindent-0.2.4
untrusted-0.9.0
uuid-1.23.1
want-0.3.1
wasi-0.11.1+wasi-snapshot-preview1
wasip2-1.0.3+wasi-0.2.9
wasip3-0.4.0+wasi-0.3.0-rc-2026-01-06
wasm-bindgen-0.2.120
wasm-bindgen-macro-0.2.120
wasm-bindgen-macro-support-0.2.120
wasm-bindgen-shared-0.2.120
wasm-encoder-0.244.0
wasm-metadata-0.244.0
wasmparser-0.244.0
windows_aarch64_gnullvm-0.52.6
windows_aarch64_msvc-0.52.6
windows_i686_gnu-0.52.6
windows_i686_gnullvm-0.52.6
windows_i686_msvc-0.52.6
windows-link-0.2.1
windows-sys-0.52.0
windows-sys-0.61.2
windows-targets-0.52.6
windows_x86_64_gnu-0.52.6
windows_x86_64_gnullvm-0.52.6
windows_x86_64_msvc-0.52.6
wit-bindgen-0.51.0
wit-bindgen-0.57.1
wit-bindgen-core-0.51.0
wit-bindgen-rust-0.51.0
wit-bindgen-rust-macro-0.51.0
wit-component-0.244.0
wit-parser-0.244.0
zerocopy-0.8.48
zerocopy-derive-0.8.48
zeroize-1.8.2
zmij-1.0.21
"

KEYWORDS="~amd64"
S="${WORKDIR}/python-sdk-${PV}"
SRC_URI="
$(cargo_crate_uris ${CRATES})
https://github.com/pinecone-io/python-sdk/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Pinecone Python SDK"
HOMEPAGE="
	https://github.com/pinecone-io/python-sdk
	https://pypi.org/project/pinecone
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+="
dev doc
ebuild_revision_2
"
RDEPEND+="
	(
		>=dev-python/httpx-0.27[${PYTHON_USEDEP},http2(+)]
		<dev-python/httpx-1.0[${PYTHON_USEDEP},http2(+)]
	)
	dev-python/msgspec[${PYTHON_USEDEP}]
	dev-python/orjson[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	(
		>=dev-util/maturin-1.0[${PYTHON_USEDEP}]
		<dev-util/maturin-2.0[${PYTHON_USEDEP}]
	)
	dev? (
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		dev-python/respx[${PYTHON_USEDEP}]
		dev-util/ruff[${PYTHON_USEDEP}]
	)
	doc? (
		>=dev-python/sphinx-8.0[${PYTHON_USEDEP}]
		>=dev-python/myst-parser-4.0[${PYTHON_USEDEP}]
		dev-python/furo[${PYTHON_USEDEP}]
		dev-python/sphinx-copybutton[${PYTHON_USEDEP}]
		dev-python/sphinx-tabs[${PYTHON_USEDEP}]
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

python_configure() {
	export PROTOC="/usr/lib/protobuf/${PROTOBUF_CPP_SLOT}/bin/protoc"
	abseil-cpp_src_configure
	protobuf_python_configure
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
