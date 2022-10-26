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
LICENSE+=" all-rights-reserved"				# The Apache-2.0 license doesn't contain all rights reserved in the template ; See flag_glyph_name.py
LICENSE+=" !system-nototools? ( Apache-2.0 )"		# nototools default license
LICENSE+=" !system-nototools? ( BSD )"			# nototools/third_party/dspl
LICENSE+=" !system-nototools? ( GPL-2 )"		# nototools/third_party/spiro
LICENSE+=" !system-nototools? ( Unicode-DFS-2016 )"	# nototools/third_party/cldr
LICENSE+=" !system-nototools? ( unicode )"		# nototools/third_party/{ucd,unicode}
# Font files are OFL-1.1
# Artwork is Apache-2.0 and flags are public domain
KEYWORDS="
~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv
~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos
~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris
"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc +optipng system-nototools test woff2 zopflipng"
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
NOTOTOOLS_DEPEND="
	$(python_gen_any_dep '
		>=app-arch/brotli-1.0.7[${PYTHON_USEDEP},python]
		>=dev-python/appdirs-1.4.4[${PYTHON_USEDEP}]
		>=dev-python/attrs-19.3.0[${PYTHON_USEDEP}]
		>=dev-python/black-19.10_beta0[${PYTHON_USEDEP}]
		>=dev-python/booleanOperations-0.9.0[${PYTHON_USEDEP}]
		>=dev-python/click-7.1.2[${PYTHON_USEDEP}]
		>=dev-python/cu2qu-1.6.7[${PYTHON_USEDEP}]
		>=dev-python/defcon-0.6.0[${PYTHON_USEDEP}]
		>=dev-python/fontMath-0.6.0[${PYTHON_USEDEP}]
		>=dev-python/fontParts-0.9.2[${PYTHON_USEDEP}]
		>=dev-python/fontPens-0.2.4[${PYTHON_USEDEP}]
		>=dev-python/fonttools-4.11.0[${PYTHON_USEDEP}]
		>=dev-python/fs-2.4.11[${PYTHON_USEDEP}]
		>=dev-python/lxml-4.5.1[${PYTHON_USEDEP}]
		>=dev-python/MutatorMath-3.0.1[${PYTHON_USEDEP}]
		>=dev-python/pathspec-0.8.0[${PYTHON_USEDEP}]
		>=dev-python/pillow-7.1.2[${PYTHON_USEDEP}]
		>=dev-python/pyclipper-1.1.0_p1[${PYTHON_USEDEP}]
		>=dev-python/pytz-2020.1[${PYTHON_USEDEP}]
		>=dev-python/six-1.15.0[${PYTHON_USEDEP}]
		>=dev-python/toml-0.10.1[${PYTHON_USEDEP}]
		>=dev-python/typed-ast-1.4.1[${PYTHON_USEDEP}]
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
INTERNAL_NOTOTOOLS_PV="0.2.13" # see setup.py for versioning
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
NOTO_EMOJI_COMMIT="aac7ccaa4d1dea4543453b96f7d6fc47066a57ff"
NOTOTOOLS_COMMIT="1e7789e6c62fb7ce91d7abdb682422cc99c47c31"
SRC_URI="
https://github.com/googlei18n/noto-emoji/archive/${NOTO_EMOJI_COMMIT}.tar.gz
	-> noto-emoji-${PV}.tar.gz
https://github.com/googlei18n/nototools/archive/${NOTOTOOLS_COMMIT}.tar.gz
	-> nototools-${NOTOTOOLS_COMMIT:0:7}.tar.gz
"
RESTRICT="mirror"
S="${WORKDIR}/noto-emoji-${NOTO_EMOJI_COMMIT}"

python_check_deps() {
	local extra=()

	if use system-nototools ; then
		extra+=(
			">=dev-python/nototools-0.2.13[${PYTHON_USEDEP}]"
		)
	else
		extra+=(
			">=app-arch/brotli-1.0.7[${PYTHON_USEDEP},python]"
			">=dev-python/appdirs-1.4.4[${PYTHON_USEDEP}]"
			">=dev-python/attrs-19.3.0[${PYTHON_USEDEP}]"
			">=dev-python/black-19.10_beta0[${PYTHON_USEDEP}]"
			">=dev-python/booleanOperations-0.9.0[${PYTHON_USEDEP}]"
			">=dev-python/click-7.1.2[${PYTHON_USEDEP}]"
			">=dev-python/cu2qu-1.6.7[${PYTHON_USEDEP}]"
			">=dev-python/defcon-0.6.0[${PYTHON_USEDEP}]"
			">=dev-python/fontMath-0.6.0[${PYTHON_USEDEP}]"
			">=dev-python/fontParts-0.9.2[${PYTHON_USEDEP}]"
			">=dev-python/fontPens-0.2.4[${PYTHON_USEDEP}]"
			">=dev-python/fonttools-4.11.0[${PYTHON_USEDEP}]"
			">=dev-python/fs-2.4.11[${PYTHON_USEDEP}]"
			">=dev-python/lxml-4.5.1[${PYTHON_USEDEP}]"
			">=dev-python/MutatorMath-3.0.1[${PYTHON_USEDEP}]"
			">=dev-python/pathspec-0.8.0[${PYTHON_USEDEP}]"
			">=dev-python/pillow-7.1.2[${PYTHON_USEDEP}]"
			">=dev-python/pyclipper-1.1.0_p1[${PYTHON_USEDEP}]"
			">=dev-python/pytz-2020.1[${PYTHON_USEDEP}]"
			">=dev-python/six-1.15.0[${PYTHON_USEDEP}]"
			">=dev-python/toml-0.10.1[${PYTHON_USEDEP}]"
			">=dev-python/typed-ast-1.4.1[${PYTHON_USEDEP}]"
			">=dev-python/ufoNormalizer-0.4.1[${PYTHON_USEDEP}]"
			">=dev-python/ufoProcessor-1.9.0[${PYTHON_USEDEP}]"
			">=dev-python/unicodedata2-13.0.0_p2[${PYTHON_USEDEP}]"
			">=dev-util/afdko-3.4.0[${PYTHON_USEDEP}]"
			">=dev-util/psautohint-2.0.1[${PYTHON_USEDEP}]"
			">=media-gfx/scour-0.37[${PYTHON_USEDEP}]"
		)
	fi

	if use woff2 ; then
		if ! has_version "media-libs/woff2" ; then
			extra+=(
				"dev-python/fonttools[woff,${PYTHON_USEDEP}]"
			)
		fi
	fi

	if has_version "dev-python/regex" ; then
		extra+=(
			">=dev-python/regex-2020.5.14[${PYTHON_USEDEP}]"
		)
	else
		extra+=(
			">=dev-python/mrab-regex-2.5.80[${PYTHON_USEDEP}]"
		)
	fi

	python_has_version \
		">=dev-python/fonttools-4.7.0[${PYTHON_USEDEP}]" \
		${extra[@]}
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
		sed -i -e $"14a# Ebuild edited:  Use zopflipng" Makefile || die
	else
		sed -i -e "s|\
emoji: \$(EMOJI_FILES)|\
MISSING_ZOPFLI = fail\nundefine MISSING_OPTIPNG\nemoji: \$(EMOJI_FILES)|g" \
			Makefile || die
		sed -i -e $"14a# Ebuild edited:  Use optipng" Makefile || die
	fi
	if has_version -b "media-gfx/graphicsmagick" ; then
		eapply "${FILESDIR}/noto-emoji-20190328-use-gm.patch"
		sed -i -e $"14a# Ebuild edited:  graphicsmagick patch applied" Makefile || die
	fi
	eapply "${FILESDIR}/noto-color-emoji-2.019_beta20200307_p20200721-revert-optipng-removal.patch"
	sed -i -e $"14a# Ebuild edited:  Revert optipng removal" Makefile || die

	# Allow output
	sed -i -e "s|\t@|\t|g" Makefile || die
	sed -i -e $"14a# Ebuild edited:  Allow verbose output" Makefile || die
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

	emake
	[[ ! -f NotoColorEmoji.ttf ]] && die "NotoColorEmoji.ttf missing"
	mv *.ttf fonts/ || die
}

_compress_font() {
	local path
	for path in $(find . -name "*.ttf") ; do
		if has_version "media-libs/woff2" ; then
			woff2_compress \
				"${path}" || die
		elif has_version "dev-python/fonttools[woff]" ; then
			fonttools \
				ttLib.woff2 \
				compress \
				-o "${path/.ttf/.woff2}" \
				"${path}" || die
		fi
	done
}

src_compile() {
	rm -rf fonts/*.ttf || die
	_build_cbdt

	cd "${S}" || die

	# Junk files
	find "fonts" -name "*.tmpl.*" -delete

	use woff2 && _compress_font
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
