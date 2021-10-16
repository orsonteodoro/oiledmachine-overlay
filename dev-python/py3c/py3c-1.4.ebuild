# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="A Python 2/3 compatibility layer for C extensions"
HOMEPAGE="https://github.com/encukou/py3c"
LICENSE="MIT doc? ( CC-BY-NC-SA-3.0 )"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/${PV}"
IUSE+=" doc"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
DEPEND+=" ${PYTHON_DEPS}"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" ${PYTHON_DEPS}
	doc? ( dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}] )"
SRC_URI="
https://github.com/encukou/py3c/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${P}"
RESTRICT="mirror"

distutils_enable_sphinx doc
