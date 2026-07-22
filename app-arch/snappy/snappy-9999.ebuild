# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_VULNERABILITY_HISTORY="DOS ID"
CFLAGS_HARDENED_USE_CASES="sensitive-data untrusted-data"
CXX_STANDARD=11

_CXX_STANDARD=(
	"cxx_standard_cxx11"
	"cxx_standard_cxx14"
	"+cxx_standard_cxx17"
)

CPU_FLAGS_X86=(
	"cpu_flags_x86_avx"
	"cpu_flags_x86_avx2"
)

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX11[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX11[@]/llvm_slot_}"
)

inherit cflags-hardened cmake-multilib libcxx-slot libstdcxx-slot

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="7406111ac4ae539ea0db8b7ea2dc76730cd957f4"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/google/snappy.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
	SRC_URI="https://github.com/google/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="A high-speed compression/decompression library by Google"
HOMEPAGE="https://github.com/google/snappy"
LICENSE="BSD"
# ABI may be broken without a new SONAME.  Please use abidiff on bumps.
SOVER="1" # Since 1.1.3
# SLOT=0 - 1.1.3
# SLOT=0/${project_major_version} - 1.1.7 to 1.1.10
# SLOT=0/${project_major_version}.1 - 1.2.0
ABIDIFF_BUMP="1" # It is not well documented.  But for simplicity, it could be project_minor_version difference.
SLOT="0/${SOVER}.${ABIDIFF_BUMP}"
IUSE="
${_CXX_STANDARD[@]}
${CPU_FLAGS_X86[@]}
test
ebuild_revision_12
"
REQUIRED_USE="
	test? (
		cxx_standard_cxx17
	)
	^^ (
		${_CXX_STANDARD[@]/+}
	)
"
RESTRICT="!test? ( test )"

BDEPEND+="
	test? (
		dev-cpp/gtest:=[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	)
"

DOCS=( format_description.txt framing_format.txt NEWS README.md )

PATCHES=(
	"${FILESDIR}/${PN}-1.2.0_external-gtest.patch"
	"${FILESDIR}/${PN}-1.2.0_no-werror.patch"
	"${FILESDIR}/${PN}-1.2.2_remove-no-rtti.patch"
)

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			GIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
	local actual_sover=$(grep -E "^project.*VERSION" "${S}/CMakeLists.txt" | grep -E -o -e "[0-9.]+" | cut -f 1 -d ".")
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" "-ne" "${expected_sover}" ; then
eerror "QA:  Bump SOVER in ebuild."
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
		die
	fi
	local actual_abidiff_bump=$(grep -E "^project.*VERSION" "${S}/CMakeLists.txt" | grep -E -o -e "[0-9.]+" | cut -f 2 -d ".")
	actual_abidiff_bump=$(( ${actual_abidiff_bump} - 1 ))
	local expected_abidiff_bump="${ABIDIFF_BUMP}"
	if ver_test "${actual_abidiff_bump}" "-ne" "${expected_abidiff_bump}" ; then
eerror "QA:  Bump ABIDIFF_BUMP in ebuild."
eerror "Actual ABIDIFF_BUMP:  ${actual_abidiff_bump}"
eerror "Expected ABIDIFF_BUMP:  ${expected_abidiff_bump}"
		die
	fi

}

multilib_src_configure() {
	cflags-hardened_append
	local mycmakeargs=(
		$(usex cxx_standard_cxx11 '-DCMAKE_CXX_STANDARD=11') # Project default
		$(usex cxx_standard_cxx14 '-DCMAKE_CXX_STANDARD=14')
		$(usex cxx_standard_cxx17 '-DCMAKE_CXX_STANDARD=17') # For gtest
		-DSNAPPY_BUILD_TESTS=$(usex test)
		-DSNAPPY_REQUIRE_AVX=$(usex cpu_flags_x86_avx)
		-DSNAPPY_REQUIRE_AVX2=$(usex cpu_flags_x86_avx2)
		-DSNAPPY_BUILD_BENCHMARKS=OFF
		# Options below are related to benchmarking, that we disable.
		-DHAVE_LIBZ=NO
		-DHAVE_LIBLZO2=NO
		-DHAVE_LIBLZ4=NO
	)
	cmake_src_configure
}

multilib_src_test() {
	# run tests directly to get verbose output
	cd "${S}" || die
	"${BUILD_DIR}"/snappy_unittest || die
}
