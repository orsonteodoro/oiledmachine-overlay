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
		# Force use the performant one
		export CC="${CHOST}-clang"
	fi
	tc-is-gcc && replace-flags '-O*' '-O1' # >= -O2 breaks with instrumented PGO by gcc.
	tc-is-clang && replace-flags '-O*' '-O3'
	strip-unsupported-flags
	sed -i -e "s|ZC_PW_MAXLEN	  16|ZC_PW_MAXLEN	  ${ZC_PW_MAXLEN:-16}|g" lib/libzc.h || die
	eautoreconf
	./configure \
		--libdir="${EPREFIX}/usr/$(get_libdir)"
}

_src_compile() {
	emake V=1
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
	uopts_src_compile
}

src_test() {
	emake -C tests check
}

src_install() {
	emake DESTDIR="${D}" install
	if [[ -e "${ED}/usr/share/doc/yazc" ]] ; then
		mv \
			"${ED}/usr/share/doc/yazc" \
			"${ED}/usr/share/doc/yazc-${PV}" \
			|| die
	fi
	uopts_src_install
}

pkg_postinst() {
	uopts_pkg_postinst
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
