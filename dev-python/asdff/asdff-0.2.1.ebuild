# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="pdm-backend"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/Bing-su/asdff.git"
	FALLBACK_COMMIT="a934f413e487d6cf86dd24598a3d6f2dc3c246d5" # Jan 25, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/Bing-su/asdff/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Adetailer Stable Diffusion diFFusers pipeline"
HOMEPAGE="
	https://github.com/Bing-su/asdff
	https://pypi.org/project/asdff
"
LICENSE="
	AGPL-3
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" dev test"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/diffusers-0.19.0[${PYTHON_USEDEP},pytorch]
	')
	>=sci-ml/transformers-4.25.1[${PYTHON_SINGLE_USEDEP}]
	dev-python/ultralytics[${PYTHON_SINGLE_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev? (
		$(python_gen_cond_dep '
			>=dev-python/black-23.9.1[${PYTHON_USEDEP}]
			>=dev-python/ipykernel-6.25.2[${PYTHON_USEDEP}]
			>=dev-python/ipywidgets-8.1.1[${PYTHON_USEDEP}]
		')
		>=dev-vcs/pre-commit-3.4.0[${PYTHON_SINGLE_USEDEP}]
		dev-util/ruff
	)
	test? (
		$(python_gen_cond_dep '
			>=dev-python/pytest-7.4.0[${PYTHON_USEDEP}]
		')
	)
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
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
