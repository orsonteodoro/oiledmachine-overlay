# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See NotoColorEmoji.tmpl.ttx.tmpl for versioning at
# <namerecord nameID="5" platformID="3" platEncID="1" langID="0x409">
EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit eutils font python-any-r1

DESCRIPTION="NotoColorEmoji is colored emojis"
HOMEPAGE="https://www.google.com/get/noto/#emoji-qaae-color"
LICENSE="Apache-2.0 OFL-1.1"
LICENSE+=" all-rights-reserved" # the Apache-2.0 license doesn't contain all rights reserved ; See flag_glyph_name.py
LICENSE+=" !system-nototools? ( Apache-2.0 )" # nototools default license
LICENSE+=" !system-nototools? ( BSD )" # nototools/third_party/dspl
LICENSE+=" !system-nototools? ( GPL-2 )" # nototools/third_party/spiro
LICENSE+=" !system-nototools? ( unicode )" # nototools/third_party/{cldr,ucd,unicode}
# Font files are OFL-1.1
# Artwork is Apache-2.0 and flags are public domain
KEYWORDS="~alpha ~amd64 ~amd64-linux ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 \
~s390 ~sh ~sparc ~sparc-solaris ~x64-solaris ~x86 ~x86-linux ~x86-solaris"
SLOT="0/${PV}"
IUSE+=" doc +optipng system-nototools zopflipng"
REQUIRED_USE+=" ^^ ( optipng zopflipng )"
RDEPEND+=" >=media-libs/fontconfig-2.11.91
	   media-libs/freetype[png]
          !media-fonts/noto-color-emoji-bin
	  !media-fonts/noto-emoji
         >=x11-libs/cairo-1.16"
NOTOTOOLS_DEPEND="
        $(python_gen_any_dep '>=media-gfx/scour-0.37[${PYTHON_USEDEP}]')
        $(python_gen_any_dep '>=dev-python/booleanOperations-0.8.2[${PYTHON_USEDEP}]')
        $(python_gen_any_dep '>=dev-python/defcon-0.6.0[${PYTHON_USEDEP}]')
        $(python_gen_any_dep '>=dev-python/fonttools-4.0.2[${PYTHON_USEDEP}]')
        $(python_gen_any_dep '>=dev-python/pillow-6.2.2[${PYTHON_USEDEP}]')
        $(python_gen_any_dep '>=dev-python/pyclipper-1.1.0_p1[${PYTHON_USEDEP}]')"
INTERNAL_NOTOTOOLS_PV="0.2.0_p20200401" # see setup.py for versioning ; official release was 20191017
BDEPEND+=" ${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-python/fonttools[${PYTHON_USEDEP}]')
	virtual/pkgconfig
        media-gfx/imagemagick
	media-gfx/pngquant
	!system-nototools? ( ${NOTOTOOLS_DEPEND} )
	system-nototools? (
		$(python_gen_any_dep '~dev-python/nototools-'$(ver_cut 1-3 ${INTERNAL_NOTOTOOLS_PV})'[${PYTHON_USEDEP}]')
	)
        optipng?   ( media-gfx/optipng )
	zopflipng? ( app-arch/zopfli )"
FONT_SUFFIX="ttf"
NOTO_EMOJI_COMMIT="ac1703e9d7feebbf5443a986e08332b1e1c5afcf"
NOTOTOOLS_COMMIT="e0a39bad11ca47f924b432bb05c3cccd87e68571"
SRC_URI="
https://github.com/googlei18n/noto-emoji/archive/${NOTO_EMOJI_COMMIT}.tar.gz \
	-> noto-emoji-${PV}.tar.gz
!system-nototools? ( https://github.com/googlei18n/nototools/archive/${NOTOTOOLS_COMMIT}.tar.gz \
	-> nototools-${INTERNAL_NOTOTOOLS_PV}.tar.gz )"
RESTRICT="mirror"
S="${WORKDIR}/noto-emoji-${NOTO_EMOJI_COMMIT}"

pkg_setup() {
	python-any-r1_pkg_setup
	if [[ ! ( "${LANG}" =~ \.utf8$ ) ]] ; then
		die "Change your locale to suffix .utf8.  Use \`eselect locale\` to set it."
	fi
}

src_prepare() {
	default
	if use zopflipng ; then
		sed -i -e "s|\
emoji: \$(EMOJI_FILES)|\
MISSING_OPTIPNG = fail\nundefine MISSING_ZOPFLI\nemoji: \$(EMOJI_FILES)|g" \
			Makefile || die
	else
		sed -i -e "s|\
emoji: \$(EMOJI_FILES)|\
MISSING_ZOPFLI = fail\nundefine MISSING_OPTIPNG\nemoji: \$(EMOJI_FILES)|g" \
			Makefile || die
	fi
	# Allow output
	sed -i -e "s|@(\$(PNGQUANT)|(\$(PNGQUANT)|g" Makefile || die
	sed -i -e "s|@convert|convert|g" Makefile || die
	sed -i -e "s|@./waveflag|./waveflag|g" Makefile || die
	if use optipng ; then
		sed -i -e "s|@\$(OPTIPNG)|\$(OPTIPNG)|g" Makefile || die
	fi
	if use zopflipng ; then
		sed -i -e "s|@\$(ZOPFLIPNG)|\$(ZOPFLIPNG)|g" Makefile || die
	fi
}

src_compile() {
	if use optipng ; then
		export ZOPFLIPNG=
	else
		export OPTIPNG=
	fi
	if ! use system-nototools ; then
		export PYTHONPATH=\
"${WORKDIR}/nototools-${NOTOTOOLS_COMMIT}:${PYTHONPATH}"
		export PATH=\
"${WORKDIR}/nototools-${NOTOTOOLS_COMMIT}/nototools:${PATH}"
	fi
	emake || die "Failed to compile font"
	[[ ! -f NotoColorEmoji.ttf ]] && die "NotoColorEmoji.ttf missing"
}

src_install() {
	font_src_install
	docinto licenses/font
	dodoc font/LICENSE
	docinto licenses/tools_and_images
	dodoc LICENSE
	docinto licenses/svg
	dodoc svg/LICENSE
	docinto licenses/third_party/color_emoji
	dodoc third_party/color_emoji/LICENSE
	docinto licenses/third_party/region-flags
	dodoc third_party/region-flags/LICENSE
	docinto licenses/third_party/pngquant
	dodoc third_party/pngquant/LICENSE
	if ! use system-nototools ; then
		docinto licenses/third_party/nototools
		dodoc "${WORKDIR}/nototools-${NOTOTOOLS_COMMIT}/LICENSE"
	fi
	if use doc ; then
		docinto readmes
		dodoc README.md AUTHORS CONTRIBUTING.md CONTRIBUTORS
		docinto readmes/third_party/color_emoji
		dodoc third_party/color_emoji/{README,README.third_party}
		docinto readmes/third_party/region-flags
		dodoc third_party/region-flags/{AUTHORS,README.third_party}
	fi
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

pkg_postinst() {
        rebuild_fontfiles
	fc-cache -fv
	einfo \
"To see emojis in your x11-term you need to switch to a .utf8 suffixed\n\
locale.  To set the locale see \`eselect locale\`.\n\
\n\
\`emerge media-fonts/noto-color-emoji-config\` to fix emojis on firefox,\n\
google-chrome, etc systemwide."
}

pkg_postrm() {
        rebuild_fontfiles
	fc-cache -fv
}
