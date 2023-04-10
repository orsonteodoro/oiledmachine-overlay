# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

YARN_INSTALL_PATH="/opt/${PN}/${PV}"
MY_PN="TypeScript"
NPM_SECAUDIT_AT_TYPES_NODE_PV="16.11.6"
# Same as package-lock but uses latest always latest.
# See https://www.npmjs.com/package/@types/node
NODE_VERSION="${NPM_SECAUDIT_AT_TYPES_NODE_PV%%.*}" # Using nodejs muxer variable name.
YARN_EXE_LIST="
"${YARN_INSTALL_PATH}/bin/tsc"
"${YARN_INSTALL_PATH}/bin/tsserver"
"

NPM_SECAUDIT_TYPESCRIPT_PV="${PV}"
inherit yarn

DESCRIPTION="TypeScript is a superset of JavaScript that compiles to clean \
JavaScript output"
HOMEPAGE="
https://www.typescriptlang.org/
https://github.com/microsoft/TypeScript
"
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
IUSE+="
test r1
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
	dev-util/synp
	media-libs/vips
"
# Initially generated from:
#   grep "resolved" /var/tmp/portage/dev-lang/typescript-4.5.5/work/TypeScript-4.5.5/yarn.lock | cut -f 2 -d '"' | cut -f 1 -d "#" | sort | uniq
# UPDATER_START_YARN_EXTERNAL_URIS
YARN_EXTERNAL_URIS="

"
# UPDATER_END_YARN_EXTERNAL_URIS
SRC_URI="
${YARN_EXTERNAL_URIS}
https://github.com/microsoft/TypeScript/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="mirror"

__npm_run() {
	local cmd=( "${@}" )
	local tries

	tries=0
	while (( ${tries} < 5 )) ; do
einfo "Tries:\t${tries}"
einfo "Running:\t${cmd[@]}"
		"${cmd[@]}" || die
		if ! grep -q -r -e "ERR_SOCKET_TIMEOUT" "${HOME}/.npm/_logs" ; then
			break
		fi
		rm -rf "${HOME}/.npm/_logs"
		tries=$((${tries} + 1))
	done
	[[ -f package-lock.json ]] || die "Missing package-lock.json for audit fix"
}

yarn_update_lock_install_pre() {
	__npm_run npm i gulp-cli -D
}

pkg_postinst() {
	if eselect typescript list | grep ${PV} >/dev/null ; then
		eselect typescript set ${PV}
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
