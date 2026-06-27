# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHKL_TIMESTAMPS=(
	"dev-libs/libinput-9999"
)

inherit chkl linux-info secure-version xorg-3

DESCRIPTION="X.org input driver based on libinput"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND=">=dev-libs/libinput-${LIBINPUT_PV}:="
DEPEND="${RDEPEND}
	>=x11-base/xorg-proto-2021.5:="

DOCS=( "README.md" )

pkg_pretend() {
	CONFIG_CHECK="~TIMERFD"
	check_extra_config
}

src_configure() {
	chkl_check_many_timestamps
	xorg-3_src_configure
}
