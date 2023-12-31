# Copyright 1999-2023 Gentoo Authors
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
+cbdt cbdt-win +colrv1 colrv1-no-flags r2
"
REQUIRED_USE="
	|| (
		cbdt
		cbdt-win
		colrv1
		colrv1-no-flags
	)
"
SLOT="0"
RDEPEND="
	>=media-libs/fontconfig-2.11.91
	>=x11-libs/cairo-1.16.0
	media-libs/freetype[png]
	colrv1? (
		|| (
			>=media-fonts/noto-color-emoji-2.038_alpha[colrv1?,colrv1-no-flags?]
			>=media-fonts/noto-color-emoji-bin-2.038_alpha[colrv1?,colrv1-no-flags?]
		)
	)
	cbdt? (
		|| (
			<media-fonts/noto-color-emoji-2.034_alpha
			<media-fonts/noto-color-emoji-bin-2.034_alpha
			>=media-fonts/noto-color-emoji-2.034_alpha[cbdt?,cbdt-win?]
			>=media-fonts/noto-color-emoji-bin-2.034_alpha[cbdt?,cbdt-win?]
			media-fonts/noto-emoji
		)
	)
"
DEPEND="${RDEPEND}"
SRC_URI=""
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="nofetch"
FONT_CONF=(
	"${S}/61-noto.conf"
)

pkg_setup() {
	export CBDT_DEFAULT=${NOTO_COLOR_EMOJI_CBDT_DEFAULT:-"Noto Color Emoji"}
	export COLRV1_DEFAULT=${NOTO_COLOR_EMOJI_COLRV1_DEFAULT:-"Noto COLRv1"}
einfo
einfo "NOTO_COLOR_EMOJI_CBDT_DEFAULT:\t${CBDT_DEFAULT}"
einfo "NOTO_COLOR_EMOJI_COLRV1_DEFAULT:\t${COLRV1_DEFAULT}"
einfo
einfo "See \`epkginfo -x media-fonts/noto-color-emoji-config::oiledmachine-overlay\`"
einfo "or metadata.xml for valid values or instructions to change them."
einfo
	font_pkg_setup
}

src_unpack() {
	mkdir -p "${S}" || die
	cat "${FILESDIR}/61-noto-${MY_PV}.conf" > "${S}/61-noto.conf" || die
	if has_version "media-fonts/noto-emoji" ; then
eerror
eerror "USE=-colrv1 is required if using distro noto-emoji package."
eerror
		die
	fi

	if ! use cbdt && ! use cbdt-win ; then
		sed -i -e '/__BEGIN_HAS_CBDT__/,/__END_HAS_CBDT__/d' "${S}/61-noto.conf" || die
	else
		sed -i -e '/__BEGIN_HAS_CBDT__/d' "${S}/61-noto.conf" || die
		sed -i -e '/__END_HAS_CBDT__/d' "${S}/61-noto.conf" || die
		sed -i -e "s|__HAS_CBDT__|${CBDT_DEFAULT}|g" "${S}/61-noto.conf" || die
	fi
	if use colrv1 || use colrv1-no-flags ; then
		sed -i -e "s|__HAS_COLRV1__|${COLRV1_DEFAULT}|g" "${S}/61-noto.conf" || die
	else
		sed -i -e "s|__HAS_COLRV1__|${CBDT_DEFAULT}|g" "${S}/61-noto.conf" || die
	fi
}

src_install() {
	font_src_install
	rm -rf "${ED}/usr/share/fonts" || die
}

pkg_postinst() {
	eselect fontconfig enable 61-noto.conf
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
	font_pkg_postrm
	if use cbdt && use colrv1 ; then
ewarn
ewarn "Manual changes to 61-noto.conf may be required for older apps to support"
ewarn "Unicode 15 emojis by using only the CBDT font variant."
ewarn
	fi
}
