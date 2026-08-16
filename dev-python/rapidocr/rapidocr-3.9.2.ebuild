# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="RapidOCR"
MY_P="${MY_PN}-${PV}"

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..13} )

CHKL_TIMESTAMPS=(
	"media-libs/opencv-4.9999"
	"media-libs/opencv-5.9999"
)

inherit chkl secure-version distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="095232a4c94f7f0e6600ba5bba1177010ad696d4"
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_P}"
	EGIT_REPO_URI="https://github.com/RapidAI/RapidOCR.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	S="${WORKDIR}/${MY_P}/python"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_P}/python"
	SRC_URI="
https://github.com/RapidAI/RapidOCR/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Awesome OCR Library"
HOMEPAGE="
	https://github.com/RapidAI/RapidOCR
	https://pypi.org/project/rapidocr
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+=" "
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/pyclipper-1.2.0[${PYTHON_USEDEP}]

		>=virtual/numpy-1.19.5[${PYTHON_USEDEP}]
		<virtual/numpy-3.0.0[${PYTHON_USEDEP}]

		>=dev-python/six-1.15.0[${PYTHON_USEDEP}]

		>=dev-python/shapely-1.7.1[${PYTHON_USEDEP}]
		!~dev-python/shapely-2.0.4

		dev-python/pyyaml[${PYTHON_USEDEP}]
		virtual/pillow[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		!~dev-python/omegaconf-2.2.1
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/colorlog[${PYTHON_USEDEP}]
	')
	media-libs/opencv:=[${PYTHON_SINGLE_USEDEP},python]
	|| (
		~media-libs/opencv-${OPENCV4_PV}[${PYTHON_SINGLE_USEDEP},python]
		~media-libs/opencv-${OPENCV5_PV}[${PYTHON_SINGLE_USEDEP},python]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/setuptools-77[${PYTHON_USEDEP}]
		>=dev-python/setuptools-scm-8[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	')
"
DOCS=( "README.md" "README-CN.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

python_configure_all() {
	chkl_check_many_timestamps
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
