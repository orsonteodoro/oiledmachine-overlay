# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{11..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Modules to convert numbers to words."
HOMEPAGE="https://github.com/savoirfairelinux/num2words"
LICENSE="MIT"
RESTRICT="test" # Untested
SLOT="0"
IUSE+=" test"
RDEPEND="
	>=dev-python/docopt-0.6.2[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		<dev-python/pep8-1.6[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/delegator[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/flake8-copyright[${PYTHON_USEDEP}]
		dev-python/isort[${PYTHON_USEDEP}]
		dev-python/tox[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests "pytest"
