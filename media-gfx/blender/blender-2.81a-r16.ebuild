# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DESCRIPTION="3D Creation/Animation/Publishing System"
HOMEPAGE="https://www.blender.org"
KEYWORDS="amd64 ~x86"
LICENSE="|| ( GPL-2 BL )
all-rights-reserved
LGPL-2.1+
MPL-2.0
build_creator? (
	Apache-2.0
	AFL-3.0
	BitstreamVera
	CC-BY-SA-3.0
	color-management? ( BSD )
	jemalloc? ( BSD-2 )
	GPL-2
	GPL-3
	GPL-3-with-font-exception
	LGPL-2.1+
	PSF-2
	ZLIB
)
build_headless? (
	Apache-2.0
	AFL-3.0
	BitstreamVera
	CC-BY-SA-3.0
	color-management? ( BSD )
	jemalloc? ( BSD-2 )
	GPL-2
	GPL-3
	GPL-3-with-font-exception
	LGPL-2.1+
	PSF-2
	ZLIB
)
cycles? (
	Apache-2.0
	Boost-1.0
	BSD
	MIT
)
"

# intern/mikktspace contains ZLIB
# intern/CMakeLists.txt contains GPL+ with all-rights-reserved ; there is no
#   all rights reserved in the vanilla GPL-2

CXXABI_V=11
LLVM_V=9
LLVM_MAX_SLOT=${LLVM_V}
PYTHON_COMPAT=( python3_{7,8} )

inherit eapi7-ver
inherit blender check-reqs cmake-utils flag-o-matic llvm pax-utils \
	python-single-r1 toolchain-funcs xdg

# If you use git tarballs, you need to download the submodules listed in
# .gitmodules.  The download.blender.org tarball is preferred because they
# bundle all the dependencies.
SRC_URI="https://download.blender.org/source/blender-${PV}.tar.xz"

BLENDER_MAIN_SYMLINK_MODE=${BLENDER_MAIN_SYMLINK_MODE:=latest}

# Slotting is for scripting and plugin compatibility
SLOT="${PV}"
SLOT_MAJ=${SLOT%/*}
# Platform defaults based on CMakeList.txt
#1234567890123456789012345678901234567890123456789012345678901234567890123456789
X86_CPU_FLAGS=( mmx:mmx sse:sse sse2:sse2 sse3:sse3 ssse3:ssse3 sse4_1:sse4_1 \
sse4_2:sse4_2 avx:avx avx2:avx2 fma:fma lzcnt:lzcnt bmi:bmi f16c:f16c )
CPU_FLAGS=( ${X86_CPU_FLAGS[@]/#/cpu_flags_x86_} )
IUSE+=" ${CPU_FLAGS[@]%:*}"
IUSE="${IUSE/cpu_flags_x86_mmx/+cpu_flags_x86_mmx}"
IUSE="${IUSE/cpu_flags_x86_sse /+cpu_flags_x86_sse }"
IUSE="${IUSE/cpu_flags_x86_sse2/+cpu_flags_x86_sse2}"
IUSE+=" X +abi5-compat abi6-compat abi7-compat -asan +bullet -collada \
-color-management -cpudetection +cuda +cycles -cycles-network +dds -debug doc \
+elbeem -embree -ffmpeg -fftw flac -jack +jemalloc +jpeg2k -llvm -man +ndof \
+nls +nvcc -nvrtc +openal +opencl -openexr -openimagedenoise -openimageio \
+openmp -opensubdiv -openvdb -optix -osl release -sdl -sndfile test +tiff \
-valgrind"
FFMPEG_IUSE+=" jpeg2k +mp3 opus +theora vorbis vpx webm x264 xvid"
IUSE+=" ${FFMPEG_IUSE}"
RESTRICT="mirror !test? ( test )"

# The release USE flag depends on platform defaults.
# Disabled dead code optimization flags introduced by
#   cd5e1ff74e4f6443f3e4b836dd23fe46b56cb7ed
# At the source code level, they mix the sse2 intrinsics functions up with the
#   __KERNEL_SSE__.
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}
	!cpu_flags_x86_mmx? ( !cpu_flags_x86_sse !cpu_flags_x86_sse2 )
	build_creator ( X )
	cpu_flags_x86_sse2? ( !cpu_flags_x86_sse? ( cpu_flags_x86_mmx ) )
	cuda? ( cycles ^^ ( nvcc nvrtc ) )
	cycles? (
		openexr tiff openimageio osl? ( llvm )
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
	)
	embree? ( cycles )
	mp3? ( ffmpeg )
	nvcc? ( || ( cuda optix ) )
	nvrtc? ( || ( cuda optix ) )
	opencl? ( cycles )
	openvdb? ( ^^ ( abi5-compat abi6-compat abi7-compat ) )
	optix? ( cuda cycles nvcc )
	opus? ( ffmpeg )
	osl? ( cycles llvm )
	release? (
		build_creator
		bullet
		collada
		color-management
		cuda? ( nvcc )
		cycles
		!cycles-network
		dds
		!debug
		elbeem
		ffmpeg
		fftw
		jack
		jemalloc
		jpeg2k
		man
		ndof
		nls
		openal
		openexr
		openimageio
		openmp
		openimagedenoise
		opensubdiv
		openvdb
		osl
		sdl
		sndfile
		!test
		tiff
		!valgrind
	)
	theora? ( ffmpeg )
	vorbis? ( ffmpeg )
	vpx? ( ffmpeg )
	webm? ( ffmpeg opus vpx )
	x264? ( ffmpeg )
	xvid? ( ffmpeg )"

# dependency version requirements see
# build_files/build_environment/cmake/versions.cmake
# doc/python_api/requirements.txt
# extern/Eigen3/eigen-update.sh
# Track OPENVDB_LIBRARY_MAJOR_VERSION_NUMBER for changes.
RDEPEND="${PYTHON_DEPS}
	>=dev-lang/python-3.7.4
	dev-libs/lzo:2
	$(python_gen_cond_dep '
		>=dev-python/certifi-2019.6.16[${PYTHON_MULTI_USEDEP}]
		>=dev-python/chardet-3.0.4[${PYTHON_MULTI_USEDEP}]
		>=dev-python/idna-2.8[${PYTHON_MULTI_USEDEP}]
		>=dev-python/numpy-1.17.0[${PYTHON_MULTI_USEDEP}]
		>=dev-python/requests-2.22.0[${PYTHON_MULTI_USEDEP}]
		>=dev-python/urllib3-1.25.3[${PYTHON_MULTI_USEDEP}]
	')
	>=media-libs/freetype-2.9.1
	>=media-libs/glew-1.13.0:*
	>=media-libs/libpng-1.6.35:0=
	media-libs/libsamplerate
	>=sys-libs/zlib-1.2.11
	|| (
		virtual/glu
		>=media-libs/glu-9.0.1
	)
	|| (
		virtual/jpeg:0=
		>=media-libs/libjpeg-turbo-1.5.3
	)
	virtual/libintl
	virtual/opengl
	collada? ( >=media-libs/opencollada-1.6.68:= )
	color-management? ( >=media-libs/opencolorio-1.1.0 )
	cuda? (
		>=x11-drivers/nvidia-drivers-418.39
		>=dev-util/nvidia-cuda-toolkit-10.1:=
	)
	cycles? ( >=dev-libs/pugixml-1.9 )
	embree? ( >=media-libs/embree-3.2.4:=\
[cpu_flags_x86_sse4_2?,cpu_flags_x86_avx?,cpu_flags_x86_avx2?,static-libs] )
	ffmpeg? ( >=media-video/ffmpeg-4.0.2:=\
[encode,jpeg2k?,mp3?,opus?,theora?,vorbis?,vpx?,x264,xvid?,zlib] )
	fftw? ( >=sci-libs/fftw-3.3.8:3.0= )
	flac? ( >=media-libs/flac-1.3.3 )
	jack? ( virtual/jack )
	jemalloc? ( >=dev-libs/jemalloc-5.0.1:= )
	jpeg2k? ( >=media-libs/openjpeg-2.3.0:2 )
	llvm? ( >=sys-devel/llvm-6.0.1:=
		 <sys-devel/llvm-10 )
	ndof? (
		app-misc/spacenavd
		>=dev-libs/libspnav-0.2.3
	)
	nls? (
		|| (
			virtual/libiconv
			>=dev-libs/libiconv-1.15
		)
	)
	openal? ( >=media-libs/openal-1.18.2 )
	opencl? ( virtual/opencl )
	openimagedenoise? ( >=media-libs/oidn-1.0.0 )
	openimageio? ( >=media-libs/openimageio-1.8.13[color-management?,jpeg2k?] )
	openexr? (
		>=media-libs/ilmbase-2.3.0:=
		>=media-libs/openexr-2.3.0:=
	)
	opensubdiv? ( >=media-libs/opensubdiv-3.4.0_rc2:=[cuda=,opencl=] )
	!openvdb? (
		|| (
			>=blender-libs/boost-1.68:=[nls?,threads(+)]
			>=dev-libs/boost-1.68:=[nls?,threads(+)]
		)
	)
	openvdb? (
		>=blender-libs/boost-1.68:=[nls?,threads(+)]
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
	sdl? ( >=media-libs/libsdl2-2.0.8[sound,joystick] )
	sndfile? ( >=media-libs/libsndfile-1.0.28 )
	tiff? ( >=media-libs/tiff-4.0.9:0[zlib] )
	valgrind? ( dev-util/valgrind )
	X? (
		x11-libs/libX11
		x11-libs/libXi
		x11-libs/libXxf86vm
	)"

DEPEND="${RDEPEND}
	asan? ( || ( sys-devel/clang
                     sys-devel/gcc ) )
	>=dev-cpp/eigen-3.3.7:3
	>=dev-util/cmake-3.5
	cycles? (
		x86? ( || (
			sys-devel/clang
			dev-lang/icc
		) )
	)
	doc? (
		app-doc/doxygen[dot]
		>=dev-python/sphinx-1.8.5[latex]
		>=dev-python/sphinx_rtd_theme-0.4.3
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
	nls? ( sys-devel/gettext )
	virtual/pkgconfig"

_PATCHES=(
	"${FILESDIR}/${PN}-2.82a-fix-install-rules.patch"
	"${FILESDIR}/${PN}-2.82a-cycles-network-fixes.patch"
	"${FILESDIR}/${PN}-2.80-install-paths-change.patch"
)

get_dest() {
	echo "/usr/bin/.${PN}/${SLOT_MAJ}/${EBLENDER_NAME}"
}

blender_check_requirements() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp

	if use doc; then
		CHECKREQS_DISK_BUILD="4G" check-reqs_pkg_pretend
	fi
}

pkg_pretend() {
	blender_check_requirements
}

pkg_setup() {
	llvm_pkg_setup
	blender_check_requirements
	python-single-r1_pkg_setup
	# Needs OpenCL 1.2 (GCN 2)
	export OPENVDB_V=$(usex openvdb $(usex abi7-compat 7 $(usex abi6-compat 6 5)) "")
	export OPENVDB_V_DIR=$(usex openvdb $(usex abi7-compat 7-${CXXABI_V} $(usex abi6-compat 6 5)) "")
	if use openvdb ; then
		if ! grep -q -F -e "delta()" "${EROOT}/usr/$(get_libdir)/blender/openvdb/${OPENVDB_V_DIR}/usr/include/openvdb/util/CpuTimer.h" ; then
			if use abi7-compat ; then
				# compatible as long as the function is present
				die "OpenVDB delta() is missing try <=7.1.x only"
			fi
		fi
	fi

	if ( has_version 'media-libs/mesa[libglvnd]' \
		&& has_version 'x11-drivers/amdgpu-pro[opengl_pro]') \
	|| ( has_version 'media-libs/mesa[libglvnd]' \
		&& has_version 'x11-drivers/amdgpu-pro-lts[opengl_pro]'); then
		die \
"You must switch to x11-drivers/amdgpu-pro[opengl_mesa] or \
x11-drivers/amdgpu-pro-lts[opengl_mesa] instead"
	fi

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

_src_prepare() {
	eapply ${_PATCHES[@]}

	S="${BUILD_DIR}" \
	CMAKE_USE_DIR="${BUILD_DIR}" \
	BUILD_DIR="${WORKDIR}/${P}_${EBLENDER}" \
	cmake-utils_src_prepare

	eapply "${FILESDIR}/blender-2.81a-parent-datafiles-dir-change.patch"

	if [[ "${EBLENDER}" == "build_creator" || "${EBLENDER}" == "build_headless" ]] ; then
		# we don't want static glew, but it's scattered across
		# multiple files that differ from version to version
		# !!!CHECK THIS SED ON EVERY VERSION BUMP!!!
		local file
		while IFS="" read -d $'\0' -r file ; do
			if grep -q -F -e "-DGLEW_STATIC" "${file}" ; then
				einfo "Removing -DGLEW_STATIC from ${file}"
				sed -i -e '/-DGLEW_STATIC/d' "${file}"
			fi
		done < <(find . -type f -name "CMakeLists.txt" -print0)

		sed -i -e "s|bf_intern_glew_mx|bf_intern_glew_mx \${GLEW_LIBRARY}|g" \
			intern/cycles/app/CMakeLists.txt || die
	fi

	# Disable MS Windows help generation. The variable doesn't do what it
	# it sounds like.
	sed -e "s|GENERATE_HTMLHELP      = YES|GENERATE_HTMLHELP      = NO|" \
	    -i doc/doxygen/Doxyfile || die
}

src_prepare() {
	ewarn
	ewarn "This version is not a Long Term Support (LTS) version."
	ewarn "Use 2.83.x series instead."
	ewarn
	xdg_src_prepare
	blender_prepare() {
		cd "${BUILD_DIR}" || die
		_src_prepare
	}
	blender_copy_sources
	blender_foreach_impl blender_prepare
}

_src_configure() {
	# FIX: forcing '-funsigned-char' fixes an anti-aliasing issue with menu
	# shadows, see bug #276338 for reference
	append-flags -funsigned-char
	append-lfs-flags
	append-cppflags -DOPENVDB_ABI_VERSION_NUMBER=${OPENVDB_V}

	local mycmakeargs=()
	mycmakeargs+=( -DCMAKE_INSTALL_BINDIR:PATH=$(get_dest) )

	if use cycles-network ; then
		ewarn \
"Cycles Networking support does not work at all even for CPU rendering.  For \
ebuild/upstream developers only."
	fi

	unset _LD_LIBRARY_PATH
	unset CMAKE_INCLUDE_PATH
	unset CMAKE_LIBRARY_PATH
	unset CMAKE_PREFIX_PATH

	if ! has_version 'media-libs/embree[cpu_flags_x86_avx]' ; then
		sed -i -e "/embree_avx/d" \
			build_files/cmake/Modules/FindEmbree.cmake || die
	fi

	if ! has_version 'media-libs/embree[cpu_flags_x86_avx2]' ; then
		sed -i -e "/embree_avx2/d" \
			build_files/cmake/Modules/FindEmbree.cmake || die
	fi

	if ! has_version 'media-libs/embree[cpu_flags_x86_sse4_2]' ; then
		sed -i -e "/embree_sse42/d" \
			build_files/cmake/Modules/FindEmbree.cmake || die
	fi

	if use cycles && ! use cpudetection ; then
		if use cpu_flags_x86_sse ; then
			# clang / gcc
			sed -i -e "s|check_cxx_compiler_flag(-msse CXX_HAS_SSE)|set(CXX_HAS_SSE TRUE)|g" \
				intern/cycles/CMakeLists.txt || die
			# icc
			sed -i -e "s|check_cxx_compiler_flag(-xsse2 CXX_HAS_SSE)|set(CXX_HAS_SSE TRUE)|g" \
				intern/cycles/CMakeLists.txt || die
		else
			# clang / gcc
			sed -i -e "s|check_cxx_compiler_flag(-msse CXX_HAS_SSE)|set(CXX_HAS_SSE FALSE)|g" \
				intern/cycles/CMakeLists.txt || die
			# icc
			sed -i -e "s|check_cxx_compiler_flag(-xsse2 CXX_HAS_SSE)|set(CXX_HAS_SSE FALSE)|g" \
				intern/cycles/CMakeLists.txt || die
		fi

		if ! use cpu_flags_x86_sse2 ; then
			sed -i -e "/WITH_KERNEL_SSE2/d" \
				intern/cycles/CMakeLists.txt || die
		fi

		if ! use cpu_flags_x86_sse3 ; then
			sed -i -e "/WITH_KERNEL_SSE3/d" \
				intern/cycles/CMakeLists.txt || die
		fi

		if ! use cpu_flags_x86_sse4_1 ; then
			sed -i -e "/WITH_KERNEL_SSE41/d" \
				intern/cycles/CMakeLists.txt || die
		fi

		if use cpu_flags_x86_avx ; then
			# clang / gcc
			sed -i -e "s|check_cxx_compiler_flag(-mavx CXX_HAS_AVX)|set(CXX_HAS_AVX TRUE)|g" \
				intern/cycles/CMakeLists.txt || die
			# icc
			sed -i -e "s|check_cxx_compiler_flag(-xavx CXX_HAS_AVX)|set(CXX_HAS_AVX TRUE)|g" \
				intern/cycles/CMakeLists.txt || die
		else
			# clang / gcc
			sed -i -e "s|check_cxx_compiler_flag(-mavx CXX_HAS_AVX)|set(CXX_HAS_AVX FALSE)|g" \
				intern/cycles/CMakeLists.txt || die
			# icc
			sed -i -e "s|check_cxx_compiler_flag(-xavx CXX_HAS_AVX)|set(CXX_HAS_AVX FALSE)|g" \
				intern/cycles/CMakeLists.txt || die
		fi

		if use cpu_flags_x86_avx2 ; then
			# clang / gcc
			sed -i -e "s|check_cxx_compiler_flag(-mavx2 CXX_HAS_AVX2)|set(CXX_HAS_AVX2 TRUE)|g" \
				intern/cycles/CMakeLists.txt || die
			# icc
			sed -i -e "s|check_cxx_compiler_flag(-xcore-avx2 CXX_HAS_AVX2)|set(CXX_HAS_AVX2 TRUE)|g" \
				intern/cycles/CMakeLists.txt || die
		else
			# clang / gcc
			sed -i -e "s|check_cxx_compiler_flag(-mavx2 CXX_HAS_AVX2)|set(CXX_HAS_AVX2 FALSE)|g" \
				intern/cycles/CMakeLists.txt || die
			# icc
			sed -i -e "s|check_cxx_compiler_flag(-xcore-avx2 CXX_HAS_AVX2)|set(CXX_HAS_AVX2 FALSE)|g" \
				intern/cycles/CMakeLists.txt || die
		fi

		if [[ "${ABI}" == "x86" ]] && grep -q -F -e "WITH_KERNEL_SSE41" intern/cycles/CMakeLists.txt ; then
			# See intern/cycles/util/util_optimization.h for reason why it was axed in x86 (32-bit).
			sed -i -e "/WITH_KERNEL_SSE41/d" \
				intern/cycles/CMakeLists.txt || die
		fi

		# No instructions present
		sed -i -e "s|-mbmi2||g" \
			intern/cycles/CMakeLists.txt || die
	fi

	# The avx2 config in CMakeLists.txt already sets this.
	if tc-is-gcc || tc-is-clang ; then
		if ! use cpudetection && use cycles && ! use cpu_flags_x86_avx2 ; then
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

		if use cycles && use cpudetection ; then
			# automatically adds -march=native
			filter-flags -m*avx* -m*mmx -m*sse* -m*ssse3 -m*3dnow -m*popcnt -m*abm -m*bmi -m*lzcnt -m*f16c -m*fma
			filter-flags -march=*
		fi

	fi

	if [[ -d "${EROOT}/usr/$(get_libdir)/blender/boost/${CXXABI_V}/usr/$(get_libdir)" ]] ; then
		mycmakeargs+=( -DBoost_NO_SYSTEM_PATHS=ON )
		mycmakeargs+=( -DBoost_INCLUDE_DIR="${EROOT}/usr/$(get_libdir)/blender/boost/${CXXABI_V}/usr/include" )
		mycmakeargs+=( -DBoost_LIBRARY_DIR_RELEASE="${EROOT}/usr/$(get_libdir)/blender/boost/${CXXABI_V}/usr/$(get_libdir)" )
		_LD_LIBRARY_PATH="${EROOT}/usr/$(get_libdir)/blender/boost/${CXXABI_V}/usr/$(get_libdir):${_LD_LIBRARY_PATH}"
	fi

	if use openvdb ; then
		export OPENVDB_ROOT_DIR="${EROOT}/usr/$(get_libdir)/blender/openvdb/${OPENVDB_V_DIR}/usr"
		_LD_LIBRARY_PATH="${EROOT}/usr/$(get_libdir)/blender/openvdb/${OPENVDB_V_DIR}/usr/$(get_libdir):${_LD_LIBRARY_PATH}"
	fi

	if use osl ; then
		if has_version 'blender-libs/mesa[libglvnd]' ; then
			mycmakeargs+=( -DOpenGL_GL_PREFERENCE=GLVND )
			if [[ -e "${EROOT}/usr/$(get_libdir)/libGLX.so" ]] ; then
				mycmakeargs+=( -DOPENGL_glx_LIBRARY="${EROOT}/usr/$(get_libdir)/libGLX.so" )
			else
				die "Install media-libs/libglvnd or indirectly through mesa[libglvnd]."
			fi
			if [[ -e "${EROOT}/usr/$(get_libdir)/libOpenGL.so" ]] ; then
				mycmakeargs+=( -DOPENGL_opengl_LIBRARY="${EROOT}/usr/$(get_libdir)/libOpenGL.so" )
			else
				die "Install media-libs/libglvnd or indirectly through mesa[libglvnd]."
			fi
			if [[ -e "${EROOT}/usr/$(get_libdir)/libEGL.so" ]] ; then
				mycmakeargs+=( -DOPENGL_egl_LIBRARY="${EROOT}/usr/$(get_libdir)/libEGL.so" )
			fi
		else
			mycmakeargs+=( -DOpenGL_GL_PREFERENCE=LEGACY )
			if [[ -e "${EROOT}/usr/$(get_libdir)/blender/mesa/${LLVM_V}/usr/$(get_libdir)/libGL.so" ]] ; then
				# legacy
				mycmakeargs+=( -DOPENGL_gl_LIBRARY="${EROOT}/usr/$(get_libdir)/blender/mesa/${LLVM_V}/usr/$(get_libdir)/libGL.so" )
			else
				die "Use either blender-libs/mesa or media-libs/mesa[libglvnd] or media-libs/libglvnd"
			fi
			if [[ -e "${EROOT}/usr/$(get_libdir)/blender/mesa/${LLVM_V}/usr/$(get_libdir)/libEGL.so" ]] ; then
				mycmakeargs+=( -DOPENGL_egl_LIBRARY="${EROOT}/usr/$(get_libdir)/blender/mesa/${LLVM_V}/usr/$(get_libdir)/libEGL.so" )
			fi
			export CMAKE_INCLUDE_PATH="${EROOT}/usr/$(get_libdir)/blender/mesa/${LLVM_V}/usr/include;${CMAKE_INCLUDE_PATH}"
			export CMAKE_LIBRARY_PATH="${EROOT}/usr/$(get_libdir)/blender/mesa/${LLVM_V}/usr/$(get_libdir);${CMAKE_LIBRARY_PATH}"
			_LD_LIBRARY_PATH="${EROOT}/usr/$(get_libdir)/blender/mesa/${LLVM_V}/usr/$(get_libdir):${_LD_LIBRARY_PATH}"
		fi
		export OSL_ROOT_DIR="${EROOT}/usr/$(get_libdir)/blender/osl/${LLVM_V}"
		_LD_LIBRARY_PATH="${EROOT}/usr/$(get_libdir)/blender/osl/${LLVM_V}/usr/$(get_libdir):${_LD_LIBRARY_PATH}"
	fi

	if [[ -n "${_LD_LIBRARY_PATH}" ]] ; then
		sed -i -e "s|\[blender_bin|['env', \"LD_LIBRARY_PATH=${_LD_LIBRARY_PATH}\", blender_bin|" \
			doc/manpage/blender.1.py || die
	fi

	mycmakeargs+=(
		-DPYTHON_VERSION="${EPYTHON/python/}"
		-DPYTHON_LIBRARY="$(python_get_library_path)"
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DSUPPORT_SSE_BUILD=$(usex cpu_flags_x86_sse)
		-DSUPPORT_SSE2_BUILD=$(usex cpu_flags_x86_sse2)
		-DWITH_ASSERT_ABORT=$(usex debug)
		-DWITH_BOOST=ON
		-DWITH_BULLET=$(usex bullet)
		-DWITH_COMPILER_ASAN=$(usex asan)
		-DWITH_CPU_SSE=$(usex cpu_flags_x86_sse2)
		-DWITH_CUDA_DYNLOAD=$(usex cuda $(usex nvcc ON OFF) ON)
		-DWITH_CXX_GUARDEDALLOC=$(usex debug)
		-DWITH_CXX11_ABI=ON
		-DWITH_CYCLES=$(usex cycles)
		-DWITH_CYCLES_CUBIN_COMPILER=$(usex nvrtc)
		-DWITH_CYCLES_CUDA_BINARIES=$(usex cuda)
		-DWITH_CYCLES_DEVICE_CUDA=$(usex cuda TRUE FALSE)
		-DWITH_CYCLES_DEVICE_OPENCL=$(usex opencl)
		-DWITH_CYCLES_DEVICE_OPTIX=$(usex optix)
		-DWITH_CYCLES_EMBREE=$(usex embree)
		-DWITH_CYCLES_KERNEL_ASAN=$(usex asan)
		-DWITH_CYCLES_NATIVE_ONLY=$(usex cpudetection)
		-DWITH_CYCLES_OSL=$(usex osl)
		-DWITH_DOC_MANPAGE=$(usex man)
		-DWITH_IMAGE_DDS=$(usex dds)
		-DWITH_IMAGE_OPENEXR=$(usex openexr)
		-DWITH_IMAGE_OPENJPEG=$(usex jpeg2k)
		-DWITH_IMAGE_TIFF=$(usex tiff)
		-DWITH_INTERNATIONAL=$(usex nls)
		-DWITH_LLVM=$(usex llvm)
		-DWITH_MEM_JEMALLOC=$(usex jemalloc)
		-DWITH_MEM_VALGRIND=$(usex valgrind)
		-DWITH_MOD_FLUID=$(usex elbeem)
		-DWITH_OPENCOLLADA=$(usex collada)
		-DWITH_OPENCOLORIO=$(usex color-management)
		-DWITH_OPENIMAGEDENOISE=$(usex openimagedenoise)
		-DWITH_OPENIMAGEIO=$(usex openimageio)
		-DWITH_OPENMP=$(usex openmp)
		-DWITH_OPENSUBDIV=$(usex opensubdiv)
		-DWITH_OPENVDB=$(usex openvdb)
		-DWITH_OPENVDB_BLOSC=$(usex openvdb)
		-DWITH_PYTHON_INSTALL=OFF
		-DWITH_PYTHON_INSTALL_NUMPY=OFF
	)

	if [[ "${EBLENDER}" == "build_creator" ]] ; then
		if use jack || use openal ; then
			mycmakeargs+=(
				-DWITH_AUDASPACE=ON
			)
		fi

		mycmakeargs+=(
			-DWITH_CODEC_FFMPEG=$(usex ffmpeg)
			-DWITH_CODEC_SNDFILE=$(usex sndfile)
			-DWITH_FFTW3=$(usex fftw)
			-DWITH_GTESTS=$(usex test)
			-DWITH_INPUT_NDOF=$(usex ndof)
			-DWITH_JACK=$(usex jack)
			-DWITH_MOD_OCEANSIM=$(usex fftw)
			-DWITH_OPENAL=$(usex openal)
			-DWITH_SDL=$(usex sdl)
		)
	fi

# For details see,
# https://github.com/blender/blender/tree/v2.81a/build_files/cmake/config
	if [[ "${EBLENDER}" == "build_creator" \
		|| "${EBLENDER}" == "build_headless" ]] ; then
		mycmakeargs+=(
			-DWITH_CYCLES_NETWORK=$(usex cycles-network)
			-DWITH_INSTALL_PORTABLE=OFF
			-DWITH_STATIC_LIBS=OFF
			-DWITH_SYSTEM_EIGEN3=ON
			-DWITH_SYSTEM_GLEW=ON
			-DWITH_SYSTEM_LZO=ON
		)
	fi

	if [[ "${EBLENDER}" == "build_headless" ]] ; then
		# for render farms
		mycmakeargs+=(
			-DWITH_AUDASPACE=OFF
			-DWITH_CODEC_FFMPEG=OFF
			-DWITH_CODEC_SNDFILE=OFF
			-DWITH_FFTW3=OFF
			-DWITH_HEADLESS=ON
			-DWITH_INPUT_NDOF=OFF
			-DWITH_JACK=OFF
			-DWITH_MOD_OCEANSIM=OFF
			-DWITH_OPENAL=OFF
			-DWITH_SDL=OFF
			-DWITH_SYSTEM_GLEW=ON
			-DWITH_X11_XINPUT=OFF
			-DWITH_X11=OFF
		)
	fi

if [[ -n "${BLENDER_DISABLE_CUDA_AUTODETECT}" \
	&& "${BLENDER_DISABLE_CUDA_AUTODETECT}" == "1" ]] ; then
	:;
else
	if use cuda ; then
		if use nvcc ; then
			if [[ -x "${EROOT}/opt/cuda/bin/nvcc" ]] ; then
				mycmakeargs+=(
			-DCUDA_NVCC_EXECUTABLE="${EROOT}/opt/cuda/bin/nvcc"
				)
			elif [[ -n "${BLENDER_NVCC_PATH}" \
			&& -x "${EROOT}/${BLENDER_NVCC_PATH}/bin/nvcc" ]] ; then
				mycmakeargs+=(
		-DCUDA_NVCC_EXECUTABLE="${EROOT}/${BLENDER_NVCC_PATH}/nvcc"
				)
			elif [[ -n "${BLENDER_NVCC_PATH}" \
		&& ! -x "${EROOT}/${BLENDER_NVCC_PATH}/bin/nvcc" ]] ; then
				die \
"\n\
nvcc is unreachable from BLENDER_NVCC_PATH.  It should be an absolute path\n\
like /opt/cuda/bin/nvcc.\n\
\n"
			else
				die \
"\n\
You need to define BLENDER_NVCC_PATH as a per-package environmental variable\n\
containing the absolute path to nvcc e.g. /opt/cuda/bin/nvcc.\n\
\n"
			fi
		fi
		if use nvrtc ; then
			if [[ -f "${EROOT}/opt/cuda/lib64/libnvrtc-builtins.so" ]] ; then
				mycmakeargs+=(
				-DCUDA_TOOLKIT_ROOT_DIR="${EROOT}/opt/cuda"
				)
			elif [[ -n "${BLENDER_CUDA_TOOLKIT_ROOT_DIR}" \
&& -f "${EROOT}/${BLENDER_CUDA_TOOLKIT_ROOT_DIR}/lib64/libnvrtc-builtins.so" ]] ; then
				mycmakeargs+=(
	-DCUDA_TOOLKIT_ROOT_DIR="${EROOT}/${BLENDER_CUDA_TOOLKIT_ROOT_DIR}"
				)
			elif [[ -n "${BLENDER_CUDA_TOOLKIT_ROOT_DIR}" \
&& ! -f "${EROOT}/${BLENDER_CUDA_TOOLKIT_ROOT_DIR}/lib64/libnvrtc-builtins.so" ]] ; then
				die \
"Cannot reach \$BLENDER_CUDA_TOOLKIT_ROOT_DIR/lib64/libnvrtc-builtins.so"
			else
				die \
"\n
libnvrtc-builtins.so is unreachable.  Define BLENDER_CUDA_TOOLKIT_ROOT_DIR\n\
as a per-package environmental variable (e.g. /opt/cuda).\n
\n"
			fi
		fi
		if use optix ; then
			if [[ -n "${BLENDER_OPTIX_ROOT_DIR}" \
		&& -f "${EROOT}/${BLENDER_OPTIX_ROOT_DIR}/include/optix.h" ]] ; then
				mycmakeargs+=(
			-DOPTIX_ROOT_DIR="${EROOT}/${BLENDER_OPTIX_ROOT_DIR}"
				)
			elif [[ -n "${BLENDER_OPTIX_ROOT_DIR}" \
		&& ! -f "${EROOT}/${BLENDER_OPTIX_ROOT_DIR}/include/optix.h" ]] ; then
				die \
"\n\
Cannot reach \$BLENDER_OPTIX_ROOT_DIR/include/optix.h.  Fix it?\n\
\n"
			elif [[ -n "${OPTIX_ROOT_DIR}" \
		&& -f "${EROOT}/${OPTIX_ROOT_DIR}/include/optix.h" ]] ; then
				:;
			elif [[ -n "${OPTIX_ROOT_DIR}" \
		&& ! -f "${EROOT}/${OPTIX_ROOT_DIR}/include/optix.h" ]] ; then
"\n\
Cannot reach \$OPTIX_ROOT_DIR/include/optix.h.  Fix it?\n\
\n"
			else
				die \
"\n\
You need to define BLENDER_OPTIX_ROOT_DIR to point to the Optix SDK folder.\n\
The build scripts expect BLENDER_OPTIX_ROOT_DIR/include/optix.h.\n\
\n"
			fi
		fi
	fi
fi

	if (( ${#BLENDER_CMAKE_ARGS[@]} > 0 )) ; then
		# Set as per-package environmental variable
		# For setting up optix/cuda
		mycmakeargs+=( ${BLENDER_CMAKE_ARGS[@]} )
	fi
	S="${BUILD_DIR}" \
	CMAKE_USE_DIR="${BUILD_DIR}" \
	BUILD_DIR="${WORKDIR}/${P}_${EBLENDER}" \
	cmake-utils_src_configure
}

src_configure() {
	blender_configure() {
		cd "${BUILD_DIR}" || die
		_src_configure
	}
	blender_foreach_impl blender_configure
}

_src_compile() {
	S="${BUILD_DIR}" \
	CMAKE_USE_DIR="${BUILD_DIR}" \
	BUILD_DIR="${WORKDIR}/${P}_${EBLENDER}" \
	cmake-utils_src_compile
}

_src_compile_docs() {
	if use doc; then
		# Workaround for binary drivers.
		addpredict /dev/ati
		addpredict /dev/dri
		addpredict /dev/nvidiactl

		einfo "Generating Blender C/C++ API docs ..."
		cd "${CMAKE_USE_DIR}"/doc/doxygen || die
		doxygen -u Doxyfile || die
		doxygen || die "doxygen failed to build API docs."

		cd "${CMAKE_USE_DIR}" || die
		einfo "Generating (BPY) Blender Python API docs ..."
		"${BUILD_DIR}"/bin/blender --background \
			--python doc/python_api/sphinx_doc_gen.py -noaudio \
			|| die "sphinx failed."

		cd "${CMAKE_USE_DIR}"/doc/python_api || die
		sphinx-build sphinx-in BPY_API || die "sphinx failed."
	fi
}

src_compile() {
	blender_compile() {
		cd "${BUILD_DIR}" || die
		_src_compile
		if [[ "${EBLENDER}" == "build_creator" ]] ; then
			_src_compile_docs
		fi
	}
	blender_foreach_impl blender_compile
}

_src_test() {
	if use test; then
		einfo "Running Blender Unit Tests for ${EBLENDER} ..."
		cd "${BUILD_DIR}"/bin/tests || die
		local f
		for f in *_test; do
			./"${f}" || die
		done
	fi
}

src_test() {
	blender_test() {
		cd "${BUILD_DIR}" || die
		_src_test
	}
	blender_foreach_impl blender_test
}

_src_install_cycles_network() {
	if use cycles-network ; then
		exeinto "${d_dest}"
		dosym "../../..${d_dest}/cycles_server" \
			"/usr/bin/cycles_server-${SLOT_MAJ}" || die
		doexe "${CMAKE_BUILD_DIR}${d_dest}/cycles_server"
	fi
}

_src_install_doc() {
	if use doc; then
		docinto "html/API/python"
		dodoc -r "${CMAKE_USE_DIR}"/doc/python_api/BPY_API/.

		docinto "html/API/blender"
		dodoc -r "${CMAKE_USE_DIR}"/doc/doxygen/html/.
	fi

	# fix doc installdir
	docinto "html"
	dodoc "${CMAKE_USE_DIR}"/release/text/readme.html
	rm -r "${ED%/}"/usr/share/doc/blender || die
}

install_licenses() {
	for f in $(find "${BUILD_DIR}" -iname "*license*" -type f \
	  -o -iname "*copyright*" \
	  -o -iname "*copying*" \
	  -o -path "*/license/*" \
	  -o -path "*/macholib/README.ctypes" \
	  -o -path "*/materials_library_vx/README.txt" ) ; \
	do
		if [[ -f "${f}" ]] ; then
			d=$(dirname "${f}" | sed -e "s|^${BUILD_DIR}||")
		else
			d=$(echo "${f}" | sed -e "s|^${BUILD_DIR}||")
		fi
		docinto "licenses/${d}"
		dodoc -r "${f}"
	done
}

install_readmes() {
	for f in $(find "${BUILD_DIR}" -iname "*readme*") ; \
	do
		if [[ -f "${f}" ]] ; then
			d=$(dirname "${f}" | sed -e "s|^${BUILD_DIR}||")
		else
			d=$(echo "${f}" | sed -e "s|^${BUILD_DIR}||")
		fi
		docinto "readmes/${d}"
		dodoc -r "${f}"
	done
}

_src_install() {
	# Pax mark blender for hardened support.
	pax-mark m "${CMAKE_BUILD_DIR}"/bin/blender

	S="${BUILD_DIR}" \
	CMAKE_USE_DIR="${BUILD_DIR}" \
	BUILD_DIR="${WORKDIR}/${P}_${EBLENDER}" \
	cmake-utils_src_install
	if [[ "${EBLENDER}" == "build_creator" ]] ; then
		CMAKE_USE_DIR="${BUILD_DIR}" \
		_src_install_doc
	fi

	local d_dest=$(get_dest)
	if [[ "${EBLENDER}" == "build_creator" ]] ; then
		python_fix_shebang "${ED%/}${d_dest}/blender-thumbnailer.py"
		python_optimize "${ED%/}/usr/share/blender/${SLOT_MAJ}/scripts"
	fi

	if [[ "${EBLENDER}" == "build_creator" \
		|| "${EBLENDER}" == "build_headless" ]] ; then
		_src_install_cycles_network
	fi

	_LD_LIBRARY_PATH=()
	if use openvdb ; then
		_LD_LIBRARY_PATH+=( "/usr/$(get_libdir)/blender/openvdb/${OPENVDB_V_DIR}/usr/$(get_libdir)\n" )
	fi
	if use osl ; then
		_LD_LIBRARY_PATH+=( "/usr/$(get_libdir)/blender/mesa/${LLVM_V}/usr/$(get_libdir)\n" )
		_LD_LIBRARY_PATH+=( "/usr/$(get_libdir)/blender/osl/${LLVM_V}/usr/$(get_libdir)\n" )
	fi
	if [[ -d "${EROOT}/usr/$(get_libdir)/blender/boost/${CXXABI_V}/usr/$(get_libdir)" ]] ; then
		sed -i -e "s|#BOOST ||g" \
			"${T}/${PN}-${SLOT_MAJ}" || die
	fi
	_LD_LIBRARY_PATH=$(echo -e "${_LD_LIBRARY_PATH[@]}" | tr "\n" ":")

	if [[ "${EBLENDER}" == "build_creator" ]] ; then
		cp "${ED}/usr/share/applications"/blender{,-${SLOT_MAJ}}.desktop || die
		local menu_file="${ED}/usr/share/applications/blender-${SLOT_MAJ}.desktop"
		sed -i -e "s|Name=Blender|Name=Blender ${PV}|g" "${menu_file}" || die
		sed -i -e "s|Exec=blender|Exec=/usr/bin/${PN}-${SLOT_MAJ}|g" "${menu_file}" || die
		sed -i -e "s|Icon=blender|Icon=blender-${SLOT_MAJ}|g" "${menu_file}" || die
		cp "${FILESDIR}/blender-wrapper" \
			"${T}/${PN}-${SLOT_MAJ}" || die
		sed -i -e "s|\${BLENDER_EXE}|${d_dest}/blender|g" \
			-e "s|#LD_LIBRARY_PATH|${LD_LIBRARY_PATH}|g" \
			"${T}/${PN}-${SLOT_MAJ}" || die
		exeinto /usr/bin
		doexe "${T}/${PN}-${SLOT_MAJ}"
	elif [[ "${EBLENDER}" == "build_headless" ]] ; then
		cp "${FILESDIR}/blender-wrapper" \
			"${T}/${PN}-headless-${SLOT_MAJ}" || die
		sed -i -e "s|\${BLENDER_EXE}|${d_dest}/blender|g" \
			-e "s|#LD_LIBRARY_PATH|${LD_LIBRARY_PATH}|g" \
			"${T}/${PN}-headless-${SLOT_MAJ}" || die
		exeinto /usr/bin
		doexe "${T}/${PN}-headless-${SLOT_MAJ}"
	fi
	install_licenses
	if use doc ; then
		install_readmes
	fi
}

src_install() {
	blender_install() {
		cd "${BUILD_DIR}" || die
		_src_install
	}
	blender_foreach_impl blender_install
	local ed_icon_hc="${ED}/usr/share/icons/hicolor"
	local ed_icon_scale="${ed_icon_hc}/scalable"
	local ed_icon_sym="${ed_icon_hc}/symbolic"
	if [[ -e "${ed_icon_scale}/apps/blender.svg" ]] ; then
		mv "${ed_icon_scale}/apps/blender"{,-${SLOT_MAJ}}".svg" || die
		mv "${ed_icon_sym}/apps/blender-symbolic"{,-${SLOT_MAJ}}".svg"
	fi
	rm -rf "${ED}/usr/share/applications/blender.desktop" || die
	if [[ -d "${ED}/usr/share/doc/blender" ]] ; then
		mv "${ED}/usr/share/doc/blender"{,-${SLOT_MAJ}} || die
	fi
	mv "${ED}/usr/share/man/man1/blender"{,-${SLOT_MAJ}}".1"
}

pkg_postinst() {
	elog
	elog "Blender uses python integration. As such, may have some"
	elog "inherit risks with running unknown python scripts."
	elog
	elog "It is recommended to change your blender temp directory"
	elog "from /tmp to /home/user/tmp or another tmp file under your"
	elog "home directory. This can be done by starting blender, then"
	elog "dragging the main menu down do display all paths."
	elog
	ewarn
	ewarn "This ebuild does not unbundle the massive amount of 3rd party"
	ewarn "libraries which are shipped with blender. Note that"
	ewarn "these have caused security issues in the past."
	ewarn "If you are concerned about security, file a bug upstream:"
	ewarn "  https://developer.blender.org/"
	ewarn
	if use cycles-network ; then
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
	xdg_pkg_postinst
	local d_src="${EROOT}/usr/bin/.${PN}"
	local V=""
	if [[ -n "${BLENDER_MAIN_SYMLINK_MODE}" \
	&& "${BLENDER_MAIN_SYMLINK_MODE}" == "latest-lts" ]] ; then
		# highest lts
		V=$(ls "${d_src}"/*/creator/.lts | sort -V | tail -n 1 \
			| cut -f 5 -d "/")
	elif [[ -n "${BLENDER_MAIN_SYMLINK_MODE}" \
	&& "${BLENDER_MAIN_SYMLINK_MODE}" == "latest" ]] ; then
		# highest v
		V=$(ls "${EROOT}${d_src}/" | sort -V | tail -n 1)
	elif [[ -n "${BLENDER_MAIN_SYMLINK_MODE}" \
	&& "${BLENDER_MAIN_SYMLINK_MODE}" =~ ^custom-[0-9]\.[0-9]+$ ]] ; then
		# custom v
		V=$(echo "${BLENDER_MAIN_SYMLINK_MODE}" | cut -f 2 -d "-")
	fi
	if [[ -n "${V}" ]] ; then
		if use build_creator ; then
			ln -sf "${EROOT}${d_src}/${V}/creator/blender" \
				"${EROOT}/usr/bin/blender" || die
		fi
		if use build_headless ; then
			ln -sf "${EROOT}${d_src}/${V}/headless/blender" \
				"${EROOT}/usr/bin/blender-headless" || die
		fi
		if [[ -e "${EROOT}${d_src}/${V}/creator/cycles_server" ]] \
			&& use cycles-network ; then
			ln -sf "${EROOT}${d_src}/${V}/creator/cycles_server" \
				"${EROOT}/usr/bin/cycles_server" || die
		elif [[ -e "${EROOT}${d_src}/${V}/headless/cycles_server" ]] \
			&& use cycles-network ; then
			ln -sf "${EROOT}${d_src}/${V}/headless/cycles_server" \
				"${EROOT}/usr/bin/cycles_server" || die
		fi
	fi
}

pkg_postrm() {
	xdg_pkg_postrm

	ewarn ""
	ewarn "You may want to remove the following directory."
	ewarn "~/.config/${PN}/${SLOT_MAJ}/cache/"
	ewarn "It may contain extra render kernels not tracked by portage"
	ewarn ""
	if [[ ! -d "${EROOT}/usr/bin/.blender" ]] ; then
		if [[ -e "${EROOT}/usr/bin/blender" ]] ; then
			rm -rf "${EROOT}/usr/bin/blender" || die
		fi
		if [[ -e "${EROOT}/usr/bin/blender-headless" ]] ; then
			rm -rf "${EROOT}/usr/bin/blender-headless" || die
		fi
		if [[ -e "${EROOT}/usr/bin/cycles_server" ]] ; then
			rm -rf "${EROOT}/usr/bin/cycles_server" || die
		fi
	fi
}
