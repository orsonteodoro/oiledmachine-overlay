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
PYTHON_COMPAT=( "python3_"{11..13} )

inherit abseil-cpp distutils-r1 protobuf pypi

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
IUSE+="
aws azure dev gcp importers kubeflow launch media models perf sweeps test
workspaces
ebuild_revision_2
"
REQUIRED_USE="
	dev? (
		test
	)
"
RDEPEND+="
	$(python_gen_cond_dep '
		(
			|| (
				dev-python/protobuf:4.21[${PYTHON_USEDEP}]
				dev-python/protobuf:4.25[${PYTHON_USEDEP}]
				dev-python/protobuf:5.29[${PYTHON_USEDEP}]
				dev-python/protobuf:6.33[${PYTHON_USEDEP}]
			)
			dev-python/protobuf:=
			>=dev-python/protobuf-3.19.0[${PYTHON_USEDEP}]
			!=dev-python/protobuf-4.21.0
			!=dev-python/protobuf-5.28.0
			<dev-python/protobuf-7[${PYTHON_USEDEP}]
		)
		>=dev-python/click-7.1[${PYTHON_USEDEP}]
		>=dev-python/GitPython-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/requests-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/psutil-5.0.0[${PYTHON_USEDEP}]
		>=dev-python/sentry-sdk-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/docker-pycreds-0.4.0[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-4.4[${PYTHON_USEDEP}]
		<dev-python/pydantic-3[${PYTHON_USEDEP}]
		dev-python/protobuf:=
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/setproctitle[${PYTHON_USEDEP}]
		dev-python/platformdirs[${PYTHON_USEDEP}]
		aws? (
			>=dev-python/botocore-1.5.76[${PYTHON_USEDEP}]
			dev-python/boto3[${PYTHON_USEDEP}]
		)
		azure? (
			dev-python/azure-identity[${PYTHON_USEDEP}]
			dev-python/azure-storage-blob[${PYTHON_USEDEP}]
		)
		gcp? (
			dev-python/google-cloud-storage[${PYTHON_USEDEP}]
		)
		importers? (
			<=dev-python/polars-1.2.1[${PYTHON_USEDEP}]
			dev-python/filelock[${PYTHON_USEDEP}]
			dev-python/mlflow[${PYTHON_USEDEP}]
			dev-python/rich[${PYTHON_USEDEP}]
			dev-python/tenacity[${PYTHON_USEDEP}]
		)
		kubeflow? (
			dev-python/google-cloud-storage[${PYTHON_USEDEP}]
			dev-python/kubernetes[${PYTHON_USEDEP}]
			dev-python/minio[${PYTHON_USEDEP}]
			dev-python/sh[${PYTHON_USEDEP}]
		)
		launch? (
			>=dev-python/pyyaml-6.0.0[${PYTHON_USEDEP}]
			dev-python/awscli[${PYTHON_USEDEP}]
			dev-python/azure-containerregistry[${PYTHON_USEDEP}]
			dev-python/azure-identity[${PYTHON_USEDEP}]
			dev-python/azure-storage-blob[${PYTHON_USEDEP}]
			dev-python/chardet[${PYTHON_USEDEP}]
			dev-python/google-auth[${PYTHON_USEDEP}]
			dev-python/google-cloud-aiplatform[${PYTHON_USEDEP}]
			dev-python/google-cloud-artifact-registry[${PYTHON_USEDEP}]
			dev-python/google-cloud-compute[${PYTHON_USEDEP}]
			dev-python/google-cloud-storage[${PYTHON_USEDEP}]
			dev-python/iso8601[${PYTHON_USEDEP}]
			dev-python/jsonschema[${PYTHON_USEDEP}]
			dev-python/kubernetes[${PYTHON_USEDEP}]
			dev-python/kubernetes_asyncio[${PYTHON_USEDEP}]
			dev-python/nbconvert[${PYTHON_USEDEP}]
			dev-python/nbformat[${PYTHON_USEDEP}]
			dev-python/optuna[${PYTHON_USEDEP}]
			dev-python/pydantic[${PYTHON_USEDEP}]
			dev-python/tomli[${PYTHON_USEDEP}]
			dev-python/typing_extensions[${PYTHON_USEDEP}]
			dev-python/wandb[${PYTHON_USEDEP},aws]
		)
		media? (
			>=dev-python/moviepy-1.0.0[${PYTHON_USEDEP}]
			>=dev-python/plotly-5.18.0[${PYTHON_USEDEP}]
			dev-python/bokeh[${PYTHON_USEDEP}]
			dev-python/imageio[${PYTHON_USEDEP}]
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/pillow[${PYTHON_USEDEP}]
			dev-python/rdkit[${PYTHON_USEDEP}]
			dev-python/soundfile[${PYTHON_USEDEP}]
		)
		models? (
			dev-python/cloudpickle[${PYTHON_USEDEP}]
		)
		perf? (
			dev-python/orjson[${PYTHON_USEDEP}]
		)
		sweeps? (
			>=dev-python/sweeps-0.2.0[${PYTHON_USEDEP}]
		)
		workspaces? (
			dev-python/wandb-workspaces[${PYTHON_USEDEP}]
		)
	')
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
			>=dev-python/click-8.1[${PYTHON_USEDEP}]

			>=dev-python/filelock-3.13[${PYTHON_USEDEP}]
			>=dev-python/pydantic-2.9[${PYTHON_USEDEP}]

			virtual/pillow[${PYTHON_USEDEP}]
			dev-python/bokeh[${PYTHON_USEDEP}]
			dev-python/imageio[${PYTHON_USEDEP},ffmpeg]
			dev-python/matplotlib[${PYTHON_USEDEP}]
			dev-python/pandas[${PYTHON_USEDEP}]
			dev-python/plotly[${PYTHON_USEDEP}]
			dev-python/polars[${PYTHON_USEDEP}]
			dev-python/rdkit[${PYTHON_USEDEP}]
			dev-python/soundfile[${PYTHON_USEDEP}]

			dev-python/tenacity[${PYTHON_USEDEP}]
			dev-python/tqdm[${PYTHON_USEDEP}]

			>=dev-python/nbclient-0.10.1[${PYTHON_USEDEP}]
			dev-python/ipykernel[${PYTHON_USEDEP}]
			dev-python/ipython[${PYTHON_USEDEP}]

			dev-python/scikit-learn[${PYTHON_USEDEP}]

			dev-python/ray[${PYTHON_USEDEP},air,tune]

			>=dev-python/plum-dispatch-2.0.0[${PYTHON_USEDEP}]
			dev-python/docker[${PYTHON_USEDEP}]
			dev-python/catboost[${PYTHON_USEDEP}]
			dev-python/lightgbm[${PYTHON_USEDEP}]
			dev-python/metaflow[${PYTHON_USEDEP}]
			dev-python/mlflow[${PYTHON_USEDEP}]
			dev-python/openai[${PYTHON_USEDEP}]
			dev-python/pyarrow[${PYTHON_USEDEP}]
			dev-python/stable_baselines3[${PYTHON_USEDEP}]
			dev-python/urllib3[${PYTHON_USEDEP}]
			dev-python/xgboost[${PYTHON_USEDEP}]

			>=dev-python/requests-2.23[${PYTHON_USEDEP}]
			dev-python/google-cloud-aiplatform[${PYTHON_USEDEP}]
			dev-python/prometheus-client[${PYTHON_USEDEP}]
			dev-python/responses[${PYTHON_USEDEP}]

			>=dev-python/botocore-1.5.76[${PYTHON_USEDEP}]
			dev-python/boto3[${PYTHON_USEDEP}]

			>=dev-python/ariadne-codegen-0.14.0[${PYTHON_USEDEP}]
		')
		>=dev-python/moviepy-1.0.0[${PYTHON_SINGLE_USEDEP}]
		>=sci-ml/tensorflow-2.18.0[${PYTHON_SINGLE_USEDEP}]
		<dev-python/gymnasium-1.0.0[${PYTHON_SINGLE_USEDEP}]
		dev-python/jax[${PYTHON_SINGLE_USEDEP},cpu]
		dev-python/lightning[${PYTHON_SINGLE_USEDEP}]
		sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
		sci-ml/torchvision[${PYTHON_SINGLE_USEDEP}]
	)
	test? (
		$(python_gen_cond_dep '
			>=dev-python/parameterized-0.9.0[${PYTHON_USEDEP}]
			>=dev-python/pytest-8.3[${PYTHON_USEDEP}]
			>=dev-python/pytest-asyncio-0.25.3[${PYTHON_USEDEP}]
			>=dev-python/pytest-cov-6.0[${PYTHON_USEDEP}]
			>=dev-python/pytest-flakefinder-1.1[${PYTHON_USEDEP}]
			>=dev-python/pytest-memray-1.7[${PYTHON_USEDEP}]
			>=dev-python/pytest-mock-3.14[${PYTHON_USEDEP}]
			>=dev-python/pytest-split-0.10.0[${PYTHON_USEDEP}]
			>=dev-python/pytest-timeout-2.3[${PYTHON_USEDEP}]
			>=dev-python/pytest-xdist-3.6[${PYTHON_USEDEP}]
			>=dev-python/pyfakefs-5.7[${PYTHON_USEDEP}]

			>=dev-python/fastapi-0.115.3[${PYTHON_USEDEP}]
			>=dev-python/flask-2.2[${PYTHON_USEDEP}]
			>=dev-python/httpx-0.27.0[${PYTHON_USEDEP}]
			>=dev-python/responses-0.23.3[${PYTHON_USEDEP}]
			>=dev-python/uvicorn-0.32.0[${PYTHON_USEDEP}]

			>=dev-python/coverage-7.6[${PYTHON_USEDEP},toml]

			>=dev-python/pyte-0.8.1[${PYTHON_USEDEP}]

			>=dev-python/hypothesis-6.131.7[${PYTHON_USEDEP}]

			dev-python/hypothesis-fspaths[${PYTHON_USEDEP}]
		')
	)
"
DOCS=( "CHANGELOG.md" "README.md" )

python_configure() {
	if has_version "dev-libs/protobuf:3/3.21" ; then
		ABSEIL_CPP_SLOT="20220623"
		PROTOBUF_CPP_SLOT="3"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_3[@]}" )
	elif has_version "dev-libs/protobuf:4/4.25" ; then
		ABSEIL_CPP_SLOT="20240116"
		PROTOBUF_CPP_SLOT="4"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_4[@]}" )
	elif has_version "dev-libs/protobuf:5/5.29" ; then
		ABSEIL_CPP_SLOT="20240722"
		PROTOBUF_CPP_SLOT="5"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_5[@]}" )
	elif has_version "dev-libs/protobuf:6/6.33" ; then
		ABSEIL_CPP_SLOT="20250512"
		PROTOBUF_CPP_SLOT="6"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_6[@]}" )
	fi
	abseil-cpp_python_configure
	protobuf_python_configure
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
