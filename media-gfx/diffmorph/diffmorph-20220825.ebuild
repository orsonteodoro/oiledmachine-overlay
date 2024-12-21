# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="DiffMorph"

FALLBACK_COMMIT="6f03bf3d6d8b9766134d10561f4354581fb9ffad" # Aug 22, 2022
PYTHON_COMPAT=( "python3_"{10..12} )

inherit python-r1

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/volotat/DiffMorph.git"
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${FALLBACK_COMMIT}"
	SRC_URI="
https://github.com/volotat/DiffMorph/archive/${FALLBACK_COMMIT}.tar.gz
	-> ${P}-${FALLBACK_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="Image morphing without reference points by applying warp maps and optimizing over them"
HOMEPAGE="
	https://github.com/volotat/DiffMorph
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
	>=dev-python/numpy-1.21.6[${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.64.0[${PYTHON_USEDEP}]
	>=media-libs/opencv-4.6.0.66[${PYTHON_USEDEP},ffmpeg?,gstreamer?,jpeg,python]
	>=sci-libs/tensorflow-2.9.1[${PYTHON_USEDEP}]
	>=sci-libs/tensorflow-addons-0.17.1[${PYTHON_USEDEP}]
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
	docinto "licenses"
	dodoc "LICENSE"
	python_foreach_impl python_newscript "morph.py" "morph"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
