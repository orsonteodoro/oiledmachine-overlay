# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=23

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX23[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX23[@]/llvm_slot_}"
)

CHKL_TIMESTAMPS=(
	"dev-libs/glib-2.89.9999"
	"dev-libs/hyprlang-9999"
	"gui-libs/hyprtoolkit-9999"
	"media-libs/mesa-9999"
	"x11-libs/cairo-9999"
	"x11-libs/libdrm-9999"
	"x11-libs/libxkbcommon-9999"
	"x11-libs/pixman-9999"
)

inherit chkl cmake libcxx-slot libstdcxx-slot secure-version

if [[ "${PV}" =~ "9999" ]]; then
	FALLBACK_COMMIT="a16ad89ed5fb4192c966018a80c652de8d96f748"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/hyprwm/hyprland-guiutils.git"
	SUBSLOT="0.2"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SUBSLOT=$(ver_cut "1-2" "${PV}")
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/hyprwm/hyprland-guiutils/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Hyprland GUI utilities, successor to hyprland-qtutils"
HOMEPAGE="https://github.com/hyprwm/hyprland-guiutils"
LICENSE="BSD"
SLOT="0/${SUBSLOT}"
RDEPEND="
	!gui-libs/hyprland-qtutils
	>=gui-libs/hyprtoolkit-${HYPRTOOLKIT_PV}:=
	>=gui-libs/hyprutils-0.2.4:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=dev-libs/glib-${GLIB_PV}:=
	>=dev-libs/hyprlang-${HYPRLANG_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=media-libs/mesa-${MESA_PV}:=[opengl]
	>=x11-libs/cairo-${CAIRO_PV}:=
	>=x11-libs/libdrm-${LIBDRM_PV}:=
	>=x11-libs/libxkbcommon-${LIBXKBCOMMON_PV}:=
	>=x11-libs/pango-${PANGO_PV}:=
	>=x11-libs/pixman-${PIXMAN_PV}:=
	dev-libs/hyprgraphics:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	gui-libs/aquamarine:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-build/cmake
	virtual/pkgconfig
"

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
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
	local actual_subslot=$(cat "${S}/VERSION" | cut -f 1-2 -d ".")
	local expected_subslot="${SUBSLOT}"
	if ver_test "${actual_subslot}" "-ne" "${expected_subslot}" ; then
eerror "QA:  Update SUBSLOT in ebuild"
eerror "Actual SUBSLOT:  ${actual_subslot}"
eerror "Expected SUBSLOT:  ${expected_subslot}"
		die
	fi
}

src_configure() {
	chkl_check_many_timestamps
	cmake_src_configure
}
