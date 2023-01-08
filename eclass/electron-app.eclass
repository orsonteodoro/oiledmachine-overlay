# Copyright 2019-2022 Orson Teodoro
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
# Electron app packages. It depends on the app-portage/npm-secaudit package to
# maintain a secure environment.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

inherit chromium-2 desktop npm-utils


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
	( fping all-rights-reserved )
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
#   ( fping all-rights-reserved ) \
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

ELECTRON_APP_OPTIONAL_DEPENDS=" "
ELECTRON_APP_CR_OPTIONAL_DEPENDS=" "
if [[ "${ELECTRON_APP_FEATURE_APPINDICATOR}" == "1" ]] ; then
	IUSE+=" app-indicator"
	ELECTRON_APP_OPTIONAL_DEPENDS+="
		app-indicator? (
			dev-libs/libappindicator:3
		)
	"
fi

if [[ "${ELECTRON_APP_FEATURE_GLOBAL_MENU_BAR}" == "1" ]] ; then
	IUSE+=" global-menu-bar"
	ELECTRON_APP_OPTIONAL_DEPENDS+="
		global-menu-bar? (
			dev-libs/libdbusmenu
		)
	"
fi

if [[ "${ELECTRON_APP_FEATURE_GNOME_KEYRING}" == "1" ]] ; then
	IUSE+=" gnome-keyring"
	ELECTRON_APP_CR_OPTIONAL_DEPENDS+="
		gnome-keyring? (
			gnome-base/gnome-keyring[pam]
		)
	"
fi

if [[ "${ELECTRON_APP_FEATURE_LIBSECRET}" == "1" ]] ; then
	IUSE+=" libsecret"
	ELECTRON_APP_CR_OPTIONAL_DEPENDS+="
		libsecret? (
			app-crypt/libsecret
		)
	"
fi

if [[ "${ELECTRON_APP_FEATURE_UNITY}" == "1" ]] ; then
	IUSE+=" unity"
	ELECTRON_APP_OPTIONAL_DEPENDS+="
		unity? (
			dev-libs/libunity
		)
	"
fi

if [[ "${ELECTRON_APP_FEATURE_PULSEAUDIO}" == "1" ]] ; then
	IUSE+=" pulseaudio"
	ELECTRON_APP_CR_OPTIONAL_DEPENDS+="
		pulseaudio? (
			media-sound/pulseaudio
		)
	"
fi

# See https://www.electronjs.org/docs/tutorial/support#linux for OS min requirements.

# The dependencies for

# Found in Chromium only
# For optional fonts, see
# https://github.com/chromium/chromium/blob/master/build/linux/install-chromeos-fonts.py
#  For specific versions associated with Chromium release, see as base address
#  https://github.com/chromium/chromium/tree/66.0.3359.181/
#    chromium/chrome/installer/linux/debian/dist_package_versions.json for
#      chromium 66.0.3359.181 (electron version v3.0.0 to latest)
#    chrome/installer/linux/debian/expected_deps_x64 for chromium 49.0.2623.75
#      to <76.0.3809.88 (electron 1.0.0 to <v3.0.0)
# Chromium supports at least U 14.04, this is why there is no version
# restrictions below in all *DEPENDs section.
CHROMIUM_DEPEND="
	${ELECTRON_APP_CR_OPTIONAL_DEPENDS}
	app-accessibility/speech-dispatcher
	dev-db/sqlite:3
"
# Electron only
# Assumes U 18.04 builder but allows for older U LTS if libs present.
COMMON_DEPEND="
	${CHROMIUM_DEPEND}
	${ELECTRON_APP_OPTIONAL_DEPENDS}
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
	media-video/ffmpeg
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
	x11-libs/gtk+:3[X]
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
	x11-libs/libdrm
	x11-libs/libxcb
	x11-libs/libxshmfence
	x11-libs/pango
	x11-libs/pixman
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
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_ANGULAR_PV}") -le 9999 ) ; then
	COMMON_DEPEND+="
		|| (
			>=net-libs/nodejs-12.20.0:12
			>=net-libs/nodejs-14.15:14
			>=net-libs/nodejs-16.10.0:16
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
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_REACT_PV}") -lt 9999 ) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-8
		<net-libs/nodejs-15
	"
elif [[ -n "${ELECTRON_APP_REACT_PV}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_REACT_PV}") -ge 9999 ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-12.17
		<net-libs/nodejs-18
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
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_TYPESCRIPT_PV}") -le 9999 ) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-4.2.0
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
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_REACT_NATIVE_PV}") -le 9999 ) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-14
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

EXPORT_FUNCTIONS pkg_setup src_unpack pkg_preinst pkg_postinst

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
# electron-builder -l snap --pd dist/linux-unpackaged/
#
_ELECTRON_APP_PACKAGING_METHODS+=( unpacked )
if [[ -n "${ELECTRON_APP_APPIMAGEABLE}" \
	&& "${ELECTRON_APP_APPIMAGEABLE}" == 1 ]] ; then
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
	ELECTRON_APP_APPIMAGE_INSTALL_DIR=${ELECTRON_APP_APPIMAGE_INSTALL_DIR:-"/opt/AppImage/${PN}"}
fi
if [[ -n "${ELECTRON_APP_SNAPABLE}" \
	&& "${ELECTRON_APP_SNAPABLE}" == 1 ]] ; then
	IUSE+=" snap"
	_ELECTRON_APP_PACKAGING_METHODS+=( snap )
	RDEPEND+=" snap? ( app-emulation/snapd )"
	# emerge will dump it in that folder then use snap functions
	# to install desktop files and mount the image.
	ELECTRON_APP_SNAP_INSTALL_DIR=${ELECTRON_APP_SNAP_INSTALL_DIR:-"/opt/snap/${PN}"}
	ELECTRON_APP_SNAP_NAME=${ELECTRON_APP_SNAP_NAME:-${PN}}
	# ELECTRON_APP_SNAP_REVISION is also defineable
fi
IUSE+=" ${_ELECTRON_APP_PACKAGING_METHODS[@]/unpacked/+unpacked}"
REQUIRED_USE+=" || ( ${_ELECTRON_APP_PACKAGING_METHODS[@]} )"


# ##################  END ebuild and eclass global variables ###################

# @FUNCTION: _electron-app-flakey-check
# @DESCRIPTION:
# Warns user that download or building can fail randomly
_electron-app-flakey-check() {
	local l=$(find "${S}" -name "package.json")
	grep -q -F -e "electron-builder" $l
	if [[ "$?" == "0" ]] ; then
ewarn
ewarn "This ebuild may fail when building with electron-builder.  Re-emerge if"
ewarn "it fails."
ewarn
	fi

	grep -q -F -e "\"electron\":" $l
	if [[ "$?" == "0" ]] ; then
ewarn
ewarn "This ebuild may fail when downloading Electron as a dependency."
ewarn "Re-emerge if it fails."
ewarn
	fi
}

# @FUNCTION: electron-app_audit_fix_npm
# @DESCRIPTION:
# Removes vulnerable packages.  It will audit every folder containing a
# package-lock.json
electron-app_audit_fix_npm() {
	if [[ -n "${ELECTRON_APP_ALLOW_AUDIT_FIX}" \
		&& "${ELECTRON_APP_ALLOW_AUDIT_FIX}" == "1" ]] ; then
		:;
	else
		return
	fi

einfo
einfo "Performing recursive package-lock.json audit fix"
einfo
	npm_update_package_locks_recursive ./ # calls npm_pre_audit
einfo
einfo "Audit fix done"
einfo
}

# @FUNCTION: electron-app_audit_fix
# @DESCRIPTION:
# Removes vulnerable packages based on the packaging system.
electron-app_audit_fix() {
	if [[ -n "${ELECTRON_APP_ALLOW_AUDIT_FIX}" \
		&& "${ELECTRON_APP_ALLOW_AUDIT_FIX}" == "1" ]] ; then
		:;
	else
		return
	fi

	case "$ELECTRON_APP_MODE" in
		npm)
			electron-app_audit_fix_npm
			;;
		yarn)
			# use npm audit anyway?
ewarn
ewarn "No audit fix implemented in yarn.  Package may be likely vulnerable."
ewarn
			;;
		*)
			;;
	esac

}

# @FUNCTION: electron-app_pkg_setup_per_package_environment_variables
# @DESCRIPTION:
# Initializes per-package environment variables
electron-app_pkg_setup_per_package_environment_variables() {
	npm-utils_pkg_setup

	# Accepts production or development [or unset as development]
	export NODE_ENV=${NODE_ENV:-production}
	if [[ "${NODE_ENV}" == "production" ]] ; then
einfo "NODE_ENV=production"
	else
einfo "NODE_ENV=development"
	fi

	# Set this in your make.conf to control number of HTTP requests.  50 is npm
	# default but it is too high.
	ELECTRON_APP_MAXSOCKETS=${ELECTRON_APP_MAXSOCKETS:-"1"}

	# You could define it as a per-package envar.  It not recommended in the ebuild.
	ELECTRON_APP_ALLOW_AUDIT=${ELECTRON_APP_ALLOW_AUDIT:-"1"}

	# You could define it as a per-package envar.  It not recommended in the ebuild.
	ELECTRON_APP_ALLOW_AUDIT_FIX=${ELECTRON_APP_ALLOW_AUDIT_FIX:-"1"}

	# You could define it as a per-package envar.  It not recommended in the ebuild.
	# Applies to only vulnerability testing not the tool itself.
	ELECTRON_APP_NO_DIE_ON_AUDIT=${ELECTRON_APP_NO_DIE_ON_AUDIT:-"0"}

	# You could define it as a per-package envar.  Disabled by default because
	# rapid changes in dependencies over short period of time.
	ELECTRON_APP_ALLOW_AUDIT_FIX_AT_EBUILD_LEVEL=${ELECTRON_APP_ALLOW_AUDIT_FIX_AT_EBUILD_LEVEL:-"0"}

	# You could define it as a per-package envar.  It not recommended in the ebuild.
	ELECTRON_APP_ALLOW_NON_LTS_ELECTRON=${ELECTRON_APP_ALLOW_NON_LTS_ELECTRON:-"0"}
}

# @FUNCTION: electron-app_pkg_setup
# @DESCRIPTION:
# Initializes globals
electron-app_pkg_setup() {
        debug-print-function ${FUNCNAME} "${@}"

	electron-app_pkg_setup_per_package_environment_variables

	chromium_suid_sandbox_check_kernel_config

	if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package env"
eerror "to be able to download micropackages and obtain version releases"
eerror "information."
eerror
		die
	fi

	#export ELECTRON_PV=$(strings /usr/bin/electron \
	#	| grep -F -e "%s Electron/" \
	#	| sed -r -e "s|[%s A-Za-z/]||g")

	# For @electron/get caches used by electron-packager and electron-builder, see
# https://github.com/electron/get#using-environment-variables-for-mirror-options
	# export ELECTRON_CUSTOM_DIR="${ELECTRON_APP_DATA_DIR}/at-electron-get"
	# mkdir -p ${ELECTRON_CUSTOM_DIR} || die

	# Caches are stored in the sandbox because it is faster and less
	# problematic as in part of the cache will be owned by root and
	# the other by portage.  By avoiding irrelevant checking and resetting
	# file ownership of packages used by other apps, we speed it up.
	export NPM_STORE_DIR="${HOME}/npm" # npm cache location
	export YARN_STORE_DIR="${HOME}/yarn" # yarn cache location
	export npm_config_maxsockets=${ELECTRON_APP_MAXSOCKETS}

	case "$ELECTRON_APP_MODE" in
		npm)
			# Lame bug.  We cannot run `electron --version` because
			# it requires X.
			# It is okay to emerge package outside of X without
			# problems.
			export npm_config_cache="${NPM_STORE_DIR}"
#einfo
#einfo "Electron version: ${ELECTRON_PV}"
#einfo
			#if [[ -z "${ELECTRON_PV}" ]] ; then
			#	echo "Some ebuilds may break.  Restart and run in X."
			#fi

			addwrite "${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
			mkdir -p "${NPM_STORE_DIR}/offline"
			chown -R portage:portage "${NPM_STORE_DIR}"

			# Some npm package.json use yarn.
			addwrite ${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
			mkdir -p ${YARN_STORE_DIR}/offline
			chown -R portage:portage "${YARN_STORE_DIR}"
			export YARN_CACHE_FOLDER=${YARN_CACHE_FOLDER:-${YARN_STORE_DIR}}
			;;
		yarn)
ewarn
ewarn "Using yarn mode which has no audit fix yet."
ewarn

			# Some npm package.json use yarn.
			addwrite ${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
			mkdir -p ${YARN_STORE_DIR}/offline
			chown -R portage:portage "${YARN_STORE_DIR}"
			export YARN_CACHE_FOLDER=${YARN_CACHE_FOLDER:-${YARN_STORE_DIR}}
			;;
		*)
eerror
eerror "Unsupported package system"
eerror
			die
			;;
	esac

	local prev_update
	if [[ -f "${ELECTRON_APP_VERSION_DATA_PATH}" ]] ; then
		prev_update=$(stat -c "%W" "${ELECTRON_APP_VERSION_DATA_PATH}")
	else
		prev_update=0
	fi
	local now=$(date +%s)
	local next_update_seconds=86400
	if [[ ! -d "${ELECTRON_APP_DATA_DIR}" ]] ; then
		mkdir -p "${ELECTRON_APP_DATA_DIR}" || die
	fi
	if (( $((${prev_update} + ${next_update_seconds})) < ${now} )) ; then
einfo
einfo "Updating Electron release data"
einfo
		rm -rf "${ELECTRON_APP_VERSION_DATA_PATH}" || true
		wget -O "${ELECTRON_APP_VERSION_DATA_PATH}" \
		"https://raw.githubusercontent.com/electron/releases/master/lite.json" || die
	else
einfo
einfo "Using cached Electron release data"
einfo
	fi

	if [[ -n "${ELECTRON_APP_APPIMAGEABLE}" \
		&& "${ELECTRON_APP_APPIMAGEABLE}" == 1 ]] ; then
		if [[ -z "${ELECTRON_APP_APPIMAGE_PATH}" ]] ; then
eerror
eerror "ELECTRON_APP_APPIMAGE_PATH must be defined relative to \${BUILD_DIR}"
eerror
			die
		fi
	fi

	if [[ -n "${ELECTRON_APP_SNAPABLE}" \
		&& "${ELECTRON_APP_SNAPABLE}" == 1 ]] ; then
		if [[ -z "${ELECTRON_APP_SNAP_PATH_BASENAME}" ]] ; then
eerror
eerror "ELECTRON_APP_SNAP_PATH_BASENAME must be defined relative to"
eerror "ELECTRON_APP_SNAP_INSTALL_DIR"
eerror
			die
		fi
		if [[ -z "${ELECTRON_APP_SNAP_PATH}" ]] ; then
eerror
eerror "ELECTRON_APP_SNAP_PATH must be defined relative to \${BUILD_DIR}"
eerror
			die
		fi
		if [[ -n "${ELECTRON_APP_SNAP_ASSERT_PATH}" \
			&& -z "${ELECTRON_APP_SNAP_ASSERT_PATH_BASENAME}" ]] ; then
eerror
eerror "ELECTRON_APP_SNAP_ASSERT_PATH_BASENAME must be defined."
eerror
			die
		fi
		if [[ -n "${ELECTRON_APP_SNAP_ASSERT_PATH_BASENAME}" \
			&& -z "${ELECTRON_APP_SNAP_ASSERT_PATH}" ]] ; then
eerror
eerror "ELECTRON_APP_SNAP_ASSERT_PATH must be defined."
eerror
			die
		fi
	fi

	npm-utils_is_nodejs_header_exe_same
	if [[ -n "${NODEJS_BDEPEND}" ]] ; then
		npm-utils_check_nodejs "${NODEJS_BDEPEND}"
	elif [[ -n "${BDEPEND}" ]] ; then
		npm-utils_check_nodejs "${BDEPEND}"
	elif [[ -n "${DEPEND}" ]] ; then
		npm-utils_check_nodejs "${DEPEND}"
	fi

	npm-utils_check_chromium_eol ${CHROMIUM_PV}
}

# @FUNCTION: electron-app_fetch_deps_npm
# @DESCRIPTION:
# Fetches an Electron npm app with security checks
# MUST be called after default unpack AND patching.
electron-app_fetch_deps_npm() {
	_electron-app-flakey-check

	pushd "${S}" || die
		local install_args=()
		# Avoid adding fsevent (a macOS dependency) which may require older node
		if [[ -e "yarn.lock" ]] ; then
			grep -q -F -e "chokidar" "yarn.lock" \
				&& install_args+=( --no-optional )
		elif [[ -e "package-lock.json" ]] ; then
			grep -q -F -e "chokidar" "package-lock.json" \
				&& install_args+=( --no-optional )
		else
			grep -q -F \
				-e "vue-cli-plugin-electron-builder" \
				-e "chokidar" \
				"package.json" \
				&& install_args+=( --no-optional )
		fi
		npm_update_package_locks_recursive ./
		rm "${HOME}/npm/_logs"/* 2>/dev/null
einfo
einfo "Running npm install ${install_args[@]} inside electron-app_fetch_deps_npm"
einfo
		npm install ${install_args[@]} || die
		npm_check_npm_error
	popd
}

# @FUNCTION: electron-app_fetch_deps_yarn
# @DESCRIPTION:
# Fetches an Electron yarn app with security checks
# MUST be called after default unpack AND patching.
electron-app_fetch_deps_yarn() {
	pushd "${S}" || die
# don't check /usr/local/share/.yarnrc .  same number used in their testing.
		export FAKEROOTKEY="15574641"

		# set global dir
		cp "${S}"/.yarnrc{,.orig} 2>/dev/null
		echo "prefix \"${S}/.yarn\"" >> "${S}/.yarnrc" || die
		echo "global-folder \"${S}/.yarn\"" >> "${S}/.yarnrc" || die
		echo "offline-cache-mirror \"${YARN_STORE_DIR}/offline\"" \
			>> "${S}/.yarnrc" || die

		mkdir -p "${S}/.yarn" || die
einfo
einfo "yarn prefix:\t\t\t$(yarn config get prefix)"
einfo "yarn global-folder:\t\t$(yarn config get global-folder)"
einfo "yarn offline-cache-mirror:\t$(yarn config get offline-cache-mirror)"
einfo

		local extra_args=()
		if [[ "${ELECTRON_APP_LOCKFILE_EXACT_VERSIONS_ONLY}" == "1" ]] ; then
ewarn
ewarn "Using exact versions in lockfile."
ewarn "This implies that security updates are NOT performed."
ewarn
			extra_args+=( --frozen-lockfile )
		fi

		yarn install \
			--network-concurrency ${ELECTRON_APP_MAXSOCKETS} \
			--verbose \
			${extra_args[@]} \
			|| die
		# todo yarn audit auto patch
		# an analog to yarn audix fix doesn't exit yet
	popd
}

# @FUNCTION: electron-app_fetch_deps
# @DESCRIPTION:
# Fetches an electron app with security checks
# MUST be called after default unpack AND patching.
electron-app_fetch_deps() {
	cd "${S}"

	# todo handle yarn
	case "$ELECTRON_APP_MODE" in
		npm)
			electron-app_fetch_deps_npm
			;;
		yarn)
			electron-app_fetch_deps_yarn
			;;
		*)
eerror
eerror "Unsupported package system"
eerror
			die
			;;
	esac
}

_query_lite_json() {
	echo $(cat "${ELECTRON_APP_VERSION_DATA_PATH}" \
		| jq '.[] | select(.tag_name == "v'${ELECTRON_PV}'")' \
		| jq ${1} \
		| sed -r -e "s|[\"]*||g")
}

# @FUNCTION: adie
# @DESCRIPTION:
# Print warnings for audits or die depending on ELECTRON_APP_NO_DIE_ON_AUDIT
adie() {
	if [[ "${ELECTRON_APP_NO_DIE_ON_AUDIT}" == "1" ]] ; then
ewarn
ewarn "${1}"
ewarn
	else
eerror
eerror "${1}"
eerror
eerror "Set ELECTRON_APP_NO_DIE_ON_AUDIT=1 to continue"
eerror
		die
	fi
}

# @FUNCTION: electron-app_audit_versions
# @DESCRIPTION:
# Audits json logs for vulnerable versions and min requirements
electron-app_audit_versions() {
einfo
einfo "Inspecting package versions for vulnerabilities and minimum version"
einfo "requirements"
einfo

	if [[ "${ELECTRON_APP_USED_AS_WEB_BROWSER_OR_SOCIAL_MEDIA_APP}" == "1" ]] ; then
ewarn
ewarn "It's strongly recommended re-emerge the app weekly to mitigate against"
ewarn "critical vulnerabilities in the internal Chromium."
ewarn
	fi

	local ELECTRON_PV
	local ELECTRON_PV_
	if npm ls electron | grep -q -F -e " electron@" ; then
		# case when ^ or latest used
		ELECTRON_PV=$(npm ls electron \
			| grep -E -e "electron@[0-9.]+" \
			| tail -n 1 \
			| grep -E -o -e "[0-9\.a-z-]*" \
			| tail -n 1) # used by package and json search
		ELECTRON_PV_=${ELECTRON_PV}
		ELECTRON_PV_=${ELECTRON_PV_/-/_}
		ELECTRON_PV_=${ELECTRON_PV_/alpha./alpha}
		ELECTRON_PV_=${ELECTRON_PV_/beta./beta}
		ELECTRON_PV_=${ELECTRON_PV_/nightly./pre} # sanitize for ver_test
	elif [[ -n "${ELECTRON_APP_ELECTRON_PV}" ]] ; then
		# fallback based on analysis on package.json
		ELECTRON_PV=${ELECTRON_APP_ELECTRON_PV} # for json search
		ELECTRON_PV_=${ELECTRON_APP_ELECTRON_PV}
		ELECTRON_PV_=${ELECTRON_PV_/-/_}
		ELECTRON_PV_=${ELECTRON_PV_/alpha./alpha}
		ELECTRON_PV_=${ELECTRON_PV_/beta./beta}
		ELECTRON_PV_=${ELECTRON_PV_/nightly./pre} # sanitize for ver_test
	else
		# Skip for dependency but not building ui yet
		return
	fi
	# BORINGSSL_PV=$(_query_lite_json '.deps.openssl')
	CHROMIUM_PV=$(_query_lite_json '.deps.chrome')
	LIBUV_PV=$(_query_lite_json '.deps.uv')
	NODE_PV=$(_query_lite_json '.deps.node')
	V8_PV=$(_query_lite_json '.deps.v8')
	ZLIB_PV=$(_query_lite_json '.deps.zlib')



	# ##### Compatibity Tests ##############################################


	if ! has_version ">=dev-libs/libuv-${LIBUV_PV}" ; then
		adie \
"Electron ${ELECTRON_PV} requires at least >=dev-libs/libuv-${LIBUV_PV} libuv"
	fi
	# It's actually BoringSSL not OpenSSL in Chromium.
	# Commented out because Chromium checks
	if ! has_version ">=net-libs/nodejs-${NODE_PV}" ; then
ewarn
ewarn "Electron ${ELECTRON_PV} requires at least >=net-libs/nodejs-${NODE_PV}"
ewarn
	fi
	if ! has_version ">=sys-libs/zlib-${ZLIB_PV%-*}" ; then
		adie \
"Electron ${ELECTRON_PV} requires at least >=sys-libs/zlib-${ZLIB_PV%-*}"
	fi

	# ##### EOL Tests ######################################################

	npm-utils_check_chromium_eol ${CHROMIUM_PV}

	# ##### EOL Tests ######################################################

einfo
einfo "Electron version report with internal/external dependencies:"
einfo
einfo "ELECTRON_PV:\t\t${ELECTRON_PV}"
einfo "CHROMIUM_PV:\t\t${CHROMIUM_PV} (internal)"
einfo "LIBUV_PV:\t\t${LIBUV_PV}"
einfo "NODE_PV:\t\t${NODE_PV} (internal)"
einfo "V8_PV:\t\t${V8_PV} (internal)"
einfo "ZLIB_PV:\t\t${ZLIB_PV} (external)"

	local node_pv=$(node --version | sed -e "s|v||")
	if ver_test $(ver_cut 1 ${NODE_PV}) -ne $(ver_cut 1 ${node_pv}) ; then
ewarn
ewarn "Detected a version mismatch between the node version bundled with"
ewarn "Electron (NODE_PV=${NODE_PV}) and the current active node version"
ewarn "(node_pv=${node_pv}).  Build failures may occur if deviation is too"
ewarn "much."
ewarn
	fi
}

# @FUNCTION: electron-app_find_analytics
# @DESCRIPTION:
# Inspect and block apps that may spy on users without consent or no opt-out.
electron-app_find_analytics() {
	[[ "${ELECTRON_APP_ANALYTICS}" =~ ("allow"|"accept") ]] && return
	local path

	IFS=$'\n'
	local L=(
		$(find "${WORKDIR}" \
			-name "package.json" \
			-o -name "package.json" \
			-o -name "package-lock.json" \
			-o -name "yarn.lock")
	)

	local analytics_packages=(
		"/analytics"
		"-analytics"
	)

einfo
einfo "Scanning for analytics packages."
einfo
	for path in ${L[@]} ; do
		local ap
		for ap in ${analytics_packages[@]} ; do
			if grep -q -e "${ap}" "${path}" ; then
eerror
eerror "An analytics package has been detected in ${PN} that may track user"
eerror "behavior.  Often times, this kind of collection is unannounced in"
eerror "in READMEs and many times no way to opt out."
eerror
eerror "ELECTRON_APP_ANALYTICS=\"allow\"  # to continue installing"
eerror "ELECTRON_APP_ANALYTICS=\"deny\"   # to stop installing (default)"
eerror
eerror "You should only apply these rules as a per-package environment"
eerror "variable."
eerror
				die
			fi
		done

	done
	IFS=$' \t\n'
}

# @FUNCTION: electron-app_find_session_replay
# @DESCRIPTION:
# Inspect and block apps that may spy on users without consent or no opt-out.
electron-app_find_session_replay() {
	[[ "${ELECTRON_APP_SESSION_REPLAY}" =~ ("allow"|"accept") ]] && return
	local path

	IFS=$'\n'
	local L=(
		$(find "${WORKDIR}" \
			-name "package.json" \
			-o -name "package.json" \
			-o -name "package-lock.json" \
			-o -name "yarn.lock")
	)

	local session_replay_packages=(
		"ffmpeg" # may access system ffmpeg with x11grab
		"ffmpeg-screen-recorder" # tagged x11grab
		"puppeteer-stream" # tagged x11grab
		"record-screen" # tagged x11grab
		"rrweb"
		"recorder"
		"screencast"
		"woobi" # tagged x11grab

		# User can define this globally in /etc/make.conf.
		# It must be a space delimited string.
		${ELECTRON_APP_SESSION_REPLAY_BLACKLIST}
	)

einfo
einfo "Scanning for session replay packages or recording packages."
einfo "(NOTE:  It is impossible to find all packages.)"
einfo
	for path in ${L[@]} ; do
		local ap
		for ap in ${session_replay_packages[@]} ; do
			if grep -q -e "${ap}" "${path}" ; then
eerror
eerror "A possible session replay or recording package has been detected in"
eerror "${PN} that may record user behavior or sensitive data with greater"
eerror "specificity which can be abused or compromise anonymity."
eerror
eerror "Build file:  ${path}"
eerror "Package:"
grep "${ap}" "${path}"
eerror
eerror
eerror "ELECTRON_APP_SESSION_REPLAY=\"allow\"  # to continue installing"
eerror "ELECTRON_APP_SESSION_REPLAY=\"deny\"   # to stop installing (default)"
eerror
eerror "You should only apply these rules as a per-package environment"
eerror "variable."
eerror
				die
			fi
		done

	done
	IFS=$' \t\n'
}

# @FUNCTION: electron-app_find_session_replay_within_source_code
# @DESCRIPTION:
# Check abuse with exec/spawn
electron-app_find_session_replay_within_source_code() {
	[[ "${ELECTRON_APP_SESSION_REPLAY}" =~ ("allow"|"accept") ]] && return
einfo
einfo "Scanning for possible [unauthorized] recording within code."
einfo "(NOTE:  It is impossible to scan all obfuscated code.)"
einfo
	IFS=$'\n'
	local path
	for path in $(find "${WORKDIR}" -type f) ; do
		if grep -E -r -e "(x11grab|screen://)" "${path}" ; then
eerror
eerror "Possible unauthorized screen recording has been detected in"
eerror "${PN} that may record user behavior or sensitive data with greater"
eerror "specificity which can be abused or compromise anonymity."
eerror
eerror "File:  ${path}"
eerror
eerror "ELECTRON_APP_SESSION_REPLAY=\"allow\"  # to continue installing"
eerror "ELECTRON_APP_SESSION_REPLAY=\"deny\"   # to stop installing (default)"
eerror
eerror "You should only apply these rules as a per-package environment"
eerror "variable."
eerror
			die
		fi
	done
	IFS=$' \t\n'
}

# @FUNCTION: electron-app_src_unpack
# @DESCRIPTION:
# Runs phases for downloading dependencies, unpacking, building
electron-app_src_unpack() {
        debug-print-function ${FUNCNAME} "${@}"

	if [[ -n "${NODE_VERSION}" ]] ; then
		local node_header_pv=$(grep \
			"NODE_MAJOR_VERSION" \
			"${ESYSROOT}/usr/include/node/node_version.h" \
			| head -n 1 \
			| cut -f 3 -d " ")
		if ver_test \
			$(ver_cut 1 ${node_header_pv}) \
			-ne \
			$(ver_cut 1 ${NODE_VERSION}) ; then
eerror
eerror "Node header version:\t\t${node_header_pv}"
eerror "Ebuild selected version:\t${NODE_VERSION}"
eerror
eerror "Switch the headers to ${NODE_VERSION}."
eerror "Did you perform \`eselect nodejs set node${NODE_VERSION}\`"
eerror
			die
		fi
	fi

	cd "${WORKDIR}"

	if [[ ! -d "${S}" ]] ; then
		default_src_unpack
	fi

	# All the phase hooks get run in unpack because of download restrictions

	cd "${S}"
	if declare -f electron-app_src_preprepare > /dev/null ; then
		electron-app_src_preprepare
	fi

	# Inspect before downloading
	electron-app_audit_versions
	electron-app_find_analytics
	electron-app_find_session_replay
	electron-app_find_session_replay_within_source_code

	cd "${S}"
	if declare -f electron-app_src_prepare > /dev/null ; then
		electron-app_src_prepare
	else
		electron-app_src_prepare_default
	fi

	cd "${S}"
	electron-app_audit_fix

	cd "${S}"
	if declare -f electron-app_src_postprepare > /dev/null ; then
		electron-app_src_postprepare
	fi


	cd "${S}"
	if declare -f electron-app_src_compile > /dev/null ; then
		electron-app_src_compile
	else
		electron-app_src_compile_default
	fi

	cd "${S}"
	if declare -f electron-app_src_postcompile > /dev/null ; then
		electron-app_src_postcompile
	fi

	if grep -q -e "Exit code:" "${T}/build.log" ; then
eerror
eerror "Detected failure.  Re-emerge..."
eerror
		die
	fi

	cd "${S}"
	# Another audit happens because electron-builder downloads again
	# possibly vulnerable libraries.
	electron-app_audit_versions
	electron-app_find_analytics
	electron-app_find_session_replay
	electron-app_find_session_replay_within_source_code

	cd "${S}"
	if declare -f electron-app_src_preinst > /dev/null ; then
		electron-app_src_preinst
	else
		electron-app_src_preinst_default
	fi
}

# @FUNCTION: electron-app_src_prepare_default
# @DESCRIPTION:
# Fetches dependencies and audit fixes them.  Currently a stub.
# TODO per package patching support.
electron-app_src_prepare_default() {
        debug-print-function ${FUNCNAME} "${@}"

	cd "${S}"
	electron-app_fetch_deps
	cd "${S}"
	#default_src_prepare
}

# @FUNCTION: electron-app_install_default
# @DESCRIPTION:
# Installs the app.  Currently a stub.
electron-app_src_install_default() {
        debug-print-function ${FUNCNAME} "${@}"

	cd "${S}"

eerror
eerror "electron-app_src_install_default is currently unimplemented.  You must"
eerror "use an override."
eerror
	die
# todo electron-app_src_install_default
}

# @FUNCTION: electron-app-build-npm
# @DESCRIPTION:
# Builds an electron app with npm
electron-app-build-npm() {
	# electron-builder can still pull packages at the build step.
	npm run build || die
}

# @FUNCTION: electron-app-build-yarn
# @DESCRIPTION:
# Builds an electron app with yarn
electron-app-build-yarn() {
	yarn run build || die
}

# @FUNCTION: electron-app_src_compile_default
# @DESCRIPTION:
# Builds an electron app.
electron-app_src_compile_default() {
        debug-print-function ${FUNCNAME} "${@}"

	cd "${S}"

	case "$ELECTRON_APP_MODE" in
		npm)
			electron-app-build-npm
			;;
		yarn)
			electron-app-build-yarn
			;;
		*)
eerror
eerror "Unsupported package system"
eerror
			die
			;;
	esac
}


# @FUNCTION: electron-app_src_preinst_default
# @DESCRIPTION:
# Dummy function
electron-app_src_preinst_default() {
	:;
}

# @FUNCTION: electron-app_desktop_install_program_raw
# @DESCRIPTION:
# Installs program only without resetting permissions or owner.
# Use electron-app_desktop_install_program instead.
electron-app_desktop_install_program_raw() {
	use unpacked || return
	_electron-app_check_missing_install_path
	local rel_src_path="$1"
	local d="${ELECTRON_APP_INSTALL_PATH}"
	local ed="${ED}/${d}"
	case "$ELECTRON_APP_MODE" in
		npm|yarn)
			local old_dotglob=$(shopt dotglob | cut -f 2)
			shopt -s dotglob # copy hidden files

			mkdir -p "${ed}" || die
			cp -a ${rel_src_path} "${ed}" || die

			if [[ "${old_dotglob}" == "on" ]] ; then
				shopt -s dotglob
			else
				shopt -u dotglob
			fi
			;;
		*)
eerror
eerror "Unsupported package system"
eerror
			die
			;;
	esac
}

# @FUNCTION: electron-app_desktop_install_program
# @DESCRIPTION:
# Installs program only.  Resets permissions and ownership.  Additional change
# of ownership and permissions should be done after running this.
electron-app_desktop_install_program() {
	use unpacked || return
	_electron-app_check_missing_install_path
	local rel_src_path="$1"
	local d="${ELECTRON_APP_INSTALL_PATH}"
	local ed="${ED}/${d}"
	case "$ELECTRON_APP_MODE" in
		npm|yarn)
			local old_dotglob=$(shopt dotglob | cut -f 2)
			shopt -s dotglob # copy hidden files

			insinto "${d}"
			doins -r ${rel_src_path}

			for f in $(find "${ed}" -type f) ; do
				if file "${f}" | grep -q "executable" ; then
					chmod 0755 $(realpath "${f}") || die
				elif file "${f}" | grep -q "shared object" ; then
					chmod 0755 $(realpath "${f}") || die
				fi
			done

			if [[ "${old_dotglob}" == "on" ]] ; then
				shopt -s dotglob
			else
				shopt -u dotglob
			fi
			;;
		*)
eerror
eerror "Unsupported package system"
eerror
			die
			;;
	esac
}

# @FUNCTION: _electron-app_check_missing_install_path
# @DESCRIPTION:
# Checks to see if ELECTRON_APP_INSTALL_PATH has been defined.
_electron-app_check_missing_install_path() {
	if [[ -z "${ELECTRON_APP_INSTALL_PATH}" ]] ; then
eerror
eerror "You must specify ELECTRON_APP_INSTALL_PATH.  Usually same location as"
eerror "/usr/\$(get_libdir)/node/\${PN}/\${SLOT} without \$ED"
eerror
		die
	fi
}

# @FUNCTION: electron-app_desktop_install
# @DESCRIPTION:
# Installs a desktop app with wrapper and desktop menu entry.
electron-app_desktop_install() {
	local rel_src_path="$1"
	local rel_icon_path="$2"
	local pkg_name="$3"
	local category="$4"
	local cmd="$5"

	if [[ -z "${rel_icon_path}" ]] ; then
eerror
eerror "You must provide 2nd arg to electron-app_desktop_install containing the"
eerror "relative icon path"
eerror
		die
	fi

	if [[ -z "${cmd}" ]] ; then
eerror
eerror "You must provide 5th arg to electron-app_desktop_install containing the"
eerror "command to execute in the wrapper script"
eerror
		die
	fi

	if use unpacked ; then
		electron-app_desktop_install_program "${rel_src_path}"
		# Create wrapper
		exeinto "/usr/bin"
		echo "#!/bin/bash" > "${T}/${PN}"
		if [[ -n "${NODE_VERSION}" ]] ; then
einfo "Setting NODE_VERSION=${NODE_VERSION} in wrapper."
			echo "export NODE_VERSION=${NODE_VERSION}" >> "${T}/${PN}"
		fi
		if [[ "${NODE_ENV}" == "production" ]] ; then
einfo "Setting NODE_ENV=\${NODE_ENV:-production} in wrapper."
			echo "export NODE_ENV=\${NODE_ENV:-production}" >> "${T}/${PN}"
		else
einfo "Setting NODE_ENV=\${NODE_ENV:-development} in wrapper."
			echo "export NODE_ENV=\${NODE_ENV:-development}" >> "${T}/${PN}"
		fi
		echo "${cmd} \"\${@}\"" >> "${T}/${PN}"
		doexe "${T}/${PN}"

		local icon=""
		local mime_type=$(file --mime-type $(realpath "./${rel_icon_path}"))
		if echo "${mime_type}" | grep -q -F -e "image/png" ; then
			icon="${PN}"
			newicon "${rel_icon_path}" "${icon}.png"
		elif echo "${mime_type}" | grep -q -F -e "image/svg" ; then
			icon="${PN}"
			newicon "${rel_icon_path}" "${icon}.svg"
		elif echo "${mime_type}" | grep -q -F -e "image/x-xpmi" ; then
			icon="${PN}"
			newicon "${rel_icon_path}" "${icon}.xpm"
		else
# See https://specifications.freedesktop.org/icon-theme-spec/icon-theme-spec-latest.html
ewarn
ewarn "Only png, svg, xpm accepted as icons for the XDG desktop icon theme"
ewarn "spec.  Skipping."
ewarn
		fi
	fi
	if has appimage ${IUSE_EFFECTIVE} ; then
		if use appimage ; then
			exeinto "${ELECTRON_APP_APPIMAGE_INSTALL_DIR}"
			doexe "${ELECTRON_APP_APPIMAGE_PATH}"
		fi
	fi
	if has snap ${IUSE_EFFECTIVE} ; then
		if use snap ; then
			insinto "${ELECTRON_APP_SNAP_INSTALL_DIR}"
			doins "${ELECTRON_APP_SNAP_PATH}"
			if [[ -e "${ELECTRON_APP_SNAP_ASSERT_PATH}" ]] ; then
				doins "${ELECTRON_APP_SNAP_ASSERT_PATH}"
			fi
		fi
	fi

	make_desktop_entry "${PN}" "${pkg_name}" "${icon}" "${category}"
}

electron-app_pkg_preinst() {
        debug-print-function ${FUNCNAME} "${@}"
	if has snap ${IUSE_EFFECTIVE} ; then
		if use snap ; then
			# Remove previous install
			local revision_arg
			if [[ -n "${ELECTRON_APP_SNAP_REVISION}" ]] ; then
				revision_arg="--revision=${ELECTRON_APP_SNAP_REVISION}"
			fi
			if snap info "${ELECTRON_APP_SNAP_NAME}" \
				2>/dev/null 1>/dev/null ; then
				snap remove \
					${ELECTRON_APP_SNAP_NAME} \
					${ELECTRON_APP_SNAP_REVISION} --purge \
					|| die
			fi
		fi
	fi
}

# @FUNCTION: electron-app_pkg_postinst
# @DESCRIPTION:
# Performs post-merge actions
electron-app_pkg_postinst() {
        debug-print-function ${FUNCNAME} "${@}"

	if has snap ${IUSE_EFFECTIVE} ; then
		if use snap ; then
ewarn
ewarn "snap support is untested"
ewarn
ewarn "Remember do not update the snap manually through the \`snap\` tool."
ewarn "Allow the emerge system to update it."
ewarn
			# I don't know if snap will sanitize the files for
			# system-wide installation.
			local has_assertion_file="--dangerous"
			if [[ -e "${ELECTRON_APP_SNAP_ASSERT_PATH}" ]] ; then
				snap ack \
"${EROOT}/${ELECTRON_APP_SNAP_INSTALL_DIR}/${ELECTRON_APP_SNAP_ASSERT_PATH_BASENAME}"
				has_assertion_file=""
			else
ewarn
ewarn "Missing assertion file for snap.  Installing with --dangerous."
ewarn
			fi
			# This will add the desktop links to the snap.
			snap install ${has_assertion_file} \
"${EROOT}/${ELECTRON_APP_SNAP_INSTALL_DIR}/${ELECTRON_APP_SNAP_PATH_BASENAME}"
		fi
	fi
}

# @FUNCTION: electron-app_get_arch
# @DESCRIPTION: Gets the suffix based on ARCH and possibly CHOST
# This applies to use of electron-packager and electron-builder
electron-app_get_arch() {
	if [[ "${ARCH}" == "amd64" ]] ; then
                echo "x64"
        elif [[ "${ARCH}" == "x86" ]] ; then
                echo "ia32"
        elif [[ "${ARCH}" == "arm64" ]] ; then
                echo "arm64"
        elif [[ "${ARCH}" == "arm" ]] ; then
		if [[ "${CHOST}" =~ armv7* ]] ; then
	                echo "armv7l"
		else
eerror
eerror "${CHOST} is not supported"
eerror
			die
		fi
        elif [[ "${ARCH}" == "n64" ]] ; then
                echo "mips64el"
	else
eerror
eerror "${ARCH} not supported"
eerror
		die
        fi
}

# @FUNCTION: electron-app_get_arch_suffix_snap
# @DESCRIPTION: Gets the arch suffix found at the end of the archive
electron-app_get_arch_suffix_snap() {
	[[ "${ARCH}" == "amd64" ]] && echo "amd64"
	[[ "${ARCH}" == "x86" ]] && echo "i386"
	[[ "${ARCH}" == "arm64" ]] && echo "arm64"
	[[ "${ARCH}" == "arm" && "${CHOST}" =~ armv7* ]] && echo "armhf"
	echo "${CHOST%%-*}"
}

# @FUNCTION: electron-app_get_arch_suffix_appimage
# @DESCRIPTION: Gets the arch suffix found at the end of the archive
electron-app_get_arch_suffix_appimage() {
	[[ "${ARCH}" == "amd64" ]] && echo "x86_64"
	[[ "${ARCH}" == "x86" ]] && echo "i386"
	[[ "${ARCH}" == "arm64" ]] && echo "arm64"
	[[ "${ARCH}" == "arm" && "${CHOST}" =~ armv7* ]] && echo "armhf"
	echo "${CHOST%%-*}"
}

# @FUNCTION: electron-builder_download_electron_builder
# @DESCRIPTION: Downloads and installs electron-builder in the devDependencies
# for packages without an Electron packager.
electron-app_download_electron_builder()
{
	npm_install_dev electron-builder
}

# @FUNCTION: electron-builder_download_electron_packager
# @DESCRIPTION: Downloads and installs electron-packager in the devDependencies
# for packages without an Electron packager.
electron-app_download_electron_packager()
{
	npm_install_dev electron-packager
}


# @FUNCTION: electron-app_src_compile_electron_packager
# @DESCRIPTION: Places all npm production packages in a single exe
# for Electron based ebuild-packages.
# For non-electron packages use pkg (via npm-utils_src_compile_pkg) instead.
#
# Assumes current dir will be packaged.
#
# Current support is tentative based on security requirements like with the
# npm-utils_src_compile_pkg.  Check back on this eclass for update details.
#
# Consumers are required to add to RDEPEND either:
#
# virtual/electron-builder:10=
# virtual/electron-builder:11=
# virtual/electron-builder:12=
#
# corresponding to the current Electron LTS versions to ensure
# that Electron + Chromium security updates are being passed down since
# the packer embeds Electron & Chromium parts.
#
# myelectronpackager args can be defined and appended to the defaults.
#
# Preference for electron-packager or electron-builder is based on the
# contents of package.json, but electron-builder is preferred for
# future sandboxing with AppImage & Snap.
#
# Exe will be placed in dist/${exe_name}-linux-"$(electron-app_get_arch)"/*
#
# @CODE
# Parameters:
# $1 - executable name
# $2 - icon path optional
# @CODE
electron-app_src_compile_electron_packager()
{
	local exe_name="${1}"
	local icon_path="${2}"
	mkdir -p dist || die
	# Make into exe.  Disabled because it works sometimes but not all the time.

	local myelectronpackager_

	if [[ -n "${icon_path}" ]] ; then
		myelectronpackager_=( --icon=${icon_path} )
	fi

	electron-packager . ${exe_name} \
		--platform=linux \
		--arch=$(electron-app_get_arch) \
		--asar \
		--out=dist \
		--overwrite \
		${myelectronpackager[@]} \
		${myelectronpackager_[@]} \
		|| die
}

# @FUNCTION: electron-app_src_compile_electron_builder
# @DESCRIPTION: Places all npm production packages in a single exe
# for Electron based ebuild-packages.
# For non-electron packages use pkg (via npm-utils_src_compile_pkg) instead.
#
# Current support is tentative based on security requirements like with the
# npm-utils_src_compile_pkg.  Check back on this eclass for update details.
#
# Consumers are required to add to RDEPEND either:
#
# virtual/electron-builder:10=
# virtual/electron-builder:11=
# virtual/electron-builder:12=
#
# corresponding to the current Electron LTS versions to ensure
# that Electron + Chromium security updates are being passed down since
# the packer embeds Electron & Chromium parts.
#
# myelectronbuilder args can be defined and appended to the defaults.
#
# Preference for electron-packager or electron-builder is based on the
# contents of package.json, but electron-builder is preferred for
# future sandboxing with AppImage & Snap.
#
# The contents are usually placed in dist/
#
# @CODE
# Parameters:
# $1 - executable name
# @CODE
electron-app_src_compile_electron_builder()
{
	local myelectronbuilder_
	if [[ -z "${myelectronbuilder}" ]] ; then
		myelectronbuilder_=( --dir )
	fi

	electron-builder -l \
		${myelectronbuilder[@]} \
		${myelectronbuilder_[@]} \
		|| die
}

# @FUNCTION: electron-app_get_node_version
# @DESCRIPTION: Gets the minimum node version required with an Electron release
#
# The versions reported by lite.json are newer and differ from the DEPS file
# in tagged.
#
# @CODE
# Parameters:
# $1 - nodejs version
# @CODE
electron-app_get_node_version()
{
	local node_version="${1}"
	wget -O "${T}/DEPS" \
"https://raw.githubusercontent.com/electron/electron/v${node_version}/DEPS" || die
	if ver_test ${node_version} -ge 6.0 ; then
		echo $(cat "${T}/DEPS" | tr "\r\n" "\n" \
			| sed -e "s| = |=|g" \
			| sed "/#/d" \
			| pcregrep -M "vars=[^=]+" \
			| head -n -1 \
			| sed -e "s|'|\"|g" -e "s|vars=||"  -e "s|True|1|" -e "s|False|0|" \
			| sed -e ':a;N;$!ba' -e "s|,\n\}|\n}|" \
			| jq ".node_version" \
			| sed -e "s|\"||g" -e "s|v||")
	else
		local commit=$(cat "${T}/DEPS" | tr "\r\n" "\n" \
			| sed -e "s| = |=|g" \
			| sed "/#/d" \
			| pcregrep -M "vars=[^=]+" \
			| head -n -1 \
			| sed -e "s|'|\"|g" -e "s|vars=||"  -e "s|True|1|" -e "s|False|0|" \
			| sed -e ':a;N;$!ba' -e "s|,\n\}|\n}|" \
			| jq ".node_version" \
			| sed -e "s|\"||g")
		wget -O "${T}/node_version.h" \
"https://raw.githubusercontent.com/electron/node/${commit}/src/node_version.h" || die
		local node_version_major=$(grep -r -e "NODE_MAJOR_VERSION" \
			"${T}/node_version.h" | head -n 1 | cut -f 3 -d " ")
		local node_version_minor=$(grep -r -e "NODE_MINOR_VERSION" \
			"${T}/node_version.h" | head -n 1 | cut -f 3 -d " ")
		local node_version_patch=$(grep -r -e "NODE_PATCH_VERSION" \
			"${T}/node_version.h" | head -n 1 | cut -f 3 -d " ")
		echo "${node_version_major}.${node_version_minor}.${node_version_patch}"
	fi
}
