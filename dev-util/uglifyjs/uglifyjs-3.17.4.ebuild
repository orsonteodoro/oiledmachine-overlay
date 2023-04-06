# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="UglifyJS"
NODEJS_PV="0.8"
YARN_BUILD_SCRIPT="none"
YARN_INSTALL_PATH="/opt/${PN}"
YARN_EXE_LIST="
${YARN_INSTALL_PATH}/bin/uglifyjs
${YARN_INSTALL_PATH}/node_modules/.bin/acorn
${YARN_INSTALL_PATH}/node_modules/.bin/semver
"
inherit yarn

DESCRIPTION="JavaScript parser / mangler / compressor / beautifier toolkit"
HOMEPAGE="https://github.com/mishoo/UglifyJS"
LICENSE="BSD-2"
KEYWORDS="~amd64"
SLOT="0"
IUSE=" test"
RDEPEND+="
	>=net-libs/nodejs-${NODEJS_PV}
"
BDEPEND+="
	>=net-libs/nodejs-${NODEJS_PV}
"
# Initially generated from:
#   grep "resolved" /var/tmp/portage/dev-util/uglifyjs-3.17.4/work/UglifyJS-3.17.4/yarn.lock | cut -f 2 -d '"' | cut -f 1 -d "#" | sort | uniq
# For the generator script, see the typescript/transform-uris.sh ebuild-package.
# UPDATER_START_YARN_EXTERNAL_URIS
YARN_EXTERNAL_URIS="
https://registry.yarnpkg.com/acorn/-/acorn-8.7.1.tgz -> yarnpkg-acorn-8.7.1.tgz
https://registry.yarnpkg.com/semver/-/semver-6.3.0.tgz -> yarnpkg-semver-6.3.0.tgz
"
# UPDATER_END_YARN_EXTERNAL_URIS
SRC_URI="
${YARN_EXTERNAL_URIS}
https://github.com/mishoo/UglifyJS/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
RESTRICT="mirror"
S="${WORKDIR}/${MY_PN}-${PV}"

src_unpack() {
	if [[ "${UPDATE_YARN_LOCK}" == "1" ]] ; then
		unpack ${P}.tar.gz
		cd "${S}" || die
		rm package-lock.json
		rm yarn.lock
		npm i || die
		npm audit fix || die
		yarn import || die
	else
		yarn_src_unpack
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
