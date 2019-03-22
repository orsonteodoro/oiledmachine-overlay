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
YARN_PACKAGE_DB="/var/lib/portage/yarn-packages"
ELECTRON_APP_REG_PATH=""

ELECTRON_APP_MODE=${ELECTRON_APP_MODE:="npm"} # can be npm, yarn
ELECTRON_APP_PRUNE=${ELECTRON_APP_PRUNE:="1"}
ELECTRON_APP_INSTALL_AUDIT=${ELECTRON_APP_INSTALL_AUDIT:="1"}
ELECTRON_APP_MAXSOCKETS=${ELECTRON_APP_MAXSOCKETS:="5"} # Set this in your make.conf to control number of HTTP requests.  50 is npm default but it is too high.

# @FUNCTION: _electron-app_fix_locks
# @DESCRIPTION:
# Restores ownership change caused by yarn
_electron-app_fix_locks() {
	local d="${NPM_STORE_DIR}"
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

# @FUNCTION: _electron-app_fix_logs
# @DESCRIPTION:
# Restores ownership change to logs
_electron-app_fix_logs() {
	local d="${NPM_STORE_DIR}"
	local f="_logs"
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

# @FUNCTION: _electron-app_fix_yarn_access
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

# @FUNCTION: _electron-app_fix_cacache_access
# @DESCRIPTION:
# Restores ownership change on cacache
_electron-app_fix_cacache_access() {
	local d="${NPM_STORE_DIR}"
	local f="_cacache"
	local dt="${d}/${f}"
	if [ -d "${dt}" ] ; then
		local u=$(ls -l "${d}" | grep "${f}" | column -t | cut -f 5 -d ' ')
		local g=$(ls -l "${d}" | grep "${f}" | column -t | cut -f 7 -d ' ')
		einfo "Restoring portage ownership on ${dt}"
		chown portage:portage -R "${dt}"
	fi
}

# @FUNCTION: _electron-app_fix_index-v5_access
# @DESCRIPTION:
# Restores ownership change on cacache
_electron-app_fix_index-v5_access() {
	local d="${NPM_STORE_DIR}"
	local f="index-v5"
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

# @FUNCTION: _electron-app-flakey-check
# @DESCRIPTION:
# Warns user that download or building can fail randomly
_electron-app-flakey-check() {
	local l=$(find "${S}" -name "package.json")
	grep -r -e "electron-builder" $l >/dev/null
	if [[ "$?" == "0" ]] ; then
		ewarn "This ebuild may fail when building with electron-builder.  Re-emerge if it fails."
	fi

	grep -r -e "\"electron\":" $l >/dev/null
	if [[ "$?" == "0" ]] ; then
		ewarn "This ebuild may fail when downloading Electron as a dependency.  Re-emerge if it fails."
	fi
}

_electron-app-audit-fix-npm() {
	if [[ "${ELECTRON_APP_INSTALL_AUDIT}" == "1" ||
		"${ELECTRON_APP_INSTALL_AUDIT}" == "true" ||
		"${ELECTRON_APP_INSTALL_AUDIT}" == "TRUE" ]] ; then
		einfo "Running \`npm i --package-lock\`"
		npm i --package-lock || die # prereq for command below

		einfo "Running \`npm audit fix --force\`"
		npm audit fix --force --maxsockets=${ELECTRON_APP_MAXSOCKETS} || die
		einfo "Auditing security done"
	fi
}

# @FUNCTION: electron-app_pkg_setup
# @DESCRIPTION:
# Initializes globals
electron-app_pkg_setup() {
        debug-print-function ${FUNCNAME} "${@}"

	export ELECTRON_VER=$(strings /usr/bin/electron | grep "%s Electron/" | sed -e "s|[%s A-Za-z/]||g")
	export NPM_STORE_DIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}/npm"
	export YARN_STORE_DIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}/yarn"

	case "$ELECTRON_APP_MODE" in
		npm)
			# Lame bug.  We cannot run `electron --version` because it requires X.
			# It is okay to emerge package outside of X without problems.
			export npm_config_cache="${NPM_STORE_DIR}"
			einfo "Electron version: ${ELECTRON_VER}"
			if [[ -z "${ELECTRON_VER}" ]] ; then
				echo "Some ebuilds may break.  Restart and run in X."
			fi

			addwrite "${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
			mkdir -p "${NPM_STORE_DIR}/offline"

			# Some npm package.json use yarn.
			addwrite ${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
			mkdir -p ${YARN_STORE_DIR}/offline
			export YARN_CACHE_FOLDER=${YARN_CACHE_FOLDER:=${YARN_STORE_DIR}}

			_electron-app_fix_locks
			_electron-app_fix_logs
			_electron-app_fix_cacache_access
			_electron-app_fix_index-v5_access
			;;
		yarn)
			ewarn "Using yarn mode which has no audit fix yet."

			# Some npm package.json use yarn.
			addwrite ${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
			mkdir -p ${YARN_STORE_DIR}/offline
			export YARN_CACHE_FOLDER=${YARN_CACHE_FOLDER:=${YARN_STORE_DIR}}
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
	_electron-app-flakey-check

	pushd "${S}"
	npm install --maxsockets=${ELECTRON_APP_MAXSOCKETS} || die
	_electron-app-audit-fix-npm
	popd
}

# @FUNCTION: electron-app-fetch-deps-yarn
# @DESCRIPTION:
# Fetches an Electron yarn app with security checks
# MUST be called after default unpack AND patching.
electron-app-fetch-deps-yarn()
{
	pushd "${S}"
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

# @FUNCTION: electron-app-fetch-deps
# @DESCRIPTION:
# Fetches an electron app with security checks
# MUST be called after default unpack AND patching.
electron-app-fetch-deps() {
	_electron-app_fix_yarn_access

	# todo handle yarn
	case "$ELECTRON_APP_MODE" in
		npm)
			_electron-app_fix_locks
			electron-app-fetch-deps-npm
			;;
		yarn)
			electron-app-fetch-deps-yarn
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
	# electron-builder can still pull packages at the build step.
	npm run build --maxsockets=${ELECTRON_APP_MAXSOCKETS} || die
}

# @FUNCTION: electron-app-build-yarn
# @DESCRIPTION:
# Builds an electron app with yarn
electron-app-build-yarn() {
	yarn run build || die
}

# @FUNCTION: electron-app_src_compile
# @DESCRIPTION:
# Builds an electron app.
electron-app_src_compile() {
        debug-print-function ${FUNCNAME} "${@}"

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

# @FUNCTION: electron-desktop-app-install
# @DESCRIPTION:
# Installs a desktop app with wrapper and desktop menu entry.
# A user can define electron-app_fix_prune to reinstall dependencies
# caused by breakage by pruning or auditing.
electron-desktop-app-install() {
	local rel_src_path="$1"
	local rel_icon_path="$2"
	local pkg_name="$3"
	local category="$4"
	local cmd="$5"

	case "$ELECTRON_APP_MODE" in
		npm)
			_electron-app-audit-fix-npm

			if ! use debug ; then
				if [[ "${ELECTRON_APP_PRUNE}" == "1" ||
					"${ELECTRON_APP_PRUNE}" == "true" ||
					"${ELECTRON_APP_PRUNE}" == "TRUE" ]] ; then
					einfo "Running \`npm prune --production\`"
					npm prune --production
				fi
			fi

			if declare -f electron-app_fix_prune > /dev/null ; then
				electron-app_fix_prune
			fi

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
			if ! use debug ; then
				if [[ "${ELECTRON_APP_PRUNE}" == "1" ||
					"${ELECTRON_APP_PRUNE}" == "true" ||
					"${ELECTRON_APP_PRUNE}" == "TRUE" ]] ; then
					einfo "Running \`yarn install --production --ignore-scripts --prefer-offline\`"
					yarn install --production --ignore-scripts --prefer-offline
				fi
			fi

			cp "${S}"/.yarnrc{,.orig}
			echo "global-folder \"/usr/$(get_libdir)/node/${PN}/${SLOT}/.yarn\"" >> "${S}/.yarnrc" || die
			echo "prefix \"/usr/$(get_libdir)/node/${PN}/${SLOT}/.yarn\"" >> "${S}/.yarnrc" || die

			# todo final audit

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
	mkdir -p "${D}/usr/bin"
	echo "#!/bin/bash" > "${D}/usr/bin/${PN}"
	echo "${cmd}" >> "${D}/usr/bin/${PN}"
	chmod +x "${D}"/usr/bin/${PN}

	newicon "${rel_icon_path}" "${PN}.png"
	make_desktop_entry ${PN} "${pkg_name}" ${PN} "${category}"
}

# @FUNCTION: electron-app-register-x
# @DESCRIPTION:
# Adds the package to the electron database
# This function MUST be called in pkg_postinst.
electron-app-register-x() {
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

	case "$ELECTRON_APP_MODE" in
		npm)
			sed -i -e "s|${CATEGORY}/${PN}:${SLOT}\t.*||g" "${NPM_PACKAGE_DB}"
			sed -i '/^$/d' "${NPM_PACKAGE_DB}"
			;;
		yarn)
			sed -i -e "s|${CATEGORY}/${PN}:${SLOT}\t.*||g" "${YARN_PACKAGE_DB}"
			sed -i '/^$/d' "${YARN_PACKAGE_DB}"
			;;
		*)
			die "Unsupported package system"
			;;
	esac
}
