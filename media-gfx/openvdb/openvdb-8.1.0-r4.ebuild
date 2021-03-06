# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Based on openvdb-7.1.0-r1.ebuild from the gentoo overlay

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit cmake flag-o-matic python-single-r1

DESCRIPTION="Library for the efficient manipulation of volumetric data"
HOMEPAGE="https://www.openvdb.org"
LICENSE="MPL-2.0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
SLOT="0"
IUSE+=" -abi6-compat -abi7-compat +abi8-compat +blosc cpu_flags_x86_avx
cpu_flags_x86_sse4_2 doc egl -imath-half +jemalloc -log4cplus -numpy
-python +static-libs tbb test -vdb_lod +vdb_print -vdb_render -vdb_view"
VDB_UTILS="vdb_lod vdb_print vdb_render vdb_view"
# For abi versions, see https://github.com/AcademySoftwareFoundation/openvdb/blob/v8.1.0/CMakeLists.txt#L205
REQUIRED_USE+="
	^^ ( abi6-compat abi7-compat abi8-compat )
	jemalloc? ( || ( test ${VDB_UTILS} ) )
	numpy? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )
	vdb_render? ( imath-half )"
# See
# https://github.com/AcademySoftwareFoundation/openvdb/blob/v8.1.0/doc/dependencies.txt
# https://github.com/AcademySoftwareFoundation/openvdb/blob/v8.1.0/ci/install.sh
ONETBB_SLOT="12"
DEPEND+="
	|| (
		(
			>=dev-cpp/tbb-2018.0:=
			<dev-cpp/tbb-2021:0=
		)
		(
			>=dev-cpp/tbb-2021:${ONETBB_SLOT}=
		)
	)
	>=dev-libs/boost-1.66:=
	>=media-libs/ilmbase-2.2:=
	>=sys-libs/zlib-1.2.7:=
	blosc? ( >=dev-libs/c-blosc-1.5:= )
	jemalloc? ( dev-libs/jemalloc:= )
	log4cplus? ( >=dev-libs/log4cplus-1.1.2:= )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			>=dev-libs/boost-1.68:=[numpy?,python?,${PYTHON_USEDEP}]
			numpy? ( >=dev-python/numpy-1.14[${PYTHON_USEDEP}] )
		')
	)
	imath-half? (
		>=media-libs/openexr-2.2:=
	)
	vdb_view? (
		media-libs/glu
		>=media-libs/glfw-3.1
		virtual/opengl
		x11-libs/libX11
		x11-libs/libXcursor
		x11-libs/libXi
		x11-libs/libXinerama
		x11-libs/libXrandr
		x11-libs/libXxf86vm
		egl? (
			>=media-libs/glfw-3.3
			media-libs/mesa[egl?]
		)
	)"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	|| (
		>=sys-devel/clang-3.8
		>=sys-devel/gcc-6.3.1
		>=dev-lang/icc-17
	)
	>=dev-util/cmake-3.16.2-r1
	>=sys-devel/bison-3
	>=sys-devel/flex-2.6
	dev-util/patchelf
	virtual/pkgconfig
	doc? (
		>=app-doc/doxygen-1.8.8
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
	test? (
		>=dev-util/cppunit-1.10
		>=dev-cpp/gtest-1.8
	)"
TBB_2021_PATCH="${PN}-5b0ec82.patch"
SRC_URI="
https://github.com/AcademySoftwareFoundation/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/AcademySoftwareFoundation/openvdb/commit/5b0ec82307c603adb147cee4bc1a925d407141f5.patch
	-> ${TBB_2021_PATCH}"
# 5b0ec82 - Changes to support TBB 2021
PATCHES=(
	"${FILESDIR}/${PN}-7.1.0-0001-Fix-multilib-header-source.patch"
)
RESTRICT="!test? ( test )"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	sed -i -e "s|lib/cmake|$(get_libdir)/cmake|g" \
		cmake/OpenVDBGLFW3Setup.cmake || die
	if has_version ">=dev-cpp/tbb-2021" ; then
		eapply "${DISTDIR}/${TBB_2021_PATCH}"
		eapply "${FILESDIR}/openvdb-8.1.0-findtbb-more-debug-messages.patch"
		eapply "${FILESDIR}/openvdb-8.1.0-prioritize-onetbb.patch"
	fi
}

src_configure() {
	local myprefix="${EPREFIX}/usr/"

	local version
	if use abi6-compat; then
		version=6
	elif use abi7-compat; then
		version=7
	elif use abi8-compat; then
		version=8
	else
		die "Openvdb abi version is not compatible"
	fi

	local mycmakeargs=(
		-DCHOST="${CHOST}"
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}/"
		-DCONCURRENT_MALLOC=$(usex jemalloc "Jemalloc" \
			$(usex tbb "Tbbmalloc" "None"))
		-DOPENVDB_ABI_VERSION_NUMBER="${version}"
		-DOPENVDB_BUILD_BINARIES=$(usex vdb_lod ON $(usex vdb_print ON \
			$(usex vdb_render ON $(usex vdb_view ON OFF))))
		-DOPENVDB_BUILD_DOCS=$(usex doc)
		-DOPENVDB_BUILD_PYTHON_MODULE=$(usex python)
		-DOPENVDB_BUILD_UNITTESTS=$(usex test)
		-DOPENVDB_BUILD_VDB_LOD=$(usex vdb_lod)
		-DOPENVDB_BUILD_VDB_PRINT=$(usex vdb_print)
		-DOPENVDB_BUILD_VDB_RENDER=$(usex vdb_render)
		-DOPENVDB_BUILD_VDB_VIEW=$(usex vdb_view)
		-DOPENVDB_CORE_SHARED=ON
		-DOPENVDB_CORE_STATIC=$(usex static-libs)
		-DOPENVDB_ENABLE_RPATH=OFF
		-DUSE_BLOSC=$(usex blosc)
		-DUSE_CCACHE=OFF
		-DUSE_COLORED_OUTPUT=ON
		-DUSE_IMATH_HALF=$(usex imath-half)
		-DUSE_LOG4CPLUS=$(usex log4cplus)
	)

	if use python; then
		mycmakeargs+=(
			-DPYOPENVDB_INSTALL_DIRECTORY="$(python_get_sitedir)"
			-DPython_EXECUTABLE="${PYTHON}"
			-DUSE_NUMPY=$(usex numpy)
		)
	fi

	if use cpu_flags_x86_avx; then
		mycmakeargs+=( -DOPENVDB_SIMD=AVX )
	elif use cpu_flags_x86_sse4_2; then
		mycmakeargs+=( -DOPENVDB_SIMD=SSE42 )
	fi

	if has_version "dev-cpp/tbb:${ONETBB_SLOT}" ; then
		einfo "Using oneTBB"
		mycmakeargs+=(
			-DUSE_PKGCONFIG=ON
			-DTBB_FORCE_ONETBB=ON
		)
	fi

	cmake_src_configure
}

src_install()
{
	cmake_src_install
	dodoc README.md
	docinto licenses
	dodoc LICENSE openvdb/openvdb/COPYRIGHT
	if has_version "dev-cpp/tbb:${ONETBB_SLOT}" ; then
		for f in $(find "${ED}") ; do
			if readelf -h "${f}" 2>/dev/null 1>/dev/null && test -x "${f}" ; then
				einfo "Setting rpath for ${f}"
				patchelf --set-rpath "/usr/$(get_libdir)/oneTBB/${ONETBB_SLOT}" \
					"${f}" || die
			fi
		done
	fi
}
