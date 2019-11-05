# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See NotoColorEmoji.tmpl.ttx.tmpl for versioning at
# <namerecord nameID="5" platformID="3" platEncID="1" langID="0x409">
EAPI=6
DESCRIPTION="NotoColorEmoji is colored emojis"
HOMEPAGE="https://www.google.com/get/noto/#emoji-qaae-color"
LICENSE="OFL-1.1"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"
inherit font
SLOT="0"
RDEPEND=" !media-fonts/noto-color-emoji
	  !media-fonts/noto-emoji
	 >=media-libs/fontconfig-2.11.91
	   media-libs/freetype[png]
         >=x11-libs/cairo-1.16"
DEPEND="dev-python/fonttools
        ${RDEPEND}"
SRC_URI=\
"https://noto-website-2.storage.googleapis.com/pkgs/NotoColorEmoji-unhinted.zip \
	-> ${PN}-${PVR}.zip"
RESTRICT="mirror"
S="${WORKDIR}"
FONT_SUFFIX="ttf"
FONT_CONF=( )

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

src_install() {
	font_src_install
}

pkg_postinst() {
        rebuild_fontfiles
	fc-cache -fv
	ewarn \
"To see emojis in your x11-term you need to switch to a utf8 locale.\n\
Try manually running \`fc-cache -fv\` on the non-root user account and\n\
logging off all accounts to get X to work.\n\
\`emerge noto-color-emoji-config\` from ebuild from oiledmachine-overlay to\n\
get noto color emojis to display properly on firefox, google-chrome, etc\n\
systemwide."
}

pkg_postrm() {
        rebuild_fontfiles
	fc-cache -fv
}
