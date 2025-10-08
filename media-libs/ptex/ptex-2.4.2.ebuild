# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX98[@]}
)
CFLAGS_HARDENED_USE_CASES="untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="OOBW"

inherit check-compiler-switch cflags-hardened cmake libstdcxx-slot

DESCRIPTION="Per-Face Texture Mapping for Production Rendering"
HOMEPAGE="https://ptex.us/"
SRC_URI="https://github.com/wdas/ptex/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86"
IUSE="static-libs"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"
BDEPEND="app-text/doxygen"

RESTRICT="test"

pkg_setup() {
	check-compiler-switch_start
	libstdcxx-slot_verify
}

src_prepare() {
	# https://github.com/wdas/ptex/issues/41
	cat <<-EOF > version || die
	v${PV}
	EOF
	cmake_src_prepare
}

src_configure() {
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	cflags-hardened_append

	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}/html"
		-DPTEX_BUILD_STATIC_LIBS=$(usex static-libs)
	)
	cmake_src_configure
}
