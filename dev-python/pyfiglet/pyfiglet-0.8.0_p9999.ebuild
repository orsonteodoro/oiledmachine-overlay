# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1 git-r3

DESCRIPTION="An implementation of figlet written in Python"
HOMEPAGE="https://github.com/pwaller/pyfiglet"
LICENSE="MIT BSD"
# For font licensing, see https://github.com/pwaller/pyfiglet/issues/89
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE+=" minimal"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"
EGIT_BRANCH="master"
EGIT_REPO_URI="https://github.com/pwaller/pyfiglet.git"
SRC_URI=""
PROPERTIES="live"
RESTRICT="mirror test" # Unpacked dependency
MY_PV="0.8.post1"

src_unpack() {
	git-r3_fetch
	git-r3_checkout
	if ! grep -E -o -e "${MY_PV}" "${S}/pyfiglet/version.py" ; then
einfo
einfo "Bump the version in the ebuild."
einfo
		die
	fi
}

src_configure() {
	if use minimal ; then
		emake minimal
	else
		emake full
	fi
	distutils-r1_src_configure
}

distutils_enable_tests "pytest"

# OILEDMACHINE-OVERLAY-META-REVDEP:  rainbowstream
