# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GCC_COMPAT=(
	"gcc_slot_14_3" # CY2026 is GCC 14.2; CUDA-12.9, CUDA-12.8
	"gcc_slot_13_4" # CUDA-12.6, CUDA-12.5, CUDA-12.4, CUDA-12.3
	"gcc_slot_11_5" # CY2025 is GCC 11.2.1, CUDA-11.8
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
