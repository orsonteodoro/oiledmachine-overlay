# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Protobuf version:  https://github.com/pinecone-io/python-sdk/blob/v10.3.0/.github/workflows/dev-publish.yml#L20
# Upstream uses 28.3 (slot 5)

inherit secure-version

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
DISTUTILS_USE_PEP517="maturin"
PYTHON_COMPAT=( "python3_"{10..15} )
RUST_MAX_VER="${RUST_LLVM_ROLLING_PV}"
RUST_MIN_VER="${RUST_LLVM_ROLLING_PV}"
RUSTFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"

ABSEIL_CPP_SLOT="20240722"
PROTOBUF_CPP_SLOT="5"
PROTOBUF_PYTHON_SLOT="${PROTOBUF_PYTHON_SLOT_5}"

inherit abseil-cpp cargo cflags-hardened distutils-r1 protobuf pypi rustflags-hardened

declare -A GIT_CRATES=(
)

DISABLED_CRATES="
pinecone-grpc-10.3.0
"
# From "./convert-cargo-lock.sh 10.3.0 10.3.0
CRATES="
aho-corasick-1.1.5
anyhow-1.0.104
async-trait-0.1.92
atomic-waker-1.1.2
axum-0.8.9
axum-core-0.5.6
base64-0.22.1
bitflags-2.13.2
bumpalo-3.20.4
bytes-1.12.2
cc-1.11.3
cfg-if-1.0.5
core-foundation-0.10.1
core-foundation-sys-0.8.7
either-1.19.0
equivalent-1.0.3
errno-0.3.15
fastrand-2.5.0
find-msvc-tools-0.1.15
fixedbitset-0.5.9
fnv-1.0.7
futures-channel-0.3.34
futures-core-0.3.34
futures-sink-0.3.34
futures-task-0.3.34
futures-util-0.3.34
getrandom-0.2.17
getrandom-0.3.4
getrandom-0.4.3
h2-0.4.20
hashbrown-0.17.1
heck-0.5.0
http-1.5.0
httparse-1.10.1
http-body-1.1.0
http-body-util-0.1.5
httpdate-1.0.3
hyper-1.12.0
hyper-timeout-0.5.2
hyper-util-0.1.21
indexmap-2.14.2
itertools-0.14.0
itoa-1.0.19
js-sys-0.3.107
libc-0.2.191
linux-raw-sys-0.12.1
log-0.4.35
matchit-0.8.4
memchr-2.8.3
mime-0.3.18
mio-1.2.5
multimap-0.10.1
once_cell-1.21.4
openssl-probe-0.2.2
percent-encoding-2.3.2
petgraph-0.7.1
pin-project-1.2.0
pin-project-internal-1.2.0
pin-project-lite-0.2.18
portable-atomic-1.15.0
ppv-lite86-0.2.21
prettyplease-0.2.37
proc-macro2-1.0.107
prost-0.13.5
prost-build-0.13.5
prost-derive-0.13.5
prost-types-0.13.5
pyo3-0.29.3
pyo3-build-config-0.29.3
pyo3-ffi-0.29.3
pyo3-macros-0.29.3
pyo3-macros-backend-0.29.3
quote-1.0.47
rand-0.9.5
rand_chacha-0.9.0
rand_core-0.9.5
r-efi-5.3.0
r-efi-6.0.0
regex-1.13.2
regex-automata-0.4.19
regex-syntax-0.8.12
ring-0.17.14
rustix-1.1.6
rustls-0.23.46
rustls-native-certs-0.8.5
rustls-pki-types-1.16.0
rustls-webpki-0.103.17
rustversion-1.0.23
schannel-0.1.30
security-framework-3.7.0
security-framework-sys-2.17.0
serde_core-1.0.229
serde_derive-1.0.229
shlex-2.0.1
slab-0.4.12
smallvec-1.16.6
socket2-0.5.10
socket2-0.6.5
subtle-2.6.1
syn-2.0.119
syn-3.0.10
sync_wrapper-1.0.2
target-lexicon-0.13.6
tempfile-3.27.0
tokio-1.54.1
tokio-macros-2.7.2
tokio-rustls-0.26.6
tokio-stream-0.1.19
tokio-util-0.7.20
tonic-0.13.1
tonic-build-0.13.1
tower-0.5.3
tower-layer-0.3.3
tower-service-0.3.3
tracing-0.1.44
tracing-attributes-0.1.31
tracing-core-0.1.36
try-lock-0.2.5
unicode-ident-1.0.27
untrusted-0.9.0
uuid-1.29.3
want-0.3.2
wasi-0.11.1+wasi-snapshot-preview1
wasip2-1.0.4+wasi-0.2.12
wasm-bindgen-0.2.130
wasm-bindgen-macro-0.2.130
wasm-bindgen-macro-support-0.2.130
wasm-bindgen-shared-0.2.130
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
wit-bindgen-0.57.1
zerocopy-0.8.64
zerocopy-derive-0.8.64
zeroize-1.9.2
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
SLOT="0"
IUSE+="
dev doc
ebuild_revision_7
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
	die
	cargo_src_unpack
	cp -aT \
		"${FILESDIR}/${PV}"* \
		"${S}" \
		|| die
}

python_configure() {
	cflags-hardened_append		# For *-sys crates
	rustflags-hardened_append	# For retpoline, int overflow mitigation
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
