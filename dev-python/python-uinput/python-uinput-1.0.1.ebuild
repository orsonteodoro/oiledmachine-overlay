# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1

KEYWORDS="~amd64"
SRC_URI="
https://github.com/pyinput/python-uinput/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Pythonic API to Linux uinput module "
HOMEPAGE="
https://pypi.org/project/python-uinput/
https://github.com/pyinput/python-uinput
"
LICENSE="GPL-3+"
SLOT="0"
IUSE=" ebuild_revision_1"
RDEPEND="
	virtual/udev
"
DEPEND="
	${DEPEND}
"

python_prepare_all() {
	rm "libsuinput/src/libudev.h" || die
	distutils-r1_python_prepare_all
}
