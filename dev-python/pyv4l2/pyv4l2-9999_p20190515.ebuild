# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Simple v4l2 lib for python3"
HOMEPAGE="https://github.com/duanhongyi/pyv4l2"
LICENSE="LGPL-3"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/${PV}"
IUSE+=" "
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}"
RDEPEND+="
	${PYTHON_DEPS}
	media-libs/libv4l
"
DEPEND+=" ${RDEPEND}
	>=dev-python/cython-0.18[${PYTHON_USEDEP}]
"
BDEPEND+=" ${PYTHON_DEPS}"
EGIT_COMMIT="f12f0b3a14e44852f0a0d13ab561cbcae8b5e0c3"
SRC_URI="
https://github.com/duanhongyi/pyv4l2/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
PATCHES=(
	"${FILESDIR}/pyv4l2-9999_p20190515-select-cython-by-envvar.patch"
)

pkg_setup() {
	export EUSE_CYTHON="True"
}
