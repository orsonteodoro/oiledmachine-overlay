# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GCC_COMPAT=(
	"gcc_slot_14_3" # CY2026 is GCC 14.2; CUDA-12.9, CUDA-12.8
	"gcc_slot_13_4" # CUDA-12.6, CUDA-12.5, CUDA-12.4, CUDA-12.3, ROCm-6.3, ROCm-6.4
	"gcc_slot_11_5" # CY2025 is GCC 11.2.1, CUDA-11.8
)
PYTHON_COMPAT=( python3_{11..14} )
inherit cmake-multilib libstdcxx-slot python-any-r1

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/KhronosGroup/${PN}.git"
	inherit git-r3
else
	GIT_COMMIT="vulkan-sdk-${PV}"
	SRC_URI="https://github.com/KhronosGroup/${PN}/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv x86"
	S="${WORKDIR}/${PN}-${GIT_COMMIT}"
fi

DESCRIPTION="Khronos reference front-end for GLSL and ESSL, and sample SPIR-V generator"
HOMEPAGE="https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/ https://github.com/KhronosGroup/glslang"

LICENSE="BSD"
SLOT="0/15.4"

BDEPEND="${PYTHON_DEPS}
	~dev-util/spirv-tools-${PV}[${MULTILIB_USEDEP}]
"

DEPEND="~dev-util/spirv-tools-${PV}[${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}"

pkg_setup() {
	python-any-r1_pkg_setup
	libstdcxx-slot_verify
}

multilib_src_configure() {
	local mycmakeargs=(
		-DENABLE_PCH=OFF
		-DALLOW_EXTERNAL_SPIRV_TOOLS=ON
	)
	cmake_src_configure
}
