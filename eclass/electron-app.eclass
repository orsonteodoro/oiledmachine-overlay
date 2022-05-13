# Copyright 2019-2020 Orson Teodoro
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: electron-app.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 6 7
# @BLURB: Eclass for GUI based Electron packages
# @DESCRIPTION:
# The electron-app eclass defines phase functions and utility functions for
# Electron app packages. It depends on the app-portage/npm-secaudit package to
# maintain a secure environment.

case "${EAPI:-0}" in
        0|1|2|3|4|5)
                die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
                ;;
        6)
		inherit eapi7-ver
		;;
	7)
                ;;
        *)
                die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
                ;;
esac


inherit chromium-2 desktop eutils npm-utils

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


ELECTRON_APP_MODE=${ELECTRON_APP_MODE:="npm"} # can be npm, yarn

# Set this in your make.conf to control number of HTTP requests.  50 is npm
# default but it is too high.
ELECTRON_APP_MAXSOCKETS=${ELECTRON_APP_MAXSOCKETS:="1"}

# You could define it as a per-package envar.  It not recommended in the ebuild.
ELECTRON_APP_ALLOW_AUDIT=${ELECTRON_APP_ALLOW_AUDIT:="1"}

# You could define it as a per-package envar.  It not recommended in the ebuild.
ELECTRON_APP_ALLOW_AUDIT_FIX=${ELECTRON_APP_ALLOW_AUDIT_FIX:="1"}

# You could define it as a per-package envar.  It not recommended in the ebuild.
# Applies to only vulnerability testing not the tool itself.
ELECTRON_APP_NO_DIE_ON_AUDIT=${ELECTRON_APP_NO_DIE_ON_AUDIT:="0"}

# You could define it as a per-package envar.  Disabled by default because
# rapid changes in dependencies over short period of time.
ELECTRON_APP_ALLOW_AUDIT_FIX_AT_EBUILD_LEVEL=\
${ELECTRON_APP_ALLOW_AUDIT_FIX_AT_EBUILD_LEVEL:="0"}

# Acceptable values:  Critical, High, Moderate, Low
# Applies to npm audit not CVSS v3
# For those that are confused, this is interpeted as tolerance level meaning
# >=$ELECTRON_APP_UNACCEPTABLE_VULNERABILITY_LEVEL.
ELECTRON_APP_UNACCEPTABLE_VULNERABILITY_LEVEL=\
${ELECTRON_APP_UNACCEPTABLE_VULNERABILITY_LEVEL:="Critical"}

# You could define it as a per-package envar.  It not recommended in the ebuild.
ELECTRON_APP_ALLOW_NON_LTS_ELECTRON=${ELECTRON_APP_ALLOW_NON_LTS_ELECTRON:="0"}

# ##################  END Per-package environmental variables ##################

# ##################  START ebuild and eclass global variables #################

NPM_PACKAGE_DB="/var/lib/portage/npm-packages"
NPM_PACKAGE_SETS_DB="/etc/portage/sets/npm-security-update"
YARN_PACKAGE_DB="/var/lib/portage/yarn-packages"
_ELECTRON_APP_REG_PATH=${_ELECTRON_APP_REG_PATH:=""} # private set only within the eclass

if [[ -n "${ELECTRON_APP_REG_PATH}" ]] ; then
die "ELECTRON_APP_REG_PATH has been removed and replaced with\n\
ELECTRON_APP_INSTALL_PATH.  Please wait for the next ebuild update."
fi

# The recurrance interval between critical vulnerabilities in chrome is 10-14
# days recently (worst cases), but longer interval between vulnerabilites with
# 159 days (~5 months) and 5 days has been observed.  If the app is used like a
# web-browser (including social media apps), the internal Chromium requires
# weekly forced updates.
ELECTRON_APP_USED_AS_WEB_BROWSER_OR_SOCIAL_MEDIA_APP=\
${ELECTRON_APP_USED_AS_WEB_BROWSER_OR_SOCIAL_MEDIA_APP:="0"}

ELECTRON_APP_LOCKS_DIR="/dev/shm"
NPM_SECAUDIT_LOCKS_DIR="/dev/shm"
ELECTRON_APP_DATA_DIR="${EROOT}/var/cache/npm-secaudit"
ELECTRON_APP_VERSION_DATA_PATH="${ELECTRON_APP_DATA_DIR}/lite.json"

# ##################  START End of Life or patched versions ####################

# Also bump if for unpublished vulnerabilities published as bugs, weakened security, or Chromium security updates.

# Stable versions list https://www.electronjs.org/docs/latest/tutorial/support#currently-supported-versions

# IMPORTANT: Update section [A] below

# See also:  https://raw.githubusercontent.com/electron/releases/master/lite.json

# Track "Security:" in https://www.electronjs.org/releases/nightly?version=20
CVE_PATCHED_ELECTRON_20="20.0.0-nightly.20220506"

# Track "Security:" in https://www.electronjs.org/releases/nightly?version=19
CVE_PATCHED_ELECTRON_19="19.0.0-nightly.20220329"

# Track "Security:" in https://www.electronjs.org/releases/stable?version=18
CVE_PATCHED_ELECTRON_18="18.2.1"

# Track "Security:" in https://www.electronjs.org/releases/stable?version=17
CVE_PATCHED_ELECTRON_17="17.4.3"

# Track "Security:" in https://www.electronjs.org/releases/stable?version=16
CVE_PATCHED_ELECTRON_16="16.2.5"

# Track "Security:" in https://www.electronjs.org/releases/stable?version=15
CVE_PATCHED_ELECTRON_15="15.5.4"


# Track "Vulnerabilities fixed" in https://github.com/nodejs/node/blob/master/doc/changelogs/CHANGELOG_V16.md
CVE_PATCHED_NODE_16_E20="16.14.2" # latest, has CVE fix
CVE_PATCHED_NODE_16_E19="16.14.2" # latest, has CVE fix
CVE_PATCHED_NODE_16_E18="16.13.2" # old, has CVE fixes
CVE_PATCHED_NODE_16_E17="16.13.0" # old
CVE_PATCHED_NODE_16_E16="16.9.1" # old
CVE_PATCHED_NODE_16_E15="16.5.0" # old

# These Chromium desktop versions listed are non vulnerable versions:
# Reason why is to minimize vulnerability checks in this eclass.

# It's difficult to determine between OS and Desktop which are not the
# vulnerable versions so it is assumed that the latest on the Linux platform is
# clean.  For the latest, Linux version see:
# https://omahaproxy.appspot.com/

# Beta channel
# Track "security updates" in https://chromereleases.googleblog.com/search/label/Stable%20updates
LATEST_CHROMIUM_102="102.0.4962.3" # E19 ; dev
LATEST_CHROMIUM_102="102.0.4999.0" # E20 ; dev
LATEST_CHROMIUM_100="100.0.4896.143" # E18 ; EOL
LATEST_CHROMIUM_98="98.0.4758.141" # E17 ; EOL
LATEST_CHROMIUM_96="96.0.4664.174" # E16 ; EOL
LATEST_CHROMIUM_94="94.0.4606.81" # E15 ; EOL

# Electron 15 uses EOL Cr94
# Electron 14 uses EOL Cr93
# Electron 13 uses EOL Cr91

# Check the runtime dependencies for electron
# Most electron apps will have electron bundled already.  No need for seperate
# ebuild.

# The chromium version can be found in the table:
# https://github.com/electron/electron/blob/12-x-y/DEPS#L17 ,  replacing 12 with one of the stable versions

# See https://www.electronjs.org/docs/development/build-instructions-linux
# For Electron 17, see https://github.com/chromium/chromium/blob/96.0.4647.0/build/install-build-deps.sh#L242
# For Electron 16, see https://github.com/chromium/chromium/blob/96.0.4647.0/build/install-build-deps.sh#L242
# For Electron 15, see https://github.com/chromium/chromium/blob/94.0.4606.81/build/install-build-deps.sh#L242
# For Electron 14, see https://github.com/chromium/chromium/blob/93.0.4577.82/build/install-build-deps.sh#L242
# For Electron 13, see https://github.com/chromium/chromium/blob/91.0.4472.164/build/install-build-deps.sh#L237

# ##################  END End of Life or patched versions ######################

#   under "List of required run-time libraries"
# Obtained from ldd
IUSE+=" app-indicator global-menu-bar gnome-keyring libsecret unity pulseaudio"

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
	app-accessibility/speech-dispatcher
	dev-db/sqlite:3
	libsecret? ( app-crypt/libsecret )
	gnome-keyring? (
		gnome-base/gnome-keyring[pam]
		gnome-base/libgnome-keyring
	)
	pulseaudio? ( media-sound/pulseaudio )"
# Electron only
# Assumes U 18.04 builder but allows for older U LTS if libs present.
COMMON_DEPEND="
	${CHROMIUM_DEPEND}
	app-accessibility/at-spi2-atk:2
	app-arch/bzip2
	app-indicator? ( dev-libs/libappindicator:3 )
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
	global-menu-bar? ( dev-libs/libdbusmenu )
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
	unity? ( dev-libs/libunity )
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
	x11-libs/pixman"

# [A] Supported versions (LTS) are listed in
# https://www.electronjs.org/docs/tutorial/support#currently-supported-versions
if [[ -n "${ELECTRON_APP_ELECTRON_V}" ]] \
&& ver_test $(ver_cut 1-2 "${ELECTRON_APP_ELECTRON_V}") -ge 17.0 ; then
:; # nightly series unsupported
elif [[ -n "${ELECTRON_APP_ELECTRON_V}" ]] \
&& ver_test $(ver_cut 1-2 "${ELECTRON_APP_ELECTRON_V}") -ge 16.0 ; then
:; # E16 alpha series officially supported upstream
elif [[ -n "${ELECTRON_APP_ELECTRON_V}" ]] \
&& ver_test $(ver_cut 1-2 "${ELECTRON_APP_ELECTRON_V}") -ge 15.0 ; then
:; # series officially supported upstream
elif [[ -n "${ELECTRON_APP_ELECTRON_V}" ]] \
&& ver_test $(ver_cut 1-2 "${ELECTRON_APP_ELECTRON_V}") -ge 14.0 ; then
:; # series officially supported upstream
elif [[ -n "${ELECTRON_APP_ELECTRON_V}" ]] \
&& ver_test $(ver_cut 1-2 "${ELECTRON_APP_ELECTRON_V}") -ge 13.0 ; then
:; # series officially supported upstream
else
if [[ "${ELECTRON_APP_ALLOW_NON_LTS_ELECTRON}" == "0" ]] ; then
die "Electron should be updated to one of the latest Long Term Support (LTS)\n\
series versions or else it likely contains critical CVE security advisories."
fi
fi

# See https://github.com/angular/angular/blob/4.0.x/package.json
if [[ -n "${ELECTRON_APP_ANGULAR_V}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_V}") -ge 2.0 \
	&& ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_V}") -le 2.4 ) ; then
COMMON_DEPEND+="
	>=net-libs/nodejs-5.4.1
	<net-libs/nodejs-7
"
elif [[ -n "${ELECTRON_APP_ANGULAR_V}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_V}") -ge 4.0 \
	&& ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_V}") -le 4.4 ) ; then
COMMON_DEPEND+="
	>=net-libs/nodejs-6.9.5
	<net-libs/nodejs-7
"
elif [[ -n "${ELECTRON_APP_ANGULAR_V}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_V}") -ge 5.0 \
	&& ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_V}") -le 6.0 ) ; then
COMMON_DEPEND+="
	>=net-libs/nodejs-8.9.1
	<net-libs/nodejs-9
"
elif [[ -n "${ELECTRON_APP_ANGULAR_V}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_V}") -ge 6.1 \
	&& ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_V}") -le 8.2 ) ; then
COMMON_DEPEND+="
	>=net-libs/nodejs-10.9.0
	<net-libs/nodejs-11
"
elif [[ -n "${ELECTRON_APP_ANGULAR_V}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_V}") -ge 9.0 \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_ANGULAR_V}") -le 11.2.8 ) ; then
COMMON_DEPEND+="
	>=net-libs/nodejs-10.9.0
	<net-libs/nodejs-13
"
elif [[ -n "${ELECTRON_APP_ANGULAR_V}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_V}") -ge 11.2.9 \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_ANGULAR_V}") -le 11.2.14 ) ; then
COMMON_DEPEND+="
	>=net-libs/nodejs-10.19.0
	<net-libs/nodejs-16
"
elif [[ -n "${ELECTRON_APP_ANGULAR_V}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_V}") -ge 12.0.0 \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_ANGULAR_V}") -le 12.2.11 ) ; then
COMMON_DEPEND+="
	|| (
		>=net-libs/nodejs-12.20.0:12
		>=net-libs/nodejs-14:14
	)
"
elif [[ -n "${ELECTRON_APP_ANGULAR_V}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_ANGULAR_V}") -ge 13 \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_ANGULAR_V}") -le 9999 ) ; then
COMMON_DEPEND+="
	|| (
		>=net-libs/nodejs-12.20.0:12
		>=net-libs/nodejs-14.15:14
		>=net-libs/nodejs-16.10.0:16
	)
"
fi

# See https://github.com/facebook/react/blob/master/package.json
if [[ -n "${ELECTRON_APP_REACT_V}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_V}") -ge 0.3 \
	&& ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_V}") -le 0.13 ) ; then
COMMON_DEPEND+="
	>=net-libs/nodejs-0.10.0
"
elif [[ -n "${ELECTRON_APP_REACT_V}" ]] \
	&& ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_V}") -eq 0.14 ; then
COMMON_DEPEND+="
	>=net-libs/nodejs-4
	<net-libs/nodejs-5
"
elif [[ -n "${ELECTRON_APP_REACT_V}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_V}") -ge 15.0 \
	&& ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_V}") -le 15.6 ) ; then
COMMON_DEPEND+="
	>=net-libs/nodejs-4
	<net-libs/nodejs-8
"
elif [[ -n "${ELECTRON_APP_REACT_V}" ]] \
	&& ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_V}") -eq 16.3 ; then
COMMON_DEPEND+="
	>=net-libs/nodejs-8
	<net-libs/nodejs-11
"
elif [[ -n "${ELECTRON_APP_REACT_V}" ]] \
	&& ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_V}") -eq 16.4 ; then
COMMON_DEPEND+="
	>=net-libs/nodejs-8
	<net-libs/nodejs-10
"
elif [[ -n "${ELECTRON_APP_REACT_V}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_REACT_V}") -ge 16.8.3 \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_REACT_V}") -le 16.8.6 ) ; then
COMMON_DEPEND+="
	>=net-libs/nodejs-8
	<net-libs/nodejs-12
"
elif [[ -n "${ELECTRON_APP_REACT_V}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_REACT_V}") -ge 16.13.0 \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_REACT_V}") -le 16.13.1 ) ; then
COMMON_DEPEND+="
	>=net-libs/nodejs-8
	<net-libs/nodejs-14
"
elif [[ -n "${ELECTRON_APP_REACT_V}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_REACT_V}") -ge 16.14.0 \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_REACT_V}") -lt 9999 ) ; then
COMMON_DEPEND+="
	>=net-libs/nodejs-8
	<net-libs/nodejs-15
"
elif [[ -n "${ELECTRON_APP_REACT_V}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_REACT_V}") -ge 9999 ; then
COMMON_DEPEND+="
	>=net-libs/nodejs-12.17
	<net-libs/nodejs-17
"
fi

# See https://github.com/microsoft/TypeScript/blob/v2.0.7/package.json
if [[ -n "${ELECTRON_APP_TYPESCRIPT_V}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_TYPESCRIPT_V}") -ge 2.0 \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_TYPESCRIPT_V}") -le 2.1.4 ) ; then
COMMON_DEPEND+="
	>=net-libs/nodejs-0.8.0
"
elif [[ -n "${ELECTRON_APP_TYPESCRIPT_V}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_TYPESCRIPT_V}") -ge 2.1.5 \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_TYPESCRIPT_V}") -le 9999 ) ; then
COMMON_DEPEND+="
	>=net-libs/nodejs-4.2.0
"
fi

# See https://github.com/facebook/react-native/blob/0.63-stable/package.json
if [[ -n "${ELECTRON_APP_REACT_NATIVE_V}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_NATIVE_V}") -ge 0.13 \
	&& ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_NATIVE_V}") -le 0.55 ) ; then
COMMON_DEPEND+="" # doesn't say
elif [[ -n "${ELECTRON_APP_REACT_NATIVE_V}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_NATIVE_V}") -ge 0.13 \
	&& ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_NATIVE_V}") -le 0.55 ) ; then
COMMON_DEPEND+="
	>=net-libs/nodejs-4
"
elif [[ -n "${ELECTRON_APP_REACT_NATIVE_V}" ]] \
	&& ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_NATIVE_V}") -eq 0.56 ; then
COMMON_DEPEND+="
	>=net-libs/nodejs-8
"
elif [[ -n "${ELECTRON_APP_REACT_NATIVE_V}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_NATIVE_V}") -ge 0.57 \
	&& ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_NATIVE_V}") -le 0.62 ) ; then
COMMON_DEPEND+="
	>=net-libs/nodejs-8.3
"
elif [[ -n "${ELECTRON_APP_REACT_NATIVE_V}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_NATIVE_V}") -ge 0.63 \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_REACT_NATIVE_V}") -lt 0.64 ) ; then
COMMON_DEPEND+="
	>=net-libs/nodejs-10
"
elif [[ -n "${ELECTRON_APP_REACT_NATIVE_V}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_NATIVE_V}") -ge 0.64 \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_REACT_NATIVE_V}") -le 0.67 ) ; then
COMMON_DEPEND+="
	>=net-libs/nodejs-12
"
elif [[ -n "${ELECTRON_APP_REACT_NATIVE_V}" ]] && ( \
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_NATIVE_V}") -ge 0.68 \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_REACT_NATIVE_V}") -le 9999 ) ; then
COMMON_DEPEND+="
	>=net-libs/nodejs-14
"
fi


# See https://github.com/DefinitelyTyped/DefinitelyTyped/blob/master/types/node
# in the v13/index.d.ts, where v13 is a particular node version.
# For @types/node
if [[ -n "${ELECTRON_APP_AT_TYPES_NODE_V}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_V}") -eq 0 ; then
COMMON_DEPEND+=" =net-libs/nodejs-0*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_V}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_V}") -eq 4 ; then
COMMON_DEPEND+=" =net-libs/nodejs-4*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_V}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_V}") -eq 6 ; then
COMMON_DEPEND+=" =net-libs/nodejs-6*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_V}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_V}") -eq 7 ; then
COMMON_DEPEND+=" =net-libs/nodejs-7*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_V}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_V}") -eq 8 ; then
COMMON_DEPEND+=" =net-libs/nodejs-8*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_V}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_V}") -eq 9 ; then
COMMON_DEPEND+=" =net-libs/nodejs-9*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_V}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_V}") -eq 10 ; then
COMMON_DEPEND+=" =net-libs/nodejs-10*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_V}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_V}") -eq 11 ; then
COMMON_DEPEND+=" =net-libs/nodejs-11*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_V}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_V}") -eq 12 ; then
COMMON_DEPEND+=" =net-libs/nodejs-12*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_V}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_V}") -eq 13 ; then
COMMON_DEPEND+=" =net-libs/nodejs-13*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_V}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_V}") -eq 14 ; then
COMMON_DEPEND+=" =net-libs/nodejs-14*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_V}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_V}") -eq 15 ; then
COMMON_DEPEND+=" =net-libs/nodejs-15*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_V}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_V}") -eq 16 ; then
COMMON_DEPEND+=" =net-libs/nodejs-16*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_V}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_V}") -eq 17 ; then
COMMON_DEPEND+=" =net-libs/nodejs-17*"
fi

if [[ -n "${ELECTRON_APP_VUE_V}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_V}") -ge 0.6.0 \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_V}") -le 0.11.10 ) ; then
COMMON_DEPEND+=" =net-libs/nodejs-0.10*" # .travis.yml
elif [[ -n "${ELECTRON_APP_VUE_V}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_V}") -ge 0.12.0 \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_V}") -le 0.12.0 ) ; then
COMMON_DEPEND+=" net-libs/iojs" # doesn't say
elif [[ -n "${ELECTRON_APP_VUE_V}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_V}") -ge 0.12.1 \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_V}") -le 0.12.1 ) ; then
COMMON_DEPEND+=" ~net-libs/iojs-2.0.1" # .travis.yml
elif [[ -n "${ELECTRON_APP_VUE_V}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_V}") -ge 0.12.2 \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_V}") -le 0.12.2 ) ; then
COMMON_DEPEND+=" " # doesn't say
elif [[ -n "${ELECTRON_APP_VUE_V}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_V}") -ge 0.12.0 \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_V}") -le 1.0.8 ) ; then
COMMON_DEPEND+=" ~net-libs/iojs-2.0.1" # .travis.yml
elif [[ -n "${ELECTRON_APP_VUE_V}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_V}") -ge 1.0.9 \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_V}") -le 1.0.17 ) ; then
COMMON_DEPEND+=" =net-libs/nodejs-4*" # based on circle.yml
elif [[ -n "${ELECTRON_APP_VUE_V}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_V}") -ge 1.0.18 \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_V}") -le 1.0.28 ) ; then
COMMON_DEPEND+=" =net-libs/nodejs-5*" # based on circle.yml
elif [[ -n "${ELECTRON_APP_VUE_V}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_V}") -ge 2.0.0 \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_V}") -le 2.4.4 ) ; then
COMMON_DEPEND+=" =net-libs/nodejs-6*" # based on circle.yml
elif [[ -n "${ELECTRON_APP_VUE_V}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_V}") -ge 2.5.0 \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_V}") -le 2.5.22 ) ; then
	# based on @types/node restriction
COMMON_DEPEND+=" =net-libs/nodejs-8*" # ^8.0.33 ; they did the testing in node6 in <=2.5.7
elif [[ -n "${ELECTRON_APP_VUE_V}" ]] && ( \
	ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_V}") -ge 2.6.0 \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_V}") -le 2.6.10 ) ; then
	# based on @types/node restriction
COMMON_DEPEND+=" =net-libs/nodejs-10*" # ^10.12.18
elif [[ -n "${ELECTRON_APP_VUE_V}" ]] \
	&& ver_test $(ver_cut 1-3 "${ELECTRON_APP_VUE_V}") -ge 2.6.11 ; then
	# based on @types/node restriction
	# dev branch
COMMON_DEPEND+=" =net-libs/nodejs-12*" # ^12.12.0
fi

# Same packages as far back as 3.x
RDEPEND+=" ${COMMON_DEPEND}"
DEPEND+=" ${COMMON_DEPEND}"

EXPORT_FUNCTIONS pkg_setup src_unpack pkg_preinst pkg_postinst pkg_postrm

IUSE+=" debug "
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

if [[ -n "${ELECTRON_APP_USED_AS_WEB_BROWSER_OR_SOCIAL_MEDIA_APP}" \
&& "${ELECTRON_APP_USED_AS_WEB_BROWSER_OR_SOCIAL_MEDIA_APP}" == "1" ]] ; then
RDEPEND+="
	app-portage/npm-secaudit
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
if [[ -n "${ELECTRON_APP_APPIMAGEABLE}" && "${ELECTRON_APP_APPIMAGEABLE}" == 1 ]] ; then
IUSE+=" appimage"
_ELECTRON_APP_PACKAGING_METHODS+=( appimage )
RDEPEND+=" appimage? ( || (
		app-arch/appimaged
		app-arch/go-appimage[appimaged]
		    )    )"
# emerge will dump the .AppImage in that folder.
ELECTRON_APP_APPIMAGE_INSTALL_DIR=\
${ELECTRON_APP_APPIMAGE_INSTALL_DIR:="/opt/AppImage/${PN}"}
fi
if [[ -n "${ELECTRON_APP_SNAPABLE}" \
	&& "${ELECTRON_APP_SNAPABLE}" == 1 ]] ; then
IUSE+=" snap"
_ELECTRON_APP_PACKAGING_METHODS+=( snap )
RDEPEND+=" snap? ( app-emulation/snapd )"
# emerge will dump it in that folder then use snap functions
# to install desktop files and mount the image.
ELECTRON_APP_SNAP_INSTALL_DIR=\
${ELECTRON_APP_SNAP_INSTALL_DIR:="/opt/snap/${PN}"}
ELECTRON_APP_SNAP_NAME=${ELECTRON_APP_SNAP_NAME:=${PN}}
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
		ewarn \
"This ebuild may fail when building with electron-builder.  Re-emerge if it\n\
fails."
	fi

	grep -q -F -e "\"electron\":" $l
	if [[ "$?" == "0" ]] ; then
		ewarn \
"This ebuild may fail when downloading Electron as a dependency.  Re-emerge\n\
if it fails."
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

	einfo "Performing recursive package-lock.json audit fix"
	npm_update_package_locks_recursive ./ # calls npm_pre_audit
	einfo "Audit fix done"
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
			ewarn \
"No audit fix implemented in yarn.  Package may be likely vulnerable."
			;;
		*)
			;;
	esac

}

# @FUNCTION: electron-app_pkg_setup
# @DESCRIPTION:
# Initializes globals
electron-app_pkg_setup() {
        debug-print-function ${FUNCNAME} "${@}"

	chromium_suid_sandbox_check_kernel_config

	if has network-sandbox $FEATURES ; then
		die \
"FEATURES=\"-network-sandbox\" must be added per-package env to be able to\n\
download micropackages and obtain version releases information."
	fi

	#export ELECTRON_VER=$(strings /usr/bin/electron \
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
			#einfo "Electron version: ${ELECTRON_VER}"
			#if [[ -z "${ELECTRON_VER}" ]] ; then
			#	echo "Some ebuilds may break.  Restart and run in X."
			#fi

			addwrite "${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
			mkdir -p "${NPM_STORE_DIR}/offline"
			chown -R portage:portage "${NPM_STORE_DIR}"

			# Some npm package.json use yarn.
			addwrite ${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
			mkdir -p ${YARN_STORE_DIR}/offline
			chown -R portage:portage "${YARN_STORE_DIR}"
			export YARN_CACHE_FOLDER=${YARN_CACHE_FOLDER:=${YARN_STORE_DIR}}
			;;
		yarn)
			ewarn "Using yarn mode which has no audit fix yet."

			# Some npm package.json use yarn.
			addwrite ${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
			mkdir -p ${YARN_STORE_DIR}/offline
			chown -R portage:portage "${YARN_STORE_DIR}"
			export YARN_CACHE_FOLDER=${YARN_CACHE_FOLDER:=${YARN_STORE_DIR}}
			;;
		*)
			die "Unsupported package system"
			;;
	esac

	if [[ ! -d "/dev/shm" ]] ; then
		die "Missing /dev/shm.  Check the kernel config?"
	fi

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
		einfo "Updating Electron release data"
		rm -rf "${ELECTRON_APP_VERSION_DATA_PATH}" || true
		wget -O "${ELECTRON_APP_VERSION_DATA_PATH}" \
		"https://raw.githubusercontent.com/electron/releases/master/lite.json" || die
	else
		einfo "Using cached Electron release data"
	fi

	if [[ -n "${ELECTRON_APP_APPIMAGEABLE}" \
		&& "${ELECTRON_APP_APPIMAGEABLE}" == 1 ]] ; then
		if [[ -z "${ELECTRON_APP_APPIMAGE_PATH}" ]] ; then
			die "ELECTRON_APP_APPIMAGE_PATH must be defined relative to \${BUILD_DIR}"
		fi
	fi

	if [[ -n "${ELECTRON_APP_SNAPABLE}" \
		&& "${ELECTRON_APP_SNAPABLE}" == 1 ]] ; then
		if [[ -z "${ELECTRON_APP_SNAP_PATH_BASENAME}" ]] ; then
			die \
"ELECTRON_APP_SNAP_PATH_BASENAME must be defined relative to \
ELECTRON_APP_SNAP_INSTALL_DIR"
		fi
		if [[ -z "${ELECTRON_APP_SNAP_PATH}" ]] ; then
			die "ELECTRON_APP_SNAP_PATH must be defined relative to \${BUILD_DIR}"
		fi
		if [[ -n "${ELECTRON_APP_SNAP_ASSERT_PATH}" \
			&& -z "${ELECTRON_APP_SNAP_ASSERT_PATH_BASENAME}" ]] ; then
			die "ELECTRON_APP_SNAP_ASSERT_PATH_BASENAME must be defined."
		fi
		if [[ -n "${ELECTRON_APP_SNAP_ASSERT_PATH_BASENAME}" \
			&& -z "${ELECTRON_APP_SNAP_ASSERT_PATH}" ]] ; then
			die "ELECTRON_APP_SNAP_ASSERT_PATH must be defined."
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

	npm-utils_check_chromium_eol ${CHROMIUM_V}
}

# @FUNCTION: electron-app_fetch_deps_npm
# @DESCRIPTION:
# Fetches an Electron npm app with security checks
# MUST be called after default unpack AND patching.
electron-app_fetch_deps_npm() {
	_electron-app-flakey-check

	pushd "${S}" || die
		local install_args=()
		# Avoid adding fsevent (a MacOS dependency) which may require older node
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
		einfo "Running npm install ${install_args[@]} inside electron-app_fetch_deps_npm"
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
		cp "${S}"/.yarnrc{,.orig}
		echo "prefix \"${S}/.yarn\"" >> "${S}/.yarnrc" || die
		echo "global-folder \"${S}/.yarn\"" >> "${S}/.yarnrc" || die
		echo "offline-cache-mirror \"${YARN_STORE_DIR}/offline\"" \
			>> "${S}/.yarnrc" || die

		mkdir -p "${S}/.yarn"
		einfo \
"yarn prefix: $(yarn config get prefix)\n\
yarn global-folder: $(yarn config get global-folder)\n\
yarn offline-cache-mirror: $(yarn config get offline-cache-mirror)"

		yarn install --network-concurrency ${ELECTRON_APP_MAXSOCKETS} \
				--verbose || die
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
			die "Unsupported package system"
			;;
	esac
}

_query_lite_json() {
	echo $(cat "${ELECTRON_APP_VERSION_DATA_PATH}" \
		| jq '.[] | select(.tag_name == "v'${ELECTRON_V}'")' \
		| jq ${1} \
		| sed -r -e "s|[\"]*||g")
}

# @FUNCTION: adie
# @DESCRIPTION:
# Print warnings for audits or die depending on ELECTRON_APP_NO_DIE_ON_AUDIT
adie() {
	if [[ "${ELECTRON_APP_NO_DIE_ON_AUDIT}" == "1" ]] ; then
		ewarn "${1}"
	else
		die "${1}"
	fi
}

# @FUNCTION: electron-app_audit_versions
# @DESCRIPTION:
# Audits json logs for vulnerable versions and min requirements
electron-app_audit_versions() {
	einfo \
"Inspecting package versions for vulnerabilities and minimum version\n\
requirements"

	if [[ "${ELECTRON_APP_USED_AS_WEB_BROWSER_OR_SOCIAL_MEDIA_APP}" == "1" ]] ; then
		elog \
"It's strongly recommended re-emerge the app weekly to mitigate against\n\
critical vulnerabilities in the internal Chromium."
	fi

	local ELECTRON_V
	if npm ls electron | grep -q -F -e " electron@" ; then
		# case when ^ or latest used
		ELECTRON_V=$(npm ls electron \
			| grep -E -e "electron@[0-9.]+" \
			| tail -n 1 \
			| grep -E -o -e "[0-9\.a-z-]*" \
			| tail -n 1) # used by package and json search
		ELECTRON_V_=${ELECTRON_V}
		ELECTRON_V_=${ELECTRON_V_/-/_}
		ELECTRON_V_=${ELECTRON_V_/alpha./alpha}
		ELECTRON_V_=${ELECTRON_V_/beta./beta}
		ELECTRON_V_=${ELECTRON_V_/nightly./pre} # sanitize for ver_test
	elif [[ -n "${ELECTRON_APP_ELECTRON_V}" ]] ; then
		# fallback based on analysis on package.json
		ELECTRON_V=${ELECTRON_APP_ELECTRON_V} # for json search
		ELECTRON_V_=${ELECTRON_APP_ELECTRON_V}
		ELECTRON_V_=${ELECTRON_V_/-/_}
		ELECTRON_V_=${ELECTRON_V_/alpha./alpha}
		ELECTRON_V_=${ELECTRON_V_/beta./beta}
		ELECTRON_V_=${ELECTRON_V_/nightly./pre} # sanitize for ver_test
	else
		# Skip for dependency but not building ui yet
		return
	fi
	#BORINGSSL_V=$(_query_lite_json '.deps.openssl')
	CHROMIUM_V=$(_query_lite_json '.deps.chrome')
	LIBUV_V=$(_query_lite_json '.deps.uv')
	NODE_V=$(_query_lite_json '.deps.node')
	V8_V=$(_query_lite_json '.deps.v8')
	ZLIB_V=$(_query_lite_json '.deps.zlib')

	# ##### Vulnerability and End Of Life (EOL) Tests ######################

	# Check Electron
	if ver_test $(ver_cut 1 ${ELECTRON_V}) -ge 19 ; then
		# E20 Nightly
		# E19 Nightly
		:; # Auto pass since vulnerabilies only announced on stable releases
	elif ver_test $(ver_cut 1 ${ELECTRON_V}) -eq 18 \
		&& ver_test ${ELECTRON_V} -ge ${CVE_PATCHED_ELECTRON_16} ; then
		:; # Patched / Passed
	elif ver_test $(ver_cut 1 ${ELECTRON_V}) -eq 18 \
		&& ver_test ${ELECTRON_V} -lt ${CVE_PATCHED_ELECTRON_16} ; then
		# Unpatched
		adie \
"Electron ${ELECTRON_V} is not receiving proper security updates."
	elif ver_test $(ver_cut 1 ${ELECTRON_V}) -eq 17 \
		&& ver_test ${ELECTRON_V} -ge ${CVE_PATCHED_ELECTRON_15} ; then
		:; # Patched / Passed
	elif ver_test $(ver_cut 1 ${ELECTRON_V}) -eq 17 \
		&& ver_test ${ELECTRON_V} -lt ${CVE_PATCHED_ELECTRON_15} ; then
		# Unpatched
		adie \
"Electron ${ELECTRON_V} is not receiving proper security updates."
	elif ver_test $(ver_cut 1 ${ELECTRON_V}) -eq 16 \
		&& ver_test ${ELECTRON_V} -ge ${CVE_PATCHED_ELECTRON_14} ; then
		:; # Patched / Passed
	elif ver_test $(ver_cut 1 ${ELECTRON_V}) -eq 16 \
		&& ver_test ${ELECTRON_V} -lt ${CVE_PATCHED_ELECTRON_14} ; then
		# Unpatched
		adie \
"Electron ${ELECTRON_V} is not receiving proper security updates."
	elif ver_test $(ver_cut 1 ${ELECTRON_V}) -eq 15 \
		&& ver_test ${ELECTRON_V} -ge ${CVE_PATCHED_ELECTRON_13} ; then
		:; # Patched / Passed
	elif ver_test $(ver_cut 1 ${ELECTRON_V}) -eq 15 \
		&& ver_test ${ELECTRON_V} -lt ${CVE_PATCHED_ELECTRON_13} ; then
		# Unpatched
		adie \
"Electron ${ELECTRON_V} is not receiving proper security updates."
	else
		adie \
"Electron ${ELECTRON_V} has already reached End Of Life (EOL)."
	fi

	# Check Node.js EOL
	if ver_test $(ver_cut 1 ${NODE_V}) -eq 16 \
		&& ver_test ${NODE_V} -ge ${CVE_PATCHED_NODE_16_E20} \
		&& ver_test $(ver_cut 1 ${ELECTRON_V}) -eq 20 ; then
		:; # Patched / Passed
	elif ver_test $(ver_cut 1 ${NODE_V}) -eq 16 \
		&& ver_test ${NODE_V} -lt ${CVE_PATCHED_NODE_16_E20} \
		&& ver_test $(ver_cut 1 ${ELECTRON_V}) -eq 20 ; then
		# Unpatched
		adie \
"Electron ${ELECTRON_V} uses Node.js ${NODE_V} which is not receiving\n\
security updates."

	elif ver_test $(ver_cut 1 ${NODE_V}) -eq 16 \
		&& ver_test ${NODE_V} -ge ${CVE_PATCHED_NODE_16_E19} \
		&& ver_test $(ver_cut 1 ${ELECTRON_V}) -eq 19 ; then
		:; # Patched / Passed
	elif ver_test $(ver_cut 1 ${NODE_V}) -eq 16 \
		&& ver_test ${NODE_V} -lt ${CVE_PATCHED_NODE_16_E19} \
		&& ver_test $(ver_cut 1 ${ELECTRON_V}) -eq 19 ; then
		# Unpatched
		adie \
"Electron ${ELECTRON_V} uses Node.js ${NODE_V} which is not receiving\n\
security updates."

	elif ver_test $(ver_cut 1 ${NODE_V}) -eq 16 \
		&& ver_test ${NODE_V} -ge ${CVE_PATCHED_NODE_16_E18} \
		&& ver_test $(ver_cut 1 ${ELECTRON_V}) -eq 18 ; then
		:; # Patched / Passed
	elif ver_test $(ver_cut 1 ${NODE_V}) -eq 16 \
		&& ver_test ${NODE_V} -lt ${CVE_PATCHED_NODE_16_E18} \
		&& ver_test $(ver_cut 1 ${ELECTRON_V}) -eq 18 ; then
		# Unpatched
		adie \
"Electron ${ELECTRON_V} uses Node.js ${NODE_V} which is not receiving\n\
security updates."

	elif ver_test $(ver_cut 1 ${NODE_V}) -eq 16 \
		&& ver_test ${NODE_V} -ge ${CVE_PATCHED_NODE_16_E17} \
		&& ver_test $(ver_cut 1 ${ELECTRON_V}) -eq 17 ; then
		:; # Patched / Passed
	elif ver_test $(ver_cut 1 ${NODE_V}) -eq 16 \
		&& ver_test ${NODE_V} -lt ${CVE_PATCHED_NODE_16_E17} \
		&& ver_test $(ver_cut 1 ${ELECTRON_V}) -eq 17 ; then
		# Unpatched
		adie \
"Electron ${ELECTRON_V} uses Node.js ${NODE_V} which is not receiving\n\
security updates."

	elif ver_test $(ver_cut 1 ${NODE_V}) -eq 16 \
		&& ver_test ${NODE_V} -ge ${CVE_PATCHED_NODE_16_E16} \
		&& ver_test $(ver_cut 1 ${ELECTRON_V}) -eq 16 ; then
		:; # Patched / Passed
	elif ver_test $(ver_cut 1 ${NODE_V}) -eq 16 \
		&& ver_test ${NODE_V} -lt ${CVE_PATCHED_NODE_16_E16} \
		&& ver_test $(ver_cut 1 ${ELECTRON_V}) -eq 16 ; then
		# Unpatched
		adie \
"Electron ${ELECTRON_V} uses Node.js ${NODE_V} which is not receiving\n\
security updates."

	elif ver_test $(ver_cut 1 ${NODE_V}) -eq 16 \
		&& ver_test ${NODE_V} -ge ${CVE_PATCHED_NODE_16_E15} \
		&& ver_test $(ver_cut 1 ${ELECTRON_V}) -eq 15 ; then
		:; # Patched / Passed
	elif ver_test $(ver_cut 1 ${NODE_V}) -eq 16 \
		&& ver_test ${NODE_V} -lt ${CVE_PATCHED_NODE_16_E15} \
		&& ver_test $(ver_cut 1 ${ELECTRON_V}) -eq 15 ; then
		# Unpatched
		adie \
"Electron ${ELECTRON_V} uses Node.js ${NODE_V} which is not receiving\n\
security updates."

	else
		# Check Node.js EOL
		adie \
"Electron ${ELECTRON_V} uses Node.js ${NODE_V} which is End Of Life (EOL)."
	fi

	# Check Chromium
	# Chromium versioning:  MAJOR.MINOR.BUILD.PATCH
	if ver_test $(ver_cut 1 ${CHROMIUM_V}) -ge 102 ; then
		:; # Auto passed because vulnerabilites are typically not announced for beta and dev channels
	elif ver_test $(ver_cut 1 ${CHROMIUM_V}) -eq 100 \
		&& ver_test ${CHROMIUM_V} -lt ${LATEST_CHROMIUM_100} ; then
		# Beta unpatched
		adie \
"Electron ${ELECTRON_V} uses Chromium ${CHROMIUM_V} which is not receiving\n\
proper security updates."
	else
		adie \
"Electron ${ELECTRON_V} uses Chromium ${CHROMIUM_V} is End Of Life (EOL)."
	fi

	# ##### Compatibity Tests ##############################################

	if ! has_version ">=dev-libs/libuv-${LIBUV_V}" ; then
		adie \
"Electron ${ELECTRON_V} requires at least >=dev-libs/libuv-${LIBUV_V} libuv"
	fi
	# It's actually BoringSSL not OpenSSL in Chromium.
	# Commented out because Chromium checks
	if ! has_version ">=net-libs/nodejs-${NODE_V}" ; then
		ewarn \
"Electron ${ELECTRON_V} requires at least >=net-libs/nodejs-${NODE_V}"
	fi
	if ! has_version ">=sys-libs/zlib-${ZLIB_V}" ; then
		adie \
"Electron ${ELECTRON_V} requires at least >=sys-libs/zlib-${ZLIB_V}"
	fi
	npm-utils_check_chromium_eol ${CHROMIUM_V}
	einfo
	einfo "Electron version report with internal/external dependencies:"
	einfo
	einfo "ELECTRON_V=${ELECTRON_V}"
	einfo "CHROMIUM_V=${CHROMIUM_V}"
	einfo "LIBUV_V=${LIBUV_V}"
	einfo "NODE_V=${NODE_V}"
	einfo "V8_V=${V8_V}"
	einfo "ZLIB_V=${ZLIB_V}"
	einfo

	local node_v=$(node --version | sed -e "s|v||")
	if ver_test $(ver_cut 1 ${NODE_V}) -ne $(ver_cut 1 ${node_v}) ; then
		ewarn \
"Detected mismatch between node_v=${NODE_V} bundled with Electron and \
active_node_v=${node_v}.  Build failures may occur if deviation is too much."
	fi
}

# @FUNCTION: electron-app_src_unpack
# @DESCRIPTION:
# Runs phases for downloading dependencies, unpacking, building
electron-app_src_unpack() {
        debug-print-function ${FUNCNAME} "${@}"

	cd "${WORKDIR}"

	if [[ ! -d "${S}" ]] ; then
		default_src_unpack
	fi

	# all the phase hooks get run in unpack because of download restrictions

	cd "${S}"
	if declare -f electron-app_src_preprepare > /dev/null ; then
		electron-app_src_preprepare
	fi

	# Inspect before downloading
	electron-app_audit_versions

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

	# Audit both the production and dev packages before possibly
	# bundling a vulnerable package/library or a dev package that
	# generates vulnerable code.
	electron-app_audit_dev

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

	cd "${S}"
	# Another audit happens because electron-builder downloads again
	# possibly vulnerable libraries.
	electron-app_audit_versions

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

	die "currently uninplemented.  must override"
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
			die "Unsupported package system"
			;;
	esac
}

# @FUNCTION: electron-app_audit_dev
# @DESCRIPTION:
# This will preform an recursive audit in place without adding packages.
# @CODE
# Parameters:
# $1 - if set to 1 will not die (optional).  It should ONLY be be used for debugging.
# @CODE
electron-app_audit_dev() {
	if [[ -n "${ELECTRON_APP_ALLOW_AUDIT}" \
		&& "${ELECTRON_APP_ALLOW_AUDIT}" == "1" ]] ; then
		:;
	else
		return
	fi

	local nodie="${1}"
	[ ! -e package-lock.json ] \
		&& die "Missing package-lock.json in implied root $(pwd)"

	L=$(find . -name "package-lock.json")
	for l in $L; do
		pushd $(dirname $l) || die
		if [[ -n "${nodie}" \
			&& "${ELECTRON_APP_NO_DIE_ON_AUDIT}" == "1" ]] ; then
				npm audit || die
			else
				local audit_file="${T}/npm-audit-result"
				npm audit &> "${audit_file}" || die
				local is_critical=0
				local is_high=0
				local is_moderate=0
				local is_low=0
				grep -q -F -e " Critical " "${audit_file}" \
					&& is_critical=1
				grep -q -F -e " High " "${audit_file}" \
					&& is_high=1
				grep -q -F -e " Moderate " "${audit_file}" \
					&& is_moderate=1
				grep -q -F -e " Low " "${audit_file}" \
					&& is_low=1
				if [[ \
"${ELECTRON_APP_UNACCEPTABLE_VULNERABILITY_LEVEL}" == "Critical" \
					&& "${is_critical}" == "1" ]] ; then
					cat "${audit_file}"
					die \
"Detected critical vulnerability in a package."
				elif [[ \
"${ELECTRON_APP_UNACCEPTABLE_VULNERABILITY_LEVEL}" == "High" \
					&& ( "${is_high}" == "1" \
					|| "${is_critical}" == "1" ) ]] ; then
					cat "${audit_file}"
					die \
"Detected high vulnerability in a package."
				elif [[ \
"${ELECTRON_APP_UNACCEPTABLE_VULNERABILITY_LEVEL}" == "Moderate" \
					&& ( "${is_moderate}" == "1" \
					|| "${is_critical}" == "1" \
					|| "${is_high}" == "1" ) ]] ; then
					cat "${audit_file}"
					die \
"Detected moderate vulnerability in a package."
				elif [[ \
"${ELECTRON_APP_UNACCEPTABLE_VULNERABILITY_LEVEL}" == "Low" \
					&& ( "${is_low}" == "1" \
					|| "${is_critical}" == "1" \
					|| "${is_high}" == "1" \
					|| "${is_moderate}" == "1" ) ]] ; then
					cat "${audit_file}"
					die \
"Detected low vulnerability in a package."
				fi
			fi
		popd
	done
}


# @FUNCTION: electron-app_audit_prod
# @DESCRIPTION:
# This will preform an recursive audit for production in place without adding
# packages.
electron-app_audit_prod() {
	if [[ -n "${ELECTRON_APP_ALLOW_AUDIT}" \
		&& "${ELECTRON_APP_ALLOW_AUDIT}" == "1" ]] ; then
		:;
	else
		return
	fi

	[ ! -e package-lock.json ] \
		&& die "Missing package-lock.json in implied root $(pwd)"

	L=$(find . -name "package-lock.json")
	for l in $L; do
		pushd $(dirname $l) || die
		local audit_file="${T}"/npm-secaudit-result
		npm audit &> "${audit_file}" || true
		cat "${audit_file}" | grep -q -F -e "ELOCKVERIFY"
		if [[ "$?" != "0" ]] ; then
			cat "${audit_file}" \
				| grep -q -F -e "require manual review"
			local result_found1="$?"
			cat "${audit_file}" \
				| grep -q -F -e "npm audit fix"
			local result_found2="$?"
			if [[ "${result_found1}" == "0" \
				|| "${result_found2}" == "0" ]] ; then
				die "package is still vulnerable at $(pwd)$l"
			fi
		fi
		popd
	done
}

# @FUNCTION: electron-app_src_preinst_default
# @DESCRIPTION:
# Dummy function
electron-app_src_preinst_default() {
	true
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
		npm)
			local old_dotglob=$(shopt dotglob | cut -f 2)
			shopt -s dotglob # copy hidden files

			mkdir -p "${ed}"
			cp -a ${rel_src_path} "${ed}"

			if [[ "${old_dotglob}" == "on" ]] ; then
				shopt -s dotglob
			else
				shopt -u dotglob
			fi
			;;
		yarn)
			local old_dotglob=$(shopt dotglob | cut -f 2)
			shopt -s dotglob # copy hidden files

			mkdir -p "${ed}"
			cp -a ${rel_src_path} "${ed}"

			if [[ "${old_dotglob}" == "on" ]] ; then
				shopt -s dotglob
			else
				shopt -u dotglob
			fi
			;;
		*)
			die "Unsupported package system"
			;;
	esac
}

# @FUNCTION: electron-app_desktop_install_program
# @DESCRIPTION:
# Installs program only.  Resets permissions and ownership.
# Additional change of ownership and permissions should be done after running
# this.
electron-app_desktop_install_program() {
	use unpacked || return
	_electron-app_check_missing_install_path
	local rel_src_path="$1"
	local d="${ELECTRON_APP_INSTALL_PATH}"
	local ed="${ED}/${d}"
	case "$ELECTRON_APP_MODE" in
		npm)
			local old_dotglob=$(shopt dotglob | cut -f 2)
			shopt -s dotglob # copy hidden files

			insinto "${d}"
			doins -r ${rel_src_path}

			# Mark .bin scripts executable
			for dir_path in $(find "${ed}" -name ".bin" -type d) ; do
				for f in $(find "${dir_path}" ) ; do
					chmod 0755 $(realpath "${f}") || die
				done
			done

			# Mark libraries executable
			for f in $(find "${ed}" \
					-name "*.so" -type f \
					-o -name "*.so.*" -type f) ; do
				chmod 0755 $(realpath "${f}") || die
			done

			# Mark electron executable
			for f in $(find "${ed}" -path "*dist/electron" -type f) ; do
				chmod 0755 "${f}" || die
			done

			# Mark chrome parts executable
			for f in $(find "${ed}" -name "chrome-sandbox" -type f) ; do
				chmod 0755 "${f}" || die
			done

			if [[ "${old_dotglob}" == "on" ]] ; then
				shopt -s dotglob
			else
				shopt -u dotglob
			fi
			;;
		yarn)
			local old_dotglob=$(shopt dotglob | cut -f 2)
			shopt -s dotglob # copy hidden files

			insinto "${d}"
			doins -r ${rel_src_path}

			# Mark .bin scripts executable
			for dir_path in $(find "${ed}" -name ".bin" -type d) ; do
				for f in $(find "${dir_path}" ) ; do
					chmod 0755 $(realpath "${f}") || die
				done
			done

			# Mark libraries executable
			for f in $(find "${ed}" -name "*.so" -type f \
					-o -name "*.so.*" -type f) ; do
				chmod 0755 $(realpath "${f}") || die
			done

			# Mark electron executable
			for f in $(find "${ed}" -path "*dist/electron" -type f) ; do
				chmod 0755 "${f}" || die
			done

			if [[ "${old_dotglob}" == "on" ]] ; then
				shopt -s dotglob
			else
				shopt -u dotglob
			fi
			;;
		*)
			die "Unsupported package system"
			;;
	esac
}

# @FUNCTION: _electron-app_check_missing_install_path
# @DESCRIPTION:
# Checks to see if ELECTRON_APP_INSTALL_PATH has been defined.
_electron-app_check_missing_install_path() {
	if [[ -z "${ELECTRON_APP_INSTALL_PATH}" ]] ; then
		die \
"You must specify ELECTRON_APP_INSTALL_PATH.  Usually same location as\n\
/usr/\$(get_libdir)/node/\${PN}/\${SLOT} without \$ED"
	fi
}

# @FUNCTION: electron-app_store_jsons_for_security_audit
# @DESCRIPTION:
# Standardize the install location for .audit
electron-app_store_jsons_for_security_audit() {
	_electron-app_check_missing_install_path
	electron-app_store_package_jsons "${S}"
	export _ELECTRON_APP_REG_PATH="${ELECTRON_APP_INSTALL_PATH}/.audit"
	insinto "${_ELECTRON_APP_REG_PATH}"

	local old_dotglob=$(shopt dotglob | cut -f 2)
	shopt -s dotglob # copy hidden files

	doins -r "${T}/package_jsons"/*

	if [[ "${old_dotglob}" == "on" ]] ; then
		shopt -s dotglob
	else
		shopt -u dotglob
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
		die \
"You must provide 2nd arg to electron-app_desktop_install containing the\n\
relative icon path"
	fi

	if [[ -z "${cmd}" ]] ; then
		die \
"You must provide 5th arg to electron-app_desktop_install containing the\n\
command to execute in the wrapper script"
	fi

	if use unpacked ; then
		electron-app_desktop_install_program "${rel_src_path}"
		# Create wrapper
		exeinto "/usr/bin"
		echo "#!/bin/bash" > "${T}/${PN}"
		echo "${cmd}" >> "${T}/${PN}"
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
			ewarn \
"Only png, svg, xpm accepted as icons for the XDG desktop icon theme spec.  Skipping."
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

	electron-app_store_jsons_for_security_audit
}

# @FUNCTION: electron-app-register-x
# @DESCRIPTION:
# Adds the package to the electron database
# This function MUST be called in pkg_postinst.
electron-app-register-x() {
	if [[ -n "${ELECTRON_APP_REG_PATH}" ]] ; then
	die "ELECTRON_APP_REG_PATH has been removed and replaced with\n\
	ELECTRON_APP_INSTALL_PATH.  Please wait for the next ebuild update."
	fi
	[[ -z "${ELECTRON_APP_INSTALL_PATH}" ]] && die "ELECTRON_APP_INSTALL_PATH must be defined"
	while true ; do
		if mkdir "${ELECTRON_APP_LOCKS_DIR}/mutex-editing-pkg_db" 2>/dev/null ; then
			trap "rm -rf \"${ELECTRON_APP_LOCKS_DIR}/mutex-editing-pkg_db\"" EXIT
			local pkg_db="${1}"
			local path=${2:-""}
			local check_path
			if [[ "${path}" =~ ^/ ]] ; then
				# assumed absolute path
				check_path="${path}"
			else
				# relative path
				check_path=$(realpath "${ELECTRON_APP_INSTALL_PATH}/${path}")
			fi

			[[ -z "${check_path}" ]] && "check_path is empty.  Audits won't work"

			# format:
			# ${CATEGORY}/${P}	path_to_package
			addwrite "${pkg_db}"

			# remove existing entry
			touch "${pkg_db}"
			sed -i -r -e "s|${CATEGORY}/${PN}:${SLOT}\t.*||g" "${pkg_db}"

			echo -e "${CATEGORY}/${PN}:${SLOT}\t${check_path}" >> "${pkg_db}"

			# remove blank lines
			sed -i '/^$/d' "${pkg_db}"
			rm -rf "${ELECTRON_APP_LOCKS_DIR}/mutex-editing-pkg_db"
			break
		else
			einfo \
"Waiting for mutex to be released for electron-app's pkg_db.  If it takes too\n\
long (15 min), cancel all emerges and remove\n\
${ELECTRON_APP_LOCKS_DIR}/mutex-editing-pkg_db"
			sleep 15
		fi
	done
}

# @FUNCTION: electron-app-register-npm
# @DESCRIPTION:
# Adds the package to the electron database
# This function MUST be called in pkg_postinst.
electron-app-register-npm() {
	local path=${1:-""}
	electron-app-register-x "${NPM_PACKAGE_DB}" "${path}"
}

# @FUNCTION: electron-app-register-yarn
# @DESCRIPTION:
# Adds the package to the electron database
# This function MUST be called in pkg_postinst.
electron-app-register-yarn() {
	local path=${1:-""}
	electron-app-register-x "${YARN_PACKAGE_DB}" "${path}"
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
# Automatically registers an electron app package.
# Set _ELECTRON_APP_REG_PATH global to relative path (NOT starting with /)
# or absolute path (starting with /) to scan for vulnerabilities containing
# node_modules.
electron-app_pkg_postinst() {
        debug-print-function ${FUNCNAME} "${@}"

	if has snap ${IUSE_EFFECTIVE} ; then
		if use snap ; then
			ewarn "snap support untested"
			ewarn \
"Remember do not update the snap manually through the \`snap\` tool.  Allow \
the emerge system to update it."
			# I don't know if snap will sanitize the files for
			# system-wide installation.
			local has_assertion_file="--dangerous"
			if [[ -e "${ELECTRON_APP_SNAP_ASSERT_PATH}" ]] ; then
				snap ack \
"${EROOT}/${ELECTRON_APP_SNAP_INSTALL_DIR}/${ELECTRON_APP_SNAP_ASSERT_PATH_BASENAME}"
				has_assertion_file=""
			else
				ewarn \
"Missing assertion file for snap.  Installing with --dangerous."
			fi
			# This will add the desktop links to the snap.
			snap install ${has_assertion_file} \
"${EROOT}/${ELECTRON_APP_SNAP_INSTALL_DIR}/${ELECTRON_APP_SNAP_PATH_BASENAME}"
		fi
	fi

	case "$ELECTRON_APP_MODE" in
		npm)
			electron-app-register-npm "${_ELECTRON_APP_REG_PATH}"
			;;
		yarn)
			electron-app-register-yarn "${_ELECTRON_APP_REG_PATH}"
			;;
		*)
			die "Unsupported package system"
			;;
	esac
}

# @FUNCTION: electron-app_pkg_postrm
# @DESCRIPTION:
# Post-removal hook for Electron apps. Removes information required for security checks.
electron-app_pkg_postrm() {
        debug-print-function ${FUNCNAME} "${@}"

	case "${ELECTRON_APP_MODE}" in
		npm)
			while true ; do
				if mkdir "${ELECTRON_APP_LOCKS_DIR}/mutex-editing-pkg_db" 2>/dev/null ; then
					trap "rm -rf \"${ELECTRON_APP_LOCKS_DIR}/mutex-editing-pkg_db\"" EXIT
					sed -i -r -e "s|${CATEGORY}/${PN}:${SLOT}\t.*||g" "${NPM_PACKAGE_DB}"
					sed -i '/^$/d' "${NPM_PACKAGE_DB}"
					rm -rf "${ELECTRON_APP_LOCKS_DIR}/mutex-editing-pkg_db"
					break
				else
					einfo \
"Waiting for mutex to be released for electron-app's pkg_db for npm.  If it\n\
takes too long (15 min), cancel all emerges and remove\n\
${ELECTRON_APP_LOCKS_DIR}/mutex-editing-pkg_db"
					sleep 15
				fi
			done

			while true ; do
				if mkdir "${NPM_SECAUDIT_LOCKS_DIR}/mutex-editing-emerge-sets-db" 2>/dev/null ; then
					trap "rm -rf \"${NPM_SECAUDIT_LOCKS_DIR}/mutex-editing-emerge-sets-db\"" EXIT
					sed -i -r -e "s|${CATEGORY}/${PN}:${SLOT}\t.*||g" "${NPM_PACKAGE_SETS_DB}"
					sed -i '/^$/d' "${NPM_PACKAGE_SETS_DB}"
					rm -rf "${NPM_SECAUDIT_LOCKS_DIR}/mutex-editing-emerge-sets-db"
					break
				else
					einfo \
"Waiting for mutex to be released for npm-secaudit's emerge-sets-db.  If it\n\
takes too long (15 min), cancel all emerges and remove\n\
${NPM_SECAUDIT_LOCKS_DIR}/mutex-editing-emerge-sets-db"
					sleep 15
				fi
			done
			;;
		yarn)
			while true ; do
				if mkdir "${ELECTRON_APP_LOCKS_DIR}/mutex-editing-pkg_db" 2>/dev/null ; then
					trap "rm -rf \"${ELECTRON_APP_LOCKS_DIR}/mutex-editing-pkg_db\"" EXIT
					sed -i -r -e "s|${CATEGORY}/${PN}:${SLOT}\t.*||g" "${YARN_PACKAGE_DB}"
					sed -i '/^$/d' "${YARN_PACKAGE_DB}"
					rm -rf "${ELECTRON_APP_LOCKS_DIR}/mutex-editing-pkg_db"
					break
				else
					einfo \
"Waiting for mutex to be released for electron-app's pkg_db for yarn.  If it\n\
takes too long (15 min), cancel all emerges and remove\n\
${ELECTRON_APP_LOCKS_DIR}/mutex-editing-pkg_db"
					sleep 15
				fi
			done


			;;
		*)
			die "Unsupported package system"
			;;
	esac
}

# @FUNCTION: electron-app_store_package_jsons
# @DESCRIPTION: Saves the package-lock.json to T for auditing
electron-app_store_package_jsons() {
	einfo "Saving package-lock.json and npm-shrinkwrap.json for future audits"

	local old_dotglob=$(shopt dotglob | cut -f 2)
	shopt -s dotglob # copy hidden files

	local ROOTDIR="${1}"
	local d
	local rd
	local F=$(find ${ROOTDIR} -name "package-lock.json" \
		-o -name "npm-shrinkwrap.json" \
		-o -name "package.json" \
		-o -name "yarn.lock")
	local td="${T}/package_jsons/"
	for f in ${F}; do
		d=$(dirname ${f})
		rd=$(dirname $(echo "${f}" | sed -e "s|${ROOTDIR}||"))
		local temp_dest=$(realpath --canonicalize-missing "${td}/${rd}")
		mkdir -p "${temp_dest}"
		einfo "Copying ${f} to ${temp_dest}"
		cp -a "${f}" "${temp_dest}" || die
	done

	if [[ "${old_dotglob}" == "on" ]] ; then
		shopt -s dotglob
	else
		shopt -u dotglob
	fi
}

# @FUNCTION: electron-app_restore_package_jsons
# @DESCRIPTION: Restores the package-lock.json to T for auditing
electron-app_restore_package_jsons() {
	local dest="${1}"
	einfo "Restoring package-lock.json and npm-shrinkwrap.json to ${dest}"

	local old_dotglob=$(shopt dotglob | cut -f 2)
	shopt -s dotglob # copy hidden files

	local td="${T}/package_jsons"

	cp -a "${td}"/* "${dest}" || die

	if [[ "${old_dotglob}" == "on" ]] ; then
		shopt -s dotglob
	else
		shopt -u dotglob
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
			die "${CHOST} is not supported"
		fi
        elif [[ "${ARCH}" == "n64" ]] ; then
                echo "mips64el"
	else
		die "${ARCH} not supported"
        fi
}

# @FUNCTION: electron-app_get_arch_suffix_snap
# @DESCRIPTION: Gets the arch suffix found at the end of the archive
electron-app_get_arch_suffix_snap() {
	if [[ "${ARCH}" == "amd64" ]] ; then
                echo "amd64"
        elif [[ "${ARCH}" == "x86" ]] ; then
                echo "i386"
        elif [[ "${ARCH}" == "arm64" ]] ; then
                echo "arm64"
        elif [[ "${ARCH}" == "arm" ]] ; then
		if [[ "${CHOST}" =~ armv7* ]] ; then
	                echo "armhf"
		fi
        fi
	echo "${CHOST%%-*}"
}

# @FUNCTION: electron-app_get_arch_suffix_appimage
# @DESCRIPTION: Gets the arch suffix found at the end of the archive
electron-app_get_arch_suffix_appimage() {
	if [[ "${ARCH}" == "amd64" ]] ; then
                echo "x86_64"
        elif [[ "${ARCH}" == "x86" ]] ; then
                echo "i386"
        elif [[ "${ARCH}" == "arm64" ]] ; then
                echo "arm64"
        elif [[ "${ARCH}" == "arm" ]] ; then
		if [[ "${CHOST}" =~ armv7* ]] ; then
	                echo "armhf"
		fi
        fi
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
		local v_major=$(grep -r -e "NODE_MAJOR_VERSION" \
			"${T}/node_version.h" | head -n 1 | cut -f 3 -d " ")
		local v_minor=$(grep -r -e "NODE_MINOR_VERSION" \
			"${T}/node_version.h" | head -n 1 | cut -f 3 -d " ")
		local v_patch=$(grep -r -e "NODE_PATCH_VERSION" \
			"${T}/node_version.h" | head -n 1 | cut -f 3 -d " ")
		echo "${v_major}.${v_minor}.${v_patch}"
	fi
}
