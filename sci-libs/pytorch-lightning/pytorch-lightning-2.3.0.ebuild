# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# lai-sphinx-theme
# lightning-cloud
# lightning-utilities
# inquirer
# playwright (or use playwright-bin)
# sphinx-multiproject
# sphinx-toolbox
# sphinxcontrib-mockautodoc
# sphinxcontrib-video
# tensorboardX
# torchmetrics

DISTUTILS_USE_PEP517="setuptools"
DISTUTILS_SINGLE_IMPL=1
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( "python3_"{10..11} )

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
IUSE+=" cloud components doc examples extra test test-gpu"
APP_BASE_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/arrow-1.2.0[${PYTHON_USEDEP}]
			<dev-python/arrow-1.3.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/backoff-2.2.1[${PYTHON_USEDEP}]
			<dev-python/backoff-2.3.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/beautifulsoup4-4.8.0[${PYTHON_USEDEP}]
			<dev-python/beautifulsoup4-4.13.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/croniter-1.3.0[${PYTHON_USEDEP}]
			<dev-python/croniter-1.5.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/deepdiff-5.7.0[${PYTHON_USEDEP}]
			<dev-python/deepdiff-6.6.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/fastapi-0.92.0[${PYTHON_USEDEP}]
			<dev-python/fastapi-0.104.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/fsspec-2022.5.0[${PYTHON_USEDEP},http(+)]
			<dev-python/fsspec-2023.11.0[${PYTHON_USEDEP},http(+)]
		)
		(
			>=dev-python/inquirer-2.10.0[${PYTHON_USEDEP}]
			<dev-python/inquirer-3.2.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/lightning-utilities-0.8.0[${PYTHON_USEDEP}]
			<dev-python/lightning-utilities-0.12.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/python-multipart-0.0.5[${PYTHON_USEDEP}]
			<dev-python/python-multipart-0.0.7[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/rich-12.3.0[${PYTHON_USEDEP}]
			<dev-python/rich-13.6.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/traitlets-5.3.0[${PYTHON_USEDEP}]
			<dev-python/traitlets-5.12.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/typing-extensions-4.4.0[${PYTHON_USEDEP}]
			<dev-python/typing-extensions-4.10.0[${PYTHON_USEDEP}]
		)
		<dev-python/click-8.2[${PYTHON_USEDEP}]
		<dev-python/dateutils-0.8.0[${PYTHON_USEDEP}]
		<dev-python/jinja-3.2.0[${PYTHON_USEDEP}]
		<dev-python/psutil-5.9.6[${PYTHON_USEDEP}]
		<dev-python/pyyaml-6.0.2[${PYTHON_USEDEP}]
		<dev-python/requests-2.32.0[${PYTHON_USEDEP}]
		<dev-python/urllib3-2.0.0[${PYTHON_USEDEP}]
		<dev-python/uvicorn-0.24.0[${PYTHON_USEDEP}]
		<dev-python/websocket-client-1.7.0[${PYTHON_USEDEP}]
		<dev-python/websockets-11.1.0[${PYTHON_USEDEP}]
		>=dev-python/lightning-cloud-0.5.69[${PYTHON_USEDEP}]
		>=dev-python/pydantic-1.7.4[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/starlette[${PYTHON_USEDEP}]
	')
"
APP_CLOUD_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/redis-4.0.1[${PYTHON_USEDEP}]
			<dev-python/redis-5.1.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/docker-5.0.0[${PYTHON_USEDEP}]
			<dev-python/docker-6.1.4[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/s3fs-2022.5.0[${PYTHON_USEDEP}]
			<dev-python/s3fs-2023.6.1[${PYTHON_USEDEP}]
		)
	')
"
APP_COMPONENTS_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/aiohttp-3.8.0[${PYTHON_USEDEP}]
			<dev-python/aiohttp-3.9.0[${PYTHON_USEDEP}]
		)
		>=dev-python/lightning-fabric-1.9.0[${PYTHON_USEDEP}]
		>=dev-python/lightning_api_access-0.0.3[${PYTHON_USEDEP}]
		>=dev-python/pytorch-lightning-1.9.0[${PYTHON_USEDEP}]
	')
"
APP_UI_RDEPEND="
"
FABRIC_BASE_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/fsspec-2022.5.0[${PYTHON_USEDEP},http(+)]
			<dev-python/fsspec-2024.4.0[${PYTHON_USEDEP},http(+)]
		)
		(
			>=dev-python/lightning-utilities-0.8.0[${PYTHON_USEDEP}]
			<dev-python/lightning-utilities-0.12.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/numpy-1.17.2[${PYTHON_USEDEP}]
			<dev-python/numpy-1.27.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/packaging-20.0[${PYTHON_USEDEP}]
			<dev-python/packaging-23.1.1[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/typing-extensions-4.4.0[${PYTHON_USEDEP}]
			<dev-python/typing-extensions-4.10.0[${PYTHON_USEDEP}]
		)
	')
	(
		>=sci-libs/pytorch-2.0.0[${PYTHON_SINGLE_USEDEP}]
		<sci-libs/pytorch-2.4.0[${PYTHON_SINGLE_USEDEP}]
	)
"
FABRIC_EXAMPLES_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/lightning-utilities-0.8.0[${PYTHON_USEDEP}]
			<dev-python/lightning-utilities-0.12.0[${PYTHON_USEDEP}]
		)
		(
			>=sci-libs/torchmetrics-0.10.0[${PYTHON_USEDEP}]
			<sci-libs/torchmetrics-1.3.0[${PYTHON_USEDEP}]
		)
		(
			>=sci-libs/torchvision-0.15.0[${PYTHON_USEDEP}]
			<sci-libs/torchvision-0.19.0[${PYTHON_USEDEP}]
		)
	')
"
PYTORCH_BASE_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/fsspec-2022.5.0[${PYTHON_USEDEP},http(+)]
			<dev-python/fsspec-2024.4.0[${PYTHON_USEDEP},http(+)]
		)
		(
			>=dev-python/lightning-utilities-0.8.0[${PYTHON_USEDEP}]
			<dev-python/lightning-utilities-0.12.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/numpy-1.17.2[${PYTHON_USEDEP}]
			<dev-python/numpy-1.27.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/packaging-20.0[${PYTHON_USEDEP}]
			<dev-python/packaging-23.1.1[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/pyyaml-5.4[${PYTHON_USEDEP}]
			<dev-python/pyyaml-6.1.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/tqdm-4.57.0[${PYTHON_USEDEP}]
			<dev-python/tqdm-4.67.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/typing-extensions-4.4.0[${PYTHON_USEDEP}]
			<dev-python/typing-extensions-4.10.0[${PYTHON_USEDEP}]
		)
	')
	(
		>=sci-libs/pytorch-2.0.0[${PYTHON_SINGLE_USEDEP}]
		<sci-libs/pytorch-2.4.0[${PYTHON_SINGLE_USEDEP}]
	)
	(
		>=sci-libs/torchmetrics-0.7.0[${PYTHON_SINGLE_USEDEP}]
		<sci-libs/torchmetrics-1.3.0[${PYTHON_SINGLE_USEDEP}]
	)
"
PYTORCH_EXAMPLES_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/lightning-utilities-0.8.0[${PYTHON_USEDEP}]
			<dev-python/lightning-utilities-0.12.0[${PYTHON_USEDEP}]
		)
		(
			>=sci-libs/torchmetrics-0.10.0[${PYTHON_USEDEP}]
			<sci-libs/torchmetrics-1.3.0[${PYTHON_USEDEP}]
		)
		(
			>=sci-libs/torchvision-0.15.0[${PYTHON_USEDEP}]
			<sci-libs/torchvision-0.19.0[${PYTHON_USEDEP}]
		)
		<dev-python/ipython-8.15.0[${PYTHON_USEDEP},all(-)]
		<dev-python/requests-2.32.0[${PYTHON_USEDEP}]
	')
"
PYTORCH_EXTRA_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/bitsandbytes-0.42.0[${PYTHON_USEDEP}]
			<dev-python/bitsandbytes-0.43.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/hydra-core-1.0.5[${PYTHON_USEDEP}]
			<dev-python/hydra-core-1.4.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/jsonargparse-4.27.7[${PYTHON_USEDEP},signatures]
			<dev-python/jsonargparse-4.28.0[${PYTHON_USEDEP},signatures]
		)
		(
			>=dev-python/matplotlib-3.1[${PYTHON_USEDEP}]
			<dev-python/matplotlib-3.9.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/omegaconf-2.0.5[${PYTHON_USEDEP}]
			<dev-python/omegaconf-2.4.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/rich-12.3.0[${PYTHON_USEDEP}]
			<dev-python/rich-13.6.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/tensorboardX-2.2[${PYTHON_USEDEP}]
			<dev-python/tensorboardX-2.7.0[${PYTHON_USEDEP}]
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
"
DEPEND+="
	${RDEPEND}
"
DOCS_BDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/docutils-0.16[${PYTHON_USEDEP}]
			<dev-python/docutils-0.21[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/lightning-utilities-0.11.1[${PYTHON_USEDEP}]
			<dev-python/lightning-utilities-0.12.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/myst-parser-0.18.1[${PYTHON_USEDEP}]
			<dev-python/myst-parser-3.0.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/nbsphinx-0.8.5[${PYTHON_USEDEP}]
			<dev-python/nbsphinx-0.9.3[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/pandoc-1.0[${PYTHON_USEDEP}]
			<dev-python/pandoc-2.3.1[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/sphinx-5.0[${PYTHON_USEDEP}]
			<dev-python/sphinx-6.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/sphinx-copybutton-0.3[${PYTHON_USEDEP}]
			<dev-python/sphinx-copybutton-0.5.3[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/sphinx-paramlinks-0.5.1[${PYTHON_USEDEP}]
			<dev-python/sphinx-paramlinks-0.6.1[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/sphinx-togglebutton-0.2[${PYTHON_USEDEP}]
			<dev-python/sphinx-togglebutton-0.3.3[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/sphinxcontrib-fulltoc-1.0[${PYTHON_USEDEP}]
			<dev-python/sphinxcontrib-fulltoc-1.2.1[${PYTHON_USEDEP}]
		)
		<dev-python/jinja-3.2.0[${PYTHON_USEDEP}]
		<dev-python/nbconvert-7.14[${PYTHON_USEDEP}]
		>=dev-python/sphinx-autodoc-typehints-1.16[${PYTHON_USEDEP}]
		>=dev-python/sphinx-toolbox-3.5.0[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-video-0.2.0[${PYTHON_USEDEP}]
		dev-python/lai-sphinx-theme[${PYTHON_USEDEP}]
		dev-python/sphinx-autobuild[${PYTHON_USEDEP}]
		dev-python/sphinx-multiproject[${PYTHON_USEDEP}]
		dev-python/sphinx-rtd-dark-mode[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-mockautodoc[${PYTHON_USEDEP}]
	')
"
APP_DOCS_BDEPEND="
	${DOCS_BDEPEND}
"
APP_TEST_BDEPEND="
	$(python_gen_cond_dep '
		<dev-python/psutil-5.10.0[${PYTHON_USEDEP}]
		<dev-python/setuptools-68.3.0[${PYTHON_USEDEP}]
		<dev-python/trio-0.22.0[${PYTHON_USEDEP}]
		>=dev-python/coverage-7.3.1[${PYTHON_USEDEP}]
		>=dev-python/httpx-0.25.0[${PYTHON_USEDEP}]
		>=dev-python/playwright-1.38.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.4.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-asyncio-0.21.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-4.1.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-doctestplus-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-rerunfailures-12.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-timeout-2.1.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-3.3.1[${PYTHON_USEDEP}]
		>=dev-python/requests-mock-1.11.0[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/pympler[${PYTHON_USEDEP}]
	')
"
FABRIC_DOCS_BDEPEND="
	${DOCS_BDEPEND}
	sci-visualization/tensorboard[${PYTHON_SINGLE_USEDEP}]
"
FABRIC_STRATEGIES_BDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/bitsandbytes-0.42.0[${PYTHON_USEDEP}]
			<dev-python/bitsandbytes-0.43.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/deepspeed-0.8.2[${PYTHON_USEDEP}]
			<dev-python/deepspeed-0.9.4[${PYTHON_USEDEP}]
		)
	')
"
FABRIC_TEST_BDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/tensorboardX-2.2[${PYTHON_USEDEP}]
			<dev-python/tensorboardX-2.7.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/torchmetrics-0.7.0[${PYTHON_USEDEP}]
			<dev-python/torchmetrics-1.3.0[${PYTHON_USEDEP}]
		)
		>=dev-python/click-8.1.7[${PYTHON_USEDEP}]
		>=dev-python/coverage-7.3.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.4.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-4.1.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-random-order-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-rerunfailures-12.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-timeout-2.1.0[${PYTHON_USEDEP}]
	')
"
PYTORCH_DOCS_BDEPEND="
	${DOCS_BDEPEND}
	$(python_gen_cond_dep '
		<dev-python/ipython-8.7.0[${PYTHON_USEDEP},notebook]
		<dev-python/setuptools-58.0[${PYTHON_USEDEP}]
		dev-python/fire[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
		dev-python/pt-lightning-sphinx-theme[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		dev-python/wcmatch[${PYTHON_USEDEP}]
	')
"
PYTORCH_STRATEGIES="
	$(python_gen_cond_dep '
		>=dev-python/deepspeed-0.8.2[${PYTHON_USEDEP}]
		<dev-python/deepspeed-0.9.4[${PYTHON_USEDEP}]
	')
"
PYTORCH_TEST_BDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/cloudpickle-1.3[${PYTHON_USEDEP}]
			<dev-python/cloudpickle-2.3.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/onnx-0.14.0[${PYTHON_USEDEP}]
			<dev-python/onnx-1.15.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/onnxruntime-0.15.0[${PYTHON_USEDEP}]
			<dev-python/onnxruntime-1.17.0[${PYTHON_USEDEP}]
		)
		(
			>dev-python/pandas-1.0[${PYTHON_USEDEP}]
			<dev-python/pandas-2.2.0[${PYTHON_USEDEP}]
		)
		(
			>dev-python/scikit-learn-0.22.1[${PYTHON_USEDEP}]
			<dev-python/scikit-learn-1.4.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/tensorboard-2.9.1[${PYTHON_USEDEP}]
			<dev-python/tensorboard-2.15.0[${PYTHON_USEDEP}]
		)
		<dev-python/psutil-5.9.6[${PYTHON_USEDEP}]
		>=dev-python/coverage-7.3.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.4.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-4.1.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-random-order-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-rerunfailures-12.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-timeout-2.1.0[${PYTHON_USEDEP}]
		dev-python/fastapi[${PYTHON_USEDEP}]
		dev-python/uvicorn[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
		doc? (
			test? (
				>=dev-python/pytest-7.4.0[${PYTHON_USEDEP}]
				>=dev-python/pytest-doctestplus-1.0.0[${PYTHON_USEDEP}]
			)
		)
	')
	doc? (
		${APP_DOCS_BDEPEND}
		${FABRIC_DOCS_BDEPEND}
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
