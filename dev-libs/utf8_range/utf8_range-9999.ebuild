# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib git-r3

DESCRIPTION="Fast UTF-8 validation with Range algorithm (NEON+SSE4+AVX2)"
HOMEPAGE="https://github.com/protocolbuffers/utf8_range"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm64"
SLOT="0"
IUSE+=" fallback-commit test"
# See https://github.com/protocolbuffers/utf8_range/blob/main/.github/workflows/cmake_tests.yml#L14
RDEPEND+="
	>=dev-cpp/abseil-cpp-20220623.0:0/20220623
"
BDEPEND+="
	>=dev-util/cmake-3.5
	test? (
		>=dev-cpp/gtest-1.12.1
	)
"
DOCS=( README.md )
EGIT_REPO_URI="https://github.com/protocolbuffers/utf8_range.git"
EGIT_BRANCH="main"
PATCHES=(
	"${FILESDIR}/utf8_range-9999-shared-libs.patch"
)

pkg_setup() {
	use fallback-commit && export EGIT_COMMIT="72c943dea2b9240cd09efde15191e144bc7c7d38" # Nov 15, 2022
}

src_configure() {
	local mycmakeargs=(
		-Dutf8_range_ENABLE_TESTS=$(usex test)
	)

	cmake-multilib_src_configure
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES: multilib-support EAPI8
# OILEDMACHINE-OVERLAY-META-REVDEP: leveldb
