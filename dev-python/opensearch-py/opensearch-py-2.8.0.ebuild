# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1

KEYWORDS="~amd64"
SRC_URI="
https://github.com/opensearch-project/opensearch-py/archive/v${PV}.tar.gz
	-> ${P}.gh.tar.gz
"

DESCRIPTION="Python client for OpenSearch"
HOMEPAGE="
	https://pypi.org/project/opensearch-py/
	https://github.com/opensearch-project/opensearch-py
"
LICENSE="Apache-2.0"
# USE=test uses 156 GB of RAM for the test suite, needs more work.
RESTRICT="test"
SLOT="0"
IUSE="async dev doc test"
REQUIRED_USE="
	dev? (
		doc
		test
	)
	doc? (
		async
	)
"
RDEPEND="
	>=dev-python/certifi-2024.07.04[${PYTHON_USEDEP}]
	>=dev-python/requests-2.32.0[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.26.19[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/events[${PYTHON_USEDEP}]
	async? (
		>=dev-python/aiohttp-3.9.4[${PYTHON_USEDEP}]
		<dev-python/aiohttp-4[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	dev? (
		>=dev-python/black-24.3.0[${PYTHON_USEDEP}]
		dev-python/jinja2[${PYTHON_USEDEP}]
	)
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
		dev-python/myst-parser[${PYTHON_USEDEP}]
		dev-python/sphinx-copybutton[${PYTHON_USEDEP}]
	)
	test? (
		(
			>=dev-python/requests-2.0.0[${PYTHON_USEDEP}]
			<dev-python/requests-3.0.0[${PYTHON_USEDEP}]
		)
		<dev-python/coverage-8.0.0[${PYTHON_USEDEP}]
		<dev-python/pytest-mock-4.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-3.0.0[${PYTHON_USEDEP}]
		dev-python/botocore[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
	)
"
