# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

BF16_ARCHES=(
	armv8.4-a
	armv8.5-a
	armv8.6-a
	armv8.7-a
	armv8.8-a
	armv8.9-a
	armv9-a
	armv9.1-a
	armv9.2-a
	armv9.3-a
	armv9.4-a
)

FP16_ARCHES=(
	armv8.2-a
	armv8.3-a
	armv8.4-a
	armv8.5-a
	armv8.6-a
	armv8.7-a
	armv8.8-a
	armv8.9-a
	armv9-a
	armv9.1-a
	armv9.2-a
	armv9.3-a
	armv9.4-a
)

FP16FML_ARCHES=(
	armv8.2-a
	armv8.3-a
	armv8.4-a
	armv8.5-a
	armv8.6-a
	armv8.7-a
	armv8.8-a
	armv8.9-a
	armv9-a
	armv9.1-a
	armv9.2-a
	armv9.3-a
	armv9.4-a
)

I8MM_ARCHES=(
	armv8.4-a
	armv8.5-a
	armv8.6-a
	armv8.7-a
	armv8.8-a
	armv8.9-a
	armv9-a
	armv9.1-a
	armv9.2-a
	armv9.3-a
	armv9.4-a
)

SVE_ARCHES=(
	armv8.6-a
	armv8.7-a
	armv8.8-a
	armv8.9-a
	armv9-a
	armv9.1-a
	armv9.2-a
	armv9.3-a
	armv9.4-a
)

CPU_FLAGS_ARM=(
	cpu_flags_arm_bf16
	cpu_flags_arm_dotprod
	cpu_flags_arm_fp16
	cpu_flags_arm_fp16fml
	cpu_flags_arm_i8mm
	cpu_flags_arm_sve
	cpu_flags_arm_sve2
	cpu_flags_arm_svebf16
	cpu_flags_arm_svei8mm
	cpu_flags_arm_svef32mm
	cpu_flags_arm_vfpv4
)

CPU_FLAGS_LOONG=(
	cpu_flags_loong_lasx
	cpu_flags_loong_lsx
	cpu_flags_loong_mmi
)

CPU_FLAGS_MIPS=(
	cpu_flags_mips_msa
)

CPU_FLAGS_PPC=(
	cpu_flags_ppc_sse2
	cpu_flags_ppc_sse41
)

CPU_FLAGS_RISCV=(
	cpu_flags_riscv_rvv
	cpu_flags_riscv_xtheadvector
	cpu_flags_riscv_zfh
	cpu_flags_riscv_zvfh
)

CPU_FLAGS_X86=(
	cpu_flags_x86_avx
	cpu_flags_x86_avx2
	cpu_flags_x86_avxneconvert
	cpu_flags_x86_avxvnni
	cpu_flags_x86_avxvnniint8
	cpu_flags_x86_avxvnniint16
	cpu_flags_x86_avx512bw
	cpu_flags_x86_avx512cd
	cpu_flags_x86_avx512dq
	cpu_flags_x86_avx512f
	cpu_flags_x86_avx512bf16
	cpu_flags_x86_avx512fp16
	cpu_flags_x86_avx512vl
	cpu_flags_x86_avx512vnni
	cpu_flags_x86_f16c
	cpu_flags_x86_fma
	cpu_flags_x86_sse2
	cpu_flags_x86_xop
)

inherit cmake toolchain-funcs

DESCRIPTION="High-performance neural network inference framework"
HOMEPAGE="https://github.com/Tencent/ncnn/"
SRC_URI="
	https://github.com/Tencent/ncnn/archive/refs/tags/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="BSD ZLIB"
SLOT="0/${PV}" # currently has unstable ABI that often requires rebuilds
KEYWORDS="amd64 ~x86"
IUSE="
${CPU_FLAGS_ARM[@]}
${CPU_FLAGS_LOONG[@]}
${CPU_FLAGS_MIPS[@]}
${CPU_FLAGS_PPC[@]}
${CPU_FLAGS_RISCV[@]}
${CPU_FLAGS_X86[@]}
openmp tools +vulkan
"
REQUIRED_USE="
	cpu_flags_arm_bf16? (
		cpu_flags_arm_dotprod
		cpu_flags_arm_fp16fml
	)
	cpu_flags_arm_i8mm? (
		cpu_flags_arm_dotprod
		cpu_flags_arm_fp16fml
	)
	cpu_flags_arm_sve? (
		cpu_flags_arm_bf16
		cpu_flags_arm_i8mm
	)
	cpu_flags_arm_sve2? (
		cpu_flags_arm_sve
	)
	cpu_flags_arm_svebf16? (
		cpu_flags_arm_sve
	)
	cpu_flags_arm_svef32mm? (
		cpu_flags_arm_sve
	)
	cpu_flags_arm_svei8mm? (
		cpu_flags_arm_sve
	)
	cpu_flags_riscv_zvfh? (
		cpu_flags_riscv_rvv
		cpu_flags_riscv_zfh
	)
	cpu_flags_x86_avx? (
		cpu_flags_x86_fma
	)
	cpu_flags_x86_avx2? (
		cpu_flags_x86_avx
		cpu_flags_x86_fma
		cpu_flags_x86_f16c
	)
	cpu_flags_x86_avx512bw? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512f
	)
	cpu_flags_x86_avx512cd? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512f
	)
	cpu_flags_x86_avx512dq? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512f
	)
	cpu_flags_x86_avx512f? (
		cpu_flags_x86_sse2
	)
	cpu_flags_x86_avx512vl? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512f
	)
	cpu_flags_x86_avx512bf16? (
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
	)
	cpu_flags_x86_avx512fp16? (
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
	)
	cpu_flags_x86_avx512vnni? (
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
	)
	cpu_flags_x86_avxneconvert? (
		cpu_flags_x86_avx2
		cpu_flags_x86_fma
		cpu_flags_x86_f16c
	)
	cpu_flags_x86_avxvnni? (
		cpu_flags_x86_fma
		cpu_flags_x86_f16c
	)
	cpu_flags_x86_avxvnniint8? (
		cpu_flags_x86_avx2
		cpu_flags_x86_fma
		cpu_flags_x86_f16c
	)
	cpu_flags_x86_avxvnniint16? (
		cpu_flags_x86_avx2
		cpu_flags_x86_fma
		cpu_flags_x86_f16c
	)
	cpu_flags_x86_f16c? (
		cpu_flags_x86_avx
	)
	cpu_flags_x86_fma? (
		cpu_flags_x86_f16c
	)
	cpu_flags_x86_xop? (
		cpu_flags_x86_avx
	)
"

# Need the static library to run tests + skip vulkan / GPU:
# -DNCNN_BUILD_TESTS=ON -DNCNN_SHARED_LIB=OFF -DNCNN_VULKAN=OFF
RESTRICT="test"

RDEPEND="
	tools? (
		dev-cpp/abseil-cpp:=
		dev-libs/protobuf:=
	)
	vulkan? (
		dev-util/glslang:=
		media-libs/vulkan-loader
	)
"
DEPEND="
	${RDEPEND}
	vulkan? ( dev-util/vulkan-headers )
"

DOCS=( README.md docs/. )

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	local mycmakeargs=(
		-DGLSLANG_TARGET_DIR="${ESYSROOT}"/usr/$(get_libdir)/cmake
		-DNCNN_BUILD_EXAMPLES=no
		-DNCNN_BUILD_TOOLS=$(usex tools)
		-DNCNN_OPENMP=$(usex openmp)
		-DNCNN_PYTHON=no # todo if something needs it
		-DNCNN_SHARED_LIB=yes
		-DNCNN_SIMPLEVK=no
		-DNCNN_SYSTEM_GLSLANG=yes
		-DNCNN_VERSION=${PV} # avoids libncnn.so.*.%Y%m%d using build date
		-DNCNN_VULKAN=$(usex vulkan)

		-DNCNN_AVX=$(usex cpu_flags_x86_avx)
		-DNCNN_AVX2=$(usex cpu_flags_x86_avx2)
		-DNCNN_AVXNECONVERT=$(usex cpu_flags_x86_avxneconvert)
		-DNCNN_AVXVNNI=$(usex cpu_flags_x86_avxvnni)
		-DNCNN_AVXVNNIINT8=$(usex cpu_flags_x86_avxvnniint8)
		-DNCNN_AVXVNNIINT16=$(usex cpu_flags_x86_avxvnniint16)
		-DNCNN_AVX512FP16=$(usex cpu_flags_x86_avx512fp16)
		-DNCNN_AVX512VNNI=$(usex cpu_flags_x86_avx512vnni)
		-DNCNN_F16C=$(usex cpu_flags_x86_f16c)
		-DNCNN_FMA=$(usex cpu_flags_x86_fma)
		-DNCNN_LASX=$(usex cpu_flags_loong_lasx)
		-DNCNN_LSX=$(usex cpu_flags_loong_lsx)
		-DNCNN_MMI=$(usex cpu_flags_loong_mmi)
		-DNCNN_MSA=$(usex cpu_flags_mips_msa)
		-DNCNN_RVV=$(usex cpu_flags_riscv_rvv)
		-DNCNN_SSE2=$(usex cpu_flags_x86_sse2)
		-DNCNN_VFPV4=$(usex cpu_flags_arm_vfpv4)
		-DNCNN_VSX_SSE2=$(usex cpu_flags_ppc_sse2)
		-DNCNN_VSX_SSE41=$(usex cpu_flags_ppc_sse41)
		-DNCNN_XOP=$(usex cpu_flags_x86_xop)
		-DNCNN_XTHEADVECTOR=$(usex cpu_flags_riscv_xtheadvector)
		-DNCNN_ZFH=$(usex cpu_flags_riscv_zfh)
		-DNCNN_ZVFH=$(usex cpu_flags_riscv_zvfh)
	)

	if use cpu_flags_x86_avx512bw && use cpu_flags_x86_avx512cd && use cpu_flags_x86_avx512dq && use cpu_flags_x86_avx512vl ; then
		mycmakeargs+=(
			-DNCNN_AVX512=ON
		)
	else
		mycmakeargs+=(
			-DNCNN_AVX512=OFF
		)
	fi

	local found
	found=0
	for x in ${FP16_ARCHES[@]} ; do
		if [[ "${CFLAGS}" =~ "-march=${x}" ]] ; then
			if use cpu_flags_arm_fp16 ; then
				found=1
				break
			fi
		fi
	done
	if (( ${found} == 1 )) ; then
		mycmakeargs+=(
			-DNCNN_ARM82=ON
		)
	else
		mycmakeargs+=(
			-DNCNN_ARM82=OFF
		)
	fi

	found=0
	for x in ${BF16_ARCHES[@]} ; do
		if [[ "${CFLAGS}" =~ "-march=${x}" ]] ; then
			if use cpu_flags_arm_bf16 ; then
				found=1
				break
			fi
		fi
	done
	if (( ${found} == 1 )) ; then
		mycmakeargs+=(
			-DNCNN_ARM84BF16=ON
		)
	else
		mycmakeargs+=(
			-DNCNN_ARM84BF16=OFF
		)
	fi

	found=0
	for x in ${FP16_ARCHES[@]} ; do
		if [[ "${CFLAGS}" =~ "-march=${x}" ]] ; then
			if use cpu_flags_arm_dotprod ; then
				found=1
				break
			fi
		fi
	done
	if (( ${found} == 1 )) ; then
		mycmakeargs+=(
			-DNCNN_ARM82DOT=ON
		)
	else
		mycmakeargs+=(
			-DNCNN_ARM82DOT=OFF
		)
	fi

	found=0
	for x in ${FP16FML_ARCHES[@]} ; do
		if [[ "${CFLAGS}" =~ "-march=${x}" ]] ; then
			if use cpu_flags_arm_fp16fml ; then
				found=1
				break
			fi
		fi
	done
	if (( ${found} == 1 )) ; then
		mycmakeargs+=(
			-DNCNN_ARM82FP16FML=ON
		)
	else
		mycmakeargs+=(
			-DNCNN_ARM82FP16FML=OFF
		)
	fi

	found=0
	for x in ${I8MM_ARCHES[@]} ; do
		if [[ "${CFLAGS}" =~ "-march=${x}" ]] ; then
			if use cpu_flags_arm_i8mm ; then
				found=1
				break
			fi
		fi
	done
	if (( ${found} == 1 )) ; then
		mycmakeargs+=(
			-DNCNN_ARM84I8MM=ON
		)
	else
		mycmakeargs+=(
			-DNCNN_ARM84I8MM=OFF
		)
	fi


	found=0
	for x in ${SVE_ARCHES[@]} ; do
		if [[ "${CFLAGS}" =~ "-march=${x}" ]] ; then
			if use cpu_flags_arm_sve ; then
				found=1
				break
			fi
		fi
	done
	if (( ${found} == 1 )) ; then
		mycmakeargs+=(
			-DNCNN_ARM86SVE=ON
		)
	else
		mycmakeargs+=(
			-DNCNN_ARM86SVE=OFF
		)
	fi

	found=0
	for x in ${SVE_ARCHES[@]} ; do
		if [[ "${CFLAGS}" =~ "-march=${x}" ]] ; then
			if use cpu_flags_arm_sve2 ; then
				found=1
				break
			fi
		fi
	done
	if (( ${found} == 1 )) ; then
		mycmakeargs+=(
			-DNCNN_ARM86SVE2=ON
		)
	else
		mycmakeargs+=(
			-DNCNN_ARM86SVE2=OFF
		)
	fi

	found=0
	for x in ${SVE_ARCHES[@]} ; do
		if [[ "${CFLAGS}" =~ "-march=${x}" ]] ; then
			if use cpu_flags_arm_svebf16 ; then
				found=1
				break
			fi
		fi
	done
	if (( ${found} == 1 )) ; then
		mycmakeargs+=(
			-DNCNN_ARM86SVEBF16=ON
		)
	else
		mycmakeargs+=(
			-DNCNN_ARM86SVEBF16=OFF
		)
	fi

	found=0
	for x in ${SVE_ARCHES[@]} ; do
		if [[ "${CFLAGS}" =~ "-march=${x}" ]] ; then
			if use cpu_flags_arm_svei8mm ; then
				found=1
				break
			fi
		fi
	done
	if (( ${found} == 1 )) ; then
		mycmakeargs+=(
			-DNCNN_ARM86SVEI8MM=ON
		)
	else
		mycmakeargs+=(
			-DNCNN_ARM86SVEI8MM=OFF
		)
	fi

	found=0
	for x in ${SVE_ARCHES[@]} ; do
		if [[ "${CFLAGS}" =~ "-march=${x}" ]] ; then
			if use cpu_flags_arm_svef32mm ; then
				found=1
				break
			fi
		fi
	done
	if (( ${found} == 1 )) ; then
		mycmakeargs+=(
			-DNCNN_ARM86SVEF32MM=ON
		)
	else
		mycmakeargs+=(
			-DNCNN_ARM86SVEF32MM=OFF
		)
	fi

	# A temporary workaround due to a >=clang-18 regression (bug #929228)
	if tc-is-clang && [[ $(clang-major-version) -ge "18" ]] ; then
		mycmakeargs+=(
			-DNCNN_AVX512BF16=OFF
		)
	else
		mycmakeargs+=(
			-DNCNN_AVX512BF16=$(usex cpu_flags_x86_avx512bf16)
		)
	fi

	cmake_src_configure
}
