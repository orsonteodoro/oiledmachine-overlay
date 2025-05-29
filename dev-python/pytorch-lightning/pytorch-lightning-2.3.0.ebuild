# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# bitsandbytes
# deepspeed
# hydra-core
# jsonargparse
# omegaconf
# sphinx-multiproject
# sphinx-toolbox
# sphinxcontrib-mockautodoc
# sphinxcontrib-video

CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE"
DISTUTILS_USE_PEP517="setuptools"
DISTUTILS_SINGLE_IMPL=1
export PACKAGE_NAME="pytorch"
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( "python3_11" )

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
https://github.com/Lightning-AI/pytorch-lightning/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="PyTorch Lightning is the lightweight PyTorch wrapper for ML \
researchers. Scale your models. Write less boilerplate."
HOMEPAGE="
	https://github.com/Lightning-AI/pytorch-lightning
	https://pypi.org/project/pytorch-lightning
"
LICENSE="Apache-2.0"
SLOT="0"
IUSE+="
doc examples extra -strict test test-gpu
ebuild_revision_6
"
PYTORCH_BASE_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/fsspec-2022.5.0[${PYTHON_USEDEP},http(+)]
			strict? (
				<dev-python/fsspec-2024.4.0[${PYTHON_USEDEP},http(+)]
			)
		)
		(
			>=dev-python/numpy-1.17.2[${PYTHON_USEDEP}]
			strict? (
				<dev-python/numpy-1.27.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/packaging-20.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/packaging-23.1.1[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/pyyaml-5.4[${PYTHON_USEDEP}]
			strict? (
				<dev-python/pyyaml-6.1.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/tqdm-4.57.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/tqdm-4.67.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/typing-extensions-4.4.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/typing-extensions-4.10.0[${PYTHON_USEDEP}]
			)
		)
	')
	(
		>=dev-python/lightning-utilities-0.8.0[${PYTHON_SINGLE_USEDEP}]
		strict? (
			<dev-python/lightning-utilities-0.12.0[${PYTHON_SINGLE_USEDEP}]
		)
	)
	(
		>=sci-ml/pytorch-2.0.0[${PYTHON_SINGLE_USEDEP}]
		strict? (
			<sci-ml/pytorch-2.4.0[${PYTHON_SINGLE_USEDEP}]
		)
	)
	(
		>=sci-ml/torchmetrics-0.7.0[${PYTHON_SINGLE_USEDEP}]
		strict? (
			<sci-ml/torchmetrics-1.3.0[${PYTHON_SINGLE_USEDEP}]
		)
	)
"
PYTORCH_EXAMPLES_RDEPEND="
	$(python_gen_cond_dep '
		!strict? (
			dev-python/ipython[${PYTHON_USEDEP},all(-)]
			dev-python/requests[${PYTHON_USEDEP}]
		)
		strict? (
			<dev-python/ipython-8.15.0[${PYTHON_USEDEP},all(-)]
			<dev-python/requests-2.32.0[${PYTHON_USEDEP}]
		)
	')
	(
		>=dev-python/lightning-utilities-0.8.0[${PYTHON_SINGLE_USEDEP}]
		strict? (
			<dev-python/lightning-utilities-0.12.0[${PYTHON_SINGLE_USEDEP}]
		)
	)
	(
		>=sci-ml/torchmetrics-0.10.0[${PYTHON_SINGLE_USEDEP}]
		strict? (
			<sci-ml/torchmetrics-1.3.0[${PYTHON_SINGLE_USEDEP}]
		)
	)
	(
		>=sci-ml/torchvision-0.15.0[${PYTHON_SINGLE_USEDEP}]
		strict? (
			<sci-ml/torchvision-0.19.0[${PYTHON_SINGLE_USEDEP}]
		)
	)
"
PYTORCH_EXTRA_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/bitsandbytes-0.42.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/bitsandbytes-0.43.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/hydra-core-1.0.5[${PYTHON_USEDEP}]
			strict? (
				<dev-python/hydra-core-1.4.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/jsonargparse-4.27.7[${PYTHON_USEDEP},signatures]
			strict? (
				<dev-python/jsonargparse-4.28.0[${PYTHON_USEDEP},signatures]
			)
		)
		(
			>=dev-python/matplotlib-3.1[${PYTHON_USEDEP}]
			strict? (
				<dev-python/matplotlib-3.9.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/omegaconf-2.0.5[${PYTHON_USEDEP}]
			strict? (
				<dev-python/omegaconf-2.4.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/rich-12.3.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/rich-13.6.0[${PYTHON_USEDEP}]
			)
		)
	')
	(
		>=sci-visualization/tensorboardx-2.2[${PYTHON_SINGLE_USEDEP}]
		strict? (
			<sci-visualization/tensorboardx-2.7.0[${PYTHON_SINGLE_USEDEP}]
		)
	)
"
RDEPEND+="
	${PYTORCH_BASE_RDEPEND}
	examples? (
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
			strict? (
				<dev-python/docutils-0.21[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/myst-parser-0.18.1[${PYTHON_USEDEP}]
			strict? (
				<dev-python/myst-parser-3.0.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/nbsphinx-0.8.5[${PYTHON_USEDEP}]
			strict? (
				<dev-python/nbsphinx-0.9.3[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/pandoc-1.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/pandoc-2.3.1[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/sphinx-5.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/sphinx-6.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/sphinx-copybutton-0.3[${PYTHON_USEDEP}]
			strict? (
				<dev-python/sphinx-copybutton-0.5.3[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/sphinx-paramlinks-0.5.1[${PYTHON_USEDEP}]
			strict? (
				<dev-python/sphinx-paramlinks-0.6.1[${PYTHON_USEDEP}]
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
		!strict? (
			dev-python/jinja2[${PYTHON_USEDEP}]
			dev-python/nbconvert[${PYTHON_USEDEP}]
		)
		strict? (
			<dev-python/jinja2-3.2.0[${PYTHON_USEDEP}]
			<dev-python/nbconvert-7.14[${PYTHON_USEDEP}]
		)
		>=dev-python/sphinx-autodoc-typehints-1.16[${PYTHON_USEDEP}]
		>=dev-python/sphinx-toolbox-3.5.0[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-video-0.2.0[${PYTHON_USEDEP}]
		dev-python/lai-sphinx-theme[${PYTHON_USEDEP}]
		dev-python/sphinx-autobuild[${PYTHON_USEDEP}]
		dev-python/sphinx-multiproject[${PYTHON_USEDEP}]
		dev-python/sphinx-rtd-dark-mode[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-mockautodoc[${PYTHON_USEDEP}]
	')
	(
		>=dev-python/lightning-utilities-0.11.1[${PYTHON_SINGLE_USEDEP}]
		strict? (
			<dev-python/lightning-utilities-0.12.0[${PYTHON_SINGLE_USEDEP}]
		)
	)
"
PYTORCH_DOCS_BDEPEND="
	${DOCS_BDEPEND}
	$(python_gen_cond_dep '
		!strict? (
			dev-python/ipython[${PYTHON_USEDEP},notebook]
			dev-python/setuptools[${PYTHON_USEDEP}]
		)
		strict? (
			<dev-python/ipython-8.7.0[${PYTHON_USEDEP},notebook]
			<dev-python/setuptools-58.0[${PYTHON_USEDEP}]
		)
		dev-python/fire[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
		dev-python/pt-lightning-sphinx-theme[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		dev-python/wcmatch[${PYTHON_USEDEP}]
	')
"
PYTORCH_STRATEGIES_BDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/deepspeed-0.8.2[${PYTHON_USEDEP}]
		strict? (
			<dev-python/deepspeed-0.9.4[${PYTHON_USEDEP}]
		)
	')
"
PYTORCH_TEST_BDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/cloudpickle-1.3[${PYTHON_USEDEP}]
			strict? (
				<dev-python/cloudpickle-2.3.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/onnx-0.14.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/onnx-1.15.0[${PYTHON_USEDEP}]
			)
		)
		(
			>dev-python/pandas-1.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/pandas-2.2.0[${PYTHON_USEDEP}]
			)
		)
		(
			>dev-python/scikit-learn-0.22.1[${PYTHON_USEDEP}]
			strict? (
				<dev-python/scikit-learn-1.4.0[${PYTHON_USEDEP}]
			)
		)
		!strict? (
			dev-python/psutil[${PYTHON_USEDEP}]
		)
		strict? (
			<dev-python/psutil-5.9.6[${PYTHON_USEDEP}]
		)
		>=dev-python/coverage-7.3.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.4.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-4.1.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-random-order-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-rerunfailures-12.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-timeout-2.1.0[${PYTHON_USEDEP}]
		dev-python/fastapi[${PYTHON_USEDEP}]
		dev-python/uvicorn[${PYTHON_USEDEP}]
	')
	(
		>=sci-ml/onnxruntime-0.15.0[${PYTHON_SINGLE_USEDEP},python]
		strict? (
			<sci-ml/onnxruntime-1.17.0[${PYTHON_SINGLE_USEDEP},python]
		)
	)
	(
		>=sci-visualization/tensorboard-2.9.1[${PYTHON_SINGLE_USEDEP}]
		strict? (
			<sci-visualization/tensorboard-2.15.0[${PYTHON_SINGLE_USEDEP}]
		)
	)
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
		${PYTORCH_DOCS_BDEPEND}
	)
	test? (
		${PYTORCH_TEST_BDEPEND}
	)
	test-gpu? (
		${PYTORCH_STRATEGIES_BDEPEND}
	)
"

python_install() {
	distutils-r1_python_install
	# Prevent ebuild-package merge conflict
	rm -rf "${ED}/usr/lib/${EPYTHON}/site-packages/lightning_fabric"
}
