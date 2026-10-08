# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="54571f86e3a8124c39bc4765ff64d766b4e25efc"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/fastfloat/fast_float.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv ~sparc x86"
	SRC_URI="
https://github.com/fastfloat/fast_float/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	"
fi

DESCRIPTION="Fast and exact implementation of the C++ from_chars functions for number types"
HOMEPAGE="https://github.com/fastfloat/fast_float"
LICENSE="|| ( Apache-2.0 Boost-1.0 MIT )"
SLOT="0"
IUSE+=" test"
RESTRICT="!test? ( test )"
BDEPEND="test? ( dev-cpp/doctest )"

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_src_unpack
	else
		unpack ${A}
	fi

}

src_configure() {
	local mycmakeargs=( -DFASTFLOAT_TEST=$(usex test) )

	# Avoid passing these without USE=test to avoid cmake warning
	# "Manually-specified variables were not used by the project"
	if use test; then
		mycmakeargs+=(
			-DSYSTEM_DOCTEST=ON
			# Unconditionally calls FetchContent
			-DFASTFLOAT_SUPPLEMENTAL_TESTS=OFF
		)
		sed -i 's/-Werror//' tests/CMakeLists.txt || die
	fi

	cmake_src_configure
}
