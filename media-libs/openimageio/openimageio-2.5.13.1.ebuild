# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Requirements:
# https://github.com/AcademySoftwareFoundation/OpenImageIO/blob/v2.5.13.1/INSTALL.md

CFLAGS_HARDENED_USE_CASES="ip-assets untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE HO SO"
CXX_STD_MIN="14"
FONT_PN="OpenImageIO"
LEGACY_TBB_SLOT="2"
LLVM_COMPAT=( {18..13} )
LLVM_MAX_SLOT="${LLVM_COMPAT[0]}"
ONETBB_SLOT="0"
OPENEXR_V2_PV=(
	# openexr:imath
	"2.5.9:2.5.9"
	"2.5.8:2.5.8"
)
OPENEXR_V3_PV=(
	# openexr:imath
	"3.3.2:3.1.12"
	"3.3.1:3.1.12"
	"3.3.0:3.1.11"
	"3.2.4:3.1.10"
	"3.2.3:3.1.10"
	"3.2.2:3.1.9"
	"3.2.1:3.1.9"
	"3.2.0:3.1.9"
	"3.1.13:3.1.9"
	"3.1.12:3.1.9"
	"3.1.11:3.1.9"
	"3.1.10:3.1.9"
	"3.1.9:3.1.9"
	"3.1.8:3.1.8"
	"3.1.7:3.1.7"
	"3.1.6:3.1.5"
	"3.1.5:3.1.5"
	"3.1.4:3.1.4"
)
OPENVDB_APIS=( {11..5} )
OPENVDB_APIS_=( ${OPENVDB_APIS[@]/#/abi} )
OPENVDB_APIS_=( ${OPENVDB_APIS_[@]/%/-compat} )
PYTHON_COMPAT=( "python3_"{11..12} )
QT5_PV="5.15"
QT6_PV="6.6"
TEST_OEXR_IMAGE_COMMIT="df16e765fee28a947244657cae3251959ae63c00" # committer-date:<=2024-05-01
TEST_OIIO_IMAGE_COMMIT="aae37a54e31c0e719edcec852994d052ecf6541e" # committer-date:<=2024-05-01
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
CPU_FEATURES=( ${X86_CPU_FEATURES[@]/#/cpu_flags_x86_} ) # Place after X86_CPU_FEATURES

inherit cflags-hardened check-compiler-switch cmake flag-o-matic font llvm python-single-r1 virtualx

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/OpenImageIO-${PV}"
SRC_URI="
https://github.com/OpenImageIO/oiio/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	test? (
https://github.com/AcademySoftwareFoundation/openexr-images/archive/${TEST_OEXR_IMAGE_COMMIT}.tar.gz
	-> ${PN}-oexr-test-image-${TEST_OEXR_IMAGE_COMMIT:0:7}.tar.gz
https://github.com/AcademySoftwareFoundation/OpenImageIO-images/archive/${TEST_OIIO_IMAGE_COMMIT}.tar.gz
	-> ${PN}-oiio-test-image-${TEST_OIIO_IMAGE_COMMIT:0:7}.tar.gz
		fits? (
https://www.cv.nrao.edu/fits/data/tests/ftt4b/file001.fits
https://www.cv.nrao.edu/fits/data/tests/ftt4b/file002.fits
https://www.cv.nrao.edu/fits/data/tests/ftt4b/file003.fits
https://www.cv.nrao.edu/fits/data/tests/ftt4b/file009.fits
https://www.cv.nrao.edu/fits/data/tests/ftt4b/file012.fits
https://www.cv.nrao.edu/fits/data/tests/pg93/tst0001.fits
https://www.cv.nrao.edu/fits/data/tests/pg93/tst0003.fits
https://www.cv.nrao.edu/fits/data/tests/pg93/tst0005.fits
https://www.cv.nrao.edu/fits/data/tests/pg93/tst0006.fits
https://www.cv.nrao.edu/fits/data/tests/pg93/tst0007.fits
https://www.cv.nrao.edu/fits/data/tests/pg93/tst0008.fits
https://www.cv.nrao.edu/fits/data/tests/pg93/tst0013.fits
		)
		jpeg2k? (
https://www.itu.int/wftp3/Public/t/testsignal/SpeImage/T803/v2002_11/J2KP4files.zip
		)
	)
"

DESCRIPTION="A library for reading and writing images"
HOMEPAGE="
https://sites.google.com/site/openimageio/
https://github.com/OpenImageIO
"
LICENSE="BSD"

# test is not quite working yet
RESTRICT="
	test
"

RESTRICT+=" mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
# font install is enabled upstream
# building test enabled upstream
IUSE+="
${CPU_FEATURES[@]%:*}
${LLVM_COMPAT[@]/#/llvm_slot_}
${OPENVDB_APIS_[@]}
aom avif clang color-management cuda cxx17 dds dicom +doc ffmpeg field3d fits
gif gui heif icc jpeg2k opencv opengl openvdb png ptex +python qt5 +qt6 raw
rav1e tbb tools +truetype wayland webp X
ebuild_revision_30
"
gen_abi_compat_required_use() {
	local s
	for s in ${OPENVDB_APIS[@]} ; do
		echo "
			abi${s}-compat? (
				openvdb
			)
		"
	done
}
gen_llvm_required_use() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				clang
			)
		"
	done
}
REQUIRED_USE="
	$(gen_abi_compat_required_use)
	$(gen_llvm_required_use)
	aom? (
		avif
	)
	avif? (
		|| (
			aom
			rav1e
		)
	)
	clang? (
		^^ (
			${LLVM_COMPAT[@]/#/llvm_slot_}
		)
	)
	opengl? (
		|| (
			qt5
			qt6
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
	qt5? (
		opengl
	)
	qt6? (
		opengl
	)
	rav1e? (
		avif
	)
	tbb? (
		openvdb
	)
"
gen_openexr_pairs() {
	local row
	for row in ${OPENEXR_V3_PV[@]} ; do
		local imath_pv="${row#*:}"
		local openexr_pv="${row%:*}"
		echo "
			(
				~media-libs/openexr-${openexr_pv}:=
				~dev-libs/imath-${imath_pv}:=
			)
		"
	done
	for row in ${OPENEXR_V2_PV[@]} ; do
		local ilmbase_pv="${row#*:}"
		local openexr_pv="${row%:*}"
		echo "
			(
				~media-libs/openexr-${openexr_pv}:=
				~media-libs/ilmbase-${ilmbase_pv}:=
			)
		"
	done
}

# Depends Mar 16, 2024
RDEPEND+="
	>=dev-cpp/robin-map-0.6.2
	>=dev-libs/boost-1.53:=
	>=dev-libs/libfmt-9.0.0:=
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
		|| (
			media-video/ffmpeg:0/55.57.57
			media-video/ffmpeg:0/56.58.58
			media-video/ffmpeg:0/57.59.59
			media-video/ffmpeg:0/58.60.60
			media-video/ffmpeg:0/59.61.61
		)
		media-video/ffmpeg:=
	)
	field3d? (
		>=media-libs/Field3D-1.7.3:=
	)
	fits? (
		sci-libs/cfitsio:=
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
		abi11-compat? (
			|| (
				=media-gfx/openvdb-13*[abi11-compat]
				=media-gfx/openvdb-12*[abi11-compat]
				=media-gfx/openvdb-11*[abi11-compat]
			)
			media-gfx/openvdb:=
		)
		abi10-compat? (
			|| (
				=media-gfx/openvdb-12*[abi10-compat]
				=media-gfx/openvdb-11*[abi10-compat]
				=media-gfx/openvdb-10*[abi10-compat]
			)
			media-gfx/openvdb:=
		)
		abi9-compat? (
			|| (
				=media-gfx/openvdb-11*[abi9-compat]
				=media-gfx/openvdb-10*[abi9-compat]
				=media-gfx/openvdb-9*[abi9-compat]
			)
			media-gfx/openvdb:=
		)
		abi8-compat? (
			|| (
				=media-gfx/openvdb-10*[abi8-compat]
				=media-gfx/openvdb-9*[abi8-compat]
				=media-gfx/openvdb-8*[abi8-compat]
			)
			media-gfx/openvdb:=
		)
		abi7-compat? (
			|| (
				=media-gfx/openvdb-9*[abi7-compat]
				=media-gfx/openvdb-8*[abi7-compat]
				=media-gfx/openvdb-7*[abi7-compat]
			)
			media-gfx/openvdb:=
		)
		abi6-compat? (
			|| (
				=media-gfx/openvdb-8*[abi6-compat]
				=media-gfx/openvdb-7*[abi6-compat]
				=media-gfx/openvdb-6*[abi6-compat]
			)
			media-gfx/openvdb:=
		)
		abi5-compat? (
			|| (
				=media-gfx/openvdb-7*[abi5-compat]
				=media-gfx/openvdb-6*[abi5-compat]
				=media-gfx/openvdb-5*[abi5-compat]
			)
			media-gfx/openvdb:=
		)
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
			dev-libs/boost:=[${PYTHON_USEDEP},python]
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
	qt6? (
		>=dev-qt/qtbase-${QT6_PV}:6[gui,opengl?,wayland?,widgets,X?]
		wayland? (
			>=dev-qt/qtdeclarative-${QT6_PV}:6[opengl]
			>=dev-qt/qtwayland-${QT6_PV}:6
		)
	)
	raw? (
		!cxx17? (
			<media-libs/libraw-0.20:=
			>=media-libs/libraw-0.18:=
		)
		cxx17? (
			>=media-libs/libraw-0.20:=
		)
	)
	truetype? (
		>=media-libs/freetype-2.8:2=
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
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				llvm-core/clang:${s}
				llvm-core/lld:${s}
				llvm-core/llvm:${s}
			)
		"
	done
}
BDEPEND_CLANG="
	$(gen_bdepend_clang)
"
BDEPEND_ICC="
	>=sys-devel/icc-13
"
BDEPEND+="
	>=dev-build/cmake-3.15
	clang? (
		${BDEPEND_CLANG}
	)
	doc? (
		app-text/doxygen
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
	icc? (
		${BDEPEND_ICC}
	)
	jpeg2k? (
		app-arch/unzip
	)
	|| (
		${BDEPEND_CLANG}
		${BDEPEND_ICC}
		>=sys-devel/gcc-8.5
	)
"
DOCS=( "CHANGES.md" "CREDITS.md" "README.md" )
PATCHES=(
	"${FILESDIR}/${PN}-2.5.8.0-fits.patch"
	"${FILESDIR}/${PN}-2.5.8.0-fix-unit_simd.patch"
	"${FILESDIR}/${PN}-2.5.8.0-fix-tests.patch"
)

_oiio_use() {
	local value=$(usex "${1}")
	local prod_name="${2}"
	local test_name="${3}"
	if use test ; then
		echo -DENABLE_${test_name}="${value}"
	fi
	echo -DUSE_${prod_name}="${value}"
}

pkg_setup() {
	check-compiler-switch_start
	if use clang && [[ -z "${CC}" || -z "${CXX}" ]] ; then
		export CC="${CHOST}-clang"
		export CXX="${CHOST}-clang++"
		export CPP="${CC} -E"
		strip-unsupported-flags
	fi
	if test-flags-CXX -std=c++${CXX_STD_MIN} >/dev/null 2>&1 ; then
		:;
	else
		die "Found unsupported -std=c++${CXX_STD_MIN}"
	fi
	python-single-r1_pkg_setup

	if use icc ; then
		which icc >/dev/null 2>&1 || die "You must set the PATH to icc as a per-package envvar"
	fi

	if use clang ; then
		llvm_pkg_setup
	fi
	export CC CXX
}

src_prepare() {
	if ! use dicom; then
		rm -r \
			"${S}/src/dicom.imageio/" \
			|| die
	fi
	cmake_src_prepare
	cmake_comment_add_subdirectory src/fonts
	if use test ; then
		mv -v \
			"${WORKDIR}/OpenImageIO-images-${TEST_OIIO_IMAGE_COMMIT}" \
			"${WORKDIR}/oiio-images" \
			|| die
		mv -v \
			"${WORKDIR}/openexr-images-${TEST_OEXR_IMAGE_COMMIT}" \
			"${WORKDIR}/openexr-images" \
			|| die
		if use jpeg2k; then
			mv -v \
				"${WORKDIR}/J2KP4files" \
				"${WORKDIR}/j2kp4files_v1_5" \
				|| die
		fi
	fi
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

cuda_host_cc_check() {
	local required_gcc_slot="${1}"
        local gcc_current_profile=$(gcc-config -c)
        local gcc_current_profile_slot=${gcc_current_profile##*-}
        if ver_test "${gcc_current_profile_slot}" -ne "${required_gcc_slot}" ; then
eerror
eerror "You must switch to =sys-devel/gcc-${required_gcc_slot}.  Do"
eerror
eerror "  eselect gcc set ${CHOST}-${required_gcc_slot}"
eerror "  source /etc/profile"
eerror
                die
        fi
}

src_configure() {
	# Avoid missing symbol in oidn
	if use cuda && has_version "=dev-util/nvidia-cuda-toolkit-12*" && has_version "=sys-devel/gcc-13*" ; then
		export CC="${CHOST}-gcc-13"
		export CXX="${CHOST}-g++-13"
		export CPP="${CC} -E"
		cuda_host_cc_check 13
	elif use cuda && has_version "=dev-util/nvidia-cuda-toolkit-12*" && has_version "=sys-devel/gcc-12*" ; then
		export CC="${CHOST}-gcc-12"
		export CXX="${CHOST}-g++-12"
		export CPP="${CC} -E"
		cuda_host_cc_check 12
	elif use cuda && has_version "=dev-util/nvidia-cuda-toolkit-12*" && has_version "=sys-devel/gcc-11*" ; then
		export CC="${CHOST}-gcc-11"
		export CXX="${CHOST}-g++-11"
		export CPP="${CC} -E"
		cuda_host_cc_check 11
	elif use cuda && has_version "=dev-util/nvidia-cuda-toolkit-11.8*" && has_version "=sys-devel/gcc-11*" ; then
		export CC="${CHOST}-gcc-11"
		export CXX="${CHOST}-g++-11"
		export CPP="${CC} -E"
		cuda_host_cc_check 11
	elif use cuda ; then
eerror
eerror "If using"
eerror
eerror "CUDA 12 - install and switch via eselect gcc to either gcc 11, 12, 13"
eerror "CUDA 11 - install and switch via eselect gcc to either gcc 11"
eerror
		die
	fi
	strip-unsupported-flags

	local cpufeature
	local mysimd=()
	for cpufeature in "${CPU_FEATURES[@]}"; do
		use "${cpufeature%:*}" && mysimd+=("${cpufeature#*:}")
	done

	# If no CPU SIMDs were used, completely disable them
	[[ -z ${mysimd} ]] && mysimd=("0")

	#
	# This is currently needed on arm64 to get the NEON SIMD wrapper to
	# compile the code successfully.
	#
	# Even if there are no SIMD features selected, it seems like the code
	# will turn on NEON support if it is available.
	#
	use arm64 && append-flags -flax-vector-conversions

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	cflags-hardened_append

	local has_qt="OFF"
	if use qt5 || use qt6 ; then
		has_qt="ON"
	fi

	local mycmakeargs=(
		-DBUILD_DOCS=$(usex doc)
		-DCMAKE_UNITY_BUILD_MODE="BATCH"
		-DINSTALL_DOCS=$(usex doc)
		-DINSTALL_FONTS="OFF"
		-DOIIO_BUILD_TESTS="OFF" # as they are RESTRICTed
		-DOIIO_BUILD_TOOLS=$(usex tools)
		-DOIIO_DOWNLOAD_MISSING_TESTDATA="OFF"
		-DUNITY_SMALL_BATCH_SIZE="$(nproc)"
		-DUSE_CCACHE="OFF"
		-DUSE_EXTERNAL_PUGIXML="ON"
		-DUSE_PYTHON=$(usex python)
		-DUSE_SIMD=$(local IFS=','; echo "${mysimd[*]}")
		-DUSE_QT=${has_qt}

	# Config update Mar 16, 2024
	# See https://github.com/AcademySoftwareFoundation/OpenImageIO/blob/v2.5.10.1/src/cmake/externalpackages.cmake

	# You must use ENABLE_ for oiio_add_tests in testing.cmake.

		$(_oiio_use gif GIF GIF)
		$(_oiio_use heif LIBHEIF Libheif)
		$(_oiio_use raw LIBRAW LIBRAW)
		$(_oiio_use openvdb OPENVDB OpenVDB)
		$(_oiio_use png PNG PNG)
		$(_oiio_use ptex PTEX PTEX)
		$(_oiio_use webp WEBP WEBP)

		-DUSE_DCMTK=$(usex dicom)
		-DUSE_FIELD3D=$(usex field3d)
		-DUSE_FFMPEG=$(usex ffmpeg)
		-DUSE_FREETYPE=$(usex truetype)
		-DUSE_JPEGTURBO="ON"
		-DUSE_LIBSQUISH=$(usex dds)
		-DUSE_NUKE="OFF" # Ebuild not in distro ebuild ecosystem
		-DUSE_OCIO=$(usex color-management)
		-DUSE_OPENCOLORIO=$(usex color-management)
		-DUSE_OPENCV=$(usex opencv)
		-DUSE_OPENGL=$(usex opengl)
		-DUSE_OPENJPEG=$(usex jpeg2k)
		-DUSE_PYTHON=$(usex python)
		-DUSE_TBB=$(usex tbb)

		-DSTOP_ON_WARNING="OFF"
		-DVERBOSE="ON"
	)

	if is-flagq '-Ofast' || is-flagq '-ffast-math' ; then
		mycmakeargs+=(
			-DUSE_FAST_MATH="ON"
		)
	else
		mycmakeargs+=(
			-DUSE_FAST_MATH="OFF"
		)
	fi

	if use gui ; then
		mycmakeargs+=(
			-DUSE_IV="ON"
			-DUSE_OPENGL="ON"
			-DUSE_QT="ON"
		)
		if ! use qt6 ; then
			mycmakeargs+=(
				-DCMAKE_DISABLE_FIND_PACKAGE_Qt6="ON"
			)
		fi
	else
		mycmakeargs+=(
			-DUSE_QT="OFF"
		)
	fi

	if use python ; then
		mycmakeargs+=(
			-DPYTHON_VERSION="${EPYTHON#python}"
			-DPYTHON_SITE_DIR="$(python_get_sitedir)"
		)
	fi

	local set_cxx17=0

	for s in ${OPENVDB_APIS[@]} ; do
		if (( ${s} >= 8 )) ; then
			if use "abi${s}-compat" && usex cxx17 ; then
				set_cxx17=1
				einfo "Using abi${s}-compat and added CMAKE_CXX_STANDARD=17"
				mycmakeargs+=(
					-DCMAKE_CXX_STANDARD=17
					-DDOWNSTREAM_CXX_STANDARD=17
				)
			elif use "abi${s}-compat" ; then
				einfo "Using abi${s}-compat and added CMAKE_CXX_STANDARD=14"
				mycmakeargs+=(
					-DCMAKE_CXX_STANDARD=14
					-DDOWNSTREAM_CXX_STANDARD=14
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

src_test() {
	# A lot of tests needs to have access to the installed data files.
	# So install them into the image directory now.
	DESTDIR="${T}" cmake_build install

	CMAKE_SKIP_TESTS=(
		"-broken$"
	)

	sed \
		-i \
		-e "s#../../../testsuite#../../../OpenImageIO-${PV}/testsuite#g" \
		"${CMAKE_USE_DIR}/testsuite/python-imagebufalgo/ref/out.txt" \
		|| die

	local -x CI CMAKE_PREFIX_PATH LD_LIBRARY_PATH OPENIMAGEIO_FONTS PYTHONPATH
	CI=true
	CMAKE_PREFIX_PATH="${T}/usr"
	LD_LIBRARY_PATH="${T}/usr/$(get_libdir)"
	OPENIMAGEIO_FONTS="${CMAKE_USE_DIR}/src/fonts"

	if use python; then
		PYTHONPATH="${T}$(python_get_sitedir)"
	fi

	virtx cmake_src_test

	# Clean up the image directory for src_install
	rm -fr "${T:?}/usr" || die
}

src_install() {
	font_src_install
	cmake_src_install

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
