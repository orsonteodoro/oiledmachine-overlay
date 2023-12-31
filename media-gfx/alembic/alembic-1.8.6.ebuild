# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )

inherit cmake python-single-r1

SRC_URI="https://github.com/alembic/alembic/archive/${PV}.tar.gz -> ${P}.tar.gz"

HOMEPAGE="https://www.alembic.io/"
DESCRIPTION="Alembic is an open framework for storing and sharing scene data \
that includes a C++ library, a file format, and client plugins and \
applications."
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="examples hdf5 python test"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"
RESTRICT="
	!test? (
		test
	)
"
OPENEXR_V2_PV="2.5.8 2.5.4"
OPENEXR_V3_PV="3.1.7 3.1.5 3.1.4"
gen_openexr_pairs() {
	local pv
	for pv in ${OPENEXR_V3_PV} ; do
		echo "
			(
				~media-libs/openexr-${pv}:=
				~dev-libs/imath-${pv}:=
			)
		"
	done
	for pv in ${OPENEXR_V2_PV} ; do
		echo "
			(
				~media-libs/openexr-${pv}:=
				~media-libs/ilmbase-${pv}:=
			)
		"
	done
}
gen_openexr_py_pairs() {
	local pv
	for pv in ${OPENEXR_V3_PV} ; do
		echo "
			(
				~media-libs/openexr-${pv}:=
				~dev-libs/imath-${pv}:=[${PYTHON_SINGLE_USEDEP},python]
			)
		"
	done
}
RDEPEND+="
	${PYTHON_DEPS}
	hdf5? (
		>=sci-libs/hdf5-1.10.2:=[zlib(+)]
		>=sys-libs/zlib-1.2.11-r1
	)
	python? (
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-libs/boost[${PYTHON_USEDEP},python]
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
	>=dev-util/cmake-3.13
	python? (
		$(python_gen_cond_dep '
			dev-python/setuptools
		')
	)
"
PATCHES=( "${FILESDIR}/${PN}-1.8.5-set-correct-libdir.patch" )
DOCS=( ACKNOWLEDGEMENTS.txt FEEDBACK.txt NEWS.txt README.txt )

src_configure() {
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
