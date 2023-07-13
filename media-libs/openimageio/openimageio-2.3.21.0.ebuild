# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STD_MIN="14"
LLVM_MAX_SLOT=15
LLVM_SLOTS=( 15 14 13 )
FONT_PN=OpenImageIO
PYTHON_COMPAT=( python3_10 )
inherit cmake font llvm python-single-r1

DESCRIPTION="A library for reading and writing images"
HOMEPAGE="
https://sites.google.com/site/openimageio/
https://github.com/OpenImageIO
"
LICENSE="BSD"
SLOT="0/$(ver_cut 1-2 ${PV})"
KEYWORDS="~amd64 ~ppc64 ~x86"
X86_CPU_FEATURES=(
	avx:avx
	avx2:avx2
	avx512f:avx512f
	f16c:f16c
	sse2:sse2
	sse3:sse3
	sse4_1:sse4.1
	sse4_2:sse4.2
	ssse3:ssse3
)
CPU_FEATURES=( ${X86_CPU_FEATURES[@]/#/cpu_flags_x86_} )
OPENVDB_APIS=( 9 8 7 6 5 )
OPENVDB_APIS_=( ${OPENVDB_APIS[@]/#/abi} )
OPENVDB_APIS_=( ${OPENVDB_APIS_[@]/%/-compat} )
# font install is enabled upstream
# building test enabled upstream
IUSE+="
${CPU_FEATURES[@]%:*}
${OPENVDB_APIS_[@]}
aom avif clang color-management cxx17 dds dicom +doc ffmpeg field3d gif heif icc
jpeg2k opencv opengl openvdb png ptex +python +qt5 raw rav1e tbb +truetype
wayland webp X

r2
"
gen_abi_compat_required_use() {
	local o
	local s
	for s in ${OPENVDB_APIS[@]} ; do
		o+="
			abi${s}-compat? (
				openvdb
			)
		"
	done
	echo "${o}"
}
REQUIRED_USE="
	$(gen_abi_compat_required_use)
	aom? (
		avif
	)
	avif? (
		|| (
			aom
			rav1e
		)
	)
	openvdb? (
		^^ (
			${OPENVDB_APIS_[@]}
		)
		tbb
	)
	python? (
		${PYTHON_REQUIRED_USE}
	)
	rav1e? (
		avif
	)
	tbb? (
		openvdb
	)
"
# See https://github.com/OpenImageIO/oiio/blob/v2.3.21.0/INSTALL.md
QT5_PV="5.6"
ONETBB_SLOT="0"
LEGACY_TBB_SLOT="2"
gen_openvdb_depends() {
	local o
	local s
	for s in ${OPENVDB_APIS[@]} ; do
		o+="
			abi${s}-compat? (
				>=media-gfx/openvdb-${s}[abi${s}-compat]
			)
		"
	done
	echo "${o}"
}

OPENEXR_V2_PV="2.5.8"
OPENEXR_V3_PV="3.1.7 3.1.6 3.1.5 3.1.4"
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

# Depends Oct 23, 2022
RDEPEND+="
	>=dev-cpp/robin-map-0.6.2
	>=dev-libs/boost-1.53:=
	>=dev-libs/libfmt-8.0.0:=
	>=dev-libs/pugixml-1.8:=
	>=media-libs/tiff-3.9:0=
	sys-libs/zlib:=
	virtual/jpeg:0
	color-management? (
		>=media-libs/opencolorio-1.1:=
	)
	dds? (
		>=media-libs/libsquish-1.13
	)
	dicom? (
		>=sci-libs/dcmtk-3.6.1
	)
	ffmpeg? (
		<media-video/ffmpeg-5.2:=
		>=media-video/ffmpeg-3.0:=
	)
	field3d? (
		>=media-libs/Field3D-1.7.3:=
	)
	gif? (
		>=media-libs/giflib-4.1:0=
	)
	heif? (
		>=media-libs/libheif-1.3:=
		avif? (
			>=media-libs/libheif-1.7:=[aom?,rav1e?]
		)
	)
	jpeg2k? (
		>=media-libs/openjpeg-2:2=
	)
	opencv? (
		>=media-libs/opencv-3:=
	)
	opengl? (
		media-libs/glew:=
		virtual/glu
		virtual/opengl
	)
	openvdb? (
		$(gen_openvdb_depends)
		tbb? (
			|| (
				(
					!<dev-cpp/tbb-2021:0=
					<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}=
					>=dev-cpp/tbb-2018:${LEGACY_TBB_SLOT}=
				)
				(
					>=dev-cpp/tbb-2021:${ONETBB_SLOT}=
				)
			)
		)
	)
	png? (
		media-libs/libpng:0=
	)
	ptex? (
		>=media-libs/ptex-2.3.1:=
	)
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-libs/boost:=[python,${PYTHON_USEDEP}]
		')
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
		')
		$(python_gen_cond_dep '
			>=dev-python/pybind11-2.4.2[${PYTHON_USEDEP}]
		')
	)
	qt5? (
		>=dev-qt/qtcore-${QT5_PV}:5
		>=dev-qt/qtgui-${QT5_PV}:5[wayland?,X?]
		>=dev-qt/qtwidgets-${QT5_PV}:5[X?]
		opengl? (
			>=dev-qt/qtopengl-${QT5_PV}:5
		)
		wayland? (
			>=dev-qt/qtwayland-${QT5_PV}:5
		)
	)
	raw? (
		!cxx17? (
			<media-libs/libraw-0.20:=
			>=media-libs/libraw-0.15:=
		)
		cxx17? (
			>=media-libs/libraw-0.20:=
		)
	)
	truetype? (
		media-libs/freetype:2=
	)
	webp? (
		>=media-libs/libwebp-0.6.1:=
	)
	|| (
		$(gen_openexr_pairs)
	)
"
DEPEND+="
	${RDEPEND}
"
gen_bdepend_clang() {
	local o=""
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		o+="
		(
			sys-devel/clang:${s}
			sys-devel/lld:${s}
			sys-devel/llvm:${s}
		)
		"
	done
	echo "${o}"
}
BDEPEND_CLANG="
	$(gen_bdepend_clang)
"
BDEPEND_ICC="
	>=sys-devel/icc-13
"
BDEPEND+="
	>=dev-util/cmake-3.12
	clang? (
		${BDEPEND_CLANG}
	)
	doc? (
		app-doc/doxygen
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
	icc? (
		${BDEPEND_ICC}
	)
	|| (
		${BDEPEND_CLANG}
		${BDEPEND_ICC}
		>=sys-devel/gcc-8.5
	)
"
SRC_URI="
https://github.com/OpenImageIO/oiio/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

DOCS=( CHANGES.md CREDITS.md README.md )
RESTRICT="test" # bug 431412
RESTRICT+=" mirror"
S="${WORKDIR}/oiio-${PV}"

pkg_setup() {
	if use clang && [[ -z "${CC}" || -z "${CXX}" ]] ; then
		export CC="${CHOST}-clang"
		export CXX="${CHOST}-clang++"
		strip-unsupported-flags
	fi
	if test-flags-CXX -std=c++${CXX_STD_MIN} 2>/dev/null 1>/dev/null ; then
		:;
	else
		die "Found unsupported -std=c++${CXX_STD_MIN}"
	fi
	use python && python-single-r1_pkg_setup

	if use icc ; then
		which icc 2>/dev/null 1>/dev/null || die "You must set the PATH to icc as a per-package envvar"
	fi

	if use clang ; then
		llvm_pkg_setup
	fi
	export CC CXX
}

src_prepare() {
	cmake_src_prepare
	cmake_comment_add_subdirectory src/fonts
}

get_tbb_slot() {
	if ! use tbb ; then
		echo "-1"
	elif use openvdb && has_version "<media-gfx/openvdb-9" ; then
		echo ${LEGACY_TBB_SLOT}
	elif has_version ">=dev-cpp/tbb-2021:${ONETBB_SLOT}" ; then
		echo ${ONETBB_SLOT}
	elif has_version "<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}" ; then
		echo ${LEGACY_TBB_SLOT}
	else
		echo "-1"
	fi
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
		-DENABLE_FIELD3D=$(usex field3d)
		-DINSTALL_DOCS=$(usex doc)
		-DINSTALL_FONTS=OFF
		-DOIIO_BUILD_TESTS=OFF # as they are RESTRICTed
		-DSTOP_ON_WARNING=OFF
		-DUSE_CCACHE=OFF
		-DUSE_EXTERNAL_PUGIXML=ON
		-DUSE_PYTHON=$(usex python)
		-DUSE_SIMD=$(local IFS=','; echo "${mysimd[*]}")
		-DUSE_QT=$(usex qt5)

		# No option() but uses custom enablement.
		-DUSE_DCMTK=$(usex dicom)
		-DUSE_JPEGTURBO=ON
		-DUSE_FIELD3D=$(usex field3d)
		-DUSE_FFMPEG=$(usex ffmpeg)
		-DUSE_FREETYPE=$(usex truetype)
		-DUSE_GIF=$(usex gif)
		-DUSE_LIBRAW=$(usex raw)
		-DUSE_LIBSQUISH=$(usex dds)
		-DUSE_NUKE=OFF # not in Gentoo
		-DUSE_OPENJPEG=$(usex jpeg2k)
		-DUSE_OPENCV=$(usex opencv)
		-DUSE_OPENGL=$(usex opengl)
		-DUSE_OPENVDB=$(usex openvdb)
		-DUSE_PNG=$(usex png)
		-DUSE_PTEX=$(usex ptex)
		-DUSE_PYTHON=$(usex python)
		-DUSE_TBB=$(usex tbb)
		-DUSE_WEBP=$(usex webp)
	)

	local set_cxx17=0

	for s in ${OPENVDB_APIS[@]} ; do
		if (( ${s} >= 8 )) ; then
			if use "abi${s}-compat" && usex cxx17 ; then
				set_cxx17=1
				einfo "Using abi${s}-compat and added CMAKE_CXX_STANDARD=17"
				mycmakeargs+=(
					-DCMAKE_CXX_STANDARD=17
				)
			elif use "abi${s}-compat" ; then
				einfo "Using abi${s}-compat and added CMAKE_CXX_STANDARD=14"
				mycmakeargs+=(
					-DCMAKE_CXX_STANDARD=14
				)
			fi
		else
			use "abi${s}-compat" && einfo "Using abi${s}-compat"
		fi
	done

	if use cxx17 && (( ${set_cxx17} == 0 )) ; then
		einfo "Added CMAKE_CXX_STANDARD=17"
		mycmakeargs+=(
			-DCMAKE_CXX_STANDARD=17
		)
	fi

	local use_tbb=$(get_tbb_slot)

	if [[ "${use_tbb}" == "${ONETBB_SLOT}" ]] ; then
		mycmakeargs+=(
			-DTBB_INCLUDE_DIR="${ESYSROOT}/usr/include"
			-DTBB_LIBRARY="${ESYSROOT}/usr/$(get_libdir)"
		)
		sed -i -e "s|tbb/tbb_stddef.h|oneapi/tbb/version.h|g" \
			"src/cmake/modules/FindTBB.cmake" || die
	elif [[ "${use_tbb}" == "${LEGACY_TBB_SLOT}" ]] ; then
		mycmakeargs+=(
			-DTBB_INCLUDE_DIR="${ESYSROOT}/usr/include/tbb/${LEGACY_TBB_SLOT}"
			-DTBB_LIBRARY="${ESYSROOT}/usr/$(get_libdir)/tbb/${LEGACY_TBB_SLOT}"
		)
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

	local use_tbb=$(get_tbb_slot)
	if [[ "${use_tbb}" == "${LEGACY_TBB_SLOT}" ]] ; then
		for f in $(find "${ED}") ; do
			test -L "${f}" && continue
			if ldd "${f}" 2>/dev/null | grep -q -F -e "libtbb" ; then
				einfo "Old rpath for ${f}:"
				patchelf --print-rpath "${f}" || die
				einfo "Setting rpath for ${f}"
				patchelf --set-rpath "${EROOT}/usr/$(get_libdir)/tbb/${LEGACY_TBB_SLOT}" \
					"${f}" || die
			fi
		done
	fi
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  link-to-multislot-tbb
