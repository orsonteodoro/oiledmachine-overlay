# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
inherit cmake-utils python-single-r1

DESCRIPTION="Bear is a tool that generates a compilation database for clang \
tooling."
HOMEPAGE="https://github.com/rizsotto/Bear"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
MY_PN="${PN/b/B}"
SLOT="0"
IUSE+=" bash-completion test"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
DEPEND+=" ${PYTHON_DEPS}"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" ${PYTHON_DEPS}
	>=dev-util/cmake-2.8
	test? (
		$(python_gen_cond_dep '>=dev-python/lit-0.7[${PYTHON_USEDEP}]' \
			python3_{6,7,8,9})
	)
	virtual/pkgconfig"
SRC_URI=\
"https://github.com/rizsotto/Bear/archive/${PV}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="mirror"

src_configure() {
	local mycmakeargs=(
		-DUSE_SHELL_COMPLETION=$(usex bash-completion)
	)
	cmake-utils_src_configure
}
