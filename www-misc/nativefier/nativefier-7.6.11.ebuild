# Copyright 1999-2019 Gentoo Authors
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

S="${WORKDIR}/${PN}-${PV}"

npm-secaudit_src_prepare() {
	S="${WORKDIR}/${PN}-${PV}/app" \
	npm-secaudit_fetch_deps

	S="${WORKDIR}/${PN}-${PV}" \
	npm-secaudit_fetch_deps
}

npm-secaudit_src_postprepare() {
	# fix breakage caused by npm audix fix --force
	npm uninstall gulp
	npm install gulp@"<4.0.0" --save-dev || die
}

npm-secaudit_src_postcompile() {
	# for stopping version lock warning from audit.  production packages installed only.
	npm uninstall gulp -D
}

src_install() {
	npm-secaudit_install "*"

	# create wrapper
	mkdir -p "${D}/usr/bin"
	echo "#!/bin/bash" > "${D}/usr/bin/${PN}"
	echo "node /usr/$(get_libdir)/node/${PN}/${SLOT}/lib/cli.js \$@" >> "${D}/usr/bin/${PN}"
	chmod +x "${D}"/usr/bin/${PN}
}
