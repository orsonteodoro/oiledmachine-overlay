# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FALLBACK_COMMIT="dffcc9e6857b0cc07154000d2ce86d4fe022a3f3" # Jul 12, 2025
XORG_DRI="always"

inherit secure-version xorg-3

KEYWORDS="amd64 ~arm64 x86"

DESCRIPTION="VMware SVGA video driver"
IUSE+=" ebuild_revision_3"
RDEPEND="
	kernel_linux? (
		>=x11-libs/libdrm-${LIBDRM_PV}:=[video_cards_vmware]
		<media-libs/mesa-25.2:=[xa]
	)
"
DEPEND="
	${RDEPEND}
"

src_configure() {
	xorg-3_src_configure
}
