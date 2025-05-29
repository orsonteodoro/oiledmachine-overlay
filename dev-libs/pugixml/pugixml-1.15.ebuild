# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Breaks during linking dev-util/hyprwayland-scanner
#CFLAGS_HARDENED_SANITIZERS="address hwaddress undefined"
#CFLAGS_HARDENED_SANITIZERS_COMPAT=( "gcc" "llvm" )
CFLAGS_HARDENED_TOLERANCE="4.0"
CFLAGS_HARDENED_USE_CASES="untrusted-data"

inherit cflags-hardened cmake-multilib flag-o-matic

KEYWORDS="
~amd64 ~arm64 ~x86
"
S="${WORKDIR}/${PN}-$(ver_cut 1-2 ${PV})"
# The release tarball doesn't have testing
SRC_URI="
https://github.com/zeux/pugixml/archive/refs/tags/v1.15.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Light-weight, simple, and fast XML parser for C++ with XPath support"
HOMEPAGE="
	https://pugixml.org/
	https://github.com/zeux/pugixml/
"
LICENSE="MIT"
IUSE+="
doc static-libs test
ebuild_revision_26
"
SLOT="0/$(ver_cut 1-2 ${PV})"
# U 22.04
DEPEND+="
	virtual/libc
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	|| (
		>=llvm-core/clang-14.0
		>=sys-devel/gcc-11.2.0
	)
	>=dev-build/cmake-3.5
"
RESTRICT="mirror"
DOCS=( docs readme.txt )

src_configure() {
	cflags-hardened_append
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DPUGIXML_BUILD_SHARED_AND_STATIC_LIBS=$(usex static-libs)
		-DPUGIXML_BUILD_TESTS=$(usex test)
	)
	cmake-multilib_src_configure
}

src_install() {
	cmake-multilib_src_install
	dodoc "LICENSE.md"
	use doc && einstalldocs
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED (1.15, 20250503)
# test-suite gcc:  passed with asan, ubsan
# test-suite clang:  passed with asan, ubsan
