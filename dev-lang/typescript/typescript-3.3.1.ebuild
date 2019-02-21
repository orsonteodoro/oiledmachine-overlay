# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RDEPEND="${RDEPEND}"

DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"

inherit eutils npm-secaudit

MY_PN="TypeScript"

DESCRIPTION="TypeScript is a superset of JavaScript that compiles to clean JavaScript output"
HOMEPAGE="https://www.typescriptlang.org/"
SRC_URI="https://github.com/Microsoft/TypeScript/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm ~arm64 ~ppc ~ppc64"
IUSE=""
REQUIRED_USE="debug" # required to build

S="${WORKDIR}/${MY_PN}-${PV}"

src_compile() {
	# We need 3.X for gulp-help.
	npm uninstall gulp
	npm install gulp@"<4.0.0" || die
	npm run build || die
	npm uninstall gulp

	npm prune --production
}

src_install() {
	npm-secaudit-install "*"

	insinto /usr/bin
	dosym /usr/$(get_libdir)/node/${PN}/${SLOT}/bin/tsc /usr/bin/tsc
	dosym /usr/$(get_libdir)/node/${PN}/${SLOT}/bin/tsserver /usr/bin/tsserver
}
