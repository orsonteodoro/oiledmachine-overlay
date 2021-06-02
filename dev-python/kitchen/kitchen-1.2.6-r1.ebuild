# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See also https://github.com/fedora-infra/kitchen

EAPI=7

PYTHON_COMPAT=( python3_{8..10} ) # setup.py says up to 3.4
inherit distutils-r1

DESCRIPTION="A cornucopia of useful code"
HOMEPAGE="https://pypi.org/project/kitchen/"
LICENSE="LGPL-2+ PSF-2.4"
KEYWORDS="~amd64 ~x86"
SLOT="0"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
RDEPEND+=" ${PYTHON_DEPS}"
DEPEND+=" ${RDEPEND}"
BDEPEND+=" ${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
RESTRICT="mirror"
