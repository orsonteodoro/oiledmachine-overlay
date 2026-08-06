# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical login sensitive-data untrusted-data"
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
	"gui-libs/hyprutils-9999"
	"media-libs/mesa-9999"
	"x11-libs/cairo-9999"
	"x11-libs/libdrm-9999"
	"x11-libs/libxkbcommon-9999"
)

inherit cflags-hardened chkl cmake libcxx-slot libstdcxx-slot secure-version

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="b222d9b1f87e980cac379371df57913a53b99d7f"
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/hyprwm/hyprlock.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/hyprwm/hyprlock/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Hyprland's GPU-accelerated screen locking utility"
HOMEPAGE="
	https://github.com/hyprwm/hyprlock
"
LICENSE="
	BSD
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+=" "
RDEPEND+="
	>=dev-libs/wayland-${WAYLAND_PV}:=
	>=media-libs/mesa-${MESA_PV}:=
	>=sys-libs/pam-${PAM_PV}:=
	>=dev-cpp/sdbus-c++-2.0.0:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=dev-libs/hyprgraphics-0.1.6:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=dev-libs/hyprlang-${HYPRLANG_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=gui-libs/hyprutils-${HYPRUTILS_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=x11-libs/cairo-${CAIRO_PV}:=
	>=x11-libs/libdrm-${LIBDRM_PV}:=
	>=x11-libs/libxkbcommon-${LIBXKBCOMMON_PV}:=
	>=x11-libs/pango-${PANGO_PV}:=
"
DEPEND+="
	${RDEPEND}
	>=dev-libs/wayland-protocols-1.35
"
BDEPEND+="
	>=dev-build/cmake-3.27
	dev-util/hyprwayland-scanner[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	dev-util/wayland-scanner
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
	cflags-hardened_append
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

# OILEDMACHINE-OVERLAY-META:  INDEPENDENTLY-CREATED-EBUILD
