# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CXX_STANDARD=26

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX26[@]}"
)
LIBSTDCXX_USEDEP_LTS="gcc_slot_skip(+)"

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX26[@]/llvm_slot_}"
)

CHKL_TIMESTAMPS=(
	"gnome-base/librsvg-9999"
	"media-libs/libheif-9999"
	"media-libs/libjpeg-turbo-9999"
	"media-libs/libjxl-9999"
	"media-libs/libspng-9999"
	"media-libs/libwebp-9999"
	"sys-apps/file-9999"
	"x11-libs/cairo-9999"
	"x11-libs/libdrm-9999"
	"x11-libs/pixman-9999"
	"x11-libs/pango-9999"
)

inherit chkl cflags-hardened cmake libcxx-slot libstdcxx-slot secure-version

if [[ "${PV}" =~ "9999" ]]; then
	FALLBACK_COMMIT="c6e7b9f673f4360bc813d3dc75028f75ee88d3f8"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/hyprwm/hyprgraphics.git"
	if [[ "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="https://github.com/hyprwm/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Hyprland graphics / resource utilities"
HOMEPAGE="https://github.com/hyprwm/hyprgraphics"

LICENSE="BSD"
SOVER="4"
SLOT="0/${SOVER}"
IUSE+="
ebuild_revision_2
"
RDEPEND="
	>=gnome-base/librsvg-${LIBRSVG_PV}:=
	>=gui-libs/hyprutils-0.1.1:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	>=x11-libs/libdrm-${LIBDRM_PV}:=
	>=x11-libs/pango-${PANGO_PV}:=
	>=media-libs/libglvnd-1.7.0:=
	>=media-libs/libheif-${LIBHEIF_PV}:=[${LIBSTDCXX_USEDEP_LTS}]
	>=media-libs/libjpeg-turbo-${LIBJPEG_TURBO_PV}:=
	>=media-libs/libjxl-${LIBJXL_PV}:=[${LIBSTDCXX_USEDEP_LTS}]
	>=media-libs/libspng-${LIBSPNG_PV}:=
	>=media-libs/libwebp-${LIBWEBP_PV}:=
	>=sys-apps/file-${FILE_PV}:=
	>=x11-libs/cairo-${CAIRO_PV}:=
	>=x11-libs/pixman-${PIXMAN_PV}:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/cmake-4.3.1
	virtual/pkgconfig
"

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]]; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
	local actual_sover=$(grep -E -e "SOVERSION [0-9]+" "${S}/CMakeLists.txt" | grep -E -o -e "[0-9]+")
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Update SOVER in ebuild"
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
		die
	fi
}

src_configure() {
	cflags-hardened_append
	chkl_check_many_timestamps
	cmake_src_configure
}
