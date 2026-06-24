# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_FORTIFY_FIX_LEVEL=3
CFLAGS_HARDENED_USE_CASES="copy-paste-password security-critical sensitive-data untrusted-data"

CHKL_TIMESTAMPS=(
	"dev-libs/libpcre2-9999"
	"dev-libs/wayland-9999"
	"sys-apps/systemd-9999"
	"x11-libs/cairo-9999"
	"x11-libs/gdk-pixbuf-9999"
	"x11-libs/libxkbcommon-9999"
	"x11-libs/pango-9999"
	"x11-libs/libxcb-9999"
)

inherit cflags-hardened chkl fcaps meson optfeature secure-version

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
basu elogind +man +swaybar +swaynag systemd tray wallpapers X
ebuild_revision_18
"
REQUIRED_USE="
	|| (
		systemd
		elogind
		basu
	)
	tray? (
		swaybar
		|| (
			systemd
			elogind
			basu
		)
	)
"

DEPEND="
	>=dev-libs/json-c-0.13:=
	>=dev-libs/libinput-1.21.0:=
	>=dev-libs/wayland-${WAYLAND_PV}:=
	>=x11-libs/libxkbcommon-${LIBXKBCOMMON_PV}:=
	sys-auth/seatd:=
	>=dev-libs/libpcre2-${LIBPCRE2_PV}:=
	>=x11-libs/cairo-${CAIRO_PV}:=
	>=x11-libs/pango-${PANGO_PV}:=
	>=x11-libs/pixman-${PIXMAN_PV}:=
	media-libs/libglvnd:=
	virtual/libudev:=
	swaybar? (
		>=x11-libs/gdk-pixbuf-${GDK_PIXBUF_PV}:=
	)
	tray? (
		systemd? (
			>=sys-apps/systemd-${SYSTEMD_PV}:=
		)
		elogind? (
			sys-auth/elogind:=
		)
		basu? (
			sys-libs/basu:=
		)
	)
	wallpapers? (
		>=gui-apps/swaybg-${SWAYBG_PV}:=[gdk-pixbuf(+)]
	)
	X? (
		>=x11-libs/libxcb-${LIBXCB_PV}:=
		x11-libs/xcb-util-wm:=
	)
"
# x11-libs/xcb-util-wm needed for xcb-iccm
if [[ "${PV}" == "9999" ]]; then
	DEPEND+="
		~gui-libs/wlroots-9999:=[X=]
	"
else
	DEPEND+="
		gui-libs/wlroots:0.19=[X=]
	"
fi
RDEPEND="
	${DEPEND}
	x11-misc/xkeyboard-config:=
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
	chkl_check_many_timestamps
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
	optfeature "a wallpaper utility" "gui-apps/swaybg"
	optfeature "a idle management utility" "gui-apps/swayidle"
	optfeature "a simple screen locker" "gui-apps/swaylock"
	optfeature "a lightweight notification daemon" "gui-apps/mako"
einfo
einfo "For a list of additional addons and tools usable with sway please"
einfo "visit the official wiki at:"
einfo
einfo "https://github.com/swaywm/sway/wiki/Useful-add-ons-for-sway"
einfo "Please note that some of them might not (yet) available on gentoo"
einfo
}
