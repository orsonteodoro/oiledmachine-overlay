# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

CMAKE_MAKEFILE_GENERATOR="emake"
CXX_STANDARD=17
PYTHON_COMPAT=( "python3_12" )

BOOST_PV="1.86.0" # Aug 7, 2024
VULKAN_PV="1.3.275.0"

# Stable
GLSLANG_COMMIT_2="4420f9b33ba44928d5c82d9eae0c3bb4d5674c05" # Jul 26, 2023
LIBREALCUGAN_NCNN_VULKAN_COMMIT="d9c5a7eb4c8475af6110496c27c3d1f702f9b96a" # Jan 9, 2025
LIBREALESRGAN_NCNN_VULKAN_COMMIT="c1f255524f79566c40866b38e5e65b40adf77eee" # Jan 9, 2025
LIBRIFE_NCNN_VULKAN_COMMIT="3f7bcb44f38b2acda6fa5e575a6d12517ac16b94" # Jan 21, 2025
NCNN_COMMIT_4="528589571085b673be7313a9c6e65801f150f607" # Dec 25, 2024
PYBIND11_COMMIT_2="3e9dfa2866941655c56877882565e7577de6fc7b" # Mar 27, 2024
SPDLOG_COMMIT="8e5613379f5140fefb0b60412fbf1f5406e7c7f8" # Nov 9, 2024
VIDEO2K_COMMIT="a96bda9b4d79616cc6b71b94e6945146b5b4d509" # Jan 23, 2025, 6.4.0

BF16_ARCHES=(
	"armv8.4-a"
	"armv8.5-a"
	"armv8.6-a"
	"armv8.7-a"
	"armv8.8-a"
	"armv8.9-a"
	"armv9-a"
	"armv9.1-a"
	"armv9.2-a"
	"armv9.3-a"
	"armv9.4-a"
)

FP16_ARCHES=(
	"armv8.2-a"
	"armv8.3-a"
	"armv8.4-a"
	"armv8.5-a"
	"armv8.6-a"
	"armv8.7-a"
	"armv8.8-a"
	"armv8.9-a"
	"armv9-a"
	"armv9.1-a"
	"armv9.2-a"
	"armv9.3-a"
	"armv9.4-a"
)

FP16FML_ARCHES=(
	"armv8.2-a"
	"armv8.3-a"
	"armv8.4-a"
	"armv8.5-a"
	"armv8.6-a"
	"armv8.7-a"
	"armv8.8-a"
	"armv8.9-a"
	"armv9-a"
	"armv9.1-a"
	"armv9.2-a"
	"armv9.3-a"
	"armv9.4-a"
)

I8MM_ARCHES=(
	"armv8.4-a"
	"armv8.5-a"
	"armv8.6-a"
	"armv8.7-a"
	"armv8.8-a"
	"armv8.9-a"
	"armv9-a"
	"armv9.1-a"
	"armv9.2-a"
	"armv9.3-a"
	"armv9.4-a"
)

SVE_ARCHES=(
	"armv8.6-a"
	"armv8.7-a"
	"armv8.8-a"
	"armv8.9-a"
	"armv9-a"
	"armv9.1-a"
	"armv9.2-a"
	"armv9.3-a"
	"armv9.4-a"
)

CPU_FLAGS_ARM=(
	"cpu_flags_arm_bf16"
	"cpu_flags_arm_dotprod"
	"cpu_flags_arm_fp16"
	"cpu_flags_arm_fp16fml"
	"cpu_flags_arm_i8mm"
	"cpu_flags_arm_sve"
	"cpu_flags_arm_sve2"
	"cpu_flags_arm_svebf16"
	"cpu_flags_arm_svei8mm"
	"cpu_flags_arm_svef32mm"
	"cpu_flags_arm_vfpv4"
)

CPU_FLAGS_LOONG=(
	"cpu_flags_loong_lasx"
	"cpu_flags_loong_lsx"
	"cpu_flags_loong_mmi"
)

CPU_FLAGS_MIPS=(
	"cpu_flags_mips_msa"
)

CPU_FLAGS_PPC=(
	"cpu_flags_ppc_sse2"
	"cpu_flags_ppc_sse41"
)

CPU_FLAGS_RISCV=(
	"cpu_flags_riscv_v"
	"cpu_flags_riscv_xtheadvector"
	"cpu_flags_riscv_zfh"
	"cpu_flags_riscv_zvfh"
)

CPU_FLAGS_X86=(
	"cpu_flags_x86_avx"
	"cpu_flags_x86_avx2"
	"cpu_flags_x86_avxneconvert"
	"cpu_flags_x86_avxvnni"
	"cpu_flags_x86_avxvnniint8"
	"cpu_flags_x86_avxvnniint16"
	"cpu_flags_x86_avx512bw"
	"cpu_flags_x86_avx512cd"
	"cpu_flags_x86_avx512dq"
	"cpu_flags_x86_avx512f"
	"cpu_flags_x86_avx512bf16"
	"cpu_flags_x86_avx512fp16"
	"cpu_flags_x86_avx512vl"
	"cpu_flags_x86_avx512vnni"
	"cpu_flags_x86_f16c"
	"cpu_flags_x86_fma"
	"cpu_flags_x86_sse2"
	"cpu_flags_x86_xop"
)

inherit ffmpeg
FFMPEG_COMPAT_SLOTS=(
	"${FFMPEG_COMPAT_SLOTS_6[@]}"
)

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)
LIBSTDCXX_USEDEP_DEV="gcc_slot_skip(+)"

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)
LIBCXX_USEDEP_DEV="gcc_slot_skip(+)"

inherit check-compiler-switch cmake dep-prepare fix-rpath flag-o-matic libcxx-slot libstdcxx-slot optfeature python-single-r1 toolchain-funcs

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/k4yt3x/video2x.git"
	FALLBACK_COMMIT="${VIDEO2K_COMMIT}"
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://raw.githubusercontent.com/boostorg/boost/refs/tags/boost-${BOOST_PV}/CMakeLists.txt
	-> boost-${BOOST_PV}-CMakeLists.txt
https://archives.boost.io/release/${BOOST_PV}/source/boost_${BOOST_PV//./_}.tar.bz2

https://github.com/k4yt3x/librealcugan-ncnn-vulkan/archive/${LIBREALCUGAN_NCNN_VULKAN_COMMIT}.tar.gz
	-> librealcugan-ncnn-vulkan-${LIBREALCUGAN_NCNN_VULKAN_COMMIT:0:7}.tar.gz

https://github.com/k4yt3x/librealesrgan-ncnn-vulkan/archive/${LIBREALESRGAN_NCNN_VULKAN_COMMIT}.tar.gz
	-> librealesrgan-ncnn-vulkan-${LIBREALESRGAN_NCNN_VULKAN_COMMIT:0:7}.tar.gz
https://github.com/k4yt3x/librife-ncnn-vulkan/archive/${LIBRIFE_NCNN_VULKAN_COMMIT}.tar.gz
	-> librife-ncnn-vulkan-${LIBRIFE_NCNN_VULKAN_COMMIT:0:7}.tar.gz
https://github.com/k4yt3x/video2x/archive/${VIDEO2K_COMMIT}.tar.gz
	-> video2x-${VIDEO2K_COMMIT:0:7}.tar.gz
https://github.com/KhronosGroup/glslang/archive/${GLSLANG_COMMIT_2}.tar.gz
	-> glslang-${GLSLANG_COMMIT_2:0:7}.tar.gz
https://github.com/pybind/pybind11/archive/${PYBIND11_COMMIT_2}.tar.gz
	-> pybind11-${PYBIND11_COMMIT_2:0:7}.tar.gz
https://github.com/Tencent/ncnn/archive/${NCNN_COMMIT_4}.tar.gz
	-> ncnn-${NCNN_COMMIT_4:0:7}.tar.gz
https://github.com/gabime/spdlog/archive/${SPDLOG_COMMIT}.tar.gz
	-> spdlog-${SPDLOG_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="A machine learning based video super resolution and frame interpolation framework"
HOMEPAGE="
	https://github.com/k4yt3x/video2x-qt6
"
LICENSE="
	(
		Apache-2.0
		BSD
		BSD-2
		custom
		GPL-3-with-special-bison-exception
		MIT
	)
	(
		BSD
		BSD-2
		ZLIB
	)
	AGPL-3
	Boost-1.0
	BSD
	ISC
	MIT
"
# AGPL-3 - video2x
# Apache-2.0 BSD BSD-2 custom GPL-3-with-special-bison-exception MIT - glslang
# Boost-1.0 - boost
# BSD BSD-2 ZLIB - ncnn
# BSD - pybind11
# ISC - video2x-qt6
# MIT - librealesrgan-ncnn-vulkan
# MIT - librife-ncnn-vulkan
# MIT - spdlog
RESTRICT="mirror"
SLOT="0/stable"
IUSE+="
${CPU_FLAGS_ARM[@]}
${CPU_FLAGS_LOONG[@]}
${CPU_FLAGS_MIPS[@]}
${CPU_FLAGS_PPC[@]}
${CPU_FLAGS_RISCV[@]}
${CPU_FLAGS_X86[@]}
cli system-boost system-ncnn system-spdlog
ebuild_revision_18
"
# Using the vendored ncnn will break libplacebo.
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	system-ncnn
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
		cpu_flags_riscv_v
		cpu_flags_riscv_zfh
	)
	cpu_flags_x86_avx? (
		cpu_flags_x86_sse2
	)
	cpu_flags_x86_avx2? (
		cpu_flags_x86_avx
		cpu_flags_x86_fma
		cpu_flags_x86_f16c
	)
	cpu_flags_x86_fma? (
		cpu_flags_x86_f16c
	)
	cpu_flags_x86_f16c? (
		cpu_flags_x86_sse2
	)
	cpu_flags_x86_xop? (
		cpu_flags_x86_avx
	)

	cpu_flags_x86_avx512f? (
		cpu_flags_x86_avx2
	)
	cpu_flags_x86_avx512cd? (
		cpu_flags_x86_avx512f
	)
	cpu_flags_x86_avx512bw? (
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512vl
	)
	cpu_flags_x86_avx512dq? (
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512vl
	)
	cpu_flags_x86_avx512vl? (
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512dq
	)

	cpu_flags_x86_avx512vnni? (
		cpu_flags_x86_avx512bw
	)
	cpu_flags_x86_avx512bf16? (
		cpu_flags_x86_avx512bw
	)
	cpu_flags_x86_avx512fp16? (
		cpu_flags_x86_avx512bf16
	)

	cpu_flags_x86_avxvnni? (
		cpu_flags_x86_avx2
	)
	cpu_flags_x86_avxvnniint8? (
		cpu_flags_x86_avxvnni
	)
	cpu_flags_x86_avxneconvert? (
		cpu_flags_x86_avxvnniint8
	)
	cpu_flags_x86_avxvnniint16? (
		cpu_flags_x86_avxvnniint8
	)
"
RDEPEND+="
	>=dev-util/glslang-1.3.268.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	dev-util/glslang:=
	>=media-libs/vulkan-loader-${VULKAN_PV}
	media-libs/vulkan-drivers
	media-libs/libplacebo[${LIBCXX_USEDEP_DEV},${LIBSTDCXX_USEDEP_DEV},glslang,vulkan]
	media-libs/libplacebo:=
	system-boost? (
		>=dev-libs/boost-${BOOST_PV}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		dev-libs/boost:=
	)
	system-ncnn? (
		>=dev-libs/ncnn-20241226[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},openmp,vulkan]
		dev-libs/ncnn:=
	)
	system-spdlog? (
		>=dev-libs/spdlog-1.15.0
	)
	|| (
		media-video/ffmpeg:58.60.60[encode,libplacebo,vulkan,x264]
		media-video/ffmpeg:0/58.60.60[encode,libplacebo,vulkan,x264]
	)
	media-video/ffmpeg:=
"
DEPEND+="
	${RDEPEND}
	>=dev-util/vulkan-headers-${VULKAN_PV}
	dev-util/vulkan-headers:=
"
BDEPEND+="
	>=dev-build/cmake-3.14
	dev-vcs/git
	sys-devel/gcc[openmp]
	virtual/pkgconfig
"
DOCS=( "README.md" )
PATCHES=(
	"${FILESDIR}/${PN}-6.2.0-install-paths.patch"
	"${FILESDIR}/${PN}-6.2.0-ncnn-simd-options.patch"
)

gen_git_tag() {
	local path="${1}"
	local tag_name="${2}"
einfo "Generating tag start for ${path}"
	pushd "${path}" >/dev/null 2>&1 || die
		git init || die
		git config user.email "name@example.com" || die
		git config user.name "John Doe" || die
		touch "dummy" || die
		git add "dummy" || die
		#git add -f * || die
		git commit -m "Dummy" || die
		git tag "${tag_name}" || die
	popd >/dev/null 2>&1 || die
einfo "Generating tag done"
}

unpack_deps() {
	dep_prepare_mv "${WORKDIR}/video2x-${VIDEO2K_COMMIT}" "${S}"

#	dep_prepare_mv "${WORKDIR}/boost-${BOOST_COMMIT}" "${S}/third_party/boost"
#	dep_prepare_mv "${WORKDIR}/program_options-${BOOST_PROGRAM_OPTIONS_COMMIT}" "${S}/third_party/boost/libs/program_options"
	dep_prepare_mv "${WORKDIR}/boost_${BOOST_PV//./_}" "${S}/third_party/boost"
	cat "${DISTDIR}/boost-${BOOST_PV}-CMakeLists.txt" > "${S}/third_party/boost/CMakeLists.txt" || die

	dep_prepare_mv "${WORKDIR}/librealcugan-ncnn-vulkan-${LIBREALCUGAN_NCNN_VULKAN_COMMIT}" "${S}/third_party/librealcugan_ncnn_vulkan"
	dep_prepare_mv "${WORKDIR}/ncnn-${NCNN_COMMIT_4}" "${S}/third_party/librealcugan_ncnn_vulkan/src/ncnn"
	dep_prepare_cp "${WORKDIR}/glslang-${GLSLANG_COMMIT_2}" "${S}/third_party/librealcugan_ncnn_vulkan/src/ncnn/glslang"
	dep_prepare_cp "${WORKDIR}/pybind11-${PYBIND11_COMMIT_2}" "${S}/third_party/librealcugan_ncnn_vulkan/src/ncnn/python/pybind11"

	dep_prepare_mv "${WORKDIR}/librealesrgan-ncnn-vulkan-${LIBREALESRGAN_NCNN_VULKAN_COMMIT}" "${S}/third_party/librealesrgan_ncnn_vulkan"
	dep_prepare_mv "${WORKDIR}/ncnn-${NCNN_COMMIT_4}" "${S}/third_party/librealesrgan_ncnn_vulkan/src/ncnn"
	dep_prepare_mv "${WORKDIR}/glslang-${GLSLANG_COMMIT_2}" "${S}/third_party/librealesrgan_ncnn_vulkan/src/ncnn/glslang"
	dep_prepare_cp "${WORKDIR}/pybind11-${PYBIND11_COMMIT_2}" "${S}/third_party/librealesrgan_ncnn_vulkan/src/scnn/python/pybind11"

	dep_prepare_mv "${WORKDIR}/ncnn-${NCNN_COMMIT_4}" "${S}/third_party/ncnn"
	dep_prepare_mv "${WORKDIR}/glslang-${GLSLANG_COMMIT_2}" "${S}/third_party/ncnn/glslang"
	dep_prepare_mv "${WORKDIR}/pybind11-${PYBIND11_COMMIT_2}" "${S}/third_party/ncnn/python/pybind11"

	dep_prepare_mv "${WORKDIR}/librife-ncnn-vulkan-${LIBRIFE_NCNN_VULKAN_COMMIT}" "${S}/third_party/librife_ncnn_vulkan"
	dep_prepare_mv "${WORKDIR}/ncnn-${NCNN_COMMIT_4}" "${S}/third_party/librife_ncnn_vulkan/src/ncnn"
	dep_prepare_mv "${WORKDIR}/glslang-${GLSLANG_COMMIT_2}" "${S}/third_party/librife_ncnn_vulkan/src/ncnn/glslang"
	dep_prepare_cp "${WORKDIR}/pybind11-${PYBIND11_COMMIT_2}" "${S}/third_party/librife_ncnn_vulkan/src/ncnn/python/pybind11"

	dep_prepare_mv "${WORKDIR}/spdlog-${SPDLOG_COMMIT}" "${S}/third_party/spdlog"


	gen_git_tag "${S}" "${PV}"
}

pkg_setup() {
	check-compiler-switch_start
	python-single-r1_pkg_setup
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
# Debug
#		unpack "video2x-${VIDEO2K_COMMIT:0:7}.tar.gz"
#		die

		unpack ${A}

	einfo "Using stable deps"
		unpack_deps
	fi
}

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	# Force GCC to simplify openmp
	export CC="${CHOST}-gcc"
	export CXX="${CHOST}-g++"
	export CPP="${CHOST}-gcc -E"
	strip-unsupported-flags

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	export MAKEOPTS="-j1"

	append-flags "-DSPDLOG_NO_EXCEPTIONS"
	append-flags "-I${S}_build/libvideo2x_install/include"
	if ! use system-boost ; then
		append-flags "-I${S}/third_party/boost"
		fix-rpath_append "/usr/lib/${PN}/$(get_libdir)"
	fi

	local mycmakeargs=(
	)

	ffmpeg_src_configure # PKG_CONFIG_PATH set here if multislot found
	local ffmpeg_major_version=$(ffmpeg_get_major_version)
	local ffmpeg_slot=$(ffmpeg_get_slot)
	local ffmpeg_default_major_version="6"
	local ffmpeg_default_slot="58.60.60"
	if [[ -n "${ffmpeg_slot}" ]] && has_version "media-video/ffmpeg:${ffmpeg_slot}" ; then
einfo "Using media-video/ffmpeg:${ffmpeg_slot} (${ffmpeg_major_version}.x)"
		mycmakeargs+=(
			-DFFMPEG_USE_SLOTTED=ON
			-DFFMPEG_SLOTTED_PATH="/usr/lib/ffmpeg/${ffmpeg_slot}"
		)
	else
einfo "Using media-video/ffmpeg:0/${ffmpeg_default_slot} (${ffmpeg_default_major_version}.x)"
		export FFMPEG_LIBDIR=""
		mycmakeargs+=(
			-DFFMPEG_USE_SLOTTED=OFF
		)
	fi

	mycmakeargs+=(
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_VIDEO2X_CLI=$(usex cli)
		-DCMAKE_PREFIX_PATH="/usr/lib/video2x"
		-DCMAKE_MODULE_PATH="${S}/third_party/boost"
		-DUSE_SYSTEM_BOOST=$(usex system-boost)
		-DUSE_SYSTEM_NCNN=$(usex system-ncnn)
		-DUSE_SYSTEM_SPDLOG=$(usex system-spdlog)
		-DUSE_SYSTEM_GLSLANG=OFF
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
		-DNCNN_RVV=$(usex cpu_flags_riscv_v)
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
	for x in "${FP16_ARCHES[@]}" ; do
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
	for x in "${BF16_ARCHES[@]}" ; do
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
	for x in "${FP16_ARCHES[@]}" ; do
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
	for x in "${FP16FML_ARCHES[@]}" ; do
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
	for x in "${I8MM_ARCHES[@]}" ; do
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
	for x in "${SVE_ARCHES[@]}" ; do
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
	for x in "${SVE_ARCHES[@]}" ; do
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
	for x in "${SVE_ARCHES[@]}" ; do
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
	for x in "${SVE_ARCHES[@]}" ; do
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
	for x in "${SVE_ARCHES[@]}" ; do
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
	cmake_src_configure
}

src_install() {
	docinto "licenses"
	dodoc "LICENSE"
	cmake_src_install
	dodir "/usr/lib/${PN}/include"
	dodir "/usr/lib/${PN}/$(get_libdir)"
	cp -aT \
		"${S}_build/realesrgan_install/include" \
		"${ED}/usr/lib/${PN}/include" \
		|| die
	cp -aT \
		"${S}_build/realesrgan_install/lib" \
		"${ED}/usr/lib/${PN}/$(get_libdir)" \
		|| die
	sed -i \
		-e "s|/lib/|/$(get_libdir)/|g" \
		"${ED}/usr/lib/video2x/$(get_libdir)/cmake/realesrgan/realesrganTargets-relwithdebinfo.cmake" \
		|| die
	cp -aT \
		"${S}_build/rife_install/include" \
		"${ED}/usr/lib/${PN}/include" \
		|| die
	cp -aT \
		"${S}_build/rife_install/lib" \
		"${ED}/usr/lib/${PN}/$(get_libdir)" \
		|| die
	sed -i \
		-e "s|/lib/|/$(get_libdir)/|g" \
		"${ED}/usr/lib/video2x/$(get_libdir)/cmake/rife/rifeTargets-relwithdebinfo.cmake" \
		|| die
	rm -rf "${ED}/var" || die

	if ! use system-boost ; then
		exeinto "/usr/lib/${PN}/$(get_libdir)"
		IFS=$'\n'
		local x
		for x in $(find "${S}_build/third_party/boost/" -name "*.so*") ; do
			doexe "${x}"
		done
		IFS=$' \t\n'
	fi
}

pkg_postinst() {
	optfeature_header "Install optional packages:"
	optfeature "Qt6 GUI frontend" "media-video/video2x-qt6"
ewarn
ewarn "Some broken videos may need to be fixed first by manually encoding"
ewarn "as ffv1 in a mkv container before upscaling.  For examples, see"
ewarn "https://github.com/k4yt3x/video2x/issues/1222#issuecomment-2466489582"
ewarn
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED (6.2.0, 20241213)
# realesr-animevideov3 - passed
# realesrgan-plus - passed
# libplacebo - passed
