# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

SRC_URI="https://github.com/jbeder/yaml-cpp/archive/${P}.tar.gz"
S="${WORKDIR}/yaml-cpp-${P}"

DESCRIPTION="YAML parser and emitter in C++"
HOMEPAGE="https://github.com/jbeder/yaml-cpp"
LICENSE="MIT"
SLOT="0/0.7"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="
	!test? (
		test
	)
"
DEPEND="
	test? (
		dev-cpp/gtest[${MULTILIB_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${P}-gtest.patch"
	"${FILESDIR}/${P}-cmake-paths.patch"
	"${FILESDIR}/${P}-install-paths.patch"
)

src_configure() {
	local mycmakeargs=(
		-DYAML_BUILD_SHARED_LIBS=ON
		-DYAML_CPP_BUILD_TOOLS=OFF # Don't have install rule
		-DYAML_CPP_BUILD_TESTS=$(usex test)
	)
	cmake-multilib_src_configure
}
