# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop electron-app eutils

DESCRIPTION="Elegant Facebook Messenger desktop app"
HOMEPAGE="https://github.com/sindresorhus/caprine"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"
BDEPEND+=" >=net-libs/nodejs-14[npm]" # based on their CI
ELECTRON_APP_ELECTRON_V="10.1.5"
ELECTRON_APP_TYPESCRIPT_V="4.1.2"
ELECTRON_APP_USED_AS_WEB_BROWSER_OR_SOCIAL_MEDIA_APP="1"
SRC_URI=\
"https://github.com/sindresorhus/caprine/archive/v${PV}.tar.gz \
	-> ${PN}-${PV}.tar.gz"
RESTRICT="mirror"
NODE_VERSION=14

pkg_setup() {
	electron-app_pkg_setup
	if has_version 'net-libs/nodejs:14' ; then
		einfo "Using nodejs:14"
		export NODE_VERSION="14"
	elif has_version 'net-libs/nodejs:15' ; then
		einfo "Using nodejs:15"
		export NODE_VERSION="15"
	elif has_version 'net-libs/nodejs:0' ; then
		einfo "Using Gentoo's nodejs package.  Not supported but let's try."
	fi
	local node_v=$(node --version | sed -e "s|v||")
	if ver_test ${node_v} -lt 14 ; then
		die "Switch your node version to >=14.  Found ${node_v} instead."
	else
		export NODE_VERSION=$(echo ${node_v} | cut -f 1 -d ".")
		einfo "Using nodejs-${NODE_VERSION}"
	fi
	NODE_MAJOR=$(grep -r -e "NODE_MAJOR_VERSION" \
		/usr/include/node/node_version.h | head -n 1 | cut -f 3 -d " ")
	NODE_MINOR=$(grep -r -e "NODE_MINOR_VERSION" \
		/usr/include/node/node_version.h | head -n 1 | cut -f 3 -d " ")
	NODE_PATCH=$(grep -r -e "NODE_PATCH_VERSION" \
		/usr/include/node/node_version.h | head -n 1 | cut -f 3 -d " ")
	if ver_test ${NODE_MAJOR}.${NODE_MINOR} -ne $(ver_cut 1-2 ${node_v}) ; then
		die \
"Inconsistency between node header and active executable version.\n\
Switch your headers via \`eselect nodejs\`"
	else
		einfo \
"Node.js header version: ${NODE_MAJOR}.${NODE_MINOR}.${NODE_PATCH}\n\
Node.js exe version: ${node_v}"
	fi
}

electron-app_src_compile() {
	cd "${S}" || die
	export PATH="${S}/node_modules/.bin:${PATH}"
	electron-builder install-app-deps || die
	tsc || die
	electron-builder -l dir || die
}

src_install() {
	export ELECTRON_APP_INSTALL_PATH="/opt/${PN}"
	electron-app_desktop_install \
		"dist/linux-unpacked/*" \
		"static/Icon.png" \
		"${PN^}" "Network" \
	"${ELECTRON_APP_INSTALL_PATH}/${PN} \"\$@\""
	fperms 755 "${ELECTRON_APP_INSTALL_PATH}/${PN}"
}

pkg_postinst() {
	electron-app_pkg_postinst
	einfo \
"If you see Config schema violation: vibrancy should be string; vibrancy \
should be equal to one of the allowed values"
	einfo "You may need to run \`rm -rf ~/.config/Caprine\`"
}
