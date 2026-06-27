# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHKL_TIMESTAMPS=(
	"x11-base/xorg-server-9999"
	"x11-libs/libX11-9999"
)

inherit chkl linux-info secure-version xorg-3

DESCRIPTION="Driver for Synaptics touchpads"

KEYWORDS="amd64 arm arm64 ~loong ~mips ppc ppc64 x86"

RDEPEND="
	>=x11-base/xorg-server-${XORG_SERVER_PV}:=
	>=x11-libs/libX11-${LIBX11_PV}:=
	>=x11-libs/libXi-${LIBXI_PV}:=
	>=x11-libs/libXtst-${LIBXTST_PV}:=
	kernel_linux? ( >=dev-libs/libevdev-0.4:= )"
DEPEND="
	${RDEPEND}
	>=sys-kernel/linux-headers-2.6.37:=
	x11-base/xorg-proto:="

check_reqs() {
	linux-info_pkg_setup

	# Just a friendly warning
	if ! linux_config_exists \
			|| ! linux_chkconfig_present INPUT_EVDEV; then
		ewarn
		ewarn "This driver requires event interface support in your kernel"
		ewarn "  Device Drivers --->"
		ewarn "    Input device support --->"
		ewarn "      <*>     Event interface"
		ewarn
	fi
}

pkg_pretend() {
	check_reqs
}

pkg_setup() {
	check_reqs
}

src_configure() {
	chkl_check_many_timestamps
	xorg-3_src_configure
}
