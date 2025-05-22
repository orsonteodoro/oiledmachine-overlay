# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-ugly"

inherit cflags-hardened gstreamer-meson

#KEYWORDS="~alpha ~amd64 ~arm64 ~ppc ~ppc64 ~sparc ~x86"

DESCRIPTION="Sid decoder plugin for GStreamer"
IUSE="
ebuild_revision_5
"
RDEPEND="
	media-libs/libsidplay:1[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	cflags-hardened_append
	local emesonargs=(
		-Dgpl=enabled
	)
	gstreamer_multilib_src_configure
}
