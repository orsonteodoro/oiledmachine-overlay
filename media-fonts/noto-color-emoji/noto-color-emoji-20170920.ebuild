# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils font python-single-r1

DESCRIPTION="NotoColorEmoji is colored emojis"
HOMEPAGE="https://www.google.com/get/noto/#emoji-qaae-color"
NOTO_EMOJI_COMMIT="411334c8e630acf858569602cbf5c19deba00878"
NOTO_TOOLS_COMMIT="99f317e3fd168bddb84abe1818765b7a2268e4a5"
SRC_URI="https://github.com/googlei18n/noto-emoji/archive/${NOTO_EMOJI_COMMIT}.zip -> noto-emoji-${NOTO_EMOJI_COMMIT}.zip
         https://github.com/googlei18n/nototools/archive/${NOTO_TOOLS_COMMIT}.zip -> noto-tools-${NOTO_TOOLS_COMMIT}.zip"
# renamed from upstream's unversioned NotoColorEmoji-unhinted.zip
# version number based on the timestamp of most recently updated file in the zip

S="${WORKDIR}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="zopflipng optipng reassign-ugly-text-emojis black-smiling-emoji" #break utr#51
REQUIRED_USE="^^ ( zopflipng optipng ) ^^ ( $(python_gen_useflags 'python2*') )"

RDEPEND=">=media-libs/fontconfig-2.11.91
         >=x11-libs/cairo-1.14.6[colored-emojis]
	 media-libs/freetype[png]
         !media-fonts/noto-color-emoji-bin
"

DEPEND="${RDEPEND}
        ${PYTHON_DEPS}
	dev-python/six
        media-gfx/imagemagick
        >=dev-python/fonttools-3.15.1
        optipng? ( media-gfx/optipng )
	zopflipng? ( app-arch/zopfli )
"

FONT_SUFFIX="ttf"
FONT_CONF=( "${FILESDIR}/01-notosans.conf" "${FILESDIR}/44-notosans.conf"  "${FILESDIR}/61-notosans.conf" )

S="${WORKDIR}/noto-emoji-${NOTO_EMOJI_COMMIT}"

pkg_setup() {
	#die "this ebuild does not work.  this exist to be updated."
	python_setup
}

src_unpack() {
	unpack ${A}
	cp "${FILESDIR}/emoji_u263b.svg" "${S}/svg/"
	cp "${FILESDIR}/emoji_u263b.png" "${S}/png/128/"
}

src_prepare() {
	sed -i -e "s|from fontTools.misc.py23 import unichr|from six import unichr|" "${WORKDIR}/nototools-${NOTO_TOOLS_COMMIT}/nototools/unicode_data.py" || die "patch failed 1"
	#FILES=$(grep -l -r -e "unichr" ./)
	#for f in $FILES
	#do
	#	einfo "Patching $f"
	#	sed -i -e "s|unichr|chr|g" "$f" || die "patch failed 2 $f"
	#done
	if use zopflipng ; then
		sed -i -e 's|emoji: \$(EMOJI_FILES)|MISSING_OPTIPNG = fail\nundefine MISSING_ZOPFLI\nemoji: \$(EMOJI_FILES)|g' Makefile
	else
		sed -i -e 's|emoji: \$(EMOJI_FILES)|MISSING_ZOPFLI = fail\nundefine MISSING_OPTIPNG\nemoji: \$(EMOJI_FILES)|g' Makefile
	fi

	cd "${WORKDIR}/noto-emoji-${NOTO_EMOJI_COMMIT}"
	#epatch "${FILESDIR}"/${PN}-20170913-svg-typo.patch

	#allow output
	sed -i -e "s|@(\$(PNGQUANT)|(\$(PNGQUANT)|g" Makefile || die
	sed -i -e "s|@convert|convert|g" Makefile || die
	sed -i -e "s|@./waveflag|./waveflag|g" Makefile || die
	if use optipng ; then
		sed -i -e "s|@\$(OPTIPNG)|\$(OPTIPNG)|g" Makefile || die
	fi
	if use zopflipng ; then
		sed -i -e "s|@\$(ZOPFLIPNG)|\$(ZOPFLIPNG)|g" Makefile || die
	fi

	epatch_user
}

src_compile() {
	if use optipng ; then
		export ZOPFLIPNG=
	else
		export OPTIPNG=
	fi

	export PYTHONPATH="${WORKDIR}/nototools-${NOTO_TOOLS_COMMIT}:${PYTHONPATH}"
	echo "PYTHONPATH=${PYTHONPATH}"
	export PATH="${WORKDIR}/nototools-${NOTO_TOOLS_COMMIT}/nototools:${PATH}"
	echo "PATH=${PATH}"
	emake || die "failed to compile font"
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
	eselect fontconfig enable 01-notosans.conf
	if use reassign-ugly-text-emojis ; then
		eselect fontconfig enable 61-notosans.conf
		ewarn "You may need to manually add exceptions to 61-notosans.conf based on fonts installed and what was in the serif and sans-serif section of 60-latin.conf and run \`fc-cache -fv\`."
		eselect fontconfig enable 44-notosans.conf
		ewarn "You may need to manually add exceptions to 44-notosans.conf based on fonts installed and what was in the serif and sans-serif section of 60-latin.conf and run \`fc-cache -fv\`."
	fi
	eselect fontconfig disable 70-no-bitmaps.conf
	ewarn "You may need to \`eselect fontconfig enable 01-notosans.conf\` manually and run \`fc-cache -fv\`."
	ewarn "You may need to \`eselect fontconfig disable 70-no-bitmaps.conf\` manually and run \`fc-cache -fv\`."
        rebuild_fontfiles
	ewarn "To see emojis in your x11-term you need to switch to a utf8 locale."
}
