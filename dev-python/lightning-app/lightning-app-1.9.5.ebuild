# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# lai-sphinx-theme
# playwright (or use playwright-bin)
# sphinx-multiproject
# sphinx-toolbox
# sphinxcontrib-mockautodoc
# sqlmodel

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
export PACKAGE_NAME="app"
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( "python3_10" )

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/pytorch-lightning-${PV}"
SRC_URI="
https://github.com/Lightning-AI/pytorch-lightning/archive/refs/tags/${PV}.tar.gz
	-> pytorch-lightning-${PV}.tar.gz
"

DESCRIPTION="Use Lightning Apps to build everything from production-ready, \
multi-cloud ML systems to simple research demos."
HOMEPAGE="
	https://github.com/Lightning-AI/pytorch-lightning
	https://pypi.org/project/lightning-app
"
LICENSE="Apache-2.0"
SLOT="0"
IUSE+=" cloud components doc examples extra -strict test test-gpu ui"
APP_BASE_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/croniter-1.3.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/croniter-1.4.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/deepdiff-5.7.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/deepdiff-6.2.4[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/fsspec-2022.5.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/fsspec-2022.7.2[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/starsessions-1.2.1[${PYTHON_USEDEP}]
			strict? (
				<dev-python/starsessions-2.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/typing-extensions-4.0.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/typing-extensions-4.4.1[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/traitlets-5.3.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/traitlets-5.9.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/arrow-1.2.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/arrow-1.2.4[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/beautifulsoup4-4.8.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/beautifulsoup4-4.11.2[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/inquirer-2.10.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/inquirer-3.1.3[${PYTHON_USEDEP}]
			)
		)
		!strict? (
			dev-python/click[${PYTHON_USEDEP}]
			dev-python/dateutils[${PYTHON_USEDEP}]
			dev-python/fastapi[${PYTHON_USEDEP}]
			dev-python/jinja2[${PYTHON_USEDEP}]
			dev-python/psutil[${PYTHON_USEDEP}]
			dev-python/pydantic[${PYTHON_USEDEP}]
			dev-python/pyyaml[${PYTHON_USEDEP}]
			dev-python/requests[${PYTHON_USEDEP}]
			dev-python/rich[${PYTHON_USEDEP}]
			dev-python/starlette[${PYTHON_USEDEP}]
			dev-python/urllib3[${PYTHON_USEDEP}]
			dev-python/uvicorn[${PYTHON_USEDEP}]
			dev-python/websocket-client[${PYTHON_USEDEP}]
			dev-python/websockets[${PYTHON_USEDEP}]
		)
		strict? (
			<dev-python/click-8.1.4[${PYTHON_USEDEP}]
			<dev-python/dateutils-0.6.13[${PYTHON_USEDEP}]
			<dev-python/fastapi-0.89.0[${PYTHON_USEDEP}]
			<dev-python/jinja2-3.1.3[${PYTHON_USEDEP}]
			<dev-python/psutil-5.9.5[${PYTHON_USEDEP}]
			<dev-python/pydantic-1.10.5[${PYTHON_USEDEP}]
			<dev-python/pyyaml-6.0.2[${PYTHON_USEDEP}]
			<dev-python/requests-2.28.3[${PYTHON_USEDEP}]
			<dev-python/rich-13.0.2[${PYTHON_USEDEP}]
			<dev-python/starlette-0.24.0[${PYTHON_USEDEP}]
			<dev-python/urllib3-1.26.14[${PYTHON_USEDEP}]
			<dev-python/uvicorn-0.17.7[${PYTHON_USEDEP}]
			<dev-python/websocket-client-1.5.2[${PYTHON_USEDEP}]
			<dev-python/websockets-10.4.1[${PYTHON_USEDEP}]
		)
		dev-python/packaging[${PYTHON_USEDEP}]
	')
	(
		>=dev-python/lightning-utilities-0.6.0_p0[${PYTHON_SINGLE_USEDEP}]
		strict? (
			<dev-python/lightning-utilities-0.7.0[${PYTHON_SINGLE_USEDEP}]
		)
	)
	>=dev-python/lightning-cloud-0.5.27[${PYTHON_SINGLE_USEDEP}]
"
APP_CLOUD_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/redis-4.0.1[${PYTHON_USEDEP}]
			strict? (
				<dev-python/redis-4.2.5[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/docker-5.0.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/docker-6.0.2[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/s3fs-2022.5.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/s3fs-2022.11.1[${PYTHON_USEDEP}]
			)
		)
	')
"
APP_COMPONENTS_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/aiohttp-3.8.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/aiohttp-3.8.4[${PYTHON_USEDEP}]
			)
		)
	')
	(
		>dev-python/pytorch-lightning-1.8.0[${PYTHON_SINGLE_USEDEP}]
		strict? (
			<dev-python/pytorch-lightning-2.0.0[${PYTHON_SINGLE_USEDEP}]
		)
	)
	>=dev-python/lightning-api-access-0.0.3[${PYTHON_SINGLE_USEDEP}]
"
APP_UI_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/panel-0.12.7[${PYTHON_USEDEP}]
			strict? (
				<dev-python/panel-0.13.2[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/streamlit-1.13.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/streamlit-1.16.1[${PYTHON_USEDEP}]
			)
		)
	')
"
RDEPEND+="
	${APP_BASE_RDEPEND}
	cloud? (
		${APP_CLOUD_RDEPEND}
	)
	components? (
		${APP_COMPONENTS_RDEPEND}
	)
	ui? (
		${APP_UI_RDEPEND}
	)
"
DEPEND+="
	${RDEPEND}
"
DOCS_BDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/docutils-0.16[${PYTHON_USEDEP}]
			strict? (
				<dev-python/docutils-0.20[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/jinja2-3.0.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/jinja2-3.2.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/nbsphinx-0.8.5[${PYTHON_USEDEP}]
			strict? (
				<dev-python/nbsphinx-0.8.10[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/pandoc-1.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/pandoc-2.3.1[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/sphinx-4.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/sphinx-5.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/sphinx-copybutton-0.3[${PYTHON_USEDEP}]
			strict? (
				<dev-python/sphinx-copybutton-0.5.1[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/sphinx-paramlinks-0.5.1[${PYTHON_USEDEP}]
			strict? (
				<dev-python/sphinx-paramlinks-0.5.5[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/sphinx-togglebutton-0.2[${PYTHON_USEDEP}]
			strict? (
				<dev-python/sphinx-togglebutton-0.3.3[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/sphinxcontrib-fulltoc-1.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/sphinxcontrib-fulltoc-1.2.1[${PYTHON_USEDEP}]
			)
		)
		>=dev-python/myst-parser-0.18.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-autodoc-typehints-1.16[${PYTHON_USEDEP}]
		>=dev-python/sphinx-toolbox-3.4.0[${PYTHON_USEDEP}]
		dev-python/sphinx-autobuild[${PYTHON_USEDEP}]
		dev-python/sphinx-multiproject[${PYTHON_USEDEP}]
		dev-python/sphinx-rtd-dark-mode[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-mockautodoc[${PYTHON_USEDEP}]
	')
"
APP_DOCS_BDEPEND="
	${DOCS_BDEPEND}
	$(python_gen_cond_dep '
		dev-python/ipython[${PYTHON_USEDEP},notebook]
		dev-python/ipython_genutils[${PYTHON_USEDEP}]
		dev-python/lai-sphinx-theme[${PYTHON_USEDEP}]
	')
"
APP_TEST_BDEPEND="
	$(python_gen_cond_dep '
		!strict? (
			dev-python/trio[${PYTHON_USEDEP}]
			dev-python/setuptools[${PYTHON_USEDEP}]
		)
		strict? (
			<dev-python/trio-0.22.0[${PYTHON_USEDEP}]
			<dev-python/setuptools-65.7.0[${PYTHON_USEDEP}]
		)
		>=dev-python/codecov-2.1.12[${PYTHON_USEDEP}]
		>=dev-python/coverage-6.5.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.2.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-asyncio-0.20.3[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-4.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-doctestplus-0.9.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-timeout-2.1.0[${PYTHON_USEDEP}]
		>=dev-python/playwright-1.30.0[${PYTHON_USEDEP}]
		dev-python/httpx[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pympler[${PYTHON_USEDEP}]
		dev-python/requests-mock[${PYTHON_USEDEP}]
		dev-python/sqlmodel[${PYTHON_USEDEP}]
	')
"
STORE_TEST_BDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/coverage-7.3.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.4.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-4.1.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-random-order-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-rerunfailures-12.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-timeout-2.1.0[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	')
	doc? (
		${APP_DOCS_BDEPEND}
	)
	test? (
		${APP_TEST_BDEPEND}
		cloud? (
			${STORE_TEST_BDEPEND}
		)
	)
"
