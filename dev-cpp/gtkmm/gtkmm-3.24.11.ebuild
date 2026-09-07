# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

API_VERSION="3.0"
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
	"x11-libs/gtk+-3.24.9999"
)

inherit cflags-hardened gnome.org libcxx-slot libstdcxx-slot meson-multilib python-any-r1 secure-version virtualx

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~sparc x86"

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
IUSE="aqua gtk-doc test wayland X"
REQUIRED_USE="|| ( aqua wayland X )"
RDEPEND="
	>=dev-cpp/atkmm-2.24.2:1.6=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP},gtk-doc?]
	>=dev-cpp/cairomm-1.12.0:1.0=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP},gtk-doc?]
	>=dev-cpp/glibmm-2.54.0:2.4=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP},gtk-doc?]
	>=dev-cpp/pangomm-2.38.1:1.4=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP},gtk-doc?]
	>=dev-libs/libsigc++-2.3.2:2=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP},gtk-doc?]
	>=media-libs/libepoxy-1.2:=[${MULTILIB_USEDEP}]
	>=x11-libs/gdk-pixbuf-${GDK_PIXBUF_PV}:=[${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-${GTK3_PV}:3=[${MULTILIB_USEDEP},aqua?,wayland?,X=]
"
DEPEND="
	${RDEPEND}
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

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	local emesonargs=(
		-Dbuild-atkmm-api=true
		-Dbuild-demos=false
		$(meson_native_use_bool gtk-doc build-documentation)
		$(meson_use test build-tests)
		$(meson_use X build-x11-api)
	)
	meson_src_configure
}

multilib_src_test() {
	virtx meson_src_test
}

multilib_src_install_all() {
	einstalldocs

	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/html/ || die
		mv "${ED}"/usr/share/doc/${PN}-${SLOT} "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}
