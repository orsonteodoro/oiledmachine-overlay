# Copyright 2024-2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="hatchling"
MY_PN="coqui-ai-Trainer"
PYTHON_COMPAT=( "python3_"{10..14} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${PV}"
SRC_URI="
https://github.com/idiap/coqui-ai-Trainer/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="🐸 - A general purpose model trainer, as flexible as it gets"
HOMEPAGE="
	https://github.com/idiap/coqui-ai-Trainer
	https://pypi.org/project/coqui-tts-trainer
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror test" # untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" aim clearml cpu cuda dev mlflow mypy test wandb"
REQUIRED_USE="
	test? (
		dev
	)
"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/coqpit-config-0.2.2[${PYTHON_USEDEP}]
		<dev-python/coqpit-config-0.3.0[${PYTHON_USEDEP}]

		>=dev-python/fsspec-2023.6.0[${PYTHON_USEDEP}]
		>=dev-python/packaging-21.0[${PYTHON_USEDEP}]
		>=dev-python/psutil-5[${PYTHON_USEDEP}]
		clearml? (
			>=sci-ml/clearml-2[${PYTHON_USEDEP}]
			>=dev-python/soundfile-0.12.0[${PYTHON_USEDEP}]
		)
		mlflow? (
			>=dev-python/mlflow-3.7[${PYTHON_USEDEP}]
			>=dev-python/soundfile-0.12.0[${PYTHON_USEDEP}]
		)
	')
	>=sci-visualization/tensorboard-2.17.1[${PYTHON_SINGLE_USEDEP}]
	cpu? (
		>=sci-ml/pytorch-2.2[${PYTHON_SINGLE_USEDEP}]
	)
	cuda? (
		>=sci-ml/pytorch-2.2[${PYTHON_SINGLE_USEDEP}]
	)
	aim? (
		$(python_gen_cond_dep '
			>=dev-python/aim-3.21[${PYTHON_USEDEP}]
		' python3_{10..12})
	)
	wandb? (
		>=dev-python/wandb-0.19[${PYTHON_SINGLE_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev? (
			>=dev-python/coverage-7[${PYTHON_USEDEP}]
			>=dev-python/pytest-8[${PYTHON_USEDEP}]
			~dev-util/ruff-0.14.7
		)
		test? (
			>=dev-python/matplotlib-3.10.5[${PYTHON_USEDEP}]
			virtual/numpy[${PYTHON_USEDEP}]
		)
		mypy? (
			~dev-python/mypy-1.19.1[${PYTHON_USEDEP}]
			>=dev-python/types-psutil-7.0.0.20250218[${PYTHON_USEDEP}]
		)
	')
	dev? (
		>=dev-python/pre-commit-3[${PYTHON_SINGLE_USEDEP}]
	)
	test? (
		>=dev-python/accelerate-1.0.0[${PYTHON_SINGLE_USEDEP}]
		>=dev-python/torchvision-0.17.0[${PYTHON_SINGLE_USEDEP}]
	)

"
DOCS=( "README.md" )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
