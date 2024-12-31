# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-/_}"

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..11} )

inherit distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_REPO_URI="https://github.com/jax-ml/ml_dtypes.git"
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_PN}-${PV}"
	FALLBACK_COMMIT="5b9fc9ad978757654843f4a8d899715dbea30e88" # Jun 6, 2023
	inherit git-r3
else
	EGIT_EIGEN_COMMIT="7bf2968fed5f246c0589e1111004cb420fcd7c71" # Mar 7, 2023
	KEYWORDS="~amd64"
	SRC_URI="
https://github.com/jax-ml/ml_dtypes/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
https://gitlab.com/libeigen/eigen/-/archive/${EGIT_EIGEN_COMMIT}/eigen-${EGIT_EIGEN_COMMIT}.tar.bz2
	"
fi
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="A stand-alone implementation of several NumPy dtype extensions \
used in machine learning."
HOMEPAGE="https://github.com/jax-ml/ml_dtypes"
LICENSE="
	Apache-2.0
	MPL-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test ebuild_revision_1"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/numpy-1.21.2[${PYTHON_USEDEP}]
	' python3_10)
	$(python_gen_cond_dep '
		>=dev-python/numpy-1.23.3[${PYTHON_USEDEP}]
	' python3_11)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/pybind11-2.10.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools-67.6.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pylint-2.6.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-6.2.5[${PYTHON_USEDEP}]
		dev-python/absl-py[${PYTHON_USEDEP}]
		dev-python/pyink[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
"
DOCS=( "CHANGELOG.md" "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "__version__ = '$(ver_cut 1-3 ${PV})'" "${S}/ml_dtypes/__init__.py" \
			|| die "QA:  Bump version"
	else
		unpack ${A}
		rm -rf "${S}/eigen"
		rm -rf "${S}/third_party/eigen"
		ln -s \
			"${WORKDIR}/eigen-${EGIT_EIGEN_COMMIT}" \
			"${S}/eigen" \
			|| die
		ln -s \
			"${WORKDIR}/eigen-${EGIT_EIGEN_COMMIT}" \
			"${S}/third_party/eigen" \
			|| die
		cd "${WORKDIR}/eigen-${EGIT_EIGEN_COMMIT}" || die
		eapply "${FILESDIR}/eigen-7bf2968-fix-relicense-print.patch"
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE" "LICENSE.eigen"
}

distutils_enable_tests "pytest"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
