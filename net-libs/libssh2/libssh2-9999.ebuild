# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="network security-critical sensitive-data untrusted-data web-browser"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="DOS ID IO OOBA OOBR OOBW"

CHKL_TIMESTAMPS=(
	"dev-libs/libgcrypt-9999"
	"dev-libs/openssl-4.0.9999"
	"dev-libs/openssl-3.6.9999"
	"dev-libs/openssl-3.5.9999"
	"dev-libs/openssl-3.4.9999"
	"dev-libs/openssl-3.3.9999"
	"dev-libs/openssl-3.0.9999"
	"net-libs/mbedtls-9999"
)

inherit cflags-hardened chkl cmake-multilib secure-version

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="db0d10736af3229888e377819a36dd3a75f29314"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/libssh2/libssh2"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="FIXME"
fi

DESCRIPTION="Library implementing the SSH2 protocol"
HOMEPAGE="https://libssh2.org"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE+="
gcrypt mbedtls test zlib
ebuild_revision_3
"
REQUIRED_USE="?? ( gcrypt mbedtls )"
RESTRICT="!test? ( test )"

RDEPEND="
	gcrypt? ( >=dev-libs/libgcrypt-${LIBGCRYPT_PV}:0[${MULTILIB_USEDEP}] )
	!gcrypt? (
		mbedtls? ( >=net-libs/mbedtls-${MBEDTLS_PV}:0=[${MULTILIB_USEDEP}] )
		!mbedtls? (
			$(secure-version_gen_openssl_depends '' '[${MULTILIB_USEDEP}]')
		)
	)
	zlib? ( >=virtual/zlib-${ZLIB_PV}:=[${MULTILIB_USEDEP}] )
"
DEPEND="
	${RDEPEND}
"

PATCHES=(
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

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	local crypto_backend=OpenSSL
	if use gcrypt; then
		crypto_backend=Libgcrypt
	elif use mbedtls; then
		crypto_backend=mbedTLS
	fi

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_STATIC_LIBS=OFF
		-DBUILD_TESTING=$(usex test)
		-DCRYPTO_BACKEND=${crypto_backend}
		-DENABLE_ZLIB_COMPRESSION=$(usex zlib)
	)

	if use test ; then
		# Pass separately to avoid unused var warnings w/ USE=-test
		mycmakeargs+=(
			-DRUN_SSHD_TESTS=OFF
			-DRUN_DOCKER_TESTS=OFF
		)
	fi

	cmake_src_configure
}

multilib_src_install_all() {
	einstalldocs
}
