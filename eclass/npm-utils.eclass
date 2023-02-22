# Copyright 2019-2022 Orson Teodoro
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: npm-utils.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for wrapper npm commands
# @DESCRIPTION:
# The npm-utils eclass defines convenience functions for working with npm with
# subdirectories.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

inherit lcnr

# ############## START Per-package environmental variables #####################

# Anything with :- is likely a environmental variable setting
# These manage the degree of consent.  Some users want a highly secure system.
# Other users just want the product to install.  By default, the eclasses use
# the policy to block criticals from being merged into the system.

# For those that just want it to install (no security) you can add
# /etc/portage/env/npm-no-audit-fix.conf with the following without # character:
# NPM_SECAUDIT_ALLOW_AUDIT_FIX=0
# NPM_SECAUDIT_NO_DIE_ON_AUDIT=1
# ELECTRON_APP_ALLOW_AUDIT=0
# ELECTRON_APP_ALLOW_AUDIT_FIX=0
# ELECTRON_APP_NO_DIE_ON_AUDIT=1

# Then, add to /etc/portage/package.env
# ${CATEGORY}/${PN} npm-no-audit-fix.conf

# See npm-utils_pkg_setup for details.

# ############## END Per-package environmental variables #######################
# ##################  START ECLASS environmental variables #####################

# Keep up to date from
# https://omahaproxy.appspot.com/
CHROMIUM_STABLE_PV="110"

# See https://nodejs.dev/en/about/releases/
NODE_VERSIONS_SUPPORTED=(14 16 18 19 20)

# See https://nodejs.dev/en/about/releases/
NODE_VERSION_UNSUPPORTED_WHEN_LESS_THAN="14"

# ##################  END ECLASS environmental variables #######################

npm-utils_pkg_setup() {
	# The following could be define as a per-package envar, but should not
	# be done in the ebuild itself.

	# Allows fixing during auditing.
	NPM_UTILS_ALLOW_AUDIT_FIX=${NPM_UTILS_ALLOW_AUDIT_FIX:-"1"}

	# You could define it as a per-package envar, but should not be done in
	# the ebuild itself.
	NPM_UTILS_ALLOW_AUDIT=${NPM_UTILS_ALLOW_AUDIT:-"1"}

	# Allows to force a package-lock which could add more vulnerabilities
	# as a consequence.
	NPM_UTILS_ALLOW_I_PACKAGE_LOCK=${NPM_UTILS_ALLOW_I_PACKAGE_LOCK:-"0"}
}

# @FUNCTION: npm_check_npm_error
# @DESCRIPTION:
# The `npm install <pkg>` command should return a non-zero value on cb() error
# but does not.  Check and die if error log is found.
npm_check_npm_error()
{
	local count
	count=$(find "${HOME}/npm/_logs/"* 2>/dev/null | wc -l)
	if (( ${count} > 0 )) ; then
ewarn
ewarn "Detected some potential download failure(s).  Logs can be found in"
ewarn "${HOME}/npm/_logs .  Retry if the build fails."
ewarn
	fi
	if grep -q -E -r -e "(ERR_SOCKET_TIMEOUT|FETCH_ERROR)" \
		"${HOME}/npm/_logs" ; then
eerror
eerror "Detected some download failure(s).  Logs can be found in"
eerror "${HOME}/npm/_logs .  Re-emerge the package."
eerror
		die
	fi
}

# @FUNCTION: npm_install_sub
# @DESCRIPTION:
# Installs a npm package in a subdirectory.
# You should specify either --save-prod, --save-dev, or --no-save.
# @CODE
# Parameters:
# $1 - directory location to install a package
# $2 ... $n - additional args to npm install (optional)
# @CODE
npm_install_sub() {
	local dir="${1}"
	shift
einfo
einfo "npm_install_sub: dir=$(pwd)/${dir}"
einfo
	pushd "${dir}" || die
		npm install ${@} || die
		npm_check_npm_error
		if [ -e package-lock.json ] ; then
			npm_pre_audit
		fi
	popd
}

# @FUNCTION: npm_install_prod
# @DESCRIPTION:
# Installs a npm package as a production dependency
# @CODE
# Parameters:
# $1 - a package to install (required)
# $2 ... $n - additional args to pass to npm install (optional)
# @CODE
npm_install_prod() {
einfo
einfo "npm_install_prod:  npm install ${@} --save-prod"
einfo
	npm install ${@} --save-prod || die
	npm_check_npm_error
	if [ -e package-lock.json ] ; then
		npm_pre_audit
	fi
}

# @FUNCTION: npm_install_dev
# @DESCRIPTION:
# Installs a npm package as a development dependency
# @CODE
# Parameters:
# $1 - a package to install (required)
# $2 ... $n - additional args to pass to npm install (optional)
# @CODE
npm_install_dev() {
einfo
einfo "npm_install_dev:  npm install ${@} --save-dev"
einfo
	npm install ${@} --save-dev || die
	npm_check_npm_error
	if [ -e package-lock.json ] ; then
		npm_pre_audit
	fi
}

# @FUNCTION: npm_uninstall
# @DESCRIPTION:
# Uninstalls a npm package
# @CODE
# Parameters:
# $1 - a package to uninstall (required)
# $2 ... $n - additional args to pass to npm uninstall (optional)
# @CODE
npm_uninstall() {
einfo
einfo "npm_uninstall:  npm uninstall ${@}"
einfo
	npm uninstall ${@} || die
}

# @FUNCTION: npm_install_no_save
# @DESCRIPTION:
# Installs a npm package without altering the package.json
# @CODE
# Parameters:
# $1 - a package to uninstall (required)
# $2 ... $n - additional args to pass to npm install (optional)
# @CODE
npm_install_no_save() {
einfo
einfo "npm_install_no_save:  npm install ${@} --no-save"
einfo
	npm install ${@} --no-save || die
	npm_check_npm_error
	if [ -e package-lock.json ] ; then
		npm_pre_audit
	fi
}

# @FUNCTION: npm_package_lock_update
# @DESCRIPTION:
# Creates a package lock in a subdirectory.
# @CODE
# Parameters:
# $1 - directory location containing the package lock to update
# @CODE
npm_package_lock_update() {
	local dir="${1}"
einfo
einfo "npm_package_lock_update: dir=$(pwd)/${dir}"
einfo
	pushd "${dir}" || die
		if [ -e package-lock.json ] ; then
			rm package-lock.json
		else
ewarn
ewarn "package-lock.json was not found as expected"
ewarn
		fi
		npm i --package-lock-only || die
		if [ ! -e package-lock.json ] ; then
ewarn
ewarn "package-lock.json was not created in ${dir}"
ewarn
		fi
	popd
}

# @FUNCTION: npm_auto_fix
# @DESCRIPTION:
# Inspects if vulnerable.  It will fix trivial vulnerabilities.
# @RETURNS: 0 no audit fix, 1 for audit fix, 2 on error
npm_auto_fix() {
	if [[ -n "${NPM_UTILS_ALLOW_AUDIT_FIX}" \
		&& "${NPM_UTILS_ALLOW_AUDIT_FIX}" == "1" ]] ; then
		:;
	else
		return
	fi

	local is_trivial=0
	local is_auto_fix=0
	local is_manual_review=0
	local is_clean=0
	local is_missing=0
	local is_invalid_version=0
	local audit_file="${T}/npm-audit-result"
	npm audit &> "${audit_file}" || true
	cat "${audit_file}" || die
	local needed_fix="$?"
	cat "${audit_file}" | grep -q -F -e "npm audit fix" \
		&& is_trivial=1
	cat "${audit_file}" | grep -q -F -e "# Run" \
		&& is_auto_fix=1
	cat "${audit_file}" | grep -q -F -e "require manual review" \
		&& is_manual_review=1
	cat "${audit_file}" | grep -q -F -e "found 0 vulnerabilit" \
		&& is_clean=1
	cat "${audit_file}" | grep -q -F -e "Missing:" \
		&& is_missing=1
	cat "${audit_file}" | grep -q -F -e "Invalid Version:" \
		&& is_invalid_version=1
	if [[ "${is_auto_fix}" == "1" ]] ; then
einfo
einfo "Found auto fixes.  Running \`npm audit fix\`.  is_auto_fix=1"
einfo
		npm audit fix || die
		#L=$(cat "${audit_file}" \
#| grep -E -e "to resolve [0-9]+ vulnerabilit(y|ies)" \
#| sed -e "s|# Run  ||" -e "s#  to resolve [0-9]+ vulnerabilit(y|ies)##g")
		#while read -r line ; do
#einfo
#einfo "Auto running fix: ${line}"
#einfo
		#	eval "${line}"
		#done <<< ${L}
		return 1
	elif [[ "${is_trivial}" == "1" ]] ; then
einfo
einfo "Found trivial fixes.  Running \`npm audit fix\`. is_trivial=1"
einfo
		npm audit fix || die
		return 1
		# npm audit 2>&1 > "${audit_file}" || die
		# cat "${audit_file}" | grep -q -F -e "found 0 vulnerabilities" \
		#	|| die "not fixed"
	elif [[ "${is_manual_review}" == "1" ]] ; then
		cat "${audit_file}" || die
ewarn
ewarn "You still have a vulnerable package.  It requires hand editing.  Fix"
ewarn "immediately.  is_manual_review=1.  Reported from: $(pwd)"
ewarn
		# assumes that fixing operations occur immediately
		return 2
	elif [[ "${is_missing}" == "1" ]] ; then
einfo
einfo "Lockfile is bad.  is_missing=1"
einfo
		cat "${audit_file}" || die
	elif [[ "${is_invalid_version}" == "1" ]] ; then
einfo
einfo "Invalid file case.  Fix lock?  is_invalid_version=1"
einfo
		rm package-lock.json
		npm i --package-lock-only 2>&1 > "${audit_file}"
		if cat "${audit_file}" | grep -q -F -e "Invalid Version:" ; then
			cat "${audit_file}" || die
einfo
einfo "Still broken.  Requires manual editing."
einfo
		fi
		is_clean=0
		cat "${audit_file}" | grep -q -F -e "found 0 vulnerabilities" \
			&& is_clean=1
		if [[ "${is_clean}" == 0 ]] ; then
einfo
einfo "Running \`npm audit fix\` anyway."
einfo
			npm audit fix || die
		fi
		npm audit 2>&1 > "${audit_file}" || die
		cat "${audit_file}" | grep -q -F -e "found 0 vulnerabilities" \
			|| return 2
		return 1
	elif [[ "${is_clean}" == "1" ]] ; then
einfo
einfo "Audit was clean.  is_clean=1"
einfo
	elif [[ "${is_clean}" == "0" ]] ; then
einfo
einfo "Audit is not clean.  Going to fix.  is_clean=0"
einfo
		cat "${audit_file}" || die
einfo
einfo "Running \`npm audit fix\`."
einfo
		npm audit fix || die
		return 1
	else
		cat "${audit_file}" || die
eerror
eerror "Uncaught error"
eerror
		die
	fi
	return 0
}

# @FUNCTION: __missing_requires_manual_intervention_message
# @DESCRIPTION:
# Handles the Missing: package dependency in audit's report.
__missing_requires_manual_intervention_message() {
	if grep -q -F -e "Missing:" "${audit_file}" ; then
		cat "${audit_file}" || die
ewarn
ewarn "Install missing packages.  Do a \`npm ls <package_name>\` of each of the"
ewarn "above packages.  Add them if they are missing"
ewarn
ewarn "The package lock dir: ${dir}"
ewarn "The package.json: ${dir}/package.json"
ewarn "The package-lock.json: ${dir}/package-lock.json"
ewarn
# It assumes that fixing operations occur immediately.
	fi
}

__replace_package_lock() {
	rm package-lock.json || die
	npm i --package-lock-only 2>&1 > "${audit_file}"
	__missing_requires_manual_intervention_message
	if [ ! -e package-lock.json ] ; then
		if [[ "${NPM_UTILS_ALLOW_I_PACKAGE_LOCK}" == "1" ]] ; then
ewarn
ewarn "Could not safely restore package-lock.json with --package-lock-only."
ewarn "Forcing 'npm i --package-lock' which may pull vulnerabilities."
ewarn "dir=$(pwd)"
ewarn

			# Warning:  It can pull vulnerability
			npm i --package-lock 2>&1 > "${audit_file}"

			__missing_requires_manual_intervention_message
		fi
	fi
}

# @FUNCTION: npm_pre_audit
# @DESCRIPTION:
# Regenerates the package-lock.json if necessary.  Fixes trivial vulnerabilites.
# If --package-lock-only fails, it will try --package-lock instead.
# warning:  this may pull vulnerable packages if --package-lock is called
npm_pre_audit() {
	if [[ -n "${NPM_UTILS_ALLOW_AUDIT}" && "${NPM_UTILS_ALLOW_AUDIT}" == "1" ]] ; then
		:;
	else
		break
	fi

	if [ -e package-lock.json ] ; then
		# upstream wanted package lock case
		local audit_file="${T}/npm-audit-result"
		npm audit &> "${audit_file}" || true

		if grep -q -F -e "Manual Review" "${audit_file}" \
		|| grep -q -F -e "npm audit security report" "${audit_file}" ; then
			# false positive cases when project-lock.json is old
			# caused by deduping
			__replace_package_lock
		elif grep -q -F -e "Missing:" "${audit_file}" ; then
			# package-lock.json may be broken.  try to fix before
			# doing audit
			__replace_package_lock
		elif grep -q -F -e "does not satisfy" "${audit_file}" ; then
			__replace_package_lock
		elif [ ! -e package-lock.json ] ; then
eerror
eerror "Missing package-lock.json required for audit.  Fixme:  unknown case."
eerror
			die
		else
			if cat "${audit_file}" | grep -q -F -e "npm ERR!" ; then
				cat "${audit_file}"
eerror
eerror "Uncaught error"
eerror
				die
			fi
		fi
	else
eerror
eerror "Using npm_pre_audit requires a package-lock.json"
eerror
		die
	fi

	if [ -e package-lock.json ] ; then
		# fix trivial vulnerabilities
		npm_auto_fix
	else
eerror
eerror "npm_pre_audit didn't create a package-lock.json"
eerror
		die
	fi
}

# @FUNCTION: npm_audit_fix
# @DESCRIPTION:
# Performs an audit fix in a sub directory.
#
# It will halt if it is not able to create a package-json.json.
#
# It will continue if it detects a vulnerability.  It is assumed that commands
# following call fix it.
#
# @CODE
# Parameters:
# $1 - directory location to perform audit
# @CODE
npm_audit_fix() {
	if [[ -n "${NPM_UTILS_ALLOW_AUDIT_FIX}" \
	&& "${NPM_UTILS_ALLOW_AUDIT_FIX}" == "1" ]] ; then
		:;
	else
		return
	fi

	local dir="${1}"
einfo
einfo "npm_audit_fix: dir=$(pwd)/${dir}"
einfo
	pushd "${dir}" || die
		npm_pre_audit
	popd
}


# @FUNCTION: npm_audit_fix
# @DESCRIPTION:
# Performs an audit fix in a directory.  It repeats the repair process
# until it converges to a minimum and recurses the package-lock tree.
#
# @CODE
# Parameters:
# $1 - directory location to start traversing which should be the project root
# @CODE
npm_audit_fix_recursive_and_converging() {
	local dir="${1}" # must be relative to $base omitting $base
	local previous_n_repairs=-1
	local n_repairs=0
	local tries=0
	local i=0

	while true ; do
		n_repairs=0
		L=$(find "${dir}" -type f -name "package-lock.json")
		for l in ${L} ; do
einfo
einfo "npm_audit_fix_recursive_and_converging: dir=${l} (pass #${i})"
einfo
			pushd $(dirname "${l}") || die
				npm_auto_fix
				if (( $? == 1 )) ; then
					n_repairs=$((${n_repairs}+1))
				fi
			popd
		done

		if [[ "${n_repairs}" == "0" ]] ; then
einfo
einfo "n_repairs is 0"
einfo
			break
		fi

		if (( ${previous_n_repairs} != -1 )) ; then
			if (( ${n_repairs} > ${previous_n_repairs} )) ; then
eerror
eerror "Repair rate explosion.  Unfixable."
eerror
				die
			elif (( ${n_repairs} < ${previous_n_repairs} )) ; then
einfo
einfo "Repair rate is converging toward zero"
einfo
			elif (( ${n_repairs} == ${previous_n_repairs} )) ; then
				tries=$((${tries}+1))
				if (( ${tries} >= 3 )) ; then
einfo
einfo "Repair rate tries is used up."
einfo
					break
				else
einfo
einfo "Repair rate is a coincidental constant?  tries=${tries}"
einfo
				fi
			fi
		fi
einfo
einfo "Convergence rate: n_repairs=${n_repairs}"
einfo
		previous_n_repairs=${n_repairs}
		i=$((${i}+1))
	done
}

# @FUNCTION: npm_update_package_locks_recursive
# @DESCRIPTION:
# Performs an recursive update of locked packages that need package-locks
# updated in order for audits to work properly.  It should be called after
# deduping is performed.
# It is assumed that the entire project at this point has already had all its
# in-the-wild vulnerable packages removed before calling it.
#
# It will halt if it is not able to create a package-json.json.
#
# It will continue if it detects a vulnerability.  It is assumed that commands
# following call fix it.
#
# @CODE
# Parameters:
# $1 - directory location to start traversing which should be the project root
# @CODE
npm_update_package_locks_recursive() {
	if [[ -n "${NPM_UTILS_ALLOW_AUDIT}" \
		&& "${NPM_UTILS_ALLOW_AUDIT}" == "1" ]] ; then
		:;
	else
		return
	fi

	local dir="${1}" # must be relative to $base omitting $base
	local base="$(pwd)"

	local i=1
	local previous_broken_lock_count=-1
	local current_broken_lock_count=0
	local n_constant=0
	local audit_file="${T}/npm-audit-result"
	while true ; do
einfo
einfo "npm_update_package_locks_recursive (pre audit): preforming pass"
einfo "dir=$(realpath ${base}/${dir})"
einfo
		L=$(find "${dir}" -type f -name "package-lock.json")
		for l in ${L} ; do
			if [ -e "${l}" ] ; then
				pushd "$(dirname ${l})" || die
einfo
einfo "Processing: $(realpath ${base}/${l})"
einfo
					npm_pre_audit
				popd
			fi
		done

		current_broken_lock_count=0
einfo
einfo "npm_update_package_locks_recursive (locks update): preforming pass #${i}"
einfo
		L=$(find "${dir}" -type f -name "package-lock.json")
		for l in ${L} ; do
			if [ -e "${l}" ] ; then
				pushd "$(dirname ${l})" || die
					npm audit &> "${audit_file}" || true
					if grep -q -F -e "Missing:" "${audit_file}" ; then
						npm_pre_audit
						current_broken_lock_count=$((${current_broken_lock_count}+1))
					else
						if cat "${audit_file}" | grep -q -F -e "npm ERR!" ; then
							cat "${audit_file}"
eerror
eerror "Uncaught error"
eerror
							die
						fi
					fi
				popd
			fi
		done
		if (( ${current_broken_lock_count} == 0 )) ; then
einfo
einfo "No broken locks encountered"
einfo
			break
		fi
		if (( ${previous_broken_lock_count} != -1 )) ; then
			# the broken locks should converge towards zero
			if (( ${current_broken_lock_count} > ${previous_broken_lock_count} )) ; then
				# if the rate of broken locks should never increase over time
eerror
eerror "Intractable lock fix algorithm.  Fix the algorithm."
eerror
				die
			fi

			if (( ${current_broken_lock_count} == ${previous_broken_lock_count} )) ; then
				# ideal termination condition
				# 0 == 0 is the perfect scenario
				n_constant=$((${n_constant}+1))
				if (( ${n_constant} >= 3 )) ; then
einfo
einfo "Constant rate encountered.  n_constant=${n_constant}"
einfo
					# this case means 3 samples, coincindental constant rate
					break
				fi
			else
einfo
einfo "Rates are converging toward 0."
einfo
				n_constant=0
			fi
		fi
einfo
einfo "Convergence rates:"
einfo
einfo "current_broken_lock_count=${current_broken_lock_count}"
einfo "previous_broken_lock_count=${previous_broken_lock_count}"
einfo
		previous_broken_lock_count=${current_broken_lock_count}
		i=$((${i}+1))
	done

einfo
einfo "npm_update_package_locks_recursive: done"
einfo
}

# @FUNCTION: npm-utils_install_header_license
# @DESCRIPTION:
# Installs a license header
npm-utils_install_header_license() {
	local dir_path=$(dirname "${1}")
	local file_name=$(basename "${1}")
	local license_name="${2}"
	local length="${3}"
	lcn_install_header \
		"${dir_path}" \
		"${file_name}" \
		"${license_name}" \
		"${length}"
}

# @FUNCTION: npm-utils_install_license_mid
# @DESCRIPTION:
# Installs a license from the middle of a file
npm-utils_install_license_mid() {
	local dir_path=$(dirname "${1}")
	local file_name=$(basename "${1}")
	local license_name="${2}"
	local start="${3}"
	local length="${4}"
	lcnr_install_mid \
		"${dir_path}" \
		"${file_name}" \
		"${license_name}" \
		"${start}" \
		"${length}"
}

# @FUNCTION: npm-utils_install_licenses
# @DESCRIPTION:
# Installs all licenses from main package and micropackages
# Standardizes the process.
npm-utils_install_licenses() {
	lcnr_install_files
}

# @FUNCTION: npm-utils_install_readmes
# @DESCRIPTION:
# Installs all readmes including those from micropackages.  Standardizes the
# process.
npm-utils_install_readmes() {
	lcnr_install_readmes
}

# @FUNCTION: npm-utils_is_nodejs_header_exe_same
# @DESCRIPTION:
# Ensures header and node exe are the same version.  Check is
# required for multislot nodejs.
npm-utils_is_nodejs_header_exe_same() {
	local node_pv=$(node --version | sed -e "s|v||")
	local node_pv_major=$(grep -r -e "NODE_MAJOR_VERSION" \
		/usr/include/node/node_version.h | head -n 1 | cut -f 3 -d " ")
	local node_pv_minor=$(grep -r -e "NODE_MINOR_VERSION" \
		/usr/include/node/node_version.h | head -n 1 | cut -f 3 -d " ")
	local node_pv_patch=$(grep -r -e "NODE_PATCH_VERSION" \
		/usr/include/node/node_version.h | head -n 1 | cut -f 3 -d " ")
	if ver_test ${node_pv_major}.${node_pv_minor} -ne $(ver_cut 1-2 ${node_pv}) ; then
eerror
eerror "Inconsistency between node header and active executable version."
eerror "Switch your headers via \`eselect nodejs\`"
eerror
		die
	else
einfo
einfo "Node.js header version:\t${node_pv_major}.${node_pv_minor}.${node_pv_patch}"
einfo "Node.js exe version:\t\t${node_pv}"
einfo
	fi
}

# @FUNCTION: npm-utils_check_nodejs
# @DESCRIPTION:
# Ensures header and exe meet requirements.
# @CODE
# Parameters:
# $1 - A string recognized by {B,R,}DEPENDS
# @CODE
npm-utils_check_nodejs() {
	local node_exe_ver=$(node --version | sed -e "s|v||")
	local node_header_ver=$(grep -r -e "NODE_MAJOR_VERSION" \
		/usr/include/node/node_version.h | head -n 1 \
		| cut -f 3 -d " ")
	node_exe_ver=$(echo "${node_exe_ver}" | cut -f 1 -d ".")

	local s="${1}"
	local has_min_ge=$(echo "${s}" | grep -q -E -o ">=net-libs/nodejs" ; echo $?)
	local has_min_gt=$(echo "${s}" | grep -q -E -o ">net-libs/nodejs" ; echo $?)
	local has_max_le=$(echo "${s}" | grep -q -E -o "<=net-libs/nodejs" ; echo $?)
	local has_max_lt=$(echo "${s}" | grep -q -E -o "<net-libs/nodejs" ; echo $?)
	local min_ver
	local max_ver
	local min_slot
	local max_slot
	if [[ "${has_min_ge}" == "0" ]] ; then
		min_slot=$(echo "${s}" \
			| grep -E -o ">=net-libs/nodejs-[0-9]+:[0-9]+" \
			| head -n 1 | sed -r -e "s|>=net-libs/nodejs-[0-9]+:||")
		min_ver=$(echo "${s}" \
			| grep -E -o ">=net-libs/nodejs-[0-9]+" \
			| head -n 1 | sed -e "s|>=net-libs/nodejs-||")
		if [[ -n "${min_slot}" ]] ; then
			min_ver="${min_ver}"
		fi
	fi
	if [[ "${has_min_gt}" == "0" ]] ; then
		min_slot=$(echo "${s}" \
			| grep -E -o ">net-libs/nodejs-[0-9]+:[0-9]+" \
			| head -n 1 | sed -r -e "s|>net-libs/nodejs-[0-9]+:||")
		min_ver=$(echo "${s}" \
			| grep -E -o ">net-libs/nodejs-[0-9]+" \
			| head -n 1 | sed -e "s|>net-libs/nodejs-||")
		if [[ -n "${min_slot}" ]] ; then
			min_ver="${min_ver}"
		fi
	fi
	if [[ "${has_max_le}" == "0" ]] ; then
		max_slot=$(echo "${s}" \
			| grep -E -o "<=net-libs/nodejs-[0-9]+:[0-9]+" \
			| head -n 1 | sed -r -e "s|<=net-libs/nodejs-[0-9]+:||")
		max_ver=$(echo "${s}" \
			| grep -E -o "<=net-libs/nodejs-[0-9]+" \
			| head -n 1 | sed -e "s|<=net-libs/nodejs-||")
		if [[ -n "${max_slot}" ]] ; then
			min_ver="${max_ver}"
		fi
	fi
	if [[ "${has_max_lt}" == "0" ]] ; then
		max_slot=$(echo "${s}" \
			| grep -E -o "<net-libs/nodejs-[0-9]+:[0-9]+" \
			| head -n 1 | sed -r -e "s|<net-libs/nodejs-[0-9]+:||")
		max_ver=$(echo "${s}" \
			| grep -E -o "<net-libs/nodejs-[0-9]+" \
			| head -n 1 | sed -e "s|<net-libs/nodejs-||")
		if [[ -n "${max_slot}" ]] ; then
			min_ver="${max_ver}"
		fi
	fi

	# floor / min
	if [[ "${has_min_ge}" == "0" ]] ; then
		if (( ${node_exe_ver} < ${min_ver} ||
			${node_header_ver} < ${min_ver} )) ; then
eerror
eerror "Both node_exe_ver=${node_exe_ver} node_header_ver=${node_header_ver} need to be"
eerror ">= ${min_ver}.  Use \`eselect nodejs set node#\` to fix this."
eerror
			die
		fi
	fi

	if [[ "${has_min_gt}" == "0" ]] ; then
		if (( ${node_exe_ver} <= ${min_ver} ||
			${node_header_ver} <= ${min_ver} )) ; then
eerror
eerror "Both node_exe_ver=${node_exe_ver} node_header_ver=${node_header_ver} need to be"
eerror "> ${min_ver}.  Use \`eselect nodejs set node#\` to fix this."
eerror
			die
		fi
	fi

	# ceil / max
	if [[ "${has_max_le}" == "0" ]] ; then
		if (( ${node_exe_ver} > ${max_ver} ||
			${node_header_ver} > ${max_ver} )) ; then
eerror
eerror "Both node_exe_ver=${node_exe_ver} node_header_ver=${node_header_ver} need to be"
eerror "<= ${max_ver}.  Use \`eselect nodejs set node#\` to fix this."
eerror
			die
		fi
	fi

	if [[ "${has_max_lt}" == "0" ]] ; then
		if (( ${node_exe_ver} >= ${max_ver} ||
			${node_header_ver} >= ${max_ver} )) ; then
eerror
eerror "Both node_exe_ver=${node_exe_ver} node_header_ver=${node_header_ver} need to be"
eerror "< ${max_ver}.  Use \`eselect nodejs set node#\` to fix this."
eerror
			die
		fi
	fi
}

# @FUNCTION: npm-utils_check_node_eol
# @DESCRIPTION: Checks if the version is node is EOL.
# 0 means EOL, 1 means supported
npm-utils_check_node_eol() {
	local pv="${1}"
	local x
	for x in ${NODE_VERSIONS_SUPPORTED[@]} ; do
		[[ "${x}" == "${pv}" ]] && return 1
	done
	return 0
}

# @FUNCTION: npm-utils_check_chromium_eol
# @DESCRIPTION: Checks if the version is EOL.  Used for
# both Electron and packages like Puppeteer.
npm-utils_check_chromium_eol() {
	# TODO check updated chromium via `chrome --version`
	local chromium_pv=${1}
	if [[ -n "${chromium_pv}" ]] ; then
		if ver_test $(ver_cut 1 ${chromium_pv}) -lt ${CHROMIUM_STABLE_PV} ; then
			if [[ \
				( -n "${NPM_SECAUDIT_NO_DIE_ON_AUDIT}" \
					&& "${NPM_SECAUDIT_NO_DIE_ON_AUDIT}" == "1" ) \
				|| ( -n "${ELECTRON_APP_NO_DIE_ON_AUDIT}" \
					&& "${ELECTRON_APP_NO_DIE_ON_AUDIT}" == "1" ) \
			]] ; then
ewarn
ewarn "The package contains chromium_pv=${chromium_pv} which is End Of Life (EOL)"
ewarn
			else
eerror
eerror "The package contains chromium_pv=${chromium_pv} which is End Of Life"
eerror "(EOL)"
eerror
eerror "Set either NPM_SECAUDIT_NO_DIE_ON_AUDIT=1 or ELECTRON_APP_NO_DIE_ON_AUDIT=1"
eerror "to continue and accept the risks."
eerror
				die
			fi
		else
einfo
einfo "chromium_pv=${chromium_pv} >= chromium_pv_stable=${CHROMIUM_STABLE_PV}"
einfo
		fi
	fi

	if [[ \
		( -n "${NPM_SECAUDIT_CHECK_CHROMIUM}" \
			&& "${NPM_SECAUDIT_CHECK_CHROMIUM}" == "1" ) \
		|| ( -n "${ELECTRON_APP_CHECK_CHROMIUM}" \
			&& "${ELECTRON_APP_CHECK_CHROMIUM}" == "1" ) \
		|| -n "${chromium_pv}" \
	]]; then
		for x in $(find . -name "chrome" 2>/dev/null) ; do
			[[ -d "${x}" ]] && continue
			chromium_pv=$(strings ${x} \
				| grep -E -e "^[0-9]+\.[0-9]\.[0-9]{3,4}\.[0-9]+$" \
				| head -n 1)
			if ver_test $(ver_cut 1 ${chromium_pv}) -lt ${CHROMIUM_STABLE_PV} ; then
				if [[ "${NPM_SECAUDIT_NO_DIE_ON_AUDIT}" == "1" \
					|| "${ELECTRON_APP_NO_DIE_ON_AUDIT}" == "1" ]] ; then
ewarn
ewarn "The package contains chromium_pv=${chromium_pv} which is End Of Life (EOL)"
ewarn
				else
eerror
eerror "The package contains chromium_pv=${chromium_pv} which is End Of Life (EOL)"
eerror
eerror "Set either NPM_SECAUDIT_NO_DIE_ON_AUDIT=1 or ELECTRON_APP_NO_DIE_ON_AUDIT=1"
eerror "to continue and accept the risks."
eerror
					die
				fi
			else
einfo
einfo "chromium_pv=${chromium_pv} >= CHROMIUM_STABLE_PV=${CHROMIUM_STABLE_PV}"
einfo
			fi
		done
	fi
}

# @FUNCTION: npm-utils_avscan
# @DESCRIPTION:
# Scans arg for malware.

# Run every time a new file is added to ${WORKDIR} or ${ED} before running
# anything.

# arg - path to scan
npm-utils_avscan() {
	local path="${1}"
	if [[ \
		"${ELECTRON_APP_AV_SCAN}" == "1" \
		|| "${NPM_SECAUDIT_AV_SCAN}" == "1" \
		|| "${NPM_UTILS_AV_SCAN}" == "1" \
		]] ; then
		if has_version "app-antivirus/clamav[clamapp]" ; then
einfo "Running avscan on ${path}"
			clamscan -r "${path}" || die
		fi
	fi
}
