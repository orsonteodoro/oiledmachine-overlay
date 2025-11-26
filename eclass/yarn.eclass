# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: yarn.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for yarn offline install
# @DESCRIPTION:
# Eclass similar to the cargo.eclass.

# For additional slot availability send issue request.

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

# Requirements:  yarn.lock or package.json -> package-lock.json -> yarn.lock
# For the URI generator, see the scripts/yarn_updater_transform_uris.sh and
# yarn_updater_update_locks.sh scripts.

# For package.json -> yarn.lock:
# (The network-sandbox needs to be disabled temporarily.)
# npm install            # or use npm install --prod
# npm audit fix
# yarn import

# When creating a lockfile, one of the dev dependencies may have vanished.
# If it fails with:
#
#   error Failed to import from package-lock.json, source file(s) corrupted
#
# Try with `npm install --prod` to generate the lockfile.

# The yarn.lock must be regenerated for security updates every week.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z "${_YARN_ECLASS}" ]]; then
_YARN_ECLASS=1

inherit edo node

# @ECLASS_VARIABLE: _YARN_PKG_SETUP_CALLED
# @INTERNAL
# @DESCRIPTION:
# Checks if state variables are initalized and network sandbox disabled.
_YARN_PKG_SETUP_CALLED=0

EXPORT_FUNCTIONS pkg_setup src_unpack src_compile src_test src_install

BDEPEND+="
	app-misc/jq
"
if [[ -n "${YARN_SLOT}" ]] ; then
	BDEPEND+="
		sys-apps/yarn:${YARN_SLOT}
	"
else
	BDEPEND+="
		sys-apps/yarn:1
	"
fi
# Eclass requires yarn >= 2.x

_yarn_set_globals() {
	NPM_SLOT="${NPM_SLOT:-3}" # v2 may be possibly used to unbreak "yarn import"
	NPM_TRIES="${NPM_TRIES:-10}"
	YARN_TRIES="${YARN_TRIES:-10}"
	YARN_SLOT="${YARN_SLOT:-1}"

	YARN_NETWORK_CONCURRENT_CONNECTIONS=${YARN_NETWORK_CONCURRENT_CONNECTIONS:-"1"}
	YARN_NETWORK_TIMEOUT=${YARN_NETWORK_TIMEOUT:-"600000"}
	YARN_TASK_POOL_CONCURRENCY=${YARN_TASK_POOL_CONCURRENCY:-"1"}
	NPM_NETWORK_FETCH_RETRIES=${NPM_NETWORK_FETCH_RETRIES:-"7"}
	NPM_NETWORK_RETRY_MINTIMEOUT=${NPM_NETWORK_RETRY_MINTIMEOUT:-"100000"}
	NPM_NETWORK_RETRY_MAXTIMEOUT=${NPM_NETWORK_RETRY_MAXTIMEOUT:-"300000"}
	NPM_NETWORK_MAX_SOCKETS=${NPM_NETWORK_MAX_SOCKETS:-"1"}

	export COREPACK_ENABLE_DOWNLOAD_PROMPT=0
	unset updateLock
	unset updaterPkgFolder
	unset updaterVersions
}
_yarn_set_globals
unset -f _yarn_set_globals

# @ECLASS_VARIABLE:  YARN_APP_INVOCATION
# @DESCRIPTION:
# Use either a wrapper script (default) or symlink.
# Valid values:  wrapper-script, symlink, none
# wrapper-script - Use a wrapper script (default)
# symlink - Use a symlink
# none - Do not create a wrapper or symlink.  Let me create it myself.

# @ECLASS_VARIABLE: YARN_BUILD_SCRIPT
# @DESCRIPTION:
# The build script to run from package.json:scripts section.

# @ECLASS_VARIABLE: YARN_EXE_LIST
# @DESCRIPTION:
# A pregenerated list of paths to turn on executable bit.
# Obtained partially from find ${YARN_INSTALL_PATH}/node_modules/ -path "*/.bin/*" | sort

# @ECLASS_VARIABLE: YARN_EXTERNAL_URIS
# @DESCRIPTION:
# Rows of URIs.
# Must be process through a URI transformer.  See scripts/*.
# Git snapshot URIs must manually added and look like:
# https://github.com/angular/dev-infra-private-build-tooling-builds/archive/<commit-id>.tar.gz -> yarnpkg-dev-infra-private-build-tooling-builds.git-<commit-id>.tgz

# @ECLASS_VARIABLE: YARN_INSTALL_PATH
# @DESCRIPTION:
# The destination install path relative to EROOT.

# @ECLASS_VARIABLE: YARN_INSTALL_ARGS
# @DESCRIPTION:
# This variable is an array.
# Global arguments to append to `yarn install`

# @ECLASS_VARIABLE: YARN_LOCKFILE_SOURCE
# @DESCRIPTION:
# The preferred yarn.lock file source.
# Acceptable values:  upstream, ebuild

# @ECLASS_VARIABLE: YARN_OFFLINE
# @DESCRIPTION:
# Use yarn eclass in offline install mode.

# @ECLASS_VARIABLE: YARN_ROOT
# @DESCRIPTION:
# The project root containing the yarn.lock file.

# @ECLASS_VARIABLE: YARN_SKIP_TARBALL_UNPACK
# @DESCRIPTION:
# Skip unpacking of ${A} or ${NPM_TARBALL}

# @ECLASS_VARIABLE: YARN_TARBALL
# @DESCRIPTION:
# The main package tarball.

# @ECLASS_VARIABLE: YARN_TEST_SCRIPT
# @DESCRIPTION:
# The test script to run from package.json:scripts section.

# @ECLASS_VARIABLE: YARN_TRIES
# @DESCRIPTION:
# The number of reconnect tries for yarn.

# @ECLASS_VARIABLE: YARN_SLOT
# @DESCRIPTION:
# The version of the Yarn lockfile. (Default:  1)
# Use 1.x or 3.x.
# Valid values:  1, 8
# lockfile version | yarn version
# 8                | 4.x
# 6                | 3.2.x, 3.3.x, 3.4.x, 3.6.x, 3.7.x, 3.8.x
# 5                | 3.1.x
# 4                | 2.1.x, 2.3.x, 2.4.x, 3.0.x
# 1                | 1.22.x

# @ECLASS_VARIABLE: NPM_AUDIT_FIX
# @DESCRIPTION:
# Allow audit fix

# @ECLASS_VARIABLE: NPM_SLOT
# @DESCRIPTION:
# The version of the NPM lockfile.  (Default:  3)
# Valid values:  1, 2, 3
# Using 3 is backwards compatible with 2.
# Using 2 is backwards compatible with 1.
# To simplify things, use the same lockfile version.

# @ECLASS_VARIABLE: NPM_TRIES
# @DESCRIPTION:
# The number of reconnect tries for npm.

# @ECLASS_VARIABLE: NPM_INSTALL_ARGS
# @DESCRIPTION:
# This variable is an array.
# Global arguments to append to `npm install`

# @ECLASS_VARIABLE: NPM_AUDIT_FIX_ARGS
# @DESCRIPTION:
# This variable is an array.
# Global arguments to append to `npm audit fix`

# @FUNCTION: yarn_env_push
# @DESCRIPTION:
# Save environment variables
yarn_env_push() {
	_YARN_UPDATE_LOCK=${YARN_UPDATE_LOCK}
	_YARN_CACHE_FOLDER=${YARN_CACHE_FOLDER}
	_YARN_UPDATER_PKG_FOLDER=${YARN_UPDATER_PKG_FOLDER}
	_YARN_UPDATER_VERSIONS=${YARN_UPDATER_VERSIONS}
	unset YARN_UPDATE_LOCK
	unset YARN_CACHE_FOLDER
	unset YARN_UPDATER_PKG_FOLDER
	unset YARN_UPDATER_VERSIONS
}

# @FUNCTION: yarn_env_pop
# @DESCRIPTION:
# Restore environment variables
yarn_env_pop() {
	YARN_UPDATE_LOCK=${_YARN_UPDATE_LOCK}
	YARN_CACHE_FOLDER=${_YARN_CACHE_FOLDER}
	YARN_UPDATER_PKG_FOLDER=${_YARN_UPDATER_PKG_FOLDER}
	YARN_UPDATER_VERSIONS=${_YARN_UPDATER_VERSIONS}
}

# @FUNCTION: yarn_check_network_sandbox
# @DESCRIPTION:
# Check the network sandbox.
yarn_check_network_sandbox() {
# Corepack problems.  Cannot do complete offline install.
# Required for yarn 4.x
	if has network-sandbox ${FEATURES} ; then
eerror
eerror "Sandbox changes requested via per-package env for =${CATEGORY}/${PN}-${PVR}."
eerror "Reason:  To download micropackages and offline cache"
eerror
eerror "Contents of /etc/portage/env/no-network-sandbox.conf"
eerror "FEATURES=\"\${FEATURES} -network-sandbox\""
eerror
eerror "Contents of /etc/portage/package.env"
eerror "${CATEGORY}/${PN} no-network-sandbox.conf"
eerror
		die
	fi
}

# @FUNCTION: yarn_check
# @DESCRIPTION:
# Checks for yarn installation.
yarn_check() {
	if ! which yarn 2>/dev/null 1>/dev/null ; then
eerror
eerror "Yarn is missing.  Pick one of the following:"
eerror
eerror "1. \`emerge sys-apps/yarn\` # For yarn 1.x"
eerror "2. \`emerge net-libs/nodejs[corepack]::oiledmachine-overlay\` # For yarn 3.x"
eerror "3. \`emerge -C sys-apps/yarn\`"
eerror "   \`emerge >=net-libs/nodejs-16.17[corepack]\` # For yarn 3.x"
eerror "   \`enable corepack\`"
eerror "   \`corepack prepare --all --activate\`"
		die
	fi

	local path=$(find "${WORKDIR}" -name "package.json" -type f \
		| head -n 1)
	path=$(realpath $(dirname "${path}"))
	pushd "${path}" >/dev/null 2>&1 || die
		local yarn_pv=$(/usr/bin/yarn --version)
		if ! [[ "${yarn_pv}" =~ [0-9]+\.[0-9]+\.[0-9]+ ]] ; then
eerror
eerror "Failed to detect version.  Install yarn."
eerror
			die
		fi
	popd >/dev/null 2>&1 || die
}

# @FUNCTION: yarn_pkg_setup
# @DESCRIPTION:
# Checks node slot required for building
yarn_pkg_setup() {
	if [[ -z "${NODE_SLOT}" ]] ; then
eerror "QA:  NODE_SLOT needs to be defined before calling npm_pkg_setup()."
		die
	fi

	node_setup
	yarn_check_network_sandbox

	# Prevent node 18 issue when downloading:
	local node_slot=$(node --version \
		| sed -e "s|^v||g" \
		| cut -f 1 -d ".")
	if ver_test "${node_slot}" -eq "18" ; then
		export NODE_OPTIONS+=" --dns-result-order=ipv4first"
	fi

	_YARN_PKG_SETUP_CALLED=1
}

# @FUNCTION: _yarn_setup_offline_cache
# @DESCRIPTION:
# Setup offline cache
_yarn_setup_offline_cache() {
	local EDISTDIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	if [[ -z "${YARN_CACHE_FOLDER}" ]] ; then
		export YARN_CACHE_FOLDER="${EDISTDIR}/yarn-download-cache-${YARN_SLOT}/${CATEGORY}/${P}"
	fi
	if [[ "${YARN_SLOT}" == "1" ]] ; then
		addwrite "${EDISTDIR}"
		addwrite "${YARN_CACHE_FOLDER}"
		mkdir -p "${YARN_CACHE_FOLDER}"
		yarn config set cacheFolder "${YARN_CACHE_FOLDER}" || die
	else
einfo "DEBUG:  Default cache folder:  ${HOME}/.yarn/berry/cache/"
		rm -rf "${HOME}/.yarn/berry/cache"
		mkdir -p "${HOME}/.yarn/berry" || die
		ln -sf "${YARN_CACHE_FOLDER}" "${HOME}/.yarn/berry/cache"
		addwrite "${EDISTDIR}"
		addwrite "${YARN_CACHE_FOLDER}"
		mkdir -p "${YARN_CACHE_FOLDER}"
	fi
einfo "YARN_CACHE_FOLDER:  ${YARN_CACHE_FOLDER}"
}

# @FUNCTION: yarn_check_vendored_yarn_default
# @DESCRIPTION:
# Check and remove vendored yarn
yarn_check_vendored_yarn_default() {
	local d=""
	if [[ -n "${YARN_ROOT}" ]] ; then
		d="${YARN_ROOT}"
	else
		d="${S}"
	fi
	if [[ -e "${d}/package.json" ]] ; then
		local yarn_pv=$(best_version "sys-apps/yarn:${YARN_SLOT}" | sed -e "s|sys-apps/yarn-||g")
einfo "Editing packageManager for yarn@${yarn_pv}"
		sed -i -r -e "s|\"packageManager\": \"yarn@[0-9.]+\"|\"packageManager\": \"yarn@${yarn_pv}\"|g" "${d}/package.json" || die
	fi
	if [[ -e "${d}/.yarn/releases" ]] ; then
ewarn "Detected vendored yarn in ${d}/.yarn/releases.  Removing..."
		rm -rf "${d}/.yarn/releases"
	fi
	if [[ -e "${d}/.yarnrc.yml" ]] && grep -F -q -e "yarnPath" "${d}/.yarnrc.yml" ; then
ewarn "Detected yarnPath in ${d}/.yarnrc.yml.  Removing..."
		sed -i -e "/yarnPath/d" "${d}/.yarnrc.yml" || die
	fi
}

# @FUNCTION: _yarn_src_unpack_default_ebuild
# @DESCRIPTION:
# Use the ebuild lockfiles
_yarn_src_unpack_default_ebuild() {
	if [[ "${YARN_ELECTRON_OFFLINE:-1}" == "0" ]] ; then
		:
	elif [[ "${YARN_OFFLINE:-1}" == "1" ]] ; then
		export ELECTRON_SKIP_BINARY_DOWNLOAD=1
	fi
	if [[ "${YARN_SKIP_TARBALL_UNPACK}" == "1" ]] ; then
		:
	elif [[ "${PV}" =~ "9999" ]] ; then
		:
	elif [[ -n "${YARN_TARBALL}" ]] ; then
		unpack "${YARN_TARBALL}"
	else
		unpack "${P}.tar.gz"
	fi

	yarn_check

	cd "${S}" || die
	if [[ "${YARN_OFFLINE:-1}" == "1" ]] ; then
		_yarn_setup_offline_cache
	fi

	if declare -f yarn_check_vendored_yarn > /dev/null 2>&1 ; then
		yarn_check_vendored_yarn
	else
		yarn_check_vendored_yarn_default
	fi

	if declare -f yarn_unpack_post > /dev/null 2>&1 ; then
		yarn_unpack_post
	fi

	if [[ "${YARN_OFFLINE:-1}" == "1" ]] ; then
		if [[ -e "${FILESDIR}/${PV}" && -n "${YARN_ROOT}" ]] ; then
			cp -aT "${FILESDIR}/${PV}" "${YARN_ROOT}" || die
		elif [[ -e "${FILESDIR}/${PV}" ]] ; then
			cp -aT "${FILESDIR}/${PV}" "${S}" || die
		fi
	fi
	local args=()
	if declare -f yarn_unpack_install_pre > /dev/null 2>&1 ; then
		yarn_unpack_install_pre
	fi

	yarn_network_settings
	if [[ "${YARN_SLOT}" == "1" ]] ; then
		args+=(
			--pure-lockfile
			--verbose
		)
		eyarn install \
			${args[@]} \
			${YARN_INSTALL_ARGS[@]}
	else
		args+=(
			--cached
		)
		eyarn add \
			${args[@]} \
			${YARN_INSTALL_ARGS[@]}
	fi

	if declare -f yarn_unpack_install_post > /dev/null 2>&1 ; then
		yarn_unpack_install_post
	fi
}

# @FUNCTION: _yarn_src_unpack_default_upstream
# @DESCRIPTION:
# Use the upstream lockfiles
_yarn_src_unpack_default_upstream() {
	export ELECTRON_SKIP_BINARY_DOWNLOAD=1
	if [[ "${PV}" =~ "9999" ]] ; then
		:
	elif [[ -n "${YARN_TARBALL}" ]] ; then
		unpack "${YARN_TARBALL}"
	else
		unpack "${P}.tar.gz"
	fi

	yarn_check

	cd "${S}" || die
	if [[ "${YARN_OFFLINE:-1}" == "1" ]] ; then
		_yarn_setup_offline_cache
	fi

	if declare -f yarn_check_vendored_yarn > /dev/null 2>&1 ; then
		yarn_check_vendored_yarn
	else
		yarn_check_vendored_yarn_default
	fi

	if declare -f yarn_unpack_post > /dev/null 2>&1 ; then
		yarn_unpack_post
	fi

	local args=()
	if declare -f yarn_unpack_install_pre > /dev/null 2>&1 ; then
		yarn_unpack_install_pre
	fi

	yarn_network_settings
	if [[ "${YARN_SLOT}" == "1" ]] ; then
		args+=(
			--pure-lockfile
			--verbose
		)
	else
		args+=(
		)
	fi

	eyarn install \
		${args[@]} \
		${YARN_INSTALL_ARGS[@]}
	if declare -f yarn_unpack_install_post > /dev/null 2>&1 ; then
		yarn_unpack_install_post
	fi
}

# @FUNCTION: _yarn_src_unpack_default
# @DESCRIPTION:
# Unpacks a yarn application.
_yarn_src_unpack_default() {
	if [[ "${YARN_LOCKFILE_SOURCE:-ebuild}" == "ebuild" ]] ; then
		_yarn_src_unpack_default_ebuild
	else
		_yarn_src_unpack_default_upstream
	fi
}

# @FUNCTION: _npm_auto_remove_node_modules
# @INTERNAL
# @DESCRIPTION:
# Auto-remove node_modules
_npm_auto_remove_node_modules() {
	local row
	IFS=$'\n'
	for row in $(grep -r -e "ENOTEMPTY: directory not empty, rename" "${HOME}/.npm/_logs") ; do
		local from=$(echo "${row}" | cut -f 2 -d "'")
		local to=$(echo "${row}" | cut -f 4 -d "'")
		local node_modules_path=$(dirname "${from}")
		if [[ -e "${node_modules_path}" ]] ; then
			rm -rf "${node_modules_path}"
einfo "Removing ${node_modules_path}"
			sed -i -e "\|${to}|d" "${T}/build.log" || die
		fi
	done
	IFS=$' \t\n'
}

# @FUNCTION: _npm_check_errors
# @DESCRIPTION:
# Check for errors that should be fatal.
_npm_check_errors() {
	grep -q -e "ENOENT" "${T}/build.log" && die "Retry"
	grep -q -e " ERR! Invalid Version" "${T}/build.log" && die "Detected error."
	grep -q -e " ERR! Exit handler never called!" "${T}/build.log" && die "Possible indeterministic behavior"
	grep -q -e "MODULE_NOT_FOUND" "${T}/build.log" && die "Detected error"
	grep -q -e "git dep preparation failed" "${T}/build.log" && die "Detected error"
	grep -q -e "- error TS" "${T}/build.log" && die "Detected error"
	grep -q -e "error during build:" "${T}/build.log" && die "Detected error"
	grep -q -e "FATAL ERROR:" "${T}/build.log" && die "Detected error"
	grep -q -e "Unknown command:" "${T}/build.log" && die "Detected error"
	grep -q -e "ETARGET" "${T}/build.log" && die "Detected error.  Remove --prefer-offline or remove --offline."
	grep -q -e "Failed to compile" "${T}/build.log" && die "Detected error"
}

# @FUNCTION: enpm
# @DESCRIPTION:
# Wrapper for the npm command.
# Rerun command if flakey connection.
enpm() {
	local cmd=("${@}")

	if [[ "${cmd[@]}" =~ "audit fix" && "${NPM_AUDIT_FIX:-1}" == "0" ]] ; then
einfo "Skipping audit fix."
		return
	fi

	local network_sandbox=0
	if has network-sandbox $FEATURES ; then
		network_sandbox=1
	fi

	local tries
	tries=0
	while (( ${tries} < ${NPM_TRIES} )) ; do
einfo "Current directory:\t${PWD}"
einfo "Tries:\t\t${tries}"
einfo "Running:\t\tnpm ${cmd[@]}"
		npm "${cmd[@]}" || die
		if ! grep -q -E -r -e "(EAI_AGAIN|ENOTEMPTY|ERR_SOCKET_TIMEOUT|ETIMEDOUT|ECONNRESET)" "${HOME}/.npm/_logs" ; then
			break
		fi
		if grep -q -r -F -e "audit error" "${HOME}/.npm/_logs" && [[ "${NPM_OFFLINE}" == "2" || "${network_sandbox}" == "1" ]] ; then
	# Audit needs network.  Prevent trying to contact the remote server
	# during offline install.
			rm -rf "${HOME}/.npm/_logs"
			break
		fi
		_npm_auto_remove_node_modules
		if grep -q -E -r -e "(EAI_AGAIN|ERR_SOCKET_TIMEOUT|ETIMEDOUT|ECONNRESET)" "${HOME}/.npm/_logs" ; then
			tries=$((${tries} + 1))
		fi
		rm -rf "${HOME}/.npm/_logs"
	done
	[[ -f "package-lock.json" ]] || die "Missing package-lock.json for audit fix"
	_npm_check_errors
}

# @FUNCTION: _yarn_check_errors
# @DESCRIPTION:
# Check for errors
_yarn_check_errors() {
	grep -q -e "FATAL ERROR:" "${T}/build.log" && die "Detected error"
	grep -q -e "ETIMEDOUT" "${T}/build.log" && die "Detected error"
	grep -q -e "^Error: Couldn't find package" "${T}/build.log" && die "Detected error"
}

# @FUNCTION: eyarn
# @DESCRIPTION:
# Wrapper for yarn command.
eyarn() {
	local cmd=("${@}")
einfo "Running:\tyarn ${cmd[@]}"

	local tries
	tries=0
	while (( ${tries} < ${YARN_TRIES} )) ; do
einfo "Current directory:\t${PWD}"
einfo "Tries:\t\t${tries}"
einfo "Running:\t\tyarn ${cmd[@]}"
		yarn_env_push
		yarn "${cmd[@]}" 2>&1 || die
		yarn_env_pop
		if ! grep -q -E -e "(ETIMEDOUT|EAI_AGAIN|ECONNRESET)" "${T}/build.log" ; then
			break
		fi
		if grep -q -E -e "ETIMEDOUT" "${T}/build.log" ; then
			tries=$((${tries} + 1))
			sed -i -e "/ETIMEDOUT/d" "${T}/build.log"
		elif grep -q -E -e "EAI_AGAIN" "${T}/build.log" ; then
			tries=$((${tries} + 1))
			sed -i -e "/EAI_AGAIN/d" "${T}/build.log"
		elif grep -q -E -e "ECONNRESET" "${T}/build.log" ; then
			tries=$((${tries} + 1))
			sed -i -e "/ECONNRESET/d" "${T}/build.log"
		fi
	done
	_yarn_check_errors
}

# @FUNCTION: _npm_setup_offline_cache
# @DESCRIPTION:
# Setup offline cache
_npm_setup_offline_cache() {
	local EDISTDIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	if [[ -z "${NPM_CACHE_FOLDER}" ]] ; then
		export NPM_CACHE_FOLDER="${EDISTDIR}/npm-download-cache-${NPM_SLOT}/${CATEGORY}/${P}"
	fi
einfo "DEBUG:  Default cache folder:  ${HOME}/.npm/_cacache"
einfo "NPM_CACHE_FOLDER:  ${NPM_CACHE_FOLDER}"
	rm -rf "${HOME}/.npm/_cacache"
	mkdir -p "${HOME}/.npm/" || die
	ln -sf "${NPM_CACHE_FOLDER}" "${HOME}/.npm/_cacache"
	addwrite "${EDISTDIR}"
	addwrite "${NPM_CACHE_FOLDER}"
	mkdir -p "${NPM_CACHE_FOLDER}"
}

# @FUNCTION: _yarn_src_unpack_update_ebuild
# @DESCRIPTION:
# Use the default ebuild updater
_yarn_src_unpack_update_ebuild() {
einfo "Updating lockfile"
		if [[ "${PV}" =~ "9999" ]] ; then
			:
		elif [[ -n "${YARN_TARBALL}" ]] ; then
			unpack "${YARN_TARBALL}"
		else
			unpack "${P}.tar.gz"
		fi

		cd "${S}" || die
		if [[ "${YARN_OFFLINE:-1}" == "1" ]] ; then
			_yarn_setup_offline_cache
		fi

		if declare -f yarn_check_vendored_yarn > /dev/null 2>&1 ; then
			yarn_check_vendored_yarn
		else
			yarn_check_vendored_yarn_default
		fi

		if declare -f yarn_unpack_post > /dev/null 2>&1 ; then
			yarn_unpack_post
		fi

	einfo "Deleting $(pwd)/package-lock.json to generate a new one."
		rm -f "package-lock.json"
	einfo "Deleting $(pwd)/yarn.lock to generate a new one."
		rm -f "yarn.lock"

		if declare -f \
			yarn_update_lock_install_pre > /dev/null 2>&1 ; then
			yarn_update_lock_install_pre
		fi

		local offline="${NPM_OFFLINE:-1}"
		local extra_args=()
		if [[ "${offline}" == "2" ]] ; then
			extra_args+=(
				"--offline"
			)
		elif [[ "${offline}" == "1" ]] ; then
			extra_args+=(
				"--prefer-offline"
			)
		fi

	# npm is used for audit fix which yarn lacks
		_npm_setup_offline_cache
		enpm install \
			${extra_args[@]} \
			${NPM_INSTALL_ARGS[@]}

		if declare -f \
			yarn_update_lock_install_post > /dev/null 2>&1 ; then
			yarn_update_lock_install_post
		fi
		if declare -f \
			yarn_update_lock_audit_pre > /dev/null 2>&1 ; then
			yarn_update_lock_audit_pre
		fi
		enpm audit fix ${NPM_AUDIT_FIX_ARGS[@]}
		if declare -f \
			yarn_update_lock_audit_post > /dev/null 2>&1 ; then
			yarn_update_lock_audit_post
		fi

		if declare -f \
			yarn_update_lock_yarn_import_pre > /dev/null 2>&1 ; then
			yarn_update_lock_yarn_import_pre
		fi

	# Converts package-lock.json to yarn.lock
einfo "Generating yarn lockfile"
		if [[ "${YARN_SLOT}" == "1" ]] ; then
			edo yarn import
		else
			rm -rf "node_modules"
			eyarn install --mode=update-lockfile
		fi
		[[ -e "yarn.lock" ]] || ewarn "Missing generated yarn.lock file"
		if declare -f \
			yarn_update_lock_yarn_import_post > /dev/null 2>&1 ; then
			yarn_update_lock_yarn_import_post
		fi

		if grep -q -e "Unrecognized or legacy configuration settings found" "${T}/build.log" ; then
einfo "DEBUG:"
# Yarn 4.x doesn't like when you touch YARN_ environment variables.
# If they exist, add them to the yarn_env_push and yarn_env_pop section.
printenv | grep '^YARN_' | cut -d= -f1
einfo "DEBUG:"
			yarn config -v
		fi
}

# @FUNCTION: _yarn_src_unpack_update_upstream
# @DESCRIPTION:
# Use the default yarn updater with upstream lockfiles
_yarn_src_unpack_update_upstream() {
einfo "Updating lockfile"
		if [[ "${PV}" =~ "9999" ]] ; then
			:
		elif [[ -n "${YARN_TARBALL}" ]] ; then
			unpack "${YARN_TARBALL}"
		else
			unpack "${P}.tar.gz"
		fi

		cd "${S}" || die
		if [[ "${YARN_OFFLINE:-1}" == "1" ]] ; then
			_yarn_setup_offline_cache
		fi

		if declare -f yarn_check_vendored_yarn > /dev/null 2>&1 ; then
			yarn_check_vendored_yarn
		else
			yarn_check_vendored_yarn_default
		fi

		if declare -f yarn_unpack_post > /dev/null 2>&1 ; then
			yarn_unpack_post
		fi
}

# @FUNCTION: __npm_patch
# @DESCRIPTION:
# Fix npm, npx wrappers
__npm_patch() {
	local npm_slot="${NPM_SLOT:-3}"
einfo "Running __npm_patch() for NPM_SLOT=${NPM_SLOT}"
	local npm_pv
	local bin_path
	if [[ -e "${HOME}/.cache/node/corepack/v1/npm" ]] ; then
		npm_pv=$(basename $(realpath "${HOME}/.cache/node/corepack/v1/npm/"*))
		bin_path="${HOME}/.cache/node/corepack/v1/npm/${npm_pv}/bin"
	else
		npm_pv=$(basename $(realpath "${HOME}/.cache/node/corepack/npm/"*))
		bin_path="${HOME}/.cache/node/corepack/npm/${npm_pv}/bin"
	fi

	if [[ "${NPM_SLOT}" == "1" ]] ; then
		sed -i \
			-e "s|\$basedir/node_modules/npm/bin|${bin_path}|g" \
			"${bin_path}/npm" || die
		sed -i \
			-e "s|\$basedir/node_modules/npm/bin|${bin_path}|g" \
			"${bin_path}/npx" || die
	fi
	if [[ "${NPM_SLOT}" == "2"  || "${NPM_SLOT}" == "3" ]] ; then
		sed -i \
			-e "s|\$CLI_BASEDIR/node_modules/npm/bin|${bin_path}|g" \
			-e "s|\$NPM_PREFIX/node_modules/npm/bin|${bin_path}|g" \
			"${bin_path}/npm" || die
		sed -i \
			-e "s|\$CLI_BASEDIR/node_modules/npm/bin|${bin_path}|g" \
			"${bin_path}/npx" || die
	fi
}

# @FUNCTION: npm_network_settings
# @DESCRIPTION:
# Smooth out network settings
npm_network_settings() {
# https://docs.npmjs.com/cli/v10/using-npm/config#fetch-retries
	npm config set fetch-retries ${NPM_NETWORK_FETCH_RETRIES} || die # 2 -> 7
# https://docs.npmjs.com/cli/v10/using-npm/config#fetch-retry-mintimeout
	npm config set fetch-retry-mintimeout ${NPM_NETWORK_RETRY_MINTIMEOUT} || die # 10 sec -> 1 min
# https://docs.npmjs.com/cli/v10/using-npm/config#fetch-retry-maxtimeout
	npm config set fetch-retry-maxtimeout ${NPM_NETWORK_RETRY_MAXTIMEOUT} || die # 1 min -> 5 min
# https://docs.npmjs.com/cli/v10/using-npm/config#maxsockets
	npm config set maxsockets ${NPM_NETWORK_MAX_SOCKETS} || die # 15 -> 1 ; smoother network multitasking
}

# @FUNCTION: yarn_network_settings
# @DESCRIPTION:
# Smooth out network settings
yarn_network_settings() {
	if [[ "${YARN_SLOT}" == "1" ]] ; then
# https://github.com/yarnpkg/yarn/blob/v1.22.21/src/constants.js#L40
		yarn config set networkTimeout ${YARN_NETWORK_TIMEOUT} || die # 30 sec -> 10 min
# https://github.com/yarnpkg/yarn/blob/v1.22.21/src/constants.js#L37
		yarn config set networkConcurrency ${YARN_NETWORK_CONCURRENT_CONNECTIONS} || die # 8 -> 1
	else
# https://github.com/yarnpkg/berry/blob/%40yarnpkg/types/4.0.0/packages/yarnpkg-core/sources/Configuration.ts#L389
		yarn config set httpTimeout ${YARN_NETWORK_TIMEOUT} || die # 1 min -> 10 min
# https://github.com/yarnpkg/berry/blob/%40yarnpkg/types/4.0.0/packages/yarnpkg-core/sources/Configuration.ts#L399
		yarn config set networkConcurrency ${YARN_NETWORK_CONCURRENT_CONNECTIONS} || die # 50 -> 1 ; smoother network multitasking

# https://github.com/yarnpkg/berry/blob/%40yarnpkg/types/4.0.0/packages/yarnpkg-core/sources/Configuration.ts#L404
		yarn config set taskPoolConcurrency ${YARN_TASK_POOL_CONCURRENCY} || die
	fi
}

# @FUNCTION: yarn_hydrate
# @DESCRIPTION:
# Load the package manager in the sandbox.
yarn_hydrate() {
	(( ${_YARN_PKG_SETUP_CALLED} == 0 )) && die "QA:  Call yarn_pkg_setup() first"
	if [[ "${YARN_OFFLINE:-1}" == "0" ]] ; then
		COREPACK_ENABLE_NETWORK="1" # It still requires online.
	else
		COREPACK_ENABLE_NETWORK="${COREPACK_ENABLE_NETWORK:-0}"
	fi
	if [[ ! -f "${EROOT}/usr/share/npm/npm-${NPM_SLOT}.tgz" ]] ; then
eerror
eerror "Missing ${EROOT}/usr/share/npm/npm-${NPM_SLOT}.tgz"
eerror
eerror "You must install sys-apps/npm:${NPM_SLOT}::oiledmachine-overlay to"
eerror "continue."
eerror
		die
	fi
	if [[ ! -f "${EROOT}/usr/share/yarn/yarn-${YARN_SLOT}.tgz" ]] ; then
eerror
eerror "Missing ${EROOT}/usr/share/yarn/yarn-${YARN_SLOT}.tgz"
eerror
eerror "You must install sys-apps/yarn:${YARN_SLOT}::oiledmachine-overlay to"
eerror "continue."
eerror
		die
	fi
einfo "Hydrating npm..."
	corepack hydrate --activate "${ESYSROOT}/usr/share/npm/npm-${NPM_SLOT}.tgz" || die
einfo "Hydrating yarn..."
	corepack hydrate --activate "${ESYSROOT}/usr/share/yarn/yarn-${YARN_SLOT}.tgz" || die

	__npm_patch
	local npm_pv
	local yarn_pv
	if [[ -e "${HOME}/.cache/node/corepack/v1/npm" ]] ; then
		npm_pv=$(basename $(realpath "${HOME}/.cache/node/corepack/v1/npm/"*))
		export PATH=".:${HOME}/.cache/node/corepack/v1/npm/${npm_pv}/bin:${PATH}"
	else
		npm_pv=$(basename $(realpath "${HOME}/.cache/node/corepack/npm/"*))
		export PATH=".:${HOME}/.cache/node/corepack/npm/${npm_pv}/bin:${PATH}"
	fi

	if [[ -e "${HOME}/.cache/node/corepack/v1/yarn" ]] ; then
		yarn_pv=$(basename $(realpath "${HOME}/.cache/node/corepack/v1/yarn/"*))
		export PATH="${HOME}/.cache/node/corepack/v1/yarn/${yarn_pv}:${PATH}"
		export PATH="${HOME}/.cache/node/corepack/v1/yarn/${yarn_pv}/bin:${PATH}"
	else
		yarn_pv=$(basename $(realpath "${HOME}/.cache/node/corepack/yarn/"*))
		export PATH="${HOME}/.cache/node/corepack/yarn/${yarn_pv}/bin:${PATH}"
	fi
	local yarn_pv=$(yarn --version)
	local node_pv=$(node --version)
einfo "Yarn version:  ${yarn_pv}"
einfo "Node.js version:  ${node_pv}"

	npm_network_settings

	yarn_env_push
	yarn config set --home enableTelemetry 0
	yarn_env_pop
}

# @FUNCTION: _yarn_src_unpack
# @DESCRIPTION:
# Unpacks a yarn application.
yarn_src_unpack() {
einfo "Called yarn_src_unpack"
	yarn_hydrate
	export PATH="${S}/node_modules/.bin:${PATH}"
	if [[ "${YARN_UPDATE_LOCK}" == "1" ]] ; then
		if [[ "${YARN_LOCKFILE_SOURCE:-ebuild}" == "ebuild" ]] ; then
			if declare -f yarn_src_unpack_update_ebuild_custom > /dev/null 2>&1 ; then
				yarn_src_unpack_update_ebuild_custom
			else
				_yarn_src_unpack_update_ebuild
			fi
		else
			_yarn_src_unpack_update_upstream
		fi
		_yarn_check_errors
		if declare -f yarn_unpack_install_pre > /dev/null 2>&1 ; then
			yarn_unpack_install_pre
		fi
einfo "Finished updating lockfiles."
		exit 0
	else
		#export ELECTRON_SKIP_BINARY_DOWNLOAD=1
		export ELECTRON_BUILDER_CACHE="${HOME}/.cache/electron-builder"
		export ELECTRON_CACHE="${HOME}/.cache/electron"
		mkdir -p "${S}" || die
		if [[ -e "${FILESDIR}/${PV}/package.json" ]] ; then
			cp -a "${FILESDIR}/${PV}/package.json" "${S}" || die
		fi
		_yarn_src_unpack_default
	fi
	grep -q -e "ENOENT" "${T}/build.log" && die "Retry"
	grep -q -e " ERR! Invalid Version" "${T}/build.log" && die "Detected error."
	grep -q -e " ERR! Exit handler never called!" "${T}/build.log" && die "Possible indeterministic behavior"
	grep -q -e "MODULE_NOT_FOUND" "${T}/build.log" && die "Detected error"
	grep -q -e " An unexpected error occurred" "${T}/build.log" && die "Detected error"
	grep -q -e "- error TS" "${T}/build.log" && die "Detected error"
}

# @FUNCTION: yarn_src_compile
# @DESCRIPTION:
# Builds a yarn application.
yarn_src_compile() {
	yarn_check
	yarn_hydrate
	[[ "${YARN_BUILD_SCRIPT}" == "none" ]] && return
	[[ "${YARN_BUILD_SCRIPT}" == "null" ]] && return
	[[ "${YARN_BUILD_SCRIPT}" == "skip" ]] && return
	local cmd="${YARN_BUILD_SCRIPT:-build}"
	grep -q -e "\"${cmd}\"" "package.json" || return
	local args=()
	if [[ "${YARN_SLOT}" == "1" ]] ; then
		yarn config set preferOffline "true"
		args+=(
			--pure-lockfile
			--verbose
		)
	else
		if [[ "${YARN_SLOT}" == "8" ]] ; then
			yarn config set enableOfflineMode "true"
		fi
		args+=(
		)
	fi

	yarn run ${cmd} \
		${args[@]} \
		|| die
	grep -q -e "ENOENT" "${T}/build.log" && die "Retry"
	grep -q -e " ERR! Exit handler never called!" "${T}/build.log" && die "Possible indeterministic behavior"
	grep -q -e "MODULE_NOT_FOUND" "${T}/build.log" && die "Detected error"
	grep -q -e "- error TS" "${T}/build.log" && die "Detected error"
}

# @FUNCTION: yarn_src_test
# @DESCRIPTION:
# Runs a yarn application test suite.
yarn_src_test() {
	[[ "${YARN_TEST_SCRIPT}" == "none" ]] && return
	[[ "${YARN_TEST_SCRIPT}" == "null" ]] && return
	[[ "${YARN_TEST_SCRIPT}" == "skip" ]] && return
	local cmd="${YARN_TEST_SCRIPT:-test}"
	grep -q -e "\"${cmd}\"" package.json || return
	yarn run ${cmd} \
		--verbose \
		|| die
}

# @FUNCTION: yarn_src_install
# @DESCRIPTION:
# Installs a yarn application.
yarn_src_install() {
	local install_path="${YARN_INSTALL_PATH:-/opt/${PN}}"
	local rows
	if cat package.json \
		| jq '.bin' \
		| grep -q ":" ; then
		rows=$(cat package.json \
			| jq '.bin' \
			| grep ":")
	elif cat package.json \
		| jq '.packages."".bin' \
		| grep -q ":" ; then
		rows=$(cat package.json \
			| jq '.packages."".bin' \
			| grep ":")
	else
		rows=""
	fi
	insinto "${install_path}"
	doins -r *
	ls .* > /dev/null && doins -r .*
	IFS=$'\n'
	local row
	for row in ${rows[@]} ; do
		local name=$(echo "${row}" \
			| cut -f 2 -d '"')
		local cmd=$(echo "${row}" \
			| cut -f 4 -d '"' \
			| sed -e "s|^\./||g")
		if [[ ${NPM_APP_INVOCATION:-"wrapper-script"} == "wrapper-script" ]] ; then
			dodir /usr/bin
cat <<EOF > "${ED}/usr/bin/${name}"
#!/bin/bash
export PATH="/usr/lib/node/${NODE_SLOT}/bin:\${PATH}"
"${YARN_INSTALL_PATH}/${cmd}" "\$@"
EOF
			fperms 0755 "/usr/bin/${name}"
		elif [[ ${NPM_APP_INVOCATION} == "symlink" ]] ; then
			dosym "${YARN_INSTALL_PATH}/${cmd}" "/usr/bin/${name}"
		fi
	done
	local path
	for path in ${YARN_EXE_LIST} ; do
		if [[ -e "${ED}/${path}" ]] ; then
			fperms 0755 "${path}" || die
		else
eerror "Skipping fperms 0755 ${path}.  Missing file."
		fi
	done
	IFS=$' \t\n'
einfo "Removing npm-packages-offline-cache"
	rm -rf "${ED}${install_path}/npm-packages-offline-cache"
	rm -rf "${ED}/opt/npm-packages-offline-cache"
}

fi
