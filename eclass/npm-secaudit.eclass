# Copyright 2019-2022 Orson Teodoro
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: npm-secaudit.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for CLI based nodejs packages
# @DESCRIPTION:
# The npm-secaudit eclass defines phase functions and utility for npm packages.
# It depends on the app-portage/npm-secaudit package to maintain a
# secure environment.
#
# It was intended to replace the insecure npm.eclass implementations and
# reduce packaging time.
#

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

inherit npm-utils

EXPORT_FUNCTIONS pkg_setup src_unpack

# ############## START Per-package environmental variables #####################

# See npm-secaudit_pkg_setup_per_package_environment_variables() for details.


# ##################  END Per-package environmental variables ##################

# ##################  START ebuild and eclass global variables #################

# See https://nodejs.dev/en/about/releases/
NODE_VERSION_UNSUPPORTED_WHEN_LESS_THAN="14"

# See https://github.com/microsoft/TypeScript/blob/v2.0.7/package.json
if [[ -n "${NPM_SECAUDIT_TYPESCRIPT_PV}" ]] && ( \
	ver_test $(ver_cut 1-2 "${NPM_SECAUDIT_TYPESCRIPT_PV}") -ge 2.0 \
	&& ver_test $(ver_cut 1-3 "${NPM_SECAUDIT_TYPESCRIPT_PV}") -le 2.1.4 ) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-0.8.0
	"
elif [[ -n "${NPM_SECAUDIT_TYPESCRIPT_PV}" ]] && ( \
	ver_test $(ver_cut 1-3 "${NPM_SECAUDIT_TYPESCRIPT_PV}") -ge 2.1.5 \
	&& ver_test $(ver_cut 1 "${NPM_SECAUDIT_TYPESCRIPT_PV}") -le 9999 ) ; then
	COMMON_DEPEND+="
		>=net-libs/nodejs-4.2.0
	"
fi

# See https://github.com/DefinitelyTyped/DefinitelyTyped/blob/master/types/node/vX/index.d.ts , \
#   where X is a number connected to the Node.js version
# The following conditional chain is for @types/node:
if [[ -n "${NPM_SECAUDIT_AT_TYPES_NODE_PV}" ]] \
	&& ver_test $(ver_cut 1 "${NPM_SECAUDIT_AT_TYPES_NODE_PV}") -eq 0 ; then
	COMMON_DEPEND+=" =net-libs/nodejs-0"
elif [[ -n "${NPM_SECAUDIT_AT_TYPES_NODE_PV}" ]] \
	&& ver_test $(ver_cut 1 "${NPM_SECAUDIT_AT_TYPES_NODE_PV}") -eq 4 ; then
	COMMON_DEPEND+=" =net-libs/nodejs-4"
elif [[ -n "${NPM_SECAUDIT_AT_TYPES_NODE_PV}" ]] \
	&& ver_test $(ver_cut 1 "${NPM_SECAUDIT_AT_TYPES_NODE_PV}") -eq 6 ; then
	COMMON_DEPEND+=" =net-libs/nodejs-6*"
elif [[ -n "${NPM_SECAUDIT_AT_TYPES_NODE_PV}" ]] \
	&& ver_test $(ver_cut 1 "${NPM_SECAUDIT_AT_TYPES_NODE_PV}") -eq 7 ; then
	COMMON_DEPEND+=" =net-libs/nodejs-7*"
elif [[ -n "${NPM_SECAUDIT_AT_TYPES_NODE_PV}" ]] \
	&& ver_test $(ver_cut 1 "${NPM_SECAUDIT_AT_TYPES_NODE_PV}") -eq 8 ; then
	COMMON_DEPEND+=" =net-libs/nodejs-8*"
elif [[ -n "${NPM_SECAUDIT_AT_TYPES_NODE_PV}" ]] \
	&& ver_test $(ver_cut 1 "${NPM_SECAUDIT_AT_TYPES_NODE_PV}") -eq 9 ; then
	COMMON_DEPEND+=" =net-libs/nodejs-9*"
elif [[ -n "${NPM_SECAUDIT_AT_TYPES_NODE_PV}" ]] \
	&& ver_test $(ver_cut 1 "${NPM_SECAUDIT_AT_TYPES_NODE_PV}") -eq 10 ; then
	COMMON_DEPEND+=" =net-libs/nodejs-10*"
elif [[ -n "${NPM_SECAUDIT_AT_TYPES_NODE_PV}" ]] \
	&& ver_test $(ver_cut 1 "${NPM_SECAUDIT_AT_TYPES_NODE_PV}") -eq 11 ; then
	COMMON_DEPEND+=" =net-libs/nodejs-11*"
elif [[ -n "${NPM_SECAUDIT_AT_TYPES_NODE_PV}" ]] \
	&& ver_test $(ver_cut 1 "${NPM_SECAUDIT_AT_TYPES_NODE_PV}") -eq 12 ; then
	COMMON_DEPEND+=" =net-libs/nodejs-12*"
elif [[ -n "${NPM_SECAUDIT_AT_TYPES_NODE_PV}" ]] \
	&& ver_test $(ver_cut 1 "${NPM_SECAUDIT_AT_TYPES_NODE_PV}") -eq 13 ; then
	COMMON_DEPEND+=" =net-libs/nodejs-13*"
elif [[ -n "${NPM_SECAUDIT_AT_TYPES_NODE_PV}" ]] \
	&& ver_test $(ver_cut 1 "${NPM_SECAUDIT_AT_TYPES_NODE_PV}") -eq 14 ; then
	COMMON_DEPEND+=" =net-libs/nodejs-14*"
elif [[ -n "${NPM_SECAUDIT_AT_TYPES_NODE_PV}" ]] \
	&& ver_test $(ver_cut 1 "${NPM_SECAUDIT_AT_TYPES_NODE_PV}") -eq 15 ; then
	COMMON_DEPEND+=" =net-libs/nodejs-15*"
elif [[ -n "${NPM_SECAUDIT_AT_TYPES_NODE_PV}" ]] \
	&& ver_test $(ver_cut 1 "${NPM_SECAUDIT_AT_TYPES_NODE_PV}") -eq 16 ; then
	COMMON_DEPEND+=" =net-libs/nodejs-16*"
elif [[ -n "${NPM_SECAUDIT_AT_TYPES_NODE_PV}" ]] \
	&& ver_test $(ver_cut 1 "${NPM_SECAUDIT_AT_TYPES_NODE_PV}") -eq 17 ; then
	COMMON_DEPEND+=" =net-libs/nodejs-17*"
fi

DEPEND+="
	${COMMON_DEPEND}
"
RDEPEND+="
	${COMMON_DEPEND}
"

# ##################  END ebuild and eclass global variables ###################

# @FUNCTION: npm-secaudit_pkg_setup_per_package_environment_variables
# @DESCRIPTION:
# Initalizes per package environment variables
npm-secaudit_pkg_setup_per_package_environment_variables() {
	npm-utils_pkg_setup

	# Accepts production or development [or unset as development]
	export NODE_ENV=${NODE_ENV:-production}
	if [[ "${NODE_ENV}" == "production" ]] ; then
einfo "NODE_ENV=production"
	else
einfo "NODE_ENV=development"
	fi

	# The following could be define as a per-package envar:
	# They are not recommended to set these in the in the ebuild.

	# Set this in your make.conf to control number of HTTP requests.  50 is
	# npm default but it is too high.
	NPM_MAXSOCKETS=${NPM_MAXSOCKETS:-"1"}

	NPM_SECAUDIT_ALLOW_AUDIT_FIX=${NPM_SECAUDIT_ALLOW_AUDIT_FIX:-"1"}

	# Applies to only vulnerability testing not the tool itself.
	# If set to 1, it will stop emerging.  Otherwise, it will install it.
	NPM_SECAUDIT_NO_DIE_ON_AUDIT=${NPM_SECAUDIT_NO_DIE_ON_AUDIT:-"0"}

	# Allow to audit Chromium versions for EOL (End Of Life meaning most
	# likely vulnerable).
	NPM_SECAUDIT_CHECK_CHROMIUM=${NPM_SECAUDIT_CHECK_CHROMIUM:-"1"}

	# Disabled by default because of rapid changes in dependencies over a
	# short period of time.
	NPM_SECAUDIT_ALLOW_AUDIT_FIX_AT_EBUILD_LEVEL=${NPM_SECAUDIT_ALLOW_AUDIT_FIX_AT_EBUILD_LEVEL:-"0"}
}


# @FUNCTION: npm-secaudit_pkg_setup
# @DESCRIPTION:
# Initializes globals
npm-secaudit_pkg_setup() {
        debug-print-function ${FUNCNAME} "${@}"

	npm-secaudit_pkg_setup_per_package_environment_variables

	if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package"
eerror "env to be able to download micropackages."
eerror
		die
	fi

	# For @electron/get caches used by electron-packager and
	# electron-builder, see
# https://github.com/electron/get#using-environment-variables-for-mirror-options
	# export ELECTRON_CUSTOM_DIR="${ELECTRON_APP_DATA_DIR}/at-electron-get"
	# mkdir -p ${ELECTRON_CUSTOM_DIR} || die

	# Caches are stored in the sandbox because it is faster and less
	# problematic as in part of the cache will be owned by root and
	# the other by portage.  By avoiding irrelevant checking and resetting
	# file ownership of packages used by other apps, we speed it up.
	export NPM_STORE_DIR="${HOME}/npm" # npm cache location
	export npm_config_cache="${NPM_STORE_DIR}"
	export npm_config_maxsockets=${NPM_MAXSOCKETS}
	mkdir -p "${NPM_STORE_DIR}/offline"
	chown -R portage:portage "${NPM_STORE_DIR}"


	addwrite "${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"

	if has_version "<net-libs/nodejs-${NODE_VERSION_UNSUPPORTED_WHEN_LESS_THAN}" ; then
ewarn
ewarn "You have a net-libs/nodejs less than ${NODE_VERSION_UNSUPPORTED_WHEN_LESS_THAN}"
ewarn "installed which is End Of Life (EOL) and has vulnerabilities."
ewarn
	fi

	local found_unsupported_node=0
	for x in $(seq 1 30) ; do
		if npm-utils_check_node_eol "${x}" \
			&& has_version "=net-libs/nodejs-${x}*" ; then
ewarn "Found EOL =net-libs/nodejs-${x}*"
			found_unsupported=1
		fi
	done

	if (( ${found_unsupported_node} == 1 )) ; then
ewarn
ewarn "You have a nodejs that is EOL and has likely vulnerabilities."
ewarn
	fi

	npm-utils_is_nodejs_header_exe_same
	if [[ -n "${NODEJS_BDEPEND}" ]] ; then
		npm-utils_check_nodejs "${NODEJS_BDEPEND}"
	elif [[ -n "${BDEPEND}" ]] ; then
		npm-utils_check_nodejs "${BDEPEND}"
	elif [[ -n "${DEPEND}" ]] ; then
		npm-utils_check_nodejs "${DEPEND}"
	fi

	npm-utils_check_chromium_eol ${CHROMIUM_PV}
}

# @FUNCTION: npm-secaudit_fetch_deps
# @DESCRIPTION:
# Builds an electron app with security checks
# MUST be called after default unpack AND patching.
npm-secaudit_fetch_deps() {
	pushd "${S}" || die
		local install_args=()
		# Avoid adding fsevent (a MacOS dependency) which may require
		# older node
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
einfo
einfo "Running npm install ${install_args[@]} inside npm-secaudit_fetch_deps"
einfo
		npm install ${install_args[@]} || die
		npm_check_npm_error
	popd
}

# @FUNCTION: npm-secaudit_src_unpack
# @DESCRIPTION:
# Runs phases for downloading dependencies, unpacking, building
npm-secaudit_src_unpack() {
        debug-print-function ${FUNCNAME} "${@}"

	if [[ -n "${NODE_VERSION}" ]] ; then
		local node_header_pv=$(grep \
			"NODE_MAJOR_VERSION" \
			"${ESYSROOT}/usr/include/node/node_version.h" \
			| head -n 1 \
			| cut -f 3 -d " ")
		if ver_test \
			$(ver_cut 1 ${node_header_pv}) \
			-ne \
			$(ver_cut 1 ${NODE_VERSION}) ; then
eerror
eerror "Node header version:\t\t${node_header_pv}"
eerror "Ebuild selected version:\t${NODE_VERSION}"
eerror
eerror "Switch the headers to ${NODE_VERSION}."
eerror "Did you perform \`eselect nodejs set node${NODE_VERSION}\`"
eerror
			die
		fi
	fi

	cd "${WORKDIR}"

	if [[ ! -d "${S}" ]] ; then
		default_src_unpack
	fi

	# All the phase hooks get run in unpack because of download restrictions

	cd "${S}" || die
	if declare -f npm-secaudit_src_preprepare > /dev/null ; then
		npm-secaudit_src_preprepare
	fi

	npm-utils_check_chromium_eol ${CHROMIUM_PV}

	cd "${S}" || die
	if declare -f npm-secaudit_src_prepare > /dev/null ; then
		npm-secaudit_src_prepare
	else
		npm-secaudit_src_prepare_default
	fi

	cd "${S}" || die
	npm-secaudit_audit_fix

	cd "${S}" || die
	if declare -f npm-secaudit_src_postprepare > /dev/null ; then
		npm-secaudit_src_postprepare
	fi

	npm-utils_check_chromium_eol ${CHROMIUM_PV}

	cd "${S}" || die
	if declare -f npm-secaudit_src_compile > /dev/null ; then
		npm-secaudit_src_compile
	else
		npm-secaudit_src_compile_default
	fi

	cd "${S}"
	if declare -f npm-secaudit_src_postcompile > /dev/null ; then
		npm-secaudit_src_postcompile
	fi

	cd "${S}"
	if declare -f npm-secaudit_src_preinst > /dev/null ; then
		npm-secaudit_src_preinst
	else
		npm-secaudit_src_preinst_default
	fi
}

# @FUNCTION: npm-secaudit_src_prepare_default
# @DESCRIPTION:
# Fetches dependencies and audit fixes them.  Currently a stub.  TODO per package patching support.
npm-secaudit_src_prepare_default() {
        debug-print-function ${FUNCNAME} "${@}"

	cd "${S}"
	npm-secaudit_fetch_deps
	cd "${S}"
	#default_src_prepare
}

# @FUNCTION: npm-secaudit_src_install_default
# @DESCRIPTION:
# Installs the program.  Analog of electron-app_desktop_install.
npm-secaudit_src_install_default() {
        debug-print-function ${FUNCNAME} "${@}"
	local rel_src_path="$1"
	local cmd="$2"

	npm-secaudit_install "${rel_src_path}"

	# Create wrapper
	exeinto "/usr/bin"
	echo "#!/bin/bash" > "${T}/${PN}"
	if [[ -n "${NODE_VERSION}" ]] ; then
einfo "Setting NODE_VERSION=${NODE_VERSION} in wrapper."
		echo "export NODE_VERSION=${NODE_VERSION}" >> "${T}/${PN}"
	fi
	if [[ "${NODE_ENV}" == "production" ]] ; then
einfo "Setting NODE_ENV=\${NODE_ENV:-production} in wrapper."
		echo "export NODE_ENV=\${NODE_ENV:-production}" >> "${T}/${PN}"
	else
einfo "Setting NODE_ENV=\${NODE_ENV:-development} in wrapper."
		echo "export NODE_ENV=\${NODE_ENV:-development}" >> "${T}/${PN}"
	fi
	echo "${cmd} \"\${@}\"" >> "${T}/${PN}"
	doexe "${T}/${PN}"

	npm-secaudit_store_jsons_for_security_audit
}

# @FUNCTION: npm-secaudit-build
# @DESCRIPTION:
# Builds an electron app
npm-secaudit-build() {
	# electron-builder can still pull packages at the build step.
	npm run build || die
}

# @FUNCTION: npm-secaudit_src_compile_default
# @DESCRIPTION:
# Builds an electron app
npm-secaudit_src_compile_default() {
        debug-print-function ${FUNCNAME} "${@}"

	cd "${S}"

	npm-secaudit-build
}

# @FUNCTION: _npm-secaudit_audit_fix
# @DESCRIPTION:
# Removes vulnerable packages.  It will audit every folder containing a package-lock.json
npm-secaudit_audit_fix() {
	if [[ -n "${NPM_SECAUDIT_ALLOW_AUDIT_FIX}" && "${NPM_SECAUDIT_ALLOW_AUDIT_FIX}" == "1" ]] ; then
		:;
	else
		return
	fi

einfo
einfo "Performing recursive package-lock.json audit fix"
einfo
	npm_update_package_locks_recursive ./ # calls npm_pre_audit
einfo
einfo "Audit fix done"
einfo
}


# @FUNCTION: npm-secaudit_src_preinst_default
# @DESCRIPTION:
# Dummy function
npm-secaudit_src_preinst_default() {
	true
}

# @FUNCTION: _npm-secaudit_check_missing_install_path
# @DESCRIPTION:
# Checks if NPM_SECAUDIT_INSTALL_PATH has been defined.
_npm-secaudit_check_missing_install_path() {
	if [[ -z "${NPM_SECAUDIT_INSTALL_PATH}" ]] ; then
eerror
eerror "You must specify NPM_SECAUDIT_INSTALL_PATH.  Usually same location as"
eerror "/usr/\$(get_libdir)/node/\${PN}/\${SLOT} without \$ED."
eerror
		die
	fi
}

# @FUNCTION: npm-secaudit_install_raw
# @DESCRIPTION:
# Installs an app to image area before going live.  Does not reset permissions or owner.
# It's recommended to use npm-secaudit_install instead.
npm-secaudit_install_raw() {
	_npm-secaudit_check_missing_install_path
	local rel_src_path="$1"

	local old_dotglob=$(shopt dotglob | cut -f 2)
	shopt -s dotglob # copy hidden files

	local d="${NPM_SECAUDIT_INSTALL_PATH}"
	local ed="${ED}/${d}"

	mkdir -p "${ed}"
	cp -a ${rel_src_path} "${ed}"

	if [[ "${old_dotglob}" == "on" ]] ; then
		shopt -s dotglob
	else
		shopt -u dotglob
	fi
}

# @FUNCTION: npm-secaudit_install
# @DESCRIPTION:
# Installs an app to image area before going live resetting permissions and owner.
# Resets ownership and permissions.
# Additional change of ownership and permissions should be done after running this.
npm-secaudit_install() {
	_npm-secaudit_check_missing_install_path
	local rel_src_path="$1"

	local old_dotglob=$(shopt dotglob | cut -f 2)
	shopt -s dotglob # copy hidden files

	local d="${NPM_SECAUDIT_INSTALL_PATH}"
	local ed="${ED}/${d}"
	insinto "${d}"
	doins -r ${rel_src_path}

	for f in $(find "${ed}" -type f) ; do
		if file "${f}" | grep "executable" ; then
			chmod 0755 $(realpath "${f}") || die
		elif file "${f}" | grep "shared object" ; then
			chmod 0755 $(realpath "${f}") || die
		fi
	done

	if [[ "${old_dotglob}" == "on" ]] ; then
		shopt -s dotglob
	else
		shopt -u dotglob
	fi
}

# For single exe packaging see:
# See npm-utils_download_pkg in npm-utils.eclass
# See npm-utils_src_compile_pkg in npm-utils.eclass
