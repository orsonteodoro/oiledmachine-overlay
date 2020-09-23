# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )

inherit cmake flag-o-matic python-single-r1

DESCRIPTION="Library for the efficient manipulation of volumetric data"
HOMEPAGE="https://www.openvdb.org"
SRC_URI="https://github.com/AcademySoftwareFoundation/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
IUSE="+abi5-compat doc python test"
CXXABI=11
LLVM_V=9
SLOT_MAJ="5"
SLOT="${SLOT_MAJ}/${PV}"
KEYWORDS="~amd64 ~x86"
RESTRICT="!test? ( test )"

# Blender disables python
# See https://github.com/blender/blender/blob/master/build_files/build_environment/cmake/openvdb.cmake
# Prevent file collisions also with ABI masks
REQUIRED_USE="
	abi5-compat
	python? ( ${PYTHON_REQUIRED_USE} )
	!python
"

RDEPEND="
	dev-cpp/tbb
	blender-libs/boost:${CXXABI}=
	blender-libs/mesa:${LLVM_V}=
	dev-libs/c-blosc:=
	dev-libs/jemalloc:=
	dev-libs/log4cplus:=
	media-libs/glfw
	media-libs/glu
	media-libs/ilmbase:=
	media-libs/openexr:=
	sys-libs/zlib:=
	x11-libs/libXcursor
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXrandr
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			blender-libs/boost:'${CXXABI}'=[python?,${PYTHON_USEDEP}]
			dev-python/numpy[${PYTHON_USEDEP}]
		')
	)
"

DEPEND="${RDEPEND}"

BDEPEND="
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
	test? ( dev-util/cppunit )
"

PATCHES=(
	"${FILESDIR}/${P}-use-gnuinstalldirs.patch"
	"${FILESDIR}/${P}-use-pkgconfig-for-ilmbase-and-openexr.patch"
	"${FILESDIR}/${PN}-4.0.2-fix-const-correctness-for-unittest.patch"
	"${FILESDIR}/${PN}-4.0.2-fix-build-docs.patch"
)

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

iprfx() {
	echo "${EPREFIX}/usr/$(get_libdir)/blender/${PN}/${SLOT_MAJ}/usr"
}

src_configure() {
	local myprefix="${EPREFIX}/usr/" # for compiling only

	# To stay in sync with blender-libs/boost
	append-cxxflags -std=c++${CXXABI}

	export BOOST_ROOT="${EROOT}/usr/$(get_libdir)/blender/boost/${CXXABI}/usr"

	local mycmakeargs=(
		-DBLOSC_LOCATION="${myprefix}"
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
		-DCMAKE_INSTALL_PREFIX="$(iprfx)"
		-DGLFW3_LOCATION="${myprefix}"
		-DOPENVDB_ABI_VERSION_NUMBER=${SLOT_MAJ}
		-DOPENVDB_BUILD_DOCS=$(usex doc)
		-DOPENVDB_BUILD_PYTHON_MODULE=$(usex python)
		-DOPENVDB_BUILD_UNITTESTS=$(usex test)
		-DOPENVDB_ENABLE_RPATH=OFF
		-DTBB_LOCATION="${myprefix}"
		-DUSE_GLFW3=ON
	)

	if has_version 'blender-libs/mesa:'${LLVM_V}'[libglvnd]' ; then
		einfo "Detected blender-libs/mesa:${LLVM_V}[libglvnd]"
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
	else
		einfo "Detected blender-libs/mesa:${LLVM_V}[-libglvnd]"
		export CMAKE_INCLUDE_PATH=\
"${EROOT}/usr/$(get_libdir)/blender/mesa/${LLVM_V}/usr/include;${CMAKE_INCLUDE_PATH}"
		export CMAKE_LIBRARY_PATH=\
"${EROOT}/usr/$(get_libdir)/blender/mesa/${LLVM_V}/usr/$(get_libdir);${CMAKE_LIBRARY_PATH}"

		mycmakeargs+=(
			-DOpenGL_GL_PREFERENCE=LEGACY
			-DOPENGL_egl_LIBRARY=\
"${EROOT}/usr/$(get_libdir)/blender/mesa/${LLVM_V}/usr/$(get_libdir)/libEGL.so"
			-DOPENGL_gl_LIBRARY=\
"${EROOT}/usr/$(get_libdir)/blender/mesa/${LLVM_V}/usr/$(get_libdir)/libGL.so"
		)
	fi

	use python && mycmakeargs+=( -DPYOPENVDB_INSTALL_DIRECTORY="$(python_get_sitedir)" )
	use test && mycmakeargs+=( -DCPPUNIT_LOCATION="${myprefix}" )

	cmake_src_configure
}

src_install() {
	cmake_src_install
	mv "${ED}/usr/share" "${ED}/$(iprfx)" || die
}
