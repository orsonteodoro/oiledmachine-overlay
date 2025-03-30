# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# mknotebooks
# pytkdocs_tweaks

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( python3_11 ) # CI only tests 3.11

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/patrick-kidger/jaxtyping/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Type annotations and runtime checking for shape and dtype of JAX/NumPy/PyTorch/etc. arrays."
HOMEPAGE="
	https://github.com/patrick-kidger/jaxtyping
	https://pypi.org/project/jaxtyping/
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc test"
DEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/numpy-1.20.0[${PYTHON_USEDEP}]
		>=dev-python/typeguard-2.13.3[${PYTHON_USEDEP}]
	')
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev-python/hatchling[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
		doc? (
			>=dev-python/jinja2-3.0.3[${PYTHON_USEDEP}]
			>=dev-python/mkdocs-1.3.0[${PYTHON_USEDEP}]
			>=dev-python/mkdocs-material-7.3.6[${PYTHON_USEDEP}]
			>=dev-python/mkdocs_include_exclude_files-0.0.1[${PYTHON_USEDEP}]
			>=dev-python/mkdocstrings-0.17.0[${PYTHON_USEDEP}]
			>=dev-python/mknotebooks-0.7.1[${PYTHON_USEDEP}]
			>=dev-python/pymdown-extensions-9.4[${PYTHON_USEDEP}]
			>=dev-python/pytkdocs_tweaks-0.0.8[${PYTHON_USEDEP}]
			>=dev-python/pygments-2.14.0[${PYTHON_USEDEP}]
		)
	')
	doc? (
		dev-python/jax[${PYTHON_SINGLE_USEDEP}]
	)
"
DOCS=( "README.md" )
PATCHES=(
)

src_unpack() {
	unpack ${A}
}

src_install() {
	distutils-r1_src_install
	docinto licenses
	dodoc LICENSE
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
