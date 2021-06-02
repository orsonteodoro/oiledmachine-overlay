# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Automatic C++ library api documentation generation: breathe \
doxygen in and exhale it out. "
HOMEPAGE="https://github.com/svenevs/exhale"
LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/${PV}"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
RDEPEND+=" ${PYTHON_DEPS}
	  dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
	  dev-python/breathe[${PYTHON_USEDEP}]
	  dev-python/lxml[${PYTHON_USEDEP}]
	  dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/sphinx-1.6.1[${PYTHON_USEDEP}]"
DEPEND+=" ${RDEPEND}"
BDEPEND+="  ${PYTHON_DEPS}
	  dev-python/ipdb[${PYTHON_USEDEP}]
	  dev-python/pytest[${PYTHON_USEDEP}]
	  dev-python/pytest-cov[${PYTHON_USEDEP}]
	>=dev-python/pytest-raises-0.10[${PYTHON_USEDEP}]"
SRC_URI="
https://github.com/svenevs/exhale/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
PATCHES=( "${FILESDIR}/exhale-0.2.3-bs4-change.patch" )
