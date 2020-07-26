# Copyright 2019-2020 Orson Teodoro
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: npm-utils.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 6 7
# @BLURB: Eclass for wrapper npm commands
# @DESCRIPTION:
# The npm-utils eclass defines convenience functions for working with npm with subdirectories.

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

NPM_UTILS_ALLOW_AUDIT_FIX=${NPM_UTILS_ALLOW_AUDIT_FIX:="1"} # You could define it as a per-package envar, but should not be done in the ebuild itself.
NPM_UTILS_ALLOW_AUDIT=${NPM_UTILS_ALLOW_AUDIT:="1"} # You could define it as a per-package envar, but should not be done in the ebuild itself.
NPM_UTILS_ALLOW_I_PACKAGE_LOCK=${NPM_UTILS_ALLOW_I_PACKAGE_LOCK:="0"}
NPM_UTILS_FIX_FORCE=${NPM_UTILS_FIX_FORCE:="0"} # You could define it as a per-package envar, but should not be done in the ebuild itself.

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
	einfo "npm_install_sub: dir=$(pwd)/${dir}"
	pushd "${dir}" || die
		npm install ${@} || die
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
# $1 ... $n - additional args to npm install (optional)
# @CODE
npm_install_prod() {
	einfo "npm_install_prod:  npm install ${@} --save-prod"
	npm install ${@} --save-prod || die
	if [ -e package-lock.json ] ; then
		npm_pre_audit
	fi
}

# @FUNCTION: npm_install_prod
# @DESCRIPTION:
# Installs a npm package as a development dependency
# @CODE
# Parameters:
# $1 ... $n - additional args to npm install (optional)
# @CODE
npm_install_dev() {
	einfo "npm_install_dev:  npm install ${@} --save-dev"
	npm install ${@} --save-dev || die
	if [ -e package-lock.json ] ; then
		npm_pre_audit
	fi
}

# @FUNCTION: npm_install_no_save
# @DESCRIPTION:
# Installs a npm package without altering the package.json
# @CODE
# Parameters:
# $1 ... $n - additional args to npm install (optional)
# @CODE
npm_install_no_save() {
	einfo "npm_install_no_save:  npm install ${@} --no-save"
	npm install ${@} --no-save || die
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
	einfo "npm_package_lock_update: dir=$(pwd)/${dir}"
	pushd "${dir}" || die
		if [ -e package-lock.json ] ; then
			rm package-lock.json
		else
			ewarn "package-lock.json was not found as expected"
		fi
		npm i --package-lock-only || die
		[ ! -e package-lock.json ] && ewarn "package-lock.json was not created in ${dir}"
	popd
}

# @FUNCTION: npm_auto_fix
# @DESCRIPTION:
# Inspects if vulnerable.  It will fix trivial vulnerabilities.
# @RETURNS: 0 no audit fix, 1 for audit fix, 2 on error
npm_auto_fix() {
	if [[ -n "${NPM_UTILS_ALLOW_AUDIT_FIX}" && "${NPM_UTILS_ALLOW_AUDIT_FIX}" == "1" ]] ; then
		:;
	else
		return
	fi

	local option_fix_force=""
	if [[ -n "${NPM_UTILS_FIX_FORCE}" && "${NPM_UTILS_FIX_FORCE}" == "1" ]] ; then
		option_fix_force="--force"
	fi

	local is_trivial=0
	local is_auto_fix=0
	local is_manual_review=0
	local is_clean=0
	local is_missing=0
	local is_invalid_version=0
	local audit_file="${T}/npm-audit-result"
	npm audit &> "${audit_file}"
	cat "${audit_file}" || die
	local needed_fix="$?"
	cat "${audit_file}" | grep -F "npm audit fix" >/dev/null && is_trivial=1
	cat "${audit_file}" | grep -F "# Run" >/dev/null && is_auto_fix=1
	cat "${audit_file}" | grep -F "require manual review" >/dev/null && is_manual_review=1
	cat "${audit_file}" | grep -F "found 0 vulnerabilit" >/dev/null && is_clean=1
	cat "${audit_file}" | grep -F "Missing:" >/dev/null && is_missing=1
	cat "${audit_file}" | grep -F "Invalid Version:" >/dev/null && is_invalid_version=1
	if [[ "${is_auto_fix}" == "1" ]] ; then
		einfo "Found auto fixes.  Running \`npm audit fix ${option_fix_force}\`.  is_auto_fix=1"
		npm audit fix ${option_fix_force}
		#L=$(cat "${audit_file}" | grep -P -e "to resolve [0-9]+ vulnerabilit(y|ies)" | sed -r -e "s|# Run  ||" -e "s#  to resolve [0-9]+ vulnerabilit(y|ies)##g")
		#while read -r line ; do
		#	einfo "Auto running fix: ${line}"
		#	eval "${line}"
		#done <<< ${L}
		return 1
	elif [[ "${is_trivial}" == "1" ]] ; then
		einfo "Found trivial fixes.  Running \`npm audit fix ${option_fix_force}\`.  is_trivial=1"
		npm audit fix ${option_fix_force} || die
		return 1
		npm audit 2>&1 > "${audit_file}"
		cat "${audit_file}" | grep -F "found 0 vulnerabilities" || die "not fixed"
	elif [[ "${is_manual_review}" == "1" ]] ; then
		cat "${audit_file}" || die
		ewarn "You still have a vulnerable package.  It requires hand editing.  Fix immediately.  is_manual_review=1"
		ewarn "Reported from: $(pwd)"
		# assumes that fixing operations occur immediately
		return 2
	elif [[ "${is_missing}" == "1" ]] ; then
		einfo "Lockfile is bad.  is_missing=1"
		cat "${audit_file}" || die
	elif [[ "${is_invalid_version}" == "1" ]] ; then
		einfo "Invalid file case.  Fix lock?  is_invalid_version=1"
		rm package-lock.json
		npm i --package-lock-only 2>&1 > "${audit_file}"
		if cat "${audit_file}" | grep -F "Invalid Version:" >/dev/null ; then
			cat "${audit_file}" || die
			einfo "Still broken.  Requires manual editing."
		fi
		is_clean=0
		cat "${audit_file}" | grep -F "found 0 vulnerabilities" >/dev/null && is_clean=1
		if [[ "${is_clean}" == 0 ]] ; then
			einfo "Running \`npm audit fix ${option_fix_force}\` anyway."
			npm audit fix ${option_fix_force}
		fi
		npm audit 2>&1 > "${audit_file}"
		cat "${audit_file}" | grep -F "found 0 vulnerabilities" || return 2
		return 1
	elif [[ "${is_clean}" == "1" ]] ; then
		einfo "Audit was clean.  is_clean=1"
	elif [[ "${is_clean}" == "0" ]] ; then
		einfo "Audit is not clean.  Going to fix.  is_clean=0"
		cat "${audit_file}" || die
		einfo "Running \`npm audit fix ${option_fix_force}\`."
		npm audit fix ${option_fix_force} || die
		return 1
	else
		cat "${audit_file}" || die
		die "Encountered unknown case.  Fixme"
	fi
	return 0
}

# @FUNCTION: __missing_requires_manual_intervention_message
# @DESCRIPTION:
# Handles the Missing: package dependency in audit's report.
__missing_requires_manual_intervention_message() {
	if grep -e "Missing:" "${audit_file}" >/dev/null ; then
		cat "${audit_file}" || die
		ewarn "Install missing packages.  Do a \`npm ls <package_name>\` of each of the above packages.  Add them if they are missing"
		ewarn
		ewarn "The package lock dir: ${dir}"
		ewarn "The package.json: ${dir}/package.json"
		ewarn "The package-lock.json: ${dir}/package-lock.json"
		# assumes that fixing operations occur immediately
	fi
}

__replace_package_lock() {
	rm package-lock.json || die
	npm i --package-lock-only 2>&1 > "${audit_file}"
	__missing_requires_manual_intervention_message
	if [ ! -e package-lock.json ] ; then
		if [[ "${NPM_UTILS_ALLOW_I_PACKAGE_LOCK}" == "1" ]] ; then
			ewarn "Could not safely restore package-lock.json with --package-lock-only.  Forcing 'npm i --package-lock' which may pull vulnerabilities.  dir=$(pwd)"
			npm i --package-lock 2>&1 > "${audit_file}"  # warning: can pull vulnerability
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
		npm audit &> "${audit_file}"

		if grep -e "Manual Review" "${audit_file}" >/dev/null || grep -e "npm audit security report" "${audit_file}" >/dev/null ; then
			# false positive cases when project-lock.json is old caused by deduping
			__replace_package_lock
		elif grep -e "Missing:" "${audit_file}" >/dev/null ; then
			# package-lock.json may be broken.  try to fix before doing audit
			__replace_package_lock
		elif grep -e "does not satisfy" "${audit_file}" >/dev/null ; then
			__replace_package_lock
		elif [ ! -e package-lock.json ] ; then
			die "Missing package-lock.json required for audit.  Fixme:  unknown case."
		fi
	else
		die "Using npm_pre_audit requires a package-lock.json"
	fi

	if [ -e package-lock.json ] ; then
		# fix trivial vulnerabilities
		npm_auto_fix
	else
		die "npm_pre_audit didn't create a package-lock.json"
	fi
}

# @FUNCTION: npm_audit_fix
# @DESCRIPTION:
# Performs an audit fix in a sub directory.
#
# It will halt if it is not able to create a package-json.json.
#
# It will continue if it detects a vulnerability.  It is assumed that commands following call fix it.
#
# @CODE
# Parameters:
# $1 - directory location to perform audit
# @CODE
npm_audit_fix() {
	if [[ -n "${NPM_UTILS_ALLOW_AUDIT_FIX}" && "${NPM_UTILS_ALLOW_AUDIT_FIX}" == "1" ]] ; then
		:;
	else
		return
	fi

	local dir="${1}"
	einfo "npm_audit_fix: dir=$(pwd)/${dir}"
	pushd "${dir}" || die
		npm_pre_audit # calls npm audit fix --force if trivial
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
			einfo "npm_audit_fix_recursive_and_converging: dir=${l} (pass #${i})"
			pushd $(dirname "${l}") || die
				npm_auto_fix
				if (( $? == 1 )) ; then
					n_repairs=$((${n_repairs}+1))
				fi
			popd
		done

		if [[ "${n_repairs}" == "0" ]] ; then
			einfo "n_repairs is 0"
			break
		fi

		if (( ${previous_n_repairs} != -1 )) ; then
			if (( ${n_repairs} > ${previous_n_repairs} )) ; then
				die "Repair rate explosion.  Unfixable."
			elif (( ${n_repairs} < ${previous_n_repairs} )) ; then
				einfo "Repair rate is converging toward zero"
			elif (( ${n_repairs} == ${previous_n_repairs} )) ; then
				tries=$((${tries}+1))
				if (( ${tries} >= 3 )) ; then
					einfo "Repair rate tries is used up."
					break
				else
					einfo "Repair rate is a coincidental constant?  tries=${tries}"
				fi
			fi
		fi
		einfo "Convergence rate: n_repairs=${n_repairs}"
		previous_n_repairs=${n_repairs}
		i=$((${i}+1))
	done
}

# @FUNCTION: npm_update_package_locks_recursive
# @DESCRIPTION:
# Performs an recursive update of locked packages that need package-locks updated
# in order for audits to work properly.  It should be called after deduping is performed.
# It is assumed that the entire project at this point has already had all its in-the-wild
# vulnerable packages removed before calling it.
#
# It will halt if it is not able to create a package-json.json.
#
# It will continue if it detects a vulnerability.  It is assumed that commands following call fix it.
#
# @CODE
# Parameters:
# $1 - directory location to start traversing which should be the project root
# @CODE
npm_update_package_locks_recursive() {
	if [[ -n "${NPM_UTILS_ALLOW_AUDIT}" && "${NPM_UTILS_ALLOW_AUDIT}" == "1" ]] ; then
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
		einfo "npm_update_package_locks_recursive (pre audit): preforming pass #${i} dir=$(realpath ${base}/${dir})"
		L=$(find "${dir}" -type f -name "package-lock.json")
		for l in ${L} ; do
			if [ -e "${l}" ] ; then
				pushd "$(dirname ${l})" || die

					einfo "Processing: $(realpath ${base}/${l})"
					npm_pre_audit
				popd
			fi
		done

		current_broken_lock_count=0
		einfo "npm_update_package_locks_recursive (locks update): preforming pass #${i}"
		L=$(find "${dir}" -type f -name "package-lock.json")
		for l in ${L} ; do
			if [ -e "${l}" ] ; then
				pushd "$(dirname ${l})" || die
					npm audit &> "${audit_file}"
					if grep -e "Missing:" "${audit_file}" >/dev/null ; then
						npm_pre_audit
						current_broken_lock_count=$((${current_broken_lock_count}+1))
					fi
				popd
			fi
		done
		if (( ${current_broken_lock_count} == 0 )) ; then
			einfo "No broken locks encountered"
			break
		fi
		if (( ${previous_broken_lock_count} != -1 )) ; then
			# the broken locks should converge towards zero
			if (( ${current_broken_lock_count} > ${previous_broken_lock_count} )) ; then
				# if the rate of broken locks should never increase over time
				die "Intractable lock fix algorithm.  Fix the algorithm."
			fi

			if (( ${current_broken_lock_count} == ${previous_broken_lock_count} )) ; then
				# ideal termination condition
				# 0 == 0 is the perfect scenario
				n_constant=$((${n_constant}+1))
				if (( ${n_constant} >= 3 )) ; then
					einfo "Constant rate encountered.  n_constant=${n_constant}"
					# this case means 3 samples, coincindental constant rate
					break
				fi
			else
				einfo "Rates are converging toward 0."
				n_constant=0
			fi
		fi
		einfo "Convergence rates: current_broken_lock_count=${current_broken_lock_count} previous_broken_lock_count=${previous_broken_lock_count}"
		previous_broken_lock_count=${current_broken_lock_count}
		i=$((${i}+1))
	done

	einfo "npm_update_package_locks_recursive: done"
}

