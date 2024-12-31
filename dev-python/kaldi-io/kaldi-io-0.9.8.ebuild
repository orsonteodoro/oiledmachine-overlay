# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
MY_PN="kaldi-io-for-python"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${PV}"
SRC_URI="
https://github.com/KarelVesely84/kaldi-io-for-python/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Python functions for reading kaldi data formats which is useful for rapid prototyping"
HOMEPAGE="
	https://github.com/KarelVesely84/kaldi-io-for-python
	https://pypi.org/project/kaldi-io
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror test" # untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
RDEPEND+="
	>=dev-python/numpy-1.15.3[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "README.md" )

python_install() {
	distutils-r1_python_install
	local path=$(python_get_sitedir)
	rm -rf "${ED}/${path}/tests" || die
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
