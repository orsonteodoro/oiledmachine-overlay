# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="An implementation of pytest.raises as a pytest.mark fixture "
HOMEPAGE="https://github.com/Lemmons/pytest-raises"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/${PV}"
PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1
RDEPEND=">=dev-python/pytest-3.2.2[${PYTHON_USEDEP}]"
DEPEND="dev-python/pylint[${PYTHON_USEDEP}]
	dev-python/pytest-cov[${PYTHON_USEDEP}]"
SRC_URI=\
"https://github.com/Lemmons/pytest-raises/archive/${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
