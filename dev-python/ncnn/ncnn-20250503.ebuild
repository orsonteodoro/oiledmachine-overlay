# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="untrusted-data"
DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
GLSLANG_COMMIT="a9ac7d5f307e5db5b8c4fbf904bdba8fca6283bc"
PYBIND11_COMMIT="3e9dfa2866941655c56877882565e7577de6fc7b"

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

PYTHON_COMPAT=( "python3_"{11,12} )

inherit cflags-hardened distutils-r1 dep-prepare toolchain-funcs

DESCRIPTION="Python bindings for the high-performance neural network inference framework"
HOMEPAGE="https://github.com/Tencent/ncnn/"
SRC_URI="
https://github.com/Tencent/ncnn/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/KhronosGroup/glslang/archive/${GLSLANG_COMMIT}.tar.gz
	-> glslang-${GLSLANG_COMMIT:0:7}.tar.gz
https://github.com/pybind/pybind11/archive/${PYBIND11_COMMIT}.tar.gz
	-> pybind11-${PYBIND11_COMMIT:0:7}.tar.gz
"

LICENSE="
	(
		Apache-2.0
		BSD
		BSD-2
		custom
		GPL-3
		MIT
	)
	(
		BSD
		BSD-2
		ZLIB
	)
	BSD
"
# Apache-2 BSD BSD-2 custom GPL-3 MIT - glslang
# BSD - pybind11
# BSD BSD-2 ZLIB - ncnn
SLOT="0/${PV}" # currently has unstable ABI that often requires rebuilds
KEYWORDS="
~amd64 ~amd64-linux ~arm ~arm-linux ~arm64 ~arm64-linux ~arm64-macos ~loong
~mips ~ppc64 ~ppc64-linux ~riscv ~riscv-linux ~x64-macos ~x86 ~x86-linux
"
IUSE="
${CPU_FLAGS_ARM[@]}
${CPU_FLAGS_LOONG[@]}
${CPU_FLAGS_MIPS[@]}
${CPU_FLAGS_PPC[@]}
${CPU_FLAGS_RISCV[@]}
${CPU_FLAGS_X86[@]}
openmp
ebuild_revision_7
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
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/portalocker[${PYTHON_USEDEP}]
	')
	media-libs/opencv[python,${PYTHON_SINGLE_USEDEP}]
	dev-util/glslang:=
	media-libs/vulkan-drivers
	media-libs/vulkan-loader
"
DEPEND="
	${RDEPEND}
	dev-util/vulkan-headers
"
BDEPEND="
	>=dev-build/cmake-3.12
"
DOCS=( "README.md" "docs/." )
PATCHES=(
	"${FILESDIR}/${PN}-20240820-simd-configure.patch"
)

pkg_pretend() {
	[[ "${MERGE_TYPE}" != "binary" ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ "${MERGE_TYPE}" != "binary" ]] && use openmp && tc-check-openmp
	python_setup
}

src_unpack() {
	unpack ${A}
	dep_prepare_mv "${WORKDIR}/glslang-${GLSLANG_COMMIT}" "${S}/glslang"
	dep_prepare_mv "${WORKDIR}/pybind11-${PYBIND11_COMMIT}" "${S}/python/pybind11"
}

src_prepare() {
	distutils-r1_src_prepare
}

src_configure() {
	cflags-hardened_append
#	export GLSLANG_TARGET_DIR="${ESYSROOT}/usr/$(get_libdir)/cmake"
	export NCNN_BUILD_EXAMPLES=OFF
	export NCNN_BUILD_TOOLS=OFF
	export NCNN_PYTHON=ON
	export NCNN_OPENMP=$(usex openmp)
	export NCNN_SHARED_LIB=ON
	export NCNN_SIMPLEVK=ON
	export NCNN_SYSTEM_GLSLANG=OFF
	export NCNN_VERSION="${PV}" # avoids libncnn.so.*.%Y%m%d using build date

	export NCNN_AVX=$(usex cpu_flags_x86_avx)
	export NCNN_AVX2=$(usex cpu_flags_x86_avx2)
	export NCNN_AVXNECONVERT=$(usex cpu_flags_x86_avxneconvert)
	export NCNN_AVXVNNI=$(usex cpu_flags_x86_avxvnni)
	export NCNN_AVXVNNIINT8=$(usex cpu_flags_x86_avxvnniint8)
	export NCNN_AVXVNNIINT16=$(usex cpu_flags_x86_avxvnniint16)
	export NCNN_AVX512FP16=$(usex cpu_flags_x86_avx512fp16)
	export NCNN_AVX512VNNI=$(usex cpu_flags_x86_avx512vnni)
	export NCNN_F16C=$(usex cpu_flags_x86_f16c)
	export NCNN_FMA=$(usex cpu_flags_x86_fma)
	export NCNN_LASX=$(usex cpu_flags_loong_lasx)
	export NCNN_LSX=$(usex cpu_flags_loong_lsx)
	export NCNN_MMI=$(usex cpu_flags_loong_mmi)
	export NCNN_MSA=$(usex cpu_flags_mips_msa)
	export NCNN_RVV=$(usex cpu_flags_riscv_rvv)
	export NCNN_SSE2=$(usex cpu_flags_x86_sse2)
	export NCNN_VFPV4=$(usex cpu_flags_arm_vfpv4)
	export NCNN_VSX_SSE2=$(usex cpu_flags_ppc_sse2)
	export NCNN_VSX_SSE41=$(usex cpu_flags_ppc_sse41)
	export NCNN_XOP=$(usex cpu_flags_x86_xop)
	export NCNN_XTHEADVECTOR=$(usex cpu_flags_riscv_xtheadvector)
	export NCNN_ZFH=$(usex cpu_flags_riscv_zfh)
	export NCNN_ZVFH=$(usex cpu_flags_riscv_zvfh)

	if use cpu_flags_x86_avx512bw && use cpu_flags_x86_avx512cd && use cpu_flags_x86_avx512dq && use cpu_flags_x86_avx512vl ; then
		export NCNN_AVX512=ON
	else
		export NCNN_AVX512=OFF
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
		export NCNN_ARM82=ON
	else
		export NCNN_ARM82=OFF
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
		export NCNN_ARM84BF16=ON
	else
		export NCNN_ARM84BF16=OFF
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
		export NCNN_ARM82DOT=ON
	else
		export NCNN_ARM82DOT=OFF
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
		export NCNN_ARM82FP16FML=ON
	else
		export NCNN_ARM82FP16FML=OFF
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
		export NCNN_ARM84I8MM=ON
	else
		export NCNN_ARM84I8MM=OFF
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
		export NCNN_ARM86SVE=ON
	else
		export NCNN_ARM86SVE=OFF
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
		export NCNN_ARM86SVE2=ON
	else
		export NCNN_ARM86SVE2=OFF
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
		export NCNN_ARM86SVEBF16=ON
	else
		export NCNN_ARM86SVEBF16=OFF
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
		export NCNN_ARM86SVEI8MM=ON
	else
		export NCNN_ARM86SVEI8MM=OFF
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
		export NCNN_ARM86SVEF32MM=ON
	else
		export NCNN_ARM86SVEF32MM=OFF
	fi

	# A temporary workaround due to a >=clang-18 regression (bug #929228)
	if tc-is-clang && [[ $(clang-major-version) -ge "18" ]] ; then
		export NCNN_AVX512BF16=OFF
	else
		export NCNN_AVX512BF16=$(usex cpu_flags_x86_avx512bf16)
	fi

	distutils-r1_src_configure
}

src_compile() {
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install

	mv "${ED}/usr/share/doc/"{"","python-"}"ncnn-20240820" || die
}
