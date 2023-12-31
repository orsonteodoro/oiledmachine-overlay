# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
MY_PN="pyGLFW"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Python bindings for GLFW"
HOMEPAGE="https://github.com/FlorianRhiem/pyGLFW"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
DEPEND+="
	media-libs/glfw
"
RDEPEND+="
	${DEPEND}
"
SRC_URI="
https://github.com/FlorianRhiem/pyGLFW/archive/refs/tags/v${PV}.tar.gz
	-> ${MY_PN}-${PV}.tar.gz
"
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="mirror"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
