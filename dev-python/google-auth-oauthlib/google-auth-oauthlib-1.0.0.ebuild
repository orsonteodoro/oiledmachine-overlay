# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# asyncmock
# gcp-sphinx-docfx-yaml

MY_P="google-auth-library-python-oauthlib-${PV}"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..11} )

inherit distutils-r1

KEYWORDS="~amd64 ~x86"
SRC_URI="
https://github.com/googleapis/google-auth-library-python-oauthlib/archive/v${PV}.tar.gz
	-> ${MY_P}.gh.tar.gz
"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="oauthlib integration for the Google Auth library"
HOMEPAGE="
	https://github.com/googleapis/google-auth-library-python-oauthlib/
	https://pypi.org/project/google-auth-oauthlib/
"
LICENSE="Apache-2.0"
RESTRICT="test" # Not tested
SLOT="0"
IUSE+=" doc test tool"
RDEPEND="
	>=dev-python/google-auth-2.15.0[${PYTHON_USEDEP}]
	>=dev-python/requests-oauthlib-0.7.0[${PYTHON_USEDEP}]
	tool? (
		>=dev-python/click-6.0.0[${PYTHON_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
"

BDEPEND="
	!=dev-python/grpcio-1.52.0_rc1
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/sphinx-4.0.1[${PYTHON_USEDEP}]
		dev-python/alabaster[${PYTHON_USEDEP}]
		dev-python/recommonmark[${PYTHON_USEDEP}]
		test? (
			dev-python/docutils[${PYTHON_USEDEP}]
			dev-python/gcp-sphinx-docfx-yaml[${PYTHON_USEDEP}]
			dev-python/pygments[${PYTHON_USEDEP}]
		)
	)
	test? (
		>=dev-python/black-22.3.0[${PYTHON_USEDEP}]
		>=dev-python/flake8-6.1.0[${PYTHON_USEDEP}]
		>=dev-python/isort-5.10.1[${PYTHON_USEDEP}]
		dev-python/asyncmock[${PYTHON_USEDEP}]
		dev-python/click[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/google-cloud-testutils[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nox[${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx "docs"
distutils_enable_tests "pytest"
