# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

CMAKE_ECLASS="cmake"
MULTILIB_CHOST_TOOLS=(
	"/usr/bin/taglib-config"
)

inherit cmake-multilib

KEYWORDS="
~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc
~x86 ~amd64-linux ~x86-linux ~ppc-macos
"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/taglib/taglib/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Library for reading and editing audio meta data"
HOMEPAGE="https://taglib.github.io/"
LICENSE="
	LGPL-2.1
	MPL-1.1
"
RESTRICT="
	mirror
	!test? (
		test
	)
"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" debug examples test"
RDEPEND+="
	>=sys-libs/zlib-1.2.11[${MULTILIB_USEDEP}]
	>=dev-libs/utfcpp-3.2.1
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	test? (
		>=dev-util/cppunit-1.15.1[${MULTILIB_USEDEP}]
	)
"
PATCHES=(
#	"${FILESDIR}/${PN}-2.0_pre20190317-merge-conflict-avoidance.patch"
#	"${FILESDIR}/${PN}-2.0_pre20190317-install-examples.patch"
#	"${FILESDIR}/${PN}-2.0_pre20190317-link-tag2-for-tagwriter.patch"
#	"${FILESDIR}/${PN}-2.0_pre20190317-link-tag2-for-tag2_c.patch"
)

src_prepare() {
	append-flags -I/usr/include/utf8cpp
	cmake_src_prepare
	sed \
		-i \
		-e "s/BUILD_TESTS AND NOT BUILD_SHARED_LIBS/BUILD_TESTS/" \
		CMakeLists.txt \
		ConfigureChecks.cmake \
		|| die
}

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=$(multilib_native_usex examples)
		-DBUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}
