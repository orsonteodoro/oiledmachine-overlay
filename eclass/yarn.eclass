# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: yarn.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for offline install for npm/yarn eclass
# @DESCRIPTION:
# Eclass similar to the cargo.eclass.

# Requirements:  yarn.lock or package.json -> package-lock.json -> yarn.lock
# For the URI generator, see the scripts/yarn_updater_transform_uris.sh and
# yarn_updater_update_locks.sh scripts.

# For package.json -> yarn.lock:
# (The network-sandbox needs to be disabled temporarily.)
# npm i            # or use npm i --prod
# npm audit fix
# yarn import

# When creating a lockfile, one of the dev dependencies may have vanished.
# If it fails with:
#
#   error Failed to import from package-lock.json, source file(s) corrupted
#
# Try with `npm i --prod` to generate the lockfile.

# The yarn.lock must be regenerated for security updates every week.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

EXPORT_FUNCTIONS pkg_setup src_unpack src_compile src_test src_install

BDEPEND+="
	app-misc/jq
"
# Eclass requires yarn >= 2.x

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
# Must be process through a URI transformer.  See tensorboard ebuild.
# Git snapshot URIs must manually added and look like:
# https://github.com/angular/dev-infra-private-build-tooling-builds/archive/<commit-id>.tar.gz -> yarnpkg-dev-infra-private-build-tooling-builds.git-<commit-id>.tgz

# @ECLASS_VARIABLE: YARN_INSTALL_PATH
# @DESCRIPTION:
# The destination install path relative to EROOT.

# @ECLASS_VARIABLE: YARN_INSTALL_UNPACK_ARGS
# @DESCRIPTION:
# Arguments to append to `npm i ` during package-lock.json generation.

# @ECLASS_VARIABLE: YARN_INSTALL_UNPACK_AUDIT_FIX_ARGS
# @DESCRIPTION:
# Arguments to append to `npm audit fix ` during package-lock.json generation.

# @ECLASS_VARIABLE: YARN_ROOT
# @DESCRIPTION:
# The project root containing the yarn.lock file.

# @ECLASS_VARIABLE: YARN_TARBALL
# @DESCRIPTION:
# The main package tarball.

# @ECLASS_VARIABLE: YARN_TEST_SCRIPT
# @DESCRIPTION:
# The test script to run from package.json:scripts section.

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
# Corepack problems.  Cannot do complete offline install.
			if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package"
eerror "env to be able to download micropackages."
eerror
				die
			fi
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
eerror "Did not find an installed nodejs slot."
eerror "Expected node versions:  ${NODE_SLOTS}"
eerror "See eselect nodejs for details."
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
eerror "Did not find an installed nodejs slot."
eerror "Expected node version:  ${NODE_VERSION}"
eerror "See eselect nodejs for details."
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
			cat "${DISTDIR}/${bn}" > "${dest}/${bn/yarnpkg-}" || die
		fi
	done
	IFS=$' \t\n'
}

# @FUNCTION: _yarn_src_unpack_default
# @DESCRIPTION:
# Unpacks a yarn application.
_yarn_src_unpack_default() {
	if [[ -n "${YARN_TARBALL}" ]] ; then
		unpack ${YARN_TARBALL}
	else
		unpack ${P}.tar.gz
	fi
	yarn_check
	_yarn_cp_tarballs
	cd "${S}" || die
	rm -rf "package-lock.json" || true
	if [[ -n "${YARN_ROOT}" ]] ; then
		rm -rf "${YARN_ROOT}/.yarnrc" || die
	fi
	rm -rf "${S}/.yarnrc" || die
	yarn config set yarn-offline-mirror ./npm-packages-offline-cache || die
	mv "${HOME}/.yarnrc" "${WORKDIR}" || die
	if [[ -f "${FILESDIR}/${PV}/yarn.lock" && -n "${YARN_ROOT}" ]] ; then
		cp "${FILESDIR}/${PV}/yarn.lock" "${YARN_ROOT}" || die
	elif [[ -f "${FILESDIR}/${PV}/yarn.lock" ]] ; then
		cp "${FILESDIR}/${PV}/yarn.lock" "${S}" || die
	fi
	if [[ -f "${FILESDIR}/${PV}/package.json" && -n "${YARN_ROOT}" ]] ; then
		cp "${FILESDIR}/${PV}/package.json" "${YARN_ROOT}" || die
	elif [[ -f "${FILESDIR}/${PV}/package.json" ]] ; then
		cp "${FILESDIR}/${PV}/package.json" "${S}" || die
	fi
	local args=()
	yarn install \
		--prefer-offline \
		--pure-lockfile \
		--verbose \
		${YARN_INSTALL_UNPACK_ARGS} \
		|| die
}

# @FUNCTION: _npm_run
# @DESCRIPTION:
# Rerun command if flakey connection.
_npm_run() {
	local cmd=("${@}")
	local tries
	tries=0
	while (( ${tries} < 5 )) ; do
einfo "Tries:\t${tries}"
einfo "Running:\t${cmd[@]}"
		"${cmd[@]}" || die
		if ! grep -q -r -e "ERR_SOCKET_TIMEOUT" "${HOME}/.npm/_logs" ; then
			break
		fi
		rm -rf "${HOME}/.npm/_logs"
		tries=$((${tries} + 1))
	done
	[[ -f package-lock.json ]] || die "Missing package-lock.json for audit fix"
}

# @FUNCTION: _yarn_src_unpack
# @DESCRIPTION:
# Unpacks a yarn application.
yarn_src_unpack() {
	if [[ "${YARN_UPDATE_LOCK}" == "1" ]] ; then
		unpack ${P}.tar.gz
		cd "${S}" || die
		rm -f package-lock.json
		rm -f yarn.lock

		if declare -f \
			yarn_update_lock_install_pre > /dev/null ; then
			yarn_update_lock_install_pre
		fi
		_npm_run npm i ${YARN_INSTALL_UNPACK_ARGS}
		if declare -f \
			yarn_update_lock_install_post > /dev/null ; then
			yarn_update_lock_install_post
		fi
		if declare -f \
			yarn_update_lock_audit_pre > /dev/null ; then
			yarn_update_lock_audit_pre
		fi
		_npm_run npm audit fix ${YARN_INSTALL_UNPACK_AUDIT_FIX_ARGS}
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
}

# @FUNCTION: yarn_src_compile
# @DESCRIPTION:
# Builds a yarn application.
yarn_src_compile() {
	yarn_check
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
		fperms 0755 "${path}" || die
	done
	IFS=$' \t\n'
}
