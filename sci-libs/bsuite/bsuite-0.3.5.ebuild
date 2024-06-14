# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# baselines
# dm-sonnet
# dopamine-rl
# plotnine
# trfl

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} ) # Upstream only tests up to 3.7

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/google-deepmind/bsuite.git"
	FALLBACK_COMMIT="a07485f497b72669f1058639fa806b6127c4c6a9" # Feb 18, 2021
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/google-deepmind/bsuite/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="bsuite is a collection of carefully-designed experiments that \
investigate core capabilities of a reinforcement learning (RL) agent "
HOMEPAGE="
	https://github.com/google-deepmind/bsuite
	https://pypi.org/project/bsuite
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" baselines-jax baselines-tensorflow baselines-third-party test"
RDEPEND+="
	dev-python/absl-py[${PYTHON_USEDEP}]
	dev-python/immutabledict[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/plotnine[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/scikit-image[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/termcolor[${PYTHON_USEDEP}]
	sci-libs/dm_env[${PYTHON_USEDEP}]
	baselines-tensorflow? (
		dev-python/tqdm[${PYTHON_USEDEP}]
		sci-libs/dm-sonnet[${PYTHON_USEDEP}]
		sci-libs/dm-tree[${PYTHON_USEDEP}]
		sci-libs/tensorflow[${PYTHON_USEDEP}]
		sci-libs/tensorflow-probability[${PYTHON_USEDEP}]
		sci-libs/trfl[${PYTHON_USEDEP}]
	)
	baselines-jax? (
		dev-python/dataclasses[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		sci-libs/dm-haiku[${PYTHON_USEDEP}]
		sci-libs/dm-tree[${PYTHON_USEDEP}]
		sci-libs/jax[${PYTHON_USEDEP}]
		sci-libs/jaxlib[${PYTHON_USEDEP}]
		sci-libs/optax[${PYTHON_USEDEP}]
		sci-libs/rlax[${PYTHON_USEDEP}]
	)
	baselines-third-party? (
		>=sci-libs/tensorflow-1.15[${PYTHON_USEDEP}]
		sci-libs/dopamine-rl[${PYTHON_USEDEP}]
		sci-libs/baselines[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	test? (
		>=sci-libs/gym-0.20.0[${PYTHON_USEDEP}]
		>=sci-libs/tensorflow-probability-0.14.1[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/pytype[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "__version__ = '0.3.5'" "${S}/bsuite/_metadata.py" \
			|| die "QA:  Bump version"
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
