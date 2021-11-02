# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop electron-app eutils

DESCRIPTION="A clean and modern encrypted journal/diary app"
HOMEPAGE="https://epicjournal.xyz/"
LICENSE="CC-BY-NC-4.0"
KEYWORDS="~amd64"
SLOT="0"
DEPEND+=" dev-db/sqlcipher"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	(
		<net-libs/nodejs-14[npm]
		>=net-libs/nodejs-12[npm]
	)
	net-libs/nodejs[npm]"
ELECTRON_APP_ELECTRON_V="3.1.13" # todo, update version
ELECTRON_APP_VUE_V="2.5.16"
MY_PN="Epic Journal"
EGIT_COMMIT="12ea7afc17c405df67ca83965747614c9f240f4d"
SRC_URI=\
"https://github.com/alangrainger/epic-journal/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

electron-app_src_preprepare() {
	eapply "${FILESDIR}/epic-journal-2.0.0_p20201215-electron-vue-871.patch"
}

electron-app_src_compile() {
	cd "${S}" || die
	export PATH="${S}/node_modules/.bin:${PATH}"
	export npm_execpath="/usr/$(get_libdir)/node_modules/npm/bin/npm-cli.js"
	#export npm_execpath="/usr/$(get_libdir)/node_modules/yarn/bin/yarn.js"
	node .electron-vue/dev-runner.js || die
	node .electron-vue/build.js || die
	electron-builder -l dir || die
}

src_install() {
	export ELECTRON_APP_INSTALL_PATH="/opt/${PN}"
	electron-app_desktop_install "build/linux-unpacked/*" \
		"build/icons/256x256.png" "${MY_PN}" \
		"Office" "${ELECTRON_APP_INSTALL_PATH}/${PN}"
	fperms 0755 "${ELECTRON_APP_INSTALL_PATH}/${PN}"
	electron-app_store_jsons_for_security_audit
	npm-utils_install_licenses
}
