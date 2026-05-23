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

inherit branding cflags-hardened cmake libcxx-slot libstdcxx-slot

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
+bluetooth +crash-handler +dbus +dwl +hyprland +greetd +i3 +jemalloc
+layer-shell +mpris +networkmanager +niri +notifications +pam +pipewire
+policykit +screencopy +session-lock +sockets test +toplevel-management
+tray +upower +wayland +X
ebuild_revision_1
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
		wayland
	)
	layer-shell? (
		wayland
	)
	niri? (
		wayland
	)
	screencopy? (
		wayland
	)
	session-lock? (
		wayland
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
	dev-qt/qtbase:6[${LIBCXX_USEDEP_DEV},${LIBSTDCXX_USEDEP_DEV},dbus?,gui,vulkan,wayland?,widgets,X?]
	dev-qt/qtbase:=
	dev-qt/qtdeclarative:6[${LIBCXX_USEDEP_DEV},${LIBSTDCXX_USEDEP_DEV},vulkan,widgets]
	dev-qt/qtdeclarative:=
	dev-qt/qtsvg:6[${LIBCXX_USEDEP_DEV},${LIBSTDCXX_USEDEP_DEV}]
	dev-qt/qtsvg:=
	bluetooth? (
		net-wireless/bluez
	)
	jemalloc? (
		dev-libs/jemalloc
	)
	networkmanager? (
		net-misc/networkmanager
	)
	pam? (
		sys-libs/pam
	)
	pipewire? (
		media-video/pipewire
	)
	policykit? (
		dev-libs/glib
		sys-auth/polkit
	)
	screencopy? (
		media-libs/mesa
		x11-libs/libdrm
	)
	wayland? (
		dev-libs/wayland
		dev-qt/qtwayland:6[${LIBCXX_USEDEP_DEV},${LIBSTDCXX_USEDEP_DEV}]
		dev-qt/qtwayland:=
	)
	X? (
		x11-libs/libxcb
	)
"
DEPEND="
	${RDEPEND}
	screencopy? (
		dev-util/vulkan-headers:=
	)
"
BDEPEND="
	dev-build/cmake
	dev-build/ninja
	dev-cpp/cli11
	dev-qt/qtshadertools:6[${LIBCXX_USEDEP_DEV},${LIBSTDCXX_USEDEP_DEV}]
	dev-qt/qtshadertools:=
	dev-util/spirv-tools
	virtual/pkgconfig
	crash-handler? (
		dev-cpp/cpptrace[unwind]
	)
	wayland? (
		dev-libs/wayland-protocols
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
	cflags-hardened_append
	# Hyprland controls all Hyprland sub-features as a group.
	# i3 controls I3 / Sway IPC.
	# niri controls Niri IPC.
	# screencopy controls all screencopy backends (icc, wlr, hyprland-toplevel).
	local _hyprland=$(usex hyprland)
	local _i3=$(usex i3)
	local _niri=$(usex niri)
	local _screencopy=$(usex screencopy)

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
		-DHYPRLAND_IPC=${_hyprland}
		-DHYPRLAND_SURFACE_EXTENSIONS=${_hyprland}
		-DI3=${_i3}
		-DI3_IPC=${_i3}
		-DNETWORK=$(usex networkmanager)
		-DNIRI=${_niri}
		-DNIRI_IPC=${_niri}
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
