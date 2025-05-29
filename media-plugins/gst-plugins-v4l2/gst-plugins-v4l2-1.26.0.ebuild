# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See sys/v4l2/meson.build

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-good"
GST_PLUGINS_ENABLED="v4l2"

inherit cflags-hardened gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

DESCRIPTION="V4L2 source/sink plugin for GStreamer"
IUSE="
udev
ebuild_revision_11
"
RDEPEND="
	~media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP}]
	media-libs/libv4l[${MULTILIB_USEDEP}]
	udev? (
		>=dev-libs/libgudev-147:=[${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
	virtual/os-headers
"

multilib_src_configure() {
	cflags-hardened_append
	local emesonargs=(
		-Dv4l2-gudev=$(usex udev enabled disabled)
	)
	gstreamer_multilib_src_configure
}

multilib_src_install_all() {
	# Buried in https://github.com/GStreamer/gst-plugins-good/blob/master/sys/v4l2/gstv4l2src.c#L41
cat <<-EOF > "${T}"/99${PN}
GST_V4L2_USE_LIBV4L2=1
EOF
	doenvd "${T}"/99${PN}
}

pkg_postinst() {
	# Buried in https://github.com/GStreamer/gst-plugins-good/blob/master/sys/v4l2/gstv4l2src.c#L41
cat <<-EOF > "${T}"/99${PN}
GST_V4L2_USE_LIBV4L2=1
EOF
	doenvd "${T}"/99${PN}
einfo
einfo "You must restart your computer for changes to take affect."
einfo
einfo "  or"
einfo
einfo "Run \`source /etc/profile\`"
einfo
}
