# Copyright 2019-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
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

# D11, U20, U22, U24

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

inherit chromium-2 desktop linux-info

#
# Hidden Rust dependency:
#
# If the lockfile contains reference to @swc/core specifically
#
#   @swc/core-linux-arm-gnueabihf
#   @swc/core-linux-arm64-gnu
#   @swc/core-linux-arm64-musl
#   @swc/core-linux-x64-gnu
#   @swc/core-linux-x64-musl
#   or similar,
#
# Rust BDEPEND and Rust path preappend should be added.  See the
# dev-util/jsonlint package for details.
#
# Use github search with commiter-date:YYYY-MM-DD to search for an
# approximation.
#
# Dependency graph:  Next.js -> @swc/core -> Rust
#

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
# Update every two months.  Next bump is Jun.
ELECTRON_APP_ELECTRON_PV_SUPPORTED="29.0" # Minimum version

ELECTRON_APP_MODE=${ELECTRON_APP_MODE:-"npm"} # can be npm, yarn
ELECTRON_APP_ECLASS_DEBUG=${ELECTRON_APP_ECLASS_DEBUG:-"debug"} # debug or production

# User generated content (images, audio, models, files)
ELECTRON_APP_USES_UGC_FILES=${ELECTRON_APP_USES_UGC_FILES:-"0"}

# User generated content (text, forums, javascript, email)
ELECTRON_APP_USES_UGC_TEXT=${ELECTRON_APP_USES_UGC_TEXT:-"0"}

# If application parses user generated content file with JavaScript, then check it.
# ID = Information Disclosure
ELECTRON_APP_REQUIRES_MITIGATE_ID_CHECK=${ELECTRON_APP_REQUIRES_MITIGATE_ID_CHECK:-"0"}

# Use the following example to extract the license.
# unzip -p /var/cache/distfiles/electron-v41.0.3-linux-x64.zip LICENSES.chromium.html > electron-41.0.3-chromium.html

# For Electron 18.2.2 from electron-builder
# See comments below for details.
ELECTRON_APP_LICENSES="
	(
		all-rights-reserved
		HPND
	)
	(
		all-rights-reserved
		custom
		ISC
	)
	(
		LGPL-2.1
		LGPL-2.1+
	)
	(
		GPL-2
		MPL-1.1
	)
	android
	Apache-2.0
	Apache-2.0-with-LLVM-exceptions
	AFL-2.0
	APSL-2
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
	custom
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
	libwebm-PATENTS
	neon_2_sse
	NEWLIB
	MPL-1.1
	MPL-2.0
	Ms-PL
	minpack
	OFL-1.1
	openssl
	ooura
	Prior-BSD-License
	SunPro
	unicode
	Unicode-DFS-2016
	unRAR
	UoI-NCSA
	ZLIB
	|| (
		(
			GPL-2+
			MPL-2.0
		)
		(
			LGPL-2.1+
			MPL-2.0
		)
		GPL-2.0+
		MPL-2.0
	)
	|| (
		(
			MIT
			public-domain
		)
		MIT
		public-domain
	)
	|| (
		LGPL-2.1+
		GPL-2+
		MPL-1.1
	)
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
	|| (
		wayland
		X
	)
"

ELECTRON_APP_IUSE_OPTIONAL=" "
ELECTRON_APP_OPTIONAL_DEPEND=" "
ELECTRON_APP_CR_OPTIONAL_DEPEND=" "
if [[ "${ELECTRON_APP_FEATURE_APPINDICATOR}" == "1" ]] ; then
	ELECTRON_APP_IUSE_OPTIONAL+=" app-indicator"
	ELECTRON_APP_OPTIONAL_DEPEND+="
		app-indicator? (
			dev-libs/libappindicator:3
		)
	"
fi

if [[ "${ELECTRON_APP_FEATURE_GLOBAL_MENU_BAR}" == "1" ]] ; then
	ELECTRON_APP_IUSE_OPTIONAL+=" global-menu-bar"
	ELECTRON_APP_OPTIONAL_DEPEND+="
		global-menu-bar? (
			dev-libs/libdbusmenu
		)
	"
fi

if [[ "${ELECTRON_APP_FEATURE_GNOME_KEYRING}" == "1" ]] ; then
	ELECTRON_APP_IUSE_OPTIONAL+=" gnome-keyring"
	ELECTRON_APP_CR_OPTIONAL_DEPEND+="
		gnome-keyring? (
			gnome-base/gnome-keyring[pam]
		)
	"
fi

if [[ "${ELECTRON_APP_FEATURE_LIBSECRET}" == "1" ]] ; then
	ELECTRON_APP_IUSE_OPTIONAL+=" libsecret"
	ELECTRON_APP_CR_OPTIONAL_DEPEND+="
		libsecret? (
			app-crypt/libsecret
		)
	"
fi

if [[ "${ELECTRON_APP_FEATURE_PULSEAUDIO}" == "1" ]] ; then
	ELECTRON_APP_IUSE_OPTIONAL+=" pulseaudio"
	ELECTRON_APP_CR_OPTIONAL_DEPEND+="
		pulseaudio? (
			media-sound/pulseaudio
		)
	"
fi

if [[ "${ELECTRON_APP_FEATURE_UNITY}" == "1" ]] ; then
	ELECTRON_APP_IUSE_OPTIONAL+=" unity"
	ELECTRON_APP_OPTIONAL_DEPEND+="
		unity? (
			dev-libs/libunity
		)
	"
fi

# Add if the app uses video or jpeg images
if [[ "${ELECTRON_APP_FEATURE_VAAPI}" == "1" ]] ; then
	ELECTRON_APP_IUSE_OPTIONAL+=" vaapi"
	ELECTRON_APP_OPTIONAL_DEPEND+="
		vaapi? (
			media-libs/libva[drm(+),X?,wayland?]
			media-libs/vaapi-drivers
		)
	"
fi

#IUSE+=" ${ELECTRON_APP_IUSE_OPTIONAL}"

# See https://www.electronjs.org/docs/tutorial/support#linux for OS min requirements.

# For dependencies, see also
# https://github.com/chromium/chromium/blob/145.0.7632.160/build/install-build-deps.py

# Found in Chromium only
# For optional fonts, see
# https://github.com/chromium/chromium/blob/master/build/linux/install-chromeos-fonts.py
#  For specific versions associated with Chromium release, see as base address
#  https://github.com/chromium/chromium/tree/145.0.7632.160/
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
# Use readelf -d <path> | grep 'NEEDED' instead of ldd to obtain list.
# Place refrences in *.node files in ebuilds instead of eclass unless it is used widely.
# TODO review ELECTRON_APP_OPTIONAL_DEPEND, CHROMIUM_DEPEND:
COMMON_DEPEND="
	app-accessibility/at-spi2-core:2
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/mesa[egl(+),gbm(+)]
	net-print/cups
	sys-apps/dbus
	sys-devel/gcc[cxx(+)]
	sys-libs/glibc
	virtual/ttf-fonts
	virtual/udev
	x11-libs/cairo
	x11-libs/gtk+:3[wayland?,X?]
	x11-libs/pango
	wayland? (
		dev-libs/wayland
	)
	X? (
		x11-libs/libX11
		x11-libs/libxcb
		x11-libs/libXcomposite
		x11-libs/libXdamage
		x11-libs/libXext
		x11-libs/libXfixes
		x11-libs/libxkbcommon
		x11-libs/libXrandr
	)
"

if [[ -n "${ELECTRON_APP_ELECTRON_PV}" ]] \
	&& \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ELECTRON_PV}") \
			-ge \
		"${ELECTRON_APP_ELECTRON_PV_SUPPORTED}" \
; then
	: # E20, E21, E22, E23 supported upstream
else
	if [[ "${ELECTRON_APP_ALLOW_NON_LTS_ELECTRON}" == "0" ]] ; then
eerror
eerror "Found:  ${ELECTRON_APP_ELECTRON_PV}"
eerror "Supported:  >=${ELECTRON_APP_ELECTRON_PV_SUPPORTED}"
eerror
eerror "Electron should be updated to one of the latest Long Term Support (LTS)"
eerror "series versions or else it likely contains critical CVE security"
eerror "advisories."
eerror
	fi
fi

# See https://github.com/angular/angular/blob/4.0.x/package.json
if [[ -n "${ELECTRON_APP_ANGULAR_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_PV}") -ge "2.0" \
	&& \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_PV}") -le "2.4" \
) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-5.4.1
		<net-libs/nodejs-7
	"
elif [[ -n "${ELECTRON_APP_ANGULAR_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_PV}") -ge "4.0" \
	&& \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_PV}") -le "4.4" \
) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-6.9.5
		<net-libs/nodejs-7
	"
elif [[ -n "${ELECTRON_APP_ANGULAR_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_PV}") -ge "5.0" \
	&& \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_PV}") -le "6.0" \
) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-8.9.1
		<net-libs/nodejs-9
	"
elif [[ -n "${ELECTRON_APP_ANGULAR_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_PV}") -ge "6.1" \
	&& \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_PV}") -le "8.2" \
) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-10.9.0
		<net-libs/nodejs-11
	"
elif [[ -n "${ELECTRON_APP_ANGULAR_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_PV}") -ge "9.0" \
	&& \
	ver_test $(ver_cut 1   "${ELECTRON_APP_ANGULAR_PV}") -le "11.2.8" \
) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-10.9.0
		<net-libs/nodejs-13
	"
elif [[ -n "${ELECTRON_APP_ANGULAR_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_PV}") -ge "11.2.9" \
	&& \
	ver_test $(ver_cut 1   "${ELECTRON_APP_ANGULAR_PV}") -le "11.2.14" \
) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-10.19.0
		<net-libs/nodejs-16
	"
elif [[ -n "${ELECTRON_APP_ANGULAR_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_PV}") -ge "12.0.0" \
	&& \
	ver_test $(ver_cut 1   "${ELECTRON_APP_ANGULAR_PV}") -le "12.2.11" \
) ; then
	COMMON_DEPEND+="
		|| (
			>=net-libs/nodejs-12.20.0:12
			>=net-libs/nodejs-14:14
		)
	"
elif [[ -n "${ELECTRON_APP_ANGULAR_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_PV}") -ge "13" \
	&& \
	ver_test $(ver_cut 1   "${ELECTRON_APP_ANGULAR_PV}") -lt "14" \
) ; then
	COMMON_DEPEND+="
		|| (
			>=net-libs/nodejs-12.20.0:12
			>=net-libs/nodejs-14.15:14
			>=net-libs/nodejs-16.10.0:16
		)
	"
elif [[ -n "${ELECTRON_APP_ANGULAR_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_PV}") -ge "14" \
	&& \
	ver_test $(ver_cut 1   "${ELECTRON_APP_ANGULAR_PV}") -lt "15" \
) ; then
	COMMON_DEPEND+="
		|| (
			>=net-libs/nodejs-14.15:14
			>=net-libs/nodejs-16.10.0:16
		)
	"
elif [[ -n "${ELECTRON_APP_ANGULAR_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_PV}") -ge "15" \
	&& \
	ver_test $(ver_cut 1   "${ELECTRON_APP_ANGULAR_PV}") -lt "16" \
) ; then
	COMMON_DEPEND+="
		|| (
			>=net-libs/nodejs-14.20:14
			>=net-libs/nodejs-16.13.0:16
			>=net-libs/nodejs-18.10.0:16
		)
	"
elif [[ -n "${ELECTRON_APP_ANGULAR_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_PV}") -ge "16" \
	&& \
	ver_test $(ver_cut 1   "${ELECTRON_APP_ANGULAR_PV}") -le "9999" \
) ; then
	COMMON_DEPEND+="
		|| (
			>=net-libs/nodejs-16.14.0:16
			>=net-libs/nodejs-18.10.0:16
		)
	"
fi

# See https://github.com/facebook/react/blob/master/package.json
if [[ "${ELECTRON_APP_REACT_PV}" == "ignore" ]] ; then
	:
elif [[ -n "${ELECTRON_APP_REACT_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_PV}") -ge "0.3" \
	&& \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_PV}") -le "0.13" \
) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-0.10.0
	"
elif [[ -n "${ELECTRON_APP_REACT_PV}" ]] \
	&& \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_PV}") -eq "0.14" \
; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-4
		<net-libs/nodejs-5
	"
elif [[ -n "${ELECTRON_APP_REACT_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_PV}") -ge "15.0" \
	&& \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_PV}") -le "15.6" \
) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-4
		<net-libs/nodejs-8
	"
elif [[ -n "${ELECTRON_APP_REACT_PV}" ]] \
	&& \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_PV}") -eq "16.3" \
; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-8
		<net-libs/nodejs-11
	"
elif [[ -n "${ELECTRON_APP_REACT_PV}" ]] \
	&& \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_PV}") -eq "16.4" \
; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-8
		<net-libs/nodejs-10
	"
elif [[ -n "${ELECTRON_APP_REACT_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_REACT_PV}") -ge "16.8.3" \
	&& \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_REACT_PV}") -le "16.8.6" \
) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-8
		<net-libs/nodejs-12
	"
elif [[ -n "${ELECTRON_APP_REACT_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_REACT_PV}") -ge "16.13.0" \
	&& \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_REACT_PV}") -le "16.13.1" \
) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-8
		<net-libs/nodejs-14
	"
elif [[ -n "${ELECTRON_APP_REACT_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_REACT_PV}") -ge "16.14.0" \
	&& \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_REACT_PV}") -lt "18" \
) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-8
		<net-libs/nodejs-15
	"
elif [[ -n "${ELECTRON_APP_REACT_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_REACT_PV}") -ge "18" \
	&& \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_REACT_PV}") -lt "18" \
) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-12.17
		<net-libs/nodejs-18
	"
elif [[ -n "${ELECTRON_APP_REACT_PV}" ]] \
	&& \
	ver_test $(ver_cut 1 "${ELECTRON_APP_REACT_PV}") -ge "9999" \
; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-16
		<net-libs/nodejs-21
	"
fi

# See https://github.com/microsoft/TypeScript/blob/v2.0.7/package.json
if [[ -n "${ELECTRON_APP_TYPESCRIPT_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_TYPESCRIPT_PV}") -ge "2.0" \
	&& \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_TYPESCRIPT_PV}") -le "2.1.4" \
) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-0.8.0
	"
elif [[ -n "${ELECTRON_APP_TYPESCRIPT_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_TYPESCRIPT_PV}") -ge "2.1.5" \
	&& \
	ver_test $(ver_cut 1 "${ELECTRON_APP_TYPESCRIPT_PV}")   -lt "5.0.2" \
) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-4.2.0
	"
elif [[ -n "${ELECTRON_APP_TYPESCRIPT_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_TYPESCRIPT_PV}") -ge "5.0.2" \
	&& \
	ver_test $(ver_cut 1 "${ELECTRON_APP_TYPESCRIPT_PV}")   -le "5.0.4" \
) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-12.20
	"
elif [[ -n "${ELECTRON_APP_TYPESCRIPT_PV}" ]] && \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_TYPESCRIPT_PV}") -gt "5.0.4" \
; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-14.17
	"
fi

# See https://github.com/facebook/react-native/blob/0.63-stable/package.json
if [[ -n "${ELECTRON_APP_REACT_NATIVE_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_NATIVE_PV}") -ge "0.13" \
	&& \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_NATIVE_PV}") -le "0.55" \
) ; then
	COMMON_DEPEND+="" # doesn't say
elif [[ -n "${ELECTRON_APP_REACT_NATIVE_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_NATIVE_PV}") -ge "0.13" \
	&& \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_NATIVE_PV}") -le "0.55" \
) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-4
	"
elif [[ -n "${ELECTRON_APP_REACT_NATIVE_PV}" ]] \
	&& \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_NATIVE_PV}") -eq "0.56" \
; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-8
	"
elif [[ -n "${ELECTRON_APP_REACT_NATIVE_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_NATIVE_PV}") -ge "0.57" \
	&& \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_NATIVE_PV}") -le "0.62" \
) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-8.3
	"
elif [[ -n "${ELECTRON_APP_REACT_NATIVE_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_NATIVE_PV}") -ge "0.63" \
	&& \
	ver_test $(ver_cut 1   "${ELECTRON_APP_REACT_NATIVE_PV}") -lt "0.64" \
) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-10
	"
elif [[ -n "${ELECTRON_APP_REACT_NATIVE_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_NATIVE_PV}") -ge "0.64" \
	&& \
	ver_test $(ver_cut 1   "${ELECTRON_APP_REACT_NATIVE_PV}") -le "0.67" ) \
; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-12
	"
elif [[ -n "${ELECTRON_APP_REACT_NATIVE_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_NATIVE_PV}") -ge "0.68" \
	&& \
	ver_test $(ver_cut 1   "${ELECTRON_APP_REACT_NATIVE_PV}") -le "0.71.12" \
) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-14
	"
elif [[ -n "${ELECTRON_APP_REACT_NATIVE_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_NATIVE_PV}") -gt "0.71.12" \
	&& \
	ver_test $(ver_cut 1   "${ELECTRON_APP_REACT_NATIVE_PV}") -le "9999" \
) ; then
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
	&& \
	ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_PV}") -eq "0" \
; then
	COMMON_DEPEND+=" =net-libs/nodejs-0*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_PV}" ]] \
	&& \
	ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_PV}") -eq "4" \
; then
	COMMON_DEPEND+=" =net-libs/nodejs-4*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_PV}" ]] \
	&& \
	ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_PV}") -eq "6" \
; then
	COMMON_DEPEND+=" =net-libs/nodejs-6*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_PV}" ]] \
	&& \
	ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_PV}") -eq "7" \
; then
	COMMON_DEPEND+=" =net-libs/nodejs-7*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_PV}" ]] \
	&& \
	ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_PV}") -eq "8" \
; then
	COMMON_DEPEND+=" =net-libs/nodejs-8*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_PV}" ]] \
	&& \
	ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_PV}") -eq "9" \
; then
	COMMON_DEPEND+=" =net-libs/nodejs-9*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_PV}" ]] \
	&& \
	ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_PV}") -eq "10" \
; then
	COMMON_DEPEND+=" =net-libs/nodejs-10*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_PV}" ]] \
	&& \
	ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_PV}") -eq "11" \
; then
	COMMON_DEPEND+=" =net-libs/nodejs-11*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_PV}" ]] \
	&& \
	ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_PV}") -eq "12" \
; then
	COMMON_DEPEND+=" =net-libs/nodejs-12*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_PV}" ]] \
	&& \
	ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_PV}") -eq "13" \
; then
	COMMON_DEPEND+=" =net-libs/nodejs-13*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_PV}" ]] \
	&& \
	ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_PV}") -eq "14" \
; then
	COMMON_DEPEND+=" =net-libs/nodejs-14*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_PV}" ]] \
	&& \
	ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_PV}") -eq "15" \
; then
	COMMON_DEPEND+=" =net-libs/nodejs-15*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_PV}" ]] \
	&& \
	ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_PV}") -eq "16" \
; then
	COMMON_DEPEND+=" =net-libs/nodejs-16*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_PV}" ]] \
	&& \
	ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_PV}") -eq "17" \
; then
	COMMON_DEPEND+=" =net-libs/nodejs-17*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_PV}" ]] \
	&& \
	ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_PV}") -eq "18" \
; then
	COMMON_DEPEND+=" =net-libs/nodejs-18*"
fi

# https://github.com/vuejs/vue/blob/v2.7.10/package.json
# https://github.com/vuejs/core/blob/v3.3.9/package.json
# Some are based on @types/node
if [[ -n "${ELECTRON_APP_VUE_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -ge "0.6.0" \
	&& \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -le "0.11.10" \
) ; then
	COMMON_DEPEND+=" =net-libs/nodejs-0.10*" # .travis.yml
elif [[ -n "${ELECTRON_APP_VUE_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -ge "0.12.0" \
	&& \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -le "0.12.0" \
) ; then
	COMMON_DEPEND+=" net-libs/iojs" # doesn't say
elif [[ -n "${ELECTRON_APP_VUE_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -ge "0.12.1" \
	&& \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -le "0.12.1" \
) ; then
	COMMON_DEPEND+=" ~net-libs/iojs-2.0.1" # .travis.yml
elif [[ -n "${ELECTRON_APP_VUE_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -ge "0.12.2" \
	&& \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -le "0.12.2" \
) ; then
	COMMON_DEPEND+=" " # doesn't say
elif [[ -n "${ELECTRON_APP_VUE_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -ge "0.12.0" \
	&& \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -le "1.0.8" \
) ; then
	COMMON_DEPEND+=" ~net-libs/iojs-2.0.1" # .travis.yml
elif [[ -n "${ELECTRON_APP_VUE_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -ge "1.0.9" \
	&& \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -le "1.0.17" \
) ; then
	COMMON_DEPEND+=" =net-libs/nodejs-4*" # based on circle.yml
elif [[ -n "${ELECTRON_APP_VUE_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -ge "1.0.18" \
	&& \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -le "1.0.28" \
) ; then
	COMMON_DEPEND+=" =net-libs/nodejs-5*" # based on circle.yml
elif [[ -n "${ELECTRON_APP_VUE_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -ge "2.0.0" \
	&& \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -le "2.4.4" \
) ; then
	COMMON_DEPEND+=" =net-libs/nodejs-6*" # based on circle.yml
elif [[ -n "${ELECTRON_APP_VUE_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -ge "2.5.0" \
	&& \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -le "2.5.22" \
) ; then
	# based on @types/node restriction
	COMMON_DEPEND+=" =net-libs/nodejs-8*" # ^8.0.33 ; they did the testing in node6 in <=2.5.7
elif [[ -n "${ELECTRON_APP_VUE_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -ge "2.6.0" \
	&& \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -le "2.6.10" \
) ; then
	# based on @types/node restriction
	COMMON_DEPEND+=" =net-libs/nodejs-10*" # ^10.12.18
elif [[ -n "${ELECTRON_APP_VUE_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -ge "2.6.11" \
	&& \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -le "2.6.14" \
) ; then
	# based on @types/node restriction
	# dev branch
	COMMON_DEPEND+=" =net-libs/nodejs-12*" # ^12.12.0
elif [[ -n "${ELECTRON_APP_VUE_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -ge "2.7" \
	&& \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -le "2.7.15" \
) ; then
	# based on @types/node restriction
	# dev branch
	COMMON_DEPEND+=" =net-libs/nodejs-17*" # ^17.0.41
elif [[ -n "${ELECTRON_APP_VUE_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -ge "3.0" \
	&& \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -le "3.2.6" \
) ; then
	COMMON_DEPEND+=" >=net-libs/nodejs-10"
elif [[ -n "${ELECTRON_APP_VUE_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -ge "3.2.7" \
	&& \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -le "3.2.37" \
) ; then
	COMMON_DEPEND+=" >=net-libs/nodejs-16.5"
elif [[ -n "${ELECTRON_APP_VUE_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -ge "3.2.38" \
	&& \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -le "3.3.4" \
) ; then
	COMMON_DEPEND+=" >=net-libs/nodejs-16.11"
elif [[ -n "${ELECTRON_APP_VUE_PV}" ]] && \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_PV}") -ge "3.3.5" ; then
	COMMON_DEPEND+=" >=net-libs/nodejs-18.12"
fi

if [[ -n "${ELECTRON_APP_VUE_CORE_PV}" ]] &&
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_CORE_PV}") -eq "3.0.0" \
; then
	COMMON_DEPEND+=" =net-libs/nodejs-10*"
elif [[ -n "${ELECTRON_APP_VUE_CORE_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_CORE_PV}") -ge "3.0.1" \
	&& \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_CORE_PV}") -lt "3.2" \
) ; then
	COMMON_DEPEND+=" =net-libs/nodejs-14*" # ^14.10.1
elif [[ -n "${ELECTRON_APP_VUE_CORE_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_CORE_PV}") -ge "3.2" ) \
; then
	COMMON_DEPEND+=" =net-libs/nodejs-16*" # ^16.4.7
fi

if [[ "${ELECTRON_APP_USES_UGC_TEXT}" == "1" || "${ELECTRON_APP_REQUIRES_MITIGATE_ID_CHECK}" == "1" ]] ; then
	RDEPEND+="
		sys-kernel/mitigate-id
	"
fi

# Same packages as far back as 3.x
RDEPEND+="
	${COMMON_DEPEND}
"
DEPEND+="
	${COMMON_DEPEND}
"

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
	local node_slot=""
	local node_env=""
	if [[ -n "${NODE_SLOT}" ]] ; then
einfo "Setting NODE_SLOT=${NODE_SLOT} in the wrapper script."
		node_slot="NODE_SLOT=${NODE_SLOT}"
	else
	# The oldest supported LTS release is 20
einfo "Assuming NODE_SLOT=${NODE_SLOT} in the wrapper script."
		node_slot="NODE_SLOT=20"
	fi
cat <<EOF > "${T}/${name}" || die
#!/bin/bash
${node_slot}
extra_args=""

# Client side window directions (title bar) issue #29618
[[ \${NODE_SLOT} -ge 18 ]] && extra_args="--enable-features=WaylandWindowDecorations"

if [[ -n \${DISPLAY} ]] ; then
	${cmd} "\${@}"
else
	${cmd} --enable-features=UseOzonePlatform --ozone-platform-hint=wayland \${extra_args} "\${@}"
fi
EOF
	doexe "${T}/${name}"
}

# https://github.com/electron/electron/releases/tag/v21.4.4
# @FUNCTION: electron-app_get_electron_platarch
# @DESCRIPTION:
# Gets the platform and architecture for electron tarballs.
electron-app_get_electron_platarch() {
	if use kernel_linux && [[ "${ARCH}" == "arm64" ]] ; then
		echo "linux-arm64"
	elif use kernel_linux && [[ "${ARCH}" == "arm" ]] ; then
		echo "linux-armv7l"
	elif use kernel_linux && [[ "${ARCH}" == "amd64" ]] ; then
		echo "linux-x64"
	elif use kernel_Darwin && [[ "${ARCH}" == "arm64-macos" ]] ; then
		echo "darwin-arm64"
	elif use kernel_Darwin && [[ "${ARCH}" == "x64-macos" ]] ; then
		echo "darwin-x64"
	fi
}

# Nightlys are not prebuilt.  Use beta instead.

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

#
#                                                                                                    fn
#                                                                      ELECTRON_CUSTOM_DIR            |
#                                                                               |                     |
#                                                                               v                     v
#   ⨯ cannot resolve https://github.com/electron/electron/releases/download/35.0.0-beta.3/electron-v35.0.0-beta.3-linux-x64.zip: status code 404
#
# Prefix with v to look like:
# [build:release     ]   • downloading     url=https://github.com/electron/electron/releases/download/v35.0.0-beta.3/electron-v35.0.0-beta.3-linux-x64.zip size=109 MB parts=8
#
# See also URIs in https://github.com/electron/electron/releases/
#
	export ELECTRON_CUSTOM_DIR=${ELECTRON_CUSTOM_DIR:-"${ELECTRON_APP_ELECTRON_PV}"}

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
	if use kernel_linux && [[ "${ARCH}" == "arm64" ]] ; then
		args+=(
			--arm64
		)
	elif use kernel_linux && [[ "${ARCH}" == "arm" ]] ; then
		args+=(
			--armv7l
		)
	elif use kernel_linux && [[ "${ARCH}" == "amd64" ]] ; then
		args+=(
			--x64
		)
	elif use kernel_Darwin && [[ "${ARCH}" == "arm64-macos" ]] ; then
		args+=(
			--arm64
		)
	elif use kernel_Darwin && [[ "${ARCH}" == "x64-macos" ]] ; then
		args+=(
			--x64
		)
	fi
	echo ${args[@]}
}

# @FUNCTION: electron-app_set_sandbox_suid
# @DESCRIPTION:
# Set the permissions of the chrome-sandbox
electron-app_set_sandbox_suid() {
	local path="${1}"

	if [[ "${ELECTRON_APP_SECCOMP:-1}" == "1" ]] ; then
		fperms u-s "${path}"
	else
		fperms 4711 "${path}"
	fi

	fowners "root:root" "${path}"
}

# @FUNCTION: _electron-app_has_all_hardening_flags
# @DESCRIPTION:
# Check each package individually for compiler hardening requirements.
_electron-app_has_all_hardening_flags() {
	local pkg="${1}"
	local F
	F=(
		"-O2"
		"-fno-delete-null-pointer-checks"
		"-fstrict-flex-arrays=3"
		"-ftrivial-auto-var-init=zero"
		"-fzero-call-used-regs=all"
		"-fwrapv"
	)

	local found_count=0
	local f
	for f in "${F[@]}" ; do
		if grep -q -e "${f}" "/var/db/pkg/${pkg}-"*"/CFLAGS" 2>/dev/null ; then
			found_count=$(( ${found_count} + 1 ))
		fi
	done

	# Transient execution CPU vulnerability mitigations
	# ID = Information Disclosure
	local found_count_id_mitigation=0
	if [[ "${tags}" =~ "sensitive-data" ]] ; then
		F=(
			"-fcf-protection=full"
			"-fhardened"
			"-mbranch-protection=pac-ret+bti"
			"-mbranch-protection=standard"
			"-mharden-sls=all"
			"-mretpoline"
			"-mindirect-branch=thunk"
			"-mindirect-branch=thunk-extern"
			"-mindirect-branch=thunk-inline"
			"-mfunction-return=thunk"
			"-mfunction-return=thunk-extern"
			"-mfunction-return=thunk-inline"
		)
		for f in "${F[@]}" ; do
			if grep -q -e "${f}" "/var/db/pkg/${pkg}-"*"/CFLAGS" 2>/dev/null ; then
				found_count_id_mitigation=$(( ${found_count_id_mitigation} + 1 ))
			fi
		done
	fi

	if [[ "${tags}" =~ "sensitive-data" ]] ; then
		if (( ${found_count} == 6 && ${found_count_id_mitigation} >= 1 )) ; then
			return 0
		fi
	else
		if (( ${found_count} == 6 )) ; then
			return 0
		fi
	fi
	return 1
}

# @FUNCTION: _electron-app_verify_chromium_kernel_config_security
# @DESCRIPTION:
# Checks if the kernel config for standard security settings.
#
# Verify kernel mitigations:
#
# ALSR - Code Reuse, Privilege Escalation, Memory Corruption
# Hardened user copy - Heap Overflow, Code Execution, Information Disclosure, Denial of Service
# Init on free / init on alloc - Use After Free
# Kernel stack offset randomization - Sandbox Escape, Privilege Escalation
# MMAP minimum address - Privilege Escalation, Sandbox Escape
# NX bit - Code Execution
# PTI - Information Disclosure
# Retpoline - Information Disclosure
# seccomp - Code Execution, Privilege Escalation
# SSP - Code Execution, Privilege Escalation
#
_electron-app_verify_chromium_kernel_config_security() {
	if use kernel_linux ; then
		linux-info_pkg_setup

einfo "Kernel version:  ${KV_MAJOR}.${KV_MINOR}"
einfo "CONFIG_PATH being reviewed:  $(linux_config_path)"

	        if ! linux_config_src_exists ; then
eerror "Missing .config in /usr/src/linux"
			die
	        fi

		if ! linux_config_exists ; then
ewarn "Missing kernel .config file."
		fi

	#
	# The kstack offset mitigation has been weaponized for Data Tampering in CVE-2025-38236
	# It has a better Faustian deal by enabling it.
	#
	# YAMA is a Chromium requirement.
	#
	# The history of the transparent hugepage commit can be found on
	# https://community.intel.com/t5/Blogs/Tech-Innovation/Client/A-Journey-for-Landing-The-V8-Heap-Layout-Visualization-Tool/post/1368855
	# I've seen this first in the nodejs repo but never understood the benefit.
	# The same article discusses the unintended consequences.
	# In the current build files in the Chromium project, they had went against their original decision about supporting THP.
	#
		CONFIG_CHECK="
			HARDENED_USERCOPY
			INIT_ON_ALLOC_DEFAULT_ON
			INIT_ON_FREE_DEFAULT_ON
			RANDOMIZE_BASE
			RANDOMIZE_KSTACK_OFFSET
			RELOCATABLE
			SECCOMP
			STACKPROTECTOR
			STACKPROTECTOR_STRONG
			STRICT_KERNEL_RWX

			~SYSFS
			MULTIUSER
			~SECURITY
			~SECURITY_YAMA

			~TRANSPARENT_HUGEPAGE
		"

		if use amd64 ; then
			CONFIG_CHECK+="
				RANDOMIZE_MEMORY
			"
		fi
		if ver_test "${KV_MAJOR}.${KV_MINOR}" "-lt" "6.9" ; then
	# Kernel 2.10
			CONFIG_CHECK+="
				PAGE_TABLE_ISOLATION
				RETPOLINE
			"
		else
	# Kernel 6.9
			CONFIG_CHECK+="
				MITIGATION_PAGE_TABLE_ISOLATION
				MITIGATION_RETPOLINE
			"
		fi

		WARNING_INIT_ON_ALLOC_DEFAULT_ON="CONFIG_INIT_ON_ALLOC_DEFAULT_ON is required to mitigate against full system compromise."
		WARNING_INIT_ON_FREE_DEFAULT_ON="CONFIG_INIT_ON_FREE_DEFAULT_ON is required to mitigate against full system compromise."
		WARNING_HARDENED_USERCOPY="CONFIG_HARDENED_USERCOPY is required to mitigate against full system compromise."
		WARNING_MITIGATION_PAGE_TABLE_ISOLATION="CONFIG_MITIGATION_PAGE_TABLE_ISOLATION is required for Meltdown mitigation or exfiltration mitigation."
		WARNING_MITIGATION_RETPOLINE="CONFIG_MITIGATION_RETPOLINE is required for Spectre mitigation or exfiltration mitigation."
		WARNING_MULTIUSER="CONFIG_MULTIUSER could be added for ptrace sandbox protection"
		WARNING_PAGE_TABLE_ISOLATION="CONFIG_PAGE_TABLE_ISOLATION is required for Meltdown mitigation or exfiltration mitigation."
		WARNING_RANDOMIZE_BASE="CONFIG_RANDOMIZE_BASE is required to mitigate against full system compromise."
		WARNING_RANDOMIZE_KSTACK_OFFSET="CONFIG_RANDOMIZE_KSTACK_OFFSET is required to mitigate against sandbox escape."
		WARNING_RANDOMIZE_MEMORY="CONFIG_RANDOMIZE_MEMORY is required to mitigate against full system compromise."
		WARNING_RANDOMIZE_RELOCATABLE="CONFIG_RANDOMIZE_BASE is required to mitigate against full system compromise."
		WARNING_RETPOLINE="CONFIG_RETPOLINE is required for Spectre mitigation or exfiltration mitigation."
		WARNING_SECCOMP="CONFIG_SECCOMP is required system will be unable to play DRM-protected content or not sandbox correctly."
		WARNING_SECURITY="CONFIG_SECURITY could be added for ptrace sandbox protection"
		WARNING_SECURITY_YAMA="CONFIG_SECURITY_YAMA could be added for ptrace sandbox protection to mitigate against credential theft or sandbox escape"
		WARNING_STACKPROTECTOR="CONFIG_STACKPROTECTOR is required to mitigate against full system compromise."
		WARNING_STACKPROTECTOR_STRONG="CONFIG_STACKPROTECTOR is required to mitigate against full system compromise."
		WARNING_STRICT_KERNEL_RWX="CONFIG_STRICT_KERNEL_RWX is required to mitigate against full system compromise."
		WARNING_SYSFS="CONFIG_SYSFS could be added for ptrace sandbox protection"
		WARNING_TRANSPARENT_HUGEPAGE="CONFIG_TRANSPARENT_HUGEPAGE could be enabled for V8 [JavaScript engine] memory access time reduction.  For webservers, music production, realtime, it should be kept disabled."

		if linux_chkconfig_present "SECURITY_YAMA" ; then
			local lsm=$(linux_chkconfig_string "LSM")
			if ! [[ "${lsm}" =~ "yama" ]] ; then
ewarn "CONFIG_LSM should add yama for ptrace sandbox protection and sandbox escape mitigation."
			fi
		fi

		check_extra_config

		local config_path=$(linux_config_path)
		local is_64bit=$(tc-get-ptr-size)
		is_64bit=$(( ${is_64bit} == 8 : 1 : 0 ))
		if [[ -e "${config_path}" ]] ; then
			local v=$(grep -e "CONFIG_DEFAULT_MMAP_MIN_ADDR" "${config_path}" | cut -f 2 -d "=")
			[[ -z "${v}" ]] && v=0
			if (( ${is_64bit} == 1 && ${v} != 65536 )) ; then
ewarn "CONFIG_DEFAULT_MMAP_MIN_ADDR should be 65536 for 64-bit"
			fi
			if (( ${is_64bit} == 0 && ${v} != 32768 )) ; then
ewarn "CONFIG_DEFAULT_MMAP_MIN_ADDR should be 32768 for 32-bit"
			fi
		else
ewarn "CONFIG_DEFAULT_MMAP_MIN_ADDR should be 65536 for 64-bit, 32768 for 32-bit"
		fi
	fi
}

# @FUNCTION: _electron-app_verify_compiler_flags_hardening
# @DESCRIPTION:
# Check compiler hardening requirements common to all network facing Electron
# apps.
_electron-app_verify_compiler_flags_hardening() {
	local L1=(
	#
	# Packages that are listed:
	#
	# 1.  Security-critical packages
	# 2.  Processes untrusted-data
	# 3.  Processes trusted-data
	# 4.  A shared library loaded during runtime into the following processes - browser, UI, rendering
	# 5.  Attack surface risks (sandbox escape potential, privilege gain, memory corruption potential)
	#
	#	"<use-flag>:<pkg>:<tags>"


	#
	# Understanding the problem of compiler hardening per process, ranked by
	# compiler hardening triage/remediation rank:
	#
	# 1. Main - not sandboxed, privileged, balanced
	# 2. Renderer - sandboxed, security-critical
	# 3. Utility - sandboxed, balanced to security-critical
	# 4. GPU process - sandboxed, balanced
	# 5. Helpers - sandboxed, balanced
	#

	#
	# The best return in security for compiler hardening remediation/triage
	# for secure messaging:
	#
	# 1. nss
	# 2. libxkbcommon
	# 3. gtk+3
	# 4. mesa
	# 5. glib:2
	# 6. glibc
	# 7. libxcb
	# 8. dbus
	# 9. at-spi2-core
	# 10. pango, cairo
	#
	# Remediating the top 5 results in 80% security improvement.
	#

	#
	# Manual hardening via per-package flags.
	# No ebuild available on the oiledmachine-overlay.
	#

	"unconditional:app-accessibility/at-spi2-core:manual,attack-surface-risk,sensitive-data,untrusted-data"		# PII
	"unconditional:dev-libs/nspr:manual,sensitive-data"
	"unconditional:media-libs/alsa-lib:manual,attack-surface-risk"
	"unconditional:net-print/cups:manual,sensitive-data,untrusted-data"
	"unconditional:sys-apps/dbus:manual,sensitive-data"								# PII, Crown Jewel Keys

	#
	# Hardened-by-default ebuilds available on the oiledmachine-overlay.
	#
	# The overlay adds the newer hardening flags which may be missing in the
	# default hardening compiler settings.
	#
	"unconditional:dev-libs/expat:untrusted-data"
	"unconditional:dev-libs/glib:attack-surface-risk,sensitive-data"
	"unconditional:dev-libs/nss:attack-surface-risk,sensitive-data,untrusted-data"
	"unconditional:media-libs/mesa:attack-surface-risk,sensitive-data,untrusted-data"
	"unconditional:x11-libs/pango:sensitive-data,untrusted-data"
	"unconditional:x11-libs/cairo:sensitive-data,untrusted-data"
	"unconditional:x11-libs/gtk+:sensitive-data"

	"wayland:dev-libs/wayland:attack-surface-risk,manual"
	"X:x11-base/xorg-server:sensitive-data"
	"X:x11-libs/libxcb:sensitive-data"
	"X:x11-libs/libxkbcommon:sensitive-data"
	"X:x11-libs/libX11:sensitive-data"
	)

	local row
	for row in "${L1[@]}" ; do
		local u=$(echo "${row}" | cut -f 1 -d ":")
		local p=$(echo "${row}" | cut -f 2 -d ":")
		local tag=$(echo "${row}" | cut -f 3 -d ":")
		if [[ "${tag}" =~ "manual" ]] ; then
			if [[ "${u}" == "unconditional" ]] ; then
ewarn "The package ${p} must be manually security-critical hardened using per-package package.env.  Use the hardening flags from the build log."
			elif use "${u}" && ! _electron-app_has_all_hardening_flags "${p}" ; then
ewarn "The package ${p} must be manually security-critical hardened using per-package package.env.  Use the hardening flags from the build log."
			fi
		elif [[ "${u}" == "unconditional" ]] ; then
			local repo=$(cat "/var/db/pkg/${p}-"*"/repository" | sed -e "/oiledmachine-overlay/d" | head -n 1)
			if ! grep -q -e "oiledmachine-overlay" "${ESYSROOT}/var/db/pkg/${p}-"*"/repository" ; then
ewarn "The package ${p}::${repo} may not be security-critical hardened.  Use the ${p}::oiledmachine-overlay ebuild instead."
			fi
		elif use "${u}" ; then
			if ! grep -q -e "oiledmachine-overlay" "${ESYSROOT}/var/db/pkg/${p}-"*"/repository" ; then
				local repo=$(cat "/var/db/pkg/${p}-"*"/repository" | sed -e "/oiledmachine-overlay/d" | head -n 1)
ewarn "The package ${p}::${repo} may not be security-critical hardened.  Use the ${p}::oiledmachine-overlay ebuild instead."
			fi
		fi
	done

	local L2=(
		"dev-libs/weston"
		"gui-liri/liri-shell"
		"gui-wm/cage"
		"gui-wm/cagebreak"
		"gui-wm/dwl"
		"gui-wm/kiwmi"
		"gui-wm/hyprland"
		"gui-wm/labwc"
		"gui-wm/mangowc"
		"gui-wm/miracle-wm"
		"gui-wm/newm"
		"gui-wm/niri"
		"gui-wm/river"
		"gui-wm/sway"
		"gui-wm/waybox"
		"gui-wm/wayfire"
		"kde-plasma/kwin"
		"x11-wm/enlightenment"
		"x11-wm/mutter"
	)

	if use wayland ; then
		local found_compositor=0
		local x
		for x in "${L2[@]}" ; do
			if has_version "${x}" ; then
				found_compositor=1
ewarn "${x} must use security-critical hardened ebuilds or per-package package.env hardening.  Use the hardening flags from the build log."
			fi
		done

		if (( ${found_compositor} == 0 )) ; then
ewarn "Wayland compositors must use security-critical hardened ebuilds or per-package package.env hardening.  Use the hardening flags from the build log."
		fi
	fi

ewarn "Packages that interact with ${PN} (e.g. password managers, clipboard managers) must use security-critical hardened ebuilds or per-package package.env hardening.  Use the hardening flags from the build log."
}

# @FUNCTION: electron-app_pkg_setup
# @DESCRIPTION:
# Perform verification or checks
# It must be manually called in pkg_setup().
electron-app_pkg_setup() {
	_electron-app_verify_chromium_kernel_config_security
	_electron-app_verify_compiler_flags_hardening
}
