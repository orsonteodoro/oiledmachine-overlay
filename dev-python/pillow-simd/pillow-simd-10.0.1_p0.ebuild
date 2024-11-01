# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# sphinx-removed-in
# pyroma

MY_PV="${PV/_p/.post}"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..11} "pypy3" )

inherit distutils-r1 pypi

KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
S="${WORKDIR}/${PN}-${MY_PV}"
SRC_URI="
https://github.com/uploadcare/pillow-simd/archive/refs/tags/v${MY_PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="The friendly PIL fork"
HOMEPAGE="
	https://github.com/uploadcare/pillow-simd
	https://pypi.org/project/Pillow-SIMD
"
LICENSE="
	HPND
"
RESTRICT="mirror test"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc test"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-67.8[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	doc? (
		dev-python/furo[${PYTHON_USEDEP}]
		dev-python/olefile[${PYTHON_USEDEP}]
		>=dev-python/sphinx-2.4[${PYTHON_USEDEP}]
		dev-python/sphinx-copybutton[${PYTHON_USEDEP}]
		dev-python/sphinx-inline-tabs[${PYTHON_USEDEP}]
		dev-python/sphinx-removed-in[${PYTHON_USEDEP}]
		dev-python/sphinxext-opengraph[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/check-manifest[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/defusedxml[${PYTHON_USEDEP}]
		dev-python/markdown2[${PYTHON_USEDEP}]
		dev-python/olefile[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/pyroma[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)
"
DOCS=( "CHANGES.rst" "README.md" )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
