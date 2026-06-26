# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data system-set untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO"

CHKL_TIMESTAMPS=(
	"app-arch/xz-utils-9999"
	"app-arch/lz4-9999"
)

inherit cflags-hardened check-compiler-switch chkl flag-o-matic meson-multilib secure-version

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="5233c58e6ca0b1c4c6b353ad79649191ed195bdc"
	EGIT_BRANCH="dev"
	EGIT_REPO_URI="https://github.com/facebook/zstd.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	S="${WORKDIR}/${P}/build/meson"
	SRC_URI="
https://github.com/facebook/zstd/releases/download/v${PV}/${P}.tar.gz
	"
fi

KEYWORDS="
~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86
~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris
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
IUSE+="
+lzma lz4 static-libs test zlib
ebuild_revision_42
"
RESTRICT="
	!test? (
		test
	)
"
RDEPEND="
	lzma? (
		>=app-arch/xz-utils-${XZ_UTILS_PV}
	)
	lz4? (
		>=app-arch/lz4-${LZ4_PV}:=
	)
	zlib? (
		>=virtual/zlib-${ZLIB_PV}:=
	)
"
DEPEND="
	${RDEPEND}
"

MESON_PATCHES=(
)

PATCHES=(
)

pkg_setup() {
	check-compiler-switch_start
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
		export S="${WORKDIR}/${P}/build/meson"
	else
		unpack ${A}
	fi
}

src_prepare() {
	cd "${WORKDIR}/${P}" || die
	default
	cd "${S}" || die
	if (( ${#MESON_PATCHES[@]} > 0 )) ; then
		eapply "${MESON_PATCHES[@]}"
	fi
}

multilib_src_configure() {
	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	chkl_check_many_timestamps
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

# OILEDMACHINE-OVERLAY-TEST:  PASSED 5233c58 (interactive)
# Double emerge:  passed
# Zstd compress/decompress with sha512sum comparison:  passed
