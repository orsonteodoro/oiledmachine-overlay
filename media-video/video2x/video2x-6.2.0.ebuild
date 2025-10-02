# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

CMAKE_MAKEFILE_GENERATOR="emake"

# Stable
BOOST_PV="1.86.0" # Aug 7, 2024
GLSLANG_COMMIT_1="4afd69177258d0636f78d2c4efb823ab6382a187" # Feb 9, 2021
GLSLANG_COMMIT_2="4420f9b33ba44928d5c82d9eae0c3bb4d5674c05" # Jul 26, 2023
GLSLANG_COMMIT_3="86ff4bca1ddc7e2262f119c16e7228d0efb67610" # May 20, 2024
LIBREALESRGAN_NCNN_VULKAN="cd68df6f98f036fcc9e7d63597ea6faa427c2d2d" # Oct 28, 2024
LIBRIFE_NCNN_VULKAN_COMMIT="f2edda49a5fd817a7137509e54e70d2e30d9b684" # Oct 28, 2024
NCNN_COMMIT_1="6125c9f47cd14b589de0521350668cf9d3d37e3c" # Apr 21, 2022
NCNN_COMMIT_2="9b5f6a39b4a4962accaad58caa771487f61f732a" # Sep 24, 2024
NCNN_COMMIT_3="b4ba207c18d3103d6df890c0e3a97b469b196b26" # Jul 28, 2022
PYBIND11_COMMIT_1="70a58c577eaf067748c2ec31bfd0b0a614cffba6" # Nov 22, 2021
PYBIND11_COMMIT_2="3e9dfa2866941655c56877882565e7577de6fc7b" # Mar 27, 2024
SPDLOG_COMMIT="e593f6695c6065e6b345fe2862f04a519ed484e0" # Sep 23, 2024
VIDEO2K_COMMIT="a6dfdc734328fda0f25b923e75f91fafc60d88ef" # Dec 11, 2024, 6.2.0

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
	"cpu_flags_riscv_rvv"
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

PYTHON_COMPAT=( "python3_12" )

inherit check-compiler-switch cmake dep-prepare flag-o-matic optfeature python-single-r1 toolchain-funcs

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
https://raw.githubusercontent.com/boostorg/boost/refs/tags/boost-1.86.0/CMakeLists.txt
	-> boost-${BOOST_PV}-CMakeLists.txt
https://archives.boost.io/release/${BOOST_PV}/source/boost_${BOOST_PV//./_}.tar.bz2
https://github.com/k4yt3x/librealesrgan-ncnn-vulkan/archive/${LIBREALESRGAN_NCNN_VULKAN}.tar.gz
	-> librealesrgan-ncnn-vulkan-${LIBREALESRGAN_NCNN_VULKAN:0:7}.tar.gz
https://github.com/k4yt3x/librife-ncnn-vulkan/archive/${LIBRIFE_NCNN_VULKAN_COMMIT}.tar.gz
	-> librife-ncnn-vulkan-${LIBRIFE_NCNN_VULKAN_COMMIT:0:7}.tar.gz
https://github.com/k4yt3x/video2x/archive/${VIDEO2K_COMMIT}.tar.gz
	-> video2x-${VIDEO2K_COMMIT:0:7}.tar.gz
https://github.com/KhronosGroup/glslang/archive/${GLSLANG_COMMIT_1}.tar.gz
	-> glslang-${GLSLANG_COMMIT_1:0:7}.tar.gz
https://github.com/KhronosGroup/glslang/archive/${GLSLANG_COMMIT_2}.tar.gz
	-> glslang-${GLSLANG_COMMIT_2:0:7}.tar.gz
https://github.com/KhronosGroup/glslang/archive/${GLSLANG_COMMIT_3}.tar.gz
	-> glslang-${GLSLANG_COMMIT_3:0:7}.tar.gz
https://github.com/pybind/pybind11/archive/${PYBIND11_COMMIT_1}.tar.gz
	-> pybind11-${PYBIND11_COMMIT_1:0:7}.tar.gz
https://github.com/pybind/pybind11/archive/${PYBIND11_COMMIT_2}.tar.gz
	-> pybind11-${PYBIND11_COMMIT_2:0:7}.tar.gz
https://github.com/Tencent/ncnn/archive/${NCNN_COMMIT_1}.tar.gz
	-> ncnn-${NCNN_COMMIT_1:0:7}.tar.gz
https://github.com/Tencent/ncnn/archive/${NCNN_COMMIT_2}.tar.gz
	-> ncnn-${NCNN_COMMIT_2:0:7}.tar.gz
https://github.com/Tencent/ncnn/archive/${NCNN_COMMIT_3}.tar.gz
	-> ncnn-${NCNN_COMMIT_3:0:7}.tar.gz
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
ebuild_revision_7
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
		cpu_flags_riscv_rvv
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
		cpu_flags_x86_avx
		cpu_flags_x86_f16c
	)
	cpu_flags_x86_f16c? (
		cpu_flags_x86_avx
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
	>=dev-util/glslang-1.3.268.0
	>=media-libs/vulkan-loader-1.3.275.0
	media-libs/vulkan-drivers
	media-libs/libplacebo[glslang,vulkan]
	system-boost? (
		>=dev-libs/boost-${BOOST_PV}
	)
	system-ncnn? (
		>=dev-libs/ncnn-20240924[openmp,vulkan]
	)
	system-spdlog? (
		>=dev-libs/spdlog-1.12.0
	)
	|| (
		media-video/ffmpeg:58.60.60[encode,libplacebo,vulkan,x264]
		media-video/ffmpeg:0/58.60.60[encode,libplacebo,vulkan,x264]
	)
	media-video/ffmpeg:=
"
DEPEND+="
	${RDEPEND}
	>=dev-util/vulkan-headers-1.3.275.0
"
BDEPEND+="
	>=dev-build/cmake-3.14
	dev-util/patchelf
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
		touch dummy || die
		git add dummy || die
		#git add -f * || die
		git commit -m "Dummy" || die
		git tag ${tag_name} || die
	popd >/dev/null 2>&1 || die
einfo "Generating tag done"
}

unpack_deps() {
	dep_prepare_mv "${WORKDIR}/video2x-${VIDEO2K_COMMIT}" "${S}"

#	dep_prepare_mv "${WORKDIR}/boost-${BOOST_COMMIT}" "${S}/third_party/boost"
#	dep_prepare_mv "${WORKDIR}/program_options-${BOOST_PROGRAM_OPTIONS_COMMIT}" "${S}/third_party/boost/libs/program_options"
	dep_prepare_mv "${WORKDIR}/boost_${BOOST_PV//./_}" "${S}/third_party/boost"
	cat "${DISTDIR}/boost-${BOOST_PV}-CMakeLists.txt" > "${S}/third_party/boost/CMakeLists.txt" || die

	dep_prepare_mv "${WORKDIR}/librealesrgan-ncnn-vulkan-${LIBREALESRGAN_NCNN_VULKAN}" "${S}/third_party/librealesrgan_ncnn_vulkan"
	dep_prepare_mv "${WORKDIR}/ncnn-${NCNN_COMMIT_1}" "${S}/third_party/librealesrgan_ncnn_vulkan/src/ncnn"
	dep_prepare_mv "${WORKDIR}/glslang-${GLSLANG_COMMIT_1}" "${S}/third_party/librealesrgan_ncnn_vulkan/src/ncnn/glslang"
	dep_prepare_cp "${WORKDIR}/pybind11-${PYBIND11_COMMIT_1}" "${S}/third_party/librealesrgan_ncnn_vulkan/src/scnn/python/pybind11"

	dep_prepare_mv "${WORKDIR}/ncnn-${NCNN_COMMIT_2}" "${S}/third_party/ncnn"
	dep_prepare_mv "${WORKDIR}/glslang-${GLSLANG_COMMIT_2}" "${S}/third_party/ncnn/glslang"
	dep_prepare_mv "${WORKDIR}/pybind11-${PYBIND11_COMMIT_2}" "${S}/third_party/ncnn/python/pybind11"

	dep_prepare_mv "${WORKDIR}/librife-ncnn-vulkan-${LIBRIFE_NCNN_VULKAN_COMMIT}" "${S}/third_party/librife_ncnn_vulkan"
	dep_prepare_mv "${WORKDIR}/ncnn-${NCNN_COMMIT_3}" "${S}/third_party/librife_ncnn_vulkan/src/ncnn"
	dep_prepare_mv "${WORKDIR}/glslang-${GLSLANG_COMMIT_3}" "${S}/third_party/librife_ncnn_vulkan/src/ncnn/glslang"
	dep_prepare_cp "${WORKDIR}/pybind11-${PYBIND11_COMMIT_1}" "${S}/third_party/librife_ncnn_vulkan/src/ncnn/python/pybind11"

	dep_prepare_mv "${WORKDIR}/spdlog-${SPDLOG_COMMIT}" "${S}/third_party/spdlog"


	gen_git_tag "${S}" "${PV}"
}

pkg_setup() {
	check-compiler-switch_start
	python-single-r1_pkg_setup
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

check_cxxabi() {
	local gcc_current_profile=$(gcc-config -c)
	local gcc_current_profile_slot=${gcc_current_profile##*-}
	local libstdcxx_cxxabi_ver=$(strings "/usr/lib/gcc/${CHOST}/${gcc_current_profile_slot}/libstdc++.so" \
		| grep CXXABI \
		| sort -V \
		| grep -E -e "CXXABI_[0-9]+" \
		| tail -n 1 \
		| cut -f 2 -d "_")
	local libstdcxx_glibcxx_ver=$(strings "/usr/lib/gcc/${CHOST}/${gcc_current_profile_slot}/libstdc++.so" \
		| grep GLIBCXX \
		| sort -V \
		| grep -E -e "GLIBCXX_[0-9]+" \
		| tail -n 1 \
		| cut -f 2 -d "_")
	local qt6core_cxxabi_ver=$(strings "/usr/lib64/libQt6Core.so" \
		| grep CXXABI \
		| sort -V \
		| grep -E -e "CXXABI_[0-9]+" \
		| tail -n 1 \
		| cut -f 2 -d "_")
	local qt6core_glibcxx_ver=$(strings "/usr/lib64/libQt6Core.so" \
		| grep GLIBCXX \
		| sort -V \
		| grep -E -e "GLIBCXX_[0-9]+" \
		| tail -n 1 \
		| cut -f 2 -d "_")
	if ver_test ${libstdcxx_cxxabi_ver} -lt ${qt6core_cxxabi_ver} ; then
eerror
eerror "Detected CXXABI missing symbol."
eerror
eerror "Ensure that the qt6core was build with the same gcc version as the"
eerror "currently selected compiler."
eerror
eerror "libstdcxx CXXABI  - ${libstdcxx_cxxabi_ver} (GCC slot ${gcc_current_profile_slot})"
eerror "libstdcxx GLIBCXX - ${libstdcxx_glibcxx_ver} (GCC slot ${gcc_current_profile_slot})"
eerror "qt6core CXXABI    - ${qt6core_cxxabi_ver}"
eerror "qt6core GLIBCXX   - ${qt6core_glibcxx_ver}"
eerror
eerror "See https://gcc.gnu.org/onlinedocs/libstdc++/manual/abi.html for details"
eerror
		die
	fi
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

	check_cxxabi

	append-flags -DSPDLOG_NO_EXCEPTIONS
	append-flags -I"${S}_build/libvideo2x_install/include"
	if ! use system-boost ; then
		append-flags -I"${S}/third_party/boost"
	fi

	local mycmakeargs=(
	)

	if has_version "media-video/ffmpeg:58.60.60" ; then
einfo "Using media-video/ffmpeg:58.60.60"
		export PKG_CONFIG_PATH="/usr/lib/ffmpeg/58.60.60/$(get_libdir)/pkgconfig:${PKG_CONFIG_PATH}"
		mycmakeargs+=(
			-DFFMPEG_USE_SLOTTED=ON
			-DFFMPEG_SLOTTED_PATH="/usr/lib/ffmpeg/58.60.60"
		)
	else
einfo "Using media-video/ffmpeg:0/58.60.60"
		export FFMPEG_LIBDIR=""
		mycmakeargs+=(
			-DFFMPEG_USE_SLOTTED=OFF
		)
	fi

	mycmakeargs+=(
		-DCMAKE_PREFIX_PATH="/usr/lib/ffmpeg/58.60.60"
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_VIDEO2X_CLI=$(usex cli)
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
	cmake_src_configure
}

src_install() {
	docinto "licenses"
	dodoc "LICENSE"
	cmake_src_install
	dodir "/usr/$(get_libdir)/${PN}/include"
	dodir "/usr/$(get_libdir)/${PN}/$(get_libdir)"
	cp -aT \
		"${S}_build/realesrgan_install/include" \
		"${ED}/usr/$(get_libdir)/${PN}/include" \
		|| die
	cp -aT \
		"${S}_build/realesrgan_install/lib" \
		"${ED}/usr/$(get_libdir)/${PN}/$(get_libdir)" \
		|| die
	sed -i \
		-e "s|/lib/|/$(get_libdir)/|g" \
		"${ED}/usr/$(get_libdir)/video2x/$(get_libdir)/cmake/realesrgan/realesrganTargets-relwithdebinfo.cmake" \
		|| die
	cp -aT \
		"${S}_build/rife_install/include" \
		"${ED}/usr/$(get_libdir)/${PN}/include" \
		|| die
	cp -aT \
		"${S}_build/rife_install/lib" \
		"${ED}/usr/$(get_libdir)/${PN}/$(get_libdir)" \
		|| die
	sed -i \
		-e "s|/lib/|/$(get_libdir)/|g" \
		"${ED}/usr/$(get_libdir)/video2x/$(get_libdir)/cmake/rife/rifeTargets-relwithdebinfo.cmake" \
		|| die
	rm -rf "${ED}/var" || die
	if has_version "media-video/ffmpeg:58.60.60" ; then
		patchelf \
			--add-rpath "/usr/lib/ffmpeg/58.60.60/$(get_libdir)" \
			"${ED}/usr/lib64/libvideo2x.so" \
			|| die
		if use cli ; then
			patchelf \
				--add-rpath "/usr/lib/ffmpeg/58.60.60/$(get_libdir)" \
				"${ED}/usr/bin/video2x" \
				|| die
		fi
	fi
	if ! use system-boost ; then
		exeinto "/usr/$(get_libdir)/${PN}/$(get_libdir)"
		IFS=$'\n'
		local x
		for x in $(find "${S}_build/third_party/boost/" -name "*.so*") ; do
			doexe "${x}"
		done
		IFS=$' \t\n'
		if use cli ; then
			patchelf \
				--add-rpath "/usr/$(get_libdir)/${PN}/$(get_libdir)" \
				"${ED}/usr/bin/video2x" \
				|| die
		fi
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
