# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CommitId="b40bae27785787b6dd70788986fd96434cf90ae2"

# For deps versioning, see:
# https://github.com/pytorch/cpuinfo/blob/b40bae27785787b6dd70788986fd96434cf90ae2/cmake/DownloadGoogleTest.cmake

inherit cmake

KEYWORDS="~amd64 ~arm ~arm64 ~x86"
S="${WORKDIR}/${PN}-${CommitId}"
SRC_URI="
https://github.com/pytorch/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="CPU INFOrmation library"
HOMEPAGE="https://github.com/pytorch/cpuinfo/"
LICENSE="MIT"
RESTRICT="
	!test? (
		test
	)
"
SLOT="0"
IUSE="test"
BDEPEND="
	test? (
		>=dev-cpp/gtest-1.11.0
	)
"
PATCHES=(
	"${FILESDIR}/${P}-gentoo.patch"
)

src_prepare() {
	cmake_src_prepare

	# >=dev-cpp/gtest-1.13.0 depends on building with at least C++14 standard
	sed -i -e 's/CXX_STANDARD 11/CXX_STANDARD 14/' \
		CMakeLists.txt || die "sed failed"
}

src_configure() {
	local mycmakeargs=(
		-DCPUINFO_BUILD_BENCHMARKS=OFF
		-DCPUINFO_BUILD_UNIT_TESTS=$(usex test ON OFF)
	)
	cmake_src_configure
}
