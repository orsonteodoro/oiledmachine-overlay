# Copyright 2019-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical untrusted-data"

inherit cflags-hardened secure-version cmake-multilib

DESCRIPTION="Heavily optimized DEFLATE/zlib/gzip (de)compression"
HOMEPAGE="https://github.com/ebiggers/libdeflate"

if [[ ${PV} == *9999* ]]; then
	FALLBACK_COMMIT="92e6a0db9fa848d742f9eb286c92afc60f2c3dda"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/ebiggers/libdeflate.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="
		https://github.com/ebiggers/libdeflate/archive/v${PV}.tar.gz -> ${P}.tar.gz
	"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
fi

LICENSE="MIT"
SLOT="0"
# the zlib USE-flag enables support for zlib
# the test USE-flag programs depend on virtual/zlib for comparison tests
IUSE+=" +utils test"

RESTRICT="
	!test? ( test )
"

DEPEND="
	test? ( >=virtual/zlib-${ZLIB_PV}[${MULTILIB_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}/${PN}-1.19-make-gzip-tests-conditional.patch"
)

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_configure() {
	cflags-hardened_append
	local mycmakeargs=(
		-DLIBDEFLATE_BUILD_SHARED_LIB="yes"
		-DLIBDEFLATE_BUILD_STATIC_LIB="no"
		-DLIBDEFLATE_USE_SHARED_LIB="yes"

		-DLIBDEFLATE_COMPRESSION_SUPPORT="yes"
		-DLIBDEFLATE_DECOMPRESSION_SUPPORT="yes"

		-DLIBDEFLATE_BUILD_GZIP="$(usex utils)"
		-DLIBDEFLATE_GZIP_SUPPORT="yes"

		-DLIBDEFLATE_ZLIB_SUPPORT="yes"

		-DLIBDEFLATE_BUILD_TESTS="$(usex test)"
	)

	cmake-multilib_src_configure
}
