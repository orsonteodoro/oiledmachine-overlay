# Copyright 2019-2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: electron-app.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for GUI based Electron packages
# @DESCRIPTION:
# The electron-app eclass defines phase functions and utility functions for
# Electron app packages.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

inherit chromium-2 desktop


# ############## START Per-package environmental variables #####################

# Some of these environmental variables manage the degree of consent for
# acceptable vulnerability level.  While the eclass author requires critical for
# updates, other organizations may be tolerant or have different security
# standards.  While some users want a highly secure system, other users just
# want the product to install.  By default, the eclasses use the policy to block
# criticals from being merged into the system.

# For those that just want it to install (no security) you can add
# /etc/portage/env/npm-no-audit-fix.conf with the following without # character:
# NPM_SECAUDIT_ALLOW_AUDIT=0
# NPM_SECAUDIT_ALLOW_AUDIT_FIX=0
# NPM_SECAUDIT_NO_DIE_ON_AUDIT=1
# ELECTRON_APP_ALLOW_AUDIT=0
# ELECTRON_APP_ALLOW_AUDIT_FIX=0
# ELECTRON_APP_NO_DIE_ON_AUDIT=1

# Then, add to /etc/portage/package.env
# ${CATEGORY}/${PN} npm-no-audit-fix.conf

# See electron-app_pkg_setup_per_package_environment_variables() for details.


# ##################  END Per-package environmental variables ##################

# ##################  START ebuild and eclass global variables #################

# [A] Supported versions (LTS) are listed in
# https://www.electronjs.org/docs/latest/tutorial/electron-timelines
ELECTRON_APP_ELECTRON_PV_SUPPORTED="20.0"

ELECTRON_APP_MODE=${ELECTRON_APP_MODE:-"npm"} # can be npm, yarn
ELECTRON_APP_ECLASS_DEBUG=${ELECTRON_APP_ECLASS_DEBUG:-"debug"} # debug or production

# The recurrance interval between critical vulnerabilities in chrome is 10-14
# days recently (worst cases), but longer interval between vulnerabilites with
# 159 days (~5 months) and 5 days has been observed.  If the app is used like a
# web-browser (including social media apps), the internal Chromium requires
# weekly forced updates.
ELECTRON_APP_USED_AS_WEB_BROWSER_OR_SOCIAL_MEDIA_APP=\
${ELECTRON_APP_USED_AS_WEB_BROWSER_OR_SOCIAL_MEDIA_APP:-"0"}

# For Electron 18.2.2 from electron-builder
# See comments below for details.
ELECTRON_APP_LICENSES="
	custom
	( all-rights-reserved HPND )
	( custom ISC all-rights-reserved )
	( LGPL-2.1 LGPL-2.1+ )
	( MPL-1.1 GPL-2 )
	android
	Apache-2.0
	Apache-2.0-with-LLVM-exceptions
	APSL-2
	AFL-2.0
	BitstreamVera
	Boost-1.0
	BSD
	BSD-2
	BSD-4
	BSD-Protection
	CC-BY-3.0
	CC-BY-SA-3.0
	CPL-1.0
	curl
	EPL-1.0
	GPL-2
	GPL-2-with-classpath-exception
	GPL-3
	GPL-3+
	MIT
	MPL-1.1
	MPL-2.0
	FLEX
	FTL
	icu-70.1
	IJG
	ISC
	HPND
	Khronos-CLHPP
	LGPL-2.1
	LGPL-2.1+
	LGPL-3
	LGPL-3+
	libpng
	libpng2
	libstdc++
	neon_2_sse
	NEWLIB
	MPL-1.1
	MPL-2.0
	Ms-PL
	OFL-1.1
	minpack
	openssl
	ooura
	Prior-BSD-License
	SunPro
	Unicode-DFS-2016
	unicode
	unRAR
	UoI-NCSA
	libwebm-PATENTS
	ZLIB
	|| ( public-domain MIT ( public-domain MIT ) )
	|| ( MPL-1.1 GPL-2+ LGPL-2.1+ )
	|| ( ( MPL-2.0 GPL-2+ ) ( MPL-2.0 LGPL-2.1+ ) MPL-2.0 GPL-2.0+ )
" # The ^^ (mutually exclusion) does not work.  It is assumed the user will choose
# outside the computer.

# For Electron: \
# custom \
#   search: "grants an immunity from suit" \
#   custom-font-license \
#     search: "removed from any derivative versions" \
#   ( all-rights-reserved HPND )
#   ( custom ISC with no advertising clause all-rights-reserved ) \
#   ( LGPL-2.1 LGPL-2.1+ ) \
#   ^^ ( (MPL-2.0 GPL-2+) (MPL-2.0 LGPL-2.1+) MPL-2.0 GPL-2.0+ )
#   android \
#   Apache-2.0 \
#   Apache-2.0-with-LLVM-exceptions \
#   APSL-2 \
#   AFL-2.0 \
#   BitstreamVera \
#   BSD \
#   BSD-2 \
#   BSD-4 \
#   BSD-Protection \
#   CC-BY-SA-3.0 \
#   CPL-1.0 \
#   curl \
#   GPL-2 \
#   GPL-2-with-classpath-exception \
#   GPL-3 \
#   GPL-3+ \
#   MIT \
#   MPL-2.0 \
#   FLEX \
#   FTL \
#   icu-70.1 \
#   icu (58) \
#   icu (1.8.1+) \
#   IJG \
#   ISC \
#   HPND \
#   Khronos-CLHPP \
#   LGPL-2.1 \
#   LGPL-2.1+ \
#   LGPL-3 \
#   LGPL-3+ \
#   libpng \
#   libpng2 \
#   libstdc++ \
#   NEWLIB \
#   MPL-1.1 \
#   MPL-2.0 \
#   Ms-PL \
#   neon_2_sse \
#   OFL-1.1 \
#   PCRE8 (BSD) \
#   minpack \
#   openssl \
#   ooura \
#   Prior-BSD-License
#   SunPro \
#   Unicode-DFS-2016 \
#   unicode \
#   unRAR \
#   UoI-NCSA \
#   libwebm-PATENTS \
#   ZLIB \
#   || ( MPL-1.1 GPL-2+ LGPL-2.1+ ) \
#   || ( public-domain MIT ( public-domain MIT ) ) - \
#   newIDE/electron-app/node_modules/electron/dist/LICENSES.chromium.html

# For Electron: \
#   (Similar to newIDE/electron-app/node_modules/electron/dist/LICENSES.chromium.html) with changes \
#   ( MPL-1.1 GPL-2 ) \
#   Boost-1.0 \
#   EPL-1.1 - \
#   newIDE/electron-app/app/node_modules/electron/dist/LICENSES.chromium.html
#
# IANAL:
# This list appears auto generated (99.4k line html license file), but some of
# these modules or files may not be present in the Chromium source code tarball.
# The license compatibility may be better explained in the headers or usage
# (build files versus redistributed).
#

ELECTRON_APP_DATA_DIR="${EROOT}/var/cache/npm-secaudit"
ELECTRON_APP_VERSION_DATA_PATH="${ELECTRON_APP_DATA_DIR}/lite.json"

IUSE+=" wayland +X"
REQUIRED_USE+="
	|| ( wayland X )
"

ELECTRON_APP_OPTIONAL_DEPEND=" "
ELECTRON_APP_CR_OPTIONAL_DEPEND=" "
if [[ "${ELECTRON_APP_FEATURE_APPINDICATOR}" == "1" ]] ; then
	IUSE+=" app-indicator"
	ELECTRON_APP_OPTIONAL_DEPEND+="
		app-indicator? (
			dev-libs/libappindicator:3
		)
	"
fi

if [[ "${ELECTRON_APP_FEATURE_GLOBAL_MENU_BAR}" == "1" ]] ; then
	IUSE+=" global-menu-bar"
	ELECTRON_APP_OPTIONAL_DEPEND+="
		global-menu-bar? (
			dev-libs/libdbusmenu
		)
	"
fi

if [[ "${ELECTRON_APP_FEATURE_GNOME_KEYRING}" == "1" ]] ; then
	IUSE+=" gnome-keyring"
	ELECTRON_APP_CR_OPTIONAL_DEPEND+="
		gnome-keyring? (
			gnome-base/gnome-keyring[pam]
		)
	"
fi

if [[ "${ELECTRON_APP_FEATURE_LIBSECRET}" == "1" ]] ; then
	IUSE+=" libsecret"
	ELECTRON_APP_CR_OPTIONAL_DEPEND+="
		libsecret? (
			app-crypt/libsecret
		)
	"
fi

if [[ "${ELECTRON_APP_FEATURE_PULSEAUDIO}" == "1" ]] ; then
	IUSE+=" pulseaudio"
	ELECTRON_APP_CR_OPTIONAL_DEPEND+="
		pulseaudio? (
			media-sound/pulseaudio
		)
	"
fi

if [[ "${ELECTRON_APP_FEATURE_UNITY}" == "1" ]] ; then
	IUSE+=" unity"
	ELECTRON_APP_OPTIONAL_DEPEND+="
		unity? (
			dev-libs/libunity
		)
	"
fi

# Add if the app uses video or jpeg images
if [[ "${ELECTRON_APP_FEATURE_VAAPI}" == "1" ]] ; then
	IUSE+=" vaapi"
	ELECTRON_APP_OPTIONAL_DEPEND+="
		media-video/ffmpeg[vaapi?]
		vaapi? (
			media-libs/libva[drm(+),X?,wayland?]
			media-libs/vaapi-drivers
		)
	"
fi

# See https://www.electronjs.org/docs/tutorial/support#linux for OS min requirements.

# For dependencies, see also
# https://github.com/chromium/chromium/blob/109.0.5414.74/build/install-build-deps.sh#L230

# Found in Chromium only
# For optional fonts, see
# https://github.com/chromium/chromium/blob/master/build/linux/install-chromeos-fonts.py
#  For specific versions associated with Chromium release, see as base address
#  https://github.com/chromium/chromium/tree/109.0.5414.74/
#    chromium/chrome/installer/linux/debian/dist_package_versions.json for
#      chromium 66.0.3359.181 (electron version v3.0.0 to latest)
#    chrome/installer/linux/debian/expected_deps_x64 for chromium 49.0.2623.75
#      to <76.0.3809.88 (electron 1.0.0 to <v3.0.0)
# Chromium supports at least U 14.04, this is why there is no version
# restrictions below in all *DEPENDs section.
CHROMIUM_DEPEND="
	${ELECTRON_APP_CR_OPTIONAL_DEPEND}
	app-accessibility/speech-dispatcher
	dev-db/sqlite:3
"
# Electron only
# Assumes U 18.04 builder but allows for older U LTS if libs present.
RPATH_OVERRIDE_DEPEND="
	media-video/ffmpeg
" # System libs that are not used which the bundle version overrides.
COMMON_DEPEND="
	${RPATH_OVERRIDE_DEPEND}
	${CHROMIUM_DEPEND}
	${ELECTRON_APP_OPTIONAL_DEPEND}
	app-accessibility/at-spi2-atk:2
	app-arch/bzip2
	dev-libs/atk
	dev-libs/expat
	dev-libs/fribidi
	dev-libs/glib:2
	dev-libs/gmp
	dev-libs/libffi
	dev-libs/libtasn1
	dev-libs/libbsd
	dev-libs/libpcre:3
	dev-libs/libunistring
	dev-libs/nss
	dev-libs/nettle
	dev-libs/nspr
	media-gfx/graphite2
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz[icu(-)]
	media-libs/libepoxy
	media-libs/libpng
	media-libs/mesa[egl(+),gbm(+)]
	net-dns/libidn2
	net-libs/gnutls
	net-print/cups
	sys-apps/dbus
	sys-apps/pciutils
	sys-apps/util-linux
	sys-devel/gcc[cxx(+)]
	sys-libs/zlib[minizip]
	virtual/ttf-fonts
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3[wayland?,X?]
	x11-libs/libdrm
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/pixman
	wayland? (
		dev-libs/wayland
	)
	X? (
		x11-libs/libX11
		x11-libs/libXScrnSaver
		x11-libs/libXau
		x11-libs/libXcomposite
		x11-libs/libXcursor
		x11-libs/libXdamage
		x11-libs/libXdmcp
		x11-libs/libXext
		x11-libs/libXfixes
		x11-libs/libXi
		x11-libs/libXrandr
		x11-libs/libXrender
		x11-libs/libXtst
		x11-libs/libXxf86vm
		x11-libs/libxcb
		x11-libs/libxshmfence
	)
"

if [[ -n "${ELECTRON_APP_ELECTRON_PV}" ]] \
	&& ver_test $(ver_cut 1-2 "${ELECTRON_APP_ELECTRON_PV}") \
		-ge \
	   ${ELECTRON_APP_ELECTRON_PV_SUPPORTED} ; then
	:; # E20, E21, E22, E23 supported upstream
else
	if [[ "${ELECTRON_APP_ALLOW_NON_LTS_ELECTRON}" == "0" ]] ; then
eerror "Found:  ${ELECTRON_APP_ELECTRON_PV}"
eerror "Supported:  >=${ELECTRON_APP_ELECTRON_PV_SUPPORTED}"
eerror "Electron should be updated to one of the latest Long Term Support (LTS)"
eerror "series versions or else it likely contains critical CVE security"
eerror "advisories."
	fi
fi

# See https://github.com/angular/angular/blob/4.0.x/package.json
if [[ -n "${ELECTRON_APP_ANGULAR_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_PV}") -ge 2.0 \
	&& ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_PV}") -le 2.4 ) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-5.4.1
		<net-libs/nodejs-7
	"
elif [[ -n "${ELECTRON_APP_ANGULAR_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_PV}") -ge 4.0 \
	&& ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_PV}") -le 4.4 ) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-6.9.5
		<net-libs/nodejs-7
	"
elif [[ -n "${ELECTRON_APP_ANGULAR_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_PV}") -ge 5.0 \
	&& ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_PV}") -le 6.0 ) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-8.9.1
		<net-libs/nodejs-9
	"
elif [[ -n "${ELECTRON_APP_ANGULAR_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_PV}") -ge 6.1 \
	&& ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_PV}") -le 8.2 ) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-10.9.0
		<net-libs/nodejs-11
	"
elif [[ -n "${ELECTRON_APP_ANGULAR_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_PV}") -ge 9.0 \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_ANGULAR_PV}") -le 11.2.8 ) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-10.9.0
		<net-libs/nodejs-13
	"
elif [[ -n "${ELECTRON_APP_ANGULAR_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_PV}") -ge 11.2.9 \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_ANGULAR_PV}") -le 11.2.14 ) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-10.19.0
		<net-libs/nodejs-16
	"
elif [[ -n "${ELECTRON_APP_ANGULAR_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_PV}") -ge 12.0.0 \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_ANGULAR_PV}") -le 12.2.11 ) ; then
	COMMON_DEPEND+="
		|| (
			>=net-libs/nodejs-12.20.0:12
			>=net-libs/nodejs-14:14
		)
	"
elif [[ -n "${ELECTRON_APP_ANGULAR_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_PV}") -ge 13 \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_ANGULAR_PV}") -lt 14 ) ; then
	COMMON_DEPEND+="
		|| (
			>=net-libs/nodejs-12.20.0:12
			>=net-libs/nodejs-14.15:14
			>=net-libs/nodejs-16.10.0:16
		)
	"
elif [[ -n "${ELECTRON_APP_ANGULAR_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_PV}") -ge 14 \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_ANGULAR_PV}") -lt 15 ) ; then
	COMMON_DEPEND+="
		|| (
			>=net-libs/nodejs-14.15:14
			>=net-libs/nodejs-16.10.0:16
		)
	"
elif [[ -n "${ELECTRON_APP_ANGULAR_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_PV}") -ge 15 \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_ANGULAR_PV}") -lt 16 ) ; then
	COMMON_DEPEND+="
		|| (
			>=net-libs/nodejs-14.20:14
			>=net-libs/nodejs-16.13.0:16
			>=net-libs/nodejs-18.10.0:16
		)
	"
elif [[ -n "${ELECTRON_APP_ANGULAR_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_PV}") -ge 16 \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_ANGULAR_PV}") -le 9999 ) ; then
	COMMON_DEPEND+="
		|| (
			>=net-libs/nodejs-16.14.0:16
			>=net-libs/nodejs-18.10.0:16
		)
	"
fi

# See https://github.com/facebook/react/blob/master/package.json
if [[ -n "${ELECTRON_APP_REACT_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_PV}") -ge 0.3 \
	&& ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_PV}") -le 0.13 ) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-0.10.0
	"
elif [[ -n "${ELECTRON_APP_REACT_PV}" ]] \
	&& ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_PV}") -eq 0.14 ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-4
		<net-libs/nodejs-5
	"
elif [[ -n "${ELECTRON_APP_REACT_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_PV}") -ge 15.0 \
	&& ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_PV}") -le 15.6 ) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-4
		<net-libs/nodejs-8
	"
elif [[ -n "${ELECTRON_APP_REACT_PV}" ]] \
	&& ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_PV}") -eq 16.3 ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-8
		<net-libs/nodejs-11
	"
elif [[ -n "${ELECTRON_APP_REACT_PV}" ]] \
	&& ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_PV}") -eq 16.4 ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-8
		<net-libs/nodejs-10
	"
elif [[ -n "${ELECTRON_APP_REACT_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_REACT_PV}") -ge 16.8.3 \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_REACT_PV}") -le 16.8.6 ) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-8
		<net-libs/nodejs-12
	"
elif [[ -n "${ELECTRON_APP_REACT_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_REACT_PV}") -ge 16.13.0 \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_REACT_PV}") -le 16.13.1 ) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-8
		<net-libs/nodejs-14
	"
elif [[ -n "${ELECTRON_APP_REACT_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_REACT_PV}") -ge 16.14.0 \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_REACT_PV}") -lt 18 ) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-8
		<net-libs/nodejs-15
	"
elif [[ -n "${ELECTRON_APP_REACT_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_REACT_PV}") -ge 18 \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_REACT_PV}") -lt 18 ) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-12.17
		<net-libs/nodejs-18
	"
elif [[ -n "${ELECTRON_APP_REACT_PV}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_REACT_PV}") -ge 9999 ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-16
		<net-libs/nodejs-21
	"
fi

# See https://github.com/microsoft/TypeScript/blob/v2.0.7/package.json
if [[ -n "${ELECTRON_APP_TYPESCRIPT_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_TYPESCRIPT_PV}") -ge 2.0 \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_TYPESCRIPT_PV}") -le 2.1.4 ) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-0.8.0
	"
elif [[ -n "${ELECTRON_APP_TYPESCRIPT_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_TYPESCRIPT_PV}") -ge 2.1.5 \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_TYPESCRIPT_PV}") -lt 5.0.2 ) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-4.2.0
	"
elif [[ -n "${ELECTRON_APP_TYPESCRIPT_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_TYPESCRIPT_PV}") -ge 5.0.2 \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_TYPESCRIPT_PV}") -le 5.0.4 ) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-12.20
	"
elif [[ -n "${ELECTRON_APP_TYPESCRIPT_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_TYPESCRIPT_PV}") -gt 5.0.4 ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-14.17
	"
fi

# See https://github.com/facebook/react-native/blob/0.63-stable/package.json
if [[ -n "${ELECTRON_APP_REACT_NATIVE_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_NATIVE_PV}") -ge 0.13 \
	&& ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_NATIVE_PV}") -le 0.55 ) ; then
	COMMON_DEPEND+="" # doesn't say
elif [[ -n "${ELECTRON_APP_REACT_NATIVE_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_NATIVE_PV}") -ge 0.13 \
	&& ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_NATIVE_PV}") -le 0.55 ) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-4
	"
elif [[ -n "${ELECTRON_APP_REACT_NATIVE_PV}" ]] \
	&& ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_NATIVE_PV}") -eq 0.56 ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-8
	"
elif [[ -n "${ELECTRON_APP_REACT_NATIVE_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_NATIVE_PV}") -ge 0.57 \
	&& ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_NATIVE_PV}") -le 0.62 ) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-8.3
	"
elif [[ -n "${ELECTRON_APP_REACT_NATIVE_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_NATIVE_PV}") -ge 0.63 \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_REACT_NATIVE_PV}") -lt 0.64 ) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-10
	"
elif [[ -n "${ELECTRON_APP_REACT_NATIVE_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_NATIVE_PV}") -ge 0.64 \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_REACT_NATIVE_PV}") -le 0.67 ) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-12
	"
elif [[ -n "${ELECTRON_APP_REACT_NATIVE_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_NATIVE_PV}") -ge 0.68 \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_REACT_NATIVE_PV}") -le 0.71.12 ) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-14
	"
elif [[ -n "${ELECTRON_APP_REACT_NATIVE_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_NATIVE_PV}") -gt 0.71.12 \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_REACT_NATIVE_PV}") -le 9999 ) ; then
	# Same as react 18.2.0
	COMMON_DEPEND+="
		>=net-libs/nodejs-12.17
		<net-libs/nodejs-18
	"
fi


# See https://github.com/DefinitelyTyped/DefinitelyTyped/blob/master/types/node
# in the v13/index.d.ts, where v13 is a particular node version.
# For @types/node
if [[ -n "${ELECTRON_APP_AT_TYPES_NODE_PV}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_PV}") -eq 0 ; then
	COMMON_DEPEND+=" =net-libs/nodejs-0*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_PV}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_PV}") -eq 4 ; then
	COMMON_DEPEND+=" =net-libs/nodejs-4*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_PV}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_PV}") -eq 6 ; then
	COMMON_DEPEND+=" =net-libs/nodejs-6*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_PV}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_PV}") -eq 7 ; then
	COMMON_DEPEND+=" =net-libs/nodejs-7*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_PV}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_PV}") -eq 8 ; then
	COMMON_DEPEND+=" =net-libs/nodejs-8*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_PV}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_PV}") -eq 9 ; then
	COMMON_DEPEND+=" =net-libs/nodejs-9*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_PV}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_PV}") -eq 10 ; then
	COMMON_DEPEND+=" =net-libs/nodejs-10*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_PV}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_PV}") -eq 11 ; then
	COMMON_DEPEND+=" =net-libs/nodejs-11*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_PV}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_PV}") -eq 12 ; then
	COMMON_DEPEND+=" =net-libs/nodejs-12*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_PV}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_PV}") -eq 13 ; then
	COMMON_DEPEND+=" =net-libs/nodejs-13*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_PV}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_PV}") -eq 14 ; then
	COMMON_DEPEND+=" =net-libs/nodejs-14*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_PV}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_PV}") -eq 15 ; then
	COMMON_DEPEND+=" =net-libs/nodejs-15*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_PV}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_PV}") -eq 16 ; then
	COMMON_DEPEND+=" =net-libs/nodejs-16*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_PV}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_PV}") -eq 17 ; then
	COMMON_DEPEND+=" =net-libs/nodejs-17*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_PV}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_PV}") -eq 18 ; then
	COMMON_DEPEND+=" =net-libs/nodejs-18*"
fi

# https://github.com/vuejs/vue/blob/v2.7.10/package.json
# Some are based on @types/node
if [[ -n "${ELECTRON_APP_VUE_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -ge 0.6.0 \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -le 0.11.10 ) ; then
	COMMON_DEPEND+=" =net-libs/nodejs-0.10*" # .travis.yml
elif [[ -n "${ELECTRON_APP_VUE_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -ge 0.12.0 \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -le 0.12.0 ) ; then
	COMMON_DEPEND+=" net-libs/iojs" # doesn't say
elif [[ -n "${ELECTRON_APP_VUE_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -ge 0.12.1 \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -le 0.12.1 ) ; then
	COMMON_DEPEND+=" ~net-libs/iojs-2.0.1" # .travis.yml
elif [[ -n "${ELECTRON_APP_VUE_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -ge 0.12.2 \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -le 0.12.2 ) ; then
	COMMON_DEPEND+=" " # doesn't say
elif [[ -n "${ELECTRON_APP_VUE_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -ge 0.12.0 \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -le 1.0.8 ) ; then
	COMMON_DEPEND+=" ~net-libs/iojs-2.0.1" # .travis.yml
elif [[ -n "${ELECTRON_APP_VUE_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -ge 1.0.9 \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -le 1.0.17 ) ; then
	COMMON_DEPEND+=" =net-libs/nodejs-4*" # based on circle.yml
elif [[ -n "${ELECTRON_APP_VUE_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -ge 1.0.18 \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -le 1.0.28 ) ; then
	COMMON_DEPEND+=" =net-libs/nodejs-5*" # based on circle.yml
elif [[ -n "${ELECTRON_APP_VUE_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -ge 2.0.0 \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -le 2.4.4 ) ; then
	COMMON_DEPEND+=" =net-libs/nodejs-6*" # based on circle.yml
elif [[ -n "${ELECTRON_APP_VUE_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -ge 2.5.0 \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -le 2.5.22 ) ; then
	# based on @types/node restriction
	COMMON_DEPEND+=" =net-libs/nodejs-8*" # ^8.0.33 ; they did the testing in node6 in <=2.5.7
elif [[ -n "${ELECTRON_APP_VUE_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -ge 2.6.0 \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -le 2.6.10 ) ; then
	# based on @types/node restriction
	COMMON_DEPEND+=" =net-libs/nodejs-10*" # ^10.12.18
elif [[ -n "${ELECTRON_APP_VUE_PV}" ]] \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -ge 2.6.11 ; then
	# based on @types/node restriction
	# dev branch
	COMMON_DEPEND+=" =net-libs/nodejs-12*" # ^12.12.0
elif [[ -n "${ELECTRON_APP_VUE_PV}" ]] \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -ge 2.7 ; then
	# based on @types/node restriction
	# dev branch
	COMMON_DEPEND+=" =net-libs/nodejs-17*" # ^17.0.41
fi

if [[ -n "${ELECTRON_APP_VUE_CORE_PV}" ]] &&
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_CORE_PV}") -eq 3.0.0 ; then
	COMMON_DEPEND+=" =net-libs/nodejs-10*"
elif [[ -n "${ELECTRON_APP_VUE_CORE_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_CORE_PV}") -ge 3.0.1 \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_CORE_PV}") -lt 3.2 ) ; then
	COMMON_DEPEND+=" =net-libs/nodejs-14*" # ^14.10.1
elif [[ -n "${ELECTRON_APP_VUE_CORE_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_CORE_PV}") -ge 3.2 ) ; then
	COMMON_DEPEND+=" =net-libs/nodejs-16*" # ^16.4.7
fi

# Same packages as far back as 3.x
RDEPEND+=" ${COMMON_DEPEND}"
DEPEND+=" ${COMMON_DEPEND}"

if (( ${EAPI} == 7 )) ; then
	BDEPEND+="
		app-misc/jq
		net-misc/wget
		sys-apps/file
		sys-apps/grep[pcre]
	"
else
	DEPEND+="
		app-misc/jq
		net-misc/wget
		sys-apps/file
		sys-apps/grep[pcre]
	"
fi

# This is for single exe portable versions versus the traditional install
# `doins -r.`   AppImage or snaps have advantages like putting electron apps
# in a sandbox and bundled in a compressed archive like squashfs.
# The uncompressed install is typically +1G so using a portable install
# may reduce to just a few MB.
# Ebuild developer must provide an electron-app_src_compile to tell
# electron-builder package the app manually.  Do something like:
# electron-builder -l AppImage --pd dist/linux-unpackaged/
# electron-builder -l flatpak --pd dist/linux-unpackaged/
# electron-builder -l snap --pd dist/linux-unpackaged/
#
_ELECTRON_APP_PACKAGING_METHODS+=( unpacked )
if [[ "${ELECTRON_APP_APPIMAGE}" == "1" ]] ; then
	IUSE+=" appimage"
	_ELECTRON_APP_PACKAGING_METHODS+=( appimage )
	RDEPEND+="
		appimage? (
			|| (
				app-arch/appimaged
				app-arch/go-appimage[appimaged]
			)
		)
	"
	# emerge will dump the .AppImage in that folder.
	ELECTRON_APP_APPIMAGE_INSTALL_DIR=${ELECTRON_APP_APPIMAGE_INSTALL_DIR:-"/opt/AppImage"}
fi
if [[ "${ELECTRON_APP_SNAP}" == "1" ]] ; then
	IUSE+=" snap"
	_ELECTRON_APP_PACKAGING_METHODS+=( snap )
	RDEPEND+="
		snap? ( app-emulation/snapd )
	"
	# emerge will dump it in that folder then use snap functions
	# to install desktop files and mount the image.
	ELECTRON_APP_SNAP_INSTALL_DIR=${ELECTRON_APP_SNAP_INSTALL_DIR:-"/opt/snap"}
	ELECTRON_APP_SNAP_NAME=${ELECTRON_APP_SNAP_NAME:-${PN}}
	# ELECTRON_APP_SNAP_REVISION is also defineable
fi
if [[ "${ELECTRON_APP_FLATPAK}" == "1" ]] ; then
	IUSE+=" flatpak"
	RDEPEND+="
		flatpak? ( sys-apps/flatpak )
	"
	_ELECTRON_APP_PACKAGING_METHODS+=( flatpak )
	ELECTRON_APP_FLATPAK_INSTALL_DIR=${ELECTRON_APP_SNAP_INSTALL_DIR:-"/opt/flatpak"}
fi
IUSE+=" ${_ELECTRON_APP_PACKAGING_METHODS[@]/unpacked/+unpacked}"
REQUIRED_USE+=" || ( ${_ELECTRON_APP_PACKAGING_METHODS[@]} )"

# The sandbox support via appimage/snap is on hold.
# To restore appimage/snap parts, see
# https://github.com/orsonteodoro/oiledmachine-overlay/blob/290569a4d3c98d225cd6576beea3bf5b6bb41b20/eclass/electron-app.eclass

# ##################  END ebuild and eclass global variables ###################

# @FUNCTION: electron-app_gen_wrapper
# @DESCRIPTION:
# Generates a wrapper script for deterministic execution and for
# dynamic X/Wayland support.
electron-app_gen_wrapper() {
	local name="${1}"
	local cmd="${2}"
	exeinto "/usr/bin"
	local node_version=""
	local node_env=""
	if [[ -n "${NODE_VERSION}" ]] ; then
einfo "Setting NODE_VERSION=${NODE_VERSION} in wrapper."
		node_version="export NODE_VERSION=${NODE_VERSION}"
	fi
	if [[ "${NODE_ENV}" == "production" ]] ; then
einfo "Setting NODE_ENV=\${NODE_ENV:-production} in wrapper."
		node_env="export NODE_ENV=\${NODE_ENV:-production}"
	else
einfo "Setting NODE_ENV=\${NODE_ENV:-development} in wrapper."
		node_env="export NODE_ENV=\${NODE_ENV:-development}"
	fi
cat <<EOF > "${T}/${name}" || die
#!/bin/bash
${node_version}
${node_env}
extra_args=""

# Client side window directions (title bar) issue #29618
[[ \${NODE_VERSION} -ge 18 ]] && extra_args="--enable-features=WaylandWindowDecorations"

if [[ -n \${DISPLAY} ]] ; then
	${cmd} "\${@}"
else
	${cmd} --enable-features=UseOzonePlatform --ozone-platform-hint=wayland \${extra_args} "\${@}"
fi
EOF
	doexe "${T}/${name}"
}

#https://github.com/electron/electron/releases/tag/v21.4.4
# @FUNCTION: electron-app_get_electron_platarch
# @DESCRIPTION:
# Gets the platform and architecture for electron tarballs.
electron-app_get_electron_platarch() {
	if use kernel_linux && use arm64 ; then
		echo "linux-arm64"
	elif use kernel_linux && use arm ; then
		echo "linux-armv7l"
	elif use kernel_linux && use amd64 ; then
		echo "linux-x64"
	elif use kernel_Darwin && use arm64-macos ; then
		echo "darwin-arm64"
	elif use kernel_Darwin && use x64-macos ; then
		echo "darwin-x64"
	fi
}

# @FUNCTION: _electron-app_gen_electron_uris_prod
# @DESCRIPTION:
# Generate URIs for offline install of electron based apps for production.
_electron-app_gen_electron_uris_prod() {
	echo "
		kernel_linux? (
			amd64? (
				https://github.com/electron/electron/releases/download/v${ELECTRON_APP_ELECTRON_PV}/electron-v${ELECTRON_APP_ELECTRON_PV}-linux-x64.zip
			)
			arm64? (
				https://github.com/electron/electron/releases/download/v${ELECTRON_APP_ELECTRON_PV}/electron-v${ELECTRON_APP_ELECTRON_PV}-linux-arm64.zip
			)
			arm? (
				https://github.com/electron/electron/releases/download/v${ELECTRON_APP_ELECTRON_PV}/electron-v${ELECTRON_APP_ELECTRON_PV}-linux-armv7l.zip
			)
		)
		kernel_Darwin? (
			x64-macos? (
				https://github.com/electron/electron/releases/download/v${ELECTRON_APP_ELECTRON_PV}/electron-v${ELECTRON_APP_ELECTRON_PV}-darwin-x64.zip
			)
			arm64-macos? (
				https://github.com/electron/electron/releases/download/v${ELECTRON_APP_ELECTRON_PV}/electron-v${ELECTRON_APP_ELECTRON_PV}-darwin-arm64.zip
			)
		)
		https://github.com/electron/electron/releases/download/v${ELECTRON_APP_ELECTRON_PV}/SHASUMS256.txt -> SHASUMS256.txt.${ELECTRON_APP_ELECTRON_PV}
	"
}

# @FUNCTION: _electron-app_gen_electron_uris_devel
# @DESCRIPTION:
# Generate URIs for offline install of electron based apps for ebuild/eclass development.
_electron-app_gen_electron_uris_devel() {
	echo "
		kernel_linux? (
			amd64? (
				https://github.com/electron/electron/releases/download/v${ELECTRON_APP_ELECTRON_PV}/electron-v${ELECTRON_APP_ELECTRON_PV}-linux-x64.zip
			)
		)
		https://github.com/electron/electron/releases/download/v${ELECTRON_APP_ELECTRON_PV}/SHASUMS256.txt -> electron-SHASUMS256.txt.${ELECTRON_APP_ELECTRON_PV}
	"
}

# @FUNCTION: electron-app_gen_electron_uris
# @DESCRIPTION:
# Generate URIs for offline install of electron based apps.
electron-app_gen_electron_uris() {
	if [[ "${ELECTRON_APP_ECLASS_DEBUG}" == "debug" ]] ; then
		_electron-app_gen_electron_uris_devel
	else
		_electron-app_gen_electron_uris_prod
	fi
}

# @FUNCTION: electron-app_cp_electron
# @DESCRIPTION:
# Copies the electron tarball for offline install.
electron-app_cp_electron() {
	#export ELECTRON_SKIP_BINARY_DOWNLOAD=${ELECTRON_SKIP_BINARY_DOWNLOAD:-1}
	export ELECTRON_BUILDER_CACHE="${HOME}/.cache/electron-builder"
	export ELECTRON_CACHE="${HOME}/.cache/electron"
	mkdir -p "${ELECTRON_CACHE}" || die
	local fn="electron-v${ELECTRON_APP_ELECTRON_PV}-$(electron-app_get_electron_platarch).zip"
	export ELECTRON_CUSTOM_FILENAME="${fn}"
	export ELECTRON_CUSTOM_DIR="${ELECTRON_APP_ELECTRON_PV}"
	cp -a \
		"${DISTDIR}/${fn}" \
		"${ELECTRON_CACHE}/${fn}" \
		|| die
	cp -a \
		"${DISTDIR}/electron-SHASUMS256.txt.${ELECTRON_APP_ELECTRON_PV}" \
		"${ELECTRON_CACHE}/SHASUMS256.txt" \
		|| die
}

# @FUNCTION: electron-app_get_electron_platarch_args
# @DESCRIPTION:
# Generate platform and architecture arguments
electron-app_get_electron_platarch_args() {
	local args=()
	if use kernel_Darwin ; then
		args+=(
			--mac
		)
	elif use kernel_linux ; then
		args+=(
			--linux
		)
	fi
	if use kernel_linux && use arm64 ; then
		args+=(
			--arm64
		)
	elif use kernel_linux && use arm ; then
		args+=(
			--armv7l
		)
	elif use kernel_linux && use amd64 ; then
		args+=(
			--arm64
		)
	elif use kernel_Darwin && use arm64-macos ; then
		args+=(
			--arm64
		)
	elif use kernel_Darwin && use x64-macos ; then
		args+=(
			--x64
		)
	fi
}
