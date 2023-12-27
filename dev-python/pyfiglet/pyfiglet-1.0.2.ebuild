# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )

if [[ "${PV}" =~ "9999" ]] ; then
	inherit git-r3
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/pwaller/pyfiglet.git"
	SRC_URI=""
else
	SRC_URI="
https://github.com/pwaller/pyfiglet/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

inherit distutils-r1

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
# U 22.04
BDEPEND+="
	dev-python/build[${PYTHON_USEDEP}]
	>=dev-python/setuptools-68.0.0[${PYTHON_USEDEP}]
	>=dev-python/wheel-0.37.1[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/subprocess32[${PYTHON_USEDEP}]
	)
"
PROPERTIES="live"
RESTRICT="mirror test" # test requires subprocess32 which is EOL
MY_PV="0.8.post1"

distutils_enable_tests "pytest"

live_unpack() {
	git-r3_fetch
	git-r3_checkout
	if ! grep -E -o -e "${MY_PV}" "${S}/pyfiglet/version.py" ; then
einfo
einfo "Bump the version in the ebuild."
einfo
		die
	fi
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		live_unpack
	else
		unpack ${A}
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

# OILEDMACHINE-OVERLAY-META-REVDEP:  rainbowstream
