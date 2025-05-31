# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_CF_PROTECTION=0         # -cf-protection is untested or unverified
CFLAGS_HARDENED_FHARDENED=0             # -fhardened is untested or unverified
CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data system-set untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO"

inherit cflags-hardened meson-multilib

KEYWORDS="
~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86
~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris
"
S="${WORKDIR}/${P}/build/meson"
SRC_URI="
https://github.com/facebook/zstd/releases/download/v${PV}/${P}.tar.gz
"

DESCRIPTION="zstd fast compression library"
HOMEPAGE="https://facebook.github.io/zstd/"
LICENSE="
	|| (
		BSD
		GPL-2
	)
"
SLOT="0/1"
IUSE="
+lzma lz4 static-libs test zlib
ebuild_revision_26
"
RESTRICT="
	!test? (
		test
	)
"
RDEPEND="
	lzma? (
		app-arch/xz-utils
	)
	lz4? (
		app-arch/lz4:=
	)
	zlib? (
		sys-libs/zlib
	)
"
DEPEND="
	${RDEPEND}
"

MESON_PATCHES=(
	# Workaround until Valgrind bugfix lands
	"${FILESDIR}/${PN}-1.5.4-no-find-valgrind.patch"
)

PATCHES=(
	"${FILESDIR}/${PN}-1.5.7-move-pragma-before-static.patch"
)

src_prepare() {
	cd "${WORKDIR}/${P}" || die
	default
	cd "${S}" || die
	eapply "${MESON_PATCHES[@]}"
}

multilib_src_configure() {
	cflags-hardened_append
	local native_file="${T}/meson.${CHOST}.${ABI}.ini.local"
	# This replaces the no-find-valgrind patch once bugfix lands in a meson
	# release + we can BDEPEND on it (https://github.com/mesonbuild/meson/pull/11372)
cat >> "${native_file}" <<-EOF || die
[binaries]
valgrind='valgrind-falseified'
EOF
	local emesonargs=(
		$(meson_native_true bin_programs)
		$(meson_native_true bin_contrib)
		$(meson_use test bin_tests)
		$(meson_native_use_feature zlib)
		$(meson_native_use_feature lzma)
		$(meson_native_use_feature lz4)
		-Ddefault_library=$(multilib_native_usex static-libs both shared)
		--native-file "${native_file}"
	)
	meson_src_configure
}

multilib_src_test() {
	meson_src_test --timeout-multiplier=2
}
