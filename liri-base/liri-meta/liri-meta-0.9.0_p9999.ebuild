# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DESCRIPTION="Meta package for liri"
HOMEPAGE="https://liri.io/"
SLOT="0/$(ver_cut 1-3 ${PV})" # based on liri-base/liri-shell
IUSE+="
appcenter browser calculator +files flatpak music networkmanager player
power-manager pulseaudio qtintegration screencast screenshot +settings systemd
+terminal text themes wallpaper

r1
"
XDG_DESKTOP_PORTAL_LIRI_PV="0.0.0_p9999"
DEPEND+="
	appcenter? (
		~liri-extra/appcenter-0.1.0_p9999
		~liri-base/xdg-desktop-portal-liri-${XDG_DESKTOP_PORTAL_LIRI_PV}
	)
	browser? (
		~liri-extra/browser-1.2.0_p9999
	)
	calculator? (
		~liri-extra/calculator-1.3.0_p9999
	)
	files? (
		~liri-base/files-0.2.0_p9999
	)
	flatpak? (
		~liri-base/xdg-desktop-portal-liri-${XDG_DESKTOP_PORTAL_LIRI_PV}
	)
	music? (
		~liri-extra/music-1.0.0_p9999
	)
	networkmanager? (
		~liri-extra/networkmanager-0.9.0_p9999
	)
	player? (
		~liri-extra/player-0.1.0_p9999
	)
	power-manager? (
		~liri-extra/power-manager-0.9.0_p9999
	)
	pulseaudio? (
		~liri-base/pulseaudio-0.9.0_p9999
	)
	qtintegration? (
		~liri-base/qtintegration-1.0.0_p9999
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
		~liri-base/terminal-0.2.0_p9999
	)
	text? (
		~liri-extra/text-0.5.0_p9999
	)
	themes? (
		~liri-base/themes-0.9.0_p9999
	)
	wallpaper? (
		~liri-base/wallpapers-0.10.0_p9999
	)
	~liri-base/session-0.1.0_p9999[systemd?]
	~liri-base/shell-${SLOT#*/}[systemd?]
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
ewarn "  -The cursor and wallpaper will not show properly if you ran"
ewarn "   \`liri-session -- -platform xcb\`"
ewarn "  -The -platform eglfs mode may not work at all."
ewarn
einfo "To run Liri in X run:"
einfo "  liri-session -- -platform xcb"
einfo
einfo "To run Liri in KMS from a VT run:"
einfo "  liri-session -- -platform eglfs"
einfo
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
