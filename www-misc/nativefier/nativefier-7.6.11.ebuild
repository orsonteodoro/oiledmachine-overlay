# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RDEPEND="${RDEPEND}
	 dev-util/electron"

DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"

inherit eutils desktop npm-secaudit

DESCRIPTION="Make any web page a desktop application"
HOMEPAGE="https://github.com/jiahaog/nativefier"
SRC_URI="https://github.com/jiahaog/nativefier/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="userpriv" # workaround for /usr/portage/distfiles/npm/_cacache access

S="${WORKDIR}/${PN}-${PV}"

src_prepare() {
	npm install electron-context-menu
	npm install electron-squirrel-startup
	npm install electron-window-state
	npm install wurl

	npm-secaudit_src_prepare

	# fix breakage caused by npm audix fix --force
	npm uninstall gulp
	npm install gulp@"<4.0.0"
}

src_install() {
	npm-secaudit-install "*"

	# create wrapper
	mkdir -p "${D}/usr/bin"
	echo "#!/bin/bash" > "${D}/usr/bin/${PN}"
	echo "node /usr/$(get_libdir)/node/${PN}/${SLOT}/lib/cli.js \$@" >> "${D}/usr/bin/${PN}"
	chmod +x "${D}"/usr/bin/${PN}
}
