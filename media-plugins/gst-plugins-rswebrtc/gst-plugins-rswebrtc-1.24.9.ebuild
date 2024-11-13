# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"

DESCRIPTION="A redirect ebuild for gst-plugins-webrtc (Rust implementation)"
LICENSE="metapackage"
SLOT="1.0"
IUSE="aom nvcodec qsv vaapi vulkan x264 x265"
RDEPEND="
	~media-libs/gst-plugins-rs-${PV}:1.0[aom?,nvcodec?,qsv?,vaapi?,vulkan?,webrtc,x264?,x265?]
"
DEPEND="
	${RDEPEND}
"
