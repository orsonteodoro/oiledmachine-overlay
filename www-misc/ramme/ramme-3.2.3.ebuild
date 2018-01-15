# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="Unofficial Instagram Desktop App"
HOMEPAGE="https://github.com/terkelg/ramme"
SRC_URI="https://github.com/terkelg/ramme/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${PN}-${PV}"

COMMON_DEPEND=">=dev-util/electron-1.6.10"

APP_DEPEND="  ${COMMON_DEPEND}
	      dev-nodejs/electron-config:1.0.0
	      dev-nodejs/electron-debug:1.1.0
	      dev-nodejs/electron-is-dev:0.1.2
	      dev-nodejs/element-ready:1.0.0
	      dev-nodejs/first-run:1.2.0
	      dev-nodejs/insight:0.8.4
	      dev-nodejs/ms:2.0.0
	      dev-nodejs/os:0.1.1"
ROOT_DEPEND=" ${COMMON_DEPEND}
	      dev-nodejs/babel-preset-babili:0.1.2
	      dev-nodejs/babel-preset-es2015:6.24.1
	      dev-nodejs/babili:0.1.2
	      dev-nodejs/del:2.2.2
	      dev-nodejs/electron-builder:18.0.1
	      dev-nodejs/gulp:4.0.0
	      dev-nodejs/gulp-autoprefixer:4.0.0
	      dev-nodejs/gulp-babel:6.1.2
	      dev-nodejs/gulp-image:2.9.0
	      dev-nodejs/gulp-sass:3.1.0
	      dev-nodejs/standard:10.0.2"

RDEPEND="${RDEPEND}
	 ${APP_DEPEND}
	 ${ROOT_DEPEND}"

DEPEND="${RDEPEND}"

ELECTRON_SLOT="1.6"

pkg_setup() {
	ewarn "This ebuild is currently going under development.  It is not ready yet and will not work."
}

dosym_app() {
	local version="${1#*:}"
	local name="${1%:*}"
	dosym "${EROOT}usr/$(get_libdir)/node/${name}/${version}" "/usr/$(get_libdir)/node/${PN}/${SLOT}/app/src/node_modules/${name}"
}

dosym_root() {
	local version="${1#*:}"
	local name="${1%:*}"
	dosym "${EROOT}usr/$(get_libdir)/node/${name}/${version}" "/usr/$(get_libdir)/node/${PN}/${SLOT}/node_modules/${name}"
}

src_compile() {
	find . -name "*.sassc"
	die
}

src_install() {
	mkdir -p "${D}/usr/$(get_libdir)/node/${PN}/${SLOT}"
	cp -a * "${D}/usr/$(get_libdir)/node/${PN}/${SLOT}"

	#link the dependencies
	dosym_app "electron-config:1.0.0"
	dosym_app "electron-debug:1.1.0"
	dosym_app "electron-is-dev:0.1.2"
	dosym_app "element-ready:1.0.0"
	dosym_app "first-run:1.2.0"
	dosym_app "insight:0.8.4"
	dosym_app "ms:2.0.0"
	dosym_app "os:0.1.1"
	dosym_app "electron:1.6.10"

	dosym_root "babel-preset-babili:0.1.2"
	dosym_root "babel-preset-es2015:6.24.1"
	dosym_root "babili:0.1.2"
	dosym_root "del:2.2.2"
	dosym_root "electron:1.6.10"
	dosym_root "electron-builder:18.0.1"
	dosym_root "gulp:4.0.0"
	dosym_root "gulp-autoprefixer:4.0.0"
	dosym_root "gulp-babel:6.1.2"
	dosym_root "gulp-image:2.9.0"
	dosym_root "gulp-sass:3.1.0"
	dosym_root "standard:10.0.2"

	#create wrapper
	mkdir -p "${D}/usr/bin"
	echo "#!/bin/bash" > "${D}/usr/bin/ramme"
	echo "/usr/$(get_libdir)/electron-${ELECTRON_SLOT}/electron /usr/$(get_libdir)/node/${PN}/${SLOT}/app/src/main" >> "${D}/usr/bin/ramme"
	chmod +x "${D}"/usr/bin/ramme
}
