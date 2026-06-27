# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_DRI=always
inherit secure-version xorg-3

DESCRIPTION="VMware SVGA video driver"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND="
	kernel_linux? (
		>=x11-libs/libdrm-${LIBDRM_PV}:=[video_cards_vmware]
		<media-libs/mesa-25.2:=[xa]
	)"
DEPEND="${RDEPEND}"
