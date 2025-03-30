# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See https://github.com/google/orbax/blob/main/.github/workflows/build.yml for supported python

# TODO package:
# google-cloud-logging
# myst-nb

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="flit"
PROTOBUF_PV="5.26.1"
PYTHON_COMPAT=( "python3_"{10,11} ) # Upstream only tests up to 3.11.

inherit distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	inherit git-r3
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/google/orbax.git"
	FALLBACK_COMMIT="33a814de0a1df3b46ad174d2373a85a5afa0151b" # May 17, 2024
	IUSE+=" fallback-commit"
else
	KEYWORDS="~amd64"
	SRC_URI="
https://github.com/google/orbax/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi
S="${WORKDIR}/${P}/export"

DESCRIPTION="Orbax is a library providing common utilities for JAX users."
HOMEPAGE="
https://github.com/google/orbax
https://pypi.org/project/orbax
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror test"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
doc tensorflow test
"
REQUIRED_USE="
	doc? (
		tensorflow
	)
"
ORBAX_EXPORT_DEPEND="
	$(python_gen_cond_dep '
		dev-python/absl-py[${PYTHON_USEDEP}]
		dev-python/dataclasses-json[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
	')
	dev-python/etils[${PYTHON_SINGLE_USEDEP}]
	dev-python/jax[${PYTHON_SINGLE_USEDEP}]
	dev-python/jaxlib[${PYTHON_SINGLE_USEDEP}]
	dev-python/jaxtyping[${PYTHON_SINGLE_USEDEP}]
	dev-python/orbax-checkpoint[${PYTHON_SINGLE_USEDEP}]
"
RDEPEND+="
	${ORBAX_EXPORT_DEPEND}
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		(
			>=dev-python/flit-core-3.5[${PYTHON_USEDEP}]
			<dev-python/flit-core-4[${PYTHON_USEDEP}]
		)
		doc? (
			>=dev-python/docutils-0.18.1[${PYTHON_USEDEP}]
			>=dev-python/sphinx-6.2.1[${PYTHON_USEDEP}]
			>=dev-python/sphinx-autodoc-typehints-1.11.1[${PYTHON_USEDEP}]
			>=dev-python/sphinxcontrib-applehelp-1.0.3[${PYTHON_USEDEP}]
			>=dev-python/sphinxcontrib-bibtex-2.4.2[${PYTHON_USEDEP}]
			>=dev-python/sphinxcontrib-devhelp-1.0.2[${PYTHON_USEDEP}]
			>=dev-python/sphinxcontrib-htmlhelp-2.0.1[${PYTHON_USEDEP}]
			>=dev-python/sphinxcontrib-katex-0.9.0[${PYTHON_USEDEP}]
			>=dev-python/sphinxcontrib-serializinghtml-1.1.5[${PYTHON_USEDEP}]
			>=dev-python/sphinxcontrib-qthelp-1.0.3[${PYTHON_USEDEP}]
			dev-python/sphinx-design[${PYTHON_USEDEP}]

			>=dev-python/ipython-7.23.1[${PYTHON_USEDEP}]
			>=dev-python/ipykernel-6.5.0[${PYTHON_USEDEP}]
			dev-python/cached-property[${PYTHON_USEDEP}]
			dev-python/importlib-resources[${PYTHON_USEDEP}]
			dev-python/myst-nb[${PYTHON_USEDEP}]
		)
		test? (
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
			dev-python/requests[${PYTHON_USEDEP}]
		)
	')
"
# Avoid circular depends with tensorflow \
PDEPEND+="
	tensorflow? (
		>=sci-ml/tensorflow-2.15.0[${PYTHON_SINGLE_USEDEP}]
	)
"
DOCS=( "CHANGELOG.md" "README.md" )

distutils_enable_sphinx "docs"

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if has "fallback-commit" ${IUSE_EFFECTIVE} ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
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
# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
# OILEDMACHINE-OVERLAY-TEST:  UNTESTED
