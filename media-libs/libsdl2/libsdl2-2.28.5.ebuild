# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="SDL2-${PV}"

inherit autotools flag-o-matic linux-info toolchain-funcs multilib-minimal

SRC_URI="https://www.libsdl.org/release/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Simple Direct Media Layer"
HOMEPAGE="https://www.libsdl.org/"
LICENSE_HIDAPI="
	|| (
		BSD
		GPL-3
		HIDAPI
	)
"
LICENSE="
	ZLIB
	all-rights-reserved
	BSD
	BrownUn_UnCalifornia_ErikCorry
	CPL-1.0
	LGPL-2.1+
	MIT
	RSA_Data_Security
	SunPro
	armv6-simd? (
		pixman-arm-asm.h
		ZLIB
	)
	cpu_flags_arm_neon? (
		MIT
		pixman-arm-asm.h
		ZLIB
	)
	hidapi-hidraw? (
		${LICENSE_HIDAPI}
	)
	hidapi-libusb? (
		${LICENSE_HIDAPI}
	)
	video? (
		X? (
			all-rights-reserved
			MIT
		)
	)
"
# project default license is ZLIB

# In test/testhaptic.c,
#   test/testrumble.c,
#   contain ZLIB with all rights reserved.  The standard ZLIB license* does not
#   come with all rights reserved.
#   *https://gitweb.gentoo.org/repo/gentoo.git/tree/licenses/ZLIB

# yuv2rgb is BSD

# src/test/SDL_test_md5.c uses ZLIB and RSA_Data_Security

# The debian/* folder is LGPL-2.1+

# Some assets are public domain but not mentioned in the LICENSE variable
#   to not to give the impression the whole entire package is public domain.

# In src/events/imKStoUCS.c,
#   include/SDL_opengl.h,
#   The standard MIT license* does not have all rights reserved.
#   *https://gitweb.gentoo.org/repo/gentoo.git/tree/licenses/MIT

# In src/hidapi/ios/hid.m,
#   src/hidapi/android/hid.cpp,
#   src/hidapi/linux/hid.cpp,
#   src/hidapi/windows/ddk_build/makefile
#   contain all rights reserved without mentioned terms or corresponding license
#   and are transported with the tarball.

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
RESTRICT="
	!test? (
		test
	)
	mirror
"
SLOT="0/$(ver_cut 1-2 ${PV})"
ARM_CPU_FLAGS=(
	-armv6-simd
	-cpu_flags_arm_neon
	cpu_flags_arm_v6
	cpu_flags_arm_v7
)
PPC_CPU_FLAGS=(
	cpu_flags_ppc_altivec
)
X86_CPU_FLAGS=(
	cpu_flags_x86_3dnow
	cpu_flags_x86_mmx
	cpu_flags_x86_sse
	cpu_flags_x86_sse2
)
IUSE="
${ARM_CPU_FLAGS[@]}
${PPC_CPU_FLAGS[@]}
${X86_CPU_FLAGS[@]}
alsa aqua custom-cflags dbus doc fcitx4 gles1 gles2 haptic +hidapi-hidraw
-hidapi-libusb ibus jack +joystick kms -libdecor libsamplerate +lsx nas +nls
opengl +openurl oss pipewire pulseaudio sndio +sound static-libs test +threads
udev +video video_cards_vc4 vulkan wayland X xscreensaver
"
# libdecor is not in main repo but in community repos
REQUIRED_USE="
	|| (
		joystick
		udev
	)
	alsa? (
		sound
	)
	fcitx4? (
		dbus
	)
	gles1? (
		video
	)
	gles2? (
		video
	)
	hidapi-hidraw? (
		joystick
		udev
	)
	hidapi-libusb? (
		joystick
	)
	haptic? (
		joystick
	)
	ibus? (
		dbus
	)
	jack? (
		sound
	)
	nas? (
		sound
	)
	opengl? (
		video
	)
	pulseaudio? (
		sound
	)
	sndio? (
		sound
	)
	vulkan? (
		video
	)
	wayland? (
		gles2
	)
	xscreensaver? (
		X
	)
"
# See https://github.com/libsdl-org/SDL/blob/release-2.28.0/.github/workflows/main.yml#L38
# https://github.com/libsdl-org/SDL/blob/release-2.28.0/docs/README-linux.md
# U 22.04 ; CI tag release-2.28.x
# libudev version relaxed
MESA_PV="22.2.5"
CDEPEND="
	virtual/libiconv[${MULTILIB_USEDEP}]
	alsa? (
		>=media-libs/alsa-lib-1.2.6.1[${MULTILIB_USEDEP}]
	)
	dbus? (
		>=sys-apps/dbus-1.12.20[${MULTILIB_USEDEP}]
	)
	fcitx4? (
		>=app-i18n/fcitx-4.2.9.8:4
	)
	gles1? (
		>=media-libs/mesa-${MESA_PV}[${MULTILIB_USEDEP},gles1]
	)
	gles2? (
		>=media-libs/mesa-${MESA_PV}[${MULTILIB_USEDEP},gles2]
	)
	hidapi-libusb? (
		>=dev-libs/libusb-1.0.25
	)
	ibus? (
		>=app-i18n/ibus-1.5.26
	)
	jack? (
		virtual/jack[${MULTILIB_USEDEP}]
	)
	kms? (
		>=x11-libs/libdrm-2.4.113[${MULTILIB_USEDEP}]
		>=media-libs/mesa-${MESA_PV}[${MULTILIB_USEDEP},gbm(+)]
	)
	libdecor? (
		>=gui-libs/libdecor-0.1.0
	)
	libsamplerate? (
		>=media-libs/libsamplerate-0.2.2[${MULTILIB_USEDEP}]
	)
	nas? (
		>=media-libs/nas-1.9.4[${MULTILIB_USEDEP}]
		>=x11-libs/libXt-1.2.1[${MULTILIB_USEDEP}]
	)
	opengl? (
		>=virtual/glu-9.0-r1[${MULTILIB_USEDEP}]
		>=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]
	)
	openurl? (
		>=x11-misc/xdg-utils-1.1.3
	)
	pipewire? (
		>=media-video/pipewire-0.3.48:=[${MULTILIB_USEDEP}]
	)
	pulseaudio? (
		>=media-libs/libpulse-15.99.1[${MULTILIB_USEDEP}]
	)
	sndio? (
		>=media-sound/sndio-1.8.1:=[${MULTILIB_USEDEP}]
	)
	udev? (
		>=virtual/libudev-232-r8:=[${MULTILIB_USEDEP}]
	)
	wayland? (
		>=dev-libs/wayland-1.20.0[${MULTILIB_USEDEP}]
		>=media-libs/mesa-${MESA_PV}[${MULTILIB_USEDEP},egl(+),gles2,wayland]
		>=x11-libs/libxkbcommon-1.4.0[${MULTILIB_USEDEP}]
	)
	X? (
		>=x11-libs/libX11-1.7.5[${MULTILIB_USEDEP}]
		>=x11-libs/libXcursor-1.2.0[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.4[${MULTILIB_USEDEP}]
		>=x11-libs/libXfixes-6.0.0[${MULTILIB_USEDEP}]
		>=x11-libs/libXi-1.8[${MULTILIB_USEDEP}]
		>=x11-libs/libXrandr-1.5.2[${MULTILIB_USEDEP}]
		xscreensaver? (
			>=x11-libs/libXScrnSaver-1.2.3[${MULTILIB_USEDEP}]
		)
	)
"
RDEPEND="
	${CDEPEND}
	vulkan? (
		media-libs/vulkan-loader
	)
"
DEPEND="
	${CDEPEND}
	ibus? (
		>=dev-libs/glib-2.72.1:2[${MULTILIB_USEDEP}]
	)
	test? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
	)
	vulkan? (
		dev-util/vulkan-headers
	)
	X? (
		x11-base/xorg-proto
	)
"
BDEPEND="
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	>=sys-devel/autoconf-2.71
	doc? (
		>=app-doc/doxygen-1.9.1
		>=media-gfx/graphviz-2.42.2
	)
	wayland? (
		>=dev-util/wayland-scanner-1.20
	)
"
MULTILIB_WRAPPED_HEADERS=(
	/usr/include/SDL2/begin_code.h
	/usr/include/SDL2/close_code.h
	/usr/include/SDL2/SDL_config.h
	/usr/include/SDL2/SDL_platform.h
)
PATCHES=(
	"${FILESDIR}/${PN}-2.0.16-static-libs.patch"
)

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

	if ! use vulkan ; then
		sed -i \
			'/testvulkan$(EXE) \\/d' \
			"test/Makefile.in" \
			|| die
	fi

	# SDL seems to customize SDL_config.h.in to remove macros like
	# PACKAGE_NAME. Add AT_NOEAUTOHEADER="yes" to prevent those macros from
	# being reintroduced.
	# https://bugs.gentoo.org/764959
	AT_NOEAUTOHEADER="yes" AT_M4DIR="/usr/share/aclocal acinclude" \
		eautoreconf
	if use test ; then
		pushd test || die
			eautoreconf
		popd
	fi
	prepare_abi() {
		cp -a "${S}" "${S}-${MULTIBUILD_VARIANT}" || die
	}
	multilib_foreach_abi prepare_abi
}

multilib_src_configure() {
	use custom-cflags || strip-flags

	if use ibus; then
		local -x IBUS_CFLAGS="\
-I${ESYSROOT}/usr/include/glib-2.0 \
-I${ESYSROOT}/usr/include/ibus-1.0 \
-I${ESYSROOT}/usr/$(get_libdir)/glib-2.0/include \
"
	fi

	local myeconfargs=(
		$(use_enable alsa)
		$(use_enable aqua video-cocoa)
		$(use_enable cpu_flags_ppc_altivec altivec)
		$(use_enable cpu_flags_x86_3dnow 3dnow)
		$(use_enable cpu_flags_x86_mmx mmx)
		$(use_enable cpu_flags_x86_sse ssemath)
		$(use_enable cpu_flags_x86_sse sse)
		$(use_enable cpu_flags_x86_sse2 sse2)
		$(use_enable dbus)
		$(use_enable fcitx4 fcitx)
		$(use_enable gles1 video-opengles1)
		$(use_enable gles2 video-opengles2)
		$(use_enable haptic)
		$(use_enable ibus)
		$(use_enable jack)
		$(use_enable joystick)
		$(use_enable kms video-kmsdrm)
		$(use_enable libdecor)
		$(use_enable libsamplerate)
		$(use_enable nas)
		$(use_enable nls locale)
		$(use_enable opengl video-opengl)
		$(use_enable openurl misc)
		$(use_enable oss)
		$(use_enable pipewire)
		$(use_enable pulseaudio)
		$(use_enable sndio)
		$(use_enable sound audio)
		$(use_enable sound diskaudio)
		$(use_enable sound dummyaudio)
		$(use_enable static-libs static)
		$(use_enable threads pthreads)
		$(use_enable udev libudev)
		$(use_enable video)
		$(use_enable video video-dummy)
		$(use_enable video_cards_vc4 video-rpi)
		$(use_enable vulkan video-vulkan)
		$(use_enable wayland video-wayland)
		$(use_enable X video-x11)
		$(use_enable X video-x11-xcursor)
		$(use_enable X video-x11-xdbe)
		$(use_enable X video-x11-xfixes)
		$(use_enable X video-x11-xinput)
		$(use_enable X video-x11-xrandr)
		$(use_enable X video-x11-xshape)
		$(use_enable xscreensaver video-x11-scrnsaver)
		$(use_with X x)
		--disable-alsa-shared
		--disable-arts
		--disable-directx
		--disable-esd
		--disable-fusionsound
		--disable-fusionsound-shared
		--disable-jack-shared
		--disable-kmsdrm-shared
		--disable-libsamplerate-shared
		--disable-nas-shared
		--disable-pipewire-shared
		--disable-pulseaudio-shared
		--disable-render-d3d
		--disable-rpath
		--disable-sndio-shared
		--disable-video-directfb
		--disable-wayland-shared
		--disable-werror
		--disable-x11-shared
		--enable-assembly
		--enable-atomic
		--enable-cpuinfo
		--enable-events
		--enable-file
		--enable-filesystem
		--enable-loadso
		--enable-power
		--enable-render
		--enable-system-iconv
		--enable-timers
		ac_cv_header_libunwind_h=no
	)

	if use armv6-simd && use cpu_flags_arm_v6 ; then
		myeconfargs+=(
			--enable-arm-simd
		)
	else
		myeconfargs+=(
			--disable-arm-simd
		)
	fi

	if use cpu_flags_arm_v7 && use cpu_flags_arm_neon ; then
		myeconfargs+=(
			--enable-arm-neon
		)
	else
		myeconfargs+=(
			--disable-arm-neon
		)
	fi

	if use hidapi-hidraw || use hidapi-libusb ; then
		myeconfargs+=(
			$(use_enable hidapi-libusb)
			--enable-hidapi
		)
	else
		myeconfargs+=(
			--disable-hidapi
		)
	fi

	if use loong ; then
		myeconfargs+=(
			$(use_enable lsx)
		)
	else
		myeconfargs+=(
			--disable-lsx
		)
	fi

	ECONF_SOURCE="${S}" \
	econf "${myeconfargs[@]}"

	if use test; then
		# Most of these workarounds courtesy Debian
		# https://salsa.debian.org/sdl-team/libsdl2/-/blob/debian/latest/debian/rules
		local mytestargs=(
			--x-includes="/usr/include"
			--x-libraries="/usr/$(get_libdir)"
			SDL_CFLAGS="-I${S}/include"
			SDL_LIBS="-L${BUILD_DIR}/build/.libs -lSDL2"
			ac_cv_lib_SDL2_ttf_TTF_Init=no
			CFLAGS="${CPPFLAGS} ${CFLAGS} ${LDFLAGS}"
		)

		mkdir "${BUILD_DIR}/test" || die
		cd "${BUILD_DIR}/test" || die
		ECONF_SOURCE="${S}/test" \
		econf "${mytestargs[@]}"
	fi
}

multilib_src_compile() {
	emake all V=1
	if use test ; then
		emake -C test all V=1
	fi
}

src_compile() {
	multilib-minimal_src_compile
	if use doc; then
		cd docs || die
		doxygen || die
	fi
}

multilib_src_test() {
	if use test ; then
		LD_LIBRARY_PATH="${BUILD_DIR}/build/.libs" \
		emake -C test check V=1
	fi
}

multilib_src_install() {
	emake DESTDIR="${D}" install
}

multilib_src_install_all() {
	# Do not delete the static .a libraries here as some are
	# mandatory. They may be needed even when linking dynamically.
	find "${ED}" -type f -name "*.la" -delete || die

	dodoc \
		{BUGS,CREDITS,README-SDL,TODO,WhatsNew}.txt \
		README.md \
		docs/README*.md
	use doc && dodoc -r docs/output/html/

	docinto licenses
	dodoc LICENSE.txt

	head -n 10 \
		"src/libm/e_atan2.c" \
		> \
		"${T}/libm.LICENSE" \
		|| die
	docinto licenses/src/libm
	dodoc "${T}/libm.LICENSE"

	if use video ; then
		if ( use cpu_flags_arm_v6 && use armv6-simd ) \
			|| ( use cpu_flags_arm_v7 && use cpu_flags_arm_neon ) ; then
			head -n 25 \
				"src/video/arm/pixman-arm-asm.h" \
				> \
				"${T}/pixman-arm-asm.LICENSE" \
				|| die
			docinto licenses/src/video/arm/pixman-arm
			dodoc "${T}/pixman-arm-asm.LICENSE"
		fi

		if use cpu_flags_arm_v6 && use armv6-simd ; then
			head -n 19 \
				"src/video/arm/pixman-arm-simd-asm.S" \
				> \
				"${T}/pixman-arm-simd-asm.LICENSE" \
				|| die
			docinto licenses/src/video/arm/pixman-arm
			dodoc "${T}/pixman-arm-simd-asm.LICENSE"
		fi

		if use cpu_flags_arm_v7 && use cpu_flags_arm_neon ; then
			head -n 44 \
				"src/video/arm/pixman-arm-neon-asm.S" \
				> \
				"${T}/pixman-arm-neon-asm.LICENSE" \
				|| die
			docinto licenses/src/video/arm/pixman-arm
			dodoc "${T}/pixman-arm-neon-asm.LICENSE"
		fi

		docinto licenses/src/video/yuv2rgb
		dodoc src/video/yuv2rgb/LICENSE

		tail -n 142 \
			"debian/copyright" \
			| head -n 58 \
			> "${T}/SDL_yuv_sw.c.LICENSE" \
			|| die
		docinto licenses/src/render
		dodoc "${T}/SDL_yuv_sw.c.LICENSE"

		if use X ; then
			head -n 25 \
				"src/events/imKStoUCS.c" \
				> \
				"${T}/imKStoUCS.c.LICENSE" \
				|| die
			docinto licenses/src/video/x11
			dodoc "${T}/imKStoUCS.c.LICENSE"
			head -n 28 \
				"src/events/imKStoUCS.h" \
				> \
				"${T}/imKStoUCS.h.LICENSE" \
				|| die
			docinto licenses/src/video/x11
			dodoc "${T}/imKStoUCS.h.LICENSE"
		fi

		# Additional copyright, The first already covered in the
		# default for this module.  Copied again for containers or
		# redist.
		docinto licenses/include
		head -n 65 \
			"include/SDL_opengl.h" \
			| tail -n 24 \
			> \
			"${T}/SDL_opengl.h.LICENSE" \
			|| die
		dodoc "${T}/SDL_opengl.h.LICENSE"
	fi

	if use hidapi-hidraw || use hidapi-libusb ; then
		docinto licenses/src/hidapi
		dodoc src/hidapi/LICENSE.txt
		dodoc src/hidapi/LICENSE-orig.txt
		dodoc src/hidapi/LICENSE-gpl3.txt
		dodoc src/hidapi/LICENSE-bsd.txt
	fi

	#if use test ; then
		head -n 52 \
			"src/test/SDL_test_md5.c" \
			> \
			"${T}/SDL_test_md5.c.LICENSE" \
			|| die
		docinto licenses/src/test
		dodoc "${T}/SDL_test_md5.c.LICENSE"
	#fi
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED 2.28.0 (test-suite) (20230625)
# USE="X alsa gles2 haptic joystick opengl sound test%* threads video wayland
# (-aqua) -armv6-simd (-custom-cflags) -dbus -doc -fcitx4 -gles1 -hidapi-hidraw
# -hidapi-libusb -ibus -jack -kms -libdecor -libsamplerate -nas -nls -openurl
# -oss -pipewire -pulseaudio -sndio -static-libs -udev -vulkan -xscreensaver"
