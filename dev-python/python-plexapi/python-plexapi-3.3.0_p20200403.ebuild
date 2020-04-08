# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Python bindings for the Plex API."
HOMEPAGE="https://github.com/pkkid/python-plexapi"
LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86"
SLOT="0"
PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1
RDEPEND="dev-python/requests[${PYTHON_USEDEP}]
	 dev-python/tqdm[${PYTHON_USEDEP}]
	 dev-python/websocket-client[${PYTHON_USEDEP}]"
EGIT_COMMIT="807aaea5479816318a711b4ce25efed57f946ff6"
SRC_URI=\
"https://github.com/pkkid/python-plexapi/archive/${EGIT_COMMIT}.tar.gz \
	-> ${PN}-${PV}-${EGIT_COMMIT}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
