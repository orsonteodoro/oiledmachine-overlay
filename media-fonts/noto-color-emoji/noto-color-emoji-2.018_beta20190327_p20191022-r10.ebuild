# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See NotoColorEmoji.tmpl.ttx.tmpl for versioning at
# <namerecord nameID="5" platformID="3" platEncID="1" langID="0x409">

PYTHON_COMPAT=( python3_{8..10} )
inherit font python-any-r1
inherit lcnr

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
KEYWORDS="
~alpha ~amd64 ~amd64-linux ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh
~sparc ~sparc-solaris ~x64-solaris ~x86 ~x86-linux ~x86-solaris
"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc optipng system-nototools +zopflipng"
REQUIRED_USE+=" ^^ ( optipng zopflipng )"
RDEPEND+="
        !media-fonts/noto-color-emoji-bin
	!media-fonts/noto-emoji
	>=media-libs/fontconfig-2.11.91
        >=x11-libs/cairo-1.16
	media-libs/freetype[png]
"
NOTOTOOLS_DEPEND="
        $(python_gen_any_dep '
		>=dev-python/booleanOperations-0.8.2[${PYTHON_USEDEP}]
	        >=dev-python/defcon-0.6.0[${PYTHON_USEDEP}]
	        >=dev-python/fonttools-4.0.2[${PYTHON_USEDEP}]
	        >=dev-python/pillow-6.2.0[${PYTHON_USEDEP}]
	        >=dev-python/pyclipper-1.1.0_p1[${PYTHON_USEDEP}]
	        >=media-gfx/scour-0.37[${PYTHON_USEDEP}]
	')
"
INTERNAL_NOTOTOOLS_PV="0.2.0_p20191019" # see setup.py for versioning ; official release was 20191017
BDEPEND+="
	${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-python/fonttools[${PYTHON_USEDEP}]')
	!system-nototools? (
		${NOTOTOOLS_DEPEND}
	)
	media-gfx/pngquant
	virtual/pkgconfig
        optipng? (
		media-gfx/optipng
	)
	system-nototools? (
		$(python_gen_any_dep '~dev-python/nototools-'$(ver_cut 1-3 ${INTERNAL_NOTOTOOLS_PV})'[${PYTHON_USEDEP}]')
	)
	zopflipng? (
		app-arch/zopfli
	)
	|| (
		media-gfx/graphicsmagick[png]
	        media-gfx/imagemagick[png]
	)
"
FONT_SUFFIX="ttf"
NOTO_EMOJI_COMMIT="018aa149d622a4fea11f01c61a7207079da301bc"
NOTOTOOLS_COMMIT="cae92ce958bee37748bf0602f5d7d97bb6db98ca"
SRC_URI="
https://github.com/googlei18n/noto-emoji/archive/${NOTO_EMOJI_COMMIT}.tar.gz
	-> noto-emoji-${PV}.tar.gz
https://github.com/googlei18n/nototools/archive/${NOTOTOOLS_COMMIT}.tar.gz
	-> nototools-${NOTOTOOLS_COMMIT:0:7}.tar.gz
"
RESTRICT="mirror"
S="${WORKDIR}/noto-emoji-${NOTO_EMOJI_COMMIT}"

python_check_deps() {
	python_has_version \
		">=dev-python/booleanOperations-0.8.2[${PYTHON_USEDEP}]" \
	        ">=dev-python/defcon-0.6.0[${PYTHON_USEDEP}]" \
	        ">=dev-python/fonttools-4.0.2[${PYTHON_USEDEP}]" \
	        ">=dev-python/pillow-6.2.0[${PYTHON_USEDEP}]" \
	        ">=dev-python/pyclipper-1.1.0_p1[${PYTHON_USEDEP}]" \
	        ">=media-gfx/scour-0.37[${PYTHON_USEDEP}]" \
		"dev-python/fonttools[${PYTHON_USEDEP}]"

	if use system-nototools ; then
		python_has_version \
			"~dev-python/nototools-"$(ver_cut 1-3 ${INTERNAL_NOTOTOOLS_PV})"[${PYTHON_USEDEP}]"
	fi
}

pkg_setup() {
	python-any-r1_pkg_setup
	if ! [[ "${LANG}" =~ \.utf8$ ]] ; then
		die "Change your locale to suffix .utf8.  Use \`eselect locale\` to set it."
	fi
	if has_version "dev-python/pypng" ; then
ewarn
ewarn "If build fails, temporarily uninstall dev-python/pypng."
ewarn
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
	if has_version -b "media-gfx/graphicsmagick" ; then
		eapply "${FILESDIR}/noto-emoji-20190328-use-gm.patch"
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

	LCNR_SOURCE="${S}"
	LCNR_TAG="source"
	lcnr_install_files

	if ! use system-nototools ; then
		LCNR_SOURCE="${WORKDIR}/nototools-${NOTOTOOLS_COMMIT}"
		LCNR_TAG="nototools"
		lcnr_install_files
	fi

	if use doc ; then
		LCNR_SOURCE="${S}"
		LCNR_TAG="source"
		lcnr_install_readmes
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
einfo
einfo "To see emojis in your x11-term you need to switch to a .utf8 suffixed"
einfo "locale.  To set the locale see \`eselect locale\`."
einfo
einfo "\`emerge media-fonts/noto-color-emoji-config\` to fix emojis on firefox,"
einfo "google-chrome, etc systemwide."
einfo
}

pkg_postrm() {
        rebuild_fontfiles
	fc-cache -fv
}
