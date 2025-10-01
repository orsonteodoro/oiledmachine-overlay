# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CPU_FLAGS_ARM=(
	"cpu_flags_arm_aes"
	"cpu_flags_arm_bf16"
	"cpu_flags_arm_neon"
	"cpu_flags_arm_sve"
	"cpu_flags_arm_sve2"
	"cpu_flags_arm_sve_256"
	"cpu_flags_arm_sve2_128"
)
CPU_FLAGS_PPC=(
	"cpu_flags_ppc_altivec"
	"cpu_flags_ppc_crypto"
	"cpu_flags_ppc_power8-vector"
	"cpu_flags_ppc_power9-vector"
	"cpu_flags_ppc_power10-vector"
	"cpu_flags_ppc_vsx"
)
CPU_FLAGS_RISCV=(
	"cpu_flags_riscv_rvv"
)
CPU_FLAGS_S390=(
	"cpu_flags_s390_z14"
	"cpu_flags_s390_z15"
)
CPU_FLAGS_X86=(
	"cpu_flags_x86_aes"
	"cpu_flags_x86_avx"
	"cpu_flags_x86_avx2"
	"cpu_flags_x86_avx10_2"
	"cpu_flags_x86_avx512bf16"
	"cpu_flags_x86_avx512bitalg"
	"cpu_flags_x86_avx512bw"
	"cpu_flags_x86_avx512cd"
	"cpu_flags_x86_avx512dq"
	"cpu_flags_x86_avx512f"
	"cpu_flags_x86_avx512fp16"
	"cpu_flags_x86_avx512vbmi"
	"cpu_flags_x86_avx512vbmi2"
	"cpu_flags_x86_avx512vl"
	"cpu_flags_x86_avx512vnni"
	"cpu_flags_x86_avx512vpopcntdq"
	"cpu_flags_x86_bmi"
	"cpu_flags_x86_bmi2"
	"cpu_flags_x86_fma"
	"cpu_flags_x86_f16c"
	"cpu_flags_x86_gfni"
	"cpu_flags_x86_pclmul"
	"cpu_flags_x86_sse2"
	"cpu_flags_x86_sse4_1"
	"cpu_flags_x86_sse4_2"
	"cpu_flags_x86_ssse3"
	"cpu_flags_x86_vaes"
	"cpu_flags_x86_vpclmulqdq"
)

inherit check-compiler-switch cmake-multilib flag-o-matic toolchain-funcs

if [[ "${PV}" == *"9999"* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/google/highway.git"
else
	SRC_URI="
https://github.com/google/highway/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	"
	KEYWORDS="~alpha ~amd64 ~arm arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

DESCRIPTION="Performance-portable, length-agnostic SIMD with runtime dispatch"
HOMEPAGE="https://github.com/google/highway"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="
${CPU_FLAGS_ARM[@]}
${CPU_FLAGS_PPC[@]}
${CPU_FLAGS_RISCV[@]}
${CPU_FLAGS_S390[@]}
${CPU_FLAGS_X86[@]}
test
ebuild_revision_9
"
REQUIRED_USE="
	cpu_flags_ppc_power8-vector? (
		cpu_flags_ppc_altivec
		cpu_flags_ppc_vsx
	)
	cpu_flags_ppc_power9-vector? (
		cpu_flags_ppc_power8-vector
	)
	cpu_flags_ppc_power10-vector? (
		cpu_flags_ppc_power9-vector
	)

	cpu_flags_x86_ssse3? (
		cpu_flags_x86_sse2
	)

	cpu_flags_x86_sse4_1? (
		cpu_flags_x86_ssse3
	)
	cpu_flags_x86_sse4_2? (
		cpu_flags_x86_sse4_1
	)

	cpu_flags_x86_pclmul? (
		cpu_flags_x86_sse4_2
	)

	cpu_flags_x86_aes? (
		cpu_flags_x86_pclmul
	)

	cpu_flags_x86_avx? (
		cpu_flags_x86_sse4_2
	)
	cpu_flags_x86_f16c? (
		cpu_flags_x86_avx
	)
	cpu_flags_x86_fma? (
		cpu_flags_x86_avx
	)

	cpu_flags_x86_avx2? (
		cpu_flags_x86_avx
	)

	cpu_flags_x86_avx512f? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512cd
	)
	cpu_flags_x86_avx512cd? (
		cpu_flags_x86_avx512f
	)
	cpu_flags_x86_avx512bw? (
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
	)
	cpu_flags_x86_avx512dq? (
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
	)
	cpu_flags_x86_avx512vl? (
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512f
	)

	cpu_flags_x86_vaes? (
		cpu_flags_x86_aes
		cpu_flags_x86_vpclmulqdq
	)
	cpu_flags_x86_vpclmulqdq? (
		cpu_flags_x86_avx2
		cpu_flags_x86_gfni
		cpu_flags_x86_vaes
	)
	cpu_flags_x86_avx512vbmi? (
		cpu_flags_x86_vpclmulqdq
		cpu_flags_x86_avx512bw
		cpu_flags_x86_f16c
	)

	cpu_flags_x86_avx512vnni? (
		cpu_flags_x86_avx512bw
		cpu_flags_x86_f16c
	)

	cpu_flags_x86_avx512vbmi2? (
		cpu_flags_x86_avx512bitalg
		cpu_flags_x86_avx512vbmi
		cpu_flags_x86_avx512vnni
		cpu_flags_x86_avx512vpopcntdq
	)
	cpu_flags_x86_avx512bitalg? (
		cpu_flags_x86_avx512vbmi2
		cpu_flags_x86_avx512vnni
		cpu_flags_x86_avx512vpopcntdq
	)
	cpu_flags_x86_avx512vpopcntdq? (
		cpu_flags_x86_avx512bitalg
		cpu_flags_x86_avx512vbmi2
		cpu_flags_x86_avx512vnni
	)
	cpu_flags_x86_gfni? (
		cpu_flags_x86_avx512bitalg
		cpu_flags_x86_avx512vbmi2
		cpu_flags_x86_avx512vnni
		cpu_flags_x86_avx512vpopcntdq
	)

	cpu_flags_x86_avx512bf16? (
		cpu_flags_x86_avx512vnni
	)

	cpu_flags_x86_avx512fp16? (
		cpu_flags_x86_avx512vbmi2
		cpu_flags_x86_avx512bf16
	)

"
DEPEND="
	test? (
		dev-cpp/gtest[${MULTILIB_USEDEP}]
	)
"
RESTRICT="
	!test? (
		test
	)
"
PATCHES=(
)

pkg_setup() {
	check-compiler-switch_start
}

_configure_cpu_flags_arm() {
	if ! use cpu_flags_arm_neon ; then
		disabled_cpu_flags+=(
			"HWY_NEON"
		)
	fi
	if ! use cpu_flags_arm_neon || use cpu_flags_arm_aes ; then
		disabled_cpu_flags+=(
			"HWY_NEON_WITHOUT_AES"
		)
	fi
	if ! use cpu_flags_arm_neon || ! use cpu_flags_arm_bf16 ; then
		disabled_cpu_flags+=(
			"HWY_NEON_BF16"
		)
	fi
	if ! use cpu_flags_arm_sve ; then
		disabled_cpu_flags+=(
			"HWY_SVE"
		)
	fi
	if ! use cpu_flags_arm_sve2 ; then
		disabled_cpu_flags+=(
			"HWY_SVE2"
		)
	fi
	if ! use cpu_flags_arm_sve_256 ; then
		disabled_cpu_flags+=(
			"HWY_SVE_256"
		)
	fi
	if ! use cpu_flags_arm_sve2_128 ; then
		disabled_cpu_flags+=(
			"HWY_SVE2_128"
		)
	fi
}

_configure_cpu_flags_ppc() {
	if ! use cpu_flags_ppc_power8-vector ; then
		append-flags -mno-power8-vector
		disabled_cpu_flags+=(
			"HWY_PPC8"
		)
	fi
	if ! use cpu_flags_ppc_power9-vector ; then
		append-flags -mno-power9-vector
		disabled_cpu_flags+=(
			"HWY_PPC9"
		)
	fi
	if ! use cpu_flags_ppc_power10-vector ; then
		if tc-is-clang ; then
			append-flags -mno-power10-vector
		fi
		disabled_cpu_flags+=(
			"HWY_PPC10"
		)
	fi
	if ! use cpu_flags_ppc_vsx ; then
		append-flags -mno-vsx
	fi
	if ! use cpu_flags_ppc_crypto ; then
		append-flags -mno-crypto
		cpp_flags+=(
			"-DHWY_DISABLE_PPC8_CRYPTO=1"
		)
	fi
}

_configure_cpu_flags_s390() {
	if ! use cpu_flags_s390_z14 ; then
		disabled_cpu_flags+=(
			"HWY_Z14"
		)
	fi
	if ! use cpu_flags_s390_z15 ; then
		disabled_cpu_flags+=(
			"HWY_Z15"
		)
	fi
}

_configure_cpu_flags_x86() {
	if ! use cpu_flags_x86_sse2 ; then
		append-flags -mno-sse2
		disabled_cpu_flags+=(
			"HWY_SSE2"
		)
	fi

	if ! use cpu_flags_x86_ssse3 ; then
		append-flags -mno-ssse3
		disabled_cpu_flags+=(
			"HWY_SSSE3"
		)
	fi

	use cpu_flags_x86_sse4_1 || append-flags -mno-sse4.1
	use cpu_flags_x86_sse4_2 || append-flags -mno-sse4.2
	if ! use cpu_flags_x86_sse4_1 || ! use cpu_flags_x86_sse4_2 ; then
		disabled_cpu_flags+=(
			"HWY_SSE4"
		)
	fi

	if ! use cpu_flags_x86_avx2 ; then
		append-flags -mno-avx2
		disabled_cpu_flags+=(
			"HWY_AVX2"
		)
	fi

	use cpu_flags_x86_avx512bw || append-flags -mno-avx512bw
	use cpu_flags_x86_avx512cd || append-flags -mno-avx512cd
	use cpu_flags_x86_avx512dq || append-flags -mno-avx512dq
	use cpu_flags_x86_avx512f || append-flags -mno-avx512f
	use cpu_flags_x86_avx512vl || append-flags -mno-avx512vl
	if ! use cpu_flags_x86_avx512f ; then
		disabled_cpu_flags+=(
			"HWY_AVX3"
		)
	fi

	use cpu_flags_x86_avx512bitalg || append-flags -mno-avx512bitalg
	use cpu_flags_x86_avx512vpopcntdq || append-flags -mno-avx512vpopcntdq
	use cpu_flags_x86_avx512vbmi || append-flags -mno-avx512vbmi
	use cpu_flags_x86_avx512vbmi2 || append-flags -mno-avx512vbmi2
	use cpu_flags_x86_avx512vnni || append-flags -mno-avx512vnni
	use cpu_flags_x86_gfni || append-flags -mno-gfni
	use cpu_flags_x86_vaes || append-flags -mno-vaes
	use cpu_flags_x86_vpclmulqdq || append-flags -mno-vpclmulqdq
	if ! use cpu_flags_x86_avx512vbmi2 ; then
		disabled_cpu_flags+=(
			"HWY_AVX3_DL"
		)
	fi

	use cpu_flags_x86_avx512fp16 || append-flags -mno-avx512fp16
	if ! use cpu_flags_x86_avx512fp16 ; then
		disabled_cpu_flags+=(
			"HWY_AVX3_SPR"
		)
	fi

	use cpu_flags_x86_avx512bf16 || append-flags -mno-avx512bf16
	if ! use cpu_flags_x86_avx512bf16 ; then
		disabled_cpu_flags+=(
			"HWY_AVX3_ZEN4"
		)
		cpp_flags+=(
			"-DHWY_AVX3_DISABLE_AVX512BF16=1"
		)
	fi

	use cpu_flags_x86_f16c || append-flags -mno-f16c
	if ! use cpu_flags_x86_f16c ; then
		cpp_flags+=(
			"-DHWY_DISABLE_F16C=1"
		)
	fi

	use cpu_flags_x86_bmi || append-flags -mno-bmi
	use cpu_flags_x86_bmi2 || append-flags -mno-bmi2
	use cpu_flags_x86_fma || append-flags -mno-fma
#	if use cpu_flags_x86_bmi && use cpu_flags_x86_bmi2 && use cpu_flags_x86_fma ; then
#		:
#	else
	# Breaks if flag is added
#		cpp_flags+=(
#			"-DHWY_DISABLE_BMI2_FMA=1"
#		)
#	fi

	use cpu_flags_x86_aes || append-flags -mno-aes
	use cpu_flags_x86_pclmul || append-flags -mno-pclmul
	if use cpu_flags_x86_pclmul && use cpu_flags_x86_aes ; then
		:
	else
		cpp_flags+=(
			"-DHWY_DISABLE_PCLMUL_AES=1"
		)
	fi

	use cpu_flags_x86_avx10_2 || append-flags -mno-avx10.2
	if ! use cpu_flags_x86_avx10_2 ; then
		disabled_cpu_flags+=(
			"HWY_AVX10_2"
		)
	fi
}

multilib_src_configure() {
ewarn "Rebuild with GCC 12 if it fails."
	check-compiler-switch_end
	if is-flagq '-flto*' && check-compiler-switch_is_lto_changed ; then
eerror "Detected compiler switch.  Removing LTO."
		filter-lto
	fi

	local cpp_flags=()
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DHWY_CMAKE_ARM7=$(usex cpu_flags_arm_neon)
		-DHWY_CMAKE_SSE2=$(usex cpu_flags_x86_sse2)
		-DHWY_CMAKE_RVV=$(usex cpu_flags_riscv_rvv)
		-DHWY_WARNINGS_ARE_ERRORS=OFF
	)

	local disabled_cpu_flags=()
	if [[ "${ARCH}" == "arm" || "${ARCH}" == "arm64" ]] ; then
		_configure_cpu_flags_arm
	fi
	if [[ "${ARCH}" == "ppc64" ]] ; then
		_configure_cpu_flags_ppc
	fi
	if [[ "${ARCH}" == "s390" ]] ; then
		_configure_cpu_flags_s390
	fi
	if [[ "${ARCH}" == "x86" || "${ARCH}" == "amd64" ]] ; then
		_configure_cpu_flags_x86
	fi

	if (( ${#disabled_cpu_flags[@]} > 0 )) ; then
		local str=""
		local x
		for x in ${disabled_cpu_flags[@]} ; do
			str+="|${x}"
		done
		str="${str:1}"
		mycmakeargs+=(
			-DCMAKE_CXX_FLAGS=-DHWY_DISABLED_TARGETS="\"(${str})\""
		)
	fi
	mycmakeargs+=(
		-DCMAKE_CXX_FLAGS="${CXXFLAGS} ${cpp_flags[*]}"
	)

	use test && mycmakeargs+=( "-DHWY_SYSTEM_GTEST=ON" )

	append-cppflags ${cpp_flags[@]}

einfo "CFLAGS:  ${CFLAGS}"
einfo "CXXFLAGS:  ${CXXFLAGS}"
einfo "CPPFLAGS:  ${CPPFLAGS}"

	cmake_src_configure
}
