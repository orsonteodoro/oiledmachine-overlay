# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Automatic C++ library api documentation generation: breathe \
doxygen in and exhale it out. "
HOMEPAGE="https://github.com/svenevs/exhale"
LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/${PV}"
IUSE+=" doc test"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
# For test requirements, see https://github.com/svenevs/exhale/blob/v0.3.5/tox.ini
# For requirements, see
# https://github.com/svenevs/exhale/blob/v0.3.5/docs/requirements.txt
# https://github.com/svenevs/exhale/blob/v0.3.5/setup.cfg#L38
RDEPEND+=" ${PYTHON_DEPS}
	  dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
	>=dev-python/breathe-4.32[${PYTHON_USEDEP}]
	  dev-python/six[${PYTHON_USEDEP}]
        >=dev-python/lxml-4.6.4[${PYTHON_USEDEP}]
"
DEPEND+=" ${RDEPEND}"
BDEPEND+="  ${PYTHON_DEPS}
	doc? (
		  dev-python/docutils
		>=dev-python/sphinx-4.3.1[${PYTHON_USEDEP}]
		 <dev-python/sphinx-5[${PYTHON_USEDEP}]
		  dev-python/sphinx-issues[${PYTHON_USEDEP}]
		>=dev-python/sphinx_rtd_theme-1[${PYTHON_USEDEP}]
	)
	test? (
		  dev-python/ipdb[${PYTHON_USEDEP}]
		 <dev-python/jinja-3.1[${PYTHON_USEDEP}]
		  dev-python/pytest[${PYTHON_USEDEP}]
		  dev-python/pytest-cov[${PYTHON_USEDEP}]
		>=dev-python/pytest-raises-0.10[${PYTHON_USEDEP}]
	)
"
SRC_URI="
https://github.com/svenevs/exhale/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

# OILEDMACHINE-OVERLAY-META-TAGS:  orphaned
