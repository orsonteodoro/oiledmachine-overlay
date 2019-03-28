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

src_unpack() {
	default_src_unpack

	npm-secaudit_src_prepare_default

	cd "${S}"

	S="${WORKDIR}/${PN}-${PV}/app" \
	npm-secaudit_fetch_deps

	S="${WORKDIR}/${PN}-${PV}" \
	npm-secaudit_fetch_deps

	cd "${S}"

	# fix breakage caused by npm audix fix --force
	npm uninstall gulp
	npm install gulp@"<4.0.0" --save-dev || die

	npm-secaudit_src_compile_default

	# for stopping version lock warning from audit.  production packages installed only.
	npm uninstall gulp -D

	npm-secaudit_src_preinst_default
}

src_install() {
	npm-secaudit_install "*"

	# create wrapper
	mkdir -p "${D}/usr/bin"
	echo "#!/bin/bash" > "${D}/usr/bin/${PN}"
	echo "node /usr/$(get_libdir)/node/${PN}/${SLOT}/lib/cli.js \$@" >> "${D}/usr/bin/${PN}"
	chmod +x "${D}"/usr/bin/${PN}
}
