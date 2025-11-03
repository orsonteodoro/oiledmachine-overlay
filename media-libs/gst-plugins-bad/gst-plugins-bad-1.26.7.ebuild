# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# lcevcdecoder
# svtjpegxs
# nvdswrapper
# teletextdec
# zxing

# X11 is no longer automagic which complicates vulkan configure.
# Upstream issue #709530 - x11 is only used by librfb USE=vnc plugin.

# Baseline requirement for libva is 1.6, but 1.10 gets more features

CFLAGS_HARDENED_USE_CASES="network untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE BO SO"
GST_ORG_MODULE="gst-plugins-bad"
PATENT_STATUS=(
	patent_status_nonfree
)
VIDEO_CARDS=(
	video_cards_amdgpu
	video_cards_r600
	video_cards_radeonsi
	video_cards_nouveau
	video_cards_nvidia
	video_cards_intel
)

inherit cflags-hardened gstreamer-meson

KEYWORDS="
~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86
~amd64-linux ~arm64-macos ~x86-linux
"

DESCRIPTION="A set of bad plugins that fall short of code quality or support needs of GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"
LICENSE="LGPL-2"
IUSE="
${PATENT_STATUS}
${VIDEO_CARDS[@]}
amf bzip2 +introspection msdk nls nvcodec onevpl +orc qsv udev vaapi vnc vulkan
vulkan-video wayland X
ebuild_revision_15
"
PATENT_STATUS_REQUIRED_USE="
	!patent_status_nonfree? (
		!amf
		!nvcodec
		!qsv
		!vaapi
		!vulkan-video
	)
	amf? (
		patent_status_nonfree
	)
	nvcodec? (
		patent_status_nonfree
	)
	qsv? (
		patent_status_nonfree
	)
	vaapi? (
		patent_status_nonfree
	)
	vulkan-video? (
		patent_status_nonfree
	)
"
REQUIRED_USE="
	${PATENT_STATUS_REQUIRED_USE}
	!qsv? (
		!msdk
		!onevpl
	)
	qsv? (
		vaapi
		|| (
			msdk
			onevpl
		)
	)
	vaapi? (
		|| (
			${VIDEO_CARDS[@]}
		)
	)
	vnc? (
		X
	)
	vulkan? (
		X
	)
	vulkan-video? (
		vulkan
	)
"
PATENT_STATUS_RDEPEND="
	!patent_status_nonfree? (
		!media-libs/amf-headers
		!media-libs/libva
		!media-libs/libvpl
		!media-libs/intel-mediasdk
		!media-libs/oneVPL-cpu
		!media-libs/vaapi-drivers
		!media-libs/vpl-gpu-rt
		!media-video/amdgpu-pro-amf
	)
	virtual/patent-status[patent_status_nonfree=]
"
RDEPEND="
	${PATENT_STATUS_RDEPEND}
	!media-plugins/gst-plugins-va
	!media-plugins/gst-transcoder
	>=dev-libs/glib-2.64.0:2[${MULTILIB_USEDEP}]
	~media-libs/gstreamer-${PV}:${SLOT}[${MULTILIB_USEDEP},introspection?]
	~media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP},introspection?]
	amf? (
		media-libs/amf-headers
		media-video/amdgpu-pro-amf[video_cards_amdgpu?]
	)
	bzip2? (
		app-arch/bzip2[${MULTILIB_USEDEP}]
	)
	introspection? (
		dev-libs/gobject-introspection:=
	)
	nls? (
		sys-devel/gettext[${MULTILIB_USEDEP}]
	)
	nvcodec? (
		dev-libs/glib:2[${MULTILIB_USEDEP}]
		dev-util/nvidia-cuda-toolkit:=
		x11-drivers/nvidia-drivers:=[${MULTILIB_USEDEP}]
	)
	orc? (
		>=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}]
	)
	qsv? (
		msdk? (
			media-libs/intel-mediasdk[${MULTILIB_USEDEP},wayland?,X?]
		)
		onevpl? (
			media-libs/libvpl[${MULTILIB_USEDEP}]
			media-libs/oneVPL-cpu
			video_cards_intel? (
				media-libs/vpl-gpu-rt
			)
		)
	)
	vaapi? (
		media-libs/libva:=[${MULTILIB_USEDEP},wayland?,X?]
		media-libs/vaapi-drivers[video_cards_amdgpu?,video_cards_r600?,video_cards_radeonsi?,video_cards_intel?,video_cards_nouveau?,video_cards_nvidia?]
		udev? (
			dev-libs/libgudev[${MULTILIB_USEDEP}]
		)
	)
	vnc? (
		X? (
			x11-libs/libX11[${MULTILIB_USEDEP}]
		)
	)
	vulkan? (
		media-libs/vulkan-drivers[${MULTILIB_USEDEP}]
		media-libs/vulkan-loader[${MULTILIB_USEDEP},wayland?,X?]
		video_cards_amdgpu? (
			media-libs/mesa[video_cards_radeonsi,vulkan]
		)
		video_cards_intel? (
			media-libs/mesa[video_cards_intel,vulkan]
		)
		video_cards_nouveau? (
			media-libs/mesa[video_cards_intel,nouveau]
		)
		video_cards_nvidia? (
			>=x11-drivers/nvidia-drivers-390.132
		)
		video_cards_radeonsi? (
			media-libs/mesa[video_cards_radeonsi,vulkan]
		)
	)
	wayland? (
		>=dev-libs/wayland-1.4.0[${MULTILIB_USEDEP}]
		>=dev-libs/wayland-protocols-1.15
		>=x11-libs/libdrm-2.4.104[${MULTILIB_USEDEP}]
	)
	X? (
		>=x11-libs/libxcb-1.10[${MULTILIB_USEDEP}]
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libxkbcommon[${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
	vulkan? (
		dev-util/vulkan-headers
	)
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
	cflags-hardened_append
	GST_PLUGINS_NOAUTO="amfcodec bz2 codec2json hls lcevcdecoder lcevcencoder ipcpipeline librfb msdk nvcodec qsv shm va vulkan wayland webrtc webrtcdsp x11"
	local emesonargs=(
		$(meson_feature "amf" "amfcodec")
		$(meson_feature "bzip2" "bz2")
		$(meson_feature "nls")
		$(meson_feature "qsv")
		$(meson_feature "vaapi" "va")
		$(meson_feature "vnc" "librfb")
		$(meson_feature "vulkan")
		$(meson_feature "vulkan-video")
		$(meson_feature "wayland")
		-Dcodec2json="disabled"
		-Dhls="disabled"
		-Dipcpipeline="enabled"
		-Dlcevcdecoder="disabled"
		-Dlcevcencoder="disabled"
		-Dmsdk=$(usex msdk "enabled" "disabled")
		-Dnvcodec=$(usex nvcodec "enabled" "disabled")
		-Dshm="enabled"
		-Dudev=$(usex udev $(usex vaapi "enabled" "disabled") "disabled")
		-Dwebrtc="disabled"
		-Dwebrtcdsp="disabled"
		-Dx11=$(usex X "enabled" "disabled")
	)
	gstreamer_multilib_src_configure
}

multilib_src_test() {
	# Tests are slower than upstream expects
	CK_DEFAULT_TIMEOUT=300 gstreamer_multilib_src_test
}

multilib_src_install() {
	gstreamer_multilib_src_install

	# Package collision
	find "${ED}/usr" -name "libgstwebrtcdsp.so" -delete || die
}
