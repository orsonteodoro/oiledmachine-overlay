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
# It depends on the app-portage/npm-secaudit package to maintain a
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

inherit eutils

EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare src_compile pkg_postrm

DEPEND+=" app-portage/npm-secaudit"
IUSE+=" debug"

NPM_PACKAGE_DB="/var/lib/portage/npm-packages"
NPM_AUDIT_REG_PATH=""

# @FUNCTION: npm_pkg_setup
# @DESCRIPTION:
# Initializes globals
npm-secaudit_pkg_setup() {
        debug-print-function ${FUNCNAME} "${@}"

	export NPM_STORE_DIR="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}/npm"
	export npm_config_cache="${NPM_STORE_DIR}"
}

# @FUNCTION: npm-secaudit-fetch-deps
# @DESCRIPTION:
# Builds an electron app with security checks
# MUST be called after default unpack AND patching.
npm-secaudit-fetch-deps() {
	pushd "${S}"
	npm install || die
	if [[ ! -e package-lock.js ]] ; then
		einfo "Running \`npm i --package-lock\`"
		npm i --package-lock # prereq for command below
	fi
	einfo "Running \`npm audit fix --force\`"
	npm audit fix --force || die
	einfo "Auditing security done"
	if ! use debug ; then
		npm prune --production
	fi
	popd
}

# @FUNCTION: npm_unpack
# @DESCRIPTION:
# Initializes cache folder and gets the archive
# without dependencies.  You MUST call
# npm-secaudit-fetch-deps manually.
npm-secaudit_src_unpack() {
        debug-print-function ${FUNCNAME} "${@}"

	addwrite "${NPM_STORE_DIR}"
	mkdir -p "${NPM_STORE_DIR}"

	default_src_unpack
}

# @FUNCTION: npm-secaudit_src_prepare
# @DESCRIPTION:
# Fetches dependencies
npm-secaudit_src_prepare() {
        debug-print-function ${FUNCNAME} "${@}"

	default_src_prepare

	npm-secaudit-fetch-deps
}

# @FUNCTION: npm-secaudit-build
# @DESCRIPTION:
# Builds an electron app
npm-secaudit-build() {
	npm run build || die
}

# @FUNCTION: npm-secaudit_src_compile
# @DESCRIPTION:
# Builds an electron app
npm-secaudit_src_compile() {
        debug-print-function ${FUNCNAME} "${@}"

	npm-secaudit-build
}

# @FUNCTION: npm-secaudit-register
# @DESCRIPTION:
# Adds the package to the electron database
# This function MUST be called in post_inst.
npm-secaudit-register() {
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
}

# @FUNCTION: npm-secaudit-install
# @DESCRIPTION:
# Installs a desktop app.
npm-secaudit-install() {
	local rel_src_path="$1"

	shopt -s dotglob # copy hidden files

	mkdir -p "${D}/usr/$(get_libdir)/node/${PN}/${SLOT}"
	cp -a ${rel_src_path} "${D}/usr/$(get_libdir)/node/${PN}/${SLOT}"
}

# @FUNCTION: npm-secaudit_post_install
# @DESCRIPTION:
# Automatically registers an npm package.
# Set NPM_AUDIT_REG_PATH global to relative path to
# scan for vulnerabilities containing node_modules.
# scan for vulnerabilities.
npm-secaudit_post_install() {
	npm-secaudit-register "${NPM_AUDIT_REG_PATH}"
}

# @FUNCTION: npm-secaudit_pkg_postrm
# @DESCRIPTION:
# Post-removal hook for Electron apps. Removes information required for security checks.
npm-secaudit_pkg_postrm() {
        debug-print-function ${FUNCNAME} "${@}"

	sed -i -e "s|${CATEGORY}/${PN}:${SLOT}\t.*||g" "${NPM_PACKAGE_DB}"
}
