# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U 22.04

# Breaks during linking dev-util/hyprwayland-scanner
#CFLAGS_HARDENED_SANITIZERS="address hwaddress undefined"
#CFLAGS_HARDENED_SANITIZERS_COMPAT="clang gcc"
CFLAGS_HARDENED_TOLERANCE="4.0"
CFLAGS_HARDENED_USE_CASES="untrusted-data"
GCC_COMPAT=(
	"gcc_slot_14_3" # CY2026 is GCC 14.2; CUDA-12.9, CUDA-12.8, U24
	"gcc_slot_13_4" # CUDA-12.6, CUDA-12.5, CUDA-12.4, CUDA-12.3, U24 (default)
	"gcc_slot_11_5" # CY2025 is GCC 11.2.1, CUDA-11.8, U22 (default), U24
)

inherit cflags-hardened check-compiler-switch cmake-multilib flag-o-matic libstdcxx-slot

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
ebuild_revision_29
"
SLOT="0/$(ver_cut 1-2 ${PV})"
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
DOCS=( "docs" "readme.txt" )

pkg_setup() {
	check-compiler-switch_start
	libstdcxx-slot_verify
}

src_configure() {
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

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
