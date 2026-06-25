# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild uses AI inference for clarification.

CFLAGS_HARDENED_USE_CASES="security-critical untrusted-data"

# Upstream wants balanced security but this ebuild overlay tries to be
# consistenly security-critical.
MODES=(
	"+security-critical"
	"balanced"
	"bug-testing"
	"performance-critical"
)

inherit cflags-hardened cmake-multilib

KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~sparc"
SRC_URI="
https://github.com/microsoft/mimalloc/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="A compact general purpose allocator with excellent performance"
HOMEPAGE="https://github.com/microsoft/mimalloc"
LICENSE="MIT"
SOVER="${PV%%.*}"
SLOT="0/${SOVER}"
IUSE="
${MODES[@]/+}
-debug test -valgrind
ebuild_revision_22
"
REQUIRED_USE="
	|| (
		${MODES[@]/+}
	)
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
		-DMI_INSTALL_TOPLEVEL=ON
		-DMI_LIBC_MUSL=$(usex elibc_musl)
		# Don't inject -march=XXX \
		-DMI_OPT_ARCH=OFF
		-DMI_TRACK_VALGRIND=$(usex valgrind)
	)
	if use security-critical ; then
		mycmakeargs+=(
			-DMI_GUARDED=ON
			-DMI_SECURE=ON
			-DMI_SECURE_FULL=ON
		)
	elif use balanced ; then
		mycmakeargs+=(
			-DMI_GUARDED=OFF
			-DMI_SECURE=ON
			-DMI_SECURE_FULL=OFF
		)
	elif use bug-testing ; then
		mycmakeargs+=(
			-DMI_GUARDED=ON
			-DMI_SECURE=OFF
			-DMI_SECURE_FULL=OFF
		)
	else # performance-critical
		mycmakeargs+=(
			-DMI_GUARDED=OFF
			-DMI_SECURE=OFF
			-DMI_SECURE_FULL=OFF
		)
	fi
	cmake-multilib_src_configure
}
