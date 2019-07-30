# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6,3_7} )

inherit distutils-r1

DESCRIPTION="Python bindings for the Plex API."
HOMEPAGE="https://github.com/pkkid/python-plexapi"
COMMIT="bd033a9f7e6ecaa48c1a293e9819e1cbd3e41752"
SRC_URI="https://github.com/pkkid/python-plexapi/archive/${COMMIT}.zip -> ${PN}-${COMMIT}.zip"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~arm ~arm64 ~ppc ~ppc64"
S="${WORKDIR}/${PN}-${COMMIT}"
