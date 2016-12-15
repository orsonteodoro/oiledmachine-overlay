# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit font

DESCRIPTION="NotoColorEmoji is colored emojis"
HOMEPAGE="https://www.google.com/get/noto/#emoji-qaae-color"
SRC_URI="https://noto-website.storage.googleapis.com/pkgs/NotoColorEmoji-unhinted.zip"
# renamed from upstream's unversioned NotoColorEmoji-unhinted.zip
# version number based on the timestamp of most recently updated file in the zip

S="${WORKDIR}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="reassign-ugly-text-emojis"

RDEPEND=">=media-libs/fontconfig-2.11.91
         >=x11-libs/cairo-1.14.6[colored-emojis]
	media-libs/freetype[png]
        !media-fonts/noto-color-emoji"

DEPEND="dev-python/fonttools
        ${RDEPEND}"

FONT_SUFFIX="ttf"
FONT_CONF=( "${FILESDIR}/01-notosans.conf" "${FILESDIR}/61-notosans.conf" )

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
	mkdir -p "${D}/etc/fonts/conf.avail/"
	cp "${FILESDIR}/01-notosans.conf" "${D}"/etc/fonts/conf.avail/ || die "failed to copy fontconfig config"
}

pkg_postinst() {
	eselect fontconfig enable 01-notosans.conf
	if use reassign-ugly-text-emojis ; then
		eselect fontconfig enable 61-notosans.conf
		ewarn "You may need to manually add exceptions to 61-notosans.conf based on fonts installed and what was in the serif and sans-serif section of 60-latin.conf and run \`fc-cache -fv\`.."
	fi
	eselect fontconfig disable 70-no-bitmaps.conf
        rebuild_fontfiles
	ewarn "You may need to \`eselect fontconfig enable 01-notosans.conf\` manually and run \`fc-cache -fv\`."
	ewarn "You may need to \`eselect fontconfig disable 70-no-bitmaps.conf\` manually and run \`fc-cache -fv\`."
}
