# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1 git-r3

DESCRIPTION="Gymnasium Notices"
HOMEPAGE="
https://github.com/Farama-Foundation/gymnasium-notices
"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" fallback-commit"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
"
DEPEND+="
	${PYTHON_DEPS}
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	>=dev-python/setuptools-42[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
"
SRC_URI="
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

src_unpack() {
	EGIT_REPO_URI="https://github.com/Farama-Foundation/gymnasium-notices.git"
	EGIT_BRANCH="main"
	if use fallback-commit ; then
		EGIT_COMMIT="77cf9f6a40dc10e81d3df32ba92f3554a4d5a24d"
	else
		EGIT_COMMIT="HEAD"
	fi
	git-r3_fetch
	git-r3_checkout
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
