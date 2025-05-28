# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Add retpoline for end-to-end copy-paste mitigation
CFLAGS_HARDENED_USE_CASES="sensitive-data secure-data"

inherit cflags-hardened meson toolchain-funcs

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
IUSE="clang legacy-renderer +qtutils systemd X"

# hyprpm (hyprland plugin manager) requires the dependencies at runtime
# so that it can clone, compile and install plugins.
HYPRPM_RDEPEND="
	>=dev-build/cmake-3.30
	app-alternatives/ninja
	dev-build/meson
	dev-vcs/git
	virtual/pkgconfig
"
RDEPEND="
	${HYPRPM_RDEPEND}
	>=dev-libs/udis86-1.7.2
	>=dev-libs/wayland-1.22.90
	>=gui-libs/aquamarine-0.8.0:=
	>=gui-libs/hyprcursor-0.1.9
	>=gui-libs/hyprutils-0.5.2:=
	dev-cpp/tomlplusplus
	dev-libs/glib:2
	dev-libs/hyprlang
	dev-libs/libinput:=
	dev-libs/hyprgraphics:=
	dev-libs/re2:=
	media-libs/libglvnd
	media-libs/mesa
	sys-apps/util-linux
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/pixman
	x11-libs/libXcursor
	qtutils? (
		gui-libs/hyprland-qtutils
	)
	X? (
		x11-libs/libxcb:0=
		x11-base/xwayland
		x11-libs/xcb-util-errors
		x11-libs/xcb-util-wm
	)
"
DEPEND="
	${RDEPEND}
	dev-cpp/glaze
	>=dev-libs/hyprland-protocols-0.6.0
	>=dev-libs/wayland-protocols-1.41
"
BDEPEND="
	>=dev-util/hyprwayland-scanner-0.3.10
	app-misc/jq
	dev-build/cmake
	virtual/pkgconfig
	!clang? (
		>=sys-devel/gcc-14:*
	)
	clang? (
		>=sys-devel/gcc-14:*
		>=llvm-core/clang-18:*
	)
"

pkg_setup() {
	[[ "${MERGE_TYPE}" == "binary" ]] && return

	if tc-is-gcc && ver_test $(gcc-version) -lt 14 ; then
		eerror "Hyprland requires >=sys-devel/gcc-14 to build"
		eerror "Please upgrade GCC: emerge -v1 sys-devel/gcc"
		die "GCC version is too old to compile Hyprland!"
	elif tc-is-clang && ver_test $(clang-version) -lt 18 ; then
		eerror "Hyprland requires >=llvm-core/clang-18 to build"
		eerror "Please upgrade Clang: emerge -v1 llvm-core/clang"
		die "Clang version is too old to compile Hyprland!"
	fi
}

src_prepare() {
	# skip version.h
	sed -i -e "s|scripts/generateVersion.sh|echo|g" "meson.build" || die
	default
}

src_configure() {
	cflags-hardened_append
	local emesonargs=(
		$(meson_feature legacy-renderer legacy_renderer)
		$(meson_feature systemd)
		$(meson_feature X xwayland)
	)
	meson_src_configure
}
