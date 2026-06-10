# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="maturin"
PYTHON_COMPAT=( "python3_"{10..14} "pypy3_11" )
RUST_MAX_VER="1.91.1"
RUST_MIN_VER="1.91.1" # LLVM 21.1
RUSTFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"

declare -A GIT_CRATES=(
)

DISABLED_CRATES="
ormsgpack-1.12.2
"

# From "./convert-cargo-lock.sh 1.12.2 1.12.2"
CRATES="
ahash-0.8.12
autocfg-1.5.1
bytecount-0.6.9
cfg-if-1.0.4
chrono-0.4.45
crunchy-0.2.4
half-2.7.1
itoa-1.0.18
libc-0.2.186
memoffset-0.9.1
num-traits-0.2.19
once_cell-1.21.4
portable-atomic-1.13.1
proc-macro2-1.0.106
pyo3-0.27.2
pyo3-build-config-0.27.2
pyo3-ffi-0.27.2
quote-1.0.45
serde-1.0.228
serde_bytes-0.11.19
serde_core-1.0.228
serde_derive-1.0.228
simdutf8-0.1.5
smallvec-1.15.1
syn-2.0.117
target-lexicon-0.13.5
unicode-ident-1.0.24
version_check-0.9.5
zerocopy-0.8.52
zerocopy-derive-0.8.52
"

inherit cargo distutils-r1 lcnr pypi rustflags-hardened

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
$(cargo_crate_uris ${CRATES})
https://github.com/ormsgpack/ormsgpack/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Fast, correct Python msgpack library supporting dataclasses, datetimes, and numpy"
HOMEPAGE="
	https://github.com/ormsgpack/ormsgpack
	https://pypi.org/project/ormsgpack
"
LICENSE="
	|| (
		Apache-2.0
		MIT
	)
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
# lto is upstream default
IUSE+=" dev doc lto numpy"
RDEPEND+="
	numpy? (
		virtual/numpy[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/maturin-1.0[${PYTHON_USEDEP}]
	<dev-python/maturin-2.0[${PYTHON_USEDEP}]
	dev? (
		dev-python/msgpack[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/mypy[${PYTHON_USEDEP}]
		' python3_{10..14})
		dev-python/pendulum[${PYTHON_USEDEP}]
		dev-python/pydantic[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-benchmark[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		dev-python/ruff[${PYTHON_USEDEP}]
		dev-python/types-python-dateutil[${PYTHON_USEDEP}]
		dev-python/types-pytz[${PYTHON_USEDEP}]
		dev-python/tzdata[${PYTHON_USEDEP}]
	)
	doc? (
		dev-python/furo[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )

pkg_setup() {
	python_setup
	rust_pkg_setup
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

src_configure() {
	if ! use lto ; then
		sed -i -e "/lto/d" "Cargo.toml" || ie
	fi
	export CARGO_TERM_VERBOSE="true"
	rustflags-hardened_append
}

python_compile() {
	export PYTHON_SYS_EXECUTABLE="${PYTHON}"
	local pypv="${EPYTHON}"
	pypv="${pypv/./}"
	pypv="${pypv/python/}"

	export BUILD_DIR="${WORKDIR}/${PN}-${PV}"
	export S="${WORKDIR}/${PN}-${PV}"
	distutils-r1_python_compile

	local wheel_path=$(realpath "${WORKDIR}/${P}/target/wheels/${P}-cp${pypv}-cp${pypv}-linux_"*".whl")
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
	dodoc "LICENSE-APACHE"
	dodoc "LICENSE-MIT"

	LCNR_SOURCE="${WORKDIR}/cargo_home/gentoo"
	LCNR_TAG="third_party"
        lcnr_install_files
}

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
