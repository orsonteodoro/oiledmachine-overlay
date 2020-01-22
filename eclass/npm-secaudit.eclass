# Copyright 2019-2020 Orson Teodoro
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: npm-secaudit.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 4 5
# @BLURB: Eclass for Electron packages
# @DESCRIPTION:
# The npm-secaudit eclass defines phase functions and utility for npm packages.
# It depends on the app-portage/npm-secaudit package to maintain a
# secure environment.
#
# It was intended to replace the insecure npm.eclass implementations and
# reduce packaging time.

case "${EAPI:-0}" in
        0|1|2|3)
                die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
                ;;
        4|5|6|7)
                ;;
        *)
                die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
                ;;
esac

inherit eutils npm-utils

EXPORT_FUNCTIONS pkg_setup src_unpack pkg_postrm pkg_postinst

DEPEND+=" app-portage/npm-secaudit"
IUSE+=" debug"

NPM_PACKAGE_DB="/var/lib/portage/npm-packages"
NPM_SECAUDIT_REG_PATH=${NPM_SECAUDIT_REG_PATH:=""}
NPM_MAXSOCKETS=${NPM_MAXSOCKETS:="1"} # Set this in your make.conf to control number of HTTP requests.  50 is npm default but it is too high.
NPM_SECAUDIT_ALLOW_AUDIT=${NPM_SECAUDIT_ALLOW_AUDIT:="1"}
NPM_SECAUDIT_ALLOW_AUDIT_FIX=${NPM_SECAUDIT_ALLOW_AUDIT_FIX:="1"}
NPM_SECAUDIT_NO_DIE_ON_AUDIT=${NPM_SECAUDIT_NO_DIE_ON_AUDIT:="0"}

# @FUNCTION: _npm-secaudit_fix_locks
# @DESCRIPTION:
# Restores ownership change caused by yarn
_npm-secaudit_fix_locks() {
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

# @FUNCTION: _npm-secaudit_fix_logs
# @DESCRIPTION:
# Restores ownership change to logs
_npm-secaudit_fix_logs() {
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

# @FUNCTION: _npm-secaudit_yarn_access
# @DESCRIPTION:
# Restores ownership change caused by yarn
_npm-secaudit_yarn_access() {
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

# @FUNCTION: _npm-secaudit_fix_cacache_access
# @DESCRIPTION:
# Restores ownership change on cacache
_npm-secaudit_fix_cacache_access() {
	local d="${NPM_STORE_DIR}"
	local f="_cacache"
	local dt="${d}/${f}"
	if [ -d "${dt}" ] ; then
		local u=$(ls -l "${d}" | grep "${f}" | column -t | cut -f 5 -d ' ')
		local g=$(ls -l "${d}" | grep "${f}" | column -t | cut -f 7 -d ' ')
		while true ; do
			if mkdir -p "${d}/mutex-removing-cacache" ; then
				# time to fix cache permissions is more expensive than just removing it all
				einfo "Removing ${dt}"
				rm -rf "${dt}"
				rm -rf "${d}/mutex-removing-cacache"
				break
			else
				einfo "Waiting to free mutex lock.  If it takes too long (15 min) close all emerge instances and remove ${d}/mutex-removing-cache."
			fi
			sleep 30
		done
	fi
	einfo "Restoring portage ownership on ${dt}"
	addwrite "${d}"
	mkdir -p "${dt}"
	chown portage:portage -R "${dt}"
}

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

	export NPM_STORE_DIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}/npm"
	export npm_config_cache="${NPM_STORE_DIR}"
	mkdir -p "${NPM_STORE_DIR}/offline"

	addwrite "${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"

	_npm-secaudit_fix_locks
	_npm-secaudit_fix_logs
	_npm-secaudit_fix_cacache_access
}

# @FUNCTION: npm-secaudit_fetch_deps
# @DESCRIPTION:
# Builds an electron app with security checks
# MUST be called after default unpack AND patching.
npm-secaudit_fetch_deps() {
	pushd "${S}" || die
		_npm-secaudit_fix_locks
		_npm-secaudit_yarn_access

		npm install --maxsockets=${NPM_MAXSOCKETS} || die
	popd
}

# @FUNCTION: npm_unpack
# @DESCRIPTION:
# Unpack sources
npm-secaudit_src_unpack() {
        debug-print-function ${FUNCNAME} "${@}"

	cd "${WORKDIR}"

	default_src_unpack

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

# @FUNCTION: npm-secaudit_src_install_default
# @DESCRIPTION:
# Installs the program.  Currently a stub.
npm-secaudit_src_install_default() {
        debug-print-function ${FUNCNAME} "${@}"

	cd "${S}"

	die "currently uninplemented.  must override"
# todo npm-secaudit_src_install_default
}

# @FUNCTION: npm-secaudit-build
# @DESCRIPTION:
# Builds an electron app
npm-secaudit-build() {
	# electron-builder can still pull packages at the build step.
	npm run build --maxsockets=${NPM_MAXSOCKETS} || die
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
	local d="${NPM_STORE_DIR}"
	while true ; do
		if mkdir "${d}/mutex-editing-pkg_db" ; then
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
			rm -rf "${d}/mutex-editing-pkg_db"
			break
		else
			einfo "Waiting for mutex to be released for npm-secaudit's pkg_db.  If it takes too long (15 min), cancel all emerges and remove ${d}/mutex-editing-pkg_db"
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
				npm audit || die
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

# @FUNCTION: npm-secaudit_src_preinst_default
# @DESCRIPTION:
# Dummy function
npm-secaudit_src_preinst_default() {
	true
}

# @FUNCTION: npm-secaudit_install
# @DESCRIPTION:
# Installs an app to image area before going live.
npm-secaudit_install() {
	local rel_src_path="$1"

	local old_dotglob=$(shopt dotglob | cut -f 2)
	shopt -s dotglob # copy hidden files

	mkdir -p "${D}/usr/$(get_libdir)/node/${PN}/${SLOT}"
	cp -a ${rel_src_path} "${D}/usr/$(get_libdir)/node/${PN}/${SLOT}"

	if [[ "${old_dotglob}" == "on" ]] ; then
		shopt -s dotglob
	else
		shopt -u dotglob
	fi
}

# @FUNCTION: npm-secaudit_pkg_postinst
# @DESCRIPTION:
# Automatically registers an npm package.
# Set NPM_SECAUDIT_REG_PATH global to relative path to
# scan for vulnerabilities containing node_modules.
# scan for vulnerabilities.
npm-secaudit_pkg_postinst() {
        debug-print-function ${FUNCNAME} "${@}"

	npm-secaudit-register "${NPM_SECAUDIT_REG_PATH}"
}

# @FUNCTION: npm-secaudit_pkg_postrm
# @DESCRIPTION:
# Post-removal hook for Electron apps. Removes information required for security checks.
npm-secaudit_pkg_postrm() {
        debug-print-function ${FUNCNAME} "${@}"

	sed -i -e "s|${CATEGORY}/${PN}:${SLOT}\t.*||g" "${NPM_PACKAGE_DB}"
	sed -i '/^$/d' "${NPM_PACKAGE_DB}"
}

# @FUNCTION: npm-secaudit_store_package_jsons
# @DESCRIPTION: Saves the package{,-lock}.json to T for auditing
npm-secaudit_store_package_jsons() {
	einfo "Saving package.json and package-lock.json for future audits ..."

	local old_dotglob=$(shopt dotglob | cut -f 2)
	shopt -s dotglob # copy hidden files

	local ROOTDIR="${1}"
	local d
	local rd
	local F=$(find ${ROOTDIR} -name "package*.json*" -o "yarn.lock")
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

# @FUNCTION: npm-secaudit_restore_package_jsons
# @DESCRIPTION: Restores the package{,-lock}.json to T for auditing
npm-secaudit_restore_package_jsons() {
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
