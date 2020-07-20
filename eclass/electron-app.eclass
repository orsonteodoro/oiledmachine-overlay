# Copyright 2019-2020 Orson Teodoro
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: electron-app.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 4 5
# @BLURB: Eclass for GUI based Electron packages
# @DESCRIPTION:
# The electron-app eclass defines phase functions and utility functions for
# Electron app packages. It depends on the app-portage/npm-secaudit package to
# maintain a secure environment.

case "${EAPI:-0}" in
        0|1|2|3|4|5|6)
                die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
                ;;
        7)
                ;;
        *)
                die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
                ;;
esac

inherit desktop eutils npm-utils

ELECTRON_APP_ALLOW_NON_LTS_ELECTRON=${ELECTRON_APP_ALLOW_NON_LTS_ELECTRON:="0"} # You could define it as a per-package envar.  It not recommended in the ebuild.

# LTS versions: https://www.electronjs.org/docs/tutorial/support
# Currently 9.x, 8.x, 7.x

# Check the runtime dependencies for electron
# Most electron apps will have electron bundled already.  No need for seperate ebuild.

# See https://www.electronjs.org/docs/development/build-instructions-linux
# Obtained from ldd
COMMON_DEPEND="
	  app-accessibility/at-spi2-atk:2=
	  app-arch/bzip2:=
	  dev-libs/atk:=
	  dev-libs/expat:=
	  dev-libs/fribidi:=
	  dev-libs/glib:2
	  dev-libs/gmp:=
	  dev-libs/libffi
	  dev-libs/libtasn1:=
	  dev-libs/libbsd:=
	  dev-libs/libpcre:=
	  dev-libs/libunistring:=
	  dev-libs/nss:=
	  dev-libs/nettle:=
	  dev-libs/nspr:=
	  media-gfx/graphite2:=
	  media-libs/alsa-lib:=
	  media-libs/fontconfig:=
	  media-libs/freetype:=
	  media-libs/harfbuzz:=[icu(-)]
	  media-libs/libepoxy:=
	  media-libs/libpng:=
	  media-libs/mesa:=[egl,gbm]
	  media-video/ffmpeg:=
	  net-dns/libidn2:=
	  net-libs/gnutls:=
	  net-print/cups:=
	  sys-apps/dbus:=
	  sys-apps/util-linux:=
	  sys-devel/gcc:=
	  sys-libs/zlib:=[minizip]
	  virtual/ttf-fonts
	  x11-libs/cairo:=
	  x11-libs/gdk-pixbuf:2=
	  x11-libs/gtk+:3[X]
	  x11-libs/libX11:=
	  x11-libs/libXScrnSaver:=
	  x11-libs/libXau:=
	  x11-libs/libXcomposite:=
	  x11-libs/libXcursor:=
	  x11-libs/libXdamage:=
	  x11-libs/libXdmcp:=
	  x11-libs/libXext:=
	  x11-libs/libXfixes:=
	  x11-libs/libXi:=
	  x11-libs/libXrandr:=
	  x11-libs/libXrender:=
	  x11-libs/libXtst:=
	  x11-libs/libXxf86vm:=
	  x11-libs/libdrm:=
	  x11-libs/libxcb:=
	  x11-libs/libxshmfence:=
	  x11-libs/pango:=
	  x11-libs/pixman:=
"
if [[ -n "${ELECTRON_APP_ELECTRON_V}" ]] && ver_test $(ver_cut 1-2 "${ELECTRON_APP_ELECTRON_V}") -ge 9.0 ; then
:; # series supported upstream
elif [[ -n "${ELECTRON_APP_ELECTRON_V}" ]] && ver_test $(ver_cut 1-2 "${ELECTRON_APP_ELECTRON_V}") -ge 8.0 ; then
:; # series supported upstream
elif [[ -n "${ELECTRON_APP_ELECTRON_V}" ]] && ver_test $(ver_cut 1-2 "${ELECTRON_APP_ELECTRON_V}") -ge 7.0 ; then
:; # series supported upstream
else
if [[ "${ELECTRON_APP_ALLOW_NON_LTS_ELECTRON}" == "0" ]] ; then
die "Electron should be updated one of the latest Long Term Support (LTS) series versions or else it likely contains critical CVE security advisories."
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
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_ANGULAR_V}") -le 9999 ) ; then
COMMON_DEPEND+="
	>=net-libs/nodejs-10.9.0
	<net-libs/nodejs-13
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
	ver_test $(ver_cut 1-2 "${ELECTRON_APP_REACT_V}") -ge 15 \
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
elif [[ -n "${ELECTRON_APP_REACT_V}" ]] \
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_REACT_V}") -eq 9999 ; then
COMMON_DEPEND+="
	>=net-libs/nodejs-8
	<net-libs/nodejs-15
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
	&& ver_test $(ver_cut 1 "${ELECTRON_APP_REACT_NATIVE_V}") -le 9999 ) ; then
COMMON_DEPEND+="
	>=net-libs/nodejs-10
"
fi


# See https://github.com/DefinitelyTyped/DefinitelyTyped/blob/master/types/node/v8/index.d.ts
# For @types/node
if [[ -n "${ELECTRON_APP_AT_TYPES_NODE_V}" ]] \
	ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_V}") -eq 0 ; then
COMMON_DEPEND+=" =net-libs/nodejs-0*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_V}" ]] \
	ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_V}") -eq 4 ; then
COMMON_DEPEND+=" =net-libs/nodejs-4*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_V}" ]] \
	ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_V}") -eq 6 ; then
COMMON_DEPEND+=" =net-libs/nodejs-6*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_V}" ]] \
	ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_V}") -eq 7 ; then
COMMON_DEPEND+=" =net-libs/nodejs-7*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_V}" ]] \
	ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_V}") -eq 8 ; then
COMMON_DEPEND+=" =net-libs/nodejs-8*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_V}" ]] \
	ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_V}") -eq 9 ; then
COMMON_DEPEND+=" =net-libs/nodejs-9*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_V}" ]] \
	ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_V}") -eq 10 ; then
COMMON_DEPEND+=" =net-libs/nodejs-10*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_V}" ]] \
	ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_V}") -eq 11 ; then
COMMON_DEPEND+=" =net-libs/nodejs-11*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_V}" ]] \
	ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_V}") -eq 12 ; then
COMMON_DEPEND+=" =net-libs/nodejs-12*"
elif [[ -n "${ELECTRON_APP_AT_TYPES_NODE_V}" ]] \
	ver_test $(ver_cut 1 "${ELECTRON_APP_AT_TYPES_NODE_V}") -eq 13 ; then
COMMON_DEPEND+=" =net-libs/nodejs-13*"
fi

# Same packages as far back as 3.x
RDEPEND+=" ${COMMON_DEPEND}"
DEPEND+=" ${COMMON_DEPEND}"

EXPORT_FUNCTIONS pkg_setup src_unpack pkg_postinst pkg_postrm

DEPEND+=" app-portage/npm-secaudit"
IUSE+=" debug"

NPM_PACKAGE_DB="/var/lib/portage/npm-packages"
NPM_PACKAGE_SETS_DB="/etc/portage/sets/npm-security-update"
YARN_PACKAGE_DB="/var/lib/portage/yarn-packages"
ELECTRON_APP_REG_PATH=${ELECTRON_APP_REG_PATH:=""}
ELECTRON_APP_MODE=${ELECTRON_APP_MODE:="npm"} # can be npm, yarn
ELECTRON_APP_MAXSOCKETS=${ELECTRON_APP_MAXSOCKETS:="1"} # Set this in your make.conf to control number of HTTP requests.  50 is npm default but it is too high.
ELECTRON_APP_ALLOW_AUDIT=${ELECTRON_APP_ALLOW_AUDIT:="1"} # You could define it as a per-package envar.  It not recommended in the ebuild.
ELECTRON_APP_ALLOW_AUDIT_FIX=${ELECTRON_APP_ALLOW_AUDIT_FIX:="1"} # You could define it as a per-package envar.  It not recommended in the ebuild.
ELECTRON_APP_NO_DIE_ON_AUDIT=${ELECTRON_APP_NO_DIE_ON_AUDIT:="0"} # You could define it as a per-package envar.  It not recommended in the ebuild.
ELECTRON_APP_LOCKS_DIR="/dev/shm"
NPM_SECAUDIT_LOCKS_DIR="/dev/shm"

# @FUNCTION: _electron-app-flakey-check
# @DESCRIPTION:
# Warns user that download or building can fail randomly
_electron-app-flakey-check() {
	local l=$(find "${S}" -name "package.json")
	grep -e "electron-builder" $l >/dev/null
	if [[ "$?" == "0" ]] ; then
		ewarn "This ebuild may fail when building with electron-builder.  Re-emerge if it fails."
	fi

	grep -e "\"electron\":" $l >/dev/null
	if [[ "$?" == "0" ]] ; then
		ewarn "This ebuild may fail when downloading Electron as a dependency.  Re-emerge if it fails."
	fi
}

# @FUNCTION: electron-app_audit_fix_npm
# @DESCRIPTION:
# Removes vulnerable packages.  It will audit every folder containing a package-lock.json
electron-app_audit_fix_npm() {
	if [[ -n "${ELECTRON_APP_ALLOW_AUDIT_FIX}" && "${ELECTRON_APP_ALLOW_AUDIT_FIX}" == "1" ]] ; then
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
	if [[ -n "${ELECTRON_APP_ALLOW_AUDIT_FIX}" && "${ELECTRON_APP_ALLOW_AUDIT_FIX}" == "1" ]] ; then
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
			ewarn "No audit fix implemented in yarn.  Package may be likely vulnerable."
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

	if has network-sandbox $FEATURES ; then
		die \
"FEATURES=\"-network-sandbox\" must be added per-package env to be able to\n\
download micropackages."
	fi

	#export ELECTRON_VER=$(strings /usr/bin/electron | grep "%s Electron/" | sed -e "s|[%s A-Za-z/]||g")
	export NPM_STORE_DIR="${HOME}/npm"
	export YARN_STORE_DIR="${HOME}/yarn"
	export npm_config_maxsockets=${ELECTRON_APP_MAXSOCKETS}

	case "$ELECTRON_APP_MODE" in
		npm)
			# Lame bug.  We cannot run `electron --version` because it requires X.
			# It is okay to emerge package outside of X without problems.
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
}

# @FUNCTION: electron-app_fetch_deps_npm
# @DESCRIPTION:
# Fetches an Electron npm app with security checks
# MUST be called after default unpack AND patching.
electron-app_fetch_deps_npm() {
	_electron-app-flakey-check

	pushd "${S}" || die
		einfo "Running npm install inside electron-app_fetch_deps_npm"
		npm install || die
	popd
}

# @FUNCTION: electron-app_fetch_deps_yarn
# @DESCRIPTION:
# Fetches an Electron yarn app with security checks
# MUST be called after default unpack AND patching.
electron-app_fetch_deps_yarn() {
	pushd "${S}" || die
		export FAKEROOTKEY="15574641" # don't check /usr/local/share/.yarnrc .  same number used in their testing.

		# set global dir
		cp "${S}"/.yarnrc{,.orig}
		echo "prefix \"${S}/.yarn\"" >> "${S}/.yarnrc" || die
		echo "global-folder \"${S}/.yarn\"" >> "${S}/.yarnrc" || die
		echo "offline-cache-mirror \"${YARN_STORE_DIR}/offline\"" >> "${S}/.yarnrc" || die

		mkdir -p "${S}/.yarn"
		einfo "yarn prefix: $(yarn config get prefix)"
		einfo "yarn global-folder: $(yarn config get global-folder)"
		einfo "yarn offline-cache-mirror: $(yarn config get offline-cache-mirror)"

		yarn install --network-concurrency ${ELECTRON_APP_MAXSOCKETS} --verbose || die
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

# @FUNCTION: electron-app_src_unpack
# @DESCRIPTION:
# Unpacks sources
electron-app_src_unpack() {
        debug-print-function ${FUNCNAME} "${@}"

	cd "${WORKDIR}"

	default_src_unpack

	# all the phase hooks get run in unpack because of download restrictions

	cd "${S}"
	if declare -f electron-app_src_preprepare > /dev/null ; then
		electron-app_src_preprepare
	fi

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

	# audit before possibly bundling a vulnerable package
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
	if declare -f electron-app_src_preinst > /dev/null ; then
		electron-app_src_preinst
	else
		electron-app_src_preinst_default
	fi
}

# @FUNCTION: electron-app_src_prepare_default
# @DESCRIPTION:
# Fetches dependencies and audit fixes them.  Currently a stub.  TODO per package patching support.
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
	if [[ -n "${ELECTRON_APP_ALLOW_AUDIT}" && "${ELECTRON_APP_ALLOW_AUDIT}" == "1" ]] ; then
		:;
	else
		return
	fi

	local nodie="${1}"
	[ ! -e package-lock.json ] && die "Missing package-lock.json in implied root $(pwd)"

	L=$(find . -name "package-lock.json")
	for l in $L; do
		pushd $(dirname $l) || die
			if [[ -n "${nodie}" && "${ELECTRON_APP_NO_DIE_ON_AUDIT}" == "1" ]] ; then
				npm audit
			else
				npm audit || die
			fi
		popd
	done
}


# @FUNCTION: electron-app_audit_prod
# @DESCRIPTION:
# This will preform an recursive audit for production in place without adding packages.
electron-app_audit_prod() {
	if [[ -n "${ELECTRON_APP_ALLOW_AUDIT}" && "${ELECTRON_APP_ALLOW_AUDIT}" == "1" ]] ; then
		:;
	else
		return
	fi

	[ ! -e package-lock.json ] && die "Missing package-lock.json in implied root $(pwd)"

	L=$(find . -name "package-lock.json")
	for l in $L; do
		pushd $(dirname $l) || die
		local audit_file="${T}"/npm-secaudit-result
		npm audit &> "${audit_file}"
		cat "${audit_file}" | grep "ELOCKVERIFY" >/dev/null
		if [[ "$?" != "0" ]] ; then
			cat "${audit_file}" | grep "require manual review" >/dev/null
			local result_found1="$?"
			cat "${audit_file}" | grep "npm audit fix" >/dev/null
			local result_found2="$?"
			if [[ "${result_found1}" == "0" || "${result_found2}" == "0" ]] ; then
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

# @FUNCTION: electron-app_desktop_install
# @DESCRIPTION:
# Installs a desktop app with wrapper and desktop menu entry.
electron-app_desktop_install() {
	local rel_src_path="$1"
	local rel_icon_path="$2"
	local pkg_name="$3"
	local category="$4"
	local cmd="$5"

	case "$ELECTRON_APP_MODE" in
		npm)
			local old_dotglob=$(shopt dotglob | cut -f 2)
			shopt -s dotglob # copy hidden files

			mkdir -p "${D}/usr/$(get_libdir)/node/${PN}/${SLOT}"
			cp -a ${rel_src_path} "${D}/usr/$(get_libdir)/node/${PN}/${SLOT}"

			if [[ "${old_dotglob}" == "on" ]] ; then
				shopt -s dotglob
			else
				shopt -u dotglob
			fi
			;;
		yarn)
			local old_dotglob=$(shopt dotglob | cut -f 2)
			shopt -s dotglob # copy hidden files

			mkdir -p "${D}/usr/$(get_libdir)/node/${PN}/${SLOT}"
			cp -a ${rel_src_path} "${D}/usr/$(get_libdir)/node/${PN}/${SLOT}"

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

	# Create wrapper
	exeinto "/usr/bin"
	echo "#!/bin/bash" > "${T}/${PN}"
	echo "${cmd}" >> "${T}/${PN}"
	doexe "${T}/${PN}"

	newicon "${rel_icon_path}" "${PN}.png"
	make_desktop_entry ${PN} "${pkg_name}" ${PN} "${category}"
}

# @FUNCTION: electron-app-register-x
# @DESCRIPTION:
# Adds the package to the electron database
# This function MUST be called in pkg_postinst.
electron-app-register-x() {
	while true ; do
		if mkdir "${ELECTRON_APP_LOCKS_DIR}/mutex-editing-pkg_db" 2>/dev/null ; then
			trap "rm -rf \"${ELECTRON_APP_LOCKS_DIR}/mutex-editing-pkg_db\"" EXIT
			local pkg_db="${1}"
			local rel_path=${2:-""}
			local check_path="/usr/$(get_libdir)/node/${PN}/${SLOT}/${rel_path}"
			# format:
			# ${CATEGORY}/${P}	path_to_package
			addwrite "${pkg_db}"

			# remove existing entry
			touch "${pkg_db}"
			sed -i -e "s|${CATEGORY}/${PN}:${SLOT}\t.*||g" "${pkg_db}"

			echo -e "${CATEGORY}/${PN}:${SLOT}\t${check_path}" >> "${pkg_db}"

			# remove blank lines
			sed -i '/^$/d' "${pkg_db}"
			rm -rf "${ELECTRON_APP_LOCKS_DIR}/mutex-editing-pkg_db"
			break
		else
			einfo "Waiting for mutex to be released for electron-app's pkg_db.  If it takes too long (15 min), cancel all emerges and remove ${ELECTRON_APP_LOCKS_DIR}/mutex-editing-pkg_db"
			sleep 15
		fi
	done
}

# @FUNCTION: electron-app-register-npm
# @DESCRIPTION:
# Adds the package to the electron database
# This function MUST be called in pkg_postinst.
electron-app-register-npm() {
	local rel_path=${1:-""}
	electron-app-register-x "${NPM_PACKAGE_DB}" "${rel_path}"
}

# @FUNCTION: electron-app-register-yarn
# @DESCRIPTION:
# Adds the package to the electron database
# This function MUST be called in pkg_postinst.
electron-app-register-yarn() {
	local rel_path=${1:-""}
	electron-app-register-x "${YARN_PACKAGE_DB}" "${rel_path}"
}

# @FUNCTION: electron-app_pkg_postinst
# @DESCRIPTION:
# Automatically registers an electron app package.
# Set ELECTRON_APP_REG_PATH global to relative path to
# scan for vulnerabilities containing node_modules.
electron-app_pkg_postinst() {
        debug-print-function ${FUNCNAME} "${@}"

	case "$ELECTRON_APP_MODE" in
		npm)
			electron-app-register-npm "${ELECTRON_APP_REG_PATH}"
			;;
		yarn)
			electron-app-register-yarn "${ELECTRON_APP_REG_PATH}"
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
					sed -i -e "s|${CATEGORY}/${PN}:${SLOT}\t.*||g" "${NPM_PACKAGE_DB}"
					sed -i '/^$/d' "${NPM_PACKAGE_DB}"
					rm -rf "${ELECTRON_APP_LOCKS_DIR}/mutex-editing-pkg_db"
					break
				else
					einfo "Waiting for mutex to be released for electron-app's pkg_db for npm.  If it takes too long (15 min), cancel all emerges and remove ${ELECTRON_APP_LOCKS_DIR}/mutex-editing-pkg_db"
					sleep 15
				fi
			done

			while true ; do
				if mkdir "${NPM_SECAUDIT_LOCKS_DIR}/mutex-editing-emerge-sets-db" 2>/dev/null ; then
					trap "rm -rf \"${NPM_SECAUDIT_LOCKS_DIR}/mutex-editing-emerge-sets-db\"" EXIT
					sed -i -e "s|${CATEGORY}/${PN}:${SLOT}\t.*||g" "${NPM_PACKAGE_SETS_DB}"
					sed -i '/^$/d' "${NPM_PACKAGE_SETS_DB}"
					rm -rf "${NPM_SECAUDIT_LOCKS_DIR}/mutex-editing-emerge-sets-db"
					break
				else
					einfo "Waiting for mutex to be released for npm-secaudit's emerge-sets-db.  If it takes too long (15 min), cancel all emerges and remove ${NPM_SECAUDIT_LOCKS_DIR}/mutex-editing-emerge-sets-db"
					sleep 15
				fi
			done
			;;
		yarn)
			while true ; do
				if mkdir "${ELECTRON_APP_LOCKS_DIR}/mutex-editing-pkg_db" 2>/dev/null ; then
					trap "rm -rf \"${ELECTRON_APP_LOCKS_DIR}/mutex-editing-pkg_db\"" EXIT
					sed -i -e "s|${CATEGORY}/${PN}:${SLOT}\t.*||g" "${YARN_PACKAGE_DB}"
					sed -i '/^$/d' "${YARN_PACKAGE_DB}"
					rm -rf "${ELECTRON_APP_LOCKS_DIR}/mutex-editing-pkg_db"
					break
				else
					einfo "Waiting for mutex to be released for electron-app's pkg_db for yarn.  If it takes too long (15 min), cancel all emerges and remove ${ELECTRON_APP_LOCKS_DIR}/mutex-editing-pkg_db"
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
# @DESCRIPTION: Saves the package{,-lock}.json to T for auditing
electron-app_store_package_jsons() {
	einfo "Saving package.json and package-lock.json for future audits ..."

	local old_dotglob=$(shopt dotglob | cut -f 2)
	shopt -s dotglob # copy hidden files

	local ROOTDIR="${1}"
	local d
	local rd
	local F=$(find ${ROOTDIR} -name "package*.json*" -o -name "yarn.lock")
	local td="${T}/package_jsons/"
	for f in $F; do
		d=$(dirname $f)
		rd=$(dirname $(echo "${f}" | sed -e "s|${ROOTDIR}||"))
		mkdir -p "${td}/${rd}"
		einfo "Copying $f to ${td}/${rd}"
		cp -a "${f}" "${td}/${rd}" || die
	done

	if [[ "${old_dotglob}" == "on" ]] ; then
		shopt -s dotglob
	else
		shopt -u dotglob
	fi
}

# @FUNCTION: electron-app_restore_package_jsons
# @DESCRIPTION: Restores the package{,-lock}.json to T for auditing
electron-app_restore_package_jsons() {
	local dest="${1}"
	einfo "Restoring package.jsons to ${dest} ..."

	local old_dotglob=$(shopt dotglob | cut -f 2)
	shopt -s dotglob # copy hidden files

	local td="${T}/package_jsons/${rd}"

	cp -a "${td}"/* "${dest}" || die

	if [[ "${old_dotglob}" == "on" ]] ; then
		shopt -s dotglob
	else
		shopt -u dotglob
	fi
}
