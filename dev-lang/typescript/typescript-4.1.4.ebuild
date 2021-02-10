# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

NPM_SECAUDIT_AT_TYPES_NODE_V="14.14.25" # always latest see https://www.npmjs.com/package/@types/node
NPM_SECAUDIT_TYPESCRIPT_V="${PV}"
inherit eutils npm-secaudit npm-utils

DESCRIPTION="TypeScript is a superset of JavaScript that compiles to clean \
JavaScript output"
HOMEPAGE="https://www.typescriptlang.org/"
LICENSE="Apache-2.0 all-rights-reserved BSD BSD-2 CC0-1.0 CC-BY-3.0 CC-BY-4.0 \
CC-BY-SA-4.0 MIT unicode W3C W3C-CLA WTFPL"
# Apache-2.0 is the main
# Rest of the licenses are third party licenses
# all-rights-reserved asserted in source and third party modules
KEYWORDS="~amd64 ~amd64-linux ~x64-macos ~arm ~arm64 ~ppc ~ppc64 ~x86"
SLOT="$(ver_cut 1-2 ${PV})/${PV}"
MIN_NODE_VERSION=$(ver_cut 1 ${NPM_SECAUDIT_AT_TYPES_NODE_V})
CDEPEND=" >=net-libs/nodejs-${MIN_NODE_VERSION}[npm]"
RDEPEND+=" ${CDEPEND}
	 app-eselect/eselect-typescript"
DEPEND+=" ${CDEPEND}
	media-libs/vips"
BDEPEND+=" ${CDEPEND}"
MY_PN="TypeScript"
FN_SRC="v${PV}.tar.gz"
FN_DEST="${PN}-${PV}.tar.gz"
SRC_URI=\
"https://github.com/Microsoft/${MY_PN}/archive/v${PV}.tar.gz \
	-> ${FN_DEST}"
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="fetch mirror"
GITHUB_HOMEPAGE="https://github.com/microsoft/TypeScript"

pkg_nofetch() {
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	local homepage="${GITHUB_HOMEPAGE}/releases"
	einfo \
"This package asserts all rights reserved in the source code and the\n\
third party modules. Please read:\n\
  https://gitweb.gentoo.org/repo/gentoo.git/tree/licenses/all-rights-reserved\n\
\n\
If you agree, please download\n\
  - ${FN_SRC}\n\
from ${homepage} and rename it to ${FN_DEST} place it in ${distdir}\n\
or do \`wget -O ${distdir}/${FN_DEST} ${GITHUB_HOMEPAGE}/archive/${FN_SRC}\`"
}

pkg_setup() {
	npm-secaudit_pkg_setup
	NODE_VERSION=$(/usr/bin/node --version | sed -e "s|v||g" | cut -f 1 -d ".")
        if (( ${NODE_VERSION} < ${MIN_NODE_VERSION} )) ; then
                echo "NODE_VERSION must be >=${MIN_NODE_VERSION}"
		die "Switch Node.js to >=${MIN_NODE_VERSION}"
        fi
	einfo "Node.js is ${NODE_VERSION}"
}

npm-secaudit_src_postprepare() {
	npm_package_lock_update ./
}

npm-secaudit_src_postcompile() {
	npm uninstall gulp -D

	# todo update
	# playwright is 0.12.1 and only used for testing
	# Firefox 74.0b10
	# Chromium 83.0.4090.0
	# WebKit 13.0.4
	npm uninstall playwright -D # remove possibly rapidly vulnerable list above
}

src_install() {
	export NPM_SECAUDIT_INSTALL_PATH="/usr/$(get_libdir)/node/${PN}/${SLOT}"
	npm-secaudit_install "*"
	fperms 755 "${NPM_SECAUDIT_INSTALL_PATH}/bin/tsc" \
		"${NPM_SECAUDIT_INSTALL_PATH}/bin/tsserver"
}

pkg_postinst() {
	npm-secaudit_pkg_postinst
	if eselect typescript list | grep ${SLOT} >/dev/null ; then
		eselect typescript set ${SLOT}
	fi
}
