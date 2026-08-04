# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=23

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX23[@]}"
)
LIBSTDCXX_USEDEP_LTS="gcc_slot_skip(+)" # Skip placeholder

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX23[@]/llvm_slot_}"
)
LIBCXX_USEDEP_LTS="llvm_slot_skip(+)" # Skip placeholder

CHKL_TIMESTAMPS=(
	"dev-libs/hyprlang-9999"
	"dev-libs/wayland-9999"
	"gui-libs/hyprtoolkit-9999"
	"gui-libs/hyprutils-9999"
	"x11-libs/cairo-9999"
	"x11-libs/libdrm-9999"
	"x11-libs/libxkbcommon-9999"
	"x11-libs/pixman-9999"
)

inherit chkl cmake libcxx-slot libstdcxx-slot secure-version

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="b6daa91510d3f6cfa02edc28fd4966414224a485"
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/hyprwm/hyprlauncher.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/hyprwm/hyprlauncher/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A multipurpose and versatile launcher / picker for Hyprland"
HOMEPAGE="
	https://github.com/hyprwm/hyprlauncher
"
LICENSE="
	BSD
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+=" "
RDEPEND+="
	>=dev-libs/hyprlang-${HYPRLANG_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=dev-libs/wayland-${WAYLAND_PV}:=
	>=gui-libs/hyprtoolkit-${HYPRTOOLKIT_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=gui-libs/hyprutils-${HYPRUTILS_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=sci-libs/libqalculate-${LIBQALCULATE_PV}:=[${LIBCXX_USEDEP_LTS},${LIBSTDCXX_USEDEP_LTS}]
	>=x11-libs/cairo-${CAIRO_PV}:=
	>=x11-libs/libdrm-${LIBDRM_PV}:=
	>=x11-libs/libxkbcommon-${LIBXKBCOMMON_PV}:=
	>=x11-libs/pixman-${PIXMAN_PV}:=
	gui-libs/aquamarine:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	gui-libs/hyprwire:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	dev-libs/hyprgraphics:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
"
DEPEND+="
	${RDEPEND}
	dev-libs/wayland-protocols:=
"
BDEPEND+="
	dev-build/cmake
	dev-util/wayland-scanner:=
	dev-util/hyprwayland-scanner:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	virtual/pkgconfig
"
DOCS=( "README.md" )

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
}

src_configure() {
	chkl_check_many_timestamps
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  INDEPEDENDENTLY-CREATED-EBUILD
