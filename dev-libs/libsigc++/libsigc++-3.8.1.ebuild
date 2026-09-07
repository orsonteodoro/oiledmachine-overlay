# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=17

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

inherit flag-o-matic gnome.org libcxx-slot libstdcxx-slot secure-version meson-multilib

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
SRC_URI="https://github.com/libsigcplusplus/libsigcplusplus/releases/download/${PV}/${P}.tar.xz"

DESCRIPTION="Typesafe callback system for standard C++"
HOMEPAGE="
	https://libsigcplusplus.github.io/libsigcplusplus/
	https://github.com/libsigcplusplus/libsigcplusplus
"
LICENSE="LGPL-2.1+"
SLOT=$(ver_cut "1" "${PV}")
IUSE="gtk-doc test"
RESTRICT="
	mirror
	!test? (
		test
	)
" # Speed up downloads and stop snooping

BDEPEND="
	gtk-doc? (
		app-text/doxygen[dot]
		>=dev-lang/perl-${PERL_PV}
		>=dev-libs/libxslt-${LIBXSLT_PV}
	)
"

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

multilib_src_configure() {
	filter-flags -fno-exceptions #84263

	local emesonargs=(
		-Dbuild-examples=false
		$(meson_native_use_bool gtk-doc build-documentation)
		$(meson_use test build-tests)
	)
	meson_src_configure
}

multilib_src_install_all() {
	# Note: html docs are installed into /usr/share/doc/libsigc++-3.0
	# We can't use /usr/share/doc/${PF} because of links from glibmm etc. docs
	:;
}
