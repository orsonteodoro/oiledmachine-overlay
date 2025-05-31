# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="copy-paste-password security-critical sensitive-data secure-data"
LLVM_COMPAT=( 19 )

inherit cflags-hardened check-compiler-switch meson toolchain-funcs

DESCRIPTION="A dynamic tiling Wayland compositor that doesn't sacrifice on its looks"
HOMEPAGE="https://github.com/hyprwm/Hyprland"

if [[ "${PV}" == *"9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hyprwm/${PN^}.git"
else
	KEYWORDS="amd64"
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
ebuild_revision_11
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
	app-alternatives/ninja
	dev-build/meson
	dev-vcs/git
	virtual/pkgconfig
"
RDEPEND="
	${HYPRPM_RDEPEND}
	>=dev-libs/udis86-1.7.2
	>=dev-libs/wayland-1.22.90
	>=gui-libs/aquamarine-0.4.2
	>=gui-libs/hyprcursor-0.1.9
	dev-cpp/tomlplusplus
	dev-libs/glib:2
	dev-libs/hyprlang
	dev-libs/libinput:=
	dev-libs/hyprgraphics:=
	dev-libs/re2:=
	gui-libs/hyprutils:=
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
	>=dev-libs/hyprland-protocols-0.4
	>=dev-libs/wayland-protocols-1.36
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
	>=dev-util/hyprwayland-scanner-0.3.10
	app-misc/jq
	dev-build/cmake
	virtual/pkgconfig
	!clang? (
		>=sys-devel/gcc-15:15
	)
	clang? (
		(
			$(gen_clang_slot)
			llvm-core/clang:=
		)
		>=sys-devel/gcc-15:15
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
		CC=$(tc-getCC)
		CXX=$(tc-getCXX)
		CPP="${CC} -E"
		if ver_test $(gcc-major-version) -ne "15" ; then
eerror "Switch to GCC 15"
			die
		fi
	fi
	strip-unsupported-flags

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
		$(meson_feature legacy-renderer legacy_renderer)
		$(meson_feature systemd)
		$(meson_feature X xwayland)
	)
	meson_src_configure
}
