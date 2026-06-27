# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_DRI=always

CHKL_TIMESTAMPS=(
	"media-libs/mesa-9999"
	"x11-base/xorg-server-9999"
)

inherit chkl linux-info secure-version xorg-3

if [[ ${PV} != 9999* ]]; then
	KEYWORDS="~alpha ~amd64 ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

DESCRIPTION="ATI video driver"
HOMEPAGE="https://www.x.org/wiki/ati/"

IUSE="udev"

RDEPEND="
	>=media-libs/mesa-${MESA_PV}:=
	>=x11-libs/libdrm-${LIBDRM_PV}:=[video_cards_radeon]
	>=x11-libs/libpciaccess-${LIBPCIACCESS_PV}:=
	>=x11-base/xorg-server-${XORG_SERVER_PV}:=[-minimal]
	udev? ( virtual/libudev:= )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto:="

pkg_pretend() {
	if use kernel_linux; then
		if kernel_is -ge 3 9; then
			CONFIG_CHECK="~!DRM_RADEON_UMS ~!FB_RADEON"
		else
			CONFIG_CHECK="~DRM_RADEON_KMS ~!FB_RADEON"
		fi
	fi
	check_extra_config
}

pkg_setup() {
	linux-info_pkg_setup
	xorg-3_pkg_setup
}

src_configure() {
	chkl_check_many_timestamps
	local XORG_CONFIGURE_OPTIONS=(
		--enable-glamor
		$(use_enable udev)
	)
	xorg-3_src_configure
}
