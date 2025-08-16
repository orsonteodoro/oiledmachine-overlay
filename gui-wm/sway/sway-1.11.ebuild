# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_FORTIFY_FIX_LEVEL=3
CFLAGS_HARDENED_USE_CASES="copy-paste-password security-critical sensitive-data untrusted-data"

inherit cflags-hardened fcaps meson optfeature

DESCRIPTION="i3-compatible Wayland window manager"
HOMEPAGE="https://swaywm.org"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/swaywm/${PN}.git"
else
	MY_PV=${PV/_rc/-rc}
	KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
	SRC_URI="https://github.com/swaywm/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="MIT"
SLOT="0"
IUSE="
+man +swaybar +swaynag tray wallpapers X
ebuild_revision_9
"
REQUIRED_USE="
	tray? (
		swaybar
	)
"

DEPEND="
	>=dev-libs/json-c-0.13:0=
	>=dev-libs/libinput-1.21.0:0=
	>=dev-libs/wayland-1.20.0
	>=x11-libs/libxkbcommon-1.5.0:0=
	sys-auth/seatd:=
	dev-libs/libpcre2
	x11-libs/cairo
	x11-libs/pango
	x11-libs/pixman
	media-libs/libglvnd
	virtual/libudev
	swaybar? (
		x11-libs/gdk-pixbuf:2
	)
	tray? (
		|| (
			sys-apps/systemd
			sys-auth/elogind
			sys-libs/basu
		)
	)
	wallpapers? (
		gui-apps/swaybg[gdk-pixbuf(+)]
	)
	X? (
		x11-libs/libxcb:0=
		x11-libs/xcb-util-wm
	)
"
# x11-libs/xcb-util-wm needed for xcb-iccm
if [[ "${PV}" == "9999" ]]; then
	DEPEND+="~gui-libs/wlroots-9999:=[X=]"
else
	DEPEND+="
		gui-libs/wlroots:0.19[X=]
	"
fi
RDEPEND="
	${DEPEND}
	x11-misc/xkeyboard-config
"
BDEPEND="
	>=dev-libs/wayland-protocols-1.24
	>=dev-build/meson-1.3
	virtual/pkgconfig
"
if [[ "${PV}" == "9999" ]]; then
	BDEPEND+="
		man? (
			~app-text/scdoc-9999
		)
	"
else
	BDEPEND+="
		man? (
			>=app-text/scdoc-1.9.3
		)
	"
fi

FILECAPS=(
	cap_sys_nice "usr/bin/${PN}" # bug 919298
)

src_configure() {
	cflags-hardened_append
	local emesonargs=(
		$(meson_feature man man-pages)
		$(meson_feature swaybar gdk-pixbuf)
		$(meson_feature tray)
		$(meson_use swaybar)
		$(meson_use swaynag)
		$(meson_use wallpapers default-wallpaper)
		-Dfish-completions=true
		-Dzsh-completions=true
		-Dbash-completions=true
	)

	meson_src_configure
}

src_install() {
	meson_src_install
	insinto "/usr/share/xdg-desktop-portal"
	doins "${FILESDIR}/sway-portals.conf"
	chmod u-s "${ED}/usr/bin/sway"
}

pkg_postinst() {
	fcaps_pkg_postinst
	optfeature_header "There are several packages that may be useful with sway:"
	optfeature "wallpaper utility" gui-apps/swaybg
	optfeature "idle management utility" gui-apps/swayidle
	optfeature "simple screen locker" gui-apps/swaylock
	optfeature "lightweight notification daemon" gui-apps/mako
einfo
einfo "For a list of additional addons and tools usable with sway please"
einfo
einfo "visit the official wiki at:"
einfo
einfo "https://github.com/swaywm/sway/wiki/Useful-add-ons-for-sway"
einfo "Please note that some of them might not (yet) available on gentoo"
einfo
}
