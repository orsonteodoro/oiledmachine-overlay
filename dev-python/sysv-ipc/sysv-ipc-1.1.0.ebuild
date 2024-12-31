# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

KEYWORDS="~amd64"
S="${WORKDIR}/${PN/-/_}-${PV}"

DESCRIPTION="System V IPC primitives (semaphores, shared memory and message queues) for Python"
HOMEPAGE="
	https://semanchuk.com/philip/sysv_ipc/
	https://pypi.org/project/sysv-ipc
"
LICENSE="
	BSD
"
RESTRICT="mirror test" # untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
"
DOCS=( "history.html" "ReadMe.html" )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
