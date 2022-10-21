# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See NotoColorEmoji.tmpl.ttx.tmpl for versioning at
# <namerecord nameID="5" platformID="3" platEncID="1" langID="0x409">

PYTHON_COMPAT=( python3_{8..10} )
inherit font python-any-r1

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
# NOTOTOOLS_DEPEND last update on 20220811
NOTOTOOLS_DEPEND="
	$(python_gen_any_dep '
		>=app-arch/brotli-1.0.9[${PYTHON_USEDEP},python]
		>=dev-python/appdirs-1.4.4[${PYTHON_USEDEP}]
		>=dev-python/attrs-21.4.0[${PYTHON_USEDEP}]
		>=dev-python/black-22.6.0[${PYTHON_USEDEP}]
		>=dev-python/booleanOperations-0.9.0[${PYTHON_USEDEP}]
		>=dev-python/click-8.1.3[${PYTHON_USEDEP}]
		>=dev-python/cu2qu-1.6.7_p1[${PYTHON_USEDEP}]
		>=dev-python/defcon-0.10.2[${PYTHON_USEDEP}]
		>=dev-python/fontMath-0.9.2[${PYTHON_USEDEP}]
		>=dev-python/fontParts-0.10.7[${PYTHON_USEDEP}]
		>=dev-python/fontPens-0.2.4[${PYTHON_USEDEP}]
		>=dev-python/fonttools-4.34.4[${PYTHON_USEDEP}]
		>=dev-python/fs-2.4.16[${PYTHON_USEDEP}]
		>=dev-python/lxml-4.9.1[${PYTHON_USEDEP}]
		>=dev-python/MutatorMath-3.0.1[${PYTHON_USEDEP}]
		>=dev-python/pathspec-0.9.0[${PYTHON_USEDEP}]
		>=dev-python/pillow-9.2.0[${PYTHON_USEDEP}]
		>=dev-python/pyclipper-1.3.0_p3[${PYTHON_USEDEP}]
		>=dev-python/pytz-2022.1[${PYTHON_USEDEP}]
		>=dev-python/regex-2022.7.25[${PYTHON_USEDEP}]
		>=dev-python/six-1.16.0[${PYTHON_USEDEP}]
		>=dev-python/toml-0.10.2[${PYTHON_USEDEP}]
		>=dev-python/typed-ast-1.4.2[${PYTHON_USEDEP}]
		>=dev-python/ufoNormalizer-0.6.1[${PYTHON_USEDEP}]
		>=dev-python/ufoProcessor-1.9.0[${PYTHON_USEDEP}]
		>=dev-python/unicodedata2-14.0.0[${PYTHON_USEDEP}]
		>=dev-util/afdko-3.9.1[${PYTHON_USEDEP}]
		>=dev-util/psautohint-2.4.0[${PYTHON_USEDEP}]
		>=media-gfx/scour-0.37[${PYTHON_USEDEP}]
	')
"
INTERNAL_NOTOTOOLS_PV="0.2.17_p20220811" # see setup.py for versioning
BDEPEND+="
	${PYTHON_DEPS}
	$(python_gen_any_dep '>=dev-python/fonttools-4.34.4[${PYTHON_USEDEP}]')
	!system-nototools? (
		${NOTOTOOLS_DEPEND}
	)
        media-gfx/imagemagick
	media-gfx/pngquant
	virtual/pkgconfig
        optipng? (
		media-gfx/optipng
	)
	system-nototools? (
		$(python_gen_any_dep '>=dev-python/nototools-0.2.17[${PYTHON_USEDEP}]')
	)
	zopflipng? (
		app-arch/zopfli
	)
"
FONT_SUFFIX="ttf"
NOTO_EMOJI_COMMIT="e8073ab740292f8d5f19b5de144087ac58044d06"
NOTOTOOLS_COMMIT="cd79db632c9a506ad61ae72bfad5875341ca56b8"
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
		">=app-arch/brotli-1.0.9[${PYTHON_USEDEP},python]" \
		">=dev-python/appdirs-1.4.4[${PYTHON_USEDEP}]" \
		">=dev-python/attrs-21.4.0[${PYTHON_USEDEP}]" \
		">=dev-python/black-22.6.0[${PYTHON_USEDEP}]" \
		">=dev-python/booleanOperations-0.9.0[${PYTHON_USEDEP}]" \
		">=dev-python/click-8.1.3[${PYTHON_USEDEP}]" \
		">=dev-python/cu2qu-1.6.7_p1[${PYTHON_USEDEP}]" \
		">=dev-python/defcon-0.10.2[${PYTHON_USEDEP}]" \
		">=dev-python/fontMath-0.9.2[${PYTHON_USEDEP}]" \
		">=dev-python/fontParts-0.10.7[${PYTHON_USEDEP}]" \
		">=dev-python/fontPens-0.2.4[${PYTHON_USEDEP}]" \
		">=dev-python/fonttools-4.34.4[${PYTHON_USEDEP}]" \
		">=dev-python/fs-2.4.16[${PYTHON_USEDEP}]" \
		">=dev-python/lxml-4.9.1[${PYTHON_USEDEP}]" \
		">=dev-python/MutatorMath-3.0.1[${PYTHON_USEDEP}]" \
		">=dev-python/pathspec-0.9.0[${PYTHON_USEDEP}]" \
		">=dev-python/pillow-9.2.0[${PYTHON_USEDEP}]" \
		">=dev-python/pyclipper-1.3.0_p3[${PYTHON_USEDEP}]" \
		">=dev-python/pytz-2022.1[${PYTHON_USEDEP}]" \
		">=dev-python/regex-2022.7.25[${PYTHON_USEDEP}]" \
		">=dev-python/six-1.16.0[${PYTHON_USEDEP}]" \
		">=dev-python/toml-0.10.2[${PYTHON_USEDEP}]" \
		">=dev-python/typed-ast-1.4.2[${PYTHON_USEDEP}]" \
		">=dev-python/ufoNormalizer-0.6.1[${PYTHON_USEDEP}]" \
		">=dev-python/ufoProcessor-1.9.0[${PYTHON_USEDEP}]" \
		">=dev-python/unicodedata2-14.0.0[${PYTHON_USEDEP}]" \
		">=dev-util/afdko-3.9.1[${PYTHON_USEDEP}]" \
		">=dev-util/psautohint-2.4.0[${PYTHON_USEDEP}]" \
		">=media-gfx/scour-0.37[${PYTHON_USEDEP}]" \
		">=dev-python/fonttools-4.34.4[${PYTHON_USEDEP}]"

	if use system-nototools ; then
		python_has_version \
			">=dev-python/nototools-0.2.17[${PYTHON_USEDEP}]"
	fi

}

pkg_setup() {
	python-any-r1_pkg_setup
#	Prevents:
#	Traceback (most recent call last):
#	  File "check_emoji_sequences.py", line 433, in <module>
#	    main()
#	  File "check_emoji_sequences.py", line 429, in main
#	    args.coverage)
#	  File "check_emoji_sequences.py", line 402, in run_check
#	    check_sequence_to_filepath(seq_to_filepath, unicode_version, coverage)
#	  File "check_emoji_sequences.py", line 325, in check_sequence_to_filepath
#	    _check_coverage(sorted_seq_to_filepath, unicode_version)
#	  File "check_emoji_sequences.py", line 299, in _check_coverage
#	    print(f'coverage: missing combining sequence {unicode_data.seq_to_string(seq)} ({name})')
#	UnicodeEncodeError: 'latin-1' codec can't encode character '\u2019' in position 64: ordinal not in range(256)
	if ! [[ "${LANG}" =~ \.utf8$ ]] ; then
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
	sed -i -e "s|MISSING_VENV = fail|MISSING_VENV =|g" Makefile || die
	# Allow output
	sed -i -e "s|@(\$(PNGQUANT)|(\$(PNGQUANT)|g" Makefile || die
	sed -i -e "s|@convert|convert|g" Makefile || die
	sed -i -e "s|@./waveflag|./waveflag|g" Makefile || die
	eapply "${FILESDIR}/noto-color-emoji-2.019_beta20200307_p20200721-revert-optipng-removal.patch"
	if use optipng ; then
		sed -i -e "s|@\$(OPTIPNG)|\$(OPTIPNG)|g" Makefile || die
	fi
	if use zopflipng ; then
		sed -i -e "s|@\$(ZOPFLIPNG)|\$(ZOPFLIPNG)|g" Makefile || die
	fi

	# check_sequence (commit bebb2f2b39d059e852b98cc0e39ef766a9dfa683) is broken when BYPASS_SEQUENCE_CHECK is True
	sed -i -e "s|check_sequence ||" Makefile || die
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
	export BYPASS_SEQUENCE_CHECK='True'
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
