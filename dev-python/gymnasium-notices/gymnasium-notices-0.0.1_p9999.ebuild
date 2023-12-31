# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

if [[ "${PV}" =~ 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/Farama-Foundation/gymnasium-notices.git"
	EGIT_BRANCH="main"
	inherit git-r3
fi

DESCRIPTION="Gymnasium Notices"
HOMEPAGE="
https://github.com/Farama-Foundation/gymnasium-notices
"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" fallback-commit"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-42[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
"
SRC_URI="
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

unpack_live() {
	if use fallback-commit ; then
		EGIT_COMMIT="77cf9f6a40dc10e81d3df32ba92f3554a4d5a24d"
	fi
	git-r3_fetch
	git-r3_checkout
	local actual_pv=$(grep -r -e "version=" "${S}/setup.py" \
		| cut -f 2 -d '"')
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
	unpack_live
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
