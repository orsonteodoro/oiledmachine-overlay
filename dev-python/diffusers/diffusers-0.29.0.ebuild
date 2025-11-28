# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# compel
# hf-doc-builder
# k-diffusion
# note_seq		*
# peft
# torchsde		*

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit abseil-cpp distutils-r1 protobuf pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/huggingface/diffusers.git"
	FALLBACK_COMMIT="39aa3909e8e2dfe30f4807aedaadf42c1d8b1a8f" # Jun 12, 2023
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/huggingface/diffusers/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="State-of-the-art diffusion in PyTorch and JAX."
HOMEPAGE="
	https://github.com/huggingface/diffusers
	https://pypi.org/project/diffusers
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
dev doc flax pytorch quality test training
ebuild_revision_2
"
REQUIRED_USE="
	dev? (
		doc
		flax
		quality
		pytorch
		test
		training
	)
"
# The protobuf requirement is relaxed
RDEPEND+="
	$(python_gen_cond_dep '
		!~dev-python/regex-2019.12.17[${PYTHON_USEDEP}]
		>=dev-python/python-3.8.0[${PYTHON_USEDEP}]
		>=sci-ml/safetensors-0.3.1[${PYTHON_USEDEP}]
		dev-python/filelock[${PYTHON_USEDEP}]
		dev-python/importlib-metadata[${PYTHON_USEDEP}]
		dev-python/note_seq[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		virtual/pillow[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		sci-ml/onnx[${PYTHON_USEDEP}]
		training? (
			>=dev-python/peft-0.6.0[${PYTHON_USEDEP}]
			dev-python/jinja2[${PYTHON_USEDEP}]
			|| (
				dev-python/protobuf:3.12[${PYTHON_USEDEP}]
				dev-python/protobuf:4.21[${PYTHON_USEDEP}]
			)
			dev-python/protobuf:=
		)
	')
	>=sci-ml/huggingface_hub-0.23.2[${PYTHON_SINGLE_USEDEP}]
	flax? (
		>=dev-python/flax-0.4.1[${PYTHON_SINGLE_USEDEP}]
		>=dev-python/jax-0.4.1[${PYTHON_SINGLE_USEDEP}]
		>=dev-python/jaxlib-0.4.1[${PYTHON_SINGLE_USEDEP}]
	)
	pytorch? (
		>=sci-ml/pytorch-1.4[${PYTHON_SINGLE_USEDEP}]
		dev-python/torchsde[${PYTHON_SINGLE_USEDEP}]
	)
	pytorch? (
		>=sci-ml/accelerate-0.29.3[${PYTHON_SINGLE_USEDEP}]
	)
	training? (
		>=sci-ml/accelerate-0.29.3[${PYTHON_SINGLE_USEDEP}]
		dev-python/datasets[${PYTHON_SINGLE_USEDEP}]
		sci-visualization/tensorboard[${PYTHON_SINGLE_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
		quality? (
			<dev-python/urllib3-2.0.1[${PYTHON_USEDEP}]
			>=dev-python/hf-doc-builder-0.3.0[${PYTHON_USEDEP}]
			>=dev-python/isort-5.5.4[${PYTHON_USEDEP}]
			>=dev-util/ruff-0.1.5
			dev-python/black[${PYTHON_USEDEP}]
		)
		doc? (
			>=dev-python/hf-doc-builder-0.3.0[${PYTHON_USEDEP}]
		)
		test? (
			(
				>=sci-ml/sentencepiece-0.1.91[${PYTHON_USEDEP}]
				!~sci-ml/sentencepiece-0.1.92[${PYTHON_USEDEP}]
			)
			<dev-python/GitPython-3.1.19[${PYTHON_USEDEP}]
			>=dev-python/compel-0.1.8[${PYTHON_USEDEP}]
			>=dev-python/requests-mock-1.10.0[${PYTHON_USEDEP}]
			>=sci-ml/safetensors-0.3.1[${PYTHON_USEDEP}]
			dev-python/datasets[${PYTHON_USEDEP}]
			dev-python/jinja2[${PYTHON_USEDEP}]
			dev-python/librosa[${PYTHON_USEDEP}]
			dev-python/parameterized[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pytest-timeout[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
			dev-python/scipy[${PYTHON_USEDEP}]
		)
	')
	test? (
		>=dev-python/invisible-watermark-0.2.0[${PYTHON_SINGLE_USEDEP}]
		>=dev-python/k-diffusion-0.0.12[${PYTHON_SINGLE_USEDEP}]
		>=sci-ml/transformers-4.25.1[${PYTHON_SINGLE_USEDEP}]
		sci-ml/torchvision[${PYTHON_SINGLE_USEDEP}]
	)
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "version=\"0.29.0\"," "${S}/setup.py" \
			|| die "QA:  Bump version"
	else
		unpack ${A}
	fi
}

python_configure() {
	if has_version "dev-libs/protobuf:" ; then
		ABSEIL_CPP_SLOT="20200225"
		PROTOBUF_CPP_SLOT="3"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_3[@]}" )
	elif has_version "dev-libs/protobuf:" ; then
		ABSEIL_CPP_SLOT="20220623"
		PROTOBUF_CPP_SLOT="3"
		PROTOBUF_PYTHON_SLOTS=( "${PROTOBUF_PYTHON_SLOTS_4_WITH_PROTOBUF_CPP_3[@]}" )
	fi
	abseil-cpp_python_configure
	protobuf_python_configure
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
