# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1 git-r3

DESCRIPTION="Video editing with Python"
HOMEPAGE="
https://zulko.github.io/moviepy/
https://github.com/Zulko/moviepy
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
"
SRC_URI="
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

src_unpack() {
	EGIT_REPO_URI="https://github.com/Zulko/moviepy.git"
	EGIT_BRANCH="master"
	if use fallback-commit ; then
		EGIT_COMMIT="99a9657ea411c81cdc88b9e9ef9bf8e4047a32d2"
	else
		EGIT_COMMIT="HEAD"
	fi
	git-r3_fetch
	git-r3_checkout
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
