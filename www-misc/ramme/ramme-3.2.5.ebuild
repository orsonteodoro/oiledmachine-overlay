# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils desktop

DESCRIPTION="Unofficial Instagram Desktop App"
HOMEPAGE="https://github.com/terkelg/ramme"
SRC_URI="https://github.com/terkelg/ramme/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="-analytics-tracking"

S="${WORKDIR}/${PN}-${PV}"

RDEPEND="${RDEPEND}
	 >=dev-util/electron-1.6.10"

DEPEND="${RDEPEND}
	dev-lang/sassc
        net-libs/nodejs[npm]"

pkg_setup() {
	export ELECTRON_SLOT=$(electron -v | sed -e "s|v||" | cut -f1-2 -d '.')
}

src_prepare() {
	default

	if ! use analytics-tracking ; then
		epatch "${FILESDIR}"/ramme-3.2.5-disable-analytics.patch
		rm "${S}"/app/src/main/analytics.js
	fi
}

src_compile() {
	cd "${S}/app"
	npm install
	einfo "Running \`npm audit fix\`"
	npm audit fix
	npm install electron

	# patch electron node_module
	cd "${S}/app/node_modules/electron"
	sed -i -e "s|module.exports = path.join(__dirname, fs.readFileSync(pathFile, 'utf-8'))|module.exports = fs.readFileSync(pathFile, 'utf-8')|" index.js || die
	echo "/usr/$(get_libdir)/electron-${ELECTRON_SLOT}/electron" > path.txt

	cd "${S}"

	sassc ./app/src/renderer/styles/app.scss > ./app/src/renderer/styles/app.css
	sassc ./app/src/renderer/styles/theme-dark/main.scss > ./app/src/renderer/styles/theme-dark/main.css
}

src_install() {
	mkdir -p "${D}/usr/$(get_libdir)/node/${PN}/${SLOT}"
	cp -a * "${D}/usr/$(get_libdir)/node/${PN}/${SLOT}"
	pushd "${D}"/usr/$(get_libdir)/node/ramme/${SLOT}/app/
	ln -s src dist
	popd

	#create wrapper
	mkdir -p "${D}/usr/bin"
	echo "#!/bin/bash" > "${D}/usr/bin/ramme"
	echo "/usr/$(get_libdir)/electron-${ELECTRON_SLOT}/electron /usr/$(get_libdir)/node/${PN}/${SLOT}/app/src/main" >> "${D}/usr/bin/ramme"
	chmod +x "${D}"/usr/bin/ramme

	newicon "media/icon.png" "ramme.png"
	make_desktop_entry ${PN} "Ramme" ${PN} "Network"
}
