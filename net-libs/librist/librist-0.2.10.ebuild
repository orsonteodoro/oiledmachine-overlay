# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See https://bugs.gentoo.org/822012

EAPI=8

inherit meson-multilib

EGIT_COMMIT="1e805500dc14a507598cebdd49557c32e514899f"
SRC_URI="
https://code.videolan.org/rist/librist/-/archive/v${PV}/${PN}-v${PV}.tar.bz2
"
S="${WORKDIR}/${PN}-v${PV}-${EGIT_COMMIT}"

DESCRIPTION="Reliable Internet Streaming Transport"
HOMEPAGE="https://code.videolan.org/rist/librist/"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="-nettle -gnutls +mbedtls +tools -tun"
REQUIRED_USE="
	!kernel_linux? ( !tun )
"
RDEPEND+="
	dev-libs/cJSON[${MULTILIB_USEDEP}]
	gnutls? (
		net-libs/gnutls[${MULTILIB_USEDEP}]
	)
	mbedtls? (
		net-libs/mbedtls[${MULTILIB_USEDEP}]
	)
	nettle? (
		dev-libs/nettle[${MULTILIB_USEDEP}]
	)
	tun? (
		sys-kernel/linux-headers
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-util/meson-0.51.0
"

src_configure() {
	local emesonargs=(
		-Dbuiltin_cjson=false
		-Dbuiltin_mbedtls=false
		$(meson_use gnutls use_gnutls)
		$(meson_use nettle use_nettle)
		$(meson_use mbedtls use_mbedtls)
		$(meson_use tools built_tools)
	)
	meson-multilib_src_configure
}
