# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# See https://bugs.gentoo.org/822012

EAPI=8

inherit meson-multilib

DESCRIPTION="Reliable Internet Streaming Transport"
HOMEPAGE="https://code.videolan.org/rist/librist/"
SRC_URI="https://code.videolan.org/rist/librist/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+tls +tools -tun"
REQUIRED_USE="
	!kernel_linux? ( !tun )
"
RDEPEND+="
	dev-libs/cJSON[${MULTILIB_USEDEP}]
	tls? ( net-libs/mbedtls[${MULTILIB_USEDEP}] )
	tun? ( sys-kernel/linux-headers )
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-util/meson-0.51.0
"

MY_PN="lib${PN,,}"
EGIT_COMMIT="00d1d3e33fb654d4744ce91fa838b413a4408494"
S="${WORKDIR}/${MY_PN}-v${PV}-${EGIT_COMMIT}"

src_configure() {
	local emesonargs=(
		-Dbuiltin_cjson=false
		-Dbuiltin_mbedtls=false
		$(meson_use tls use_mbedtls)
		$(meson_use tools built_tools)
	)
	meson-multilib_src_configure
}
