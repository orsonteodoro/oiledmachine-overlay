# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="maturin"
PYTHON_COMPAT=( "python3_"{10..12} ) # Upstream tests up to 3.10 but 3.12 needed for Open WebUI
RUST_MAX_VER="1.91.1"
RUST_MIN_VER="1.91.1" # LLVM 21.1
RUSTFLAGS_HARDENED_USE_CASES="security-critical untrusted-data" # You can add ip-assets to RUSTFLAGS_HARDENED_USE_CASES_USER_APPEND

declare -A GIT_CRATES=(
)

DISABLED_CRATES="
safetensors-python-0.7.0
"

# From "./convert-cargo-lock.sh 0.7.0 0.7.0"
CRATES="
aho-corasick-1.1.4
allocator-api2-0.2.21
anes-0.1.6
anstyle-1.0.14
anyhow-1.0.102
autocfg-1.5.1
bitflags-2.13.0
bit-set-0.8.0
bit-vec-0.8.0
bumpalo-3.20.3
cast-0.3.0
cfg-if-1.0.4
ciborium-0.2.2
ciborium-io-0.2.2
ciborium-ll-0.2.2
clap-4.6.1
clap_builder-4.6.0
clap_lex-1.1.0
criterion-0.6.0
criterion-plot-0.5.0
crossbeam-deque-0.8.6
crossbeam-epoch-0.9.18
crossbeam-utils-0.8.21
crunchy-0.2.4
either-1.16.0
equivalent-1.0.2
errno-0.3.14
fastrand-2.4.1
fnv-1.0.7
foldhash-0.1.5
foldhash-0.2.0
futures-core-0.3.32
futures-task-0.3.32
futures-util-0.3.32
getrandom-0.3.4
getrandom-0.4.2
half-2.7.1
hashbrown-0.15.5
hashbrown-0.16.1
hashbrown-0.17.1
heck-0.5.0
id-arena-2.3.0
indexmap-2.14.0
indoc-2.0.7
itertools-0.10.5
itertools-0.13.0
itoa-1.0.18
js-sys-0.3.99
leb128fmt-0.1.0
libc-0.2.186
linux-raw-sys-0.12.1
log-0.4.32
memchr-2.8.1
memmap2-0.9.10
memoffset-0.9.1
num-traits-0.2.19
once_cell-1.21.4
oorandom-11.1.5
pin-project-lite-0.2.17
plotters-0.3.7
plotters-backend-0.3.7
plotters-svg-0.3.7
portable-atomic-1.13.1
ppv-lite86-0.2.21
prettyplease-0.2.37
proc-macro2-1.0.106
proptest-1.11.0
pyo3-0.25.1
pyo3-build-config-0.25.1
pyo3-ffi-0.25.1
pyo3-macros-0.25.1
pyo3-macros-backend-0.25.1
quick-error-1.2.3
quote-1.0.45
rand-0.9.4
rand_chacha-0.9.0
rand_core-0.9.5
rand_xorshift-0.4.0
rayon-1.12.0
rayon-core-1.13.0
r-efi-5.3.0
r-efi-6.0.0
regex-1.12.3
regex-automata-0.4.14
regex-syntax-0.8.10
rustix-1.1.4
rustversion-1.0.22
rusty-fork-0.3.1
safetensors-0.7.0
same-file-1.0.6
semver-1.0.28
serde-1.0.228
serde_core-1.0.228
serde_derive-1.0.228
serde_json-1.0.150
slab-0.4.12
syn-2.0.117
target-lexicon-0.13.5
tempfile-3.27.0
tinytemplate-1.2.1
unarray-0.1.4
unicode-ident-1.0.24
unicode-xid-0.2.6
unindent-0.2.4
wait-timeout-0.2.1
walkdir-2.5.0
wasip2-1.0.3+wasi-0.2.9
wasip3-0.4.0+wasi-0.3.0-rc-2026-01-06
wasm-bindgen-0.2.122
wasm-bindgen-macro-0.2.122
wasm-bindgen-macro-support-0.2.122
wasm-bindgen-shared-0.2.122
wasm-encoder-0.244.0
wasm-metadata-0.244.0
wasmparser-0.244.0
web-sys-0.3.99
winapi-util-0.1.11
windows-link-0.2.1
windows-sys-0.61.2
wit-bindgen-0.51.0
wit-bindgen-0.57.1
wit-bindgen-core-0.51.0
wit-bindgen-rust-0.51.0
wit-bindgen-rust-macro-0.51.0
wit-component-0.244.0
wit-parser-0.244.0
zerocopy-0.8.50
zerocopy-derive-0.8.50
zmij-1.0.21
"

inherit cargo distutils-r1 lcnr pypi rustflags-hardened

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
$(cargo_crate_uris ${CRATES})
https://github.com/safetensors/safetensors/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Simple, safe way to store and distribute tensors"
HOMEPAGE="
	https://github.com/safetensors/safetensors
	https://pypi.org/project/safetensors
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+="
all dev jax mlx numpy paddlepaddle pinned-tf quality tensorflow test testingfree
torch
"
REQUIRED_USE="
	all? (
		jax
		numpy
		paddlepaddle
		pinned-tf
		quality
		test
		torch
	)
	dev? (
		all
	)
	tensorflow? (
		numpy
	)
	torch? (
		numpy
	)
	pinned-tf? (
		numpy
	)
	jax? (
		numpy
	)
	paddlepaddle? (
		numpy
	)
	test? (
		numpy
	)
	testingfree? (
		numpy
	)
"
RDEPEND+="
	numpy? (
		virtual/numpy[${PYTHON_USEDEP}]
	)
	torch? (
		dev-python/packaging[${PYTHON_USEDEP}]
		>=dev-python/torch-1.10[${PYTHON_USEDEP}]
	)
	tensorflow? (
		>=dev-python/tensorflow-2.11.0[${PYTHON_USEDEP}]
	)
	pinned-tf? (
		~dev-python/tensorflow-2.18.0[${PYTHON_USEDEP}]
	)
	jax? (
		>=dev-python/flax-0.6.3[${PYTHON_USEDEP}]
		>=dev-python/jax-0.3.25[${PYTHON_USEDEP}]
		>=dev-python/jaxlib-0.3.25[${PYTHON_USEDEP}]
	)
	mlx? (
		>=dev-python/mlx-0.0.9[${PYTHON_USEDEP}]
	)
	paddlepaddle? (
		>=dev-python/paddlepaddle-2.4.1[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/maturin-1.0[${PYTHON_USEDEP}]
	<dev-python/maturin-2.0[${PYTHON_USEDEP}]
	quality? (
		dev-util/ruff
	)
	test? (
		>=dev-python/h5py-3.7.0[${PYTHON_USEDEP}]
		>=sci-ml/huggingface-hub-0.12.1[${PYTHON_USEDEP}]
		>=dev-python/setuptools-rust-1.5.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.2.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-benchmark-4.0.0[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-6.70.2[${PYTHON_USEDEP}]
	)
	testingfree? (
		>=sci-ml/huggingface-hub-0.12.1[${PYTHON_USEDEP}]
		>=dev-python/setuptools-rust-1.5.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.2.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-benchmark-4.0.0[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-6.70.2[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )

src_unpack() {
	unpack ${A}
	cargo_src_unpack
	cp -aTv \
		"${FILESDIR}/${PV}" \
		"${S}" \
		|| die
}

src_configure() {
	export CARGO_TERM_VERBOSE="true"
	rustflags-hardened_append
	cargo_src_configure
}

python_compile() {
	export PYTHON_SYS_EXECUTABLE="${PYTHON}"
	local pypv="${EPYTHON}"
	pypv="${pypv/./}"
	pypv="${pypv/python/}"
	sed -i \
		-r -e "s|abi3-py[0-9]+|abi3-py${pypv}|g" \
		"${S}/bindings/python/Cargo.toml" \
		|| die

	export BUILD_DIR="${WORKDIR}/${PN}-${PV}/bindings/python"
	cd "${BUILD_DIR}" || die
	distutils-r1_python_compile

	local wheel_path=$(realpath "${WORKDIR}/${PN}-${PV}/bindings/python/target/wheels/${PN}-${PV}-cp${pypv}-abi3-linux_x86_64.whl")
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
