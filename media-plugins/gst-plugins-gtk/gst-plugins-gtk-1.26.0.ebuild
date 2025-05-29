# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# egl, wayland and X only matters if gst-plugins-base is built with USE=opengl
# and/or USE=gles2.  We mirror egl/gles2/opengl/wayland/X due to automagic
# detection from gstreamer-gl.pc variables.  We don't care about matching
# egl/wayland/X if both opengl and gles2 are disabled here and on
# gst-plugins-base, but there's no way to express that.

# We only need gtk+ matching backend flags when GL is enabled

CFLAGS_HARDENED_USE_CASES="plugin untrusted-data"
GST_ORG_MODULE="gst-plugins-good"
GST_PLUGINS_ENABLED="gtk3"

inherit cflags-hardened gstreamer-meson

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"

DESCRIPTION="Video sink plugin for GStreamer that renders to a GtkWidget"
# Keep default IUSE mirrored with gst-plugins-base
IUSE="
+egl +gles2 opengl wayland +X
ebuild_revision_11
"
GL_DEPS="
	>=x11-libs/gtk+-3.15:3[X?,wayland?,${MULTILIB_USEDEP}]
"
RDEPEND="
	>=x11-libs/gtk+-3.15:3[${MULTILIB_USEDEP}]
	~media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP},egl=,gles2=,opengl=,wayland=,X=]
	gles2? (
		${GL_DEPS}
	)
	opengl? (
		${GL_DEPS}
	)
"
DEPEND="
	${RDEPEND}
"

multilib_src_configure() {
	cflags-hardened_append
	gstreamer_multilib_src_configure
}
