# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RDEPEND="${RDEPEND}
	 >=dev-util/electron-1.7.13"

DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"

inherit eutils desktop electron-app

MY_PN="SnippetStore"
DESCRIPTION="A snippet management app for developers"
HOMEPAGE="https://zerox-dg.github.io/SnippetStoreWeb/"
SRC_URI="https://github.com/ZeroX-DG/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}/${MY_PN}-${PV}"

src_compile() {
	export PATH="${S}/node_modules/.bin:${PATH}"
	npm run build || die

	rm -rf dist/ # same as `rimraf dist/` in package.json

	# This is required for compleness and for the program to run properly.
	# We deviate since we are not building for other distros.
	electron-builder -l tar.xz || die
}

src_install() {
	electron-desktop-app-install "*" "resources/icon/icon512.png" "${MY_PN}" "Development" "/usr/$(get_libdir)/node/${PN}/${SLOT}/dist/linux-unpacked/snippetstore"
}
