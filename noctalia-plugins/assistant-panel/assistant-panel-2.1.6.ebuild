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
	https://noctalia.dev/plugins/assistant-panel
	https://github.com/noctalia-dev/noctalia-plugins/tree/main/assistant-panel
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+="
ollama
ebuild_revision_2
"
RDEPEND+="
	>=gui-apps/noctalia-shell-4.1.2:0/4
	net-misc/curl
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
	doins -r *
	einstalldocs
	exeinto "/opt/noctalia-plugins/bin"
	doexe "${FILESDIR}/install-assistant-panel"
}

pkg_postinst() {
einfo
einfo "To install ${PN} for the current user, run"
einfo "/opt/noctalia-plugins/bin/install-assistant-panel"
einfo
einfo "Set the following in the plugin settings (Right-click status bar > Settings gear icon > Plugins > Assistant Panel)"
einfo "OpenAI Base URL:  https://api.openai.com/v1/chat/completions"
	if use ollama ; then
einfo "Ollama Base URL:  http://localhost:11434/v1"
einfo "Local Mode:  On (Right)"
	fi
einfo
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
