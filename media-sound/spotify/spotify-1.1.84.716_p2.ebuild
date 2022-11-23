# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop gnome2-utils toolchain-funcs unpacker xdg

DESCRIPTION="A social music platform"
HOMEPAGE="https://www.spotify.com"
LICENSE="Spotify BSD"

# Third Party Licenses:
# CEF uses the BSD license
# CEF depends on Blink and internal third party libraries/codecs.

# For details see:
# https://www.spotify.com/us/download/linux/
# https://community.spotify.com/t5/Desktop-Linux/Linux-Spotify-client-1-x-now-in-stable/m-p/1300404
#
# Stable: http://repository.spotify.com/dists/stable/Release
# Testing: http://repository.spotify.com/dists/testing/Release
#
# Requirements:
#
# Stable:
# http://repository.spotify.com/dists/stable/non-free/binary-amd64/Packages
#
# Testing:
# http://repository.spotify.com/dists/testing/non-free/binary-amd64/Packages
#

MY_PV=$(ver_cut 1-4 ${PV})
MY_REV=$(ver_cut 6 ${PV})
BUILD_ID_AMD64="gc5f8b819"
if [[ -z "${MY_REV}" ]] ; then
	_BUILD_ID_AMD64="${BUILD_ID_AMD64}"
else
	_BUILD_ID_AMD64="${BUILD_ID_AMD64}-${MY_REV}"
fi
FN="${PN}-client_${MY_PV}.${_BUILD_ID_AMD64}_amd64.deb"
SRC_URI="${FN}"
SLOT="0"
KEYWORDS="~amd64"

# Dropped pax-kernel USE flag because of the license plus the CEF version used
# is already EOL.  Use the web version instead for the secure version.

# Dropped systray USE flag because of license.

IUSE="emoji ffmpeg libnotify pulseaudio vaapi wayland zenity +X"
REQUIRED_USE="
	|| ( wayland X )
"
RESTRICT="fetch mirror strip"

# Support based on (20.04) LTS mainly but older LTSs may be supported.

# Found in Recommends: section of stable requirements.
# If >=ffmpeg-5.0 is installed only, then audio podcast playback doesn't work.
# A few of these audio podcasts require <ffmpeg-5.0.
OPTIONAL_RDEPENDS_LISTED="
	ffmpeg? (
		>=media-video/ffmpeg-4.2.2
		<media-video/ffmpeg-5
	)
	libnotify? (
		>=x11-libs/libnotify-0.7.9
	)
"

# Not listed in URLs
OPTIONAL_RDEPENDS_UNLISTED="
	emoji? (
		>=media-libs/fontconfig-2.11.91
		>=x11-libs/cairo-1.16.0
		media-libs/freetype[png]
		|| (
			media-fonts/noto-color-emoji
			media-fonts/noto-color-emoji-bin
			media-fonts/noto-emoji
			media-fonts/twemoji
		)
	)
	pulseaudio? (
		media-sound/pulseaudio
	)
	vaapi? (
		>=media-libs/libva-2.1[drm(+),wayland?,X?]
		media-libs/vaapi-drivers
	)
	zenity? (
		>=gnome-extra/zenity-3.28.1
	)
"

# START CEF DEPENDS
# Some *DEPENDs below are copy pasted and based on the cef-bin ebuild.

# *DEPENDs based on install-build-deps.sh's common_lib_list and lib_list variables.
# U >=16.04 LTS assumed, supported only in CEF

# For details see:
# https://github.com/chromium/chromium/blob/99.0.4844.84/build/install-build-deps.sh#L237

# The version is obtained in src_prepare

# libxss1 is x11-libs/libXScrnSaver

GLIB_V="2.48"
XI_V="1.7.6"
CHROMIUM_CDEPEND="
	>=app-accessibility/at-spi2-atk-2.18.3
	>=dev-libs/glib-${GLIB_V}:2
	>=dev-libs/libevdev-1.4.6
	>=dev-libs/libffi-3.2.1
	>=dev-libs/nss-3.21
	>=media-libs/alsa-lib-1.1.0
	>=media-libs/mesa-11.2.0[gbm(+),wayland?,X?]
	>=sys-apps/pciutils-3.3.1
	>=sys-apps/util-linux-2.27.1
	>=sys-libs/glibc-2.23
	>=sys-libs/libcap-2.24
	>=sys-libs/pam-1.1.8
	>=x11-libs/cairo-1.14.6
	>=x11-libs/gtk+-3.18.9:3[wayland?,X?]
	>=x11-libs/libdrm-2.4.67
	wayland? (
		>=dev-libs/wayland-1.13:=
	)
	X? (
		>=x11-libs/libXtst-1.2.2
	)
"

# Possibly Nth level dependencies, but not direct.
UNLISTED_RDEPEND="
	>=media-libs/mesa-11.2.0[egl(+),wayland?,X?]
	>=x11-libs/libxkbcommon-0.5.0
	dev-libs/fribidi
	dev-libs/gmp
	dev-libs/libbsd
	dev-libs/libtasn1
	dev-libs/libunistring
	dev-libs/nettle
	media-libs/harfbuzz
	media-libs/libglvnd
"

# Not listed as either direct or Nth level library
# Also the feature may not be present or reachable.
#UNLISTED_CR_RDEPEND_DROPPED="
#	>=app-accessibility/speech-dispatcher-0.8.3
#	>=dev-db/sqlite-3.11
#	>=dev-libs/libappindicator-12.10
#	gnome-keyring? ( >=gnome-base/gnome-keyring-3.12 )
#"

#UNLISTED_SP_RDEPEND_DROPPED="
#	>=x11-libs/libxshmfence-1.3
#

OPTIONAL_RDEPEND="
	>=media-libs/vulkan-loader-1.0.8.0
"

# cups is required or it will segfault.
CHROMIUM_RDEPEND="
	${CHROMIUM_CDEPEND}
	${OPTIONAL_RDEPEND}
	${UNLISTED_RDEPEND}
	>=dev-libs/atk-2.18.0
	>=dev-libs/expat-2.1.0
	>=dev-libs/libpcre-8.38
	>=dev-libs/nspr-4.11
	>=media-libs/fontconfig-2.11.94
	>=media-libs/freetype-2.6.1
	>=media-libs/libpng-1.6.20
	>=net-print/cups-2.1.3
	>=sys-devel/gcc-5.4.0[cxx(+)]
	>=x11-libs/pango-1.38.1
	>=x11-libs/pixman-0.33.6
	>=sys-libs/zlib-1.2.8
	X? (
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
	)
"

CEFCLIENT_RDEPENDS_NOT_LISTED="
	>=x11-libs/gtk+:3[wayland?,X?]
"

CEFCLIENT_RDEPENDS="
	>=dev-libs/glib-${GLIB_V}:2
	>=x11-libs/libXi-${XI_V}
"

RDEPEND+="
	${CEFCLIENT_RDEPENDS}
	${CHROMIUM_RDEPEND}
"

# END CEF DEPENDS


# gcc contains libatomic.so.1
# mesa contains libgbm.so.1
# Sourced from http://repository.spotify.com/dists/stable/non-free/binary-amd64/Packages
RDEPEND+="
	${OPTIONAL_RDEPENDS_LISTED}
	${OPTIONAL_RDEPENDS_UNLISTED}
	>=dev-libs/atk-2.34.1
	>=dev-libs/glib-2.64.6
	>=dev-libs/nss-3.49.1
	>=gnome-base/gconf-3.2.6
	>=media-libs/alsa-lib-1.2.2
	>=media-libs/mesa-20.0.4[wayland?,X?]
	>=net-misc/curl-7.68[ssl,gnutls]
	>=x11-libs/gtk+-3.22.30:3[wayland?,X?]
	>=x11-misc/xdg-utils-1.1.3
	sys-devel/gcc
	sys-libs/glibc
	X? (
		>=x11-libs/libXScrnSaver-1.2.3
		>=x11-libs/libXtst-1.2.3
	)
	|| (
		=dev-libs/openssl-3*:0
		=dev-libs/openssl-1.1*:0
		=dev-libs/openssl-1.0.2*:0
		=dev-libs/openssl-1.0.1*:0
		=dev-libs/openssl-1.0.0*:0
	)
"

#RDEPEND_LISTED_BUT_NOT_LINKED="
#	>=x11-libs/libXScrnSaver-1.2.3
#	>=x11-libs/libXtst-1.2.3
#"

BDEPEND+="
	app-arch/gzip
	wayland? (
		|| (
			sys-devel/gcc
			sys-devel/clang
		)
	)
"

S="${WORKDIR}"

QA_PREBUILT="
	opt/${PN}/${PN}-client/${PN}
	opt/${PN}/${PN}-client/libEGL.so
	opt/${PN}/${PN}-client/libGLESv2.so
	opt/${PN}/${PN}-client/libcef.so
	opt/${PN}/${PN}-client/libvk_swiftshader.so
	opt/${PN}/${PN}-client/libvulkan.so.1
	opt/${PN}/${PN}-client/swiftshader/libEGL.so
	opt/${PN}/${PN}-client/swiftshader/libGLESv2.so
"

pkg_nofetch() {
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
einfo
einfo "Please download ${FN} from:"
einfo
einfo "  https://www.spotify.com/us/download/linux/"
einfo
einfo "or"
einfo
einfo "  https://repository-origin.spotify.com/pool/non-free/s/spotify-client/"
einfo
einfo "and move it to your distfiles directory located at"
einfo
einfo "  ${distdir}"
einfo
}

pkg_setup() {
einfo
einfo "This is the stable version."
einfo
	if ! has_version "sys-devel/gcc:10" ; then
ewarn
ewarn "Upstream assumes gcc-10 with libatomic.so.1 is installed"
ewarn "like the reference developer machine but is missing."
ewarn
	fi
	if ! use ffmpeg ; then
ewarn
ewarn "Some podcasts will be broken if the ffmpeg USE flag is disabled."
ewarn
	fi
}

src_compile() {
	if use wayland ; then
		cat "${FILESDIR}/xstub.c" > "${T}/xstub.c" || die
		CC=$(tc-getCC)
		${CC} "${T}/xstub.c" -o "${T}/${PN}-xstub.so" -shared || die
	fi
}

gen_x11_wrapper() {
cat <<-EOF >"${D}/usr/bin/${PN}-x11" || die
#!/bin/sh
exec "${DEST}/${PN}" "\$@"
EOF
	fperms +x /usr/bin/${PN}-x11
}

gen_wayland_wrapper() {
cat <<-EOF >"${D}/usr/bin/${PN}-wayland" || die
#!/bin/sh
LD_PRELOAD=/usr/$(get_libdir)/${PN}-xstub.so exec "${DEST}/${PN}" --enable-features=UseOzonePlatform --ozone-platform=wayland "\$@"
EOF
	fperms +x /usr/bin/${PN}-wayland
}

src_install() {
	gunzip usr/share/doc/${PN}-client/changelog.gz || die
	dodoc usr/share/doc/${PN}-client/changelog

	SHARE_PATH="usr/share/${PN}"
	insinto /usr/share/pixmaps
	doins "${SHARE_PATH}/icons/"*".png"

	# Install in /opt/${PN}
	DEST="/opt/${PN}/${PN}-client"
	insinto "${DEST}"
	doins -r "${SHARE_PATH}/"*
	fperms +x "${DEST}/${PN}"

	dodir /usr/bin
	if use wayland ; then
		dolib.so "${T}/${PN}-xstub.so"
		gen_wayland_wrapper
	fi
	if use X ; then
		gen_x11_wrapper
	fi

	if use wayland ; then
		dosym ${PN}-wayland /usr/bin/${PN}
	elif use X ; then
		dosym ${PN}-x11 /usr/bin/${PN}
	fi

	local FONT_SIZES=(
		16
		22
		24
		32
		48
		64
		128
		256
		512
	)
	local size
	for size in ${FONT_SIZES[@]} ; do
		newicon -s ${size} \
		"${S}/${SHARE_PATH}/icons/${PN}-linux-${size}.png" \
			"${PN}-client.png"
	done
	domenu "${S}/${SHARE_PATH}/${PN}.desktop"
	# Dropped pax_kernel USE flag because of license.
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_pkg_postinst

ewarn
ewarn "If ${PN^} crashes after an upgrade its cache may be corrupt.  To remove"
ewarn "the cache:"
ewarn
ewarn "  rm -rf ~/.cache/${PN} ~/.config/${PN}"
ewarn

	if ! use ffmpeg ; then
ewarn
ewarn "Some podcasts will be broken if the ffmpeg USE flag is disabled."
ewarn
	fi

	if ! use emoji ; then
ewarn
ewarn "Some tracks will be blank with emoji USE flag disabled."
ewarn
	fi

	# Prevent install collsion if any.
	ln -sf "libcurl.so.4" "/usr/$(get_libdir)/libcurl-gnutls.so.4" || die

# For DEPENDs compatibility requirements check for install-build-deps.sh.
#	CEF_VERSION=$(strings "${EROOT}/opt/${PN}/${PN}-client/libcef.so" \
#		| grep -E "\+chromium-")
#einfo
#einfo "CEF version:  ${CEF_VERSION}"
#einfo
	if use wayland ; then
ewarn
ewarn "Fullscreening a video podcast in a Wayland desktop environment may"
ewarn "segfault, use cinema mode instead."
ewarn
	fi

	if use wayland && use X ; then
ewarn
ewarn "This ebuild makes the alternative platform the default."
ewarn "To override this choice you can choose one below:"
ewarn
ewarn "  ln -sf ${PN}-wayland /usr/bin/${PN}"
ewarn "  ln -sf ${PN}-x11 /usr/bin/${PN}"
ewarn
	fi
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_pkg_postrm
}
