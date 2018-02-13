# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A JavaScript code analyzer for deep, cross-editor language support"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
SRC_URI="https://github.com/ternjs/tern/archive/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
SLOT="${PV}"

RDEPEND="net-libs/nodejs[npm]"
DEPEND="${RDEPEND}"

DOCS=( CONTRIBUTING.md AUTHORS README.md )

src_unpack() {
	default
}

src_compile() {
	cd "${S}"
	npm install
}

src_install() {
	DEST="${D}/usr/$(get_libdir)/node/${PN}/${SLOT}"
	mkdir -p "${DEST}"
	cp -a  bin defs emacs lib node_modules package.json plugin "${DEST}"
	use doc && dodoc -r doc/* index.html ${DOCS}
}
