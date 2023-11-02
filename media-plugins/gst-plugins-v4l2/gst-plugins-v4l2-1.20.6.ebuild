# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer-meson

DESCRIPION="V4L2 source/sink plugin for GStreamer"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ~ppc ppc64 ~riscv ~sparc x86"
IUSE="udev"
# See sys/v4l2/meson.build
RDEPEND="
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP}]
	>=media-libs/libv4l-0.9.5[${MULTILIB_USEDEP}]
	udev? (
		>=dev-libs/libgudev-208:=[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	virtual/os-headers
"

GST_PLUGINS_ENABLED="v4l2"

multilib_src_configure() {
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
einfo " or"
einfo
einfo "Run \`source /etc/profile\`"
einfo
}
