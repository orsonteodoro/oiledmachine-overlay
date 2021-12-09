# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eapi7-ver
inherit gnome2-utils pax-utils unpacker xdg

DESCRIPTION="Spotify is a social music platform"
HOMEPAGE="https://www.spotify.com/ch-de/download/previews/"
LICENSE="Spotify BSD"

# Third Party Licenses:
# CEF uses the BSD license

# For details see:
# https://www.spotify.com/us/download/linux/
# https://community.spotify.com/t5/Desktop-Linux/Linux-Spotify-client-1-x-now-in-stable/m-p/1300404

# Stable: http://repository.spotify.com/dists/stable/Release
# Testing: http://repository.spotify.com/dists/testing/Release

# Requirements:
#
# Stable:
# http://repository.spotify.com/dists/stable/non-free/binary-amd64/Packages
#
# Testing:
# http://repository.spotify.com/dists/testing/non-free/binary-amd64/Packages

BUILD_ID_AMD64="gc253025e"
SRC_BASE="http://repository.spotify.com/pool/non-free/s/${PN}-client/"
SRC_URI="${SRC_BASE}${PN}-client_${PV}.${BUILD_ID_AMD64}_amd64.deb"
SLOT="0"
KEYWORDS="~amd64"
IUSE="ffmpeg libnotify pax_kernel pulseaudio systray zenity"
RESTRICT="mirror strip"

# zenity is needed for filepicker

# Versions based on (20.04) LTS mainly but older LTSs may be supported

# Found in Recommends: section
OPTIONAL_RDEPENDS_LISTED="
	ffmpeg? (
		>=media-video/ffmpeg-4.2.2
	)
	libnotify? ( >=x11-libs/libnotify-0.7.9 )
"

# Not listed in URLs
OPTIONAL_RDEPENDS_UNLISTED="
	pulseaudio? ( media-sound/pulseaudio )
	systray? (
		dev-python/pygobject:3
		gnome-extra/gnome-integration-spotify
	)
	zenity? ( gnome-extra/zenity )
"

# START CEF DEPENDS
# Depends based on cef-bin

# Based on install-build-deps.sh
# U >=16.04 LTS assumed, supported only in CEF

# For details see:
# https://github.com/chromium/chromium/blob/87.0.4280.141/build/install-build-deps.sh

# The version is obtained in src_prepare

# TODO: app-accessibility/speech-dispatcher needs multilib
# libxss1 is x11-libs/libXScrnSaver
GLIB_V="2.48"
XI_V="1.7.6"
CHROMIUM_CDEPEND="
	>=app-accessibility/at-spi2-atk-2.18.3
	>=app-accessibility/speech-dispatcher-0.8.3
	>=dev-db/sqlite-3.11
	>=dev-libs/glib-${GLIB_V}:2
	>=dev-libs/libappindicator-12.10
	>=dev-libs/libevdev-1.4.6
	>=dev-libs/libffi-3.2.1
	>=net-print/cups-2.1.3
	>=sys-apps/pciutils-3.3.1
	>=sys-libs/libcap-2.24
	>=sys-libs/pam-1.1.8
	>=media-libs/alsa-lib-1.1.0
	>=media-libs/mesa-11.2.0[gbm]
	>=sys-apps/util-linux-2.27.1
	>=sys-libs/glibc-2.23
	>=x11-libs/cairo-1.14.6
	>=x11-libs/gtk+-3.18.9:3
	>=x11-libs/libXtst-1.2.2
	>=x11-libs/libdrm-2.4.67"
# Unlisted based on ldd inspection not found in common_lib_list
# check alsa, xshmfence in ldd
UNLISTED_RDEPEND="
	net-dns/libidn
	dev-libs/fribidi
	dev-libs/gmp
	dev-libs/libbsd
	dev-libs/libtasn1
	dev-libs/libunistring
	>=dev-libs/nss-3.21
	dev-libs/nettle
	media-gfx/graphite2
	media-libs/harfbuzz
	media-libs/libglvnd
	>=media-libs/mesa-11.2.0[egl]
	>=x11-libs/libxkbcommon-0.5.0
	>=x11-libs/libxshmfence-1.3"
OPTIONAL_RDEPEND="
	>=gnome-base/libgnome-keyring-3.12
	>=media-libs/vulkan-loader-1.0.8.0"

CHROMIUM_RDEPEND_NOT_LISTED="
	dev-libs/wayland
"

CHROMIUM_RDEPEND="
	${CHROMIUM_CDEPEND}
	${UNLISTED_RDEPEND}
	${OPTIONAL_RDEPEND}
	>=sys-devel/gcc-5.4.0[cxx(+)]
	>=dev-libs/atk-2.18.0
	>=dev-libs/expat-2.1.0
	>=dev-libs/libpcre-8.38
	>=dev-libs/nspr-4.11
	>=media-libs/fontconfig-2.11.94
	>=media-libs/freetype-2.6.1
	>=media-libs/libpng-1.6.20
	>=x11-libs/libX11-1.6.3
	>=x11-libs/libXau-1.0.8
	>=x11-libs/libXcomposite-0.4.4
	>=x11-libs/libXcursor-1.1.14
	>=x11-libs/libXdamage-1.1.4
	>=x11-libs/libXdmcp-1.1.2
	>=x11-libs/libXext-1.3.3
	>=x11-libs/libXfixes-5.0.1
	>=x11-libs/libXi-${XI_V}
	>=x11-libs/libXinerama-1.1.3
	>=x11-libs/libXrandr-1.5.0
	>=x11-libs/libXrender-0.9.9
	>=x11-libs/libxcb-1.6.3
	>=x11-libs/pango-1.38.1
	>=x11-libs/pixman-0.33.6
	>=sys-libs/zlib-1.2.8"
# libcef alone uses aura not gtk

CEFCLIENT_RDEPENDS_NOT_LISTED="
	>=x11-libs/gtk+:3
	>=x11-libs/gtkglext-1.2.0
"

CEFCLIENT_RDEPENDS="
	>=dev-libs/glib-${GLIB_V}:2
	>=x11-libs/libXi-${XI_V}
"

RDEPEND+="
	${CHROMIUM_RDEPEND}
	${CEFCLIENT_RDEPENDS}
"

# END CEF DEPENDS


# gcc contains libatomic.so.1
# mesa contains libgbm.so.1
BDEPEND+=" >=dev-util/patchelf-0.10"
RDEPEND+="
	${OPTIONAL_RDEPENDS_LISTED}
	${OPTIONAL_RDEPENDS_UNLISTED}
	>=dev-libs/atk-2.34.1
	>=dev-libs/glib-2.64.6
	>=x11-libs/gtk+-3.22.30:3
	sys-devel/gcc
	>=dev-libs/nss-3.49.1
	>=dev-libs/openssl-1:0
	 <dev-libs/openssl-1.2:0
	>=gnome-base/gconf-3.2.6
	>=media-libs/alsa-lib-1.2.2
	>=media-libs/mesa-20.0.4[X(+)]
	>=net-misc/curl-7.68[ssl,gnutls]
	>=x11-libs/libXScrnSaver-1.2.3
	>=x11-libs/libXtst-1.2.3
	>=x11-misc/xdg-utils-1.1.3
"

S=${WORKDIR}/

QA_PREBUILT="
	opt/spotify/spotify-client/spotify
	opt/spotify/spotify-client/libEGL.so
	opt/spotify/spotify-client/libGLESv2.so
	opt/spotify/spotify-client/libcef.so
	opt/spotify/spotify-client/swiftshader/libEGL.so
	opt/spotify/spotify-client/swiftshader/libGLESv2.so
"

pkg_setup() {
	einfo "This is the testing version."
	if ! has_version "sys-devel/gcc:10" ; then
		ewarn "Upstream assumes gcc-10 with libatomic.so.1 is installed"
		ewarn "like the reference developer machine but is missing."
	fi
}

src_prepare() {
	# For depends requirements
	CEF_VERSION=$(strings "${WORKDIR}/usr/share/spotify/libcef.so" | grep -E "\+chromium-")
	einfo "CEF version:  ${CEF_VERSION}"

	xdg_src_prepare
	# Fix desktop entry to launch spotify-dbus.py for systray integration
	if use systray ; then
		sed -i \
			-e 's/spotify \%U/spotify-dbus.py \%U/g' \
			usr/share/spotify/spotify.desktop || die "sed failed"
	fi
	default

	# Spotify links against libcurl-gnutls.so.4, which does not exist in Gentoo.
	patchelf --replace-needed libcurl-gnutls.so.4 libcurl.so.4 usr/bin/spotify \
		|| die "failed to patch libcurl library dependency"
}

src_install() {
	gunzip usr/share/doc/spotify-client/changelog.gz || die
	dodoc usr/share/doc/spotify-client/changelog

	SPOTIFY_PKG_HOME=usr/share/spotify
	insinto /usr/share/pixmaps
	doins ${SPOTIFY_PKG_HOME}/icons/*.png

	# install in /opt/spotify
	SPOTIFY_HOME=/opt/spotify/spotify-client
	insinto ${SPOTIFY_HOME}
	doins -r ${SPOTIFY_PKG_HOME}/*
	fperms +x ${SPOTIFY_HOME}/spotify

	dodir /usr/bin
	cat <<-EOF >"${D}"/usr/bin/spotify || die
		#! /bin/sh
		exec ${SPOTIFY_HOME}/spotify "\$@"
	EOF
	fperms +x /usr/bin/spotify

	local size
	for size in 16 22 24 32 48 64 128 256 512; do
		newicon -s ${size} \
		"${S}${SPOTIFY_PKG_HOME}/icons/spotify-linux-${size}.png" \
			"spotify-client.png"
	done
	domenu "${S}${SPOTIFY_PKG_HOME}/spotify.desktop"
	if use pax_kernel; then
		#create the headers, reset them to default, then paxmark -m them
		pax-mark C "${ED}${SPOTIFY_HOME}/${PN}" || die
		pax-mark z "${ED}${SPOTIFY_HOME}/${PN}" || die
		pax-mark m "${ED}${SPOTIFY_HOME}/${PN}" || die
		eqawarn "You have set USE=pax_kernel meaning that you intend to run"
		eqawarn "${PN} under a PaX enabled kernel.  To do so, we must modify"
		eqawarn "the ${PN} binary itself and this *may* lead to breakage!  If"
		eqawarn "you suspect that ${PN} is being broken by this modification,"
		eqawarn "please open a bug."
	fi
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_pkg_postinst

	ewarn "If Spotify crashes after an upgrade its cache may be corrupt."
	ewarn "To remove the cache:"
	ewarn "rm -rf ~/.cache/spotify"
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_pkg_postrm
}
