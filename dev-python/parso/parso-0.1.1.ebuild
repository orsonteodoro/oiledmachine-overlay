# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1

DESCRIPTION="A Python Parser"
HOMEPAGE="https://github.com/davidhalter/parso"
SRC_URI="https://github.com/davidhalter/parso/archive/v0.1.1.tar.gz -> ${P}.tar.gz"

LICENSE="MIT PSF-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RESTRICT=""

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

python_install_all() {
	distutils-r1_python_install_all
}
