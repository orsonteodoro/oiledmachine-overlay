# Copyright 1999-2019 Gentoo Authors
# Copyright 2019 Orson Teodoro
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

# @FUNCTION: npm_install_sub
# @DESCRIPTION:
# Installs a npm package in a subdirectory.
# @CODE
# Parameters:
# $1 - directory location to install a package
# $2 ... $n - additional args to npm install (optional)
# @CODE
npm_install_sub() {
	local dir="${1}"
	shift
	einfo "npm_install_sub: dir=${dir}"
	pushd "${dir}" || die
		npm install ${@} || die
		if [ -e package-lock.json ] ; then
			rm package-lock.json
			npm i --package-lock-only || die
		fi
	popd
}

# @FUNCTION: npm_audit_package_lock_update
# @DESCRIPTION:
# Creates a package lock in a subdirectory.
# @CODE
# Parameters:
# $1 - directory location containing the package lock to update
# @CODE
npm_audit_package_lock_update() {
	local dir="${1}"
	einfo "npm_audit_package_lock_update: dir=${dir}"
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

# @FUNCTION: npm_audit_fix
# @DESCRIPTION:
# Performs an audit fix in a sub directory.
# @CODE
# Parameters:
# $1 - directory location to perform audit
# @CODE
npm_audit_fix() {
	local dir="${1}"
	einfo "npm_audit_fix: dir=${dir}"
	pushd "${dir}" || die
		npm audit fix --force
	popd
}

# @FUNCTION: npm_update_babel_package_locks
# @DESCRIPTION:
# Performs an recursive update of babel packages that need package-locks updated
# in order for audits to work properly.  It should be called after deduping is performed.
# @CODE
# Parameters:
# $1 - directory location to start traversing
# @CODE
npm_update_babel_package_locks() {
	local dir="${1}"
	einfo "npm_update_babel_package_locks: dir=${dir}"
	L=$(find "${dir}" -type d -name "babel-template" \
		-o -name "babel-traverse" \
		-o -name "babel-runtime" \
		-o -name "babel-types" \
		-o -name "babel-register" \
		-o -name "babel-polyfill" \
		-o -name "babel-code-frame" \
		-o -name "babel-plugin-transform-es2015-block-scoping")
	for l in ${L} ; do
		if [ -e "${l}/package-lock.json" ] ; then
			pushd "${l}" || die
				einfo "Processing: ${l}"
				rm package-lock.json || die
				npm i --package-lock-only
				npm audit &> "${T}"/npm-audit-result
				if grep -r -e "Errors were found in your package-lock.json" "${T}/npm-audit-result" >/dev/null ; then
					cat "${T}/npm-audit-result"
					eerror "You are likely missing packages.  Do a \`npm ls\` on each one and install the missing package."
					eerror "You may need to install the package in the project root or in the ${l} folder."
					die
				fi
			popd
		fi
	done
}
