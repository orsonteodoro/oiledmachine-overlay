# Copyright 1999-2019 Gentoo Foundation
# Copyright 2019 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: electron-app.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 4 5
# @BLURB: Eclass for Electron packages
# @DESCRIPTION:
# The electron-app eclass defines phase functions and utility functions for
# Electron app packages. It depends on the app-portage/npm-secaudit package to
# maintain a secure environment.

case "${EAPI:-0}" in
        0|1|2|3)
                die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
                ;;
        4|5|6)
                ;;
        *)
                die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
                ;;
esac

inherit desktop eutils

EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare src_compile pkg_postinst pkg_postrm

DEPEND+=" app-portage/npm-secaudit"
IUSE+=" debug"

NPM_PACKAGE_DB="/var/lib/portage/npm-packages"
ELECTRON_APP_REG_PATH=""

ELECTRON_APP_MODE="npm" # can be npm, yarn (not implemented yet)
ELECTRON_APP_NO_PRUNE=""

# @FUNCTION: _electron-app_fix_locks
# @DESCRIPTION:
# Restores ownership change caused by yarn
_electron-app_fix_locks() {
	local d="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}/npm"
	local f="_locks"
	local dt="${d}/${f}"
	if [ -d "${dt}" ] ; then
		local u=$(ls -l "${d}" | grep "${f}" | column -t | cut -f 5 -d ' ')
		local g=$(ls -l "${d}" | grep "${f}" | column -t | cut -f 7 -d ' ')
		if [[ "$u" == "root" && "$g" == "root" ]] ; then
			einfo "Restoring portage ownership on ${dt}"
			chown portage:portage -R "${dt}"
		fi
	fi
}

# @FUNCTION: _electron-app_fix_locks
# @DESCRIPTION:
# Restores ownership change caused by yarn
_electron-app_fix_yarn_access() {
	local d="${HOME}"
	local f=".config"
	local dt="${d}/${f}"
	if [ -d "${dt}" ] ; then
		local u=$(ls -l "${d}" | grep "${f}" | column -t | cut -f 5 -d ' ')
		local g=$(ls -l "${d}" | grep "${f}" | column -t | cut -f 7 -d ' ')
		if [[ "$u" == "root" && "$g" == "root" ]] ; then
			einfo "Restoring portage ownership on ${dt}"
			chown portage:portage -R "${dt}"
		fi
	fi
}

# @FUNCTION: electron-app_pkg_setup
# @DESCRIPTION:
# Initializes globals
electron-app_pkg_setup() {
        debug-print-function ${FUNCNAME} "${@}"

	case "$ELECTRON_APP_MODE" in
		npm)
			# Lame bug.  We cannot run `electron --version` because it requires X.
			# It is okay to emerge package outside of X without problems.
			export ELECTRON_VER=$(strings /usr/bin/electron | grep "%s Electron/" | sed -e "s|[%s A-Za-z/]||g")
			export ELECTRON_STORE_DIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}/npm"
			export npm_config_cache="${ELECTRON_STORE_DIR}"
			einfo "Electron version: ${ELECTRON_VER}"
			if [[ -z "${ELECTRON_VER}" ]] ; then
				echo "Some ebuilds may break.  Restart and run in X."
			fi

			_electron-app_fix_locks
			;;
		*)
			die "Unsupported package system"
			;;
	esac
}

# @FUNCTION: electron-app-fetch-deps-npm
# @DESCRIPTION:
# Fetches an Electron npm app with security checks
# MUST be called after default unpack AND patching.
electron-app-fetch-deps-npm()
{
	pushd "${S}"
	npm install || die
	if [[ ! -e package-lock.js ]] ; then
		einfo "Running \`npm i --package-lock\`"
		npm i --package-lock || die # prereq for command below
	fi
	einfo "Running \`npm audit fix --force\`"
	npm audit fix --force || die
	einfo "Auditing security done"
	popd
}

# @FUNCTION: electron-app-fetch-deps
# @DESCRIPTION:
# Fetches an electron app with security checks
# MUST be called after default unpack AND patching.
electron-app-fetch-deps() {
	_electron-app_fix_locks
	_electron-app_fix_yarn_access

	# todo handle yarn
	case "$ELECTRON_APP_MODE" in
		npm)
			electron-app-fetch-deps-npm
			;;
		*)
			die "Unsupported package system"
			;;
	esac
}

# @FUNCTION: electron-app_src_unpack
# @DESCRIPTION:
# Initializes cache folder and gets the archive
# without dependencies.  You MUST call
# npm-secaudit-fetch-deps manually.
electron-app_src_unpack() {
        debug-print-function ${FUNCNAME} "${@}"

	addwrite "${ELECTRON_STORE_DIR}"
	mkdir -p "${ELECTRON_STORE_DIR}"

	default_src_unpack
}

# @FUNCTION: electron-app_src_prepare
# @DESCRIPTION:
# Fetches dependencies
electron-app_src_prepare() {
        debug-print-function ${FUNCNAME} "${@}"

	default_src_prepare

	electron-app-fetch-deps
}

# @FUNCTION: electron-app-build-npm
# @DESCRIPTION:
# Builds an electron app with npm
electron-app-build-npm() {
	npm run build || die
}

# @FUNCTION: electron-app_src_compile
# @DESCRIPTION:
# Builds an electron app
electron-app_src_compile() {
        debug-print-function ${FUNCNAME} "${@}"

	case "$ELECTRON_APP_MODE" in
		npm)
			electron-app-build-npm
			;;
		*)
			die "Unsupported package system"
			;;
	esac
}

# @FUNCTION: electron-app-register
# @DESCRIPTION:
# Adds the package to the electron database
# This function MUST be called in pkg_postinst.
electron-app-register() {
	local rel_path=${1:-""}
	local check_path="/usr/$(get_libdir)/node/${PN}/${SLOT}/${rel_path}"
	# format:
	# ${CATEGORY}/${P}	path_to_package
	addwrite "${NPM_PACKAGE_DB}"

	# remove existing entry
	touch "${NPM_PACKAGE_DB}"
	sed -i -e "s|${CATEGORY}/${PN}:${SLOT}\t.*||g" "${NPM_PACKAGE_DB}"

	echo -e "${CATEGORY}/${PN}:${SLOT}\t${check_path}" >> "${NPM_PACKAGE_DB}"

	# remove blank lines
	sed -i '/^$/d' "${NPM_PACKAGE_DB}"
}

# @FUNCTION: electron-desktop-app-install
# @DESCRIPTION:
# Installs a desktop app.
electron-desktop-app-install() {
	local rel_src_path="$1"
	local rel_main_app_path="$2"
	local rel_icon_path="$3"
	local pkg_name="$4"
	local category="$5"

	shopt -s dotglob # copy hidden files

	case "$ELECTRON_APP_MODE" in
		npm)
			einfo "Running \`npm i --package-lock\`"
			npm i --package-lock || die # prereq for command below for bugged lockfiles

			einfo "Running \`npm audit fix --force\`"
			npm audit fix --force || die

			if ! use debug ; then
				if [[ "${ELECTRON_APP_NO_PRUNE}" == "0" ||
					"${ELECTRON_APP_NO_PRUNE}" == "false" ||
					"${ELECTRON_APP_NO_PRUNE}" == "FALSE" ]] ; then
					einfo "Running \`npm prune --production\`"
					npm prune --production
				fi
			fi

			mkdir -p "${D}/usr/$(get_libdir)/node/${PN}/${SLOT}"
			cp -a ${rel_src_path} "${D}/usr/$(get_libdir)/node/${PN}/${SLOT}"

			#create wrapper
			mkdir -p "${D}/usr/bin"
			echo "#!/bin/bash" > "${D}/usr/bin/${PN}"
			echo "/usr/bin/electron /usr/$(get_libdir)/node/${PN}/${SLOT}/${rel_main_app_path}" >> "${D}/usr/bin/${PN}"
			chmod +x "${D}"/usr/bin/${PN}
			;;
		*)
			die "Unsupported package system"
			;;
	esac

	newicon "${rel_icon_path}" "${PN}.png"
	make_desktop_entry ${PN} "${pkg_name}" ${PN} "${category}"
}

# @FUNCTION: electron-app_pkg_postinst
# @DESCRIPTION:
# Automatically registers an electron app package.
# Set ELECTRON_APP_REG_PATH global to relative path to
# scan for vulnerabilities containing node_modules.
electron-app_pkg_postinst() {
	electron-app-register "${ELECTRON_APP_REG_PATH}"
}

# @FUNCTION: electron-app_pkg_postrm
# @DESCRIPTION:
# Post-removal hook for Electron apps. Removes information required for security checks.
electron-app_pkg_postrm() {
        debug-print-function ${FUNCNAME} "${@}"

	case "$ELECTRON_APP_MODE" in
		npm)
			sed -i -e "s|${CATEGORY}/${PN}:${SLOT}\t.*||g" "${NPM_PACKAGE_DB}"
			;;
		*)
			die "Unsupported package system"
			;;
	esac
}
