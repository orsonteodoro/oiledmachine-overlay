# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE"

LUA_COMPAT=( "lua5-"{1..2} "luajit" )
PATENT_STATUS_IUSE=(
	patent_status_nonfree
)
PYTHON_COMPAT=( "python3_"{10..13} )

inherit cflags-hardened flag-o-matic lua-single meson optfeature pax-utils
inherit python-single-r1 xdg

if [[ "${PV}" == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/mpv-player/mpv.git"
	inherit git-r3
else
	KEYWORDS="
~amd64 ~arm64 ~arm64-macos ~amd64-linux ~x64-macos
	"
	SRC_URI="
https://github.com/mpv-player/mpv/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Media player for the command line"
HOMEPAGE="https://mpv.io/"
#506946
LICENSE="
	BSD
	GPL-2+
	ISC
	LGPL-2.1+
	MIT
"
RESTRICT="
	!test? (
		test
	)
"
SLOT="0/2" # soname
IUSE="
${PATENT_STATUS_IUSE[@]}
+X +alsa aqua archive bluray cdda +cli coreaudio debug +drm dvb dvd +egl gamepad
+iconv jack javascript jpeg lcms libcaca +libmpv +lua network nvenc openal
pipewire pulseaudio rubberband sdl selinux sixel sndio soc test tools +uchardet
vaapi vapoursynth vdpau vulkan wayland xv zimg zlib
ebuild_revision_11
"
PATENT_STATUS_REQUIRED_USE="
	!patent_status_nonfree? (
		!nvenc
		!vdpau
		!vaapi
	)
	nvenc? (
		patent_status_nonfree
	)
	vaapi? (
		patent_status_nonfree
	)
	vdpau? (
		patent_status_nonfree
	)
"
REQUIRED_USE="
	${PATENT_STATUS_REQUIRED_USE}
	${PYTHON_REQUIRED_USE}
	|| (
		cli
		libmpv
	)
	egl? (
		|| (
			X
			drm
			wayland
		)
	)
	lua? (
		${LUA_REQUIRED_USE}
	)
	nvenc? (
		|| (
			egl
			vulkan
		)
	)
	test? (
		cli
	)
	tools? (
		cli
	)
	uchardet? (
		iconv
	)
	vaapi? (
		|| (
			X
			drm
			wayland
		)
	)
	vdpau? (
		X
	)
	vulkan? (
		|| (
			X
			wayland
		)
	)
	xv? (
		X
	)
"
# FFmpeg 6.1
PATENT_STATUS_DEPEND="
	virtual/patent-status[patent_status_nonfree=]
	!patent_status_nonfree? (
		!media-libs/libva
		!x11-libs/libvdpau
		|| (
			media-video/ffmpeg:58.60.60[encode(+),network?,-patent_status_nonfree,soc(-)?,threads(+),-vaapi,-vdpau]
			media-video/ffmpeg:0/58.60.60[encode(+),network?,-patent_status_nonfree,soc(-)?,threads(+),-vaapi,-vdpau]
		)
	)
	patent_status_nonfree? (
		|| (
			media-video/ffmpeg:58.60.60[encode(+),network?,patent_status_nonfree,soc(-)?,threads(+),vaapi?,vdpau?]
			media-video/ffmpeg:0/58.60.60[encode(+),network?,patent_status_nonfree,soc(-)?,threads(+),vaapi?,vdpau?]
		)
	)
	media-video/ffmpeg:=
"
COMMON_DEPEND="
	${PATENT_STATUS_DEPEND}
	>=media-libs/libplacebo-7.349.0:=[vulkan?]
	>=media-libs/libass-0.12.2:=[fontconfig]
	alsa? (
		>=media-libs/alsa-lib-1.0.18
	)
	archive? (
		>=app-arch/libarchive-3.4.0:=
	)
	bluray? (
		>=media-libs/libbluray-0.3.0:=
	)
	cdda? (
		dev-libs/libcdio-paranoia:=
		>=dev-libs/libcdio-0.90:=
	)
	drm? (
		>=x11-libs/libdrm-2.4.105
		media-libs/libdisplay-info:=
		egl? (
			>=media-libs/mesa-17.1.0[gbm(+)]
		)
	)
	dvd? (
		media-libs/libdvdnav
	)
	egl? (
		media-libs/libglvnd
		media-libs/libplacebo[opengl]
	)
	gamepad? (
		media-libs/libsdl2[joystick]
	)
	iconv? (
		virtual/libiconv
		uchardet? (
			app-i18n/uchardet
		)
	)
	jack? (
		virtual/jack
	)
	javascript? (
		>=dev-lang/mujs-1.0.0:=
	)
	jpeg? (
		media-libs/libjpeg-turbo:=
	)
	lcms? (
		>=media-libs/lcms-2.6:2
	)
	libcaca? (
		>=media-libs/libcaca-0.99_beta18
	)
	lua? (
		${LUA_DEPS}
	)
	network? (
		elibc_glibc? (
			sys-libs/glibc[nscd]
		)
	)
	nvenc? (
		dev-util/nvidia-cuda-toolkit:=
		x11-drivers/nvidia-drivers
	)
	openal? (
		>=media-libs/openal-1.13
	)
	pipewire? (
		>=media-video/pipewire-0.3.57:=
	)
	pulseaudio? (
		media-libs/libpulse
	)
	rubberband? (
		>=media-libs/rubberband-1.8.0
		media-libs/rubberband:=
	)
	sdl? (
		media-libs/libsdl2[sound,threads(+),video]
	)
	sixel? (
		>=media-libs/libsixel-1.5
	)
	sndio? (
		>=media-sound/sndio-1.9.0:=
	)
	vaapi? (
		>=media-libs/libva-1.1.0:=[X?,drm(+)?,wayland?]
		media-libs/vaapi-drivers[patent_status_nonfree=]
	)
	vapoursynth? (
		>=media-libs/vapoursynth-56
	)
	vdpau? (
		>=x11-libs/libvdpau-0.2
	)
	vulkan? (
		>=media-libs/vulkan-loader-1.3.238[X?,wayland?]
		media-libs/vulkan-drivers
	)
	wayland? (
		>=x11-libs/libxkbcommon-0.3.0
		>=dev-libs/wayland-1.21.0
		>=dev-libs/wayland-protocols-1.41
	)
	X? (
		>=x11-libs/libX11-1.0.0
		>=x11-libs/libXext-1.0.0
		>=x11-libs/libXpresent-1.0.0
		>=x11-libs/libXrandr-1.4.0
		>=x11-libs/libXScrnSaver-1.0.0
		xv? (
			x11-libs/libXv
		)
	)
	zimg? (
		>=media-libs/zimg-2.9
	)
	zlib? (
		sys-libs/zlib:=
	)
"
RDEPEND="
	${COMMON_DEPEND}
	selinux? (
		sec-policy/selinux-mplayer
	)
	tools? (
		${PYTHON_DEPS}
	)
"
DEPEND="
	${COMMON_DEPEND}
	dvb? (
		sys-kernel/linux-headers
	)
	nvenc? (
		dev-util/nvidia-cuda-toolkit:=
		media-libs/nv-codec-headers:=
	)
	vulkan? (
		>=dev-util/vulkan-headers-1.3.238
	)
	wayland? (
		dev-libs/wayland-protocols
	)
	X? (
		x11-base/xorg-proto
	)
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-build/meson-1.3.0
	dev-util/patchelf
	virtual/pkgconfig
	cli? (
		dev-python/docutils
	)
	wayland? (
		dev-util/wayland-scanner
	)
"

pkg_pretend() {
	if has_version "${CATEGORY}/${PN}[X,opengl]" && ! use egl ; then #953107
ewarn "${PN}'s 'opengl' USE was removed in favour of the 'egl' USE as it was"
ewarn "only for the deprecated 'gl-x11' mpv option when 'egl-x11/wayland'"
ewarn "should be used if --gpu-api=opengl. It is recommended to enable 'egl'"
ewarn "unless using vulkan (default since ${PN}-0.40) or something else."
	fi
}

pkg_setup() {
	use lua && lua-single_pkg_setup
	python-single-r1_pkg_setup
}

src_configure() {
	if has_version "media-video/ffmpeg:58.60.60" ; then
		export PKG_CONFIG_PATH="/usr/lib/ffmpeg/58.60.60/$(get_libdir)/pkgconfig:${PKG_CONFIG_PATH}"
	fi
	if use !debug ; then
		if use test ; then
einfo "Skipping -DNDEBUG due to USE=test"
		else
			append-cppflags -DNDEBUG # treated specially
		fi
	fi

	cflags-hardened_append

	local emesonargs=(
		$(meson_feature alsa)
		$(meson_feature aqua cocoa)
		$(meson_feature archive libarchive)
		$(meson_feature bluray libbluray)
		$(meson_feature cdda)
		$(meson_feature cli html-build)
		$(meson_feature cli manpage-build)
		$(meson_feature coreaudio)
		$(meson_feature drm)
		$(meson_feature dvb dvbin)
		$(meson_feature dvd dvdnav)
		$(meson_feature egl)
		$(meson_feature gamepad sdl2-gamepad)
		$(meson_feature iconv)
		$(meson_feature jack)
		$(meson_feature javascript)
		$(meson_feature jpeg)
		$(meson_feature lcms lcms2)
		$(meson_feature libcaca caca)
		$(meson_feature libmpv plain-gl)
		$(meson_feature nvenc cuda-hwaccel)
		$(meson_feature openal)
		$(meson_feature pipewire)
		$(meson_feature pulseaudio pulse)
		$(meson_feature rubberband)
		$(meson_feature sdl sdl2-audio)
		$(meson_feature sdl sdl2-video)
		$(meson_feature sixel)
		$(meson_feature sndio)
		$(meson_feature uchardet)
		$(meson_feature vaapi)
		$(meson_feature vapoursynth)
		$(meson_feature vdpau)
		$(meson_feature vulkan)
		$(meson_feature wayland)
		$(meson_feature X x11)
		$(meson_feature xv)
		$(meson_feature zimg)
		$(meson_feature zlib)
		$(meson_use cli cplayer)
		$(meson_use libmpv)
		$(meson_use test tests)
		-Dbuild-date="false"
		-Dcplugins="enabled"
		-Dgl=$(use aqua || use egl || use libmpv && echo "enabled" || echo "disabled")
		-Dlibavdevice="enabled"
		-Dlua=$(usex lua "${ELUA}" "disabled")
		-Dpdf-build="disabled"
		-Dsdl2=$(use gamepad || use sdl && echo "enabled" || echo "disabled") #857156
		-Dvapoursynth="disabled" # only available in overlays
	)

	if use drm && use wayland && use elibc_glibc && has_version ">=sys-libs/glibc-2.26" ; then
		emesonargs+=(
			-Ddmabuf-wayland="enabled"
			-Dmemfd-create="enabled"
		)
	else
		emesonargs+=(
			-Ddmabuf-wayland="disabled"
		)
	fi

	meson_src_configure
}

src_test() {
	# ffmpeg tests are picky and easily break without necessarily
	# meaning that there are runtime issues (bug #921091,#924276)
	meson_src_test --no-suite "ffmpeg"
}

src_install() {
	meson_src_install

	if use lua ; then
		insinto "/usr/share/${PN}"
		doins -r "TOOLS/lua"
		if use cli && use lua_single_target_luajit ; then
			pax-mark -m "${ED}/usr/bin/${PN}"
		fi
	fi

	if use tools ; then
		dobin "TOOLS/"{"mpv_identify.sh","umpv"}
		newbin "TOOLS/idet.sh" "mpv_idet.sh"
		python_fix_shebang "${ED}/usr/bin/umpv"
	fi

	if use cli ; then
		dodir "/usr/share/doc/${PF}/html"
		mv "${ED}/usr/share/doc/"{"mpv","${PF}/html"}"/mpv.html" || die
		mv "${ED}/usr/share/doc/"{"mpv","${PF}/examples"} || die
	fi

	local GLOBIGNORE=*"/"*"build"*":"*"/"*"policy"*
	dodoc "RELEASE_NOTES" "DOCS/"*"."{"md","rst"}

	if has_version "media-video/ffmpeg:58.60.60" ; then
		patchelf --add-rpath "/usr/lib/ffmpeg/58.60.60/$(get_libdir)" "${ED}/usr/bin/mpv" || die
		patchelf --add-rpath "/usr/lib/ffmpeg/58.60.60/$(get_libdir)" "${ED}/usr/$(get_libdir)/libmpv.so" || die
	fi

	fperms 0664 "/etc/mpv"
	fperms 0664 "/etc/mpv/encoding-profiles.conf"
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature_header "Install optional packages:"
	optfeature "Website URL support (requires ${CATEGORY}/${PN}[lua])" "net-misc/yt-dlp"
	if use network && use elibc_glibc ; then
# Fixes:
# [ffmpeg] tcp: Failed to resolve hostname <redacted>: Temporary failure in name resolution
ewarn "The nscd service must be enabled and running for proper DNS resolution."
	fi
}
