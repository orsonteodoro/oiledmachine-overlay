# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CommitId="a30ca3f9509c2cfd28561abbca51328f0bdf9014"
PYTHON_COMPAT=( python3_{9..12} )

inherit python-any-r1 cmake prefix

S="${WORKDIR}/${PN}-${CommitId}"
SRC_URI="
https://github.com/pytorch/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="A CPU+GPU Profiling library that provides access to timeline traces and hardware performance counters"
HOMEPAGE="https://github.com/pytorch/kineto"
LICENSE="BSD"
RESTRICT="
	!test? (
		test
	)
"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RDEPEND="
	>=dev-libs/dynolog-0.1.0_p20230125
	>=dev-libs/libfmt-9.1.0
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	test? (
		>=dev-cpp/gtest-1.10.0
	)
	${PYTHON_DEPS}
"
PATCHES=(
	"${FILESDIR}/${PN}-0.4.0-gcc13.patch"
)

src_prepare() {
	cd libkineto
	cmake_src_prepare
}

src_configure() {
	cd libkineto
	local mycmakeargs=(
		-DLIBKINETO_THIRDPARTY_DIR="${EPREFIX}/usr/include/"
	)
	eapply $(prefixify_ro "${FILESDIR}/${PN}-0.4.0_p20231031-gentoo.patch")
	cmake_src_configure
}
