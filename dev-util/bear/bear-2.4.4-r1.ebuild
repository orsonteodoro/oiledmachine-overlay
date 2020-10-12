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
IUSE="bash-completion test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.8
	test? (
		$(python_gen_cond_dep '>=dev-python/lit-0.7[${PYTHON_USEDEP}]' python3_{6,7,8})
	)
	virtual/pkgconfig"
SRC_URI=\
"https://github.com/rizsotto/Bear/archive/${PV}.tar.gz \
	-> ${P}.tar.gz"
inherit multilib cmake-utils
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="mirror"

src_configure() {
	local mycmakeargs=(
		-DUSE_SHELL_COMPLETION=$(usex bash-completion)
	)
	cmake-utils_src_configure
}
