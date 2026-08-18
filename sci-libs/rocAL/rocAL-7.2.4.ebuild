# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22, U24

# TODO:
# ffmpeg multislot configure/rpath

ABSEIL_CPP_SLOT=""
BOOST_PV="1.72.0"
CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CXX_STANDARD=17
LLVM_SLOT=22
PYTHON_COMPAT=( "python3_"{10,12} )
RAPIDJSON_COMMIT="24b5e7a8b27f42fa16b96fc70aade9106cf7102f" # Security fix for OOBR, 20250205
PROTOBUF_PV="3.12.4" # The version is behind the 3.21 offered.
ROCM_SLOT=$(ver_cut "1-2" "${PV}")
ROCM_VERSION="${PV}"

AMDGPU_TARGETS_COMPAT=(
	"gfx908"
	"gfx90a"
	"gfx942"
	"gfx950"
	"gfx1030"
	"gfx1031"
	"gfx1032"
	"gfx1100"
	"gfx1101"
	"gfx1102"
	"gfx1200"
	"gfx1201"
)

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_ROCM_7_2[@]}"
)

inherit ffmpeg
FFMPEG_COMPAT_SLOTS=(
	"${FFMPEG_COMPAT_SLOTS_4[@]}" # U22
	"${FFMPEG_COMPAT_SLOTS_5[@]}" # D12
	"${FFMPEG_COMPAT_SLOTS_6[@]}" # U24
	"${FFMPEG_COMPAT_SLOTS_7[@]}" # D13
)

CHKL_TIMESTAMPS=(
	"dev-libs/rapidjson-9999"
	"media-libs/libjpeg-turbo-9999"
)

inherit abseil-cpp cflags-hardened check-compiler-switch cmake flag-o-matic libstdcxx-slot protobuf python-single-r1 secure-version rocm

#KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-rocm-${PV}"
SRC_URI="
https://github.com/ROCm/rocAL/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	!system-rapidjson? (
https://github.com/Tencent/rapidjson/archive/${RAPIDJSON_COMMIT}.tar.gz
	-> rapidjson-${RAPIDJSON_COMMIT:0:7}.tar.gz
	)
"

DESCRIPTION="The AMD rocAL is designed to efficiently decode and process \
images and videos from a variety of storage formats and modify them through a \
processing graph programmable by the user. "
HOMEPAGE="https://github.com/ROCm/rocAL"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
"
# The distro's MIT license template does not contain all rights reserved.
SLOT="0/${ROCM_SLOT}"
IUSE+="
${AMDGPU_TARGETS_COMPAT[@]}
cpu enhanced-message ffmpeg ieee1394 opencv python system-rapidjson
test
ebuild_revision_18
"
REQUIRED_USE="
	|| (
		${AMDGPU_TARGETS_COMPAT[@]}
	)
"
# The required Protobuf version is relaxed.
RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=dev-python/pybind11-2.11.1[${PYTHON_USEDEP}]
	')
	>=media-libs/libjpeg-turbo-${LIBJPEG_TURBO_PV}:=
	dev-db/lmdb:=
	dev-libs/protobuf:=[${LIBSTDCXX_USEDEP}]
	|| (
		dev-libs/protobuf:3/3.12[${LIBSTDCXX_USEDEP}]
		dev-libs/protobuf:3/3.21[${LIBSTDCXX_USEDEP}]
	)
	~dev-util/hip-${PV}:=[${LIBSTDCXX_USEDEP}]
	~dev-libs/rocm-opencl-runtime-${PV}:=[${LIBSTDCXX_USEDEP}]
	~sci-libs/MIVisionX-${PV}:=[${LIBSTDCXX_USEDEP}]
	~sci-libs/rocDecode-${PV}:=[${LIBSTDCXX_USEDEP}]
	~sci-libs/rpp-${PV}:=[${LIBSTDCXX_USEDEP}]
	~sys-libs/llvm-roc-libomp-${PV}:=[${LIBSTDCXX_USEDEP}]
	!ffmpeg? (
		>=dev-libs/boost-${BOOST_PV}:=[${LIBSTDCXX_USEDEP}]
	)
	ffmpeg? (
		$(secure-version_gen_ffmpeg_depends '4.4-7.1')
	)
	opencv? (
		>=media-libs/opencv-${OPENCV4_PV}:=[${LIBSTDCXX_USEDEP},features2d,gtk3,ieee1394?,jpeg,png,tiff]
		|| (
			~media-libs/opencv-${OPENCV4_PV}[${LIBSTDCXX_USEDEP},features2d,gtk3,ieee1394?,jpeg,png,tiff]
		)
	)
"
DEPEND="
	${RDEPEND}
	>=dev-libs/half-1.12.0:=
	system-rapidjson? (
		=dev-libs/rapidjson-${RAPIDJSON_PV}:=
	)
"
BDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=dev-python/wheel-0.37.0[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
		test? (
			>=dev-python/pytest-7.0.0[${PYTHON_USEDEP}]
		)
	')
	>=dev-build/cmake-3.5
	dev-lang/nasm
	dev-lang/yasm
	virtual/pkgconfig
"
PATCHES=(
)

pkg_setup() {
	check-compiler-switch_start
	rocm_pkg_setup
	python-single-r1_pkg_setup
	libstdcxx-slot_verify
}

src_unpack() {
	if [[ "${PV}" == *"9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

build_rapidjson() {
	use system-rapidjson && return
	local staging_dir="${WORKDIR}/install"
	pushd "${S_RAPIDJSON}" || die
		mkdir build || die
		cd build || die
		local mycmakeargs=(
			-DCMAKE_INSTALL_PREFIX="${staging_dir}/${EPREFIX}${EROCM_PATH}/$(rocm_get_libdir)/rapidjson"
		)
		cmake \
			"${mycmakeargs[@]}" \
			.. \
			|| die
		emake
		emake install || die
	popd
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	chkl_check_many_timestamps

	rocm_set_default_gcc

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	cflags-hardened_append

	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if ! check-compiler-switch_is_system_flavor ; then
einfo "Detected GPU compiler switch.  Disabling LTO."
		filter-lto
	fi

	# The required Protobuf version is relaxed.
	if has_version "dev-libs/protobuf:3/3.12" ; then
		ABSEIL_CPP_SLOT="20200225"
		PROTOBUF_PYTHON_SLOT="${PROTOBUF_PYTHON_SLOT_3}"
	elif has_version "dev-libs/protobuf:3/3.21" ; then
		ABSEIL_CPP_SLOT="20220623"
		PROTOBUF_PYTHON_SLOT="${PROTOBUF_PYTHON_SLOT_4_WITH_PROTOBUF_CPP_3}"
	fi
	abseil-cpp_src_configure
	protobuf_src_configure
	ffmpeg_src_configure

	build_rapidjson
	local mycmakeargs=(
		$(abseil-cpp_append_cmake)
		$(protobuf_append_cmake)
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DENHANCED_MESSAGE=$(usex enhanced-message ON OFF)
		-DGPU_SUPPORT=$(usex cpu OFF ON)
	)

	# FIXME: Fix prefix in TURBO_JPEG_PATH.
	local staging_dir="${WORKDIR}/install"
	export TURBO_JPEG_PATH="${staging_dir}/${EPREFIX}${EROCM_PATH}/$(rocm_get_libdir)/libjpeg-turbo"
	mycmakeargs+=(
		-DTURBO_JPEG_PATH="${staging_dir}/${EPREFIX}${EROCM_PATH}/$(rocm_get_libdir)/libjpeg-turbo"
		-DPYBIND11_INCLUDES="${ESYSROOT}/usr/include"
	)

	if use python ; then
		mycmakeargs+=(
			-DCMAKE_INSTALL_PREFIX_PYTHON="${EPREFIX}/usr/lib/${EPYTHON}/site-packages"
		)
	fi

	rocm_src_configure
}

src_install() {
	cmake_src_install
	rocm_fix_rpath
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs testing
