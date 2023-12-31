# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_10 ) # Based on CI distro

inherit distutils-r1

if [[ "${PV}" =~ 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/Farama-Foundation/gym-notices.git"
	EGIT_BRANCH="main"
	inherit git-r3
	IUSE+=" fallback-commit"
else
	SRC_URI="
https://github.com/Farama-Foundation/gym-notices/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Gym Notices"
HOMEPAGE="
https://github.com/Farama-Foundation/gym-notices
"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
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
	use fallback-commit && EGIT_COMMIT="cce76d2982209020d437f384b5f8421f5418e3a4"
	git-r3_fetch
	git-r3_checkout
	grep -e "version=\"$(ver_cut 1-3 ${PV})\"" "${S}/setup.py" \
		|| die "QA:  Bump version"
}

src_unpack() {
	if [[ "${PV}" =~ 9999 ]] ; then
		unpack_live
	else
		unpack ${A}
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
