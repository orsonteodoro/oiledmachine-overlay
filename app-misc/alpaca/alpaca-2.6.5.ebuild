# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

PYTHON_COMPAT=( "python3_"{10..12} ) # Upstream tests with python3.11

inherit python-single-r1 meson optfeature xdg

KEYWORDS="~amd64"
S="${WORKDIR}/${PN^}-${PV}"
SRC_URI="
https://github.com/Jeffser/Alpaca/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="An Ollama AI client made with GTK4 and Adwaita"
HOMEPAGE="
	https://jeffser.com/alpaca
	https://github.com/Jeffser/Alpaca
"
LICENSE="GPL-3+"
SLOT="0"
IUSE+="
X wayland
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	|| (
		X
		wayland
	)
"
RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/html2text-2024.2.26[${PYTHON_USEDEP}]
		>=virtual/pillow-10.3.0[${PYTHON_USEDEP}]
		>=dev-python/pypdf-4.2.0[${PYTHON_USEDEP}]
		>=dev-python/pytube-15.0.0[${PYTHON_USEDEP}]
		>=dev-python/requests-2.31.0[${PYTHON_USEDEP}]
	')
	>=gui-libs/gtksourceview-5[introspection]
	>=app-misc/ollama-0.3.12
	dev-libs/appstream
	dev-libs/gobject-introspection[${PYTHON_SINGLE_USEDEP}]
	gui-libs/gtk[wayland?,X?]
	gui-libs/libadwaita[introspection]
	gui-libs/vte[introspection]
	sys-apps/xdg-desktop-portal
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-build/meson-0.62.0
"

src_install() {
	default
	meson_src_install
	python_fix_shebang -f "${ED}"
	keepdir "/usr/share/${PN^}"
}

pkg_postinst() {
	xdg_pkg_postinst
einfo
einfo "To connect to Ollama:"
einfo
einfo "Preferences > Use Remote Connection To Ollama"
einfo "Server URL:  http://127.0.0.1:11434"
einfo
ewarn
ewarn "DWM users:"
ewarn
ewarn "To show the FileChooser dialog window for visual LLMs, add the following to ~/.xinitrc and restart dwm:"
ewarn
ewarn "/usr/libexec/xdg-desktop-portal -r &"
ewarn
	optfeature_header "Install a package with FileChooser support required for visual LLM support:"
	optfeature "gnome FileChooser support" "sys-apps/xdg-desktop-portal-gnome"
	optfeature "gtk FileChooser support" "sys-apps/xdg-desktop-portal-gtk"
	optfeature "kde FileChooser support" "kde-plasma/xdg-desktop-portal-kde"
	optfeature "lxqt FileChooser support" "gui-libs/xdg-desktop-portal-lxqt"
	optfeature "wlroots FileChooser support" "gui-libs/xdg-desktop-portal-wlr"
}
