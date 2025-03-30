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
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}-${PV}"
	EGIT_REPO_URI="https://github.com/google-deepmind/distrax.git"
	FALLBACK_COMMIT="1c4c6aa0ff31b5ab04f951ece3a5438b2c506ea6" # Nov 21, 2023
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="
https://github.com/google-deepmind/distrax/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi
S="${WORKDIR}/${PN}-${PV}"

DESCRIPTION="Distrax: Probability distributions in JAX."
HOMEPAGE="
	https://github.com/google-deepmind/distrax
	https://pypi.org/project/distrax
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" examples test"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/absl-py-0.9.0[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.23.0[${PYTHON_USEDEP}]
	')
	>=dev-python/chex-0.1.8[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/jax-0.1.55[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/jaxlib-0.1.67[${PYTHON_SINGLE_USEDEP}]
	>=sci-ml/tensorflow-probability-0.15.0[${PYTHON_SINGLE_USEDEP},jax]
	examples? (
		>=dev-python/dm-haiku-0.0.3[${PYTHON_SINGLE_USEDEP}]
		>=dev-python/optax-0.0.6[${PYTHON_SINGLE_USEDEP}]
		>=sci-ml/tensorflow-2.4.0[${PYTHON_SINGLE_USEDEP}]
		>=sci-ml/tensorflow-datasets-4.2.0[${PYTHON_SINGLE_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev-python/wheel[${PYTHON_USEDEP}]
		test? (
			>=dev-python/mock-4.0.3[${PYTHON_USEDEP}]
		)
	')
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
	' python3_12)
	test? (
		>=dev-python/dm-haiku-0.0.3[${PYTHON_SINGLE_USEDEP}]
	)
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "__version__ = \"0.1.5\"" "${S}/distrax/__init__.py" \
			|| die "QA:  Bump version"
	else
		unpack ${A}
	fi
}

python_install() {
	distutils-r1_python_install
	if use examples ; then
		dodir "/usr/share/${PN}"
		mv \
			"${ED}/usr/lib/${EPYTHON}/site-packages/examples" \
			"${ED}/usr/share/${PN}"
		rm -rf "${ED}/usr/share/${PN}/examples/__pycache__"
	else
		rm -rf "${ED}/usr/lib/${EPYTHON}/site-packages/examples"
	fi
	mv \
		"${ED}/usr/lib/${EPYTHON}/site-packages/requirements" \
		"${ED}/usr/lib/${EPYTHON}/site-packages/${PN}"
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
