# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

BOOST_PV="1.72.0"
LIBJPEG_TURBO_PV="3.0.2"
LLVM_SLOT=18
PYTHON_COMPAT=( "python3_12" ) # U 20/22
RAPIDJSON_COMMIT="f9d53419e912910fd8fa57d5705fa41425428c35" # committer-date:<=2023-10-05
PROTOBUF_PV="3.12.4" # The version is behind the 3.21 offered.
ROCM_SLOT="6.2"
ROCM_VERSION="6.2.4"
RRAWTHER_LIBJPEG_TURBO_COMMIT="ae4e2a24e54514d1694d058650c929e6086cc4bb"

inherit check-compiler-switch cmake flag-o-matic python-single-r1 rocm

#KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-rocm-${PV}"
SRC_URI="
https://github.com/ROCm/rocAL/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/rrawther/libjpeg-turbo/archive/${RRAWTHER_LIBJPEG_TURBO_COMMIT}.tar.gz
	-> rrawther-libjpeg-turbo-${RRAWTHER_LIBJPEG_TURBO_COMMIT:0:7}.tar.gz
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
SLOT="${ROCM_SLOT}/${PV}"
IUSE+="
cpu enhanced-message ffmpeg ieee1394 opencv python system-rapidjson system-jpeg
test
ebuild_revision_4
"
RDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/half-1.12.0
	dev-libs/protobuf:=
	$(python_gen_cond_dep '
		>=dev-python/pybind11-2.10.4[${PYTHON_USEDEP}]
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
PATCHES=(
	"${FILESDIR}/${PN}-6.2.0-hardcoded-paths.patch"
)

pkg_setup() {
	check-compiler-switch_start
	rocm_pkg_setup
	python-single-r1_pkg_setup
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
	local staging_dir="${WORKDIR}/install"
	cd "${WORKDIR}/libjpeg-turbo-${RRAWTHER_LIBJPEG_TURBO_COMMIT}" || die
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

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if ! check-compiler-switch_is_system_flavor ; then
einfo "Detected GPU compiler switch.  Disabling LTO."
		filter-lto
	fi

	build_libjpeg_turbo
	build_rapidjson
	local mycmakeargs=(
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
			-DCMAKE_INSTALL_PREFIX_PYTHON="${EPREFIX}${EROCM_PATH}/lib/${EPYTHON}/site-packages"
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
