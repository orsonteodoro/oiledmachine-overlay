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
IUSE+=" doc optipng system-nototools +zopflipng woff2"
REQUIRED_USE+="
	^^ (
		optipng
		zopflipng
	)
"
RDEPEND+="
        !media-fonts/noto-color-emoji-bin
	!media-fonts/noto-emoji
	>=media-libs/fontconfig-2.11.91
        >=x11-libs/cairo-1.16
	media-libs/freetype[png]
	woff2? (
		>=media-libs/freetype-2.10.2[brotli]
	)
"
# NOTOTOOLS_DEPEND last update on 20210908
NOTOTOOLS_DEPEND="
	$(python_gen_any_dep '
		>=app-arch/brotli-1.0.9[${PYTHON_USEDEP},python]
		>=dev-python/appdirs-1.4.4[${PYTHON_USEDEP}]
		>=dev-python/attrs-19.3.0[${PYTHON_USEDEP}]
		>=dev-python/black-21.8_beta0[${PYTHON_USEDEP}]
		>=dev-python/booleanOperations-0.9.0[${PYTHON_USEDEP}]
		>=dev-python/click-7.1.2[${PYTHON_USEDEP}]
		>=dev-python/cu2qu-1.6.7[${PYTHON_USEDEP}]
		>=dev-python/defcon-0.6.0[${PYTHON_USEDEP}]
		>=dev-python/fontMath-0.6.0[${PYTHON_USEDEP}]
		>=dev-python/fontParts-0.9.2[${PYTHON_USEDEP}]
		>=dev-python/fontPens-0.2.4[${PYTHON_USEDEP}]
		>=dev-python/fonttools-4.11.0[${PYTHON_USEDEP}]
		>=dev-python/fs-2.4.11[${PYTHON_USEDEP}]
		>=dev-python/lxml-4.6.3[${PYTHON_USEDEP}]
		>=dev-python/MutatorMath-3.0.1[${PYTHON_USEDEP}]
		>=dev-python/pathspec-0.9.0[${PYTHON_USEDEP}]
		>=dev-python/pillow-8.3.2[${PYTHON_USEDEP}]
		>=dev-python/pyclipper-1.2.1[${PYTHON_USEDEP}]
		>=dev-python/pytz-2020.1[${PYTHON_USEDEP}]
		>=dev-python/six-1.16.0[${PYTHON_USEDEP}]
		>=dev-python/toml-0.10.1[${PYTHON_USEDEP}]
		>=dev-python/typed-ast-1.4.2[${PYTHON_USEDEP}]
		>=dev-python/ufoNormalizer-0.4.1[${PYTHON_USEDEP}]
		>=dev-python/ufoProcessor-1.9.0[${PYTHON_USEDEP}]
		>=dev-python/unicodedata2-13.0.0_p2[${PYTHON_USEDEP}]
		>=dev-util/afdko-3.4.0[${PYTHON_USEDEP}]
		>=dev-util/psautohint-2.0.1[${PYTHON_USEDEP}]
		>=media-gfx/scour-0.37[${PYTHON_USEDEP}]
	')
	|| (
		$(python_gen_any_dep '
			>=dev-python/regex-2020.5.14[${PYTHON_USEDEP}]
			>=dev-python/mrab-regex-2.5.80[${PYTHON_USEDEP}]
		')
	)
"
INTERNAL_NOTOTOOLS_PV="0.2.16_p20210908" # see setup.py for versioning
BDEPEND+="
	${PYTHON_DEPS}
	$(python_gen_any_dep '>=dev-python/fonttools-4.7.0[${PYTHON_USEDEP}]')
	!system-nototools? (
		${NOTOTOOLS_DEPEND}
	)
	media-gfx/pngquant
	virtual/pkgconfig
        optipng? (
		media-gfx/optipng
	)
	system-nototools? (
		$(python_gen_any_dep '>=dev-python/nototools-0.2.13[${PYTHON_USEDEP}]')
	)
	woff2? (
		|| (
			media-libs/woff2
			dev-python/fonttools
		)
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
NOTO_EMOJI_COMMIT="9a5261d871451f9b5183c93483cbd68ed916b1e9"
NOTOTOOLS_COMMIT="be1af37ec5cdd919b1b8dd8bd34517d6cdc53b8c"
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
		">=dev-python/attrs-19.3.0[${PYTHON_USEDEP}]" \
		">=dev-python/black-21.8_beta0[${PYTHON_USEDEP}]" \
		">=dev-python/booleanOperations-0.9.0[${PYTHON_USEDEP}]" \
		">=dev-python/click-7.1.2[${PYTHON_USEDEP}]" \
		">=dev-python/cu2qu-1.6.7[${PYTHON_USEDEP}]" \
		">=dev-python/defcon-0.6.0[${PYTHON_USEDEP}]" \
		">=dev-python/fontMath-0.6.0[${PYTHON_USEDEP}]" \
		">=dev-python/fontParts-0.9.2[${PYTHON_USEDEP}]" \
		">=dev-python/fontPens-0.2.4[${PYTHON_USEDEP}]" \
		">=dev-python/fonttools-4.11.0[${PYTHON_USEDEP}]" \
		">=dev-python/fs-2.4.11[${PYTHON_USEDEP}]" \
		">=dev-python/lxml-4.6.3[${PYTHON_USEDEP}]" \
		">=dev-python/MutatorMath-3.0.1[${PYTHON_USEDEP}]" \
		">=dev-python/pathspec-0.9.0[${PYTHON_USEDEP}]" \
		">=dev-python/pillow-8.3.2[${PYTHON_USEDEP}]" \
		">=dev-python/pyclipper-1.2.1[${PYTHON_USEDEP}]" \
		">=dev-python/pytz-2020.1[${PYTHON_USEDEP}]" \
		">=dev-python/six-1.16.0[${PYTHON_USEDEP}]" \
		">=dev-python/toml-0.10.1[${PYTHON_USEDEP}]" \
		">=dev-python/typed-ast-1.4.2[${PYTHON_USEDEP}]" \
		">=dev-python/ufoNormalizer-0.4.1[${PYTHON_USEDEP}]" \
		">=dev-python/ufoProcessor-1.9.0[${PYTHON_USEDEP}]" \
		">=dev-python/unicodedata2-13.0.0_p2[${PYTHON_USEDEP}]" \
		">=dev-util/afdko-3.4.0[${PYTHON_USEDEP}]" \
		">=dev-util/psautohint-2.0.1[${PYTHON_USEDEP}]" \
		">=media-gfx/scour-0.37[${PYTHON_USEDEP}]" \
		">=dev-python/fonttools-4.7.0[${PYTHON_USEDEP}]" \
		&& { \
			python_has_version ">=dev-python/regex-2020.5.14[${PYTHON_USEDEP}]" \
			|| python_has_version ">=dev-python/mrab-regex-2.5.80[${PYTHON_USEDEP}]" ; \
		}


	if use system-nototools ; then
		python_has_version \
			">=dev-python/nototools-0.2.13[${PYTHON_USEDEP}]"
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
	eapply "${FILESDIR}/noto-color-emoji-2.019_beta20200307_p20200721-revert-optipng-removal.patch"
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

_build_cbdt() {
einfo "Building CBDT font"
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

	export VIRTUAL_ENV="true"
	export BYPASS_SEQUENCE_CHECK="true"

	${EPYTHON} size_check.py || die
	emake
	[[ ! -f NotoColorEmoji.ttf ]] && die "NotoColorEmoji.ttf missing"
	mv *.ttf fonts/ || die
}

_compress_font() {
	local path
	for path in $(find . -name "*.ttf") ; do
		if has_version "media-libs/woff2" ; then
			woff2_compress "${path}" || die
		fi
		if has_version "dev-python/fonttools" ; then
			fonttools ttLib.woff2 compress -o "${path/.ttf/.woff2}" "${path}"
		fi
	done
}

src_compile() {
	rm -rf fonts/*.ttf || die
	_build_cbdt
	use woff2 && _compress_font
}

src_install() {
	FONT_S="${S}/fonts"
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

	find "${ED}/usr/share/fonts" -name "*WindowsCompatible*" -delete

	if use cbdt-win ; then
		insinto /usr/share/${PN}
		doins fonts/NotoColorEmoji_WindowsCompatible.ttf
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
