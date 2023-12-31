# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="A python wrapper for the pocket api"
HOMEPAGE="https://github.com/tapanpandita/pocket/"
LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
DEPEND+="
	dev-python/requests[${PYTHON_USEDEP}]
"
RDEPEND+="
	${DEPEND}
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
SRC_URI="
https://github.com/tapanpandita/pocket/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

distutils_enable_tests "nose"

# Pocket 0.3.7, Python 3.10
#test_pocket_init (test_pocket.PocketTest) ... ok
#test_pocket_init_payload (test_pocket.PocketTest) ... ok
#test_post_request (test_pocket.PocketTest) ... ok

#----------------------------------------------------------------------
#Ran 3 tests in 1.039s

#OK


# OILEDMACHINE-OVERLAY-META-REVDEP:  rainbowstream
