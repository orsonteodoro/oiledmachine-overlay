# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Based on openvdb-7.1.0-r1.ebuild from the gentoo overlay

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit cmake flag-o-matic python-single-r1

DESCRIPTION="Library for the efficient manipulation of volumetric data"
HOMEPAGE="https://www.openvdb.org"
LICENSE="MPL-2.0"
#KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86" # Build time problems
SLOT="0"
OPENVDB_ABIS=( 6 7 8 9 10 )
OPENVDB_ABIS_=( ${OPENVDB_ABIS[@]/#/abi} )
OPENVDB_ABIS_=( ${OPENVDB_ABIS_[@]/%/-compat} )
X86_CPU_FLAGS=( avx sse4_2 )
IUSE+=" ${X86_CPU_FLAGS[@]/#/cpu_flags_x86_}"
IUSE+=" ${OPENVDB_ABIS_[@]} +abi$(ver_cut 1 ${PV})-compat"
IUSE+=" +blosc doc egl -imath-half +jemalloc -log4cplus -numpy -python
+static-libs -tbbmalloc -no-concurrent-malloc test -vdb_lod +vdb_print
-vdb_render -vdb_view"
VDB_UTILS="vdb_lod vdb_print vdb_render vdb_view"
# For abi versions, see https://github.com/AcademySoftwareFoundation/openvdb/blob/v9.0.0/CMakeLists.txt#L256
REQUIRED_USE+="
	^^ ( ${OPENVDB_ABIS_[@]} )
	^^ ( jemalloc tbbmalloc no-concurrent-malloc )
	jemalloc? ( || ( test ${VDB_UTILS} ) )
	numpy? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )
	vdb_render? ( imath-half )"
# See
# https://github.com/AcademySoftwareFoundation/openvdb/blob/v9.0.0/doc/dependencies.txt
# https://github.com/AcademySoftwareFoundation/openvdb/blob/v9.0.0/ci/install.sh
ONETBB_SLOT="0"
LEGACY_TBB_SLOT="2"
DEPEND+="
	|| (
		(
			>=dev-cpp/tbb-2018.0:${LEGACY_TBB_SLOT}=
			 <dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}=
			!<dev-cpp/tbb-2021:0=
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
		>=dev-cpp/gtest-1.10
	)"
SRC_URI="
https://github.com/AcademySoftwareFoundation/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
"
PATCHES=(
	"${FILESDIR}/${PN}-7.1.0-0001-Fix-multilib-header-source.patch"
	"${FILESDIR}/${PN}-8.1.0-glfw-libdir.patch"
	"${FILESDIR}/${PN}-9.0.0-numpy.patch"
	"${FILESDIR}/${PN}-9.0.0-unconditionally-search-Python-interpreter.patch"
)
RESTRICT="!test? ( test )"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	sed -i -e "s|lib/cmake|$(get_libdir)/cmake|g" \
		cmake/OpenVDBGLFW3Setup.cmake || die
	if has_version ">=dev-cpp/tbb-2021:${ONETBB_SLOT}" ; then
		eapply "${FILESDIR}/openvdb-8.1.0-findtbb-more-debug-messages.patch"
		eapply "${FILESDIR}/openvdb-8.1.0-prioritize-onetbb.patch"
	fi
}

src_configure() {
	export MAKEOPTS="-j1" # prevent stall
	local myprefix="${EPREFIX}/usr/"

	local version
	for s in ${OPENVDB_ABIS[@]} ; do
		if use "abi${s}-compat" ; then
			version=${s}
		fi
	done

	local mycmakeargs=(
		-DCHOST="${CHOST}"
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}/"
		-DCONCURRENT_MALLOC=$(usex jemalloc "Jemalloc" \
			$(usex tbbmalloc "Tbbmalloc" "None"))
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

	if has_version ">=dev-cpp/tbb-2021:${ONETBB_SLOT}" ; then
		einfo "Using oneTBB"
		mycmakeargs+=(
			-DUSE_PKGCONFIG=ON
			-DTbb_INCLUDE_DIR=/usr/include
			-DTBB_LIBRARYDIR=/usr/$(get_libdir)
			-DTBB_FORCE_ONETBB=ON
			-DTBB_SLOT=""
		)
	elif has_version "<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}" ; then
		einfo "Legacy TBB"
		mycmakeargs+=(
			-DUSE_PKGCONFIG=ON
			-DTbb_INCLUDE_DIR=/usr/include/tbb/${LEGACY_TBB_SLOT}
			-DTBB_LIBRARYDIR=/usr/$(get_libdir)/tbb/${LEGACY_TBB_SLOT}
			-DTBB_FORCE_ONETBB=OFF
			-DTBB_SLOT="-${LEGACY_TBB_SLOT}"
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
	if has_version ">=dev-cpp/tbb-2021:${ONETBB_SLOT}" ; then
		:;
	elif has_version "<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}" ; then
		for f in $(find "${ED}") ; do
			if readelf -h "${f}" 2>/dev/null 1>/dev/null && test -x "${f}" ; then
				einfo "Setting rpath for ${f}"
				patchelf --set-rpath "/usr/$(get_libdir)/tbb/${LEGACY_TBB_SLOT}" \
					"${f}" || die
			fi
		done
	fi
}
