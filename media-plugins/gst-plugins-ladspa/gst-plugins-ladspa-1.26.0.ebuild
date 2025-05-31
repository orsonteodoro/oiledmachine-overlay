# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-bad"

inherit cflags-hardened gstreamer-meson

KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

DESCRIPTION="Ladspa elements for GStreamer"
IUSE="
rdf
ebuild_revision_13
"
RDEPEND="
	media-libs/ladspa-sdk[${MULTILIB_USEDEP}]
	rdf? (
		media-libs/liblrdf[${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	cflags-hardened_append
	local emesonargs=(
		$(meson_feature "rdf" "ladspa-rdf")
	)
	gstreamer_multilib_src_configure
}
