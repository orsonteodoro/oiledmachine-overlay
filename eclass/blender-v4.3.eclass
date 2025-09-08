# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: blender-v4.3.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: blender implementation
# @DESCRIPTION:
# The blender-v4.3.eclass helps reduce code duplication across ebuilds
# using the same major.minor version.

# FIXME:  alembic requires imath

# Upstream uses LLVM 12.0.0 for Linux.  For prebuilt binary only addons, this may be
# problematic so avoid them.

# The ebuild uses the same matching LLVM version used with Mesa to prevent
# the multiple LLVM bug.

# For versioning see:
# https://github.com/blender/blender/blob/v4.3.2/source/blender/blenkernel/BKE_blender_version.h

# Keep dates and links updated to speed up releases and decrease maintenance time cost.
# No need to look past those dates.

# Last change was Nov 3, 2024 for:
# https://github.com/blender/blender/blob/v4.3.2/build_files/build_environment/install_linux_packages.py

# Last change was Sep 24, 2024 for:
# https://github.com/blender/blender/blob/v4.3.2/build_files/cmake/config/blender_release.cmake
# used for REQUIRED_USE section.

# Last change was Oct 18, 2024 for:
# https://github.com/blender/blender/blob/v4.3.2/build_files/build_environment/cmake/versions.cmake
# used for *DEPENDs.

# HIP:  https://github.com/blender/blender/blob/v4.3.2/intern/cycles/cmake/external_libs.cmake#L47

# GPU lib versions:  https://github.com/blender/blender/blob/v4.3.2/build_files/config/pipeline_config.yaml

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


case ${EAPI:-0} in
	[78]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} is not supported." ;;
esac

ARM_CPU_FLAGS_3_3=(
	neon2x:neon2x
)

CPU_FLAGS_3_3=(
	${ARM_CPU_FLAGS_3_3[@]/#/cpu_flags_arm_}
)

CXXABI_VER=17 # Linux builds should be gnu11, but in Win builds it is c++17

# For max and min package versions see link below. \
# https://github.com/blender/blender/blob/v4.3.2/build_files/build_environment/install_linux_packages.py
# Ebuild will disable patented codecs by default, but upstream enables by default.
FFMPEG_IUSE+="
	+jpeg2k libaom +mp3 +opus rav1e svt-av1 +theora +vorbis +vpx webm +webp x264 x265 +xvid
"

LLVM_COMPAT=( {18..15} )
LLVM_MAX_SLOT="${LLVM_COMPAT[0]}"
LLVM_MAX_UPSTREAM=17 # (inclusive)

# Platform defaults based on CMakeList.txt
OPENVDB_ABIS_MAJOR_VERS=11
OPENVDB_ABIS=(
	${OPENVDB_ABIS_MAJOR_VERS/#/abi}
)
OPENVDB_ABIS=(
	${OPENVDB_ABIS[@]/%/-compat}
)

PATENT_STATUS_IUSE=(
	patent_status_nonfree
)

# For the max exclusive Python supported (and others), see \
# https://github.com/blender/blender/blob/v4.3.2/build_files/build_environment/install_linux_packages.py#L693 \
PYTHON_COMPAT=( "python3_"{11,12} ) # <= 3.12.

BOOST_PV="1.82"
CLANG_MIN="8.0"
FREETYPE_PV="2.13.0"
GCC_MIN="11.2"
LEGACY_TBB_SLOT="2"
LIBOGG_PV="1.3.5"
LIBSNDFILE_PV="1.2.2"
ONETBB_SLOT="0"
OPENEXR_V3_PV=(
	# openexr:imath
	"3.3.2:3.1.12"
	"3.3.1:3.1.12"
	"3.3.0:3.1.11"
	"3.2.4:3.1.10"
	"3.2.3:3.1.10"
	"3.2.2:3.1.9"
	"3.2.1:3.1.9"
)
OSL_PV="1.13.7"
PUGIXML_PV="1.10"
THEORA_PV="1.1.1"

CUDA_TARGETS_COMPAT=(
	compute_75
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
)
OPTIX_RAYTRACE_TARGETS=(
	sm_75
	sm_86
	sm_89
)

AMDGPU_TARGETS_COMPAT=(
# https://github.com/blender/blender/blob/v4.3.2/CMakeLists.txt#L699
	gfx900
	gfx902
	gfx90c
	gfx1010
	gfx1011
	gfx1012
	gfx1030
	gfx1031
	gfx1032
	gfx1034
	gfx1035
	gfx1036
	gfx1100
	gfx1101
	gfx1102
	gfx1103
	gfx1150
	gfx1151
)
HIPRT_RAYTRACE_TARGETS=(
# See https://github.com/GPUOpen-LibrariesAndSDKs/HIPRT/blob/2.3.7df94af/scripts/bitcodes/compile.py#L90
	gfx900
	gfx902
	gfx90c
	gfx1010
	gfx1011
	gfx1012
	gfx1030
	gfx1031
	gfx1032
	gfx1034
	gfx1035
	gfx1036
	gfx1100
	gfx1101
	gfx1102
)
ROCM_SLOTS=(
	rocm_5_7
)

IUSE+="
${CPU_FLAGS_3_3[@]%:*}
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${FFMPEG_IUSE}
${LLVM_COMPAT[@]/#/llvm_slot_}
${OPENVDB_ABIS[@]}
${PATENT_STATUS_IUSE[@]}
${ROCM_SLOTS[@]}
+X +abi11-compat +alembic aot -asan +boost +bullet +collada +color-management
-cpudetection +cuda +cycles +cycles-path-guiding +dds
-debug -dbus doc +draco +elbeem +embree +ffmpeg +fftw flac +gmp -hiprt +hydra
+jack +jemalloc +jpeg2k -llvm -man +materialx +nanovdb +ndof +nls +nvcc +openal
+opencl +openexr +openimagedenoise +openimageio +openmp +opensubdiv +openvdb
+openxr -optix +osl +pdf +potrace +pulseaudio release -rocm -sdl +sndfile sycl
+tbb test +tiff +usd +uv-slim -valgrind +wayland
ebuild_revision_13
"
# hip is default ON upstream.
inherit blender

LICENSE+="
	(
		(
			all-rights-reserved
			Apache-2.0
		)
		(
			all-rights-reserved
			MIT
		)
		(
			all-rights-reserved
			|| (
				BSD
				GPL-2
			)
		)
		(
			Apache-2.0
			custom
		)
		Apache-2.0-with-LLVM-exceptions
		0BSD
		Boost-1.0
		BSD
		BSD-2
		CC0-1.0
		custom
		GPL-3
		LGPL-2.1+
		libpng
		MPL-2.0
		Old-MIT
		PSF-2.2
		public-domain
		UoI-NCSA
		ZLIB
	)
	(
		all-rights-reserved
		Apache-2.0
	)
	(
		all-rights-reserved
		MIT
	)
	(
		Apache-2.0
		BSD
		BSD-2
		GPL-2.0+
		GPL-3.0+
		LGPL-2.1+
		MIT
		MPL-2.0
		ZLIB
	)
	(
		Apache-2.0
		BSD
		MIT
		ZLIB
	)
	(
		BSD
		custom
	)
	(
		custom
		MIT
	)
	Apache-2.0
	BL
	Boost-1.0
	BSD
	BSD-2.0
	CC-BY-4.0
	CC0-1.0
	custom
	GPL-2+
	GPL-2.0
	GPL-3.0
	LGPL-2.1
	MIT
	ZLIB
	|| (
		CC0-1.0
		public-domain
	)

"
# ( all-rights-reserved Apache-2.0 ) - blender-4.3.2/extern/mantaflow/LICENSE
# ( all-rights-reserved Apache-2.0 )
#   ( all-rights-reserved MIT )
#   ( all-rights-reserved || ( BSD GPL-2 ) )
#   ( Apache-2.0 custom )
#   Apache-2.0-with-LLVM-exceptions
#   0BSD
#   Boost-1.0
#   BSD
#   BSD-2
#   CC0-1.0
#   custom
#   GPL-3
#   LGPL-2.1
#   libpng
#   MPL-2.0
#   Old-MIT
#   PSF-2.2
#   public-domain
#   UoI-NCSA
#   ZLIB
#   - blender-4.3.2/release/license/THIRD-PARTY-LICENSES.txt
# all-rights-reserved MIT - blender-4.3.2/extern/vulkan_memory_allocator/LICENSE.txt
# Apache-2.0 - blender-4.3.2/intern/cycles/doc/license/Apache2-license.txt
# Apache-2.0 - blender-4.3.2/extern/cuew/LICENSE
# Apache-2.0 BSD BSD-2 GPL-2.0+ GPL-3.0+ LGPL-2.1+ MIT MPL-2.0 ZLIB - blender-4.3.2/doc/license/SPDX-license-identifiers.txt
# Apache-2.0 BSD MIT ZLIB - blender-4.3.2/intern/cycles/doc/license/SPDX-license-identifiers.txt
# BL - blender-4.3.2/doc/license/BL-license.txt
# Boost-1.0 - blender-4.3.2/extern/quadriflow/3rd/lemon-1.3.1/LICENSE
# BSD - blender-4.3.2/intern/cycles/doc/license/BSD-3-Clause-license.txt
# BSD-2.0 - blender-4.3.2/extern/xxhash/LICENSE
# BSD custom - blender-4.3.2/extern/quadriflow/LICENSE.txt
# CC-BY-4.0 - The splash screen chosen license is found in https://www.blender.org/download/demo-files/ )
# CC0-1.0 - blender-4.3.2/release/datafiles/studiolights/world/license.txt
# custom MIT - blender-4.3.2/extern/fmtlib/LICENSE.rst
# GPL-2+ - blender-4.3.2/tools/check_source/check_licenses.py
# GPL-2.0 - blender-4.3.2/release/license/GPL-license.txt
# GPL-3.0 - blender-4.3.2/doc/license/GPL3-license.txt
# LGPL-2.1 - ./blender-4.3.2/doc/license/LGPL2.1-license.txt
# MIT - blender-4.3.2/intern/cycles/doc/license/MIT-license.txt
# ZLIB - blender-4.3.2/intern/cycles/doc/license/Zlib-license.txt
# ZLIB - blender-4.3.2/doc/license/Zlib-license.txt
# || ( CC0-1.0 public-domain ) - blender-4.3.2/release/datafiles/studiolights/matcap/license.txt
# The distro's Apache-2.0 license template does not contain all rights reserved.
# The distro's GPL-2 license template does not contain all rights reserved.
# The distro's MIT license template does not contain all rights reserved.

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
	libaom
	mp3
	opus
	theora
	vorbis
	vpx
	x264
	x265
	xvid
"
PATENT_STATUS_REQUIRED_USE="
	!patent_status_nonfree? (
		!x264
		!x265
	)
	x264? (
		patent_status_nonfree
	)
	x265? (
		patent_status_nonfree
	)
"
REQUIRED_USE+="
	$(gen_required_use_cuda_targets)
	$(gen_required_use_rocm_targets)
	${PATENT_STATUS_REQUIRED_USE}
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
	sycl? (
		cycles
	)
	dbus? (
		wayland
	)
	embree? (
		cycles
	)
	hiprt? (
		cycles
		|| (
			${HIPRT_RAYTRACE_TARGETS[@]/#/amdgpu_targets_}
		)
		|| (
			rocm_5_7
		)
	)
	hydra? (
		usd
	)
	libaom? (
		ffmpeg
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
		|| (
			${OPTIX_RAYTRACE_TARGETS[@]/#/cuda_targets_}
		)
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
		sndfile
		tbb
		tiff
		usd
		uv-slim
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
	rocm_5_7? (
		llvm_slot_17
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
	x265? (
		ffmpeg
	)
	xvid? (
		ffmpeg
	)
"

gen_asan_bdepend() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				=llvm-runtimes/clang-runtime-${s}[compiler-rt,sanitize]
				=llvm-runtimes/compiler-rt-sanitizers-${s}*:=[asan]
				llvm-core/clang:${s}
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
				>=llvm-core/llvm-${s}:${s}=
			)
		"
	done
}

gen_oidn_depends() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
		llvm_slot_${s}? (
			>=media-libs/oidn-2.3.0[llvm_slot_${s},aot?,sycl?]
			<media-libs/oidn-3[llvm_slot_${s},aot?,sycl?]
		)
		"
	done
}

gen_oiio_depends() {
	local s
	for s in ${OPENVDB_ABIS[@]} ; do
		echo "
			${s}? (
				>=dev-cpp/robin-map-0.6.2
				>=dev-libs/libfmt-9.1.0
				>=media-libs/openimageio-2.5.11.0[${PYTHON_SINGLE_USEDEP},${s}(+),color-management?,jpeg2k?,png,python,tools(+),webp?]
				<media-libs/openimageio-2.6[${PYTHON_SINGLE_USEDEP},${s}(+),color-management?,jpeg2k?,png,python,tools(+),webp?]
			)
		"
	done
}

gen_openexr_pairs() {
	local row
	for row in ${OPENEXR_V3_PV[@]} ; do
		local imath_pv="${row#*:}"
		local openexr_pv="${row%:*}"
		echo "
			(
				~media-libs/openexr-${openexr_pv}:=
				~dev-libs/imath-${imath_pv}:=
			)
		"
	done
}

gen_osl_depends()
{
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				>=media-libs/osl-${OSL_PV}:=[llvm_slot_${s},static-libs]
				<media-libs/osl-2:=[llvm_slot_${s},static-libs]
			)
		"
	done
}

# The ffplay contradicts in
# build_files/build_environment/cmake/ffmpeg.cmake : --enable-ffplay
# build_files/build_environment/install_linux_packages.py : --disable-ffplay
CODECS="
	libaom? (
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
		>=media-libs/libvpx-1.14
	)
	x264? (
		>=media-libs/x264-0.0.20220221
	)
	xvid? (
		>=media-libs/xvid-1.3.7
	)
"

PATENT_STATUS_RDEPEND="
	virtual/patent-status[patent_status_nonfree=]
	!patent_status_nonfree? (
		ffmpeg? (
			|| (
				media-video/ffmpeg:0/56.58.58[encode,jpeg2k?,libaom?,mp3?,opus?,-patent_status_nonfree,rav1e?,sdl,svt-av1?,theora?,vorbis?,vpx?,-x264,xvid?,zlib]
				media-video/ffmpeg:0/57.59.59[encode,jpeg2k?,libaom?,mp3?,opus?,-patent_status_nonfree,rav1e?,sdl,svt-av1?,theora?,vorbis?,vpx?,-x264,xvid?,zlib]
				>=media-video/ffmpeg-6.1.1:0/58.60.60[encode,jpeg2k?,libaom?,mp3?,opus?,-patent_status_nonfree,rav1e?,sdl,svt-av1?,theora?,vorbis?,vpx?,-x264,xvid?,zlib]
			)
		)
	)
	patent_status_nonfree? (
		ffmpeg? (
			|| (
				media-video/ffmpeg:0/56.58.58[encode,jpeg2k?,libaom?,mp3?,opus?,patent_status_nonfree,rav1e?,sdl,svt-av1?,theora?,vorbis?,vpx?,x264?,xvid?,zlib]
				media-video/ffmpeg:0/57.59.59[encode,jpeg2k?,libaom?,mp3?,opus?,patent_status_nonfree,rav1e?,sdl,svt-av1?,theora?,vorbis?,vpx?,x264?,xvid?,zlib]
				>=media-video/ffmpeg-6.1.1:0/58.60.60[encode,jpeg2k?,libaom?,mp3?,opus?,patent_status_nonfree,rav1e?,sdl,svt-av1?,theora?,vorbis?,vpx?,x264?,xvid?,zlib]
			)
		)
	)
"
# The distro's llvm 14 for mesa is 22.05.
# Missing OCLOC
# For compute-runtime version correspondance to level zero, see https://github.com/intel/compute-runtime/blob/23.52.28202.45/manifests/manifest.yml#L56
RDEPEND+="
	$(python_gen_cond_dep '
		(
			>=dev-python/numpy-1.24.3[${PYTHON_USEDEP}]
			<dev-python/numpy-2[${PYTHON_USEDEP}]
		)
		>=dev-python/certifi-2021.10.8[${PYTHON_USEDEP}]
		>=dev-python/charset-normalizer-2.0.6[${PYTHON_USEDEP}]
		>=dev-python/idna-3.2[${PYTHON_USEDEP}]
		>=dev-python/pybind11-2.10.1[${PYTHON_USEDEP}]
		>=dev-python/requests-2.26.0[${PYTHON_USEDEP}]
		>=dev-python/urllib3-1.26.7[${PYTHON_USEDEP}]
		>=dev-python/zstandard-0.16.0[${PYTHON_USEDEP}]
	' 'python*')
	${CODECS}
	${PATENT_STATUS_RDEPEND}
	${PYTHON_DEPS}
	>=dev-cpp/pystring-1.1.3
	>=dev-lang/python-3.11.9
	>=dev-libs/fribidi-1.0.12
	>=media-libs/freetype-${FREETYPE_PV}
	>=media-libs/libpng-1.6.37:0=
	>=media-libs/shaderc-2022.3
	>=media-libs/vulkan-loader-1.3.270
	>=sys-libs/minizip-ng-3.0.7
	>=sys-libs/zlib-1.2.13
	dev-libs/lzo:2
	media-libs/libglvnd
	media-libs/libsamplerate
	media-libs/vulkan-drivers
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
		>=media-libs/opencolorio-2.3.2[cpu_flags_x86_sse2?,python]
	)
	cuda? (
		cuda_targets_sm_30? (
			|| (
				=dev-util/nvidia-cuda-toolkit-10.2*
				=dev-util/nvidia-cuda-toolkit-10.1*
			)
		)
		cuda_targets_sm_35? (
			|| (
				=dev-util/nvidia-cuda-toolkit-11*
				=dev-util/nvidia-cuda-toolkit-10.2*
				=dev-util/nvidia-cuda-toolkit-10.1*
			)
		)
		cuda_targets_sm_37? (
			|| (
				=dev-util/nvidia-cuda-toolkit-11*
				=dev-util/nvidia-cuda-toolkit-10.2*
				=dev-util/nvidia-cuda-toolkit-10.1*
			)
		)
		cuda_targets_sm_50? (
			|| (
				=dev-util/nvidia-cuda-toolkit-12*
				=dev-util/nvidia-cuda-toolkit-11*
				=dev-util/nvidia-cuda-toolkit-10.2*
				=dev-util/nvidia-cuda-toolkit-10.1*
			)
		)
		cuda_targets_sm_52? (
			|| (
				=dev-util/nvidia-cuda-toolkit-12*
				=dev-util/nvidia-cuda-toolkit-11*
				=dev-util/nvidia-cuda-toolkit-10.2*
				=dev-util/nvidia-cuda-toolkit-10.1*
			)
		)
		cuda_targets_sm_60? (
			|| (
				=dev-util/nvidia-cuda-toolkit-12*
				=dev-util/nvidia-cuda-toolkit-11*
				=dev-util/nvidia-cuda-toolkit-10.2*
				=dev-util/nvidia-cuda-toolkit-10.1*
			)
		)
		cuda_targets_sm_61? (
			|| (
				=dev-util/nvidia-cuda-toolkit-12*
				=dev-util/nvidia-cuda-toolkit-11*
				=dev-util/nvidia-cuda-toolkit-10.2*
				=dev-util/nvidia-cuda-toolkit-10.1*
			)
		)
		cuda_targets_sm_70? (
			|| (
				=dev-util/nvidia-cuda-toolkit-12*
				=dev-util/nvidia-cuda-toolkit-11*
				=dev-util/nvidia-cuda-toolkit-10.2*
				=dev-util/nvidia-cuda-toolkit-10.1*
			)
		)
		cuda_targets_sm_75? (
			|| (
				=dev-util/nvidia-cuda-toolkit-12*
				=dev-util/nvidia-cuda-toolkit-11*
				=dev-util/nvidia-cuda-toolkit-10.2*
				=dev-util/nvidia-cuda-toolkit-10.1*
			)
		)
		cuda_targets_sm_86? (
			|| (
				=dev-util/nvidia-cuda-toolkit-12*
				=dev-util/nvidia-cuda-toolkit-11*
				=dev-util/nvidia-cuda-toolkit-10.2*
				=dev-util/nvidia-cuda-toolkit-10.1*
			)
		)
		cuda_targets_sm_89? (
			|| (
				=dev-util/nvidia-cuda-toolkit-12*
				=dev-util/nvidia-cuda-toolkit-11*
				=dev-util/nvidia-cuda-toolkit-10.2*
				=dev-util/nvidia-cuda-toolkit-10.1*
			)
		)
		cuda_targets_compute_75? (
			|| (
				=dev-util/nvidia-cuda-toolkit-12*
				=dev-util/nvidia-cuda-toolkit-11*
				=dev-util/nvidia-cuda-toolkit-10.2*
				=dev-util/nvidia-cuda-toolkit-10.1*
			)
		)
		=dev-util/nvidia-cuda-toolkit:=
	)
	cycles? (
		cycles-path-guiding? (
			(
				>=media-libs/openpgl-0.6[tbb?]
				<media-libs/openpgl-0.7[tbb?]
			)
		)
		osl? (
			>=dev-libs/pugixml-${PUGIXML_PV}
		)
	)
	dbus? (
		sys-apps/dbus
	)
	embree? (
		>=media-libs/embree-4.3.2:=[-backface-culling(-),-compact-polys(-),cpu_flags_arm_neon2x?,cpu_flags_x86_sse4_2?,cpu_flags_x86_avx?,cpu_flags_x86_avx2?,filter-function(+),raymask,static-libs,sycl?,tbb?]
		<media-libs/embree-5
	)
	ffmpeg? (
		media-video/ffmpeg:=
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
	hiprt? (
		rocm_5_7? (
			=media-libs/hiprt-2.3*:5.7[rocm]
		)
		media-libs/hiprt:=
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
	llvm_slot_15? (
		openmp? (
			!rocm? (
				llvm-runtimes/openmp:15
			)
		)
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
	)
	llvm_slot_16? (
		openmp? (
			!rocm? (
				llvm-runtimes/openmp:16
			)
		)
		|| (
			=media-libs/mesa-22.3*[X?]
			=media-libs/mesa-23.0*[X?]
			=media-libs/mesa-23.1*[X?]
			=media-libs/mesa-23.2*[X?]
			=media-libs/mesa-23.3*[X?]
			=media-libs/mesa-24.0*[X?]
			=media-libs/mesa-9999[X?]
		)
	)
	llvm_slot_17? (
		openmp? (
			!rocm? (
				llvm-runtimes/openmp:17
			)
		)
		|| (
			=media-libs/mesa-23.3*[X?]
			=media-libs/mesa-24.0*[X?]
			=media-libs/mesa-9999[X?]
		)
	)
	materialx? (
		>=media-libs/materialx-1.38.8[${PYTHON_SINGLE_USEDEP},python]
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
		>=media-libs/openal-1.23.1[pulseaudio?]
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
		>=media-libs/opensubdiv-3.6.0:=[cuda=,opencl=,opengl(+),tbb?]
	)
	openvdb? (
		abi11-compat? (
			|| (
				=media-gfx/openvdb-13*[${PYTHON_SINGLE_USEDEP},abi11-compat,blosc,numpy]
				=media-gfx/openvdb-12*[${PYTHON_SINGLE_USEDEP},abi11-compat,blosc,numpy]
				=media-gfx/openvdb-11*[${PYTHON_SINGLE_USEDEP},abi11-compat,blosc,numpy]
			)
		)
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
		>=media-libs/harfbuzz-5.1.0[truetype]
	)
	rocm? (
		rocm_5_7? (
			~dev-libs/rocm-opencl-runtime-${HIP_5_7_VERSION}:5.7
			~dev-util/hip-${HIP_5_7_VERSION}:5.7[rocm]
			~sys-libs/llvm-roc-libomp-${HIP_5_7_VERSION}:5.7
		)
		dev-util/hip:=
	)
	sdl? (
		!pulseaudio? (
			>=media-libs/libsdl2-2.28.2[alsa,opengl,sound]
		)
		>=media-libs/libsdl2-2.28.2[opengl,pulseaudio?,sound]
	)
	sndfile? (
		>=media-libs/libsndfile-${LIBSNDFILE_PV}
		flac? (
			>=media-libs/libsndfile-${LIBSNDFILE_PV}[-minimal]
		)
	)
	sycl? (
		(
			>=dev-libs/level-zero-1.16.1
			<dev-libs/level-zero-2
		)
		|| (
			(
				>=sys-devel/DPC++-2024.03.14:0/7[aot?]
				!<sys-devel/DPC++-2024.03.14
			)
		)
		aot? (
			>=dev-libs/intel-compute-runtime-23.52.28202.45[l0]
			>=dev-util/intel-graphics-compiler-1.0.17384.29
		)
	)
	tbb? (
		>=dev-cpp/tbb-2021:${ONETBB_SLOT}[tbbmalloc]
		usd? (
			!<dev-cpp/tbb-2021:0=
			<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}=[tbbmalloc(+)]
		)
	)
	tiff? (
		>=media-libs/tiff-4.6.0:0[jpeg,zlib]
	)
	usd? (
		>=media-libs/openusd-24.05[imaging,monolithic,opengl,openvdb,openimageio,python]
		<media-libs/openusd-25[imaging,monolithic,opengl,openvdb,openimageio,python]
	)
	valgrind? (
		dev-debug/valgrind
	)
	wayland? (
		>=dev-libs/wayland-1.23.0
		>=dev-libs/wayland-protocols-1.36
		>=gui-libs/libdecor-0.2.2
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
	' 'python*')
	>=dev-build/cmake-3.10
	>=dev-cpp/yaml-cpp-0.7.0
	>=dev-build/meson-0.63.0
	>=dev-util/vulkan-headers-1.3.270
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
				>=llvm-core/clang-${CLANG_MIN}
				dev-lang/icc
			)
		)
	)
	doc? (
		$(python_gen_cond_dep '
			>=dev-python/sphinx-3.3.1[${PYTHON_USEDEP},latex]
			>=dev-python/sphinx-rtd-theme-0.5.0[${PYTHON_USEDEP}]
		' 'python*')
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
	rocm? (
		rocm_5_7? (
			~sys-devel/llvm-roc-${HIP_5_7_VERSION}:5.7
		)
	)
	test? (
		>=dev-libs/weston-13.0.3
	)
	|| (
		>=sys-devel/gcc-${GCC_MIN}
		>=llvm-core/clang-${CLANG_MIN}
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-4.0.2-install-paths-change.patch"
	"${FILESDIR}/${PN}-4.1.0-openusd-21.11-python.patch"
#	"${FILESDIR}/${PN}-3.0.0-openusd-21-ConnectToSource.patch"
#	"${FILESDIR}/${PN}-3.0.0-openusd-21.11-lightapi.patch"
	"${FILESDIR}/${PN}-4.3.1-build-draco.patch"
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
	print_release_description

	local found=0
	for s in ${LLVM_COMPAT[@]} ; do
		if (( ${s} > ${LLVM_MAX_UPSTREAM} )) ; then
			use "llvm_slot_${s}" && found=${s}
		fi
	done

	if (( ${found} != 0 )) ; then
ewarn
ewarn "Upstream supports <= LLVM-${LLVM_MAX_UPSTREAM}.x only."
ewarn "llvm-core/llvm:${found} compatibility is still in testing in this"
ewarn "overlay and made available to resolve the multiple LLVM libraries"
ewarn "loaded bug which includes (proprietary) GPU driver parts linked with a"
ewarn "different version of LLVM.  To avoid this bug, use the same LLVM"
ewarn "version from the driver to this package in the dependency chain"
ewarn "including all dependencies of this package."
ewarn
	fi

	if use rocm ; then
		if use rocm_5_7 ; then
			export LLVM_SLOT=17
			export ROCM_SLOT="5.7"
			export ROCM_VERSION="${HIP_5_7_VERSION}"
		else
# See https://github.com/blender/blender/blob/v4.3.2/build_files/config/pipeline_config.yaml
eerror
eerror "Only rocm_5_7 supported."
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

apply_hiprt_2_3_patchset() {
	use hiprt || return
	local hiprt_patchset=(
		"blender-4.3.0-pr-121050-001.patch"
		"blender-4.3.0-pr-121050-002.patch"
#		"blender-4.3.0-pr-121050-003.patch"
		"blender-4.3.0-pr-121050-004.patch"
		"blender-4.3.0-pr-121050-005.patch"
#		"blender-4.3.0-pr-121050-006.patch"
		"blender-4.3.0-pr-121050-007-for-4.2.patch"
		"blender-4.3.0-pr-121050-008.patch"
		"blender-4.3.0-pr-121050-009.patch"
		"blender-4.3.0-pr-121050-010.patch"
		"blender-4.3.0-pr-121050-011.patch"
		"blender-4.3.0-pr-121050-012.patch"
		"blender-4.3.0-pr-121050-013.patch"
		"blender-4.3.0-pr-121050-014.patch"
		"blender-4.3.0-pr-121050-015.patch"
		"blender-4.3.0-pr-121050-016.patch"
		"blender-4.3.0-pr-121050-017.patch"
		"blender-4.3.0-pr-121050-018.patch"
		"blender-4.3.0-pr-121050-019.patch"
	)
einfo "Applying hiprt_patchset"
	local x
	for x in ${hiprt_patchset[@]} ; do
		eapply "${FILESDIR}/pr121050/${x}"
	done
	eapply "${FILESDIR}/${PN}-3.6.13-hiprt-linker-changes.patch"
	eapply "${FILESDIR}/${PN}-3.6.13-HIPRT-change-version-file-path.patch"
}

_src_prepare_patches() {
	#apply_hiprt_2_3_patchset
	eapply "${FILESDIR}/blender-3.2.2-findtbb2.patch"
	eapply "${FILESDIR}/blender-4.3.1-parent-datafiles-dir-change.patch"
	if \
		( \
			has_version "<dev-cpp/tbb-2021:0" \
				|| \
			has_version "<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}" \
		) \
		&& \
		use usd ; then
		:
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
		local rocm_version=""
		if use rocm_5_7 ; then
			rocm_version="${HIP_5_7_VERSION}"
		fi

		sed \
			-i \
			-e "s|/opt/rocm/|/opt/rocm-${rocm_version}/|g" \
			"extern/hipew/src/hipew.c" \
			|| die

		sed \
			-i \
			-e "s|HIP 5.5.0|HIP ${rocm_version}|g" \
			"intern/cycles/cmake/external_libs.cmake" \
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

	if use rocm ; then
		rocm_set_default_hipcc
	fi

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
	cflags-hardened_append

	local s="${OPENVDB_ABIS_MAJOR_VERS}"
	if use "abi${s}-compat" ; then
		append-cppflags -DOPENVDB_ABI_VERSION_NUMBER=${s}
	fi

	local mycmakeargs=(
		-DCMAKE_INSTALL_BINDIR:PATH="${EPREFIX}$(get_dest)"
	)

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
		-DWITH_CYCLES_DEVICE_HIPRT=$(usex hiprt)
		-DWITH_CYCLES_HIP_BINARIES=$(usex rocm)
		-DWITH_CYCLES_ONEAPI_BINARIES=$(usex aot)
		-DWITH_CYCLES_PATH_GUIDING=$(usex cycles-path-guiding)
		-DWITH_DOC_MANPAGE=$(usex man)
		-DWITH_DRACO=$(usex draco)
		-DWITH_GHOST_WAYLAND_DBUS=$(usex dbus)
		-DWITH_GHOST_WAYLAND_DYNLOAD=$(usex wayland)
		-DWITH_GMP=$(usex gmp)
		-DWITH_HYDRA=$(usex hydra)
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
		-DWITH_UV_SLIM=$(usex uv-slim)
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
			-DHIP_DIR="/opt/rocm-${ROCM_VERSION}"
			-DHIP_ROOT_DIR="/opt/rocm-${ROCM_VERSION}"
		)
einfo "AMDGPU_TARGETS:  ${targets}"
	fi

	if use hiprt ; then
		mycmakeargs+=(
			-DHIPRT_ROOT_DIR="/opt/rocm-${ROCM_VERSION}"
		)
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
		if ! use rocm ; then
			mycmakeargs+=(
				-DOPENMP_CUSTOM=ON
				-DOPENMP_FOUND=ON
				-DOpenMP_C_FLAGS="-I${ESYSROOT}/usr/lib/llvm/${llvm_slot}/include -fopenmp=libomp"
				-DOpenMP_C_LIB_NAMES="-I${ESYSROOT}/usr/lib/llvm/${llvm_slot}/include -fopenmp=libomp"
				-DOpenMP_LINKER_FLAGS="${ESYSROOT}/usr/lib/llvm/${llvm_slot}/$(get_libdir)/libomp.so.${LLVM_SLOT}"
			)
		else
			mycmakeargs+=(
				-DOPENMP_CUSTOM=ON
				-DOPENMP_FOUND=ON
				-DOpenMP_C_FLAGS="-I${ESYSROOT}${EROCM_LLVM_PATH}/include -fopenmp=libomp"
				-DOpenMP_C_LIB_NAMES="-I${ESYSROOT}${EROCM_LLVM_PATH}/include -fopenmp=libomp"
				-DOpenMP_LINKER_FLAGS="${ESYSROOT}${EROCM_LLVM_PATH}/$(rocm_get_libdir)/libomp.so"
			)
		fi
	fi

	if use openmp && tc-is-gcc ; then
		local gcc_slot="$(gcc-major-version)"
		local gomp_abspath
		if [[ "${ABI}" =~ ("amd64") && -e "${ESYSROOT}/usr/lib/gcc/${CHOST}/${gcc_slot}/libgomp.so" ]] ; then
			gomp_abspath="${ESYSROOT}/usr/lib/gcc/${CHOST}/${gcc_slot}/libgomp.so"
		elif [[ "${ABI}" =~ ("x86") && -e "${ESYSROOT}/usr/lib/gcc/${CHOST}/${gcc_slot}/32/libgomp.so" ]] ; then
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
# https://github.com/blender/blender/tree/v4.3.2/build_files/cmake/config
	if [[ "${impl}" == "build_creator" \
		|| "${impl}" == "build_headless" ]] ; then
		mycmakeargs+=(
			-DWITH_CYCLES=$(usex cycles)
			-DWITH_CYCLES_CUDA_BINARIES=$(usex cuda)
			-DWITH_CYCLES_DEVICE_CUDA=$(usex cuda TRUE FALSE)
			-DWITH_CYCLES_DEVICE_ONEAPI=$(usex sycl)
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
		:
	else
		if use cuda ; then
			blender_configure_optix
		fi
	fi

	if (( ${#BLENDER_CMAKE_ARGS[@]} > 0 )) ; then
		# Set as per-package environmental variable
		# For setting up optix/cuda
		mycmakeargs+=(
			${BLENDER_CMAKE_ARGS[@]}
		)
	fi

	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
