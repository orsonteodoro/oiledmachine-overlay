# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTEST_PV="3.2.2"
PYTHON_COMPAT=( "python3_"{8..11} )

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/Lemmons/pytest-raises/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

DESCRIPTION="An implementation of pytest.raises as a pytest.mark fixture "
HOMEPAGE="https://github.com/Lemmons/pytest-raises"
LICENSE="MIT"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
RDEPEND+="
	>=dev-python/pytest-${PYTEST_PV}[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pytest-${PYTEST_PV}[${PYTHON_USEDEP}]
		dev-python/codecov[${PYTHON_USEDEP}]
		dev-python/pylint[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests "pytest"

# OILEDMACHINE-OVERLAY-META-REVDEP:  exhale -> orphaned
# OILEDMACHINE-OVERLAY-META-TAGS:  orphaned
