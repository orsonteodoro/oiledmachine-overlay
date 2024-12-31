# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )
SPHINX_PV="4.3.2"

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/svenevs/exhale/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Automatic C++ library api documentation generation: breathe \
doxygen in and exhale it out"
HOMEPAGE="https://github.com/svenevs/exhale"
LICENSE="BSD"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc test"
REQUIRED_USE="
"
# For test requirements, see https://github.com/svenevs/exhale/blob/v0.3.6/tox.ini
# For requirements, see
# https://github.com/svenevs/exhale/blob/v0.3.6/docs/requirements.txt
# https://github.com/svenevs/exhale/blob/v0.3.6/setup.cfg#L38
RDEPEND+="
	(
		>=dev-python/sphinx-${SPHINX_PV}[${PYTHON_USEDEP}]
		<dev-python/sphinx-5[${PYTHON_USEDEP}]
	)
	>=dev-python/breathe-4.33.1[${PYTHON_USEDEP}]
        >=dev-python/lxml-4.6.4[${PYTHON_USEDEP}]
	dev-python/beautifulsoup4[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-42[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/sphinx-${SPHINX_PV}[${PYTHON_USEDEP}]
		>=dev-python/sphinx-rtd-theme-1.0.0[${PYTHON_USEDEP}]
		dev-python/sphinx-issues[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/pytest-raises-0.10[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/flake8-colors[${PYTHON_USEDEP}]
		dev-python/flake8-docstrings[${PYTHON_USEDEP}]
		dev-python/flake8-import-order[${PYTHON_USEDEP}]
		dev-python/ipdb[${PYTHON_USEDEP}]
		dev-python/pep8-naming[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/tox[${PYTHON_USEDEP}]
		dev-python/twine[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-0.3.6-fix-degrees_to_radians_s-fn-matching-linux.patch"
)

distutils_enable_sphinx "docs"
distutils_enable_tests "pytest"

# OILEDMACHINE-OVERLAY-META-TAGS:  orphaned
