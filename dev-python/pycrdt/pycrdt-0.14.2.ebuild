# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="maturin"
PYTHON_COMPAT=( "python3_"{10..14} )
RUST_MIN_VER="1.93.1"
RUST_MAX_VER="1.93.1" # LLVM 21.1

declare -A GIT_CRATES=(
)

DISABLED_CRATES="
pycrdt-0.14.2
"

# From "./convert-cargo-lock.sh 0.14.2 0.14.2"
CRATES="
arc-swap-1.9.2
async-lock-3.4.2
async-trait-0.1.92
bitflags-2.13.1
bumpalo-3.20.3
cfg-if-1.0.4
crossbeam-utils-0.8.22
dashmap-6.2.1
event-listener-5.4.2
event-listener-strategy-0.5.4
fastrand-2.5.0
futures-task-0.3.34
getrandom-0.4.3
hashbrown-0.14.5
heck-0.5.0
itoa-1.0.18
js-sys-0.3.104
libc-0.2.189
lock_api-0.4.14
memchr-2.8.3
once_cell-1.21.4
parking-2.2.1
parking_lot_core-0.9.12
pin-project-lite-0.2.17
portable-atomic-1.15.0
proc-macro2-1.0.107
pyo3-0.29.2
pyo3-build-config-0.29.2
pyo3-ffi-0.29.2
pyo3-macros-0.29.2
pyo3-macros-backend-0.29.2
quote-1.0.47
redox_syscall-0.5.18
r-efi-6.0.0
rustversion-1.0.23
scopeguard-1.2.0
serde-1.0.229
serde_core-1.0.229
serde_derive-1.0.229
serde_json-1.0.151
smallstr-0.3.1
smallvec-1.15.2
syn-2.0.119
syn-3.0.3
target-lexicon-0.13.5
thiserror-2.0.20
thiserror-impl-2.0.20
unicode-ident-1.0.24
wasm-bindgen-0.2.127
wasm-bindgen-macro-0.2.127
wasm-bindgen-macro-support-0.2.127
wasm-bindgen-shared-0.2.127
windows-link-0.2.1
yrs-0.27.3
zmij-1.0.23
"

inherit cargo distutils-r1 pypi

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
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+="
dev doc test types
ebuild_revision_3
"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/typing_extensions-4.15.0[${PYTHON_USEDEP}]
		<dev-python/typing_extensions-5.0.0[${PYTHON_USEDEP}]

		dev-python/exceptiongroup[${PYTHON_USEDEP}]
	' python3_10)

	>=dev-python/anyio-4.4.0[${PYTHON_USEDEP}]
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
		<dev-python/trio-0.34[${PYTHON_USEDEP}]

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
	#die
	cargo_src_unpack
	if [[ "${GENERATE_LOCKFILE}" != "1" ]] ; then
		cp -aT \
			"${FILESDIR}/${PV}"* \
			"${S}" \
			|| die
	fi
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
