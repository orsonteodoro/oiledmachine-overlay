# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FONT_PN=OpenImageIO
PYTHON_COMPAT=( python3_{8..10} )
inherit cmake font python-single-r1

DESCRIPTION="A library for reading and writing images"
HOMEPAGE="https://sites.google.com/site/openimageio/ https://github.com/OpenImageIO"
LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="amd64 ~ppc64 x86"
X86_CPU_FEATURES=(
	sse2:sse2 sse3:sse3 ssse3:ssse3 sse4_1:sse4.1 sse4_2:sse4.2
	avx:avx avx2:avx2 avx512f:avx512f f16c:f16c )
CPU_FEATURES=( ${X86_CPU_FEATURES[@]/#/cpu_flags_x86_} )
OPENVDB_APIS=( 5 6 7 8 )
OPENVDB_APIS_=( ${OPENVDB_APIS[@]/#/abi} )
OPENVDB_APIS_=( ${OPENVDB_APIS_[@]/%/-compat} )
# font install is enabled upstream
# building test enabled upstream
IUSE+=" ${CPU_FEATURES[@]%:*} ${OPENVDB_APIS_[@]}
color-management dds dicom +doc ffmpeg field3d gif heif jpeg2k libressl opencv
opengl openvdb ptex +python +qt5 raw ssl tbb +truetype"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )
	openvdb? ( ^^ ( ${OPENVDB_APIS_[@]} ) )"
# See https://github.com/OpenImageIO/oiio/blob/Release-2.2.15.1/INSTALL.md for requirements
QT_V="5.6"
RDEPEND+="
	>=dev-cpp/robin-map-0.6.2
	>=dev-libs/boost-1.53:=
	  dev-libs/pugixml:=
	>=media-libs/ilmbase-2.2.0-r1:=
	  media-libs/libpng:0=
	>=media-libs/libwebp-0.6.1:=
	>=media-libs/openexr-2.0:=
	>=media-libs/tiff-3.9:0=
	sys-libs/zlib:=
	virtual/jpeg:0
	color-management? ( >=media-libs/opencolorio-1.1:= )
	dds? ( >=media-libs/libsquish-1.13 )
	dicom? ( >=sci-libs/dcmtk-3.6.1 )
	ffmpeg? ( >=media-video/ffmpeg-2.6:= )
	field3d? ( >=media-libs/Field3D-1.7.3:= )
	gif? ( >=media-libs/giflib-4.1:0= )
	heif? ( >=media-libs/libheif-1.3:= )
	jpeg2k? ( >=media-libs/openjpeg-2:2= )
	opencv? ( >=media-libs/opencv-2:= )
	opengl? (
		media-libs/glew:=
		virtual/glu
		virtual/opengl
	)
	openvdb? (
		>=dev-cpp/tbb-2018
		>=media-libs/openvdb-5[abi5-compat?,abi6-compat?,abi7-compat?,abi8-compat?]
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
		>=dev-qt/qtcore-${QT_V}:5
		>=dev-qt/qtgui-${QT_V}:5
		>=dev-qt/qtwidgets-${QT_V}:5
		opengl? ( >=dev-qt/qtopengl-${QT_V}:5 )
	)
	raw? ( >=media-libs/libraw-0.15:= )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	truetype? ( media-libs/freetype:2= )"
DEPEND+=" ${RDEPEND}"
BDEPEND+="
	>=dev-util/cmake-3.12
	|| (
		>=sys-devel/gcc-4.8.2
		>=sys-devel/clang-3.3
		>=sys-devel/icc-13
	)
	doc? (
		app-doc/doxygen
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)"
SRC_URI="
https://github.com/OpenImageIO/oiio/archive/Release-${PV}.tar.gz
	-> ${P}.tar.gz"
DOCS=( CHANGES.md CREDITS.md README.md )
RESTRICT="test" # bug 431412
S="${WORKDIR}/oiio-Release-${PV}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	cmake_comment_add_subdirectory src/fonts
}

src_configure() {
	# Build with SIMD support
	local cpufeature
	local mysimd=()
	for cpufeature in "${CPU_FEATURES[@]}"; do
		use "${cpufeature%:*}" && mysimd+=("${cpufeature#*:}")
	done

	# If no CPU SIMDs were used, completely disable them
	[[ -z ${mysimd} ]] && mysimd=("0")

	local mycmakeargs=(
		-DBUILD_DOCS=$(usex doc)
		-DVERBOSE=ON
		-DINSTALL_DOCS=$(usex doc)
		-DINSTALL_FONTS=OFF
		-DOIIO_BUILD_TESTS=OFF # as they are RESTRICTed
		-DSTOP_ON_WARNING=OFF
		-DUSE_CCACHE=OFF
		-DUSE_EXTERNAL_PUGIXML=ON
		-DUSE_PYTHON=$(usex python)
		-DUSE_SIMD=$(local IFS=','; echo "${mysimd[*]}")
		-DUSE_QT=$(usex qt5)
	)

	if use abi5-compat ; then
		ewarn "Using abi5-compat"
	elif use abi6-compat ; then
		ewarn "Using abi6-compat"
	elif use abi7-compat ; then
		ewarn "Using abi7-compat"
	elif use abi8-compat ; then
		einfo "Using abi8-compat and added CMAKE_CXX_STANDARD=14"
		mycmakeargs+=(
			-DCMAKE_CXX_STANDARD=14
		)
	else
		ewarn "One of ${OPENVDB_APIS_[@]} was not set."
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install
	# can't use font_src_install
	# it does directory hierarchy recreation
	FONT_S=(
		"${S}/src/fonts/Droid_Sans"
		"${S}/src/fonts/Droid_Sans_Mono"
		"${S}/src/fonts/Droid_Serif"
	)
	insinto ${FONTDIR}
	for dir in "${FONT_S[@]}"; do
		doins "${dir}"/*.ttf
	done
}
