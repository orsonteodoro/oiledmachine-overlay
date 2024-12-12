# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

CMAKE_MAKEFILE_GENERATOR="emake"

# Stable
BOOST_PV_STABLE="1.86.0"
GLSLANG_COMMIT_1_STABLE="4afd69177258d0636f78d2c4efb823ab6382a187"
GLSLANG_COMMIT_2_STABLE="4420f9b33ba44928d5c82d9eae0c3bb4d5674c05"
LIBREALESRGAN_NCNN_VULKAN_STABLE="cd68df6f98f036fcc9e7d63597ea6faa427c2d2d"
NCNN_COMMIT_1_STABLE="6125c9f47cd14b589de0521350668cf9d3d37e3c"
NCNN_COMMIT_2_STABLE="9b5f6a39b4a4962accaad58caa771487f61f732a"
OPENCV_COMMIT_STABLE="71d3237a093b60a27601c20e9ee6c3e52154e8b1"
PYBIND11_COMMIT_1_STABLE="70a58c577eaf067748c2ec31bfd0b0a614cffba6"
PYBIND11_COMMIT_2_STABLE="3e9dfa2866941655c56877882565e7577de6fc7b"
SPDLOG_COMMIT_STABLE="e593f6695c6065e6b345fe2862f04a519ed484e0"
VIDEO2K_COMMIT_STABLE="0d6a6abce20c5488280e98a54fc1ac25855e1ca3"

# Unstable
GLSLANG_COMMIT_1_UNSTABLE="4afd69177258d0636f78d2c4efb823ab6382a187"
GLSLANG_COMMIT_2_UNSTABLE="4420f9b33ba44928d5c82d9eae0c3bb4d5674c05"
LIBREALESRGAN_NCNN_VULKAN_UNSTABLE="790b1468acfcbfe6476febee9210cad7ba72e3f7"
NCNN_COMMIT_1_UNSTABLE="6125c9f47cd14b589de0521350668cf9d3d37e3c"
NCNN_COMMIT_2_UNSTABLE="9b5f6a39b4a4962accaad58caa771487f61f732a"
PYBIND11_COMMIT_1_UNSTABLE="70a58c577eaf067748c2ec31bfd0b0a614cffba6"
PYBIND11_COMMIT_2_UNSTABLE="3e9dfa2866941655c56877882565e7577de6fc7b"
VIDEO2K_COMMIT_UNSTABLE="56afd0e6292d89f7821a44bc6d7ea4841566cc56"

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

PYTHON_COMPAT=( "python3_12" )

inherit cmake dep-prepare flag-o-matic python-single-r1

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/k4yt3x/video2x-qt6.git"
	FALLBACK_COMMIT="abb3ee2ed71291ec3dbebc74d123279518cd634e" # Nov 7, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
#	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/k4yt3x/video2x-qt6/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
	stable-deps? (
https://archives.boost.io/release/${BOOST_PV_STABLE}/source/boost_${BOOST_PV_STABLE//./_}.tar.bz2
https://github.com/k4yt3x/librealesrgan-ncnn-vulkan/archive/${LIBREALESRGAN_NCNN_VULKAN_STABLE}.tar.gz
	-> librealesrgan-ncnn-vulkan-${LIBREALESRGAN_NCNN_VULKAN_STABLE:0:7}.tar.gz
https://github.com/k4yt3x/video2x/archive/${VIDEO2K_COMMIT_STABLE}.tar.gz
	-> video2x-${VIDEO2K_COMMIT_STABLE:0:7}.tar.gz
https://github.com/KhronosGroup/glslang/archive/${GLSLANG_COMMIT_1_STABLE}.tar.gz
	-> glslang-${GLSLANG_COMMIT_1_STABLE:0:7}.tar.gz
https://github.com/KhronosGroup/glslang/archive/${GLSLANG_COMMIT_2_STABLE}.tar.gz
	-> glslang-${GLSLANG_COMMIT_2_STABLE:0:7}.tar.gz
https://github.com/pybind/pybind11/archive/${PYBIND11_COMMIT_1_STABLE}.tar.gz
	-> pybind11-${PYBIND11_COMMIT_1_STABLE:0:7}.tar.gz
https://github.com/pybind/pybind11/archive/${PYBIND11_COMMIT_2_STABLE}.tar.gz
	-> pybind11-${PYBIND11_COMMIT_2_STABLE:0:7}.tar.gz
https://github.com/Tencent/ncnn/archive/${NCNN_COMMIT_2_STABLE}.tar.gz
	-> ncnn-${NCNN_COMMIT_2_STABLE:0:7}.tar.gz
https://github.com/Tencent/ncnn/archive/${NCNN_COMMIT_1_STABLE}.tar.gz
	-> ncnn-${NCNN_COMMIT_1_STABLE:0:7}.tar.gz
https://github.com/opencv/opencv/archive/${OPENCV_COMMIT_STABLE}.tar.gz
	-> opencv-${OPENCV_COMMIT_STABLE:0:7}.tar.gz
https://github.com/gabime/spdlog/archive/${SPDLOG_COMMIT_STABLE}.tar.gz
	-> spdlog-${SPDLOG_COMMIT_STABLE:0:7}.tar.gz
	)
	!stable-deps? (
https://github.com/k4yt3x/librealesrgan-ncnn-vulkan/archive/${LIBREALESRGAN_NCNN_VULKAN_UNSTABLE}.tar.gz
	-> librealesrgan-ncnn-vulkan-${LIBREALESRGAN_NCNN_VULKAN_UNSTABLE:0:7}.tar.gz
https://github.com/k4yt3x/video2x/archive/${VIDEO2K_COMMIT_UNSTABLE}.tar.gz
	-> video2x-${VIDEO2K_COMMIT_UNSTABLE:0:7}.tar.gz
https://github.com/KhronosGroup/glslang/archive/${GLSLANG_COMMIT_1_UNSTABLE}.tar.gz
	-> glslang-${GLSLANG_COMMIT_1_UNSTABLE:0:7}.tar.gz
https://github.com/KhronosGroup/glslang/archive/${GLSLANG_COMMIT_2_UNSTABLE}.tar.gz
	-> glslang-${GLSLANG_COMMIT_2_UNSTABLE:0:7}.tar.gz
https://github.com/pybind/pybind11/archive/${PYBIND11_COMMIT_1_UNSTABLE}.tar.gz
	-> pybind11-${PYBIND11_COMMIT_1_UNSTABLE:0:7}.tar.gz
https://github.com/pybind/pybind11/archive/${PYBIND11_COMMIT_2_UNSTABLE}.tar.gz
	-> pybind11-${PYBIND11_COMMIT_2_UNSTABLE:0:7}.tar.gz
https://github.com/Tencent/ncnn/archive/${NCNN_COMMIT_2_UNSTABLE}.tar.gz
	-> ncnn-${NCNN_COMMIT_2_UNSTABLE:0:7}.tar.gz
https://github.com/Tencent/ncnn/archive/${NCNN_COMMIT_1_UNSTABLE}.tar.gz
	-> ncnn-${NCNN_COMMIT_1_UNSTABLE:0:7}.tar.gz
	)
	"
fi

DESCRIPTION="An AI video upscaler with a graphical user friendly Qt6 frontend"
HOMEPAGE="
	https://github.com/k4yt3x/video2x-qt6
"
LICENSE="
	(
		BSD
		BSD-2
		ZLIB
	)
	(
		Apache-2.0
		BSD
		BSD-2
		custom
		GPL-3-with-special-bison-exception
		MIT
	)
	AGPL-3
	BSD
	ISC
	MIT
"
# ISC video2x-qt6
# AGPL-3 - video2x
# Apache-2.0 BSD BSD-2 custom GPL-3-with-special-bison-exception MIT - glslang
# BSD BSD-2 ZLIB - ncnn
# BSD - pybind11
# MIT - librealesrgan-ncnn-vulkan
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
${CPU_FLAGS_ARM[@]}
${CPU_FLAGS_LOONG[@]}
${CPU_FLAGS_MIPS[@]}
${CPU_FLAGS_PPC[@]}
${CPU_FLAGS_RISCV[@]}
${CPU_FLAGS_X86[@]}
-stable-deps -system-ncnn wayland X
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
	|| (
		wayland
		X
	)
"
RDEPEND+="
	!media-video/video2x
	>=dev-libs/spdlog-1.12.0
	>=media-libs/vulkan-loader-1.3.275.0
	dev-qt/qttools:6[linguist]
	dev-qt/qttools:=
	dev-qt/qtbase:6[gui,widgets,wayland?,X?]
	dev-qt/qtbase:=
	media-libs/libplacebo[glslang,vulkan]
	system-ncnn? (
		>=dev-libs/ncnn-20240924[openmp,vulkan]
	)
	|| (
		media-video/ffmpeg:58.60.60[libplacebo,vulkan,x264]
		media-video/ffmpeg:0/58.60.60[libplacebo,vulkan,x264]
	)
	media-video/ffmpeg:=
"
DEPEND+="
	${RDEPEND}
	>=dev-util/vulkan-headers-1.3.275.0
"
BDEPEND+="
	>=dev-build/cmake-3.14
	sys-devel/gcc[openmp]
	virtual/pkgconfig
"
#	[${PYTHON_USEDEP}]
DOCS=( "README.md" )

gen_git_tag() {
	local path="${1}"
	local tag_name="${2}"
einfo "Generating tag start for ${path}"
	pushd "${path}" >/dev/null 2>&1 || die
		git init || die
		git config user.email "name@example.com" || die
		git config user.name "John Doe" || die
		git add -f * || die
		git commit -m "Dummy" || die
		git tag ${tag_name} || die
	popd >/dev/null 2>&1 || die
einfo "Generating tag done"
}

unpack_stable_deps() {
	dep_prepare_mv "${WORKDIR}/video2x-${VIDEO2K_COMMIT_STABLE}" "${S}/third_party/video2x"

	dep_prepare_mv "${WORKDIR}/boost_${BOOST_PV_STABLE//./_}" "${S}/third_party/video2x/third_party/boost"

	dep_prepare_mv "${WORKDIR}/librealesrgan-ncnn-vulkan-${LIBREALESRGAN_NCNN_VULKAN_STABLE}" "${S}/third_party/video2x/third_party/librealesrgan_ncnn_vulkan"
	dep_prepare_mv "${WORKDIR}/ncnn-${NCNN_COMMIT_1_STABLE}" "${S}/third_party/video2x/third_party/librealesrgan_ncnn_vulkan/src/ncnn"
	dep_prepare_mv "${WORKDIR}/glslang-${GLSLANG_COMMIT_1_STABLE}" "${S}/third_party/video2x/third_party/librealesrgan_ncnn_vulkan/src/ncnn/glslang"
	dep_prepare_mv "${WORKDIR}/pybind11-${PYBIND11_COMMIT_1_STABLE}" "${S}/third_party/video2x/third_party/librealesrgan_ncnn_vulkan/src/scnn/python/pybind11"

	dep_prepare_mv "${WORKDIR}/ncnn-${NCNN_COMMIT_2_STABLE}" "${S}/third_party/video2x/third_party/ncnn"
	dep_prepare_mv "${WORKDIR}/glslang-${GLSLANG_COMMIT_2_STABLE}" "${S}/third_party/video2x/third_party/ncnn/glslang"
	dep_prepare_mv "${WORKDIR}/pybind11-${PYBIND11_COMMIT_2_STABLE}" "${S}/third_party/video2x/third_party/ncnn/python/pybind11"

	dep_prepare_mv "${WORKDIR}/opencv-${OPENCV_COMMIT_STABLE}" "${S}/third_party/video2x/third_party/opencv"

	dep_prepare_mv "${WORKDIR}/spdlog-${SPDLOG_COMMIT_STABLE}" "${S}/third_party/video2x/third_party/spdlog"

	gen_git_tag "${S}" "${PV}"
#	gen_git_tag "${S}/third_party/video2x" "${PV}"
#	gen_git_tag "${S}/third_party/video2x/third_party/librealesrgan_ncnn_vulkan/src/ncnn" "20241028"
#	gen_git_tag "${S}/third_party/video2x/third_party/ncnn" "20240924"
}

unpack_unstable_deps() {
	dep_prepare_mv "${WORKDIR}/video2x-${VIDEO2K_COMMIT_UNSTABLE}" "${S}/third_party/video2x"

	dep_prepare_mv "${WORKDIR}/librealesrgan-ncnn-vulkan-${LIBREALESRGAN_NCNN_VULKAN_UNSTABLE}" "${S}/third_party/video2x/third_party/libreal_esrgan_ncnn_vulkan"
	dep_prepare_mv "${WORKDIR}/ncnn-${NCNN_COMMIT_1_UNSTABLE}" "${S}/third_party/video2x/third_party/libreal_esrgan_ncnn_vulkan/src/ncnn"
	dep_prepare_mv "${WORKDIR}/glslang-${GLSLANG_COMMIT_1_UNSTABLE}" "${S}/third_party/video2x/third_party/libreal_esrgan_ncnn_vulkan/src/ncnn/glslang"
	dep_prepare_mv "${WORKDIR}/pybind11-${PYBIND11_COMMIT_1_UNSTABLE}" "${S}/third_party/video2x/third_party/libreal_esrgan_ncnn_vulkan/src/scnn/python/pybind11"

	dep_prepare_mv "${WORKDIR}/ncnn-${NCNN_COMMIT_2_UNSTABLE}" "${S}/third_party/video2x/third_party/ncnn"
	dep_prepare_mv "${WORKDIR}/glslang-${GLSLANG_COMMIT_2_UNSTABLE}" "${S}/third_party/video2x/third_party/ncnn/glslang"
	dep_prepare_mv "${WORKDIR}/pybind11-${PYBIND11_COMMIT_2_UNSTABLE}" "${S}/third_party/video2x/third_party/ncnn/python/pybind11"

	gen_git_tag "${S}" "${PV}"
#	gen_git_tag "${S}/third_party/video2x" "6.0.0-beta.1" # placeholder
#	gen_git_tag "${S}/third_party/video2x/third_party/libreal_esrgan_ncnn_vulkan/src/ncnn" "20220421"
#	gen_git_tag "${S}/third_party/video2x/third_party/ncnn" "20240924"
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}

		if use stable-deps ; then
			unpack_stable_deps
		else
			unpack_unstable_deps
		fi
	fi
}

src_configure() {
	# Force GCC to simplify openmp
	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
	export CPP="${CHOST}-gcc -E"
	strip-unsupported-flags

	if use stable-deps ; then
		append-flags -DSPDLOG_NO_EXCEPTIONS
		append-flags -I"${S}_build/libvideo2x_install/include"
	fi

	if has_version "media-video/ffmpeg:58.60.60" ; then
einfo "Using media-video/ffmpeg:58.60.60"
		PKG_CONFIG_PATH="/usr/lib/ffmpeg/58.60.60/$(get_libdir)/pkgconfig:${PKG_CONFIG_PATH}"
	else
einfo "Using media-video/ffmpeg:0/58.60.60"
	fi

	local mycmakeargs=(
		-DUSE_SYSTEM_NCNN=$(usex system-ncnn)
		-DNCNN_AVX=$(usex cpu_flags_x86_avx)
		-DNCNN_AVX2=$(usex cpu_flags_x86_avx2)
		-DNCNN_AVXNECONVERT=$(usex cpu_flags_x86_avxneconvert)
		-DNCNN_AVXVNNI=$(usex cpu_flags_x86_avxvnni)
		-DNCNN_AVXVNNIINT8=$(usex cpu_flags_x86_avxvnniint8)
		-DNCNN_AVXVNNIINT16=$(usex cpu_flags_x86_avxvnniint16)
		-DNCNN_AVX512BF16=$(usex cpu_flags_x86_avx512bf16)
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
		mycmakeargs=(
			-DNCNN_ARM82=ON
		)
	else
		mycmakeargs=(
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
		mycmakeargs=(
			-DNCNN_ARM84BF16=ON
		)
	else
		mycmakeargs=(
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
		mycmakeargs=(
			-DNCNN_ARM82DOT=ON
		)
	else
		mycmakeargs=(
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
		mycmakeargs=(
			-DNCNN_ARM82FP16FML=ON
		)
	else
		mycmakeargs=(
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
		mycmakeargs=(
			-DNCNN_ARM84I8MM=ON
		)
	else
		mycmakeargs=(
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
		mycmakeargs=(
			-DNCNN_ARM86SVE=ON
		)
	else
		mycmakeargs=(
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
		mycmakeargs=(
			-DNCNN_ARM86SVE2=ON
		)
	else
		mycmakeargs=(
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
		mycmakeargs=(
			-DNCNN_ARM86SVEBF16=ON
		)
	else
		mycmakeargs=(
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
		mycmakeargs=(
			-DNCNN_ARM86SVEI8MM=ON
		)
	else
		mycmakeargs=(
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
		mycmakeargs=(
			-DNCNN_ARM86SVEF32MM=ON
		)
	else
		mycmakeargs=(
			-DNCNN_ARM86SVEF32MM=OFF
		)
	fi

	cmake_src_configure
}

src_install() {
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
