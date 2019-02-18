# Copyright 1999-2019 Gentoo Foundation
# Copyright 2019 Orson Teodoro
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
# It depends on the sys-app/npm-secaudit package to maintain a
# secure environment.
#
# It was intended to replace the insecure npm.eclass implementations and
# reduce packaging time.

case "${EAPI:-0}" in
        0|1|2|3)
                die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
                ;;
        4|5|6)
                ;;
        *)
                die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
                ;;
esac

DEPEND+=" app-portage/npm-secaudit"

NPM_PACKAGE_DB="/var/lib/portage/npm-packages"

EXPORT_FUNCTIONS pkg_postrm

# @FUNCTION: npm-secaudit-build
# @DESCRIPTION:
# Builds an electron app with security checks
npm-secaudit-build() {
	local path="$1"

	pushd "${1}"
	npm install || die
	if [[ ! -e package-lock.js ]] ; then
		einfo "Running \`npm i --package-lock-only\`"
		npm i --package-lock-only # prereq for command below
	fi
	einfo "Running \`npm audit fix --force\`"
	npm audit fix --force || die
	einfo "Auditing security done"
	npm install electron || die
	popd
}

# @FUNCTION: npm-secaudit-register
# @DESCRIPTION:
# Adds the package to the electron database
# This function MUST be called in src_install.
npm-secaudit-register() {
	local rel_path=${1:-""}
	local check_path="/usr/$(get_libdir)/node/${PN}/${SLOT}/${rel_path}"
	# format:
	# ${CATEGORY}/${P}	path_to_package		date_of_last_check
	addwrite "${NPM_PACKAGE_DB}"

	# remove existing entry
	sed -i -e "s|${CATEGORY}/${P}.*||g" "${NPM_PACKAGE_DB}"

	echo -e "${CATEGORY}/${P}\t${check_path}\t$(date +%s)" >> "${NPM_PACKAGE_DB}"
}

# @FUNCTION: npm-secaudit-install
# @DESCRIPTION:
# Installs a desktop app.
npm-secaudit-install() {
	local rel_src_path="$1"

	mkdir -p "${D}/usr/$(get_libdir)/node/${PN}/${SLOT}"
	cp -a ${rel_src_path} "${D}/usr/$(get_libdir)/node/${PN}/${SLOT}"
}

# @FUNCTION: npm-secaudit_pkg_postrm
# @DESCRIPTION:
# Post-removal hook for Electron apps. Removes information required for security checks.
npm-secaudit_pkg_postrm() {
	sed -i -e "s|${CATEGORY}/${P}.*||g" "${NPM_PACKAGE_DB}"
}
