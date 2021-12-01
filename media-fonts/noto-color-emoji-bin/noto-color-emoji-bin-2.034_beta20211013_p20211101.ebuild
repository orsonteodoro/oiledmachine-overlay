# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See NotoColorEmoji.tmpl.ttx.tmpl for versioning at
# <namerecord nameID="5" platformID="3" platEncID="1" langID="0x409">
EAPI=7
DESCRIPTION="NotoColorEmoji is colored emojis"
HOMEPAGE="https://www.google.com/get/noto/#emoji-qaae-color"
LICENSE="OFL-1.1"
KEYWORDS="~alpha ~amd64 ~amd64-linux ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 \
~s390 ~sh ~sparc ~sparc-solaris ~x64-solaris ~x86 ~x86-linux ~x86-solaris"
inherit font
SLOT="0/${PV}"
RDEPEND=" !media-fonts/noto-color-emoji
	  !media-fonts/noto-emoji
	 >=media-libs/fontconfig-2.11.91
	   media-libs/freetype[png]
         >=x11-libs/cairo-1.16"
DEPEND="dev-python/fonttools
        ${RDEPEND}"
EGIT_COMMIT="9a5261d871451f9b5183c93483cbd68ed916b1e9"
GH_URI="https://github.com/googlefonts/noto-emoji/raw/${EGIT_COMMIT}/fonts/"
SRC_URI=\
"${GH_URI}/LICENSE -> ${P}.LICENSE
${GH_URI}/NotoColorEmoji.ttf -> ${P}.ttf"
RESTRICT="mirror"
S="${WORKDIR}"
FONT_SUFFIX="ttf"
FONT_CONF=( )

src_unpack() {
	mkdir -p "${S}" || die
	cp "${DISTDIR}/${P}.LICENSE" LICENSE || die
	cp "${DISTDIR}/${P}.ttf" NotoColorEmoji.ttf || die
}

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
	docinto licenses
	dodoc LICENSE
}

pkg_postinst() {
        rebuild_fontfiles
	fc-cache -fv
	ewarn \
"To see emojis in your x11-term you need to switch to a .utf8 suffixed locale\n\
via \`eselect locale\`.\n\
\n\
Try manually running \`fc-cache -fv\` on the non-root user account and\n\
logging off all accounts to get X to work.\n\
\n\
\`emerge noto-color-emoji-config\` from ebuild from oiledmachine-overlay to\n\
get noto color emojis to display properly on firefox, google-chrome, etc\n\
systemwide."
}

pkg_postrm() {
        rebuild_fontfiles
	fc-cache -fv
}
