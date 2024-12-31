# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
https://github.com/explosion/ml-datasets/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="🌊 Machine learning dataset loaders for testing and example scripts"
HOMEPAGE="
	https://github.com/explosion/ml-datasets
	https://pypi.org/project/ml-datasets
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
RDEPEND+="
	>=dev-python/numpy-1.7.0[${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.10.0[${PYTHON_USEDEP}]
	>=dev-python/srsly-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/catalogue-0.2.0[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "README.md" )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
