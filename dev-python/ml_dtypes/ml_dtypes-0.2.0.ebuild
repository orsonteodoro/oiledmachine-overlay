# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-/_}"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{10,11} )

inherit distutils-r1

if [[ "${PV}" =~ 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jax-ml/ml_dtypes.git"
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_PN}-${PV}"
	IUSE+=" fallback-commit"
else
	EGIT_EIGEN_COMMIT="7bf2968fed5f246c0589e1111004cb420fcd7c71"
	SRC_URI="
https://github.com/jax-ml/ml_dtypes/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
https://gitlab.com/libeigen/eigen/-/archive/${EGIT_EIGEN_COMMIT}/eigen-${EGIT_EIGEN_COMMIT}.tar.bz2
	"
fi

DESCRIPTION="A stand-alone implementation of several NumPy dtype extensions \
used in machine learning."
HOMEPAGE="https://github.com/jax-ml/ml_dtypes"
LICENSE="
	Apache-2.0
	MPL-2.0
"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
DEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/numpy-1.21.2[${PYTHON_USEDEP}]
	' python3_10)
	$(python_gen_cond_dep '
		>=dev-python/numpy-1.23.3[${PYTHON_USEDEP}]
	' python3_11)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-67.6.0[${PYTHON_USEDEP}]
	>=dev-python/pybind11-2.10.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pylint-2.6.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-6.2.5[${PYTHON_USEDEP}]
		dev-python/absl-py[${PYTHON_USEDEP}]
		dev-python/pyink[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
"
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="mirror"
DOCS=( CHANGELOG.md README.md )

src_unpack() {
	if [[ "${PV}" =~ 9999 ]] ; then
		use fallback-commit && EGIT_COMMIT="5b9fc9ad978757654843f4a8d899715dbea30e88"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "__version__ = '$(ver_cut 1-3 ${PV})'" "${S}/ml_dtypes/__init__.py" \
			|| die "QA:  Bump version"
	else
		unpack ${A}
		rm -rf "${S}/eigen"
		rm -rf "${S}/third_party/eigen"
		ln -s "${WORKDIR}/eigen-${EGIT_EIGEN_COMMIT}" \
			"${S}/eigen" \
			|| die
		ln -s "${WORKDIR}/eigen-${EGIT_EIGEN_COMMIT}" \
			"${S}/third_party/eigen" \
			|| die
		cd "${WORKDIR}/eigen-${EGIT_EIGEN_COMMIT}" || die
		eapply "${FILESDIR}/eigen-7bf2968-fix-relicense-print.patch"
	fi
}

src_install() {
	distutils-r1_src_install
	docinto licenses
	dodoc LICENSE LICENSE.eigen
}

distutils_enable_tests "pytest"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
