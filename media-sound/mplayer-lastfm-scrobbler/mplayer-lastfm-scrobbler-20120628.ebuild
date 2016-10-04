# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils git-r3

EGIT_REPO_URI="https://github.com/Bilalh/mplayer-last.fm-scrobbler.git"
EGIT_COMMIT="1f3e8c3bcb06fa21b1c36ec1dac0e953dee51c66"

DESCRIPTION="MPlayer last.fm Scrobbler"
HOMEPAGE="https://github.com/Bilalh/mplayer-last.fm-scrobbler"
SRC_URI=""
LICENSE="CC-BY-NC-SA-3.0"

SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"

IUSE=""

DEPEND="media-sound/lastfmsubmitd
        media-libs/taglib
        >=dev-lang/ruby-1.9
        dev-ruby/escape"

RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-20120628-fifo-homedir.patch"
        #wget https://raw.githubusercontent.com/Bilalh/Bash-Scripts/master/mplayer.sh
}

src_compile() {
	cd "${S}"
	./make.sh
	cd "${S}/Daemon"
	make
}

src_install() {
	mkdir -p "${D}/usr/local/bin/"
	cp taginfo "${D}/usr/local/bin/taginfo"
	cp tagformat "${D}/usr/local/bin/tagformat"
	cp mplayerlastfm.sh "${D}/usr/local/bin/mplayerlastfm"
	cp play_directory.sh "${D}/usr/local/bin/play_directory"

	cd "${S}/Daemon"
	SCRIPTS="*.rb *.applescript"
	OBJS="last_fm_scrobble_on_mplayer_played_50 last_fm_scrobble_on_mplayer_played_50_with_info"
	[ ! -d "${D}/usr/local/bin/" ] && mkdir "${D}/usr/local/bin/"; \
	chmod +x ${SCRIPTS}; \
	cp ${OBJS} ${SCRIPTS} "${D}/usr/local/bin/"

	cd "${S}"
	docinto "/usr/share/${P}"
	dodoc Readme.md
	cd "${S}/Daemon"
	docinto "/usr/share/${P}/Daemon"
	dodoc Readme.md

	#mkdir -p "${D}/usr/bin"
	#cp "${S}/mplayer.sh" "${D}/usr/bin"
	#chmod +x "${D}/usr/bin/mplayer.sh"
}

pkg_postinst() {
	einfo "You may need a 'mkfifo ~/.mplayer/pipe' for the daemon to work properly with mplayer."
	ewarn "mplayer-1.2.1 requires lastfm USE flag from oiledmachine-overlay"
}
