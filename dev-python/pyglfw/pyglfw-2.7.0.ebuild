# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# For native glfw version requirement, see
# https://github.com/FlorianRhiem/pyGLFW/blob/v2.7.0/.gitlab-ci.yml#L2

MY_PN="pyGLFW"

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{8..11} ) # CI only test up to 3.8

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${PV}"
SRC_URI="
https://github.com/FlorianRhiem/pyGLFW/archive/refs/tags/v${PV}.tar.gz
	-> ${MY_PN}-${PV}.tar.gz
"

DESCRIPTION="Python bindings for GLFW"
HOMEPAGE="https://github.com/FlorianRhiem/pyGLFW"
LICENSE="MIT"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" wayland X"
RDEPEND+="
	>=media-libs/glfw-3.3.9[wayland?,X?]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
