# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# deepspeed
# lai-sphinx-theme
# sphinx-multiproject
# sphinx-toolbox
# sphinxcontrib-mockautodoc
# sphinxcontrib-video
# torchmetrics				examples

DISTUTILS_USE_PEP517="setuptools"
DISTUTILS_SINGLE_IMPL=1
export PACKAGE_NAME="fabric"
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( "python3_"{10..11} )

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/pytorch-lightning-${PV}"
SRC_URI="
https://github.com/Lightning-AI/pytorch-lightning/archive/refs/tags/${PV}.tar.gz
	-> pytorch-lightning-${PV}.tar.gz
"

DESCRIPTION="Fabric is the fast and lightweight way to scale PyTorch models \
without boilerplate"
HOMEPAGE="
	https://github.com/Lightning-AI/pytorch-lightning
	https://pypi.org/project/lightning-fabric
"
LICENSE="Apache-2.0"
SLOT="0"
IUSE+=" doc examples -strict test test-gpu"
FABRIC_BASE_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/fsspec-2022.5.0[${PYTHON_USEDEP},http(+)]
			strict? (
				<dev-python/fsspec-2024.4.0[${PYTHON_USEDEP},http(+)]
			)
		)
		(
			>=sci-libs/lightning-utilities-0.8.0[${PYTHON_USEDEP}]
			strict? (
				<sci-libs/lightning-utilities-0.12.0[${PYTHON_USEDEP}]
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
			>=dev-python/typing-extensions-4.4.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/typing-extensions-4.10.0[${PYTHON_USEDEP}]
			)
		)
	')
	(
		>=sci-libs/pytorch-2.0.0[${PYTHON_SINGLE_USEDEP}]
		strict? (
			<sci-libs/pytorch-2.4.0[${PYTHON_SINGLE_USEDEP}]
		)
	)
"
FABRIC_EXAMPLES_RDEPEND="
	$(python_gen_cond_dep '
		(
			>=sci-libs/lightning-utilities-0.8.0[${PYTHON_USEDEP}]
			strict? (
				<sci-libs/lightning-utilities-0.12.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=sci-libs/torchmetrics-0.10.0[${PYTHON_USEDEP}]
			strict? (
				<sci-libs/torchmetrics-1.3.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=sci-libs/torchvision-0.15.0[${PYTHON_USEDEP}]
			strict? (
				<sci-libs/torchvision-0.19.0[${PYTHON_USEDEP}]
			)
		)
	')
"
RDEPEND+="
	${FABRIC_BASE_RDEPEND}
	examples? (
		${FABRIC_EXAMPLES_RDEPEND}
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
			>=sci-libs/lightning-utilities-0.11.1[${PYTHON_USEDEP}]
			strict? (
				<sci-libs/lightning-utilities-0.12.0[${PYTHON_USEDEP}]
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
			dev-python/jinja[${PYTHON_USEDEP}]
			dev-python/nbconvert[${PYTHON_USEDEP}]
		)
		strict? (
			<dev-python/jinja-3.2.0[${PYTHON_USEDEP}]
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
"
FABRIC_DOCS_BDEPEND="
	${DOCS_BDEPEND}
	sci-visualization/tensorboard[${PYTHON_SINGLE_USEDEP}]
"
FABRIC_STRATEGIES_BDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/bitsandbytes-0.42.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/bitsandbytes-0.43.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/deepspeed-0.8.2[${PYTHON_USEDEP}]
			strict? (
				<dev-python/deepspeed-0.9.4[${PYTHON_USEDEP}]
			)
		)
	')
"
FABRIC_TEST_BDEPEND="
	$(python_gen_cond_dep '
		(
			>=sci-visualization/tensorboardx-2.2[${PYTHON_USEDEP}]
			strict? (
				<sci-visualization/tensorboardx-2.7.0[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/torchmetrics-0.7.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/torchmetrics-1.3.0[${PYTHON_USEDEP}]
			)
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
		${FABRIC_DOCS_BDEPEND}
	)
	test? (
		${FABRIC_TEST_BDEPEND}
	)
	test-gpu? (
		${FABRIC_STRATEGIES_BDEPEND}
	)
"
