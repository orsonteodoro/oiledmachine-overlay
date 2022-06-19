# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )
inherit distutils-r1

DESCRIPTION="Python module for parsing messages from the 'js8' command line decoder"
HOMEPAGE="https://github.com/jketterl/js8py"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/${PV}"
IUSE+=" "
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
RDEPEND+=" ${PYTHON_DEPS}"
DEPEND+=" ${RDEPEND}"
BDEPEND+=" ${PYTHON_DEPS}"
SRC_URI="
https://github.com/jketterl/js8py/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
DOCS=( LICENSE README.md )
