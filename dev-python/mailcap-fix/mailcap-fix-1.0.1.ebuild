# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python{2_6,2_7,3_1,3_2,3_3,3_4,3_5} )

inherit distutils-r1

MY_PN="mailcap_fix"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A python module that will check for package updates"
HOMEPAGE="https://github.com/michael-lazar/mailcap_fix"
SRC_URI="https://github.com/michael-lazar/mailcap_fix/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

S="${WORKDIR}/${MY_P}"

DEPEND="dev-python/setuptools"
RDEPEND=""

