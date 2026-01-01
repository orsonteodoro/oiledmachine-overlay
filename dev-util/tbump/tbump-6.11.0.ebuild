# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="poetry"
EPYTEST_DESELECT=(
	"tbump/test/test_api.py"
	"tbump/test/test_cli.py"
	"tbump/test/test_file_bumper.py::test_file_bumper_preserve_endings"
	"tbump/test/test_file_bumper.py::test_file_bumper_simple"
	"tbump/test/test_git_bumper.py"
	"tbump/test/test_hooks.py"
	"tbump/test/test_init.py"
)
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1

if [[ "${PV}" == *"9999"* ]]; then
	EGIT_REPO_URI="https://github.com/your-tools/tbump.git"
	inherit git-r3
else
	KEYWORDS="~amd64"
	inherit pypi
fi

DESCRIPTION="tbump helps you bump the version of your project easily"
HOMEPAGE="https://github.com/your-tools/tbump/"
LICENSE="BSD"
SLOT="0"
IUSE="lint test"
RDEPEND="
	>=dev-python/cli-ui-0.10.3[${PYTHON_USEDEP}]
	>=dev-python/docopt-0.6.2[${PYTHON_USEDEP}]
	>=dev-python/schema-0.7.1[${PYTHON_USEDEP}]
	>=dev-python/tomlkit-0.11[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/poetry-core-1.0.0
	test? (
		>=dev-python/coverage-6.0_beta1[${PYTHON_USEDEP}]
		>=dev-python/pytest-6.2.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-2.10[${PYTHON_USEDEP}]
		>=dev-python/pytest-mock-2.0.0[${PYTHON_USEDEP}]
	)
	lint? (
		>=dev-python/black-22.3[${PYTHON_USEDEP}]
		>=dev-python/flake8-3.9.2[${PYTHON_USEDEP}]
		>=dev-python/flake8-bugbear-21.4.3[${PYTHON_USEDEP}]
		>=dev-python/flake8-comprehensions-3.4.0[${PYTHON_USEDEP}]
		>=dev-python/isort-5.7.0[${PYTHON_USEDEP}]
		>=dev-python/mypy-0.960[${PYTHON_USEDEP}]
		>=dev-python/pep8-naming-0.11.1[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests "pytest"
