# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils npm-secaudit npm-utils

DESCRIPTION="Beautiful images of your code from right inside your terminal."
HOMEPAGE="https://github.com/mixn/carbon-now-cli"
LICENSE="MIT"
KEYWORDS="~amd64 ~amd64-linux ~x64-macos ~arm ~arm64 ~ppc ~ppc64 ~x86"
SLOT="0"
IUSE+=" clipboard"
RDEPEND+=" clipboard? ( x11-misc/xclip )"
BDEPEND+=" >=net-libs/nodejs-14[npm]" # package.json says 8.3 but tested working only on 14
MY_PN="${PN//-cli/}"
CHROMIUM_V="90.0.4427.0" # After update
SRC_URI=\
"https://github.com/mixn/carbon-now-cli/archive/v${PV}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"
QA_PRESTRIPPED="
	opt/carbon-now-cli/node_modules/puppeteer/.local-chromium/linux-*/chrome-linux/nacl_irt_x86_64.nexe
	opt/carbon-now-cli/node_modules/puppeteer/.local-chromium/linux-*/chrome-linux/nacl_helper_nonsfi
"

QA_WX_LOAD="
	opt/carbon-now-cli/node_modules/puppeteer/.local-chromium/linux-*/chrome-linux/nacl_irt_x86_64.nexe
"
# No strip required for exes produced by pkg (/opt/carbon-now-cli/carbon-now-cli)
RESTRICT="strip"
PKG_NODE_ARG="-t node14.4.0" # Use prebuilt instead of re-building from source to save time.
			     # Remove if newer prebuilt is available.

npm-secaudit_src_preprepare() {
	# Fix me: Pkg: Error reading from file.
	ewarn "This ebuild is a Work In Progress (WIP) and will not work."

	eapply "${FILESDIR}/carbon-now-cli-1.4.0-pkg.patch"
	eapply "${FILESDIR}/carbon-now-cli-1.4.0-pkg-browser-path.patch"
	npm-utils_download_pkg
	npm_uninstall puppeteer
	npm_install_prod puppeteer@"^8.0.0"
}

npm-secaudit_src_compile() {
	cd "${S}" || die
	export PATH="${S}/node_modules/.bin:${PATH}"
	mkdir -p dist || die
	local dn=$(basename $(find "node_modules/puppeteer/.local-chromium" -name "linux-*"))
	sed -i -e "s|linux-686378|${dn}|" \
		src/headless-visit.js || die
	local mypkgargs=(
		${PKG_NODE_ARG}
	)
	npm-utils_src_compile_pkg ${PN}
}

src_install() {
	export NPM_SECAUDIT_INSTALL_PATH="/opt/${PN}"
	npm-secaudit_install "dist/*"
	cp "${FILESDIR}/${MY_PN}" "${T}" || die

	exeinto /usr/bin
	doexe "${T}/${MY_PN}"
	insinto "${NPM_SECAUDIT_INSTALL_PATH}/node_modules/puppeteer"
	doins -r "node_modules/puppeteer/.local-chromium"
	fperms 0755 "${NPM_SECAUDIT_INSTALL_PATH}/${PN}"
	insinto "${NPM_SECAUDIT_INSTALL_PATH}/src/helpers"
	doins src/helpers/{carbon-map.json,language-map.json}
	exeinto "${NPM_SECAUDIT_INSTALL_PATH}/node_modules/opn"
	doexe node_modules/opn/xdg-open

	local dn=$(basename $(find "node_modules/puppeteer/.local-chromium" -name "linux-*"))
	fperms 0755 \
		$(find "${ED}${NPM_SECAUDIT_INSTALL_PATH}/node_modules/puppeteer/.local-chromium/${dn}/chrome-linux" \
		-name "*.so*" \
		-o -name "chrome" \
		-o -name "chrome_sandbox" \
		-o -name "chrome-wrapper" \
		-o -name "crashpad_handler" \
		-o -name "nacl_helper" \
		-o -name "nacl_helper_bootstrap" \
		-o -name "nacl_helper_nonsfi" \
		-o -name "nacl_irt_x86_64.nexe" \
		-o -name "xdg-mime" \
		-o -name "xdg-settings" \
		| sed -e "s|${ED}||g")

	npm-secaudit_store_package_jsons ./
	npm-utils_install_licenses
}

pkg_postinst() {
	npm-secaudit_pkg_postinst
	ewarn \
"The program may fail randomly.  Try again if it fails."
}
