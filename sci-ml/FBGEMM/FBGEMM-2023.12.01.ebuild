# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CommitId="88fc6e741bc03e09fcdc3cd365fa3aafddb7ec24" # committer-date:2023-12-01
PYTHON_COMPAT=( python3_{10..12} )

inherit python-any-r1 flag-o-matic cmake

S="${WORKDIR}/${PN}-${CommitId}"
SRC_URI="
https://github.com/pytorch/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Facebook GEneral Matrix Multiplication"
HOMEPAGE="https://github.com/pytorch/FBGEMM"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="doc test"
DEPEND="
	>=dev-libs/asmjit-2022.06.28
	>=dev-libs/cpuinfo-2022.11.18
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	${PYTHON_DEPS}
	doc? (
		$(python_gen_any_dep '
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
			dev-python/breathe[${PYTHON_USEDEP}]
		')
	)
	test? (
		>=dev-cpp/gtest-1.10.0
	)
"
RESTRICT="
	!test? (
		test
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-2023.11.02-gentoo.patch"
)

python_check_deps() {
	if use doc; then
		python_has_version \
			"dev-python/sphinx[${PYTHON_USEDEP}]" \
			"dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]" \
			"dev-python/breathe[${PYTHON_USEDEP}]"
	fi
}

src_prepare() {
	# Bug #855668
	filter-lto
	rm test/RowWiseSparseAdagradFusedTest.cc || die
	rm test/SparseAdagradTest.cc || die
	sed -i \
		-e "/-Werror/d" \
		CMakeLists.txt \
		|| die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DFBGEMM_LIBRARY_TYPE=shared
		-DFBGEMM_BUILD_BENCHMARKS=OFF
		-DFBGEMM_BUILD_DOCS=$(usex doc ON OFF)
		-DFBGEMM_BUILD_TESTS=$(usex test ON OFF)
	)
	cmake_src_configure
}

src_test() {
	OMP_STACKSIZE=512k \
	cmake_src_test
}
