# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CRSH DOS"

CHKL_TIMESTAMPS=(
	"dev-libs/openssl-4.0.9999"
	"dev-libs/openssl-3.6.9999"
	"dev-libs/openssl-3.5.9999"
	"dev-libs/openssl-3.4.9999"
	"dev-libs/openssl-3.0.9999"
)

inherit cflags-hardened chkl meson-multilib secure-version

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="2fc078db25bae61ed0a52dc4fdb7dcce6a6ed037"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/cisco/libsrtp.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv -sparc x86 ~x64-macos"
	SRC_URI="https://github.com/cisco/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Open-source implementation of the Secure Real-time Transport Protocol (SRTP)"
HOMEPAGE="https://github.com/cisco/libsrtp"

LICENSE="BSD"
PV_MAJOR="3"
SOVER="1"
SLOT="${PV_MAJOR}/${SOVER}"
IUSE+=" debug doc mbedtls nss +openssl static-libs test"
RESTRICT="!test? ( test )"

REQUIRED_USE="?? ( mbedtls nss openssl )"

RDEPEND="
	mbedtls? (
		net-libs/mbedtls:=[${MULTILIB_USEDEP}]
		|| (
			>=net-libs/mbedtls-${MBEDTLS_3_PV}:3=[${MULTILIB_USEDEP}]
			>=net-libs/mbedtls-${MBEDTLS_4_PV}:4=[${MULTILIB_USEDEP}]
		)
	)
	nss? (
		>=dev-libs/nss-${NSS_PV}:=[${MULTILIB_USEDEP}]
	)
	openssl? (
		$(secure-version_gen_openssl_depends '' '[${MULTILIB_USEDEP}]')
	)
"
DEPEND="${RDEPEND}"

BDEPEND="
	doc? ( app-text/doxygen )
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}"/libsrtp-2.4.2-doc.patch )

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
	local actual_sover=$(grep -e "soversion = " "${S}/meson.build" | grep -E -o "[0-9]+")
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Update the SOVER in the ebuild."
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
		die
	fi
	local actual_major_ver=$(grep "project" "${S}/meson.build" | head -n 1 | cut -f 6 -d "'" | grep -E -o "[0-9.]+" | cut -f 1 -d ".")
	local expected_major_ver="${PV_MAJOR}"
	if ver_test "${actual_major_ver}" "-ne" "${expected_major_ver}" ; then
eerror "QA:  Update the PV_MAJOR in the ebuild."
eerror "Actual PV_MAJOR:  ${actual_major_ver}"
eerror "Expected PV_MAJOR:  ${expected_major_ver}"
		die
	fi
}

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	local crypto_lib="internal"
	use mbedtls && crypto_lib="mbedtls"
	use nss && crypto_lib="nss"
	use openssl && crypto_lib="openssl"

	# stdout: default error output for messages in debug
	# openssl-kdf: OpenSSL 1.1.0+
	local emesonargs=(
		-Dcrypto-library=${crypto_lib}
		-Dcrypto-library-kdf=disabled
		-Dfuzzer=disabled
		-Dlog-stdout=true
		-Dpcap-tests=disabled
		-Ddefault_library=$(usex static-libs both shared)

		$(meson_feature test tests)
		$(meson_native_use_feature doc)
		$(meson_use debug debug-logging)
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
	if multilib_is_native_abi && use doc; then
		meson_src_compile doc/html
	fi
}

multilib_src_install() {
	if multilib_is_native_abi && use doc; then
		dodoc -r html
	fi
	meson_src_install
}

multilib_src_install_all() {
	local DOCS=( CHANGES )
	einstalldocs
}
