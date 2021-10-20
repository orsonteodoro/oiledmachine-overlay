# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Meta package for liri"
HOMEPAGE="https://liri.io/"
SLOT="0/${PV}" # based on liri-base/liri-shell
IUSE+=" appcenter browser calculator +files flatpak materialdecoration music \
networkmanager +platformtheme player power-manager pulseaudio qtintegration \
screencast screenshot +settings systemd +terminal text themes wallpaper \
xwayland"
REQUIRED_USE="
	materialdecoration? ( !qtintegration )
	qtintegration? ( materialdecoration )
"
DEPEND+="
	~liri-base/session-0.1.0_pre20211010[systemd?]
	~liri-base/shell-0.9.0_p20211010:${SLOT}[systemd?]
	appcenter? ( liri-base/appcenter )
	browser? ( ~liri-extra/browser-1.2.0_pre20211009 )
	calculator? ( liri-extra/calculator )
	files? ( ~liri-base/files-0.2.0_p20211010 )
	flatpak? ( liri-base/xdg-desktop-portal-liri[flatpak] )
	materialdecoration? ( liri-base/materialdecoration )
	music? ( liri-extra/music )
	networkmanager? ( ~liri-extra/networkmanager-0.9.0_pre20211009 )
	platformtheme? ( liri-base/platformtheme )
	player? ( ~liri-extra/player-0.1.0_pre20211009 )
	power-manager? ( ~liri-extra/power-manager-0.9.0_pre20211010 )
	pulseaudio? ( ~liri-base/pulseaudio-0.9.0_pre20211010 )
	qtintegration? ( ~liri-base/qtintegration-1.0.0_p20211009 )
	screencast? ( liri-extra/screencast )
	screenshot? ( liri-extra/screenshot )
	settings? ( ~liri-base/settings-0.9.0_p20211010 )
	terminal? ( ~liri-base/terminal-0.2.0_p20211010 )
	text? ( liri-extra/text )
	themes? ( ~liri-base/themes-0.9.0_p20211009 )
	wallpaper? ( ~liri-base/wallpapers-0.10.0_p20211009 )
	xwayland? ( ~liri-base/qml-xwayland-0.10.0_p20211009 )"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	~liri-base/cmake-shared-2.0.0_p20211010
	~liri-base/fluid-1.2.0_p20211009
"
RESTRICT="mirror"

pkg_postinst() {
	ewarn
	ewarn \
"If you have installed the Pro OpenGL drivers from the AMDGPU-PRO package, \n"\
"please switch to the Mesa GL driver instead.\n"\
"\n"\
"Failure to do so can cause the following:\n"\
"  -The cursor and wallpaper will not show properly if you ran\n"\
"   \`liri-session -- -platform xcb\`.\n"\
"  -The -platform eglfs mode may not work at all."
	ewarn
	einfo \
"To run Liri in X run:\n"\
"  liri-session -- -platform xcb\n"\
"\n"\
"To run Liri in KMS from a VT run:\n"\
"  liri-session -- -platform eglfs\n"\
"\n"
}
