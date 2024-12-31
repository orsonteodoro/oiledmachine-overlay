# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO *DEPENDs for new ebuilds.

DISTUTILS_USE_PEP517="flit"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
https://github.com/drivendataorg/cloudpathlib/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Python pathlib-style classes for cloud storage services"
HOMEPAGE="
	https://github.com/drivendataorg/cloudpathlib
	https://pypi.org/project/cloudpathlib
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" azure dev gs s3"
RDEPEND+="
	azure? (
		>=dev-python/azure-storage-blob-12[${PYTHON_USEDEP}]
		>=dev-python/azure-storage-file-datalake-12[${PYTHON_USEDEP}]
	)
	gs? (
		dev-python/google-cloud-storage[${PYTHON_USEDEP}]
	)
	s3? (
		>=dev-python/boto3-1.34.0[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		>=dev-python/black-24.1.0[${PYTHON_USEDEP},jupyter(+)]
		>=dev-python/mkdocs-1.2.2[${PYTHON_USEDEP}]
		>=dev-python/mkdocs-material-7.2.6[${PYTHON_USEDEP}]
		>=dev-python/mkdocstrings-0.19.0[${PYTHON_USEDEP},python-legacy(+)]
		dev-python/azure-identity[${PYTHON_USEDEP}]
		dev-python/build[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/ipytest[${PYTHON_USEDEP}]
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/jupyter[${PYTHON_USEDEP}]
		dev-python/loguru[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/mike[${PYTHON_USEDEP}]
		dev-python/mkdocs-jupyter[${PYTHON_USEDEP}]
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-python/nbautoexport[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		virtual/pillow[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pydantic[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cases[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/pytest-duration-insights[${PYTHON_USEDEP}]
		dev-python/pytest-reportlog[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/python-dotenv[${PYTHON_USEDEP}]
		dev-python/rich[${PYTHON_USEDEP}]
		dev-python/shortuuid[${PYTHON_USEDEP}]
		dev-python/tabulate[${PYTHON_USEDEP}]
		dev-python/tenacity[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		dev-python/typer[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	)
"
DOCS=( "HISTORY.md" "README.md" )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
