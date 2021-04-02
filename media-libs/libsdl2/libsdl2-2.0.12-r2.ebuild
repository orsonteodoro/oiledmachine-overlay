# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic linux-info toolchain-funcs multilib-minimal

MY_P="SDL2-${PV}"
DESCRIPTION="Simple Direct Media Layer"
HOMEPAGE="https://www.libsdl.org/"
LICENSE_HIDAPI="|| ( BSD GPL-3 HIDAPI )"
LICENSE="ZLIB
	BSD
	BrownUn_UnCalifornia_ErikCorry
	LGPL-2.1+
	RSA_Data_Security
	SunPro
	armv6-simd? ( ZLIB pixman-arm-asm.h )
	cpu_flags_arm_neon? ( MIT ZLIB pixman-arm-asm.h )
	hidapi-hidraw? ( ${LICENSE_HIDAPI} )
	hidapi-libusb? ( ${LICENSE_HIDAPI} )
	video? ( X? ( MIT all-rights-reserved ) )"
# project default license is ZLIB
# yuv2rgb is BSD
# src/test/SDL_test_md5.c uses ZLIB and RSA_Data_Security
# The debian/* folder is LGPL-2.1+
# Some assets are public domain but not mentioned in the LICENSE variable
#   to not to give the impression the whole entire package is public domain.
# In src/video/x11/imKStoUCS.c,
#   The standard MIT license* does not have all-rights-reserved.
#     *https://gitweb.gentoo.org/repo/gentoo.git/tree/licenses/MIT
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 sparc x86"
SLOT="0/${PV}"
IUSE="alsa -armv6-simd aqua cpu_flags_arm_v6 cpu_flags_arm_v7 \
-cpu_flags_arm_neon armv6-simd cpu_flags_ppc_altivec cpu_flags_x86_3dnow \
cpu_flags_x86_mmx cpu_flags_x86_sse cpu_flags_x86_sse2 custom-cflags dbus \
fcitx4 gles2 haptic -hidapi-hidraw -hidapi-libusb ibus jack +joystick kms \
libsamplerate nas opengl oss pulseaudio +sound static-libs +threads tslib udev \
+video video_cards_vc4 vulkan wayland X xinerama xscreensaver"
REQUIRED_USE="
	alsa? ( sound )
	fcitx4? ( dbus )
	gles2? ( video )
	hidapi-hidraw? ( joystick udev )
	hidapi-libusb? ( joystick )
	ibus? ( dbus )
	jack? ( sound )
	nas? ( sound )
	opengl? ( video )
	pulseaudio? ( sound )
	vulkan? ( video )
	wayland? ( gles2 )
	xinerama? ( X )
	xscreensaver? ( X )"
CDEPEND="
	alsa? ( >=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}] )
	dbus? ( >=sys-apps/dbus-1.6.18-r1[${MULTILIB_USEDEP}] )
	fcitx4? ( app-i18n/fcitx:4 )
	gles2? ( >=media-libs/mesa-9.1.6[${MULTILIB_USEDEP},gles2] )
	hidapi-libusb? ( >=dev-libs/libusb-1.0.9 )
	ibus? ( app-i18n/ibus )
	jack? ( virtual/jack[${MULTILIB_USEDEP}] )
	kms? (
		>=x11-libs/libdrm-2.4.46[${MULTILIB_USEDEP}]
		>=media-libs/mesa-9.0.0[${MULTILIB_USEDEP},gbm]
	)
	libsamplerate? ( media-libs/libsamplerate[${MULTILIB_USEDEP}] )
	nas? (
		>=media-libs/nas-1.9.4[${MULTILIB_USEDEP}]
		>=x11-libs/libXt-1.1.4[${MULTILIB_USEDEP}]
	)
	opengl? (
		>=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]
		>=virtual/glu-9.0-r1[${MULTILIB_USEDEP}]
	)
	pulseaudio? ( >=media-sound/pulseaudio-2.1-r1[${MULTILIB_USEDEP}] )
	tslib? ( >=x11-libs/tslib-1.0-r3[${MULTILIB_USEDEP}] )
	udev? ( >=virtual/libudev-208:=[${MULTILIB_USEDEP}] )
	wayland? (
		>=dev-libs/wayland-1.0.6[${MULTILIB_USEDEP}]
		>=media-libs/mesa-9.1.6[${MULTILIB_USEDEP},egl,gles2,wayland]
		>=x11-libs/libxkbcommon-0.2.0[${MULTILIB_USEDEP}]
	)
	X? (
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXcursor-1.1.14[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXi-1.7.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXrandr-1.4.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXxf86vm-1.1.3[${MULTILIB_USEDEP}]
		xinerama? ( >=x11-libs/libXinerama-1.1.3[${MULTILIB_USEDEP}] )
		xscreensaver? ( >=x11-libs/libXScrnSaver-1.2.2-r1[${MULTILIB_USEDEP}] )
	)"
RDEPEND="${CDEPEND}
	vulkan? ( media-libs/vulkan-loader )"
DEPEND="${CDEPEND}
	ibus? ( dev-libs/glib:2[${MULTILIB_USEDEP}] )
	vulkan? ( dev-util/vulkan-headers )
	X? ( x11-base/xorg-proto )
"
BDEPEND="
	virtual/pkgconfig
"
MULTILIB_WRAPPED_HEADERS=(
	/usr/include/SDL2/SDL_config.h
	/usr/include/SDL2/SDL_platform.h
	/usr/include/SDL2/begin_code.h
	/usr/include/SDL2/close_code.h
)
SRC_URI="https://www.libsdl.org/release/${MY_P}.tar.gz"
PATCHES=(
	"${FILESDIR}"/${PN}-2.0.12-static-libs.patch
	"${FILESDIR}"/${PN}-2.0.12-vulkan-headers.patch
	"${FILESDIR}"/${PN}-2.0.12-egl-detection.patch
)
S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use hidapi-hidraw ; then
		linux-info_pkg_setup
		if ! linux_config_src_exists ; then
			ewarn \
"Missing kernel .config file.  Do \`make menuconfig\` and save it to fix this."
		fi
		if ! linux_chkconfig_present HIDRAW ; then
			ewarn \
"You must have CONFIG_HIDRAW enabled in the kernel for hidraw \
joystick or console gamepad support."
		fi
	fi
}

src_prepare() {
	default

	# Unbundle some headers.
	rm -r src/video/khronos || die
	ln -s "${ESYSROOT}/usr/include" src/video/khronos || die

	AT_M4DIR="/usr/share/aclocal acinclude" eautoreconf
}

multilib_src_configure() {
	use custom-cflags || strip-flags

	if use ibus; then
		local -x IBUS_CFLAGS=\
"-I${ESYSROOT}/usr/include/ibus-1.0 -I${ESYSROOT}/usr/include/glib-2.0 \
-I${ESYSROOT}/usr/$(get_libdir)/glib-2.0/include"
	fi

	# sorted by `./configure --help`
	local myeconfargs=(
		$(use_enable static-libs static)
		--enable-atomic
		$(use_enable sound audio)
		$(use_enable video)
		--enable-render
		--enable-events
		$(use_enable joystick)
		$(use_enable haptic)
		--enable-power
		--enable-filesystem
		$(use_enable threads)
		--enable-timers
		--enable-file
		--enable-loadso
		--enable-cpuinfo
		--enable-assembly
		$(use_enable cpu_flags_ppc_altivec altivec)
		$(use_enable cpu_flags_x86_sse ssemath)
		$(use_enable cpu_flags_x86_mmx mmx)
		$(use_enable cpu_flags_x86_3dnow 3dnow)
		$(use_enable cpu_flags_x86_sse sse)
		$(use_enable cpu_flags_x86_sse2 sse2)
		$(use_enable oss)
		$(use_enable alsa)
		--disable-alsa-shared
		$(use_enable jack)
		--disable-jack-shared
		--disable-esd
		$(use_enable pulseaudio)
		--disable-pulseaudio-shared
		--disable-arts
		$(use_enable libsamplerate)
		$(use_enable nas)
		--disable-nas-shared
		--disable-sndio
		--disable-sndio-shared
		$(use_enable sound diskaudio)
		$(use_enable sound dummyaudio)
		$(use_enable wayland video-wayland)
		--disable-wayland-shared
		$(use_enable video_cards_vc4 video-rpi)
		$(use_enable X video-x11)
		--disable-x11-shared
		$(use_enable X video-x11-xcursor)
		$(use_enable X video-x11-xdbe)
		$(use_enable xinerama video-x11-xinerama)
		$(use_enable X video-x11-xinput)
		$(use_enable X video-x11-xrandr)
		$(use_enable xscreensaver video-x11-scrnsaver)
		$(use_enable X video-x11-xshape)
		$(use_enable X video-x11-vm)
		$(use_enable aqua video-cocoa)
		--disable-video-directfb
		--disable-fusionsound
		--disable-fusionsound-shared
		$(use_enable kms video-kmsdrm)
		--disable-kmsdrm-shared
		$(use_enable video video-dummy)
		$(use_enable opengl video-opengl)
		--disable-video-opengles1
		$(use_enable gles2 video-opengles2)
		$(use_enable vulkan video-vulkan)
		$(use_enable udev libudev)
		$(use_enable dbus)
		$(use_enable fcitx4 fcitx)
		$(use_enable ibus)
		$(use_enable tslib input-tslib)
		--disable-directx
		--disable-rpath
		--disable-render-d3d
		$(use_with X x)
	)

	if use cpu_flags_arm_v6 && use armv6-simd ; then
		myeconfargs+=( --enable-arm-simd )
	else
		myeconfargs+=( --disable-arm-simd )
	fi

	if use cpu_flags_arm_v7 && use cpu_flags_arm_neon ; then
		myeconfargs+=( --enable-arm-neon )
	else
		myeconfargs+=( --disable-arm-neon )
	fi

	if use hidapi-hidraw || use hidapi-libusb ; then
		myeconfargs+=(
			--enable-hidapi
			$(use_enable hidapi-libusb)
		)
	else
		myeconfargs+=( --disable-hidapi )
	fi

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	emake V=1
}

multilib_src_install() {
	emake DESTDIR="${D}" install
}

multilib_src_install_all() {
	# Do not delete the static .a libraries here as some are
	# mandatory. They may be needed even when linking dynamically.
	find "${ED}" -type f -name "*.la" -delete || die
	dodoc {BUGS,CREDITS,README,README-SDL,TODO,WhatsNew}.txt docs/README*.md

	docinto licenses
	dodoc COPYING.txt

	head -n 10 src/libm/e_atan2.c > \
		"${T}/libm.LICENSE" || die
	docinto licenses/src/libm
	dodoc "${T}/libm.LICENSE"

	if use video ; then
		if ( use cpu_flags_arm_v6 && use armv6-simd ) \
			|| ( use cpu_flags_arm_v7 && use cpu_flags_arm_neon ) ; then
			head -n 25 src/video/arm/pixman-arm-asm.h > \
				"${T}/pixman-arm-asm.LICENSE" || die
			docinto licenses/src/video/arm/pixman-arm
			dodoc "${T}/pixman-arm-asm.LICENSE"
		fi

		if use cpu_flags_arm_v6 && use armv6-simd ; then
			head -n 19 src/video/arm/pixman-arm-simd-asm.S > \
				"${T}/pixman-arm-simd-asm.LICENSE" || die
			docinto licenses/src/video/arm/pixman-arm
			dodoc "${T}/pixman-arm-simd-asm.LICENSE"
		fi

		if use cpu_flags_arm_v7 && use cpu_flags_arm_neon ; then
			head -n 44 src/video/arm/pixman-arm-neon-asm.S > \
				"${T}/pixman-arm-neon-asm.LICENSE" || die
			docinto licenses/src/video/arm/pixman-arm
			dodoc "${T}/pixman-arm-neon-asm.LICENSE"
		fi

		docinto licenses/src/video/yuv2rgb
		dodoc src/video/yuv2rgb/LICENSE

		tail -n 142 debian/copyright | head -n 58 > \
			"${T}/SDL_yuv_sw.c.LICENSE" || die
		docinto licenses/src/render
		dodoc "${T}/SDL_yuv_sw.c.LICENSE"

		if use X ; then
			head -n 25 src/video/x11/imKStoUCS.c > \
				"${T}/imKStoUCS.c.LICENSE" || die
			docinto licenses/src/video/x11
			dodoc "${T}/imKStoUCS.c.LICENSE"
			head -n 28 src/video/x11/imKStoUCS.h > \
				"${T}/imKStoUCS.h.LICENSE" || die
			docinto licenses/src/video/x11
			dodoc "${T}/imKStoUCS.h.LICENSE"
		fi
	fi

	if use hidapi-hidraw || use hidapi-libusb ; then
		docinto licenses/src/hidapi
		dodoc src/hidapi/LICENSE.txt
		dodoc src/hidapi/LICENSE-orig.txt
		dodoc src/hidapi/LICENSE-gpl3.txt
		dodoc src/hidapi/LICENSE-bsd.txt
	fi

	#if use test ; then
		head -n 52 src/test/SDL_test_md5.c > \
			"${T}/SDL_test_md5.c.LICENSE" || die
		docinto licenses/src/test
		dodoc "${T}/SDL_test_md5.c.LICENSE"
	#fi

}
