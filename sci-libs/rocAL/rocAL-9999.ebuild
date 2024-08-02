# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

BOOST_PV="1.72.0"
LIBJPEG_TURBO_PV="3.0.2"
LLVM_SLOT=17
PYTHON_COMPAT=( "python3_10" ) # U 20/22
RAPIDJSON_COMMIT="f9d53419e912910fd8fa57d5705fa41425428c35" # committer-date:<=2023-10-05
PROTOBUF_PV="3.12.0" # The version is behind the 3.21 offered.
ROCM_SLOT="6.2"
ROCM_VERSION="6.2.0"

inherit cmake python-single-r1 rocm

if [[ ${PV} == *"9999" ]] ; then
	EGIT_REPO_URI="https://github.com/ROCm/rocAL.git"
	EGIT_BRANCH="develop"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	SRC_URI="
	!system-jpeg? (
https://github.com/libjpeg-turbo/libjpeg-turbo/archive/refs/tags/${LIBJPEG_TURBO_PV}.tar.gz
	-> libjpeg-turbo-${LIBJPEG_TURBO_PV}.tar.gz
	)
	!system-rapidjson? (
https://github.com/Tencent/rapidjson/archive/${RAPIDJSON_COMMIT}.tar.gz
	-> rapidjson-${RAPIDJSON_COMMIT:0:7}.tar.gz
	)
	"
	inherit git-r3
else
	SRC_URI="
https://github.com/ROCm/rocAL/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	!system-jpeg? (
https://github.com/libjpeg-turbo/libjpeg-turbo/archive/refs/tags/${LIBJPEG_TURBO_PV}.tar.gz
	-> libjpeg-turbo-${LIBJPEG_TURBO_PV}.tar.gz
	)
	!system-rapidjson? (
https://github.com/Tencent/rapidjson/archive/${RAPIDJSON_COMMIT}.tar.gz
	-> rapidjson-${RAPIDJSON_COMMIT:0:7}.tar.gz
	)
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-rocm-${PV}"
fi

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
SLOT="${ROCM_SLOT}/${PV}"
IUSE+=" cpu enhanced-message ffmpeg ieee1394 opencv python system-rapidjson system-jpeg test ebuild-revision-0"
if [[ "${PV}" == *"9999" ]] ; then
	RDEPEND="
		${PYTHON_DEPS}
		>=dev-libs/half-1.12.0
		>=dev-libs/protobuf-${PROTOBUF_PV}:0/3.21
		$(python_gen_cond_dep '
			>=dev-python/pybind11-2.11.1[${PYTHON_USEDEP}]
		')
		dev-db/lmdb
		dev-libs/rocm-opencl-runtime:=
		dev-util/hip:=
		media-libs/libjpeg-turbo
		sci-libs/MIVisionX:=
		sci-libs/rocDecode:=
		sci-libs/rpp:=
		sys-libs/llvm-roc-libomp:=
		!ffmpeg? (
			>=dev-libs/boost-${BOOST_PV}:=
		)
		opencv? (
			>=media-libs/opencv-4.6.0[features2d,gtk3,ieee1394?,jpeg,png,tiff]
		)
	"
	DEPEND="
		${RDEPEND}
		system-rapidjson? (
			=dev-libs/rapidjson-9999
		)
	"
	BDEPEND="
		${PYTHON_DEPS}
		>=dev-build/cmake-3.5
		$(python_gen_cond_dep '
			>=dev-python/wheel-0.37.0[${PYTHON_USEDEP}]
			dev-python/pip[${PYTHON_USEDEP}]
			test? (
				>=dev-python/pytest-7.0.0[${PYTHON_USEDEP}]
			)
		')
		dev-lang/nasm
		dev-lang/yasm
		sys-devel/gcc[openmp]
		sys-devel/gcc:=
		virtual/pkgconfig
	"
else
	RDEPEND="
		${PYTHON_DEPS}
		>=dev-libs/half-1.12.0
		>=dev-libs/protobuf-${PROTOBUF_PV}:0/3.21
		$(python_gen_cond_dep '
			>=dev-python/pybind11-2.11.1[${PYTHON_USEDEP}]
		')
		dev-db/lmdb
		media-libs/libjpeg-turbo
		~dev-util/hip-${PV}:${ROCM_SLOT}
		~dev-libs/rocm-opencl-runtime-${PV}:${ROCM_SLOT}
		~sci-libs/MIVisionX-${PV}:${ROCM_SLOT}
		~sci-libs/rocDecode-${PV}:${ROCM_SLOT}
		~sci-libs/rpp-${PV}:${ROCM_SLOT}
		~sys-libs/llvm-roc-libomp-${PV}:${ROCM_SLOT}
		!ffmpeg? (
			>=dev-libs/boost-${BOOST_PV}:=
		)
		opencv? (
			>=media-libs/opencv-4.6.0[features2d,gtk3,ieee1394?,jpeg,png,tiff]
		)
	"
	DEPEND="
		${RDEPEND}
		system-rapidjson? (
			=dev-libs/rapidjson-9999
		)
	"
	BDEPEND="
		${PYTHON_DEPS}
		>=dev-build/cmake-3.5
		$(python_gen_cond_dep '
			>=dev-python/wheel-0.37.0[${PYTHON_USEDEP}]
			dev-python/pip[${PYTHON_USEDEP}]
			test? (
				>=dev-python/pytest-7.0.0[${PYTHON_USEDEP}]
			)
		')
		dev-lang/nasm
		dev-lang/yasm
		sys-devel/gcc:${HIP_6_2_GCC_SLOT}[openmp]
		sys-devel/gcc:=
		virtual/pkgconfig
	"
fi
PATCHES=(
	"${FILESDIR}/${PN}-95ce348-hardcoded-paths.patch"
)

pkg_setup() {
ewarn "Ebuild in development"
die
	rocm_pkg_setup
}

src_unpack() {
	if [[ ${PV} == *"9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

build_libjpeg_turbo() {
	use system-jpeg && return
	local staging_dir="${WORKDIR}/install"
	cd "${WORKDIR}/libjpeg-turbo-${LIBJPEG_TURBO_PV}" || die
	mkdir -p "build" || die
	cd "build" || die
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${staging_dir}/${EPREFIX}${EROCM_PATH}/$(rocm_get_libdir)/libjpeg-turbo"
		-DCMAKE_BUILD_TYPE=RELEASE
		-DENABLE_STATIC=FALSE
		-DCMAKE_INSTALL_DEFAULT_LIBDIR=lib
	)
	cmake \
		"${mycmakeargs[@]}" \
		.. \
		|| die
	emake || die
	emake install || die
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
	rocm_set_default_gcc
	build_libjpeg_turbo
	build_rapidjson
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DENHANCED_MESSAGE=$(usex enhanced-message ON OFF)
		-DGPU_SUPPORT=$(usex cpu OFF ON)
	)

	# FIXME: fix prefix in TURBO_JPEG_PATH.
	local staging_dir="${WORKDIR}/install"
	export TURBO_JPEG_PATH="${staging_dir}/${EPREFIX}${EROCM_PATH}/$(rocm_get_libdir)/libjpeg-turbo"
	mycmakeargs+=(
		-DTURBO_JPEG_PATH="${staging_dir}/${EPREFIX}${EROCM_PATH}/$(rocm_get_libdir)/libjpeg-turbo"
		-DPYBIND11_INCLUDES="${ESYSROOT}/usr/include"
	)

	if use python ; then
		mycmakeargs+=(
			-DCMAKE_INSTALL_PREFIX_PYTHON="${EPREFIX}${EROCM_PATH}/lib/${EPYTHON}/site-packages"
		)
	fi

	rocm_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  in development
