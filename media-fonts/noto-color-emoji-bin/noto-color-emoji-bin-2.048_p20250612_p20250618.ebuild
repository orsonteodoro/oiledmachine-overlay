# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Versioning:
# <tagged release>_p<date in NotoColorEmoji.tmpl.ttx.tmpl>_p<tagged data or commit date>

# See NotoColorEmoji.tmpl.ttx.tmpl for versioning at col = 2 (0-based index)
# <namerecord nameID="5" platformID="3" platEncID="1" langID="0x409">

inherit font

DESCRIPTION="A prebuilt font for colored emojis"
HOMEPAGE="https://www.google.com/get/noto/#emoji-qaae-color"
LICENSE="OFL-1.1"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE="+cbdt cbdt-win +colrv1 colrv1-no-flags"
REQUIRED_USE="
	|| (
		cbdt
		cbdt-win
		colrv1
		colrv1-no-flags
	)
"
COLRV1_DEPEND="
	>=media-libs/freetype-2.11.0
"
RDEPEND="
	>=media-libs/fontconfig-2.11.91
        >=x11-libs/cairo-1.16
	media-libs/freetype[png]
	colrv1? (
		${COLRV1_DEPEND}
	)
	colrv1-no-flags? (
		${COLRV1_DEPEND}
	)
"
DEPEND="
        ${RDEPEND}
	dev-python/fonttools
"
EGIT_COMMIT="b3e3051a088047d19fd4d49b1c3ac42fb8c3aaf8"
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
	colrv1? (
		${GH_URI}/Noto-COLRv1.ttf
			-> Noto-COLRv1.ttf.${EGIT_COMMIT:0:7}
	)
	colrv1-no-flags? (
		${GH_URI}/Noto-COLRv1-noflags.ttf
			-> Noto-COLRv1-noflags.ttf.${EGIT_COMMIT:0:7}
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

	if use colrv1 ; then
		cp "${DISTDIR}/Noto-COLRv1.ttf.${EGIT_COMMIT:0:7}" \
			Noto-COLRv1.ttf || die
	fi

	if use colrv1-no-flags ; then
		cp "${DISTDIR}/Noto-COLRv1-no-flags.ttf.${EGIT_COMMIT:0:7}" \
			Noto-COLRv1-no-flags.ttf || die
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
