# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

API_VERSION="1.0" # See https://gitlab.freedesktop.org/cairo/cairomm/-/blob/1.14.5/meson.build#L13
CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CXX_STANDARD=11
PYTHON_COMPAT=( python3_{10..14} )

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX11[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX11[@]/llvm_slot_}"
)

CHKL_TIMESTAMPS=(
	"media-libs/fontconfig-9999"
	"x11-libs/cairo-9999"
)

inherit cflags-hardened chkl libcxx-slot libstdcxx-slot meson-multilib secure-version python-any-r1

DESCRIPTION="C++ bindings for the Cairo vector graphics library"
HOMEPAGE="https://cairographics.org/cairomm/ https://gitlab.freedesktop.org/cairo/cairomm"
SRC_URI="https://www.cairographics.org/releases/${P}.tar.xz"

LICENSE="LGPL-2+"
SLOT="${API_VERSION}" # The distro messed up.
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~sparc x86"
IUSE="gtk-doc test X"
RESTRICT="
	mirror
	!test? (
		test
	)
" # Speed up and stop snooping

RDEPEND="
	>=dev-libs/libsigc++-2.6.0:2=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP},gtk-doc?]
	>=x11-libs/cairo-${CAIRO_PV}:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP},X=]
"
DEPEND="${RDEPEND}
	test? (
		>=dev-libs/boost-1.33.1:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP}]
		>=media-libs/fontconfig-${FONTCONFIG_PV}:=[${MULTILIB_USEDEP}]
	)
"
BDEPEND="
	virtual/pkgconfig
	gtk-doc? (
		${PYTHON_DEPS}
		>=dev-cpp/mm-common-1.0.4
		app-text/doxygen[dot]
		dev-libs/libxslt
	)
"

pkg_setup() {
	use gtk-doc && python-any-r1_pkg_setup
	libcxx-slot_verify
	libstdcxx-slot_verify
}

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	local emesonargs=(
		$(meson_native_use_bool gtk-doc build-documentation)
		-Dbuild-examples=false
		$(meson_use test build-tests)
		-Dboost-shared=true
	)
	meson_src_configure
}
