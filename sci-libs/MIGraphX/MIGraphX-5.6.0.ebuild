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

inherit cmake llvm python-r1

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
IUSE="-cpu -fpga -hip-rtc -mlir +rocm test"
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
		>=sys-libs/libomp-${LLVM_MAX_SLOT}
		dev-libs/oneDNN
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
	>=dev-util/cmake-3.5
	~dev-util/rocm-cmake-${PV}:${SLOT}
	mlir? (
		|| (
			~sci-libs/rocMLIR-${PV}:${SLOT}
			=sci-libs/rocMLIR-9999
			=sci-libs/rocMLIR-5.5*:0/5.5
		)
	)
"
PATCHES=(
)

pkg_setup() {
	llvm_pkg_setup # For LLVM_SLOT init.  Must be explicitly called or it is blank.
	python_setup
}

src_prepare() {
	cmake_src_prepare
	sed \
		-i \
		-e "s|msgpackc-cxx QUIET|msgpack-cxx|g" \
		"src/CMakeLists.txt" \
		|| die
	sed \
		-i \
		-e "s|NOT msgpackc-cxx_FOUND|NOT msgpack-cxx_FOUND|g" \
		"src/CMakeLists.txt" \
		|| die
	IFS=$'\n'
	sed \
		-i \
		-e "s|half/half.hpp|half.hpp|g" \
		$(grep -l -r -e "half/half.hpp" "${S}") \
		|| die
	IFS=$' \t\n'
}

src_configure() {
	export HIP_CLANG_PATH=$(get_llvm_prefix ${LLVM_SLOT})"/bin"
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

	CXX="${HIP_CXX:-hipcc}" \
	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
