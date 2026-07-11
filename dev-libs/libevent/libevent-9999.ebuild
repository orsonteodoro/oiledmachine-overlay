# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_REMOVE_MODULES_LIST=( FindMbedTLS )

CHKL_TIMESTAMPS=(
	"dev-libs/openssl-4.0.9999"
	"dev-libs/openssl-3.6.9999"
	"dev-libs/openssl-3.5.9999"
	"dev-libs/openssl-3.4.9999"
	"dev-libs/openssl-3.0.9999"
)

inherit cmake-multilib chkl secure-version

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="4df63044206cee1bc6009e94f6eaebee87aa4724"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/libevent/libevent.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	BASE_URI="https://github.com/libevent/libevent/releases/download/release-${PV}-alpha"
	S=${WORKDIR}/${MY_P}
	inherit verify-sig
	SRC_URI="
${BASE_URI}/${MY_P}.tar.gz
	verify-sig? (
${BASE_URI}/${MY_P}.tar.gz.asc
	)
	"
fi

DESCRIPTION="Library to execute a function when a specific event occurs on a file descriptor"
HOMEPAGE="
	https://libevent.org/
	https://github.com/libevent/libevent/
"

LICENSE="BSD"
SLOT="0/2.2.1-r2"
KEYWORDS=""
IUSE+="
	+clock-gettime debug malloc-replacement mbedtls +ssl static-libs
	test verbose-debug
"
# TODO: hangs
RESTRICT="test"

DEPEND="
	mbedtls? (
		net-libs/mbedtls:=[${MULTILIB_USEDEP}]
		|| (
			>=net-libs/mbedtls-${MBEDTLS_3_PV}:3[${MULTILIB_USEDEP}]
			>=net-libs/mbedtls-${MBEDTLS_4_PV}:4[${MULTILIB_USEDEP}]
		)
	)
	ssl? (
		$(secure-version_gen_openssl_depends '' '[${MULTILIB_USEDEP}]')
	)
"
RDEPEND="
	${DEPEND}
"

DOCS=( README.md ChangeLog{,-2.0,-2.1} whatsnew-2.{0,1}.txt )
MULTILIB_WRAPPED_HEADERS=(
	/usr/include/event2/event-config.h
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
	local mycmakeargs=(
		-DEVENT__DISABLE_CLOCK_GETTIME=$(usex clock-gettime OFF ON)
		-DEVENT__DISABLE_DEBUG_MODE=$(usex debug OFF ON)
		-DEVENT__DISABLE_MBEDTLS=$(usex mbedtls OFF ON)
		-DEVENT__DISABLE_MM_REPLACEMENT=$(usex malloc-replacement OFF ON)
		-DEVENT__DISABLE_OPENSSL=$(usex ssl OFF ON)
		-DEVENT__LIBRARY_TYPE=$(usex static-libs BOTH SHARED)
		-DCMAKE_DEBUG_POSTFIX=""
		-DCMAKE_DISABLE_FIND_PACKAGE_MbedTLS=$(usex mbedtls OFF ON)
		-DCMAKE_DISABLE_FIND_PACKAGE_OpenSSL=$(usex ssl OFF ON)
	)
	cmake_src_configure
}
