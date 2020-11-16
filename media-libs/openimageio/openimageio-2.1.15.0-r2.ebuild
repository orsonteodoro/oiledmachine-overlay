# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit cmake python-single-r1

DESCRIPTION="A library for reading and writing images"
HOMEPAGE="https://sites.google.com/site/openimageio/ https://github.com/OpenImageIO"
SRC_URI="https://github.com/OpenImageIO/oiio/archive/Release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"

X86_CPU_FEATURES=(
	sse2:sse2 sse3:sse3 ssse3:ssse3 sse4_1:sse4.1 sse4_2:sse4.2
	avx:avx avx2:avx2 avx512f:avx512f f16c:f16c
)
CPU_FEATURES=( ${X86_CPU_FEATURES[@]/#/cpu_flags_x86_} )

IUSE="abi5-compat abi6-compat abi7-compat color-management dds dicom doc ffmpeg field3d gif heif jpeg2k libressl opencv opengl openvdb ptex python qt5 raw ssl tbb +truetype ${CPU_FEATURES[@]%:*}"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )
	openvdb? ( ^^ ( abi5-compat abi6-compat abi7-compat ) )
"

RESTRICT="test" # bug 431412

# See https://github.com/OpenImageIO/oiio/blob/Release-2.1.15.0/INSTALL.md for requirements
BDEPEND="
	>=dev-util/cmake-3.12
	doc? (
		app-doc/doxygen
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
"
RDEPEND="
	>=dev-libs/boost-1.53:=
	  dev-libs/pugixml:=
	>=dev-cpp/robin-map-0.6.2
	>=media-libs/ilmbase-2.2.0-r1:=
	  media-libs/libpng:0=
	>=media-libs/libwebp-0.2.1:=
	>=media-libs/openexr-2.0:=
	>=media-libs/tiff-3.9:0=
	sys-libs/zlib:=
	virtual/jpeg:0
	color-management? ( media-libs/opencolorio:= )
	dds? ( >=media-libs/libsquish-1.13 )
	dicom? ( sci-libs/dcmtk )
	ffmpeg? ( >=media-video/ffmpeg-2.6:= )
	field3d? ( media-libs/Field3D:= )
	gif? ( >=media-libs/giflib-4.1:0= )
	heif? ( >=media-libs/libheif-1.3:= )
	jpeg2k? ( >=media-libs/openjpeg-1.5:0= )
	opencv? ( >=media-libs/opencv-2:= )
	opengl? (
		media-libs/glew:=
		virtual/glu
		virtual/opengl
	)
	openvdb? (
		>=dev-cpp/tbb-2018
		>=media-libs/openvdb-5[abi5-compat?,abi6-compat?,abi7-compat?]
	)
	ptex? ( media-libs/ptex:= )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-libs/boost:=[python,${PYTHON_MULTI_USEDEP}]
		')
		$(python_gen_cond_dep '
			>=dev-python/pybind11-2.4.2[${PYTHON_MULTI_USEDEP}]
		')
	)
	qt5? (
		>=dev-qt/qtcore-5.6:5
		>=dev-qt/qtgui-5.6:5
		>=dev-qt/qtwidgets-5.6:5
		opengl? ( >=dev-qt/qtopengl-5.6:5 )
	)
	raw? ( >=media-libs/libraw-0.15:= )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	truetype? ( media-libs/freetype:2= )
"
DEPEND="${RDEPEND}"

DOCS=( CHANGES.md CREDITS.md README.md )

PATCHES=(
	"${FILESDIR}/${PN}-2.1.15.0-longitude-spelling.patch"
)

S="${WORKDIR}/oiio-Release-${PV}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	cmake_comment_add_subdirectory src/fonts
}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_DOCS=$(usex doc)
		-DOIIO_BUILD_TESTS=OFF # as they are RESTRICTed
		-DSTOP_ON_WARNING=OFF
	)

	cmake_src_configure
}
