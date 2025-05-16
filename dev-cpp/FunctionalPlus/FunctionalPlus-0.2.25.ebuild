# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22.04

PYTHON_COMPAT=( "python3_12" ) # Based on latest commit
CLANG_SLOTS=( {18..11} )
GCC_SLOTS=( {13..9} )

inherit cmake-multilib

KEYWORDS="~amd64 ~arm64 ~arm64-macos"
S="${WORKDIR}/${PN}-${PV/_/-}"
SRC_URI="
https://github.com/Dobiasd/FunctionalPlus/archive/refs/tags/v${PV/_/-}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Functional Programming Library for C++. Write concise and readable C++ code."
HOMEPAGE="
https://www.editgym.com/fplus-api-search/
https://github.com/Dobiasd/FunctionalPlus
"
LICENSE="Boost-1.0"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE="clang doc test"
gen_clang_bdepend() {
	local s
	for s in ${CLANG_SLOTS[@]} ; do
		echo "
			(
				llvm-core/clang:${s}
				=llvm-runtimes/libunwind-${s}*
			)
		"
	done
}
gen_gcc_bdepend() {
	local s
	for s in ${GCC_SLOTS[@]} ; do
		echo "
			(
				sys-devel/gcc:${s}
			)
		"
	done
}
BDEPEND="
	>=dev-build/cmake-3.22.1
	clang? (
		|| (
			$(gen_clang_bdepend)
		)
	)
	test? (
		>=dev-cpp/doctest-2.4.11
	)
	|| (
		$(gen_clang_bdepend)
		$(gen_gcc_bdepend)
	)
"
DOCS=( "README.md" )

# OILEDMACHINE-OVERLAY-META:  created-ebuild

pkg_setup() {
	python_setup
}
