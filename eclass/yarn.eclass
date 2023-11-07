# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
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

if [[ -z ${_YARN_ECLASS} ]]; then
_YARN_ECLASS=1

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
}
_yarn_set_globals
unset -f _yarn_set_globals

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

# @ECLASS_VARIABLE: YARN_INSTALL_UNPACK_ARGS
# @DESCRIPTION:
# Arguments to append to `yarn install ` during yarn.lock generation.

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
# Valid values:  1, 3

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

# @ECLASS_VARIABLE: NPM_INSTALL_UNPACK_ARGS
# @DESCRIPTION:
# Arguments to append to `npm install ` contexts during package-lock.json generation.

# @ECLASS_VARIABLE: NPM_INSTALL_UNPACK_AUDIT_FIX_ARGS
# @DESCRIPTION:
# Arguments to append to `npm audit fix ` contexts during package-lock.json generation.

# @FUNCTION: yarn_check_network_sandbox
# @DESCRIPTION:
# Check the network sandbox.
yarn_check_network_sandbox() {
# Corepack problems.  Cannot do complete offline install.
	if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package"
eerror "env to be able to download micropackages."
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
	pushd "${path}" || die
		local yarn_pv=$(/usr/bin/yarn --version)
		if ! [[ "${yarn_pv}" =~ [0-9]+\.[0-9]+\.[0-9]+ ]] ; then
eerror
eerror "Failed to detect version.  Install yarn or disable network-sandbox in"
eerror "FEATURES."
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package"
eerror "env to be able to download micropackages."
eerror
				die
		elif ver_test ${yarn_pv} -ge 1 ; then
			:;#yarn_check_network_sandbox
		fi
	popd
}

# @FUNCTION: yarn_pkg_setup
# @DESCRIPTION:
# Checks node slot required for building
yarn_pkg_setup() {
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
}

# @FUNCTION: _yarn_cp_tarballs
# @INTERNAL
# @DESCRIPTION:
# Copies all tarballs to the offline cache
_yarn_cp_tarballs() {
	local dest="${WORKDIR}/npm-packages-offline-cache"
	mkdir -p "${dest}" || die
	IFS=$'\n'
	local uri
	for uri in ${YARN_EXTERNAL_URIS} ; do
		local bn
		if [[ "${uri}" =~ "->" && "${uri}" =~ ".git" ]] ; then
			bn=$(echo "${uri}" \
				| cut -f 3 -d " ")
einfo "Copying ${DISTDIR}/${bn} -> ${dest}/${bn/yarnpkg-}"
			local fn="${bn/yarnpkg-}"
			fn="${fn/.tgz}"
			local path=$(mktemp -d -p "${T}")
			pushd "${path}" || die
				tar --strip-components=1 -xvf "${DISTDIR}/${bn}" || die
				tar -cf "${dest}/${fn}" * || die
			popd
			rm -rf "${path}" || die
		else
			bn=$(echo "${uri}" \
				| cut -f 3 -d " ")
einfo "Copying ${DISTDIR}/${bn} -> ${dest}/${bn/yarnpkg-}"
			cp -a "${DISTDIR}/${bn}" "${dest}/${bn/yarnpkg-}" || die
		fi
	done
	IFS=$' \t\n'
}

# @FUNCTION: _yarn_src_unpack_default_ebuild
# @DESCRIPTION:
# Use the ebuild lockfiles
_yarn_src_unpack_default_ebuild() {
	if [[ "${YARN_ELECTRON_OFFLINE:-1}" == "0" ]] ; then
		:;
	elif [[ "${YARN_OFFLINE:-1}" == "1" ]] ; then
		export ELECTRON_SKIP_BINARY_DOWNLOAD=1
	fi
	if [[ ${PV} =~ 9999 ]] ; then
		:;
	elif [[ -n "${YARN_TARBALL}" ]] ; then
		unpack ${YARN_TARBALL}
	else
		unpack ${P}.tar.gz
	fi
	yarn_check
	cd "${S}" || die
	if [[ "${YARN_OFFLINE:-1}" == "1" ]] ; then
		_yarn_cp_tarballs
		rm -f "package-lock.json" || true
		if [[ -n "${YARN_ROOT}" ]] ; then
			rm -rf "${YARN_ROOT}/.yarnrc" || die
		fi
		rm -rf "${S}/.yarnrc" || die
		if [[ "${YARN_SLOT}" == "1" ]] ; then
			yarn config set yarn-offline-mirror ./npm-packages-offline-cache || die
			mv "${HOME}/.yarnrc" "${WORKDIR}" || die
		fi
		if [[ -e "${FILESDIR}/${PV}" && "${YARN_MULTI_LOCKFILE}" == "1" && -n "${YARN_ROOT}" ]] ; then
			cp -aT "${FILESDIR}/${PV}" "${YARN_ROOT}" || die
		elif [[ -e "${FILESDIR}/${PV}" && "${YARN_MULTI_LOCKFILE}" == "1" ]] ; then
			cp -aT "${FILESDIR}/${PV}" "${S}" || die
		elif [[ -f "${FILESDIR}/${PV}/package.json" && -n "${YARN_ROOT}" ]] ; then
			cp "${FILESDIR}/${PV}/package.json" "${YARN_ROOT}" || die
		elif [[ -f "${FILESDIR}/${PV}/package.json" ]] ; then
			cp "${FILESDIR}/${PV}/package.json" "${S}" || die
		fi
		if [[ -e "${FILESDIR}/${PV}" && "${YARN_MULTI_LOCKFILE}" == "1" && -n "${YARN_ROOT}" ]] ; then
			cp -aT "${FILESDIR}/${PV}" "${YARN_ROOT}" || die
		elif [[ -e "${FILESDIR}/${PV}" && "${YARN_MULTI_LOCKFILE}" == "1" ]] ; then
			cp -aT "${FILESDIR}/${PV}" "${S}" || die
		elif [[ -f "${FILESDIR}/${PV}/yarn.lock" && -n "${YARN_ROOT}" ]] ; then
			cp "${FILESDIR}/${PV}/yarn.lock" "${YARN_ROOT}" || die
		elif [[ -f "${FILESDIR}/${PV}/yarn.lock" ]] ; then
			cp "${FILESDIR}/${PV}/yarn.lock" "${S}" || die
		fi
	fi
	local args=()
	if declare -f yarn_unpack_install_pre > /dev/null ; then
		yarn_unpack_install_pre
	fi
	eyarn install \
		--prefer-offline \
		--pure-lockfile \
		--verbose \
		${YARN_INSTALL_UNPACK_ARGS}
	if declare -f yarn_unpack_install_post > /dev/null ; then
		yarn_unpack_install_post
	fi
}

# @FUNCTION: _yarn_src_unpack_default_upstream
# @DESCRIPTION:
# Use the upstream lockfiles
_yarn_src_unpack_default_upstream() {
	export ELECTRON_SKIP_BINARY_DOWNLOAD=1
	if [[ ${PV} =~ 9999 ]] ; then
		:;
	elif [[ -n "${YARN_TARBALL}" ]] ; then
		unpack ${YARN_TARBALL}
	else
		unpack ${P}.tar.gz
	fi
	yarn_check
	cd "${S}" || die
	if [[ "${YARN_OFFLINE:-1}" == "1" ]] ; then
		_yarn_cp_tarballs
		if [[ -n "${YARN_ROOT}" ]] ; then
			rm -rf "${YARN_ROOT}/.yarnrc" || die
		fi
		rm -rf "${S}/.yarnrc" || die
		if [[ "${YARN_SLOT}" == "1" ]] ; then
			yarn config set yarn-offline-mirror ./npm-packages-offline-cache || die
			mv "${HOME}/.yarnrc" "${WORKDIR}" || die
		fi
	fi
	local args=()
	if declare -f yarn_unpack_install_pre > /dev/null ; then
		yarn_unpack_install_pre
	fi
	eyarn install \
		--prefer-offline \
		--pure-lockfile \
		--verbose \
		${YARN_INSTALL_UNPACK_ARGS}
	if declare -f yarn_unpack_install_post > /dev/null ; then
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

	local tries
	tries=0
	while (( ${tries} < ${NPM_TRIES} )) ; do
einfo "Tries:\t${tries}"
einfo "Running:\tnpm ${cmd[@]}"
		npm "${cmd[@]}" || die
		if ! grep -q -E -r -e "(EAI_AGAIN|ENOTEMPTY|ERR_SOCKET_TIMEOUT|ETIMEDOUT|ECONNRESET)" "${HOME}/.npm/_logs" ; then
			break
		fi
		_npm_auto_remove_node_modules
		if grep -q -E -r -e "(EAI_AGAIN|ERR_SOCKET_TIMEOUT|ETIMEDOUT|ECONNRESET)" "${HOME}/.npm/_logs" ; then
			tries=$((${tries} + 1))
		fi
		rm -rf "${HOME}/.npm/_logs"
	done
	[[ -f package-lock.json ]] || die "Missing package-lock.json for audit fix"
	grep -q -e "ENOENT" "${T}/build.log" && die "Retry"
	grep -q -e " ERR! Invalid Version" "${T}/build.log" && die "Detected error."
	grep -q -e " ERR! Exit handler never called!" "${T}/build.log" && die "Possible indeterministic behavior"
	grep -q -e "git dep preparation failed" "${T}/build.log" && die "Detected error"
}

# @FUNCTION: eyarn
# @DESCRIPTION:
# Wrapper for yarn command.
eyarn() {
	local cmd=("${@}")
einfo "Running:\tyarn ${cmd[@]}"
	yarn "${cmd[@]}" || die
}

# @FUNCTION: _yarn_src_unpack_update_ebuild
# @DESCRIPTION:
# Use the default ebuild updater
_yarn_src_unpack_update_ebuild() {
einfo "Updating lockfile"
		if [[ ${PV} =~ 9999 ]] ; then
			:;
		elif [[ -n "${YARN_TARBALL}" ]] ; then
			unpack ${YARN_TARBALL}
		else
			unpack ${P}.tar.gz
		fi
		cd "${S}" || die
		rm -f package-lock.json
		rm -f yarn.lock

		if declare -f \
			yarn_update_lock_install_pre > /dev/null ; then
			yarn_update_lock_install_pre
		fi
		enpm install ${NPM_INSTALL_UNPACK_ARGS}
		if declare -f \
			yarn_update_lock_install_post > /dev/null ; then
			yarn_update_lock_install_post
		fi
		if declare -f \
			yarn_update_lock_audit_pre > /dev/null ; then
			yarn_update_lock_audit_pre
		fi
		enpm audit fix ${NPM_INSTALL_UNPACK_AUDIT_FIX_ARGS}
		if declare -f \
			yarn_update_lock_audit_post > /dev/null ; then
			yarn_update_lock_audit_post
		fi

		if declare -f \
			yarn_update_lock_yarn_import_pre > /dev/null ; then
			yarn_update_lock_yarn_import_pre
		fi
		yarn import || die
		if declare -f \
			yarn_update_lock_yarn_import_post > /dev/null ; then
			yarn_update_lock_yarn_import_post
		fi

}

# @FUNCTION: _yarn_src_unpack_update_upstream
# @DESCRIPTION:
# Use the default yarn updater with upstream lockfiles
_yarn_src_unpack_update_upstream() {
einfo "Updating lockfile"
		if [[ ${PV} =~ 9999 ]] ; then
			:;
		elif [[ -n "${YARN_TARBALL}" ]] ; then
			unpack ${YARN_TARBALL}
		else
			unpack ${P}.tar.gz
		fi
		cd "${S}" || die
}

# @FUNCTION: __npm_patch
# @DESCRIPTION:
# Fix npm, npx wrappers
__npm_patch() {
	local npm_slot="${NPM_SLOT:-3}"
einfo "Running __npm_patch() for NPM_SLOT=${npm_slot}"
	local npm_pv=$(basename $(realpath "${HOME}/.cache/node/corepack/npm/"*))
	if [[ "${npm_slot}" == "1" ]] ; then
		sed -i \
			-e "s|\$basedir/node_modules/npm/bin|${HOME}/.cache/node/corepack/npm/${npm_pv}/bin|g" \
			"${HOME}/.cache/node/corepack/npm/${npm_pv}/bin/npm" || die
		sed -i \
			-e "s|\$basedir/node_modules/npm/bin|${HOME}/.cache/node/corepack/npm/${npm_pv}/bin|g" \
			"${HOME}/.cache/node/corepack/npm/${npm_pv}/bin/npx" || die
	fi
	if [[ "${npm_slot}" == "2"  || "${npm_slot}" == "3" ]] ; then
		sed -i \
			-e "s|\$CLI_BASEDIR/node_modules/npm/bin|${HOME}/.cache/node/corepack/npm/${npm_pv}/bin|g" \
			-e "s|\$NPM_PREFIX/node_modules/npm/bin|${HOME}/.cache/node/corepack/npm/${npm_pv}/bin|g" \
			"${HOME}/.cache/node/corepack/npm/${npm_pv}/bin/npm" || die
		sed -i \
			-e "s|\$CLI_BASEDIR/node_modules/npm/bin|${HOME}/.cache/node/corepack/npm/${npm_pv}/bin|g" \
			"${HOME}/.cache/node/corepack/npm/${npm_pv}/bin/npx" || die
	fi
}

# @FUNCTION: yarn_hydrate
# @DESCRIPTION:
# Load the package manager in the sandbox.
yarn_hydrate() {
	if [[ "${YARN_OFFLINE:-1}" == "0" ]] ; then
		COREPACK_ENABLE_NETWORK="1"
	else
		COREPACK_ENABLE_NETWORK="${COREPACK_ENABLE_NETWORK:-0}"
	fi
	local npm_slot=${NPM_SLOT:-3}
	local yarn_slot=${YARN_SLOT:-1}
	if [[ ! -f "${EROOT}/usr/share/npm/npm-${npm_slot}.tgz" ]] ; then
eerror
eerror "Missing ${EROOT}/usr/share/npm/npm-${npm_slot}.tgz"
eerror
eerror "You must install sys-apps/npm:${npm_slot}::oiledmachine-overlay to"
eerror "continue."
eerror
		die
	fi
	if [[ ! -f "${EROOT}/usr/share/yarn/yarn-${yarn_slot}.tgz" ]] ; then
eerror
eerror "Missing ${EROOT}/usr/share/yarn/yarn-${yarn_slot}.tgz"
eerror
eerror "You must install sys-apps/yarn:${yarn_slot}::oiledmachine-overlay to"
eerror "continue."
eerror
		die
	fi
einfo "Hydrating npm..."
	corepack hydrate --activate "${ESYSROOT}/usr/share/npm/npm-${npm_slot}.tgz" || die
einfo "Hydrating yarn..."
	corepack hydrate --activate "${ESYSROOT}/usr/share/yarn/yarn-${yarn_slot}.tgz" || die
	__npm_patch
	local npm_pv=$(basename $(realpath "${HOME}/.cache/node/corepack/npm/"*))
	local yarn_pv=$(basename $(realpath "${HOME}/.cache/node/corepack/yarn/"*))
	export PATH="${HOME}/.cache/node/corepack/npm/${npm_pv}/bin:${PATH}"
	export PATH="${HOME}/.cache/node/corepack/yarn/${yarn_pv}/bin:${PATH}"
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
			_yarn_src_unpack_update_ebuild
		else
			_yarn_src_unpack_update_upstream
		fi
		die
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
	grep -q -e "\"${cmd}\"" package.json || return
	local args=()
	yarn run ${cmd} \
		--prefer-offline \
		--pure-lockfile \
		--verbose \
		|| die
	grep -q -e "ENOENT" "${T}/build.log" && die "Retry"
	grep -q -e " ERR! Exit handler never called!" "${T}/build.log" && die "Possible indeterministic behavior"
	grep -q -e "MODULE_NOT_FOUND" "${T}/build.log" && die "Detected error"
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
		if [[ -n "${NODE_VERSION}" ]] ; then
			dodir /usr/bin
cat <<EOF > "${ED}/usr/bin/${name}"
#!/bin/bash
NODE_VERSION=${NODE_VERSION}
"${YARN_INSTALL_PATH}/${cmd}" "\$@"
EOF
			fperms 0755 "/usr/bin/${name}"
		else
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
