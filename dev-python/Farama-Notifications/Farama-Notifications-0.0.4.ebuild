# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_10 ) # Based on CI distro

inherit distutils-r1

if [[ "${PV}" =~ 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/Farama-Foundation/Farama-Notifications.git"
	EGIT_BRANCH="main"
	inherit git-r3
else
	SRC_URI="
https://github.com/Farama-Foundation/Farama-Notifications/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
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
S="${WORKDIR}/${P}"
RESTRICT="mirror"

unpack_live() {
	if use fallback-commit ; then
		EGIT_COMMIT="9596114567580db30c4d1735f540e84da480199a"
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
	if [[ "${PV}" =~ 9999 ]] ; then
		unpack_live
	else
		unpack ${A}
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
