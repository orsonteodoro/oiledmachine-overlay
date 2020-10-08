# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Corresponds to Blender 2.81

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
LLVM_V=9
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
IUSE+=" +abi5-compat abi6-compat abi7-compat asan color-management \
cpudetection cuda -debug embree +gui -network nvcc nvrtc opencl -opensubdiv \
openvdb optix -osl"
# Same dependency versions as Blender 2.81
RDEPEND="${PYTHON_DEPS}
	>=dev-lang/python-3.7.4
	color-management? ( >=media-libs/opencolorio-1.1.0 )
	cuda? ( >=x11-drivers/nvidia-drivers-418.39
		 >=dev-util/nvidia-cuda-toolkit-10.1:= )
	>=blender-libs/boost-1.68:${CXXABI_V}=[threads]
	>=dev-libs/pugixml-1.9
	embree? ( >=media-libs/embree-3.2.4:=\
[cpu_flags_x86_sse4_2?,cpu_flags_x86_avx?,cpu_flags_x86_avx2?,static-libs] )
	blender-libs/mesa:${LLVM_V}=
	>=media-libs/glew-1.13.0
	>=media-libs/openimageio-1.8.13
	opensubdiv? ( >=media-libs/opensubdiv-3.4.0_rc2[cuda=,opencl=] )
	openvdb? (
abi5-compat? ( >=blender-libs/openvdb-5.1.0:5[${PYTHON_SINGLE_USEDEP},abi5-compat(+)]
		 <blender-libs/openvdb-7.1:5[${PYTHON_SINGLE_USEDEP},abi5-compat(+)] )
abi6-compat? ( >=blender-libs/openvdb-5.1.0:6[${PYTHON_SINGLE_USEDEP},abi6-compat(+)]
		 <blender-libs/openvdb-7.1:6[${PYTHON_SINGLE_USEDEP},abi6-compat(+)] )
abi7-compat? ( >=blender-libs/openvdb-5.1.0:7-${CXXABI_V}[${PYTHON_SINGLE_USEDEP},abi7-compat(+)]
		 <blender-libs/openvdb-7.1:7-${CXXABI_V}[${PYTHON_SINGLE_USEDEP},abi7-compat(+)] )
		>=dev-cpp/tbb-2018.5
		>=dev-libs/c-blosc-1.14.4
	)
	optix? ( >=dev-libs/optix-7 )
	osl? ( >=blender-libs/osl-1.9.9:${LLVM_V}=[static-libs]
		blender-libs/mesa:${LLVM_V}= )
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
EGIT_COMMIT="v${PV}"
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
	export OPENVDB_V=$(usex openvdb $(usex abi7-compat 7 $(usex abi6-compat 6 5)) "")
	export OPENVDB_V_DIR=$(usex openvdb $(usex abi7-compat 7-${CXXABI_V} $(usex abi6-compat 6 5)) "")

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

# PreFix
prfx() {
	echo "${EROOT}/usr/$(get_libdir)/blender"
}

_LD_LIBRARY_PATH=()
_PATH=()
src_configure() {
	append-cppflags -DOPENVDB_ABI_VERSION_NUMBER=${OPENVDB_V}

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

	# Cycles must use <= c++11 or it might have build time failures.
	# Apps must have the same LLVM version to avoid the multiple LLVM versions bug.

	if [[ -d "$(prfx)/boost/${CXXABI_V}/usr/$(get_libdir)" ]] ; then
		export BOOST_ROOT="$(prfx)/boost/${CXXABI_V}/usr"
		_LD_LIBRARY_PATH+=( "$(prfx)/boost/${CXXABI_V}/usr/$(get_libdir)\n" )
	fi

	if has_version 'blender-libs/mesa:'${LLVM_V}'[libglvnd]' ; then
		mycmakeargs+=( -DOpenGL_GL_PREFERENCE=GLVND )
		if [[ -e "${EROOT}/usr/$(get_libdir)/libGLX.so" ]] ; then
			mycmakeargs+=( -DOPENGL_glx_LIBRARY="${EROOT}/usr/$(get_libdir)/libGLX.so" )
		else
			die "Install media-libs/libglvnd or indirectly through blender-libs/mesa:${LLVM_V}[libglvnd]."
		fi
		if [[ -e "${EROOT}/usr/$(get_libdir)/libOpenGL.so" ]] ; then
			mycmakeargs+=( -DOPENGL_opengl_LIBRARY="${EROOT}/usr/$(get_libdir)/libOpenGL.so" )
		else
			die "Install media-libs/libglvnd or indirectly through blender-libs/mesa:${LLVM_V}[libglvnd]."
		fi
		if [[ -e "${EROOT}/usr/$(get_libdir)/libEGL.so" ]] ; then
			mycmakeargs+=( -DOPENGL_egl_LIBRARY="${EROOT}/usr/$(get_libdir)/libEGL.so" )
		fi
	else
		mycmakeargs+=( -DOpenGL_GL_PREFERENCE=LEGACY )
		if [[ -e "$(prfx)/mesa/${LLVM_V}/usr/$(get_libdir)/libGL.so" ]] ; then
			# legacy
			mycmakeargs+=( -DOPENGL_gl_LIBRARY="$(prfx)/mesa/${LLVM_V}/usr/$(get_libdir)/libGL.so" )
		else
			die "Use either blender-libs/mesa:${LLVM_V}[-libglvnd], or blender-libs/mesa:${LLVM_V}[libglvnd] with media-libs/libglvnd"
		fi
		if [[ -e "$(prfx)/mesa/${LLVM_V}/usr/$(get_libdir)/libEGL.so" ]] ; then
			mycmakeargs+=( -DOPENGL_egl_LIBRARY="$(prfx)/mesa/${LLVM_V}/usr/$(get_libdir)/libEGL.so" )
		fi
		export CMAKE_INCLUDE_PATH="$(prfx)/mesa/${LLVM_V}/usr/include;${CMAKE_INCLUDE_PATH}"
		export CMAKE_LIBRARY_PATH="$(prfx)/mesa/${LLVM_V}/usr/$(get_libdir);${CMAKE_LIBRARY_PATH}"
		_LD_LIBRARY_PATH+=( "$(prfx)/mesa/${LLVM_V}/usr/$(get_libdir)\n" )
	fi

	if [[ -d "$(prfx)/mesa/${LLVM_V}/usr/$(get_libdir)/dri" ]] ; then
		_LIBGL_DRIVERS_PATH+=( "$(prfx)/mesa/${LLVM_V}/usr/$(get_libdir)/dri\n" )
		_LIBGL_DRIVERS_DIR+=( "$(prfx)/mesa/${LLVM_V}/usr/$(get_libdir)/dri\n" )
	fi

	if use openvdb ; then
		export OPENVDB_ROOT_DIR="$(prfx)/openvdb/${OPENVDB_V_DIR}/usr"
		_LD_LIBRARY_PATH+=( "$(prfx)/openvdb/${OPENVDB_V_DIR}/usr/$(get_libdir)\n" )
	fi

	if use osl ; then
		export OSL_ROOT_DIR="$(prfx)/osl/${LLVM_V}"
		_LD_LIBRARY_PATH+=( "$(prfx)/osl/${LLVM_V}/usr/$(get_libdir)\n" )
		_PATH+=( "$(prfx)/osl/${LLVM_V}/usr/bin\n" )
	fi

	if use network ; then
		sed -i -e "/WITH_CYCLES_NETWORK FALSE/d" \
			src/CMakeLists.txt || die
	fi

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
	newexe "${BUILD_DIR}/bin/cycles" ".cycles"
	if use network ; then
		newexe "${BUILD_DIR}/bin/cycles_server" ".cycles"
	fi
	if use nvrtc ; then
		if [[ -e "${BUILD_DIR}/bin/cycles_cubin_cc" ]] ; then
			doexe "${BUILD_DIR}/bin/cycles_cubin_cc"
		fi
	fi
	insinto /usr/$(get_libdir)/cycles/$(get_libdir)
	doins "${BUILD_DIR}/lib/"*
	_LD_LIBRARY_PATH=$(echo -e "${_LD_LIBRARY_PATH[@]}" | tr "\n" ":" | sed "s|: |:|g")
	_PATH=$(echo -e "${_PATH[@]}" | tr "\n" ":" | sed "s|: |:|g")
	cp "${FILESDIR}/cycles-wrapper" "${T}/cycles" || die
	sed -i -e "s|\${CYCLES_EXE}|/usr/$(get_libdir)/cycles/bin/.cycles|" \
		-e "s|#LD_LIBRARY_PATH|export LD_LIBRARY_PATH=\"${_LD_LIBRARY_PATH}\"|" \
		-e "s|#LIBGL_DRIVERS_PATH|export LIBGL_DRIVERS_PATH=\"${_LIBGL_DRIVERS_PATH}\"|" \
		-e "s|#LIBGL_DRIVERS_DIR|export LIBGL_DRIVERS_DIR=\"${_LIBGL_DRIVERS_DIR}\"|" \
		-e "s|#PATH|export PATH=\"${_PATH}\"|" \
		"${T}/cycles" || die
	doexe "${T}/cycles"
	if use network ; then
		cp "${FILESDIR}/cycles-wrapper" "${T}/cycles_server" || die
		sed -i -e "s|\${CYCLES_EXE}|/usr/$(get_libdir)/cycles/bin/.cycles_server|" \
			-e "s|#LD_LIBRARY_PATH|export LD_LIBRARY_PATH=\"${_LD_LIBRARY_PATH}\"|" \
			-e "s|#LIBGL_DRIVERS_PATH|export LIBGL_DRIVERS_PATH=\"${_LIBGL_DRIVERS_PATH}\"|" \
			-e "s|#LIBGL_DRIVERS_DIR|export LIBGL_DRIVERS_DIR=\"${_LIBGL_DRIVERS_DIR}\"|" \
			-e "s|#PATH|export PATH=\"${_PATH}\"|" \
			"${T}/cycles_server" || die
		doexe "${T}/cycles_server"
	fi
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
