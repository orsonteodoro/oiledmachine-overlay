# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY=""

CHKL_TIMESTAMPS=(
	"app-arch/bzip2-9999"
	"app-arch/xz-utils-9999"
	"app-arch/zstd-9999"
	"dev-libs/nettle-9999"
	"dev-libs/openssl-4.0.9999"
	"dev-libs/openssl-3.6.9999"
	"dev-libs/openssl-3.5.9999"
	"dev-libs/openssl-3.4.9999"
	"dev-libs/openssl-3.3.9999"
	"dev-libs/openssl-3.0.9999"
)

inherit cflags-hardened chkl cmake flag-o-matic secure-version

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="14783686318d15d86eb298c7ce953d56e6670d17"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/nih-at/libzip.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~sparc x86"
	SRC_URI="https://www.nih.at/libzip/${P}.tar.xz"
fi

DESCRIPTION="Library for manipulating zip archives"
HOMEPAGE="https://nih.at/libzip/"

LICENSE="BSD"
SOVER="5"
SLOT="0/${SOVER}"
IUSE+=" bzip2 gnutls lzma ssl test tools zstd"
REQUIRED_USE="test? ( ssl tools )"
RESTRICT="!test? ( test )"

DEPEND="
	>=virtual/zlib-${ZLIB_PV}:=
	bzip2? ( >=app-arch/bzip2-${BZIP2_PV}:= )
	lzma? ( >=app-arch/xz-utils-${XZ_UTILS_PV}:= )
	ssl? (
		gnutls? (
			>=dev-libs/nettle-${NETTLE_PV}:=
			>=net-libs/gnutls-${GNUTLS_PV}:=
		)
		!gnutls? (
			${OPENSSL_RDEPEND}
		)
	)
	zstd? ( >=app-arch/zstd-${ZSTD_PV}:= )
"
RDEPEND="${DEPEND}"
BDEPEND="test? ( dev-util/nihtest )"

PATCHES=(
)

src_prepare() {
	rm -r examples/cmake-project || die # bug #964582
	cmake_src_prepare
}

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
	local actual_sover=$(grep -E -o -e "SOVERSION [0-9]+ " "${S}/lib/CMakeLists.txt" | cut -f 2 -d " " | cut -f 2 -d " ")
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Update the SOVER"
eerror "QA:  Actual sover:  ${actual_sover}"
eerror "QA:  Expected sover:  ${expected_sover}"
		die
	fi
}

src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	append-lfs-flags
	local mycmakeargs=(
		-DBUILD_DOC=ON
		-DBUILD_OSSFUZZ=OFF
		-DBUILD_EXAMPLES=OFF # nothing is installed
		-DENABLE_COMMONCRYPTO=OFF # not in tree
		-DENABLE_BZIP2=$(usex bzip2)
		-DENABLE_LZMA=$(usex lzma)
		-DENABLE_ZSTD=$(usex zstd)
		-DBUILD_REGRESS=$(usex test)
		-DBUILD_TOOLS=$(usex tools)
	)

	if use ssl; then
		if use gnutls; then
			mycmakeargs+=(
				-DENABLE_GNUTLS=$(usex gnutls)
				-DENABLE_OPENSSL=OFF
			)
		else
			mycmakeargs+=(
				-DENABLE_GNUTLS=OFF
				-DENABLE_OPENSSL=ON
			)
		fi
	else
		mycmakeargs+=(
			-DENABLE_GNUTLS=OFF
			-DENABLE_OPENSSL=OFF
		)
	fi
	cmake_src_configure
}
