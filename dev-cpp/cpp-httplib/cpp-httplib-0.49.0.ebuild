# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CRFL CRSH HHI ICV ID IV NPD SO"

PYTHON_COMPAT=( python3_{10..14} )

CHKL_TIMESTAMPS=(
	"app-arch/brotli-9999"
	"dev-libs/openssl-4.0.9999"
	"dev-libs/openssl-3.6.9999"
	"dev-libs/openssl-3.5.9999"
	"dev-libs/openssl-3.4.9999"
	"dev-libs/openssl-3.0.9999"
	"app-arch/zstd-9999"
)

inherit cmake-multilib chkl python-any-r1 secure-version toolchain-funcs

DESCRIPTION="C++ HTTP/HTTPS server and client library"
HOMEPAGE="https://github.com/yhirose/cpp-httplib/"

if [[ "${PV}" == *9999* ]] ; then
	FALLBACK_COMMIT="c64bf21a5ea10c196187cda52ccd776725968e3c"
	EGIT_REPO_URI="https://github.com/yhirose/${PN}.git"
	EGIT_BRANCH="master"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="https://github.com/yhirose/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ~mips ~ppc ppc64 ~riscv ~s390 ~sparc x86"
fi

LICENSE="MIT"
SLOT="0/"$(ver_cut "1-2" "${PV}")

IUSE+="
brotli mbedtls ssl test zlib zstd
ebuild_revision_2
"
REQUIRED_USE="test? ( brotli zlib zstd )"
RESTRICT="!test? ( test )"

RDEPEND="
	brotli? (
		>=app-arch/brotli-${BROTLI_PV}:=[${MULTILIB_USEDEP}]
	)
	ssl? (
		mbedtls? (
			net-libs/mbedtls:=[${MULTILIB_USEDEP}]
			|| (
				>=net-libs/mbedtls-${MBEDTLS_3_PV}:3[${MULTILIB_USEDEP}]
				>=net-libs/mbedtls-${MBEDTLS_4_PV}:4[${MULTILIB_USEDEP}]
			)
		)
		!mbedtls? (
			$(secure-version_gen_openssl_depends '' '[${MULTILIB_USEDEP}]')
		)
	)
	zlib? (
		>=virtual/zlib-${ZLIB_PV}:=[${MULTILIB_USEDEP}]
	)
	zstd? (
		>=app-arch/zstd-${ZSTD_PV}:=[${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
	test? (
		dev-cpp/gtest:=
		dev-libs/openssl:=
		net-misc/curl:=
	)
"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
"

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		# TODO:  add verify-sig
		unpack ${A}
	fi
}

src_configure() {
	chkl_check_many_timestamps
	cmake-multilib_append
	local -a mycmakeargs=(
		-DHTTPLIB_COMPILE=yes
		-DHTTPLIB_SHARED=yes
		-DHTTPLIB_USE_BROTLI_IF_AVAILABLE=no
		-DHTTPLIB_USE_OPENSSL_IF_AVAILABLE=no
		-DHTTPLIB_USE_MBEDTLS_IF_AVAILABLE=no
		-DHTTPLIB_USE_WOLFSSL_IF_AVAILABLE=no
		-DHTTPLIB_USE_ZLIB_IF_AVAILABLE=no
		-DHTTPLIB_USE_ZSTD_IF_AVAILABLE=no
		-DHTTPLIB_REQUIRE_BROTLI=$(usex brotli)
		-DHTTPLIB_REQUIRE_OPENSSL=$(usex ssl $(usex mbedtls no yes))
		-DHTTPLIB_REQUIRE_MBEDTLS=$(usex ssl $(usex mbedtls))
		-DHTTPLIB_REQUIRE_ZLIB=$(usex zlib)
		-DHTTPLIB_REQUIRE_ZSTD=$(usex zstd)
		-DPython3_EXECUTABLE="${PYTHON}"
	)
	cmake-multilib_src_configure
}

multilib_src_test() {
	if [[ $(tc-get-ptr-size) == 4 ]] ; then
		ewarn "Upstream no longer supports 32 bits:"
		ewarn "https://github.com/yhirose/cpp-httplib/issues/2148"
		return
	fi

	cp -p -R --reflink=auto "${S}/test" ./test || die

	local -a failing_tests=(
		# Disable all online tests.
		"*.*_Online"
	)

	# Little dance to please the GTEST filter (join array using ":").
	failing_tests_str="${failing_tests[@]}"
	failing_tests_filter="${failing_tests_str// /:}"

	# PREFIX is . to avoid calling "brew" and relying on stuff in /opt
	GTEST_FILTER="-${failing_tests_filter}" emake -C test \
		CXX="$(tc-getCXX)" CXXFLAGS="${CXXFLAGS} -I." PREFIX=.
}
