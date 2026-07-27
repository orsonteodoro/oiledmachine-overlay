# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${P/_}"
MY_P="${MY_P/_p/.}"

CFLAGS_HARDENED_USE_CASES="security-critical untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE SO"

CHKL_TIMESTAMPS=(
	"media-libs/libogg-9999"
)

inherit autotools cflags-hardened chkl flag-o-matic multilib-minimal secure-version

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="a1b872e6704cc5825750098ce0e0c0b4aacaef4d"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://gitlab.xiph.org/xiph/speex.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	KEYWORDS="
~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv sparc x86
~amd64-linux ~x86-linux ~ppc-macos ~x64-macos
	"
	SRC_URI="https://downloads.xiph.org/releases/speex/${MY_P}.tar.gz"
fi

CPU_FLAGS_ARM=(
	"cpu_flags_arm_v4"
	"cpu_flags_arm_v5"
	"cpu_flags_arm_v6"
)

CPU_FLAGS_X86=(
	"cpu_flags_x86_sse"
)

S="${WORKDIR}/${MY_P}"

DESCRIPTION="Audio compression format designed for speech"
HOMEPAGE="https://www.speex.org/"
LICENSE="BSD"
SLOT="0"
IUSE="
${CPU_FLAGS_ARM[@]}
${CPU_FLAGS_X86[@]}
utils valgrind +vbr
ebuild_revision_24
"
RDEPEND="
	utils? (
		>=media-libs/libogg-${LIBOGG_PV}:=
		>=media-libs/speexdsp-${SPEEXDSP_PV}:=[${MULTILIB_USEDEP}]
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
)

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
}

src_prepare() {
	default
	sed -i \
		-e 's:noinst_PROGRAMS:check_PROGRAMS:' \
		"libspeex/Makefile.am" \
		|| die
	eautoreconf
}

multilib_src_configure() {
	chkl_check_many_timestamps
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
