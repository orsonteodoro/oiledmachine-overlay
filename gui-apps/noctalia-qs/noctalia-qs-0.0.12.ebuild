# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# For depends see nix/package.nix, nix/shell.nix

# Upstream recommends leaving all build options enabled by default

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CXX_STANDARD=20

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX20[@]}" # 13-16
)
LIBSTDCXX_USEDEP_DEV="gcc_slot_skip(+)"

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX20[@]}" # 20-22
)
LIBCXX_USEDEP_DEV="llvm_slot_skip(+)"

CHKL_TIMESTAMPS=(
	"dev-libs/glib-2.89.9999"
	"dev-libs/wayland-9999"
	"dev-qt/qtbase-6.9999"
	"dev-qt/qtdeclarative-6.9999"
	"media-libs/mesa-9999"
	"media-video/pipewire-9999"
	"net-wireless/bluez-9999"
	"net-misc/networkmanager-9999"
	"sys-libs/pam-9999"
	"x11-libs/libxcb-9999"
)

inherit branding cflags-hardened chkl cmake libcxx-slot libstdcxx-slot secure-version

if [[ "${PV}" =~ "9999" ]]; then
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/noctalia-dev/noctalia-qs.git"
	FALLBACK_COMMIT="e7224b756dcd10eec040df818a4c7a0fda5d6eff"
	IUSE+=" fallback-commit"
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="
https://github.com/noctalia-dev/noctalia-qs/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	"
fi

DESCRIPTION="Flexible toolkit for making desktop shells with QtQuick, for Wayland and X11"
HOMEPAGE="
	https://github.com/noctalia-dev/noctalia-qs
"
LICENSE="LGPL-3"
SLOT="0/4"
IUSE+="
+bluetooth +crash-handler +dbus +dwl +hyprland +hyprland-ipc +greetd +i3
+jemalloc +layer-shell +mpris +networkmanager +niri +niri-ipc +notifications
+minimal +pam +pipewire +policykit +screencopy +session-lock +sockets test
+toplevel-management +tray +upower +wayland +X
ebuild_revision_5
"
REQUIRED_USE="
	dbus? (
		|| (
			bluetooth
			mpris
			networkmanager
			notifications
			upower
		)
	)
	hyprland? (
		toplevel-management
		wayland
	)
	layer-shell? (
		wayland
	)
	minimal? (
		bluetooth
		dwl
		hyprland
		i3
		layer-shell
		mpris
		networkmanager
		niri
		notifications
		pam
		pipewire
		session-lock
		toplevel-management
		tray
		upower
	)
	niri? (
		wayland
	)
	niri-ipc? (
		niri
	)
	screencopy? (
		wayland
	)
	session-lock? (
		wayland
	)
	screencopy? (
		toplevel-management
	)
	toplevel-management? (
		wayland
	)
	|| (
		wayland
		X
	)
"

RDEPEND="
	!gui-apps/quickshell
	>=dev-qt/qtbase-${QTBASE6_PV}:6=[${LIBCXX_USEDEP_DEV},${LIBSTDCXX_USEDEP_DEV},dbus?,gui,vulkan,wayland?,widgets,X?]
	>=dev-qt/qtdeclarative-${QTDECLARATIVE6_PV}:6=[${LIBCXX_USEDEP_DEV},${LIBSTDCXX_USEDEP_DEV},vulkan,widgets]
	dev-qt/qtsvg:6=[${LIBCXX_USEDEP_DEV},${LIBSTDCXX_USEDEP_DEV}]
	bluetooth? (
		>=net-wireless/bluez-${BLUEZ_PV}:=
	)
	jemalloc? (
		>=dev-libs/jemalloc-${JEMALLOC_PV}:=
	)
	networkmanager? (
		>=net-misc/networkmanager-${NETWORKMANAGER_PV}:=
	)
	pam? (
		>=sys-libs/pam-${PAM_PV}:=
	)
	pipewire? (
		>=media-video/pipewire-${PIPEWIRE_PV}:=
	)
	policykit? (
		>=dev-libs/glib-${GLIB_PV}:=
		sys-auth/polkit:=
	)
	screencopy? (
		>=media-libs/mesa-${MESA_PV}:=
		>=x11-libs/libdrm-${LIBDRM_PV}:=
	)
	wayland? (
		>=dev-libs/wayland-${WAYLAND_PV}:=
		dev-qt/qtwayland:6=[${LIBCXX_USEDEP_DEV},${LIBSTDCXX_USEDEP_DEV}]
	)
	X? (
		>=x11-libs/libxcb-${LIBXCB_PV}:=
	)
"
DEPEND="
	${RDEPEND}
	dev-cpp/cli11:=
	crash-handler? (
		dev-cpp/cpptrace:=[unwind]
	)
	screencopy? (
		dev-util/vulkan-headers:=
	)
	wayland? (
		dev-libs/wayland-protocols:=
	)
"
BDEPEND="
	dev-build/cmake
	dev-build/ninja
	dev-qt/qtshadertools:6=[${LIBCXX_USEDEP_DEV},${LIBSTDCXX_USEDEP_DEV}]
	dev-util/spirv-tools
	virtual/pkgconfig
	wayland? (
		dev-util/wayland-scanner
	)
"

DOCS=( "README.md" "changelog/" )

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify

	# Check now because it takes a long time to build.
	if has_version "gui-wm/dwl" && ! use "hyprland" ; then
ewarn "You forgot to add the dwl USE flag to ${PN} for dwl support."
	fi
	if has_version "gui-wm/hyprland" && ! use "hyprland" ; then
ewarn "You forgot to add the hyprland USE flag to ${PN} for Hyprland support."
	fi
	if has_version "x11-wm/i3" && ! use "i3" ; then
ewarn "You forgot to add the i3 in USE flag to ${PN} for i3 support."
	fi
	if has_version "gui-wm/niri" && ! use "niri" ; then
ewarn "You forgot to add the niri USE flag to ${PN} for Niri support."
	fi
	if has_version "gui-wm/sway" && ! use "i3" ; then
ewarn "You forgot to add the i3 in USE flag to ${PN} for Sway support."
	fi
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]]; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	# Hyprland controls all Hyprland sub-features as a group.
	# i3 controls I3 / Sway IPC.
	# niri controls Niri IPC.
	# screencopy controls all screencopy backends (icc, wlr, hyprland-toplevel).
	local _hyprland=$(usex hyprland)
	local _i3=$(usex i3)
	local _niri=$(usex niri)
	local _screencopy=$(usex screencopy)

	# The reason why niri-ipc and hyprland-ipc are optional is a security issue with IPC.
	# There is a possibility of memory corrupting two processes with IPC.  The blast
	# radius increases with IPC support.
	# i3 IPC is still required.
	local mycmakeargs=(
		-DBLUETOOTH=$(usex bluetooth)
		-DBUILD_TESTING=$(usex test)
		-DCRASH_HANDLER=$(usex crash-handler)
		-DDISTRIBUTOR="${BRANDING_OS_NAME} oiledmachine-overlay"
		-DDWL=$(usex dwl)
		-DGIT_REVISION=${EGIT_COMMIT}
		-DINSTALL_QML_PREFIX="$(get_libdir)/qt6/qml"
		-DHYPRLAND=${_hyprland}
		-DHYPRLAND_FOCUS_GRAB=${_hyprland}
		-DHYPRLAND_GLOBAL_SHORTCUTS=${_hyprland}
		-DHYPRLAND_IPC=$(usex hyprland-ipc)
		-DHYPRLAND_SURFACE_EXTENSIONS=${_hyprland}
		-DI3=${_i3}
		-DI3_IPC=${_i3}
		-DNETWORK=$(usex networkmanager)
		-DNIRI=${_niri}
		-DNIRI_IPC=$(usex niri-ipc)
		-DSCREENCOPY=${_screencopy}
		-DSCREENCOPY_HYPRLAND_TOPLEVEL=${_screencopy}
		-DSCREENCOPY_ICC=${_screencopy}
		-DSCREENCOPY_WLR=${_screencopy}
		-DSERVICE_GREETD=$(usex greetd)
		-DSERVICE_MPRIS=$(usex mpris)
		-DSERVICE_NOTIFICATIONS=$(usex notifications)
		-DSERVICE_PAM=$(usex pam)
		-DSERVICE_PIPEWIRE=$(usex pipewire)
		-DSERVICE_POLKIT=$(usex policykit)
		-DSERVICE_STATUS_NOTIFIER=$(usex tray)
		-DSERVICE_UPOWER=$(usex upower)
		-DSOCKETS=$(usex sockets)
		-DUSE_JEMALLOC=$(usex jemalloc)
		-DWAYLAND=$(usex wayland)
		-DWAYLAND_SESSION_LOCK=$(usex session-lock)
		-DWAYLAND_TOPLEVEL_MANAGEMENT=$(usex toplevel-management)
		-DWAYLAND_WLR_LAYERSHELL=$(usex layer-shell)
		-DX11=$(usex X)
	)
	cmake_src_configure
}

# OILEDMACHINE_OVERLAY_TEST:  PASSED interactive 0.0.12 (20260523)
