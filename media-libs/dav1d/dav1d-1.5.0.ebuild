# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="IO"
NASM_PV="2.15.05"

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://code.videolan.org/videolan/dav1d"
	inherit git-r3
else
	KEYWORDS="
~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86
~arm64-macos ~x64-macos
	"
	SRC_URI="https://downloads.videolan.org/pub/videolan/dav1d/${PV}/${P}.tar.xz"
fi

inherit cflags-hardened meson-multilib

DESCRIPTION="dav1d is an AV1 Decoder :)"
HOMEPAGE="https://code.videolan.org/videolan/dav1d"
LICENSE="BSD-2"
# Check SONAME on version bumps!
SLOT="0/7"
IUSE="
+8bit +10bit +asm test xxhash
ebuild_revision_12
"
RESTRICT="
	!test? (
		test
	)
"
DEPEND="
	xxhash? (
		dev-libs/xxhash
	)
"
BDEPEND="
	asm? (
		abi_x86_32? (
			>=dev-lang/nasm-${NASM_PV}
		)
		abi_x86_64? (
			>=dev-lang/nasm-${NASM_PV}
		)
	)
"
DOCS=( "README.md" "doc/PATENTS" "THANKS.md" )

multilib_src_configure() {
	cflags-hardened_append
	local -a bits=()
	use 8bit  && bits+=( 8 )
	use 10bit && bits+=( 16 )

	local enable_asm
	if [[ "${MULTILIB_ABI_FLAG}" == "abi_x86_x32" ]]; then
		enable_asm=false
	else
		enable_asm=$(usex asm true false)
	fi

	local emesonargs=(
		$(meson_feature xxhash xxhash_muxer)
		$(meson_use test enable_tests)
		-Dbitdepths=$(IFS="," ; echo "${bits[*]}")
		-Denable_asm=${enable_asm}
	)
	meson_src_configure
}

multilib_src_test() {
	if multilib_is_native_abi ; then
		meson_src_test
	fi
}
