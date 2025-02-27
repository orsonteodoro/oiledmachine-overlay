# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual to select between different tmpfiles.d handlers"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="systemd +tmpfiles"

RDEPEND="
	!prefix-guest? (
		systemd? ( sys-apps/systemd )
		!systemd? ( sys-apps/systemd-utils[tmpfiles?] )
	)
	!tmpfiles? (
		!sys-apps/systemd
	)
"
# system is still fine with tmpfiles off.

# Reason for tmpfiles USE flag.
# https://www-cdn-origin.gentoo.org/support/news-items/2022-11-21-tmpfiles-clean.html

pkg_setup() {
	if use tmpfiles ; then
ewarn
ewarn "Using the tmpfile USE flag may add realtime irreversable industrial"
ewarn "production defects, poor quality music production, disrupt live"
ewarn "or movie performance, cause gaming loss or irreversable hardcore mode"
ewarn "character loss if not opt-out."
ewarn
ewarn "To opt-out either disable the tmpfiles USE flag or comment out in"
ewarn "/etc/cron.daily/systemd-tmpfiles-clean"
ewarn
	fi
}
