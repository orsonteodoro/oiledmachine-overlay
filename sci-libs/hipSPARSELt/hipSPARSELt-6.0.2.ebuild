# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx940
	gfx941
	gfx942
)

HIP_SUPPORT_CUDA=1
LLVM_SLOT=17
ROCM_SLOT="${PV%.*}"
ROCM_VERSION="${PV}"

inherit cmake rocm

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-rocm-${PV}"
SRC_URI="
https://github.com/ROCm/hipSPARSELt/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${PN}-rocm-${PV}.tar.gz
"

DESCRIPTION="hipSPARSELt is a SPARSE marshalling library, with multiple supported backends."
HOMEPAGE="https://github.com/ROCm/hipSPARSELt"
REQUIRED_USE="${ROCM_REQUIRED_USE}"
LICENSE="MIT"
RESTRICT="test"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="cuda rocm samples test ebuild-revision-0"
REQUIRED_USE="
	^^ (
		cuda
		rocm
	)
"
RDEPEND="
	dev-util/hip:${SLOT}
	~dev-util/Tensile-${PV}:${SLOT}
	cuda? (
		${HIP_CUDA_DEPEND}
	)
	rocm? (
		~sci-libs/hipSPARSE-${PV}:${SLOT}
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${HIPCC_DEPEND}
	>=dev-build/cmake-3.10.2
	test? (
		dev-cpp/gtest
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-6.0.2-hardcoded-paths.patch"
)

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_CLIENTS_BENCHMARKS=$(usex benchmark)
		-DBUILD_CLIENTS_SAMPLES=$(usex samples)
		-DBUILD_CLIENTS_TESTS=$(usex test)
		-DBUILD_CUDA=$(usex cuda)
		-DBUILD_GTEST=OFF
	)
	if use cuda ; then
		mycmakeargs+=(
			-DHIP_COMPILER="nvcc"
			-DHIP_PLATFORM="nvidia"
			-DHIP_RUNTIME="cuda"
		)
	elif use rocm ; then
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
			-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
			-DROCM_SYMLINK_LIBS=OFF
		)
	fi
	rocm_set_default_hipcc
	rocm_src_configure
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs test
