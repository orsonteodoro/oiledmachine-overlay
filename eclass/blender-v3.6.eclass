# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: blender-v3.6.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: blender implementation
# @DESCRIPTION:
# The blender-v3.6.eclass helps reduce code duplication across ebuilds
# using the same major.minor version.

# FIXME:  alembic requires imath

# Upstream uses LLVM 12.0.0 for Linux.  For prebuilt binary only addons, this may be
# problematic so avoid them.

# The ebuild uses the same matching LLVM version used with Mesa to prevent
# the multiple LLVM bug.

case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

ARM_CPU_FLAGS_3_3=(
	neon2x:neon2x
)

CPU_FLAGS_3_3=(
	${ARM_CPU_FLAGS_3_3[@]/#/cpu_flags_arm_}
)

CXXABI_VER=17 # Linux builds should be gnu11, but in Win builds it is c++17

# For max and min package versions see link below. \
# https://github.com/blender/blender/blob/v3.6.10/build_files/build_environment/install_linux_packages.py
FFMPEG_IUSE+="
	+aom +jpeg2k +mp3 +opus +theora +vorbis +vpx webm +webp +x264 +xvid
"

LLVM_COMPAT=( {15..12} )
LLVM_MAX_SLOT="${LLVM_COMPAT[0]}"
LLVM_MAX_UPSTREAM=15 # (inclusive)

# Platform defaults based on CMakeList.txt
OPENVDB_ABIS_MAJOR_VERS=10
OPENVDB_ABIS=(
	${OPENVDB_ABIS_MAJOR_VERS/#/abi}
)
OPENVDB_ABIS=(
	${OPENVDB_ABIS[@]/%/-compat}
)

# For the max exclusive Python supported (and others), see \
# https://github.com/blender/blender/blob/v3.6.10/build_files/build_environment/install_linux_packages.py#L693 \
PYTHON_COMPAT=( python3_{10,11} ) # <= 3.11.

BOOST_PV="1.80"
CLANG_MIN="8.0"
FREETYPE_PV="2.13.0"
GCC_MIN="9.3"
LEGACY_TBB_SLOT="2"
LIBOGG_PV="1.3.5"
LIBSNDFILE_PV="1.2.2"
ONETBB_SLOT="0"
OPENEXR_V3_PV="3.1.9 3.1.8 3.1.7"
OSL_PV="1.11"
PUGIXML_PV="1.10"
THEORA_PV="1.1.1"

CUDA_TARGETS_COMPAT=(
	sm_30
	sm_35
	sm_37
	sm_50
	sm_52
	sm_60
	sm_61
	sm_70
	sm_75
	sm_86
	sm_89
	compute_89
)

AMDGPU_TARGETS_COMPAT=(
	gfx900
	gfx90c
	gfx902
	gfx1010
	gfx1011
	gfx1012
	gfx1030
	gfx1031
	gfx1032
	gfx1034
	gfx1035
	gfx1100
	gfx1101
	gfx1102
)
ROCM_SLOTS=(
	rocm_5_4
	rocm_5_3
	rocm_5_2
	rocm_5_1
)

IUSE+="
${CPU_FLAGS_3_3[@]%:*}
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${FFMPEG_IUSE}
${LLVM_COMPAT[@]/#/llvm_slot_}
${OPENVDB_ABIS[@]}
${ROCM_SLOTS[@]}
+X +abi10-compat +alembic -asan +boost +bullet +collada +color-management
-cpudetection +cuda +cycles -cycles-device-oneapi +cycles-path-guiding +dds
-debug -dbus doc +draco +elbeem +embree +ffmpeg +fftw flac +gmp +jack
+jemalloc +jpeg2k -llvm -man -materialx +nanovdb +ndof +nls +nvcc +openal
+opencl +openexr +openimagedenoise +openimageio +openmp +opensubdiv +openvdb
+openxr -optix +osl +pdf +potrace +pulseaudio release -rocm +sdl +sndfile sycl
system-llvm +tbb test +tiff +usd -valgrind +wayland
r2
"
# hip is default ON upstream.
inherit blender

# See the blender.eclass for the LICENSE variable.
LICENSE+=" CC-BY-4.0" # The splash screen is CC-BY stated in https://www.blender.org/download/demo-files/ )

gen_required_use_cuda_targets() {
	local x
	for x in ${CUDA_TARGETS_COMPAT[@]} ; do
		echo "
			cuda_targets_${x}? (
				cuda
			)
		"
	done
}

gen_required_use_rocm_targets() {
	local x
	for x in ${AMDGPU_TARGETS_COMPAT[@]} ; do
		echo "
			amdgpu_targets_${x}? (
				rocm
			)
		"
	done
}

# The below are hardcoded enabled in the dependency builder but no explicit option
IMPLIED_RELEASE_BUILD_REQUIRED_USE="
	aom
	mp3
	opus
	theora
	vorbis
	vpx
	xvid
"
REQUIRED_USE+="
	$(gen_required_use_cuda_targets)
	$(gen_required_use_rocm_targets)
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
	?? (
		${LLVM_COMPAT[@]/#/llvm_slot_}
	)
	^^ (
		${OPENVDB_ABIS[@]}
	)
	aom? (
		ffmpeg
	)
	build_creator? (
		X
	)
	cuda? (
		^^ (
			nvcc
		)
		cycles
		|| (
			${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
		)
	)
	cycles? (
		tbb
	)
	cycles-device-oneapi? (
		cycles
	)
	dbus? (
		wayland
	)
	embree? (
		cycles
	)
	materialx? (
		!python_single_target_python3_10
		python_single_target_python3_11
	)
	mp3? (
		ffmpeg
	)
	nanovdb? (
		cycles
		openvdb
		|| (
			opencl
			cuda
		)
	)
	nvcc? (
		|| (
			cuda
			optix
		)
	)
	opencl? (
		cycles
	)
	openimagedenoise? (
		tbb
	)
	openvdb? (
		openexr
		tbb
		|| (
			${OPENVDB_ABIS[@]}
		)
	)
	optix? (
		cuda
		cycles
		nvcc
	)
	opus? (
		ffmpeg
	)
	osl? (
		cycles
		llvm
	)
	release? (
		!debug
		!test
		!valgrind
		alembic
		boost
		build_creator
		bullet
		collada
		color-management
		cycles
		cycles-path-guiding
		dds
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
		tiff
		usd
		webp
		cuda? (
			nvcc
		)
	)
	rocm? (
		!nanovdb
		cycles
		${ROCM_REQUIRED_USE}
		^^ (
			${ROCM_SLOTS[@]}
		)
	)
	rocm_5_4? (
		llvm_slot_15
		rocm
	)
	rocm_5_3? (
		llvm_slot_15
		rocm
	)
	rocm_5_2? (
		llvm_slot_14
		rocm
	)
	rocm_5_1? (
		llvm_slot_14
		rocm
	)
	theora? (
		ffmpeg
	)
	usd? (
		tbb
	)
	vorbis? (
		ffmpeg
	)
	vpx? (
		ffmpeg
	)
	webm? (
		ffmpeg
		opus
		vpx
	)
	x264? (
		ffmpeg
	)
	xvid? (
		ffmpeg
	)
"

# Keep dates and links updated to speed up releases and decrease maintenance time cost.
# no need to look past those dates.

# Last change was Feb 23, 2023 for:
# https://github.com/blender/blender/blob/v3.6.10/build_files/build_environment/install_linux_packages.py

# Last change was May 15, 2023 for:
# https://github.com/blender/blender/commits/v3.6.10/build_files/cmake/config/blender_release.cmake
# used for REQUIRED_USE section.

# Last change was Mar 12, 2024 for:
# https://github.com/blender/blender/commits/v3.6.10/build_files/build_environment/cmake/versions.cmake
# used for *DEPENDs.

# HIP:  https://github.com/blender/blender/blob/v3.6.10/intern/cycles/cmake/external_libs.cmake#L47

# dependency version requirements see
# build_files/build_environment/cmake/versions.cmake
# doc/python_api/requirements.txt
# extern/Eigen3/eigen-update.sh
# Track OPENVDB_LIBRARY_MAJOR_VERSION_NUMBER for changes.
# Track build_files/build_environment/dependencies.dot for ffmpeg dependencies
#
# Mentioned in versions.cmake but missing in (R)DEPENDS freeglut,
# glfw, clew, cuew, webp, xml2, tinyxml, yaml, flexbison,
# bzip2, libffi, lzma, openssl, sqlite, nasm, ispc for oidn,
# faad (added in 0.6 ffmpeg but removed in 0.7+)
#
# The LLVM linked to Blender should match mesa's linked llvm version to avoid
# multiple version problem if using system's mesa.

gen_asan_bdepend() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				=sys-devel/clang-runtime-${s}[compiler-rt,sanitize]
				=sys-libs/compiler-rt-sanitizers-${s}*:=[asan]
				sys-devel/clang:${s}
			)
		"
	done
}

gen_llvm_depends()
{
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				>=sys-devel/llvm-${s}:${s}=
			)
		"
	done
}

gen_oidn_depends() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
		llvm_slot_${s}? (
			<media-libs/oidn-1.5[llvm_slot_${s}]
			>=media-libs/oidn-1.4.3[llvm_slot_${s}]
		)
		"
	done
}

gen_oiio_depends() {
	local s
	for s in ${OPENVDB_ABIS[@]} ; do
		echo "
			${s}? (
				<media-libs/openimageio-2.5[${PYTHON_SINGLE_USEDEP},${s}(+),color-management?,jpeg2k?,png,python,tools(+),webp?]
				>=media-libs/openimageio-2.4.15.0[${PYTHON_SINGLE_USEDEP},${s}(+),color-management?,jpeg2k?,png,python,tools(+),webp?]
				>=dev-cpp/robin-map-0.6.2
				>=dev-libs/libfmt-9.1.0
			)
		"
	done
}

gen_openexr_pairs() {
	local pv
	for pv in ${OPENEXR_V3_PV} ; do
		echo "
			(
				~media-libs/openexr-${pv}:=
				~dev-libs/imath-${pv}:=
			)
		"
	done
}

gen_openvdb_depends() {
	local s=${OPENVDB_ABIS_MAJOR_VERS}
	echo "
		abi${s}-compat? (
			=media-gfx/openvdb-${s}.0*[${PYTHON_SINGLE_USEDEP},abi${s}-compat,blosc,numpy]
		)
	"
}

gen_osl_depends()
{
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				<media-libs/osl-2:=[llvm_slot_${s},static-libs]
				>=media-libs/osl-${OSL_PV}:=[llvm_slot_${s},static-libs]
			)
		"
	done
}

# The ffplay contradicts in
# build_files/build_environment/cmake/ffmpeg.cmake : --enable-ffplay
# build_files/build_environment/install_linux_packages.py : --disable-ffplay
CODECS="
	aom? (
		>=media-libs/libaom-3.3.0
	)
	mp3? (
		>=media-sound/lame-3.100[sndfile]
	)
	opus? (
		>=media-libs/opus-1.3.1
	)
	theora? (
		>=media-libs/libogg-${LIBOGG_PV}
		>=media-libs/libtheora-${THEORA_PV}
		vorbis? (
			>=media-libs/libtheora-${THEORA_PV}[encode]
		)
	)
	vorbis? (
		>=media-libs/libogg-${LIBOGG_PV}
		>=media-libs/libvorbis-1.3.7
	)
	vpx? (
		>=media-libs/libvpx-1.11
	)
	x264? (
		>=media-libs/x264-0.0.20220221
	)
	xvid? (
		>=media-libs/xvid-1.3.7
	)
"

# The distro's llvm 14 for mesa is 22.05.
# Missing OCLOC
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/certifi-2021.10.8[${PYTHON_USEDEP}]
		>=dev-python/charset-normalizer-2.0.6[${PYTHON_USEDEP}]
		>=dev-python/idna-3.2[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.23.5[${PYTHON_USEDEP}]
		>=dev-python/pybind11-2.10.1[${PYTHON_USEDEP}]
		>=dev-python/zstandard-0.16.0[${PYTHON_USEDEP}]
		>=dev-python/requests-2.26.0[${PYTHON_USEDEP}]
		>=dev-python/urllib3-1.26.7[${PYTHON_USEDEP}]
	')
	${CODECS}
	${PYTHON_DEPS}
	>=dev-cpp/pystring-1.1.3
	>=dev-lang/python-3.10.13
	>=dev-libs/fribidi-1.0.12
	>=media-libs/freetype-${FREETYPE_PV}
	>=media-libs/libpng-1.6.37:0=
	>=media-libs/shaderc-2022.3
	>=media-libs/vulkan-loader-1.2.198
	>=sys-libs/minizip-ng-3.0.7
	>=sys-libs/zlib-1.2.13
	dev-libs/lzo:2
	media-libs/libglvnd
	media-libs/libsamplerate
	virtual/libintl
	alembic? (
		>=media-gfx/alembic-1.8.3[boost(+),hdf(+)]
	)
	boost? (
		>=dev-libs/boost-${BOOST_PV}:=[nls?,threads(+)]
		usd? (
			>=dev-libs/boost-${BOOST_PV}:=[nls?,threads(+),python]
		)
	)
	collada? (
		>=media-libs/opencollada-1.6.68:=
		dev-libs/libpcre:=[static-libs]
	)
	color-management? (
		>=dev-libs/expat-2.5.0
		>=media-libs/opencolorio-2.2.0[cpu_flags_x86_sse2?,python]
	)
	cuda? (
		cuda_targets_sm_30? (
			|| (
				=dev-util/nvidia-cuda-toolkit-10.2*:=
				=dev-util/nvidia-cuda-toolkit-10.1*:=
			)
		)
		cuda_targets_sm_35? (
			|| (
				=dev-util/nvidia-cuda-toolkit-11*:=
				=dev-util/nvidia-cuda-toolkit-10.2*:=
				=dev-util/nvidia-cuda-toolkit-10.1*:=
			)
		)
		cuda_targets_sm_37? (
			|| (
				=dev-util/nvidia-cuda-toolkit-11*:=
				=dev-util/nvidia-cuda-toolkit-10.2*:=
				=dev-util/nvidia-cuda-toolkit-10.1*:=
			)
		)
		cuda_targets_sm_50? (
			|| (
				=dev-util/nvidia-cuda-toolkit-12*:=
				=dev-util/nvidia-cuda-toolkit-11*:=
				=dev-util/nvidia-cuda-toolkit-10.2*:=
				=dev-util/nvidia-cuda-toolkit-10.1*:=
			)
		)
		cuda_targets_sm_52? (
			|| (
				=dev-util/nvidia-cuda-toolkit-12*:=
				=dev-util/nvidia-cuda-toolkit-11*:=
				=dev-util/nvidia-cuda-toolkit-10.2*:=
				=dev-util/nvidia-cuda-toolkit-10.1*:=
			)
		)
		cuda_targets_sm_60? (
			|| (
				=dev-util/nvidia-cuda-toolkit-12*:=
				=dev-util/nvidia-cuda-toolkit-11*:=
				=dev-util/nvidia-cuda-toolkit-10.2*:=
				=dev-util/nvidia-cuda-toolkit-10.1*:=
			)
		)
		cuda_targets_sm_61? (
			|| (
				=dev-util/nvidia-cuda-toolkit-12*:=
				=dev-util/nvidia-cuda-toolkit-11*:=
				=dev-util/nvidia-cuda-toolkit-10.2*:=
				=dev-util/nvidia-cuda-toolkit-10.1*:=
			)
		)
		cuda_targets_sm_70? (
			|| (
				=dev-util/nvidia-cuda-toolkit-12*:=
				=dev-util/nvidia-cuda-toolkit-11*:=
				=dev-util/nvidia-cuda-toolkit-10.2*:=
				=dev-util/nvidia-cuda-toolkit-10.1*:=
			)
		)
		cuda_targets_sm_75? (
			|| (
				=dev-util/nvidia-cuda-toolkit-12*:=
				=dev-util/nvidia-cuda-toolkit-11*:=
				=dev-util/nvidia-cuda-toolkit-10.2*:=
				=dev-util/nvidia-cuda-toolkit-10.1*:=
			)
		)
		cuda_targets_sm_86? (
			|| (
				=dev-util/nvidia-cuda-toolkit-12*:=
				=dev-util/nvidia-cuda-toolkit-11*:=
				=dev-util/nvidia-cuda-toolkit-10.2*:=
				=dev-util/nvidia-cuda-toolkit-10.1*:=
			)
		)
		cuda_targets_sm_89? (
			|| (
				=dev-util/nvidia-cuda-toolkit-12*:=
				=dev-util/nvidia-cuda-toolkit-11*:=
				=dev-util/nvidia-cuda-toolkit-10.2*:=
				=dev-util/nvidia-cuda-toolkit-10.1*:=
			)
		)
		cuda_targets_compute_89? (
			|| (
				=dev-util/nvidia-cuda-toolkit-12*:=
				=dev-util/nvidia-cuda-toolkit-11*:=
				=dev-util/nvidia-cuda-toolkit-10.2*:=
				=dev-util/nvidia-cuda-toolkit-10.1*:=
			)
		)
		|| (
			=dev-util/nvidia-cuda-toolkit-12*:=
			=dev-util/nvidia-cuda-toolkit-11*:=
			=dev-util/nvidia-cuda-toolkit-10.2*:=
			=dev-util/nvidia-cuda-toolkit-10.1*:=
		)
	)
	cycles? (
		cycles-path-guiding? (
			(
				<media-libs/openpgl-0.6[tbb?]
				>=media-libs/openpgl-0.5[tbb?]
			)
		)
		osl? (
			>=dev-libs/pugixml-${PUGIXML_PV}
		)
	)
	cycles-device-oneapi? (
		<dev-libs/level-zero-2
		>=dev-libs/level-zero-1.8.8
	)
	dbus? (
		sys-apps/dbus
	)
	embree? (
		>=media-libs/embree-4.1.0:=\
[-backface-culling(-),-compact-polys(-),cpu_flags_arm_neon2x?,\
cpu_flags_x86_sse4_2?,\
cpu_flags_x86_avx?,cpu_flags_x86_avx2?,filter-function(+),raymask,static-libs,sycl?,tbb?]
		<media-libs/embree-5
	)
	ffmpeg? (
		<media-video/ffmpeg-7:=\
[encode,jpeg2k?,mp3?,opus?,sdl,theora?,vorbis?,vpx?,x264,xvid?,zlib]
		>=media-video/ffmpeg-4:=\
[encode,jpeg2k?,mp3?,opus?,sdl,theora?,vorbis?,vpx?,x264,xvid?,zlib]
	)
	fftw? (
		>=sci-libs/fftw-3.3.10:3.0=
	)
	flac? (
		>=media-libs/flac-1.4.2
	)
	gmp? (
		>=dev-libs/gmp-6.2.1[cxx]
	)
	jack? (
		virtual/jack
	)
	jemalloc? (
		>=dev-libs/jemalloc-5.2.1:=
	)
	jpeg2k? (
		>=media-libs/openjpeg-2.5.0:2
	)
	llvm? (
		$(gen_llvm_depends)
	)
	llvm_slot_12? (
		|| (
			~media-libs/mesa-21.1.0[X?]
			~media-libs/mesa-21.1.1[X?]
			~media-libs/mesa-21.1.2[X?]
			~media-libs/mesa-21.1.3[X?]
			~media-libs/mesa-21.1.4[X?]
			~media-libs/mesa-21.1.5[X?]
			~media-libs/mesa-21.1.6[X?]
			~media-libs/mesa-21.1.7[X?]
			~media-libs/mesa-21.1.8[X?]
			~media-libs/mesa-21.2.0[X?]
			~media-libs/mesa-21.2.1[X?]
			~media-libs/mesa-21.2.2[X?]
			~media-libs/mesa-21.2.5[X?]
			~media-libs/mesa-21.2.6[X?]
			~media-libs/mesa-21.3.0[X?]
			~media-libs/mesa-21.3.1[X?]
			~media-libs/mesa-21.3.2[X?]
			~media-libs/mesa-21.3.3[X?]
			~media-libs/mesa-21.3.4[X?]
			~media-libs/mesa-21.3.5[X?]
			~media-libs/mesa-21.3.6[X?]
			~media-libs/mesa-21.3.7[X?]
			~media-libs/mesa-21.3.8[X?]
			~media-libs/mesa-22.0.0[X?]
			~media-libs/mesa-22.0.2[X?]
			~media-libs/mesa-22.0.3[X?]
			~media-libs/mesa-22.0.4[X?]
			~media-libs/mesa-22.0.5[X?]
			~media-libs/mesa-22.1.0[X?]
			~media-libs/mesa-22.1.1[X?]
			~media-libs/mesa-22.1.2[X?]
			~media-libs/mesa-22.1.3[X?]
		)
		system-llvm? (
			sys-libs/libomp:12
		)
	)
	llvm_slot_13? (
		|| (
			~media-libs/mesa-21.2.5[X?]
			~media-libs/mesa-21.2.6[X?]
			~media-libs/mesa-21.3.0[X?]
			~media-libs/mesa-21.3.1[X?]
			~media-libs/mesa-21.3.2[X?]
			~media-libs/mesa-21.3.3[X?]
			~media-libs/mesa-21.3.4[X?]
			~media-libs/mesa-21.3.5[X?]
			~media-libs/mesa-21.3.6[X?]
			~media-libs/mesa-21.3.7[X?]
			~media-libs/mesa-21.3.8[X?]
			~media-libs/mesa-22.0.0[X?]
			~media-libs/mesa-22.0.2[X?]
			~media-libs/mesa-22.0.3[X?]
			~media-libs/mesa-22.0.4[X?]
			~media-libs/mesa-22.0.5[X?]
			~media-libs/mesa-22.1.0[X?]
			~media-libs/mesa-22.1.1[X?]
			~media-libs/mesa-22.1.2[X?]
			~media-libs/mesa-22.1.5[X?]
			~media-libs/mesa-22.1.6[X?]
			~media-libs/mesa-22.1.7[X?]
			~media-libs/mesa-22.2.0[X?]
			~media-libs/mesa-22.2.1[X?]
			~media-libs/mesa-22.2.2[X?]
			~media-libs/mesa-22.2.3[X?]
			~media-libs/mesa-22.2.5[X?]
			~media-libs/mesa-22.3.1[X?]
			~media-libs/mesa-22.3.2[X?]
			~media-libs/mesa-22.3.3[X?]
			 ~media-libs/mesa-22.3.7[X?]
		)
		system-llvm? (
			sys-libs/libomp:13
		)
	)
	llvm_slot_14? (
		|| (
			~media-libs/mesa-22.0.5[X?]
			~media-libs/mesa-22.1.0[X?]
			~media-libs/mesa-22.1.1[X?]
			~media-libs/mesa-22.1.2[X?]
			~media-libs/mesa-22.1.5[X?]
			~media-libs/mesa-22.1.6[X?]
			~media-libs/mesa-22.1.7[X?]
			~media-libs/mesa-22.2.0[X?]
			~media-libs/mesa-22.2.1[X?]
			~media-libs/mesa-22.2.2[X?]
			~media-libs/mesa-22.2.3[X?]
			~media-libs/mesa-22.2.5[X?]
			~media-libs/mesa-22.3.1[X?]
			~media-libs/mesa-22.3.2[X?]
			~media-libs/mesa-22.3.3[X?]
			 ~media-libs/mesa-22.3.7[X?]
		)
		system-llvm? (
			sys-libs/libomp:14
		)
	)
	llvm_slot_15? (
		|| (
			~media-libs/mesa-22.2.0[X?]
			~media-libs/mesa-22.2.1[X?]
			~media-libs/mesa-22.2.2[X?]
			~media-libs/mesa-22.2.3[X?]
			~media-libs/mesa-22.2.5[X?]
			~media-libs/mesa-22.3.1[X?]
			~media-libs/mesa-22.3.2[X?]
			~media-libs/mesa-22.3.3[X?]
			~media-libs/mesa-22.3.6[X?]
			~media-libs/mesa-22.3.5[X?]
			 ~media-libs/mesa-22.3.7[X?]
			=media-libs/mesa-23.1.0[X?]
			=media-libs/mesa-23.1.1[X?]
			=media-libs/mesa-23.1.2[X?]
			=media-libs/mesa-23.1.3[X?]
			=media-libs/mesa-23.1.4[X?]
			=media-libs/mesa-23.1.5[X?]
			=media-libs/mesa-23.1.6[X?]
			=media-libs/mesa-23.1.7[X?]
			=media-libs/mesa-23.1.8[X?]
			=media-libs/mesa-23.1.9[X?]
			=media-libs/mesa-23.2.1[X?]
			=media-libs/mesa-23.3.0[X?]
			=media-libs/mesa-23.3.1[X?]
			=media-libs/mesa-23.3.2[X?]
			=media-libs/mesa-23.3.3[X?]
			=media-libs/mesa-23.3.4[X?]
			=media-libs/mesa-23.3.5[X?]
			=media-libs/mesa-23.3*[X?]
			=media-libs/mesa-24.0*[X?]
			=media-libs/mesa-9999[X?]
		)
		system-llvm? (
			sys-libs/libomp:15
		)
	)
	materialx? (
		media-libs/materialx[${PYTHON_SINGLE_USEDEP},python]
	)
	ndof? (
		>=dev-libs/libspnav-1.1
		app-misc/spacenavd
	)
	nls? (
		|| (
			virtual/libiconv
			>=dev-libs/libiconv-1.16
		)
	)
	openal? (
		!pulseaudio? (
			>=media-libs/openal-1.21.1[alsa]
		)
		>=media-libs/openal-1.21.1[pulseaudio?]
	)
	opencl? (
		virtual/opencl
	)
	openimagedenoise? (
		$(gen_oidn_depends)
	)
	openimageio? (
		$(gen_oiio_depends)
		>=dev-libs/pugixml-${PUGIXML_PV}
	)
	openexr? (
		!<media-libs/openexr-3
		|| (
			$(gen_openexr_pairs)
		)
	)
	opensubdiv? (
		>=media-libs/opensubdiv-3.5.0:=[cuda=,opencl=,opengl(+),tbb?]
	)
	openvdb? (
		$(gen_openvdb_depends)
		>=dev-libs/c-blosc-1.21.1[zlib]
		nanovdb? (
			~media-gfx/nanovdb-32.4.2_p20221027:0=
		)
	)
	openxr? (
		>=media-libs/openxr-1.0.17
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
	release? (
		>=media-libs/freetype-${FREETYPE_PV}[brotli,bzip2,harfbuzz,png]
		media-libs/harfbuzz[truetype]
	)
	rocm? (
		rocm_5_4? (
			~dev-util/hip-${HIP_5_4_VERSION}:5.4[rocm,system-llvm=]
			!system-llvm? (
				~dev-libs/rocm-opencl-runtime-${HIP_5_4_VERSION}:5.4
				~sys-libs/llvm-roc-libomp-${HIP_5_4_VERSION}:5.4
			)
		)
		rocm_5_3? (
			~dev-util/hip-${HIP_5_3_VERSION}:5.3[rocm,system-llvm=]
			!system-llvm? (
				~dev-libs/rocm-opencl-runtime-${HIP_5_3_VERSION}:5.3
				~sys-libs/llvm-roc-libomp-${HIP_5_3_VERSION}:5.3
			)
		)
		rocm_5_2? (
			~dev-util/hip-${HIP_5_2_VERSION}:5.2[rocm,system-llvm=]
			!system-llvm? (
				~dev-libs/rocm-opencl-runtime-${HIP_5_2_VERSION}:5.2
				~sys-libs/llvm-roc-libomp-${HIP_5_2_VERSION}:5.2
			)
		)
		rocm_5_1? (
			~dev-util/hip-${HIP_5_1_VERSION}:5.1[rocm,system-llvm=]
			!system-llvm? (
				~dev-libs/rocm-opencl-runtime-${HIP_5_1_VERSION}:5.1
				~sys-libs/llvm-roc-libomp-${HIP_5_1_VERSION}:5.1
			)
		)
		dev-util/hip:=
	)
	sdl? (
		!pulseaudio? (
			>=media-libs/libsdl2-2.0.20[alsa,opengl,sound]
		)
		>=media-libs/libsdl2-2.0.20[opengl,pulseaudio?,sound]
	)
	sndfile? (
		>=media-libs/libsndfile-${LIBSNDFILE_PV}
		flac? (
			>=media-libs/libsndfile-${LIBSNDFILE_PV}[-minimal]
		)
	)
	sycl? (
		>=sys-devel/DPC++-2022.12:0/6
	)
	tbb? (
		>=dev-cpp/tbb-2021:${ONETBB_SLOT}[tbbmalloc]
		usd? (
			!<dev-cpp/tbb-2021:0=
			<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}=[tbbmalloc(+)]
		)
	)
	tiff? (
		>=media-libs/tiff-4.5.1:0[jpeg,zlib]
	)
	usd? (
		<media-libs/openusd-24[imaging,monolithic,opengl,openvdb,openimageio,python]
		>=media-libs/openusd-23.05[imaging,monolithic,opengl,openvdb,openimageio,python]
	)
	valgrind? (
		dev-util/valgrind
	)
	wayland? (
		>=dev-libs/wayland-1.22.0
		>=dev-libs/wayland-protocols-1.31
		>=gui-libs/libdecor-0.1.0
	)
	webp? (
		>=media-libs/libwebp-1.3.2
	)
	X? (
		x11-libs/libX11
		x11-libs/libXi
		x11-libs/libXxf86vm
	)
	|| (
		virtual/glu
		>=media-libs/glu-9.0.1
	)
	|| (
		virtual/jpeg:0=
		>=media-libs/libjpeg-turbo-2.1.3
	)
"
DEPEND+="
	${RDEPEND}
	>=dev-cpp/eigen-3.3.7:3=
"
# Missing SSE2NEON
BDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/setuptools-63.2.0[${PYTHON_USEDEP}]
		>=dev-python/cython-0.29.30[${PYTHON_USEDEP}]
		>=dev-python/autopep8-1.6.0[${PYTHON_USEDEP}]
		>=dev-python/pycodestyle-2.8.0[${PYTHON_USEDEP}]
	')
	>=dev-build/cmake-3.10
	>=dev-cpp/yaml-cpp-0.7.0
	>=dev-util/meson-0.63.0
	>=dev-util/vulkan-headers-1.2.198
	dev-util/patchelf
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
				>=sys-devel/clang-${CLANG_MIN}
				dev-lang/icc
			)
		)
	)
	doc? (
		>=dev-python/sphinx-3.3.1[latex]
		>=dev-python/sphinx_rtd_theme-0.5.0
		app-text/doxygen[dot]
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
	nls? (
		sys-devel/gettext
	)
	|| (
		>=sys-devel/gcc-${GCC_MIN}
		>=sys-devel/clang-${CLANG_MIN}
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-3.5.1-fix-install-rules.patch"
	"${FILESDIR}/${PN}-3.0.0-install-paths-change.patch"
	"${FILESDIR}/${PN}-3.5.1-openusd-21.11-python.patch"
#	"${FILESDIR}/${PN}-3.0.0-openusd-21-ConnectToSource.patch"
#	"${FILESDIR}/${PN}-3.0.0-openusd-21.11-lightapi.patch"
	"${FILESDIR}/${PN}-2.93.7-build-draco.patch"
#	"${FILESDIR}/${PN}-3.0.0-intern-ghost-fix-typo-in-finding-XF86VMODE.patch"
	"${FILESDIR}/${PN}-3.0.0-boost_python.patch"
#	"${FILESDIR}/${PN}-3.0.0-oiio-util.patch"
	"${FILESDIR}/${PN}-3.5.1-tbb-rpath.patch"
	"${FILESDIR}/${PN}-3.6.0-hip-flags.patch"
)

check_multiple_llvm_versions_in_native_libs() {
	# Checks to avoid loading multiple versions of LLVM.

	local llvm_slot
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		use "llvm_slot_${s}" && llvm_slot=${s}
	done

	if ldd "${ESYSROOT}/usr/$(get_libdir)/dri/"*".so" 2>/dev/null 1>/dev/null ; then
		local llvm_ret
		ldd "${ESYSROOT}/usr/$(get_libdir)/dri/"*".so" \
			| grep -q -e "LLVM-${llvm_slot}"
		llvm_ret="$?"
		if [[ "${llvm_ret}" != "0" ]] ; then
ewarn
ewarn "Detected linking inconsistency:"
ewarn
ewarn "Requested LLVM blender USE flag:  llvm-${llvm_slot}"
ewarn "Files inspected:  ${ESYSROOT}/usr/$(get_libdir)/dri/"*".so"
ewarn "Actual LLVM linking:"
ewarn
		ldd "${ESYSROOT}/usr/$(get_libdir)/dri/"*".so" \
			| grep -e "LLVM-"
ewarn
ewarn "These should be the same to avoid a possible multiple LLVMs loaded bug."
ewarn
ewarn

ewarn
ewarn "Prebuilt binary video card drivers users:"
ewarn
ewarn "You need link media-libs/mesa with LLVM ${llvm_slot}.  See"
ewarn "media-libs/mesa ebuilds for compatibility details."
ewarn
			if use osl ; then
eerror
eerror "You must pick one of the following:"
eerror
eerror "(1) Use media-libs/mesa[llvm,llvm-${llvm_slot}]::oiledmachine-overlay"
eerror "instead if it exists."
eerror "(2) Disable the osl USE flag."
eerror
				die
			fi
		fi
	fi

	if use osl && [[ -e "${ESYSROOT}/usr/$(get_libdir)/liboslexec.so" ]] ; then
		osl_llvm=
		if ldd "${ESYSROOT}/usr/$(get_libdir)/liboslexec.so" \
			| grep -q -F "libLLVMAnalysis.so.9" ; then
			# split llvm
			osl_llvm=9
		else
			# monolithic llvm
			osl_llvm=$(ldd "${ESYSROOT}/usr/$(get_libdir)/liboslexec.so" \
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
	# TODO: ldd oiio for webp and warn user if missing
	# Needs OpenCL 1.2 (GCN 2)
	check_multiple_llvm_versions_in_native_libs
ewarn
ewarn "This version is not a Long Term Support (LTS) version."
ewarn "Consider using 2.93.x or 3.3.x series instead."
ewarn

	local found=0
	for s in ${LLVM_COMPAT[@]} ; do
		if (( "${s}" > ${LLVM_MAX_UPSTREAM} )) ; then
			use "llvm_slot_${s}" && found=${s}
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

	if use cycles-device-oneapi ; then
ewarn
ewarn "Support for the cycles-device-oneapi may be incomplete because distro"
ewarn "may be missing several packages."
ewarn
	fi

	if use rocm ; then
	# Upstream uses hip 5.5.0 external_libs.cmake which uses llvm 16.
	# It is not possible because of version_mex excludes 16 in install_linux_packages.py.
	# It will cause an emerge conflict.
	# It may also trigger a multiple LLVMs loaded bug.
		if use rocm_5_4 ; then
			export LLVM_SLOT=15
			export ROCM_SLOT="5.4"
			export ROCM_VERSION="${HIP_5_4_VERSION}"
		elif use rocm_5_3 ; then
			export LLVM_SLOT=15
			export ROCM_SLOT="5.3"
			export ROCM_VERSION="${HIP_5_3_VERSION}"
		elif use rocm_5_2 ; then
			export LLVM_SLOT=14
			export ROCM_SLOT="5.2"
			export ROCM_VERSION="${HIP_5_2_VERSION}"
		elif use rocm_5_1 ; then
			export LLVM_SLOT=14
			export ROCM_SLOT="5.1"
			export ROCM_VERSION="${HIP_5_1_VERSION}"
		elif use llvm-13 || use llvm-12 ; then
eerror
eerror "ROCm < 5.1 is not supported on the distro."
eerror "Disable the rocm USE flag."
eerror
			die
		else
eerror
eerror "No matching llvm/hip pair."
eerror
eerror "llvm-15 can only pair with hip 5.3.3, 5.4.3"
eerror "llvm-14 can only pair with hip 5.1.3, 5.2.3"
eerror
			die
		fi
		rocm_pkg_setup
	#else
		# See blender_pkg_setup for llvm_pkg_setup
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
	eapply "${FILESDIR}/blender-3.2.2-findtbb2.patch"
	eapply "${FILESDIR}/blender-3.6.0-parent-datafiles-dir-change.patch"
	if \
		( \
			has_version "<dev-cpp/tbb-2021:0" \
				|| \
			has_version "<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}" \
		) \
		&& \
		use usd ; then
		:;
	elif \
		! has_version "<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}" && \
		has_version ">=dev-cpp/tbb-2021:${ONETBB_SLOT}" && \
		use usd ; then
		show_tbb_error
	fi
	if \
		has_version ">=dev-cpp/tbb-2021:${ONETBB_SLOT}" && \
		has_version "<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}" && \
		use usd ; then
		eapply "${FILESDIR}/blender-3.5.1-tbb2-usd.patch"
	elif use usd ;then
ewarn
ewarn "Untested tbb configuration.  It is assumed"
ewarn ">=dev-cpp/tbb-2021:${ONETBB_SLOT} and"
ewarn "<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT} are both installed."
ewarn
ewarn "Install both if build fails."
ewarn
	fi
	if use rocm ; then
		sed -e "s|/opt/rocm/hip/lib/libamdhip64.so|${EPREFIX}${EROCM_PATH}/$(get_libdir)/libamdhip64.so|" \
			-i extern/hipew/src/hipew.c \
			|| die

		local rocm_version=""
		if use rocm_5_4 ; then
			rocm_version="${HIP_5_4_VERSION}"
		elif use rocm_5_3 ; then
			rocm_version="${HIP_5_3_VERSION}"
		elif use rocm_5_2 ; then
			rocm_version="${HIP_5_2_VERSION}"
		elif use rocm_5_1 ; then
			rocm_version="${HIP_5_1_VERSION}"
		fi

		sed -i "s|HIP 5.5.0|HIP ${rocm_version}|g" \
			-i intern/cycles/cmake/external_libs.cmake \
			|| die
	fi
}

_src_configure_compiler() {
	check_optimal_compiler_for_cycles_x86
}

_src_configure() {
	export CMAKE_USE_DIR="${S}"
	export BUILD_DIR="${S}_${impl}_build"
	cd "${CMAKE_USE_DIR}" || die

	if has_version "dev-libs/wayland" && ! use wayland ; then
eerror
eerror "You must enable the wayland USE flag or uninstall wayland."
eerror
		die
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
	mycmakeargs+=( -DCMAKE_INSTALL_BINDIR:PATH="${EPREFIX}$(get_dest)" )

	unset CMAKE_INCLUDE_PATH
	unset CMAKE_LIBRARY_PATH
	unset CMAKE_PREFIX_PATH

	blender_configure_simd_cycles
	blender_configure_eigen

	# TODO: migrate blender-libs changes from blender-v2.83 once LLVM-10 is deprecated

	# WITH_INPUT_IME is default ON upstream but only supports non-linux
	mycmakeargs+=(
# Fixes
#CMake Error: The inter-target dependency graph contains the following strongly connected component (cycle):
#  "cycles_bvh" of type SHARED_LIBRARY
		-DBUILD_SHARED_LIBS=OFF

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
		-DWITH_CYCLES_HIP_BINARIES=$(usex rocm)
		-DWITH_CYCLES_DEVICE_HIPRT=NO # No package yet
		-DWITH_CYCLES_PATH_GUIDING=$(usex cycles-path-guiding)
		-DWITH_DOC_MANPAGE=$(usex man)
		-DWITH_DRACO=$(usex draco)
		-DWITH_GHOST_WAYLAND_DBUS=$(usex dbus)
		-DWITH_GHOST_WAYLAND_DYNLOAD=$(usex wayland)
		-DWITH_GMP=$(usex gmp)
		-DWITH_IK_SOLVER=ON
		-DWITH_INPUT_IME=OFF
		-DWITH_IMAGE_OPENEXR=$(usex openexr)
		-DWITH_IMAGE_OPENJPEG=$(usex jpeg2k)
		-DWITH_INTERNATIONAL=$(usex nls)
		-DWITH_HARU=$(usex pdf)
		-DWITH_LLVM=$(usex llvm)
		-DWITH_MATERIALX=$(usex materialx)
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

	# Speed up build time
	if use cuda ; then
		local targets=""
		local cuda_target
		for cuda_target in ${CUDA_TARGETS_COMPAT[@]} ; do
			if use "${cuda_target/#/cuda_targets_}" ; then
				targets+=";${cuda_target}"
			fi
		done
		targets=$(echo "${targets}" \
			| sed -e "s|^;||g")
		mycmakeargs+=(
			-DCYCLES_CUDA_BINARIES_ARCH="${targets}"
		)
einfo "CUDA_TARGETS:  ${targets}"
	fi

	# Speed up build time
	if use rocm ; then
		local targets=""
		local rocm_target
		for rocm_target in ${AMDGPU_TARGETS_COMPAT[@]} ; do
			if use "${rocm_target/#/amdgpu_targets_}" ; then
				targets+=";${rocm_target}"
			fi
		done
		targets=$(echo "${targets}" \
			| sed -e "s|^;||g")
		mycmakeargs+=(
			-DCYCLES_HIP_BINARIES_ARCH="${targets}"
		)
einfo "AMDGPU_TARGETS:  ${targets}"
	fi

	local llvm_slot
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		use "llvm_slot_${s}" && llvm_slot=${s}
	done

	if use openmp && tc-is-clang ; then
		local llvm_slot
		local s
		for s in ${LLVM_COMPAT[@]} ; do
			use "llvm_slot_${s}" && llvm_slot=${s}
		done
		mycmakeargs+=(
			-DOPENMP_CUSTOM=ON
			-DOPENMP_FOUND=ON
			-DOpenMP_C_FLAGS="-I${ESYSROOT}/usr/lib/llvm/${llvm_slot}/include -fopenmp=libomp"
			-DOpenMP_C_LIB_NAMES="-I${ESYSROOT}/usr/lib/llvm/${llvm_slot}/include -fopenmp=libomp"
			-DOpenMP_LINKER_FLAGS="${ESYSROOT}/usr/lib/llvm/${llvm_slot}/$(get_libdir)/libomp.so.${LLVM_SLOT}"
		)
	fi

	if use openmp && tc-is-gcc ; then
		local gcc_slot="$(gcc-major-version)"
		local gomp_abspath
		if [[ "${ABI}" =~ (amd64) && -e "${ESYSROOT}/usr/lib/gcc/${CHOST}/${gcc_slot}/libgomp.so" ]] ; then
			gomp_abspath="${ESYSROOT}/usr/lib/gcc/${CHOST}/${gcc_slot}/libgomp.so"
		elif [[ "${ABI}" =~ (x86) && -e "${ESYSROOT}/usr/lib/gcc/${CHOST}/${gcc_slot}/32/libgomp.so" ]] ; then
			gomp_abspath="${ESYSROOT}/usr/lib/gcc/${CHOST}/${gcc_slot}/32/libgomp.so"
		elif [[ -e "${GOMP_LIB64_ABSPATH}" ]] ; then
			gomp_abspath="${GOMP_LIB64_ABSPATH}"
		elif [[ -e "${GOMP_LIB32_ABSPATH}" ]] ; then
			gomp_abspath="${GOMP_LIB32_ABSPATH}"
		elif [[ -e "${GOMP_LIB_ABSPATH}" ]] ; then
			gomp_abspath="${GOMP_LIB_ABSPATH}"
		else
eerror
eerror "${ABI} is unknown.  Please set one or more of the following per-package"
eerror "environment variables:"
eerror
eerror "GOMP_LIB_ABSPATH"
eerror "GOMP_LIB32_ABSPATH"
eerror "GOMP_LIB64_ABSPATH"
eerror
eerror "to point to the absolute path to libgomp.so for GCC slot ${gcc_slot}"
eerror "corresponding to that ABI."
eerror
			die
		fi
		mycmakeargs+=(
			-DOPENMP_CUSTOM=ON
			-DOPENMP_FOUND=ON
			-DOpenMP_C_FLAGS="-I${ESYSROOT}/usr/lib/gcc/${CHOST}/${gcc_slot}/include -fopenmp"
			-DOpenMP_C_LIB_NAMES="-I${ESYSROOT}/usr/lib/gcc/${CHOST}/${gcc_slot}/include -fopenmp"
			-DOpenMP_LINKER_FLAGS="${gomp_abspath}"
		)
	fi

	if use materialx ; then
		mycmakeargs+=(
			-DMaterialX_DIR:PATH="${ESYSROOT}/usr/$(get_libdir)/materialx/lib/cmake/MaterialX"
		)
	fi

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
# https://github.com/blender/blender/tree/v3.6.10/build_files/cmake/config
	if [[ "${impl}" == "build_creator" \
		|| "${impl}" == "build_headless" ]] ; then
		mycmakeargs+=(
			-DWITH_CYCLES=$(usex cycles)
			-DWITH_CYCLES_CUDA_BINARIES=$(usex cuda)
			-DWITH_CYCLES_DEVICE_CUDA=$(usex cuda TRUE FALSE)
			-DWITH_CYCLES_DEVICE_ONEAPI=$(usex cycles-device-oneapi)
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

	mycmakeargs+=(
		-DWITH_INSTALL_PORTABLE=OFF
	)

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

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
