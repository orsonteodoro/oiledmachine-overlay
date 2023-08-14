# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx940
	gfx1030
)
LLVM_MAX_SLOT=16

inherit cmake llvm rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/GPUOpen-ProfessionalCompute-Libraries/rpp/"
	inherit git-r3
else
	SRC_URI="
https://github.com/GPUOpen-ProfessionalCompute-Libraries/rpp/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${P}"
fi

DESCRIPTION="AMD ROCm Performance Primitives (RPP) library is a comprehensive \
high-performance computer vision library for AMD processors with HIP/OpenCL/CPU \
back-ends."
HOMEPAGE="https://github.com/GPUOpen-ProfessionalCompute-Libraries/rpp"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
IUSE="
${ROCM_IUSE}
cpu opencl rocm test
"
gen_rocm_required_use() {
	local x
	for x in ${AMDGPU_TARGETS_COMPAT[@]} ; do
		echo "
			amdgpu_targets_${x}? (
				rocm
			)
		"
	done
}
REQUIRED_USE="
	$(gen_rocm_required_use)
	^^ (
		rocm
		opencl
		cpu
	)
"
RDEPEND="
	>=sys-libs/libomp-${LLVM_MAX_SLOT}
	dev-libs/boost:=
	opencl? (
		virtual/opencl
	)
	rocm? (
		dev-util/hip:=
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.5
	test? (
		media-libs/opencv
		media-libs/libjpeg-turbo
	)
"
RESTRICT="test"
PATCHES=(
)

pkg_setup() {
	llvm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=()

	CXX="${HIP_CXX:-hipcc}"

	if [[ "${CXX}" =~ "g++" ]] ; then
		mycmakeargs+=(
			-DOpenMP_CXX_FLAGS="-fopenmp=libopenmp"
			-DOpenMP_CXX_LIB_NAMES="libopenmp"
			-DOpenMP_libomp_LIBRARY="openmp"
		)
	else
		mycmakeargs+=(
			-DOpenMP_CXX_FLAGS="-fopenmp=libomp"
			-DOpenMP_CXX_LIB_NAMES="libomp"
			-DOpenMP_libomp_LIBRARY="omp"
		)
	fi

	if use opencl ; then
		mycmakeargs+=(
			-DBACKEND="OPENCL"
		)
	elif use rocm ; then
		export HIP_CLANG_PATH=$(get_llvm_prefix ${LLVM_SLOT})"/bin"
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DAMDGPU_TARGETS=$(get_amdgpu_flags)
			-DBACKEND="HIP"
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
		)
	elif use cpu ; then
		mycmakeargs+=(
			-DBACKEND="CPU"
		)
	fi
	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
