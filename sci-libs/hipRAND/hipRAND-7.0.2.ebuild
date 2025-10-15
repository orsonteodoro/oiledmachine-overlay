# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
	gfx803
	gfx900_xnack_minus
	gfx906_xnack_minus
	gfx908_xnack_minus
	gfx90a_xnack_minus
	gfx90a_xnack_plus
	gfx942
	gfx1030
	gfx1100
	gfx1101
	gfx1102
	gfx1151
	gfx1200
	gfx1201
)
HIP_SUPPORT_CUDA=1
LLVM_SLOT=19
ROCM_SLOT="${PV%.*}"
ROCM_VERSION="${PV}"

inherit cmake rocm

KEYWORDS="~amd64"
S="${WORKDIR}/hipRAND-rocm-${PV}"
SRC_URI="
https://github.com/ROCm/hipRAND/archive/refs/tags/rocm-${PV}.tar.gz
	-> hipRAND-rocm-${PV}.tar.gz
"

DESCRIPTION="CU / ROCM agnostic hip RAND implementation"
HOMEPAGE="https://github.com/ROCm/hipRAND"
REQUIRED_USE="${ROCM_REQUIRED_USE}"
LICENSE="MIT"
# all-rights-reserved MIT - CMakeLists.txt
# all-rights-reserved MIT - LICENSE.txt
# BSD - test/fortran/fruit/LICENSE.txt
RESTRICT="test"
SLOT="0/${ROCM_SLOT}"
IUSE="
${ROCM_IUSE}
asan cuda rocm
ebuild_revision_7
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
		cuda
		rocm
	)
"
RDEPEND="
	dev-util/hip:${SLOT}
	dev-util/hip:=
	cuda? (
		${HIP_CUDA_DEPEND}
	)
	rocm? (
		sci-libs/rocRAND:${SLOT}
		sci-libs/rocRAND:=
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
			-DBUILD_ADDRESS_SANITIZER=$(usex asan ON OFF)
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
