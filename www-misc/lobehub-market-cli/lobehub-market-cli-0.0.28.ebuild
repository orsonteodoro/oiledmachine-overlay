# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NODE_SLOT="22"
NPM_TARBALL="market-cli-${PV}.tgz"

KEYWORDS="~amd64"
S="${WORKDIR}/package"
SRC_URI="
https://registry.npmjs.org/@lobehub/market-cli/-/market-cli-${PV}.tgz
"

inherit npm

DESCRIPTION="LobeHub Marketplace CLI"
HOMEPAGE="
	https://www.npmjs.com/package/@lobehub/market-cli
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
ebuild_revision_2
"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	net-libs/nodejs:${NODE_SLOT}
"

pkg_setup() {
	npm_pkg_setup
}

src_unpack() {
	unpack ${A}
	npm_src_unpack
}

src_compile() {
	npm_src_compile
}

src_install() {
	cat "${FILESDIR}/lhm" > "${T}/lhm"
	sed -i -e "s|@NODE_SLOT@|${NODE_SLOT}|g" "${T}/lhm" || die
	insinto "/opt/${PN}"
	doins -r *
	fperms 755 "/opt/${PN}/dist/cli.js"
	exeinto "/usr/bin"
	doexe "${T}/lhm"
	dosym "/usr/bin/lhm" "/usr/bin/lobehub-market-cli"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
