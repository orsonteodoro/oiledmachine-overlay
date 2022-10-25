# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See NotoColorEmoji.tmpl.ttx.tmpl for versioning at
# <namerecord nameID="5" platformID="3" platEncID="1" langID="0x409">

PYTHON_COMPAT=( python3_{8..10} )
inherit font lcnr python-any-r1

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
IUSE+=" +cbdt cbdt-win +colrv1 colrv1-no-flags doc +optipng system-nototools test woff2 zopflipng"
REQUIRED_USE+="
	^^ (
		optipng
		zopflipng
	)
	kernel_Winnt? (
		cbdt-win
	)
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
RDEPEND+="
        !media-fonts/noto-color-emoji-bin
	!media-fonts/noto-emoji
	>=media-libs/fontconfig-2.11.91
        >=x11-libs/cairo-1.16
	media-libs/freetype[png]
	colrv1? (
		${COLRV1_DEPEND}
	)
	colrv1-no-flags? (
		${COLRV1_DEPEND}
	)
	woff2? (
		>=media-libs/freetype-2.10.2[brotli]
	)
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
	media-gfx/pngquant
	virtual/pkgconfig
	colrv1? (
		$(python_gen_any_dep '>=dev-python/nanoemoji-0.15.0[${PYTHON_USEDEP}]')
	)
	colrv1-no-flags? (
		$(python_gen_any_dep '>=dev-python/nanoemoji-0.15.0[${PYTHON_USEDEP}]')
	)
        optipng? (
		media-gfx/optipng
	)
	system-nototools? (
		$(python_gen_any_dep '>=dev-python/nototools-0.2.17[${PYTHON_USEDEP}]')
	)
	woff2? (
		|| (
			media-libs/woff2
			(
				$(python_gen_any_dep '
					dev-python/fonttools[woff,${PYTHON_USEDEP}]
				')
			)
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
NOTO_EMOJI_COMMIT="f826707b28355f6cd1593f504427ca2b1f6c4c19"
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

	if use colrv1 || use colrv1-no-flags ; then
		python_has_version \
			">=dev-python/nanoemoji-0.15.0[${PYTHON_USEDEP}]"
	fi

	if use system-nototools ; then
		python_has_version \
			">=dev-python/nototools-0.2.17[${PYTHON_USEDEP}]"
	fi
	if use woff2 ; then
		has_version "media-libs/woff2" \
			|| python_has_version "dev-python/fonttools[woff,${PYTHON_USEDEP}]"
	fi
}

pkg_setup() {
	font_pkg_setup
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

_build_colrv1() {
	[[ ! -f font/NotoColorEmoji.ttf ]] && _build_cbdt

einfo "Building COLRv1 font"
	addpredict /proc/self/comm
	${EPYTHON} colrv1_generate_configs.py || die

	which nanoemoji || die "nanoemoji is unreachable"
	rm -rf colrv1/build/ || die
	pushd colrv1 2>/dev/null 1>/dev/null || die
		nanoemoji *.toml || die
	popd 2>/dev/null 1>/dev/null || die
	cp colrv1/build/NotoColorEmoji.ttf fonts/Noto-COLRv1.ttf || die
	cp colrv1/build/NotoColorEmoji-noflags.ttf fonts/Noto-COLRv1-noflags.ttf || die

	${EPYTHON} colrv1_postproc.py || die
}

_compress_font() {
	local path
	for path in $(find . -name "*.ttf") ; do
		if has_version "media-libs/woff2" ; then
			woff2_compress "${path}" || die
		elif has_version "dev-python/fonttools[woff]" ; then
			fonttools ttLib.woff2 compress -o "${path/.ttf/.woff2}" "${path}" || die
		fi
	done
}

src_compile() {
	rm -rf fonts/*.ttf || die
	use cbdt && _build_cbdt
	if use colrv1 || use colrv1-no-flags ; then
		_build_colrv1
	fi
	use woff2 && _compress_font
	unset LD_PRELOAD

	# Junk file
	find "${S}/fonts" -name "NotoColorEmoji.tmpl.ttf" -delete
}

src_test() {
	local path
	for path in $(find fonts -name "*.ttf" -o -name "*.woff2") ; do
		fc-query "${path}" || die
	done
}

src_install() {
	FONT_S="${S}/fonts"
	font_src_install

	if use woff2 ; then
		insinto "/usr/share/${PN}"
		local path
		for path in $(find fonts -name "*.woff2") ; do
			doins "${path}"
		done
	fi

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

	! use cbdt && find "${ED}" -name "NotoColorEmoji*" -delete
	! use colrv1 && find "${ED}" -name "Noto-COLRv1.*" -delete
	! use colrv1-no-flags && find "${ED}" -name "Noto-COLRv1-noflags*" -delete
}

pkg_postinst() {
	font_pkg_postinst
einfo
einfo "To see emojis in your x11-term you need to switch to a .utf8 suffixed"
einfo "locale.  To set the locale see \`eselect locale\`."
einfo
einfo "\`emerge media-fonts/noto-color-emoji-config\` to fix emojis on firefox,"
einfo "google-chrome, etc systemwide."
einfo
}
