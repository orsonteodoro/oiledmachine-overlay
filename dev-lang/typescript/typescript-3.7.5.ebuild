# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="TypeScript is a superset of JavaScript that compiles to clean JavaScript output"
HOMEPAGE="https://www.typescriptlang.org/"
LICENSE="Apache-2.0 CC-BY-4.0 MIT Unicode-DFS W3C W3C-CLA"
# Apache-2.0 is the main
# Rest of the licenses are third party licenses
KEYWORDS="~amd64 ~amd64-linux ~x64-macos ~arm ~arm64 ~ppc ~ppc64 ~x86"
SLOT="$(ver_cut 1-2 ${PV})"
RDEPEND="${RDEPEND}
	 app-eselect/eselect-typescript"
DEPEND="${RDEPEND}
	media-libs/vips
        net-libs/nodejs[npm]"
inherit eutils npm-secaudit npm-utils
MY_PN="TypeScript"
SRC_URI=\
"https://github.com/Microsoft/${MY_PN}/archive/v${PV}.tar.gz \
	-> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

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
