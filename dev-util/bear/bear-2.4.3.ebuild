# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Bear is a tool that generates a compilation database for clang \
tooling."
HOMEPAGE="https://github.com/rizsotto/Bear"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
MY_PN="${PN/b/B}"
SLOT="0"
PYTHON_COMPAT=( python3_{6,7,8} )
inherit python-single-r1
RDEPEND=">=dev-libs/libconfig-1.4"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
SRC_URI=\
"https://github.com/rizsotto/Bear/archive/v${PV}.tar.gz \
	-> ${P}.tar.gz"
inherit multilib cmake-utils
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="mirror"
