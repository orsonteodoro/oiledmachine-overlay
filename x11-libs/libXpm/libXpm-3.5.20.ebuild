# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_DOC=doc
XORG_MULTILIB=yes

CHKL_TIMESTAMPS=(
	"dev-libs/glib-2.90.9999"
)

inherit chkl secure-version xorg-3

DESCRIPTION="X.Org Xpm library"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=x11-libs/libX11-${LIBX11_PV}:=[${MULTILIB_USEDEP}]
	>=x11-libs/libXext-${LIBXEXT_PV}:=[${MULTILIB_USEDEP}]
	>=x11-libs/libXt-${LIBXT_PV}:=[${MULTILIB_USEDEP}]

	app-alternatives/gzip:*
	app-arch/ncompress:=
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto:=
	test? ( >=dev-libs/glib-${GLIB_PV}:= )
"
BDEPEND="
	sys-devel/gettext
	test? (
		app-arch/gzip
		app-arch/ncompress
	)
"

src_configure() {
	chkl_check_many_timestamps
	local XORG_CONFIGURE_OPTIONS=(
		$(use_enable test unit-tests)
	)
	xorg-3_src_configure
}
