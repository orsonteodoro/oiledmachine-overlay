# Copyright 2019-2020 Orson Teodoro
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: npm-secaudit.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 6 7
# @BLURB: Eclass for CLI based nodejs packages
# @DESCRIPTION:
# The npm-secaudit eclass defines phase functions and utility for npm packages.
# It depends on the app-portage/npm-secaudit package to maintain a
# secure environment.
#
# It was intended to replace the insecure npm.eclass implementations and
# reduce packaging time.
#

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

inherit eutils npm-utils

EXPORT_FUNCTIONS pkg_setup src_unpack pkg_postrm pkg_postinst

# ############## START Per-package environmental variables #####################

# Set this in your make.conf to control number of HTTP requests.  50 is npm
# default but it is too high.
NPM_MAXSOCKETS=${NPM_MAXSOCKETS:="1"}

# You could define it as a per-package envar.  It not recommended in the ebuild.
NPM_SECAUDIT_ALLOW_AUDIT=${NPM_SECAUDIT_ALLOW_AUDIT:="1"}

# You could define it as a per-package envar.  It not recommended in the ebuild.
NPM_SECAUDIT_ALLOW_AUDIT_FIX=${NPM_SECAUDIT_ALLOW_AUDIT_FIX:="1"}

# You could define it as a per-package envar.  It not recommended in the ebuild.
NPM_SECAUDIT_NO_DIE_ON_AUDIT=${NPM_SECAUDIT_NO_DIE_ON_AUDIT:="0"}

# You could define it as a per-package envar.  Disabled by default because of
# rapid changes in dependencies over a short period of time.
NPM_SECAUDIT_ALLOW_AUDIT_FIX_AT_EBUILD_LEVEL=${NPM_SECAUDIT_ALLOW_AUDIT_FIX_AT_EBUILD_LEVEL:="0"}

# Acceptable values:  Critical, High, Moderate, Low
# Applies to npm audit not CVSS v3
# For those that are confused, this is interpeted as tolerance level meaning
# >=$NPM_SECAUDIT_UNACCEPTABLE_VULNERABILITY_LEVEL.
NPM_SECAUDIT_UNACCEPTABLE_VULNERABILITY_LEVEL=\
${NPM_SECAUDIT_UNACCEPTABLE_VULNERABILITY_LEVEL:="Critical"}

# ##################  END Per-package environmental variables ##################

# ##################  START ebuild and eclass global variables #################

_NPM_SECAUDIT_REG_PATH=${_NPM_SECAUDIT_REG_PATH:=""} # private set only within in the eclass
if [[ -n "${NPM_SECAUDIT_REG_PATH}" ]] ; then
die "NPM_SECAUDIT_REG_PATH has been removed and replaced with\n\
NPM_SECAUDIT_INSTALL_PATH.  Please wait for the next ebuild update."
fi
NPM_PACKAGE_DB="/var/lib/portage/npm-packages"
NPM_PACKAGE_SETS_DB="/etc/portage/sets/npm-security-update"
NPM_SECAUDIT_LOCKS_DIR="/dev/shm"
NODE_VERSION_UNSUPPORTED_WHEN_LESS_THAN="10"

# See https://github.com/microsoft/TypeScript/blob/v2.0.7/package.json
if [[ -n "${NPM_SECAUDIT_TYPESCRIPT_V}" ]] && ( \
	ver_test $(ver_cut 1-2 "${NPM_SECAUDIT_TYPESCRIPT_V}") -ge 2.0 \
	&& ver_test $(ver_cut 1-3 "${NPM_SECAUDIT_TYPESCRIPT_V}") -le 2.1.4 ) ; then
COMMON_DEPEND+="
	>=net-libs/nodejs-0.8.0
"
elif [[ -n "${NPM_SECAUDIT_TYPESCRIPT_V}" ]] && ( \
	ver_test $(ver_cut 1-3 "${NPM_SECAUDIT_TYPESCRIPT_V}") -ge 2.1.5 \
	&& ver_test $(ver_cut 1 "${NPM_SECAUDIT_TYPESCRIPT_V}") -le 9999 ) ; then
COMMON_DEPEND+="
	>=net-libs/nodejs-4.2.0
"
fi

# See https://github.com/DefinitelyTyped/DefinitelyTyped/blob/master/types/node/v8/index.d.ts
# For @types/node
if [[ -n "${NPM_SECAUDIT_AT_TYPES_NODE_V}" ]] \
	&& ver_test $(ver_cut 1 "${NPM_SECAUDIT_AT_TYPES_NODE_V}") -eq 0 ; then
COMMON_DEPEND+=" =net-libs/nodejs-0"
elif [[ -n "${NPM_SECAUDIT_AT_TYPES_NODE_V}" ]] \
	&& ver_test $(ver_cut 1 "${NPM_SECAUDIT_AT_TYPES_NODE_V}") -eq 4 ; then
COMMON_DEPEND+=" =net-libs/nodejs-4"
elif [[ -n "${NPM_SECAUDIT_AT_TYPES_NODE_V}" ]] \
	&& ver_test $(ver_cut 1 "${NPM_SECAUDIT_AT_TYPES_NODE_V}") -eq 6 ; then
COMMON_DEPEND+=" =net-libs/nodejs-6*"
elif [[ -n "${NPM_SECAUDIT_AT_TYPES_NODE_V}" ]] \
	&& ver_test $(ver_cut 1 "${NPM_SECAUDIT_AT_TYPES_NODE_V}") -eq 7 ; then
COMMON_DEPEND+=" =net-libs/nodejs-7*"
elif [[ -n "${NPM_SECAUDIT_AT_TYPES_NODE_V}" ]] \
	&& ver_test $(ver_cut 1 "${NPM_SECAUDIT_AT_TYPES_NODE_V}") -eq 8 ; then
COMMON_DEPEND+=" =net-libs/nodejs-8*"
elif [[ -n "${NPM_SECAUDIT_AT_TYPES_NODE_V}" ]] \
	&& ver_test $(ver_cut 1 "${NPM_SECAUDIT_AT_TYPES_NODE_V}") -eq 9 ; then
COMMON_DEPEND+=" =net-libs/nodejs-9*"
elif [[ -n "${NPM_SECAUDIT_AT_TYPES_NODE_V}" ]] \
	&& ver_test $(ver_cut 1 "${NPM_SECAUDIT_AT_TYPES_NODE_V}") -eq 10 ; then
COMMON_DEPEND+=" =net-libs/nodejs-10*"
elif [[ -n "${NPM_SECAUDIT_AT_TYPES_NODE_V}" ]] \
	&& ver_test $(ver_cut 1 "${NPM_SECAUDIT_AT_TYPES_NODE_V}") -eq 11 ; then
COMMON_DEPEND+=" =net-libs/nodejs-11*"
elif [[ -n "${NPM_SECAUDIT_AT_TYPES_NODE_V}" ]] \
	&& ver_test $(ver_cut 1 "${NPM_SECAUDIT_AT_TYPES_NODE_V}") -eq 12 ; then
COMMON_DEPEND+=" =net-libs/nodejs-12*"
elif [[ -n "${NPM_SECAUDIT_AT_TYPES_NODE_V}" ]] \
	&& ver_test $(ver_cut 1 "${NPM_SECAUDIT_AT_TYPES_NODE_V}") -eq 13 ; then
COMMON_DEPEND+=" =net-libs/nodejs-13*"
fi

DEPEND+=" ${COMMON_DEPEND}"
#DEPEND+="
#app-portage/npm-secaudit"
RDEPEND+=" ${COMMON_DEPEND}"
IUSE+=" debug"

# ##################  END ebuild and eclass global variables #################


# @FUNCTION: npm_pkg_setup
# @DESCRIPTION:
# Initializes globals
npm-secaudit_pkg_setup() {
        debug-print-function ${FUNCNAME} "${@}"

	if has network-sandbox $FEATURES ; then
		die \
"FEATURES=\"-network-sandbox\" must be added per-package env to be able to\n\
download micropackages."
	fi

	export NPM_STORE_DIR="${HOME}/npm"
	export npm_config_cache="${NPM_STORE_DIR}"
	export npm_config_maxsockets=${NPM_MAXSOCKETS}
	mkdir -p "${NPM_STORE_DIR}/offline"
	chown -R portage:portage "${NPM_STORE_DIR}"

	addwrite "${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"

	if [[ ! -d "/dev/shm" ]] ; then
		die "Missing /dev/shm.  Check the kernel config?"
	fi

	if has_version "<net-libs/nodejs-${NODE_VERSION_UNSUPPORTED_WHEN_LESS_THAN}" ; then
		ewarn \
"You have a nodejs less than ${NODE_VERSION_UNSUPPORTED_WHEN_LESS_THAN} which\n\
is End Of Life (EOL) and has vulnerabilities."
	fi
}

# @FUNCTION: npm-secaudit_fetch_deps
# @DESCRIPTION:
# Builds an electron app with security checks
# MUST be called after default unpack AND patching.
npm-secaudit_fetch_deps() {
	pushd "${S}" || die
		local install_args=()
		# Avoid adding fsevent (a MacOS dependency) which may require older node
		if [[ -e "yarn.lock" ]] ; then
			grep -F -e "chokidar" "yarn.lock" \
				&& install_args+=( --no-optional )
		elif [[ -e "package-lock.json" ]] ; then
			grep -F -e "chokidar" "package-lock.json" \
				&& install_args+=( --no-optional )
		else
			grep -F \
				-e "vue-cli-plugin-electron-builder" \
				-e "chokidar" \
				"package.json" \
				&& install_args+=( --no-optional )
		fi
		einfo "Running npm install ${install_args[@]}"
		npm install ${install_args[@]} || die
	popd
}

# @FUNCTION: npm-secaudit_src_unpack
# @DESCRIPTION:
# Runs phases for downloading dependencies, unpacking, building
npm-secaudit_src_unpack() {
        debug-print-function ${FUNCNAME} "${@}"

	cd "${WORKDIR}"

	if [[ ! -d "${S}" ]] ; then
		default_src_unpack
	fi

	# all the phase hooks get run in unpack because of download restrictions

	cd "${S}"
	if declare -f npm-secaudit_src_preprepare > /dev/null ; then
		npm-secaudit_src_preprepare
	fi

	cd "${S}"
	if declare -f npm-secaudit_src_prepare > /dev/null ; then
		npm-secaudit_src_prepare
	else
		npm-secaudit_src_prepare_default
	fi

	cd "${S}"
	npm-secaudit_audit_fix

	cd "${S}"
	if declare -f npm-secaudit_src_postprepare > /dev/null ; then
		npm-secaudit_src_postprepare
	fi

	# audit before possibly bundling a vulnerable package
	npm-secaudit_audit_dev

	cd "${S}"
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


# @FUNCTION: npm_secaudit_store_jsons_for_security_audit
# @DESCRIPTION:
# Standardize the install location for .audit
npm_secaudit_store_jsons_for_security_audit() {
	_npm-secaudit_check_missing_install_path
	npm_secaudit_store_package_jsons "${S}"
	export _NPM_SECAUDIT_REG_PATH="${NPM_SECAUDIT_INSTALL_PATH}/.audit"
	insinto "${_NPM_SECAUDIT_REG_PATH}"

	local old_dotglob=$(shopt dotglob | cut -f 2)
	shopt -s dotglob # copy hidden files

	doins -r "${T}/package_jsons"/*

	if [[ "${old_dotglob}" == "on" ]] ; then
		shopt -s dotglob
	else
		shopt -u dotglob
	fi
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
	echo "${cmd}" >> "${T}/${PN}"
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

# @FUNCTION: npm-secaudit-register
# @DESCRIPTION:
# Adds the package to the electron database
# This function MUST be called in post_inst.
npm-secaudit-register() {
	if [[ -n "${NPM_SECAUDIT_REG_PATH}" ]] ; then
	die "NPM_SECAUDIT_REG_PATH has been removed and replaced with\n\
	NPM_SECAUDIT_INSTALL_PATH.  Please wait for the next ebuild update."
	fi
	while true ; do
		if mkdir "${NPM_SECAUDIT_LOCKS_DIR}/mutex-editing-pkg_db" 2>/dev/null ; then
			trap "rm -rf \"${NPM_SECAUDIT_LOCKS_DIR}/mutex-editing-pkg_db\"" EXIT
			local path=${1:-""}
			local check_path
			if [[ "${path}" =~ ^/ ]] ; then
				# absolute path
				check_path="${path}"
			else
				# relative path
				check_path=$(realpath "/usr/$(get_libdir)/node/${PN}/${SLOT}/${path}")
			fi
			# format:
			# ${CATEGORY}/${P}	path_to_package
			addwrite "${NPM_PACKAGE_DB}"

			# remove existing entry
			touch "${NPM_PACKAGE_DB}"
			sed -i -r -e "s|${CATEGORY}/${PN}:${SLOT}\t.*||g" "${NPM_PACKAGE_DB}"

			echo -e "${CATEGORY}/${PN}:${SLOT}\t${check_path}" >> "${NPM_PACKAGE_DB}"

			# remove blank lines
			sed -i '/^$/d' "${NPM_PACKAGE_DB}"
			rm -rf "${NPM_SECAUDIT_LOCKS_DIR}/mutex-editing-pkg_db"
			break
		else
			einfo \
"Waiting for mutex to be released for npm-secaudit's pkg_db.  If it takes too\n\
long (15 min), cancel all emerges and remove\n\
${NPM_SECAUDIT_LOCKS_DIR}/mutex-editing-pkg_db"
			sleep 15
		fi
	done
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

	einfo "Performing recursive package-lock.json audit fix"
	npm_update_package_locks_recursive ./ # calls npm_pre_audit
	einfo "Audit fix done"
}

# @FUNCTION: npm-secaudit_audit_dev
# @DESCRIPTION:
# This will preform an recursive audit in place without adding packages.
# @CODE
# Parameters:
# $1 - if set to 1 will not die (optional).  It should ONLY be be used for debugging.
# @CODE
npm-secaudit_audit_dev() {
	if [[ -n "${NPM_SECAUDIT_ALLOW_AUDIT}" && "${NPM_SECAUDIT_ALLOW_AUDIT}" == "1" ]] ; then
		:;
	else
		return
	fi

	local nodie="${1}"
	[ ! -e package-lock.json ] && die "Missing package-lock.json in implied root $(pwd)"

	L=$(find . -name "package-lock.json")
	for l in $L; do
		pushd $(dirname $l) || die
			if [[ -n "${nodie}" && "${NPM_SECAUDIT_NO_DIE_ON_AUDIT}" == "1" ]] ; then
				npm audit
			else
				local audit_file="${T}/npm-audit-result"
				npm audit &> "${audit_file}"
				local is_critical=0
				local is_high=0
				local is_moderate=0
				local is_low=0
				grep -q -F -e " Critical " "${audit_file}" && is_critical=1
				grep -q -F -e " High " "${audit_file}" && is_high=1
				grep -q -F -e " Moderate " "${audit_file}" && is_moderate=1
				grep -q -F -e " Low " "${audit_file}" && is_low=1
	if [[ "${NPM_SECAUDIT_UNACCEPTABLE_VULNERABILITY_LEVEL}" == "Critical" \
					&& "${is_critical}" == "1" ]] ; then
					cat "${audit_file}"
					die "Detected critical vulnerability in a package."
	elif [[ "${NPM_SECAUDIT_UNACCEPTABLE_VULNERABILITY_LEVEL}" == "High" \
					&& ( "${is_high}" == "1" \
					|| "${is_critical}" == "1" ) ]] ; then
					cat "${audit_file}"
					die "Detected high vulnerability in a package."
	elif [[ "${NPM_SECAUDIT_UNACCEPTABLE_VULNERABILITY_LEVEL}" == "Moderate" \
					&& ( "${is_moderate}" == "1" \
					|| "${is_critical}" == "1" \
					|| "${is_high}" == "1" ) ]] ; then
					cat "${audit_file}"
					die "Detected moderate vulnerability in a package."
	elif [[ "${NPM_SECAUDIT_UNACCEPTABLE_VULNERABILITY_LEVEL}" == "Low" \
					&& ( "${is_low}" == "1" \
					|| "${is_critical}" == "1" \
					|| "${is_high}" == "1" \
					|| "${is_moderate}" == "1" ) ]] ; then
					cat "${audit_file}"
					die "Detected low vulnerability in a package."
				fi
			fi
		popd
	done
}

# @FUNCTION: npm-secaudit_audit_prod
# @DESCRIPTION:
# This will preform an recursive audit for production in place without adding packages.
npm-secaudit_audit_prod() {
	if [[ -n "${NPM_SECAUDIT_ALLOW_AUDIT}" && "${NPM_SECAUDIT_ALLOW_AUDIT}" == "1" ]] ; then
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
			cat "${audit_file}" | grep -q -F -e "ELOCKVERIFY"
			if [[ "$?" != "0" ]] ; then
				cat "${audit_file}" | grep -q -F -e "require manual review"
				local result_found1="$?"
				cat "${audit_file}" | grep -q -F -e "npm audit fix"
				local result_found2="$?"
				if [[ "${result_found1}" == "0" || "${result_found2}" == "0" ]] ; then
					die "package is still vulnerable at $(pwd)$l"
				fi
			fi
		popd
	done
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
		die \
"You must specify NPM_SECAUDIT_INSTALL_PATH.  Usually same location as\n\
/usr/\$(get_libdir)/node/\${PN}/\${SLOT} without \$ED."
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

	# Mark .bin scripts executable
	for dir_path in $(find "${ed}" -name ".bin" -type d) ; do
		for f in $(find "${dir_path}" ) ; do
			chmod 0755 $(realpath "${f}") || die
		done
	done

	# Mark libraries executable
	for f in $(find "${ed}" -name "*.so" -type f -o -name "*.so.*" -type f) ; do
		chmod 0755 $(realpath "${f}") || die
	done

	if [[ "${old_dotglob}" == "on" ]] ; then
		shopt -s dotglob
	else
		shopt -u dotglob
	fi
}

# @FUNCTION: npm-secaudit_pkg_postinst
# @DESCRIPTION:
# Automatically registers an npm package.
# Set NPM_SECAUDIT_REG_PATH global to relative path (NOT starting with /) or
# absolute path (starting with /) to scan for vulnerabilities containing
# node_modules.
npm-secaudit_pkg_postinst() {
        debug-print-function ${FUNCNAME} "${@}"

	npm-secaudit-register "${NPM_SECAUDIT_REG_PATH}"
}

# @FUNCTION: npm-secaudit_pkg_postrm
# @DESCRIPTION:
# Post-removal hook for Electron apps. Removes information required for security checks.
npm-secaudit_pkg_postrm() {
        debug-print-function ${FUNCNAME} "${@}"

	while true ; do
		if mkdir "${NPM_SECAUDIT_LOCKS_DIR}/mutex-editing-pkg_db" 2>/dev/null ; then
			trap "rm -rf \"${NPM_SECAUDIT_LOCKS_DIR}/mutex-editing-pkg_db\"" EXIT
			sed -i -r -e "s|${CATEGORY}/${PN}:${SLOT}\t.*||g" "${NPM_PACKAGE_DB}"
			sed -i '/^$/d' "${NPM_PACKAGE_DB}"
			rm -rf "${NPM_SECAUDIT_LOCKS_DIR}/mutex-editing-pkg_db"
			break
		else
			einfo \
"Waiting for mutex to be released for npm-secaudit's pkg_db.  If it takes too\n\
long (15 min), cancel all emerges and remove\n\
${NPM_SECAUDIT_LOCKS_DIR}/mutex-editing-pkg_db"
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
}

# @FUNCTION: npm-secaudit_store_package_jsons
# @DESCRIPTION: Saves the package-lock.json to T for auditing
npm-secaudit_store_package_jsons() {
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

# @FUNCTION: npm-secaudit_restore_package_jsons
# @DESCRIPTION: Restores the package-lock.json to T for auditing
npm-secaudit_restore_package_jsons() {
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
