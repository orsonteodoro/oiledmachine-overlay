# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib flag-o-matic

SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="Binary-decimal and decimal-binary conversion routines for IEEE doubles"
HOMEPAGE="https://github.com/google/double-conversion"
LICENSE="BSD"
SLOT="0/3"
KEYWORDS="
~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390
~sparc ~x86 ~amd64-linux ~x86-linux
"
IUSE="test"

src_configure() {
	# -O0 breaks on 32-bit on
	# test_ieee ........................Subprocess aborted
	# -Ofast breaks on
#2/9 Test #2: test_bignum_dtoa .................Subprocess aborted***Exception:   0.01 sec
#3/9 Test #3: test_conversions .................Subprocess aborted***Exception:   0.01 sec
#5/9 Test #5: test_dtoa ........................Subprocess aborted***Exception:   0.01 sec
#6/9 Test #6: test_fast_dtoa ...................Subprocess aborted***Exception:   0.02 sec
#8/9 Test #9: test_strtod ......................Subprocess aborted***Exception:   0.01 sec
	replace-flags '-O0' '-O1'	# Bump to next fastest
	replace-flags '-Ofast' '-O3'	# Downgrade to next slowest
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
	)
	cmake-multilib_src_configure
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED 3.3.0 (20230529)
# For both 32 and 64 bit
# 100% tests passed, 0 tests failed out of 9
