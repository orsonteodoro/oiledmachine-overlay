# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-bad"

inherit gstreamer-meson

KEYWORDS="~amd64 ~arm64 ~x86"

DESCRIPTION="OpenCV elements for GStreamer"
RDEPEND="
	>=media-libs/opencv-4.0.0:=[${MULTILIB_USEDEP},contrib,contribdnn]
"
DEPEND="
	${RDEPEND}
"
PATCHES=(
#	"${FILESDIR}/gst-plugins-bad-1.22.3-use-system-libs-opencv.patch"
)

multilib_src_configure() {
	local emesonargs=(
		# We need to disable here to avoid colliding w/ gst-plugins-bad
		# on translations, because we currently do a "full" install in
		# multilib_src_install in this package. See bug #907480.
		-Dnls=disabled
	)
	gstreamer_multilib_src_configure
}

multilib_src_install() {
	DESTDIR="${D}" \
	eninja install
}