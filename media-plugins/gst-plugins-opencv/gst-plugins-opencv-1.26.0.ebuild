# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-bad"

inherit cflags-hardened gstreamer-meson

KEYWORDS="~amd64 ~arm64 ~x86"

DESCRIPTION="OpenCV elements for GStreamer"
IUSE="
ebuild_revision_11
"
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
	cflags-hardened_append
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
