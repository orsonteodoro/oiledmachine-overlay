# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} ) # Up to 3.10 listed

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/huggingface/accelerate.git"
	FALLBACK_COMMIT="e6ee1337014f6f97c3cf58f806aa28a0109f09a5" # Mar 4, 2026
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/huggingface/accelerate/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Accelerate"
HOMEPAGE="
	https://github.com/huggingface/accelerate
	https://pypi.org/project/accelerate
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+="
deepspeed dev quality rich sagemaker test test-dev test-fp8 test-prod test-trackers
ebuild_revision_1
"
REQUIRED_USE+="
	test? (
		test-dev
		test-prod
	)
	dev? (
		quality
		rich
		test
	)
"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/numpy-1.17[${PYTHON_USEDEP}]
		>=dev-python/packaging-20.0[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		>=dev-python/safetensors-0.4.3[${PYTHON_USEDEP}]
		deepspeed? (
			dev-python/deepspeed[${PYTHON_USEDEP}]
		)
		quality? (
			>=dev-util/ruff-0.13.1
		)
		rich? (
			dev-python/rich[${PYTHON_USEDEP}]
		)
		sagemaker? (
			dev-python/sagemaker[${PYTHON_USEDEP}]
		)
	')
	>=dev-python/huggingface-hub-0.21.0[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/torch-2.0.0[${PYTHON_SINGLE_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		test-dev? (
			dev-python/datasets[${PYTHON_USEDEP}]
			dev-python/diffusers[${PYTHON_USEDEP}]
			dev-python/evaluate[${PYTHON_USEDEP}]
			>=dev-python/torchdata-0.8.0[${PYTHON_USEDEP}]
			>=dev-python/torchpippy-0.2.0[${PYTHON_USEDEP}]
			dev-python/transformers[${PYTHON_USEDEP}]
			dev-python/scipy[${PYTHON_USEDEP}]
			dev-python/scikit-learn[${PYTHON_USEDEP}]
			dev-python/tqdm[${PYTHON_USEDEP}]
			dev-python/bitsandbytes[${PYTHON_USEDEP}]
			dev-python/timm[${PYTHON_USEDEP}]
		)
		test-fp8? (
			dev-python/torchao
		)
		test-prod? (
			>=dev-python/pytest-7.2.0[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
			dev-python/pytest-subtests[${PYTHON_USEDEP}]
			dev-python/parameterized[${PYTHON_USEDEP}]
			dev-python/pytest-order[${PYTHON_USEDEP}]
		)
		test-trackers? (
			dev-python/wandb[${PYTHON_USEDEP}]
			dev-python/comet-ml[${PYTHON_USEDEP}]
			dev-python/tensorboard[${PYTHON_USEDEP}]
			dev-python/dvclive[${PYTHON_USEDEP}]
			dev-python/matplotlib[${PYTHON_USEDEP}]
			dev-python/swanlab[${PYTHON_USEDEP},dashboard]
			dev-python/trackio[${PYTHON_USEDEP}]
		)
	')
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
