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
# The npm-utils eclass defines convenience functions for working with npm with
# subdirectories.

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

# ############## START Per-package environmental variables #####################

# Anything with := is likely a environmental variable setting
# These manage the degree of consent.  Some users want a highly secure system.
# Other users just want the product to install.  By default, the eclasses use
# the policy to block criticals from being merged into the system.

# For those that just want it to install (no security) you can add
# /etc/portage/env/npm-no-audit-fix.conf with the following without # character:
# NPM_SECAUDIT_ALLOW_AUDIT=0
# NPM_SECAUDIT_ALLOW_AUDIT_FIX=0
# NPM_SECAUDIT_NO_DIE_ON_AUDIT=1
# ELECTRON_APP_ALLOW_AUDIT=0
# ELECTRON_APP_ALLOW_AUDIT_FIX=0
# ELECTRON_APP_NO_DIE_ON_AUDIT=1

# Then, add to /etc/portage/package.env
# ${CATEGORY}/${PN} npm-no-audit-fix.conf


# You could define it as a per-package envar, but should not be done in the
# ebuild itself.
NPM_UTILS_ALLOW_AUDIT_FIX=${NPM_UTILS_ALLOW_AUDIT_FIX:="1"}

# You could define it as a per-package envar, but should not be done in the
# ebuild itself.
NPM_UTILS_ALLOW_AUDIT=${NPM_UTILS_ALLOW_AUDIT:="1"}

NPM_UTILS_ALLOW_I_PACKAGE_LOCK=${NPM_UTILS_ALLOW_I_PACKAGE_LOCK:="0"}

# Keep up to date from
# https://www.chromestatus.com/features
# https://en.wikipedia.org/wiki/Google_Chrome_version_history
CHROMIUM_STABLE_V="89"

# ##################  END Per-package environmental variables ##################

# @FUNCTION: npm_check_npm_error
# @DESCRIPTION:
# The `npm install <pkg>` command should return a non-zero value on cb() error
# but does not.  Check and die if error log is found.
npm_check_npm_error()
{
	if find "${HOME}/npm/_logs/"* 2>/dev/null 1>/dev/null ; then
		die \
"Detected potential download failure(s).  Retry.  Logs can be found in \
${HOME}/npm/_logs"
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
	einfo "npm_install_sub: dir=$(pwd)/${dir}"
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
	einfo "npm_install_prod:  npm install ${@} --save-prod"
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
	einfo "npm_install_dev:  npm install ${@} --save-dev"
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
	einfo "npm_uninstall:  npm uninstall ${@}"
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
	einfo "npm_install_no_save:  npm install ${@} --no-save"
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
	einfo "npm_package_lock_update: dir=$(pwd)/${dir}"
	pushd "${dir}" || die
		if [ -e package-lock.json ] ; then
			rm package-lock.json
		else
			ewarn "package-lock.json was not found as expected"
		fi
		npm i --package-lock-only || die
		[ ! -e package-lock.json ] \
		&& ewarn "package-lock.json was not created in ${dir}"
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
		einfo \
"Found auto fixes.  Running \`npm audit fix\`.  is_auto_fix=1"
		npm audit fix || die
		#L=$(cat "${audit_file}" \
#| grep -E -e "to resolve [0-9]+ vulnerabilit(y|ies)" \
#| sed -e "s|# Run  ||" -e "s#  to resolve [0-9]+ vulnerabilit(y|ies)##g")
		#while read -r line ; do
		#	einfo "Auto running fix: ${line}"
		#	eval "${line}"
		#done <<< ${L}
		return 1
	elif [[ "${is_trivial}" == "1" ]] ; then
		einfo \
"Found trivial fixes.  Running \`npm audit fix\`.\n\
is_trivial=1"
		npm audit fix || die
		return 1
		# npm audit 2>&1 > "${audit_file}" || die
		# cat "${audit_file}" | grep -q -F -e "found 0 vulnerabilities" \
		#	|| die "not fixed"
	elif [[ "${is_manual_review}" == "1" ]] ; then
		cat "${audit_file}" || die
		ewarn \
"You still have a vulnerable package.  It requires hand editing.\n\
Fix immediately.  is_manual_review=1.  Reported from: $(pwd)"
		# assumes that fixing operations occur immediately
		return 2
	elif [[ "${is_missing}" == "1" ]] ; then
		einfo "Lockfile is bad.  is_missing=1"
		cat "${audit_file}" || die
	elif [[ "${is_invalid_version}" == "1" ]] ; then
		einfo "Invalid file case.  Fix lock?  is_invalid_version=1"
		rm package-lock.json
		npm i --package-lock-only 2>&1 > "${audit_file}"
		if cat "${audit_file}" | grep -q -F -e "Invalid Version:" ; then
			cat "${audit_file}" || die
			einfo "Still broken.  Requires manual editing."
		fi
		is_clean=0
		cat "${audit_file}" \
			| grep -q -F -e "found 0 vulnerabilities" \
			&& is_clean=1
		if [[ "${is_clean}" == 0 ]] ; then
			einfo \
			"Running \`npm audit fix\` anyway."
			npm audit fix || die
		fi
		npm audit 2>&1 > "${audit_file}" || die
		cat "${audit_file}" | grep -q -F -e "found 0 vulnerabilities" \
			|| return 2
		return 1
	elif [[ "${is_clean}" == "1" ]] ; then
		einfo "Audit was clean.  is_clean=1"
	elif [[ "${is_clean}" == "0" ]] ; then
		einfo "Audit is not clean.  Going to fix.  is_clean=0"
		cat "${audit_file}" || die
		einfo "Running \`npm audit fix\`."
		npm audit fix || die
		return 1
	else
		cat "${audit_file}" || die
		die "Uncaught error"
	fi
	return 0
}

# @FUNCTION: __missing_requires_manual_intervention_message
# @DESCRIPTION:
# Handles the Missing: package dependency in audit's report.
__missing_requires_manual_intervention_message() {
	if grep -q -F -e "Missing:" "${audit_file}" ; then
		cat "${audit_file}" || die
		ewarn \
"Install missing packages.  Do a \`npm ls <package_name>\` of each of the\n\
above packages.  Add them if they are missing"
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
			ewarn \
"Could not safely restore package-lock.json with --package-lock-only.\n\
Forcing 'npm i --package-lock' which may pull vulnerabilities.  dir=$(pwd)"

			# warning: can pull vulnerability
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
			die \
"Missing package-lock.json required for audit.  Fixme:  unknown case."
		else
			if cat "${audit_file}" | grep -q -F -e "npm ERR!" ; then
				cat "${audit_file}"
				die "Uncaught error"
			fi
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
	einfo "npm_audit_fix: dir=$(pwd)/${dir}"
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
					einfo \
"Repair rate tries is used up."
					break
				else
					einfo \
"Repair rate is a coincidental constant?  tries=${tries}"
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
		einfo \
"npm_update_package_locks_recursive (pre audit): preforming pass #${i}\n\
dir=$(realpath ${base}/${dir})"
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
		einfo \
"npm_update_package_locks_recursive (locks update): preforming pass #${i}"
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
							die "Uncaught error"
						fi
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
		einfo \
"Convergence rates: current_broken_lock_count=${current_broken_lock_count}\n\
previous_broken_lock_count=${previous_broken_lock_count}"
		previous_broken_lock_count=${current_broken_lock_count}
		i=$((${i}+1))
	done

	einfo "npm_update_package_locks_recursive: done"
}

# @FUNCTION: npm-utils_install_header_license
# @DESCRIPTION:
# Installs a license header
npm-utils_install_header_license() {
	local dir_path="${1}"
	local file_name="${2}"
	local license_name="${3}"
	local length="${4}"
	d="${dir_path}"
	dl="licenses/${d}"
	docinto "${dl}"
	mkdir -p "${T}/${dl}" || die
	head -n ${length} "${S}/${d}/${file_name}" > \
		"${T}/${dl}/${license_name}" || die
	dodoc "${T}/${dl}/${license_name}"
}

# @FUNCTION: npm-utils_install_license_mid
# @DESCRIPTION:
# Installs a license from the middle of a file
npm-utils_install_license_mid() {
	local dir_path="${1}"
	local file_name="${2}"
	local license_name="${3}"
	local start="${4}"
	local length="${5}"
	d="${dir_path}"
	dl="licenses/${d}"
	docinto "${dl}"
	mkdir -p "${T}/${dl}" || die
	tail -n +${start} "${S}/${d}/${file_name}" \
		| head -n ${length} > \
		"${T}/${dl}/${license_name}" || die
	dodoc "${T}/${dl}/${license_name}"
}

# @FUNCTION: npm-utils_install_licenses
# @DESCRIPTION:
# Installs all licenses from main package and micropackages
# Standardizes the process.
npm-utils_install_licenses() {
	OIFS="${IFS}"
	export IFS=$'\n'
	for f in $(find "${S}" \
	  -iname "*licen*" -type f \
	  -o -iname "*copyright*" \
	  -o -iname "*copying*" \
	  -o -iname "*patent*" \
	  -o -iname "ofl.txt" \
	  -o -iname "*notice*" \
	  ) $(grep -i -G -l \
		-e "copyright" \
		-e "licen" \
		-e "warrant" \
		$(find "${S}" -iname "*readme*")) ; \
	do
		if [[ -f "${f}" ]] ; then
			d=$(dirname "${f}" | sed -e "s|^${S}||")
		else
			d=$(echo "${f}" | sed -e "s|^${S}||")
		fi
		docinto "licenses/${d}"
		dodoc -r "${f}"
	done
	export IFS="${OIFS}"
}

# @FUNCTION: npm-utils_install_readmes
# @DESCRIPTION:
# Installs all readmes including those from micropackages.  Standardizes the
# process.
npm-utils_install_readmes() {
	OIFS="${IFS}"
	export IFS=$'\n'
	for f in $(find "${S}" \
	  -iname "*.pdf" \
	  -o -iname "*authors*" \
	  -o -iname "*bug*report*.md" \
	  -o -iname "*changelog*" \
	  -o -iname "*changes*" \
	  -o -iname "*code*of*conduct*" \
	  -o -iname "*contributing*" \
	  -o -iname "*feature*request*.md" \
	  -o -iname "*governance*" \
	  -o -iname "*history*" \
	  -o -iname "*issue*template*.md" \
	  -o -iname "*language*.md" \
	  -o -iname "*pull*request*template*.md" \
	  -o -iname "*readme*" \
	  -o -ipath "*/doc/*" \
	  -o -ipath "*/docs/*" \
	  ) ; \
	do
		if [[ -f "${f}" ]] ; then
			d=$(dirname "${f}" | sed -e "s|^${S}||")
		else
			d=$(echo "${f}" | sed -e "s|^${S}||")
		fi
		docinto "readmes/${d}"
		dodoc -r "${f}"
	done
	export IFS="${OIFS}"
}

# @FUNCTION: npm-utils_is_nodejs_header_exe_same
# @DESCRIPTION:
# Ensures header and node exe are the same version.  Check is
# required for multislot nodejs.
npm-utils_is_nodejs_header_exe_same() {
	local node_v=$(node --version | sed -e "s|v||")
	local node_major=$(grep -r -e "NODE_MAJOR_VERSION" \
		/usr/include/node/node_version.h | head -n 1 | cut -f 3 -d " ")
	local node_minor=$(grep -r -e "NODE_MINOR_VERSION" \
		/usr/include/node/node_version.h | head -n 1 | cut -f 3 -d " ")
	local node_patch=$(grep -r -e "NODE_PATCH_VERSION" \
		/usr/include/node/node_version.h | head -n 1 | cut -f 3 -d " ")
	if ver_test ${node_major}.${node_minor} -ne $(ver_cut 1-2 ${node_v}) ; then
		die \
"Inconsistency between node header and active executable version.\n\
Switch your headers via \`eselect nodejs\`"
	else
		einfo \
"Node.js header version: ${node_major}.${node_minor}.${node_minor}\n\
Node.js exe version: ${node_v}"
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
	local node_exe_v=$(node --version | sed -e "s|v||")
	local node_header_v=$(grep -r -e "NODE_MAJOR_VERSION" \
		/usr/include/node/node_version.h | head -n 1 \
		| cut -f 3 -d " ")
	node_exe_v=$(echo "${node_exe_v}" | cut -f 1 -d ".")

	local s="${1}"
	local has_min_ge=$(echo "${s}" | grep -q -E -o ">=net-libs/nodejs" ; echo $?)
	local has_min_gt=$(echo "${s}" | grep -q -E -o ">net-libs/nodejs" ; echo $?)
	local has_max_le=$(echo "${s}" | grep -q -E -o "<=net-libs/nodejs" ; echo $?)
	local has_max_lt=$(echo "${s}" | grep -q -E -o "<net-libs/nodejs" ; echo $?)
	local min_v
	local max_v
	if [[ "${has_min_ge}" == "0" ]] ; then
		min_slot_v=$(echo "${s}" \
			| grep -E -o ">=net-libs/nodejs-[0-9]+:[0-9]+" \
			| head -n 1 | sed -r -e "s|>=net-libs/nodejs-[0-9]+:||")
		min_v=$(echo "${s}" \
			| grep -E -o ">=net-libs/nodejs-[0-9]+" \
			| head -n 1 | sed -e "s|>=net-libs/nodejs-||")
		if [[ -n "${min_slot_v}" ]] ; then
			min_v="${min_v}"
		fi
	fi
	if [[ "${has_min_gt}" == "0" ]] ; then
		min_slot_v=$(echo "${s}" \
			| grep -E -o ">net-libs/nodejs-[0-9]+:[0-9]+" \
			| head -n 1 | sed -r -e "s|>net-libs/nodejs-[0-9]+:||")
		min_v=$(echo "${s}" \
			| grep -E -o ">net-libs/nodejs-[0-9]+" \
			| head -n 1 | sed -e "s|>net-libs/nodejs-||")
		if [[ -n "${min_slot_v}" ]] ; then
			min_v="${min_v}"
		fi
	fi
	if [[ "${has_max_le}" == "0" ]] ; then
		max_slot_v=$(echo "${s}" \
			| grep -E -o "<=net-libs/nodejs-[0-9]+:[0-9]+" \
			| head -n 1 | sed -r -e "s|<=net-libs/nodejs-[0-9]+:||")
		max_v=$(echo "${s}" \
			| grep -E -o "<=net-libs/nodejs-[0-9]+" \
			| head -n 1 | sed -e "s|<=net-libs/nodejs-||")
		if [[ -n "${max_slot_v}" ]] ; then
			min_v="${max_v}"
		fi
	fi
	if [[ "${has_max_lt}" == "0" ]] ; then
		max_slot_v=$(echo "${s}" \
			| grep -E -o "<net-libs/nodejs-[0-9]+:[0-9]+" \
			| head -n 1 | sed -r -e "s|<net-libs/nodejs-[0-9]+:||")
		max_v=$(echo "${s}" \
			| grep -E -o "<net-libs/nodejs-[0-9]+" \
			| head -n 1 | sed -e "s|<net-libs/nodejs-||")
		if [[ -n "${max_slot_v}" ]] ; then
			min_v="${max_v}"
		fi
	fi

	# floor / min
	if [[ "${has_min_ge}" == "0" ]] ; then
		if (( ${node_exe_v} < ${min_v} ||
			${node_header_v} < ${min_v} )) ; then
			die \
"Both node_exe_v=${node_exe_v} node_header_v=${node_header_v} need to be \
>= ${min_v}"
		fi
	fi

	if [[ "${has_min_gt}" == "0" ]] ; then
		if (( ${node_exe_v} <= ${min_v} ||
			${node_header_v} <= ${min_v} )) ; then
			die \
"Both node_exe_v=${node_exe_v} node_header_v=${node_header_v} need to be \
> ${min_v}"
		fi
	fi

	# ceil / max
	if [[ "${has_max_le}" == "0" ]] ; then
		if (( ${node_exe_v} > ${max_v} ||
			${node_header_v} > ${max_v} )) ; then
			die \
"Both node_exe_v=${node_exe_v} node_header_v=${node_header_v} need to be \
<= ${max_v}"
		fi
	fi

	if [[ "${has_max_lt}" == "0" ]] ; then
		if (( ${node_exe_v} >= ${max_v} ||
			${node_header_v} >= ${max_v} )) ; then
			die \
"Both node_exe_v=${node_exe_v} node_header_v=${node_header_v} need to be \
< ${max_v}"
		fi
	fi
}

# @FUNCTION: npm-utils_check_chromium_eol
# @DESCRIPTION: Checks if the version is EOL.  Used for
# both Electron and packages like Puppeteer.
npm-utils_check_chromium_eol() {
	# TODO check updated chromium via `chrome --version`
	local chromium_v=${1}
	if [[ -n "${chromium_v}" ]] ; then
		if ver_test $(ver_cut 1 ${chromium_v}) -lt ${CHROMIUM_STABLE_V} ; then
			if [[ \
				( -n "${NPM_SECAUDIT_NO_DIE_ON_AUDIT}" \
					&& "${NPM_SECAUDIT_NO_DIE_ON_AUDIT}" == "1" ) \
				|| ( -n "${ELECTRON_APP_NO_DIE_ON_AUDIT}" \
					&& "${ELECTRON_APP_NO_DIE_ON_AUDIT}" == "1" ) \
			]] ; then
				ewarn \
"The package contains chromium_v=${chromium_v} which is End Of Life (EOL)"
			else
				die \
"The package contains chromium_v=${chromium_v} which is End Of Life (EOL)"
			fi
		else
			einfo \
"chromium_v=${chromium_v} >= chromium_v_stable=${CHROMIUM_STABLE_V}"
		fi
	fi

	if [[ \
		( -n "${NPM_SECAUDIT_CHECK_CHROMIUM}" \
			&& "${NPM_SECAUDIT_CHECK_CHROMIUM}" == "1" ) \
		|| ( -n "${ELECTRON_APP_CHECK_CHROMIUM}" \
			&& "${ELECTRON_APP_CHECK_CHROMIUM}" == "1" ) \
		|| -n "${chromium_v}" \
	]]; then
		for x in $(find . -name "chrome" 2>/dev/null) ; do
			chromium_v=$(strings ${x} \
		| grep -E -e "^[0-9]+\.[0-9]\.[0-9]{3,4}\.[0-9]+$" | head -n 1)
			if ver_test $(ver_cut 1 ${chromium_v}) -lt ${CHROMIUM_STABLE_V} ; then
				if [[ "${NPM_SECAUDIT_NO_DIE_ON_AUDIT}" == "1" ]] ; then
					ewarn \
"The package contains chromium_exe_v=${chromium_v} which is End Of Life (EOL)"
				else
					die \
"The package contains chromium_exe_v=${chromium_v} which is End Of Life (EOL)"
				fi
			else
				einfo \
"chromium_exe_v=${chromium_v} >= chromium_exe_v_stable=${CHROMIUM_STABLE_V}"
			fi
		done
	fi
}
