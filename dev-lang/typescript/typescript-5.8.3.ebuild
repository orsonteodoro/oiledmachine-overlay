# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="TypeScript"
NPM_SECAUDIT_AT_TYPES_NODE_PV="22.13.4"
# Same as package-lock but uses latest always latest.
# See https://www.npmjs.com/package/@types/node
NODE_VERSION="${NPM_SECAUDIT_AT_TYPES_NODE_PV%%.*}" # Using nodejs muxer variable name.
NPM_INSTALL_PATH="/opt/${PN}/${PV}"
NPM_EXE_LIST="
"${NPM_INSTALL_PATH}/bin/tsc"
"${NPM_INSTALL_PATH}/bin/tsserver"
"
inherit npm

DESCRIPTION="TypeScript is a statically typed superset of JavaScript that \
compiles to clean JavaScript output"
HOMEPAGE="
https://www.typescriptlang.org/
https://github.com/microsoft/TypeScript
"
LICENSE="
	(
		all-rights-reserved
		Apache-2.0
	)
	CC-BY-4.0
	MIT
	Unicode-DFS-2016
	W3C-Community-Final-Specification-Agreement
	W3C-Software-and-Document-Notice-and-License-2015
"
# TODO:  Inspect downloaded dependencies
# (Apache-2.0 all-rights-reserved) - CopyrightNotice.txt
# Apache-2.0 is the main
# Rest of the licenses are third party licenses
KEYWORDS="~amd64 ~arm64"
SLOT="$(ver_cut 1-2 ${PV})/${PV}"
IUSE+="
test ebuild_revision_4
"
RDEPEND+="
	>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}
	app-eselect/eselect-typescript
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=net-libs/nodejs-${NODE_VERSION}[npm]
"
SRC_URI="
https://github.com/microsoft/TypeScript/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="mirror"

npm_update_lock_install_pre() {
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
		enpm install "@types/node@${NPM_SECAUDIT_AT_TYPES_NODE_PV}" --prefer-offline
	fi
}

npm_update_lock_install_post() {
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
		enpm install "esbuild@^0.25.0" # GHSA-67mh-4wv8-2f99
	fi
}

src_install() {
	npm_src_install

	# Move wrappers
	mv "${ED}/usr/bin/tsc" \
		"${ED}/opt/${PN}/${PV}" || die
	mv "${ED}/usr/bin/tsserver" \
		"${ED}/opt/${PN}/${PV}" || die
einfo "Removing npm-packages-offline-cache"
        rm -rf "${ED}/opt/${PN}/npm-packages-offline-cache"
}

pkg_postinst() {
	if eselect typescript list | grep ${PV} >/dev/null ; then
		eselect typescript set ${PV}
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED (test suite) 5.1.3 (20230607)
# 87465 passing (17m)

# OILEDMACHINE-OVERLAY-TEST:  PASSED (test suite) 5.1.6 (20230709)
#  87478 passing (15m)
#
#Finished do-runtests-parallel in 15m 11.9s

# OILEDMACHINE-OVERLAY-TEST:  PASSED (test suite) 5.5.2 (20240620)
#12 errors
#Error in lint in 2m 45.1s
#  [▬▬▬▬▬▬▬▬▬▬] ✔ 94798 passing (24m)
#
#
#  94798 passing (24m)

