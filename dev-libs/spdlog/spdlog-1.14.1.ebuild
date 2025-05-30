# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib sandbox-changes

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="v1.x"
	EGIT_REPO_URI="https://github.com/gabime/${PN}"
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm64"
	SRC_URI="
https://github.com/gabime/spdlog/archive/v${PV}.tar.gz -> ${P}.tar.gz
	"
fi

DESCRIPTION="Very fast, header only, C++ logging library"
HOMEPAGE="https://github.com/gabime/spdlog"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE="test"
DEPEND="
	>=dev-libs/libfmt-8.0.0:=[${MULTILIB_USEDEP}]
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.10
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
"
PATCHES=(
	"${FILESDIR}/${PN}-force_external_fmt.patch"
)

check_network_sandbox() {
	# We need to download catch2 to make it multilib since the catch ebuild
	# package is unilib.
	sandbox-changes_no_network_sandbox "To download catch2 for running multilib tests"
}

pkg_setup() {
	use test && check_network_sandbox
}

src_prepare() {
	cmake_src_prepare
	rm -r \
		"include/spdlog/fmt/bundled" \
		|| die "Failed to delete bundled libfmt"
	sed -i \
		-e "s|Catch2 3 QUIET|Catch2 3|g" \
		"tests/CMakeLists.txt" \
		|| die
}

src_configure() {
	local mycmakeargs=(
		-DSPDLOG_BUILD_BENCH=no
		-DSPDLOG_BUILD_EXAMPLE=no
		-DSPDLOG_BUILD_SHARED=yes
		-DSPDLOG_BUILD_TESTS=$(usex test)
		-DSPDLOG_FMT_EXTERNAL=yes
	)
	cmake-multilib_src_configure
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED 1.12.0 (20230715)
# Notes:  Both 32-bit and 64-bit tested
#     Start 1: spdlog-utests
# 1/1 Test #1: spdlog-utests ....................   Passed    5.08 sec
#
# 100% tests passed, 0 tests failed out of 1
#
# Total Test time (real) =   5.08 sec
