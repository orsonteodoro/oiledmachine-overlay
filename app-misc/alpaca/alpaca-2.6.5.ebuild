# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

PYTHON_COMPAT=( "python3_"{10..12} ) # Upstream tests with python3.11

inherit python-single-r1 meson

KEYWORDS="~amd64"
S="${WORKDIR}/${PN^}-${PV}"
SRC_URI="
https://github.com/Jeffser/Alpaca/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="An Ollama client made with GTK4 and Adwaita"
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
		>=dev-python/pillow-10.3.0[${PYTHON_USEDEP}]
		>=dev-python/pypdf-4.2.0[${PYTHON_USEDEP}]
		>=dev-python/pytube-15.0.0[${PYTHON_USEDEP}]
		>=dev-python/requests-2.31.0[${PYTHON_USEDEP}]
		>=gui-libs/gtksourceview-5[introspection]
	')
	app-misc/ollama
	dev-libs/appstream
	dev-libs/gobject-introspection[${PYTHON_SINGLE_USEDEP}]
	gui-libs/gtk[wayland?,X?]
	gui-libs/libadwaita[introspection]
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
