# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

# This ebuild contains a patch with AI generated code.

PYTHON_COMPAT=( "python3_"{12,13} )

ABSEIL_CPP_SLOT="20240116"
CXX_STANDARD=26
CFLAGS_HARDENED_USE_CASES="copy-paste-password security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="RC"
RE2_SLOT="20250512"

inherit libstdcxx-compat
GCC_COMPAT=(
	# For older GPU libs users, use hyprland 0.39.1 instead
	"${LIBSTDCXX_COMPAT_STDCXX26[@]}"
)
LIBSTDCXX_USEDEP_LTS="gcc_slot_skip(+)" # Skip placeholder

inherit libcxx-compat
LLVM_COMPAT=(
	# For older GPU libs users, use hyprland 0.39.1 instead
	"${LIBCXX_COMPAT_STDCXX26[@]/llvm_slot_}"
)
LIBCXX_USEDEP_LTS="llvm_slot_skip(+)" # Skip placeholder

CHKL_TIMESTAMPS=(
	"app-misc/jq-9999"
	"dev-cpp/muParser-9999"
	"dev-cpp/tomlplusplus-9999"
	"dev-libs/glib-2.89.9999"
	"dev-libs/hyprlang-9999"
	"dev-libs/libinput-9999"
	"dev-libs/wayland-9999"
	"gui-libs/hyprutils-9999"
	"media-libs/lcms-9999"
	"media-libs/mesa-9999"
	"sys-apps/util-linux-9999"
	"sys-libs/readline-9999"
	"x11-base/xwayland-9999"
	"x11-libs/cairo-9999"
	"x11-libs/libdrm-9999"
	"x11-libs/pango-9999"
	"x11-libs/pixman-9999"
	"x11-libs/libxcb-9999"
	"x11-libs/libXcursor-9999"
	"x11-libs/libxkbcommon-9999"
)

inherit abseil-cpp cflags-hardened check-compiler-switch chkl cmake libcxx-slot libstdcxx-slot optfeature python-single-r1 re2 secure-version toolchain-funcs

DESCRIPTION="A dynamic tiling Wayland compositor that doesn't sacrifice on its looks"
HOMEPAGE="https://github.com/hyprwm/Hyprland"

if [[ "${PV}" == *"9999" ]] ; then
	FALLBACK_COMMIT="7d2ea270704c265dd100a7898e6186e49c6741a7"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/hyprwm/${PN^}.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-source"
	SRC_URI="
https://github.com/hyprwm/${PN^}/releases/download/v${PV}/source-v${PV}.tar.gz
	-> ${P}.gh.tar.gz
	"
fi

LICENSE="BSD"
SLOT="0"
IUSE+="
${GCC_COMPAT[@]}
clang gcc legacy-renderer -guiutils systemd test X
ebuild_revision_32
"
REQUIRED_USE="
	^^ (
		clang
		gcc
	)
"
# hyprpm (hyprland plugin manager) requires the dependencies at runtime
# so that it can clone, compile and install plugins.
HYPRPM_RDEPEND="
	>=dev-vcs/git-2.51.0:=
"
# Relaxed re2 version requirement.  Originally slot 11
# glib was not mentioned in build files
# util-linux was not mentoned in build files
# glib version is relaxed
RDEPEND="
	${HYPRPM_RDEPEND}
	>=dev-cpp/muParser-${MUPARSER_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=dev-cpp/tomlplusplus-${TOMLPLUSPLUS_PV}:=[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS}]
	>=dev-libs/glib-${GLIB_PV}:=
	>=dev-libs/hyprlang-${HYPRLANG_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=dev-libs/hyprgraphics-0.5.1:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=dev-libs/libei-${LIBEI_PV}:=
	>=dev-libs/libinput-${LIBINPUT_PV}:=
	>=dev-libs/udis86-1.7.2:=
	>=dev-libs/wayland-${WAYLAND_PV}:=
	>=gui-libs/aquamarine-0.11.0:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=gui-libs/hyprcursor-0.1.13:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=gui-libs/hyprutils-${HYPRUTILS_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=gui-libs/hyprwire-0.3.1:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=media-libs/lcms-${LCMS_PV}:=
	>=media-libs/libglvnd-${LIBGLVND_PV}:=
	>=media-libs/mesa-${MESA_PV}:=[opengl]
	>=sys-apps/pciutils-3.10.0:=
	>=sys-apps/util-linux-${UTIL_LINUX_PV}:=
	>=sys-libs/readline-${READLINE_PV}:=
	>=x11-libs/cairo-${CAIRO_PV}:=
	>=x11-libs/libdrm-${LIBDRM_PV}:=
	>=x11-libs/libXcursor-${LIBXCURSOR_PV}:=
	>=x11-libs/libxkbcommon-${LIBXKBCOMMON_PV}:=
	>=x11-libs/pango-${PANGO_PV}:=
	>=x11-libs/pixman-${PIXMAN_PV}:=
	dev-cpp/sdbus-c++:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	dev-lang/lua:5.5=
	dev-libs/re2:${RE2_SLOT}=[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS}]
	dev-util/glslang:=
	guiutils? (
		gui-libs/hyprland-guiutils:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	)
	X? (
		>=x11-libs/libxcb-${LIBXCB_PV}:0=
		>=x11-libs/libXdmcp-1.1.5:=
		>=x11-libs/xcb-util-errors-1.0.1:=
		>=x11-libs/xcb-util-renderutil-0.3.10:=
		>=x11-libs/xcb-util-wm-0.4.2:=
		>=x11-base/xwayland-${XWAYLAND_PV}:=
	)
"
DEPEND="
	${RDEPEND}
	>=dev-cpp/glaze-7.6.0:=
	>=dev-libs/hyprland-protocols-0.6.4:=
	>=dev-libs/wayland-protocols-1.49:=
"
BDEPEND="
	>=dev-build/cmake-4.3.2
	>=dev-util/hyprwayland-scanner-0.4.5[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=dev-util/wayland-scanner-1.24.0
	virtual/pkgconfig
	clang? (
		>=llvm-core/clang-17:=
	)
	gcc? (
		>=sys-devel/gcc-14:=
	)
	test? (
		>=app-misc/jq-${JQ_PV}
		>=dev-cpp/gtest-1.17.0[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS}]
		x11-apps/xeyes
		x11-terms/kitty
	)
"
PATCHES=(
	"${FILESDIR}/hyprland-7d2ea27-string_view.patch"
)

pkg_setup() {
	check-compiler-switch_start
	[[ "${MERGE_TYPE}" == "binary" ]] && return

	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export CPP=$(tc-getCPP)
	strip-unsupported-flags

einfo "CC:  ${CC}"
einfo "CXX:  ${CXX}"
einfo "CPP:  ${CPP}"
einfo "CFLAGS:  ${CFLAGS}"
einfo "CXXFLAGS:  ${CXXFLAGS}"
einfo "CPPFLAGS:  ${CPPFLAGS}"

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	${CC} --version || die

	libcxx-slot_verify
	libstdcxx-slot_verify

	if tc-is-gcc ; then
		tc-check-min_ver "gcc" "14"
	else
		tc-check-min_ver "clang" "17"
	fi

	python-single-r1_pkg_setup
}

src_unpack() {
	if [[ "${PV}" == *"9999" ]] ; then
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
}

src_configure() {
	if tc-is-clang ; then
		use clang || die "Enable the clang USE flag"
	fi
	if tc-is-gcc ; then
		use gcc || die "Enable the gcc USE flag"
	fi
	chkl_check_many_timestamps
	cflags-hardened_append
	abseil-cpp_src_configure
	re2_src_configure
	local mycmakeargs=(
		-DNO_SYSTEMD=$(usex !systemd)
		-DNO_XWAYLAND=$(usex !X)
		-DUSE_TRACY=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
}

pkg_postinst() {
ewarn "This main package does not install a clock, terminal, file manager by default."
einfo
einfo
einfo "Edit the default keybindings and my programs sections and"
einfo "use the hyprland.lua as a starter config (RECOMMENDED):"
einfo
einfo "mkdir -p ~/.config/hypr"
einfo "cat /usr/share/hypr/hyprland.lua > ~/.config/hypr/hyprland.lua"
einfo
einfo
einfo "The cheat sheet for hyprland.lua keybindings:"
einfo
einfo "  SUPER + R -- Runs app launcher"
einfo "  SUPER + Q -- Runs terminal"
einfo "  SUPER + left key -- Focus on left window"
einfo "  SUPER + right key -- Focus on right window"
einfo "  SUPER + top key -- Focus on top window"
einfo "  SUPER + bottom key -- Focus on bottom window"
einfo "  SUPER + M -- Quit"
einfo "  SUPER + SHIFT + 1 -- Move window to virtual desktop 1"
einfo "  SUPER + SHIFT + 2 -- Move window to virtual desktop 2"
einfo "  ..."
einfo "  SUPER + SHIFT + 9 -- Move window to virtual desktop 9"
einfo "  SUPER + 1 -- Use virtual desktop 1"
einfo "  SUPER + 2 -- Use virtual desktop 2"
einfo "  ..."
einfo "  SUPER + 9 -- Use virtual desktop 9"
einfo
ewarn
ewarn "Hyprlang is deprecated and will be removed in the future."
ewarn "Migrate the config to the newest LUA based config."
ewarn
	optfeature_header "Install optional packages:"
	optfeature "a memory safe Rust based GTK4 status bar with clock" "gui-apps/wayle"
	optfeature "a themable status bar with clock and plugins" "gui-apps/noctalia"
	optfeature "a dmenu style app lanucher" "dev-libs/bemenu"
	optfeature "a Polkit agent for password requests for privileged actions" "sys-auth/hyprpolkitagent"
	optfeature "a memory safe Rust based terminal" "x11-terms/alacritty"
}

# OILEDMACHINE-OVERLAY-TEST:  INTERACTIVE 0.51.1 PASSED (20250815)
# OILEDMACHINE-OVERLAY-TEST:  INTERACTIVE 0.51.1 PASSED (20251010)
# OILEDMACHINE-OVERLAY-TEST:  INTERACTIVE 0.55.2 PASSED (20260519)
# OILEDMACHINE-OVERLAY-TEST:  INTERACTIVE live (7d2ea27) PASSED (20260723)

# Tested use flags:
# USE="-X -clang -legacy-renderer -qtutils -systemd"
