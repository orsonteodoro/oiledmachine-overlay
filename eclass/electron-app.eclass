# Copyright 1999-2019 Gentoo Foundation
# Copyright 2019 Orson Teodoro
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: electron-app.eclass
# @MAINTAINER:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @AUTHOR:
# Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 4 5
# @BLURB: Eclass for Electron packages
# @DESCRIPTION:
# The electron-app eclass defines phase functions and utility functions for
# Electron app packages. It depends on the app-portage/npm-secaudit package to
# maintain a secure environment.

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

inherit desktop

NPM_PACKAGE_DB="/var/lib/portage/npm-packages"

EXPORT_FUNCTIONS pkg_postrm

# @FUNCTION: electron-app-build
# @DESCRIPTION:
# Builds an electron app with security checks
electron-app-build() {
	local path="$1"

	pushd "${1}"
	npm install || die
	if [[ ! -e package-lock.js ]] ; then
		einfo "Running \`npm i --package-lock\`"
		npm i --package-lock # prereq for command below
	fi
	einfo "Running \`npm audit fix --force\`"
	npm audit fix --force || die
	einfo "Auditing security done"
	npm install electron || die
	popd
}

# @FUNCTION: electron-app-register
# @DESCRIPTION:
# Adds the package to the electron database
# This function MUST be called in pkg_postinst.
electron-app-register() {
	local rel_path=${1:-""}
	local check_path="/usr/$(get_libdir)/node/${PN}/${SLOT}/${rel_path}"
	# format:
	# ${CATEGORY}/${P}	path_to_package
	addwrite "${NPM_PACKAGE_DB}"

	# remove existing entry
	touch "${NPM_PACKAGE_DB}"
	sed -i -e "s|${CATEGORY}/${PN}:${SLOT}\t.*||g" "${NPM_PACKAGE_DB}"

	echo -e "${CATEGORY}/${PN}:${SLOT}\t${check_path}" >> "${NPM_PACKAGE_DB}"
}

# @FUNCTION: electron-desktop-app-install
# @DESCRIPTION:
# Installs a desktop app.
electron-desktop-app-install() {
	local rel_src_path="$1"
	local rel_main_app_path="$2"
	local rel_icon_path="$3"
	local pkg_name="$4"
	local category="$5"

	mkdir -p "${D}/usr/$(get_libdir)/node/${PN}/${SLOT}"
	cp -a ${rel_src_path} "${D}/usr/$(get_libdir)/node/${PN}/${SLOT}"

	#create wrapper
	mkdir -p "${D}/usr/bin"
	echo "#!/bin/bash" > "${D}/usr/bin/${PN}"
	echo "/usr/bin/electron /usr/$(get_libdir)/node/${PN}/${SLOT}/${rel_main_app_path}" >> "${D}/usr/bin/${PN}"
	chmod +x "${D}"/usr/bin/${PN}

	newicon "${rel_icon_path}" "${PN}.png"
	make_desktop_entry ${PN} "${pkg_name}" ${PN} "${category}"
}

# @FUNCTION: electron-app_pkg_postrm
# @DESCRIPTION:
# Post-removal hook for Electron apps. Removes information required for security checks.
electron-app_pkg_postrm() {
	sed -i -e "s|${CATEGORY}/${PN}:${SLOT}\t.*||g" "${NPM_PACKAGE_DB}"
}
