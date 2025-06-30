# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

# TODO package:
# duckduckgo-search
# kokoro
# libportaudio
# openai-whisper
# youtube-transcript-api


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
		>=dev-python/duckduckgo-search-8.0.4[${PYTHON_USEDEP}]
		>=dev-python/html2text-2025.4.15[${PYTHON_USEDEP}]
		>=dev-python/kokoro-0.9.2[${PYTHON_USEDEP}]
		>=dev-python/lxml-5.3.1[${PYTHON_USEDEP}]
		>=dev-python/markitdown-0.1.1[${PYTHON_USEDEP}]
		>=dev-python/matplotlib-3.10.0[${PYTHON_USEDEP}]
		>=dev-python/odfpy-1.4.1[${PYTHON_USEDEP}]
		>=dev-python/openai-1.84.0[${PYTHON_USEDEP}]
		>=dev-python/openai-whisper-20240930[${PYTHON_USEDEP}]
		>=dev-python/pydbus-0.6.0[${PYTHON_USEDEP}]
		>=dev-python/pyicu-2.15.2[${PYTHON_USEDEP}]
		>=dev-python/requests-2.32.3[${PYTHON_USEDEP}]
		>=dev-python/youtube-transcript-api-1.0.3[${PYTHON_USEDEP}]
		>=media-libs/opencv-4.11.0[${PYTHON_USEDEP},python]
		>=virtual/pillow-11.2.1[${PYTHON_USEDEP}]
	')
	>=app-misc/ollama-0.3.12
	>=app-text/libspelling-0.4.7
	>=media-libs/portaudio-19.07.00
	>=gui-libs/gtk-4:4[wayland?,X?]
	>=gui-libs/vte-0.78.0[introspection]
	dev-libs/appstream
	dev-libs/gobject-introspection[${PYTHON_SINGLE_USEDEP}]
	gui-libs/libadwaita[introspection]
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
