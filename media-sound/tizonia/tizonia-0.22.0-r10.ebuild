# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Command-line cloud music player for Linux with support for \
Spotify, Google Play Music, YouTube, SoundCloud, TuneIn, IHeartRadio, Plex \
servers and Chromecast devices."
HOMEPAGE="http://tizonia.org"
LICENSE="LGPL-3.0+"
KEYWORDS="~amd64 ~x86"
PYTHON_COMPAT=( python3_{6,7,8} )
inherit eutils flag-o-matic meson multilib-minimal python-single-r1 xdg
SLOT="0/${PV}"
IUSE="+aac +alsa +bash-completion -blocking-etb-ftb -blocking-sendcommand
 +boost +curl +dbus +file-io +flac +fuzzywuzzy +inproc-io
 +mp4 +ogg +opus +lame +libsndfile +mad +mp3-metadata-eraser +mp2 +mpg123
 +player +pulseaudio +python +sdl +icecast-client +icecast-server
 +iheart -test +vorbis +vpx +webm +zsh-completion
 +chromecast +google-music +plex +soundcloud +spotify +tunein +youtube"
REQUIRED_USE="chromecast? ( player python boost curl dbus google-music )
	      google-music? ( player python boost fuzzywuzzy curl )
	      icecast-client? ( player curl )
	      icecast-server? ( player )
	      iheart? ( boost player python )
	      mp2? ( mpg123 )
	      mp3-metadata-eraser? ( mpg123 )
	      ogg? ( curl )
	      player? ( boost python )
	      plex? ( player python boost fuzzywuzzy curl )
	      python? ( || ( chromecast google-music iheart plex player
			soundcloud spotify tunein youtube ) )
	      !python? ( !chromecast !google-music !iheart !plex !player
			!soundcloud !spotify !tunein !youtube )
	      soundcloud? ( player python boost fuzzywuzzy curl )
	      spotify? ( player python boost fuzzywuzzy )
	      tunein? ( player python boost fuzzywuzzy curl )
	      youtube? ( player python boost fuzzywuzzy curl )"

# 3rd party repos may be required and be added to package.unmask.  Use
# `layman -a <repo-name>` to add some of these overlays that hold these
# packages:
# =media-sound/tizonia-0.22.0-r3::oiledmachine-overlay
# =dev-python/casttube-0.2.0::HomeAssistantRepository
# =dev-python/fuzzywuzzy-0.12.0::gentoo
# =dev-python/gmusicapi-12.1.1::palmer
# =dev-python/gpsoauth-0.4.1::palmer
# =dev-python/proboscis-1.2.6.0::palmer
# =dev-python/PyChromecast-3.2.2::HomeAssistantRepository
# =dev-python/pycryptodomex-3.7.3::palmer
# =dev-python/python-plexapi-3.0.6::oiledmachine-overlay
# =dev-python/soundcloud-python-9999.20151015::oiledmachine-overlay
# =dev-python/validictory-1.1.2::palmer
# =media-libs/nestegg-9999.20190603::oiledmachine-overlay
# * Use the newer version if possible.  The versions listed are examples.

# The following should be added to package.accept_keywords or package.unmask
# if you are using multilib with 32-bit:
# dev-libs/libspotify::oiledmachine-overlay
# dev-libs/log4c::oiledmachine-overlay
# media-libs/liboggz::oiledmachine-overlay
# media-libs/opusfile::oiledmachine-overlay
# media-libs/libmp4v2::oiledmachine-overlay
# media-libs/libfishsound::oiledmachine-overlay

# The following require package.masks if using multilib with 32-bit:
# dev-libs/libspotify::gentoo
# dev-libs/libspotify::palmer
# media-libs/liboggz::gentoo
# media-libs/opusfile::gentoo
# media-libs/libmediainfo::gentoo
# media-libs/libmp4v2::gentoo
# media-libs/libfishsound::gentoo
# net-libs/zeromq::gentoo

#
# ogg_muxer requires curl, oggmuxsnkprc.c is work in progress.  ogg should
# work without curl for just strictly local playback only (as in non streaming
# player) tizonia
#
# >=dev-python/dnspython-1.16.0 added to avoid merge conflict between pycrypto
# and pycryptodome.  It should not be here but resolved in dnspython.
RDEPEND="aac? (  media-libs/faad2[${MULTILIB_USEDEP}] )
	 alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )
	 bash-completion? ( app-shells/bash )
	 boost? (
		>=dev-libs/boost-1.54[${MULTILIB_USEDEP}]
		$(python_gen_cond_dep '>=dev-libs/boost-1.54[python,${PYTHON_MULTI_USEDEP}]')
	 )
	 chromecast? ( || ( $(python_gen_cond_dep 'dev-python/PyChromecast[${PYTHON_MULTI_USEDEP}]')
			    $(python_gen_cond_dep 'dev-python/pychromecast[${PYTHON_MULTI_USEDEP}]') ) )
	 curl? ( >=net-misc/curl-7.18.0[${MULTILIB_USEDEP}] )
	 flac? ( >=media-libs/flac-1.3.0[${MULTILIB_USEDEP}] )
	 fuzzywuzzy? ( $(python_gen_cond_dep 'dev-python/fuzzywuzzy[${PYTHON_MULTI_USEDEP}]') )
	 google-music? ( $(python_gen_cond_dep 'dev-python/gmusicapi[${PYTHON_MULTI_USEDEP}]') )
	 inproc-io? ( >=net-libs/zeromq-4.0.4[${MULTILIB_USEDEP}] )
	 lame? ( media-sound/lame[${MULTILIB_USEDEP}] )
	 ogg? ( >=media-libs/liboggz-1.1.1[${MULTILIB_USEDEP}] )
	 opus? ( >=media-libs/opusfile-0.5[${MULTILIB_USEDEP}] )
	 dbus? ( sys-apps/dbus[${MULTILIB_USEDEP}] )
	 libsndfile? ( >=media-libs/libsndfile-1.0.25[${MULTILIB_USEDEP}] )
	 mp4? ( media-libs/libmp4v2[${MULTILIB_USEDEP}] )
	 mad? ( media-libs/libmad[${MULTILIB_USEDEP}] )
	 mpg123? ( >=media-sound/mpg123-1.16.0[${MULTILIB_USEDEP}] )
	 opus? ( >=media-libs/opus-1.1[${MULTILIB_USEDEP}] )
	 player? ( >=media-libs/libmediainfo-0.7.65[${MULTILIB_USEDEP}]
		   >=media-libs/taglib-1.7.0[${MULTILIB_USEDEP}] )
	 plex? ( $(python_gen_cond_dep 'dev-python/python-plexapi[${PYTHON_MULTI_USEDEP}]') )
	 pulseaudio? ( >=media-sound/pulseaudio-1.1[${MULTILIB_USEDEP}] )
	 python? ( ${PYTHON_DEPS} )
	 sdl? ( media-libs/libsdl[${MULTILIB_USEDEP}] )
	 soundcloud? ( $(python_gen_cond_dep 'dev-python/soundcloud-python[${PYTHON_MULTI_USEDEP}]') )
	 spotify? ( >=dev-libs/libspotify-12.1.51[${MULTILIB_USEDEP}] )
	 $(python_gen_cond_dep '>=sys-apps/util-linux-2.19.0[${PYTHON_MULTI_USEDEP}]')
	 test? ( dev-db/sqlite:3[${MULTILIB_USEDEP}] )
	 vorbis? ( media-libs/libfishsound[${MULTILIB_USEDEP}] )
	 vpx? ( media-libs/libvpx[${MULTILIB_USEDEP}] )
	 youtube? ( $(python_gen_cond_dep 'dev-python/pafy[${PYTHON_MULTI_USEDEP}]')
		    $(python_gen_cond_dep 'net-misc/youtube-dl[${PYTHON_MULTI_USEDEP}]') )
	 webm? ( media-libs/nestegg[${MULTILIB_USEDEP}] )
	 zsh-completion? ( app-shells/zsh )"

DEPEND="${RDEPEND}
	>=dev-libs/check-0.9.4[${MULTILIB_USEDEP}]
	>=dev-libs/log4c-1.2.1[${MULTILIB_USEDEP}]"
SRC_URI=\
"https://github.com/tizonia/tizonia-openmax-il/archive/v${PV}.tar.gz \
	-> ${PN}-${PV}.tar.gz"
MY_PN="tizonia-openmax-il"
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="mirror"
_PATCHES=(
	"${FILESDIR}/tizonia-0.22.0-modular-1.patch"
	"${FILESDIR}/tizonia-0.22.0-modular-2.patch"
	"${FILESDIR}/tizonia-0.22.0-modular-3.patch"
	"${FILESDIR}/tizonia-0.22.0-modular-4.patch"
	"${FILESDIR}/tizonia-0.22.0-modular-5.patch"
	"${FILESDIR}/tizonia-0.22.0-modular-6.patch"
	"${FILESDIR}/tizonia-0.22.0-modular-7.patch"
	"${FILESDIR}/tizonia-0.22.0-modular-8.patch"
	"${FILESDIR}/tizonia-0.22.0-modular-9.patch"
	"${FILESDIR}/tizonia-0.22.0-modular-10.patch"
	"${FILESDIR}/tizonia-0.22.0-modular-11.patch"
	"${FILESDIR}/tizonia-0.22.0-modular-12.patch"
	"${FILESDIR}/tizonia-0.22.0-modular-13.patch"
	"${FILESDIR}/tizonia-0.22.0-modular-meson-build.patch"
	"${FILESDIR}/tizonia-0.22.0-modular-meson-optional-python.patch"
)

pkg_setup() {
	python_setup
	local jobs=$(echo "${MAKEOPTS}" | grep -P -o -e "(-j|--jobs=)\s*[0-9]+" \
			| sed -r -e "s#(-j|--jobs=)\s*##g")
	local cores=$(nproc)
	if (( ${jobs} > $((${cores}/2)) )) ; then
		ewarn \
"${PN} may lock up or freeze the computer if the N value in MAKEOPTS=\"-jN\" \
is greater than \$(nproc)/2"
	fi
}

src_prepare() {
	default
	xdg_src_prepare
	eapply ${_PATCHES[@]}
	multilib_copy_sources
}

src_configure() {
	configure_abi() {
		cd "${BUILD_DIR}"

		L=$(find . -name "*.pc.in")
		for l in $L ; do
			einfo "Patching $l for -lpython3.6m to -l${EPYTHON}m"
			sed -i "s|-lpython3.6m|-l${EPYTHON}m|g" $l || die
			einfo "Patching $l for -lboost_python36 to -lboost_${EPYTHON//./}"
			sed -i "s|-lboost_python36|-lboost_${EPYTHON//./}|g" $l || die
		done

		PYTHON_LIBS="-L/usr/$(get_libdir) -l${EPYTHON}m" \
		PYTHON_SITE_PKG="/usr/$(get_libdir)/${EPYTHON}/site-packages" \
		PKG_CONFIG="/usr/bin/$(get_abi_CHOST ${ABI})-pkg-config" \

		local plugins=
		use aac && plugins+=( aac_decoder )
		use alsa && plugins+=( pcm_renderer_alsa )
		use file-io && plugins+=( file_writer )
		use flac && plugins+=( flac_decoder )
		use icecast-server && plugins+=( http_renderer )
		use inproc-io && plugins+=( inproc_reader inproc_writer )
		use lame && plugins+=( mp3_encoder )
		use libsndfile && plugins+=( pcm_decoder )
		use mad && plugins+=( mp3_decoder )
		use mp3-metadata-eraser && plugins+=( mp3_metadata )
		use opus && plugins+=( opus_decoder opusfile_decoder )
		use pulseaudio && plugins+=( pcm_renderer_pa )
		use sdl && plugins+=( yuv_renderer )
		use vorbis && plugins+=( vorbis_decoder )
		use vpx && plugins+=( vp8_decoder )
		use webm && plugins+=( webm_demuxer )

		local clients=
		use chromecast \
			&& clients+=( chromecast ) \
			&& plugins+=( chromecast_renderer )
		use google-music && clients+=( gmusic )
		use iheart && clients+=( iheart )
		use plex && clients+=( plex )
		use soundcloud && clients+=( soundcloud )
		use spotify \
			&& clients+=( spotify ) \
			&& plugins+=( spotify )
		use tunein && clients+=( tunein )
		use youtube && clients+=( youtube )

		( use icecast-client || use google-music || use iheart || use plex \
			|| use soundcloud || use tunein || use youtube ) \
			&& plugins+=( http_source )

		local emesonargs=(
			-Dplugins=$(echo ${plugins[@]} | tr " " ",")
			-Dclient-services=$(echo ${clients[@]} | tr " " ",")
			$(meson_use blocking-etb-ftb)
			$(meson_use blocking-sendcommand)
			$(meson_use aac)
			$(meson_use alsa)
			$(meson_use curl)
			$(meson_use dbus)
			$(meson_use icecast-client)
			$(meson_use icecast-server)
			$(multilib_native_usex python -Dpython=true -Dpython=false)
			$(multilib_native_usex player -Dplayer=true -Dplayer=false)
			$(usex python -Dboost_python_version=${EPYTHON/./} -Dboost_python_version='')
			$(usex bash-completion -Dbashcompletiondir=/usr/share/bash-completion/completions "")
			$(usex zsh-completion -Dzshcompletiondir=/usr/share/zsh/vendor-completions "")
		)
		EMESON_SOURCE="${BUILD_DIR}" \
		BUILD_DIR="${WORKDIR}/${P}-build-${ABI}" \
		meson_src_configure
	}
	multilib_foreach_abi configure_abi
}


src_compile() {
	compile_abi() {
		EMESON_SOURCE="${BUILD_DIR}" \
		BUILD_DIR="${WORKDIR}/${P}-build-${ABI}" \
		meson_src_compile
	}
	multilib_foreach_abi compile_abi
}

src_install() {
	install_abi() {
		EMESON_SOURCE="${BUILD_DIR}" \
		BUILD_DIR="${WORKDIR}/${P}-build-${ABI}" \
		meson_src_install
	}
	multilib_foreach_abi install_abi
	einstalldocs
}
