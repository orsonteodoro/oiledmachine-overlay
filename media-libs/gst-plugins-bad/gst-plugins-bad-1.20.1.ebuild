# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE="gst-plugins-bad"
PYTHON_COMPAT=( python3_{8,9,10} )
inherit flag-o-matic gstreamer-meson python-any-r1

DESCRIPTION="Less plugins for GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"

LICENSE="LGPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

# TODO: egl and gtk IUSE only for transition
IUSE="X bzip2 +egl gles2 gtk +introspection +opengl +orc vnc wayland" # Keep default IUSE mirrored with gst-plugins-base where relevant

VAAPI_DRIVERS="
video_cards_amdgpu video_cards_intel video_cards_iris video_cards_i965
video_cards_nouveau video_cards_nvidia video_cards_r600 video_cards_radeonsi
"

# Using vaapi stateless support via gst-plugins-bad.
# The gst-plugins-vaapi (or stateful version) is discontinued (EOL).
IUSE+="
	${VAAPI_DRIVERS}
	vaapi
"
REQUIRED_USE+="
	vaapi? ( || ( ${VAAPI_DRIVERS} ) )
	video_cards_amdgpu? (
		!video_cards_r600
		!video_cards_radeonsi
	)
	video_cards_r600? (
		!video_cards_amdgpu
		!video_cards_radeonsi
	)
	video_cards_radeonsi? (
		!video_cards_amdgpu
		!video_cards_r600
	)
"

# Do the check here because ebuild maintainer do not do the check in
# media-libs/gst-plugins-bad.
# See https://gitlab.freedesktop.org/gstreamer/gstreamer/-/blob/1.20.3/subprojects/gst-plugins-bad/sys/va/meson.build#L33
MESA_PV="22.1.7"
LIBVA_DEPEND="
	vaapi? (
		|| (
			video_cards_amdgpu? (
				>=media-libs/mesa-${MESA_PV}:=[vaapi,video_cards_radeonsi,${MULTILIB_USEDEP}]
			)
			video_cards_i965? (
				|| (
					x11-libs/libva-intel-media-driver
					x11-libs/libva-intel-driver[${MULTILIB_USEDEP}]
				)
			)
			video_cards_intel? (
				|| (
					x11-libs/libva-intel-media-driver
					x11-libs/libva-intel-driver[${MULTILIB_USEDEP}]
				)
			)
			video_cards_iris? (
				x11-libs/libva-intel-media-driver
			)
			video_cards_nouveau? (
				>=media-libs/mesa-${MESA_PV}:=[video_cards_nouveau,${MULTILIB_USEDEP}]
				|| (
					media-libs/mesa:=[vaapi,video_cards_nouveau,${MULTILIB_USEDEP}]
					>=x11-libs/libva-vdpau-driver-0.7.4-r3[${MULTILIB_USEDEP}]
				)
			)
			video_cards_nvidia? (
				>=x11-libs/libva-vdpau-driver-0.7.4-r1[${MULTILIB_USEDEP}]
				x11-drivers/nvidia-drivers
			)
			video_cards_r600? (
				>=media-libs/mesa-${MESA_PV}:=[vaapi,video_cards_r600,${MULTILIB_USEDEP}]
			)
			video_cards_radeonsi? (
				>=media-libs/mesa-${MESA_PV}:=[vaapi,video_cards_radeonsi,${MULTILIB_USEDEP}]
			)
		)
	)
"

# X11 is automagic for now, upstream #709530 - only used by librfb USE=vnc plugin
# We mirror opengl/gles2 from -base to ensure no automagic openglmixers plugin (with "opengl?" it'd still get built with USE=-opengl here)
# FIXME	gtk? ( >=media-plugins/gst-plugins-gtk-${PV}:${SLOT}[${MULTILIB_USEDEP}] )
RDEPEND="
	!media-plugins/gst-transcoder
	>=media-libs/gstreamer-${PV}:${SLOT}[${MULTILIB_USEDEP},introspection?]
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP},egl?,introspection?,gles2=,opengl=]
	introspection? ( >=dev-libs/gobject-introspection-1.31.1:= )

	bzip2? ( >=app-arch/bzip2-1.0.6-r4[${MULTILIB_USEDEP}] )
	vaapi? (
		${LIBVA_DEPEND}
		dev-libs/libgudev
		>=x11-libs/libva-1.8:=[${MULTILIB_USEDEP}]
	)
	vnc? ( X? ( x11-libs/libX11[${MULTILIB_USEDEP}] ) )
	wayland? (
		>=dev-libs/wayland-1.4.0[${MULTILIB_USEDEP}]
		>=x11-libs/libdrm-2.4.55[${MULTILIB_USEDEP}]
		>=dev-libs/wayland-protocols-1.15
	)

	orc? ( >=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}] )
"

DEPEND="${RDEPEND}"

BDEPEND="
	${PYTHON_DEPS}
	dev-util/glib-utils
"

DOCS=( AUTHORS ChangeLog NEWS README.md RELEASE )

# FIXME: gstharness.c:889:gst_harness_new_with_padnames: assertion failed: (element != NULL)
RESTRICT="test"

# Fixes backported to 1.20.1, to be removed in 1.20.2+
PATCHES=(
)

src_prepare() {
	default
	addpredict /dev # Prevent sandbox violations bug #570624
}

multilib_src_configure() {
	GST_PLUGINS_NOAUTO="shm ipcpipeline librfb hls va"

	local emesonargs=(
		-Dshm=enabled
		-Dipcpipeline=enabled
		-Dhls=disabled
		$(meson_feature vaapi va)
		$(meson_feature vnc librfb)

		$(meson_feature wayland)
	)

	if use opengl || use gles2; then
		myconf+=( -Dgl=enabled )
	else
		myconf+=( -Dgl=disabled )
	fi

	GST_PLUGINS_EXT_DEPS="${GST_PLUGINS_EXT_DEPS} va"

	gstreamer_multilib_src_configure
}

multilib_src_test() {
	# Tests are slower than upstream expects
	CK_DEFAULT_TIMEOUT=300 gstreamer_multilib_src_test
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
