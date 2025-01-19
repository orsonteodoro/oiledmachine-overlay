# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: playwright.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for playwright dependencies
# @DESCRIPTION:
# Adds/checks playwright dependencies.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac


_playwright_set_globals() {
	if [[ -z "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" ]] ; then
		PLAYWRIGHT_BROWSERS+=(
			"chromium"
			"firefox"
			"webkit"
		)
	fi
}
_playwright_set_globals
unset -f _playwright_set_globals

PLAYWRIGHT_BROWSERS=()
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "chromium"( |$) ]] ; then
	PLAYWRIGHT_BROWSERS+=(
		"chromium"
	)
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "chromium-tip-of-tree"( |$) ]] ; then
	PLAYWRIGHT_BROWSERS+=(
		"chromium-tip-of-tree"
	)
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "chromium-headless-shell"( |$) ]] ; then
	PLAYWRIGHT_BROWSERS+=(
		"chromium-headless-shell"
	)
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "firefox"( |$) ]] ; then
	PLAYWRIGHT_BROWSERS+=(
		"firefox"
	)
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "firefox-beta"( |$) ]] ; then
	PLAYWRIGHT_BROWSERS+=(
		"firefox-beta"
	)
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "webkit"( |$) ]] ; then
	PLAYWRIGHT_BROWSERS+=(
		"webkit"
	)
fi



IUSE+="
	${PLAYWRIGHT_BROWSERS[@]}
"
REQUIRED_USE+="
	|| (
		${PLAYWRIGHT_BROWSERS[@]}
	)
"

if [[ "${EPLAYWRIGHT_NEEDS_TOOLS}" == "1" ]] ; then
	IUSE+="
		tools
	"
	RDEPEND+="
		tools? (
			(
				media-fonts/font-cronyx-cyrillic
				media-fonts/font-misc-cyrillic
				media-fonts/font-screen-cyrillic
				media-fonts/font-winitzki-cyrillic
			)
			media-fonts/font-bitstream-type1
			media-fonts/freefont
			media-fonts/ja-ipafonts
			media-fonts/liberation-fonts
			media-fonts/thaifonts-scalable
			media-fonts/unifont
			media-fonts/wqy-zenhei
			media-libs/fontconfig
			media-libs/freetype
			x11-base/xorg-server[xvfb]
			|| (
				media-fonts/noto-color-emoji
				media-fonts/noto-color-emoji-bin
				media-fonts/noto-emoji
			)
		)
	"
fi

CHROMIUM_RDEPEND="
	app-accessibility/at-spi2-core
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	dev-libs/wayland
	media-libs/alsa-lib
	media-libs/mesa
	net-print/cups
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/libX11
	x11-libs/libdrm
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libxkbcommon
	x11-libs/libXrandr
	x11-libs/pango
"

FIREFOX_RDEPEND="
	app-accessibility/at-spi2-core
	dev-libs/glib:2
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-video/ffmpeg
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/pango
"

WEBKIT_RDEPEND="
	>=dev-libs/icu-70
	app-accessibility/at-spi2-core
	app-crypt/libsecret
	app-text/enchant
	dev-libs/glib:2
	dev-libs/hyphen
	dev-libs/libevdev
	dev-libs/libevent
	dev-libs/libgudev
	dev-libs/libffi
	dev-libs/libmanette
	dev-libs/libxml2
	dev-libs/libxslt
	dev-libs/wayland
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz[icu]
	media-libs/gst-plugins-bad[opengl]
	media-libs/gst-plugins-base
	media-libs/gst-plugins-good
	media-libs/libepoxy
	media-libs/libglvnd
	media-libs/libjpeg-turbo
	media-libs/libpng
	media-libs/lcms
	media-libs/mesa
	media-libs/openjpeg
	media-libs/opus
	media-libs/libwebp
	media-libs/woff2
	media-libs/x264
	media-plugins/gst-plugins-libav
	media-plugins/gst-plugins-meta[ffmpeg]
	net-libs/libproxy
	net-libs/libsoup
	sys-apps/dbus
	sys-devel/gcc
	virtual/opengl
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libxkbcommon
	x11-libs/libdrm
	x11-libs/libnotify
	x11-libs/pango
"

# Based on U 22.04
# Compatible with playwright 1.34.3
# https://github.com/microsoft/playwright/blob/v1.34.3/packages/playwright-core/src/server/registry/nativeDeps.ts

if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "chromium"( |$) ]] ; then
	RDEPEND+="
		chromium? (
			${CHROMIUM_RDEPEND}
		)
	"
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "chromium-tip-of-tree"( |$) ]] ; then
	RDEPEND+="
		chromium-tip-of-tree? (
			${CHROMIUM_RDEPEND}
		)
	"
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "chromium-headless-shell"( |$) ]] ; then
	RDEPEND+="
		chromium-headless-shell? (
			${CHROMIUM_RDEPEND}
		)
	"
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "firefox"( |$) ]] ; then
	RDEPEND+="
		firefox? (
			${FIREFOX_RDEPEND}
		)
	"
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "firefox-beta"( |$) ]] ; then
	RDEPEND+="
		firefox-beta? (
			${FIREFOX_RDEPEND}
		)
	"
fi
if [[ "${EPLAYRIGHT_ALLOW_BROWSERS[@]}" =~ "webkit"( |$) ]] ; then
	RDEPEND+="
		webkit? (
			${WEBKIT_RDEPEND}
		)
	"
fi

# @FUNCTION: playwright_gen_uris
# @DESCRIPTION:
# Generate URIs for offline cache.
playwright_gen_uris() {
	#TODO
	:
}
