# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
inherit distutils-r1

DESCRIPTION="Python bindings for the Plex API."
HOMEPAGE="https://github.com/pkkid/python-plexapi"
LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86"
SLOT="0"
DEPEND+=" dev-python/requests[${PYTHON_USEDEP}]"
RDEPEND+=" ${DEPEND}"
SRC_URI=\
"https://github.com/pkkid/python-plexapi/archive/${PV}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
