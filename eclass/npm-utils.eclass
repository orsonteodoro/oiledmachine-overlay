# Copyright 2019-2020 Orson Teodoro
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: npm-utils.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 4 5 6 7
# @BLURB: Eclass for wrapper npm commands
# @DESCRIPTION:
# The npm-utils eclass defines convenience functions for working with npm with subdirectories.

NPM_UTILS_ALLOW_AUDIT_FIX=${NPM_UTILS_ALLOW_AUDIT_FIX:="1"}
NPM_UTILS_ALLOW_AUDIT=${NPM_UTILS_ALLOW_AUDIT:="1"}

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

# @FUNCTION: __check_vulnerable
# @DESCRIPTION:
# Inspects if vulnerable.  It will fix trivial vulnerabilities.
__check_vulnerable() {
	if [[ -n "${NPM_UTILS_ALLOW_AUDIT_FIX}" && "${NPM_UTILS_ALLOW_AUDIT_FIX}" == "1" ]] ; then
		:;
	else
		return
	fi

	npm audit &> "${audit_file}"
	cat "${audit_file}" | grep -F "npm audit fix" >/dev/null
	local result_found2="$?"
	if [[ "${result_found2}" == "0" ]] ; then
		einfo "Found trivial fixes... running \`npm audit fix --force\`."
		npm audit fix --force || die
	fi

	npm audit &> "${audit_file}"
	cat "${audit_file}" | grep -F "# Run" >/dev/null
	local result_found3="$?"
	if [[ "${result_found3}" == "0" ]] ; then
		L=$(cat "${audit_file}" | grep -P -e "to resolve [0-9]+ vulnerabilit(y|ies)" | sed -r -e "s|# Run  ||" -e "s#  to resolve [0-9]+ vulnerabilit(y|ies)##g")
		while read -r line ; do
			einfo "Auto running fix: ${line}"
			eval "${line}"
		done <<< ${L}
	fi

	npm audit &> "${audit_file}"
	cat "${audit_file}" | grep -F "require manual review" >/dev/null
	local result_found1="$?"
	if [[ "${result_found1}" == "0" ]] ; then
		cat "${audit_file}"
		ewarn "You still have a vulnerable package.  It requires manual review.  Fix immediately."
		ewarn "Reported from: $(pwd)"
		# assumes that fixing operations occur immediately
	fi
}

# @FUNCTION: __post_audit_missing
# @DESCRIPTION:
# Handles the Missing: package dependency in audit's report.
__post_audit_missing() {
	npm audit &> "${audit_file}"
	if grep -e "Missing:" "${audit_file}" >/dev/null ; then
		cat "${audit_file}"
		ewarn "Install missing packages.  Do a \`npm ls <package_name>\` of each of the above packages.  Add them if they are missing"
		ewarn
		ewarn "The package lock dir: ${dir}"
		ewarn "The package.json: ${dir}/package.json"
		ewarn "The package-lock.json: ${dir}/package-lock.json"
		# assumes that fixing operations occur immediately
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

	local audit_file="${T}/npm-audit-result"
	if [ -e package-lock.json ] ; then
		# upstream wanted package lock case
		npm audit &> "${audit_file}"

		if grep -e "Manual Review" "${audit_file}" >/dev/null || grep -e "npm audit security report" "${audit_file}" >/dev/null ; then
			# false positive cases when project-lock.json is old caused by deduping
			rm package-lock.json || die
			npm i --package-lock-only
			if [ ! -e package-lock.json ] ; then
				npm i --package-lock # warning: can pull vulnerability
			fi
		fi
		if grep -e "Missing:" "${audit_file}" >/dev/null ; then
			# package-lock.json may be broken.  try to fix before doing audit
			rm package-lock.json || die
			npm i --package-lock-only
			if [ ! -e package-lock.json ] ; then
				npm i --package-lock # warning: can pull vulnerability
			fi
			__post_audit_missing
		fi
		if grep -e "does not satisfy" "${audit_file}" >/dev/null ; then
			rm package-lock.json || die
			npm i --package-lock-only
			if [ ! -e package-lock.json ] ; then
				npm i --package-lock # warning: can pull vulnerability
			fi
		fi
		if [ ! -e package-lock.json ] ; then
			die "Missing package-lock.json required for audit"
		fi
	else
		die "Using npm_pre_audit requires a package-lock.json"
	fi

	if [ -e package-lock.json ] ; then
		# fix trivial vulnerabilities
		__check_vulnerable
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
		npm_pre_audit
		npm audit fix --force
	popd
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
	while true ; do
		einfo "npm_update_package_locks_recursive (pre audit): preforming pass #${i} dir=$(realpath ${base}/${dir})"
		L=$(find "${dir}" -type f -name "package-lock.json")
		for l in ${L} ; do
			if [ -e "${l}" ] ; then
				pushd "$(dirname ${l})" || die
					local audit_file="${T}/npm-audit-result"

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
						ewarn "__check_vulnerable: Found Missing:"
						if [ -e package-lock.json ] ; then
							einfo "__check_vulnerable:  Fixing package lock."
							rm package-lock.json
							npm i --package-lock-only
							__check_vulnerable
						fi
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

# @FUNCTION: npm_dedupe_cycle
# @DESCRIPTION:
# Removes circular chain
# It happens when fixing package-locks with missing packages.
# @CODE
# Parameters:
# $1 - base directory of project root
# @CODE
npm_dedupe_cycle() {
	local B="${1}"
	local P=$(pwd | sed -e "s|${B}||")
	L1=$(echo "${P}" | sed -e "s|node_modules/||g" | tr "/" "\n" | wc -l)
	L2=$(echo "${P}" | sed -e "s|node_modules/||g" | tr "/" "\n" | uniq | wc -l)
	if [[ "${L1}" != "${L2}" ]] ; then
		einfo "Circular chain detected"
		pushd "${B}" || die
			npm dedupe
		popd
	fi
}
