# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U20, U22

# TODO package:
# openvino

_MULTILIB_WRAPPED_HEADERS=( # {{{
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
) # }}}
CMAKE_PV="3.26"
# TODO make this only relevant for binhost \
CPU_FEATURES_MAP=(
	"cpu_flags_arm_fp16:FP16"				# arm only
	"cpu_flags_arm_neon:NEON"				# arm only
	"cpu_flags_arm_neon_bf16:NEON_BF16"			# arm64 only
	"cpu_flags_arm_neon_fp16:NEON_FP16"			# arm64 only
	"cpu_flags_arm_neon_dotprod:NEON_DOTPROD"		# arm64 only
	"cpu_flags_arm_vfpv3:VFPV3"				# arm only
	"cpu_flags_loong_lsx:LSX"
	"cpu_flags_loong_lasx:LASX"
	"cpu_flags_mips_msa:MSA"
	"cpu_flags_ppc_vsx:VSX"					# Always available on Power8
	"cpu_flags_ppc_vsx3:VSX3"				# Always available on Power9
	"cpu_flags_riscv_rvv:RVV"
	"cpu_flags_x86_avx:AVX"
	"cpu_flags_x86_avx2:AVX2"
	"cpu_flags_x86_avx512bw:AVX_512BW"
	"cpu_flags_x86_avx512cd:AVX_512CD"
	"cpu_flags_x86_avx512dq:AVX_512DQ"
	"cpu_flags_x86_avx512er:AVX512_KNL_EXTRA"
	"cpu_flags_x86_avx512f:AVX_512F"
	"cpu_flags_x86_avx512ifma:AVX_512IFMA"
	"cpu_flags_x86_avx512pf:AVX512_KNL_EXTRA"
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
GSTREAMER_PV="1.16.2"
PYTHON_COMPAT=( "python3_"{10..12} )
OPENEXR2_PV="2.5.10 2.5.9 2.5.8 2.5.7 2.4.3 2.4.2 2.4.1 2.4.0 2.3.0"
OPENEXR3_PV="3.1.12 3.1.11 3.1.10 3.1.9 3.1.8 3.1.7 3.1.6 3.1.5 3.1.4 3.1.3 3.0.5 3.0.4 3.0.3 3.0.2 3.0.1"
QT5_PV="5.12.8"
QT6_PV="6.2.4"

inherit cuda java-pkg-opt-2 java-ant-2 cmake-multilib flag-o-matic python-r1
inherit toolchain-funcs virtualx

if [[ ${PV} = *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	# From ocv_download()
	ADE_PV="0.1.2d"									# See https://github.com/opencv/opencv/blob/4.9.0/modules/gapi/cmake/DownloadADE.cmake#L2
	DNN_SAMPLES_FACE_DETECTOR_COMMIT="b2bfc75f6aea5b1f834ff0f0b865a7c18ff1459f"	# See https://github.com/opencv/opencv_extra/blob/4.9.0/testdata/dnn/download_models.py#L384
	FACE_ALIGNMENT_COMMIT="8afa57abc8229d611c4937165d20e2a2d9fc5a12"		# See https://github.com/opencv/opencv_contrib/blob/4.9.0/modules/face/CMakeLists.txt
	NVIDIA_OPTICAL_FLOW_COMMIT="edb50da3cf849840d680249aa6dbef248ebce2ca"		# See https://github.com/opencv/opencv_contrib/blob/4.9.0/modules/cudaoptflow/CMakeLists.txt#L12
	QRCODE_COMMIT="a8b69ccc738421293254aec5ddb38bd523503252"			# See https://github.com/opencv/opencv_contrib/blob/4.9.0/modules/wechat_qrcode/CMakeLists.txt#L15
	XFEATURES2D_BOOSTDESC_COMMIT="34e4206aef44d50e6bbcd0ab06354b52e7466d26"		# See https://github.com/opencv/opencv_contrib/blob/4.9.0/modules/xfeatures2d/cmake/download_boostdesc.cmake#L2
	XFEATURES2D_VGG_COMMIT="fccf7cd6a4b12079f73bbfb21745f9babcd4eb1d"		# See https://github.com/opencv/opencv_contrib/blob/4.9.0/modules/xfeatures2d/cmake/download_vgg.cmake#L2

	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
	SRC_URI="
		https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/opencv/ade/archive/v${ADE_PV}.tar.gz -> ade-${ADE_PV}.tar.gz
		contrib? (
			https://github.com/${PN}/${PN}_contrib/archive/${PV}.tar.gz -> ${PN}_contrib-${PV}.tar.gz
			contribxfeatures2d? (
				https://github.com/${PN}/${PN}_3rdparty/archive/${XFEATURES2D_BOOSTDESC_COMMIT}.tar.gz
					-> ${PN}_3rdparty-${XFEATURES2D_BOOSTDESC_COMMIT}.tar.gz
				https://github.com/${PN}/${PN}_3rdparty/archive/${XFEATURES2D_VGG_COMMIT}.tar.gz
					-> ${PN}_3rdparty-${XFEATURES2D_VGG_COMMIT}.tar.gz
			)
			contribdnn? (
				https://github.com/${PN}/${PN}_3rdparty/archive/${FACE_ALIGNMENT_COMMIT}.tar.gz
					-> ${PN}_3rdparty-${FACE_ALIGNMENT_COMMIT}.tar.gz
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
		test? (
			https://github.com/${PN}/${PN}_extra/archive/refs/tags/${PV}.tar.gz -> ${PN}_extra-${PV}.tar.gz
		)
	"
fi

DESCRIPTION="A collection of algorithms and sample code for various computer vision problems"
HOMEPAGE="https://opencv.org"
LICENSE="Apache-2.0"
RESTRICT="
	!test? (
		test
	)
"
SLOT="0/${PV}" # subslot = libopencv* soname version
# general options
IUSE="
	debug doc +eigen gflags glog java non-free opencvapps +python test
	testprograms
	ebuild-revision-3
"
# hal for acceleration
IUSE+="
	carotene openvx
"
# modules
IUSE+="
	contrib contribcvv contribdnn contribfreetype contribhdf contribovis
	contribsfm contribxfeatures2d dnnsamples examples +features2d
"
# hardware
IUSE+="
	opencl cuda cudnn video_cards_intel
"
# video
IUSE+="
	+ffmpeg gstreamer xine vaapi v4l gphoto2 ieee1394 libaom openh264 vpx
"
# image
IUSE+="
	avif gdal jasper jpeg jpeg2k openexr png quirc spng tesseract tiff webp
"
# gui
IUSE+="
	gtk3 qt5 qt6 opengl vtk wayland
"
# parallel
IUSE+="
	openmp tbb
"
# lapack options
IUSE+="
	atlas lapack mkl
"
IUSE+="
	${CPU_FEATURES_MAP[*]%:*}
"
unset ARM_CPU_FEATURES PPC_CPU_FEATURES X86_CPU_FEATURES_RAW X86_CPU_FEATURES

REQUIRED_USE="
	?? (
		carotene
		openvx
	)
	?? (
		gtk3
		|| (
			qt5
			qt6
		)
	)
	amd64? (
		cpu_flags_x86_sse
		cpu_flags_x86_sse2
	)
	cpu_flags_x86_avx2? (
		cpu_flags_x86_f16c
	)
	cpu_flags_x86_avx512er? (
		cpu_flags_x86_avx512pf
	)
	cpu_flags_x86_avx512pf? (
		cpu_flags_x86_avx512er
	)
	cpu_flags_x86_avx512_4fmaps? (
		cpu_flags_x86_avx512_4vnniw
	)
	cpu_flags_x86_avx512_4vnniw? (
		cpu_flags_x86_avx512_4fmaps
	)
	cpu_flags_x86_f16c? (
		cpu_flags_x86_avx
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
	java? (
		python
	)
	opengl? (
		?? (
			gtk3
			|| (
				qt5
				qt6
			)
		)
	)
	python? (
		${PYTHON_REQUIRED_USE}
	)
	tesseract? (
		contrib
	)
	test? (
		features2d
		jpeg
		png
		tiff
		|| (
			ffmpeg
			gstreamer
		)
	)
"
# TODO find a way to compile these with the cuda compiler
REQUIRED_USE+="
	cuda? (
		!gdal
		!openexr
		!tbb
	)
"
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
CUDA_DEPEND="
		|| (
			=dev-util/nvidia-cuda-toolkit-11.8*
		)
		dev-util/nvidia-cuda-toolkit:=
"
# For ffmpeg version, see \
# https://github.com/opencv/opencv_3rdparty/blob/fbac408a47977ee4265f39e7659d33f1dfef5216/ffmpeg/download_src.sh#L24
RDEPEND="
	(
		|| (
			>=dev-libs/protobuf-3.19.1:0/3.21[${MULTILIB_USEDEP}]
		)
		dev-libs/protobuf:=[${MULTILIB_USEDEP}]
	)
	>=app-arch/bzip2-1.0.8[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.3.0[${MULTILIB_USEDEP}]
	avif? (
		>=media-libs/libavif-0.9.3[${MULTILIB_USEDEP}]
	)
	cuda? (
		${CUDA_DEPEND}
	)
	cudnn? (
		=dev-libs/cudnn-8.6*:0/8
		dev-libs/cudnn:=
	)
	contribdnn? (
		>=dev-libs/flatbuffers-23.5.9:0
		dev-libs/flatbuffers:=
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
		|| (
			media-video/ffmpeg:0/56.58.58[${MULTILIB_USEDEP},libaom?,openh264?,vpx?]
		)
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
		!jasper? (
			>=media-libs/openjpeg-2.5.0:2[${MULTILIB_USEDEP}]
			media-libs/openjpeg:=[${MULTILIB_USEDEP}]
		)
		jasper? (
			>=media-libs/jasper-1.900.1:0
			media-libs/jasper:=
		)
	)
	lapack? (
		!atlas? (
			!mkl? (
				virtual/cblas
				>=virtual/lapack-3.10
				virtual/lapacke
			)
		)
		atlas? (
			>=sci-libs/atlas-3.10.3
		)
		mkl? (
			>=sci-libs/mkl-2020.0.166
		)
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
	png? (
		>=media-libs/libpng-1.6.37:0[${MULTILIB_USEDEP}]
		media-libs/libpng:=[${MULTILIB_USEDEP}]
	)
	python? (
		${PYTHON_DEPS}
		>=dev-python/numpy-1.16.5:0[${PYTHON_USEDEP}]
		dev-python/numpy:=[${PYTHON_USEDEP}]
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
	!qt5? (
		qt6? (
			>=dev-qt/qtbase-${QT6_PV}:6[gui,widgets,concurrent,opengl?]
		)
	)
	quirc? (
		>=media-libs/quirc-1.1:0
	)
	spng? (
		>=media-libs/libspng-0.7.4[${MULTILIB_USEDEP}]
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
"
# TODO gstreamer dependencies
DEPEND+="
	test? (
		gstreamer? (
			>=media-plugins/gst-plugins-jpeg-${GSTREAMER_PV}[${MULTILIB_USEDEP}]
			>=media-plugins/gst-plugins-x264-${GSTREAMER_PV}[${MULTILIB_USEDEP}]
		)
	)
"
BDEPEND="
	>=dev-build/cmake-${CMAKE_PV}
	>=dev-util/patchelf-0.10
	virtual/pkgconfig
	cuda? (
		${CUDA_DEPEND}
		sys-apps/grep[pcre]
	)
	doc? (
		>=app-text/doxygen-1.8.17[dot]
		python? (
			>=dev-python/beautifulsoup4-4.8.2[${PYTHON_USEDEP}]
		)
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-3.4.0-disable-download.patch"
	"${FILESDIR}/${PN}-3.4.1-cuda-add-relaxed-constexpr.patch"
	"${FILESDIR}/${PN}-4.1.2-opencl-license.patch"
	"${FILESDIR}/${PN}-4.4.0-disable-native-cpuflag-detect.patch"
	"${FILESDIR}/${PN}-4.5.0-link-with-cblas-for-lapack.patch"
	"${FILESDIR}/${PN}-4.8.1-use-system-flatbuffers.patch"
	"${FILESDIR}/${PN}-4.8.1-use-system-opencl.patch"
	"${FILESDIR}/${PN}-4.9.0-drop-python2-detection.patch"
	"${FILESDIR}/${PN}-4.9.0-ade-0.1.2d.tar.gz.patch"
	"${FILESDIR}/${PN}-4.9.0-cmake-cleanup.patch"
	# TODO applied in src_prepare
	# "${FILESDIR}/${PN}_contrib-${PV}-rgbd.patch"
	# "${FILESDIR}/${PN}_contrib-4.8.1-NVIDIAOpticalFlowSDK-2.0.tar.gz.patch"
)

cuda_get_cuda_compiler() {
	local compiler
	tc-is-gcc && compiler="gcc"
	tc-is-clang && compiler="clang"
	[[ -z "$compiler" ]] && die "no compiler specified"

	local package="sys-devel/${compiler}"
	local version="${package}"
	local CUDAHOSTCXX_test
	while
		local CUDAHOSTCXX="${CUDAHOSTCXX_test}"
		version=$(best_version "${version}")
		if [[ -z "${version}" ]] ; then
			if [[ -z "${CUDAHOSTCXX}" ]] ; then
				die "could not find supported version of ${package}"
			fi
			break
		fi
		local exe_name="${compiler}-"$(echo "${version}" | grep -oP "(?<=${package}-)[0-9]*")
		exe_name=$(which "${exe_name}")
		exe_name=$(realpath "${exe_name}")
		exe_name=$(dirname "${exe_name}")
		CUDAHOSTCXX_test="${exe_name}"
		version="<${version}"
	do ! echo "int main(){}" | nvcc "-ccbin ${CUDAHOSTCXX_test}" - -x cu &>/dev/null ; done

	echo "${CUDAHOSTCXX}"
}

cuda_get_host_native_arch() {
	: "${CUDAARCHS:=$(__nvcc_device_query)}"
	echo "${CUDAARCHS}"
}

pkg_pretend() {
	if use cuda && [[ -z "${CUDA_GENERATION}" ]] && [[ -z "${CUDA_ARCH_BIN}" ]] ; then # TODO CUDAARCHS
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
}

src_prepare() {
	local file
	cmake_src_prepare

	# Remove bundled stuff
	rm -r "3rdparty" || die "Removing 3rd party components failed"
	sed \
		-i \
		-e '/add_subdirectory(.*3rdparty.*)/ d' \
		"CMakeLists.txt" \
		"cmake/"*"cmake" \
		|| die

	if use contrib ; then
		cd "${WORKDIR}/${PN}_contrib-${PV}" || die
		eapply "${FILESDIR}/${PN}_contrib-4.8.1-rgbd.patch"
		eapply "${FILESDIR}/${PN}_contrib-4.8.1-NVIDIAOpticalFlowSDK-2.0.tar.gz.patch"
		if has_version ">=dev-util/nvidia-cuda-toolkit-12.4" && use cuda ; then
	# TODO https://github.com/NVIDIA/cccl/pull/1522
			eapply "${FILESDIR}/${PN}_contrib-4.9.0-cuda-12.4.patch"
		fi
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
		mkdir -p "${WORKDIR}/${PN}_extra-${PV}/testdata/cv/face/" || die
		file="face_landmark_model.dat"
		local s2=$(md5sum "${WORKDIR}/${PN}_3rdparty-${FACE_ALIGNMENT_COMMIT}/${file}" \
			| cut -f 1 -d " ")
		cp \
			"${WORKDIR}/${PN}_3rdparty-${FACE_ALIGNMENT_COMMIT}/${file}" \
			"${WORKDIR}/${PN}_extra-${PV}/testdata/cv/face/" \
			|| die
		mv \
			"${WORKDIR}/${PN}_3rdparty-${FACE_ALIGNMENT_COMMIT}/${file}" \
			"${S}/.cache/data/${s2}-${file}" || die
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

		JAVA_ANT_ENCODING="iso-8859-1"
		# set encoding so even this cmake build will pick it up.
		export ANT_OPTS+=" -Dfile.encoding=iso-8859-1"
	fi
}

multilib_src_configure() {
	# bug #919101 and https://github.com/opencv/opencv/issues/19020
	filter-lto

	local mycmakeargs=(
		-DBUILD_ANDROID_EXAMPLES=OFF
		#-DBUILD_ANDROID_SERVICE=OFF
		-DBUILD_CUDA_STUBS=$(multilib_native_usex cuda)
		-DBUILD_DOCS=$(usex doc)"						# It doesn't install anyways.
		-DBUILD_EXAMPLES="$(multilib_native_usex examples)
		-DBUILD_FAT_JAVA_LIB=OFF
		-DBUILD_IPP_IW=OFF
		-DBUILD_ITT=OFF
		-DBUILD_JAVA=$(multilib_native_usex java)				# Ant needed, no compile flag
		-DBUILD_opencv_apps=$(usex opencvapps)
		-DBUILD_opencv_cudalegacy=OFF
		-DBUILD_opencv_features2d=$(usex features2d)
		-DBUILD_opencv_gapi=$(usex ffmpeg ON $(usex gstreamer))
		-DBUILD_opencv_java_bindings_generator=$(usex java)
		-DBUILD_opencv_js=OFF
		-DBUILD_opencv_js_bindings_generator=OFF
		-DBUILD_opencv_objc_bindings_generator=OFF
		-DBUILD_opencv_python2=OFF
		-DBUILD_opencv_ts=$(usex test)
		-DBUILD_opencv_video=$(usex ffmpeg ON $(usex gstreamer))
		-DBUILD_opencv_videoio=$(usex ffmpeg ON $(usex gstreamer))
		#-DBUILD_opencv_world=ON
		-DBUILD_PACKAGE=OFF
		-DBUILD_PERF_TESTS=OFF
		-DBUILD_PROTOBUF=OFF
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_TESTS=$(multilib_native_usex test)
	# bug 733796, but PCH is a risky game in CMake anyway \
		-DBUILD_USE_SYMLINKS=ON
		-DBUILD_WITH_DEBUG_INFO=$(usex debug)
		-DBUILD_WITH_DYNAMIC_IPP=OFF
		#-DBUILD_WITH_STATIC_CRT=OFF
		-DCMAKE_CXX_STANDARD=17							# For protobuf
		-DCMAKE_POLICY_DEFAULT_CMP0148="OLD"					# FindPythonInterp
		-DCUDA_NPP_LIBRARY_ROOT_DIR=$(usex cuda "${EPREFIX}/opt/cuda" "")
		-DCV_TRACE="$(usex debug)"
		-DDNN_PLUGIN_LIST="all"
		#-DENABLE_CCACHE=OFF
		-DENABLE_COVERAGE=OFF
		-DENABLE_DOWNLOAD=yes
		-DENABLE_IMPL_COLLECTION=OFF
		-DENABLE_INSTRUMENTATION=OFF
		-DENABLE_NOISY_WARNINGS=$(usex debug)
		-DENABLE_PRECOMPILED_HEADERS=OFF
		-DENABLE_PROFILING=OFF
		-DENABLE_SOLUTION_FOLDERS=OFF
		-DGENERATE_ABI_DESCRIPTOR=OFF
		-DHAVE_opencv_java=$(multilib_native_usex java)
		-DHIGHGUI_PLUGIN_LIST="all"
		#-DINSTALL_ANDROID_EXAMPLES=OFF
		-DINSTALL_BIN_EXAMPLES=$(multilib_native_usex examples)
		-DINSTALL_CREATE_DISTRIB=OFF
		-DINSTALL_C_EXAMPLES=$(multilib_native_usex examples)
		-DINSTALL_TESTS=$(multilib_native_usex testprograms)
		-DINSTALL_TO_MANGLED_PATHS=OFF
	# opencv uses both ${CMAKE_INSTALL_LIBDIR} and ${LIB_SUFFIX} to set	\
	# its destination libdir						\
		-DLIB_SUFFIX=
		-DMIN_VER_CMAKE="${CMAKE_PV}"
		-DOPENCV_DOC_INSTALL_PATH="share/doc/${P}"
		-DOPENCV_DOWNLOAD_TRIES_LIST="0"
		-DOPENCV_ENABLE_MEMORY_SANITIZER=$(usex debug)
		-DOPENCV_ENABLE_NONFREE=$(usex non-free)
		-DOPENCV_EXTRA_MODULES_PATH=$(usex contrib "${WORKDIR}/${PN}_contrib-${PV}/modules" "")
		-DOPENCV_GENERATE_PKGCONFIG=ON
		-DOPENCV_SAMPLES_BIN_INSTALL_PATH="libexec/${PN}/bin/samples"
	# NOTE do this so testprograms do not fail TODO adjust path in code \
		-DOPENCV_TEST_DATA_INSTALL_PATH="share/${PN}$(ver_cut 1)/testdata"
		-DOPENCV_TEST_INSTALL_PATH="libexec/${PN}/bin/test"
		-DOPENCV_WARNINGS_ARE_ERRORS=OFF
		-DOpenGL_GL_PREFERENCE="GLVND"
		-DProtobuf_MODULE_COMPATIBLE=ON
		-DPROTOBUF_UPDATE_FILES=ON
		-DVIDEOIO_PLUGIN_LIST="all"
		-DWITH_1394=$(usex ieee1394)
		-DWITH_ARAVIS=OFF
		#-DWITH_AVFOUNDATION=OFF						# IOS
		-DWITH_AVIF=$(usex avif)
		-DWITH_CLP=OFF
		-DWITH_CUDA=$(multilib_native_usex cuda)
		-DWITH_CUBLAS=$(multilib_native_usex cuda)
		-DWITH_CUDNN=$(multilib_native_usex cudnn)
		-DWITH_CUFFT=$(multilib_native_usex cuda)
		-DWITH_DIRECTX=OFF
		#-DWITH_DSHOW=ON							# Direct show supp
		-DWITH_EIGEN=$(usex eigen)
		-DWITH_FFMPEG=$(usex ffmpeg)
		-DWITH_FLATBUFFERS=$(multilib_native_usex contribdnn)
		-DWITH_GDAL=$(multilib_native_usex gdal)
		-DWITH_GDCM=OFF
		-DWITH_GIGEAPI=OFF
		-DWITH_GPHOTO2=$(usex gphoto2)
		-DWITH_GSTREAMER=$(usex gstreamer)
		-DWITH_GTK="$(usex gtk3)"
		-DWITH_GTK_2_X=OFF							# We only want GTK3 nowadays
		-DWITH_INTELPERC=OFF
		-DWITH_IPP=OFF
		-DWITH_IPP_A=OFF
		-DWITH_ITT=OFF								# 3dparty libs itt_notify
		-DWITH_JASPER=$(multilib_native_usex jasper)
		-DWITH_JPEG=$(usex jpeg)
		-DWITH_LAPACK=$(multilib_native_usex lapack)
		-DWITH_LIBV4L=$(usex v4l)
		-DWITH_MATLAB=OFF
		-DWITH_MSMF=OFF
		-DWITH_NVCUVENC=OFF							# TODO needs NVIDIA Video Codec SDK
	# NOTE set this via MYCMAKEARGS if needed \
		-DWITH_NVCUVID=OFF							# TODO needs NVIDIA Video Codec SDK
		-DWITH_OPENCL=$(usex opencl)
		-DWITH_OPENCL_SVM=OFF # "$(usex opencl)"
		-DWITH_OPENEXR=$(multilib_native_usex openexr)
		-DWITH_OPENGL=$(usex opengl)
		-DWITH_OPENJPEG=$(usex jpeg2k)
		-DWITH_OPENMP=$(usex !tbb $(usex openmp))
		-DWITH_OPENNI=OFF							# Not packaged
		-DWITH_OPENNI2=OFF							# Not packaged
		-DWITH_PNG=$(usex png)
		-DWITH_PROTOBUF=ON
		-DWITH_PTHREADS_PF=ON
		-DWITH_PVAPI=OFF
		#-DWITH_QTKIT=OFF
		#-DWITH_QUICKTIME=OFF
		-DWITH_QUIRC=$(usex quirc)
		-DWITH_SPNG=$(usex spng)
		-DWITH_TBB=$(usex tbb)
		-DWITH_TIFF=$(usex tiff)
		-DWITH_UNICAP=OFF							# Not packaged
		-DWITH_V4L=$(usex v4l)
		-DWITH_VA=$(usex vaapi)
		-DWITH_VA_INTEL=$(usex vaapi "$(usex video_cards_intel)")
		-DWITH_VFW=OFF								# Video windows support
		-DWITH_VTK=$(multilib_native_usex vtk)
		-DWITH_WAYLAND=$(usex wayland)
		-DWITH_WEBP=$(usex webp)
		-DWITH_WIN32UI=OFF							# Windows only
		-DWITH_XIMEA=OFF							# Windows only
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

	has_openvx_support() {
		has_version "sci-libs/MIVisionX" && return 0
		#has_version "dev-util/openvino" && return 0 # TODO package
		return 1
	}

	if use openvx && has_openvx_support ; then
		mycmakeargs+=(
			-DWITH_OPENVX=ON
		)
	else
		mycmakeargs+=(
			-DWITH_OPENVX=OFF
		)
	fi

	if use qt5 ; then
		mycmakeargs+=(
			-DCMAKE_DISABLE_FIND_PACKAGE_Qt6=ON
			-DWITH_QT=$(multilib_native_usex qt5)
		)
	elif use qt6 ; then
		mycmakeargs+=(
			-DCMAKE_DISABLE_FIND_PACKAGE_Qt5=ON
			-DWITH_QT=$(multilib_native_usex qt6)
		)
	else
		mycmakeargs+=(
			-DCMAKE_DISABLE_FIND_PACKAGE_Qt5=ON
			-DCMAKE_DISABLE_FIND_PACKAGE_Qt6=ON
			-DWITH_QT=OFF
		)
	fi

	# CPU flags should solve bug #633900
	# TODO binhost
	# https://github.com/opencv/opencv/wiki/CPU-optimizations-build-options

	local CPU_BASELINE=""
	local i
	for i in "${CPU_FEATURES_MAP[@]}" ; do
		local flag="${i%:*}"
		if [[ "${ABI}" != x86 || "${flag}" != "cpu_flags_x86_avx2" ]] ; then # Workaround for Bug 747163
			use "${flag}" && CPU_BASELINE="${CPU_BASELINE}${i#*:};"
		fi
	done
	unset CPU_FEATURES_MAP

	mycmakeargs+=(
		-DCPU_BASELINE="${CPU_BASELINE}"
	)
	if [[ "${MERGE_TYPE}" != "buildonly" ]] ; then
		mycmakeargs+=(
			-DCPU_DISPATCH=
			-DOPENCV_CPU_OPT_IMPLIES_IGNORE=ON
		)
	fi

	if use contrib ; then
		mycmakeargs+=(
			-DBUILD_opencv_cvv=$(usex contribcvv)
			-DBUILD_opencv_dnn=$(usex contribdnn)
			-DBUILD_opencv_freetype=$(usex contribfreetype)
			-DBUILD_opencv_hdf=$(multilib_native_usex contribhdf)
			-DBUILD_opencv_ovis=$(usex contribovis)
			-DBUILD_opencv_sfm=$(usex contribsfm)
			-DBUILD_opencv_xfeatures2d=$(usex contribxfeatures2d)
		)

		if multilib_is_native_abi && use !tesseract ; then
			mycmakeargs+=(
				-DCMAKE_DISABLE_FIND_PACKAGE_Tesseract=ON
			)
		fi
	fi

	# Workaround for bug 413429
	tc-export CC CXX

	if multilib_is_native_abi && use cuda ; then
		cuda_add_sandbox -w
		sandbox_write "/proc/self/task"
		CUDAHOSTCXX="$(cuda_get_cuda_compiler)"
		CUDAARCHS="$(cuda_get_host_native_arch)"
		export CUDAHOSTCXX
		export CUDAARCHS
		mycmakeargs+=(
			-DENABLE_CUDA_FIRST_CLASS_LANGUAGE=ON
		)
	fi

	if use ffmpeg ; then
		mycmakeargs+=(
			-DOPENCV_GAPI_GSTREAMER=OFF
		)
	fi

	if use mkl ; then
		mycmakeargs+=(
			-DLAPACK_IMPL="MKL"
			-DMKL_WITH_OPENMP=$(usex !tbb $(usex openmp))
			-DMKL_WITH_TBB=$(usex tbb)
		)
	fi

	# NOTE set this via MYCMAKEARGS if needed
	if use opencl ; then
		if has_version "sci-libs/clfft" ; then
			mycmakeargs+=(
				-DWITH_OPENCLAMDFFT=ON
			)
		else
			mycmakeargs+=(
				-DWITH_OPENCLAMDFFT=OFF
			)
		fi
		if has_version "sci-libs/clblas" ; then
			mycmakeargs+=(
				-DWITH_OPENCLAMDBLAS=ON
			)
		else
			mycmakeargs+=(
				-DWITH_OPENCLAMDBLAS=OFF
			)
		fi
	else
		mycmakeargs+=(
			-DWITH_OPENCLAMDBLAS=OFF
			-DWITH_OPENCLAMDFFT=OFF
		)
	fi

	if use test ; then
		# opencv tests assume to be build in Release mode
		CMAKE_BUILD_TYPE="Release"
		mycmakeargs+=(
			-DOPENCV_TEST_DATA_PATH="${WORKDIR}/${PN}_extra-${PV}/testdata"
		)
		if use vtk ; then
			mycmakeargs+=(
				-DVTK_MPI_NUMPROCS="$(nproc)" # TODO
			)
		fi
	fi

	if multilib_is_native_abi && use python ; then
		python_configure() {
	# Set all python variables to load the correct distro paths.
			local mycmakeargs=(
				"${mycmakeargs[@]}"
				-DBUILD_opencv_python3=ON
				-DBUILD_opencv_python_bindings_generator=ON
				-DBUILD_opencv_python_tests=$(usex test)
				-DINSTALL_PYTHON_EXAMPLES=$(usex examples)
	# python_setup alters PATH and sets this as wrapper to the correct	\
	# interpreter we are building for					\
				-DPYTHON_DEFAULT_EXECUTABLE="${EPYTHON}"
			)
			cmake_src_configure
		}

		python_foreach_impl python_configure
	else
		mycmakeargs+=(
			-DBUILD_opencv_python3=OFF
			-DBUILD_opencv_python_bindings_generator=OFF
			-DBUILD_opencv_python_tests=OFF
			-DINSTALL_PYTHON_EXAMPLES=OFF
			-DPYTHON_EXECUTABLE=OFF
		)
		cmake_src_configure
	fi
	use java && java-ant-2_src_configure
}

multilib_src_compile() {
	opencv_compile() {
		cmake_src_compile
	}
	if multilib_is_native_abi && use python ; then
		python_foreach_impl opencv_compile
	else
		opencv_compile
	fi
}

multilib_src_test() {
	CMAKE_SKIP_TESTS=(
		'Test_ONNX_layers.LSTM_cell_forward/0'
		'Test_ONNX_layers.LSTM_cell_bidirectional/0'
		'Test_TensorFlow_layers.Convolution3D/1'
		'Test_TensorFlow_layers.concat_3d/1'

		'AsyncAPICancelation/cancel*basic'
	)

	if ! use gtk && ! use qt5 && ! use qt6 ; then
		CMAKE_SKIP_TESTS+=(
			# these fail with parallism
			'^Highgui_*'
		)
	fi

	if multilib_is_native_abi && use cuda ; then
		CMAKE_SKIP_TESTS+=(
			'CUDA_OptFlow/BroxOpticalFlow.Regression/0'
			'CUDA_OptFlow/BroxOpticalFlow.OpticalFlowNan/0'
			'CUDA_OptFlow/NvidiaOpticalFlow_1_0.Regression/0'
			'CUDA_OptFlow/NvidiaOpticalFlow_2_0.Regression/0'
		)
	fi

	if use opengl ; then
		CMAKE_SKIP_TESTS+=(
			'OpenGL/Buffer.MapDevice/*'
			'OpenGL/*Gpu*'
		)
	fi

	if use opencl ; then
		CMAKE_SKIP_TESTS+=(
			'OCL_Arithm/InRange.Mat/\(CV_32S,*'
		)
	fi

	local myctestargs=(
		--test-timeout 180
	)

	if multilib_is_native_abi && use cuda ; then
		cuda_add_sandbox -w
		export DNN_BACKEND_OPENCV="cuda"
		export OPENCV_PARALLEL_BACKEND="threads"
	fi

	opencv_test() {
		export LIBGL_ALWAYS_SOFTWARE=true # A workaround for zink warnings
		export OPENCV_CORE_PLUGIN_PATH="${BUILD_DIR}/lib"
		export OPENCV_DNN_PLUGIN_PATH="${BUILD_DIR}/lib"
		export OPENCV_TEST_DATA_PATH="${WORKDIR}/${PN}_extra-${PV}/testdata"
		export OPENCV_VIDEOIO_PLUGIN_PATH="${BUILD_DIR}/lib"
		results=()
		for test in "${BUILD_DIR}/bin/opencv_test_"* ; do
			echo "${test}"
			if ! "${test}" --gtest_color=yes --gtest_filter="-$(IFS=: ; echo "${CMAKE_SKIP_TESTS[*]}")" ; then

				results+=( "$(basename ${test})" )

				if [[ -z "${OPENCV_TEST_CONTINUE_ON_FAIL}" ]] ; then
					eerror "${results[*]} failed"
					die
				fi
			fi
		done

		echo -e "${results[*]}"
	}

	if multilib_is_native_abi && use python ; then
		python_foreach_impl virtx opencv_test
	else
		virtx opencv_test
	fi
}

multilib_src_install() {
	if use abi_x86_64 && use abi_x86_32 ; then
		MULTILIB_WRAPPED_HEADERS=( # {{{
			${_MULTILIB_WRAPPED_HEADERS[@]}
		)
	fi
	if multilib_is_native_abi && use python ; then
		python_foreach_impl cmake_src_install
		python_foreach_impl python_optimize
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
}
