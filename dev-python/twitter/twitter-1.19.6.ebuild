# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="An API and command-line toolset for Twitter (twitter.com)"
HOMEPAGE="
	https://mike.verdone.ca/twitter/
	https://github.com/python-twitter-tools/twitter/tree/master
"
LICENSE="MIT"
KEYWORDS="amd64 x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
"
DEPEND+="
	${PYTHON_DEPS}
	dev-python/certifi[${PYTHON_USEDEP}]
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
RESTRICT="mirror"
PATCHES=( "${FILESDIR}/${PN}-9999-ansi-fix.patch" )

# OILEDMACHINE-OVERLAY-META-REVDEP:  rainbowstream
