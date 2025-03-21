# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="sonnet"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} ) # Upstream list up to 3.10

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_BRANCH="v2"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/google-deepmind/sonnet.git"
	FALLBACK_COMMIT="95d81587faf28d60fd074082a7bd8fdfdcfd850b" # Jan 2, 2024
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${PV}"
	SRC_URI="
https://github.com/google-deepmind/sonnet/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Sonnet is a library for building neural networks in TensorFlow."
HOMEPAGE="
	https://github.com/google-deepmind/sonnet
	https://pypi.org/project/dm-sonnet
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" doc examples test"
RDEPEND+="
	>=dev-python/absl-py-0.7.1[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.16.3[${PYTHON_USEDEP}]
	>=dev-python/tabulate-0.7.5[${PYTHON_USEDEP}]
	>=dev-python/wrapt-1.11.1[${PYTHON_USEDEP}]
	>=dev-python/dm-tree-0.1.1[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
TENSORFLOW_BDEPEND="
	>=sci-ml/tensorflow-2.12.0_rc0
	>=sci-ml/tensorflow-probability-0.12.2
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	doc? (
		${TENSORFLOW_BDEPEND}
		(
			>=dev-python/sphinxcontrib-bibtex-0.4.2[${PYTHON_USEDEP}]
			<dev-python/sphinxcontrib-bibtex-2[${PYTHON_USEDEP}]
		)
		>=dev-python/sphinx-2.0.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-rtd-theme-0.4.3[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-katex-0.4.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-autodoc-typehints-1.10.3[${PYTHON_USEDEP}]
	)
	test? (
		(
			>=sci-misc/tensorflow-datasets-1[${PYTHON_USEDEP}]
			<sci-misc/tensorflow-datasets-4[${PYTHON_USEDEP}]
		)
		${TENSORFLOW_BDEPEND}
		>=dev-python/mock-3.0.5[${PYTHON_USEDEP}]
		dev-python/docutils[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "__version__ = \"2.0.2\"" "${S}/sonnet/__init__.py" \
			|| die "QA:  Bump version"
	else
		unpack ${A}
	fi
}

python_install() {
	distutils-r1_python_install
	if use examples ; then
		dodir "/usr/share/${MY_PN}"
		mv \
			"${ED}/usr/lib/${EPYTHON}/site-packages/examples" \
			"${ED}/usr/share/${MY_PN}"
		rm -rf "${ED}/usr/share/${MY_PN}/examples/__pycache__"
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
