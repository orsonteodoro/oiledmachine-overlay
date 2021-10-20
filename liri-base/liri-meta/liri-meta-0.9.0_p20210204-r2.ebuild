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
	platformtheme? ( !qtintegration )
	qtintegration? ( !materialdecoration !platformtheme )
"
DEPEND+="
	~liri-base/session-0.1.0_pre20200524[systemd?]
	~liri-base/shell-0.9.0_p20210204:${SLOT}[systemd?]
	appcenter? ( ~liri-base/appcenter-0.1.0_p20200527 )
	browser? ( ~liri-extra/browser-1.2.0_pre20201011 )
	calculator? ( ~liri-extra/calculator-1.3.0_p20201120 )
	files? ( ~liri-base/files-0.2.0_p20201120 )
	flatpak? ( ~liri-base/xdg-desktop-portal-liri-0.0.0_pre20201029[flatpak] )
	materialdecoration? ( ~liri-base/materialdecoration-1.1.0_pre20210215 )
	music? ( ~liri-extra/music-1.0.0_pre20200314 )
	networkmanager? ( ~liri-extra/networkmanager-0.9.0_pre20210124 )
	platformtheme? ( ~liri-base/platformtheme-1.0.0_p20201202 )
	player? ( ~liri-extra/player-0.1.0_pre20201030 )
	power-manager? ( ~liri-extra/power-manager-0.9.0_pre20210110 )
	pulseaudio? ( ~liri-base/pulseaudio-0.9.0_pre20210111 )
	qtintegration? ( ~liri-base/qtintegration-1.0.0_p20210215 )
	screencast? ( ~liri-extra/screencast-0.9.0_pre20201203 )
	screenshot? ( ~liri-extra/screenshot-0.9.0_pre20201204 )
	settings? ( ~liri-base/settings-0.9.0_p20201219 )
	terminal? ( ~liri-base/terminal-0.2.0_p20201120 )
	text? ( ~liri-extra/text-0.5.0_p20201120 )
	themes? ( ~liri-base/themes-0.9.0_p20201202 )
	wallpaper? ( ~liri-base/wallpapers-0.10.0_p20201011 )
	xwayland? ( ~liri-base/qml-xwayland-0.10.0_p20201203 )"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	~liri-base/cmake-shared-1.1.0_p20210103
	~liri-base/fluid-1.2.0_p20210121
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
