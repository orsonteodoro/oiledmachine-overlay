# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# X11 is automagic for now, upstream #709530 - only used by librfb USE=vnc plugin
# Baseline requirement for libva is 1.6, but 1.10 gets more features

GST_ORG_MODULE="gst-plugins-bad"

inherit gstreamer-meson

KEYWORDS="
~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86
~amd64-linux ~arm64-macos ~x86-linux
"

DESCRIPTION="Less plugins for GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"
LICENSE="LGPL-2"
IUSE="X bzip2 +introspection +orc udev vaapi vnc wayland"
RDEPEND="
	!media-plugins/gst-plugins-va
	!media-plugins/gst-transcoder
	>=dev-libs/glib-2.64.0[${MULTILIB_USEDEP}]
	~media-libs/gstreamer-${PV}:${SLOT}[${MULTILIB_USEDEP},introspection?]
	~media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP},introspection?]
	bzip2? (
		app-arch/bzip2[${MULTILIB_USEDEP}]
	)
	introspection? (
		dev-libs/gobject-introspection:=
	)
	orc? (
		>=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}]
	)
	vaapi? (
		media-libs/libva:=[${MULTILIB_USEDEP}]
		udev? (
			dev-libs/libgudev[${MULTILIB_USEDEP}]
		)
	)
	vnc? (
		X? (
			x11-libs/libX11[${MULTILIB_USEDEP}]
		)
	)
	wayland? (
		>=dev-libs/wayland-1.4.0[${MULTILIB_USEDEP}]
		>=dev-libs/wayland-protocols-1.15
		>=x11-libs/libdrm-2.4.104[${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-util/glib-utils
"
DOCS=( "AUTHORS" "ChangeLog" "NEWS" "README.md" "RELEASE" )
PATCHES=(
#	"${FILESDIR}/0001-meson-Fix-libdrm-and-vaapi-configure-checks.patch"
#	"${FILESDIR}/0002-meson-Add-feature-options-for-optional-va-deps-libdr.patch"
)

src_prepare() {
	default
	addpredict "/dev" # Prevent sandbox violations bug #570624
}

multilib_src_configure() {
	GST_PLUGINS_NOAUTO="bz2 hls ipcpipeline librfb shm va wayland"
	local emesonargs=(
		$(meson_feature "bzip2" "bz2")
		$(meson_feature "vaapi" "va")
		$(meson_feature "vnc" "librfb")
		$(meson_feature "wayland")
		-Dshm="enabled"
		-Dipcpipeline="enabled"
		-Dhls="disabled"
		-Dudev=$(usex udev $(usex vaapi "enabled" "disabled") "disabled")
		-Dx11=$(usex X $(usex vnc "enabled" "disabled") "disabled")
	)
	gstreamer_multilib_src_configure
}

multilib_src_test() {
	# Tests are slower than upstream expects
	CK_DEFAULT_TIMEOUT=300 gstreamer_multilib_src_test
}
