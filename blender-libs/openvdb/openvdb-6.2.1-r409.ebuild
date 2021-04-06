# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6..9} )

inherit cmake flag-o-matic python-single-r1

DESCRIPTION="Library for the efficient manipulation of volumetric data"
HOMEPAGE="https://www.openvdb.org"
LICENSE="MPL-2.0"
KEYWORDS="~amd64 ~x86"
CXXABI=11
LLVM_V=11 # originally 9, do not exceed LLVM_MAX_SLOT in mesa stable
SLOT_MAJ="4"
SLOT="${SLOT_MAJ}/${PVR}"
# python is enabled upstream
IUSE+=" +abi4-compat +blosc doc egl +jemalloc -log4cplus -numpy -openexr \
-python +static-libs tbb test -vdb_lod +vdb_print -vdb_render -vdb_view"
# Blender disables python
# See https://github.com/blender/blender/blob/master/build_files/build_environment/cmake/openvdb.cmake
# Prevent file collisions also with ABI masks
VDB_UTILS="vdb_lod vdb_print vdb_render vdb_view"
REQUIRED_USE+="
	!python
	abi4-compat
	jemalloc? ( || ( test ${VDB_UTILS} ) )
	python? ( ${PYTHON_REQUIRED_USE} )
	vdb_render? ( openexr )"
# For dependencies, see
# https://github.com/AcademySoftwareFoundation/openvdb/blob/v6.2.1/doc/dependencies.txt
# https://github.com/AcademySoftwareFoundation/openvdb/blob/v6.2.1/ci/install.sh
# Assumes U 16.04
DEPEND+="
	>=blender-libs/boost-1.61:${CXXABI}=
	>=dev-cpp/tbb-4.46
	>=media-libs/ilmbase-2.2:=
	>=sys-libs/zlib-1.2.7:=
	blosc? ( >=dev-libs/c-blosc-1.5:= )
	jemalloc? ( dev-libs/jemalloc:= )
	log4cplus? ( >=dev-libs/log4cplus-1.1.2:= )
	openexr? ( >=media-libs/openexr-2.2:= )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			>=blender-libs/boost-1.61:'${CXXABI}'=[numpy?,python?,${PYTHON_USEDEP}]
			numpy? ( dev-python/numpy[${PYTHON_USEDEP}] )
		')
	)
	vdb_view? (
		media-libs/glu
		>=media-libs/glfw-3.1
		blender-libs/mesa:${LLVM_V}=
		media-libs/libglvnd
		x11-libs/libX11
		x11-libs/libXcursor
		x11-libs/libXi
		x11-libs/libXinerama
		x11-libs/libXrandr
		x11-libs/libXxf86vm
		egl? (
			>=media-libs/glfw-3.3
			blender-libs/mesa:${LLVM_V}=[egl?]
		)
	)"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	>=dev-util/cmake-3.16.2-r1
	virtual/pkgconfig
	|| (
		>=sys-devel/clang-3.8
		>=sys-devel/gcc-4.8
		>=dev-lang/icc-17
	)
	doc? (
		>=app-doc/doxygen-1.8.8
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
	test? ( >=dev-util/cppunit-1.10 )"
SRC_URI="\
 https://github.com/AcademySoftwareFoundation/${PN}/archive/v${PV}.tar.gz \
	-> ${P}.tar.gz"
PATCHES=( "${FILESDIR}/${P}-fix-multilib-header-source.patch"
	  "${FILESDIR}/${PN}-4.0.2-fix-const-correctness-for-unittest.patch"
	  "${FILESDIR}/${P}-use-gnuinstalldirs.patch" )
RESTRICT="!test? ( test )"

pkg_setup() {
	use python && python-single-r1_pkg_setup

	local jobs=$(echo "${MAKEOPTS}" | grep -P -o -e "(-j|--jobs=)\s*[0-9]+" \
			| sed -r -e "s#(-j|--jobs=)\s*##g")
	local cores=$(nproc)
	if (( ${jobs} > $((${cores}/4)) )) ; then
		ewarn \
"${PN} may lock up or freeze the computer if the N value in MAKEOPTS=\"-jN\" \
is greater than \$(nproc)/4"
	fi
}

src_prepare() {
	cmake_src_prepare
	sed -i -e "s|lib/cmake/glfw|$(get_libdir)/lib/cmake/glfw|g" \
		"cmake/OpenVDBGLFW3Setup.cmake" || die
}

iprfx() {
	echo "${EPREFIX}/usr/$(get_libdir)/blender/${PN}/${SLOT_MAJ}/usr"
}

src_configure() {
	local myprefix="${EPREFIX}/usr/" # for compiling only

	# To stay in sync with blender-libs/boost
	append-cxxflags -std=c++${CXXABI}

	export LD_LIBRARY_PATH=\
"${EROOT}/usr/$(get_libdir)/blender/boost/${CXXABI}/usr/$(get_libdir)"
	export BOOST_ROOT=\
"${EROOT}/usr/$(get_libdir)/blender/boost/${CXXABI}/usr"

	local mycmakeargs=(
		-DCHOST="${CHOST}"
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
		-DCMAKE_INSTALL_PREFIX="$(iprfx)"
		-DOPENVDB_ABI_VERSION_NUMBER=${SLOT_MAJ}
		-DOPENVDB_BUILD_BINARIES=$(usex vdb_lod ON $(usex vdb_print ON \
			$(usex vdb_render ON $(usex vdb_view ON OFF))))
		-DOPENVDB_BUILD_DOCS=$(usex doc)
		-DOPENVDB_BUILD_PYTHON_MODULE=$(usex python)
		-DOPENVDB_BUILD_UNITTESTS=$(usex test)
		-DOPENVDB_BUILD_VDB_LOD=$(usex vdb_lod)
		-DOPENVDB_BUILD_VDB_PRINT=$(usex vdb_print)
		-DOPENVDB_BUILD_VDB_RENDER=$(usex vdb_render)
		-DOPENVDB_BUILD_VDB_VIEW=$(usex vdb_view)
		-DOPENVDB_CORE_STATIC=$(usex static-libs)
		-DOPENVDB_ENABLE_RPATH=OFF
		-DUSE_BLOSC=$(usex blosc)
		-DUSE_EXR=$(use openexr)
		-DUSE_LOG4CPLUS=$(usex log4cplus)
	)

	if use vdb_view ; then
		export CMAKE_INCLUDE_PATH=\
"${EROOT}/usr/include;${CMAKE_INCLUDE_PATH}"
		export CMAKE_LIBRARY_PATH=\
"${EROOT}/usr/$(get_libdir);${CMAKE_LIBRARY_PATH}"

		mycmakeargs+=(
			-DOpenGL_GL_PREFERENCE=GLVND
			-DOPENGL_egl_LIBRARY=/usr/$(get_libdir)/libEGL.so
			-DOPENGL_glx_LIBRARY=/usr/$(get_libdir)/libGLX.so
			-DOPENGL_opengl_LIBRARY=/usr/$(get_libdir)/libOpenGL.so
		)
	fi

	if use python ; then
		mycmakeargs+=(
			-DPYOPENVDB_INSTALL_DIRECTORY="$(python_get_sitedir)"
			-DUSE_NUMPY=$(usex numpy)
		)
	fi
	use test && mycmakeargs+=( -DCPPUNIT_LOCATION="${myprefix}" )

	cmake_src_configure
}

src_install() {
	cmake_src_install
	mv "${ED}/usr/share" "${ED}/$(iprfx)" || die
	docinto licenses
	dodoc LICENSE openvdb/COPYRIGHT
}
