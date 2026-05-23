# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_BRANCH="main"
EGIT_COMMIT="c48ae3851c6e78d669b0ed3f1d7936163a2a7131" # Mar 29, 2026
EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
EGIT_REPO_URI="https://github.com/noctalia-dev/noctalia-plugins.git"
S="${WORKDIR}/${P}/${PN}"
inherit git-r3

DESCRIPTION="AI Chat and Translation panel"
HOMEPAGE="
	https://github.com/noctalia-dev/noctalia-plugins
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+=" ollama"
RDEPEND+="
	>=gui-apps/noctalia-shell-4.1.2:0/4
	ollama? (
		app-misc/ollama
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "README.md" )

src_unpack() {
	git-r3_fetch
	git-r3_checkout
}

src_install() {
	insinto "/opt/noctalia-plugins/${PN}"
	einstalldocs
}

pkg_postinst() {
einfo "To install per user:"
einfo "mkdir -p ~/.config/noctalia/plugins/"
einfo "cp -a /opt/noctalia-plugins/assistant-panel ~/.config/noctalia/plugins/"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
