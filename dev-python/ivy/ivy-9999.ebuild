# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# D10

# From a53af2b commit note:
# Apache-2.0 = Ivy
# transpiler = EULA

# Do not change the version until the stable is Apache-2.0.
# The 1.0.0.1 version is restrictive EULA.

# TODO package
# paddlepaddle
# pyvis

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="poetry"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/ivy-llc/ivy.git"
	FALLBACK_COMMIT="51a256a1bb4221f36da2c57302e1592da45b3a84" # Dec 6, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	#KEYWORDS="~amd64" # Ebuild needs test for download
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/ivy-llc/ivy/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Convert machine learning code between frameworks"
HOMEPAGE="
	https://github.com/ivy-llc/ivy
	https://pypi.org/project/ivy
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" cuda optional"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/cryptography-40.0.0[${PYTHON_USEDEP}]
		dev-python/astor[${PYTHON_USEDEP}]
		dev-python/dill[${PYTHON_USEDEP}]
		dev-python/einops[${PYTHON_USEDEP}]
		dev-python/gast[${PYTHON_USEDEP}]
		dev-python/networkx[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		dev-util/ruff
	')
	optional? (
		$(python_gen_cond_dep '
			>=dev-python/hypothesis-6.98.10[${PYTHON_USEDEP}]
			dev-python/astunparse[${PYTHON_USEDEP}]
			dev-python/autoflake[${PYTHON_USEDEP}]
			dev-python/black[${PYTHON_USEDEP}]
			dev-python/coverage[${PYTHON_USEDEP}]
			dev-python/dm-haiku[${PYTHON_USEDEP}]
			dev-python/flax[${PYTHON_USEDEP}]
			dev-python/h5py[${PYTHON_USEDEP}]
			dev-python/jax[${PYTHON_USEDEP}]
			dev-python/jaxlib[${PYTHON_USEDEP}]
			dev-python/matplotlib[${PYTHON_USEDEP}]
			dev-python/ml-dtypes[${PYTHON_USEDEP}]
			dev-python/networkx[${PYTHON_USEDEP}]
			dev-python/pynvml[${PYTHON_USEDEP}]
			dev-python/paddlepaddle[${PYTHON_USEDEP}]
			dev-python/pandas[${PYTHON_USEDEP}]
			dev-python/pydriller[${PYTHON_USEDEP}]
			dev-python/pymongo[${PYTHON_USEDEP}]
			dev-python/pyspark[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pyvis[${PYTHON_USEDEP}]
			dev-python/redis[${PYTHON_USEDEP}]
			dev-python/scikit-learn[${PYTHON_USEDEP}]
			dev-python/scipy[${PYTHON_USEDEP}]
			dev-python/snakeviz[${PYTHON_USEDEP}]
			dev-python/xgboost[${PYTHON_USEDEP}]
			media-libs/opencv[${PYTHON_USEDEP},python]
			sci-libs/tensorflow[${PYTHON_USEDEP}]
		')
		sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
		sci-ml/torchvision[${PYTHON_SINGLE_USEDEP}]
	)
	cuda? (
		$(python_gen_cond_dep '
			dev-python/autoflake[${PYTHON_USEDEP}]
			dev-python/coverage[${PYTHON_USEDEP}]
			dev-python/dm-haiku[${PYTHON_USEDEP}]
			dev-python/flax[${PYTHON_USEDEP}]
			dev-python/h5py[${PYTHON_USEDEP}]
			dev-python/hypothesis[${PYTHON_USEDEP}]
			dev-python/jax[${PYTHON_USEDEP},cuda]
			dev-python/jaxlib[${PYTHON_USEDEP},cuda]
			dev-python/matplotlib[${PYTHON_USEDEP}]
			dev-python/networkx[${PYTHON_USEDEP}]
			dev-python/pandas[${PYTHON_USEDEP}]
			dev-python/pydriller[${PYTHON_USEDEP}]
			dev-python/pymongo[${PYTHON_USEDEP}]
			dev-python/pyspark[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/redis[${PYTHON_USEDEP}]
			dev-python/scikit-learn[${PYTHON_USEDEP}]
			dev-python/scipy[${PYTHON_USEDEP}]
			dev-python/snakeviz[${PYTHON_USEDEP}]
			media-libs/opencv[${PYTHON_USEDEP},python]
			sci-libs/tensorflow[${PYTHON_USEDEP}]
		')
		sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
		sci-ml/torchvision[${PYTHON_SINGLE_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/setuptools-42[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
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

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
