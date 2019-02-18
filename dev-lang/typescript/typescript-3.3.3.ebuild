# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RDEPEND="${RDEPEND}"

DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"

inherit eutils npm-secaudit

DESCRIPTION="TypeScript is a superset of JavaScript that compiles to clean JavaScript output"
HOMEPAGE="https://www.typescriptlang.org/"
SRC_URI="https://registry.npmjs.org/${PN}/-/${PN}-${PV}.tgz -> ${PN}-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm ~arm64 ~ppc ~ppc64"
IUSE=""

S="${WORKDIR}/package"

src_compile() {
	npm-secaudit-build "${S}"
}

src_install() {
	npm-secaudit-install "*"

	insinto /usr/bin
	dosym /usr/$(get_libdir)/node/${PN}/${SLOT}/bin/tsc /usr/bin/tsc
	dosym /usr/$(get_libdir)/node/${PN}/${SLOT}/bin/tsserver /usr/bin/tsserver
}

pkg_postinst() {
	npm-secaudit-register
}
