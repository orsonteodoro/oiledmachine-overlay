# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=SPIRV-Headers

INTERNAL_VERSION="1.6.7" # https://github.com/KhronosGroup/SPIRV-Headers/blob/main/include/spirv/unified1/spirv.core.grammar.json#L12

inherit cmake

if [[ ${PV} == *9999* ]]; then
	FALLBACK_COMMIT="29981f65241605e08b0ede4cfeb999fe3b723c6a"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/KhronosGroup/${MY_PN}.git"
	if [[ "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="https://github.com/KhronosGroup/${MY_PN}/archive/vulkan-sdk-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
	S="${WORKDIR}"/${MY_PN}-vulkan-sdk-${PV}
fi

DESCRIPTION="Machine-readable files for the SPIR-V Registry"
HOMEPAGE="https://registry.khronos.org/SPIR-V/ https://github.com/KhronosGroup/SPIRV-Headers"

LICENSE="MIT"
SLOT="0/${INTERNAL_VERSION}"

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
	local p="${S}/include/spirv/unified1/spirv.core.grammar.json"
	local spirv_headers_pv_c1=$(grep "major_version" "${p}" | grep -E -o -e "[0-9]+")
	local spirv_headers_pv_c2=$(grep "minor_version" "${p}" | grep -E -o -e "[0-9]+")
	local spirv_headers_pv_c3=$(grep "revision" "${p}" | grep -E -o -e "[0-9]+")
	local actual_spirv_headers_pv="${spirv_headers_pv_c1}.${spirv_headers_pv_c2}.${spirv_headers_pv_c3}"
	local expected_spirv_headers_pv="${INTERNAL_VERSION}"
	if ver_test "${actual_spirv_headers_pv}" "-ne" "${expected_spirv_headers_pv}" ; then
eerror "QA:  Bump INTERNAL_VERSION"
eerror "Actual spirv-headers version:  ${actual_spirv_headers_pv}"
eerror "Expected spirv-headers version:  ${expected_spirv_headers_pv}"
		die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DSPIRV_HEADERS_ENABLE_TESTS=OFF
		-DSPIRV_HEADERS_ENABLE_INSTALL=ON
	)
	cmake_src_configure
}
