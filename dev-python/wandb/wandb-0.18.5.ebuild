# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package (optional):
# hypothesis-fspaths
# lightning
# ray
# polars
# metaflow
# mlflow
# catboost
# stable_baselines3
# google-cloud-aiplatform
# pytest-split
# pytest-flakefinder

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
https://github.com/wandb/wandb/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="A CLI and library for interacting with the Weights & Biases API"
HOMEPAGE="
	https://github.com/wandb/wandb
	https://pypi.org/project/wandb
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev test"
REQUIRED_USE="
	dev? (
		test
	)
"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/click-7.1[${PYTHON_USEDEP}]
		>=dev-python/GitPython-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/requests-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/psutil-5.0.0[${PYTHON_USEDEP}]
		>=dev-python/sentry-sdk-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/docker-pycreds-0.4.0[${PYTHON_USEDEP}]
		>=dev-python/protobuf-3.19.0[${PYTHON_USEDEP}]
		dev-python/protobuf:=
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/setproctitle[${PYTHON_USEDEP}]
		dev-python/platformdirs[${PYTHON_USEDEP}]
	')
	$(python_gen_cond_dep '
		>=dev-python/typing-extensions-4.4[${PYTHON_USEDEP}]
	' python3_{10,11})
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev-python/hatchling[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	')
	dev? (
		$(python_gen_cond_dep '
			sci-ml/tensorflow[${PYTHON_SINGLE_USEDEP}]
		' python3_12)
		$(python_gen_cond_dep '
			<sci-ml/tensorflow-2.14[${PYTHON_SINGLE_USEDEP}]
		' python3_{10,11})
		$(python_gen_cond_dep '
			dev-python/hypothesis[${PYTHON_USEDEP}]
			dev-python/hypothesis-fspaths[${PYTHON_USEDEP}]

			virtual/pillow[${PYTHON_USEDEP}]
			dev-python/pandas[${PYTHON_USEDEP}]
			dev-python/polars[${PYTHON_USEDEP}]
			dev-python/moviepy[${PYTHON_USEDEP}]
			dev-python/imageio[${PYTHON_USEDEP},ffmpeg]
			dev-python/matplotlib[${PYTHON_USEDEP}]
			dev-python/soundfile[${PYTHON_USEDEP}]
			dev-python/rdkit[${PYTHON_USEDEP}]
			dev-python/plotly[${PYTHON_USEDEP}]
			dev-python/bokeh[${PYTHON_USEDEP}]

			dev-python/tqdm[${PYTHON_USEDEP}]

			dev-python/ipython[${PYTHON_USEDEP}]
			dev-python/ipykernel[${PYTHON_USEDEP}]
			dev-python/nbclient[${PYTHON_USEDEP}]

			dev-python/scikit-learn[${PYTHON_USEDEP}]

			dev-python/lightning[${PYTHON_USEDEP}]
			dev-python/ray[${PYTHON_USEDEP},air,tune]

			dev-python/fastcore[${PYTHON_USEDEP}]
			dev-python/pyarrow[${PYTHON_USEDEP}]
			dev-python/metaflow[${PYTHON_USEDEP}]
			dev-python/xgboost[${PYTHON_USEDEP}]
			dev-python/lightgbm[${PYTHON_USEDEP}]
			dev-python/mlflow[${PYTHON_USEDEP}]
			dev-python/urllib3[${PYTHON_USEDEP}]
			dev-python/docker[${PYTHON_USEDEP}]
			dev-python/catboost[${PYTHON_USEDEP}]
			dev-python/openai[${PYTHON_USEDEP}]
			<dev-python/gymnasium-1.0.0[${PYTHON_USEDEP}]
			dev-python/stable_baselines3[${PYTHON_USEDEP}]

			dev-python/responses[${PYTHON_USEDEP}]
			dev-python/prometheus-client[${PYTHON_USEDEP}]
			dev-python/google-cloud-aiplatform[${PYTHON_USEDEP}]
		')
		sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
		sci-ml/torchvision[${PYTHON_SINGLE_USEDEP}]
		dev-python/jax[${PYTHON_SINGLE_USEDEP},cpu]
	)
	test? (
		$(python_gen_cond_dep '
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pytest-asyncio[${PYTHON_USEDEP}]
			dev-python/pytest-cov[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
			dev-python/pytest-split[${PYTHON_USEDEP}]
			dev-python/pytest-mock[${PYTHON_USEDEP}]
			dev-python/pytest-timeout[${PYTHON_USEDEP}]
			dev-python/pytest-flakefinder[${PYTHON_USEDEP}]
			dev-python/pyfakefs[${PYTHON_USEDEP}]
			dev-python/parameterized[${PYTHON_USEDEP}]

			>dev-python/flask-2.0.0[${PYTHON_USEDEP}]
			dev-python/pandas[${PYTHON_USEDEP}]
			dev-python/responses[${PYTHON_USEDEP}]

			dev-python/coverage[${PYTHON_USEDEP},toml(+)]

			>=dev-python/pyte-0.8[${PYTHON_USEDEP}]
		')
	)
"
DOCS=( "CHANGELOG.md" "README.md" )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
