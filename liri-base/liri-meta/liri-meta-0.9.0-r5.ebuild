# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Meta package for liri"
HOMEPAGE="https://liri.io/"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}" # based on liri-base/liri-shell
IUSE="appcenter browser calculator +files flatpak networkmanager platformtheme \
power-manager pulseaudio +settings systemd +terminal text themes wallpaper \
xwayland"
RDEPEND="appcenter? ( liri-base/appcenter )
	 browser? ( liri-extra/browser )
	 calculator? ( liri-extra/calculator )
	 files? ( liri-base/files )
	 flatpak? ( liri-base/xdg-desktop-portal-liri[flatpak] )
	 >=liri-base/session-0.1.0_p20200524[systemd?]
	   liri-base/shell:${SLOT}[systemd?]
	 networkmanager? ( liri-extra/networkmanager )
	 platformtheme? ( liri-base/platformtheme )
	 power-manager? ( liri-extra/power-manager )
	 pulseaudio? ( liri-base/pulseaudio )
	 settings? ( liri-base/settings )
	 terminal? ( liri-base/terminal )
	 text? ( liri-extra/text )
	 themes? ( liri-base/themes )
	 xwayland? ( liri-base/qml-xwayland )"
RESTRICT="mirror"
