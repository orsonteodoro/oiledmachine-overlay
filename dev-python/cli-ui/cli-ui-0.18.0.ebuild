# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="poetry"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1

if [[ "${PV}" == *"9999"* ]]; then
	EGIT_REPO_URI="https://github.com/your-tools/python-cli-ui.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	inherit pypi
fi

DESCRIPTION="Python library for better command line interfaces"
HOMEPAGE="
	https://your-tools.github.io/python-cli-ui/
	https://github.com/your-tools/python-cli-ui/
	https://pypi.org/project/cli-ui/
"
LICENSE="BSD"
SLOT="0"
IUSE="doc lint test"
RDEPEND="
	>=dev-python/colorama-0.4.1[${PYTHON_USEDEP}]
	>=dev-python/tabulate-0.9.0[${PYTHON_USEDEP}]
	>=dev-python/unidecode-1.3.6[${PYTHON_USEDEP}]
"
BDEPEND="
	doc? (
		>=dev-python/ghp-import-2.1.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-5.3.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-autobuild-2021.3.14[${PYTHON_USEDEP}]
	)
	lint? (
		>=dev-python/black-22.3[${PYTHON_USEDEP}]
		>=dev-python/flake8-6.0[${PYTHON_USEDEP}]
		>=dev-python/flake8-bugbear-22.12[${PYTHON_USEDEP}]
		>=dev-python/flake8-comprehensions-3.10.0[${PYTHON_USEDEP}]
		>=dev-python/isort-5.10.0[${PYTHON_USEDEP}]
		>=dev-python/mypy-0.991[${PYTHON_USEDEP}]
		>=dev-python/pep8-naming-0.13.1[${PYTHON_USEDEP}]
		>=dev-python/types-tabulate-0.9.0[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/pytest-7.2.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-4.0.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests "pytest"
