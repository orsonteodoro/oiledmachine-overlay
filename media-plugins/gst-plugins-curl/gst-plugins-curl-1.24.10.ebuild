# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE="gst-plugins-bad"

inherit gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"

DESCRIPTION="cURL network source and sink for GStreamer"
IUSE="ssh"
RDEPEND="
	>=net-misc/curl-7.55.0[${MULTILIB_USEDEP},ssh?]
	~media-libs/gst-plugins-base-${PV}:1.0[${MULTILIB_USEDEP}]
	ssh? (
		>=net-libs/libssh2-1.4.3[${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	GST_PLUGINS_NOAUTO="curl-ssh2"
	local emesonargs=(
		-Dcurl-ssh2=$(usex ssh "enabled" "disabled")
	)
	gstreamer_multilib_src_configure
}