# Copyright 2018-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_ASSEMBLERS="inline"
CFLAGS_HARDENED_LANGS="asm c-lang"
CFLAGS_HARDENED_USE_CASES="network"

inherit cflags-hardened meson-multilib

DESCRIPTION="Library for Reliable Internet Stream Transport (RIST) protocol"
HOMEPAGE="https://code.videolan.org/rist/librist"
SRC_URI="https://code.videolan.org/rist/librist/-/archive/v${PV}/librist-v${PV}.tar.bz2"
S="${WORKDIR}/librist-v${PV}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm64"
IUSE="
-nettle -gnutls +mbedtls test +tools -tun
"
RESTRICT="
	!test? (
		test
	)
"
REQUIRED_USE="
	test? (
		tools
	)
	!kernel_linux? (
		!tun
	)
"

RDEPEND="
	dev-libs/cJSON[${MULTILIB_USEDEP}]
	gnutls? (
		net-libs/gnutls[${MULTILIB_USEDEP}]
	)
	mbedtls? (
		net-libs/mbedtls:3[${MULTILIB_USEDEP}]
		net-libs/mbedtls:=
	)
	nettle? (
		dev-libs/nettle[${MULTILIB_USEDEP}]
	)
	tools? (
		net-libs/libmicrohttpd[${MULTILIB_USEDEP}]
		net-libs/libmicrohttpd:=
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-build/cmake
	virtual/pkgconfig
	test? ( dev-util/cmocka )
"

PATCHES=(
	"${FILESDIR}/${PN}-0.2.11-mbedtls-3.patch"
	"${FILESDIR}/${PN}-0.2.11-no-pedantic-errors.patch"
)

src_configure() {
	cflags-hardened_append
	local emesonargs=(
		$(meson_use gnutls use_gnutls)
		$(meson_use nettle use_nettle)
		$(meson_use mbedtls use_mbedtls)
		$(meson_use test)
		$(meson_use tools built_tools)
		$(meson_use tun use_tun)
		-Dstatic_analyze=false
		-Dbuiltin_cjson=false
		-Dbuiltin_mbedtls=false
		-Dfallback_builtin=false
	)
	meson-multilib_src_configure
}

src_test() {
	# multicast tests fails with FEATURES=network-sandbox
	meson-multilib_src_test --no-suite multicast
}
