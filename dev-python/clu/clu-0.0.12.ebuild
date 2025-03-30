# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/google/CommonLoopUtils.git"
	FALLBACK_COMMIT="d381738d31db53c7dd6e722f58dc76d187462df2" # Apr 9, 2024
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/CommonLoopUtils-${PV}"
	SRC_URI="
https://github.com/google/CommonLoopUtils/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A set of libraries for Machine Learning (ML) training loops in JAX"
HOMEPAGE="
	https://github.com/google/CommonLoopUtils
	https://pypi.org/project/clu
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
RDEPEND+="
	$(python_gen_cond_dep '
		dev-python/absl-py[${PYTHON_USEDEP}]
		dev-python/etils[${PYTHON_USEDEP},epath]
		dev-python/ml-collections[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
		dev-python/wrapt[${PYTHON_USEDEP}]
	')
	dev-python/flax[${PYTHON_SINGLE_USEDEP}]
	dev-python/jax[${PYTHON_SINGLE_USEDEP}]
	dev-python/jaxlib[${PYTHON_SINGLE_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
		test? (
			dev-python/pytest[${PYTHON_USEDEP}]
		)
	')
	test? (
		>=sci-ml/pytorch-2.0.0[${PYTHON_SINGLE_USEDEP}]
		sci-ml/tensorflow[${PYTHON_SINGLE_USEDEP}]
		sci-ml/tensorflow-datasets[${PYTHON_SINGLE_USEDEP}]
	)
"
DOCS=( "AUTHORS" "CHANGELOG.md" "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "version=\"0.0.12\"," "${S}/setup.py" \
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
