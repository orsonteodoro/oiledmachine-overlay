# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RDEPEND="${RDEPEND}
	 >=dev-util/electron-2.0.10"

DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"

inherit eutils desktop npm-secaudit npm-utils

MY_PN="${PN//-cli/}"
DESCRIPTION="Beautiful images of your code — from right inside your terminal."
HOMEPAGE="https://github.com/mixn/carbon-now-cli"
SRC_URI="https://github.com/mixn/carbon-now-cli/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="clipboard"

RDEPEND="clipboard? ( x11-misc/xclip )"

S="${WORKDIR}/${PN}-${PV}"

npm-secaudit_src_compile() {
	cd "${S}"

	export PATH="${S}/node_modules/.bin:$PATH"
	# not required
}

src_install() {
	npm-secaudit_install "*"

	#create wrapper
	mkdir -p "${D}/usr/bin"
	echo "#!/bin/bash" > "${D}/usr/bin/${MY_PN}"
	echo "/usr/bin/node /usr/$(get_libdir)/node/${PN}/${SLOT}/cli.js -h \$@" >> "${D}/usr/bin/${MY_PN}"
	chmod +x "${D}"/usr/bin/${MY_PN}
}
