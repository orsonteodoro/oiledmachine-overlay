# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1
if [[ "${PV}" =~ "9999" ]] ; then
	inherit git-r3
else
	if [[ "${PV}" =~ "alpha" ]] ; then
		MY_PV="$(ver_cut 1-2 ${PV})-alpha.$(ver_cut 4 ${PV})"
	else
		MY_PV="${PV}"
	fi
	SRC_URI="
https://github.com/python-${PN}-tools/twitter/archive/refs/tags/${PN}-${MY_PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="An API and command-line toolset for Twitter (twitter.com)"
HOMEPAGE="
	https://mike.verdone.ca/twitter/
	https://github.com/python-twitter-tools/twitter/tree/master
"
LICENSE="MIT"
KEYWORDS="amd64 x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE="fallback-commit"
DEPEND+="
	dev-python/certifi[${PYTHON_USEDEP}]
"
RDEPEND+="
	${DEPEND}
"
RESTRICT="mirror"
PATCHES=(
	"${FILESDIR}/${PN}-9999-ansi-fix.patch"
)

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		EGIT_REPO_URI="https://github.com/python-twitter-tools/twitter.git"
		EGIT_BRANCH="master"
		if use fallback-commit ; then
			EGIT_COMMIT="8313dc57d0c44c9f88f92d46e9f9d7512e5cd9ca"
		else
			EGIT_COMMIT="HEAD"
		fi
		git-r3_fetch
		git-r3_checkout
		S="${WORKDIR}/${P}"
	else
		unpack ${A}
		S="${WORKDIR}/${PN}-${PN}-${MY_PV}"
	fi
}

# OILEDMACHINE-OVERLAY-META-REVDEP:  rainbowstream
