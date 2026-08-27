# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24, VFX CY2024

CFLAGS_HARDENED_USE_CASES="security-critical untrusted-data"
CXX_STANDARD=14
PYTHON_COMPAT=( "python3_"{9..14} ) # Same as OpenUSD

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX14[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX14[@]/llvm_slot_}"
)

CHKL_TIMESTAMPS=(
	"media-libs/openexr-9999"
	"sci-libs/hdf5-9999"
)

inherit cflags-hardened chkl cmake libcxx-slot libstdcxx-slot secure-version python-single-r1

KEYWORDS="~amd64 ~arm64"
SRC_URI="
https://github.com/alembic/alembic/archive/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Alembic is an open framework for storing and sharing scene data \
that includes a C++ library, a file format, and client plugins and \
applications."
HOMEPAGE="
	https://www.alembic.io/
	https://github.com/alembic/alembic
"
LICENSE="
	Boost-1.0
	BSD
	custom
"
# custom - search "TO THE FULLEST EXTENT PERMITTED UNDER APPLICABLE LAW"
SOVER=$(ver_cut "1-2" "${PV}")
SLOT="0/${SOVER}"
IUSE="
doc examples hdf5 python test
ebuild_revision_13
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"
RESTRICT="
	!test? (
		test
	)
"
RDEPEND+="
	${PYTHON_DEPS}
	~dev-libs/imath-${IMATH_PV}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${PYTHON_SINGLE_USEDEP}]
	hdf5? (
		>=sci-libs/hdf5-${HDF5_PV}:=[zlib(+)]
		>=virtual/zlib-${ZLIB_PV}:=
	)
	python? (
		$(python_gen_cond_dep '
			>=dev-libs/boost-1.55.0:=[${PYTHON_USEDEP},python]
			virtual/numpy:=[${PYTHON_USEDEP}]
		')
		>=dev-libs/boost-1.55.0:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		>=media-libs/openexr-${OPENEXR_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		~dev-libs/imath-${IMATH_PV}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${PYTHON_SINGLE_USEDEP},python]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-build/cmake-3.29
	python? (
		$(python_gen_cond_dep '
			dev-python/setuptools[${PYTHON_USEDEP}]
		')
	)
"
PATCHES=(
)
DOCS=( "FEEDBACK.txt" "NEWS.txt" "README.txt" )

pkg_setup() {
	python-single-r1_pkg_setup
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	local mycmakeargs=(
		$(usex python "-DPython3_EXECUTABLE=${PYTHON}" "")
		-DALEMBIC_BUILD_LIBS=ON
		-DALEMBIC_DEBUG_WARNINGS_AS_ERRORS=OFF
		-DALEMBIC_SHARED_LIBS=ON
		-DDOCS_PATH=OFF
		-DUSE_ARNOLD=OFF
		-DUSE_BINARIES=ON
		-DUSE_EXAMPLES=$(usex examples)
		-DUSE_HDF5=$(usex hdf5)
		-DUSE_MAYA=OFF
		-DUSE_PRMAN=OFF
		-DUSE_PYALEMBIC=$(usex python)
		-DUSE_TESTS=$(usex test)
	)

	cmake_src_configure
}

# Some tests may fail if run in parallel mode.
# See https://github.com/alembic/alembic/issues/401
src_test() {
	cmake_src_test -j1
}

src_install() {
	cmake_src_install
	use doc && einstalldocs
	docinto "licenses"
	dodoc "THIRD-PARTY.txt"
	dodoc "ACKNOWLEDGEMENTS.txt"
}
