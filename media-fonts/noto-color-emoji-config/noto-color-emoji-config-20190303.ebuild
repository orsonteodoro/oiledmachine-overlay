# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="${PV}"

inherit font

DESCRIPTION="Minimal config to get colored Noto emojis working on Gentoo."
LICENSE="CC-PD"
KEYWORDS="
~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv
~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos
~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris
"
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
	mkdir -p "${S}" || die
	cat "${FILESDIR}/61-noto-${MY_PV}.conf" > "${S}/61-noto.conf" || die

	if use colorize-chrome-editboxes ; then
		cat "${FILESDIR}/41-noto-colorize-chrome-editboxes-${MY_PV}.conf" \
			> "${S}/41-noto-colorize-chrome-editboxes.conf" || die
		FONT_CONF+=( "${S}/41-noto-colorize-chrome-editboxes.conf" )
	fi
	if use colorize-firefox-editboxes ; then
		cat "${FILESDIR}/41-noto-colorize-firefox-editboxes-${MY_PV}.conf" \
			> "${S}/41-noto-colorize-firefox-editboxes.conf" || die
		FONT_CONF+=( "${S}/41-noto-colorize-firefox-editboxes.conf" )
	fi
}

src_install() {
	font_src_install
	rm -rf "${ED}/usr/share/fonts" || die
}

pkg_postinst() {
	eselect fontconfig enable 61-noto.conf
	if use colorize-chrome-editboxes ; then
		eselect fontconfig enable 41-noto-colorize-chrome-editboxes.conf
	fi
	if use colorize-firefox-editboxes ; then
		eselect fontconfig enable 41-noto-colorize-firefox-editboxes.conf
	fi
	font_pkg_postinst
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
	font_pkg_postrm
}
