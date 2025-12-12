# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: blender-v4.5.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 8
# @BLURB: blender implementation
# @DESCRIPTION:
# The blender-v4.5.eclass helps reduce code duplication across ebuilds
# using the same major.minor version.

# FIXME:  alembic requires imath

# The ebuild uses the same matching LLVM version used with Mesa to prevent
# the multiple LLVM bug.

# For versioning see:
# https://github.com/blender/blender/blob/v4.5.5/source/blender/blenkernel/BKE_blender_version.h

# Keep dates and links updated to speed up releases and decrease maintenance time cost.
# No need to look past those dates.

# Last change was Oct 27, 2025 for:
# https://github.com/blender/blender/blob/v4.5.5/build_files/build_environment/install_linux_packages.py

# Last change was Apr 8, 2025 for:
# https://github.com/blender/blender/blob/v4.5.5/build_files/cmake/config/blender_release.cmake
# used for REQUIRED_USE section.

# Last change was Oct 7, 2025 for:
# https://github.com/blender/blender/blob/v4.5.5/build_files/build_environment/cmake/versions.cmake
# used for *DEPENDs.

# HIP:  https://github.com/blender/blender/blob/v4.5.5/intern/cycles/cmake/external_libs.cmake#L47

# GPU lib versions:  https://github.com/blender/blender/blob/v4.5.5/build_files/config/pipeline_config.yaml

# dependency version requirements see
# build_files/build_environment/cmake/versions.cmake
# doc/python_api/requirements.txt
# extern/Eigen3/eigen-update.sh
# Track OPENVDB_LIBRARY_MAJOR_VERSION_NUMBER for changes.
# Track build_files/build_environment/dependencies.dot for ffmpeg dependencies
#
# Mentioned in versions.cmake but missing in (R)DEPENDS freeglut,
# glfw, clew, cuew, webp, xml2, tinyxml, yamlcpp, flexbison,
# bzip2, libffi, lzma, openssl, sqlite, nasm, ispc for oidn,
# faad (added in 0.6 ffmpeg but removed in 0.7+), sse2neon, zstd
# brotli
#
# The LLVM linked to Blender should match mesa's linked llvm version to avoid
# multiple version problem if using system's mesa.

# DPC++ is not packaged because [core] parts of the stack (e.g. oneMKL used for
# GPU acceleration) are unconditional and have download restrictions or are
# closed source.  It may be re-evaluated to see if apps/libs on the core closed
# components can be pruned or made an optional conditional requirement.
#
# DPC++ slot (SYCL_MAJOR_VERSION):
# https://github.com/intel/llvm/blob/05e047c0932d5043ddff5e4058a3afca8e0943aa/sycl/CMakeLists.txt#L93
#
# The nightly is missing the stable commit, which is why 2 separate or more slots are recommended.
#
# Recommended changes:
#
# nightly SLOT:  nightly/8
# 6.2.0 SLOT:  release/6.2
#
# Nightly prefix:  /usr/lib/dpc++/nightly/8
# Release prefix:  /usr/lib/dpc++/release/6.2
# Alternative stable prefix:  /usr/lib/dpc++/6.2
# Alternative nightly prefix:  /usr/lib/dpc++/nightly-8

# The distro's llvm 14 for mesa is 22.05.
# Missing OCLOC
# Missing nanobind
# For compute-runtime version correspondance to level zero, see https://github.com/intel/compute-runtime/blob/23.52.28202.45/manifests/manifest.yml#L56
# https://github.com/oneapi-src/unified-runtime/blob/da04d13807044aaf17615b66577fb0e832011ab1/cmake/FetchLevelZero.cmake#L104

case ${EAPI:-0} in
	[8]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} is not supported." ;;
esac

CXX_STANDARD=17
# For the max exclusive Python supported (and others), see \
# https://github.com/blender/blender/blob/v4.5.5/build_files/build_environment/install_linux_packages.py#L693 \
PYTHON_COMPAT=( "python3_"{11,12} ) # <= 3.12.
BOOST_PV="1.82"
CLANG_MIN="18" # C++17
FREETYPE_PV="2.13.0"
GCC_MIN="11" # C++17
LIBOGG_PV="1.3.5"
LIBSNDFILE_PV="1.2.2"
ONETBB_SLOT="0"
OPENVDB_ABIS_MAJOR_VERS=12
OSL_PV="1.14.3.0"
PUGIXML_PV="1.10"
THEORA_PV="1.1.1"
VULKAN_PV="1.3.296"

ARM_CPU_FLAGS_3_3=(
	neon2x:neon2x
)

CPU_FLAGS_3_3=(
	"${ARM_CPU_FLAGS_3_3[@]/#/cpu_flags_arm_}"
)

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	# There is a bug if it is duplicate LLVM_COMPAT entry, it will complain it is more than 1 when emerging.
	#${LIBCXX_COMPAT_CXX17_CUDA_12_8[@]/llvm_slot_} # 16..19
	#${LIBCXX_COMPAT_CXX17_ROCM_6_4[@]/llvm_slot_} # 19
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}" # 18, 19
)
# ROCm 6.4: 19, ROCm 6.3: 18
# Upstream limits LLVM to [15, 18) but relaxed for ROCm and overlay compatibility
# It uses LLVM 17 as default.
LLVM_MAX_SLOT="19"
LLVM_MAX_UPSTREAM=17 # (inclusive)

inherit ffmpeg
FFMPEG_COMPAT_SLOTS=(
	"${FFMPEG_COMPAT_SLOTS_7[@]}"
)

# For max and min package versions see link below. \
# https://github.com/blender/blender/blob/v4.5.5/build_files/build_environment/install_linux_packages.py
# Ebuild will disable patented codecs by default, but upstream enables by default.
FFMPEG_IUSE=(
	"+jpeg2k"
	"libaom"
	"+mp3"
	"+opus"
	"rav1e"
	"svt-av1"
	"+theora"
	"+vorbis"
	"+vpx"
	"webm"
	"+webp"
	"x264"
	"x265"
	"+xvid"
)

# Platform defaults based on CMakeList.txt
OPENVDB_ABIS=(
	"${OPENVDB_ABIS_MAJOR_VERS/#/abi}"
)

OPENVDB_ABIS=(
	"${OPENVDB_ABIS[@]/%/-compat}"
)

OPENEXR_V3_PV=(
	# openexr:imath
	"3.3.5:3.1.12"
	"3.3.4:3.1.12"
	"3.3.3:3.1.12"
	"3.3.2:3.1.12"
	"3.3.1:3.1.12"
	"3.3.0:3.1.11"
	"3.2.4:3.1.10"
	"3.2.3:3.1.10"
	"3.2.2:3.1.9"
	"3.2.1:3.1.9"
)

PATENT_STATUS_IUSE=(
	"patent_status_nonfree"
)

CUDA_TARGETS_COMPAT=(
	"compute_75"

	"sm_35"
	"sm_37"
	"sm_50"
	"sm_52"
	"sm_60"
	"sm_61"
	"sm_70"
	"sm_75"
	"sm_86"
	"sm_89"
	"sm_120"
)

OPTIX_RAYTRACE_TARGETS=(
	"sm_75"
	"sm_86"
	"sm_89"
	"sm_120"
)

AMDGPU_TARGETS_COMPAT=(
# https://github.com/blender/blender/blob/v4.5.5/CMakeLists.txt#L699
	"gfx1010"
	"gfx1011"
	"gfx1012"
	"gfx1030"
	"gfx1031"
	"gfx1032"
	"gfx1034"
	"gfx1035"
	"gfx1036"
	"gfx1100"
	"gfx1101"
	"gfx1102"
	"gfx1103"
	"gfx1150"
	"gfx1151"
	"gfx1152"
	"gfx1200"
	"gfx1201"
)

HIPRT_RAYTRACE_TARGETS=(
# See https://github.com/GPUOpen-LibrariesAndSDKs/HIPRT/blob/2.5.a21e075/scripts/bitcodes/compile.py#L90
	"gfx1010"
	"gfx1011"
	"gfx1012"
	#"gfx1013"
	"gfx1030"
	"gfx1031"
	"gfx1032"
	#"gfx1033"
	"gfx1034"
	"gfx1035"
	"gfx1036"
	"gfx1100"
	"gfx1101"
	"gfx1102"
	"gfx1103"
	"gfx1150"
	"gfx1151"
	"gfx1152"
	"gfx1200"
	"gfx1201"
)

ROCM_SLOTS=(
	"rocm_6_4"
)

IUSE+="
${CPU_FLAGS_3_3[@]%:*}
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${FFMPEG_IUSE[@]}
${LLVM_COMPAT[@]/#/llvm_slot_}
${OPENVDB_ABIS[@]}
${PATENT_STATUS_IUSE[@]}
${ROCM_SLOTS[@]}
+X +abi12-compat +alembic aot -asan +boost +bullet +collada +color-management
-cpudetection +cuda +cycles +cycles-path-guiding +dds
-debug -dbus doc +draco +elbeem +embree +ffmpeg +fftw flac +gmp -hiprt +hydra
+jack +jemalloc +jpeg2k -llvm -man +materialx +nanovdb +ndof +nls +nvcc +openal
+opencl +openexr +openimagedenoise +openimageio +opensubdiv +openvdb
+openxr -optix +osl +pdf +pipewire +potrace +pulseaudio release -rocm -sdl
+sndfile sycl +tbb test +tiff +usd +uv-slim -valgrind +wayland
ebuild_revision_34
"
# hip is default ON upstream.
inherit libcxx-slot libstdcxx-slot blender

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
# ( all-rights-reserved Apache-2.0 ) - blender-4.5.5/extern/mantaflow/LICENSE
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
#   - blender-4.5.5/release/license/THIRD-PARTY-LICENSES.txt
# all-rights-reserved MIT - blender-4.5.5/extern/vulkan_memory_allocator/LICENSE.txt
# Apache-2.0 - blender-4.5.5/intern/cycles/doc/license/Apache2-license.txt
# Apache-2.0 - blender-4.5.5/extern/cuew/LICENSE
# Apache-2.0 BSD BSD-2 GPL-2.0+ GPL-3.0+ LGPL-2.1+ MIT MPL-2.0 ZLIB - blender-4.5.5/doc/license/SPDX-license-identifiers.txt
# Apache-2.0 BSD MIT ZLIB - blender-4.5.5/intern/cycles/doc/license/SPDX-license-identifiers.txt
# BL - blender-4.5.5/doc/license/BL-license.txt
# Boost-1.0 - blender-4.5.5/extern/quadriflow/3rd/lemon-1.3.1/LICENSE
# BSD - blender-4.5.5/intern/cycles/doc/license/BSD-3-Clause-license.txt
# BSD-2.0 - blender-4.5.5/extern/xxhash/LICENSE
# BSD custom - blender-4.5.5/extern/quadriflow/LICENSE.txt
# CC-BY-4.0 - The splash screen chosen license is found in https://www.blender.org/download/demo-files/ )
# CC0-1.0 - blender-4.5.5/release/datafiles/studiolights/world/license.txt
# custom MIT - blender-4.5.5/extern/fmtlib/LICENSE.rst
# GPL-2+ - blender-4.5.5/tools/check_source/check_licenses.py
# GPL-2.0 - blender-4.5.5/release/license/GPL-license.txt
# GPL-3.0 - blender-4.5.5/doc/license/GPL3-license.txt
# LGPL-2.1 - ./blender-4.5.5/doc/license/LGPL2.1-license.txt
# MIT - blender-4.5.5/intern/cycles/doc/license/MIT-license.txt
# ZLIB - blender-4.5.5/intern/cycles/doc/license/Zlib-license.txt
# ZLIB - blender-4.5.5/doc/license/Zlib-license.txt
# || ( CC0-1.0 public-domain ) - blender-4.5.5/release/datafiles/studiolights/matcap/license.txt
# The distro's Apache-2.0 license template does not contain all rights reserved.
# The distro's GPL-2 license template does not contain all rights reserved.
# The distro's MIT license template does not contain all rights reserved.

gen_required_use_cuda_targets() {
	local x
	for x in "${CUDA_TARGETS_COMPAT[@]}" ; do
		echo "
			cuda_targets_${x}? (
				cuda
			)
		"
	done
}

gen_required_use_rocm_targets() {
	local x
	for x in "${AMDGPU_TARGETS_COMPAT[@]}" ; do
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
		^^ (
			${LIBCXX_COMPAT_CXX17_CUDA_12_8[@]}
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
			rocm_6_4
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
		^^ (
			${LLVM_COMPAT[@]/#/llvm_slot_}
		)
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
		^^ (
			${LLVM_COMPAT[@]/#/llvm_slot_}
		)
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
		^^ (
			${LIBCXX_COMPAT_CXX17_ROCM_6_4[@]}
		)
	)
	rocm_6_4? (
		llvm_slot_19
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
	for s in "${LLVM_COMPAT[@]}" ; do
		echo "
			llvm_slot_${s}? (
				=llvm-runtimes/clang-runtime-${s}[compiler-rt,sanitize]
				=llvm-runtimes/compiler-rt-sanitizers-${s}*[${LIBSTDCXX_USEDEP},asan]
				llvm-runtimes/compiler-rt-sanitizers:=
				llvm-core/clang:${s}[${LIBSTDCXX_USEDEP}]
				llvm-core/clang:=
			)
		"
	done
}

gen_llvm_depends()
{
	local s
	for s in "${LLVM_COMPAT[@]}" ; do
		echo "
			llvm_slot_${s}? (
				>=llvm-core/llvm-${s}:${s}[${LIBSTDCXX_USEDEP}]
				llvm-core/llvm:=
			)
		"
	done
}

gen_oidn_depends() {
	local s
	for s in "${LLVM_COMPAT[@]}" ; do
		echo "
		llvm_slot_${s}? (
			>=media-libs/oidn-2.3.3[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},aot?,sycl?]
			<media-libs/oidn-3.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},aot?,sycl?]
			media-libs/oidn:=
		)
		"
	done
}

gen_oiio_depends() {
	local s
	for s in "${OPENVDB_ABIS[@]}" ; do
		echo "
			${s}? (
				>=dev-cpp/robin-map-1.3.0
				>=dev-libs/libfmt-9.1.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
				dev-libs/libfmt:=
				>=media-libs/openimageio-3.0.6.1[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${PYTHON_SINGLE_USEDEP},${s}(+),color-management?,jpeg2k?,png,python,tools(+),webp?]
				<media-libs/openimageio-3.1.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${PYTHON_SINGLE_USEDEP},${s}(+),color-management?,jpeg2k?,png,python,tools(+),webp?]
				media-libs/openimageio:=
			)
		"
	done
}

gen_openexr_pairs() {
	local row
	for row in "${OPENEXR_V3_PV[@]}" ; do
		local imath_pv="${row#*:}"
		local openexr_pv="${row%:*}"
		echo "
			(
				~media-libs/openexr-${openexr_pv}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
				media-libs/openexr:=
				~dev-libs/imath-${imath_pv}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
				dev-libs/imath:=
			)
		"
	done
}

gen_osl_depends()
{
	local s
	for s in "${LLVM_COMPAT[@]}" ; do
		echo "
			llvm_slot_${s}? (
				>=media-libs/osl-${OSL_PV}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},static-libs]
				<media-libs/osl-2.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},static-libs]
				media-libs/osl:=
			)
		"
	done
}

# The ffplay contradicts in
# build_files/build_environment/cmake/ffmpeg.cmake : --enable-ffplay
# build_files/build_environment/install_linux_packages.py : --disable-ffplay
CODECS="
	libaom? (
		>=media-libs/libaom-3.4.0
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
				media-video/ffmpeg:59.61.61[encode,jpeg2k?,libaom?,mp3?,opus?,-patent_status_nonfree,rav1e?,sdl,svt-av1?,theora?,vorbis?,vpx?,-x264,xvid?,zlib]

				media-video/ffmpeg:0/59.61.61[encode,jpeg2k?,libaom?,mp3?,opus?,-patent_status_nonfree,rav1e?,sdl,svt-av1?,theora?,vorbis?,vpx?,-x264,xvid?,zlib]
			)
			media-video/ffmpeg:=
		)
	)
	patent_status_nonfree? (
		ffmpeg? (
			|| (
				media-video/ffmpeg:59.61.61[encode,jpeg2k?,libaom?,mp3?,opus?,patent_status_nonfree,rav1e?,sdl,svt-av1?,theora?,vorbis?,vpx?,x264?,xvid?,zlib]

				media-video/ffmpeg:0/59.61.61[encode,jpeg2k?,libaom?,mp3?,opus?,patent_status_nonfree,rav1e?,sdl,svt-av1?,theora?,vorbis?,vpx?,x264?,xvid?,zlib]
			)
			media-video/ffmpeg:=
		)
	)
"

CUDA_12_8_RDEPEND="
	(
		=dev-util/nvidia-cuda-toolkit-12.8*
		dev-util/nvidia-cuda-toolkit:=
		>=x11-drivers/nvidia-drivers-570.124
		virtual/cuda-compiler[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	)
"

is_rocm_target_allowed() {
	local target="${1}"
	for x in "${AMDGPU_TARGETS_COMPAT[@]}" ; do
		[[ "${x}" == "${target}" ]] && return 0
	done
	return 1
}

gen_hiprt_usedep() {
	local hiprt_ver="${1/./_}"
	local rocm_slot="${2/./_}"
	local t="HIPRT_${hiprt_ver}_${rocm_slot}_AMDGPU_TARGETS_COMPAT[@]"
	local a=( "${!t}" )
	local str=""
	for x in ${a[@]} ; do
		if is_rocm_target_allowed "${x}" ; then
			str+=",amdgpu_targets_${x}(-)?"
		fi
	done
	str="${str:1}"
	echo "${str}"
}

gen_rocm_hiprt_rdepend() {
	local u
	for u in "${ROCM_SLOTS[@]}" ; do
		local s="${u/rocm_}"
		local s="${s/_/.}"
		local d="${s/./_}"
		local ROCM_SLOT="${s}"
		echo "
			rocm_${d}? (
				|| (
					=media-libs/HIPRT-2.5*:0/${s}[${LIBSTDCXX_USEDEP},rocm,$(gen_hiprt_usedep 2.5 ${s})]
					=media-libs/HIPRT-3.0*:0/${s}[${LIBSTDCXX_USEDEP},rocm,$(gen_hiprt_usedep 3.0 ${s})]
				)
				media-libs/HIPRT:=
			)
		"
	done
}

gen_rocm_rdepend() {
	local u
	for u in "${ROCM_SLOTS[@]}" ; do
		local s="${u/rocm_}"
		local s="${s/_/.}"
		local d="${s/./_}"
		local ROCM_SLOT="${s}"
		local v="HIP_${d}_VERSION"
		local v="${!v}"
		echo "
			rocm_${d}? (
				>=dev-libs/rocm-opencl-runtime-${v}:0/${s}[${LIBSTDCXX_USEDEP}]
				dev-libs/rocm-opencl-runtime:=
				>=dev-util/hip-${v}:0/${s}[${LIBSTDCXX_USEDEP},rocm]
				dev-util/hip:=
				>=sys-libs/llvm-roc-libomp-${v}:0/${s}[${LIBSTDCXX_USEDEP},$(get_rocm_usedep LLVM_ROC_LIBOMP)]
				sys-libs/llvm-roc-libomp:=
			)
		"
	done
}

RDEPEND+="
	$(python_gen_cond_dep '
		(
			>=dev-python/numpy-1.26.4[${PYTHON_USEDEP}]
			<dev-python/numpy-2[${PYTHON_USEDEP}]
		)
		>=dev-python/certifi-2025.4.26[${PYTHON_USEDEP}]
		>=dev-python/charset-normalizer-3.4.1[${PYTHON_USEDEP}]
		>=dev-python/idna-3.10[${PYTHON_USEDEP}]
		>=dev-python/pybind11-2.10.1[${PYTHON_USEDEP}]
		>=dev-python/requests-2.32.3[${PYTHON_USEDEP}]
		>=dev-python/urllib3-2.4.0[${PYTHON_USEDEP}]
		>=dev-python/zstandard-0.23.0[${PYTHON_USEDEP}]
	' 'python*')
	${CODECS}
	${PATENT_STATUS_RDEPEND}
	${PYTHON_DEPS}
	>=dev-cpp/pystring-1.1.3[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	dev-cpp/pystring:=
	>=dev-lang/python-3.11.11
	>=dev-libs/fribidi-1.0.12
	>=dev-util/glslang-${VULKAN_PV}
	dev-util/glslang:=
	>=media-libs/freetype-${FREETYPE_PV}[brotli]
	>=media-libs/libpng-1.6.43:0
	media-libs/libpng:=
	>=media-libs/shaderc-2024.3[${LIBSTDCXX_USEDEP}]
	media-libs/shaderc:=
	>=media-libs/vulkan-loader-${VULKAN_PV}
	>=sci-mathematics/manifold-3.1.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	sci-mathematics/manifold:=
	>=sys-libs/minizip-ng-3.0.7
	>=sys-libs/zlib-1.3.1
	dev-libs/lzo:2
	media-libs/libglvnd
	media-libs/libsamplerate
	media-libs/vulkan-drivers
	virtual/libintl
	alembic? (
		>=media-gfx/alembic-1.8.3[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},boost(+),hdf(+)]
		media-gfx/alembic:=
	)
	boost? (
		>=dev-libs/boost-${BOOST_PV}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},nls?,threads(+)]
		usd? (
			>=dev-libs/boost-${BOOST_PV}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},nls?,threads(+),python]
		)
		dev-libs/boost:=
	)
	collada? (
		>=media-libs/aras-p-opencollada-20240718[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		media-libs/aras-p-opencollada:=
	)
	color-management? (
		>=dev-libs/expat-2.6.4
		>=media-libs/opencolorio-2.4.1[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},cpu_flags_x86_sse2?,python]
		media-libs/opencolorio:=
	)
	cuda? (
		cuda_targets_sm_50? (
			|| (
				${CUDA_12_8_RDEPEND}
			)
		)
		cuda_targets_sm_52? (
			|| (
				${CUDA_12_8_RDEPEND}
			)
		)
		cuda_targets_sm_60? (
			|| (
				${CUDA_12_8_RDEPEND}
			)
		)
		cuda_targets_sm_61? (
			|| (
				${CUDA_12_8_RDEPEND}
			)
		)
		cuda_targets_sm_70? (
			|| (
				${CUDA_12_8_RDEPEND}
			)
		)
		cuda_targets_sm_75? (
			|| (
				${CUDA_12_8_RDEPEND}
			)
		)
		cuda_targets_sm_86? (
			|| (
				${CUDA_12_8_RDEPEND}
			)
		)
		cuda_targets_sm_89? (
			|| (
				${CUDA_12_8_RDEPEND}
			)
		)
		cuda_targets_compute_75? (
			|| (
				${CUDA_12_8_RDEPEND}
			)
		)
		dev-util/nvidia-cuda-toolkit:=
		virtual/cuda-compiler:=
	)
	cycles? (
		cycles-path-guiding? (
			(
				>=media-libs/openpgl-0.6.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},tbb?]
				<media-libs/openpgl-0.7.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},tbb?]
				media-libs/openpgl:=
			)
		)
		osl? (
			>=dev-libs/pugixml-${PUGIXML_PV}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
			dev-libs/pugixml:=
		)
	)
	dbus? (
		sys-apps/dbus
	)
	embree? (
		>=media-libs/embree-4.4.0[-backface-culling(-),-compact-polys(-),cpu_flags_arm_neon2x?,cpu_flags_x86_sse4_2?,cpu_flags_x86_avx?,cpu_flags_x86_avx2?,filter-function(+),raymask,static-libs,sycl?,tbb?]
		<media-libs/embree-5
		media-libs/embree:=
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
		>=dev-libs/gmp-6.3.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},cxx]
		dev-libs/gmp:=
	)
	hiprt? (
		$(gen_rocm_hiprt_rdepend)
		media-libs/HIPRT:=
	)
	jack? (
		virtual/jack
	)
	jemalloc? (
		>=dev-libs/jemalloc-5.2.1[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		dev-libs/jemalloc:=
	)
	jpeg2k? (
		>=media-libs/openjpeg-2.5.0:2
		media-libs/openjpeg:=
	)
	llvm? (
		$(gen_llvm_depends)
	)
	llvm_slot_18? (
		|| (
			=media-libs/mesa-25.0*[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},X?]
			=media-libs/mesa-25.1*[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},X?]
			=media-libs/mesa-25.2*[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},X?]
			=media-libs/mesa-9999[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},X?]
		)
		media-libs/mesa:=
	)
	llvm_slot_19? (
		|| (
			=media-libs/mesa-25.0*[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},X?]
			=media-libs/mesa-25.1*[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},X?]
			=media-libs/mesa-25.2*[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},X?]
			=media-libs/mesa-9999[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},X?]
		)
		media-libs/mesa:=
	)
	materialx? (
		>=media-libs/materialx-1.39.2[${LIBSTDCXX_USEDEP},${PYTHON_SINGLE_USEDEP},python]
		media-libs/materialx:=
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
			>=media-libs/openal-1.23.1[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},alsa]
		)
		>=media-libs/openal-1.23.1[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},pulseaudio?]
		media-libs/openal:=
	)
	opencl? (
		virtual/opencl
	)
	openimagedenoise? (
		$(gen_oidn_depends)
	)
	openimageio? (
		$(gen_oiio_depends)
		>=dev-libs/pugixml-${PUGIXML_PV}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		dev-libs/pugixml:=
	)
	openexr? (
		!<media-libs/openexr-3
		|| (
			$(gen_openexr_pairs)
		)
	)
	opensubdiv? (
		>=media-libs/opensubdiv-3.6.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},cuda=,opencl=,opengl(+),tbb?]
		media-libs/opensubdiv:=
	)
	openvdb? (
		abi12-compat? (
			|| (
				=media-gfx/openvdb-13*[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${PYTHON_SINGLE_USEDEP},abi12-compat,blosc,nanovdb?,numpy]
				=media-gfx/openvdb-12*[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${PYTHON_SINGLE_USEDEP},abi12-compat,blosc,nanovdb?,numpy]
			)
			media-gfx/openvdb:=
		)
		>=dev-libs/c-blosc-1.21.1[zlib]
	)
	openxr? (
		>=media-libs/openxr-1.0.22[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		media-libs/openxr:=
	)
	optix? (
		>=dev-libs/optix-8
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
		>=media-libs/harfbuzz-10.0.1[truetype]
	)
	rocm? (
		$(gen_rocm_rdepend)
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
			>=dev-libs/level-zero-1.19.2[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
			<dev-libs/level-zero-2.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
			dev-libs/level-zero:=
		)
		|| (
			(
				>=sys-devel/DPC++-2025.01.08:nightly/8[aot?]
				!<sys-devel/DPC++-2025.01.08
			)
		)
		aot? (
			>=dev-libs/intel-compute-runtime-23.52.28202.45[l0]
			>=dev-util/intel-graphics-compiler-2.1.14
		)
	)
	tbb? (
		>=dev-cpp/tbb-2021.13.0:${ONETBB_SLOT}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},tbbmalloc(+)]
		dev-cpp/tbb:=
	)
	tiff? (
		>=media-libs/tiff-4.7.0:0[jpeg,zlib]
	)
	usd? (
		>=media-libs/openusd-25.02[imaging,materialx?,monolithic,opengl,openvdb,openimageio,python]
		<media-libs/openusd-26.0[imaging,materialx?,monolithic,opengl,openvdb,openimageio,python]
		media-libs/openusd:=
	)
	valgrind? (
		dev-debug/valgrind
	)
	wayland? (
		>=dev-libs/wayland-1.23.1
		>=dev-libs/wayland-protocols-1.44
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
		(
			>=media-libs/glu-9.0.1[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
			media-libs/glu:=
		)
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
BDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/setuptools-63.2.0[${PYTHON_USEDEP}]
		=dev-python/cython-3*[${PYTHON_USEDEP}]
		dev-python/cython:=
		>=dev-python/autopep8-2.3.1[${PYTHON_USEDEP}]
		>=dev-python/pycodestyle-2.13.0[${PYTHON_USEDEP}]
	' 'python*')
	>=dev-build/cmake-3.10
	>=dev-cpp/yaml-cpp-0.7.0[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	dev-cpp/yaml-cpp:=
	>=dev-build/meson-0.63.0
	>=dev-util/vulkan-headers-${VULKAN_PV}
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
				(
					>=llvm-core/clang-${CLANG_MIN}[${LIBSTDCXX_USEDEP}]
					llvm-core/clang:=
				)
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
		rocm_6_4? (
			>=sys-devel/llvm-roc-${HIP_6_4_VERSION}:0/6.4
			sys-devel/llvm-roc:=
		)
	)
	test? (
		>=dev-libs/weston-14.0.2
	)
	|| (
		>=sys-devel/gcc-${GCC_MIN}
		(
			>=llvm-core/clang-${CLANG_MIN}[${LIBSTDCXX_USEDEP}]
			llvm-core/clang:=
		)
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-4.5.3-install-paths-change.patch"
	"${FILESDIR}/${PN}-4.1.0-openusd-21.11-python.patch"
#	"${FILESDIR}/${PN}-3.0.0-openusd-21-ConnectToSource.patch"
#	"${FILESDIR}/${PN}-3.0.0-openusd-21.11-lightapi.patch"
#	"${FILESDIR}/${PN}-3.0.0-intern-ghost-fix-typo-in-finding-XF86VMODE.patch"
	"${FILESDIR}/${PN}-3.0.0-boost_python.patch"
#	"${FILESDIR}/${PN}-3.0.0-oiio-util.patch"
	"${FILESDIR}/${PN}-4.5.3-hip-flags.patch"
	"${FILESDIR}/${PN}-4.5.3-fix-brotli-check.patch"
	"${FILESDIR}/${PN}-4.5.3-simd-checks.patch"
	"${FILESDIR}/${PN}-4.5.3-optionalize-simd.patch"
	"${FILESDIR}/${PN}-5.0.0-fix-hip-bin-path.patch"
	"${FILESDIR}/${PN}-5.0.0-hip-symbolize-versions.patch"
)

_blender_set_rocm_compiler() {
	# See https://github.com/blender/blender/blob/v4.5.5/build_files/config/pipeline_config.yaml
	if use rocm_6_4 ; then
		export LLVM_SLOT=19
		export ROCM_SLOT="6.4"
		export ROCM_VERSION="${HIP_6_4_VERSION}"
	fi
	rocm_pkg_setup
	rocm_set_default_hipcc
}

_blender_pkg_setup() {
	# TODO: ldd oiio for webp and warn user if missing
	# Needs OpenCL 1.2 (GCN 2)
	print_release_description

	local found=0
	local s
	for s in "${LLVM_COMPAT[@]}" ; do
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

	local x
	for x in "${LLVM_COMPAT[@]}" ; do
		if use "llvm_slot_${x}" ; then
ewarn "Using LLVM ${x}"
			break
		fi
	done

	libcxx-slot_verify
	libstdcxx-slot_verify
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
	for x in "${hiprt_patchset[@]}" ; do
		eapply "${FILESDIR}/pr121050/${x}"
	done
	eapply "${FILESDIR}/${PN}-3.6.13-hiprt-linker-changes.patch"
	eapply "${FILESDIR}/${PN}-3.6.13-HIPRT-change-version-file-path.patch"
}

_src_prepare_patches() {
	#apply_hiprt_2_3_patchset
	eapply "${FILESDIR}/blender-4.5.3-parent-datafiles-dir-change.patch"
	if use rocm ; then
		local rocm_version=""
		if use rocm_6_4 ; then
			rocm_version="${HIP_6_4_VERSION}"
		fi

		sed \
			-i \
			-e "s|/opt/rocm/|/opt/rocm/|g" \
			"extern/hipew/src/hipew.c" \
			|| die

		sed \
			-i \
			-e "s|HIP 5.5.0|HIP ${rocm_version}|g" \
			"intern/cycles/cmake/external_libs.cmake" \
			|| die

		local hiprt_major_version=$(grep -e "#define HIPRT_MAJOR_VERSION" "/opt/rocm/include/hiprt/hiprt.h" \
			| cut -f 3 -d " ")
		local hiprt_minor_version=$(grep -e "#define HIPRT_MINOR_VERSION" "/opt/rocm/include/hiprt/hiprt.h" \
			| cut -f 3 -d " ")
		local hiprt_patch_version=$(grep -e "#define HIPRT_PATCH_VERSION" "/opt/rocm/include/hiprt/hiprt.h" \
			| cut -f 3 -d " ")
		local hiprt_api_version=$(grep -e "#define HIPRT_API_VERSION" "/opt/rocm/include/hiprt/hiprt.h" \
			| cut -f 3 -d " ")
		local hiprt_version_str=$(grep -e "#define HIPRT_VERSION_STR" "/opt/rocm/include/hiprt/hiprt.h" \
			| cut -f 3 -d " " \
			| sed -e 's|"||g')
		local hip_version_str=$(grep -e "#define HIP_VERSION_STR" "/opt/rocm/include/hiprt/hiprt.h" \
			| cut -f 3 -d " " \
			| sed -e 's|"||g')
		sed \
			-i \
			-e "s|@HIPRT_MAJOR_VERSION@|${hiprt_major_version}|g" \
			-e "s|@HIPRT_MINOR_VERSION@|${hiprt_minor_version}|g" \
			-e "s|@HIPRT_PATCH_VERSION@|${hiprt_patch_version}|g" \
			-e "s|@HIPRT_API_VERSION@|${hiprt_api_version}|g" \
			-e "s|@HIPRT_VERSION_STR@|${hiprt_version_str}|g" \
			-e "s|@HIP_VERSION_STR@|${hip_version_str}|g" \
			"extern/hipew/include/hiprtew.h" \
			|| die
	fi
}

_src_configure_compiler() {
	set_blender_compiler
}

_src_configure() {
	export CMAKE_USE_DIR="${S}"
	export BUILD_DIR="${S}_${impl}_build"
	cd "${CMAKE_USE_DIR}" || die

	if has_version "dev-libs/wayland" && ! use wayland ; then
eerror "You must enable the wayland USE flag or uninstall wayland."
		die
	fi

	# FIX: forcing '-funsigned-char' fixes an anti-aliasing issue with menu
	# shadows, see bug #276338 for reference
	append-flags -funsigned-char
	append-lfs-flags
	cflags-hardened_append
	fix_mb_len_max

	local s="${OPENVDB_ABIS_MAJOR_VERS}"
	if use "abi${s}-compat" ; then
		append-cppflags -DOPENVDB_ABI_VERSION_NUMBER="${s}"
	fi

	local mycmakeargs=(
		-DCMAKE_INSTALL_BINDIR:PATH="${EPREFIX}$(get_dest)"
	)

	unset CMAKE_INCLUDE_PATH
	unset CMAKE_LIBRARY_PATH
	unset CMAKE_PREFIX_PATH

	blender_configure_eigen

	# TODO: migrate blender-libs changes from blender-v2.83 once LLVM-10 is deprecated

	cython_set_cython_slot "3"
	cython_python_configure

	if use rocm ; then
		if eselect profile show | grep "llvm" ; then
	# Skip for libc++ based systems
			:
		else
	# Apply for libstdc++ based systems
			filter-flags "-Wl,--as-needed"
			append-ldflags "-Wl,-latomic"
		fi
	fi

	if has "materialx" ${IUSE_EFFECTIVE} use materialx ; then
		fix-rpath_append "/usr/lib/materialx/$(get_libdir)"
	fi

	ffmpeg_src_configure

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
		-DWITH_OPENSUBDIV=$(usex opensubdiv)
		-DWITH_OPENVDB=$(usex openvdb)
		-DWITH_OPENVDB_BLOSC=$(usex openvdb)
		-DWITH_PIPEWIRE=$(usex pipewire)
		-DWITH_POTRACE=$(usex potrace)
		-DWITH_PUGIXML=$(usex openimageio ON $(usex osl ON OFF))
		-DWITH_PULSEAUDIO=$(usex pulseaudio)
		-DWITH_PYTHON_INSTALL=OFF
		-DWITH_PYTHON_INSTALL_NUMPY=OFF
		-DWITH_UV_SLIM=$(usex uv-slim)
		-DWITH_USD=$(usex usd)
		-DWITH_TBB=$(usex tbb)
		-DWITH_XR_OPENXR=$(usex openxr)

		-DWITH_SSE=$(usex cpu_flags_x86_sse)
		-DWITH_SSE2=$(usex cpu_flags_x86_sse2)
		-DWITH_SSE3=$(usex cpu_flags_x86_sse3)
		-DWITH_SSSE3=$(usex cpu_flags_x86_ssse3)
		-DWITH_LZCNT=$(usex cpu_flags_x86_lzcnt)
		-DWITH_BMI=$(usex cpu_flags_x86_bmi)
		-DWITH_BMI2=$(usex cpu_flags_x86_bmi2)
		-DWITH_FMA=$(usex cpu_flags_x86_fma)
		-DWITH_F16C=$(usex cpu_flags_x86_f16c)
		-DWITH_SSE41=$(usex cpu_flags_x86_sse4_1)
		-DWITH_SSE42=$(usex cpu_flags_x86_sse4_2)
		-DWITH_AVX=$(usex cpu_flags_x86_avx)
		-DWITH_AVX2=$(usex cpu_flags_x86_avx2)
	)

	blender_configure_linker_flags

	# Speed up build time
	if use cuda ; then
		local targets=""
		local cuda_target
		for cuda_target in "${CUDA_TARGETS_COMPAT[@]}" ; do
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
		for rocm_target in "${AMDGPU_TARGETS_COMPAT[@]}" ; do
			if use "${rocm_target/#/amdgpu_targets_}" ; then
				targets+=";${rocm_target}"
			fi
		done
		targets=$(echo "${targets}" \
			| sed -e "s|^;||g")
		mycmakeargs+=(
			-DCYCLES_HIP_BINARIES_ARCH="${targets}"
			-DHIP_DIR="/opt/rocm"
			-DHIP_ROOT_DIR="/opt/rocm"
		)
einfo "AMDGPU_TARGETS:  ${targets}"
	fi

	if use hiprt ; then
		mycmakeargs+=(
			-DHIPRT_ROOT_DIR="/opt/rocm"
		)
	fi

	local llvm_slot
	local s
	for s in "${LLVM_COMPAT[@]}" ; do
		use "llvm_slot_${s}" && llvm_slot="${s}"
	done

	if use materialx ; then
		mycmakeargs+=(
			-DMaterialX_DIR:PATH="${ESYSROOT}/usr/lib/materialx/$(get_libdir)/cmake/MaterialX"
		)
	fi

	if use collada ; then
		mycmakeargs+=(
			-DOpenCOLLADA_DIR:PATH="${ESYSROOT}/usr/lib/aras-p-opencollada"
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
# https://github.com/blender/blender/tree/v4.5.5/build_files/cmake/config
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
			"${BLENDER_CMAKE_ARGS[@]}"
		)
	fi

	cmake_src_configure
}

_blender_src_install() {
	if use rocm ; then
	#
	# We do not add /opt/rocm/lib to /etc/ld.so.conf by default to avoid
	# mixing OpenMP, mixing LLVM libs, or security reasons.  One or the
	# other may be behind in security updates.
	#
	# Tell the dynamic loader where to find the HIP RT library when dlopen
	# is called.
	#
		fix-rpath_repair_append "${ED}/usr/$(get_libdir)/blender/${PV}/creator" "/opt/rocm/lib"
		fix-rpath_repair_append "${ED}/usr/$(get_libdir)/blender/${PV}/creator" "/opt/rocm/lib/llvm/lib"
	fi

	if use ffmpeg ; then
	# The rpath gets dropped when it should not.
		local ffmpeg_slot=$(ffmpeg_get_slot)
		fix-rpath_repair_append "${ED}/usr/$(get_libdir)/blender/${PV}/creator" "/usr/lib/ffmpeg/${ffmpeg_slot}/$(get_libdir)"
	fi
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
