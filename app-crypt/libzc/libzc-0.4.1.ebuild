# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FLAG_O_MATIC_STRIP_UNSUPPORTED_FLAGS=1
UOPTS_SUPPORT_EBOLT=0
UOPTS_SUPPORT_EPGO=0
UOPTS_SUPPORT_TBOLT=1
UOPTS_SUPPORT_TPGO=1
TRAINERS=(
	"libzc_trainers_all"
	"libzc_trainers_bruteforce"
)

inherit autotools check-compiler-switch flag-o-matic toolchain-funcs uopts

KEYWORDS="
~amd64
"
SRC_URI="
https://github.com/mferland/libzc/archive/v${PV}.tar.gz -> ${P}.tar.gz
"

DESCRIPTION="Tool and library for cracking legacy zip files."
HOMEPAGE="https://github.com/mferland/libzc"
LICENSE="GPL-3+"
RESTRICT="
	!test? (
		test
	)
"
SLOT="0"
IUSE="
${TRAINERS[@]}
test
ebuild_revision_3
"
REQUIRED_USE="
	bolt? (
		|| (
			libzc_trainers_all
			libzc_trainers_bruteforce
		)
	)
	pgo? (
		|| (
			libzc_trainers_all
			libzc_trainers_bruteforce
		)
	)
"
RDEPEND="
	sys-libs/zlib
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	sys-devel/gcc
	dev-build/make
	bolt? (
		llvm-core/clang
	)
	pgo? (
		llvm-core/clang
	)
"

pkg_setup() {
	check-compiler-switch_start
	uopts_setup
}


src_prepare() {
	default
	uopts_src_prepare
}

src_configure() { :; }

_src_configure_compiler() {
	if use pgo || use bolt ; then
		# Force use of the performant one.
		export CC="${CHOST}-clang"
		export CXX="${CHOST}-clang++"
		export CPP="${CC} -E"
		strip-unsupported-flags
	else
		export CC=$(tc-getCC)
		export CXX=$(tc-getCXX)
		export CPP=$(tc-getCPP)
	fi
}

_src_configure() {
	uopts_src_configure
	tc-is-gcc && replace-flags '-O*' '-O1' # >= -O2 breaks with instrumented PGO by gcc.
	tc-is-clang && replace-flags '-O*' '-O3'
	strip-unsupported-flags

	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	local len=${ZC_PW_MAXLEN:-16}
	einfo "ZC_PW_MAXLEN:  ${len}"
	sed -i -e "s|ZC_PW_MAXLEN 16|ZC_PW_MAXLEN ${len}|g" lib/libzc.h || die
	eautoreconf
	./configure \
		--libdir="${EPREFIX}/usr/$(get_libdir)"
}

_src_compile() {
	emake V=1
}

train_meets_requirements() {
	return 0
}

train_trainer_custom() {
	if use libzc_trainers_all ; then
		emake -C tests check
	elif use libzc_trainers_bruteforce ; then
		emake -C tests bruteforce
		pushd tests || die
			./bruteforce || true
		popd || die
	fi
}

src_compile() {
	BUILD_DIR="${S}"
	uopts_src_compile
}

src_test() {
	emake -C tests check
}

src_install() {
	BUILD_DIR="${S}"
	emake DESTDIR="${D}" install
	if [[ -e "${ED}/usr/share/doc/yazc" ]] ; then
		mv \
			"${ED}/usr/share/doc/yazc" \
			"${ED}/usr/share/doc/${P}" \
			|| die
	fi
	uopts_src_install
}

pkg_postinst() {
	uopts_pkg_postinst
ewarn
ewarn "The brute force time cost is possibly quadratic."
ewarn
ewarn "For a 4 core machine, the following may be true to scan the entire"
ewarn "key space:"
ewarn
ewarn "If password length is 6, it will take 4 hours to solve."
ewarn "If password length is 10, it will take ~2 days to solve."
ewarn "If password length is 15, it will take ~15 days to solve."
ewarn "If password length is 20, it will take ~20 days to solve."
ewarn "If password length is 50, it will take ~157 days to solve."
ewarn

ewarn
ewarn "This package is still good for smaller passwords or smaller key search"
ewarn "spaces but only uses CPU and may not have resume, but for longer"
ewarn "passwords, consider GPU methods instead."
ewarn
}

# OILEDMACHINE-OVERLAY-TEST:  passed (0.4.1, 20240215)
#============================================================================
#Testsuite summary for zc 0.4.1
#============================================================================
# TOTAL: 8
# PASS:  8
# SKIP:  0
# XFAIL: 0
# FAIL:  0
# XPASS: 0
# ERROR: 0
#============================================================================
