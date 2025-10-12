# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: blender-v4.5.eclass
# @MAINTAINER: Orson Teodoro <orsonteodoro@hotmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: blender implementation
# @DESCRIPTION:
# The blender-v4.5.eclass helps reduce code duplication across ebuilds
# using the same major.minor version.

# FIXME:  alembic requires imath

# Upstream uses LLVM 12.0.0 for Linux.  For prebuilt binary only addons, this may be
# problematic so avoid them.

# The ebuild uses the same matching LLVM version used with Mesa to prevent
# the multiple LLVM bug.

# For versioning see:
# https://github.com/blender/blender/blob/v4.5.3/source/blender/blenkernel/BKE_blender_version.h

# Keep dates and links updated to speed up releases and decrease maintenance time cost.
# No need to look past those dates.

# Last change was Jul 7, 2025 for:
# https://github.com/blender/blender/blob/v4.5.3/build_files/build_environment/install_linux_packages.py

# Last change was Apr 8, 2025 for:
# https://github.com/blender/blender/blob/v4.5.3/build_files/cmake/config/blender_release.cmake
# used for REQUIRED_USE section.

# Last change was Jul 8, 2025 for:
# https://github.com/blender/blender/blob/v4.5.3/build_files/build_environment/cmake/versions.cmake
# used for *DEPENDs.

# HIP:  https://github.com/blender/blender/blob/v4.5.3/intern/cycles/cmake/external_libs.cmake#L47

# GPU lib versions:  https://github.com/blender/blender/blob/v4.5.3/build_files/config/pipeline_config.yaml

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

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX17[@]}
)

# For max and min package versions see link below. \
# https://github.com/blender/blender/blob/v4.5.3/build_files/build_environment/install_linux_packages.py
# Ebuild will disable patented codecs by default, but upstream enables by default.
FFMPEG_IUSE+="
	+jpeg2k libaom +mp3 +opus rav1e svt-av1 +theora +vorbis +vpx webm +webp x264 x265 +xvid
"

# ROCm 6.4: 19, ROCm 6.3: 18
# Upstream limits LLVM to [15, 18) but relaxed for ROCm and overlay compatibility
# It uses LLVM 17 as default.
LLVM_COMPAT=( {18..17} ) # TODO bump to 19 after ROCm 6.4 added
LLVM_MAX_SLOT="${LLVM_COMPAT[0]}"
LLVM_MAX_UPSTREAM=17 # (inclusive)

# Platform defaults based on CMakeList.txt
OPENVDB_ABIS_MAJOR_VERS=12
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
# https://github.com/blender/blender/blob/v4.5.3/build_files/build_environment/install_linux_packages.py#L693 \
PYTHON_COMPAT=( "python3_"{11,12} ) # <= 3.12.

BOOST_PV="1.82"
CLANG_MIN="8.0"
FREETYPE_PV="2.13.0"
GCC_MIN="11.2"
LIBOGG_PV="1.3.5"
LIBSNDFILE_PV="1.2.2"
ONETBB_SLOT="0"
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
OSL_PV="1.14.3.0"
PUGIXML_PV="1.10"
THEORA_PV="1.1.1"
VULKAN_PV="1.3.296"

CUDA_TARGETS_COMPAT=(
	compute_75
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

	sm_80
	sm_90
	sm_100
	sm_120
)
OPTIX_RAYTRACE_TARGETS=(
	sm_75
	sm_86
	sm_89
)

AMDGPU_TARGETS_COMPAT=(
# https://github.com/blender/blender/blob/v4.5.3/CMakeLists.txt#L699
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
	gfx1152
	gfx1200
	gfx1201
)
HIPRT_RAYTRACE_TARGETS=(
# See https://github.com/GPUOpen-LibrariesAndSDKs/HIPRT/blob/2.5.a21e075/scripts/bitcodes/compile.py#L90
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
	gfx1150
	gfx1151
	gfx1200
	gfx1201
)
ROCM_SLOTS=(
	rocm_6_3
)

IUSE+="
${CPU_FLAGS_3_3[@]%:*}
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${FFMPEG_IUSE}
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
ebuild_revision_21
"
# hip is default ON upstream.
inherit blender libstdcxx-slot

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
# ( all-rights-reserved Apache-2.0 ) - blender-4.5.3/extern/mantaflow/LICENSE
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
#   - blender-4.5.3/release/license/THIRD-PARTY-LICENSES.txt
# all-rights-reserved MIT - blender-4.5.3/extern/vulkan_memory_allocator/LICENSE.txt
# Apache-2.0 - blender-4.5.3/intern/cycles/doc/license/Apache2-license.txt
# Apache-2.0 - blender-4.5.3/extern/cuew/LICENSE
# Apache-2.0 BSD BSD-2 GPL-2.0+ GPL-3.0+ LGPL-2.1+ MIT MPL-2.0 ZLIB - blender-4.5.3/doc/license/SPDX-license-identifiers.txt
# Apache-2.0 BSD MIT ZLIB - blender-4.5.3/intern/cycles/doc/license/SPDX-license-identifiers.txt
# BL - blender-4.5.3/doc/license/BL-license.txt
# Boost-1.0 - blender-4.5.3/extern/quadriflow/3rd/lemon-1.3.1/LICENSE
# BSD - blender-4.5.3/intern/cycles/doc/license/BSD-3-Clause-license.txt
# BSD-2.0 - blender-4.5.3/extern/xxhash/LICENSE
# BSD custom - blender-4.5.3/extern/quadriflow/LICENSE.txt
# CC-BY-4.0 - The splash screen chosen license is found in https://www.blender.org/download/demo-files/ )
# CC0-1.0 - blender-4.5.3/release/datafiles/studiolights/world/license.txt
# custom MIT - blender-4.5.3/extern/fmtlib/LICENSE.rst
# GPL-2+ - blender-4.5.3/tools/check_source/check_licenses.py
# GPL-2.0 - blender-4.5.3/release/license/GPL-license.txt
# GPL-3.0 - blender-4.5.3/doc/license/GPL3-license.txt
# LGPL-2.1 - ./blender-4.5.3/doc/license/LGPL2.1-license.txt
# MIT - blender-4.5.3/intern/cycles/doc/license/MIT-license.txt
# ZLIB - blender-4.5.3/intern/cycles/doc/license/Zlib-license.txt
# ZLIB - blender-4.5.3/doc/license/Zlib-license.txt
# || ( CC0-1.0 public-domain ) - blender-4.5.3/release/datafiles/studiolights/matcap/license.txt
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
			rocm_6_3
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
	)
	rocm_6_3? (
		llvm_slot_18
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
				=llvm-runtimes/compiler-rt-sanitizers-${s}*[asan]
				llvm-runtimes/compiler-rt-sanitizers:=
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
			>=media-libs/oidn-2.3.3[${LIBSTDCXX_USEDEP},llvm_slot_${s},aot?,sycl?]
			<media-libs/oidn-3.0[${LIBSTDCXX_USEDEP},llvm_slot_${s},aot?,sycl?]
			media-libs/oidn:=
		)
		"
	done
}

gen_oiio_depends() {
	local s
	for s in ${OPENVDB_ABIS[@]} ; do
		echo "
			${s}? (
				>=dev-cpp/robin-map-1.3.0
				>=dev-libs/libfmt-9.1.0[${LIBSTDCXX_USEDEP}]
				dev-libs/libfmt:=
				>=media-libs/openimageio-3.0.6.1[${LIBSTDCXX_USEDEP},${PYTHON_SINGLE_USEDEP},${s}(+),color-management?,jpeg2k?,png,python,tools(+),webp?]
				<media-libs/openimageio-3.1.0[${LIBSTDCXX_USEDEP},${PYTHON_SINGLE_USEDEP},${s}(+),color-management?,jpeg2k?,png,python,tools(+),webp?]
				media-libs/openimageio:=
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
				~media-libs/openexr-${openexr_pv}[${LIBSTDCXX_USEDEP}]
				media-libs/openexr:=
				~dev-libs/imath-${imath_pv}[${LIBSTDCXX_USEDEP}]
				dev-libs/imath:=
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
				>=media-libs/osl-${OSL_PV}[llvm_slot_${s},static-libs]
				<media-libs/osl-2.0[llvm_slot_${s},static-libs]
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
				media-video/ffmpeg:0/56.58.58[encode,jpeg2k?,libaom?,mp3?,opus?,-patent_status_nonfree,rav1e?,sdl,svt-av1?,theora?,vorbis?,vpx?,-x264,xvid?,zlib]
				media-video/ffmpeg:0/57.59.59[encode,jpeg2k?,libaom?,mp3?,opus?,-patent_status_nonfree,rav1e?,sdl,svt-av1?,theora?,vorbis?,vpx?,-x264,xvid?,zlib]
				media-video/ffmpeg:0/58.60.60[encode,jpeg2k?,libaom?,mp3?,opus?,-patent_status_nonfree,rav1e?,sdl,svt-av1?,theora?,vorbis?,vpx?,-x264,xvid?,zlib]
				media-video/ffmpeg:0/59.61.61[encode,jpeg2k?,libaom?,mp3?,opus?,-patent_status_nonfree,rav1e?,sdl,svt-av1?,theora?,vorbis?,vpx?,-x264,xvid?,zlib]
				>=media-video/ffmpeg-4.0:0[encode,jpeg2k?,libaom?,mp3?,opus?,-patent_status_nonfree,rav1e?,sdl,svt-av1?,theora?,vorbis?,vpx?,-x264,xvid?,zlib]
				<media-video/ffmpeg-8:0[encode,jpeg2k?,libaom?,mp3?,opus?,-patent_status_nonfree,rav1e?,sdl,svt-av1?,theora?,vorbis?,vpx?,-x264,xvid?,zlib]
			)
		)
	)
	patent_status_nonfree? (
		ffmpeg? (
			|| (
				media-video/ffmpeg:0/56.58.58[encode,jpeg2k?,libaom?,mp3?,opus?,patent_status_nonfree,rav1e?,sdl,svt-av1?,theora?,vorbis?,vpx?,x264?,xvid?,zlib]
				media-video/ffmpeg:0/57.59.59[encode,jpeg2k?,libaom?,mp3?,opus?,patent_status_nonfree,rav1e?,sdl,svt-av1?,theora?,vorbis?,vpx?,x264?,xvid?,zlib]
				media-video/ffmpeg:0/58.60.60[encode,jpeg2k?,libaom?,mp3?,opus?,patent_status_nonfree,rav1e?,sdl,svt-av1?,theora?,vorbis?,vpx?,x264?,xvid?,zlib]
				media-video/ffmpeg:0/59.61.61[encode,jpeg2k?,libaom?,mp3?,opus?,patent_status_nonfree,rav1e?,sdl,svt-av1?,theora?,vorbis?,vpx?,x264?,xvid?,zlib]
				>=media-video/ffmpeg-4.0:0[encode,jpeg2k?,libaom?,mp3?,opus?,patent_status_nonfree,rav1e?,sdl,svt-av1?,theora?,vorbis?,vpx?,x264?,xvid?,zlib]
				<media-video/ffmpeg-8:0[encode,jpeg2k?,libaom?,mp3?,opus?,patent_status_nonfree,rav1e?,sdl,svt-av1?,theora?,vorbis?,vpx?,x264?,xvid?,zlib]
			)
		)
	)
"
# The distro's llvm 14 for mesa is 22.05.
# Missing OCLOC
# Missing nanobind
# For compute-runtime version correspondance to level zero, see https://github.com/intel/compute-runtime/blob/23.52.28202.45/manifests/manifest.yml#L56
# https://github.com/oneapi-src/unified-runtime/blob/da04d13807044aaf17615b66577fb0e832011ab1/cmake/FetchLevelZero.cmake#L104
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
	>=dev-cpp/pystring-1.1.3[${LIBSTDCXX_USEDEP}]
	dev-cpp/pystring[${LIBSTDCXX_USEDEP}]
	>=dev-lang/python-3.11.11
	>=dev-libs/fribidi-1.0.12
	>=media-libs/freetype-${FREETYPE_PV}[brotli]
	>=media-libs/libpng-1.6.43:0=
	>=media-libs/shaderc-2024.3[${LIBSTDCXX_USEDEP}]
	media-libs/shaderc:=
	>=media-libs/vulkan-loader-${VULKAN_PV}
	>=sci-mathematics/manifold-3.1.0[${LIBSTDCXX_USEDEP}]
	sci-mathematics/manifold:=
	>=sys-libs/minizip-ng-3.0.7
	>=sys-libs/zlib-1.3.1
	dev-libs/lzo:2
	media-libs/libglvnd
	media-libs/libsamplerate
	media-libs/vulkan-drivers
	virtual/libintl
	alembic? (
		>=media-gfx/alembic-1.8.3[${LIBSTDCXX_USEDEP},boost(+),hdf(+)]
		media-gfx/alembic:=
	)
	boost? (
		>=dev-libs/boost-${BOOST_PV}[${LIBSTDCXX_USEDEP},nls?,threads(+)]
		usd? (
			>=dev-libs/boost-${BOOST_PV}[${LIBSTDCXX_USEDEP},nls?,threads(+),python]
		)
		dev-libs/boost:=
	)
	collada? (
		>=media-libs/aras-p-opencollada-20240718[${LIBSTDCXX_USEDEP}]
		media-libs/aras-p-opencollada:=
	)
	color-management? (
		>=dev-libs/expat-2.6.4
		>=media-libs/opencolorio-2.4.1[${LIBSTDCXX_USEDEP},cpu_flags_x86_sse2?,python]
	)
	cuda? (
		cuda_targets_sm_35? (
			|| (
				=dev-util/nvidia-cuda-toolkit-11*
			)
		)
		cuda_targets_sm_37? (
			|| (
				=dev-util/nvidia-cuda-toolkit-11*
			)
		)
		cuda_targets_sm_50? (
			|| (
				=dev-util/nvidia-cuda-toolkit-12*
				=dev-util/nvidia-cuda-toolkit-11*
			)
		)
		cuda_targets_sm_52? (
			|| (
				=dev-util/nvidia-cuda-toolkit-12*
				=dev-util/nvidia-cuda-toolkit-11*
			)
		)
		cuda_targets_sm_60? (
			|| (
				=dev-util/nvidia-cuda-toolkit-12*
				=dev-util/nvidia-cuda-toolkit-11*
			)
		)
		cuda_targets_sm_61? (
			|| (
				=dev-util/nvidia-cuda-toolkit-12*
				=dev-util/nvidia-cuda-toolkit-11*
			)
		)
		cuda_targets_sm_70? (
			|| (
				=dev-util/nvidia-cuda-toolkit-12*
				=dev-util/nvidia-cuda-toolkit-11*
			)
		)
		cuda_targets_sm_75? (
			|| (
				=dev-util/nvidia-cuda-toolkit-12*
				=dev-util/nvidia-cuda-toolkit-11*
			)
		)
		cuda_targets_sm_86? (
			|| (
				=dev-util/nvidia-cuda-toolkit-12*
				=dev-util/nvidia-cuda-toolkit-11*
			)
		)
		cuda_targets_sm_89? (
			|| (
				=dev-util/nvidia-cuda-toolkit-12*
				=dev-util/nvidia-cuda-toolkit-11*
			)
		)
		cuda_targets_compute_75? (
			|| (
				=dev-util/nvidia-cuda-toolkit-12*
				=dev-util/nvidia-cuda-toolkit-11*
			)
		)
		dev-util/nvidia-cuda-toolkit:=
	)
	cycles? (
		cycles-path-guiding? (
			(
				>=media-libs/openpgl-0.6.0[${LIBSTDCXX_USEDEP},tbb?]
				<media-libs/openpgl-0.7.0[${LIBSTDCXX_USEDEP},tbb?]
				media-libs/openpgl:=
			)
		)
		osl? (
			>=dev-libs/pugixml-${PUGIXML_PV}[${LIBSTDCXX_USEDEP}]
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
		>=dev-libs/gmp-6.3.0[cxx]
	)
	hiprt? (
		rocm_6_3? (
			=media-libs/hiprt-2.5*:6.3[rocm]
		)
		media-libs/hiprt:=
	)
	jack? (
		virtual/jack
	)
	jemalloc? (
		>=dev-libs/jemalloc-5.2.1[${LIBSTDCXX_USEDEP}]
		dev-libs/jemalloc:=
	)
	jpeg2k? (
		>=media-libs/openjpeg-2.5.0:2
	)
	llvm? (
		$(gen_llvm_depends)
	)
	llvm_slot_17? (
		|| (
			=media-libs/mesa-24.1*[X?]
		)
	)
	llvm_slot_18? (
		|| (
			=media-libs/mesa-24.1*[X?]
			=media-libs/mesa-25.0*[X?]
			=media-libs/mesa-25.1*[X?]
			=media-libs/mesa-25.2*[X?]
			=media-libs/mesa-9999[X?]
		)
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
			>=media-libs/openal-1.23.1[${LIBSTDCXX_USEDEP},alsa]
		)
		>=media-libs/openal-1.23.1[${LIBSTDCXX_USEDEP},pulseaudio?]
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
		>=dev-libs/pugixml-${PUGIXML_PV}[${LIBSTDCXX_USEDEP}]
		dev-libs/pugixml:=
	)
	openexr? (
		!<media-libs/openexr-3
		|| (
			$(gen_openexr_pairs)
		)
	)
	opensubdiv? (
		>=media-libs/opensubdiv-3.6.0[${LIBSTDCXX_USEDEP},cuda=,opencl=,opengl(+),tbb?]
		media-libs/opensubdiv:=
	)
	openvdb? (
		abi12-compat? (
			|| (
				=media-gfx/openvdb-13*[${LIBSTDCXX_USEDEP},${PYTHON_SINGLE_USEDEP},abi12-compat,blosc,nanovdb?,numpy]
				=media-gfx/openvdb-12*[${LIBSTDCXX_USEDEP},${PYTHON_SINGLE_USEDEP},abi12-compat,blosc,nanovdb?,numpy]
			)
			media-gfx/openvdb:=
		)
		>=dev-libs/c-blosc-1.21.1[zlib]
	)
	openxr? (
		>=media-libs/openxr-1.0.22[${LIBSTDCXX_USEDEP}]
		media-libs/openxr:=
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
		>=media-libs/harfbuzz-10.0.1[truetype]
	)
	rocm? (
		rocm_6_3? (
			~dev-libs/rocm-opencl-runtime-${HIP_6_3_VERSION}:6.3
			~dev-util/hip-${HIP_6_3_VERSION}:6.3[${LIBSTDCXX_USEDEP},rocm]
			dev-util/hip:=
			~sys-libs/llvm-roc-libomp-${HIP_6_3_VERSION}:6.3
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
			>=dev-libs/level-zero-1.19.2[${LIBSTDCXX_USEDEP}]
			<dev-libs/level-zero-2.0[${LIBSTDCXX_USEDEP}]
			dev-libs/level-zero:=
		)
		|| (
			(
				>=sys-devel/DPC++-2025.01.08:0/8[aot?]
				!<sys-devel/DPC++-2025.01.08
			)
		)
		aot? (
			>=dev-libs/intel-compute-runtime-23.52.28202.45[l0]
			>=dev-util/intel-graphics-compiler-2.1.14
		)
	)
	tbb? (
		>=dev-cpp/tbb-2021.13.0:${ONETBB_SLOT}[${LIBSTDCXX_USEDEP},tbbmalloc(+)]
		dev-cpp/tbb:=
	)
	tiff? (
		>=media-libs/tiff-4.7.0:0[jpeg,zlib]
	)
	usd? (
		>=media-libs/openusd-25.02[imaging,materialx?,monolithic,opengl,openvdb,openimageio,python]
		<media-libs/openusd-26.0[imaging,materialx?,monolithic,opengl,openvdb,openimageio,python]
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
			>=media-libs/glu-9.0.1[${LIBSTDCXX_USEDEP}]
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
		>=dev-python/cython-3.0.11[${PYTHON_USEDEP}]
		>=dev-python/autopep8-2.3.1[${PYTHON_USEDEP}]
		>=dev-python/pycodestyle-2.13.0[${PYTHON_USEDEP}]
	' 'python*')
	>=dev-build/cmake-3.10
	>=dev-cpp/yaml-cpp-0.7.0[${LIBSTDCXX_USEDEP}]
	dev-cpp/yaml-cpp:=
	>=dev-build/meson-0.63.0
	>=dev-util/vulkan-headers-${VULKAN_PV}
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
		rocm_6_3? (
			~sys-devel/llvm-roc-${HIP_6_3_VERSION}:6.3
		)
	)
	test? (
		>=dev-libs/weston-14.0.2
	)
	|| (
		>=sys-devel/gcc-${GCC_MIN}
		>=llvm-core/clang-${CLANG_MIN}
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
)

_blender_pkg_setup() {
	# TODO: ldd oiio for webp and warn user if missing
	# Needs OpenCL 1.2 (GCN 2)
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

	if use llvm_slot_18 ; then
ewarn "Using LLVM 18"
ewarn "LLVM 18 is only for ROCm 6.3 builds and is untested."
	fi
	if use llvm_slot_17 ; then
einfo "Using LLVM 17"
	fi

	if use rocm ; then
	# Upstream uses ROCm 6.4 for Linux, ROCm 6.3 for Windows
		if use rocm_6_3 ; then
			export LLVM_SLOT=18
			export ROCM_SLOT="6.3"
			export ROCM_VERSION="${HIP_6_3_VERSION}"
		else
# See https://github.com/blender/blender/blob/v4.5.3/build_files/config/pipeline_config.yaml
eerror
eerror "Supported ROCm version(s):"
eerror
eerror "  6.3"
eerror "  6.4"
eerror
			die
		fi
		rocm_pkg_setup
	#else
		# See blender_pkg_setup for llvm_pkg_setup
	fi
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
	for x in ${hiprt_patchset[@]} ; do
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
		if use rocm_6_3 ; then
			rocm_version="${HIP_6_3_VERSION}"
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
		append-cppflags -DOPENVDB_ABI_VERSION_NUMBER=${s}
	fi

	local mycmakeargs=(
		-DCMAKE_INSTALL_BINDIR:PATH="${EPREFIX}$(get_dest)"
	)

	unset CMAKE_INCLUDE_PATH
	unset CMAKE_LIBRARY_PATH
	unset CMAKE_PREFIX_PATH

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
# https://github.com/blender/blender/tree/v4.5.3/build_files/cmake/config
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
