# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Based on openvdb-7.1.0-r1.ebuild from the gentoo overlay

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit cmake flag-o-matic python-single-r1

DESCRIPTION="Library for the efficient manipulation of volumetric data"
HOMEPAGE="https://www.openvdb.org"
SRC_URI="https://github.com/AcademySoftwareFoundation/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE+=" -abi6-compat +abi7-compat +blosc cpu_flags_x86_avx \
cpu_flags_x86_sse4_2 doc egl +jemalloc -log4cplus -numpy -openexr -python \
static-libs tbb test -vdb_lod +vdb_print -vdb_render -vdb_view"
RESTRICT="!test? ( test )"

VDB_UTILS="vdb_lod vdb_print vdb_render vdb_view"
REQUIRED_USE+="
	^^ ( abi6-compat abi7-compat )
	jemalloc? ( || ( test ${VDB_UTILS} ) )
	numpy? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )
	vdb_render? ( openexr )
"

# See
# https://github.com/AcademySoftwareFoundation/openvdb/blob/v7.1.0/doc/dependencies.txt
# https://github.com/AcademySoftwareFoundation/openvdb/blob/v7.1.0/ci/install.sh

DEPEND+="
	>=dev-cpp/tbb-2017.6
	>=dev-libs/boost-1.61:=
	>=media-libs/ilmbase-2.2:=
	>=sys-libs/zlib-1.2.7:=
	blosc? ( >=dev-libs/c-blosc-1.5:= )
	jemalloc? ( dev-libs/jemalloc:= )
	log4cplus? ( >=dev-libs/log4cplus-1.1.2:= )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			>=dev-libs/boost-1.68:=[numpy?,python?,${PYTHON_USEDEP}]
			numpy? ( dev-python/numpy[${PYTHON_USEDEP}] )
		')
	)
	openexr? (
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
	virtual/pkgconfig
	doc? (
		>=app-doc/doxygen-1.8.8
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
	test? ( >=dev-util/cppunit-1.10 )"
PATCHES=(
	"${FILESDIR}/${P}-0001-Fix-multilib-header-source.patch"
	"${FILESDIR}/${P}-0002-Fix-doc-install-dir.patch"
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	sed -i -e "s|lib/cmake|$(get_libdir)/cmake|g" \
		cmake/OpenVDBGLFW3Setup.cmake || die
}

src_configure() {
	local myprefix="${EPREFIX}/usr/"

	local version
	if use abi6-compat; then
		version=6
	elif use abi7-compat; then
		version=7
	else
		die "Openvdb abi version is not compatible"
	fi

	local mycmakeargs=(
		-DCHOST="${CHOST}"
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}/"
		-DCONCURRENT_MALLOC=$(usex jemalloc "Jemalloc" $(usex tbb "Tbbmalloc" "None"))
		-DOPENVDB_ABI_VERSION_NUMBER="${version}"
		-DOPENVDB_BUILD_BINARIES=$(usex vdb_lod ON $(usex vdb_print ON $(usex vdb_render ON $(usex vdb_view ON OFF))))
		-DOPENVDB_BUILD_DOCS=$(usex doc)
		-DOPENVDB_BUILD_UNITTESTS=$(usex test)
		-DOPENVDB_BUILD_VDB_LOD=$(usex vdb_lod)
		-DOPENVDB_BUILD_VDB_PRINT=$(usex vdb_print)
		-DOPENVDB_BUILD_VDB_RENDER=$(usex vdb_render)
		-DOPENVDB_BUILD_VDB_VIEW=$(usex vdb_view)
		-DOPENVDB_CORE_SHARED=ON
		-DOPENVDB_CORE_STATIC=$(usex static-libs)
		-DOPENVDB_ENABLE_RPATH=OFF
		-DUSE_CCACHE=OFF
		-DUSE_COLORED_OUTPUT=ON
		-DUSE_BLOSC=$(usex blosc)
		-DUSE_EXR=$(usex openexr)
		-DUSE_LOG4CPLUS=$(usex log4cplus)
		-DUSE_NUMPY=$(usex numpy)
	)

	if use python; then
		mycmakeargs+=(
			-DOPENVDB_BUILD_PYTHON_MODULE=ON
			-DUSE_NUMPY=$(usex numpy)
			-DPYOPENVDB_INSTALL_DIRECTORY="$(python_get_sitedir)"
			-DPython_EXECUTABLE="${PYTHON}"
		)
	fi

	if use cpu_flags_x86_avx; then
		mycmakeargs+=( -DOPENVDB_SIMD=AVX )
	elif use cpu_flags_x86_sse4_2; then
		mycmakeargs+=( -DOPENVDB_SIMD=SSE42 )
	fi

	cmake_src_configure
}

src_install()
{
	cmake_src_install
	dodoc README.md
	docinto licenses
	dodoc LICENSE openvdb/COPYRIGHT
}
