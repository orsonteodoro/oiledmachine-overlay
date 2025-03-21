# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# colossalai
# deepspeed
# fairscale
# hivemind
# horovod
# hydra-core
# jsonargparse
# omegaconf
# sphinx-multiproject
# sphinx-toolbox
# sphinxcontrib-mockautodoc

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
export PACKAGE_NAME="pytorch"
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( "python3_10" )

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
IUSE+=" doc examples extra -strict test test-gpu ui"
PYTORCH_BASE_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/numpy-1.17.2[${PYTHON_USEDEP}]
			strict? (
				<dev-python/numpy-1.24.2[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/pyyaml-5.4[${PYTHON_USEDEP}]
			strict? (
				<dev-python/pyyaml-6.0.1[${PYTHON_USEDEP}]
			)
		)
		(
			>dev-python/fsspec-2021.06.0[${PYTHON_USEDEP},http(+)]
			strict? (
				<dev-python/fsspec-2023.2.0[${PYTHON_USEDEP},http(+)]
			)
		)
		(
			>=dev-python/lightning-utilities-0.6.0_p0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/lightning-utilities-0.7.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/packaging-17.1[${PYTHON_USEDEP}]
			strict? (
				<dev-python/packaging-23.0.1[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/tqdm-4.57.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/tqdm-4.65.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/typing-extensions-4.0.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/typing-extensions-4.4.1[${PYTHON_USEDEP}]
			)
		)
	')
	(
		>=sci-ml/pytorch-1.10.0[${PYTHON_SINGLE_USEDEP}]
		strict? (
			<sci-ml/pytorch-2.0.1[${PYTHON_SINGLE_USEDEP}]
		)
	)
	(
		>=sci-libs/torchmetrics-0.7.0[${PYTHON_SINGLE_USEDEP}]
		strict? (
			<sci-libs/torchmetrics-0.12.0[${PYTHON_SINGLE_USEDEP}]
		)
	)
"
PYTORCH_EXAMPLES_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/gym-0.17.0[${PYTHON_USEDEP},classic_control(+)]
			strict? (
				<dev-python/gym-0.26.3[${PYTHON_USEDEP},classic_control(+)]
			)
		)
		strict? (
			<dev-python/ipython-8.7.1[${PYTHON_USEDEP},all(-)]
		)
	')
	(
		>=sci-libs/torchmetrics-0.10.0[${PYTHON_SINGLE_USEDEP}]
		strict? (
			<sci-libs/torchmetrics-0.12.0[${PYTHON_SINGLE_USEDEP}]
		)
	)
	(
		>=sci-libs/torchvision-0.11.1[${PYTHON_SINGLE_USEDEP}]
		strict? (
			<sci-libs/torchvision-0.15.2[${PYTHON_SINGLE_USEDEP}]
		)
	)
"
PYTORCH_EXTRA_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/hydra-core-1.0.5[${PYTHON_USEDEP}]
			strict? (
				<dev-python/hydra-core-1.4.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/jsonargparse-4.18.0[${PYTHON_USEDEP},signatures]
			strict? (
				<dev-python/jsonargparse-4.19.0[${PYTHON_USEDEP},signatures]
			)
		)
		(
			>dev-python/matplotlib-3.1[${PYTHON_USEDEP}]
			strict? (
				<dev-python/matplotlib-3.6.2[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/omegaconf-2.0.5[${PYTHON_USEDEP}]
			<dev-python/omegaconf-2.4.0[${PYTHON_USEDEP}]
		)
		(
			!~dev-python/rich-10.15.0a[${PYTHON_USEDEP}]
			!~dev-python/rich-10.15.0_alpha[${PYTHON_USEDEP}]
			>=dev-python/rich-10.14.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/rich-13.0.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=sci-visualization/tensorboardx-2.2[${PYTHON_USEDEP}]
			strict? (
				<sci-visualization/tensorboardx-2.5.2[${PYTHON_USEDEP}]
			)
		)
	')
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
		dev-python/nbformat[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/wcmatch[${PYTHON_USEDEP}]
	')
"
PYTORCH_STRATEGIES_BDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/colossalai-0.2.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/colossalai-0.2.5[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/deepspeed-0.6.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/deepspeed-0.8.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/fairscale-0.4.5[${PYTHON_USEDEP}]
			strict? (
				<dev-python/fairscale-0.4.13[${PYTHON_USEDEP}]
			)
		)
		(
			!~dev-python/horovod-0.24.0[${PYTHON_USEDEP}]
			>=dev-python/horovod-0.21.2[${PYTHON_USEDEP}]
			strict? (
				<dev-python/horovod-0.26.2[${PYTHON_USEDEP}]
			)
		)
		>=dev-python/hivemind-1.1.5[${PYTHON_USEDEP}]
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
			>dev-python/pandas-1.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/pandas-1.5.4[${PYTHON_USEDEP}]
			)
		)
		(
			>dev-python/scikit-learn-0.22.1[${PYTHON_USEDEP}]
			strict? (
				<dev-python/scikit-learn-1.2.1[${PYTHON_USEDEP}]
			)
		)
		(
			>=sci-visualization/tensorboard-2.9.1[${PYTHON_USEDEP}]
			strict? (
				<sci-visualization/tensorboard-2.12.0[${PYTHON_USEDEP}]
			)
		)
		!strict? (
			dev-python/fastapi[${PYTHON_USEDEP}]
			dev-python/onnx[${PYTHON_USEDEP}]
			>=dev-python/protobuf-3.20.2:0/3.21[${PYTHON_USEDEP}]
			dev-python/psutil[${PYTHON_USEDEP}]
			dev-python/uvicorn[${PYTHON_USEDEP}]
		)
		strict? (
			<dev-python/fastapi-0.87.0[${PYTHON_USEDEP}]
			<dev-python/onnx-1.14.0[${PYTHON_USEDEP}]
			<dev-python/protobuf-3.20.2:0/3.21[${PYTHON_USEDEP}]
			<dev-python/psutil-5.9.5[${PYTHON_USEDEP}]
			<dev-python/uvicorn-0.19.1[${PYTHON_USEDEP}]
		)
		>=dev-python/codecov-2.1.12[${PYTHON_USEDEP}]
		>=dev-python/coverage-6.5.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.2.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-4.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-forked-1.4.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-rerunfailures-10.3[${PYTHON_USEDEP}]
	')
	>=dev-vcs/pre-commit-2.20.0[${PYTHON_SINGLE_USEDEP}]
	!strict? (
		sci-libs/onnxruntime[${PYTHON_SINGLE_USEDEP},python]
	)
	strict? (
		<sci-libs/onnxruntime-1.14.0[${PYTHON_SINGLE_USEDEP},python]
	)
"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
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
