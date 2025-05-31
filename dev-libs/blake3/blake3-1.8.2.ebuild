# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"

PYTHON_COMPAT=( "python3_"{10..13} )
inherit cflags-hardened cmake python-any-r1

KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~s390 ~x86"
S="${WORKDIR}/BLAKE3-${PV}/c"
SRC_URI="
https://github.com/BLAKE3-team/BLAKE3/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="A fast cryptographic hash function"
HOMEPAGE="https://github.com/BLAKE3-team/BLAKE3"
LICENSE="
	|| (
		Apache-2.0
		CC0-1.0
	)
"
SLOT="0/0"
IUSE="
-tbb test
ebuild_revision_12
"
RESTRICT="
	!test? (
		test
	)
"
BDEPEND="
	tbb? (
		dev-cpp/tbb:0
	)
	test? (
		${PYTHON_DEPS}
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-1.5.3-backport-pr405.patch"
)

pkg_setup() {
	python-any-r1_pkg_setup
}

src_configure() {
	cflags-hardened_append
	local mycmakeargs=(
		-DBLAKE3_BUILD_TESTING=$(usex test)
		-DBLAKE3_USE_TBB=$(usex tbb)
	)
	cmake_src_configure
}
