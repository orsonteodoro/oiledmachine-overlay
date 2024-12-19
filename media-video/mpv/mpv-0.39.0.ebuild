# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( "lua5-"{1..2} "luajit" )
PYTHON_COMPAT=( "python3_"{10..13} )

inherit flag-o-matic lua-single meson optfeature pax-utils python-single-r1 xdg

if [[ "${PV}" == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/mpv-player/mpv.git"
	inherit git-r3
else
	KEYWORDS="
amd64 ~arm arm64 ~loong ~ppc ppc64 ~riscv x86 ~amd64-linux
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
+X +alsa aqua archive bluray cdda +cli coreaudio debug +drm dvb dvd +egl gamepad
+iconv jack javascript jpeg lcms libcaca +libmpv +lua nvenc openal opengl
pipewire pulseaudio rubberband sdl selinux sixel sndio soc test tools +uchardet
vaapi vdpau vulkan wayland xv zimg zlib
"
REQUIRED_USE="
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
			opengl
			vulkan
		)
	)
	opengl? (
		|| (
			X
			aqua
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
COMMON_DEPEND="
	>=media-libs/libplacebo-6.338.2:=[opengl?,vulkan?]
	>=media-libs/libass-0.12.2:=[fontconfig]
	|| (
		media-video/ffmpeg:58.60.60[encode,soc(-)?,threads,vaapi?,vdpau?]
		media-video/ffmpeg:0/58.60.60[encode,soc(-)?,threads,vaapi?,vdpau?]
	)
	media-video/ffmpeg:=
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
		egl? (
			>=media-libs/mesa-17.1.0[gbm(+)]
		)
	)
	dvd? (
		>=media-libs/libdvdnav-4.2.0
		>=media-libs/libdvdread-4.1.0:=
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
	openal? (
		>=media-libs/openal-1.13
	)
	opengl? (
		media-libs/libglvnd[X?]
	)
	pipewire? (
		>=media-video/pipewire-0.3.57:=
	)
	pulseaudio? (
		media-libs/libpulse
	)
	rubberband? (
		>=media-libs/rubberband-1.8.0
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
	)
	vdpau? (
		>=x11-libs/libvdpau-0.2
	)
	vulkan? (
		>=media-libs/vulkan-loader-1.3.238[X?,wayland?]
	)
	wayland? (
		>=dev-libs/wayland-1.21.0
		>=dev-libs/wayland-protocols-1.31
		x11-libs/libxkbcommon
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
	X? (
		x11-base/xorg-proto
	)
	dvb? (
		sys-kernel/linux-headers
	)
	nvenc? (
		media-libs/nv-codec-headers
	)
	vulkan? (
		>=dev-util/vulkan-headers-1.3.238
	)
	wayland? (
		dev-libs/wayland-protocols
	)
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-build/meson-0.62.0
	dev-util/patchelf
	virtual/pkgconfig
	cli? (
		dev-python/docutils
	)
	wayland? (
		dev-util/wayland-scanner
	)
"

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

	mpv_feature_multi() {
		local set
		local use
		for use in "${1}" "${2}"; do
			use ${use} || set="disabled"
		done
		echo -D${3-${2}}=${set-"enabled"}
	}

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
		$(meson_feature nvenc cuda-interop)
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
		$(mpv_feature_multi aqua opengl videotoolbox-gl)
		$(mpv_feature_multi egl drm gbm) # gbm is only used by egl-drm
		$(mpv_feature_multi egl drm egl-drm)
		$(mpv_feature_multi egl wayland egl-wayland)
		$(mpv_feature_multi egl X egl-x11)
		$(mpv_feature_multi opengl X gl-x11)
		$(mpv_feature_multi opengl aqua gl-cocoa)
		$(mpv_feature_multi vaapi X vaapi-x11)
		$(mpv_feature_multi vaapi drm vaapi-drm)
		$(mpv_feature_multi vaapi wayland vaapi-wayland)
		$(mpv_feature_multi vdpau opengl vdpau-gl-x11)
		-Dbuild-date="false"
		-Dcplugins="enabled"
		-Dgl=$(use egl || use libmpv || use opengl && echo "enabled" || echo "disabled")
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
}
