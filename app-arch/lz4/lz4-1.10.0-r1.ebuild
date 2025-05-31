# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data system-set untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="HO IO"
EMESON_SOURCE="${S}/build/meson"

inherit cflags-hardened meson-multilib

KEYWORDS="
~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86
~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris
"
SRC_URI="
	https://github.com/lz4/lz4/archive/v${PV}.tar.gz -> ${P}.tar.gz
"

DESCRIPTION="Extremely Fast Compression algorithm"
HOMEPAGE="https://github.com/lz4/lz4"
LICENSE="BSD-2 GPL-2"
RESTRICT="
	!test? (
		test
	)
"
SLOT="0/1.10.0-meson"
IUSE="
static-libs test
ebuild_revision_15
"

PATCHES=(
	"${FILESDIR}/${PV}-fix-freestanding-test.patch"
	# https://github.com/lz4/lz4/pull/1485
	"${FILESDIR}/${PV}-meson-do-not-force-c99-mode.patch"
)

multilib_src_configure() {
	cflags-hardened_append
	local emesonargs=(
		-Dtests=$(usex test true false)
		-Ddefault_library=$(usex static-libs both shared)
	# https://bugs.gentoo.org/940641
		-Dossfuzz=false
	)
	# With -Dprograms=false, the test suite is only rudimentary, so build
	# them for testing non-native ABI as well.
	if multilib_is_native_abi || use test ; then
		emesonargs+=(
			-Dprograms=true
		)
	fi

	meson_src_configure
}
