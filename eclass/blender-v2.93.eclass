# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: blender-v2.93.eclass
# @MAINTAINER: orsonteodoro@hotmail.com
# @SUPPORTED_EAPIS: 7 8
# @BLURB: blender implementation
# @DESCRIPTION:
# The blender-v2.93.eclass helps reduce code duplication across ebuilds
# using the same major.minor version.

# Upstream uses LLVM 9 for Linux.  For prebuilt binary only addons, this may be
# problematic so avoid them.

# The ebuild uses the same matching LLVM version used with Mesa to prevent
# the multiple LLVM bug.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

CXXABI_V=17 # Linux builds should be gnu11, but in Win builds it is c++17
PYTHON_COMPAT=( python3_{9,10} ) # For the max exclusive Python supported (and
# others), see \
# https://github.com/blender/blender/blob/v2.93.0/build_files/build_environment/install_deps.sh#L382

# Platform defaults based on CMakeList.txt
OPENVDB_ABIS_MAJOR_VERS=8
OPENVDB_ABIS=( ${OPENVDB_ABIS_MAJOR_VERS/#/abi} )
OPENVDB_ABIS=( ${OPENVDB_ABIS[@]/%/-compat} )
IUSE+=" ${OPENVDB_ABIS[@]}"
IUSE+="
X +abi8-compat +alembic -asan +boost +bullet +collada +color-management
-cpudetection +cuda +cycles +dds -debug doc +draco +elbeem
+embree +ffmpeg +fftw flac +gmp +jack +jemalloc +jpeg2k -llvm -man +nanovdb
+ndof +nls +nvcc -nvrtc +openal +opencl +openexr +openimagedenoise +openimageio
+openmp +opensubdiv +openvdb +openxr -optix +osl +pdf +potrace +pulseaudio
release +sdl +sndfile +tbb test +tiff +usd -valgrind -webp r1
"
LLVM_MAX_UPSTREAM="11" # (inclusive)
LLVM_SLOTS=(13 12 11)
gen_llvm_iuse()
{
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		echo " llvm-${s}"
	done
}
IUSE+=" "$(gen_llvm_iuse) # same as Mesa and LLVM latest stable keyword \
# For max and min package versions see link below. \
# https://github.com/blender/blender/blob/v2.93.6/build_files/build_environment/install_deps.sh#L488
FFMPEG_IUSE+=" +jpeg2k +mp3 +opus +theora +vorbis +vpx webm +x264 +xvid"
IUSE+=" ${FFMPEG_IUSE}"

CLANG_MIN="8.0"
GCC_MIN="9.3"
inherit blender

SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${PN}-3.0.1-ffmpeg-5.0.patch.bz2"

# See the blender.eclass for the LICENSE variable.
LICENSE+=" CC-BY-4.0" # The splash screen is CC-BY stated in https://www.blender.org/download/demo-files/ )

# The below are hardcoded enabled in the dependency builder but no explicit option
IMPLIED_RELEASE_BUILD_REQUIRED_USE="
	mp3
	opus
	theora
	vorbis
	vpx
	xvid
"
REQUIRED_USE+="
	^^ ( ${LLVM_SLOTS[@]/#/llvm-} )
	^^ ( ${OPENVDB_ABIS[@]} )
	!boost? (
		!alembic
		!color-management
		!cycles
		!nls
		!openvdb
	)
	!tbb? (
		!cycles
		!elbeem
		!openimagedenoise
		!openvdb
	)
	build_creator? ( X )
	cuda? (
		^^ (
			nvcc
			nvrtc
		)
		cycles
	)
	cycles? ( tbb )
	embree? ( cycles )
	mp3? ( ffmpeg )
	nanovdb? (
		|| (
			cuda
			opencl
		)
		cycles
		openvdb
	)
	nvcc? (
		|| (
			cuda
			optix
		)
	)
	nvrtc? (
		|| (
			cuda
			optix
		)
	)
	opencl? ( cycles )
	openimagedenoise? ( tbb )
	openvdb? (
		|| ( ${OPENVDB_ABIS[@]} )
		openexr
		tbb
	)
	optix? (
		cuda
		cycles
		nvcc
	)
	opus? ( ffmpeg )
	osl? (
		cycles
		llvm
	)
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
		usd
		!valgrind
	)
	theora? ( ffmpeg )
	usd? ( tbb )
	vorbis? ( ffmpeg )
	vpx? ( ffmpeg )
	webm? (
		ffmpeg
		opus
		vpx
	)
	x264? ( ffmpeg )
	xvid? ( ffmpeg )
"

# Keep dates and links updated to speed up releases and decrease maintenance time cost.
# no need to look past those dates.

# Last change was May 26, 2021 for:
# https://github.com/blender/blender/commits/v2.93.0/build_files/cmake/config/blender_release.cmake
# used for REQUIRED_USE section.

# Last change was Mar 16, 2021 for:
# https://github.com/blender/blender/commits/v2.93.0/build_files/build_environment/cmake/versions.cmake
# used for *DEPENDs.

# dependency version requirements see
# build_files/build_environment/cmake/versions.cmake
# doc/python_api/requirements.txt
# extern/Eigen3/eigen-update.sh
# Track OPENVDB_LIBRARY_MAJOR_VERSION_NUMBER for changes.
# Track build_files/build_environment/dependencies.dot for ffmpeg dependencies
#
# Mentioned in versions.cmake but missing in (R)DEPENDS freeglut,
# glfw, clew, cuew, webp, xml2, tinyxml, yaml, flexbison (flex and bison for osl),
# bzip2, libffi, lzma, openssl, sqlite, nasm, ispc for oidn,
# faad (added in 0.6 ffmpeg but removed in 0.7+)
#
# The LLVM linked to Blender should match mesa's linked llvm version to avoid
# multiple version problem if using system's mesa.

gen_llvm_depends()
{
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
			llvm-${s}? ( >=sys-devel/llvm-${s}:${s}= )
		"
	done
}

gen_oiio_depends() {
	local s
	for s in ${OPENVDB_ABIS[@]} ; do
		echo "
			${s}? (
				>=media-libs/openimageio-2.1.15.0[${s},color-management?,jpeg2k?,png,webp?]
				<media-libs/openimageio-2.2.10.0
			)
		"
	done
}

gen_openvdb_depends() {
	local s=${OPENVDB_ABIS_MAJOR_VERS}
	echo "
		abi${s}-compat? (
			=media-gfx/openvdb-${s}.0*[${PYTHON_SINGLE_USEDEP},abi${s}-compat,blosc]
			>=media-gfx/openvdb-${s}.0.1
		)
	"
}

gen_osl_depends()
{
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
			llvm-${s}? ( >=media-libs/osl-${OSL_V}:=[llvm-${s},static-libs] )
		"
	done
}

OPENEXR_V2="2.5.7 2.5.8"
gen_openexr_pairs() {
	local v
	for v in ${OPENEXR_V2} ; do
		echo "
			(
				~media-libs/openexr-${v}:=
				~media-libs/ilmbase-${v}:=
			)
		"
	done
}

ONETBB_SLOT="0"
LEGACY_TBB_SLOT="2"

BOOST_V="1.73"
LIBOGG_V="1.3.4"
LIBSNDFILE_V="1.0.28"
OSL_V="1.11.10.0"
PUGIXML_V="1.10"
THEORA_V="1.1.1"
# the ffplay contradicts in
# build_files/build_environment/cmake/ffmpeg.cmake : --enable-ffplay
# build_files/build_environment/install_deps.sh : --disable-ffplay
CODECS="
	mp3? ( >=media-sound/lame-3.100 )
	opus? ( >=media-libs/opus-1.3.1 )
	theora? (
		>=media-libs/libogg-${LIBOGG_V}
		>=media-libs/libtheora-${THEORA_V}
		vorbis? ( >=media-libs/libtheora-${THEORA_V}[encode] )
	)
	vorbis? (
		>=media-libs/libogg-${LIBOGG_V}
		>=media-libs/libvorbis-1.3.6
	)
	vpx? ( >=media-libs/libvpx-1.8.2 )
	x264? ( >=media-libs/x264-0.0.20200409 )
	xvid? ( >=media-libs/xvid-1.3.7 )
"
RDEPEND+="
	${CODECS}
	${PYTHON_DEPS}
	|| (
		>=media-libs/glu-9.0.1
		virtual/glu
	)
	|| (
		>=media-libs/libjpeg-turbo-2.0.4
		virtual/jpeg:0=
	)
	>=dev-lang/python-3.9.2
	  dev-libs/lzo:2
	$(python_gen_cond_dep '
		>=dev-python/certifi-2020.4.5.2[${PYTHON_USEDEP}]
		>=dev-python/chardet-3.0.4[${PYTHON_USEDEP}]
		>=dev-python/idna-2.9[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.17.5[${PYTHON_USEDEP}]
		>=dev-python/requests-2.23.0[${PYTHON_USEDEP}]
		>=dev-python/urllib3-1.25.9[${PYTHON_USEDEP}]
	')
	>=media-libs/freetype-2.10.2
	>=media-libs/glew-1.13.0:*
	  media-libs/libglvnd
	>=media-libs/libpng-1.6.37:0=
	  media-libs/libsamplerate
	>=sys-libs/zlib-1.2.11
	virtual/libintl
	alembic? (
		>=media-gfx/alembic-1.7.16[boost(+),hdf(+)]
	)
	boost? (
		>=dev-libs/boost-${BOOST_V}:=[nls?,threads(+)]
		usd? (
			>=dev-libs/boost-${BOOST_V}:=[nls?,threads(+),python]
		)
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
		osl? (
			>=dev-libs/pugixml-${PUGIXML_V}
		)
	)
	embree? (
		>=media-libs/embree-3.10.0:=\
[cpu_flags_x86_sse4_2?,cpu_flags_x86_avx?,cpu_flags_x86_avx2?,raymask,static-libs]
	)
	ffmpeg? (
		>=media-video/ffmpeg-4.2.3:=\
[encode,jpeg2k?,mp3?,opus?,sdl,theora?,vorbis?,vpx?,x264,xvid?,zlib]
	)
	fftw? (
		>=sci-libs/fftw-3.3.8:3.0=
	)
	flac? (
		>=media-libs/flac-1.3.3
	)
	gmp? (
		>=dev-libs/gmp-6.2
	)
	jack? (
		virtual/jack
	)
	jemalloc? (
		>=dev-libs/jemalloc-5.2.1:=
	)
	jpeg2k? (
		>=media-libs/openjpeg-2.3.1:2
	)
	llvm? (
		$(gen_llvm_depends)
	)
	llvm-11? (
		>=media-libs/mesa-20.3.5
		>=sys-libs/libomp-11
	)
	llvm-12? (
		>=media-libs/mesa-20.1.1
		>=sys-libs/libomp-12
	)
	llvm-13? (
		>=media-libs/mesa-21.2.5
		>=sys-libs/libomp-13
	)
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
	openal? (
		>=media-libs/openal-1.20.1
	)
	opencl? (
		virtual/opencl
	)
	openimagedenoise? (
		>=media-libs/oidn-1.3.0
		<media-libs/oidn-1.4
	)
	openimageio? (
		$(gen_oiio_depends)
		>=dev-libs/pugixml-${PUGIXML_V}
	)
	openexr? (
		|| (
			$(gen_openexr_pairs)
		)
		!>=media-libs/openexr-3
	)
	opensubdiv? (
		>=media-libs/opensubdiv-3.4.3:=[cuda=,opencl=,tbb?]
	)
	openvdb? (
		$(gen_openvdb_depends)
		>=dev-libs/c-blosc-1.5.0[zlib]
		nanovdb? (
			~media-gfx/nanovdb-25.0.0_pre20200924:0=
		)
	)
	openxr? (
		>=media-libs/openxr-1.0.14
	)
	optix? (
		>=dev-libs/optix-7
	)
	osl? (
		$(gen_osl_depends)
	)
	pdf? (
		>=media-libs/libharu-2.3.0
	)
	potrace? (
		>=media-gfx/potrace-1.16
	)
	pulseaudio? (
		media-sound/pulseaudio
	)
	sdl? (
		>=media-libs/libsdl2-2.0.12[sound]
	)
	sndfile? (
		>=media-libs/libsndfile-${LIBSNDFILE_V}
		flac? (
			>=media-libs/libsndfile-${LIBSNDFILE_V}[-minimal]
		)
	)
	tbb? (
		>=dev-cpp/tbb-2021:${ONETBB_SLOT}
		usd? (
			!<dev-cpp/tbb-2021:0=
			 <dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}=
		)
	)
	tiff? (
		>=media-libs/tiff-4.1.0:0[webp?,zlib]
	)
	usd? (
		>=media-libs/openusd-21.11[monolithic]
		<media-libs/openusd-22[monolithic]
	)
	valgrind? (
		dev-util/valgrind
	)
	webp? (
		>=media-libs/libwebp-0.6.1
	)
	X? (
		x11-libs/libX11
		x11-libs/libXi
		x11-libs/libXxf86vm
	)
"
DEPEND+=" ${RDEPEND}
	>=dev-cpp/eigen-3.3.7:3=
"
gen_asan_bdepend() {
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
			llvm-${s}? (
				 sys-devel/clang:${s}
				=sys-libs/compiler-rt-sanitizers-${s}*[asan]
				=sys-devel/clang-runtime-${s}[compiler-rt,sanitize]
			)
		"
	done
}
BDEPEND+="
	|| (
		>=sys-devel/clang-${CLANG_MIN}
		>=sys-devel/gcc-${GCC_MIN}
	)
	>=dev-util/cmake-3.10
	  virtual/pkgconfig
	asan? (
		|| (
			$(gen_asan_bdepend)
			(
				>=sys-devel/gcc-${GCC_MIN}[sanitizer]
			)
		)
	)
	cycles? (
		x86? (
			|| (
				  dev-lang/icc
				>=sys-devel/clang-${CLANG_MIN}
			)
		)
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

PATCHES=(
	"${FILESDIR}/${PN}-2.82a-fix-install-rules.patch"
#	"${FILESDIR}/${PN}-2.82a-cycles-network-fixes.patch"
#	"${FILESDIR}/${PN}-2.83.1-device_network_h-fixes.patch"
#	"${FILESDIR}/${PN}-2.83.1-device_network_h-add-device-header.patch"
#	"${FILESDIR}/${PN}-2.83.1-update-acquire_tile-for-cycles-networking.patch"
	"${FILESDIR}/${PN}-2.91.0-install-paths-change.patch"
	"${FILESDIR}/${PN}-3.0.0-openusd-21.11-lib-renamed.patch"
	"${FILESDIR}/${PN}-3.0.0-openusd-21.11-python.patch"
	"${FILESDIR}/${PN}-3.0.0-openusd-21-ConnectToSource.patch"
	"${FILESDIR}/${PN}-2.93.7-openusd-21.11-lightapi.patch"
	"${FILESDIR}/${PN}-2.93.7-build-draco.patch"
	"${FILESDIR}/${PN}-3.0.0-boost_python.patch"
)

check_multiple_llvm_versions_in_native_libs() {
	# Checks to avoid loading multiple versions of LLVM.

	local llvm_slot
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		use "llvm-${s}" && llvm_slot=${s}
	done

	if ldd "${EPREFIX}/usr/$(get_libdir)/dri/"*".so" 2>/dev/null 1>/dev/null ; then
		local llvm_ret=$(ldd "${EPREFIX}/usr/$(get_libdir)/dri/"*".so" \
			| grep -q -e "LLVM-${llvm_slot}")
		if [[ "${llvm_ret}" != "0" ]] ; then
eerror
eerror "You need link media-libs/mesa with LLVM ${llvm_slot}.  See"
eerror "media-libs/mesa ebuilds for compatibility details."
eerror
			die
		fi
	fi

	if use osl && [[ -e "${EPREFIX}/usr/$(get_libdir)/liboslexec.so" ]] ; then
		osl_llvm=
		if ldd "${EPREFIX}/usr/$(get_libdir)/liboslexec.so" \
			| grep -q -F "libLLVMAnalysis.so.9" ; then
			# split llvm
			osl_llvm=9
		else
			# monolithic llvm
			osl_llvm=$(ldd "${EPREFIX}/usr/$(get_libdir)/liboslexec.so" \
				| grep -F -i -e "LLVM" | head -n 1 \
				| grep -o -E -e "libLLVM-[0-9]+.so" \
				| head -n 1 | grep -o -E -e "[0-9]+")
		fi
		if [[ -n "${osl_llvm}" ]] \
			&& ver_test "${osl_llvm}" -ne "${llvm_slot}" ; then
eerror
eerror "media-libs/osl must be linked to LLVM ${llvm_slot}"
eerror
			die
		fi
	fi
}

_blender_pkg_setup() {
	# Needs OpenCL 1.2 (GCN 2)
	check_multiple_llvm_versions_in_native_libs
einfo
einfo "This version a Long Term Support (LTS) version till 2023."
einfo

	local found=0
	for s in ${LLVM_SLOTS[@]} ; do
		if (( "${s}" > ${LLVM_MAX_UPSTREAM} )) ; then
			use "llvm-${s}" && found=1
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
	eapply "${FILESDIR}/blender-2.91.0-parent-datafiles-dir-change.patch"
	if ( has_version "<dev-cpp/tbb-2021:0" \
		|| \
	     has_version "<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}" \
	   ) \
		&& \
	     use usd ; then
		:;
	elif has_version ">=dev-cpp/tbb-2021:${ONETBB_SLOT}" && \
	   ! has_version "<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}" && \
	     use usd ; then
		show_tbb_error
	fi
	if   has_version ">=dev-cpp/tbb-2021:${ONETBB_SLOT}" && \
	     has_version "<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}" && \
	     use usd ; then
		eapply "${FILESDIR}/blender-3.0.0-link-usd-to-legacy-tbb.patch"
	elif use usd ;then
ewarn
ewarn "Untested tbb configuration.  It is assumed"
ewarn ">=dev-cpp/tbb-2021:${ONETBB_SLOT} and"
ewarn "<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT} are both installed."
ewarn
ewarn "Install both if build fails."
ewarn
	fi

	if has_version ">=media-video/ffmpeg-5" ; then
		eapply "${WORKDIR}/${PN}-3.0.1-ffmpeg-5.0.patch"
	fi
}

_src_configure() {
	export CMAKE_USE_DIR="${S}_${impl}"
	export BUILD_DIR="${S}_${impl}_build"
	cd "${CMAKE_USE_DIR}" || die

	filter-flags '-fprofile*'
	local pgo_data_dir="${T}/pgo-${ABI}"
	mkdir -p "${pgo_data_dir}"
	if use pgo && [[ "${PGO_PHASE}" == "pgi" ]] \
		&& has_pgo_requirement ; then
einfo
einfo "Setting up PGI"
einfo
		if tc-is-clang ; then
			append-flags -fprofile-generate="${pgo_data_dir}"
		else
			append-flags -fprofile-generate -fprofile-dir="${pgo_data_dir}"
		fi
	elif use pgo && [[ "${PGO_PHASE}" == "pgo" ]] \
		&& has_pgo_requirement ; then
einfo
einfo "Setting up PGO"
einfo
		if tc-is-clang ; then
			llvm-profdata merge -output="${pgo_data_dir}/pgo-custom.profdata" \
				"${pgo_data_dir}" || die
			append-flags -fprofile-use="${pgo_data_dir}/pgo-custom.profdata"
		else
			append-flags -fprofile-use -fprofile-correction -fprofile-dir="${pgo_data_dir}"
		fi
	fi

	# FIX: forcing '-funsigned-char' fixes an anti-aliasing issue with menu
	# shadows, see bug #276338 for reference
	append-flags -funsigned-char
	append-lfs-flags

	local s=${OPENVDB_ABIS_MAJOR_VERS}
	if use abi${s}-compat ; then
		append-cppflags -DOPENVDB_ABI_VERSION_NUMBER=${s}
	fi

	local mycmakeargs=()
	mycmakeargs+=( -DCMAKE_INSTALL_BINDIR:PATH="${EPREFIX}/$(get_dest)" )

	if use cycles-network ; then
ewarn
ewarn "Cycles Networking support does not work at all even for CPU rendering."
ewarn "For ebuild / upstream developers only."
ewarn
	fi

	unset CMAKE_INCLUDE_PATH
	unset CMAKE_LIBRARY_PATH
	unset CMAKE_PREFIX_PATH

	blender_configure_simd_cycles
	blender_configure_eigen

	if use openxr || use osl ; then
		blender_configure_mesa_match_system_llvm
	fi

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
		-DWITH_DRACO=$(usex draco)
		-DWITH_IK_SOLVER=ON
		-DWITH_GMP=$(usex gmp)
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

	if [[ "${impl}" == "build_creator" ]] ; then
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
# https://github.com/blender/blender/tree/v2.93.0/build_files/cmake/config
	if [[ "${impl}" == "build_creator" \
		|| "${impl}" == "build_headless" ]] ; then
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
			-DWITH_CYCLES_NETWORK=OFF
			-DWITH_CYCLES_OSL=$(usex osl)
			-DWITH_STATIC_LIBS=OFF
			-DWITH_SYSTEM_EIGEN3=ON
			-DWITH_SYSTEM_GLEW=ON
			-DWITH_SYSTEM_LZO=ON
		)
	fi

	if true ; then
		mycmakeargs+=(
			-DWITH_INSTALL_PORTABLE=OFF
		)
	elif use pgo && [[ ${PGO_PHASE} == "pgi" ]] ; then
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

	if [[ "${impl}" == "build_headless" ]] ; then
		# For render farms
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

	cmake_src_configure
}
