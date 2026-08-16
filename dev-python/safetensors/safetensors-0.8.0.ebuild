# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="maturin"
PYTHON_COMPAT=( "python3_"{10..14} )
RUST_MAX_VER="1.93.1"
RUST_MIN_VER="1.93.1" # LLVM 21.1
RUSTFLAGS_HARDENED_USE_CASES="security-critical untrusted-data" # You can add ip-assets to RUSTFLAGS_HARDENED_USE_CASES_USER_APPEND

declare -A GIT_CRATES=(
)

DISABLED_CRATES="
safetensors-python-0.8.0
"

# From "./convert-cargo-lock.sh 0.8.0 0.8.0"
CRATES="
allocator-api2-0.2.21
bitflags-2.13.1
block2-0.6.2
cfg-if-1.0.4
dispatch2-0.3.1
equivalent-1.0.2
errno-0.3.14
fastrand-2.5.0
foldhash-0.2.0
getrandom-0.4.3
hashbrown-0.16.1
heck-0.5.0
itoa-1.0.18
libc-0.2.189
linux-raw-sys-0.12.1
memchr-2.8.3
memmap2-0.9.11
objc2-0.6.4
objc2-core-foundation-0.3.2
objc2-encode-4.1.0
objc2-foundation-0.3.2
objc2-metal-0.3.2
once_cell-1.21.4
portable-atomic-1.15.0
proc-macro2-1.0.107
pyo3-0.28.3
pyo3-build-config-0.28.3
pyo3-ffi-0.28.3
pyo3-macros-0.28.3
pyo3-macros-backend-0.28.3
quote-1.0.47
r-efi-6.0.0
rustix-1.1.4
safetensors-0.8.0
serde-1.0.229
serde_core-1.0.229
serde_derive-1.0.229
serde_json-1.0.151
syn-2.0.119
syn-3.0.3
target-lexicon-0.13.5
tempfile-3.27.0
unicode-ident-1.0.24
windows-link-0.2.1
windows-sys-0.61.2
zmij-1.0.23
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
	pinned-tf? (
		numpy
	)
	jax? (
		numpy
	)
	paddlepaddle? (
		numpy
	)
	tensorflow? (
		numpy
	)
	test? (
		numpy
	)
	testingfree? (
		numpy
	)
	torch? (
		numpy
	)
"
RDEPEND+="
	jax? (
		>=dev-python/flax-0.6.3[${PYTHON_USEDEP}]
		>=dev-python/jax-0.3.25[${PYTHON_USEDEP}]
		>=dev-python/jaxlib-0.3.25[${PYTHON_USEDEP}]
	)
	mlx? (
		>=dev-python/mlx-0.0.9[${PYTHON_USEDEP}]
	)
	numpy? (
		virtual/numpy:=[${PYTHON_USEDEP}]
	)
	paddlepaddle? (
		>=dev-python/paddlepaddle-2.4.1[${PYTHON_USEDEP}]
	)
	pinned-tf? (
		~sci-ml/tensorflow-2.18.0[${PYTHON_USEDEP}]
	)
	torch? (
		>=sci-ml/pytorch-1.10[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
	)
	tensorflow? (
		>=sci-ml/tensorflow-2.11.0[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-util/maturin-1.0[${PYTHON_USEDEP}]
	<dev-util/maturin-2.0[${PYTHON_USEDEP}]
	quality? (
		dev-util/ruff
	)
	test? (
		>=dev-python/h5py-3.7.0[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-6.70.2[${PYTHON_USEDEP}]
		>=dev-python/setuptools-rust-1.5.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.2.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-benchmark-4.0.0[${PYTHON_USEDEP}]
		>=sci-ml/huggingface-hub-0.12.1[${PYTHON_USEDEP}]
	)
	testingfree? (
		>=dev-python/hypothesis-6.70.2[${PYTHON_USEDEP}]
		>=dev-python/setuptools-rust-1.5.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.2.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-benchmark-4.0.0[${PYTHON_USEDEP}]
		>=sci-ml/huggingface-hub-0.12.1[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )

src_unpack() {
	unpack ${A}
	#die
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
