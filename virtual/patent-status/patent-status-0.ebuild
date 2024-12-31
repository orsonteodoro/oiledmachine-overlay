# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PATENT_STATUS=(
	patent_status_nonfree
	patent_status_sponsored_ncp_nb
)

DESCRIPTION="A virtual for patent status consistency across ebuilds"
LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="
${PATENT_STATUS[@]}
"

# The ffmpeg-chromium is blacklisted because it is misconfigured to
# unconditionally enable patented codecs (aac, h264).

RDEPEND+="
	!patent_status_nonfree? (
		!media-libs/faac
		!media-libs/faad2
		!media-libs/fdk-aac
		!media-libs/kvazaar
		!media-libs/libde265
		!media-libs/libva
		!media-libs/openh264
		!media-libs/vaapi-drivers
		!media-libs/vo-aacenc
		!media-libs/x264
		!media-libs/x265
		!media-plugins/gst-plugins-dash
		!media-plugins/gst-plugins-faac
		!media-plugins/gst-plugins-faad
		!media-plugins/gst-plugins-fdkaac
		!media-plugins/gst-plugins-hls
		!media-plugins/gst-plugins-hlssink3
		!media-plugins/gst-plugins-libde265
		!media-plugins/gst-plugins-openh264
		!media-plugins/gst-plugins-uvch264
		!media-plugins/gst-plugins-vaapi
		!media-plugins/gst-plugins-voaacenc
		!media-plugins/gst-plugins-x264
		!media-plugins/gst-plugins-x265
		!media-video/ffmpeg-chromium
		!x11-libs/libvdpau
	)
"
DEPEND+="
	${RDEPEND}
"
