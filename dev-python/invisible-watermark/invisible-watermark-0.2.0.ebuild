# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
FALLBACK_COMMIT="85b10745cfa3849411af22375a847fba36d405ed" # Jul 6, 2023
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/ShieldMnt/invisible-watermark.git"
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${FALLBACK_COMMIT}"
	SRC_URI="
https://github.com/ShieldMnt/invisible-watermark/archive/${FALLBACK_COMMIT}.tar.gz
	-> ${P}-${FALLBACK_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="A Python library for invisible image watermark (blind image watermark)"
HOMEPAGE="
	https://github.com/ShieldMnt/invisible-watermark
	https://pypi.org/project/invisible-watermark
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" ffmpeg gstreamer"
REQUIRED_USE="
	|| (
		ffmpeg
		gstreamer
	)
"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/pywavelets-1.1.1[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.17.0[${PYTHON_USEDEP}]
		>=virtual/pillow-6.0.0[${PYTHON_USEDEP}]
	')
	>=media-libs/opencv-4.1.0.25[${PYTHON_SINGLE_USEDEP},ffmpeg?,gstreamer?,jpeg,png,python]
	dev-python/pytorch[${PYTHON_SINGLE_USEDEP}]
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
