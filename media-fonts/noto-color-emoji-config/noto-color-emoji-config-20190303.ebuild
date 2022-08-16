# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="${PV}"

inherit font

DESCRIPTION="Minimal config to get colored Noto emojis working on Gentoo."
LICENSE="CC-PD"
KEYWORDS="~amd64 ~x86"
IUSE="
-colorize-firefox-editboxes -colorize-chrome-editboxes colorize-white-smiley
"
REQUIRED_USE=""
SLOT="0"
RDEPEND="
	>=media-libs/fontconfig-2.11.91
	>=x11-libs/cairo-1.16.0
	media-libs/freetype[png]
	|| (
		media-fonts/noto-emoji
		media-fonts/noto-color-emoji
		media-fonts/noto-color-emoji-bin
	)
	colorize-white-smiley? ( media-fonts/ttf-bitstream-vera )
"
# colorize-white-smiley maybe works on firefox?
DEPEND="${RDEPEND}"
SRC_URI=""
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="nofetch"

FONT_CONF=( "${S}/61-noto.conf" )

src_unpack() {
	mkdir -p "${S}"
	cp "${FILESDIR}/61-noto-${MY_PV}.conf" "${S}/61-noto.conf" || die

	if use colorize-chrome-editboxes ; then
		cp "${FILESDIR}/41-noto-colorize-chrome-editboxes-${MY_PV}.conf" \
			"${S}/41-noto-colorize-chrome-editboxes.conf" || die
		FONT_CONF+=( "${S}/41-noto-colorize-chrome-editboxes.conf" )
	fi
	if use colorize-firefox-editboxes ; then
		cp "${FILESDIR}/41-noto-colorize-firefox-editboxes-${MY_PV}.conf" \
			"${S}/41-noto-colorize-firefox-editboxes.conf" || die
		FONT_CONF+=( "${S}/41-noto-colorize-firefox-editboxes.conf" )
	fi
}

pkg_postinst() {
	eselect fontconfig enable 61-noto.conf
	if use colorize-chrome-editboxes ; then
		eselect fontconfig enable 41-noto-colorize-chrome-editboxes.conf
	fi
	if use colorize-firefox-editboxes ; then
		eselect fontconfig enable 41-noto-colorize-firefox-editboxes.conf
	fi
	fc-cache -fv
ewarn
ewarn "To see emojis in your x11-term you need to switch to a utf8 locale."
ewarn "Try manually running \`fc-cache -fv\` on the non-root user account and"
ewarn "logging off all accounts to get X to work."
ewarn
}

pkg_postrm() {
einfo
einfo "Errors immediately below are okay."
einfo
	eselect fontconfig disable 61-noto.conf
	eselect fontconfig disable 41-noto-colorize-chrome-editboxes.conf
	eselect fontconfig disable 41-noto-colorize-firefox-editboxes.conf
	rebuild_fontfiles
	fc-cache -fv
}
