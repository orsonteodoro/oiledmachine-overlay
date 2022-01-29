# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: blender-v3.0.eclass
# @MAINTAINER: orsonteodoro@hotmail.com
# @BLURB: blender implementation
# @DESCRIPTION:
# The blender-v3.0.eclass helps reduce code duplication across ebuilds
# using the same major.minor version.

# Upstream uses LLVM 9 for Linux.  For prebuilt binary only addons, this may be
# problematic so avoid them.

# The ebuild uses the same matching LLVM version used with Mesa to prevent
# the multiple LLVM bug.

CXXABI_V=17 # Linux builds should be gnu11, but in Win builds it is c++17
PYTHON_COMPAT=( python3_{9,10} ) # For the max exclusive Python supported (and
# others), see \
# https://github.com/blender/blender/blob/blender-v3.0-release/build_files/build_environment/install_deps.sh#L382

# Platform defaults based on CMakeList.txt
#1234567890123456789012345678901234567890123456789012345678901234567890123456789
OPENVDB_ABIS_MAJOR_VERS=( 8 )
OPENVDB_ABIS=( ${OPENVDB_ABIS_MAJOR_VERS[@]/#/abi} )
OPENVDB_ABIS=( ${OPENVDB_ABIS[@]/%/-compat} )
IUSE+=" ${OPENVDB_ABIS[@]}"
IUSE+=" X +abi8-compat +alembic -asan +boost +bullet +collada -cycles-hip
+color-management -cpudetection +cuda +cycles +dds -debug doc +draco +elbeem
+embree +ffmpeg +fftw flac +gmp +jack +jemalloc +jpeg2k -llvm -man +nanovdb
+ndof +nls +nvcc -nvrtc +openal +opencl +openexr +openimagedenoise +openimageio
+openmp +opensubdiv +openvdb +openxr -optix +osl +pdf +potrace +pulseaudio
release +sdl +sndfile +tbb test +tiff +usd -valgrind"
LLVM_MAX_UPSTREAM="12" # (inclusive)
LLVM_SLOTS=(13 12 11)
gen_llvm_iuse()
{
	local o=""
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		o+=" llvm-${s}"
	done
	echo "${o}"
}
IUSE+=" "$(gen_llvm_iuse) # same as Mesa and LLVM latest stable keyword \
# For max and min package versions see link below. \
# https://github.com/blender/blender/blob/blender-v3.0-release/build_files/build_environment/install_deps.sh#L488
FFMPEG_IUSE+=" jpeg2k +mp3 opus +theora vorbis vpx webm x264 xvid"
IUSE+=" ${FFMPEG_IUSE}"

CLANG_MIN="8.0"
GCC_MIN="9.3"
inherit blender

# See the blender.eclass for the LICENSE variable.
LICENSE+=" CC-BY-4.0" # The splash screen is CC-BY stated in https://www.blender.org/download/demo-files/ )

# The release USE flag depends on platform defaults.
REQUIRED_USE+="
	^^ ( ${LLVM_SLOTS[@]/#/llvm-} )
	^^ ( ${OPENVDB_ABIS[@]} )
	!boost? ( !alembic !cycles !nls !openvdb
		!color-management )
	!tbb? ( !cycles !elbeem !openimagedenoise !openvdb )
	build_creator? ( X )
	cuda? ( cycles ^^ ( nvcc nvrtc ) )
	cycles? ( tbb )
	cycles-hip? ( cycles )
	embree? ( cycles )
	mp3? ( ffmpeg )
	nanovdb? ( cycles openvdb || ( cuda opencl ) )
	nvcc? ( || ( cuda optix ) )
	nvrtc? ( || ( cuda optix ) )
	opencl? ( cycles )
	openimagedenoise? ( tbb )
	openvdb? ( || ( ${OPENVDB_ABIS[@]} ) openexr tbb )
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
		dds
		!debug
		draco
		elbeem
		embree
		ffmpeg
		fftw
		gmp
		jack
		jemalloc
		jpeg2k
		man
		nanovdb
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
		pdf
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

# Keep dates and links updated to speed up releases and decrease maintenance time cost.
# no need to look past those dates.

# Last change was Nov 10, 2021 for:
# https://github.com/blender/blender/commits/blender-v3.0-release/build_files/cmake/config/blender_release.cmake
# used for REQUIRED_USE section.

# Last change was Oct 21, 2021 for:
# https://github.com/blender/blender/commits/blender-v3.0-release/build_files/build_environment/cmake/versions.cmake
# used for *DEPENDs.

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

gen_llvm_depends()
{
	local o
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		o+="
			llvm-${s}? ( >=sys-devel/llvm-${s}:${s}= )
		"
	done
	echo "${o}"
}

gen_oiio_depends() {
	local o
	local s
	for s in ${OPENVDB_ABIS[@]} ; do
		o+="
			${s}? (
				>=media-libs/openimageio-2.2.15.1[${s},color-management?,jpeg2k?]
			)
		"
	done
	echo "${o}"
}

gen_openvdb_depends() {
	local o
	local s
	for s in ${OPENVDB_ABIS_MAJOR_VERS[@]} ; do
		if (( ${s} == 8 )) ; then
			o+="
				abi${s}-compat? (
					>=media-gfx/openvdb-8.0.1[${PYTHON_SINGLE_USEDEP},abi${s}-compat]
				)
			"
		else
			o+="
				abi${s}-compat? (
					>=media-gfx/openvdb-${s}[${PYTHON_SINGLE_USEDEP},abi${s}-compat]
				)
			"
		fi
	done
	echo "${o}"
}

gen_osl_depends()
{
	local o
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		o+="
			llvm-${s}? ( >=media-libs/osl-${OSL_V}:=[llvm-${s},static-libs] )
		"
	done
	echo "${o}"
}

ONETBB_SLOT="0"
LEGACY_TBB_SLOT="2"
OSL_V="1.11.14.1"
PUGIXML_DEPEND=">=dev-libs/pugixml-1.10"
RDEPEND+="  ${PYTHON_DEPS}
	>=dev-lang/python-3.9.7
	>=dev-libs/wayland-protocols-1.21
	dev-libs/lzo:2
	$(python_gen_cond_dep '
		>=dev-python/certifi-2021.10.8[${PYTHON_MULTI_USEDEP}]
		>=dev-python/charset_normalizer-2.0.6[${PYTHON_MULTI_USEDEP}]
		>=dev-python/idna-3.2[${PYTHON_MULTI_USEDEP}]
		>=dev-python/numpy-1.21.2[${PYTHON_MULTI_USEDEP}]
		>=dev-python/requests-2.26.0[${PYTHON_MULTI_USEDEP}]
		>=dev-python/urllib3-1.26.7[${PYTHON_MULTI_USEDEP}]
		>=dev-python/zstandard-0.15.2[${PYTHON_MULTI_USEDEP}]
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
	llvm-11? (
		>=media-libs/mesa-20.3.5
		>=sys-libs/libomp-11
	)
	llvm-12? (
		>=media-libs/mesa-20.1.5
		>=sys-libs/libomp-12
	)
	llvm-13? (
		>=media-libs/mesa-21.2.5
		>=sys-libs/libomp-13
	)
	media-libs/libglvnd
	alembic? ( >=media-gfx/alembic-1.7.16[boost(+),hdf(+)] )
	boost? (
		!usd? ( >=dev-libs/boost-1.73:=[nls?,threads(+)] )
		usd? ( >=dev-libs/boost-1.73:=[nls?,threads(+),python] )
	)
	collada? (
		dev-libs/libpcre:=[static-libs]
		>=media-libs/opencollada-1.6.68:=
	)
	color-management? (
		>=media-libs/opencolorio-2
		>=dev-libs/expat-2.2.8
	)
	cuda? (
		>=x11-drivers/nvidia-drivers-418.39
		>=dev-util/nvidia-cuda-toolkit-10.1:=
	)
	cycles? (
		osl? ( ${PUGIXML_DEPEND} )
	)
	cycles-hip? (
		|| (
			dev-util/hip
			dev-libs/rocm-bin[hip-devel,hip-runtime-amd]
		)
	)
	embree? ( >=media-libs/embree-3.10.0:=\
[cpu_flags_x86_sse4_2?,cpu_flags_x86_avx?,cpu_flags_x86_avx2?,raymask,static-libs] )
	ffmpeg? ( >=media-video/ffmpeg-4.4:=\
[encode,jpeg2k?,mp3?,opus?,theora?,vorbis?,vpx?,x264,xvid?,zlib] )
	fftw? ( >=sci-libs/fftw-3.3.8:3.0= )
	flac? ( >=media-libs/flac-1.3.3 )
	gmp? ( >=dev-libs/gmp-6.2 )
	jack? ( virtual/jack )
	jemalloc? ( >=dev-libs/jemalloc-5.2.1:= )
	jpeg2k? ( >=media-libs/openjpeg-2.3.1:2 )
	llvm? ( $(gen_llvm_depends) )
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
	openimagedenoise? (
		>=media-libs/oidn-1.4.1
	)
	openimageio? (
		$(gen_oiio_depends)
		${PUGIXML_DEPEND}
	)
	openexr? (
		>=media-libs/ilmbase-2.5.5:=
		>=media-libs/openexr-2.5.5:=
	)
	opensubdiv? ( >=media-libs/opensubdiv-3.4.3:=[cuda=,opencl=] )
	openvdb? (
		$(gen_openvdb_depends)
		>=dev-libs/c-blosc-1.5.0
		nanovdb? ( >=media-gfx/nanovdb-32.3.3_pre20211001:= )
	)
	openxr? ( >=media-libs/openxr-1.0.17 )
	optix? ( >=dev-libs/optix-7 )
	osl? ( $(gen_osl_depends) )
	pdf? ( >=media-libs/libharu-2.3.0 )
	potrace? ( >=media-gfx/potrace-1.16 )
	pulseaudio? ( media-sound/pulseaudio )
	sdl? ( >=media-libs/libsdl2-2.0.12[sound] )
	sndfile? ( >=media-libs/libsndfile-1.0.28 )
	tbb? ( >=dev-cpp/tbb-2020.2 )
	tiff? ( >=media-libs/tiff-4.1.0:0[zlib] )
	usd? (
		>=media-libs/openusd-21.11[monolithic]
		<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}=
	)
	valgrind? ( dev-util/valgrind )
	X? (
		x11-libs/libX11
		x11-libs/libXi
		x11-libs/libXxf86vm
	)"
DEPEND+=" ${RDEPEND}
	>=dev-cpp/eigen-3.3.7:3=
"
gen_asan_bdepend() {
	local s
	local o
	for s in ${LLVM_SLOTS[@]} ; do
		o+="
			llvm-${s}? (
				sys-devel/clang:${s}
				=sys-libs/compiler-rt-sanitizers-${s}*[asan]
				=sys-devel/clang-runtime-${s}[compiler-rt,sanitize]
			)
		"
	done
	echo "${o}"
}
BDEPEND+="
	|| (
		>=sys-devel/clang-${CLANG_MIN}
		>=sys-devel/gcc-${GCC_MIN}
	)
	>=dev-util/cmake-3.10
	virtual/pkgconfig
	asan? ( || (
			$(gen_asan_bdepend)
			(
				>=sys-devel/gcc-${GCC_MIN}[sanitizer]
			)
		)
	)
	cycles? (
		x86? ( || (
			>=sys-devel/clang-${CLANG_MIN}
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
	"${FILESDIR}/${PN}-3.0.0-install-paths-change.patch"
	"${FILESDIR}/${PN}-3.0.0-openusd-21.11-lib-renamed.patch"
	"${FILESDIR}/${PN}-3.0.0-openusd-21.11-python.patch"
	"${FILESDIR}/${PN}-3.0.0-openusd-21-ConnectToSource.patch"
	"${FILESDIR}/${PN}-3.0.0-openusd-21.11-lightapi.patch"
	"${FILESDIR}/${PN}-3.0.0-openusd-21.11-replace-IsInMaster.patch"
	"${FILESDIR}/${PN}-2.93.7-build-draco.patch"
	"${FILESDIR}/${PN}-3.0.0-intern-ghost-fix-typo-in-finding-XF86VMODE.patch"
	"${FILESDIR}/${PN}-3.0.0-boost_python.patch"
	"${FILESDIR}/${PN}-3.0.0-oiio-util.patch"
)

check_multiple_llvm_versions_in_native_libs() {
	# Checks to avoid loading multiple versions of LLVM.

	local llvm_slot
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		use "llvm-${s}" && llvm_slot=${s}
	done

	if ls ldd "${EROOT}"/usr/$(get_libdir)/dri/*.so 2>/dev/null 1>/dev/null ; then
		local llvm_ret=$(ldd "${EROOT}"/usr/$(get_libdir)/dri/*.so \
			| grep -q -e "LLVM-${llvm_slot}")
		if [[ "${llvm_ret}" != "0" ]] ; then
			die \
"You need link media-libs/mesa with LLVM ${llvm_slot}.  See media-libs/mesa \
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
			&& ver_test "${osl_llvm}" -ne "${llvm_slot}" ; then
			die "media-libs/osl must be linked to LLVM ${llvm_slot}"
		fi
	fi
}

_blender_pkg_setup() {
	# Needs OpenCL 1.2 (GCN 2)
	check_multiple_llvm_versions_in_native_libs
	ewarn
	ewarn "This version is not a Long Term Support (LTS) version."
	ewarn "Consider using 2.93.x series instead."
	ewarn

	local found=0
	for s in ${LLVM_SLOTS[@]} ; do
		if (( "${s}" > ${LLVM_MAX_UPSTREAM} )) ; then
			use "llvm-${s}" && found=${s}
		fi
	done

	if (( ${found} != 0 )) ; then
ewarn
ewarn "Upstream supports <= LLVM-${LLVM_MAX_UPSTREAM}.x only."
ewarn "sys-devel/llvm:${found} compatibility is still in testing in this"
ewarn "overlay and made available to resolve the multiple LLVM libraries"
ewarn "loaded bug which includes (proprietary) GPU driver parts linked with a"
ewarn "different version of LLVM.  To avoid this bug, use the same LLVM"
ewarn "version from the driver to this package in the dependency chain"
ewarn "including all dependencies of this package."
ewarn
	fi
}

show_tbb_error() {
	eerror
	eerror "You can only choose one adventure:"
	eerror
	eerror "  (1) disable the usd USE flag"
	eerror "  (2) use the tbb:${LEGACY_TBB_SLOT} from the oiledmachine-overlay"
	eerror "  (3) use the <tbb-2021:0::gentoo and hardmask tbb >= 2021"
	eerror
	eerror "Any downgrade or upgrade may require a rebuild of those packages"
	eerror "depending on them."
	eerror
	die
}

_src_prepare_patches() {
	eapply "${FILESDIR}/blender-3.0.0-parent-datafiles-dir-change.patch"
	if ( has_version "<dev-cpp/tbb-2021:0" || has_version "<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}" ) && use usd ; then
		:;
	elif has_version ">=dev-cpp/tbb-2021:${ONETBB_SLOT}" && ! has_version "<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}" && use usd ; then
		show_tbb_error
	fi
}

_src_configure() {
	filter-flags '-fprofile*'
	if use pgo && [[ "${PGO_PHASE}" == "pgi" ]] \
		&& has_pgo_requirement ; then
		einfo "Setting up PGI"
		if tc-is-clang ; then
			append-flags -fprofile-generate="${T}/pgo-${ABI}"
		else
			append-flags -fprofile-generate -fprofile-dir="${T}/pgo-${ABI}"
		fi
	elif use pgo && [[ "${PGO_PHASE}" == "pgo" ]] \
		&& has_pgo_requirement ; then
		einfo "Setting up PGO"
		if tc-is-clang ; then
			llvm-profdata merge -output="${T}/pgo-${ABI}/pgo-custom.profdata" \
				"${T}/pgo-${ABI}" || die
			append-flags -fprofile-use="${T}/pgo-${ABI}/pgo-custom.profdata"
		else
			append-flags -fprofile-use -fprofile-correction -fprofile-dir="${T}/pgo-${ABI}"
		fi
	fi

	# FIX: forcing '-funsigned-char' fixes an anti-aliasing issue with menu
	# shadows, see bug #276338 for reference
	append-flags -funsigned-char
	append-lfs-flags

	for s in ${OPENVDB_ABIS_MAJOR_VERS[@]} ; do
		if use abi${s}-compat ; then
			append-cppflags -DOPENVDB_ABI_VERSION_NUMBER=${s}
		fi
	done

	local mycmakeargs=()
	mycmakeargs+=( -DCMAKE_INSTALL_BINDIR:PATH=$(get_dest) )

	unset CMAKE_INCLUDE_PATH
	unset CMAKE_LIBRARY_PATH
	unset CMAKE_PREFIX_PATH

	blender_configure_simd_cycles
	blender_configure_eigen

	if use openxr || use osl ; then
		blender_configure_mesa_match_system_llvm
	fi

	blender_configure_nanovdb

	# Just attach the abi as a suffix for the key for multiabi support.
	_LD_LIBRARY_PATHS[${EBLENDER}]="${_LD_LIBRARY_PATH}"
	_LIBGL_DRIVERS_DIRS[${EBLENDER}]="${_LIBGL_DRIVERS_DIR}"
	_LIBGL_DRIVERS_PATHS[${EBLENDER}]="${_LIBGL_DRIVERS_PATH}"
	_PATHS[${EBLENDER}]="${_PATH}"

	# TODO: migrate blender-libs changes from blender-v2.83 once LLVM-10 is deprecated

	# WITH_INPUT_IME is default ON upstream but only supports non-linux
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
		-DWITH_CYCLES_HIP_BINARIES=$(usex cycles-hip)
		-DWITH_DOC_MANPAGE=$(usex man)
		-DWITH_DRACO=$(usex draco)
		-DWITH_GMP=$(usex gmp)
		-DWITH_IK_SOLVER=ON
		-DWITH_INPUT_IME=OFF
		-DWITH_IMAGE_DDS=$(usex dds)
		-DWITH_IMAGE_OPENEXR=$(usex openexr)
		-DWITH_IMAGE_OPENJPEG=$(usex jpeg2k)
		-DWITH_IMAGE_TIFF=$(usex tiff)
		-DWITH_INTERNATIONAL=$(usex nls)
		-DWITH_HARU=$(usex pdf)
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
		-DWITH_PUGIXML=$(usex openimageio ON $(usex osl ON OFF))
		-DWITH_PULSEAUDIO=$(usex pulseaudio)
		-DWITH_PYTHON_INSTALL=OFF
		-DWITH_PYTHON_INSTALL_NUMPY=OFF
		-DWITH_USD=$(usex usd)
		-DWITH_TBB=$(usex tbb)
		-DWITH_XR_OPENXR=$(usex openxr)
	)

	blender_configure_linker_flags

	if use usd ; then
		blender_configure_openusd
	fi

	if [[ "${EBLENDER}" == "build_creator" ]] ; then
		if use jack || use openal || use pulseaudio ; then
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
# https://github.com/blender/blender/tree/blender-v3.0-release/build_files/cmake/config
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
			-DWITH_CYCLES_OSL=$(usex osl)
			-DWITH_STATIC_LIBS=OFF
			-DWITH_SYSTEM_EIGEN3=ON
			-DWITH_SYSTEM_GLEW=ON
			-DWITH_SYSTEM_LZO=ON
		)
	fi

	if use pgo && [[ ${PGO_PHASE} == "pgi" ]] ; then
		# The paths are relative
		mycmakeargs+=(
			-DWITH_INSTALL_PORTABLE=ON
		)
	else
		# The paths are hardcoded?
		mycmakeargs+=(
			-DWITH_INSTALL_PORTABLE=OFF
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
