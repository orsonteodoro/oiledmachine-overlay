# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUSTFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
DISTUTILS_USE_PEP517="maturin"
PYTHON_COMPAT=( "python3_"{11..15} )
RUST_MIN_VER="${RUST_LLVM_ROLLING_PV}"
RUST_MAX_VER="${RUST_LLVM_ROLLING_PV}"
RUSTFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"

declare -A GIT_CRATES=(
)

DISABLED_CRATES="
pycrdt-0.14.13
"

# From "./convert-cargo-lock.sh 0.14.13 0.14.13"
CRATES="
arc-swap-1.9.5
async-lock-3.5.0
async-trait-0.1.92
bitflags-2.13.2
bumpalo-3.20.4
cfg-if-1.0.5
crossbeam-utils-0.8.23
dashmap-6.2.1
event-listener-5.4.2
event-listener-strategy-0.5.4
fastrand-2.5.0
futures-task-0.3.34
getrandom-0.4.3
hashbrown-0.14.5
heck-0.5.0
itoa-1.0.19
js-sys-0.3.107
libc-0.2.191
lock_api-0.4.14
memchr-2.8.3
once_cell-1.21.4
parking-2.2.1
parking_lot_core-0.9.12
pin-project-lite-0.2.18
portable-atomic-1.15.0
proc-macro2-1.0.107
pyo3-0.30.1
pyo3-build-config-0.30.1
pyo3-ffi-0.30.1
pyo3-macros-0.30.1
pyo3-macros-backend-0.30.1
quote-1.0.47
redox_syscall-0.5.18
r-efi-6.0.0
rustversion-1.0.23
scopeguard-1.2.0
serde-1.0.229
serde_core-1.0.229
serde_derive-1.0.229
serde_json-1.0.154
smallstr-0.3.1
smallvec-1.16.6
syn-3.0.10
target-lexicon-0.13.6
thiserror-2.0.21
thiserror-impl-2.0.21
unicode-ident-1.0.27
wasm-bindgen-0.2.130
wasm-bindgen-macro-0.2.130
wasm-bindgen-macro-support-0.2.130
wasm-bindgen-shared-0.2.130
windows-link-0.2.1
yrs-0.28.2
zmij-1.0.23
"

inherit cargo cflags-hardened distutils-r1 pypi rustflags-hardened

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
$(cargo_crate_uris ${CRATES})
https://github.com/y-crdt/pycrdt/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="CRDTs based on Yrs"
HOMEPAGE="
	https://github.com/y-crdt/pycrdt
	https://pypi.org/project/pycrdt
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0"
IUSE+="
dev doc test types
ebuild_revision_8
"
RDEPEND+="
	>=dev-python/anyio-4.14.0[${PYTHON_USEDEP}]
	<dev-python/anyio-5.0.0[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-util/maturin-1.8.2[${PYTHON_USEDEP}]
	<dev-util/maturin-2[${PYTHON_USEDEP}]

	doc? (
		dev-python/mkdocs[${PYTHON_USEDEP}]
		dev-python/mkdocs-material[${PYTHON_USEDEP}]
		dev-python/mkdocstrings[${PYTHON_USEDEP},python(+)]
	)
	test? (
		$(python_gen_cond_dep '
			dev-python/exceptiongroup[${PYTHON_USEDEP}]
		' python3_10)

		>=dev-python/pydantic-2.5.2[${PYTHON_USEDEP}]
		<dev-python/pydantic-3[${PYTHON_USEDEP}]

		>=dev-python/pytest-8.3.5[${PYTHON_USEDEP}]
		<dev-python/pytest-10[${PYTHON_USEDEP}]

		>=dev-python/trio-0.25.1[${PYTHON_USEDEP}]
		<dev-python/trio-0.35[${PYTHON_USEDEP}]

		>=dev-python/coverage-7[${PYTHON_USEDEP},toml(+)]
		dev-python/anyio[${PYTHON_USEDEP}]
	)
	types? (
		>=dev-python/mypy-2.3.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-mypy-testing-0.2.0[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )

src_unpack() {
	unpack ${A}
#	die
	cargo_src_unpack
	if [[ "${GENERATE_LOCKFILE}" != "1" ]] ; then
		cp -aT \
			"${FILESDIR}/${PV}"* \
			"${S}" \
			|| die
	fi
}

src_configure() {
	cflags-hardened_append
	rustflags-hardened_append
	distutils-r1_src_configure
}

python_compile() {
	cargo_src_compile
	S="${WORKDIR}/${PN}-${PV}" \
	distutils-r1_python_compile
}

src_compile() {
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
