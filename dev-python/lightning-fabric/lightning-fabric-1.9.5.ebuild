# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# deepspeed
# sphinx-multiproject
# sphinx-toolbox
# sphinxcontrib-mockautodoc

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
export PACKAGE_NAME="fabric"
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( "python3_10" )

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
			>=dev-python/numpy-1.17.2[${PYTHON_USEDEP}]
			strict? (
				<dev-python/numpy-1.24.2[${PYTHON_USEDEP}]
			)
		)
		(
			>=dev-python/packaging-17.1[${PYTHON_USEDEP}]
			strict? (
				<dev-python/packaging-23.0.1[${PYTHON_USEDEP}]
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
"
FABRIC_EXAMPLES_RDEPEND="
	(
		>=sci-ml/torchmetrics-0.10.0[${PYTHON_SINGLE_USEDEP}]
		strict? (
			<sci-ml/torchmetrics-0.12.0[${PYTHON_SINGLE_USEDEP}]
		)
	)
	(
		>=sci-ml/torchvision-0.10.0[${PYTHON_SINGLE_USEDEP}]
		strict? (
			<sci-ml/torchvision-0.15.2[${PYTHON_SINGLE_USEDEP}]
		)
	)
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
FABRIC_STRATEGIES_BDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/deepspeed-0.6.0[${PYTHON_USEDEP}]
			strict? (
				<dev-python/deepspeed-0.8.1[${PYTHON_USEDEP}]
			)
		)
	')
"
FABRIC_TEST_BDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/click-8.1.3[${PYTHON_USEDEP}]
		>=dev-python/codecov-2.1.12[${PYTHON_USEDEP}]
		>=dev-python/coverage-6.5.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-7.2.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-4.0.0[${PYTHON_USEDEP}]
	')
	(
		>=sci-visualization/tensorboardx-2.2[${PYTHON_SINGLE_USEDEP}]
		strict? (
			<sci-visualization/tensorboardx-2.5.2[${PYTHON_SINGLE_USEDEP}]
		)
	)
	>=dev-vcs/pre-commit-2.20.0[${PYTHON_SINGLE_USEDEP}]
"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	')
	test? (
		${FABRIC_TEST_BDEPEND}
	)
	test-gpu? (
		${FABRIC_STRATEGIES_BDEPEND}
	)
"
