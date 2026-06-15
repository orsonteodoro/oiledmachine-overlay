# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_BUILDFILES_SANITIZERS="asan ubsan"
CFLAGS_HARDENED_LANGS="c-lang"
CFLAGS_HARDENED_USE_CASES="untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE FS UAF"

PATENT_STATUS_IUSE=(
	patent_status_nonfree
)

# Force FFmpeg live to mitigate vulnerabilities
inherit ffmpeg
FFMPEG_COMPAT_SLOTS=(
	"${FFMPEG_COMPAT_SLOTS_8[@]}"
)

LUA_COMPAT=( lua5-1 luajit )
PYTHON_COMPAT=( python3_{10..14} )

CHKL_TIMESTAMPS=(
	# The proper way to do this is to add all the live codecs and scan the commit history for vulnerability fixed.
	# See https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/vf.eclass for a list of vulnerabilities.
	# Currently, the packages that were triaged were the most widely used.
	# Last security check 20260614
	"media-libs/libplacebo-9999;Mon, 1 Jun 2026 20:39:36 +0200"	# Bumped live/*DEPENDS to latest non-vulnerable
	"media-video/ffmpeg-9999;Mon, 15 Jun 2026 04:07:59 +0300"	# Bumped live/*DEPENDS to latest non-vulnerable
	"media-video/ffmpeg-9999m;Mon, 15 Jun 2026 04:07:59 +0300"	# Bumped live/*DEPENDS to latest non-vulnerable
)

inherit cflags-hardened chkl flag-o-matic lua-single meson optfeature pax-utils python-single-r1 xdg

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/mpv-player/mpv.git"
	FALLBACK_COMMIT="7d245fd100fc0d87edcc559b0676a326dc8c5801"
	IUSE+=" fallback-commit"
	inherit git-r3
else
	SRC_URI="https://github.com/mpv-player/mpv/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="Media player for the command line"
HOMEPAGE="https://mpv.io/"

LICENSE="LGPL-2.1+ GPL-2+ BSD ISC MIT" #506946
SLOT="0/2" # soname
# oiledmachine-overlay:  added vapoursynth
IUSE+="
	${PATENT_STATUS_IUSE[@]}
	+X +alsa aqua archive bluray cdda +cli coreaudio +curl debug +drm
	dvb dvd +egl gamepad +iconv jack javascript jpeg lcms libcaca
	+libmpv +lua network nvenc openal pipewire pulseaudio rubberband sdl
	selinux sixel sndio soc subrandr test tools +uchardet vaapi vapoursynth vdpau
	+vulkan wayland xv zimg zlib
	ebuild_revision_4
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
	|| ( cli libmpv )
	egl? ( || ( X drm wayland ) )
	lua? ( ${LUA_REQUIRED_USE} )
	nvenc? ( || ( egl vulkan ) )
	test? ( cli )
	tools? ( cli )
	uchardet? ( iconv )
	vaapi? ( || ( X drm wayland ) )
	vdpau? ( X )
	vulkan? ( || ( X wayland ) )
	xv? ( X )
"

RESTRICT="!test? ( test )"
# oiledmachine-overlay:  Forced FFmpeg 8.1 for mitigation
PATENT_STATUS_DEPEND="
	virtual/patent-status[patent_status_nonfree=]
	!patent_status_nonfree? (
		!media-libs/libva
		!x11-libs/libvdpau
		|| (
			>=media-video/ffmpeg-9999:60.62.62[encode(+),network?,-patent_status_nonfree,soc(-)?,threads(+),-vaapi,-vdpau]
			>=media-video/ffmpeg-9999:0/60.62.62[encode(+),network?,-patent_status_nonfree,soc(-)?,threads(+),-vaapi,-vdpau]
		)
	)
	patent_status_nonfree? (
		|| (
			>=media-video/ffmpeg-9999:60.62.62[encode(+),network?,patent_status_nonfree,soc(-)?,threads(+),vaapi?,vdpau?]
			>=media-video/ffmpeg-9999:0/60.62.62[encode(+),network?,patent_status_nonfree,soc(-)?,threads(+),vaapi?,vdpau?]
		)
	)
	media-video/ffmpeg:=
"
COMMON_DEPEND="
	${PATENT_STATUS_DEPEND}
	media-libs/libass:=[fontconfig]
	>=media-libs/libplacebo-9999:=[vulkan?]
	>=media-video/ffmpeg-9999:=[encode(+),threads(+),vaapi?,vdpau?]
	X? (
		x11-libs/libX11
		x11-libs/libXScrnSaver
		x11-libs/libXext
		x11-libs/libXfixes
		x11-libs/libXpresent
		x11-libs/libXrandr
		xv? ( x11-libs/libXv )
	)
	alsa? ( media-libs/alsa-lib )
	archive? ( app-arch/libarchive:= )
	bluray? ( media-libs/libbluray:= )
	cdda? (
		dev-libs/libcdio-paranoia:=
		dev-libs/libcdio:=
	)
	curl? ( net-misc/curl )
	drm? (
		media-libs/libdisplay-info:=
		x11-libs/libdrm
		egl? ( media-libs/mesa[gbm(+)] )
	)
	dvd? ( media-libs/libdvdnav )
	egl? (
		media-libs/libglvnd
		media-libs/libplacebo[opengl]
	)
	gamepad? ( media-libs/libsdl2[joystick] )
	iconv? (
		virtual/libiconv
		uchardet? ( app-i18n/uchardet )
	)
	jack? ( virtual/jack )
	javascript? ( dev-lang/mujs:= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	lcms? ( media-libs/lcms:2 )
	libcaca? ( media-libs/libcaca )
	lua? ( ${LUA_DEPS} )
	network? (
		elibc_glibc? (
			sys-libs/glibc[nscd]
		)
	)
	openal? ( media-libs/openal )
	pipewire? ( media-video/pipewire:= )
	pulseaudio? ( media-libs/libpulse )
	rubberband? ( media-libs/rubberband:= )
	sdl? ( media-libs/libsdl2[sound,threads(+),video] )
	sixel? ( media-libs/libsixel )
	sndio? ( media-sound/sndio:= )
	soc? ( >=media-video/ffmpeg-8.1:=[soc(-)] )
	subrandr? ( >=media-libs/subrandr-1.1.0 )
	vaapi? (
		media-libs/libva:=[X?,drm(+)?,wayland?]
		virtual/vaapi[patent_status_nonfree=]
	)
	vapoursynth? (
		>=media-libs/vapoursynth-56
	)
	vdpau? (
		media-libs/libglvnd[X]
		x11-libs/libvdpau
	)
	vulkan? ( media-libs/vulkan-loader[X?,wayland?] )
	wayland? (
		>=dev-libs/wayland-1.23
		x11-libs/libxkbcommon
	)
	zimg? ( media-libs/zimg )
	zlib? ( virtual/zlib:= )
"
RDEPEND="
	${COMMON_DEPEND}
	selinux? ( sec-policy/selinux-mplayer )
	tools? ( ${PYTHON_DEPS} )
"
DEPEND="
	${COMMON_DEPEND}
	X? ( x11-base/xorg-proto )
	dvb? ( sys-kernel/linux-headers )
	nvenc? ( media-libs/nv-codec-headers )
	vaapi? (
		egl? ( x11-libs/libdrm )
	)
	vulkan? (
		dev-util/vulkan-headers
		virtual/vulkan
	)
	wayland? ( >=dev-libs/wayland-protocols-1.41 )
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-build/meson-1.3.0
	virtual/pkgconfig
	cli? ( dev-python/docutils )
	wayland? ( >=dev-util/wayland-scanner-1.23 )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.41.0-v4l2request.patch
)

pkg_setup() {
	use lua && lua-single_pkg_setup
	python-single-r1_pkg_setup
}

src_unpack() {
	chkl_check_many_timestamps
	if [[ ${PV} == 9999 ]]; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_configure() {
	ffmpeg_src_configure
	cflags-hardened_append
	if use !debug; then
		if use test; then
			einfo "Skipping -DNDEBUG due to USE=test"
		else
			append-cppflags -DNDEBUG # treated specially
		fi
	fi

	local emesonargs=(
		$(meson_use cli cplayer)
		$(meson_use libmpv)
		$(meson_use test tests)

		$(meson_feature cli html-build)
		$(meson_feature cli manpage-build)
		-Dpdf-build=disabled

		-Dbuild-date=false

		# misc options
		$(meson_feature X x11-clipboard)
		$(meson_feature archive libarchive)
		$(meson_feature bluray libbluray)
		$(meson_feature cdda)
		-Dcplugins=enabled
		$(meson_feature curl libcurl)
		$(meson_feature dvb dvbin)
		$(meson_feature dvd dvdnav)
		$(meson_feature gamepad sdl2-gamepad)
		$(meson_feature iconv)
		$(meson_feature javascript)
		-Dlibavdevice=enabled
		$(meson_feature lcms lcms2)
		-Dlua=$(usex lua "${ELUA}" disabled)
		$(meson_feature rubberband)
		$(meson_feature subrandr)
		$(meson_feature uchardet)
		-Dvapoursynth=disabled # only available in overlays
		$(meson_feature zimg)
		$(meson_feature zlib)

		# audio output
		$(meson_feature alsa)
		$(meson_feature coreaudio)
		$(meson_feature jack)
		$(meson_feature openal)
		$(meson_feature pipewire)
		$(meson_feature pulseaudio pulse)
		$(meson_feature sdl sdl2-audio)
		$(meson_feature sndio)

		# video output
		$(meson_feature X x11)
		$(meson_feature aqua cocoa)
		$(meson_feature drm)
		$(meson_feature jpeg)
		$(meson_feature libcaca caca)
		$(meson_feature sdl sdl2-video)
		$(meson_feature sixel)
		$(meson_feature wayland)
		$(meson_feature xv)

		-Dgl=$(use aqua || use egl || use libmpv || use vdpau &&
			echo enabled || echo disabled)
		$(meson_feature egl)
		$(meson_feature libmpv plain-gl)
		$(meson_feature vdpau gl-x11) # only needed for vdpau (bug #955122)

		$(meson_feature vulkan)

		# hardware decoding
		$(meson_feature nvenc cuda-hwaccel)
		$(meson_feature soc v4l2request)
		$(meson_feature vaapi)
		$(meson_feature vdpau)

		$(meson_feature vapoursynth)
	)

	meson_src_configure
}

src_test() {
	unset LANGUAGE #954214

	# ffmpeg tests are picky and easily break without necessarily
	# meaning that there are runtime issues (bug #921091,#924276)
	meson_src_test --no-suite ffmpeg
}

src_install() {
	meson_src_install

	if use lua; then
		insinto /usr/share/${PN}
		doins -r TOOLS/lua

		if use cli && use lua_single_target_luajit; then
			pax-mark -m "${ED}"/usr/bin/${PN}
		fi
	fi

	if use tools; then
		dobin TOOLS/{mpv_identify.sh,umpv}
		newbin TOOLS/idet.sh mpv_idet.sh
		python_fix_shebang "${ED}"/usr/bin/umpv
	fi

	if use cli; then
		dodir /usr/share/doc/${PF}/html
		mv "${ED}"/usr/share/doc/{mpv,${PF}/html}/mpv.html || die
		mv "${ED}"/usr/share/doc/{mpv,${PF}/examples} || die
	fi

	# prevent build-only ffnvcodec from leaking into the .pc (bug #971646)
	if use libmpv && use nvenc; then
		sed -Ee '/^Requires/s/ffnvcodec[^,]*,? ?//;s/, $//;/^Requires[^:]*: $/d' \
			-i "${ED}"/usr/$(get_libdir)/pkgconfig/mpv.pc || die
	fi

	local GLOBIGNORE=*/*build*:*/*policy*
	dodoc RELEASE_NOTES DOCS/*.{md,rst}
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "various websites URL support$(usev !lua \
		" (requires ${PN} with USE=lua)")" net-misc/yt-dlp
	if use network && use elibc_glibc ; then
# Fixes:
# [ffmpeg] tcp: Failed to resolve hostname <redacted>: Temporary failure in name resolution
ewarn "The nscd service must be enabled and running for proper DNS resolution."
	fi
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive/integration-testing) 65a1852 live (20260614)
# streaming audio:  passed
# video test:  passed
