# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WAYLAND_PV="1.20.0"
WAYLAND_PROTOCOLS_PV="1.32"

inherit meson

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.freedesktop.org/libdecor/libdecor.git"
else
	SRC_URI="
https://gitlab.freedesktop.org/libdecor/libdecor/-/archive/${PV}/${P}.tar.gz
	"
	KEYWORDS="~amd64"
fi

DESCRIPTION="A client-side decorations library for Wayland clients"
HOMEPAGE="https://gitlab.freedesktop.org/libdecor/libdecor"
LICENSE="MIT"
SLOT="0"
IUSE="+dbus examples +gtk"
# F34
DEPEND="
	>=dev-libs/wayland-${WAYLAND_PV}
	>=dev-libs/wayland-protocols-${WAYLAND_PROTOCOLS_PV}
	>=x11-libs/cairo-1.17.4
	>=x11-libs/gtk+-3.24.30:3
	>=x11-libs/pango-1.48.11
	dbus? (
		>=sys-apps/dbus-1.12.20
	)
	examples? (
		>=dev-libs/wayland-${WAYLAND_PV}
		>=media-libs/mesa-21.0.2[egl(+)]
		virtual/opengl
		>=x11-libs/libxkbcommon-1.3.0
	)
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=dev-util/meson-0.49
	>=dev-util/ninja-1.10.2
	>=sys-devel/binutils-2.35.2
	>=sys-devel/gcc-11.3.1
	examples? (
		>=dev-libs/wayland-protocols-${WAYLAND_PROTOCOLS_PV}
	)
"

src_configure() {
	local emesonargs=(
		$(meson_feature dbus)
		$(meson_feature gtk)
		$(meson_use examples demo)
		-Dauto_features=disabled # Avoid auto-magic, built-in feature of meson
		-Dinstall_demo=true
	)
	meson_src_configure
}
