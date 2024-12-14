# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-bad"

inherit gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"

DESCRIPTION="WildMIDI soft synth plugin for GStreamer"
RDEPEND="
	>=media-sound/wildmidi-0.4.2
	~media-libs/gst-plugins-base-${PV}:1.0
"
DEPEND="
	${RDEPEND}
"
