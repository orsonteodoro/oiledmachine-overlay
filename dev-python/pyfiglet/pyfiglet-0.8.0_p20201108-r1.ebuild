# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="An implementation of figlet written in Python"
HOMEPAGE="https://github.com/pwaller/pyfiglet"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
RDEPEND+=" ${PYTHON_DEPS}"
DEPEND+=" ${RDEPEND}"
BDEPEND+="
	${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]"
EGIT_COMMIT="7a45881472ed08cb193e88b02e88301f7074a9e5"
SRC_URI="
https://github.com/pwaller/pyfiglet/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}.tar.gz"
RESTRICT="mirror"
