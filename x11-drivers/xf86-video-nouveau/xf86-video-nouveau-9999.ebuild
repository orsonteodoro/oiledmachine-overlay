# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FALLBACK_COMMIT="4ee596fb3a3ff58fde7456ce364e54f8860cd016" # Jun 14, 2026
XORG_DRI="always"

inherit secure-version xorg-3

KEYWORDS="amd64 ~arm64 ~loong ppc ppc64 ~riscv x86"

DESCRIPTION="Accelerated Open Source driver for nVidia cards"
HOMEPAGE="
	https://nouveau.freedesktop.org/
	https://gitlab.freedesktop.org/xorg/driver/xf86-video-nouveau
"
IUSE+=" ebuild_revision_3"
RDEPEND="
	>=x11-libs/libdrm-${LIBDRM_PV}:=[video_cards_nouveau]
	virtual/libudev:=
"
DEPEND="
	${RDEPEND}
"
