# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit font

DESCRIPTION="NotoColorEmoji is colored emojis"
HOMEPAGE="https://www.google.com/get/noto/#emoji-qaae-color"
SRC_URI="https://noto-website.storage.googleapis.com/pkgs/NotoColorEmoji-unhinted.zip -> ${P}.zip"
# renamed from upstream's unversioned NotoColorEmoji-unhinted.zip
# version number based on the timestamp of most recently updated file in the zip

S="${WORKDIR}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-libs/fontconfig-2.11.91
         >=x11-libs/cairo-1.16
	media-libs/freetype[png]
        !media-fonts/noto-color-emoji
	!media-fonts/noto-emoji"

DEPEND="dev-python/fonttools
        ${RDEPEND}"

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

src_prepare() {
	epatch_user
}

src_install() {
	font_src_install
}

pkg_postinst() {
        rebuild_fontfiles
	fc-cache -fv
	ewarn "To see emojis in your x11-term you need to switch to a utf8 locale."
	ewarn "Try manually running \`fc-cache -fv\` on the non-root user account and logging off all accounts to get X to work."
	ewarn "\`emerge noto-color-emoji-config\` from ebuild from oiledmachine-overlay to get noto color emojis to display properly on firefox, google-chrome, etc systemwide."
}

pkg_postrm() {
        rebuild_fontfiles
	fc-cache -fv
}
