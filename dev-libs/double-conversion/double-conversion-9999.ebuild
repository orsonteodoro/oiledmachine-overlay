# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=17

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX17[@]}
)

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}
)

inherit cmake-multilib flag-o-matic libcxx-slot libstdcxx-slot

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="cca5e458e1bb930a19fa77ea8ee7dff7069ba68e"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/google/double-conversion.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="https://github.com/google/double-conversion/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Binary-decimal and decimal-binary conversion routines for IEEE doubles"
HOMEPAGE="https://github.com/google/double-conversion"
LICENSE="BSD"
SOVER="3"
SLOT="0/${SOVER}"
KEYWORDS="~amd64 ~arm64"
IUSE="test"

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

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
	local actual_sover=$(grep -E -e "SOVERSION [0-9]+" "${S}/CMakeLists.txt" | cut -f 6 -d " " | sed -e "s|)||g")
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Update the SOVER in the ebuild."
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
	fi
}

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
