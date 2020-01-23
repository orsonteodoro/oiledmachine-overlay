# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See NotoColorEmoji.tmpl.ttx.tmpl for versioning at
# <namerecord nameID="5" platformID="3" platEncID="1" langID="0x409">
EAPI=6
DESCRIPTION="NotoColorEmoji is colored emojis"
HOMEPAGE="https://www.google.com/get/noto/#emoji-qaae-color"
LICENSE="Apache-2.0 OFL-1.1"
# Font files are OFL-1.1
# Artwork is Apache-2.0 and flags are public domain
KEYWORDS="~alpha ~amd64 ~amd64-linux ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 \
~s390 ~sh ~sparc ~sparc-solaris ~x64-solaris ~x86 ~x86-linux ~x86-solaris"
PYTHON_COMPAT=( python3_{6,7,8} )
SLOT="0/${PV}"
IUSE="optipng +zopflipng"
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
NOTO_TOOLS_PV="0.2.0_p20191019" # see setup.py for versioning
SRC_URI=\
"https://github.com/googlei18n/noto-emoji/archive/${NOTO_EMOJI_COMMIT}.tar.gz \
	-> noto-emoji-${PV}.tar.gz
https://github.com/googlei18n/nototools/archive/${NOTO_TOOLS_COMMIT}.tar.gz \
	-> noto-tools-${NOTO_TOOLS_PV}.tar.gz"
inherit eutils font
RESTRICT="mirror"
S="${WORKDIR}/noto-emoji-${NOTO_EMOJI_COMMIT}"

pkg_setup() {
	python_setup
	einfo "PYTHON=${PYTHON}"
}

src_prepare() {
	default
	sed -i -e "s|\
from fontTools.misc.py23 import unichr|\
from six import unichr|" \
	"${WORKDIR}/nototools-${NOTO_TOOLS_COMMIT}/nototools/unicode_data.py" \
		|| die
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
