# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN,,}"
MY_PN="${MY_PN/-/_}"

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="C-API of RapidFuzz, which can be used to extend RapidFuzz from
separate packages"
LICENSE="MIT"
HOMEPAGE="https://github.com/maxbachmann/rapidfuzz_capi"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/${PV}"
IUSE+=" "
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
DEPEND+=" ${PYTHON_DEPS}"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="mirror"
