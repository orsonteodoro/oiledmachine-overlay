# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
# Only Python 3.5 tested upstream.
inherit distutils-r1

DESCRIPTION="A Python wrapper around the Soundcloud API"
HOMEPAGE="https://github.com/soundcloud/soundcloud-python"
LICENSE="BSD-2"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/${PV}"
IUSE+=" test"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
DEPEND+=" ${PYTHON_DEPS}
	>=dev-python/fudge-1.0.3[${PYTHON_USEDEP}]
	>=dev-python/requests-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/simplejson-2.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.2.0[${PYTHON_USEDEP}]"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" ${PYTHON_DEPS}
	test? ( >=dev-python/nose-1.1.2[${PYTHON_USEDEP}] )"
EGIT_COMMIT="d77f6e5a7ce4852244e653cb67bb20a8a5f04849"
SRC_URI="
https://github.com/${PN/-*}/${PN}/archive/${EGIT_COMMIT}.tar.gz
		-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
