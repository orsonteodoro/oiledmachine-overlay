# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-/_}"

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_PN}-${PV}"
	EGIT_REPO_URI="https://github.com/google-deepmind/rlax.git"
	FALLBACK_COMMIT="461b4cf9b4239d6b1b83aad6e5946f68d8402b93" # May 24, 2024
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="
https://github.com/google-deepmind/rlax/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="A library of reinforcement learning building blocks in JAX."
HOMEPAGE="
	https://github.com/google-deepmind/rlax
	https://pypi.org/project/rlax
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc examples test"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/absl-py-0.9.0[${PYTHON_USEDEP}]
		>=dev-python/chex-0.0.8[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.18.0[${PYTHON_USEDEP}]
		dev-python/dm-env[${PYTHON_USEDEP}]
		examples? (
			>=dev-python/dm-env-1.2[${PYTHON_USEDEP}]
		)
	')
	>=dev-python/distrax-0.0.2[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/jax-0.3.0[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/jaxlib-0.1.37[${PYTHON_SINGLE_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
		doc? (
			>=dev-python/docutils-0.16[${PYTHON_USEDEP}]
			>=dev-python/ipykernel-5.3.4[${PYTHON_USEDEP}]
			>=dev-python/ipython-7.16.3[${PYTHON_USEDEP}]
			>=dev-python/matplotlib-3.5.0[${PYTHON_USEDEP}]
			>=dev-python/myst_nb-0.13.1[${PYTHON_USEDEP}]
			>=dev-python/pandoc-1.0.2[${PYTHON_USEDEP}]
			>=dev-python/sphinx-4.5.0[${PYTHON_USEDEP}]
			>=dev-python/sphinx-book-theme-0.3.3[${PYTHON_USEDEP}]
			>=dev-python/sphinxcontrib-katex-0.9.0[${PYTHON_USEDEP}]
			>=dev-python/sphinxcontrib-bibtex-2.4.2[${PYTHON_USEDEP}]
			>=dev-python/sphinx-autodoc-typehints-1.11.1[${PYTHON_USEDEP}]
			<dev-python/jinja2-3.1[${PYTHON_USEDEP}]
		)
	')
	test? (
		>=dev-python/dm-haiku-0.0.4[${PYTHON_SINGLE_USEDEP}]
		>=dev-python/optax-0.0.9[${PYTHON_SINGLE_USEDEP}]
	)
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "__version__ = \"0.1.6\"" "${S}/rlax/__init__.py" \
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
	if use doc ; then
		dodir "/usr/share/doc/${P}"
		mv \
			"${ED}/usr/lib/${EPYTHON}/site-packages/docs" \
			"${ED}/usr/share/doc/${P}"
	else
		rm -rf "${ED}/usr/lib/${EPYTHON}/site-packages/docs"
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
