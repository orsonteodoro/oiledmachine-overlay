# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# When you update this, update also dev-util/pnnx and dev-python/ncnn

CFLAGS_HARDENED_USE_CASES="untrusted-data"
DISTUTILS_OPTIONAL=1
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

PYTHON_COMPAT=( "python3_"{11..13} )

inherit cflags-hardened cmake dep-prepare distutils-r1 optfeature toolchain-funcs

DESCRIPTION="High-performance neural network inference framework"
HOMEPAGE="https://github.com/Tencent/ncnn/"
SRC_URI_DISABLED="
https://github.com/KhronosGroup/glslang/archive/${GLSLANG_COMMIT}.tar.gz
	-> glslang-${GLSLANG_COMMIT:0:7}.tar.gz
https://github.com/pybind/pybind11/archive/${PYBIND11_COMMIT}.tar.gz
	-> pybind11-${PYBIND11_COMMIT:0:7}.tar.gz
"
SRC_URI="
https://github.com/Tencent/ncnn/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
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
examples openmp python tools +vulkan
ebuild_revision_9
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
	python? (
		${PYTHON_REQUIRED_USE}
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
		media-libs/vulkan-drivers
		media-libs/vulkan-loader
	)
"
DEPEND="
	${RDEPEND}
	vulkan? (
		dev-util/vulkan-headers
	)
"
BDEPEND="
	>=dev-build/cmake-3.12
"
PDEPEND="
	~dev-python/ncnn-${PV}[${PYTHON_USEDEP},openmp?]
	dev-python/ncnn:=
"

DOCS=( "README.md" "docs/." )

pkg_pretend() {
	[[ "${MERGE_TYPE}" != "binary" ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ "${MERGE_TYPE}" != "binary" ]] && use openmp && tc-check-openmp
	python_setup
}

gen_git_tag() {
	local path="${1}"
	local tag_name="${2}"
einfo "Generating tag start for ${path}"
	pushd "${path}" >/dev/null 2>&1 || die
		git init || die
		git config user.email "name@example.com" || die
		git config user.name "John Doe" || die
		touch dummy || die
		git add dummy || die
		#git add -f * || die
		git commit -m "Dummy" || die
		git tag "${tag_name}" || die
	popd >/dev/null 2>&1 || die
einfo "Generating tag done"
}

src_unpack() {
	unpack ${A}

# Breaks during build.
#	dep_prepare_mv "${WORKDIR}/glslang-${GLSLANG_COMMIT}" "${S}/glslang"
#	dep_prepare_mv "${WORKDIR}/pybind11-${PYBIND11_COMMIT}" "${S}/python/pybind11"
#	gen_git_tag "${S}" "${PV}"
}

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	cflags-hardened_append
	mycmakeargs+=(
		-DGLSLANG_TARGET_DIR="${ESYSROOT}/usr/$(get_libdir)/cmake"
		-DNCNN_BUILD_EXAMPLES=$(usex examples)
		-DNCNN_BUILD_TOOLS=$(usex tools)
		-DNCNN_PYTHON=OFF
		-DNCNN_OPENMP=$(usex openmp)
		-DNCNN_SHARED_LIB=ON
		-DNCNN_SIMPLEVK=OFF
		-DNCNN_SYSTEM_GLSLANG=ON
		-DNCNN_VERSION="${PV}" # avoids libncnn.so.*.%Y%m%d using build date
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

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
}

pkg_postinst() {
	# TODO:  Add more orphaned packages or move into overlay's README.md
	optfeature_header "Install optional packages:"
	optfeature "From PyTorch or ONNX to ncnn model converter" "dev-util/pnnx"
}
