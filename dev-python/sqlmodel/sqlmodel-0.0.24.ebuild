# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="pdm-backend"
EPYTEST_DESELECT=(
	# Uses coverage
	# TIP: Search for subprocess.run([coverage])
	"tests/test_tutorial/test_fastapi/test_app_testing/test_tutorial001_py310_tests_main.py::test_run_tests"
	"tests/test_tutorial/test_fastapi/test_app_testing/test_tutorial001_py39_tests_main.py::test_run_tests"
	"tests/test_tutorial/test_fastapi/test_app_testing/test_tutorial001_tests_main.py::test_run_tests"
)
EPYTEST_IGNORE=(
	# Uses coverage
	# TIP: Search for imports of coverage_run
	"tests/test_tutorial/test_create_db_and_table/test_tutorial001.py"
	"tests/test_tutorial/test_create_db_and_table/test_tutorial001_py310.py"
)
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="SQL databases in Python, designed for simplicity, compatibility, and robustness"
HOMEPAGE="
	https://sqlmodel.tiangolo.com/
	https://github.com/fastapi/sqlmodel/
	https://pypi.org/project/sqlmodel/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="dev doc test"
RDEPEND="
	(
		>=dev-python/sqlalchemy-2.0.14[${PYTHON_USEDEP}]
		<dev-python/sqlalchemy-2.1.0[${PYTHON_USEDEP}]
	)
	(
		>=dev-python/pydantic-1.10.13[${PYTHON_USEDEP}]
		<dev-python/pydantic-3.0.0[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	dev? (
		(
			>=dev-python/pre-commit-2.17.0[${PYTHON_USEDEP}]
			<dev-python/pre-commit-4.0.0[${PYTHON_USEDEP}]
		)
	)
	doc? (
		>=dev-python/cairosvg-2.7.1[${PYTHON_USEDEP}]
		>=dev-python/markdown-include-variants-0.0.4[${PYTHON_USEDEP}]
		>=dev-python/mdx-include-1.4.1[${PYTHON_USEDEP}]
		>=dev-python/mkdocs-macros-plugin-1.0.5[${PYTHON_USEDEP}]
		>=dev-python/mkdocs-material-9.5.18[${PYTHON_USEDEP}]
		>=dev-python/mkdocs-redirects-1.2.1[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-5.3.1[${PYTHON_USEDEP}]
		>=dev-python/typer-0.12.3[${PYTHON_USEDEP}]
		>=virtual/pillow-11.0.0[${PYTHON_USEDEP}]
		test? (
			>=dev-python/black-22.10[${PYTHON_USEDEP}]
		)
	)
	test? (
		>=dev-python/coverage-6.2[${PYTHON_USEDEP},toml(+)]
		>=dev-python/dirty-equals-0.9.0[${PYTHON_USEDEP}]
		>=dev-python/fastapi-0.103.2[${PYTHON_USEDEP}]
		>=dev-python/httpx-0.24.1[${PYTHON_USEDEP}]
		>=dev-python/jinja2-3.1.4[${PYTHON_USEDEP}]
		>=dev-python/mypy-1.4.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.0.1[${PYTHON_USEDEP}]
		>=dev-util/ruff-0.9.6
		>=dev-python/typing-extensions-4.12.2[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests "pytest"

python_test() {
	epytest "tests"
}
