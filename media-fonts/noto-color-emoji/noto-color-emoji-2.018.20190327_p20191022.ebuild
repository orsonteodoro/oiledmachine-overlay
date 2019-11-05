# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See NotoColorEmoji.tmpl.ttx.tmpl for versoning
EAPI=6
DESCRIPTION="NotoColorEmoji is colored emojis"
HOMEPAGE="https://www.google.com/get/noto/#emoji-qaae-color"
LICENSE="OFL-1.1"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6,3_7} )
# renamed from upstream's unversioned NotoColorEmoji-unhinted.zip
# version number based on the timestamp of most recently updated file in the zip
SLOT="0"
IUSE="black-smiling-emoji optipng +zopflipng" # black smiling emoji breaks utr#51
inherit python-single-r1
REQUIRED_USE="^^ ( optipng zopflipng ) \
	      ^^ ( $(python_gen_useflags 'python*') )"
RDEPEND=">=media-libs/fontconfig-2.11.91
	   media-libs/freetype[png]
          !media-fonts/noto-color-emoji-bin
	  !media-fonts/noto-emoji
         >=x11-libs/cairo-1.16"
DEPEND="${RDEPEND}
        ${PYTHON_DEPS}
        >=dev-python/fonttools-3.15.1[${PYTHON_USEDEP}]
	  dev-python/six
        media-gfx/imagemagick
	media-gfx/pngquant
        optipng?   ( media-gfx/optipng )
	zopflipng? ( app-arch/zopfli )"
FONT_SUFFIX="ttf"
FONT_CONF=( )
NOTO_EMOJI_COMMIT="018aa149d622a4fea11f01c61a7207079da301bc"
NOTO_TOOLS_COMMIT="cae92ce958bee37748bf0602f5d7d97bb6db98ca"
SRC_URI=\
"https://github.com/googlei18n/noto-emoji/archive/${NOTO_EMOJI_COMMIT}.tar.gz \
	-> noto-emoji-${NOTO_EMOJI_COMMIT}.tar.gz
https://github.com/googlei18n/nototools/archive/${NOTO_TOOLS_COMMIT}.tar.gz \
	-> noto-tools-${NOTO_TOOLS_COMMIT}.tar.gz"
inherit eutils font
RESTRICT="mirror"
S="${WORKDIR}/noto-emoji-${NOTO_EMOJI_COMMIT}"

pkg_setup() {
	python_setup
	einfo "PYTHON=${PYTHON}"
}

src_unpack() {
	unpack ${A}
	if use black-smiling-emoji ; then
		cp "${FILESDIR}/emoji_u263b.svg" "${S}/svg/" || die
		cp "${FILESDIR}/emoji_u263b.png" "${S}/png/128/" || die
	fi
}

src_prepare() {
	default
	sed -i -e "s|\
from fontTools.misc.py23 import unichr|\
from six import unichr|" \
	"${WORKDIR}/nototools-${NOTO_TOOLS_COMMIT}/nototools/unicode_data.py" \
		|| die
	if use zopflipng ; then
		sed -i -e 's|\
emoji: \$(EMOJI_FILES)|\
MISSING_OPTIPNG = fail\nundefine MISSING_ZOPFLI\nemoji: \$(EMOJI_FILES)|g' \
			Makefile || die
	else
		sed -i -e 's|\
emoji: \$(EMOJI_FILES)|\
MISSING_ZOPFLI = fail\nundefine MISSING_OPTIPNG\nemoji: \$(EMOJI_FILES)|g' \
			Makefile || die
	fi

	cd "${WORKDIR}/noto-emoji-${NOTO_EMOJI_COMMIT}" || die

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

	export PYTHONPATH=\
"${WORKDIR}/nototools-${NOTO_TOOLS_COMMIT}:${PYTHONPATH}"
	export PATH=\
"${WORKDIR}/nototools-${NOTO_TOOLS_COMMIT}/nototools:${PATH}"
	emake || die "Failed to compile font"
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
"To see emojis in your x11-term you need to switch to a utf8 locale.\n\
\`emerge media-fonts/noto-color-emoji-config\` to fix emojis on firefox,\n\
google-chrome, etc systemwide."
}

pkg_postrm() {
        rebuild_fontfiles
	fc-cache -fv
}
