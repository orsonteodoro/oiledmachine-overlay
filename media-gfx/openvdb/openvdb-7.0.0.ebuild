EAPI=6

PYTHON_COMPAT=( python3_{7,8} )

inherit cmake-utils flag-o-matic python-single-r1

DESCRIPTION="Libs for the efficient manipulation of volumetric data"
HOMEPAGE="http://www.openvdb.org"
SRC_URI="https://github.com/AcademySoftwareFoundation/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0/${PV}"
KEYWORDS=""
IUSE="doc python test libglvnd"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=dev-libs/boost-1.70.0
	>=dev-libs/c-blosc-1.5.0
	dev-libs/jemalloc
	dev-libs/log4cplus
	media-libs/glfw
	media-libs/openexr
	sys-libs/zlib:=
	x11-libs/libXcursor
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXrandr
	libglvnd? ( media-libs/libglvnd )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			>=dev-libs/boost-1.70:=[python,${PYTHON_MULTI_USEDEP}]
			dev-python/numpy[${PYTHON_MULTI_USEDEP}]
		')
	)"

DEPEND="${RDEPEND}
	dev-cpp/tbb
	virtual/pkgconfig
	doc? ( app-doc/doxygen[latex] )
	test? ( dev-util/cppunit )"

PATCHES=(
	"${FILESDIR}/${PN}-remesh.patch"
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	sed -i -e "s|DESTINATION doc|DESTINATION share/doc/${P}|g" doc/CMakeLists.txt || die
	sed -i -e "s|DESTINATION lib|DESTINATION $(get_libdir)|g" {,openvdb/}CMakeLists.txt || die
	sed -i -e "s|  lib|  $(get_libdir)|g" openvdb/CMakeLists.txt || die
	sed -i -e "s/MINIMUM_PYTHON_VERSION 2.7/MINIMUM_PYTHON_VERSION 3.7/g" CMakeLists.txt || die
	sed -i -e "s|PC_IlmBase QUIET IlmBase|PC_IlmBase REQUIRED IlmBase|g" cmake/FindIlmBase.cmake || die
	sed -i -e "s|PC_OpenEXR QUIET OpenEXR|PC_OpenEXR REQUIRED OpenEXR|g" cmake/FindOpenEXR.cmake || die
}

src_configure() {
	local myprefix="${EPREFIX}/usr/"

	append-cxxflags -DPY_OPENVDB_USE_NUMPY

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${myprefix}"
		-DOPENVDB_BUILD_PYTHON_MODULE=$(usex python)
		-DOPENVDB_BUILD_DOCS=$(usex doc)
		-DOPENVDB_BUILD_UNITTESTS=$(usex test)
		-DOPENVDB_ENABLE_RPATH=OFF
		-DOPENVDB_CORE_STATIC=OFF
	)

	use python && mycmakeargs+=( -DPYOPENVDB_INSTALL_DIRECTORY="$(python_get_sitedir)" )
	use test && mycmakeargs+=( -DCPPUNIT_LOCATION="${myprefix}" )

	cmake-utils_src_configure

	sed -i "s/isystem/I/g" $(find ${BUILD_DIR} -name flags.make) || die
}
