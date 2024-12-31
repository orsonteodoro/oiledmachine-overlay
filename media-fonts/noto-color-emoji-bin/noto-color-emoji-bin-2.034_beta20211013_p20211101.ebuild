# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See NotoColorEmoji.tmpl.ttx.tmpl for versioning at
# <namerecord nameID="5" platformID="3" platEncID="1" langID="0x409">

inherit font

DESCRIPTION="A prebuilt font for colored emojis"
HOMEPAGE="https://www.google.com/get/noto/#emoji-qaae-color"
LICENSE="OFL-1.1"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE="+cbdt cbdt-win"
REQUIRED_USE="
	|| (
		cbdt
		cbdt-win
	)
"
RDEPEND="
	!media-fonts/noto-color-emoji
	!media-fonts/noto-emoji
	>=media-libs/fontconfig-2.11.91
        >=x11-libs/cairo-1.16
	media-libs/freetype[png]
"
DEPEND="
        ${RDEPEND}
	dev-python/fonttools
"
EGIT_COMMIT="9a5261d871451f9b5183c93483cbd68ed916b1e9"
GH_URI="https://github.com/googlefonts/noto-emoji/raw/${EGIT_COMMIT}/fonts/"
SRC_URI="
	${GH_URI}/LICENSE -> ${P}.LICENSE
	cbdt? (
		${GH_URI}/NotoColorEmoji.ttf
			-> NotoColorEmoji.ttf.${EGIT_COMMIT:0:7}
	)
	cbdt-win? (
		${GH_URI}/NotoColorEmoji_WindowsCompatible.ttf
			-> NotoColorEmoji_WindowsCompatible.ttf.${EGIT_COMMIT:0:7}
	)
"
RESTRICT="mirror"
S="${WORKDIR}"
FONT_SUFFIX="ttf"
FONT_CONF=( )

src_unpack() {
	mkdir -p "${S}" || die
	cp "${DISTDIR}/${P}.LICENSE" LICENSE || die

	if use cbdt ; then
		cp "${DISTDIR}/NotoColorEmoji.ttf.${EGIT_COMMIT:0:7}" \
			NotoColorEmoji.ttf || die
	fi

	if use cbdt-win ; then
		cp "${DISTDIR}/NotoColorEmoji_WindowsCompatible.ttf.${EGIT_COMMIT:0:7}" \
			NotoColorEmoji_WindowsCompatible.ttf || die
	fi
}

src_install() {
	font_src_install
	docinto licenses
	dodoc LICENSE

	if use cbdt-win ; then
		insinto /usr/share/${PN/-bin}
		doins NotoColorEmoji_WindowsCompatible.ttf
	fi

	find "${ED}/usr/share/fonts" -name "*WindowsCompatible*" -delete
}

pkg_postinst() {
	font_pkg_postinst
ewarn
ewarn "To see emojis in your x11-term you need to switch to a .utf8 suffixed"
ewarn "locale via \`eselect locale\`."
ewarn
ewarn "Try manually running \`fc-cache -fv\` on the non-root user account and"
ewarn "logging off all accounts to get X to work."
ewarn
ewarn "\`emerge noto-color-emoji-config\` from ebuild from oiledmachine-overlay"
ewarn "to get noto color emojis to display properly on firefox, google-chrome,"
ewarn "etc systemwide."
ewarn
}
