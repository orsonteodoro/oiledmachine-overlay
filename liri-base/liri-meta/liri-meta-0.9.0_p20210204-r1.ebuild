# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Meta package for liri"
HOMEPAGE="https://liri.io/"
SLOT="0/${PV}" # based on liri-base/liri-shell
IUSE+=" appcenter browser calculator +files flatpak materialdecoration music \
networkmanager +platformtheme player power-manager pulseaudio screencast \
screenshot +settings systemd +terminal text themes wallpaper xwayland"
DEPEND+=" appcenter? ( liri-base/appcenter )
	 browser? ( liri-extra/browser )
	 calculator? ( liri-extra/calculator )
	 files? ( liri-base/files )
	 flatpak? ( liri-base/xdg-desktop-portal-liri[flatpak] )
	 >=liri-base/session-0.1.0_pre20200524[systemd?]
	   liri-base/shell:${SLOT}[systemd?]
	 materialdecoration? ( liri-base/materialdecoration )
	 music? ( liri-extra/music )
	 networkmanager? ( liri-extra/networkmanager )
	 platformtheme? ( liri-base/platformtheme )
	 player? ( liri-extra/player )
	 power-manager? ( liri-extra/power-manager )
	 pulseaudio? ( liri-base/pulseaudio )
	 screencast? ( liri-extra/screencast )
	 screenshot? ( liri-extra/screenshot )
	 settings? ( liri-base/settings )
	 terminal? ( liri-base/terminal )
	 text? ( liri-extra/text )
	 themes? ( liri-base/themes )
	 xwayland? ( liri-base/qml-xwayland )"
RDEPEND+=" ${DEPEND}"
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
