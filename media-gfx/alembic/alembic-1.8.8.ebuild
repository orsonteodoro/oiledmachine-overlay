# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24, VFX CY2024

CFLAGS_HARDENED_USE_CASES="untrusted-data"
OPENEXR_V3_PV=(
	# openexr:imath
	"3.3.5:3.1.12"
	"3.3.4:3.1.12"
	"3.3.3:3.1.12"
	"3.3.2:3.1.12"
	"3.3.1:3.1.12"
	"3.3.0:3.1.11"
	"3.2.4:3.1.10"
	"3.2.3:3.1.10"
	"3.2.2:3.1.9"
	"3.2.1:3.1.9"
	"3.2.0:3.1.9"
	"3.1.13:3.1.9"
	"3.1.12:3.1.9"
	"3.1.11:3.1.9"
	"3.1.10:3.1.9"
	"3.1.9:3.1.9"
	"3.1.8:3.1.8"
	"3.1.7:3.1.7"
	"3.1.6:3.1.5"
	"3.1.5:3.1.5"
	"3.1.4:3.1.4"
)
PYTHON_COMPAT=( "python3_"{8..11} )

inherit cflags-hardened cmake python-single-r1

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
SLOT="0"
IUSE="
examples hdf5 python test
ebuild_revision_1
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"
RESTRICT="
	!test? (
		test
	)
"
gen_openexr_pairs() {
	local row
	for row in ${OPENEXR_V3_PV[@]} ; do
		local imath_pv="${row#*:}"
		local openexr_pv="${row%:*}"
		echo "
			(
				~media-libs/openexr-${openexr_pv}:=
				media-libs/openexr:=
				~dev-libs/imath-${imath_pv}:=
				dev-libs/imath:=
			)
		"
	done
}
gen_openexr_py_pairs() {
	local row
	for row in ${OPENEXR_V3_PV[@]} ; do
		local imath_pv="${row#*:}"
		local openexr_pv="${row%:*}"
		echo "
			(
				~media-libs/openexr-${openexr_pv}:=
				media-libs/openexr:=
				~dev-libs/imath-${imath_pv}:=[${PYTHON_SINGLE_USEDEP},python]
				dev-libs/imath:=
			)
		"
	done
}
RDEPEND+="
	${PYTHON_DEPS}
	hdf5? (
		(
			>=sci-libs/hdf5-1.8.9:=[zlib(+)]
			sci-libs/hdf5:=
		)
		>=sys-libs/zlib-1.3
	)
	python? (
		$(python_gen_cond_dep '
			>=dev-libs/boost-1.55.0[${PYTHON_USEDEP},python]
			dev-python/numpy[${PYTHON_USEDEP}]
		')
		|| (
			$(gen_openexr_py_pairs)
		)
	)
	|| (
		$(gen_openexr_pairs)
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-build/cmake-3.13
	python? (
		$(python_gen_cond_dep '
			dev-python/setuptools[${PYTHON_USEDEP}]
		')
	)
"
PATCHES=(
)
DOCS=( "ACKNOWLEDGEMENTS.txt" "FEEDBACK.txt" "NEWS.txt" "README.txt" )

src_configure() {
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
