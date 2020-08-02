# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
EGIT_COMMIT="65a6a4e225fff1288148de92721418e1c634713b"
inherit cmake-multilib

DESCRIPTION="Library for reading and editing audio meta data"
HOMEPAGE="https://taglib.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1 MPL-1.1"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
SLOT="taglib2-preview/${PV}" # -preview suffix added to avoid future conflicts with official release
IUSE="debug examples test"
RESTRICT="mirror !test? ( test )"

BDEPEND="virtual/pkgconfig"
RDEPEND=">=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( >=dev-util/cppunit-1.13.2[${MULTILIB_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}/${PN}-${PV}-merge-conflict-avoidance.patch"
	"${FILESDIR}/${PN}-2.0_pre20190317-install-examples.patch"
)

MULTILIB_CHOST_TOOLS=(
	/usr/bin/taglib2-config
)

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

src_prepare() {
	cmake_src_prepare

	sed -e "s/BUILD_TESTS AND NOT BUILD_SHARED_LIBS/BUILD_TESTS/" \
		-i CMakeLists.txt \
		-i ConfigureChecks.cmake || die
}

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=$(multilib_native_usex examples)
		-DBUILD_TESTS=$(usex test)
	)

	cmake_src_configure
}
