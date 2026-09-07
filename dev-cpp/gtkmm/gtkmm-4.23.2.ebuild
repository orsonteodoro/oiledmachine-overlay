# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

API_VERSION="4.0"
CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CXX_STANDARD=17
PYTHON_COMPAT=( python3_{10..14} )

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

CHKL_TIMESTAMPS=(
	"gui-libs/gtk-4.23.9999"
)

inherit cflags-hardened gnome.org libcxx-slot libstdcxx-slot meson secure-version python-any-r1 virtualx

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

DESCRIPTION="C++ interface for GTK+"
HOMEPAGE="https://gtkmm.gnome.org/en/index.html"
LICENSE="LGPL-2.1+"
RESTRICT="
	!test? (
		test
	)
	mirror
" # Speed up downloads and stop snooping
SLOT="${API_VERSION}"
IUSE="gtk-doc test vulkan"
RDEPEND="
	>=dev-cpp/glibmm-2.75.0:2.68=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},gtk-doc?]
	>=dev-cpp/cairomm-1.15.4:1.16=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},gtk-doc?]
	>=dev-cpp/pangomm-2.50.0:2.48=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},gtk-doc?]
	>=gui-libs/gtk-${GTK4_PV}:4=[vulkan?]
	>=media-libs/libepoxy-1.2:=
	>=x11-libs/gdk-pixbuf-${GDK_PIXBUF_PV}:=
	vulkan? (
		>=media-libs/vulkan-loader-${VULKAN_PV}:=
	)
"
DEPEND="
	${RDEPEND}
	gtk-doc? (
		>=dev-libs/libsigc++-3:3=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	)
"
BDEPEND="
	virtual/pkgconfig
	gtk-doc? (
		app-text/doxygen[dot]
		>=dev-lang/perl-${PERL_PV}
		>=dev-libs/libxslt-${LIBXSLT_PV}
	)
	${PYTHON_DEPS}
"
PATCHES=(
	"${FILESDIR}"/MR-101.patch
)

pkg_setup() {
	python-any-r1_pkg_setup
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
	local actual_subslot=$(grep -E -e "gtkmm_api_version" "${S}/meson.build" | head -n 1 | cut -f 2 -d "'")
	local expected_subslot="${API_VERSION}"
	if ver_test "${actual_subslot}" "-ne" "${expected_subslot}" ; then
eerror "QA:  Update API_VERSION"
eerror "Actual subslot:  ${actual_subslot}"
eerror "Expected subslot:  ${expected_subslot}"
		die
	fi
}

src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	local emesonargs=(
		-Dbuild-demos=false
		$(meson_use gtk-doc build-documentation)
		$(meson_use test build-tests)
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}
