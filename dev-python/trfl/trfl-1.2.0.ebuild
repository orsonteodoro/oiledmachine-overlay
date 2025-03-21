# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} ) # Upstream listed up to 3.7

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/google-deepmind/trfl.git"
	FALLBACK_COMMIT="ed6eff5b79ed56923bcb102e152c01ea52451d4c" # Aug 16, 2021
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	EGIT_COMMIT="ed6eff5b79ed56923bcb102e152c01ea52451d4c" # Aug 16, 2021
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
	SRC_URI="
https://github.com/google-deepmind/trfl/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}-gh-${EGIT_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="trfl is a library of building blocks for reinforcement learning \
algorithms."
HOMEPAGE="
	https://github.com/google-deepmind/trfl
	https://pypi.org/project/trfl
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" cuda tensorflow test"
RDEPEND+="
	dev-python/absl-py[${PYTHON_USEDEP}]
	dev-python/dm-tree[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/wrapt[${PYTHON_USEDEP}]
	tensorflow? (
		>=sci-ml/tensorflow-1.15[${PYTHON_USEDEP},cuda?]
		>=sci-ml/tensorflow-probability-0.8[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "version='1.2.0'," "${S}/setup.py" \
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
