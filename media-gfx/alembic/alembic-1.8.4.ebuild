# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# py311 needs imath-3.1.6+, see PR #28265
PYTHON_COMPAT=( python3_{8..11} )

inherit cmake python-single-r1

DESCRIPTION="Open framework for storing and sharing scene data"
HOMEPAGE="https://www.alembic.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="examples hdf5 python test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

OPENEXR_V2="2.5.7 2.5.8"
OPENEXR_V3="3.1.4 3.1.5"
gen_openexr_pairs() {
	local v
	for v in ${OPENEXR_V2} ; do
		echo "
			(
				~media-libs/openexr-${v}:=
				~media-libs/ilmbase-${v}:=
			)
		"
	done
	for v in ${OPENEXR_V3} ; do
		echo "
			(
				~media-libs/openexr-${v}:=
				~dev-libs/imath-${v}:=

			)
		"
	done
}

gen_openexr_py_pairs() {
	local v
	for v in ${OPENEXR_V3} ; do
		echo "
			(
				~media-libs/openexr-${v}:=
				~dev-libs/imath-${v}:=[python,${PYTHON_SINGLE_USEDEP}]
			)
		"
	done
}

RDEPEND="
	${PYTHON_DEPS}
	|| ( $(gen_openexr_pairs) )
	hdf5? (
		>=sci-libs/hdf5-1.10.2:=[zlib(+)]
		>=sys-libs/zlib-1.2.11-r1
	)
	python? (
		$(python_gen_cond_dep 'dev-libs/boost[python,${PYTHON_USEDEP}]')
		|| ( $(gen_openexr_py_pairs) )
	)
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-1.8.0-0001-set-correct-libdir.patch )

DOCS=( ACKNOWLEDGEMENTS.txt FEEDBACK.txt NEWS.txt README.txt )

src_configure() {
	local mycmakeargs=(
		-DALEMBIC_BUILD_LIBS=ON
		-DALEMBIC_DEBUG_WARNINGS_AS_ERRORS=OFF
		-DALEMBIC_SHARED_LIBS=ON
		# currently does nothing but require doxygen
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

	use python && mycmakeargs+=( -DPython3_EXECUTABLE=${PYTHON} )

	cmake_src_configure
}

# Some tests may fail if run in parallel mode.
# See https://github.com/alembic/alembic/issues/401
src_test() {
	cmake_src_test -j1
}
