# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U20, U22

MY_P="SDL2-${PV/_pre}"

# Used by ffplay to play videos
CFLAGS_HARDENED_USE_CASES="sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="DF HO"

inherit cflags-hardened check-compiler-switch cmake flag-o-matic linux-info toolchain-funcs multilib-minimal

KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~x86"
S="${WORKDIR}/${MY_P}"
SRC_URI="https://www.libsdl.org/release/${MY_P}.tar.gz"

DESCRIPTION="Simple Direct Media Layer"
HOMEPAGE="
	https://www.libsdl.org/
	https://github.com/libsdl-org/SDL
"
LICENSE_HIDAPI="
	|| (
		BSD
		GPL-3
		HIDAPI
	)
"
LICENSE="
	all-rights-reserved
	BSD
	BrownUn_UnCalifornia_ErikCorry
	CPL-1.0
	LGPL-2.1+
	MIT
	RSA_Data_Security
	SunPro
	ZLIB
	armv6-simd? (
		pixman-arm-asm.h
		ZLIB
	)
	cpu_flags_arm_neon? (
		MIT
		pixman-arm-asm.h
		ZLIB
	)
	hidapi? (
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
LOONG_CPU_FLAGS=(
	cpu_flags_loong_lsx
	cpu_flags_loong_lasx
)
PPC_CPU_FLAGS=(
	cpu_flags_ppc_altivec
)
X86_CPU_FLAGS=(
	cpu_flags_x86_3dnow
	cpu_flags_x86_mmx
	cpu_flags_x86_sse
	cpu_flags_x86_sse2
	cpu_flags_x86_sse3
)
VIDEO_CARDS_FLAGS=(
	video_cards_vc4
	video_cards_vivante
)
# oss is enabled by default upstream
IUSE="
${ARM_CPU_FLAGS[@]}
${LOONG_CPU_FLAGS[@]}
${PPC_CPU_FLAGS[@]}
${VIDEO_CARDS_FLAGS[@]}
${X86_CPU_FLAGS[@]}
+alsa aqua custom-cflags +dbus doc fcitx +gles1 +gles2 +haptic +hidapi
+hidapi-joystick -hidapi-libusb +ibus +jack +joystick +kms +libdecor
+libsamplerate +nas +nls +opengl +openurl oss +pipewire +pulseaudio
+sndio +sound +static-libs test +udev +video +vulkan +wayland +X
+xscreensaver
ebuild_revision_10
"
# libdecor is not in main repo but in community repos
REQUIRED_USE="
	alsa? (
		sound
	)
	fcitx? (
		dbus
	)
	gles1? (
		video
	)
	gles2? (
		video
	)
	hidapi-joystick? (
		hidapi
		joystick
	)
	hidapi-libusb? (
		hidapi
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
	test? (
		static-libs
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
	|| (
		joystick
		udev
	)
"
# See https://github.com/libsdl-org/SDL/blob/release-2.30.0/.github/workflows/main.yml#L47
# https://github.com/libsdl-org/SDL/blob/release-2.30.0/docs/README-linux.md
# U 22.04 ; CI tag release-2.30.x
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
	hidapi-libusb? (
		>=dev-libs/libusb-1.0.25[${MULTILIB_USEDEP}]
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
		>=gui-libs/libdecor-0.1.0[${MULTILIB_USEDEP}]
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
		>=media-libs/mesa-${MESA_PV}[${MULTILIB_USEDEP},egl(+),gles2(+),opengl,wayland]
		>=x11-libs/libxkbcommon-1.4.0[${MULTILIB_USEDEP}]
		gui-libs/libdecor[${MULTILIB_USEDEP}]
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
	fcitx? (
		>=app-i18n/fcitx-4.2.9.8:*
	)
	gles1? (
		>=media-libs/mesa-${MESA_PV}[${MULTILIB_USEDEP},gles1(+)]
	)
	gles2? (
		>=media-libs/mesa-${MESA_PV}[${MULTILIB_USEDEP},gles2(+)]
	)
	vulkan? (
		media-libs/vulkan-drivers[${MULTILIB_USEDEP}]
		media-libs/vulkan-loader[${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${CDEPEND}
	gles1? (
		media-libs/libglvnd[${MULTILIB_USEDEP}]
	)
	gles2? (
		media-libs/libglvnd[${MULTILIB_USEDEP}]
	)
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
	>=dev-build/autoconf-2.71
	doc? (
		>=app-text/doxygen-1.9.1
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
)

pkg_setup() {
	check-compiler-switch_start
}

src_prepare() {
	cmake_src_prepare

	# Unbundle some headers.
	rm -r src/video/khronos || die
	ln -s "${ESYSROOT}/usr/include" src/video/khronos || die

	prepare_abi() {
		cp -a "${S}" "${S}-${MULTIBUILD_VARIANT}" || die
	}
	multilib_foreach_abi prepare_abi
}

multilib_src_configure() {
	use custom-cflags || strip-flags

	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	cflags-hardened_append

	local mycmakeargs=(
		-DSDL_3DNOW=$(usex cpu_flags_x86_3dnow)
		-DSDL_ALSA=$(usex alsa)
		-DSDL_ALSA_SHARED="OFF"
		-DSDL_ALTIVEC=$(usex cpu_flags_ppc_altivec)
		-DSDL_ARTS="OFF"
		-DSDL_ASSEMBLY="ON"
		-DSDL_AUDIO=$(usex sound)
		-DSDL_COCOA=$(usex aqua)
		-DSDL_CPUINFO="ON"
		-DSDL_DBUS=$(usex dbus)
		-DSDL_DIRECTFB="OFF"
		-DSDL_DIRECTX="OFF"
		-DSDL_DISKAUDIO=$(usex sound)
		-DSDL_DUMMYAUDIO=$(usex sound)
		-DSDL_DUMMYVIDEO=$(usex video)
		-DSDL_GCC_ATOMICS="ON"
		-DSDL_ESD="OFF"
		-DSDL_EVENTS="ON"
		-DSDL_FILE="ON"
		-DSDL_FILESYSTEM="ON"
		-DSDL_FUSIONSOUND="OFF"
		-DSDL_FUSIONSOUND_SHARED="OFF"
		-DSDL_HAPTIC=$(usex haptic)
		-DSDL_HIDAPI=$(usex hidapi)
		-DSDL_IBUS=$(usex ibus)
		-DSDL_JACK=$(usex jack)
		-DSDL_JACK_SHARED="OFF"
		-DSDL_JOYSTICK=$(usex joystick)
		-DSDL_KMSDRM=$(usex kms)
		-DSDL_KMSDRM_SHARED="OFF"
		-DSDL_LIBSAMPLERATE=$(usex libsamplerate)
		-DSDL_LIBSAMPLERATE_SHARED="OFF"
		-DSDL_LIBUDEV=$(usex udev)
		-DSDL_LOADSO="ON"
		-DSDL_LOCALE=$(usex nls)
		-DSDL_MMX=$(usex cpu_flags_x86_mmx)
		-DSDL_MISC=$(usex openurl)
		-DSDL_NAS=$(usex nas)
		-DSDL_NAS_SHARED="OFF"
		-DSDL_OPENGL=$(usex opengl)
		-DSDL_OSS=$(usex oss)
		-DSDL_RENDER_D3D="OFF"
		-DSDL_PIPEWIRE=$(usex pipewire)
		-DSDL_PIPEWIRE_SHARED="OFF"
		-DSDL_POWER="ON"
		-DSDL_PULSEAUDIO=$(usex pulseaudio)
		-DSDL_PULSEAUDIO_SHARED="OFF"
		-DSDL_RENDER="ON"
		-DSDL_RPATH="OFF"
		-DSDL_RPI=$(usex video_cards_vc4)
		-DSDL_SNDIO=$(usex sndio)
		-DSDL_SNDIO_SHARED="OFF"
		-DSDL_SSE=$(usex cpu_flags_x86_sse)
		-DSDL_SSE2=$(usex cpu_flags_x86_sse2)
		-DSDL_SSE3=$(usex cpu_flags_x86_sse3)
		-DSDL_SSEMATH=$(usex cpu_flags_x86_sse)
		-DSDL_STATIC=$(usex static-libs)
		-DSDL_SYSTEM_ICONV="ON"
		-DSDL_TESTS=$(usex test)
		-DSDL_TIMERS="ON"
		-DSDL_VIDEO=$(usex video)
		-DSDL_VIDEO_RENDER_D3D="OFF"
		-DSDL_VIVANTE=$(usex video_cards_vivante)
		-DSDL_VULKAN=$(usex vulkan)
		-DSDL_WAYLAND=$(usex wayland)
		-DSDL_WAYLAND_LIBDECOR=$(usex wayland)
		-DSDL_WAYLAND_LIBDECOR_SHARED="OFF"
		-DSDL_WAYLAND_SHARED="OFF"
		-DSDL_WERROR="OFF"
		-DSDL_X11=$(usex X)
		-DSDL_X11_SHARED="OFF"
		-DSDL_X11_XCURSOR=$(usex X)
		-DSDL_X11_XDBE=$(usex X)
		-DSDL_X11_XINPUT=$(usex X)
		-DSDL_X11_XFIXES=$(usex X)
		-DSDL_X11_XRANDR=$(usex X)
		-DSDL_X11_XSCRNSAVER=$(usex xscreensaver)
		-DSDL_X11_XSHAPE=$(usex X)
	)

	if use gles1 || use gles2 ; then
		mycmakeargs+=(
			-DSDL_OPENGLES="ON"
		)
	else
		mycmakeargs+=(
			-DSDL_OPENGLES="OFF"
		)
	fi

	if use hidapi-joystick || use hidapi-libusb ; then
		mycmakeargs+=(
			-DSDL_HIDAPI="ON"
		)
	else
		mycmakeargs+=(
			-DSDL_HIDAPI="OFF"
			-DSDL_HIDAPI_JOYSTICK="OFF"
			-DSDL_HIDAPI_LIBUSB="OFF"
		)
	fi

	if use hidapi-joystick ; then
		mycmakeargs+=(
			-DSDL_HIDAPI_JOYSTICK="ON"
		)
	fi
	if use hidapi-libusb ; then
		mycmakeargs+=(
			-DSDL_HIDAPI_LIBUSB="ON"
		)
	fi

	if use armv6-simd && use cpu_flags_arm_v6 ; then
		mycmakeargs+=(
			-DSDL_ARMSIMD="ON"
		)
	else
		mycmakeargs+=(
			-DSDL_ARMSIMD="OFF"
		)
	fi

	if use cpu_flags_arm_v7 && use cpu_flags_arm_neon ; then
		mycmakeargs+=(
			-DSDL_ARMNEON="ON"
		)
	else
		mycmakeargs+=(
			-DSDL_ARMNEON="OFF"
		)
	fi

	if use loong ; then
		myeconfargs+=(
			-DSDL_LSX=$(usex cpu_flags_loong_lsx)
			-DSDL_LASX=$(usex cpu_flags_loong_lasx)
		)
	else
		myeconfargs+=(
			-DSDL_LSX="OFF"
			-DSDL_LASX="OFF"
		)
	fi

	cmake_src_configure
}

multilib_src_compile() {
	cmake_src_compile

	if use doc; then
		cd docs || die
		doxygen || die
	fi
}

# TODO PGO
multilib_src_test() {
	unset SDL_GAMECONTROLLERCONFIG
	unset SDL_GAMECONTROLLER_USE_BUTTON_LABELS
	cmake_src_test
}

multilib_src_install() {
	cmake_src_install
}

multilib_src_install_all() {
	dodoc \
		{"BUGS","CREDITS","README-SDL","TODO","WhatsNew"}".txt" \
		"README.md" \
		"docs/README"*".md"
	use doc && dodoc -r "docs/output/html/"

	docinto "licenses"
	dodoc "LICENSE.txt"

	head -n 10 \
		"src/libm/e_atan2.c" \
		> \
		"${T}/libm.LICENSE" \
		|| die
	docinto "licenses/src/libm"
	dodoc "${T}/libm.LICENSE"

	if use video ; then
		if ( use cpu_flags_arm_v6 && use armv6-simd ) \
			|| ( use cpu_flags_arm_v7 && use cpu_flags_arm_neon ) ; then
			head -n 25 \
				"src/video/arm/pixman-arm-asm.h" \
				> \
				"${T}/pixman-arm-asm.LICENSE" \
				|| die
			docinto "licenses/src/video/arm/pixman-arm"
			dodoc "${T}/pixman-arm-asm.LICENSE"
		fi

		if use cpu_flags_arm_v6 && use armv6-simd ; then
			head -n 19 \
				"src/video/arm/pixman-arm-simd-asm.S" \
				> \
				"${T}/pixman-arm-simd-asm.LICENSE" \
				|| die
			docinto "licenses/src/video/arm/pixman-arm"
			dodoc "${T}/pixman-arm-simd-asm.LICENSE"
		fi

		if use cpu_flags_arm_v7 && use cpu_flags_arm_neon ; then
			head -n 44 \
				"src/video/arm/pixman-arm-neon-asm.S" \
				> \
				"${T}/pixman-arm-neon-asm.LICENSE" \
				|| die
			docinto "licenses/src/video/arm/pixman-arm"
			dodoc "${T}/pixman-arm-neon-asm.LICENSE"
		fi

		docinto "licenses/src/video/yuv2rgb"
		dodoc "src/video/yuv2rgb/LICENSE"

		tail -n 142 \
			"debian/copyright" \
			| head -n 58 \
			> "${T}/SDL_yuv_sw.c.LICENSE" \
			|| die
		docinto "licenses/src/render"
		dodoc "${T}/SDL_yuv_sw.c.LICENSE"

		if use X ; then
			head -n 25 \
				"src/events/imKStoUCS.c" \
				> \
				"${T}/imKStoUCS.c.LICENSE" \
				|| die
			docinto "licenses/src/video/x11"
			dodoc "${T}/imKStoUCS.c.LICENSE"
			head -n 28 \
				"src/events/imKStoUCS.h" \
				> \
				"${T}/imKStoUCS.h.LICENSE" \
				|| die
			docinto "licenses/src/video/x11"
			dodoc "${T}/imKStoUCS.h.LICENSE"
		fi

		# Additional copyright, The first already covered in the
		# default for this module.  Copied again for containers or
		# redist.
		docinto "licenses/include"
		head -n 65 \
			"include/SDL_opengl.h" \
			| tail -n 24 \
			> \
			"${T}/SDL_opengl.h.LICENSE" \
			|| die
		dodoc "${T}/SDL_opengl.h.LICENSE"
	fi

	if use hidapi-libusb ; then
		docinto "licenses/src/hidapi"
		dodoc "src/hidapi/LICENSE.txt"
		dodoc "src/hidapi/LICENSE-orig.txt"
		dodoc "src/hidapi/LICENSE-gpl3.txt"
		dodoc "src/hidapi/LICENSE-bsd.txt"
	fi

	#if use test ; then
		head -n 52 \
			"src/test/SDL_test_md5.c" \
			> \
			"${T}/SDL_test_md5.c.LICENSE" \
			|| die
		docinto "licenses/src/test"
		dodoc "${T}/SDL_test_md5.c.LICENSE"
	#fi
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED 2.28.0 (test-suite) (20230625)
# USE="X alsa gles2 haptic joystick opengl sound test%* threads video wayland
# (-aqua) -armv6-simd (-custom-cflags) -dbus -doc -fcitx4 -gles1 -hidapi-hidraw
# -hidapi-libusb -ibus -jack -kms -libdecor -libsamplerate -nas -nls -openurl
# -oss -pipewire -pulseaudio -sndio -static-libs -udev -vulkan -xscreensaver"
