# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="google-auth-library-python-oauthlib-${PV}"

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1

SRC_URI="
https://github.com/googleapis/google-auth-library-python-oauthlib/archive/v${PV}.tar.gz
	-> ${MY_P}.gh.tar.gz
"

DESCRIPTION="Google Authentication Library"
HOMEPAGE="
	https://github.com/googleapis/google-auth-library-python-oauthlib/
	https://pypi.org/project/google-auth-oauthlib/
"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RDEPEND="
	>=dev-python/click-6.0.0[${PYTHON_USEDEP}]
	>=dev-python/google-auth-2.15.0[${PYTHON_USEDEP}]
	>=dev-python/requests-oauthlib-0.7.0[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"
S="${WORKDIR}/${MY_P}"

distutils_enable_tests "pytest"
