# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Meta package for liri"
HOMEPAGE="https://liri.io/"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}" # based on liri-base/liri-shell
IUSE="calculator +files networkmanager pulseaudio +settings systemd +terminal text xwayland"
RDEPEND="calculator? ( liri-extra/calculator )
	 files? ( liri-base/files )
	 >=liri-base/session-0.1.0_p20200524[systemd?]
	   liri-base/shell:${SLOT}[systemd?]
	 networkmanager? ( liri-extra/networkmanager )
	 pulseaudio? ( liri-base/pulseaudio )
	 settings? ( liri-base/settings )
	 terminal? ( liri-base/terminal )
	 text? ( liri-extra/text )
	 xwayland? ( liri-base/qml-xwayland )"
RESTRICT="mirror"
