# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=15
PYTHON_COMPAT=( python3_{10..11} )

inherit cmake llvm python-r1

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/GPUOpen-ProfessionalCompute-Libraries/MIVisionX/"
	inherit git-r3
else
	SRC_URI="
https://github.com/GPUOpen-ProfessionalCompute-Libraries/MIVisionX/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-rocm-${PV}"
fi

DESCRIPTION="MIVisionX toolkit is a set of comprehensive computer vision and \
machine intelligence libraries, utilities, and applications bundled into a \
single toolkit."
HOMEPAGE="https://github.com/GPUOpen-ProfessionalCompute-Libraries/MIVisionX"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
IUSE="
cpu +enhanced-message ffmpeg +loom +migraphx +neural-net opencl opencv
+rocal +rocm +rpp
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	rocal? (
		^^ (
			rocm
			opencl
		)
	)
	rpp? (
		^^ (
			rocm
			opencl
		)
	)
	^^ (
		rocm
		opencl
		cpu
	)
"
BOOST_PV="1.72.0"
PROTOBUF_PV="3.12.4"
RDEPEND="
	${PYTHON_DEPS}
	>=dev-python/pybind11-2.0[${PYTHON_USEDEP}]
	dev-libs/openssl
	~dev-util/hip-${PV}:${SLOT}
	ffmpeg? (
		>=media-video/ffmpeg-4.0.4[fdk,gpl,libass,x264,x265,nonfree]
	)
	neural-net? (
		>=dev-libs/protobuf-${PROTOBUF_PV}
	)
	opencl? (
		virtual/opencl
		~sci-libs/miopengemm-${PV}:${SLOT}
	)
	opencv? (
		>=media-libs/opencv-4.5.5[jpeg]
	)
	rocal? (
		>=dev-libs/protobuf-${PROTOBUF_PV}
		>=sys-libs/libomp-${LLVM_MAX_SLOT}
		media-libs/libjpeg-turbo
		sys-devel/gcc[openmp]
		!ffmpeg? (
			>=dev-libs/boost-${BOOST_PV}:=
		)
	)
	rocm? (
		>=sys-libs/libomp-${LLVM_MAX_SLOT}
		sys-devel/gcc[openmp]
		~sci-libs/rocBLAS-${PV}:${SLOT}
	)
	rpp? (
		>=dev-libs/boost-${BOOST_PV}:=
		~sci-libs/rpp-${PV}:${SLOT}
	)
"
DEPEND="
	${RDEPEND}
	>=dev-cpp/eigen-3:=
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-util/cmake-3.5
	virtual/pkgconfig
"
PATCHES=(
)

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENHANCED_MESSAGE=$(usex enhanced-message ON OFF)
		-DGPU_SUPPORT=$(usex cpu OFF ON)
		-DLOOM=$(usex loom ON OFF)
		-DMIGRAPHX=$(usex migraphx ON OFF)
		-DNEURAL_NET=$(usex neural-net ON OFF)
		-DROCAL=$(usex rocal ON OFF)
	)

	export CXX="${HIP_CXX:-clang++}"

	if use opencl ; then
		mycmakeargs+=(
			-DBACKEND="OPENCL"
		)
	elif use cpu ; then
		mycmakeargs+=(
			-DBACKEND="CPU"
		)
	elif use rocm ; then
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DBACKEND="HIP"
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
		)

		if [[ "${CXX}" =~ (^|-)"g++" ]] ; then
			mycmakeargs+=(
				-DOpenMP_CXX_FLAGS="-fopenmp"
				-DOpenMP_CXX_LIB_NAMES="libopenmp"
				-DOpenMP_libopenmp_LIBRARY="openmp"
			)
		else
			mycmakeargs+=(
				-DOpenMP_CXX_FLAGS="-fopenmp=libomp"
				-DOpenMP_CXX_LIB_NAMES="libomp"
				-DOpenMP_libomp_LIBRARY="omp"
			)
		fi
	fi

	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
