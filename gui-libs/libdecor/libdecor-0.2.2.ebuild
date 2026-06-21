# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# F34

WAYLAND_PV="9999"
WAYLAND_PROTOCOLS_PV="1.32"

CHKL_TIMESTAMPS=(
	"dev-libs/wayland-9999"		# Bumped *DEPENDS/live to latest non-vulnerable
	"x11-libs/cairo-9999"		# Bumped *DEPENDS/live to latest non-vulnerable
	"x11-libs/pango-9999"		# Bumped *DEPENDS/live to latest non-vulnerable
)

inherit chkl meson-multilib

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.freedesktop.org/libdecor/libdecor.git"
else
	KEYWORDS="~amd64"
	SRC_URI="
https://gitlab.freedesktop.org/libdecor/libdecor/-/archive/${PV}/${P}.tar.gz
	"
fi

DESCRIPTION="A client-side decorations library for Wayland clients"
HOMEPAGE="https://gitlab.freedesktop.org/libdecor/libdecor"
LICENSE="MIT"
SLOT="0"
IUSE="+dbus examples +gtk"
RDEPEND="
	>=dev-libs/wayland-${WAYLAND_PV}:=
	>=dev-libs/wayland-protocols-${WAYLAND_PROTOCOLS_PV}:=
	>=x11-libs/cairo-9999:=
	>=x11-libs/gtk+-3.24.52:3=
	>=x11-libs/pango-1.57.1:=
	dbus? (
		>=sys-apps/dbus-1.12.20:=
	)
	examples? (
		>=dev-libs/wayland-${WAYLAND_PV}:=
		>=media-libs/mesa-21.0.2:=[egl(+)]
		virtual/opengl:*
		>=x11-libs/libxkbcommon-1.3.0:=
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/meson-0.49
	>=dev-build/ninja-1.10.2
	>=sys-devel/binutils-2.35.2
	>=sys-devel/gcc-11.3.1
	examples? (
		>=dev-libs/wayland-protocols-${WAYLAND_PROTOCOLS_PV}
	)
"

multilib_src_configure() {
	chkl_check_many_timestamps
	local emesonargs=(
		$(meson_feature dbus)
		$(meson_feature gtk)
		$(meson_use examples demo)
		-Dauto_features=disabled # Avoid auto-magic, built-in feature of meson
		-Dinstall_demo=true
	)
	meson_src_configure
}
