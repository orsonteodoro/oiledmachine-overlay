# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-/_}"

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} ) # Upstream list up to 3.7

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/google/gin-config.git"
	FALLBACK_COMMIT="a5d050f099e8f0255985648ecd5c1ca20d14c61f" # Nov 3, 2021
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	EGIT_COMMIT="a5d050f099e8f0255985648ecd5c1ca20d14c61f" # Nov 3, 2021
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
	SRC_URI="
https://github.com/google/gin-config/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}-gh-${EGIT_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="Gin-Config: A lightweight configuration library for Python"
HOMEPAGE="
	https://github.com/google/gin-config
	https://pypi.org/project/gin-config
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" cuda pytorch tensorflow test"
RDEPEND+="
	pytorch? (
		>=sci-ml/pytorch-1.3.0[${PYTHON_SINGLE_USEDEP}]
	)
	tensorflow? (
		>=sci-ml/tensorflow-1.13.0[${PYTHON_SINGLE_USEDEP},cuda?]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
		test? (
			>=dev-python/absl-py-0.1.6[${PYTHON_USEDEP}]
			>=dev-python/mock-3.0.5[${PYTHON_USEDEP}]
			dev-python/nose[${PYTHON_USEDEP}]
		)
	')
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "_VERSION = '0.5.0'" "${S}/setup.py" \
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
