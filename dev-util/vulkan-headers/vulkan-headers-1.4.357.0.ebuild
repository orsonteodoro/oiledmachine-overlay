# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=Vulkan-Headers
COMMIT_ID="e3b1eec08173d6b825cd3ac88c885a63b621504a"
FLAVOR="vulkan-tmp" # vulkan-tmp or vulkan-sdk

inherit cmake

if [[ ${PV} == *9999* ]]; then
	INTERNAL_PV="1.4.357"
	FALLBACK_COMMIT="${COMMIT_ID}"
	EGIT_BRANCH="${FLAVOR}-1.4.356"
	EGIT_REPO_URI="https://github.com/KhronosGroup/${MY_PN}.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	INTERNAL_PV="${PV}"
	SRC_URI="
https://github.com/KhronosGroup/Vulkan-Headers/archive/${COMMIT_ID}.tar.gz -> ${P}.${COMMIT_ID:0:7}.tar.gz
	"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
	S="${WORKDIR}/Vulkan-Headers-${COMMIT_ID}"
fi

DESCRIPTION="Vulkan Header files and API registry"
HOMEPAGE="https://github.com/KhronosGroup/Vulkan-Headers"

LICENSE="Apache-2.0"
SLOT="0/${INTERNAL_PV}"
IUSE+=" test"
RESTRICT="!test? ( test )"

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
		local actual_ver
		local expected_ver
		actual_ver=$(cat "${S}/registry/validusage.json" | grep "api version" | cut -f 4 -d '"')
		expected_ver=$(ver_cut "1-3" "${INTERNAL_PV}")
		if ver_test "${actual_ver}" "-ne" "${expected_ver}" ; then
eerror "QA:  Version inconsistency detected.  Fix the COMMIT_ID or INTERNAL_PV."
eerror "Actual version:  ${actual_ver}"
eerror "Expected version:  ${expected_ver}"
			die
		fi
	fi
}

src_configure() {
	local mycmakeargs=(
		-DVULKAN_HEADERS_ENABLE_MODULE=OFF
		-DVULKAN_HEADERS_ENABLE_TESTS=$(usex test)
	)

	cmake_src_configure
}

src_install() {
	# VULKAN_HEADERS_ENABLE_MODULE doesn't seem to be working so just
	# delete the modules manually
	cmake_src_install
	find "${ED}" -name "*.cppm" -type f -delete || die
}
