# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="A standalone release of DeepMind Lab's maze generator with Python bindings."
HOMEPAGE="https://github.com/deepmind/labmaze"
LICENSE="
	Apache-2.0
"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
DEPEND+="
	!=dev-python/setuptools-50.0.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.8.0[${PYTHON_USEDEP}]
	dev-python/absl-py[${PYTHON_USEDEP}]
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
"
SRC_URI="
https://github.com/deepmind/labmaze/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

src_install() {
	distutils-r1_src_install
	docinto licenses
	dodoc AUTHORS LICENSE
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
