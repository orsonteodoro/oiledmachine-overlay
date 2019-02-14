# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils font

DESCRIPTION="Minimal config to get colored Noto emojis working on Gentoo."
SRC_URI=""

S="${WORKDIR}"

LICENSE="CC-PD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE=""

RDEPEND=">=media-libs/fontconfig-2.11.91
         >=x11-libs/cairo-1.16.0
	 media-libs/freetype[png]
	 media-fonts/noto-emoji
	 !media-fonts/noto-color-emoji
	 !media-fonts/noto-color-emoji-bin
	"

DEPEND="${RDEPEND}"
RESTRICT="nofetch"

FONT_CONF=( "${FILESDIR}/61-noto.conf" )

rebuild_fontfiles() {
        einfo "Refreshing fonts.scale and fonts.dir..."
        cd ${FONT_ROOT}
        mkfontdir -- ${FONT_TARGETS}
        if [ "${ROOT}" = "/" ] &&  [ -x /usr/bin/fc-cache ]
        then
                einfo "Updating font cache..."
                HOME="/root" /usr/bin/fc-cache -f ${FONT_TARGETS}
        fi
}

pkg_postinst() {
	eselect fontconfig enable 61-noto.conf
        rebuild_fontfiles
	fc-cache -fv
	ewarn "To see emojis in your x11-term you need to switch to a utf8 locale."
	ewarn "Try manually running \`fc-cache -fv\` on the non-root user account and logging off all accounts to get X to work."
	ewarn "If you see enlarged emojis in Firefox 52.x, it requires the noto-fix use flag and the Firefox 52.x in the oiledmachine-overlay or Firefox 58.x or newer in the gentoo overlay."
}

pkg_postrm() {
	eselect fontconfig disable 61-noto.conf
        rebuild_fontfiles
	fc-cache -fv
}
