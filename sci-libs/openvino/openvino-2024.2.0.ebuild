# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# D9, U18, U20, U22

# FIXME:
# dev-python/openvino-dev in DEPEND vs development-tools USE

# TODO package:
# deepctr-torch
# facexlib
# kornia
# lpips
# mlas
# natten
# omegaconf
# optimum
# paddlepaddle
# pyctcdecode
# pytest-dependency
# pytest-html
# sacremoses
# super-image
# tf-sentence-transformers
# torchaudio

# For driver version, see
# https://github.com/openvinotoolkit/openvino/blob/2024.2.0/docs/dev/build_linux.md#software-requirements

CPU_FLAGS_X86=(
	"cpu_flags_x86_avx2"
	"cpu_flags_x86_avx512f"
	"cpu_flags_x86_sse4_2"
)
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..11} ) # Based on https://github.com/openvinotoolkit/openvino/blob/2024.2.0/docs/dev/build_linux.md#software-requirements

BENCHMARK_1_COMMIT="bf585a2789e30585b4e3ce6baf11ef2750b54677"
BENCHMARK_2_COMMIT="5b7683f49e1e9223cf9927b24f6fd3d6bd82e3f8"
BENCHMARK_3_COMMIT="2dd015dfef425c866d9a43f2c67d8b52d709acb6"
CMOCK_COMMIT="379a9a8d5dd5cdff8fd345710dd70ae26f966c71"
COMPUTELIBRARY_COMMIT="4fda7a803eaadf00ba36bd532481a33c18952089"
FLATBUFFERS_COMMIT="0100f6a5779831fa7a651e4b67ef389a8752bd9b"
GFLAGS_1_COMMIT="e171aa2d15ed9eb17054558e0b3a6a413bb01067"
GFLAGS_2_COMMIT="8411df715cf522606e3b1aca386ddfc0b63d34b4"
GOOGLETEST_1_COMMIT="18f8200e3079b0e54fa00cb7ac55d4c39dcf6da6"
GOOGLETEST_2_COMMIT="5ec7f0c4a113e2f18ac2c6cc7df51ad6afc24081"
GOOGLETEST_3_COMMIT="70a225df5dd55bd5931664fadaa67765eb9f6016"
ITTAPI_COMMIT="69dd04030d3a2cf4c32e649ac1f2a628d5af6b46"
LEVEL_ZERO_COMMIT="4ed13f327d3389285592edcf7598ec3cb2bc712e"
LEVEL_ZERO_NPU_EXTENSIONS_COMMIT="d490a130fbb80e600b3aed3886c305abcb60d77c"
LIBXSMM_COMMIT="13df674c4b73a1b84f6456de8595903ebfbb43e0"
MLAS_COMMIT="d1bc25ec4660cddd87804fcf03b2411b5dfb2e94"
NCC_COMMIT="63e59ed312ba7a946779596e86124c1633f67607"
NLOHMANN_JSON_COMMIT="9cca280a4d0ccf0c08f47a99aa71d1b0e52f8d03"
ONEDNN_1_COMMIT="373e65b660c0ba274631cf30c422f10606de1618"
ONEDNN_2_COMMIT="37f48519b87cf8b5e5ef2209340a1948c3e87d72"
ONNX_COMMIT="b86cc54efce19530fb953e4b21f57e6b3888534c"
OPEN_MODEL_ZOO_COMMIT="9c6d95a2a668d6ae41aebda42b15608db7dd3fa0"
OPENCL_CLHPP_COMMIT="83cc072d8240aad47ef4663d572a31ef27d0411a"
OPENCL_HEADERS_COMMIT="2368105c0531069fe927989505de7d125ec58c55"
OPENCL_ICD_LOADER_COMMIT="229410f86a8c8c9e0f86f195409e5481a2bae067"
PROTOBUF_COMMIT="fe271ab76f2ad2b2b28c10443865d2af21e27e0e"
PUGIXML_COMMIT="2e357d19a3228c0a301727aac6bea6fecd982d21"
PYBIND11_1_COMMIT="3e9dfa2866941655c56877882565e7577de6fc7b"
PYBIND11_2_COMMIT="5b0a6fc2017fcc176545afe3e09c9f9885283242"
SNAPPY_COMMIT="dc05e026488865bc69313a68bcc03ef2e4ea8e83"
TELEMETRY_COMMIT="58e16c257a512ec7f451c9fccf9ff455065b285b"
XBYAK_COMMIT="58642e0cdd5cbe12f5d6e05069ddddbc0f5d5383"
ZLIB_COMMIT="09155eaa2f9270dc4ed1fa13e2b4b2613e6e4851"

inherit cmake dep-prepare distutils-r1

_gen_gh_uri() {
	local org="${1}"
	local project_name="${2}"
	local commit="${3}"
	local alt_name="${4}"
	if [[ -n "${alt_name}" ]] ; then
		echo "
https://github.com/${org}/${project_name}/archive/${commit}.tar.gz -> ${org}-${alt_name}-${commit:0:7}.tar.gz
		"
	else
		echo "
https://github.com/${org}/${project_name}/archive/${commit}.tar.gz -> ${org}-${project_name}-${commit:0:7}.tar.gz
		"
	fi
}

KEYWORDS="~amd64 ~arm ~arm64 ~riscv"
S="${WORKDIR}/${P}"
# snappy has .gitmodules benchmark (bf5), googletest (18f)
# protobuf has .gitmodules benchmark (5b7), googletest (5ec)
# open_model_zoo has .gitmodules gflags (e17)
# gflags (e17) has .gitmodules gflags (841)
# OpenCL-CLHPP (83cc) has .gitmodules cmock (379)
SRC_URI="
https://github.com/openvinotoolkit/openvino/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
$(_gen_gh_uri herumi xbyak ${XBYAK_COMMIT})
$(_gen_gh_uri openvinotoolkit open_model_zoo ${OPEN_MODEL_ZOO_COMMIT})
!system-pugixml? (
	$(_gen_gh_uri zeux pugixml ${PUGIXML_COMMIT})
)
!system-snappy? (
	$(_gen_gh_uri google snappy ${SNAPPY_COMMIT})
	$(_gen_gh_uri google benchmark ${BENCHMARK_1_COMMIT})
	$(_gen_gh_uri google googletest ${GOOGLETEST_1_COMMIT})
)
$(_gen_gh_uri openvinotoolkit telemetry ${TELEMETRY_COMMIT})
$(_gen_gh_uri ARM-software ComputeLibrary ${COMPUTELIBRARY_COMMIT})
$(_gen_gh_uri libxsmm libxsmm ${LIBXSMM_COMMIT})
$(_gen_gh_uri openvinotoolkit mlas ${MLAS_COMMIT})
$(_gen_gh_uri openvinotoolkit oneDNN ${ONEDNN_1_COMMIT})
$(_gen_gh_uri madler zlib ${ZLIB_COMMIT})
!system-protobuf? (
	$(_gen_gh_uri protocolbuffers protobuf ${PROTOBUF_COMMIT})
	$(_gen_gh_uri google benchmark ${BENCHMARK_2_COMMIT})
	$(_gen_gh_uri google googletest ${GOOGLETEST_2_COMMIT})
)
$(_gen_gh_uri onnx onnx ${ONNX_COMMIT})
$(_gen_gh_uri google benchmark ${BENCHMARK_3_COMMIT})
$(_gen_gh_uri pybind pybind11 ${PYBIND11_2_COMMIT})
!system-opencl? (
	$(_gen_gh_uri KhronosGroup OpenCL-Headers ${OPENCL_HEADERS_COMMIT})
	$(_gen_gh_uri KhronosGroup OpenCL-CLHPP ${OPENCL_CLHPP_COMMIT})
	$(_gen_gh_uri KhronosGroup OpenCL-ICD-Loader ${OPENCL_ICD_LOADER_COMMIT})
	$(_gen_gh_uri ThrowTheSwitch CMock ${CMOCK_COMMIT})
)

$(_gen_gh_uri nlohmann json ${NLOHMANN_JSON_COMMIT})
$(_gen_gh_uri intel ittapi ${ITTAPI_COMMIT})
$(_gen_gh_uri openvinotoolkit googletest ${GOOGLETEST_3_COMMIT})
$(_gen_gh_uri gflags gflags ${GFLAGS_1_COMMIT})
$(_gen_gh_uri gflags gflags ${GFLAGS_2_COMMIT} gflags-doc)
!system-flatbuffers? (
	$(_gen_gh_uri google flatbuffers ${FLATBUFFERS_COMMIT})
)
$(_gen_gh_uri pybind pybind11 ${PYBIND11_1_COMMIT})
$(_gen_gh_uri nithinn ncc ${NCC_COMMIT})
$(_gen_gh_uri oneapi-src oneDNN ${ONEDNN_2_COMMIT})
$(_gen_gh_uri oneapi-src level-zero ${LEVEL_ZERO_COMMIT})
$(_gen_gh_uri intel level-zero-npu-extensions ${LEVEL_ZERO_NPU_EXTENSIONS_COMMIT})
openmp? (
	amd64? (
		https://storage.openvinotoolkit.org/dependencies/thirdparty/linux/iomp.tgz -> iomp-x86-64-7832b16.tgz
	)
)
tbb? (
	kernel_linux? (
		amd64? (
			https://storage.openvinotoolkit.org/dependencies/thirdparty/linux/tbbbind_2_5_static_lin_v4.tgz
		)
	)
	!system-tbb? (
		amd64? (
			https://storage.openvinotoolkit.org/dependencies/thirdparty/linux/oneapi-tbb-2021.2.4-lin.tgz
		)
		arm64? (
			https://storage.openvinotoolkit.org/dependencies/thirdparty/linux/oneapi-tbb-2021.2.5-lin-arm64.tgz
		)
	)
)
"
# The version difference for tbb is not a mistake.
# For downloads, grep also RESOLVE_DEPENDENCY in cmake/dependencies.cmake

DESCRIPTION="OpenVINO™ is an open-source toolkit for optimizing and deploying AI inference"
HOMEPAGE="https://github.com/openvinotoolkit/openvino"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror test" # Missing test dependencies
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
	${CPU_FLAGS_X86[@]}
	development-tools doc -lto +mlas +npu -openmp runtime +samples
	-system-flatbuffers system-opencl system-protobuf system-pugixml
	system-snappy system-tbb -telemetry test +tbb video_cards_intel
	ebuild-revision-5
"
REQUIRED_USE="
	?? (
		tbb
		openmp
	)
	system-tbb? (
		tbb
	)
	^^ (
		runtime
		development-tools
	)
"
RDEPEND+="
	dev-cpp/tbb
	dev-libs/protobuf
	mlas? (
		>=sci-libs/mlas-20240118
	)
	system-flatbuffers? (
		>=dev-libs/flatbuffers-23.5.26
	)
	system-opencl? (
		>=dev-cpp/clhpp-2023.12.14
		>=dev-libs/opencl-icd-loader-2023.12.14
		>=dev-util/opencl-headers-2023.12.14
	)
	system-protobuf? (
		>=dev-libs/protobuf-3.20.3:0/3.21
	)
	system-pugixml? (
		>=dev-libs/pugixml-1.14
	)
	system-snappy? (
		>=app-arch/snappy-1.1.10
	)
	video_cards_intel? (
		>=dev-libs/intel-compute-runtime-21.38.21026
	)
"
DEPEND+="
	${RDEPEND}
"
# tests/constraints.txt \
BDEPEND_TEST_CONSTRAINTS="
	$(python_gen_any_dep '
		(
			>=sci-libs/pytorch-1.13[${PYTHON_SINGLE_USEDEP}]
			<sci-libs/pytorch-2.3[${PYTHON_SINGLE_USEDEP}]
		)
	')
	(
		>=dev-python/h5py-3.1.0[${PYTHON_USEDEP}]
		<dev-python/h5py-3.11.0[${PYTHON_USEDEP}]
	)
	(
		>=dev-python/numpy-1.16.6[${PYTHON_USEDEP}]
		<dev-python/numpy-1.27[${PYTHON_USEDEP}]
	)
	(
		>=sci-libs/tensorflow-2.5[${PYTHON_USEDEP}]
		<sci-libs/tensorflow-2.17.0[${PYTHON_USEDEP}]
	)
	(
		>=dev-python/pytest-5.0[${PYTHON_USEDEP}]
		<dev-python/pytest-7.5[${PYTHON_USEDEP}]
	)
	(
		>=dev-python/keras-2.0.0[${PYTHON_USEDEP}]
		<dev-python/keras-3.0.0[${PYTHON_USEDEP}]
	)
	<dev-python/networkx-3.1.1[${PYTHON_USEDEP}]
	<dev-python/jax-0.4.15[${PYTHON_USEDEP}]
	<dev-python/jaxlib-0.4.15[${PYTHON_USEDEP}]
	>=dev-python/attrs-23.2.0[${PYTHON_USEDEP}]
	>=dev-python/defusedxml-0.7.1[${PYTHON_USEDEP}]
	>=dev-python/distro-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/fastjsonschema-2.17.1[${PYTHON_USEDEP}]
	>=dev-python/kornia-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/jinja2-2.11.2[${PYTHON_USEDEP}]
	>=dev-python/paddlepaddle-2.5.0[${PYTHON_USEDEP}]
	>=dev-python/pandas-1.3.5[${PYTHON_USEDEP}]
	>=dev-python/protobuf-3.18.1:0/3.21[${PYTHON_USEDEP}]
	>=dev-python/py-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/pymongo-3.12.0[${PYTHON_USEDEP}]
	>=dev-python/pytest-dependency-0.5.1[${PYTHON_USEDEP}]
	>=dev-python/pytest-html-4.1.1[${PYTHON_USEDEP}]
	>=dev-python/pytest-timeout-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.4.1[${PYTHON_USEDEP}]
	>=dev-python/requests-2.25.1[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.11.1[${PYTHON_USEDEP}]
	>=dev-python/sympy-1.10[${PYTHON_USEDEP}]
	>=dev-python/wheel-0.38.1[${PYTHON_USEDEP}]
	>=media-libs/opencv-4.5[${PYTHON_USEDEP},python]
"
# tests/stress_tests/scripts/requirements.txt \
BDEPEND_STRESS_TESTS="
	${BDEPEND_TEST_CONSTRAINTS}
	dev-python/defusedxml[${PYTHON_USEDEP}]
	dev-python/fastjsonschema[${PYTHON_USEDEP}]
	dev-python/h5py[${PYTHON_USEDEP}]
	dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/pymongo[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
"
# tests/e2e_tests/requirements.txt \
BDEPEND_E2E_TESTS="
	(
		>=dev-python/scipy-1.5.4[${PYTHON_USEDEP}]
		<dev-python/scipy-1.12[${PYTHON_USEDEP}]
	)
	(
		>=dev-python/omegaconf-2.1[${PYTHON_USEDEP}]
		<dev-python/omegaconf-2.4[${PYTHON_USEDEP}]
	)
	>=dev-python/distro-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-4.17.0[${PYTHON_USEDEP}]
	>=dev-python/lpips-0.1.3[${PYTHON_USEDEP}]
	>=dev-python/py-cpuinfo-7.0.0[${PYTHON_USEDEP}]
	>=dev-python/pytest-7.2.0[${PYTHON_USEDEP}]
	>=dev-python/pytest-cov-2.11.1[${PYTHON_USEDEP}]
	>=dev-python/pytest-json-report-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/pytest-xdist-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/pytest-timeout-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/pycocotools-2.0.6[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-6.0[${PYTHON_USEDEP}]
	>=dev-python/scikit-image-0.17.2[${PYTHON_USEDEP}]
	>=dev-python/tabulate-0.9.0[${PYTHON_USEDEP}]
	>=dev-python/unittest-xml-reporting-3.0.4[${PYTHON_USEDEP}]
	>=media-libs/opencv-4.5[${PYTHON_USEDEP},python]
	>=dev-python/pretrainedmodels-0.7.4[${PYTHON_USEDEP}]
	>=dev-python/timm-0.9.2[${PYTHON_USEDEP}]
	dev-python/deepctr-torch[${PYTHON_USEDEP}]
	dev-python/openvino-dev[${PYTHON_USEDEP}]
	dev-python/pytest-html[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/tensorflow-hub[${PYTHON_USEDEP}]
"
# model_hub_tests/tensorflow/requirements.txt \
BDEPEND_MODEL_HUB_TENSORFLOW_TESTS="
	$(python_gen_any_dep '
		sci-libs/transformers[${PYTHON_SINGLE_USEDEP}]
	')
	${BDEPEND_TEST_CONSTRAINTS}
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/pytest-html[${PYTHON_USEDEP}]
	dev-python/tf-sentence-transformers[${PYTHON_USEDEP}]
	sci-libs/tensorflow[${PYTHON_USEDEP}]
	sci-libs/tensorflow-hub[${PYTHON_USEDEP}]
	sci-libs/tensorflow-text[${PYTHON_USEDEP}]
"
# tests/model_hub_tests/performance_tests/requirements.txt \
BDEPEND_MODEL_HUB_TESTS_PERFORMANCE_TESTS="
	${BDEPEND_TEST_CONSTRAINTS}
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/py[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/pytest-html[${PYTHON_USEDEP}]
	sci-libs/tensorflow-hub[${PYTHON_USEDEP}]
"
# tests/model_hub_tests/pytorch/requirements.txt \
BDEPEND_MODEL_HUB_TESTS_PYTORCH="
	${BDEPEND_TEST_CONSTRAINTS}
	$(python_gen_any_dep '
		sci-libs/pytorch[${PYTHON_SINGLE_USEDEP}]
		sci-libs/torchaudio[${PYTHON_SINGLE_USEDEP}]
		sci-libs/torchvision[${PYTHON_SINGLE_USEDEP}]
		sci-libs/transformers[${PYTHON_SINGLE_USEDEP}]
	')
	>=dev-python/auto-gptq-0.5.1[${PYTHON_USEDEP}]
	dev-python/av[${PYTHON_USEDEP}]
	dev-python/basicsr[${PYTHON_USEDEP}]
	dev-python/facexlib[${PYTHON_USEDEP}]
	dev-python/kornia[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/optimum[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/protobuf[${PYTHON_USEDEP}]
	dev-python/pyctcdecode[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/pytest-html[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/sacremoses[${PYTHON_USEDEP}]
	dev-python/soundfile[${PYTHON_USEDEP}]
	dev-python/super-image[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	sci-libs/datasets[${PYTHON_USEDEP}]
	dev-python/sentencepiece[${PYTHON_USEDEP},python]
	dev-python/timm[${PYTHON_USEDEP}]
"
# tests/model_hub_tests/pytorch/requirements_secondary.txt \
BDEPEND_MODEL_HUB_TESTS_PYTORCH_SECONDARY="
	${BDEPEND_TEST_CONSTRAINTS}
"
# tests/layer_tests/requirements.txt \
BDEPEND_LAYER_TESTS="
	${BDEPEND_TEST_CONSTRAINTS}
	$(python_gen_any_dep '
		sci-libs/onnxruntime[${PYTHON_SINGLE_USEDEP},python]
		sci-libs/pytorch[${PYTHON_SINGLE_USEDEP}]
		sci-libs/torchvision[${PYTHON_SINGLE_USEDEP}]
		sci-libs/transformers[${PYTHON_SINGLE_USEDEP}]
	')
	$(python_gen_cond_dep '
		sci-libs/tensorflow-addons[${PYTHON_USEDEP}]
	' python3_10)
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	virtual/pillow[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/sympy[${PYTHON_USEDEP}]
	kernel_linux? (
		amd64? (
			dev-python/jax[${PYTHON_USEDEP}]
			dev-python/jaxlib[${PYTHON_USEDEP}]
		)
	)
"
# tests/time_tests/scripts/requirements.txt \
BDEPEND_TIME_TESTS_SCRIPTS="
	${BDEPEND_TEST_CONSTRAINTS}
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
# tests/time_tests/test_runner/requirements.txt \
BDEPEND_TIME_TESTS_TEST_RUNNER="
	${BDEPEND_TEST_CONSTRAINTS}
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/distro[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/py[${PYTHON_USEDEP}]
	dev-python/pymongo[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/pytest-html[${PYTHON_USEDEP}]
	dev-python/pytest-timeout[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
# tests/memory_tests/test_runner/requirements.txt \
BDEPEND_MEMORY_TESTS="
	${BDEPEND_TEST_CONSTRAINTS}
	dev-python/distro[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/py[${PYTHON_USEDEP}]
	dev-python/pymongo[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/pytest-html[${PYTHON_USEDEP}]
	dev-python/pytest-timeout[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
# tests/conditional_compilation/requirements.txt \
BDEPEND_CONDITIONAL_COMPILATION="
	${BDEPEND_TEST_CONSTRAINTS}
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/protobuf[${PYTHON_USEDEP}]
	dev-python/py[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/pytest-dependency[${PYTHON_USEDEP}]
	dev-python/pytest-html[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
# tests/samples_tests/smoke_tests/requirements.txt \
BDEPEND_SAMPLES_TESTS_SMOKE_TESTS="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/pytest-xdist[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	media-libs/opencv[${PYTHON_USEDEP},python]
"
BDEPEND+="
	>=dev-build/cmake-3.13
	>=sys-devel/gcc-7.5
	doc? (
		>=dev-python/alabaster-0.7.12[${PYTHON_USEDEP}]
		>=dev-python/atomicwrites-1.4.0[${PYTHON_USEDEP}]
		>=dev-python/attrs-22.1.0[${PYTHON_USEDEP}]
		>=dev-python/babel-2.11.0[${PYTHON_USEDEP}]
		>=dev-python/beautifulsoup4-4.9.3[${PYTHON_USEDEP}]
		>=dev-python/breathe-4.35.0[${PYTHON_USEDEP}]
		>=dev-python/certifi-2023.7.22[${PYTHON_USEDEP}]
		>=dev-python/colorama-0.4.6[${PYTHON_USEDEP}]
		>=dev-python/cython-0.29.33[${PYTHON_USEDEP}]
		>=dev-python/docutils-0.20[${PYTHON_USEDEP}]
		>=dev-python/idna-3.4[${PYTHON_USEDEP}]
		>=dev-python/imagesize-1.3.0[${PYTHON_USEDEP}]
		>=dev-python/importlib-metadata-4.8.0[${PYTHON_USEDEP}]
		>=dev-python/iniconfig-1.1.1[${PYTHON_USEDEP}]
		>=dev-python/ipython-8.10.0[${PYTHON_USEDEP}]
		>=dev-python/jinja2-3.1.3[${PYTHON_USEDEP}]
		>=dev-python/lxml-4.9.2[${PYTHON_USEDEP}]
		>=dev-python/markupsafe-2.1.1[${PYTHON_USEDEP}]
		>=dev-python/mistune-2.0.3[${PYTHON_USEDEP}]
		>=dev-python/myst-parser-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/packaging-23.0[${PYTHON_USEDEP}]
		>=dev-python/pluggy-0.13.1[${PYTHON_USEDEP}]
		>=dev-python/py-1.9.0[${PYTHON_USEDEP}]
		>=dev-python/pydata-sphinx-theme-0.14.4[${PYTHON_USEDEP}]
		>=dev-python/pygments-2.15.1[${PYTHON_USEDEP}]
		>=dev-python/pyparsing-3.0.9[${PYTHON_USEDEP}]
		>=dev-python/pytest-6.2.5[${PYTHON_USEDEP}]
		>=dev-python/pytest-html-3.1.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-metadata-1.11.0[${PYTHON_USEDEP}]
		>=dev-python/pytz-2022.7[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-6.0.1[${PYTHON_USEDEP}]
		>=dev-python/requests-2.32.0[${PYTHON_USEDEP}]
		>=dev-python/six-1.15.0[${PYTHON_USEDEP}]
		>=dev-python/snowballstemmer-2.1.0[${PYTHON_USEDEP}]
		>=dev-python/soupsieve-2.2.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-7.2.6[${PYTHON_USEDEP}]
		>=dev-python/sphinx-copybutton-0.5.2[${PYTHON_USEDEP}]
		>=dev-python/sphinx-design-0.5.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-inline-tabs-2023.4.21[${PYTHON_USEDEP}]
		>=dev-python/sphinx-sitemap-2.2.0[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-applehelp-1.0.2[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-devhelp-1.0.2[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-htmlhelp-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-jsmath-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-qthelp-1.0.3[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-serializinghtml-1.1.9[${PYTHON_USEDEP}]
		>=dev-python/toml-0.10.2[${PYTHON_USEDEP}]
		>=dev-python/urllib3-1.26.18[${PYTHON_USEDEP}]
		>=dev-python/zipp-3.4.1[${PYTHON_USEDEP}]
	)
	test? (
		${BDEPEND_STRESS_TESTS}
		${BDEPEND_E2E_TESTS}
		${BDEPEND_MODEL_HUB_TENSORFLOW_TESTS}
		${BDEPEND_MODEL_HUB_TESTS_PERFORMANCE_TESTS}
		${BDEPEND_MODEL_HUB_TESTS_PYTORCH}
		${BDEPEND_MODEL_HUB_TESTS_PYTORCH_SECONDARY}
		${BDEPEND_LAYER_TESTS}
		${BDEPEND_TIME_TESTS_SCRIPTS}
		${BDEPEND_TIME_TESTS_TEST_RUNNER}
		${BDEPEND_MEMORY_TESTS}
		${BDEPEND_CONDITIONAL_COMPILATION}
		${BDEPEND_SAMPLES_TESTS_SMOKE_TESTS}
	)
"
DOCS=( "README.md" )
_PATCHES=(
	"${FILESDIR}/${PN}-2024.1.0-offline-install.patch"
	"${FILESDIR}/${PN}-2024.1.0-dont-delete-archives.patch"
	"${FILESDIR}/${PN}-2024.1.0-set-python-tag.patch"
)

#distutils_enable_sphinx "docs"

pkg_setup() {
	python_setup
}

dep_prepare_archive_cp() {
	local dest="${1}"
	local filename="${2}"
	local new_name="${3}"
	mkdir -p "${S}/${dest}"
	if [[ -n "${new_name}" ]] ; then
		cp -a $(realpath "${DISTDIR}/${filename}") "${S}/${dest}/${new_name}" || die
	else
		cp -a $(realpath "${DISTDIR}/${filename}") "${S}/${dest}" || die
	fi
}

src_unpack() {
	unpack ${A}
	dep_prepare_cp "${WORKDIR}/xbyak-${XBYAK_COMMIT}" "${S}/thirdparty/xbyak"
	dep_prepare_cp "${WORKDIR}/open_model_zoo-${OPEN_MODEL_ZOO_COMMIT}" "${S}/thirdparty/open_model_zoo"
	if ! use system-pugixml ; then
		dep_prepare_cp "${WORKDIR}/pugixml-${PUGIXML_COMMIT}" "${S}/thirdparty/pugixml"
	fi
	if ! use system-snappy ; then
		dep_prepare_cp "${WORKDIR}/snappy-${SNAPPY_COMMIT}" "${S}/thirdparty/snappy"
		dep_prepare_cp "${WORKDIR}/benchmark-${BENCHMARK_1_COMMIT}" "${S}/thirdparty/snappy/third_party/benchmark"
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_1_COMMIT}" "${S}/thirdparty/snappy/third_party/googletest"
	fi
	dep_prepare_cp "${WORKDIR}/telemetry-${TELEMETRY_COMMIT}" "${S}/thirdparty/telemetry"
	dep_prepare_cp "${WORKDIR}/ComputeLibrary-${COMPUTELIBRARY_COMMIT}" "${S}/src/plugins/intel_cpu/thirdparty/ComputeLibrary"
	dep_prepare_cp "${WORKDIR}/libxsmm-${LIBXSMM_COMMIT}" "${S}/src/plugins/intel_cpu/thirdparty/libxsmm"
	dep_prepare_cp "${WORKDIR}/mlas-${MLAS_COMMIT}" "${S}/src/plugins/intel_cpu/thirdparty/mlas"
	dep_prepare_cp "${WORKDIR}/oneDNN-${ONEDNN_1_COMMIT}" "${S}/src/plugins/intel_cpu/thirdparty/onednn"
	dep_prepare_cp "${WORKDIR}/zlib-${ZLIB_COMMIT}" "${S}/thirdparty/zlib/zlib"
	if ! use system-protobuf ; then
		dep_prepare_cp "${WORKDIR}/protobuf-${PROTOBUF_COMMIT}" "${S}/thirdparty/protobuf/protobuf"
		dep_prepare_cp "${WORKDIR}/benchmark-${BENCHMARK_2_COMMIT}" "${S}/thirdparty/protobuf/protobuf/third_party/benchmark"
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_2_COMMIT}" "${S}/thirdparty/protobuf/protobuf/third_party/googletest"
	fi
	dep_prepare_cp "${WORKDIR}/onnx-${ONNX_COMMIT}" "${S}/thirdparty/onnx/onnx"
	dep_prepare_cp "${WORKDIR}/benchmark-${BENCHMARK_3_COMMIT}" "${S}/thirdparty/onnx/onnx/third_party/benchmark"
	dep_prepare_cp "${WORKDIR}/pybind11-${PYBIND11_2_COMMIT}" "${S}/thirdparty/onnx/onnx/third_party/pybind11"
	if ! use system-opencl ; then
		dep_prepare_cp "${WORKDIR}/OpenCL-Headers-${OPENCL_HEADERS_COMMIT}" "${S}/thirdparty/ocl/cl_headers"
		dep_prepare_cp "${WORKDIR}/OpenCL-CLHPP-${OPENCL_CLHPP_COMMIT}" "${S}/thirdparty/ocl/clhpp_headers"
		dep_prepare_cp "${WORKDIR}/OpenCL-ICD-Loader-${OPENCL_ICD_LOADER_COMMIT}" "${S}/thirdparty/ocl/icd_loader"
		dep_prepare_cp "${WORKDIR}/CMock-${CMOCK_COMMIT}" "${S}/thirdparty/ocl/clhpp_headers/external/CMock"
	fi
	dep_prepare_cp "${WORKDIR}/json-${NLOHMANN_JSON_COMMIT}" "${S}/thirdparty/json/nlohmann_json"
	dep_prepare_cp "${WORKDIR}/ittapi-${ITTAPI_COMMIT}" "${S}/thirdparty/ittapi/ittapi"
	dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_3_COMMIT}" "${S}/thirdparty/gtest/gtest"
	dep_prepare_cp "${WORKDIR}/gflags-${GFLAGS_1_COMMIT}" "${S}/thirdparty/gflags/gflags"
	dep_prepare_cp "${WORKDIR}/gflags-${GFLAGS_2_COMMIT}" "${S}/thirdparty/gflags/gflags/doc"
	dep_prepare_cp "${WORKDIR}/gflags-${GFLAGS_1_COMMIT}" "${S}/thirdparty/open_model_zoo/demos/thirdparty/gflags"
	dep_prepare_cp "${WORKDIR}/gflags-${GFLAGS_2_COMMIT}" "${S}/thirdparty/open_model_zoo/demos/thirdparty/gflags/doc"
	if ! use system-flatbuffers ; then
		dep_prepare_cp "${WORKDIR}/flatbuffers-${FLATBUFFERS_COMMIT}" "${S}/thirdparty/flatbuffers/flatbuffers"
	fi
	dep_prepare_cp "${WORKDIR}/pybind11-${PYBIND11_1_COMMIT}" "${S}/src/bindings/python/thirdparty/pybind11"
	dep_prepare_cp "${WORKDIR}/ncc-${NCC_COMMIT}" "${S}/cmake/developer_package/ncc_naming_style/ncc"
	dep_prepare_cp "${WORKDIR}/oneDNN-${ONEDNN_2_COMMIT}" "${S}/src/plugins/intel_gpu/thirdparty/onednn_gpu"
	dep_prepare_cp "${WORKDIR}/level-zero-${LEVEL_ZERO_COMMIT}" "${S}/src/plugins/intel_npu/thirdparty/level-zero"
	dep_prepare_cp "${WORKDIR}/level-zero-npu-extensions-${LEVEL_ZERO_NPU_EXTENSIONS_COMMIT}" "${S}/src/plugins/intel_npu/thirdparty/level-zero-ext"

	if use tbb ; then
		if use kernel_linux && [[ "${ABI}" == "amd64" ]] ; then
			dep_prepare_archive_cp "temp/download" "tbbbind_2_5_static_lin_v4.tgz" # prebuilt
		fi
	fi
	if use openmp ; then
		if [[ "${ABI}" == "amd64" ]] ; then
			dep_prepare_archive_cp "temp/download" "iomp-x86-64-7832b16.tgz" "iomp.tgz"
		fi
	fi
	if use tbb && use system-tbb ; then
		if [[ "${ABI}" == "amd64" ]] ; then
			dep_prepare_archive_cp "temp/download" "oneapi-tbb-2021.2.4-lin.tgz"
		elif [[ "${ABI}" == "arm64" ]] ; then
			dep_prepare_archive_cp "temp/download" "oneapi-tbb-2021.2.1-lin-arm64-20231012.tgz"
		fi
	fi
}

python_prepare_all() {
	eapply ${_PATCHES[@]}
	if ! use telemetry ; then
		eapply "${FILESDIR}/openvino-2024.1.0-hard-disable-telemetry.patch"
	fi
	cmake_src_prepare
	distutils-r1_python_prepare_all
}

src_configure() {
	local mycmakeargs
	local _mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
#		-DCI_BUILD_NUMBER="2024.2.0-000--"
		-DCMAKE_COMPILE_WARNING_AS_ERROR=OFF
		-DCMAKE_VERBOSE_MAKEFILE=ON
		-DCPACK_GENERATOR=TGZ
		-DENABLE_ARM_COMPUTE_CMAKE=OFF
		-DENABLE_AUTO=ON
		-DENABLE_AUTO_BATCH=ON
		-DENABLE_AVX2=$(usex cpu_flags_x86_avx2)
		-DENABLE_AVX512F=$(usex cpu_flags_x86_avx512f)
		-DENABLE_CLANG_FORMAT=OFF
		-DENABLE_COVERAGE=OFF
		-DENABLE_CPPLINT=ON
		-DENABLE_CPPLINT_REPORT=OFF
		-DENABLE_CPU_DEBUG_CAPS=OFF
		-DENABLE_DEBUG_CAPS=OFF
		-DENABLE_DOCS=OFF
		-DENABLE_FASTER_BUILD=OFF
		-DENABLE_FUNCTIONAL_TESTS=OFF
		-DENABLE_FUZZING=OFF
		-DENABLE_GPU_DEBUG_CAPS=OFF
		-DENABLE_HETERO=ON
		-DENABLE_INTEGRITYCHECK=OFF
		-DENABLE_INTEL_CPU=ON
		-DENABLE_INTEL_GPU=$(usex video_cards_intel)
		-DENABLE_INTEL_NPU=$(usex npu)

# Fix for:
# src/bindings/js/node/include/node_output.hpp:6:10: fatal error: napi.h: No such file or directory
#    6 | #include <napi.h>
#      |          ^~~~~~~~
# compilation terminated.
		-DENABLE_JS=OFF

		-DENABLE_LIBRARY_VERSIONING=ON
		-DENABLE_LTO=$(usex lto)
		-DENABLE_MULTI=ON
		-DENABLE_NCC_STYLE=OFF
		-DENABLE_NPU_DEBUG_CAPS=OFF
		-DENABLE_ONEDNN_FOR_GPU=ON
		-DENABLE_OPENVINO_DEBUG=OFF
		-DENABLE_OV_IR_FRONTEND=ON
		-DENABLE_OV_ONNX_FRONTEND=ON
		-DENABLE_OV_PADDLE_FRONTEND=ON
		-DENABLE_OV_PYTORCH_FRONTEND=ON
		-DENABLE_OV_TF_FRONTEND=ON
		-DENABLE_OV_TF_LITE_FRONTEND=ON
		-DENABLE_PKGCONFIG_GEN=ON
		-DENABLE_PLUGINS_XML=OFF
		-DENABLE_PROFILING_FILTER=ALL
		-DENABLE_PROFILING_FIRST_INFERENCE=ON
		-DENABLE_PROFILING_ITT=OFF
		-DENABLE_PROXY=ON
		-DENABLE_PYTHON_PACKAGING=OFF
		-DENABLE_QSPECTRE=OFF
		-DENABLE_SANITIZER=OFF
		-DENABLE_SNAPPY_COMPRESSION=ON
		-DENABLE_SNIPPETS_DEBUG_CAPS=OFF
		-DENABLE_SSE42=$(usex cpu_flags_x86_sse4_2)
		-DENABLE_STRICT_DEPENDENCIES=OFF
		-DENABLE_SYSTEM_FLATBUFFERS=$(usex system-flatbuffers)
		-DENABLE_SYSTEM_OPENCL=$(usex system-opencl)
		-DENABLE_SYSTEM_PROTOBUF=$(usex system-protobuf)
		-DENABLE_SYSTEM_PUGIXML=$(usex system-pugixml)
		-DENABLE_SYSTEM_SNAPPY=$(usex system-snappy)
		-DENABLE_SYSTEM_TBB=$(usex system-tbb)
		-DENABLE_TBB_RELEASE_ONLY=ON
		-DENABLE_TEMPLATE=ON
		-DENABLE_TESTS=OFF
		-DENABLE_THREAD_SANITIZER=OFF
		-DENABLE_UB_SANITIZER=OFF
		-DENABLE_UNSAFE_LOCATIONS=OFF
		-DOFFLINE_INSTALL=ON
		-DOS_FOLDER=OFF
		-DSELECTIVE_BUILD=OFF
		-DUSE_BUILD_TYPE_SUBFOLDER=ON
	)

	if use tbb && use system-tbb && has_version "<dev-cpp/tbb-2021" ; then
		_mycmakeargs+=(
			-DENABLE_TBBBIND_2_5=ON
		)
	else
	# Uses >= tbb 2021
		_mycmakeargs+=(
			-DENABLE_TBBBIND_2_5=OFF
		)
	fi

	if [[ "${ARCH}" == "x86" || "${ARCH}" == "amd64" || "${ARCH}" == "arm64" ]] ; then
		_mycmakeargs+=(
			-DENABLE_MLAS_FOR_CPU=$(usex mlas)
		)
	else
		_mycmakeargs+=(
			-DENABLE_MLAS_FOR_CPU=OFF
		)
	fi

	if [[ "${ARCH}" == "riscv" ]] ; then
		_mycmakeargs+=(
			-DENABLE_TBBBIND_2_5=OFF
			-DTHREADING="SEQ"
		)
	elif [[ "${ARCH}" == "arm" || "${ARCH}" == "x86" ]] ; then
		_mycmakeargs+=(
			-DENABLE_TBBBIND_2_5=OFF
			-DTHREADING=$(usex openmp "OMP" "SEQ")
		)
	else
		_mycmakeargs+=(
			-DENABLE_TBBBIND_2_5=$(usex tbb)
			-DTHREADING=$(usex tbb "TBB" $(usex openmp "OMP" "SEQ"))
		)
	fi

	export LIBDIR=$(get_libdir)
	mycmakeargs=(
		${_mycmakeargs[@]}
		-DCMAKE_INSTALL_PREFIX="/usr/$(get_libdir)/openvino"
		-DENABLE_CPP_API=ON
		-DENABLE_PYTHON_API=OFF
		-DENABLE_PYTHON=OFF
		-DENABLE_SAMPLES=$(usex samples)
		-DENABLE_WHEEL=OFF
	)

einfo "Configuring runtime"
	cmake_src_configure

	configure_python_impl() {
		local sitedir=$(python_get_sitedir)
einfo "PYTHON_SITEDIR:  ${sitedir}"
		local python_tag="${EPYTHON/python/}"
		python_tag="cp${python_tag/./}"
		export PYTHON_TAG="${python_tag}"
		mycmakeargs=(
			${_mycmakeargs[@]}
			-DCMAKE_INSTALL_PREFIX="/usr/$(get_libdir)/openvino/python/${EPYTHON}"
			-DENABLE_CPP_API=OFF
			-DENABLE_PYTHON_API=ON
			-DENABLE_PYTHON=ON
			-DENABLE_SAMPLES=OFF
			-DENABLE_TESTS=OFF
			-DENABLE_WHEEL=ON
			-DPython3_EXECUTABLE="${PYTHON}"
		)

einfo "Configuring ${EPYTHON} support"
		cmake_src_configure
	}
	python_foreach_impl configure_python_impl
}

src_compile() {
	cmake_src_compile
	compile_python_impl() {
		cmake_src_compile
	}
	python_foreach_impl compile_python_impl
}

get_arch() {
	local arch
	if [[ "${ABI}" == "amd64" ]] ; then
		arch="intel64"
	elif [[ "${ABI}" == "x86" ]] ; then
		arch="ia32"
	elif [[ "${ABI}" == "arm" ]] ; then
		arch="arm"
	elif [[ "${ABI}" == "arm64" ]] ; then
		arch="arm64"
	elif [[ "${ARCH}" == "riscv" ]] && [ "${ABI}" == "lp64d" || "${ABI}" == "lp64" ]] ; then
		arch="riscv64"
	else
eerror "ABI=${ABI} is not supported"
		die
	fi
	echo "${arch}"
}

gen_envd() {
	local arch=$(get_arch)
newenvd - "60${PN}" <<-_EOF_
LDPATH="/usr/$(get_libdir)/openvino/runtime/lib/${arch}"
_EOF_
}

fix_rpaths() {
	local arch=$(get_arch)
	# Fix runtime rpath
	local x
	for x in $(find "${ED}/usr/$(get_libdir)/openvino/runtime/lib/${arch}" -name "*.so") ; do
		patchelf --add-rpath "/usr/$(get_libdir)/openvino/runtime/lib/${arch}" "${x}" || die
	done
	for x in $(find "${ED}/usr/$(get_libdir)/openvino/deployment_tools/inference_engine/lib/${arch}" -name "*.so") ; do
		patchelf --add-rpath "/usr/$(get_libdir)/openvino/deployment_tools/inference_engine/lib/${arch}" "${x}" || die
	done

	# Fix bindings rpath
	fix_rpath_python_impl() {
		for x in $(find "${ED}/usr/$(get_libdir)/openvino/python/${EPYTHON}" -name "*.so") ; do
			patchelf --add-rpath "/usr/$(get_libdir)/openvino/python/${EPYTHON}/runtime/lib/${arch}" "${x}" || die
		done
	}
	python_foreach_impl fix_rpath_python_impl
}

src_install() {
	export LIBDIR=$(get_libdir)
	cmake_src_install
	install_python_impl() {
		local python_tag="${EPYTHON/python/}"
		python_tag="cp${python_tag/./}"
		export PYTHON_TAG="${python_tag}"
		cmake_src_install

		local wheel_path
		local d="${WORKDIR}/${PN}-${PV}_${EPYTHON}/install"

		local wheel_dir="${WORKDIR}/${PN}-${PV}_build-${EPYTHON/./_}/wheels"
		if use runtime ; then
			wheel_path=$(realpath "${wheel_dir}/openvino-${PV}-"*".whl")
			distutils_wheel_install "${d}" \
				"${wheel_path}"
		fi

		if use development-tools ; then
			wheel_path=$(realpath "${wheel_dir}/openvino_dev-${PV}-"*".whl")
			distutils_wheel_install "${d}" \
				"${wheel_path}"
		fi

		multibuild_merge_root "${d}" "${D%/}"

		local suffix=$(${EPYTHON} -c "import distutils.sysconfig;print(distutils.sysconfig.get_config_var('EXT_SUFFIX'))")

#		dosym \
#			"/usr/$(get_libdir)/openvino/python/${EPYTHON}/python/_pyngraph${suffix}" \
#			"/usr/lib/${EPYTHON}/site-packages/_pyngraph${suffix}"
#		dosym \
#			"/usr/$(get_libdir)/openvino/python/${EPYTHON}/python/ngraph" \
#			"/usr/lib/${EPYTHON}/site-packages/ngraph"
#		dosym \
#			"/usr/$(get_libdir)/openvino/python/${EPYTHON}/python/openvino" \
#			"/usr/lib/${EPYTHON}/site-packages/openvino"
	}
	python_foreach_impl install_python_impl
	docinto "licenses"
	dodoc "LICENSE"
	rm -rf "${ED}/var"
	gen_envd
	fix_rpaths
}

pkg_postinst() {
	if use telemetry ; then
elog
elog "You have enabled telemetry.  To opt-out and to see the data retention policy, see"
elog
elog "https://github.com/openvinotoolkit/openvino/blob/2024.2.0/docs/articles_en/about-openvino/additional-resources/telemetry.rst"
elog
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
