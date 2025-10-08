# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

GCC_COMPAT=(
	# It requires std::unreachable() from either GCC >=13 or Clang >=15.
	# It may be possible to build Clang 15 with GCC 11 then build hyprland with Clang 15.
	"gcc_slot_11_5" # Support -std=c++23 without breaking systemwide CUDA 11.x, CUDA 12.x
	"gcc_slot_12_5" # Support -std=c++23 without breaking systemwide CUDA >=12.3, ROCm >=6.2
	"gcc_slot_13_4" # Support -std=c++23 without breaking systemwide CUDA >=12.4, ROCm >=6.4
	"gcc_slot_14_3" # Support -std=c++23 without breaking systemwide CUDA >=12.8
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
legacy-renderer systemd X
ebuild_revision_13
"
REQUIRED_USE="
"
# hyprpm (hyprland plugin manager) requires the dependencies at runtime
# so that it can clone, compile and install plugins.
HYPRPM_RDEPEND="
	>=dev-build/cmake-3.22.1
	>=dev-build/meson-0.61.2
	>=dev-vcs/git-2.34.1
	app-alternatives/ninja
	virtual/pkgconfig
"
# glib missing in build files
# pixman missing in build files
# tomlplusplus missing in U22 repo
# util-linux missing in build files
RDEPEND="
	${HYPRPM_RDEPEND}
	>=dev-cpp/tomlplusplus-3.4.0[${LIBSTDCXX_USEDEP}]
	dev-cpp/tomlplusplus:=
	>=dev-libs/hyprlang-0.3.2[${LIBSTDCXX_USEDEP}]
	dev-libs/hyprlang:=
	>=dev-libs/libinput-1.20.0:=
	>=dev-libs/udis86-1.7.2
	>=dev-libs/wayland-1.20.0
	>=gui-libs/hyprcursor-0.1.6[${LIBSTDCXX_USEDEP}]
	gui-libs/hyprcursor:=
	>=gui-libs/wlroots-hyprland-0.18.0_p20240424
	>=media-libs/libglvnd-1.4.0
	>=media-libs/mesa-22.0.1
	>=x11-libs/cairo-1.16.0
	>=x11-libs/libdrm-2.4.110
	>=x11-libs/libxkbcommon-1.4.0
	>=x11-libs/pango-1.50.6
	>=x11-libs/pixman-0.40.0
	>=dev-libs/glib-2.72.1:2
	>=sys-apps/util-linux-2.37.2
	>=sys-apps/pciutils-3.7.0
	X? (
		>=x11-libs/libxcb-1.14:0=
		>=x11-libs/xcb-util-wm-0.4.1
		>=x11-base/xwayland-22.1.1
	)
"
DEPEND="
	${RDEPEND}
	>=dev-libs/hyprland-protocols-0.3.0
	>=dev-libs/wayland-protocols-1.25
"
BDEPEND="
	>=app-misc/jq-1.6
	>=dev-build/cmake-3.22.1
	>=dev-util/wayland-scanner-1.20.0
	virtual/pkgconfig
	|| (
		>=sys-devel/gcc-11
		>=llvm-core/clang-13
	)
"
PATCHES=(
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

	libstdcxx-slot_verify
	local gcc_slot=$(gcc-config -c | cut -f 5 -d "-")
	if (( ${gcc_slot} == 11 || ${gcc_slot} == 12 )) ; then
ewarn "${PN} requires Clang >= 15.  You need to set CC=clang-15 and CXX=clang++-15 or higher"
		tc-check-min_ver "clang" "15"
	else
		tc-check-min_ver "gcc" "13"
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
		#$(meson_feature legacy-renderer legacy_renderer)
		$(meson_feature systemd)
		$(meson_feature X xwayland)
	)
	meson_src_configure
}

# OILEDMACHINE-OVERLAY-TEST:  0.51.1 PASSED (20250815)

# Tested use flags:
# USE="-X -clang -legacy-renderer -qtutils -systemd"
