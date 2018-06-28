# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
IUSE="colorize-xfce4-terminal-white-smiley colorize-chrome-white-smiley"

RDEPEND=">=media-libs/fontconfig-2.11.91
         >=x11-libs/cairo-1.14.6[colored-emojis]
	media-libs/freetype[png]
        !media-fonts/noto-color-emoji"

DEPEND="dev-python/fonttools
        ${RDEPEND}"

FONT_SUFFIX="ttf"
FONT_CONF=( "${FILESDIR}/01-noto-scalable.conf" "${FILESDIR}/02-noto-colorize-chrome-white-smiley.conf" "${FILESDIR}/02-noto-colorize-xfce4-terminal-white-smiley.conf" "${FILESDIR}/61-noto-colorize.conf" )

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
	mkdir -p "${D}/etc/fonts/conf.avail/"
	cp "${FILESDIR}/01-notosans.conf" "${D}"/etc/fonts/conf.avail/ || die "failed to copy fontconfig config"
}

pkg_postinst() {
	eselect fontconfig enable 01-noto-scalable.conf
	if use colorize-chrome-white-smiley ; then
		eselect fontconfig enable 02-noto-colorize-chrome-white-smiley.conf
	else
		eselect fontconfig disable 02-noto-colorize-chrome-white-smiley.conf
	fi
	if use colorize-xfce4-terminal-smiley ; then
		eselect fontconfig enable 02-noto-colorize-xfce4-terminal-white-smiley.conf
	else
		eselect fontconfig disable 02-noto-colorize-xfce4-terminal-white-smiley.conf
	fi
	eselect fontconfig enable 61-noto-colorize.conf
	eselect fontconfig disable 70-no-bitmaps.conf
        rebuild_fontfiles
	fc-cache -fv
	ewarn "To see emojis in your x11-term you need to switch to a utf8 locale."
	ewarn "Try manually running \`fc-cache -fv\` on the non-root user account and logging off all accounts to get X to work."
	ewarn "If you see enlarged emojis in Firefox 52.x, it requires the noto-fix use flag and the Firefox 52.x in the oiledmachine-overlay or Firefox 58.x or newer in the gentoo overlay."
}

pkg_postrm() {
	eselect fontconfig disable 01-noto-scalable.conf
	eselect fontconfig disable 02-noto-colorize-chrome-white-smiley.conf
	eselect fontconfig disable 02-noto-colorize-xfce4-terminal-white-smiley.conf
	eselect fontconfig disable 61-noto-colorize.conf
	eselect fontconfig enable 70-no-bitmaps.conf
        rebuild_fontfiles
	fc-cache -fv
}
