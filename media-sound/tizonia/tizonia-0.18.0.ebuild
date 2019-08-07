# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} )

inherit autotools distutils-r1 eutils flag-o-matic multilib multilib-minimal multilib-build

MY_PN="tizonia-openmax-il"
DESCRIPTION="Command-line cloud music player for Linux with support for Spotify, Google Play Music, YouTube, SoundCloud, Dirble Internet Radio, Plex servers and Chromecast devices."
HOMEPAGE="http://tizonia.org"
SRC_URI="https://github.com/tizonia/tizonia-openmax-il/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="LGPL-3.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=" +aac +alsa +bash-completion blocking-etb-ftb blocking-sendcommand +boost +curl +dbus +file-io +flac +fuzzywuzzy +inproc-io +mp4 +ogg +opus +lame +libsndfile +mad +mp3-metadata-eraser +mp2 +mpg123 +player +pulseaudio +sdl +icecast-client +icecast-server -test +vorbis +vpx +webm +zsh-completion openrc systemd"
IUSE+=" +chromecast +dirble +google-music +plex +soundcloud +spotify +youtube"

# 3rd party repos may be required and add to package.unmask.  use layman -a
#=media-sound/tizonia-0.18.0::oiledmachine-overlay
#=dev-python/soundcloud-python-9999.20151015::oiledmachine-overlay
#=dev-python/gmusicapi-12.1.1::palmer
#=dev-python/proboscis-1.2.6.0::palmer
#=dev-libs/libspotify-12.1.51::palmer
#=dev-python/validictory-1.1.2::palmer
#=dev-python/pycryptodomex-3.7.3::palmer
#=dev-python/gpsoauth-0.4.1::palmer
#=media-libs/nestegg-9999.20190603::oiledmachine-overlay
#=dev-python/python-plexapi-3.0.6::oiledmachine-overlay
#=dev-python/PyChromecast-3.2.2::HomeAssistantRepository
#=dev-python/casttube-0.2.0::HomeAssistantRepository
#=dev-python/fuzzywuzzy-0.12.0::gentoo

# ogg_muxer requires curl, oggmuxsnkprc.c is work in progress.  ogg should work without curl for just strictly local playback only (as in non streaming player) tizonia
# >=dev-python/dnspython-1.16.0 added to avoid merge conflict between pycrypto and pycryptodome.  It should not be here but resolved in dnspython.
RDEPEND="alsa? ( media-libs/alsa-lib )
	 bash-completion? ( app-shells/bash )
	 chromecast? ( || ( dev-python/PyChromecast dev-python/pychromecast ) )
	 curl? ( >=net-misc/curl-7.18.0 )
	 dirble? ( dev-python/eventlet
                   >=dev-python/dnspython-1.16.0 )
	 flac? ( >=media-libs/flac-1.3.0 )
	 fuzzywuzzy? ( dev-python/fuzzywuzzy )
	 google-music? ( dev-python/gmusicapi )
	 lame? ( media-sound/lame )
	 ogg? ( >=media-libs/liboggz-1.1.1 )
	 opus? ( >=media-libs/opusfile-0.5 )
	 dbus? ( sys-apps/dbus )
	 boost? ( >=dev-libs/boost-1.54[python] )
	 player? ( >=media-libs/taglib-1.7.0
		   >=media-libs/libmediainfo-0.7.65 )
	 mpg123? ( >=media-sound/mpg123-1.16.0 )
	 mad? ( media-libs/libmad )
	 libsndfile? ( >=media-libs/libsndfile-1.0.25 )
	 opus? ( >=media-libs/opus-1.1 )
	 plex? ( dev-python/python-plexapi )
	 pulseaudio? ( >=media-sound/pulseaudio-1.1 )
	 mp4? ( media-libs/libmp4v2 )
	 plex? ( dev-python/python-plexapi )
	 sdl? ( media-libs/libsdl )
	 soundcloud? ( dev-python/soundcloud-python )
	 spotify? ( >=dev-libs/libspotify-12.1.51 )
	 test? ( dev-db/sqlite:3 )
	 vorbis? ( media-libs/libfishsound )
	 vpx? ( media-libs/libvpx )
	 youtube? ( net-misc/youtube-dl[${PYTHON_USEDEP}]
		    dev-python/pafy )
	 inproc-io? ( >=net-libs/zeromq-4.0.4 )
	 >=sys-apps/util-linux-2.19.0
	 webm? ( media-libs/nestegg )
	 zsh-completion? ( app-shells/zsh )
	 ${PYTHON_DEPS}
         "
DEPEND="${RDEPEND}
	>=dev-libs/log4c-1.2.1
	>=dev-libs/check-0.9.4
	"
REQUIRED_USE="chromecast? ( player boost curl dbus google-music )
	      dirble? ( player boost curl )
	      google-music? ( player boost fuzzywuzzy )
	      mp2? ( mpg123 )
	      mp3-metadata-eraser? ( mpg123 )
	      player? ( boost )
	      plex? ( player boost fuzzywuzzy )
	      soundcloud? ( player boost fuzzywuzzy )
	      spotify? ( player boost fuzzywuzzy )
	      youtube? ( player boost fuzzywuzzy )
	      icecast-server? ( player )
	      icecast-client? ( player curl )
	      ^^ ( python_targets_python2_7 python_targets_python3_5 python_targets_python3_6 python_targets_python3_7 )
	      dbus? ( || ( openrc systemd ) )
	      openrc? ( dbus )
	      systemd? ( dbus )
	      ogg? ( curl )
	     "
S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	default

	eapply "${FILESDIR}/tizonia-0.18.0-modular-1.patch"
	eapply "${FILESDIR}/tizonia-0.18.0-modular-2.patch"
	eapply "${FILESDIR}/tizonia-0.18.0-modular-3.patch"
	eapply "${FILESDIR}/tizonia-0.18.0-modular-4.patch"
	eapply "${FILESDIR}/tizonia-0.18.0-modular-5.patch"
	eapply "${FILESDIR}/tizonia-0.18.0-modular-6.patch"
	eapply "${FILESDIR}/tizonia-0.18.0-modular-7.patch"
	eapply "${FILESDIR}/tizonia-0.18.0-modular-8.patch"
	eapply "${FILESDIR}/tizonia-0.18.0-modular-9.patch"
	eapply "${FILESDIR}/tizonia-0.18.0-modular-10.patch"
	eapply "${FILESDIR}/tizonia-0.18.0-modular-11.patch"
	eapply "${FILESDIR}/tizonia-0.18.0-modular-12.patch"
	eapply "${FILESDIR}/tizonia-0.18.0-modular-13.patch"
	eapply "${FILESDIR}/tizonia-0.18.0-modular-14.patch"
	eapply "${FILESDIR}/tizonia-0.18.0-modular-15.patch"
	eapply "${FILESDIR}/tizonia-0.18.0-modular-16.patch"
	eapply "${FILESDIR}/tizonia-0.18.0-modular-17.patch"
	eapply "${FILESDIR}/tizonia-0.18.0-modular-18.patch"
	eapply "${FILESDIR}/tizonia-0.18.0-modular-19.patch"
	eapply "${FILESDIR}/tizonia-0.18.0-modular-20.patch"
	eapply "${FILESDIR}/tizonia-0.18.0-modular-21.patch"
	eapply "${FILESDIR}/tizonia-0.18.0-modular-22.patch"
	eapply "${FILESDIR}/tizonia-0.18.0-modular-23.patch"
	eapply "${FILESDIR}/tizonia-0.18.0-modular-24.patch"

	eautoreconf

	multilib_copy_sources
}

multilib_src_configure() {
	python_foreach_impl python_configure_all
}

python_configure_all() {
	cd "${WORKDIR}/${MY_PN}-${PV}-${MULTILIB_ABI_FLAG}.${ABI}"
	L=$(grep -l -r -e "boost_python" ./)
	for l in $L ; do
		einfo "Patching $l -lboost_python to -lboost_${EPYTHON//python/python-}"
		sed -i "s|-lboost_python|-lboost_${EPYTHON//python/python-}|g" $l || die
	done

	local myconf

	if use zsh-completion ; then
		myconf+=" --with-zshcompletiondir=/usr/share/zsh/vendor-completions"
	else
		myconf+=" --without-zshcompletiondir"
	fi

	if use bash-completion ; then
		myconf+=" --with-bashcompletiondir=/usr/share/bash-completion/completions"
	else
		myconf+=" --without-bashcompletiondir"
	fi

	if use icecast-client || use soundcloud || use google-music || use dirble || use youtube || use plex ; then
		myconf+=" --with-http-source"
	else
		myconf+=" --without-http-source"
	fi

	econf \
		$(use_with aac) \
		$(use_with alsa) \
		$(use_with bash-completion) \
		$(use_enable blocking-sendcommand) \
		$(use_enable blocking-etb-ftb) \
		$(use_with boost) \
		$(use_with chromecast) \
		$(use_with curl) \
		$(use_with dbus) \
		$(use_with dirble) \
		$(use_with file-io) \
		$(use_with flac) \
		$(use_with google-music gmusic) \
		$(use_with icecast-client) \
		$(use_with icecast-server) \
		$(use_with inproc-io) \
		$(use_with mp4) \
		$(use_with mp3-metadata-eraser) \
		$(use_with ogg) \
		$(use_with openrc) \
		$(use_with opus) \
		$(use_enable player) \
		$(use_with lame) \
		$(use_with libsndfile) \
		$(use_with mad) \
		$(use_with mp2) \
		$(use_with plex) \
		$(use_with pulseaudio) \
		$(use_with sdl) \
		$(use_with soundcloud) \
		$(use_with spotify) \
		$(use_with systemd) \
		$(use_with vorbis) \
		$(use_with vpx vp8) \
		$(use_with webm) \
		$(use_with youtube) \
		$(use_with zsh-completion) \
		$(use_enable test) \
		${myconf} || die
}


multilib_src_compile() {
	python_foreach_impl python_compile_all
}

python_compile_all() {
	emake || die
}

multilib_src_install() {
	python_foreach_impl python_install_all

	if use openrc ; then
		dodir /etc/init.d
		exeinto /etc/init.d
		doexe ${FILESDIR}/tizrmd
	fi
	if use systemd ; then
		dodir /usr/lib/systemd/system/
		mv "${D}"/usr/share/dbus-1/services/com.aratelia.tiz.rm.service "${D}"/usr/lib/systemd/system/ || die
	else
		rm -rf "${D}"/usr/share/dbus-1/services/com.aratelia.tiz.rm.service || die
	fi

	#if ! use bash-completion ; then
	#	[ -d "${D}"/usr/share/bash-completion ] && rm -rf "${D}"/usr/share/bash-completion || die
	#fi
}

python_install_all() {
	emake DESTDIR="${D}" install
}

multilib_src_install_all() {
	einstalldocs
}

pkg_postrm() {
	if use openrc ; then
		rc-update add tizrmd
		/etc/init.d/tizrmd start
	fi
	if use systemd ; then
		systemctl enable com.aratelia.tiz.rm.service
		systemctl start com.aratelia.tiz.rm.service
	fi
}

pkg_prerm() {
	if use openrc ; then
		/etc/init.d/tizrmd stop
		rc-update delete tizrmd
	fi
	if use systemd ; then
		systemctl disable com.aratelia.tiz.rm.service
		systemctl stop com.aratelia.tiz.rm.service
	fi
}
