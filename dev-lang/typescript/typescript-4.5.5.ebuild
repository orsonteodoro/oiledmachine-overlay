# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_SECAUDIT_AT_TYPES_NODE_PV="16.11.6"
# Same as package-lock but uses latest always latest.
# See https://www.npmjs.com/package/@types/node
NODE_VERSION="${NPM_SECAUDIT_AT_TYPES_NODE_PV%%.*}" # Using nodejs muxer variable name.

NPM_SECAUDIT_TYPESCRIPT_PV="${PV}"
inherit npm-secaudit npm-utils

DESCRIPTION="TypeScript is a superset of JavaScript that compiles to clean \
JavaScript output"
HOMEPAGE="https://www.typescriptlang.org/"
LICENSE="
	( Apache-2.0 all-rights-reserved )
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
KEYWORDS="~amd64 ~amd64-linux ~x64-macos ~arm ~arm64 ~ppc ~ppc64 ~x86"
SLOT="$(ver_cut 1-2 ${PV})/${PV}"
RDEPEND+="
	>=net-libs/nodejs-${NODE_VERSION}:${NODE_VERSION}
	app-eselect/eselect-typescript
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=net-libs/nodejs-${NODE_VERSION}[npm]
	media-libs/vips
"
MY_PN="TypeScript"
FN_SRC="v${PV}.tar.gz"
FN_DEST="${PN}-${PV}.tar.gz"
SRC_URI="
https://github.com/Microsoft/${MY_PN}/archive/v${PV}.tar.gz
	-> ${FN_DEST}
"
S="${WORKDIR}/${MY_PN}-${PV}"
if [[ "${UPDATE_MANIFEST}" != "1" ]] ; then
	RESTRICT="fetch mirror"
fi
GITHUB_HOMEPAGE="https://github.com/microsoft/TypeScript"

pkg_nofetch() {
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	local homepage="${GITHUB_HOMEPAGE}/releases"
einfo
einfo "This package asserts all rights reserved in the source code and the"
einfo "third party modules. Please read:"
einfo
einfo "  https://gitweb.gentoo.org/repo/gentoo.git/tree/licenses/all-rights-reserved"
einfo
einfo "If you agree, please download"
einfo
einfo "  ${FN_SRC}"
einfo
einfo "from ${homepage} and rename it to ${FN_DEST} place it in ${distdir}"
einfo "or do \`wget -O ${distdir}/${FN_DEST} ${GITHUB_HOMEPAGE}/archive/${FN_SRC}\`"
einfo
}

pkg_setup() {
	npm-secaudit_pkg_setup
	local node_pv=$(/usr/bin/node --version \
		| sed -e "s|v||g" \
		| cut -f 1 -d ".")
        if (( ${node_pv} < ${NODE_VERSION} )) ; then
		eerror
		eerror "node_pv must be >=${NODE_VERSION}"
		eerror "Switch Node.js to >=${NODE_VERSION}"
		eerror
		die
        fi
	einfo "Node.js is ${node_pv}"
}

npm-secaudit_src_postprepare() {
	npm_package_lock_update ./
}

npm-secaudit_src_postcompile() {
	npm uninstall gulp -D
}

src_install() {
	export NPM_SECAUDIT_INSTALL_PATH="/opt/${PN}/${SLOT}"
	npm-secaudit_install "*"
	fperms 0755 "${NPM_SECAUDIT_INSTALL_PATH}/bin/tsc" \
		"${NPM_SECAUDIT_INSTALL_PATH}/bin/tsserver"
}

pkg_postinst() {
	npm-secaudit_pkg_postinst
	if eselect typescript list | grep ${SLOT} >/dev/null ; then
		eselect typescript set ${SLOT}
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
