# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: npm.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for npm offline install
# @DESCRIPTION:
# Eclass similar to the cargo.eclass.

# For additional slot availability send issue request.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z "${_NPM_ECLASS}" ]]; then
_NPM_ECLASS=1

EXPORT_FUNCTIONS pkg_setup src_unpack src_compile src_test src_install

BDEPEND+="
	app-misc/jq
"
if [[ -n "${NPM_SLOT}" ]] ; then
	BDEPEND+="
		sys-apps/npm:${NPM_SLOT}
	"
else
	BDEPEND+="
		sys-apps/npm:3
	"
fi

_npm_set_globals() {
	NPM_DEDUPE=${NPM_DEDUPE:-0}
	NPM_NETWORK_FETCH_RETRIES=${NPM_NETWORK_FETCH_RETRIES:-7}
	NPM_NETWORK_MAX_SOCKETS=${NPM_NETWORK_MAX_SOCKETS:-1}
	NPM_NETWORK_RETRY_MAXTIMEOUT=${NPM_NETWORK_RETRY_MAXTIMEOUT:-300000}
	NPM_NETWORK_RETRY_MINTIMEOUT=${NPM_NETWORK_RETRY_MINTIMEOUT:-100000}
	NPM_TRIES=${NPM_TRIES:-10}
}
_npm_set_globals
unset -f _npm_set_globals

# @ECLASS_VARIABLE: NPM_AUDIT_FIX
# @DESCRIPTION:
# Allow audit fix

# @ECLASS_VARIABLE: NPM_BUILD_SCRIPT
# @DESCRIPTION:
# The build script to run from package.json:scripts section.

# @ECLASS_VARIABLE: NPM_EXE_LIST
# @DESCRIPTION:
# A pregenerated list of paths to turn on executable bit.
# Obtained partially from find ${NPM_INSTALL_PATH}/node_modules/ -path "*/.bin/*" | sort

# @ECLASS_VARIABLE: NPM_EXTERNAL_URIS
# @DESCRIPTION:
# Rows of URIs.
# Must be process through a URI transformer.  See scripts/*.
# Git snapshot URIs must manually added and look like:
# https://github.com/angular/dev-infra-private-build-tooling-builds/archive/<commit-id>.tar.gz -> npmpkg-dev-infra-private-build-tooling-builds.git-<commit-id>.tgz

# @ECLASS_VARIABLE: NPM_INSTALL_PATH
# @DESCRIPTION:
# The destination install path relative to EROOT.

# @ECLASS_VARIABLE: NPM_INSTALL_ARGS
# @DESCRIPTION:
# This variable is an array.
# Global arguments to append to `npm install`

# @ECLASS_VARIABLE: NPM_AUDIT_FIX_ARGS
# @DESCRIPTION:
# This variable is an array.
# Global arguments to append to `npm audit fix`

# @ECLASS_VARIABLE: NPM_LOCKFILE_SOURCE
# @DESCRIPTION:
# The preferred package-lock.json file source.
# Acceptable values:  upstream, ebuild

# @ECLASS_VARIABLE: NPM_OFFLINE
# @DESCRIPTION:
# Use npm eclass in offline install mode.
# Valid values: 1 [partial offline], 2 [completely offline], 0 [online]

# @ECLASS_VARIABLE: NPM_ROOT
# @DESCRIPTION:
# The project root containing the package-lock.json file.

# @ECLASS_VARIABLE: NPM_SKIP_TARBALL_UNPACK
# @DESCRIPTION:
# Skip unpacking of ${A} or ${NPM_TARBALL}

# @ECLASS_VARIABLE: NPM_SLOT
# @DESCRIPTION:
# The version of the lockfile.  (Default:  3)
# Valid values:  1, 2, 3
# Using 3 is backwards compatible with 2.
# Using 2 is backwards compatible with 1.
# To simplify things, use the same lockfile version.

# @ECLASS_VARIABLE: NPM_TARBALL
# @DESCRIPTION:
# The main package tarball.

# @ECLASS_VARIABLE: NPM_TEST_SCRIPT
# @DESCRIPTION:
# The test script to run from package.json:scripts section.

# @ECLASS_VARIABLE: NPM_TRIES
# @DESCRIPTION:
# The number of reconnect tries.

# @FUNCTION: npm_check_network_sandbox
# @DESCRIPTION:
# Check the network sandbox.
npm_check_network_sandbox() {
# Corepack problems.  Cannot do complete offline install.
	if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package"
eerror "env to be able to download and cache offline micropackages."
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

# @FUNCTION: _npm_check_errors
# @DESCRIPTION:
# Check for build errors
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
}

# @FUNCTION: npm_pkg_setup
# @DESCRIPTION:
# Checks node slot required for building
npm_pkg_setup() {
	local found=0
	local slot
	local node_pv=$(node --version \
		| sed -e "s|v||g")
	if [[ -n "${NODE_SLOTS}" ]] ; then
		for slot in ${NODE_SLOTS} ; do
			if has_version "=net-libs/nodejs-${slot}*" \
				&& (( ${node_pv%%.*} == ${slot} )) ; then
				export NODE_VERSION=${slot}
				found=1
				break
			fi
		done
		if (( ${found} == 0 )) ; then
eerror
eerror "Did not find the preferred nodejs slot."
eerror "Expected node versions:  ${NODE_SLOTS}"
eerror
eerror "Try one of the following:"
eerror
			local s
			for s in ${NODE_SLOTS} ; do
eerror "  eselect nodejs set node${s}"
			done

eerror
eerror "See eselect nodejs for more details."
eerror
			die
		fi
	elif [[ -n "${NODE_VERSION}" ]] ; then
		if has_version "=net-libs/nodejs-${NODE_VERSION}*" \
			&& (( ${node_pv%%.*} == ${NODE_VERSION} )) ; then
			found=1
		fi
		if (( ${found} == 0 )) ; then
eerror
eerror "Did not find the preferred nodejs slot."
eerror "Expected node version:  ${NODE_VERSION}"
eerror
eerror "Try the following:"
eerror
eerror "  eselect nodejs set node$(ver_cut 1 ${NODE_VERSION})"
eerror
eerror "See eselect nodejs for more details."
eerror
			die
		fi
	fi
	npm_check_network_sandbox
}

# @FUNCTION: _npm_cp_tarballs
# @INTERNAL
# @DESCRIPTION:
# Copies all tarballs to the offline cache
_npm_cp_tarballs() {
	local dest="${WORKDIR}/npm-packages-offline-cache"
	mkdir -p "${dest}" || die
	IFS=$'\n'

	local tarballs=()

einfo "Copying/expanding tarballs to ${dest}"
	local uri
	for uri in ${NPM_EXTERNAL_URIS} ; do
		local bn
		if [[ "${uri}" =~ "->" && "${uri}" =~ ".git" ]] ; then
			bn=$(echo "${uri}" \
				| cut -f 3 -d " ")
#einfo "Copying ${DISTDIR}/${bn} -> ${dest}/${bn/npmpkg-}"
			local fn="${bn/npmpkg-}"
			fn_raw="${fn}"
			fn="${fn/.tgz}"
			local path=$(mktemp -d -p "${T}")
			pushd "${path}" >/dev/null 2>&1 || die
# See https://docs.npmjs.com/cli/v10/configuring-npm/package-json#local-paths
				tar --strip-components=1 -xvf "${DISTDIR}/${bn}" >/dev/null 2>&1 || die
				mkdir -p "${dest}/${fn}" || die
				mv * "${dest}/${fn}" || die
			popd >/dev/null 2>&1 || die
			rm -rf "${path}" || die
		else
			bn=$(echo "${uri}" \
				| cut -f 3 -d " ")
#einfo "Copying ${DISTDIR}/${bn} -> ${dest}/${bn/npmpkg-}"
			cp -a "${DISTDIR}/${bn}" "${dest}/${bn/npmpkg-}" || die
			tarballs+=( "${dest}/${bn/npmpkg-}" )
		fi
	done

ewarn "Adding tarballs to cache.  Please wait..."
einfo "running:  npm cache add ${tarballs[@]}"
	npm cache add ${tarballs[@]}

	IFS=$' \t\n'
}

# @FUNCTION: npm_gen_new_name
# @DESCRIPTION:
# Generate new name with @ in URIs to prevent wrong hash.
npm_gen_new_name() {
	local uri="${1}"
	if [[ "${uri}" =~ ("git+https"|"git+ssh") && "${uri}" =~ "github" ]] ; then
		local commit_id=$(echo "${uri}" \
			| cut -f 2 -d "#")
		local owner=$(echo "${uri}" \
			| cut -f 4 -d "/")
		local project_name=$(echo "${uri}" \
			| cut -f 5 -d "/" \
			| cut -f 1 -d "#" \
			| sed -e "s|.git$||")
		echo "${project_name}.git-${commit_id}"
	elif [[ "${uri}" =~ "@" ]] ; then
		local ns=$(echo "${uri}" \
			| grep -E -o -e "@[a-zA-Z0-9._-]+")
		local bn=$(basename "${uri}")
		echo "${ns}-${bn}"
	else
		local bn=$(basename "${uri}")
		echo "${bn}"
	fi

}

# @FUNCTION: _npm_src_unpack_default_upstream
# @DESCRIPTION:
# Use the ebuild lockfiles
_npm_src_unpack_default_ebuild() {
	local offline="${NPM_OFFLINE:-1}"
	if [[ "${NPM_ELECTRON_OFFLINE:-1}" == "0" ]] ; then
		:
	elif [[ "${offline}" == "1" || "${offline}" == "2" ]] ; then
		export ELECTRON_SKIP_BINARY_DOWNLOAD=1
	fi
	if [[ "${NPM_SKIP_TARBALL_UNPACK}" == "1" ]] ; then
		:
	elif [[ "${PV}" =~ "9999" ]] ; then
		:
	elif [[ -n "${NPM_TARBALL}" ]] ; then
		unpack "${NPM_TARBALL}"
	else
		unpack "${P}.tar.gz"
	fi
	cd "${S}" || die
	if declare -f npm_unpack_post >/dev/null 2>&1 ; then
		npm_unpack_post
	fi
	if [[ "${offline}" == "1" || "${offline}" == "2" ]] ; then
		#_npm_cp_tarballs

		local EDISTDIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"

		export NPM_ENABLE_OFFLINE_MODE=1
		export NPM_CACHE_FOLDER="${EDISTDIR}/npm-download-cache-${NPM_SLOT}/${CATEGORY}/${P}"
	einfo "DEBUG:  Default cache folder:  ${HOME}/.npm/_cacache"
	einfo "NPM_ENABLE_OFFLINE_MODE:  ${YARN_ENABLE_OFFLINE_MODE}"
	einfo "NPM_CACHE_FOLDER:  ${NPM_CACHE_FOLDER}"
		rm -rf "${HOME}/.npm/_cacache"
		ln -s "${NPM_CACHE_FOLDER}" "${HOME}/.npm/_cacache" # npm likes to remove the ${HOME}/.npm folder
		addwrite "${EDISTDIR}"
		addwrite "${NPM_CACHE_FOLDER}"
		mkdir -p "${NPM_CACHE_FOLDER}"

		rm -f "package-lock.json" || true
		if [[ -e "${FILESDIR}/${PV}" && "${NPM_MULTI_LOCKFILE}" == "1" && -n "${NPM_ROOT}" ]] ; then
			cp -aT "${FILESDIR}/${PV}" "${NPM_ROOT}" || die
		elif [[ -e "${FILESDIR}/${PV}" && "${NPM_MULTI_LOCKFILE}" == "1" ]] ; then
			cp -aT "${FILESDIR}/${PV}" "${S}" || die
		elif [[ -f "${FILESDIR}/${PV}/package.json" && -n "${NPM_ROOT}" ]] ; then
			cp "${FILESDIR}/${PV}/package.json" "${NPM_ROOT}" || die
		elif [[ -f "${FILESDIR}/${PV}/package.json" ]] ; then
			cp "${FILESDIR}/${PV}/package.json" "${S}" || die
		fi
		if [[ -e "${FILESDIR}/${PV}" && "${NPM_MULTI_LOCKFILE}" == "1" && -n "${NPM_ROOT}" ]] ; then
			cp -aT "${FILESDIR}/${PV}" "${NPM_ROOT}" || die
		elif [[ -e "${FILESDIR}/${PV}" && "${NPM_MULTI_LOCKFILE}" == "1" ]] ; then
			cp -aT "${FILESDIR}/${PV}" "${S}" || die
		elif [[ -f "${FILESDIR}/${PV}/package-lock.json" && -n "${NPM_ROOT}" ]] ; then
			cp "${FILESDIR}/${PV}/package-lock.json" "${NPM_ROOT}" || die
		elif [[ -f "${FILESDIR}/${PV}/package-lock.json" ]] ; then
			cp "${FILESDIR}/${PV}/package-lock.json" "${S}" || die
		else
einfo "Missing package-lock.json"
			die
		fi
	fi
	local args=()
	if declare -f npm_unpack_install_pre > /dev/null 2>&1 ; then
		npm_unpack_install_pre
	fi
	local extra_args=()
	if [[ "${offline}" == "2" ]] ; then
		extra_args+=(
			"--no-audit"
			"--offline"
		)
	elif [[ "${offline}" == "1" ]] ; then
		extra_args+=(
			"--no-audit"
			"--prefer-offline"
		)
	fi
	enpm install \
		${extra_args[@]} \
		${NPM_INSTALL_ARGS[@]}
	if declare -f npm_unpack_install_post > /dev/null 2>&1 ; then
		npm_unpack_install_post
	fi
}

# @FUNCTION: _npm_src_unpack_default_upstream
# @DESCRIPTION:
# Use the upstream lockfiles
_npm_src_unpack_default_upstream() {
	local offline="${NPM_OFFLINE:-1}"
	if [[ "${offline}" == "1" || "${offline}" == "2" ]] ; then
		export ELECTRON_SKIP_BINARY_DOWNLOAD=1
	fi
	if [[ "${PV}" =~ "9999" ]] ; then
		:
	elif [[ -n "${NPM_TARBALL}" ]] ; then
		unpack "${NPM_TARBALL}"
	else
		unpack "${P}.tar.gz"
	fi
	cd "${S}" || die
	if declare -f npm_unpack_post >/dev/null 2>&1 ; then
		npm_unpack_post
	fi
	local args=()
	if declare -f npm_unpack_install_pre > /dev/null 2>&1 ; then
		npm_unpack_install_pre
	fi
	local extra_args=()
	if [[ "${offline}" == "2" ]] ; then
		extra_args+=(
			"--no-audit"
			"--offline"
		)
	elif [[ "${offline}" == "1" ]] ; then
		extra_args+=(
			"--no-audit"
			"--prefer-offline"
		)
	fi
	enpm install \
		${extra_args[@]} \
		${NPM_INSTALL_ARGS[@]}
	if declare -f npm_unpack_install_post > /dev/null 2>&1 ; then
		npm_unpack_install_post
	fi
}

# @FUNCTION: _npm_src_unpack_default
# @DESCRIPTION:
# Unpacks a npm application.
_npm_src_unpack_default() {
	if [[ "${NPM_LOCKFILE_SOURCE:-ebuild}" == "ebuild" ]] ; then
		_npm_src_unpack_default_ebuild
	else
		_npm_src_unpack_default_upstream
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
	[[ -f package-lock.json ]] || die "Missing package-lock.json for audit fix"
	_npm_check_errors
}

# @FUNCTION: __npm_patch
# @DESCRIPTION:
# Fix npm, npx wrappers
__npm_patch() {
	local npm_slot="${NPM_SLOT:-3}"
einfo "Running __npm_patch() for NPM_SLOT=${npm_slot}"
	local npm_pv
	local bin_path
	if [[ -e "${HOME}/.cache/node/corepack/v1/npm" ]] ; then
		npm_pv=$(basename $(realpath "${HOME}/.cache/node/corepack/v1/npm/"*))
		bin_path="${HOME}/.cache/node/corepack/v1/npm/${npm_pv}/bin"
	else
		npm_pv=$(basename $(realpath "${HOME}/.cache/node/corepack/npm/"*))
		bin_path="${HOME}/.cache/node/corepack/npm/${npm_pv}/bin"
	fi

	if [[ "${npm_slot}" == "1" ]] ; then
		sed -i \
			-e "s|\$basedir/node_modules/npm/bin|${bin_path}|g" \
			"${bin_path}/npm" || die
		sed -i \
			-e "s|\$basedir/node_modules/npm/bin|${bin_path}|g" \
			"${bin_path}/npx" || die
	fi
	if [[ "${npm_slot}" == "2"  || "${npm_slot}" == "3" ]] ; then
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

# @FUNCTION: npm_hydrate
# @DESCRIPTION:
# Load the package manager in the sandbox.
npm_hydrate() {
	local offline="${NPM_OFFLINE:-1}"
	if [[ "${offline}" == "0" ]] ; then
		COREPACK_ENABLE_NETWORK="1" # It still requires online.
	else
		COREPACK_ENABLE_NETWORK="${COREPACK_ENABLE_NETWORK:-0}"
	fi
	local npm_slot="${NPM_SLOT:-3}"
	if [[ ! -f "${EROOT}/usr/share/npm/npm-${npm_slot}.tgz" ]] ; then
eerror
eerror "Missing ${EROOT}/usr/share/npm/npm-${npm_slot}.tgz"
eerror
eerror "You must install sys-apps/npm:${npm_slot}::oiledmachine-overlay to"
eerror "continue."
eerror
		die
	fi
einfo "Hydrating npm..."
	corepack hydrate "${ESYSROOT}/usr/share/npm/npm-${npm_slot}.tgz" || die
	__npm_patch

	if [[ -e "${HOME}/.cache/node/corepack/v1/npm" ]] ; then
		local npm_pv=$(basename $(realpath "${HOME}/.cache/node/corepack/v1/npm/"*))
		export PATH=".:${HOME}/.cache/node/corepack/v1/npm/${npm_pv}/bin:${PATH}"
	else
		local npm_pv=$(basename $(realpath "${HOME}/.cache/node/corepack/npm/"*))
		export PATH=".:${HOME}/.cache/node/corepack/npm/${npm_pv}/bin:${PATH}"
	fi

	npm_network_settings
}

# @FUNCTION: _npm_src_unpack
# @DESCRIPTION:
# Unpacks a npm application.
npm_src_unpack() {
	npm_hydrate
	export PATH="${S}/node_modules/.bin:${PATH}"
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
		if [[ "${PV}" =~ "9999" ]] ; then
			:
		elif [[ -n "${NPM_TARBALL}" ]] ; then
			unpack "${NPM_TARBALL}"
		else
			unpack "${P}.tar.gz"
		fi
		cd "${S}" || die
		if declare -f npm_unpack_post >/dev/null 2>&1 ; then
			npm_unpack_post
		fi
		rm -f package-lock.json

		if declare -f npm_update_lock_install_pre > /dev/null 2>&1 ; then
			npm_update_lock_install_pre
		fi
		enpm install \
			${NPM_INSTALL_ARGS[@]}
		if declare -f npm_update_lock_install_post > /dev/null 2>&1 ; then
			npm_update_lock_install_post
		fi
		if declare -f npm_update_lock_audit_pre > /dev/null 2>&1 ; then
			npm_update_lock_audit_pre
		fi
		enpm audit fix \
			${NPM_AUDIT_FIX_ARGS[@]}
		if declare -f npm_update_lock_audit_post > /dev/null 2>&1 ; then
			npm_update_lock_audit_post
		fi

		if [[ "${NPM_DEDUPE}" == "1" ]] ; then
			enpm dedupe
		fi

		if declare -f npm_save_lockfiles > /dev/null 2>&1 ; then
			npm_save_lockfiles
		fi

		_npm_check_errors
einfo "Finished updating lockfiles."
		exit 0
	else
		local offline="${NPM_OFFLINE:-1}"
		if [[ "${offline}" == "1" || "${offline}" == "2" ]] ; then
			#export ELECTRON_SKIP_BINARY_DOWNLOAD=1
			export ELECTRON_BUILDER_CACHE="${HOME}/.cache/electron-builder"
			export ELECTRON_CACHE="${HOME}/.cache/electron"
		fi
		mkdir -p "${S}" || die
		if [[ -e "${FILESDIR}/${PV}/package.json" ]] ; then
			cp -a "${FILESDIR}/${PV}/package.json" "${S}" || die
		fi
		_npm_src_unpack_default
	fi
	_npm_check_errors
}

# @FUNCTION: npm_src_compile
# @DESCRIPTION:
# Builds a npm application.
npm_src_compile() {
	npm_hydrate
	[[ "${NPM_BUILD_SCRIPT}" == "none" ]] && return
	[[ "${NPM_BUILD_SCRIPT}" == "null" ]] && return
	[[ "${NPM_BUILD_SCRIPT}" == "skip" ]] && return
	local cmd="${NPM_BUILD_SCRIPT:-build}"
	grep -q -e "\"${cmd}\"" package.json || return
	local extra_args=()
	local offline="${NPM_OFFLINE:-1}"
	if [[ "${offline}" == "2" ]] ; then
		extra_args+=( "--offline" )
	elif [[ "${offline}" == "1" ]] ; then
		extra_args+=( "--prefer-offline" )
	fi
	npm run ${cmd} \
		${extra_args[@]} \
		|| die
	_npm_check_errors
}

# @FUNCTION: npm_src_test
# @DESCRIPTION:
# Runs a npm application test suite.
npm_src_test() {
	[[ "${NPM_TEST_SCRIPT}" == "none" ]] && return
	[[ "${NPM_TEST_SCRIPT}" == "null" ]] && return
	[[ "${NPM_TEST_SCRIPT}" == "skip" ]] && return
	local cmd="${NPM_TEST_SCRIPT:-test}"
	grep -q -e "\"${cmd}\"" package.json || return
	npm run ${cmd} \
		|| die
}

# @FUNCTION: npm_src_install
# @DESCRIPTION:
# Installs a npm application.
npm_src_install() {
	local install_path="${NPM_INSTALL_PATH:-/opt/${PN}}"
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
		if [[ -n "${NODE_VERSION}" ]] ; then
			dodir /usr/bin
cat <<EOF > "${ED}/usr/bin/${name}"
#!/bin/bash
NODE_VERSION=${NODE_VERSION}
"${install_path}/${cmd}" "\$@"
EOF
			fperms 0755 "/usr/bin/${name}"
		else
			dosym "${install_path}/${cmd}" "/usr/bin/${name}"
		fi
	done
	local path
	for path in ${NPM_EXE_LIST} ; do
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
