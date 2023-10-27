# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="UglifyJS"
NODEJS_PV="0.8"
NPM_BUILD_SCRIPT="none"
NPM_INSTALL_PATH="/opt/${PN}"
NPM_EXE_LIST="
${NPM_INSTALL_PATH}/bin/uglifyjs
${NPM_INSTALL_PATH}/node_modules/.bin/acorn
${NPM_INSTALL_PATH}/node_modules/.bin/semver
"
inherit npm

DESCRIPTION="JavaScript parser / mangler / compressor / beautifier toolkit"
HOMEPAGE="https://github.com/mishoo/UglifyJS"
LICENSE="BSD-2"
KEYWORDS="~amd64"
SLOT="0"
IUSE=" test r1"
RDEPEND+="
	>=net-libs/nodejs-${NODEJS_PV}
"
BDEPEND+="
	>=net-libs/nodejs-${NODEJS_PV}
"
# Initially generated from:
#   grep "resolved" /var/tmp/portage/dev-util/uglifyjs-3.17.4/work/UglifyJS-3.17.4/package-lock.json | cut -f 4 -d '"' | cut -f 1 -d "#" | sort | uniq
# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
https://registry.npmjs.org/acorn/-/acorn-8.7.1.tgz -> npmpkg-acorn-8.7.1.tgz
https://registry.npmjs.org/semver/-/semver-6.3.1.tgz -> npmpkg-semver-6.3.1.tgz
"
# UPDATER_END_NPM_EXTERNAL_URIS
SRC_URI="
${NPM_EXTERNAL_URIS}
https://github.com/mishoo/UglifyJS/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
RESTRICT="mirror"
S="${WORKDIR}/${MY_PN}-${PV}"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
