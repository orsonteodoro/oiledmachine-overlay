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
IUSE+=" test"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
RBDEPEND=" >=net-libs/grpc-1.26
	   >=dev-libs/protobuf-3.11"
DEPEND+=" >=dev-cpp/nlohmann_json-3.7.3
	  >=dev-libs/libfmt-6.1
	  >=dev-libs/spdlog-1.5
	  >=dev-db/sqlite-3.14"
RDEPEND+=" ${RBDEPEND}
	   ${DEPEND}"
BDEPEND+=" ${RBDEPEND}
	>=dev-util/cmake-3.12
	test? (
		${PYTHON_DEPS}
		>=dev-cpp/gtest-1.10
		$(python_gen_cond_dep '>=dev-python/lit-0.7[${PYTHON_USEDEP}]' \
			python3_{6,7,8})
		dev-util/valgrind
	)
	virtual/pkgconfig"
SRC_URI=\
"https://github.com/rizsotto/Bear/archive/${PV}.tar.gz \
	-> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="mirror"

src_configure() {
	local mycmakeargs=(
		-DENABLE_UNIT_TESTS=$(usex test)
		-DENABLE_FUNC_TESTS=$(usex test)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	# Removed staged folder.  It contains the same contents.
	rm -rf "${ED}/var" || die
}
