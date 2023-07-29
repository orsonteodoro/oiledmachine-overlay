# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="dm-haiku"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_10 ) # Upstream only tests up to 3.9
inherit distutils-r1

DESCRIPTION="JAX-based neural network library"
HOMEPAGE="
https://dm-haiku.readthedocs.io/
https://github.com/deepmind/dm-haiku
"
LICENSE="
	Apache-2.0
"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc jax test"
RDEPEND+="
	>=dev-python/absl-py-0.7.1[${PYTHON_USEDEP}]
	>=dev-python/jmp-0.0.2[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.18.0[${PYTHON_USEDEP}]
	>=dev-python/tabulate-0.8.9[${PYTHON_USEDEP}]
	jax? (
		>=dev-python/jax-0.4.13[${PYTHON_USEDEP}]
		>=dev-python/jaxlib-0.4.13[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${DEPEND}
"
BDEPEND+="
	doc? (
		>=dev-python/absl-py-0.15.0[${PYTHON_USEDEP}]
		>=dev-python/alabaster-0.7.12[${PYTHON_USEDEP}]
		>=dev-python/attrs-21.2.0[${PYTHON_USEDEP}]
		>=dev-python/Babel-2.9.1[${PYTHON_USEDEP}]
		>=dev-python/backcall-0.2.0[${PYTHON_USEDEP}]
		>=dev-python/bleach-4.1.0[${PYTHON_USEDEP}]
		>=dev-python/certifi-2021.10.8[${PYTHON_USEDEP}]
		>=dev-python/charset-normalizer-2.0.7[${PYTHON_USEDEP}]
		>=dev-python/cycler-0.11.0[${PYTHON_USEDEP}]
		>=dev-python/decorator-5.1.0[${PYTHON_USEDEP}]
		>=dev-python/defusedxml-0.7.1[${PYTHON_USEDEP}]
		>=dev-python/docutils-0.17.1[${PYTHON_USEDEP}]
		>=dev-python/entrypoints-0.3[${PYTHON_USEDEP}]
		>=dev-python/flatbuffers-2.0[${PYTHON_USEDEP}]
		>=dev-python/idna-3.3[${PYTHON_USEDEP}]
		>=dev-python/imagesize-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/importlib-resources-5.9.0[${PYTHON_USEDEP}]
		>=dev-python/ipykernel-5.3.4[${PYTHON_USEDEP}]
		>=dev-python/ipython-7.16.1[${PYTHON_USEDEP}]
		>=dev-python/ipython-genutils-0.2.0[${PYTHON_USEDEP}]
		>=dev-python/jax-0.3.16[${PYTHON_USEDEP}]
		>=dev-python/jaxlib-0.3.15[${PYTHON_USEDEP}]
		>=dev-python/jedi-0.18.0[${PYTHON_USEDEP}]
		>=dev-python/jinja2-2.11.3[${PYTHON_USEDEP}]
		>=dev-python/jmp-0.0.2[${PYTHON_USEDEP}]
		>=dev-python/jq-1.1.1[${PYTHON_USEDEP}]
		>=dev-python/jsonschema-4.1.2[${PYTHON_USEDEP}]
		>=dev-python/jupyter-client-7.0.6[${PYTHON_USEDEP}]
		>=dev-python/jupyter-core-4.9.1[${PYTHON_USEDEP}]
		>=dev-python/jupyterlab-pygments-0.1.2[${PYTHON_USEDEP}]
		>=dev-python/kiwisolver-1.3.2[${PYTHON_USEDEP}]
		>=dev-python/latexcodec-2.0.1[${PYTHON_USEDEP}]
		>=dev-python/markupsafe-2.0.1[${PYTHON_USEDEP}]
		>=dev-python/matplotlib-3.3.3[${PYTHON_USEDEP}]
		>=dev-python/mistune-0.8.4[${PYTHON_USEDEP}]
		>=dev-python/nbclient-0.5.4[${PYTHON_USEDEP}]
		>=dev-python/nbconvert-6.2.0[${PYTHON_USEDEP}]
		>=dev-python/nbformat-5.1.3[${PYTHON_USEDEP}]
		>=dev-python/nbsphinx-0.8.9[${PYTHON_USEDEP}]
		>=dev-python/nest-asyncio-1.5.1[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.21.3[${PYTHON_USEDEP}]
		>=dev-python/opt-einsum-3.3.0[${PYTHON_USEDEP}]
		>=dev-python/oset-0.1.3[${PYTHON_USEDEP}]
		>=dev-python/packaging-21.2[${PYTHON_USEDEP}]
		>=dev-python/pandas-1.3.4[${PYTHON_USEDEP}]
		>=dev-python/pandoc-1.0.2[${PYTHON_USEDEP}]
		>=dev-python/pandocfilters-1.5.0[${PYTHON_USEDEP}]
		>=dev-python/parso-0.8.2[${PYTHON_USEDEP}]
		>=dev-python/pexpect-4.8.0[${PYTHON_USEDEP}]
		>=dev-python/pickleshare-0.7.5[${PYTHON_USEDEP}]
		>=dev-python/pillow-9.0.0[${PYTHON_USEDEP}]
		>=dev-python/ply-3.11[${PYTHON_USEDEP}]
		>=dev-python/prompt-toolkit-3.0.21[${PYTHON_USEDEP}]
		>=dev-python/ptyprocess-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/pybtex-0.24.0[${PYTHON_USEDEP}]
		>=dev-python/pybtex-docutils-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/pygments-2.7.4[${PYTHON_USEDEP}]
		>=dev-python/pyparsing-2.4.7[${PYTHON_USEDEP}]
		>=dev-python/pyrsistent-0.18.0[${PYTHON_USEDEP}]
		>=dev-python/python-dateutil-2.8.2[${PYTHON_USEDEP}]
		>=dev-python/pytz-2021.3[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-6.0[${PYTHON_USEDEP}]
		>=dev-python/pyzmq-22.3.0[${PYTHON_USEDEP}]
		>=dev-python/requests-2.26.0[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.7.1[${PYTHON_USEDEP}]
		>=dev-python/seaborn-0.11.1[${PYTHON_USEDEP}]
		>=dev-python/six-1.16.0[${PYTHON_USEDEP}]
		>=dev-python/snowballstemmer-2.1.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-4.5.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-autodoc-typehints-1.11.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-book-theme-0.3.3[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-applehelp-1.0.2[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-bibtex-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-devhelp-1.0.2[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-htmlhelp-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-jsmath-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-katex-0.8.6[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-qthelp-1.0.3[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-serializinghtml-1.1.5[${PYTHON_USEDEP}]
		>=dev-python/tabulate-0.8.9[${PYTHON_USEDEP}]
		>=dev-python/testpath-0.5.0[${PYTHON_USEDEP}]
		>=dev-python/tornado-6.1[${PYTHON_USEDEP}]
		>=dev-python/traitlets-5.1.1[${PYTHON_USEDEP}]
		>=dev-python/urllib3-1.26.7[${PYTHON_USEDEP}]
		>=dev-python/wcwidth-0.2.5[${PYTHON_USEDEP}]
		>=dev-python/webencodings-0.5.1[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/chex-0.0.4[${PYTHON_USEDEP}]
		>=dev-python/cloudpickle-1.2.2[${PYTHON_USEDEP}]
		>=dev-python/mock-3.0.5[${PYTHON_USEDEP}]
		>=dev-python/dm-tree-0.1.1[${PYTHON_USEDEP}]
		>=dev-python/optax-0.0.1[${PYTHON_USEDEP}]
		>=sci-libs/tensorflow-2.9.1[${PYTHON_USEDEP},python]
		dev-python/dill[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
	)
"
SRC_URI="
https://github.com/deepmind/dm-haiku/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="mirror"
DOCS=( README.md )
PATCHES=(
)

distutils_enable_sphinx "docs"
distutils_enable_tests "pytest"

src_unpack() {
	unpack ${A}
}

src_install() {
	distutils-r1_src_install
	docinto licenses
	dodoc LICENSE
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  UNTESTED
