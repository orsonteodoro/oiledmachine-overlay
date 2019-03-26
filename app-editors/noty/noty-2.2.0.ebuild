# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

RDEPEND="${RDEPEND}
	 >=dev-util/electron-2.0.0" # workaround
#	 >=dev-util/electron-3.0.0" # real requirement

DEPEND="${RDEPEND}
        net-libs/nodejs[npm]"

inherit eutils desktop electron-app

DESCRIPTION="Autosaving sticky note with support for multiple notes without needing multiple windows. "
HOMEPAGE="https://github.com/fabiospampinato/noty"
SRC_URI="https://github.com/fabiospampinato/noty/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}/${PN}-${PV}"

src_unpack() {
	default_src_unpack

	electron-app_src_prepare_default

	sed -i -e "s|\"electron\": \"3.0.0\",|\"electron\": \"^${ELECTRON_VER}\",|" package.json || die # workaround

	mkdir -p patches || die
	echo "patches/*.patch eol=lf" >> .gitattributes || die
	patch -p1 -i "${FILESDIR}/add-prepare-patch-package-to-package-json.patch" || die
	cp -a "${FILESDIR}"/idb-connector-remove-gxcoff.patch patches || die

	einfo "Installing patch-package"
	npm install patch-package || die

	einfo "Running electron-app_fetch_deps"
	electron-app_fetch_deps

	electron-app_src_compile
	electron-app_src_preinst_default
}

electron-app_src_compile() {
	export PATH="${S}/node_modules/.bin:${PATH}"
	electron-webpack app --env.minify=false || die

	# This is required for compleness and for the program to run properly.
	electron-builder -l dir || die
}

src_install() {
	electron-app_desktop_install "*" "resources/icon/icon.png" "${PN^}" "Utility" "/usr/$(get_libdir)/node/${PN}/${SLOT}/releases/linux-unpacked/noty"
}
