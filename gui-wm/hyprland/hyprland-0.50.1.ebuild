# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

GCC_SLOT="15"
CFLAGS_HARDENED_USE_CASES="copy-paste-password security-critical sensitive-data secure-data"
LLVM_COMPAT=( 20 )

inherit cflags-hardened check-compiler-switch meson toolchain-funcs

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
${LLVM_COMPAT[@]/#/llvm_slot_}
clang legacy-renderer +qtutils systemd X
ebuild_revision_13
"
REQUIRED_USE="
	clang? (
		^^ (
			${LLVM_COMPAT[@]/#/llvm_slot_}
		)
	)
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
	>=dev-cpp/tomlplusplus-3.4.0
	>=dev-libs/hyprlang-0.3.2
	>=dev-libs/hyprgraphics-0.1.3:=
	>=dev-libs/libinput-1.28.1:=
	dev-libs/re2:=
	>=dev-libs/udis86-1.7.2
	>=dev-libs/wayland-1.22.90
	>=gui-libs/aquamarine-0.9.0:=
	>=gui-libs/hyprcursor-0.1.7
	>=gui-libs/hyprutils-0.8.1:=
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
gen_clang_slot() {
	for x in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${x}? (
				llvm-core/clang:${x}
			)
		"
	done
}
BDEPEND="
	>=app-misc/jq-1.8.1
	>=dev-util/hyprwayland-scanner-0.3.10
	>=dev-build/cmake-4.0.3
	virtual/pkgconfig
	!clang? (
		>=sys-devel/gcc-15.1.1:15
	)
	clang? (
		(
			$(gen_clang_slot)
			llvm-core/clang:=
		)
		>=sys-devel/gcc-15.1.1:15
	)
"

pkg_setup() {
	check-compiler-switch_start
	[[ "${MERGE_TYPE}" == "binary" ]] && return

	if use clang ; then
		local x
		for x in ${LLVM_COMPAT[@]} ; do
			if use "llvm_slot_${x}" ; then
				LLVM_SLOT="${x}"
				break
			fi
		done
		local path
		path="/usr/lib/llvm/${LLVM_SLOT}/bin"
einfo "PATH:  ${PATH} (before)"
		PATH=$(echo "${PATH}" \
			| tr ":" "\n" \
			| sed -e "\|/usr/lib/llvm|d" \
			| sed -e "s|/opt/bin|/opt/bin\n${path}|g" \
			| tr "\n" ":")
einfo "PATH:  ${PATH} (after)"
		export CC="${CHOST}-clang-${LLVM_SLOT}"
		export CXX="${CHOST}-clang++-${LLVM_SLOT}"
		export CPP="${CC} -E"
	else
		CC="${CHOST}-gcc-${GCC_SLOT}"
		CXX="${CHOST}-g++-${GCC_SLOT}"
		CPP="${CC} -E"
		if ver_test $(gcc-major-version) -ne "${GCC_SLOT}" ; then
eerror "Switch to GCC ${GCC_SLOT}"
			die
		fi
	fi
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
