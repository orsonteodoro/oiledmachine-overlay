# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DESCRIPTION="Meta package for liri"
HOMEPAGE="https://liri.io/"
SLOT="0/$(ver_cut 1-3 ${PV})" # based on liri-base/liri-shell
IUSE+="
appcenter browser calculator +files flatpak music networkmanager
player power-manager pulseaudio samtal screencast screenshot +settings systemd
+terminal text themes wallpaper

wayland eglfs X

r2
"
REQUIRED_USE+="
	|| (
		wayland
		X
	)
"
DEPEND+="
	appcenter? (
		~liri-extra/appcenter-0.1.0_p9999[wayland?,X?]
	)
	browser? (
		~liri-extra/browser-1.2.0_p9999[wayland?,X?]
	)
	calculator? (
		~liri-extra/calculator-1.3.0_p9999[wayland?,X?]
	)
	files? (
		~liri-base/files-0.2.0_p9999[wayland?,X?]
	)
	flatpak? (
		~liri-base/xdg-desktop-portal-liri-0.0.0_p9999
	)
	music? (
		~liri-extra/music-1.0.0_p9999[wayland?,X?]
	)
	networkmanager? (
		~liri-extra/networkmanager-0.9.0_p9999
	)
	player? (
		~liri-extra/player-0.1.0_p9999[wayland?,X?]
	)
	power-manager? (
		~liri-extra/power-manager-0.9.0_p9999
	)
	pulseaudio? (
		~liri-base/pulseaudio-0.9.0_p9999
	)
	samtal? (
		~liri-extra/samtal-0.1.0_p9999[wayland?,X?]
	)
	screencast? (
		~liri-extra/screencast-0.9.0_p9999
	)
	screenshot? (
		~liri-extra/screenshot-0.9.0_p9999
	)
	settings? (
		~liri-base/settings-0.9.0_p9999
	)
	terminal? (
		~liri-extra/terminal-0.2.0_p9999[wayland?,X?]
	)
	text? (
		~liri-extra/text-0.5.0_p9999[wayland?,X?]
	)
	themes? (
		~liri-base/themes-0.9.0_p9999
	)
	wallpaper? (
		~liri-base/wallpapers-0.10.0_p9999
	)
	~liri-base/session-0.1.0_p9999[eglfs?,systemd?,wayland?,X?]
	~liri-base/shell-${PV}[systemd?]
"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	~liri-base/cmake-shared-2.0.0_p9999
	~liri-base/fluid-1.2.0_p9999
"
RESTRICT="mirror"

pkg_postinst() {
ewarn
ewarn "Please switch to the Mesa GL driver.  Do not use the proprietary driver."
ewarn
ewarn "Failure to do so can cause the following:"
ewarn
ewarn "  -The cursor and wallpaper will not show properly if you ran"
ewarn "   \`liri-session -- -platform xcb\`"
ewarn "  -The -platform eglfs mode may not work at all."
ewarn
einfo
einfo "To run a Liri session in X do:"
einfo
einfo "  startx"
einfo "  open terminal program"
einfo "  liri-session"
einfo
ewarn "liri-session will not work with .xinitrc."
einfo
einfo
einfo "To run a Liri session in EGL fullscreen do:"
einfo
einfo "  sudo gpasswd -a <user> input"
einfo "  logout and login"
einfo "  liri-session -- -platform eglfs"
einfo
einfo
einfo "To run a Liri session in Wayland with Weston do:"
einfo
einfo "  sudo emerge -1vuDN weston[desktop,drm,fullscreen,gles2,seatd]"
einfo "  export XDG_RUNTIME_DIR=/tmp/xdg-runtime-\$(id -u)"
einfo "  weston --shell=fullscreen-shell.so"
einfo "  open terminal program"
einfo "  QT_WAYLAND_SHELL_INTEGRATION=fullscreen-shell liri-session -- -platform wayland"
einfo
einfo
einfo "To run a Liri session in Wayland with dwl do:"
einfo
einfo "  export XDG_RUNTIME_DIR=/tmp/xdg-runtime-\$(id -u)"
einfo "  dwl -s \"liri-session -- -platform wayland\""
einfo
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
