# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-/_}"

DISTUTILS_USE_PEP517="setuptools"
DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="The official Python client for the Huggingface Hub"
HOMEPAGE="
	https://github.com/huggingface/huggingface_hub
	https://pypi.org/project/huggingface-hub
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" cli fastai hf-transfer inference pytorch quality tensorflow tensorflow-testing test typing"
REQUIRED_USE="
	test? (
		cli
		inference
	)
"
# Missing in safetensors:
PYTORCH_DEPENDS="
	$(python_gen_cond_dep '
		>=dev-python/numpy-1.21.6[${PYTHON_USEDEP}]
	')
	>=sci-ml/pytorch-1.10[${PYTHON_SINGLE_USEDEP}]
"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/fsspec-2023.5.0[${PYTHON_USEDEP}]
		>=dev-python/packaging-20.9[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-5.1[${PYTHON_USEDEP}]
		>=dev-python/tqdm-4.42.1[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-3.7.4.3[${PYTHON_USEDEP}]
		dev-python/filelock[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		cli? (
			>=dev-python/inquirerpy-0.3.4[${PYTHON_USEDEP}]
		)
		fastai? (
			>=dev-python/fastai-2.4[${PYTHON_USEDEP}]
			>=dev-python/fastcore-1.3.27[${PYTHON_USEDEP}]
			dev-python/toml[${PYTHON_USEDEP}]
		)
		hf-transfer? (
			>=dev-python/hf-transfer-0.1.4[${PYTHON_USEDEP}]
		)
		inference? (
			dev-python/aiohttp[${PYTHON_USEDEP}]
		)
		quality? (
			>=dev-python/libcst-1.4.0[${PYTHON_USEDEP}]
			>=dev-python/mypy-1.5.1[${PYTHON_USEDEP}]
			>=dev-util/ruff-0.9.0
		)
		tensorflow? (
			dev-python/graphviz[${PYTHON_USEDEP}]
			dev-python/pydot[${PYTHON_USEDEP}]
			dev-python/tensorflow[${PYTHON_USEDEP}]
		)
	')
	pytorch? (
		${PYTORCH_DEPENDS}
		$(python_gen_cond_dep '
			dev-python/safetensors[${PYTHON_USEDEP},torch(+)]
		')
		dev-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		tensorflow-testing? (
			<dev-python/keras-3.0[${PYTHON_USEDEP}]
			dev-python/tensorflow[${PYTHON_USEDEP}]
		)
		test? (
			>=dev-python/gradio-4.0.0[${PYTHON_USEDEP}]
			>=dev-python/pytest-8.1.1[${PYTHON_USEDEP}]
			<dev-python/urllib3-2.0[${PYTHON_USEDEP}]
			dev-python/fastapi[${PYTHON_USEDEP}]
			dev-python/jedi[${PYTHON_USEDEP}]
			dev-python/jinja2[${PYTHON_USEDEP}]
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/pillow[${PYTHON_USEDEP}]
			dev-python/pytest-asyncio[${PYTHON_USEDEP}]
			dev-python/pytest-cov[${PYTHON_USEDEP}]
			dev-python/pytest-env[${PYTHON_USEDEP}]
			dev-python/pytest-mock[${PYTHON_USEDEP}]
			dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
			dev-python/pytest-vcr[${PYTHON_USEDEP}]
			dev-python/soundfile[${PYTHON_USEDEP}]
		)
		typing? (
			>=dev-python/typing-extensions-4.8.0[${PYTHON_USEDEP}]
			dev-python/types-pyyaml[${PYTHON_USEDEP}]
			dev-python/types-requests[${PYTHON_USEDEP}]
			dev-python/types-simplejson[${PYTHON_USEDEP}]
			dev-python/types-toml[${PYTHON_USEDEP}]
			dev-python/types-tqdm[${PYTHON_USEDEP}]
			dev-python/types-urllib3[${PYTHON_USEDEP}]
		)
	')
"
DOCS=( "README.md" )

src_unpack() {
	unpack ${A}
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
