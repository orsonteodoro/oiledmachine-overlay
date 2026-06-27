# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHKL_TIMESTAMPS=(
	"x11-base/xorg-server-9999"
)

inherit chkl secure-version xorg-meson

if [[ ${PV} != 9999* ]]; then
	KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="Accelerated Open Source driver for AMDGPU cards"

IUSE+="
udev
"

RDEPEND=">=x11-libs/libdrm-${LIBDRM_PV}:=[video_cards_amdgpu]
	>=x11-base/xorg-server-${XORG_SERVER_PV}:=[-minimal]
	udev? ( virtual/libudev:= )"
DEPEND="${RDEPEND}"

src_configure() {
	chkl_check_many_timestamps
	local XORG_CONFIGURE_OPTIONS=(
		-Dglamor=enabled
		$(meson_feature udev)
	)
	xorg-meson_src_configure
}
