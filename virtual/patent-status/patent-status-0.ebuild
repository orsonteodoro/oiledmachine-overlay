# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PATENT_STATUS=(
	patent_status_nonfree
	patent_status_sponsored_ncp_nb
)

DESCRIPTION="A virtual package for patent status consistency across ebuilds"
LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="
${PATENT_STATUS[@]}
"

# The libva, libvdpau are blacklisted because drivers/packages typically do not
# have a conditional choice between free and nonfree like in the mesa package.
# Many packages make the patented package unconditonal.  We want to prevent
# inadvertant conversion or contamination of content wrapped in nonfree.  These
# restrictions can be removed once the packages are properly fixed to
# prune/disable nonfree support.  Sometimes, app developers do not give you a
# choice to select the codec.  The disabled patent_status_nonfree USE flag can
# help encourage packagers to mod for free codec/containers supported
# configurations.

# The ffmpeg-chromium is blacklisted because it is misconfigured to
# unconditionally enable patented codecs (aac, h264).

# The distro's fdk-aac ebuild references a tarball containing the nonfree
# folders referencing unexpired patents based on commit message.  This is why it
# is blacklisted.  It can be fixed by using the same tarball as Fedora's
# fdk-aac-free package.  The free was suggested in the Wikipedia page for just
# the expired variant.

RDEPEND+="
	!patent_status_nonfree? (
		!media-libs/faac
		!media-libs/faad2
		!media-libs/fdk-aac
		!media-libs/intel-mediasdk
		!media-libs/kvazaar
		!media-libs/libde265
		!media-libs/libva
		!media-libs/libvpl
		!media-libs/oneVPL-cpu
		!media-libs/oneVPL-intel-gpu
		!media-libs/openh264
		!media-libs/raspberrypi-userland
		!media-libs/vaapi-drivers
		!media-libs/vo-aacenc
		!media-libs/vpl-gpu-rt
		!media-libs/vvdec
		!media-libs/x264
		!media-libs/x265
		!media-plugins/gst-plugins-dash
		!media-plugins/gst-plugins-faac
		!media-plugins/gst-plugins-faad
		!media-plugins/gst-plugins-fdkaac
		!media-plugins/gst-plugins-fmp4
		!media-plugins/gst-plugins-hls
		!media-plugins/gst-plugins-hlsmultivariantsink
		!media-plugins/gst-plugins-hlssink3
		!media-plugins/gst-plugins-libde265
		!media-plugins/gst-plugins-mp4
		!media-plugins/gst-plugins-openh264
		!media-plugins/gst-plugins-uvch264
		!media-plugins/gst-plugins-vaapi
		!media-plugins/gst-plugins-voaacenc
		!media-plugins/gst-plugins-vvdec
		!media-plugins/gst-plugins-x264
		!media-plugins/gst-plugins-x265
		!media-video/amdgpu-pro-amf
		!media-video/ffmpeg-chromium
		!x11-libs/libvdpau
	)
"
DEPEND+="
	${RDEPEND}
"
