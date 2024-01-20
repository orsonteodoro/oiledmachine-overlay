# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual to select between different tmpfiles.d handlers"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="systemd +tmpfiles"

RDEPEND="
	!prefix-guest? (
		systemd? ( sys-apps/systemd )
		!systemd? ( sys-apps/systemd-utils[tmpfiles?] )
	)
"
# system is still fine with tmpfiles off.

# Reason for tmpfiles USE flag.
# https://www-cdn-origin.gentoo.org/support/news-items/2022-11-21-tmpfiles-clean.html

pkg_setup() {
	if use tmpfiles ; then
ewarn
ewarn "Using tmpfile USE flag may add realtime industrial production defects,"
ewarn "poor quality music production, disrupt live performance, cause gaming"
ewarn "loss if not opt-out."
ewarn
ewarn "To opt-out either disable the tmpfiles USE flag or comment out in"
ewarn "/etc/cron.daily/systemd-tmpfiles-clean"
ewarn
	fi
}
