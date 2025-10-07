# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

GCC_COMPAT=(
	"gcc_slot_14_3" # Support -std=c++26, but reduce chances of breaking CUDA 12.x support
)
CFLAGS_HARDENED_USE_CASES="copy-paste-password security-critical sensitive-data secure-data"

inherit cflags-hardened check-compiler-switch libstdcxx-slot meson toolchain-funcs

DESCRIPTION="A dynamic tiling Wayland compositor that doesn't sacrifice on its looks"
HOMEPAGE="https://github.com/hyprwm/Hyprland"

if [[ "${PV}" == *"9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hyprwm/${PN^}.git"
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
IUSE="
legacy-renderer +qtutils systemd X
ebuild_revision_13
"
REQUIRED_USE="
"
# hyprpm (hyprland plugin manager) requires the dependencies at runtime
# so that it can clone, compile and install plugins.
HYPRPM_RDEPEND="
	>=dev-build/cmake-3.30
	>=dev-build/meson-1.8.2
	>=dev-vcs/git-2.50.1
	app-alternatives/ninja
	virtual/pkgconfig
"
# Relaxed re2 version requirement.  Originally slot 11
RDEPEND="
	${HYPRPM_RDEPEND}
	>=dev-cpp/tomlplusplus-3.4.0[${LIBSTDCXX_USEDEP}]
	dev-cpp/tomlplusplus:=
	>=dev-libs/hyprlang-0.3.2[${LIBSTDCXX_USEDEP}]
	dev-libs/hyprlang:=
	>=dev-libs/hyprgraphics-0.1.3[${LIBSTDCXX_USEDEP}]
	dev-libs/hyprgraphics:=
	>=dev-libs/libinput-1.28.1:=
	dev-libs/re2[${LIBSTDCXX_USEDEP}]
	dev-libs/re2:=
	>=dev-libs/udis86-1.7.2
	>=dev-libs/wayland-1.22.90
	>=gui-libs/aquamarine-0.9.0[${LIBSTDCXX_USEDEP}]
	gui-libs/aquamarine:=
	>=gui-libs/hyprcursor-0.1.7[${LIBSTDCXX_USEDEP}]
	gui-libs/hyprcursor:=
	>=gui-libs/hyprutils-0.8.1[${LIBSTDCXX_USEDEP}]
	gui-libs/hyprutils:=
	>=media-libs/libglvnd-1.7.0
	>=media-libs/mesa-25.1.6
	>=x11-libs/cairo-1.18.4
	>=x11-libs/libdrm-2.4.125
	>=x11-libs/libXcursor-1.2.3
	>=x11-libs/libxkbcommon-1.10.0
	>=x11-libs/pango-1.56.4
	>=x11-libs/pixman-0.46.2
	dev-libs/glib:2
	sys-apps/util-linux
	qtutils? (
		gui-libs/hyprland-qtutils
	)
	X? (
		>=x11-libs/libxcb-1.17.0:0=
		>=x11-libs/xcb-util-errors-1.0.1
		>=x11-libs/xcb-util-wm-0.4.2
		>=x11-base/xwayland-24.1.8
	)
"
DEPEND="
	${RDEPEND}
	>=dev-cpp/glaze-5.5.4
	>=dev-libs/hyprland-protocols-0.6.4
	>=dev-libs/wayland-protocols-1.43
"
BDEPEND="
	>=app-misc/jq-1.8.1
	>=dev-util/hyprwayland-scanner-0.3.10[${LIBSTDCXX_USEDEP}]
	dev-util/hyprwayland-scanner:=
	>=dev-build/cmake-4.0.3
	virtual/pkgconfig
	|| (
		>=sys-devel/gcc-14
		>=llvm-core/clang-17
	)
"

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

	if tc-is-clang && ! use clang ; then
eerror "Enable the clang USE flag"
		die
	fi
	libstdcxx-slot_verify
}

src_prepare() {
	# skip version.h
	sed -i -e "s|scripts/generateVersion.sh|echo|g" "meson.build" || die
	default
}

src_configure() {
	cflags-hardened_append
	local emesonargs=(
		#$(meson_feature legacy-renderer legacy_renderer)
		$(meson_feature systemd)
		$(meson_feature X xwayland)
	)
	meson_src_configure
}

# OILEDMACHINE-OVERLAY-TEST:  0.51.1 PASSED (20250815)

# Tested use flags:
# USE="-X -clang -legacy-renderer -qtutils -systemd"
