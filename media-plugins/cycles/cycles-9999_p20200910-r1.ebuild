# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Cycles is a ray tracing renderer focused on interactivity and \
ease of use, while still supporting many production features."
HOMEPAGE="https://developer.blender.org/tag/cycles/"
KEYWORDS="amd64 ~x86"
LICENSE="Apache-2.0
	 Boost-1.0
	 BSD
	 MIT"
CXXABI_V=11
LLVM_V=10
LLVM_MAX_SLOT=${LLVM_V}
SLOT="0/${PV}"
RESTRICT="fetch mirror"
X86_CPU_FLAGS=( mmx:mmx sse:sse sse2:sse2 sse3:sse3 ssse3:ssse3 sse4_1:sse4_1 \
sse4_2:sse4_2 avx:avx avx2:avx2 fma:fma lzcnt:lzcnt bmi:bmi f16c:f16c )
CPU_FLAGS=( ${X86_CPU_FLAGS[@]/#/cpu_flags_x86_} )
PYTHON_COMPAT=( python3_{7,8} )
inherit llvm python-single-r1
IUSE=" ${CPU_FLAGS[@]%:*}"
IUSE="${IUSE/cpu_flags_x86_mmx/+cpu_flags_x86_mmx}"
IUSE="${IUSE/cpu_flags_x86_sse /+cpu_flags_x86_sse }"
IUSE="${IUSE/cpu_flags_x86_sse2/+cpu_flags_x86_sse2}"
IUSE+=" abi7-compat asan +color-management cpudetection cuda -debug +embree \
+gui -network nvcc nvrtc opencl +openimagedenoise +opensubdiv +openvdb optix \
+osl"
# Same dependency versions as Blender 2.90.0
EGIT_COMMIT="3738dbe4c64a391bef4951c08965d144203f3892"
RDEPEND="${PYTHON_DEPS}
	>=dev-lang/python-3.7.7
	color-management? ( >=media-libs/opencolorio-1.1.1 )
	cuda? ( >=x11-drivers/nvidia-drivers-418.39
		 >=dev-util/nvidia-cuda-toolkit-10.1:= )
	>=dev-libs/boost-1.70[threads(+)]
	>=dev-libs/pugixml-1.10
	embree? ( >=media-libs/embree-3.10.0:=\
[cpu_flags_x86_sse4_2?,cpu_flags_x86_avx?,cpu_flags_x86_avx2?,static-libs] )
	>=media-libs/mesa-20.0.6:=
	>=media-libs/glew-1.13.0
	>=media-libs/openimageio-2.1.15.0
	openimagedenoise? ( >=media-libs/oidn-1.2.1 )
	opensubdiv? ( >=media-libs/opensubdiv-3.4.3[cuda=,opencl=] )
	openvdb? (
		>=media-gfx/openvdb-7[${PYTHON_SINGLE_USEDEP},abi7-compat(+)]
		>=dev-cpp/tbb-2019.9
		>=dev-libs/c-blosc-1.5.0
	)
	optix? ( >=dev-libs/optix-7 )
	osl? ( >=media-libs/osl-1.10.10:=[static-libs] )
	virtual/opencl"
DEPEND="${RDEPEND}
	asan? ( || ( sys-devel/clang
		     sys-devel/gcc ) )
	x86? ( || (
		sys-devel/clang
		dev-lang/icc
	) )"
# OpenVDB is disabled until multiple LLVMs problem is resolved for standalone cycles.
REQUIRED_USE=" ${PYTHON_REQUIRED_USE}
	amd64? ( cpu_flags_x86_sse2 )
	x86? ( cpu_flags_x86_sse2 )
	cpu_flags_x86_sse? ( cpu_flags_x86_sse2 )
	cpu_flags_x86_sse2? ( cpu_flags_x86_sse )
	cpudetection? (
		cpu_flags_x86_avx? ( cpu_flags_x86_sse )
		cpu_flags_x86_avx2? ( cpu_flags_x86_sse )
	)
	!cpudetection? (
		amd64? (
			cpu_flags_x86_sse4_1? ( cpu_flags_x86_sse3 )
			cpu_flags_x86_avx? ( cpu_flags_x86_sse4_1 )
			cpu_flags_x86_avx2? ( cpu_flags_x86_avx
						cpu_flags_x86_sse4_1
						cpu_flags_x86_fma
						cpu_flags_x86_lzcnt
						cpu_flags_x86_bmi
						cpu_flags_x86_f16c )
		)
		cpu_flags_x86_sse3? ( cpu_flags_x86_sse2
					cpu_flags_x86_ssse3 )
		cpu_flags_x86_ssse3? ( cpu_flags_x86_sse3 )
	)
	cuda? ( ^^ ( nvcc nvrtc ) )
	nvcc? ( || ( cuda optix ) )
	nvrtc? ( || ( cuda optix ) )
	optix? ( cuda nvcc )"
EGIT_REPO_URI="git://git.blender.org/cycles.git"
EGIT_COMMIT="${EGIT_COMMIT}"
CMAKE_MAKEFILE_GENERATOR="ninja"
CMAKE_BUILD_TYPE="Release"
inherit cmake-utils desktop git-r3 xdg
SRC_URI=""
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"
PATCHES=(
	"${FILESDIR}/cycles-1.11.0-network-fixes.patch"
	"${FILESDIR}/cycles-1.11.0-device_network_h-fixes.patch"
	"${FILESDIR}/cycles-1.11.0-device_network_h-add-device-header.patch"
	"${FILESDIR}/cycles-1.11.0-update-acquire_tile-for-cycles-networking.patch"
	"${FILESDIR}/cycles-1.11.0-change-prefix-install.patch"
)

pkg_setup() {
	llvm_pkg_setup
	python-single-r1_pkg_setup
	export OPENVDB_V=$(usex openvdb 7 "")
	export OPENVDB_V_DIR=$(usex openvdb 7-14 "")

	grep -q -i -E -e 'abm( |$)' /proc/cpuinfo
	local has_abm="$?"
	grep -q -i -E -e 'bmi1( |$)' /proc/cpuinfo
	local has_bmi1="$?"
	grep -q -i -E -e 'f16c( |$)' /proc/cpuinfo
	local has_f16c="$?"
	grep -q -i -E -e 'fma( |$)' /proc/cpuinfo
	local has_fma="$?"
	grep -q -i -E -e 'ssse3( |$)' /proc/cpuinfo
	local has_ssse3="$?"

	# For tzcnt
	if use cpu_flags_x86_bmi ; then
		if [[ "${has_bmi1}" != "0" ]] ; then
			ewarn \
"bmi may not be supported on your CPU and was enabled via cpu_flags_x86_bmi"
		fi
	fi

	if use cpu_flags_x86_f16c ; then
		if [[ "${has_f16c}" != "0" ]] ; then
			ewarn \
"f16c may not be supported on your CPU and was enabled via cpu_flags_x86_f16c"
		fi
	fi

	if use cpu_flags_x86_fma ; then
		if [[ "${has_fma}" != "0" ]] ; then
			ewarn \
"fma may not be supported on your CPU and was enabled via cpu_flags_x86_fma"
		fi
	fi

	if use cpu_flags_x86_lzcnt ; then
		if [[ "${has_bmi1}" != "0" && "${has_abm}" != "0" ]] ; then
			ewarn \
"lzcnt may not be supported on your CPU and was enabled via cpu_flags_x86_lzcnt"
		fi
	fi

	if use cpu_flags_x86_ssse3 ; then
		if [[ "${has_ssse3}" != "0" ]] ; then
			ewarn \
"ssse3 may not be supported on your CPU and was enabled via cpu_flags_x86_ssse3"
		fi
	fi

	if [[ "${ABI}" == "x86" ]] ; then
		# Cycles says that a bug might be in in gcc so use clang or icc.
		# If you use gcc, it will not optimize cycles except with maybe sse2.
		if [[ -n "${BLENDER_CC_ALT}" && -n "${BLENDER_CXX_ALT}" ]] ; then
			export CC=${BLENDER_CC_ALT}
			export CXX=${BLENDER_CXX_ALT}
		elif [[ -n "${CC}" && -n "${CXX}" ]] \
			&& [[ ! ( "${CC}" =~ gcc ) ]] \
			&& [[ ! ( "${CXX}" =~ "g++" ) ]] ; then
			# Defined by user from per-package environmental variables.
			export CC
			export CXX
		elif has_version 'sys-devel/clang' ; then
			export CC=clang
			export CXX=clang++
		elif has_version 'dev-lang/icc' ; then
			export CC=icc
			export CXX=icpc
		fi
	else
		if [[ ! -n "${CC}" || ! -n "${CXX}" ]] ; then
			export CC=$(tc-getCC $(get_abi_CHOST "${ABI}"))
			export CXX=$(tc-getCXX $(get_abi_CHOST "${ABI}"))
		fi
	fi

	einfo "CC=${CC}"
	einfo "CXX=${CXX}"

	# Checks to avoid loading multiple versions of LLVM.

	if ls ldd "${EROOT}"/usr/$(get_libdir)/dri/*.so 2>/dev/null 1>/dev/null ; then
		local llvm_ret=$(ldd "${EROOT}"/usr/$(get_libdir)/dri/*.so \
			| grep -q -e "LLVM-${LLVM_V}")
		if [[ "${llvm_ret}" != "0" ]] ; then
			die \
"You need link media-libs/mesa with LLVM ${LLVM_V}.  See media-libs/mesa \
ebuilds for compatibility details."
		fi
	fi

	if use osl && [[ -e "/usr/$(get_libdir)/liboslexec.so" ]] ; then
		osl_llvm=
		if ldd /usr/$(get_libdir)/liboslexec.so \
			| grep -q -F "libLLVMAnalysis.so.9" ; then
			# split llvm
			osl_llvm=9
		else
			# monolithic llvm
			osl_llvm=$(ldd /usr/$(get_libdir)/liboslexec.so \
				| grep -F -i -e "LLVM" | head -n 1 \
				| grep -o -E -e "libLLVM-[0-9]+.so" \
				| head -n 1 | grep -o -E -e "[0-9]+")
		fi
		if [[ -n "${osl_llvm}" ]] \
			&& ver_test "${osl_llvm}" -ne "${LLVM_V}" ; then
			die "media-libs/osl must be linked to LLVM ${LLVM_V}"
		fi
	fi
}

src_unpack() {
	git-r3_fetch
	git-r3_checkout
}

src_prepare() {
	local jobs=$(echo "${MAKEOPTS}" | grep -P -o -e "(-j|--jobs=)\s*[0-9]+" \
			| sed -r -e "s#(-j|--jobs=)\s*##g")
	local cores=$(nproc)
	if (( ${jobs} > $((${cores}/2)) )) ; then
		ewarn \
"${PN} may lock up or freeze the computer if the N value in MAKEOPTS=\"-jN\" \
is greater than \$(nproc)/2"
	fi

	cmake-utils_src_prepare
	if use network ; then
		ewarn \
"Cycles Networking support does not work at all even for CPU rendering.  For \
ebuild/upstream developers only."
	fi

	sed -i -e "s|bf_intern_glew_mx|bf_intern_glew_mx \${GLEW_LIBRARY}|g" \
		src/app/CMakeLists.txt || die

}

src_configure() {
	append-cppflags -DOPENVDB_ABI_VERSION_NUMBER=${OPENVDB_V}

	if ! has_version 'media-libs/embree[cpu_flags_x86_avx]' ; then
		sed -i -e "/embree_avx/d" \
			src/cmake/Modules/FindEmbree.cmake || die
	fi

	if ! has_version 'media-libs/embree[cpu_flags_x86_avx2]' ; then
		sed -i -e "/embree_avx2/d" \
			src/cmake/Modules/FindEmbree.cmake || die
	fi

	if ! has_version 'media-libs/embree[cpu_flags_x86_sse4_2]' ; then
		sed -i -e "/embree_sse42/d" \
			src/cmake/Modules/FindEmbree.cmake || die
	fi

	if ! use cpudetection ; then
		if use cpu_flags_x86_sse ; then
			# clang / gcc
			sed -i -e "s|check_cxx_compiler_flag(-msse CXX_HAS_SSE)|set(CXX_HAS_SSE TRUE)|g" \
				src/CMakeLists.txt || die
			# icc
			sed -i -e "s|check_cxx_compiler_flag(-xsse2 CXX_HAS_SSE)|set(CXX_HAS_SSE TRUE)|g" \
				src/CMakeLists.txt || die
		else
			# clang / gcc
			sed -i -e "s|check_cxx_compiler_flag(-msse CXX_HAS_SSE)|set(CXX_HAS_SSE FALSE)|g" \
				src/CMakeLists.txt || die
			# icc
			sed -i -e "s|check_cxx_compiler_flag(-xsse2 CXX_HAS_SSE)|set(CXX_HAS_SSE FALSE)|g" \
				src/CMakeLists.txt || die
		fi

		if ! use cpu_flags_x86_sse2 ; then
			sed -i -e "/WITH_KERNEL_SSE2/d" \
				src/CMakeLists.txt || die
		fi

		if ! use cpu_flags_x86_sse3 ; then
			sed -i -e "/WITH_KERNEL_SSE3/d" \
				src/CMakeLists.txt || die
		fi

		if ! use cpu_flags_x86_sse4_1 ; then
			sed -i -e "/WITH_KERNEL_SSE41/d" \
				src/CMakeLists.txt || die
		fi

		if use cpu_flags_x86_avx ; then
			# clang / gcc
			sed -i -e "s|check_cxx_compiler_flag(-mavx CXX_HAS_AVX)|set(CXX_HAS_AVX TRUE)|g" \
				src/CMakeLists.txt || die
			# icc
			sed -i -e "s|check_cxx_compiler_flag(-xavx CXX_HAS_AVX)|set(CXX_HAS_AVX TRUE)|g" \
				src/CMakeLists.txt || die
		else
			# clang / gcc
			sed -i -e "s|check_cxx_compiler_flag(-mavx CXX_HAS_AVX)|set(CXX_HAS_AVX FALSE)|g" \
				src/CMakeLists.txt || die
			# icc
			sed -i -e "s|check_cxx_compiler_flag(-xavx CXX_HAS_AVX)|set(CXX_HAS_AVX FALSE)|g" \
				src/CMakeLists.txt || die
		fi

		if use cpu_flags_x86_avx2 ; then
			# clang / gcc
			sed -i -e "s|check_cxx_compiler_flag(-mavx2 CXX_HAS_AVX2)|set(CXX_HAS_AVX2 TRUE)|g" \
				src/CMakeLists.txt || die
			# icc
			sed -i -e "s|check_cxx_compiler_flag(-xcore-avx2 CXX_HAS_AVX2)|set(CXX_HAS_AVX2 TRUE)|g" \
				src/CMakeLists.txt || die
		else
			# clang / gcc
			sed -i -e "s|check_cxx_compiler_flag(-mavx2 CXX_HAS_AVX2)|set(CXX_HAS_AVX2 FALSE)|g" \
				src/CMakeLists.txt || die
			# icc
			sed -i -e "s|check_cxx_compiler_flag(-xcore-avx2 CXX_HAS_AVX2)|set(CXX_HAS_AVX2 FALSE)|g" \
				src/CMakeLists.txt || die
		fi

		if [[ "${ABI}" == "x86" ]] && grep -q -F -e "WITH_KERNEL_SSE41" src/CMakeLists.txt ; then
			# See intern/cycles/util/util_optimization.h for reason why it was axed in x86 (32-bit).
			sed -i -e "/WITH_KERNEL_SSE41/d" \
				src/CMakeLists.txt || die
		fi

		# No instructions present
		sed -i -e "s|-mbmi2||g" \
			src/CMakeLists.txt || die
	fi

	# The avx2 config in CMakeLists.txt already sets this.
	if tc-is-gcc || tc-is-clang ; then
		if ! use cpudetection && ! use cpu_flags_x86_avx2 ; then
			if use cpu_flags_x86_bmi ; then
				# bmi1 only, tzcnt
				if [[ "${CXXFLAGS}" =~ march=(\
native|\
\
haswell|broadwell|skylake|knl|knm|skylake-avx512|cannonlake|icelake-client|\
icelake-server|cascadelake|cooperlake|tigerlake|sapphirerapids|\
\
bdver2|bdver3|bdver4|znver1|znver2|btver2) ]] \
				|| [[ "${CXXFLAGS}" =~ mbmi( |$) ]] ; then
					# Already added
					:;
				else
					append-cxxflags -mbmi
				fi
			else
				append-cxxflags -mno-bmi
			fi
			if use cpu_flags_x86_lzcnt ; then
				# intel puts lzcnt in bmi1
				# amd puts lzcnt in abm
				if [[ "${CXXFLAGS}" =~ march=(\
native|\
\
haswell|broadwell|skylake|knl|knm|skylake-avx512|cannonlake|icelake-client|\
icelake-server|cascadelake|cooperlake|tigerlake|sapphirerapids|\
\
amdfam10|barcelona|bdver1|bdver2|bdver3|bdver4|znver1|znver2|btver1|btver2) ]] \
				|| [[ "${CXXFLAGS}" =~ mlzcnt ]] ; then
					# Already added
					:;
				else
					append-cxxflags -mlzcnt
				fi
			else
				append-cxxflags -mno-lzcnt
			fi
		fi

		if use cpu_flags_x86_f16c ; then
			if [[ "${CXXFLAGS}" =~ march=(\
native|\
\
ivybridge|haswell|broadwell|skylake|knl|knm|skylake-avx512|cannonlake|\
icelake-client|icelake-server|cascadelake|copperlake|tigerlake|sapphirerapids|\
\
bdver2|bdver3|bdver4|znver1|znver2|btver2) ]] \
			|| [[ "${CXXFLAGS}" =~ mf16c ]] ; then
				# Already added
				:;
			else
				append-cxxflags -mf16c
			fi
		else
			append-cxxflags -mno-f16c
		fi

		if use cpu_flags_x86_fma ; then
			# for eigen and cycles
			if [[ "${CXXFLAGS}" =~ march=(\
native|\
\
haswell|broadwell|skylake|knl|knm|skylake-avx512|cannonlake|icelake-client|\
icelake-server|cascadelake|cooperlake|tigerlake|sapphirerapids|alderlake|\
\
bdver2|bdver3|bdver4|znver1|znver2) ]] \
			|| [[ "${CXXFLAGS}" =~ mfma ]] ; then
				# Already added
				:;
			else
				append-cxxflags -mfma
			fi
		else
			append-cxxflags -mno-fma
		fi

		if use cpudetection ; then
			# automatically adds -march=native
			filter-flags -m*avx* -m*mmx -m*sse* -m*ssse3 -m*3dnow \
				-m*popcnt -m*abm -m*bmi -m*lzcnt -m*f16c -m*fma
			filter-flags -march=*
		fi

	fi

	if use network ; then
		sed -i -e "/WITH_CYCLES_NETWORK FALSE/d" \
			src/CMakeLists.txt || die
	fi

	# Cycles must use <= c++17 or it might have build time failures.
	# Apps must have the same LLVM version to avoid the multiple LLVM versions bug.

	mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=/usr/$(get_libdir)/cycles
		-DBUILD_SHARED_LIBS=OFF
		-DWITH_BLENDER=FALSE
		-DWITH_CPU_SSE=$(usex cpu_flags_x86_sse2)
		-DWITH_CUDA_DYNLOAD=$(usex cuda $(usex nvcc ON OFF) ON)
		-DWITH_CYCLES_CUBIN_COMPILER=$(usex nvrtc)
		-DWITH_CYCLES_CUDA_BINARIES=$(usex cuda)
		-DWITH_CYCLES_DEBUG=$(usex debug)
		-DWITH_CYCLES_DEVICE_CUDA=$(usex cuda TRUE FALSE)
		-DWITH_CYCLES_DEVICE_OPENCL=$(usex opencl)
		-DWITH_CYCLES_DEVICE_OPTIX=$(usex optix)
		-DWITH_CYCLES_EMBREE=$(usex embree)
		-DWITH_CYCLES_KERNEL_ASAN=$(usex asan)
		-DWITH_CYCLES_LOGGING=OFF
		-DWITH_CYCLES_NATIVE_ONLY=$(usex cpudetection)
		-DWITH_CYCLES_NETWORK=$(usex network)
		-DWITH_CYCLES_OPENCOLORIO=$(usex color-management)
		-DWITH_CYCLES_OPENIMAGEDENOISE=$(usex openimagedenoise)
		-DWITH_CYCLES_OPENSUBDIV=$(usex opensubdiv)
		-DWITH_CYCLES_OPENVDB=$(usex openvdb)
		-DWITH_CYCLES_OSL=$(usex osl)
		-DWITH_CYCLES_STANDALONE=TRUE
		-DWITH_CYCLES_STANDALONE_GUI=$(usex gui)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	exeinto /usr/$(get_libdir)/cycles/bin
	doexe "${BUILD_DIR}/bin/cycles"
	if use network ; then
		doexe "${BUILD_DIR}/bin/cycles_server"
	fi
	if use nvrtc ; then
		if [[ -e "${BUILD_DIR}/bin/cycles_cubin_cc" ]] ; then
			doexe "${BUILD_DIR}/bin/cycles_cubin_cc"
		fi
	fi
	insinto /usr/$(get_libdir)/cycles/$(get_libdir)
	doins "${BUILD_DIR}/lib/"*
}

pkg_postinst() {
	if use network ; then
		einfo
		ewarn "The Cycles Networking support is experimental and"
		ewarn "incomplete."
		einfo
		einfo "To make a OpenCL GPU available do:"
		einfo "cycles_server --device OPENCL"
		einfo
		einfo "To make a CUDA GPU available do:"
		einfo "cycles_server --device CUDA"
		einfo
		einfo "To make a CPU available do:"
		einfo "cycles_server --device CPU"
		einfo
		einfo "Only one instance of a cycles_server can be used on a host."
		einfo
		einfo "You may want to run cycles_server on the client too, but"
		einfo "it is not necessary."
		einfo
		einfo "Clients need to set the Rendering Engine to Cycles and"
		einfo "Device to Networked Device.  Finding the server is done"
		einfo "automatically."
		einfo
	fi
}
