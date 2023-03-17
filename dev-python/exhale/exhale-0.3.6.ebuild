# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="Automatic C++ library api documentation generation: breathe \
doxygen in and exhale it out"
HOMEPAGE="https://github.com/svenevs/exhale"
LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc test"
REQUIRED_USE="
	doc? (
		python_targets_python3_9
	)
"
# 3.9 is required because jinja-2 is only 3.9 compat

# For test requirements, see https://github.com/svenevs/exhale/blob/v0.3.5/tox.ini
# For requirements, see
# https://github.com/svenevs/exhale/blob/v0.3.5/docs/requirements.txt
# https://github.com/svenevs/exhale/blob/v0.3.5/setup.cfg#L38
RDEPEND+="
	(
		<dev-python/sphinx-5[${PYTHON_USEDEP}]
		>=dev-python/sphinx-4.3[${PYTHON_USEDEP}]
	)
	>=dev-python/breathe-4.32[${PYTHON_USEDEP}]
	>=dev-python/docutils-0.12[${PYTHON_USEDEP}]
        >=dev-python/lxml-4.6.4[${PYTHON_USEDEP}]
	dev-python/beautifulsoup4[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	doc? (
		>=dev-python/sphinx_rtd_theme-1[${PYTHON_USEDEP}]
		dev-python/sphinx-issues[${PYTHON_USEDEP}]
		<dev-python/jinja-3.1[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/pytest-raises-0.10[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/flake8-colors[${PYTHON_USEDEP}]
		dev-python/flake8-docstrings[${PYTHON_USEDEP}]
		dev-python/flake8-import-order[${PYTHON_USEDEP}]
		dev-python/ipdb[${PYTHON_USEDEP}]
		dev-python/pep8-naming[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/tox[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/ipdb[${PYTHON_USEDEP}]
		dev-python/twine[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
	)
"
SRC_URI="
https://github.com/svenevs/exhale/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
PATCHES=(
	"${FILESDIR}/${PN}-0.3.6-fix-degrees_to_radians_s-fn-matching-linux.patch"
)

distutils_enable_sphinx "docs"
distutils_enable_tests "pytest"

# OILEDMACHINE-OVERLAY-META-TAGS:  orphaned
