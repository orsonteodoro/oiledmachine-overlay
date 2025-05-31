# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE SO"

inherit autotools cflags-hardened flag-o-matic multilib-minimal

MY_P="${P/_}"
MY_P="${MY_P/_p/.}"

CPU_FLAGS_ARM=(
	"cpu_flags_arm_v4"
	"cpu_flags_arm_v5"
	"cpu_flags_arm_v6"
)
CPU_FLAGS_X86=(
	"cpu_flags_x86_sse"
)

KEYWORDS="
~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv sparc x86
~amd64-linux ~x86-linux ~ppc-macos ~x64-macos
"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Audio compression format designed for speech"
HOMEPAGE="https://www.speex.org/"
SRC_URI="https://downloads.xiph.org/releases/speex/${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="0"
IUSE="
${CPU_FLAGS_ARM[@]}
${CPU_FLAGS_X86[@]}
utils valgrind +vbr
ebuild_revision_14
"
RDEPEND="
	utils? (
		media-libs/libogg:=
		media-libs/speexdsp[${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
	valgrind? (
		dev-debug/valgrind
	)
"
BDEPEND="
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}/${PN}-1.2.0-configure.patch"
	"${FILESDIR}/${PN}-1.2.1-vla-detection.patch"
	"${FILESDIR}/${PN}-1.2.1-slibtoolize.patch"
	"${FILESDIR}/${PN}-1.2.1-valgrind.patch"
)

src_prepare() {
	default
	sed -i \
		-e 's:noinst_PROGRAMS:check_PROGRAMS:' \
		"libspeex/Makefile.am" \
		|| die
	eautoreconf
}

multilib_src_configure() {
	append-lfs-flags
	cflags-hardened_append

	local myeconfargs=(
		$(multilib_native_use_enable valgrind)
		$(multilib_native_use_enable utils binaries)
		$(multilib_native_use_with utils speexdsp)
		$(use_enable cpu_flags_x86_sse sse)
		$(use_enable vbr)
	)

	local ARM4_ARG="--disable-arm4-asm"
	local ARM5_ARG="--disable-arm5e-asm"
	local FIXED_ARG="--disable-fixed-point"

	if use arm && ! use cpu_flags_arm_v6; then
		FIXED_ARG="--enable-fixed-point"
		if use cpu_flags_arm_v5; then
			ARM5_ARG="--enable-arm5e-asm"
		elif use cpu_flags_arm_v4; then
			ARM4_ARG="--enable-arm4-asm"
		fi
	fi

	myeconfargs+=(
		${ARM4_ARG}
		${ARM5_ARG}
		${FIXED_ARG}
	)

	ECONF_SOURCE="${S}" \
	econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -type f -delete || die
}
