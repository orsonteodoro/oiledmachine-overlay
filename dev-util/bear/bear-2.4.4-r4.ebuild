# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/b/B}"

PYTHON_COMPAT=( python3_{8..11} )

inherit cmake python-any-r1

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${MY_PN}-${PV}"
SRC_URI="
https://github.com/rizsotto/Bear/archive/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Bear is a tool that generates a compilation database for clang \
tooling."
HOMEPAGE="https://github.com/rizsotto/Bear"
LICENSE="GPL-3+"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" bash-completion test"
RDEPEND+="
	${PYTHON_DEPS}
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	>=dev-build/cmake-2.8
	virtual/pkgconfig
	test? (
		$(python_gen_any_dep '
			>=dev-python/lit-0.7[${PYTHON_USEDEP}]
		')
	)
"

src_configure() {
	local mycmakeargs=(
		-DUSE_SHELL_COMPLETION=$(usex bash-completion)
	)
	cmake_src_configure
}
