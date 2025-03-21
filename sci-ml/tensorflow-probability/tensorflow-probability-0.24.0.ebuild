# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-/_}"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/tensorflow/probability.git"
	FALLBACK_COMMIT="4a8f74cb950b99bb108485c6f08adf1eb6dc4fa2" # Feb 27, 2023
	S="${WORKDIR}/${P}"
	inherit git-r3
	PDEPEND+="
		jax? (
			dev-python/jax[${PYTHON_USEDEP}]
			dev-python/jaxlib[${PYTHON_USEDEP}]
		)
		tensorflow? (
			=sci-ml/tensorflow-9999[${PYTHON_USEDEP}]
			=dev-python/tf-keras-9999[${PYTHON_USEDEP}]
		)
		tfds? (
			=sci-misc/tensorflow-datasets-9999[${PYTHON_USEDEP}]
		)
	"
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/probability-${PV}"
	SRC_URI="
https://github.com/tensorflow/probability/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
	PDEPEND+="
		jax? (
			dev-python/jax[${PYTHON_USEDEP}]
			dev-python/jaxlib[${PYTHON_USEDEP}]
		)
		tensorflow? (
			>=sci-ml/tensorflow-2.16[${PYTHON_USEDEP}]
			>=dev-python/tf-keras-2.16[${PYTHON_USEDEP}]
		)
		tfds? (
			>=sci-misc/tensorflow-datasets-2.2.0[${PYTHON_USEDEP}]
		)
	"
fi

DESCRIPTION="Probabilistic reasoning and statistical analysis in TensorFlow"
HOMEPAGE="
	https://github.com/tensorflow/probability
	https://pypi.org/project/tensorflow-probability
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" jax tensorflow tfds"
RDEPEND+="
	>=dev-python/cloudpickle-1.3[${PYTHON_USEDEP}]
	>=dev-python/gast-0.3.2[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.13.3[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	dev-python/absl-py[${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/dm-tree[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "_MAJOR_VERSION = '0'" "${S}/tensorflow_probability/python/version.py" || die "QA:  Bump version"
		grep -q -e "_MINOR_VERSION = '24'" "${S}/tensorflow_probability/python/version.py" || die "QA:  Bump version"
		grep -q -e "_PATCH_VERSION = '0'" "${S}/tensorflow_probability/python/version.py" || die "QA:  Bump version"
	else
		unpack ${A}
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}
