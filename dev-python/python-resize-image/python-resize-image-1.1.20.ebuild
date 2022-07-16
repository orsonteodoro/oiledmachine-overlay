# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="A Small python package to easily resize images"
HOMEPAGE="https://github.com/VingtCinq/python-resize-image"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
SLOT="0/${PV}"
IUSE+=" "
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
DEPEND+=" ${PYTHON_DEPS}"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	${PYTHON_DEPS}
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
