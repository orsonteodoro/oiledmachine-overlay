# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="An implementation of pytest.raises as a pytest.mark fixture "
HOMEPAGE="https://github.com/Lemmons/pytest-raises"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/${PV}"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
DEPEND+=" ${PYTHON_DEPS}
	>=dev-python/pytest-3.2.2[${PYTHON_USEDEP}]"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" ${PYTHON_DEPS}
	dev-python/pylint[${PYTHON_USEDEP}]
	dev-python/pytest-cov[${PYTHON_USEDEP}]"
SRC_URI="
https://github.com/Lemmons/pytest-raises/archive/${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
