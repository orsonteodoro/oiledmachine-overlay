# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# colossalai
# deepspeed
# fairscale
# hivemind
# horovod
# lai-sphinx-theme
# lightning_api_access
# lightning-cloud
# lightning-utilities
# inquirer
# playwright (or use playwright-bin)
# sphinx-multiproject
# sphinx-toolbox
# sphinxcontrib-mockautodoc
# sqlmodel
# tensorboardX
# torchmetrics

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( "python3_10" )

inherit distutils-r1

#KEYWORDS="~amd64" # Needs install test
SRC_URI="
https://github.com/Lightning-AI/pytorch-lightning/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Lightweight PyTorch wrapper for ML researchers"
HOMEPAGE="
	https://github.com/Lightning-AI/pytorch-lightning
	https://pypi.org/project/pytorch-lightning
"
LICENSE="Apache-2.0"
SLOT="0"
IUSE+=" cloud components doc examples extra test test-gpu ui"
APP_BASE_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/croniter-1.3.0[${PYTHON_USEDEP}]
			<dev-python/croniter-1.4.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/deepdiff-5.7.0[${PYTHON_USEDEP}]
			<dev-python/deepdiff-6.2.4[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/fsspec-2022.5.0[${PYTHON_USEDEP}]
			<dev-python/fsspec-2022.7.2[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/starsessions-1.2.1[${PYTHON_USEDEP}]
			<dev-python/starsessions-2.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/typing-extensions-4.0.0[${PYTHON_USEDEP}]
			<dev-python/typing-extensions-4.4.1[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/traitlets-5.3.0[${PYTHON_USEDEP}]
			<dev-python/traitlets-5.9.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/arrow-1.2.0[${PYTHON_USEDEP}]
			<dev-python/arrow-1.2.4[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/lightning-utilities-0.6.0_p0[${PYTHON_USEDEP}]
			<dev-python/lightning-utilities-0.7.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/beautifulsoup4-4.8.0[${PYTHON_USEDEP}]
			<dev-python/beautifulsoup4-4.11.2[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/inquirer-2.10.0[${PYTHON_USEDEP}]
			<dev-python/inquirer-3.1.3[${PYTHON_USEDEP}]
		)
		<dev-python/click-8.1.4[${PYTHON_USEDEP}]
		<dev-python/dateutils-0.6.13[${PYTHON_USEDEP}]
		<dev-python/fastapi-0.89.0[${PYTHON_USEDEP}]
		<dev-python/jinja-3.1.3[${PYTHON_USEDEP}]
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
		>=dev-python/lightning-cloud-0.5.27[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
	')
"
APP_CLOUD_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/redis-4.0.1[${PYTHON_USEDEP}]
			<dev-python/redis-4.2.5[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/docker-5.0.0[${PYTHON_USEDEP}]
			<dev-python/docker-6.0.2[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/s3fs-2022.5.0[${PYTHON_USEDEP}]
			<dev-python/s3fs-2022.11.1[${PYTHON_USEDEP}]
		)
	')
"
APP_COMPONENTS_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/aiohttp-3.8.0[${PYTHON_USEDEP}]
			<dev-python/aiohttp-3.8.4[${PYTHON_USEDEP}]
		)
		(
			>dev-python/pytorch-lightning-1.8.0[${PYTHON_USEDEP}]
			<dev-python/pytorch-lightning-2.0.0[${PYTHON_USEDEP}]
		)
		>=dev-python/lightning_api_access-0.0.3[${PYTHON_USEDEP}]
	')
"
APP_UI_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/panel-0.12.7[${PYTHON_USEDEP}]
			<dev-python/panel-0.13.2[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/streamlit-1.13.0[${PYTHON_USEDEP}]
			<dev-python/streamlit-1.16.1[${PYTHON_USEDEP}]
		)
	')
"
FABRIC_BASE_RDEPEND="
	$(python_gen_cond_dep '
		(
			>dev-python/fsspec-2021.06.0[${PYTHON_USEDEP},http(+)]
			<dev-python/fsspec-2023.2.0[${PYTHON_USEDEP},http(+)]
		)
		(
			>=dev-python/lightning-utilities-0.6.0_p0[${PYTHON_USEDEP}]
			<dev-python/lightning-utilities-0.7.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/numpy-1.17.2[${PYTHON_USEDEP}]
			<dev-python/numpy-1.24.2[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/packaging-17.1[${PYTHON_USEDEP}]
			<dev-python/packaging-23.0.1[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/typing-extensions-4.0.0[${PYTHON_USEDEP}]
			<dev-python/typing-extensions-4.4.1[${PYTHON_USEDEP}]
		)
	')
	(
		>=sci-libs/pytorch-1.10.0[${PYTHON_SINGLE_USEDEP}]
		<sci-libs/pytorch-2.0.1[${PYTHON_SINGLE_USEDEP}]
	)
"
FABRIC_EXAMPLES_RDEPEND="
	(
		>=sci-libs/torchvision-0.10.0[${PYTHON_SINGLE_USEDEP}]
		<sci-libs/torchvision-0.15.2[${PYTHON_SINGLE_USEDEP}]
	)
	(
		>=sci-libs/torchmetrics-0.10.0[${PYTHON_SINGLE_USEDEP}]
		<sci-libs/torchmetrics-0.12.0[${PYTHON_SINGLE_USEDEP}]
	)
"
PYTORCH_BASE_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/numpy-1.17.2[${PYTHON_USEDEP}]
			<dev-python/numpy-1.24.2[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/pyyaml-5.4[${PYTHON_USEDEP}]
			<dev-python/pyyaml-6.0.1[${PYTHON_USEDEP}]
		)
		(
			>dev-python/fsspec-2021.06.0[${PYTHON_USEDEP},http(+)]
			<dev-python/fsspec-2023.2.0[${PYTHON_USEDEP},http(+)]
		)
		(
			>=dev-python/lightning-utilities-0.6.0_p0[${PYTHON_USEDEP}]
			<dev-python/lightning-utilities-0.7.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/packaging-17.1[${PYTHON_USEDEP}]
			<dev-python/packaging-23.0.1[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/tqdm-4.57.0[${PYTHON_USEDEP}]
			<dev-python/tqdm-4.65.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/typing-extensions-4.0.0[${PYTHON_USEDEP}]
			<dev-python/typing-extensions-4.4.1[${PYTHON_USEDEP}]
		)
	')
	(
		>=sci-libs/pytorch-1.10.0[${PYTHON_SINGLE_USEDEP}]
		<sci-libs/pytorch-2.0.1[${PYTHON_SINGLE_USEDEP}]
	)
	(
		>=sci-libs/torchmetrics-0.7.0[${PYTHON_SINGLE_USEDEP}]
		<sci-libs/torchmetrics-0.12.0[${PYTHON_SINGLE_USEDEP}]
	)
"
PYTORCH_EXAMPLES_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=sci-libs/gym-0.17.0[${PYTHON_USEDEP},classic_control(+)]
			<sci-libs/gym-0.26.3[${PYTHON_USEDEP},classic_control(+)]
		)
		<dev-python/ipython-8.7.1[${PYTHON_USEDEP},all(-)]
	')
	(
		>=sci-libs/torchmetrics-0.10.0[${PYTHON_SINGLE_USEDEP}]
		<sci-libs/torchmetrics-0.12.0[${PYTHON_SINGLE_USEDEP}]
	)
	(
		>=sci-libs/torchvision-0.11.1[${PYTHON_SINGLE_USEDEP}]
		<sci-libs/torchvision-0.15.2[${PYTHON_SINGLE_USEDEP}]
	)
"
PYTORCH_EXTRA_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/hydra-core-1.0.5[${PYTHON_USEDEP}]
			<dev-python/hydra-core-1.4.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/jsonargparse-4.18.0[${PYTHON_USEDEP},signatures]
			<dev-python/jsonargparse-4.19.0[${PYTHON_USEDEP},signatures]
		)
		(
			>dev-python/matplotlib-3.1[${PYTHON_USEDEP}]
			<dev-python/matplotlib-3.6.2[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/omegaconf-2.0.5[${PYTHON_USEDEP}]
			<dev-python/omegaconf-2.4.0[${PYTHON_USEDEP}]
		)
		(
			!~dev-python/rich-10.15.0a[${PYTHON_USEDEP}]
			!~dev-python/rich-10.15.0_alpha[${PYTHON_USEDEP}]
			>=dev-python/rich-10.14.0[${PYTHON_USEDEP}]
			<dev-python/rich-13.0.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/tensorboardX-2.2[${PYTHON_USEDEP}]
			<dev-python/tensorboardX-2.5.2[${PYTHON_USEDEP}]
		)
	')
"
RDEPEND+="
	${APP_BASE_RDEPEND}
	${FABRIC_BASE_RDEPEND}
	${PYTORCH_BASE_RDEPEND}
	cloud? (
		${APP_CLOUD_RDEPEND}
	)
	components? (
		${APP_COMPONENTS_RDEPEND}
	)
	examples? (
		${FABRIC_EXAMPLES_RDEPEND}
		${PYTORCH_EXAMPLES_RDEPEND}
	)
	extra? (
		${PYTORCH_EXTRA_RDEPEND}
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
			<dev-python/docutils-0.20[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/jinja-3.0.0[${PYTHON_USEDEP}]
			<dev-python/jinja-3.2.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/nbsphinx-0.8.5[${PYTHON_USEDEP}]
			<dev-python/nbsphinx-0.8.10[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/pandoc-1.0[${PYTHON_USEDEP}]
			<dev-python/pandoc-2.3.1[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/sphinx-4.0[${PYTHON_USEDEP}]
			<dev-python/sphinx-5.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/sphinx-copybutton-0.3[${PYTHON_USEDEP}]
			<dev-python/sphinx-copybutton-0.5.1[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/sphinx-paramlinks-0.5.1[${PYTHON_USEDEP}]
			<dev-python/sphinx-paramlinks-0.5.5[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/sphinx-togglebutton-0.2[${PYTHON_USEDEP}]
			<dev-python/sphinx-togglebutton-0.3.3[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/sphinxcontrib-fulltoc-1.0[${PYTHON_USEDEP}]
			<dev-python/sphinxcontrib-fulltoc-1.2.1[${PYTHON_USEDEP}]
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
		<dev-python/trio-0.22.0[${PYTHON_USEDEP}]
		<dev-python/setuptools-65.7.0[${PYTHON_USEDEP}]
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
FABRIC_STRATEGIES_BDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/deepspeed-0.6.0[${PYTHON_USEDEP}]
			<dev-python/deepspeed-0.8.1[${PYTHON_USEDEP}]
		)
	')
"
FABRIC_TEST_BDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/tensorboardX-2.2[${PYTHON_USEDEP}]
			<dev-python/tensorboardX-2.5.2[${PYTHON_USEDEP}]
		)
		>=dev-python/click-8.1.3[${PYTHON_USEDEP}]
		>=dev-python/codecov-2.1.12[${PYTHON_USEDEP}]
		>=dev-python/coverage-6.5.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.2.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-4.0.0[${PYTHON_USEDEP}]
		>=dev-vcs/pre-commit-2.20.0[${PYTHON_USEDEP}]
	')
"
PYTORCH_DOCS_BDEPEND="
	${DOCS_BDEPEND}
	$(python_gen_cond_dep '
		<dev-python/ipython-8.7.0[${PYTHON_USEDEP},notebook]
		<dev-python/setuptools-58.0[${PYTHON_USEDEP}]
		dev-python/fire[${PYTHON_USEDEP}]
		dev-python/nbformat[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/wcmatch[${PYTHON_USEDEP}]
	')
"
PYTORCH_STRATEGIES="
	$(python_gen_cond_dep '
		(
			>=dev-python/colossalai-0.2.0[${PYTHON_USEDEP}]
			<dev-python/colossalai-0.2.5[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/deepspeed-0.6.0[${PYTHON_USEDEP}]
			<dev-python/deepspeed-0.8.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/fairscale-0.4.5[${PYTHON_USEDEP}]
			<dev-python/fairscale-0.4.13[${PYTHON_USEDEP}]
		)
		(
			!~dev-python/horovod-0.24.0[${PYTHON_USEDEP}]
			>=dev-python/horovod-0.21.2[${PYTHON_USEDEP}]
			<dev-python/horovod-0.26.2[${PYTHON_USEDEP}]
		)
		>=dev-python/hivemind-1.1.5[${PYTHON_USEDEP}]
	')
"
PYTORCH_TEST_BDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/cloudpickle-1.3[${PYTHON_USEDEP}]
			<dev-python/cloudpickle-2.3.0[${PYTHON_USEDEP}]
		)
		(
			>dev-python/pandas-1.0[${PYTHON_USEDEP}]
			<dev-python/pandas-1.5.4[${PYTHON_USEDEP}]
		)
		(
			>dev-python/scikit-learn-0.22.1[${PYTHON_USEDEP}]
			<dev-python/scikit-learn-1.2.1[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/tensorboard-2.9.1[${PYTHON_USEDEP}]
			<dev-python/tensorboard-2.12.0[${PYTHON_USEDEP}]
		)
		<dev-python/fastapi-0.87.0[${PYTHON_USEDEP}]
		<dev-python/onnx-1.14.0[${PYTHON_USEDEP}]
		<dev-python/onnxruntime-1.14.0[${PYTHON_USEDEP}]
		<dev-python/protobuf-3.20.2:0/3.21[${PYTHON_USEDEP}]
		<dev-python/psutil-5.9.5[${PYTHON_USEDEP}]
		<dev-python/uvicorn-0.19.1[${PYTHON_USEDEP}]
		>=dev-python/codecov-2.1.12[${PYTHON_USEDEP}]
		>=dev-python/coverage-6.5.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.2.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-4.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-forked-1.4.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-rerunfailures-10.3[${PYTHON_USEDEP}]
		>=dev-vcs/pre-commit-2.20.0[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	')
	doc? (
		${APP_DOCS_BDEPEND}
		${PYTORCH_DOCS_BDEPEND}
	)
	test? (
		${APP_TEST_BDEPEND}
		${FABRIC_TEST_BDEPEND}
		${PYTORCH_TEST_BDEPEND}
	)
	test-gpu? (
		${FABRIC_STRATEGIES_BDEPEND}
		${PYTORCH_STRATEGIES}
	)
"
