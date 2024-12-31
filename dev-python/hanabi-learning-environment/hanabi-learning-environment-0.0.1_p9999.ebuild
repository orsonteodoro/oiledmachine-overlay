# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{8..11} )

inherit distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_REPO_URI="https://github.com/deepmind/hanabi-learning-environment.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="HEAD"
	FALLBACK_COMMIT="54e79594f4b6fb40ebb3004289c6db0e34a8b5fb" # Aug 25, 2021
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="FIXME"
fi
S="${WORKDIR}/${P}"

DESCRIPTION="hanabi_learning_environment is a research platform for Hanabi experiments."
HOMEPAGE="
https://github.com/deepmind/hanabi-learning-environment
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror test"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" examples"
RDEPEND+="
	dev-python/cffi[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-build/cmake-2.8.11
	dev-build/ninja
	dev-python/scikit-build[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
"
DOCS=( "README.md" )

unpack_live() {
	use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
	git-r3_fetch
	git-r3_checkout
	local actual_pv=$(grep -r -e "version=" "${S}/setup.py" \
		| cut -f 2 -d "'")
	local expected_pv=$(ver_cut 1-3 ${PV})
	if [[ "${actual_pv}" != "${expected_pv}" ]] ; then
eerror
eerror "Version change detected that may alter *DEPENDs requirements"
eerror
eerror "Expected version:\t${expected_pv}"
eerror "Actual version:\t${actual_pv}"
eerror
eerror "Use the fallback-commit to continue."
eerror
		die
	fi
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		unpack_live
	else
		unpack ${A}
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
	if use examples ; then
		insinto "/usr/share/${PN}/examples"
		doins -r "examples/"*
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
