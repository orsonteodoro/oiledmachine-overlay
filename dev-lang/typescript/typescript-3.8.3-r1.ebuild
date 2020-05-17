# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="TypeScript is a superset of JavaScript that compiles to clean \
JavaScript output"
HOMEPAGE="https://www.typescriptlang.org/"
LICENSE="Apache-2.0 all-rights-reserved BSD BSD-2 CC0-1.0 CC-BY-3.0 CC-BY-4.0 \
CC-BY-SA-4.0 MIT unicode W3C W3C-CLA WTFPL"
# Apache-2.0 is the main
# Rest of the licenses are third party licenses
# all-rights-reserved asserted in source and third party modules
KEYWORDS="~amd64 ~amd64-linux ~x64-macos ~arm ~arm64 ~ppc ~ppc64 ~x86"
SLOT="$(ver_cut 1-2 ${PV})"
RDEPEND="${RDEPEND}
	 app-eselect/eselect-typescript"
DEPEND="${RDEPEND}
	media-libs/vips
        net-libs/nodejs[npm]"
inherit eutils npm-secaudit npm-utils
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

npm-secaudit_src_postprepare() {
	npm_package_lock_update ./
}

npm-secaudit_src_postcompile() {
	npm uninstall gulp -D
}

src_install() {
	npm-secaudit_install "*"
}

pkg_postinst() {
	npm-secaudit_pkg_postinst
	if eselect typescript list | grep ${SLOT} >/dev/null ; then
		eselect typescript set ${SLOT}
	fi
}
