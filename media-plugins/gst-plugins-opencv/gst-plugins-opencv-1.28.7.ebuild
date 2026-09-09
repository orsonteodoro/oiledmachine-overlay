# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin sensitive-data untrusted-data"
GST_ORG_MODULE="gst-plugins-bad"

CHKL_TIMESTAMPS=(
	"media-libs/opencv-4.9999"
	"media-libs/opencv-5.9999"
)

inherit cflags-hardened chkl secure-version gstreamer-meson

KEYWORDS="~amd64 ~arm64 ~x86"

DESCRIPTION="OpenCV elements for GStreamer"
IUSE="
ebuild_revision_24
"
RDEPEND="
	media-libs/opencv:=[${MULTILIB_USEDEP},contrib,contribdnn]
	|| (
		~media-libs/opencv-${OPENCV4_PV}[${MULTILIB_USEDEP},contrib,contribdnn]
		~media-libs/opencv-${OPENCV5_PV}[${MULTILIB_USEDEP},contrib,contribdnn]
	)
"
DEPEND="
	${RDEPEND}
"
PATCHES=(
#	"${FILESDIR}/gst-plugins-bad-1.22.3-use-system-libs-opencv.patch"
)

multilib_src_configure() {
	chkl_check_many_timestamps
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
