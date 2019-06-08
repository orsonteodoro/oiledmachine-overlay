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
npm_install_sub() {
	local dir="${1}"
	einfo "dir=${dir}"
	pushd "${dir}"
	npm install
	[ -e package-lock.json ] && rm package-lock.json
	npm i --package-lock-only
	popd
}

# @FUNCTION: npm_audit_package_lock_update
# @DESCRIPTION:
# Creates a package lock in a subdirectory.
npm_audit_package_lock_update() {
	local dir="${1}"
	einfo "dir=${dir}"
	pushd "${dir}"
	rm package-lock.json
	npm i --package-lock-only
	popd
}

# @FUNCTION: npm_audit_fix
# @DESCRIPTION:
# Performs an audit fix in a sub directory.
npm_audit_fix() {
	local dir="${1}"
	einfo "dir=${dir}"
	pushd "${dir}"
	npm audit fix --force
	popd
}
