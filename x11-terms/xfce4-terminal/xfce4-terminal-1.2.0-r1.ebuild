# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="untrusted-data security-critical sensitive-data"

CHKL_TIMESTAMPS=(
	"dev-libs/glib-2.90.9999"
	"dev-libs/libpcre2-9999"
	"dev-libs/libxml2-9999"
	"x11-libs/gtk+-3.24.9999"
	"x11-libs/libX11-9999"
)

inherit cflags-hardened chkl meson optfeature secure-version xdg-utils

DESCRIPTION="A terminal emulator for the Xfce desktop environment"
HOMEPAGE="
	https://docs.xfce.org/apps/terminal/start
	https://gitlab.xfce.org/apps/xfce4-terminal/
"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/$(ver_cut 1-2)/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv ~sparc x86 ~x64-solaris"
IUSE="
+color-themes utempter wayland X
ebuild_revision_1
"
REQUIRED_USE="|| ( wayland X )"

RDEPEND="
	>=dev-libs/glib-${GLIB_PV}:=
	>=dev-libs/libpcre2-${LIBPCRE2_PV}:=
	>=x11-libs/gtk+-${GTK3_PV}:3=[wayland?,X?]
	>=x11-libs/vte-0.51.3:2.91=
	>=xfce-base/libxfce4ui-4.17.5:=[X?]
	>=xfce-base/libxfce4util-4.16.0:=
	>=xfce-base/xfconf-4.16.0:=
	utempter? ( sys-libs/libutempter:= )
	wayland? ( >=gui-libs/gtk-layer-shell-0.7.0:= )
	X? ( >=x11-libs/libX11-${LIBX11_PV}:= )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-libs/libxml2-${LIBXML2_PV}
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	# https://gitlab.xfce.org/apps/xfce4-terminal/-/commit/b07d9546a08a3cd70b7e9aaad7a86256fbe32b8b
	"${FILESDIR}/${P}-no-wayland.patch"
)

src_configure() {
	chkl_check_many_timestamps
	local emesonargs=(
		$(meson_feature X x11)
		$(meson_feature wayland)
		$(meson_feature wayland gtk-layer-shell)
		$(meson_feature utempter libutempter)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	use color-themes || rm -rf "${ED}/usr/share/xfce4/terminal/colorschemes"
}

pkg_postinst() {
	xdg_icon_cache_update
	optfeature_header "Install optional packages:"
	optfeature "additional color schemes" "x11-themes/gogh"
	optfeature "additional color schemes" "x11-themes/tinted-terminal-xfce4"
	optfeature "additional color schemes" "x11-themes/xfce4-terminal-catppuccin-theme"
}

pkg_postrm() {
	xdg_icon_cache_update
}
