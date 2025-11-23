# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit cython distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/mark9064/pyamdgpuinfo.git"
	FALLBACK_COMMIT="9299d4c4903c1f6f8f84968f8c4ee40de3235b3b" # Oct 11, 2023
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/mark9064/pyamdgpuinfo/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="AMD GPU stats"
HOMEPAGE="
	https://github.com/mark9064/pyamdgpuinfo
	https://pypi.org/project/pyamdgpuinfo
"
LICENSE="
	GPL-3
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
ebuild_revison_3
"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	=dev-python/cython-3*[${PYTHON_USEDEP}]
	dev-python/cython:=
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
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

python_configure() {
	local cython_slot=$(best_version "=dev-python/cython-3*" | sed -e "s|dev-python/cython-||g")
	cython_slot=$(ver_cut "1-2" "${cython_slot}")
	export CYTHON_SLOT="${cython_slot}"
	cython_python_configure
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
