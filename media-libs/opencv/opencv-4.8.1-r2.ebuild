# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U20
# CI does not test U22 *DEPENDs for this release.

# For the flatbuffers version restriction, see
# https://github.com/opencv/opencv/blob/4.8.1/modules/dnn/misc/tflite/schema_generated.h#L11
# (The patch will allow for newer revisions.)

_MULTILIB_WRAPPED_HEADERS=(
	# [opencv4]
	"/usr/include/opencv4/opencv2/cvconfig.h"
	"/usr/include/opencv4/opencv2/opencv_modules.hpp"

	"/usr/include/opencv4/opencv2/core_detect.hpp"

	"/usr/include/opencv4/opencv2/cudaarithm.hpp"
	"/usr/include/opencv4/opencv2/cudabgsegm.hpp"
	"/usr/include/opencv4/opencv2/cudacodec.hpp"
	"/usr/include/opencv4/opencv2/cudafeatures2d.hpp"
	"/usr/include/opencv4/opencv2/cudafilters.hpp"
	"/usr/include/opencv4/opencv2/cudaimgproc.hpp"
	"/usr/include/opencv4/opencv2/cudalegacy.hpp"
	"/usr/include/opencv4/opencv2/cudalegacy/NCV.hpp"
	"/usr/include/opencv4/opencv2/cudalegacy/NCVBroxOpticalFlow.hpp"
	"/usr/include/opencv4/opencv2/cudalegacy/NCVHaarObjectDetection.hpp"
	"/usr/include/opencv4/opencv2/cudalegacy/NCVPyramid.hpp"
	"/usr/include/opencv4/opencv2/cudalegacy/NPP_staging.hpp"
	"/usr/include/opencv4/opencv2/cudaobjdetect.hpp"
	"/usr/include/opencv4/opencv2/cudaoptflow.hpp"
	"/usr/include/opencv4/opencv2/cudastereo.hpp"
	"/usr/include/opencv4/opencv2/cudawarping.hpp"
	# [cudev]
	"/usr/include/opencv4/opencv2/cudev.hpp"
	"/usr/include/opencv4/opencv2/cudev/block/block.hpp"
	"/usr/include/opencv4/opencv2/cudev/block/detail/reduce.hpp"
	"/usr/include/opencv4/opencv2/cudev/block/detail/reduce_key_val.hpp"
	"/usr/include/opencv4/opencv2/cudev/block/dynamic_smem.hpp"
	"/usr/include/opencv4/opencv2/cudev/block/reduce.hpp"
	"/usr/include/opencv4/opencv2/cudev/block/scan.hpp"
	"/usr/include/opencv4/opencv2/cudev/block/vec_distance.hpp"
	"/usr/include/opencv4/opencv2/cudev/common.hpp"
	"/usr/include/opencv4/opencv2/cudev/expr/binary_func.hpp"
	"/usr/include/opencv4/opencv2/cudev/expr/binary_op.hpp"
	"/usr/include/opencv4/opencv2/cudev/expr/color.hpp"
	"/usr/include/opencv4/opencv2/cudev/expr/deriv.hpp"
	"/usr/include/opencv4/opencv2/cudev/expr/expr.hpp"
	"/usr/include/opencv4/opencv2/cudev/expr/per_element_func.hpp"
	"/usr/include/opencv4/opencv2/cudev/expr/reduction.hpp"
	"/usr/include/opencv4/opencv2/cudev/expr/unary_func.hpp"
	"/usr/include/opencv4/opencv2/cudev/expr/unary_op.hpp"
	"/usr/include/opencv4/opencv2/cudev/expr/warping.hpp"
	"/usr/include/opencv4/opencv2/cudev/functional/color_cvt.hpp"
	"/usr/include/opencv4/opencv2/cudev/functional/detail/color_cvt.hpp"
	"/usr/include/opencv4/opencv2/cudev/functional/functional.hpp"
	"/usr/include/opencv4/opencv2/cudev/functional/tuple_adapter.hpp"
	"/usr/include/opencv4/opencv2/cudev/grid/copy.hpp"
	"/usr/include/opencv4/opencv2/cudev/grid/detail/copy.hpp"
	"/usr/include/opencv4/opencv2/cudev/grid/detail/histogram.hpp"
	"/usr/include/opencv4/opencv2/cudev/grid/detail/integral.hpp"
	"/usr/include/opencv4/opencv2/cudev/grid/detail/minmaxloc.hpp"
	"/usr/include/opencv4/opencv2/cudev/grid/detail/pyr_down.hpp"
	"/usr/include/opencv4/opencv2/cudev/grid/detail/pyr_up.hpp"
	"/usr/include/opencv4/opencv2/cudev/grid/detail/reduce.hpp"
	"/usr/include/opencv4/opencv2/cudev/grid/detail/reduce_to_column.hpp"
	"/usr/include/opencv4/opencv2/cudev/grid/detail/reduce_to_row.hpp"
	"/usr/include/opencv4/opencv2/cudev/grid/detail/split_merge.hpp"
	"/usr/include/opencv4/opencv2/cudev/grid/detail/transform.hpp"
	"/usr/include/opencv4/opencv2/cudev/grid/detail/transpose.hpp"
	"/usr/include/opencv4/opencv2/cudev/grid/histogram.hpp"
	"/usr/include/opencv4/opencv2/cudev/grid/integral.hpp"
	"/usr/include/opencv4/opencv2/cudev/grid/pyramids.hpp"
	"/usr/include/opencv4/opencv2/cudev/grid/reduce.hpp"
	"/usr/include/opencv4/opencv2/cudev/grid/reduce_to_vec.hpp"
	"/usr/include/opencv4/opencv2/cudev/grid/split_merge.hpp"
	"/usr/include/opencv4/opencv2/cudev/grid/transform.hpp"
	"/usr/include/opencv4/opencv2/cudev/grid/transpose.hpp"
	"/usr/include/opencv4/opencv2/cudev/ptr2d/constant.hpp"
	"/usr/include/opencv4/opencv2/cudev/ptr2d/deriv.hpp"
	"/usr/include/opencv4/opencv2/cudev/ptr2d/detail/gpumat.hpp"
	"/usr/include/opencv4/opencv2/cudev/ptr2d/extrapolation.hpp"
	"/usr/include/opencv4/opencv2/cudev/ptr2d/glob.hpp"
	"/usr/include/opencv4/opencv2/cudev/ptr2d/gpumat.hpp"
	"/usr/include/opencv4/opencv2/cudev/ptr2d/interpolation.hpp"
	"/usr/include/opencv4/opencv2/cudev/ptr2d/lut.hpp"
	"/usr/include/opencv4/opencv2/cudev/ptr2d/mask.hpp"
	"/usr/include/opencv4/opencv2/cudev/ptr2d/remap.hpp"
	"/usr/include/opencv4/opencv2/cudev/ptr2d/resize.hpp"
	"/usr/include/opencv4/opencv2/cudev/ptr2d/texture.hpp"
	"/usr/include/opencv4/opencv2/cudev/ptr2d/traits.hpp"
	"/usr/include/opencv4/opencv2/cudev/ptr2d/transform.hpp"
	"/usr/include/opencv4/opencv2/cudev/ptr2d/warping.hpp"
	"/usr/include/opencv4/opencv2/cudev/ptr2d/zip.hpp"
	"/usr/include/opencv4/opencv2/cudev/util/atomic.hpp"
	"/usr/include/opencv4/opencv2/cudev/util/detail/tuple.hpp"
	"/usr/include/opencv4/opencv2/cudev/util/detail/type_traits.hpp"
	"/usr/include/opencv4/opencv2/cudev/util/limits.hpp"
	"/usr/include/opencv4/opencv2/cudev/util/saturate_cast.hpp"
	"/usr/include/opencv4/opencv2/cudev/util/simd_functions.hpp"
	"/usr/include/opencv4/opencv2/cudev/util/tuple.hpp"
	"/usr/include/opencv4/opencv2/cudev/util/type_traits.hpp"
	"/usr/include/opencv4/opencv2/cudev/util/vec_math.hpp"
	"/usr/include/opencv4/opencv2/cudev/util/vec_traits.hpp"
	"/usr/include/opencv4/opencv2/cudev/warp/detail/reduce.hpp"
	"/usr/include/opencv4/opencv2/cudev/warp/detail/reduce_key_val.hpp"
	"/usr/include/opencv4/opencv2/cudev/warp/reduce.hpp"
	"/usr/include/opencv4/opencv2/cudev/warp/scan.hpp"
	"/usr/include/opencv4/opencv2/cudev/warp/shuffle.hpp"
	"/usr/include/opencv4/opencv2/cudev/warp/warp.hpp"
	# [contribcvv]
	"/usr/include/opencv4/opencv2/cvv.hpp"
	"/usr/include/opencv4/opencv2/cvv/call_meta_data.hpp"
	"/usr/include/opencv4/opencv2/cvv/cvv.hpp"
	"/usr/include/opencv4/opencv2/cvv/debug_mode.hpp"
	"/usr/include/opencv4/opencv2/cvv/dmatch.hpp"
	"/usr/include/opencv4/opencv2/cvv/filter.hpp"
	"/usr/include/opencv4/opencv2/cvv/final_show.hpp"
	"/usr/include/opencv4/opencv2/cvv/show_image.hpp"
	# [contribdnn]
	"/usr/include/opencv4/opencv2/dnn.hpp"
	"/usr/include/opencv4/opencv2/dnn/all_layers.hpp"
	"/usr/include/opencv4/opencv2/dnn/dict.hpp"
	"/usr/include/opencv4/opencv2/dnn/dnn.hpp"
	"/usr/include/opencv4/opencv2/dnn/dnn.inl.hpp"
	"/usr/include/opencv4/opencv2/dnn/layer.details.hpp"
	"/usr/include/opencv4/opencv2/dnn/layer.hpp"
	"/usr/include/opencv4/opencv2/dnn/shape_utils.hpp"
	"/usr/include/opencv4/opencv2/dnn/utils/debug_utils.hpp"
	"/usr/include/opencv4/opencv2/dnn/utils/inference_engine.hpp"
	"/usr/include/opencv4/opencv2/dnn/version.hpp"
	"/usr/include/opencv4/opencv2/dnn_superres.hpp"
	# [contribhdf]
	"/usr/include/opencv4/opencv2/hdf.hpp"
	"/usr/include/opencv4/opencv2/hdf/hdf5.hpp"

	"/usr/include/opencv4/opencv2/mcc.hpp"
	"/usr/include/opencv4/opencv2/mcc/ccm.hpp"
	"/usr/include/opencv4/opencv2/mcc/checker_detector.hpp"
	"/usr/include/opencv4/opencv2/mcc/checker_model.hpp"

	"/usr/include/opencv4/opencv2/text.hpp"
	"/usr/include/opencv4/opencv2/text/erfilter.hpp"
	"/usr/include/opencv4/opencv2/text/ocr.hpp"
	"/usr/include/opencv4/opencv2/text/swt_text_detection.hpp"
	"/usr/include/opencv4/opencv2/text/textDetector.hpp"

	# [qt5,qt6]
	"/usr/include/opencv4/opencv2/viz.hpp"
	"/usr/include/opencv4/opencv2/viz/types.hpp"
	"/usr/include/opencv4/opencv2/viz/viz3d.hpp"
	"/usr/include/opencv4/opencv2/viz/vizcore.hpp"
	"/usr/include/opencv4/opencv2/viz/widget_accessor.hpp"
	"/usr/include/opencv4/opencv2/viz/widgets.hpp"

	"/usr/include/opencv4/opencv2/wechat_qrcode.hpp"
)
# From ocv_download()
ADE_PV="0.1.2a"									# See https://github.com/opencv/opencv/blob/4.8.1/modules/gapi/cmake/DownloadADE.cmake#L2
CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data" # Biometrics TFA
CFLAGS_HARDENED_VULNERABILITY_HISTORY="BO CE HO IO"
CMAKE_PV="3.26"
DNN_SAMPLES_FACE_DETECTOR_COMMIT="b2bfc75f6aea5b1f834ff0f0b865a7c18ff1459f"	# See https://github.com/opencv/opencv_extra/blob/4.8.1/testdata/dnn/download_models.py#L311
FACE_ALIGNMENT_COMMIT="8afa57abc8229d611c4937165d20e2a2d9fc5a12"		# See https://github.com/opencv/opencv_contrib/blob/4.8.1/modules/face/CMakeLists.txt#L11
GSTREAMER_PV="1.16.2"
NVIDIA_OPTICAL_FLOW_COMMIT="edb50da3cf849840d680249aa6dbef248ebce2ca"		# See https://github.com/opencv/opencv_contrib/blob/4.8.1/modules/cudaoptflow/CMakeLists.txt#L12
OPENEXR2_PV="2.5.10 2.5.9 2.5.8 2.5.7 2.4.3 2.4.2 2.4.1 2.4.0 2.3.0"
OPENEXR3_PV="3.1.12 3.1.11 3.1.10 3.1.9 3.1.8 3.1.7 3.1.6 3.1.5 3.1.4 3.1.3 3.0.5 3.0.4 3.0.3 3.0.2 3.0.1"
PATENT_STATUS_IUSE=(
	patent_status_nonfree
)
PYTHON_COMPAT=( "python3_"{10..12} )
QRCODE_COMMIT="a8b69ccc738421293254aec5ddb38bd523503252"			# See https://github.com/opencv/opencv_contrib/blob/4.8.1/modules/wechat_qrcode/CMakeLists.txt#L15
QT5_PV="5.12.8"
QT6_PV="6.2.4" # For U22 Only
ROCM_SLOTS=(
	"rocm_5_7"
	"rocm_5_6"
	"rocm_5_5"
	"rocm_5_4"
	"rocm_5_3"
	"rocm_5_2"
	"rocm_5_1"
)
XFEATURES2D_BOOSTDESC_COMMIT="34e4206aef44d50e6bbcd0ab06354b52e7466d26"		# See https://github.com/opencv/opencv_contrib/blob/4.8.1/modules/xfeatures2d/cmake/download_boostdesc.cmake#L2
XFEATURES2D_VGG_COMMIT="fccf7cd6a4b12079f73bbfb21745f9babcd4eb1d"		# See https://github.com/opencv/opencv_contrib/blob/4.8.1/modules/xfeatures2d/cmake/download_vgg.cmake#L2

# The following lines are shamelessly stolen from ffmpeg-9999.ebuild with modifications
ARM_CPU_FEATURES=(
	"cpu_flags_arm_fp16:FP16"				# arm only
	"cpu_flags_arm_neon:NEON"				# arm only
	"cpu_flags_arm_neon_dotprod:NEON_DOTPROD"		# arm64 only
	"cpu_flags_arm_vfpv3:VFPV3"				# arm only
)
PPC_CPU_FEATURES=(
	"cpu_flags_ppc_vsx:VSX"					# Always available on Power8
	"cpu_flags_ppc_vsx3:VSX3"				# Always available on Power9
)
RISCV_CPU_FEATURES=(
	"cpu_flags_riscv_rvv:RVV"
)
LOONG_CPU_FEATURES=(
	"cpu_flags_loong_lsx:LSX"
	"cpu_flags_loong_lasx:LASX"
)
X86_CPU_FEATURES=(
	"cpu_flags_x86_avx:AVX"
	"cpu_flags_x86_avx2:AVX2"
	"cpu_flags_x86_avx512bw:AVX_512BW"
	"cpu_flags_x86_avx512cd:AVX_512CD"
	"cpu_flags_x86_avx512dq:AVX_512DQ"
	"cpu_flags_x86_avx512er:AVX512_KNL_EXTRA"
	"cpu_flags_x86_avx512pf:AVX512_KNL_EXTRA"
	"cpu_flags_x86_avx512f:AVX_512F"
	"cpu_flags_x86_avx512ifma:AVX_512IFMA"
	"cpu_flags_x86_avx512vl:AVX_512VL"
	"cpu_flags_x86_avx512_bitalg:AVX_512BITALG"
	"cpu_flags_x86_avx512_4fmaps:AVX512_KNM_EXTRA"
	"cpu_flags_x86_avx512_4vnniw:AVX512_KNM_EXTRA"
	"cpu_flags_x86_avx512_vbmi:AVX_512VBMI"
	"cpu_flags_x86_avx512_vbmi2:AVX_512VBMI2"
	"cpu_flags_x86_avx512_vnni:AVX_512VNNI"
	"cpu_flags_x86_avx512_vpopcntdq:AVX_512VPOPCNTDQ"
	"cpu_flags_x86_f16c:FP16"
	"cpu_flags_x86_fma3:FMA3"
	"cpu_flags_x86_popcnt:POPCNT"
	"cpu_flags_x86_sse:SSE"					# Always available on 64-bit CPUs
	"cpu_flags_x86_sse2:SSE2"				# Always available on 64-bit CPUs
	"cpu_flags_x86_sse3:SSE3"
	"cpu_flags_x86_sse4_1:SSE4_1"
	"cpu_flags_x86_sse4_2:SSE4_2"
	"cpu_flags_x86_ssse3:SSSE3"
)
CPU_FEATURES_MAP=(
	${ARM_CPU_FEATURES[@]}
	${LOONG_CPU_FEATURES[@]}
	${PPC_CPU_FEATURES[@]}
	${RISCV_CPU_FEATURES[@]}
	${X86_CPU_FEATURES[@]}
)

inherit cflags-hardened cuda java-pkg-opt-2 cmake-multilib flag-o-matic hip-versions
inherit python-single-r1 toolchain-funcs

KEYWORDS="~amd64 ~arm64"
SRC_URI="
	https://github.com/${PN}/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz
	https://github.com/opencv/ade/archive/v${ADE_PV}.tar.gz
		-> ade-${ADE_PV}.tar.gz
	contrib? (
		https://github.com/${PN}/${PN}_contrib/archive/${PV}.tar.gz
			-> ${P}_contrib.tar.gz
		contribdnn? (
			https://github.com/${PN}/${PN}_3rdparty/archive/${FACE_ALIGNMENT_COMMIT}.tar.gz
				-> ${PN}_3rdparty-${FACE_ALIGNMENT_COMMIT}.tar.gz
		)
		contribxfeatures2d? (
			https://github.com/${PN}/${PN}_3rdparty/archive/${XFEATURES2D_BOOSTDESC_COMMIT}.tar.gz
				-> ${PN}_3rdparty-${XFEATURES2D_BOOSTDESC_COMMIT}.tar.gz
			https://github.com/${PN}/${PN}_3rdparty/archive/${XFEATURES2D_VGG_COMMIT}.tar.gz
				-> ${PN}_3rdparty-${XFEATURES2D_VGG_COMMIT}.tar.gz
		)
		cuda? (
			https://github.com/NVIDIA/NVIDIAOpticalFlowSDK/archive/${NVIDIA_OPTICAL_FLOW_COMMIT}.tar.gz
				-> NVIDIAOpticalFlowSDK-${NVIDIA_OPTICAL_FLOW_COMMIT}.tar.gz
		)
		dnnsamples? (
			https://github.com/${PN}/${PN}_3rdparty/archive/${QRCODE_COMMIT}.tar.gz
				-> ${PN}_3rdparty-${QRCODE_COMMIT}.tar.gz
			https://github.com/${PN}/${PN}_3rdparty/archive/${DNN_SAMPLES_FACE_DETECTOR_COMMIT}.tar.gz
				-> ${PN}_3rdparty-${DNN_SAMPLES_FACE_DETECTOR_COMMIT}.tar.gz
		)
	)
"

DESCRIPTION="A collection of algorithms and sample code for various computer vision problems"
HOMEPAGE="https://opencv.org"
LICENSE="Apache-2.0"
RESTRICT="
"
SLOT="0/${PV}" # subslot = libopencv* soname version
# We assume not cross-compiling options enabled.
# CI tests with +atlas -openblas for some jobs.
# atlas disabled because it cannot compile, but ON upstream
# mkl not observed in CI.
IUSE="
${CPU_FEATURES_MAP[@]%:*}
${PATENT_STATUS_IUSE[@]}
${ROCM_SLOTS[@]}
-atlas -avif +carotene +contrib contribcvv +contribdnn contribfreetype contribhdf
contribovis contribsfm contribxfeatures2d -cuda -cudnn debug dnnsamples +eigen
-examples +features2d +ffmpeg +flann -gdal gflags glog -gphoto2 +gstreamer +gtk3
-halide +hdr +ieee1394 +imgproc +java +jpeg +jpeg2k +lapack +libaom -mkl mpeg +netpbm -non-free -openblas
+opencl +openexr -opengl -openmp +opencvapps +openh264 openvino -openvx +png
+python +quirc -qt5 -qt6 rocm -spng +sun -system-flatbuffers tesseract -testprograms
-tbb +tiff +vaapi +v4l +vpx +vtk -wayland +webp x264 x265 -xine video_cards_intel
-vulkan ebuild_revision_29
"
# OpenGL needs gtk or Qt installed to activate, otherwise build system
# will silently disable it without the user knowing, which defeats the
# purpose of the opengl use flag.
# cuda needs contrib, bug #701712
gen_rocm_required_use() {
	local s
	for s in ${ROCM_SLOTS[@]} ; do
		echo "
			${s}? (
				rocm
			)
		"
	done
}
PATENT_STATUS_REQUIRED_USE="
	!patent_status_nonfree? (
		!openh264
		!vaapi
		!x264
		!x265
	)
	openh264? (
		patent_status_nonfree
	)
	vaapi? (
		patent_status_nonfree
	)
	x264? (
		patent_status_nonfree
	)
	x265? (
		patent_status_nonfree
	)
"
REQUIRED_USE="
	$(gen_rocm_required_use)
	${PATENT_STATUS_REQUIRED_USE}
	?? (
		carotene
		openvx
	)
	?? (
		gtk3
		qt5
		qt6
		wayland
	)
	?? (
		cuda
		gdal
	)
	?? (
		cuda
		openexr
	)
	?? (
		cuda
		tbb
	)
	amd64? (
		cpu_flags_x86_sse
		cpu_flags_x86_sse2
	)
	atlas? (
		lapack
	)
	contribcvv? (
		contrib
		|| (
			qt5
			qt6
		)
	)
	contribdnn? (
		contrib
	)
	contribfreetype? (
		contrib
	)
	contribhdf? (
		contrib
	)
	contribovis? (
		contrib
	)
	contribsfm? (
		contrib
		eigen
		gflags
		glog
	)
	contribxfeatures2d? (
		contrib
	)
	cpu_flags_x86_avx? (
		cpu_flags_x86_sse4_2
	)
	cpu_flags_x86_avx2? (
		cpu_flags_x86_avx
		cpu_flags_x86_f16c
		cpu_flags_x86_fma3
	)
	cpu_flags_x86_avx512bw? (
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512vl
	)
	cpu_flags_x86_avx512cd? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512f
	)
	cpu_flags_x86_avx512dq? (
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512vl
	)
	cpu_flags_x86_avx512er? (
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512pf
	)
	cpu_flags_x86_avx512f? (
		cpu_flags_x86_avx2
		cpu_flags_x86_avx512cd
	)
	cpu_flags_x86_avx512ifma? (
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
		cpu_flags_x86_avx512_vbmi
	)
	cpu_flags_x86_avx512pf? (
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512er
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
	)
	cpu_flags_x86_avx512vl? (
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512dq
	)
	cpu_flags_x86_avx512_4fmaps? (
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512er
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512pf
		cpu_flags_x86_avx512_4vnniw
		cpu_flags_x86_avx512_vpopcntdq
	)
	cpu_flags_x86_avx512_4vnniw? (
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512er
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512pf
		cpu_flags_x86_avx512_4fmaps
		cpu_flags_x86_avx512_vpopcntdq
	)
	cpu_flags_x86_avx512ifma? (
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
		cpu_flags_x86_avx512_vbmi
		cpu_flags_x86_avx512_vbmi2
		cpu_flags_x86_avx512_vpopcntdq
		cpu_flags_x86_avx512_vnni
	)
	cpu_flags_x86_avx512_vbmi? (
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
		cpu_flags_x86_avx512ifma
		cpu_flags_x86_avx512_vbmi2
		cpu_flags_x86_avx512_vpopcntdq
		cpu_flags_x86_avx512_vnni
	)
	cpu_flags_x86_avx512_vbmi2? (
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
		cpu_flags_x86_avx512ifma
		cpu_flags_x86_avx512_vbmi
		cpu_flags_x86_avx512_vpopcntdq
		cpu_flags_x86_avx512_vnni
	)
	cpu_flags_x86_avx512_vnni? (
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512bw
		cpu_flags_x86_avx512dq
		cpu_flags_x86_avx512f
		cpu_flags_x86_avx512vl
		cpu_flags_x86_avx512ifma
		cpu_flags_x86_avx512_vbmi
		cpu_flags_x86_avx512_vbmi2
		cpu_flags_x86_avx512_vpopcntdq
		cpu_flags_x86_avx512_vnni
	)
	cpu_flags_x86_avx512_vpopcntdq? (
		cpu_flags_x86_avx512cd
		cpu_flags_x86_avx512f
	)
	cpu_flags_x86_f16c? (
		cpu_flags_x86_avx
	)
	cpu_flags_x86_fma3? (
		cpu_flags_x86_avx2
	)
	cpu_flags_x86_sse4_1? (
		cpu_flags_x86_sse3
		cpu_flags_x86_ssse3
	)
	cpu_flags_x86_sse4_2? (
		cpu_flags_x86_sse4_1
		cpu_flags_x86_popcnt
	)
	cpu_flags_x86_ssse3? (
		cpu_flags_x86_sse3
	)
	cpu_flags_x86_sse2? (
		cpu_flags_x86_sse
	)
	cuda? (
		contrib
		tesseract? (
			opencl
		)
	)
	cudnn? (
		cuda
	)
	dnnsamples? (
		examples
	)
	gflags? (
		contrib
	)
	glog? (
		contrib
	)
	java? (
		python
	)
	lapack? (
		|| (
			atlas
			mkl
			openblas
		)
	)
	libaom? (
		ffmpeg
	)
	mkl? (
		lapack
	)
	mpeg? (
		gstreamer
	)
	openblas? (
		lapack
	)
	opengl? (
		gtk3
		qt5
		qt6
	)
	openh264? (
		ffmpeg
	)
	openvx? (
		|| (
			rocm
		)
	)
	python? (
		${PYTHON_REQUIRED_USE}
		contrib
		contribdnn
		features2d
		flann
		imgproc
		|| (
			ffmpeg
			gstreamer
		)
	)
	rocm? (
		^^ (
			${ROCM_SLOTS[@]}
		)
	)
	tesseract? (
		contrib
	)
	vaapi? (
		gstreamer
	)
	vpx? (
		|| (
			ffmpeg
			gstreamer
		)
	)
	x264? (
		gstreamer
	)
	x265? (
		gstreamer
	)
"
# The following logic is intrinsic in the build system, but we do not enforce
# it on the useflags since this just blocks emerging pointlessly:
#	openmp? (
#		!tbb
#	)
gen_openexr_rdepend() {
	local ver
	for ver in ${OPENEXR2_PV[@]} ; do
		echo "
			(
				~dev-libs/imath-${ver}
				~media-libs/openexr-${ver}
			)
		"
	done
	for ver in ${OPENEXR3_PV[@]} ; do
		echo "
			(
				~dev-libs/imath-${ver}
				~media-libs/openexr-${ver}
			)
		"
	done
}
# For ffmpeg version, see \
# https://github.com/opencv/opencv_3rdparty/blob/7da61f0695eabf8972a2c302bf1632a3d99fb0d5/ffmpeg/download_src.sh#L24
# For the commit above, see
# https://github.com/opencv/opencv/blob/4.8.1/3rdparty/ffmpeg/ffmpeg.cmake#L3
gen_rocm_rdepend() {
	local s
	for s in ${ROCM_SLOTS[@]} ; do
		local slot="${s/rocm_}"
		slot="${slot/_/.}"
		echo "
			${s}? (
				sci-libs/MIVisionX:${slot}
			)
		"
	done
}
PATENT_STATUS_RDEPEND="
	virtual/patent-status[patent_status_nonfree=]
	!patent_status_nonfree? (
		ffmpeg? (
			|| (
				media-video/ffmpeg:58.60.60[${MULTILIB_USEDEP},libaom?,-openh264,-patent_status_nonfree,vpx?]
				media-video/ffmpeg:56.58.58[${MULTILIB_USEDEP},libaom?,-openh264,-patent_status_nonfree,vpx?]
				media-video/ffmpeg:0/58.60.60[${MULTILIB_USEDEP},libaom?,-openh264,-patent_status_nonfree,vpx?]
				media-video/ffmpeg:0/56.58.58[${MULTILIB_USEDEP},libaom?,-openh264,-patent_status_nonfree,vpx?]
			)
		)
		gstreamer? (
			>=media-plugins/gst-plugins-meta-${GSTREAMER_PV}:1.0[${MULTILIB_USEDEP},mpeg?,-patent_status_nonfree,-vaapi,vpx?,-x264,-x265]
			!media-plugins/gst-plugins-vaapi
		)
	)
	patent_status_nonfree? (
		ffmpeg? (
			|| (
				media-video/ffmpeg:58.60.60[${MULTILIB_USEDEP},libaom?,openh264?,patent_status_nonfree,vpx?]
				media-video/ffmpeg:56.58.58[${MULTILIB_USEDEP},libaom?,openh264?,patent_status_nonfree,vpx?]
				media-video/ffmpeg:0/58.60.60[${MULTILIB_USEDEP},libaom?,openh264?,patent_status_nonfree,vpx?]
				media-video/ffmpeg:0/56.58.58[${MULTILIB_USEDEP},libaom?,openh264?,patent_status_nonfree,vpx?]
			)
		)
		gstreamer? (
			>=media-plugins/gst-plugins-meta-${GSTREAMER_PV}:1.0[${MULTILIB_USEDEP},mpeg?,patent_status_nonfree,vaapi?,vpx?,x264?,x265?]
			vaapi? (
				>=media-plugins/gst-plugins-vaapi-${GSTREAMER_PV}:1.0[${MULTILIB_USEDEP}]
			)
		)
	)
"
RDEPEND="
	${PATENT_STATUS_RDEPEND}
	dev-libs/protobuf[${MULTILIB_USEDEP}]
	dev-libs/protobuf:=
	>=app-arch/bzip2-1.0.8[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.13[${MULTILIB_USEDEP}]
	!qt5? (
		qt6? (
			>=dev-qt/qtbase-${QT6_PV}:6[gui,widgets,concurrent,opengl?]
		)
	)
	atlas? (
		>=sci-libs/atlas-3.10.3
	)
	avif? (
		>=media-libs/libavif-0.9.3[${MULTILIB_USEDEP}]
	)
	cuda? (
		|| (
			=dev-util/nvidia-cuda-toolkit-11.8*
		)
		dev-util/nvidia-cuda-toolkit:=
	)
	cudnn? (
		=dev-libs/cudnn-8.6*:0/8
		dev-libs/cudnn:=
	)
	contribdnn? (
		system-flatbuffers? (
			=dev-libs/flatbuffers-23.5*:0
			dev-libs/flatbuffers:=
		)
	)
	contribhdf? (
		>=sci-libs/hdf5-1.10.4:0
		sci-libs/hdf5:=
	)
	contribfreetype? (
		(
			>=media-libs/harfbuzz-2.6.4:0[${MULTILIB_USEDEP}]
			media-libs/harfbuzz:=[${MULTILIB_USEDEP}]
		)
		>=media-libs/freetype-2.10.1:2[${MULTILIB_USEDEP}]
	)
	contribovis? (
		>=dev-games/ogre-1.12:0
		dev-games/ogre:=
	)
	ffmpeg? (
		media-video/ffmpeg:=[${MULTILIB_USEDEP}]
	)
	gdal? (
		>=sci-libs/gdal-3.0.4:0
		sci-libs/gdal:=
	)
	gflags? (
		>=dev-cpp/gflags-2.2.2:0[${MULTILIB_USEDEP}]
		dev-cpp/gflags:=[${MULTILIB_USEDEP}]
	)
	glog? (
		>=dev-cpp/glog-0.4.0:0[${MULTILIB_USEDEP}]
		dev-cpp/glog:=[${MULTILIB_USEDEP}]
	)
	gphoto2? (
		>=media-libs/libgphoto2-2.5.24:0[${MULTILIB_USEDEP}]
		media-libs/libgphoto2:=[${MULTILIB_USEDEP}]
	)
	gstreamer? (
		>=media-libs/gstreamer-${GSTREAMER_PV}:1.0[${MULTILIB_USEDEP}]
		>=media-libs/gst-plugins-base-${GSTREAMER_PV}:1.0[${MULTILIB_USEDEP}]
	)
	gtk3? (
		>=dev-libs/glib-2.64.6:2[${MULTILIB_USEDEP}]
		>=x11-libs/gtk+-3.24.18:3[${MULTILIB_USEDEP}]
	)
	halide? (
		dev-lang/halide[${MULTILIB_USEDEP}]
	)
	ieee1394? (
		(
			>=media-libs/libdc1394-2.2.6:2[${MULTILIB_USEDEP}]
			media-libs/libdc1394:=[${MULTILIB_USEDEP}]
		)
		>=sys-libs/libraw1394-2.1.2:0[${MULTILIB_USEDEP}]
	)
	java? (
		>=virtual/jre-1.8:*
	)
	jpeg? (
		>=media-libs/libjpeg-turbo-2.1.3:0[${MULTILIB_USEDEP}]
		media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}]
	)
	jpeg2k? (
		>=media-libs/openjpeg-2.5.0:2[${MULTILIB_USEDEP}]
		media-libs/openjpeg:=[${MULTILIB_USEDEP}]
	)
	lapack? (
		>=virtual/lapack-3.9.0[eselect-ldso]
		virtual/cblas[eselect-ldso]
		virtual/lapacke[eselect-ldso]
	)
	mkl? (
		>=sci-libs/mkl-2020.0.166
	)
	openblas? (
		>=sci-libs/openblas-0.3.8
	)
	opencl? (
		virtual/opencl[${MULTILIB_USEDEP}]
		dev-util/opencl-headers
	)
	openexr? (
		|| (
			$(gen_openexr_rdepend)
		)
		dev-libs/imath:=
		media-libs/openexr:=
	)
	opengl? (
		virtual/opengl[${MULTILIB_USEDEP}]
		virtual/glu[${MULTILIB_USEDEP}]
	)
	openvino? (
		=sci-ml/openvino-2021.4.2
	)
	png? (
		>=media-libs/libpng-1.6.37:0[${MULTILIB_USEDEP}]
		media-libs/libpng:=[${MULTILIB_USEDEP}]
	)
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			>=dev-python/numpy-1.16.5:0[${PYTHON_USEDEP}]
			dev-python/numpy:=[${PYTHON_USEDEP}]
		')
		openvino? (
			=sci-ml/openvino-2021.4.2[${PYTHON_SINGLE_USEDEP}]
		)
	)
	qt5? (
		>=dev-qt/qtgui-${QT5_PV}:5
		>=dev-qt/qtwidgets-${QT5_PV}:5
		>=dev-qt/qttest-${QT5_PV}:5
		>=dev-qt/qtconcurrent-${QT5_PV}:5
		opengl? (
			>=dev-qt/qtopengl-${QT5_PV}:5
		)
	)
	quirc? (
		>=media-libs/quirc-1.1:0
	)
	rocm? (
		|| (
			$(gen_rocm_rdepend)
		)
	)
	spng? (
		>=media-libs/libspng-0.7.3[${MULTILIB_USEDEP}]
	)
	tesseract? (
		>=app-text/tesseract-4.1.1:0[opencl=,${MULTILIB_USEDEP}]
	)
	tbb? (
		>=dev-cpp/tbb-2020.2[${MULTILIB_USEDEP}]
		dev-cpp/tbb:=[${MULTILIB_USEDEP}]
	)
	tiff? (
		>=media-libs/tiff-4.2.0:0[${MULTILIB_USEDEP}]
		media-libs/tiff:=[${MULTILIB_USEDEP}]
	)
	v4l? (
		>=media-libs/libv4l-0.8.3:0[${MULTILIB_USEDEP}]
	)
	vaapi? (
		>=media-libs/libva-2.7.0:0[${MULTILIB_USEDEP}]
	)
	vtk? (
		>=sci-libs/vtk-7.1.1:0[rendering,cuda=]
		sci-libs/vtk:=
	)
	vulkan? (
		media-libs/vulkan-drivers[${MULTILIB_USEDEP}]
		media-libs/vulkan-loader[${MULTILIB_USEDEP}]
	)
	wayland? (
		>=dev-libs/wayland-protocols-1.13
		>=dev-libs/wayland-1.18.0[${MULTILIB_USEDEP}]
		>=x11-libs/libxkbcommon-0.10.0[${MULTILIB_USEDEP}]
	)
	webp? (
		>=media-libs/libwebp-1.3.2:0[${MULTILIB_USEDEP}]
		media-libs/libwebp:=[${MULTILIB_USEDEP}]
	)
	xine? (
		>=media-libs/xine-lib-1.2.9:1
	)
"
DEPEND="
	${RDEPEND}
	eigen? (
		>=dev-cpp/eigen-3.3.8-r1:3
	)
	java? (
		>=virtual/jdk-1.8:*
	)
	vulkan? (
		dev-util/vulkan-headers
	)
"
BDEPEND="
	>=dev-build/cmake-${CMAKE_PV}
	>=dev-util/patchelf-0.10
	dev-util/patchelf
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}/${PN}-3.4.0-disable-download.patch"
	"${FILESDIR}/${PN}-3.4.1-cuda-add-relaxed-constexpr.patch"
	"${FILESDIR}/${PN}-4.1.2-opencl-license.patch"
	"${FILESDIR}/${PN}-4.4.0-disable-native-cpuflag-detect.patch"
	"${FILESDIR}/${PN}-4.5.0-link-with-cblas-for-lapack.patch"
	"${FILESDIR}/${PN}-4.8.0-arm64-fp16.patch"
	"${FILESDIR}/${PN}-4.8.0-fix-cuda-12.2.0.patch"
#	"${FILESDIR}/${PN}-4.8.1-use-system-flatbuffers.patch"
	"${FILESDIR}/${PN}-4.8.1-eliminate-lto-compiler-warnings.patch"
	"${FILESDIR}/${PN}-4.8.1-python3_12-support.patch"
	"${FILESDIR}/${PN}-4.8.1-use-system-opencl.patch"
	"${FILESDIR}/${PN}-4.8.1-opencv_test.patch"
	"${FILESDIR}/${PN}-4.8.1-drop-python2-detection.patch"
	"${FILESDIR}/${PN}-4.8.1-libpng16.patch"
	"${FILESDIR}/${PN}-4.8.1-ade-0.1.2a.tar.gz.patch"
	"${FILESDIR}/${PN}-4.8.1-protobuf-22.patch" # bug 909087, in 4.9.0
	# TODO applied in src_prepare
	# "${FILESDIR}/${PN}_contrib-${PV}-rgbd.patch"
	# "${FILESDIR}/${PN}_contrib-4.8.1-NVIDIAOpticalFlowSDK-2.0.tar.gz.patch"
	"${FILESDIR}/${PN}-4.9.0-openvx-paths.patch" # oiledmachine-overlay change
	"${FILESDIR}/${PN}-4.10.0-vulkan-libdirs.patch"
	"${FILESDIR}/${PN}-4.10.0-halide-libdirs.patch"
)

pkg_pretend() {
	if use cuda && [[ -z "${CUDA_GENERATION}" ]] && [[ -z "${CUDA_ARCH_BIN}" ]] ; then
einfo
einfo "The target CUDA architecture can be set via one of:"
einfo
einfo "  - CUDA_GENERATION set to one of Maxwell, Pascal, Volta, Turing,"
einfo "    Ampere, Lovelace, Hopper, Auto."
einfo "  - CUDA_ARCH_BIN, (and optionally CUDA_ARCH_PTX) in the form of x.y tuples."
einfo "    You can specify multiple tuple separated by \";\"."
einfo
einfo "The CUDA architecture tuple for your device can be found at"
einfo "https://developer.nvidia.com/cuda-gpus."
einfo
	fi

	if \
		use cuda \
		&& [[ "${MERGE_TYPE}" == "buildonly" ]] \
		&& [[ -n "${CUDA_GENERATION}" \
		|| -n "${CUDA_ARCH_BIN}" ]] \
	; then
einfo
einfo "When building a binary package it's recommended to unset CUDA_GENERATION"
einfo "and CUDA_ARCH_BIN so all available architectures are build."
einfo
	fi

	[[ "${MERGE_TYPE}" != "binary" ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ "${MERGE_TYPE}" != "binary" ]] && use openmp && tc-check-openmp
	use java && java-pkg-opt-2_pkg_setup
	python_setup
}

src_prepare() {
	local file
	if use cuda ; then
		export CUDA_VERBOSE=$(usex debug "true" "false")
		cuda_src_prepare
	fi

	cmake_src_prepare

	if use contribdnn && use system-flatbuffers ; then
		eapply "${FILESDIR}/${PN}-4.8.1-use-system-flatbuffers.patch"
	fi

	# Remove bundled stuff
	mkdir -p "3rdparty.orig" || die
	mv "3rdparty/flatbuffers" "3rdparty.orig" || die
	if use carotene ; then
		mv "3rdparty/carotene" "3rdparty.orig" || die
	fi
	rm -r "3rdparty" || die "Removing 3rd party components failed"
	if use system-flatbuffers ; then
		rm -rf "3rdparty.orig" || die
	else
		mv "3rdparty.orig" "3rdparty" || die
	fi
	sed \
		-i \
		-e '/add_subdirectory(.*3rdparty.*)/ d' \
		"CMakeLists.txt" \
		"cmake/"*"cmake" \
		|| die

	if use contrib ; then
		cd "${WORKDIR}/${PN}_contrib-${PV}" || die
		eapply "${FILESDIR}/${PN}_contrib-${PV}-rgbd.patch"
		eapply "${FILESDIR}/${PN}_contrib-4.8.1-NVIDIAOpticalFlowSDK-2.0.tar.gz.patch"
		cd "${S}" || die

		! use contribcvv && { rm -R "${WORKDIR}/${PN}_contrib-${PV}/modules/cvv" || die; }
		# ! use contribdnn && { rm -R "${WORKDIR}/${PN}_contrib-${PV}/modules/dnn" || die; }
		! use contribfreetype && { rm -R "${WORKDIR}/${PN}_contrib-${PV}/modules/freetype" || die; }
		! use contribhdf && { rm -R "${WORKDIR}/${PN}_contrib-${PV}/modules/hdf" || die; }
		! use contribovis && { rm -R "${WORKDIR}/${PN}_contrib-${PV}/modules/ovis" || die; }
		! use contribsfm && { rm -R "${WORKDIR}/${PN}_contrib-${PV}/modules/sfm" || die; }
		! use contribxfeatures2d && { rm -R "${WORKDIR}/${PN}_contrib-${PV}/modules/xfeatures2d" || die; }
	fi

	mkdir -p "${S}/.cache/ade" || die
	local s2=$(md5sum "${DISTDIR}/ade-${ADE_PV}.tar.gz" \
		| cut -f 1 -d " ")
	cp \
		"${DISTDIR}/ade-${ADE_PV}.tar.gz" \
		"${S}/.cache/ade/${s2}-v${ADE_PV}.tar.gz" \
		|| die

	if use dnnsamples ; then
		mkdir -p "${S}/.cache/wechat_qrcode" || die
		for file in "detect.caffemodel" "detect.prototxt" "sr.prototxt" "sr.caffemodel" ; do
			local s2=$(md5sum "${WORKDIR}/${PN}_3rdparty-${QRCODE_COMMIT}/${file}" \
				| cut -f 1 -d " ")
			mv \
				"${WORKDIR}/${PN}_3rdparty-${QRCODE_COMMIT}/${file}" \
				"${S}/.cache/wechat_qrcode/${s2}-${file}" \
				|| die
		done

		mv \
			"${WORKDIR}/${PN}_3rdparty-${DNN_SAMPLES_FACE_DETECTOR_COMMIT}/res10_300x300_ssd_iter_140000.caffemodel" \
			"${S}/samples/dnn/" \
			|| die
	fi

	if use contribxfeatures2d ; then
		cp \
			"${WORKDIR}/${PN}_3rdparty-${XFEATURES2D_BOOSTDESC_COMMIT}/"*".i" \
			"${WORKDIR}/${PN}_contrib-${PV}/modules/xfeatures2d/src/" \
			|| die
		mkdir -p "${S}/.cache/xfeatures2d/boostdesc" || die
		for file in "${WORKDIR}/${PN}_3rdparty-${XFEATURES2D_BOOSTDESC_COMMIT}/"*".i" ; do
			local s1=$(basename "${file}")
			local s2=$(md5sum "${WORKDIR}/${PN}_3rdparty-${XFEATURES2D_BOOSTDESC_COMMIT}/${s1}" \
				| cut -f 1 -d " ")
			mv \
				"${WORKDIR}/${PN}_3rdparty-${XFEATURES2D_BOOSTDESC_COMMIT}/${s1}" \
				"${S}/.cache/xfeatures2d/boostdesc/${s2}-${s1}" \
				|| die
		done

		cp \
			"${WORKDIR}/${PN}_3rdparty-${XFEATURES2D_VGG_COMMIT}/"*".i" \
			"${WORKDIR}/${PN}_contrib-${PV}/modules/xfeatures2d/src/" \
			|| die
		mkdir -p "${S}/.cache/xfeatures2d/vgg" || die
		for file in "${WORKDIR}/${PN}_3rdparty-${XFEATURES2D_VGG_COMMIT}/"*".i" ; do
			local s1=$(basename "${file}")
			local s2=$(md5sum "${WORKDIR}/${PN}_3rdparty-${XFEATURES2D_VGG_COMMIT}/${s1}" \
				| cut -f 1 -d " ")
			mv \
				"${WORKDIR}/${PN}_3rdparty-${XFEATURES2D_VGG_COMMIT}/${s1}" \
				"${S}/.cache/xfeatures2d/vgg/${s2}-${s1}" || die
		done
	fi

	if use contribdnn ; then
		mkdir -p "${S}/.cache/data" || die
		file="face_landmark_model.dat"
		local s2=$(md5sum "${WORKDIR}/${PN}_3rdparty-${FACE_ALIGNMENT_COMMIT}/${file}" \
			| cut -f 1 -d " ")
		mv \
			"${WORKDIR}/${PN}_3rdparty-${FACE_ALIGNMENT_COMMIT}/${file}" \
			"${S}/.cache/data/${s2}-${file}" \
			|| die
	fi

	if use cuda ; then
		mkdir -p "${S}/.cache/nvidia_optical_flow"
		local s2=$(md5sum "${DISTDIR}/NVIDIAOpticalFlowSDK-${NVIDIA_OPTICAL_FLOW_COMMIT}.tar.gz" \
			| cut -f 1 -d " ")
		cp \
			"${DISTDIR}/NVIDIAOpticalFlowSDK-${NVIDIA_OPTICAL_FLOW_COMMIT}.tar.gz" \
			"${S}/.cache/nvidia_optical_flow/${s2}-${NVIDIA_OPTICAL_FLOW_COMMIT}.tar.gz" \
			|| die
	fi

	if use java ; then
		java-pkg-opt-2_src_prepare

		# this really belongs in src_prepare() too
		JAVA_ANT_ENCODING="iso-8859-1"
		# set encoding so even this cmake build will pick it up.
		export ANT_OPTS+=" -Dfile.encoding=iso-8859-1"
	fi
}

multilib_src_configure() {
	# bug #919101 and https://github.com/opencv/opencv/issues/19020
	filter-lto

	cflags-hardened_append

	# bug 734284
	# Jasper was removed from tree because of security problems.  Upstream
	# were/are making progress. We use openjpeg instead.

	export LIBDIR=$(get_libdir)
	local mycmakeargs=(
		-DBUILD_ANDROID_EXAMPLES=OFF
		#-DBUILD_ANDROID_SERVICE=OFF
		-DBUILD_CUDA_STUBS=$(multilib_native_usex cuda)
		-DBUILD_DOCS=OFF					# It doesn't install anyways.
		-DBUILD_EXAMPLES=$(multilib_native_usex examples)
		-DBUILD_FAT_JAVA_LIB=OFF
		-DBUILD_JAVA=$(multilib_native_usex java)		# Ant needed, no compile flag
		-DBUILD_opencv_apps=$(usex opencvapps ON OFF)
		-DBUILD_opencv_features2d=$(usex features2d ON OFF)
		-DBUILD_opencv_flann=$(usex flann)
		-DBUILD_opencv_gapi=$(usex ffmpeg ON $(usex gstreamer))
		-DBUILD_opencv_imgproc=$(usex imgproc)
		-DBUILD_PACKAGE=OFF
		-DBUILD_PERF_TESTS=OFF
		-DBUILD_PROTOBUF=OFF
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_TESTS=$(multilib_native_usex testprograms)
		-DBUILD_WITH_DEBUG_INFO=$(usex debug)
		-DBUILD_WITH_DYNAMIC_IPP=OFF
		#-DBUILD_WITH_STATIC_CRT=OFF
		-DCMAKE_CXX_STANDARD=14					# For protobuf
		-DCMAKE_POLICY_DEFAULT_CMP0146="OLD"			# FindCUDA
		-DCMAKE_POLICY_DEFAULT_CMP0148="OLD"			# FindPythonInterp
		-DCMAKE_SKIP_RPATH=ON
		-DCUDA_NPP_LIBRARY_ROOT_DIR=$(usex cuda "${EPREFIX}/opt/cuda" "")
		-DDOWNLOAD_EXTERNAL_TEST_DATA=OFF
		-DENABLE_CCACHE=OFF
		-DENABLE_COVERAGE=OFF
		-DENABLE_DOWNLOAD=yes
		-DENABLE_IMPL_COLLECTION=OFF
		-DENABLE_INSTRUMENTATION=OFF
		-DENABLE_NOISY_WARNINGS=OFF
	# bug 733796, but PCH is a risky game in CMake anyway \
		-DENABLE_PRECOMPILED_HEADERS=OFF
		-DENABLE_PROFILING=OFF
		-DENABLE_SOLUTION_FOLDERS=OFF
		-DGENERATE_ABI_DESCRIPTOR=OFF
		-DHAVE_opencv_java=$(multilib_native_usex java ON OFF)
		#-DINSTALL_ANDROID_EXAMPLES=OFF
		-DINSTALL_CREATE_DISTRIB=OFF
		-DINSTALL_PYTHON_EXAMPLES=$(multilib_native_usex examples)
		-DINSTALL_TESTS=$(multilib_native_usex testprograms)
		-DINSTALL_TO_MANGLED_PATHS=OFF
		-DINSTALL_C_EXAMPLES=$(multilib_native_usex examples)
	# opencv uses both ${CMAKE_INSTALL_LIBDIR} and ${LIB_SUFFIX} to set its \
	# destination libdir							\
		-DLIB_SUFFIX=
		-DMIN_VER_CMAKE="${CMAKE_PV}"
		-DOPENCV_DOC_INSTALL_PATH=
		-DOPENCV_ENABLE_MEMORY_SANITIZER=$(usex debug)
		-DOPENCV_ENABLE_NONFREE=$(usex non-free)
		-DOPENCV_EXTRA_MODULES_PATH=$(usex contrib "${WORKDIR}/${PN}_contrib-${PV}/modules" "")
		-DOPENCV_GENERATE_PKGCONFIG=ON
		-DOPENCV_WARNINGS_ARE_ERRORS=OFF
		-DOpenGL_GL_PREFERENCE="GLVND"
		-DProtobuf_MODULE_COMPATIBLE=ON
		-DPROTOBUF_UPDATE_FILES=ON
		-DWITH_1394=$(usex ieee1394)
		-DWITH_ARAVIS=OFF
		#-DWITH_AVFOUNDATION=OFF				# IOS
		-DWITH_AVIF=$(usex avif)
		-DWITH_CLP=OFF
		-DWITH_CSTRIPES=OFF
		-DWITH_CUBLAS=$(multilib_native_usex cuda)
		-DWITH_CUDA=$(multilib_native_usex cuda)
		-DWITH_CUDNN=$(multilib_native_usex cudnn)
		-DWITH_CUFFT=$(multilib_native_usex cuda)
		-DWITH_DIRECTX=OFF
		#-DWITH_DSHOW=ON					# Directshow supp
		-DWITH_EIGEN=$(usex eigen)
		-DWITH_FFMPEG=$(usex ffmpeg)
		-DWITH_FLATBUFFERS=$(multilib_native_usex contribdnn)
		-DWITH_GDAL=$(multilib_native_usex gdal)
		-DWITH_GDCM=OFF
		-DWITH_GIGEAPI=OFF
		-DWITH_GPHOTO2=$(usex gphoto2)
		-DWITH_GTK=$(usex gtk3)
		-DWITH_GTK_2_X=OFF					# We only want GTK3 nowadays
		-DWITH_GSTREAMER=$(usex gstreamer)
		-DWITH_GSTREAMER_0_10=OFF				# We don't want this
		-DWITH_IMGCODEC_HDR=$(usex hdr)
		-DWITH_IMGCODEC_PFM=$(usex netpbm)
		-DWITH_IMGCODEC_PXM=$(usex netpbm)
		-DWITH_IMGCODEC_SUNRASTER=$(usex sun)
		-DWITH_INTELPERC=OFF
		-DWITH_IPP=OFF
		-DWITH_IPP_A=OFF
		-DWITH_ITT=OFF						# 3dparty libs itt_notify
		-DWITH_JASPER=OFF					# bug 734284
		-DWITH_JPEG=$(usex jpeg)
		-DWITH_LAPACK=$(multilib_native_usex lapack)
		-DWITH_LIBV4L=$(usex v4l)
		-DWITH_MATLAB=OFF
		-DWITH_MSMF=OFF
		-DWITH_NVCUVID=OFF
		-DWITH_OPENCL=$(usex opencl)
		-DWITH_OPENCL_SVM=OFF
		-DWITH_OPENCLAMDBLAS=$(usex opencl)
		-DWITH_OPENCLAMDFFT=$(usex opencl)
		-DWITH_OPENEXR=$(multilib_native_usex openexr)
		-DWITH_OPENGL=$(usex opengl)
		-DWITH_OPENJPEG=$(usex jpeg2k)
		-DWITH_OPENMP=$(usex !tbb $(usex openmp))
		-DWITH_OPENNI=OFF					# Not packaged
		-DWITH_OPENNI2=OFF					# Not packaged
		-DWITH_OPENVINO=$(usex openvino)
		-DWITH_PNG=$(usex png)
		-DWITH_PROTOBUF=ON
		-DWITH_PTHREADS_PF=ON
		-DWITH_PVAPI=OFF
		#-DWITH_QUICKTIME=OFF
		-DWITH_QUIRC=$(usex quirc)
		#-DWITH_QTKIT=OFF
		-DWITH_SPNG=$(usex spng)
		-DWITH_TBB=$(usex tbb)
		-DWITH_TIFF=$(usex tiff)
		-DWITH_UNICAP=OFF					# Not packaged
		-DWITH_V4L=$(usex v4l)
		-DWITH_VA=$(usex vaapi)
		-DWITH_VA_INTEL=$(usex vaapi $(usex video_cards_intel))	# Default ON upstream
		-DWITH_VFW=OFF						# Video windows support
		-DWITH_VTK=$(multilib_native_usex vtk)
		-DWITH_VULKAN=$(usex vulkan)
		-DWITH_WAYLAND=$(usex wayland)
		-DWITH_WEBP=$(usex webp)
		-DWITH_WIN32UI=OFF					# Windows only
		-DWITH_XIMEA=OFF					# Windows only
		-DWITH_XINE=$(multilib_native_usex xine)
	)

	if [[ "${ARCH}" == "arm" || "${ARCH}" == "arm64" ]] ; then
		mycmakeargs+=(
			-DWITH_CAROTENE=$(usex carotene)
		)
	else
		mycmakeargs+=(
			-DWITH_CAROTENE=OFF
		)
	fi

	if use halide ; then
		mycmakeargs+=(
			-DHALIDE_ROOT_DIR="/usr"
		)
	fi

	local openvino_arch=""
	if use openvino && [[ "${ARCH}" == "x86" ]] ; then
		openvino_arch="ia32"
	elif use openvino && [[ "${ARCH}" == "arm" ]] ; then
		openvino_arch="arm"
	elif use openvino && [[ "${ARCH}" == "arm64" ]] ; then
		openvino_arch="arm64"
	elif use openvino && [[ "${ARCH}" == "amd64" ]] ; then
		openvino_arch="intel64"
	elif use openvino ; then
eerror "OpenVINO is not supported for ${ARCH}"
		die
	fi

	if [[ -n "${openvino_arch}" ]] ; then
		mycmakeargs+=(
			-DInferenceEngine_DIR="/usr/$(get_libdir)/openvino/deployment_tools/inference_engine/share"
			-Dngraph_DIR="/usr/$(get_libdir)/openvino/deployment_tools/ngraph/cmake"
		)
	fi

	if use openvx && use rocm_5_7 ; then
		export ROCM_PATH="/opt/rocm-${HIP_5_7_VERSION}"
		mycmakeargs+=(
			-DOPENVX_ROOT="/opt/rocm-${HIP_5_7_VERSION}"
			-DWITH_OPENVX=ON
		)
	elif use openvx && use rocm_5_6 ; then
		export ROCM_PATH="/opt/rocm-${HIP_5_6_VERSION}"
		mycmakeargs+=(
			-DOPENVX_ROOT="/opt/rocm-${HIP_5_6_VERSION}"
			-DWITH_OPENVX=ON
		)
	elif use openvx && use rocm_5_5 ; then
		export ROCM_PATH="/opt/rocm-${HIP_5_5_VERSION}"
		mycmakeargs+=(
			-DOPENVX_ROOT="/opt/rocm-${HIP_5_5_VERSION}"
			-DWITH_OPENVX=ON
		)
	elif use openvx && use rocm_5_4 ; then
		export ROCM_PATH="/opt/rocm-${HIP_5_4_VERSION}"
		mycmakeargs+=(
			-DOPENVX_ROOT="/opt/rocm-${HIP_5_4_VERSION}"
			-DWITH_OPENVX=ON
		)
	elif use openvx && use rocm_5_3 ; then
		export ROCM_PATH="/opt/rocm-${HIP_5_3_VERSION}"
		mycmakeargs+=(
			-DOPENVX_ROOT="/opt/rocm-${HIP_5_3_VERSION}"
			-DWITH_OPENVX=ON
		)
	elif use openvx && use rocm_5_2 ; then
		export ROCM_PATH="/opt/rocm-${HIP_5_2_VERSION}"
		mycmakeargs+=(
			-DOPENVX_ROOT="/opt/rocm-${HIP_5_2_VERSION}"
			-DWITH_OPENVX=ON
		)
	elif use openvx && use rocm_5_1 ; then
		export ROCM_PATH="/opt/rocm-${HIP_5_1_VERSION}"
		mycmakeargs+=(
			-DOPENVX_ROOT="/opt/rocm-${HIP_5_1_VERSION}"
			-DWITH_OPENVX=ON
		)
	else
		export ROCM_PATH=""
		mycmakeargs+=(
			-DWITH_OPENVX=OFF
		)
	fi

	if use qt5 ; then
		mycmakeargs+=(
			-DCMAKE_DISABLE_FIND_PACKAGE_Qt6=ON
			-DWITH_QT=$(multilib_native_usex qt5 ON OFF)
		)
	elif use qt6 ; then
		mycmakeargs+=(
			-DCMAKE_DISABLE_FIND_PACKAGE_Qt5=ON
			-DWITH_QT=$(multilib_native_usex qt6 ON OFF)
		)
	else
		mycmakeargs+=(
			-DCMAKE_DISABLE_FIND_PACKAGE_Qt5=ON
			-DCMAKE_DISABLE_FIND_PACKAGE_Qt6=ON
			-DWITH_QT=OFF
		)
	fi

	# CPU flags should solve bug #633900
	local CPU_BASELINE=""
	local i
	for i in ${CPU_FEATURES_MAP[@]} ; do
		local use_flag="${i%:*}"
		local baseline_flag="${i#*:}"
		if [[ "${ABI}" == "arm" ]] ; then
			if [[ "${baseline_flag}" == "FP16" || "${baseline_flag}" == "NEON" || "${baseline_flag}" == "VFPV3" ]] ; then
				use "${use_flag}" && CPU_BASELINE="${CPU_BASELINE}${baseline_flag};"
			fi
		elif [[ "${ABI}" == "arm64" ]] ; then
			if [[ "${baseline_flag}" =~ ("NEON_DOTPROD") ]] ; then
				use "${use_flag}" && CPU_BASELINE="${CPU_BASELINE}${baseline_flag};"
			fi
		elif [[ "${ABI}" != "x86" || "${use_flag}" != "cpu_flags_x86_avx2" ]] ; then # Workaround for Bug 747163
			use "${use_flag}" && CPU_BASELINE="${CPU_BASELINE}${baseline_flag};"
		fi
	done

	mycmakeargs+=(
		-DCPU_BASELINE="${CPU_BASELINE}"
		-DCPU_DISPATCH=
		-DOPENCV_CPU_OPT_IMPLIES_IGNORE=ON
	)

	if use contrib ; then
		mycmakeargs+=(
			-DBUILD_opencv_dnn=$(multilib_native_usex contribdnn ON OFF)
			-DBUILD_opencv_cvv=$(usex contribcvv ON OFF)
			-DBUILD_opencv_freetype=$(usex contribfreetype ON OFF)
			-DBUILD_opencv_hdf=$(multilib_native_usex contribhdf ON OFF)
			-DBUILD_opencv_ovis=$(usex contribovis ON OFF)
			-DBUILD_opencv_sfm=$(usex contribsfm ON OFF)
			-DBUILD_opencv_xfeatures2d=$(usex contribxfeatures2d ON OFF)
		)

		if multilib_is_native_abi ; then
			mycmakeargs+=(
				-DCMAKE_DISABLE_FIND_PACKAGE_Tesseract=$(usex !tesseract)
			)
		else
			mycmakeargs+=(
				-DCMAKE_DISABLE_FIND_PACKAGE_Tesseract=ON
			)
		fi
	fi

	# Workaround for bug 413429
	tc-export CC CXX

	if use mkl ; then
		mycmakeargs+=(
			-DLAPACK_IMPL="MKL"
			-DMKL_WITH_OPENMP=$(usex !tbb $(usex openmp))
			-DMKL_WITH_TBB=$(usex tbb)
		)
	fi

	if multilib_is_native_abi && use cuda ; then
		cuda_add_sandbox -w
		sandbox_write "/proc/self/task"

		if [[ -n "${CUDA_GENERATION}" ]] ; then
			mycmakeargs+=(
				-DCUDA_GENERATION="${CUDA_GENERATION}"
			)
		fi

		if [[ -n "${CUDA_ARCH_BIN}" ]] ; then
				mycmakeargs+=(
					-DCUDA_ARCH_BIN="${CUDA_ARCH_BIN}"
				)

			if [[ -n "${CUDA_ARCH_PTX}" ]] ; then
				mycmakeargs+=(
					-DCUDA_ARCH_PTX="${CUDA_ARCH_PTX}"
				)
			fi
		fi

		local NVCCFLAGS_OpenCV="${NVCCFLAGS// /\;}"
		mycmakeargs+=(
			-DCUDA_NVCC_FLAGS="-forward-unknown-opts;${NVCCFLAGS_OpenCV//\"/}"
			-DOPENCV_CUDA_DETECTION_NVCC_FLAGS="-ccbin=$(cuda_gccdir)"
		)

		use vtk && mycmakeargs+=(
			-DCMAKE_CUDA_FLAGS="-forward-unknown-opts ${NVCCFLAGS//\;/ }"
		)
	fi

	# CI tested versions
	if use ffmpeg && has_version "media-video/ffmpeg:58.60.60" ; then # 6.1.x
		export PKG_CONFIG_PATH="/usr/lib/ffmpeg/58.60.60/$(get_libdir)/pkgconfig:${PKG_CONFIG_PATH}"
	elif use ffmpeg && has_version "media-video/ffmpeg:56.58.58" ; then # 4.x
		export PKG_CONFIG_PATH="/usr/lib/ffmpeg/56.58.58/$(get_libdir)/pkgconfig:${PKG_CONFIG_PATH}"
	fi

	if use vulkan ; then
		export VULKAN_SDK="/usr"
	fi

	if multilib_is_native_abi && use python ; then
		python_configure() {
	# Set all python variables to load the correct distro paths.
			local mycmakeargs=(
				"${mycmakeargs[@]}"
				-DINSTALL_PYTHON_EXAMPLES=$(usex examples)
	# python_setup alters PATH and sets this as wrapper to the correct	\
	# interpreter we are building for					\
				-DPYTHON_DEFAULT_EXECUTABLE="${EPYTHON}"
			)
			cmake_src_configure
		}

		python_configure
	else
		mycmakeargs+=(
			-DBUILD_opencv_python2=OFF
			-DBUILD_opencv_python3=OFF
			-DINSTALL_PYTHON_EXAMPLES=OFF
			-DPYTHON_EXECUTABLE=OFF
		)
		cmake_src_configure
	fi

}

multilib_src_compile() {
	cmake_src_compile
}

# Fix loader for cx-Freeze
# Fixes:
# ImportError: ERROR: recursion is detected during loading of "cv2" binary extensions. Check OpenCV installation.
fix_python_loader() {
	# Use abspath instead of relpath
	local ver="${EPYTHON/python}"
	local libdir=$(get_libdir)
cat <<EOF > "${ED}/usr/lib/${EPYTHON}/site-packages/cv2/config-${ver}.py"
PYTHON_EXTENSIONS_PATHS = [
    "/usr/lib/${EPYTHON}/site-packages/cv2/python-${ver}"
] + PYTHON_EXTENSIONS_PATHS
EOF
cat <<EOF > "${ED}/usr/lib/${EPYTHON}/site-packages/cv2/config.py"
import os

BINARIES_PATHS = [
     "/usr/${libdir}"
] + BINARIES_PATHS
EOF
}

multilib_src_install() {
	if use abi_x86_64 && use abi_x86_32 ; then
		MULTILIB_WRAPPED_HEADERS=(
			${_MULTILIB_WRAPPED_HEADERS[@]}
		)
	fi
	if multilib_is_native_abi && use python ; then
		cmake_src_install
		python_optimize
		fix_python_loader
	else
		cmake_src_install
	fi

	# Fix TBB linking
	if use tbb ; then
		local LIBPATHS=(
			$(find "${ED}/usr/$(get_libdir)" -name "*.so*")
		)
		local path
		for path in ${LIBPATHS[@]} ; do
			[[ -L "${path}" ]] && continue
			if ldd "${path}" | grep -F -q "libtbb.so.2" ; then
				if [[ -e "/usr/$(get_libdir)/tbb/2/libtbb.so.2" ]] ; then
	# TBB legacy (oiledmachine-overlay ebuild fork)
einfo "Fixing rpath for ${path}"
					patchelf --add-rpath "/usr/$(get_libdir)/tbb/2" "${path}" || die
				fi
			elif ldd "${path}" | grep -F -q "libtbb.so.12" ; then
	# oneTBB
				:
			fi
		done
	fi

	if use ffmpeg ; then
		local x
		for x in $(ls "${ED}/usr/$(get_libdir)/libopencv"*".so") ; do
			local path=$(ldd "${x}" | grep -q "libav" && echo "${x}")
			if [[ -z "${path}" ]] ; then
				:
			elif has_version "media-video/ffmpeg:58.60.60" ; then # 6.1.x
einfo "Fixing rpath for ${x}"
				patchelf --add-rpath "/usr/lib/ffmpeg/58.60.60/$(get_libdir)" "${x}" || die
			elif has_version "media-video/ffmpeg:56.58.58" ; then # 4.x
einfo "Fixing rpath for ${x}"
				patchelf --add-rpath "/usr/lib/ffmpeg/56.58.58/$(get_libdir)" "${x}" || die
			fi
		done
	fi
}

pkg_postinst() {
ewarn
ewarn "The selected BLAS or LAPACK should match the vendor."
ewarn
ewarn "sci-libs/atlas - For non-Intel CPUs (BLAS)"
ewarn "sci-libs/blis - For non-Intel CPUs (BLAS)"
ewarn "sci-libs/mkl - For Intel® CPUs/GPUs (BLAS, LAPACK)"
ewarn "sci-libs/openblas - For non-Intel CPUs (BLAS, LAPACK)"
ewarn
	if use lapack ; then
		if cat "/proc/cpuinfo" | grep -q "GenuineIntel" ; then
			if ! eselect lapack show | grep -q "mkl" ; then
ewarn "Run \`eselect lapack set mkl\` to optimize for Intel® CPUs/GPUs."
			fi
		elif cat "/proc/cpuinfo" | grep -q "AuthenticAMD" ; then
			if ! eselect lapack show | grep -q "openblas" ; then
ewarn "Run \`eselect lapack set openblas\` to optimize for AMD CPUs."
			fi
		else
			if ! eselect lapack show | grep -q "openblas" ; then
ewarn "Run \`eselect lapack set openblas\` to optimize for ${ARCH}."
			fi
		fi

		if cat "/proc/cpuinfo" | grep -q "GenuineIntel" ; then
			if ! eselect blas show | grep -q "mkl" ; then
ewarn "Run \`eselect blas set mkl\` to optimize for Intel® CPUs/GPUs."
			fi
		elif cat "/proc/cpuinfo" | grep -q "AuthenticAMD" ; then
			if has_version "sci-libs/atlas" && ! eselect blas show | grep -q "atlas" ; then
ewarn "Run \`eselect blas set atlas\` to optimize for ${ARCH}."
			fi
			if has_version "sci-libs/blis" && ! eselect blas show | grep -q "blis" ; then
ewarn "Run \`eselect blas set blis\` to optimize for AMD CPUs."
			fi
			if has_version "sci-libs/openblas" && ! eselect blas show | grep -q "openblas" ; then
ewarn "Run \`eselect blas set openblas\` to optimize for AMD CPUs."
			fi
		else
			if has_version "sci-libs/atlas" && ! eselect blas show | grep -q "atlas" ; then
ewarn "Run \`eselect blas set atlas\` to optimize for ${ARCH}."
			fi
			if has_version "sci-libs/blis" && ! eselect blas show | grep -q "blis" ; then
ewarn "Run \`eselect blas set blis\` to optimize for ${ARCH}."
			fi
			if has_version "sci-libs/openblas" && ! eselect blas show | grep -q "openblas" ; then
ewarn "Run \`eselect blas set openblas\` to optimize for ${ARCH}"
			fi
		fi
	fi
}
