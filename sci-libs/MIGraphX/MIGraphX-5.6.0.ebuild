# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="AMDMIGraphX"
MY_P="${CATEGORY}/${MY_PN}-${PV}"

AMDGPU_TARGETS_COMPAT=(
	gfx900
	gfx906
	gfx908
	gfx1030
)
LLVM_MAX_SLOT=16
PYTHON_COMPAT=( python3_{10..11} )

inherit cmake flag-o-matic llvm python-r1 rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/AMDMIGraphX/"
	inherit git-r3
else
	SRC_URI="
https://github.com/ROCmSoftwarePlatform/AMDMIGraphX/archive/rocm-${PV}.tar.gz
	-> ${MY_PN}-${PV}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-rocm-${PV}"
fi

DESCRIPTION="AMD's graph optimization engine"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/AMDMIGraphX"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
IUSE="-cpu -fpga -hip-rtc -mlir +rocm system-llvm test"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	|| (
		rocm
		cpu
		fpga
	)
	mlir? (
		rocm
	)
"
# protobuf is relaxed
RDEPEND="
	>=dev-db/sqlite-3.17
	>=dev-cpp/msgpack-cxx-3.3.0
	>=dev-cpp/nlohmann_json-3.8.0
	>=dev-libs/half-1.12.0
	>=dev-python/pybind11-2.6.0[${PYTHON_USEDEP}]
	dev-libs/msgpack
	dev-libs/protobuf:0/32
	cpu? (
		dev-libs/oneDNN
		sys-libs/libomp:${LLVM_MAX_SLOT}
	)
	rocm? (
		~sci-libs/miopen-${PV}:${SLOT}
		~sci-libs/rocBLAS-${PV}:${SLOT}
	)
	test? (
		~dev-util/hip-${PV}:${SLOT}
	)
"
DEPEND="
	${RDEPEND}
	>=dev-cpp/blaze-3.4:=
"
BDEPEND="
	!system-llvm? (
		sys-devel/llvm-roc:=
		~sys-devel/llvm-roc-${PV}
	)
	>=dev-util/cmake-3.5
	sys-devel/hip-compiler[system-llvm=]
	~dev-util/rocm-cmake-${PV}:${SLOT}
	mlir? (
		|| (
			~sci-libs/rocMLIR-${PV}:${SLOT}
			=sci-libs/rocMLIR-9999
			=sci-libs/rocMLIR-5.5*:0/5.5
		)
	)
	rocm? (
		sys-devel/rocm-compiler[system-llvm=]
	)
	system-llvm? (
		sys-devel/clang:${LLVM_MAX_SLOT}[extra]
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-5.6.0-path-changes.patch"
)

pkg_setup() {
	llvm_pkg_setup # For LLVM_SLOT init.  Must be explicitly called or it is blank.
	python_setup
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	sed \
		-i \
		-e "s|msgpackc-cxx|msgpack-cxx|g" \
		"src/CMakeLists.txt" \
		|| die
	rocm_src_prepare
}

src_configure() {
	export HIP_CLANG_PATH="${ESYSROOT_LLVM_PATH}/bin"
	local mycmakeargs=(
		-DMIGRAPHX_ENABLE_CPU=$(usex cpu ON OFF)
		-DMIGRAPHX_ENABLE_FPGA=$(usex fpga ON OFF)
		-DMIGRAPHX_ENABLE_GPU=$(usex rocm ON OFF)
		-DMIGRAPHX_ENABLE_MLIR=$(usex mlir ON OFF)
		-DMIGRAPHX_USE_HIPRTC=$(usex hip-rtc ON OFF)
	)

	if use rocm ; then
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
		)
	fi

	export CC="${HIP_CC:-hipcc}"
	export CXX="${HIP_CXX:-hipcc}"
	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
