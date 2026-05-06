# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="maturin"
PYTHON_COMPAT=( "python3_"{10..14} )
RUST_MIN_VER="1.88.0"
RUST_MAX_VER="1.88.0"

declare -A GIT_CRATES=(
)

DISABLED_CRATES="
pycrdt-0.13.0
"

# From "./convert-cargo-lock.sh 0.13.0 0.13.0"
CRATES="
arc-swap-1.9.1
async-lock-3.4.2
async-trait-0.1.89
bitflags-2.11.1
bumpalo-3.20.2
cfg-if-1.0.4
concurrent-queue-2.5.0
crossbeam-utils-0.8.21
dashmap-6.1.0
event-listener-5.4.1
event-listener-strategy-0.5.4
fastrand-2.4.1
getrandom-0.3.4
hashbrown-0.14.5
heck-0.5.0
itoa-1.0.18
js-sys-0.3.97
libc-0.2.186
lock_api-0.4.14
memchr-2.8.0
once_cell-1.21.4
parking-2.2.1
parking_lot_core-0.9.12
pin-project-lite-0.2.17
portable-atomic-1.13.1
proc-macro2-1.0.106
pyo3-0.28.3
pyo3-build-config-0.28.3
pyo3-ffi-0.28.3
pyo3-macros-0.28.3
pyo3-macros-backend-0.28.3
quote-1.0.45
redox_syscall-0.5.18
r-efi-5.3.0
rustversion-1.0.22
scopeguard-1.2.0
serde-1.0.228
serde_core-1.0.228
serde_derive-1.0.228
serde_json-1.0.149
smallstr-0.3.1
smallvec-1.15.1
syn-2.0.117
target-lexicon-0.13.5
thiserror-2.0.18
thiserror-impl-2.0.18
unicode-ident-1.0.24
wasip2-1.0.3+wasi-0.2.9
wasm-bindgen-0.2.120
wasm-bindgen-macro-0.2.120
wasm-bindgen-macro-support-0.2.120
wasm-bindgen-shared-0.2.120
windows-link-0.2.1
wit-bindgen-0.57.1
yrs-0.26.0
zmij-1.0.21
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
ebuild_revision_1
"
RDEPEND+="
	$(python_gen_cond_dep '
		(
			>=dev-python/typing_extensions-4.15.0[${PYTHON_USEDEP}]
			<dev-python/typing_extensions-5.0.0[${PYTHON_USEDEP}]
		)
		dev-python/exceptiongroup[${PYTHON_USEDEP}]
	' python3_10)
	(
		>=dev-python/anyio-4.4.0[${PYTHON_USEDEP}]
		<dev-python/anyio-5.0.0[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	(
		>=dev-util/maturin-1.8.0[${PYTHON_USEDEP}]
		<dev-util/maturin-2[${PYTHON_USEDEP}]
	)
	doc? (
		dev-python/mkdocs[${PYTHON_USEDEP}]
		dev-python/mkdocs-material[${PYTHON_USEDEP}]
		dev-python/mkdocstrings[${PYTHON_USEDEP},python(+)]
	)
	test? (
		$(python_gen_cond_dep '
			>=dev-python/exceptiongroup[${PYTHON_USEDEP}]
		' python3_10)
		(
			>=dev-python/pydantic-2.5.2[${PYTHON_USEDEP}]
			<dev-python/pydantic-3[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/pytest-8.3.5[${PYTHON_USEDEP}]
			<dev-python/pytest-10[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/trio-0.25.1[${PYTHON_USEDEP}]
			<dev-python/trio-0.34[${PYTHON_USEDEP}]
		)
		>=dev-python/coverage-7[${PYTHON_USEDEP},toml(+)]
		dev-python/anyio[${PYTHON_USEDEP}]
	)
	types? (
		>=dev-python/mypy-1.19.0[${PYTHON_USEDEP}]
		dev-python/pytest-mypy-testing[${PYTHON_USEDEP}]
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
