# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-/_}"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_10" ) # 3.8 is upstream max tested

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Cadene/pretrained-models.pytorch.git"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	FALLBACK_COMMIT="8aae3d8f1135b6b13fed79c1d431e3449fdbf6e0" # Apr 16, 2020
	IUSE+=" fallback-commit"
else
	KEYWORDS="~amd64"
	EGIT_COMMIT="ac8682febf8533e7c009425407e84de7b8567109"
	S="${WORKDIR}/pretrained-models.pytorch-${EGIT_COMMIT}"
	SRC_URI="
https://github.com/Cadene/pretrained-models.pytorch/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}-gh-${EGIT_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="Pretrained Convolutional Neural Networks for PyTorch:  NASNet, ResNeXt, ResNet, InceptionV4, InceptionResnetV2, Xception, DPN, etc."
HOMEPAGE="
	https://github.com/Cadene/pretrained-models.pytorch
"
LICENSE="
	MIT
"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
RDEPEND+="
	$(python_gen_any_dep '
		sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
		sci-ml/torchvision[${PYTHON_SINGLE_USEDEP}]
	')
	dev-python/munch[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/wheel[${PYTHON_USEDEP}]
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "__version__ = '0.7.4'" "${S}/pretrainedmodels/version.py" \
			|| die "QA:  Bump version"
	else
		unpack ${A}
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE.txt"
	einstalldocs
}

distutils_enable_tests "pytest"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
