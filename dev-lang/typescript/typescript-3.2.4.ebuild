# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RDEPEND="${RDEPEND}
	 app-eselect/eselect-typescript"

DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"

inherit eutils npm-secaudit versionator

MY_PN="TypeScript"

DESCRIPTION="TypeScript is a superset of JavaScript that compiles to clean JavaScript output"
HOMEPAGE="https://www.typescriptlang.org/"
SRC_URI="https://github.com/Microsoft/TypeScript/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="$(get_version_component_range 1-2 ${PV})"
KEYWORDS="~amd64 ~x86 ~arm ~arm64 ~ppc ~ppc64"
IUSE=""

S="${WORKDIR}/${MY_PN}-${PV}"

src_compile() {
	# We need 3.X for gulp-help.  The audit fix updates it to 4.X and breaks it.
	npm uninstall gulp
	npm install gulp@"<4.0.0" || die
	npm-secaudit_src_compile
	npm uninstall gulp
}

src_install() {
	npm-secaudit-install "*"
}

pkg_postinst() {
	npm-secaudit_pkg_postinst
	eselect typescript list | grep ${SLOT} >/dev/null
	if [[ "$?" == "0" ]] ; then
		eselect typescript set ${SLOT}
	fi
}
