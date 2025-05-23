# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{8..11} )

inherit distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_BRANCH="master"
	EGIT_COMMIT="HEAD"
	EGIT_REPO_URI=""
	FALLBACK_COMMIT="5a144438cc89bfc0ec94db960718ccf1f76468c1" # Oct 24, 2018
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="
https://github.com/tapanpandita/pocket/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi
S="${WORKDIR}/${P}"

DESCRIPTION="A Python wrapper for the Pocket API"
HOMEPAGE="https://github.com/tapanpandita/pocket/"
LICENSE="BSD"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
RDEPEND+="
	dev-python/requests[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
#		>=dev-python/distribute-0.7.3[${PYTHON_USEDEP}] # Removed in HEAD
BDEPEND+="
	test? (
		>=dev-python/coverage-3.7.1[${PYTHON_USEDEP}]
		>=dev-python/mock-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/nose-1.3.0[${PYTHON_USEDEP}]
		>=dev-python/requests-2.1.0[${PYTHON_USEDEP}]
	)
"

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

# Pocket 0.3.7, Python 3.10
#test_pocket_init (test_pocket.PocketTest) ... ok
#test_pocket_init_payload (test_pocket.PocketTest) ... ok
#test_post_request (test_pocket.PocketTest) ... ok

#----------------------------------------------------------------------
#Ran 3 tests in 1.039s

#OK


# OILEDMACHINE-OVERLAY-META-REVDEP:  rainbowstream
