# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Meta package for liri"
HOMEPAGE="https://liri.io/"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}" # based on liri-base/liri-shell
IUSE="+files pulseaudio systemd +terminal xwayland"
RDEPEND="files? ( liri-base/files )
	 >=liri-base/session-0.1.0_p20200524[systemd?]
	   liri-base/shell:${SLOT}[systemd?]
	 pulseaudio? ( liri-base/pulseaudio )
	 terminal? ( liri-base/terminal )
	 xwayland? ( liri-base/qml-xwayland )"
RESTRICT="mirror"
