# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CPU_FLAGS_ARM=(
	"cpu_flags_arm_neon"
	"cpu_flags_arm_neon_without_aes"
	"cpu_flags_arm_neon_bf16"
	"cpu_flags_arm_sve"
	"cpu_flags_arm_sve2"
	"cpu_flags_arm_sve_256"
	"cpu_flags_arm_sve2_128"
)
CPU_FLAGS_PPC=(
	"cpu_flags_ppc_ppc8"
	"cpu_flags_ppc_ppc9"
	"cpu_flags_ppc_ppc10"
)
CPU_FLAGS_S390=(
	"cpu_flags_s390_z14"
	"cpu_flags_s390_z15"
)
CPU_FLAGS_RISCV=(
	"cpu_flags_riscv_rvv"
)
CPU_FLAGS_X86=(
	"cpu_flags_x86_avx"
	"cpu_flags_x86_avx2"
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
	"cpu_flags_x86_f16c"
	"cpu_flags_x86_gfni"
	"cpu_flags_x86_sse2"
	"cpu_flags_x86_sse4_2"
	"cpu_flags_x86_ssse3"
	"cpu_flags_x86_vaes"
	"cpu_flags_x86_vpclmulqdq"
)

inherit cmake-multilib

if [[ "${PV}" == *9999* ]]; then
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
${CPU_FLAGS_S390[@]}
${CPU_FLAGS_RISCV[@]}
${CPU_FLAGS_X86[@]}
test
"
REQUIRED_USE="
	cpu_flags_x86_ssse3? (
		cpu_flags_x86_sse2
	)

	cpu_flags_x86_sse4_2? (
		cpu_flags_x86_ssse3
	)

	cpu_flags_x86_avx? (
		cpu_flags_x86_sse4_2
	)

	cpu_flags_x86_avx2? (
		cpu_flags_x86_avx
		cpu_flags_x86_f16c
	)

	cpu_flags_x86_avx512f? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512vl
	)
	cpu_flags_x86_avx512cd? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
	)
	cpu_flags_x86_avx512dq? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
	)
	cpu_flags_x86_avx512bw? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
	)
	cpu_flags_x86_avx512vl? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512f
	)

	cpu_flags_x86_vpclmulqdq? (
		cpu_flags_x86_avx512bitalg
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vbmi
		cpu_flags_x86_avx512vl
		cpu_flags_x86_avx512vnni
		cpu_flags_x86_gfni
		cpu_flags_x86_vaes
	)
	cpu_flags_x86_avx512vbmi? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
		cpu_flags_x86_f16c
	)
	cpu_flags_x86_avx512vbmi2? (
		cpu_flags_x86_avx512bitalg
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vbmi
		cpu_flags_x86_avx512vl
		cpu_flags_x86_avx512vnni
		cpu_flags_x86_gfni
		cpu_flags_x86_vaes
		cpu_flags_x86_vpclmulqdq
	)
	cpu_flags_x86_vaes? (
		cpu_flags_x86_avx512bitalg
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vbmi2
		cpu_flags_x86_avx512vl
		cpu_flags_x86_avx512vnni
		cpu_flags_x86_gfni
		cpu_flags_x86_vpclmulqdq
	)
	cpu_flags_x86_avx512vnni? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
		cpu_flags_x86_f16c
	)
	cpu_flags_x86_avx512bitalg? (
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vbmi2
		cpu_flags_x86_avx512vl
		cpu_flags_x86_avx512vnni
		cpu_flags_x86_gfni
		cpu_flags_x86_vaes
		cpu_flags_x86_vpclmulqdq
	)
	cpu_flags_x86_avx512vpopcntdq? (
		cpu_flags_x86_avx512bitalg
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vbmi2
		cpu_flags_x86_avx512vl
		cpu_flags_x86_avx512vnni
		cpu_flags_x86_gfni
		cpu_flags_x86_vaes
		cpu_flags_x86_vpclmulqdq
	)
	cpu_flags_x86_gfni? (
		cpu_flags_x86_avx512bitalg
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vbmi2
		cpu_flags_x86_avx512vl
		cpu_flags_x86_avx512vnni
		cpu_flags_x86_vaes
		cpu_flags_x86_vpclmulqdq
	)

	cpu_flags_x86_avx512bf16? (
		cpu_flags_x86_gfni
	)

	cpu_flags_x86_avx512fp16? (
		cpu_flags_x86_gfni
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

_configure_cpu_flags_arm() {
	if ! use cpu_flags_arm_neon ; then
		disabled_cpu_flags+=(
			"HWY_NEON"
		)
	fi
	if ! use cpu_flags_arm_neon_without_aes ; then
		disabled_cpu_flags+=(
			"HWY_NEON_WITHOUT_AES"
		)
	fi
	if ! use cpu_flags_arm_neon_bf16 ; then
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
	if ! use cpu_flags_ppc_ppc8 ; then
		disabled_cpu_flags+=(
			"HWY_PPC8"
		)
	fi
	if ! use cpu_flags_ppc_ppc9 ; then
		disabled_cpu_flags+=(
			"HWY_PPC9"
		)
	fi
	if ! use cpu_flags_ppc_ppc10 ; then
		disabled_cpu_flags+=(
			"HWY_PPC10"
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
		disabled_cpu_flags+=(
			"HWY_SSE2"
		)
	fi
	if ! use cpu_flags_x86_ssse3 ; then
		disabled_cpu_flags+=(
			"HWY_SSSE3"
		)
	fi
	if ! use cpu_flags_x86_sse4_2 ; then
		disabled_cpu_flags+=(
			"HWY_SSE4"
		)
	fi
	if ! use cpu_flags_x86_avx2 ; then
		disabled_cpu_flags+=(
			"HWY_AVX2"
		)
	fi
	if ! use cpu_flags_x86_avx512bw ; then
		disabled_cpu_flags+=(
			"HWY_AVX3"
		)
	fi
	if ! use cpu_flags_x86_gfni ; then
		disabled_cpu_flags+=(
			"HWY_AVX3_DL"
		)
	fi
	if ! use cpu_flags_x86_avx512fp16 ; then
		disabled_cpu_flags+=(
			"HWY_AVX3_SPR"
		)
	fi
	if ! use cpu_flags_x86_avx512bf16 ; then
		disabled_cpu_flags+=(
			"HWY_AVX3_ZEN4"
		)
	fi
	if ! use cpu_flags_x86_f16c ; then
		mycmakeargs+=(
			"-DHWY_DISABLE_F16C=1"
		)
	fi
}

multilib_src_configure() {
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
			-DCMAKE_CXX_FLAGS="-DHWY_DISABLED_TARGETS=\"(${str})\""
		)
	fi

	use test && mycmakeargs+=( "-DHWY_SYSTEM_GTEST=ON" )

	cmake_src_configure
}
