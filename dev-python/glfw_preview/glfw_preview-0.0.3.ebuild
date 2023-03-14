# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
MY_PN="pyGLFW"
MY_PV="2.5.6"
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="This is a helper package for the glfw package that enables \
wrappers for unreleased GLFW3 macros and functions."
HOMEPAGE="https://github.com/FlorianRhiem/pyGLFW/tree/master/utils/glfw_preview"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
DEPEND+="
"
RDEPEND+="
	${DEPEND}
"
SRC_URI="
https://github.com/FlorianRhiem/pyGLFW/archive/refs/tags/v${MY_PV}.tar.gz
	-> ${MY_PN}-${MY_PV}.tar.gz
"
S="${WORKDIR}/${MY_PN}-${MY_PV}/utils/glfw_preview"
RESTRICT="mirror"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
