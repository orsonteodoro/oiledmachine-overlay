# Copyright 2024 Orson Teodoro
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

UOPTS_SUPPORT_EPGO=0
UOPTS_SUPPORT_EBOLT=0
inherit autotools flag-o-matic toolchain-funcs uopts

SRC_URI="
https://github.com/mferland/libzc/archive/v${PV}.tar.gz -> ${P}.tar.gz
"

DESCRIPTION="Tool and library for cracking legacy zip files."
HOMEPAGE="https://github.com/mferland/libzc"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="
~amd64
"
IUSE="test trainer-all trainer-bruteforce"
REQUIRED_USE="
	bolt? (
		|| (
			trainer-all
			trainer-bruteforce
		)
	)
	pgo? (
		|| (
			trainer-all
			trainer-bruteforce
		)
	)
"
RESTRICT="
	!test? (
		test
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
	sys-devel/make
	bolt? (
		sys-devel/clang
	)
	pgo? (
		sys-devel/clang
	)
"

pkg_setup() {
	uopts_setup
}


src_prepare() {
	default
	uopts_src_prepare
}

src_configure() { :; }

_src_configure() {
	uopts_src_configure
	if use pgo || use bolt ; then
		# Force use of the performant one.
		export CC="${CHOST}-clang"
	fi
	tc-is-gcc && replace-flags '-O*' '-O1' # >= -O2 breaks with instrumented PGO by gcc.
	tc-is-clang && replace-flags '-O*' '-O3'
	strip-unsupported-flags
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
	if use trainer-all ; then
		emake -C tests check
	elif use trainer-bruteforce ; then
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
ewarn "This package is still good for smaller passwords but only uses CPU and"
ewarn "may not have resume, but for longer passwords, consider GPU methods"
ewarn "instead."
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
