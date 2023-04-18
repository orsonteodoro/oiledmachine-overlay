# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
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

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_NPM_ECLASS} ]]; then
_NPM_ECLASS=1

EXPORT_FUNCTIONS pkg_setup src_unpack src_compile src_test src_install

BDEPEND+="
	app-misc/jq
"

_npm_set_globals() {
	NPM_TRIES="${NPM_TRIES:-10}"
}
_npm_set_globals
unset -f _npm_set_globals

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

# @ECLASS_VARIABLE: NPM_INSTALL_UNPACK_ARGS
# @DESCRIPTION:
# Arguments to append to `npm i ` during package-lock.json generation.

# @ECLASS_VARIABLE: NPM_INSTALL_UNPACK_AUDIT_FIX_ARGS
# @DESCRIPTION:
# Arguments to append to `npm audit fix ` during package-lock.json generation.

# @ECLASS_VARIABLE: NPM_ROOT
# @DESCRIPTION:
# The project root containing the package-lock.json file.

# @ECLASS_VARIABLE: NPM_TARBALL
# @DESCRIPTION:
# The main package tarball.

# @ECLASS_VARIABLE: NPM_TEST_SCRIPT
# @DESCRIPTION:
# The test script to run from package.json:scripts section.

# @ECLASS_VARIABLE: NPM_TRIES
# @DESCRIPTION:
# The number of reconnect tries.

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

# @FUNCTION: _npm_cp_tarballs
# @INTERNAL
# @DESCRIPTION:
# Copies all tarballs to the offline cache
_npm_cp_tarballs() {
	local dest="${WORKDIR}/npm-packages-offline-cache"
	mkdir -p "${dest}" || die
	IFS=$'\n'
	local uri
	for uri in ${NPM_EXTERNAL_URIS} ; do
		local bn
		if [[ "${uri}" =~ "->" && "${uri}" =~ ".git" ]] ; then
			bn=$(echo "${uri}" \
				| cut -f 3 -d " ")
einfo "Copying ${DISTDIR}/${bn} -> ${dest}/${bn/npmpkg-}"
			local fn="${bn/npmpkg-}"
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
einfo "Copying ${DISTDIR}/${bn} -> ${dest}/${bn/npmpkg-}"
			cp -a "${DISTDIR}/${bn}" "${dest}/${bn/npmpkg-}" || die
		fi
	done
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
			| cut -f 1 -d ".")
		echo "${project_name}.git-${commit_id}.tgz"
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

# @FUNCTION: npm_transform_uris_default
# @DESCRIPTION:
# Convert package-lock.json for offline install.
npm_transform_uris_default() {
	local lockfile
	for lockfile in $(find . -name "package-lock.json") ; do
		IFS=$'\n'
		local uri
		for uri in $(grep -E -o \
			-e "http[s]?://registry.npmjs.org/([@a-zA-Z0-9._-]+/)+-/([@a-zA-Z0-9._-]+.tgz)" \
			-e "git\+https://git@github.com[^#]+#[a-zA-Z0-9]+" \
			-e "git\+ssh://git@github.com[^#]+#[a-zA-Z0-9]+" \
			"${lockfile}") ; do
			local bn=$(basename "${uri}")
			local newname=$(npm_gen_new_name "${uri}")
			sed -i -e "s|${uri}|file:${WORKDIR}/npm-packages-offline-cache/${newname}|g" "${lockfile}" || die
		done
		IFS=$' \t\n'
		if grep -q "registry.npmjs.org" "${lockfile}" ; then
eerror
eerror "Detected URI in lockfile that is not converted to offline format."
eerror "File:  ${lockfile}"
eerror
			die
		fi
	done
}

# @FUNCTION: _npm_src_unpack_default
# @DESCRIPTION:
# Unpacks a npm application.
_npm_src_unpack_default() {
	if [[ "${NPM_OFFLINE:-1}" == "1" ]] ; then
		export ELECTRON_SKIP_BINARY_DOWNLOAD=1
	fi
	if [[ ${PV} =~ 9999 ]] ; then
		:;
	elif [[ -n "${NPM_TARBALL}" ]] ; then
		unpack ${NPM_TARBALL}
	else
		unpack ${P}.tar.gz
	fi
	cd "${S}" || die
	if [[ "${NPM_OFFLINE:-1}" == "1" ]] ; then
		_npm_cp_tarballs
		rm -rf "package-lock.json" || true
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
		if declare -f npm_transform_uris > /dev/null ; then
			# For repo
			npm_transform_uris
		else
			npm_transform_uris_default
		fi
	fi
	local args=()
	if declare -f npm_unpack_install_pre > /dev/null ; then
		npm_unpack_install_pre
	fi
	local extra_args=()
	if [[ "${NPM_OFFLINE:-1}" == "1" ]] ; then
		extra_args+=( "--prefer-offline" )
	fi
	enpm install \
		${extra_args[@]} \
		${NPM_INSTALL_UNPACK_ARGS}
	if declare -f npm_unpack_install_post > /dev/null ; then
		npm_unpack_install_post
	fi
}

# @FUNCTION: _npm_auto_rename
# @INTERNAL
# @DESCRIPTION:
# Auto-rename dir
_npm_auto_rename() {
	local row
	IFS=$'\n'
	for row in $(grep -r -e "ENOTEMPTY: directory not empty, rename" "${HOME}/.npm/_logs") ; do
		local from=$(echo "${row}" | cut -f 2 -d "'")
		local to=$(echo "${row}" | cut -f 4 -d "'")
		if [[ -e "${from}" ]] ; then
			local ts=$(date "+%s")
einfo "Moving ${from} -> ${to}.${ts}"
			mv "${from}" "${to}.${ts}" || true
			sed -i -e "\|${to}|d" "${T}/build.log" || die
		fi
	done
	IFS=$' \t\n'
}

# @FUNCTION: _npm_auto_remove_node_modules
# @INTERNAL
# @DESCRIPTION:
# Removes all node_modules folders
_npm_auto_remove_node_modules() {
	local row
	IFS=$'\n'
	if grep -r -e "ENOTEMPTY: directory not empty, rename" "${HOME}/.npm/_logs" ; then
		find . -type d -name "node_modules" -exec rm -rf '{}' \;
	fi
	IFS=$' \t\n'
}

# @FUNCTION: enpm
# @DESCRIPTION:
# Wrapper for the npm command.
# Rerun command if flakey connection.
enpm() {
	local cmd=("${@}")
	local tries
	tries=0
	while (( ${tries} < ${NPM_TRIES} )) ; do
einfo "Tries:\t${tries}"
einfo "Running:\tnpm ${cmd[@]}"
		npm "${cmd[@]}" || die
		if ! grep -q -E -r -e "(ENOTEMPTY|ERR_SOCKET_TIMEOUT|ETIMEDOUT)" "${HOME}/.npm/_logs" ; then
			break
		fi
		_npm_auto_remove_node_modules
		if grep -q -E -r -e "(ERR_SOCKET_TIMEOUT|ETIMEDOUT)" "${HOME}/.npm/_logs" ; then
			tries=$((${tries} + 1))
		fi
		rm -rf "${HOME}/.npm/_logs"
	done
	[[ -f package-lock.json ]] || die "Missing package-lock.json for audit fix"
}

# @FUNCTION: _npm_src_unpack
# @DESCRIPTION:
# Unpacks a npm application.
npm_src_unpack() {
	export PATH="${S}/node_modules/.bin:${PATH}"
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
		if [[ ${PV} =~ 9999 ]] ; then
			:;
		elif [[ -n "${NPM_TARBALL}" ]] ; then
			unpack ${NPM_TARBALL}
		else
			unpack ${P}.tar.gz
		fi
		cd "${S}" || die
		rm -f package-lock.json

		if declare -f \
			npm_update_lock_install_pre > /dev/null ; then
			npm_update_lock_install_pre
		fi
		enpm i ${NPM_INSTALL_UNPACK_ARGS}
		if declare -f \
			npm_update_lock_install_post > /dev/null ; then
			npm_update_lock_install_post
		fi
		if declare -f \
			npm_update_lock_audit_pre > /dev/null ; then
			npm_update_lock_audit_pre
		fi
		enpm audit fix ${NPM_INSTALL_UNPACK_AUDIT_FIX_ARGS}
		if declare -f \
			npm_update_lock_audit_post > /dev/null ; then
			npm_update_lock_audit_post
		fi

		die
	else
		if [[ "${NPM_OFFLINE:-1}" == "1" ]] ; then
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
}

# @FUNCTION: npm_src_compile
# @DESCRIPTION:
# Builds a npm application.
npm_src_compile() {
	[[ "${NPM_BUILD_SCRIPT}" == "none" ]] && return
	[[ "${NPM_BUILD_SCRIPT}" == "null" ]] && return
	[[ "${NPM_BUILD_SCRIPT}" == "skip" ]] && return
	local cmd="${NPM_BUILD_SCRIPT:-build}"
	grep -q -e "\"${cmd}\"" package.json || return
	local extra_args=()
	if [[ "${NPM_OFFLINE:-1}" == "1" ]] ; then
		extra_args+=( "--prefer-offline" )
	fi
	npm run ${cmd} \
		${extra_args[@]} \
		|| die
	grep -q -e "ENOENT" "${T}/build.log" && die
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
"${NPM_INSTALL_PATH}/${cmd}" "\$@"
EOF
			fperms 0755 "/usr/bin/${name}"
		else
			dosym "${NPM_INSTALL_PATH}/${cmd}" "/usr/bin/${name}"
		fi
	done
	local path
	for path in ${NPM_EXE_LIST} ; do
		fperms 0755 "${path}" || die
	done
	IFS=$' \t\n'
}

fi
