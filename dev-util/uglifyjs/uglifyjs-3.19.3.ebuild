# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="UglifyJS"
NODEJS_PV="0.8"
NPM_BUILD_SCRIPT="none"
NPM_INSTALL_PATH="/opt/${PN}"
NPM_EXE_LIST=(
	"${NPM_INSTALL_PATH}/bin/uglifyjs"
	"${NPM_INSTALL_PATH}/node_modules/.bin/acorn"
	"${NPM_INSTALL_PATH}/node_modules/.bin/semver"
)

inherit npm

SRC_URI="
https://github.com/mishoo/UglifyJS/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="JavaScript parser / mangler / compressor / beautifier toolkit"
HOMEPAGE="https://github.com/mishoo/UglifyJS"
LICENSE="BSD-2"
KEYWORDS="~amd64"
RESTRICT="mirror"
SLOT="0"
IUSE="
test
ebuild_revision_2
"
RDEPEND+="
	>=net-libs/nodejs-${NODEJS_PV}
"
BDEPEND+="
	>=net-libs/nodejs-${NODEJS_PV}
"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
