# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="Universal-NCNN-upscaler-python"
MY_PV="${PV//./-}"
DISTUTILS_USE_PEP517="pdm-backend"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/TNTwise/Universal-NCNN-upscaler-python.git"
	FALLBACK_COMMIT="7e88aba5717509020dece7d280e5d64318f5b732" # 2024-10-09
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
	SRC_URI="
https://github.com/TNTwise/Universal-NCNN-upscaler-python/archive/refs/tags/${MY_PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Python Binding for *-ncnn-vulkan with PyBind11"
HOMEPAGE="
	https://github.com/TNTwise/Universal-NCNN-upscaler-python
"
LICENSE="
	GPL-3
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
RDEPEND+="
	media-libs/opencv[${PYTHON_USEDEP},python]
	virtual/pillow[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
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
