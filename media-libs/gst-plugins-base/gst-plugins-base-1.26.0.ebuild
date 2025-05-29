# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# D12, F40

# For OpenGL we have three separate concepts, with a list of possibilities in
# each:
#  * opengl APIs - opengl and/or gles2; USE=opengl and USE=gles2 enable these
#    accordingly; if neither is enabled, OpenGL helper library and elements are
#    not built at all and all the other options aren't relevant
#  * opengl platforms - glx and/or egl; also cgl, wgl, eagl for non-linux;
#    USE="X opengl" enables glx platform; USE="egl" enables egl platform.  The
#    rest is up for relevant prefix teams.
#  * opengl windowing system - x11, wayland, win32, cocoa, android, viv_fb, gbm
#    and/or dispmanx; USE=X enables x11 (but for WSI it's automagic - FIXME),
#    USE=wayland enables wayland, USE=gbm enables gbm (automagic upstream -
#    FIXME); rest is up for relevant prefix/arch teams/contributors to test and
#    provide patches
# With the following limitations:
#  * If opengl and/or gles2 is enabled, a platform has to be enabled - x11 or
#    egl in our case, but x11 (glx) is acceptable only with opengl
#  * If opengl and/or gles2 is enabled, a windowing system has to be enabled -
#    x11, wayland or gbm in our case
#  * glx platform requires opengl API (but we don't REQUIRED_USE that as USE=X
#    is common, glx is just disabled with USE=-opengl or USE=-X)
#  * wayland, gbm and most other non-glx WSIs require egl platform
# Additionally there is optional dmabuf support with egl for additional dmabuf
# based upload/download/eglimage options; and optional graphene usage for
# gltransformation and glvideoflip elements and more GLSL Uniforms support in
# glshader; and libpng/jpeg are required for gloverlay element;

# Keep default IUSE options for relevant ones mirrored with gst-plugins-gtk and
# gst-plugins-bad

CFLAGS_HARDENED_USE_CASES="network untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO CE HO IO SO"
GST_ORG_MODULE="gst-plugins-base"
MITIGATION_DATE="Dec 3, 2024" # Advisory date
MITIGATION_URI="https://gstreamer.freedesktop.org/security/"
SEVERITY_LABEL="CVSS 4.0"
VULNERABILITIES_FIXED=(
	"CVE-2024-47615;CE, DoS, DT, ID;High"
	"CVE-2024-47607;DoS, DT, ID;High"
	"CVE-2024-47538;DoS, DT, ID;High"
	"CVE-2024-47600;DoS, DT;Medium"
	"CVE-2024-47541;DoS;Medium"
	"CVE-2024-47835;DoS;Medium"
	"CVE-2024-47542;DoS;Medium"
)

inherit cflags-hardened flag-o-matic gstreamer-meson vf

KEYWORDS="
~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86
~amd64-linux ~arm64-macos ~x86-linux
"

DESCRIPTION="A based set of plugins meeting code quality and support needs of GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"
LICENSE="GPL-2+ LGPL-2+"
IUSE="
alsa +egl gbm +gles2 +introspection ivorbis nls +ogg opengl +orc +pango theora
+vorbis wayland +X
ebuild_revision_13
"
GL_REQUIRED_USE="
	|| (
		gbm
		wayland
		X
	)
	gbm? (
		egl
	)
	wayland? (
		egl
	)
"
REQUIRED_USE="
	ivorbis? (
		ogg
	)
	theora? (
		ogg
	)
	vorbis? (
		ogg
	)
	opengl? (
		${GL_REQUIRED_USE}
		|| (
			egl
			X
		)
	)
	gles2? (
		${GL_REQUIRED_USE}
		egl
	)
"

# Dependencies needed by opengl library and plugin (enabled via USE gles2 and/or
# opengl)
# dmabuf automagic from libdrm headers (drm_fourcc.h) and EGL, so ensure it with
# USE=egl (platform independent header used only, thus no MULTILIB_USEDEP);
# provides dmabuf based upload/download/eglimage options
GL_DEPS="
	>=media-libs/graphene-1.4.0[${MULTILIB_USEDEP}]
	>=media-libs/libpng-1.0:0[${MULTILIB_USEDEP}]
	media-libs/libjpeg-turbo:0=[${MULTILIB_USEDEP}]
	egl? (
		>=x11-libs/libdrm-2.4.98
	)
	gbm? (
		>=dev-libs/libgudev-147[${MULTILIB_USEDEP}]
		>=x11-libs/libdrm-2.4.98[${MULTILIB_USEDEP}]
	)
	wayland? (
		>=dev-libs/wayland-1.11[${MULTILIB_USEDEP}]
		>=dev-libs/wayland-protocols-1.15
	)

	>=media-libs/mesa-22.3[${MULTILIB_USEDEP},egl(+)?,gbm(+)?,wayland?]
	gles2? (
		>=media-libs/mesa-22.3[${MULTILIB_USEDEP},gles2(+),opengl]
	)
	media-libs/mesa:=
"
# graphene is for optional gltransformation and glvideoflip elements and more
# GLSL Uniforms support in glshader; libpng/jpeg for gloverlay element
# >=media-libs/graphene-1.4.0[${MULTILIB_USEDEP}]

RDEPEND="
	>=dev-libs/glib-2.64.0:2[${MULTILIB_USEDEP}]
	app-text/iso-codes
	sys-libs/zlib[${MULTILIB_USEDEP}]
	alsa? (
		>=media-libs/alsa-lib-0.9.1[${MULTILIB_USEDEP}]
	)
	gles2? (
		${GL_DEPS}
	)
	introspection? (
		dev-libs/gobject-introspection:=
	)
	ivorbis? (
		>=media-libs/tremor-0_pre20180316[${MULTILIB_USEDEP}]
	)
	nls? (
		sys-devel/gettext[${MULTILIB_USEDEP}]
	)
	ogg? (
		>=media-libs/libogg-1.0[${MULTILIB_USEDEP}]
	)
	opengl? (
		${GL_DEPS}
	)
	orc? (
		>=dev-lang/orc-0.4.24[${MULTILIB_USEDEP}]
	)
	pango? (
		>=x11-libs/pango-1.22.0[${MULTILIB_USEDEP}]
	)
	theora? (
		>=media-libs/libtheora-1.1[encode,${MULTILIB_USEDEP}]
	)
	vorbis? (
		>=media-libs/libvorbis-1.3.1[${MULTILIB_USEDEP}]
	)
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
		x11-libs/libXv[${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
	dev-util/glib-utils
	X? (
		x11-base/xorg-proto
	)
"

DOCS=( "AUTHORS" "NEWS" "README.md" "RELEASE" )

PATCHES=(
)

pkg_setup() {
	if [[ -n "${MITIGATION_URI}" ]] ; then
einfo "Security announcement date:  ${MITIGATION_DATE}"
einfo "Security vulnerabilities fixed:  ${MITIGATION_URI}"
	fi
	vf_show
	gstreamer-meson_pkg_setup
}

multilib_src_configure() {
	cflags-hardened_append
	filter-flags -mno-sse -mno-sse2 -mno-sse4.1 #610340

	# opus: split to media-plugins/gst-plugins-opus
	GST_PLUGINS_NOAUTO="alsa gl ogg pango theora tremor vorbis x11 xshm xvideo"

	local emesonargs=(
		$(meson_feature "alsa")
		$(meson_feature "ivorbis" "tremor")
		$(meson_feature "nls")
		$(meson_feature "ogg")
		$(meson_feature "pango")
		$(meson_feature "theora")
		$(meson_feature "vorbis")
		$(meson_feature "X" "x11")
		$(meson_feature "X" "xshm")
		$(meson_feature "X" "xvideo")
		-Dtools=enabled
	)

	if use opengl || use gles2; then
		# because meson doesn't likes extraneous commas
		local gl_api=( $(use opengl && echo opengl) $(use gles2 && echo gles2) )
		local gl_platform=( $(use X && use opengl && echo glx) $(use egl && echo egl) )
		local gl_winsys=(
			$(use X && echo x11)
			$(use wayland && echo wayland)
			$(use egl && echo egl)
			$(use gbm && echo gbm)
		)
		emesonargs+=(
			-Dgl-graphene=enabled
			-Dgl_api=$(IFS=, ; echo "${gl_api[*]}")
			-Dgl_platform=$(IFS=, ; echo "${gl_platform[*]}")
			-Dgl_winsys=$(IFS=, ; echo "${gl_winsys[*]}")
			-Dgl=enabled
		)
	else
		emesonargs+=(
			-Dgl_api=
			-Dgl_platform=
			-Dgl_winsys=
			-Dgl=disabled
		)
	fi

	# Workaround EGL/eglplatform.h being built with X11 present
	use X || export CFLAGS="${CFLAGS} -DEGL_NO_X11"

	gstreamer_multilib_src_configure
}
