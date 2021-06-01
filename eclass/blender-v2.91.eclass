# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: blender-v2.91.eclass
# @MAINTAINER: orsonteodoro@hotmail.com
# @BLURB: blender implementation
# @DESCRIPTION:
# The blender-v2.91.eclass helps reduce code duplication across ebuilds
# using the same major.minor version.

CXXABI_V=17 # Linux builds should be gnu11, but in Win builds it is c++17
LLVM_V=11 # originally 10, do not exceed LLVM_MAX_SLOT in mesa stable or make different from mesa stable
LLVM_MAX_SLOT=${LLVM_V}
PYTHON_COMPAT=( python3_{7,8} )

# Platform defaults based on CMakeList.txt
#1234567890123456789012345678901234567890123456789012345678901234567890123456789
IUSE+=" X +abi7-compat +alembic -asan +boost +bullet +collada \
+color-management -cpudetection +cuda +cycles -cycles-network +dds -debug doc \
+elbeem +embree +ffmpeg +fftw flac -gmp +jack +jemalloc +jpeg2k -llvm -man \
-nanovdb +ndof +nls +nvcc -nvrtc +openal +opencl +openexr +openimagedenoise \
+openimageio +openmp +opensubdiv +openvdb +openxr -optix +osl -potrace release \
+sdl +sndfile +tbb test +tiff -valgrind"
FFMPEG_IUSE+=" jpeg2k +mp3 opus +theora vorbis vpx webm x264 xvid"
IUSE+=" ${FFMPEG_IUSE}"

inherit blender

# See the blender.eclass for the LICENSE variable.

# The release USE flag depends on platform defaults.
REQUIRED_USE+="
	!boost? ( !alembic !cycles !cycles-network !nls !openvdb
		!color-management )
	!tbb? ( !cycles !elbeem !openimagedenoise !openvdb )
	build_creator? ( X )
	cuda? ( cycles ^^ ( nvcc nvrtc ) )
	cycles? ( tbb )
	embree? ( cycles )
	mp3? ( ffmpeg )
	nanovdb? ( cycles openvdb || ( cuda opencl ) )
	nvcc? ( || ( cuda optix ) )
	nvrtc? ( || ( cuda optix ) )
	opencl? ( cycles )
	openimagedenoise? ( tbb )
	openvdb? ( abi7-compat openexr tbb )
	optix? ( cuda cycles nvcc )
	opus? ( ffmpeg )
	osl? ( cycles llvm )
	release? (
		alembic
		boost
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
		embree
		ffmpeg
		fftw
		gmp
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
		openxr
		osl
		potrace
		sdl
		sndfile
		tbb
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

# versions.cmake last date inspected: Jul 7, 2020

# dependency version requirements see
# build_files/build_environment/cmake/versions.cmake
# doc/python_api/requirements.txt
# extern/Eigen3/eigen-update.sh
# Track OPENVDB_LIBRARY_MAJOR_VERSION_NUMBER for changes.
# Track build_files/build_environment/dependencies.dot for ffmpeg dependencies
#
# Mentioned in versions.cmake but missing in (R)DEPENDS freeglut, alembic,
# glfw, clew, cuew, webp, xml2, tinyxml, yaml, lcms, flexbison,
# bzip2 libffi, lzma, openssl, sqlite, usd, mesa, nasm, ispc,
# faad (added in 0.6 ffmpeg but removed in 0.7+)
#
# Already processed as ffmpeg dependency: lame, ogg, vorbis, theora,
# vpx, opus, x264, vidcore
#
# The actual llvm version requested by Blender upstream
#	llvm? ( >=sys-devel/llvm-9.0.1:=
#		 <sys-devel/llvm-10 )
# It should match mesa's linked llvm version to avoid multiple version problem.
# if using system's mesa.
BOOST_DEPEND=">=dev-libs/boost-1.70:=[nls?,threads(+)]"
TBB_DEPEND=">=dev-cpp/tbb-2019.9"
RDEPEND+="  ${PYTHON_DEPS}
	>=dev-lang/python-3.7.7
	dev-libs/lzo:2
	$(python_gen_cond_dep '
		>=dev-python/certifi-2020.4.5.2[${PYTHON_MULTI_USEDEP}]
		>=dev-python/chardet-3.0.4[${PYTHON_MULTI_USEDEP}]
		>=dev-python/idna-2.9[${PYTHON_MULTI_USEDEP}]
		>=dev-python/numpy-1.17.5[${PYTHON_MULTI_USEDEP}]
		>=dev-python/requests-2.23.0[${PYTHON_MULTI_USEDEP}]
		>=dev-python/urllib3-1.25.9[${PYTHON_MULTI_USEDEP}]
	')
	>=media-libs/freetype-2.10.2
	>=media-libs/glew-1.13.0:*
	>=media-libs/libpng-1.6.37:0=
	media-libs/libsamplerate
	>=sys-libs/zlib-1.2.11
	|| (
		virtual/glu
		>=media-libs/glu-9.0.1
	)
	|| (
		virtual/jpeg:0=
		>=media-libs/libjpeg-turbo-2.0.4
	)
	virtual/libintl
	virtual/opengl
	media-libs/libglvnd
	alembic? ( >=media-gfx/alembic-1.7.12[boost(+),hdf(+)] )
	boost? ( ${BOOST_DEPEND} )
	collada? (
		dev-libs/libpcre:=[static-libs]
		>=media-libs/opencollada-1.6.68:=
	)
	color-management? ( >=media-libs/opencolorio-1.1.1 )
	cuda? (
		>=x11-drivers/nvidia-drivers-418.39
		>=dev-util/nvidia-cuda-toolkit-10.1:=
	)
	cycles? ( >=dev-libs/pugixml-1.10 )
	embree? ( >=media-libs/embree-3.10.0:=\
[cpu_flags_x86_sse4_2?,cpu_flags_x86_avx?,cpu_flags_x86_avx2?,raymask,static-libs] )
	ffmpeg? ( >=media-video/ffmpeg-4.2.3:=\
[encode,jpeg2k?,mp3?,opus?,theora?,vorbis?,vpx?,x264,xvid?,zlib] )
	fftw? ( >=sci-libs/fftw-3.3.8:3.0= )
	flac? ( >=media-libs/flac-1.3.3 )
	gmp? ( >=dev-libs/gmp-6.2 )
	jack? ( virtual/jack )
	jemalloc? ( >=dev-libs/jemalloc-5.2.1:= )
	jpeg2k? ( >=media-libs/openjpeg-2.3.1:2 )
	llvm? ( sys-devel/llvm:${LLVM_V}= )
	ndof? (
		app-misc/spacenavd
		>=dev-libs/libspnav-0.2.3
	)
	nls? (
		|| (
			virtual/libiconv
			>=dev-libs/libiconv-1.16
		)
	)
	openal? ( >=media-libs/openal-1.20.1 )
	opencl? ( virtual/opencl )
	openimagedenoise? ( >=media-libs/oidn-1.2.3 )
	openimageio? ( >=media-libs/openimageio-2.1.15.0[color-management?,jpeg2k?] )
	openexr? (
		>=media-libs/ilmbase-2.4.0:=
		>=media-libs/openexr-2.4.0:=
	)
	opensubdiv? ( >=media-libs/opensubdiv-3.4.3:=[cuda=,opencl=] )
	openvdb? (
		>=media-gfx/openvdb-7[${PYTHON_SINGLE_USEDEP},abi7-compat(+)]
		>=dev-libs/c-blosc-1.5.0
		nanovdb? ( >=media-gfx/nanovdb-25.0.0_pre20200924:= )
	)
	openxr? ( >=media-libs/openxr-1.0.8 )
	optix? ( >=dev-libs/optix-7 )
	osl? ( >=media-libs/osl-1.10.10:=[llvm-${LLVM_V},static-libs] )
	potrace? ( >=media-gfx/potrace-1.16 )
	sdl? ( >=media-libs/libsdl2-2.0.12[sound] )
	sndfile? ( >=media-libs/libsndfile-1.0.28 )
	tbb? ( ${TBB_DEPEND} )
	tiff? ( >=media-libs/tiff-4.1.0:0[zlib] )
	valgrind? ( dev-util/valgrind )
	X? (
		x11-libs/libX11
		x11-libs/libXi
		x11-libs/libXxf86vm
	)"
DEPEND+=" ${RDEPEND}
	>=dev-cpp/eigen-3.3.7:3=
"
BDEPEND+="
	>=dev-util/cmake-3.10
	virtual/pkgconfig
	asan? ( || ( sys-devel/clang
                     sys-devel/gcc ) )
	cycles? (
		x86? ( || (
			sys-devel/clang
			dev-lang/icc
		) )
	)
	doc? (
		app-doc/doxygen[dot]
		>=dev-python/sphinx-3.3.1[latex]
		>=dev-python/sphinx_rtd_theme-0.5.0
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
	nls? ( sys-devel/gettext )
"

_PATCHES=(
	"${FILESDIR}/${PN}-2.82a-fix-install-rules.patch"
	"${FILESDIR}/${PN}-2.82a-cycles-network-fixes.patch"
	"${FILESDIR}/${PN}-2.83.1-device_network_h-fixes.patch"
	"${FILESDIR}/${PN}-2.83.1-device_network_h-add-device-header.patch"
	"${FILESDIR}/${PN}-2.83.1-update-acquire_tile-for-cycles-networking.patch"
	"${FILESDIR}/${PN}-2.91.0-install-paths-change.patch"
)

check_multiple_llvm_versions_in_native_libs() {
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

_blender_pkg_setup() {
	# Needs OpenCL 1.2 (GCN 2)
	export OPENVDB_V=$(usex openvdb 7 "")
	export OPENVDB_V_DIR=$(usex openvdb 7-14 "")
	if use openvdb ; then
		if ! grep -q -F -e "delta()" \
"${EROOT}/usr/include/openvdb/util/CpuTimer.h" 2>/dev/null ; then
			if use abi7-compat ; then
				# compatible as long as the function is present?
				die "OpenVDB delta() is missing try < 8.x only"
			fi
		fi
	fi
	check_multiple_llvm_versions_in_native_libs
	ewarn
	ewarn "This version is not a Long Term Support (LTS) version."
	ewarn "Use 2.83.x series instead."
	ewarn
}

_src_prepare_patches() {
	eapply "${FILESDIR}/blender-2.91.0-parent-datafiles-dir-change.patch"
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

	unset CMAKE_INCLUDE_PATH
	unset CMAKE_LIBRARY_PATH
	unset CMAKE_PREFIX_PATH

	blender_configure_simd_cycles
	blender_configure_eigen

	if use openxr || use osl ; then
		blender_configure_mesa_match_system_llvm
	fi

	# Just attach the abi as a suffix for the key for multiabi support.
	_LD_LIBRARY_PATHS[${EBLENDER}]="${_LD_LIBRARY_PATH}"
	_LIBGL_DRIVERS_DIRS[${EBLENDER}]="${_LIBGL_DRIVERS_DIR}"
	_LIBGL_DRIVERS_PATHS[${EBLENDER}]="${_LIBGL_DRIVERS_PATH}"
	_PATHS[${EBLENDER}]="${_PATH}"

	# TODO: migrate blender-libs changes from blender-v2.83 once LLVM-10 is deprecated

	mycmakeargs+=(
		-DPYTHON_VERSION="${EPYTHON/python/}"
		-DPYTHON_LIBRARY="$(python_get_library_path)"
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DSUPPORT_SSE_BUILD=$(usex cpu_flags_x86_sse)
		-DSUPPORT_SSE2_BUILD=$(usex cpu_flags_x86_sse2)
		-DWITH_ALEMBIC=$(usex alembic)
		-DWITH_ASSERT_ABORT=$(usex debug)
		-DWITH_BOOST=$(usex boost)
		-DWITH_BULLET=$(usex bullet)
		-DWITH_COMPILER_ASAN=$(usex asan)
		-DWITH_CPU_SSE=$(usex cpu_flags_x86_sse2)
		-DWITH_CUDA_DYNLOAD=$(usex cuda $(usex nvcc ON OFF) ON)
		-DWITH_CXX_GUARDEDALLOC=$(usex debug)
		-DWITH_CXX11_ABI=ON
		-DWITH_DOC_MANPAGE=$(usex man)
		-DWITH_GMP=$(usex gmp)
		-DWITH_IMAGE_DDS=$(usex dds)
		-DWITH_IMAGE_OPENEXR=$(usex openexr)
		-DWITH_IMAGE_OPENJPEG=$(usex jpeg2k)
		-DWITH_IMAGE_TIFF=$(usex tiff)
		-DWITH_INTERNATIONAL=$(usex nls)
		-DWITH_LLVM=$(usex llvm)
		-DWITH_MEM_JEMALLOC=$(usex jemalloc)
		-DWITH_MEM_VALGRIND=$(usex valgrind)
		-DWITH_MOD_FLUID=$(usex elbeem)
		-DWITH_NANOVDB=$(usex nanovdb)
		-DWITH_OPENCOLLADA=$(usex collada)
		-DWITH_OPENCOLORIO=$(usex color-management)
		-DWITH_OPENIMAGEDENOISE=$(usex openimagedenoise)
		-DWITH_OPENIMAGEIO=$(usex openimageio)
		-DWITH_OPENMP=$(usex openmp)
		-DWITH_OPENSUBDIV=$(usex opensubdiv)
		-DWITH_OPENVDB=$(usex openvdb)
		-DWITH_OPENVDB_BLOSC=$(usex openvdb)
		-DWITH_POTRACE=$(usex potrace)
		-DWITH_PYTHON_INSTALL=OFF
		-DWITH_PYTHON_INSTALL_NUMPY=OFF
		-DWITH_XR_OPENXR=$(usex openxr)
		-DWITH_TBB=$(usex tbb)
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
# https://github.com/blender/blender/tree/v2.91.0/build_files/cmake/config
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

