# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="DF HO"

CHKL_TIMESTAMPS=(
	"dev-libs/fribidi-9999"
	"media-libs/alsa-lib-9999"
	"media-libs/libpulse-9999"
	"media-libs/mesa-9999"
	"media-sound/sndio-9999"
	"sys-apps/dbus-9999"
	"x11-libs/libdrm-9999"
	"x11-libs/libX11-9999"
	"x11-libs/libXcursor-9999"
	"x11-libs/libxkbcommon-9999"
)

inherit cflags-hardened check-compiler-switch chkl cmake-multilib dot-a secure-version

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="a8591d943b7079b17fdd018dc04ec9c71dc94ae4"
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/SDL3-${PV}"
	EGIT_REPO_URI="https://github.com/libsdl-org/SDL.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
	SRC_URI="https://www.libsdl.org/release/SDL3-${PV}.tar.gz"
fi

DESCRIPTION="Simple Direct Media Layer"
HOMEPAGE="https://www.libsdl.org/"
S=${WORKDIR}/SDL3-${PV}

LICENSE="ZLIB"
SLOT="0"

IUSE+="
	X alsa aqua bidi dbus doc ibus io-uring jack kms opengl oss
	pipewire pulseaudio sndio test udev usb vulkan wayland
	cpu_flags_ppc_altivec cpu_flags_x86_avx cpu_flags_x86_avx2
	cpu_flags_x86_avx512f cpu_flags_x86_mmx cpu_flags_x86_sse
	cpu_flags_x86_sse2 cpu_flags_x86_sse3 cpu_flags_x86_sse4_1
	cpu_flags_x86_sse4_2
"
REQUIRED_USE="
	ibus? ( dbus )
	kms? ( opengl )
	wayland? ( opengl )
"
RESTRICT="!test? ( test )"

# dlopen/dbus-only: dbus, ibus, libudev, liburing, vulkan-loader
RDEPEND="
	virtual/libiconv:*[${MULTILIB_USEDEP}]
	X? (
		>=x11-libs/libX11-${LIBX11_PV}:=[${MULTILIB_USEDEP}]
		x11-libs/libXScrnSaver:=[${MULTILIB_USEDEP}]
		>=x11-libs/libXcursor-${LIBXCURSOR_PV}:=[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-${LIBXEXT_PV}:=[${MULTILIB_USEDEP}]
		>=x11-libs/libXfixes-${LIBXFIXES_PV}:=[${MULTILIB_USEDEP}]
		>=x11-libs/libXi-${LIBXI_PV}:=[${MULTILIB_USEDEP}]
		>=x11-libs/libXrandr-${LIBXRANDR_PV}:=[${MULTILIB_USEDEP}]
		>=x11-libs/libXtst-${LIBXTST_PV}:=[${MULTILIB_USEDEP}]
	)
	alsa? ( >=media-libs/alsa-lib-${ALSA_LIB_PV}:=[${MULTILIB_USEDEP}] )
	bidi? ( >=dev-libs/fribidi-${FRIBIDI_PV}:=[${MULTILIB_USEDEP}] )
	dbus? ( >=sys-apps/dbus-${DBUS_PV}:=[${MULTILIB_USEDEP}] )
	ibus? ( app-i18n/ibus:= )
	io-uring? ( sys-libs/liburing:=[${MULTILIB_USEDEP}] )
	jack? ( virtual/jack:*[${MULTILIB_USEDEP}] )
	kms? (
		>=media-libs/mesa-${MESA_PV}:=[gbm(+),${MULTILIB_USEDEP}]
		>=x11-libs/libdrm-${LIBDRM_PV}:=[${MULTILIB_USEDEP}]
	)
	opengl? ( >=media-libs/libglvnd-${LIBGLVND_PV}:=[X?,${MULTILIB_USEDEP}] )
	pipewire? ( >=media-video/pipewire-${PIPEWIRE_PV}:=[${MULTILIB_USEDEP}] )
	pulseaudio? ( >=media-libs/libpulse-${LIBPULSE_PV}:=[${MULTILIB_USEDEP}] )
	sndio? ( >=media-sound/sndio-${SNDIO_PV}:=[${MULTILIB_USEDEP}] )
	udev? ( virtual/libudev:=[${MULTILIB_USEDEP}] )
	usb? ( virtual/libusb:1[${MULTILIB_USEDEP}] )
	wayland? (
		>=dev-libs/wayland-${WAYLAND_PV}:=[${MULTILIB_USEDEP}]
		gui-libs/libdecor:=[${MULTILIB_USEDEP}]
		>=x11-libs/libxkbcommon-${LIBXKBCOMMON_PV}:=[${MULTILIB_USEDEP}]
	)
	vulkan? ( >=media-libs/vulkan-loader-${VULKAN_LOADER_PV}:=[${MULTILIB_USEDEP}] )
"
DEPEND="
	${RDEPEND}
	X? ( x11-base/xorg-proto:= )
	test? (
		>=dev-util/vulkan-headers-${VULKAN_LOADER_PV}:=
		>=media-libs/libglvnd-${LIBGLVND_PV}:=
	)
	vulkan? ( >=dev-util/vulkan-headers-${VULKAN_LOADER_PV}:= )
"
BDEPEND="
	doc? (
		app-text/doxygen
		media-gfx/graphviz
	)
	wayland? ( dev-util/wayland-scanner )
"

CMAKE_QA_COMPAT_SKIP=1 #964577

pkg_setup() {
	check-compiler-switch_start
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_prepare() {
	cmake_src_prepare

	# unbundle libglvnd and vulkan headers
	rm -r src/video/khronos || die
	ln -s -- "${ESYSROOT}"/usr/include src/video/khronos || die
}

src_configure() {
	chkl_check_many_timestamps

	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	cflags-hardened_append

	lto-guarantee-fat

	local mycmakeargs=(
		-DSDL_ASSERTIONS=disabled
		-DSDL_DEPS_SHARED=no # link rather than dlopen() where possible
		-DSDL_RPATH=no
		-DSDL_STATIC=no
		-DSDL_TESTS=$(usex test)

		# audio
		-DSDL_ALSA=$(usex alsa)
		-DSDL_JACK=$(usex jack)
		-DSDL_OSS=$(usex oss)
		-DSDL_PIPEWIRE=$(usex pipewire)
		-DSDL_PULSEAUDIO=$(usex pulseaudio)
		-DSDL_SNDIO=$(usex sndio)

		# input
		-DSDL_HIDAPI_LIBUSB=$(usex usb)
		-DSDL_IBUS=$(use ibus)
		-DSDL_LIBUDEV=$(usex udev)

		# video
		-DSDL_COCOA=$(usex aqua)
		-DSDL_DIRECTX=no
		-DSDL_KMSDRM=$(usex kms)
		-DSDL_LIBTHAI=no # not packaged
		-DSDL_OPENGL=$(usex opengl)
		-DSDL_OPENGLES=$(usex opengl)
		-DSDL_OPENVR=no # not packaged, note needs opengl REQUIRED_USE if added
		-DSDL_ROCKCHIP=no
		-DSDL_RPI=no
		-DSDL_VIVANTE=no
		-DSDL_VULKAN=$(usex vulkan)
		-DSDL_WAYLAND=$(usex wayland)
		-DSDL_X11=$(usex X)
		# SDL disallows this by default, allow it but warn in pkg_postinst
		$(use !X && use !wayland && echo -DSDL_UNIX_CONSOLE_BUILD=yes)

		# misc
		-DSDL_DBUS=$(usex dbus)
		-DSDL_FRIBIDI=$(usex bidi)
		-DSDL_LIBURING=$(usex io-uring)

		# cpu instruction sets
		-DSDL_ALTIVEC=$(usex cpu_flags_ppc_altivec)
		-DSDL_AVX=$(usex cpu_flags_x86_avx)
		-DSDL_AVX2=$(usex cpu_flags_x86_avx2)
		-DSDL_AVX512F=$(usex cpu_flags_x86_avx512f)
		-DSDL_MMX=$(usex cpu_flags_x86_mmx)
		-DSDL_SSE=$(usex cpu_flags_x86_sse)
		-DSDL_SSE2=$(usex cpu_flags_x86_sse2)
		-DSDL_SSE3=$(usex cpu_flags_x86_sse3)
		-DSDL_SSE4_1=$(usex cpu_flags_x86_sse4_1)
		-DSDL_SSE4_2=$(usex cpu_flags_x86_sse4_2)
	)

	cmake-multilib_src_configure
}

src_compile() {
	cmake-multilib_src_compile

	if use doc; then
		cd docs && doxygen || die
	fi
}

src_test() {
	unset "${!SDL_@}" # ignore users' preferences for tests

	cmake-multilib_src_test
}

src_install() {
	local DOCS=( {BUGS,WhatsNew}.txt {CREDITS,README}.md docs/*.md )
	cmake-multilib_src_install

	strip-lto-bytecode

	rm -r -- "${ED}"/usr/share/licenses || die

	use doc && dodoc -r docs/output/html/
}

pkg_postinst() {
	# skipping audio/video can make sense given many packages only use SDL
	# for input, but still warn given off-by-default and may be unexpected
	if use !X && use !aqua && use !kms && use !wayland; then
		ewarn
		ewarn "All typical display drivers (e.g. USE=wayland) are disabled,"
		ewarn "applications using SDL for display may not function properly."
	fi

	if use !alsa && use !jack && use !oss && use !pipewire &&
		use !pulseaudio && use !sndio; then
		ewarn
		ewarn "All typical audio drivers (e.g. USE=pipewire) are disabled,"
		ewarn "applications using SDL for audio may not function properly."
	fi
}
