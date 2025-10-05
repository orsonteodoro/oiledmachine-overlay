# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=SPIRV-Tools
GCC_COMPAT=(
	"gcc_slot_14_3" # CY2026 is GCC 14.2; CUDA-12.9, CUDA-12.8
	"gcc_slot_13_4" # CUDA-12.6, CUDA-12.5, CUDA-12.4, CUDA-12.3, ROCm-6.3, ROCm-6.4
	"gcc_slot_11_5" # CY2025 is GCC 11.2.1, CUDA-11.8
)
PYTHON_COMPAT=( python3_{11..14} )
PYTHON_REQ_USE="xml(+)"
inherit cmake-multilib libstdcxx-slot python-any-r1

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/KhronosGroup/${MY_PN}.git"
	inherit git-r3
else
	EGIT_COMMIT="vulkan-sdk-${PV}"
	SRC_URI="https://github.com/KhronosGroup/${MY_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
	S="${WORKDIR}"/${MY_PN}-${EGIT_COMMIT}
fi

DESCRIPTION="Provides an API and commands for processing SPIR-V modules"
HOMEPAGE="https://github.com/KhronosGroup/SPIRV-Tools"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="~dev-util/spirv-headers-${PV}"
# RDEPEND=""
BDEPEND="${PYTHON_DEPS}"

pkg_setup() {
	python-any-r1_pkg_setup
	libstdcxx-slot_verify
}

multilib_src_configure() {
	local mycmakeargs=(
		-DSPIRV-Headers_SOURCE_DIR="${ESYSROOT}"/usr/
		-DSPIRV_WERROR=OFF
		-DSPIRV_SKIP_TESTS=$(usex !test)
		-DSPIRV_TOOLS_BUILD_STATIC=OFF
		-DCMAKE_C_FLAGS="${CFLAGS} -DNDEBUG"
		-DCMAKE_CXX_FLAGS="${CXXFLAGS} -DNDEBUG"
	)

	cmake_src_configure
}

src_test() {
	CMAKE_SKIP_TESTS=(
		# Not relevant for us downstream
		spirv-tools-copyrights
		# Tests fail upon finding symbols that do not match a regular expression
		# in the generated library. Easily hit with non-standard compiler flags
		spirv-tools-symbol-exports.*
	)

	multilib-minimal_src_test
}
