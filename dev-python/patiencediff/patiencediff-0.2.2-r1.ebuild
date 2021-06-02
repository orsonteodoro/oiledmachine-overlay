# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=bdepend
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Patiencediff implementation"
HOMEPAGE="https://github.com/breezy-team/patiencediff"
LICENSE="GPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
REQUIRED_USE=" ${PYTHON_REQUIRED_USE}"
SLOT="0/${PV}"
RDEPEND+=" ${PYTHON_DEPS}"
DEPEND+=" ${RDEPEND}"
BDEPEND+=" ${PYTHON_DEPS}"
SRC_URI="
https://github.com/breezy-team/patiencediff/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
