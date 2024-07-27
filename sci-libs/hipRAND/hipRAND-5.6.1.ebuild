# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

HIP_SUPPORT_CUDA=1
LLVM_SLOT=16
ROCM_SLOT="${PV%.*}"
ROCM_VERSION="${PV}"

inherit cmake rocm

KEYWORDS="~amd64"
S="${WORKDIR}/hipRAND-rocm-${PV}"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/hipRAND/archive/refs/tags/rocm-${PV}.tar.gz
	-> hipRAND-rocm-${PV}.tar.gz
"

DESCRIPTION="CU / ROCM agnostic hip RAND implementation"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipRAND"
REQUIRED_USE="${ROCM_REQUIRED_USE}"
LICENSE="MIT"
# all-rights-reserved MIT - CMakeLists.txt
# all-rights-reserved MIT - LICENSE.txt
# BSD - test/fortran/fruit/LICENSE.txt
RESTRICT="test"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="cuda rocm ebuild-revision-7"
REQUIRED_USE="
	^^ (
		cuda
		rocm
	)
"
RDEPEND="
	dev-util/hip:${SLOT}
	cuda? (
		${HIP_CUDA_DEPEND}
	)
	rocm? (
		sci-libs/rocRAND:${SLOT}
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${HIPCC_DEPEND}
	>=dev-build/cmake-3.10.2
"
PATCHES=(
	"${FILESDIR}/${PN}-5.5.1-hardcoded-paths.patch"
)

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	local mycmakeargs=()
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
