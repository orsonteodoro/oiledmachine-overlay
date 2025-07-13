# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical untrusted-data"

inherit cflags-hardened cmake-multilib

KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~sparc"
SRC_URI="
https://github.com/microsoft/mimalloc/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="A compact general purpose allocator with excellent performance"
HOMEPAGE="https://github.com/microsoft/mimalloc"
LICENSE="MIT"
SLOT="0/3"
IUSE="
-debug -guarded test -valgrind
ebuild_revision_13
"
RESTRICT="
	!test? (
		test
	)
"
DEPEND="
	valgrind? (
		dev-debug/valgrind
	)
"

src_configure() {
	cflags-hardened_append
	local mycmakeargs=(
		-DMI_BUILD_TESTS=$(usex test)
		-DMI_BUILD_OBJECT=OFF
		-DMI_BUILD_STATIC=OFF
		-DMI_DEBUG_FULL=$(usex debug)
		-DMI_GUARDED=$(usex guarded)
		-DMI_INSTALL_TOPLEVEL=ON
		-DMI_LIBC_MUSL=$(usex elibc_musl)
		# Don't inject -march=XXX \
		-DMI_OPT_ARCH=OFF
		-DMI_SECURE=ON
		-DMI_TRACK_VALGRIND=$(usex valgrind)
	)
	cmake-multilib_src_configure
}
