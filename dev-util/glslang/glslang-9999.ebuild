# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="NPD"
CXX_STANDARD=17

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

PYTHON_COMPAT=( "python3_"{10..14} )
inherit cflags-hardened cmake-multilib libcxx-slot libstdcxx-slot python-any-r1

if [[ ${PV} == *9999* ]]; then
	FALLBACK_COMMIT="32238786c835d237c729375f96218e834ab83787"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/KhronosGroup/${PN}.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	GIT_COMMIT="vulkan-sdk-${PV}"
	SRC_URI="https://github.com/KhronosGroup/${PN}/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm arm64 ~loong ppc ppc64 ~riscv ~x86"
	S="${WORKDIR}/${PN}-${GIT_COMMIT}"
fi

DESCRIPTION="Khronos reference front-end for GLSL and ESSL, and sample SPIR-V generator"
HOMEPAGE="https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/ https://github.com/KhronosGroup/glslang"
LICENSE="BSD"
INTERNAL_PV="16.5" # Versioning based on https://github.com/KhronosGroup/glslang/blob/main/CHANGES.md
SLOT="0/${INTERNAL_PV}"
IUSE+=" ebuild_revision_1"
BDEPEND="${PYTHON_DEPS}
	>=dev-util/spirv-tools-${PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP}]
"
DEPEND="
	>=dev-util/spirv-tools-${PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

pkg_setup() {
	python-any-r1_pkg_setup
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
	local actual_pv=$(grep -E -o "^## [0-9]+[.][0-9]+[.][0-9]+" "${S}/CHANGES.md" | head -n 1 | sed -e "s|^## ||g" | cut -f 1-2 -d ".")
	local expected_pv="${INTERNAL_PV}"
	if ver_test "${actual_pv}" "-ne" "${expected_pv}" ; then
eerror "QA:  Update the INTERNAL_PV"
eerror "QA:  Actual PV:  ${actual_pv}"
eerror "QA:  Expected PV:  ${expected_pv}"
		die
	fi
}

multilib_src_configure() {
	cflags-hardened_append
	local mycmakeargs=(
		-DENABLE_PCH=OFF
		-DALLOW_EXTERNAL_SPIRV_TOOLS=ON
	)
	cmake_src_configure
}
