# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="GLUI User Interface Library"
HOMEPAGE="http://www.cs.unc.edu/~rademach/glui/"
LICENSE="ZLIB"
SLOT="0/$(ver_cut 1-2 ${PV})"
KEYWORDS="~amd64 ~x86"
DEPEND+=" virtual/opengl[${MULTILIB_USEDEP}]
	  media-libs/freeglut[${MULTILIB_USEDEP}]"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" >=dev-util/cmake-2.8.11"
EGIT_COMMIT="093edc777c02118282910bdee59f8db1bd46a84d"
SRC_URI="
https://github.com/libglui/glui/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
PATCHES=( "${FILESDIR}/glui-2.37-custom-cmake-libdir.patch" )
