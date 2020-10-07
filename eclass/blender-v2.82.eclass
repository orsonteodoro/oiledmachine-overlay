# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: blender-v2.82.eclass
# @MAINTAINER: orsonteodoro@hotmail.com
# @BLURB: blender implementation
# @DESCRIPTION:
# The blender-v2.82.eclass helps reduce code duplication across ebuilds
# using the same major.minor version.

CXXABI_V=11
LLVM_V=9
LLVM_MAX_SLOT=${LLVM_V}
PYTHON_COMPAT=( python3_{7,8} )

# Platform defaults based on CMakeList.txt
#1234567890123456789012345678901234567890123456789012345678901234567890123456789
IUSE=" X +abi7-compat -asan +bullet +collada +color-management -cpudetection \
+cuda +cycles -cycles-network +dds -debug doc +elbeem -embree +ffmpeg +fftw \
flac +jack +jemalloc +jpeg2k -llvm -man +ndof +nls +nvcc -nvrtc +openal \
+opencl +openexr +openimagedenoise +openimageio +openmp +opensubdiv +openvdb \
-optix +osl release +sdl +sndfile test +tiff -valgrind"
FFMPEG_IUSE+=" jpeg2k +mp3 opus +theora vorbis vpx webm x264 xvid"
IUSE+=" ${FFMPEG_IUSE}"

inherit blender

# See the blender.eclass for the LICENSE variable.

# The release USE flag depends on platform defaults.
REQUIRED_USE+="
	build_creator? ( X )
	cuda? ( cycles ^^ ( nvcc nvrtc ) )
	embree? ( cycles )
	mp3? ( ffmpeg )
	nvcc? ( || ( cuda optix ) )
	nvrtc? ( || ( cuda optix ) )
	opencl? ( cycles )
	openvdb? ( abi7-compat )
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
# Track build_files/build_environment/dependencies.dot for ffmpeg dependencies
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
	collada? (
		dev-libs/libpcre:=[static-libs]
		>=media-libs/opencollada-1.6.68:=
	)
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
	flac? ( >=media-libs/flac-1.3.2 )
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
		>=media-libs/ilmbase-2.4.0:=
		>=media-libs/openexr-2.4.0:=
	)
	opensubdiv? ( >=media-libs/opensubdiv-3.4.0_rc2:=[cuda=,opencl=] )
	!openvdb? (
		|| (
			>=blender-libs/boost-1.70:${CXXABI_V}=[nls?,threads(+)]
			>=dev-libs/boost-1.70:=[nls?,threads(+)]
		)
	)
	openvdb? (
	>=blender-libs/openvdb-7:7-${CXXABI_V}[${PYTHON_SINGLE_USEDEP},abi7-compat(+)]
	 <blender-libs/openvdb-7.1:7-${CXXABI_V}[${PYTHON_SINGLE_USEDEP},abi7-compat(+)]
		>=blender-libs/boost-1.70:${CXXABI_V}=[nls?,threads(+)]
		>=dev-cpp/tbb-2019.9
		>=dev-libs/c-blosc-1.5.0
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

_blender_pkg_setup() {
	# Needs OpenCL 1.2 (GCN 2)
	export OPENVDB_V=$(usex openvdb 7 "")
	export OPENVDB_V_DIR=$(usex openvdb 7-${CXXABI_V} "")
	if use openvdb ; then
		if ! grep -q -F -e "delta()" \
"$(erdpfx)/openvdb/${OPENVDB_V_DIR}/usr/include/openvdb/util/CpuTimer.h" ; then
			if use abi7-compat ; then
				# compatible as long as the function is present?
				die "OpenVDB delta() is missing try <=7.1.x only"
			fi
		fi
	fi
	ewarn
	ewarn "This version is not a Long Term Support (LTS) version."
	ewarn "Use 2.83.x series instead."
	ewarn
}

_src_prepare_patches() {
	eapply "${FILESDIR}/blender-2.81a-parent-datafiles-dir-change.patch"

	if use osl ; then
		sed -i "/[/]usr[/]include[/]OSL[/]/a\    /usr/$(get_libdir)/${PN}/osl/${LLVM_V}/usr/include/OSL" \
			build_files/cmake/Modules/FindOpenShadingLanguage.cmake || die
	fi
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

	blender_configure_simd_cycles
	blender_configure_eigen
	blender_configure_boost_cxxyy
	blender_configure_openvdb_cxxyy
	blender_configure_osl_match_llvm

	if use osl ; then
		blender_configure_mesa_match_llvm
	fi

	# Just attach the abi as a suffix for the key for multiabi support.
	_LD_LIBRARY_PATHS[${EBLENDER}]="${_LD_LIBRARY_PATH}"
	_LIBGL_DRIVERS_DIRS[${EBLENDER}]="${_LIBGL_DRIVERS_DIR}"
	_LIBGL_DRIVERS_PATHS[${EBLENDER}]="${_LIBGL_DRIVERS_PATH}"
	_PATHS[${EBLENDER}]="${_PATH}"

	if [[ -n "${_LD_LIBRARY_PATH}" ]] ; then
		sed -i -e "s|\[blender_bin|['env', \"LD_LIBRARY_PATH=${_LD_LIBRARY_PATH}\", \"LIBGL_DRIVERS_DIR=${_LIBGL_DRIVERS_DIR}\", \"LIBGL_DRIVERS_PATH=${_LIBGL_DRIVERS_PATH}\", blender_bin|" \
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
# https://github.com/blender/blender/tree/v2.82/build_files/cmake/config
# https://github.com/blender/blender/tree/v2.82a/build_files/cmake/config
	if [[ "${EBLENDER}" == "build_creator" \
		|| "${EBLENDER}" == "build_headless" ]] ; then
		mycmakeargs+=(
			-DWITH_CYCLES=$(usex cycles)
			-DWITH_CYCLES_CUBIN_COMPILER=$(usex nvrtc)
			-DWITH_CYCLES_CUDA_BINARIES=$(usex cuda)
			-DWITH_CYCLES_DEVICE_CUDA=$(usex cuda TRUE FALSE)
			-DWITH_CYCLES_DEVICE_OPENCL=$(usex opencl)
			-DWITH_CYCLES_DEVICE_OPTIX=$(usex optix)
			-DWITH_CYCLES_EMBREE=$(usex embree)
			-DWITH_CYCLES_KERNEL_ASAN=$(usex asan)
			-DWITH_CYCLES_NATIVE_ONLY=$(usex cpudetection)
			-DWITH_CYCLES_NETWORK=$(usex cycles-network)
			-DWITH_CYCLES_OSL=$(usex osl)
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
			blender_configure_nvcc
			blender_configure_nvrtc
			blender_configure_optix
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

blender_set_wrapper_deps() {
	if use openvdb ; then
		_LD_LIBRARY_PATH+=( "$(dpfx)/openvdb/${OPENVDB_V_DIR}/usr/$(get_libdir)\n" )
	fi
	if use osl ; then
		_LD_LIBRARY_PATH+=( "$(dpfx)/mesa/${LLVM_V}/usr/$(get_libdir)\n" )
		_LD_LIBRARY_PATH+=( "$(dpfx)/osl/${LLVM_V}/usr/$(get_libdir)\n" )
		_LIBGL_DRIVERS_DIR+=( "$(dpfx)/mesa/${LLVM_V}/usr/$(get_libdir)/dri\n" )
		_LIBGL_DRIVERS_PATH+=( "$(dpfx)/mesa/${LLVM_V}/usr/$(get_libdir)/dri\n" )
		_PATH+=( "$(dpfx)/osl/${LLVM_V}/usr/bin\n" )
	fi
	if [[ -d "$(erdpfx)/boost/${CXXABI_V}/usr/$(get_libdir)" ]] ; then
		_LD_LIBRARY_PATH+=( "$(dpfx)/boost/${CXXABI_V}/usr/$(get_libdir)\n" )
	fi
}
