# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib git-r3

FALLBACK_COMMIT="4ec9170bcdfaba23c15fbbc90917e6316a99cc86" # Dec 28, 2023
EGIT_BRANCH="main"
EGIT_REPO_URI="https://github.com/protocolbuffers/protobuf.git"
EGIT_SUBMODULES=()
S="${WORKDIR}/utf8_range-9999/third_party/utf8_range"

DESCRIPTION="Fast UTF-8 validation with Range algorithm (NEON+SSE4+AVX2)"
HOMEPAGE="https://github.com/protocolbuffers/protobuf/tree/main/third_party/utf8_range"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm64"
SLOT="0"
IUSE+=" fallback-commit test"
# See https://github.com/protocolbuffers/utf8_range/blob/main/.github/workflows/cmake_tests.yml#L14
RDEPEND+="
	>=dev-cpp/abseil-cpp-20220623.0:0/20220623
"
BDEPEND+="
	>=dev-build/cmake-3.5
	test? (
		>=dev-cpp/gtest-1.12.1
	)
"
DOCS=( README.md )
PATCHES=(
	"${FILESDIR}/utf8_range-9999-396e26b-shared-libs.patch"
)

src_unpack() {
	use fallback-commit && export EGIT_COMMIT="${EGIT_COMMIT}"
	git-r3_src_unpack
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
