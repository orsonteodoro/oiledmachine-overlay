# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U18, U20, U22

# TODO package:
# kornia
# natten
# paddlepaddle
# pytest-dependency
# pytest-html
# test-generator

DISTUTILS_USE_PEP517="setuptools"
CPU_FLAGS_X86=(
	"cpu_flags_x86_avx2"
	"cpu_flags_x86_avx512f"
	"cpu_flags_x86_sse4_2"
)
PYTHON_COMPAT=( "python3_"{10..11} ) # Based on https://github.com/openvinotoolkit/openvino/blob/2023.3.0/docs/dev/build_linux.md#software-requirements

inherit cmake python-any-r1

# Too many deep dependencies
EGIT_BRANCH="master"
EGIT_COMMIT="${PV}"
EGIT_REPO_URI="https://github.com/openvinotoolkit/openvino.git"
inherit git-r3

#KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
S="${WORKDIR}/${P}"

DESCRIPTION="OpenVINO™ is an open-source toolkit for optimizing and deploying AI inference"
HOMEPAGE="https://github.com/openvinotoolkit/openvino"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror test" # Missing test dependencies
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
	${CPU_FLAGS_X86[@]}
	doc gna -lto +mlas -openmp -system-flatbuffers test +tbb
	video_cards_intel
"
REQUIRED_USE="
	?? (
		tbb
		openmp
	)
"
RDEPEND+="
	>=app-arch/snappy-1.1.10
	>=dev-libs/pugixml-1.14
	>=dev-libs/protobuf-3.20.3:0/3.21
	dev-cpp/tbb
	mlas? (
		>=sci-libs/mlas-20231105
	)
	system-flatbuffers? (
		>=dev-libs/flatbuffers-23.3.3
	)
	video_cards_intel? (
		>=dev-libs/intel-compute-runtime-21.38.21026
	)
"
DEPEND+="
	${RDEPEND}
"
# tests/constraints.txt \
BDEPEND_CONSTRAINTS="
	$(python_gen_any_dep '
		(
			>=dev-python/numpy-1.16.6[${PYTHON_USEDEP}]
			<dev-python/numpy-1.27[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/tensorflow-2.5[${PYTHON_USEDEP}]
			<dev-python/tensorflow-2.15.0[${PYTHON_USEDEP}]
		)
		(
			>=dev-python/pytest-5.0[${PYTHON_USEDEP}]
			<dev-python/pytest-7.5[${PYTHON_USEDEP}]
		)
		(
			>=sci-libs/pytorch-1.13[${PYTHON_USEDEP}]
			<sci-libs/pytorch-2.2[${PYTHON_USEDEP}]
		)
		>=dev-python/attrs-23.1.0[${PYTHON_USEDEP}]
		>=dev-python/distro-1.8.0[${PYTHON_USEDEP}]
		>=dev-python/h5py-3.1.0[${PYTHON_USEDEP}]
		>=dev-python/jinja-2.11.2[${PYTHON_USEDEP}]
		>=dev-python/pandas-1.3.5[${PYTHON_USEDEP}]
		>=dev-python/pymongo-3.12.0[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-5.4.1[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.11.1[${PYTHON_USEDEP}]
		>=dev-python/wheel-0.38.1[${PYTHON_USEDEP}]
		>=dev-python/defusedxml-0.7.1[${PYTHON_USEDEP}]
		>=dev-python/fastjsonschema-2.17.1[${PYTHON_USEDEP}]
		>=dev-python/test-generator-0.1.2[${PYTHON_USEDEP}]
		>=dev-python/requests-2.25.1[${PYTHON_USEDEP}]
		>=dev-python/paddlepaddle-2.5.0[${PYTHON_USEDEP}]
		>=dev-python/protobuf-python-3.18.1:0/3.21[${PYTHON_USEDEP}]
		>=dev-python/py-1.9.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-dependency-0.5.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-html-4.1.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-timeout-2.1.0[${PYTHON_USEDEP}]
		>=media-libs/opencv-4.5[${PYTHON_USEDEP},python]
		<dev-python/jax-0.4.15[${PYTHON_USEDEP}]
		<dev-python/jaxlib-0.4.15[${PYTHON_USEDEP}]
	')
"
# tests/stress_tests/scripts/requirements.txt \
BDEPEND_STRESS_TESTS="
	${BDEPEND_CONSTRAINTS}
	$(python_gen_any_dep '
		dev-python/pymongo[${PYTHON_USEDEP}]
		dev-python/jinja[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/fastjsonschema[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/h5py[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/defusedxml[${PYTHON_USEDEP}]
	')
"
# tests/model_hub_tests/torch_tests/requirements.txt \
BDEPEND_MODEL_HUB_TESTS_TORCH_TESTS="
	${BDEPEND_CONSTRAINTS}
	$(python_gen_any_dep '
		>=dev-python/auto-gptq-0.5.1[${PYTHON_USEDEP}]
		dev-python/av[${PYTHON_USEDEP}]
		dev-python/basicsr[${PYTHON_USEDEP}]
		dev-python/datasets[${PYTHON_USEDEP}]
		dev-python/facexlib[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/optimum[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/protobuf-python[${PYTHON_USEDEP}]
		dev-python/pyctcdecode[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-html[${PYTHON_USEDEP}]
		dev-python/sacremoses[${PYTHON_USEDEP}]
		dev-python/sentencepiece[${PYTHON_USEDEP}]
		dev-python/soundfile[${PYTHON_USEDEP}]
		dev-python/super-image[${PYTHON_USEDEP}]
		dev-python/timm[${PYTHON_USEDEP}]
		dev-python/torch[${PYTHON_USEDEP}]
		dev-python/torchaudio[${PYTHON_USEDEP}]
		dev-python/torchvision[${PYTHON_USEDEP}]
		dev-python/transformers[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	')
"
# tests/model_hub_tests/torch_tests/requirements_secondary.txt \
BDEPEND_MODEL_HUB_TESTS_TORCH_TESTS_SECONDARY="
	${BDEPEND_CONSTRAINTS}
	$(python_gen_any_dep '
		dev-python/natten[${PYTHON_USEDEP}]
	')
"
# tests/time_tests/test_runner/requirements.txt \
BDEPEND_TIME_TESTS_TEST_RUNNER="
	${BDEPEND_CONSTRAINTS}
	$(python_gen_any_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/py[${PYTHON_USEDEP}]
		dev-python/attrs[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/jsonschema[${PYTHON_USEDEP}]
		dev-python/distro[${PYTHON_USEDEP}]
		dev-python/pymongo[${PYTHON_USEDEP}]
		dev-python/pytest-html[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	')
"
# tests/model_hub_tests/tf_hub_tests/requirements.txt \
BDEPEND_MODEL_HUB_TESTS_TF_HUB_TESTS="
	${BDEPEND_CONSTRAINTS}
	$(python_gen_any_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-html[${PYTHON_USEDEP}]
		dev-python/tensorflow[${PYTHON_USEDEP}]
		dev-python/tensorflow-hub[${PYTHON_USEDEP}]
		dev-python/tensorflow-text[${PYTHON_USEDEP}]
	')
"
# tests/model_hub_tests/performance_tests/requirements.txt \
BDEPEND_MODEL_HUB_TESTS_PERFORMANCE_TESTS="
	${BDEPEND_CONSTRAINTS}
	$(python_gen_any_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-html[${PYTHON_USEDEP}]
		dev-python/tensorflow-hub[${PYTHON_USEDEP}]
		dev-python/py[${PYTHON_USEDEP}]
	')
"
# tests/layer_tests/requirements.txt \
BDEPEND_LAYER_TESTS="
	${BDEPEND_CONSTRAINTS}
	$(python_gen_any_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/onnxruntime[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/torch[${PYTHON_USEDEP}]
		dev-python/torchvision[${PYTHON_USEDEP}]
		dev-python/transformers[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		linux_kernel? (
			amd64? (
				dev-python/jax[${PYTHON_USEDEP}]
				dev-python/jaxlib[${PYTHON_USEDEP}]
			)
		)
	')
	$(python_gen_any_dep '
		dev-python/tensorflow-addons[${PYTHON_USEDEP}]
	' python3_10)
"
# tests/time_tests/scripts/requirements.txt \
BDEPEND_TIME_TESTS_SCRIPTS="
	${BDEPEND_CONSTRAINTS}
	$(python_gen_any_dep '
		dev-python/pyyaml[${PYTHON_USEDEP}]
	')
"
# time_tests/test_runner/requirements.txt \
BDEPEND_TIME_TESTS_TEST_RUNNER="
	${BDEPEND_CONSTRAINTS}
	$(python_gen_any_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/py[${PYTHON_USEDEP}]
		dev-python/attrs[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/jsonschema[${PYTHON_USEDEP}]
		dev-python/distro[${PYTHON_USEDEP}]
		dev-python/pymongo[${PYTHON_USEDEP}]
		dev-python/pytest-html[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	')
"
# tests/memory_tests/test_runner/requirements.txt \
BDEPEND_MEMORY_TESTS_TEST_RUNNER="
	${BDEPEND_CONSTRAINTS}
	$(python_gen_any_dep '
		dev-python/pytest
		dev-python/py[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/pymongo[${PYTHON_USEDEP}]
		dev-python/jsonschema[${PYTHON_USEDEP}]
		dev-python/distro[${PYTHON_USEDEP}]
		dev-python/pytest-html[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
	')
"
# tests/conditional_compilation/requirements.txt \
BDEPEND_CONDITIONAL_COMPILATION="
	${BDEPEND_CONSTRAINTS}
	$(python_gen_any_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/protobuf-python[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-dependency[${PYTHON_USEDEP}]
		dev-python/pytest-html[${PYTHON_USEDEP}]
		dev-python/py[${PYTHON_USEDEP}]
		dev-python/PyYAML[${PYTHON_USEDEP}]
	')
"
# tests/samples_tests/smoke_tests/requirements.txt \
BDEPEND_SAMPLES_TESTS_SMOKE_TESTS="
	${BDEPEND_CONSTRAINTS}
	$(python_gen_any_dep '
		dev-python/requests
		dev-python/pyyaml
		dev-python/wheel
		dev-python/test-generator
		dev-python/numpy
		dev-python/pytest
		dev-python/py
		dev-python/scikit-build
		dev-python/opencv-python-headless
		dev-python/progress
		dev-python/nibabel
		dev-python/scipy
	')
"

BDEPEND+="
	>=dev-build/cmake-3.13
	>=sys-devel/gcc-7.5
	doc? (
		$(python_gen_any_dep '
			>=dev-python/alabaster-0.7.12[${PYTHON_USEDEP}]
			>=dev-python/atomicwrites-1.4.0[${PYTHON_USEDEP}]
			>=dev-python/attrs-22.1.0[${PYTHON_USEDEP}]
			>=dev-python/Babel-2.11.0[${PYTHON_USEDEP}]
			>=dev-python/beautifulsoup4-4.9.3[${PYTHON_USEDEP}]
			>=dev-python/breathe-4.35.0[${PYTHON_USEDEP}]
			>=dev-python/certifi-2023.7.22[${PYTHON_USEDEP}]
			>=dev-python/colorama-0.4.6[${PYTHON_USEDEP}]
			>=dev-python/cython-0.29.33[${PYTHON_USEDEP}]
			>=dev-python/docutils-0.16[${PYTHON_USEDEP}]
			>=dev-python/idna-3.4[${PYTHON_USEDEP}]
			>=dev-python/imagesize-1.2.0[${PYTHON_USEDEP}]
			>=dev-python/importlib-metadata-4.4.0[${PYTHON_USEDEP}]
			>=dev-python/iniconfig-1.1.1[${PYTHON_USEDEP}]
			>=dev-python/ipython-8.10.0[${PYTHON_USEDEP}]
			>=dev-python/jinja-3.1.2[${PYTHON_USEDEP}]
			>=dev-python/lxml-4.9.2[${PYTHON_USEDEP}]
			>=dev-python/markupsafe-2.1.1[${PYTHON_USEDEP}]
			>=dev-python/mistune-2.0.3[${PYTHON_USEDEP}]
			>=dev-python/myst-parser-0.18.1[${PYTHON_USEDEP}]
			>=dev-python/packaging-23.0[${PYTHON_USEDEP}]
			>=dev-python/pluggy-0.13.1[${PYTHON_USEDEP}]
			>=dev-python/pydata-sphinx-theme-0.7.2[${PYTHON_USEDEP}]
			>=dev-python/pygments-2.15.1[${PYTHON_USEDEP}]
			>=dev-python/pyparsing-3.0.9[${PYTHON_USEDEP}]
			>=dev-python/pytest-6.2.5[${PYTHON_USEDEP}]
			>=dev-python/pytest-html-3.1.1[${PYTHON_USEDEP}]
			>=dev-python/pytest-metadata-1.11.0[${PYTHON_USEDEP}]
			>=dev-python/py-1.9.0[${PYTHON_USEDEP}]
			>=dev-python/pytz-2022.7[${PYTHON_USEDEP}]
			>=dev-python/pyyaml-6.0.1[${PYTHON_USEDEP}]
			>=dev-python/requests-2.31.0[${PYTHON_USEDEP}]
			>=dev-python/six-1.15.0[${PYTHON_USEDEP}]
			>=dev-python/snowballstemmer-2.1.0[${PYTHON_USEDEP}]
			>=dev-python/soupsieve-2.2.1[${PYTHON_USEDEP}]
			>=dev-python/sphinx-4.5.0[${PYTHON_USEDEP}]
			>=dev-python/sphinx-copybutton-0.5.1[${PYTHON_USEDEP}]
			>=dev-python/sphinx-design-0.3.0[${PYTHON_USEDEP}]
			>=dev-python/sphinx-inline-tabs-2021.8.17_beta10[${PYTHON_USEDEP}]
			>=dev-python/sphinx-panels-0.6.0[${PYTHON_USEDEP}]
			>=dev-python/sphinx-sitemap-2.2.0[${PYTHON_USEDEP}]
			>=dev-python/sphinxcontrib-applehelp-1.0.2[${PYTHON_USEDEP}]
			>=dev-python/sphinxcontrib-devhelp-1.0.2[${PYTHON_USEDEP}]
			>=dev-python/sphinxcontrib-htmlhelp-2.0.0[${PYTHON_USEDEP}]
			>=dev-python/sphinxcontrib-jsmath-1.0.1[${PYTHON_USEDEP}]
			>=dev-python/sphinxcontrib-qthelp-1.0.3[${PYTHON_USEDEP}]
			>=dev-python/sphinxcontrib-serializinghtml-1.1.5[${PYTHON_USEDEP}]
			>=dev-python/toml-0.10.2[${PYTHON_USEDEP}]
			>=dev-python/urllib3-1.26.18[${PYTHON_USEDEP}]
			>=dev-python/zipp-3.4.1[${PYTHON_USEDEP}]
		')
	)
	test? (
		${BDEPEND_STRESS_TESTS}
		${BDEPEND_MODEL_HUB_TESTS_TORCH_TESTS}
		${BDEPEND_MODEL_HUB_TESTS_TORCH_TESTS_SECONDARY}
		${BDEPEND_MODEL_HUB_TESTS_TF_HUB_TESTS}
		${BDEPEND_MODEL_HUB_TESTS_PERFORMANCE_TESTS}
		${BDEPEND_LAYER_TESTS}
		${BDEPEND_TIME_TESTS_SCRIPTS}
		${BDEPEND_TIME_TESTS_TEST_RUNNER}
		${BDEPEND_MEMORY_TESTS_TEST_RUNNER}
		${BDEPEND_CONDITIONAL_COMPILATION}
		${BDEPEND_SAMPLES_TESTS_SMOKE_TESTS}
	)
"
DOCS=( "README.md" )
PATCHES=(
)

#distutils_enable_sphinx "docs"

pkg_setup() {
	python_setup
}

src_unpack() {
	git-r3_fetch
	git-r3_checkout
}

src_configure() {
	local mycmakelists=(
		-DBUILD_SHARED_LIBS=ON
		-DCI_BUILD_NUMBER="2023.3.0-000--"
		-DCMAKE_COMPILE_WARNING_AS_ERROR=OFF
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
		-DENABLE_GAPI_PREPROCESSING=ON
		-DENABLE_GPU_DEBUG_CAPS=OFF
		-DENABLE_HETERO=ON
		-DENABLE_INTEGRITYCHECK=OFF
		-DENABLE_INTEL_CPU=ON
		-DENABLE_INTEL_GNA=ON
		-DENABLE_INTEL_GNA_DEBUG=OFF
		-DENABLE_INTEL_GPU=$(usex video_cards_intel)
		-DENABLE_IR_V7_READER=OFF
		-DENABLE_LIBRARY_VERSIONING=ON
		-DENABLE_LTO=$(usex lto)
		-DENABLE_MULTI=ON
		-DENABLE_NCC_STYLE=OFF
		-DENABLE_ONEDNN_FOR_GPU=ON
		-DENABLE_OPENVINO_DEBUG=OFF
		-DENABLE_OV_IR_FRONTEND=ON
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
		-DENABLE_SAMPLES=ON
		-DENABLE_SANITIZER=OFF
		-DENABLE_SNAPPY_COMPRESSION=ON
		-DENABLE_SNIPPETS_DEBUG_CAPS=OFF
		-DENABLE_SSE42=$(usex cpu_flags_x86_sse4_2)
		-DENABLE_STRICT_DEPENDENCIES=OFF
		-DENABLE_SYSTEM_FLATBUFFERS=$(usex system-flatbuffers)
		-DENABLE_SYSTEM_OPENCL=ON
		-DENABLE_SYSTEM_PROTOBUF=ON
		-DENABLE_SYSTEM_PUGIXML=ON
		-DENABLE_SYSTEM_SNAPPY=ON
		-DENABLE_SYSTEM_TBB=ON
		-DENABLE_TBB_RELEASE_ONLY=ON
		-DENABLE_TEMPLATE=ON
		-DENABLE_TESTS=OFF
		-DENABLE_THREAD_SANITIZER=OFF
		-DENABLE_UB_SANITIZER=OFF
		-DENABLE_UNSAFE_LOCATIONS=OFF
		-DENABLE_V7_SERIALIZE=OFF
		-DGAPI_TEST_PERF=OFF
		-DOS_FOLDER=OFF
		-DSELECTIVE_BUILD=OFF
		-DUSE_BUILD_TYPE_SUBFOLDER=ON
	)

	if [[ "${ARCH}" == "x86" || "${ARCH}" == "amd64" || "${ARCH}" == "arm64" ]] ; then
		mycmakelists+=(
			-DENABLE_MLAS_FOR_CPU=$(usex mlas)
		)
	else
		mycmakelists+=(
			-DENABLE_MLAS_FOR_CPU=OFF
		)
	fi

	if [[ "${ARCH}" == "riscv" ]] ; then
		mycmakelists=(
			-DENABLE_TBBBIND_2_5=OFF
			-DTHREADING="SEQ"
		)
	else
		mycmakelists=(
			-DENABLE_TBBBIND_2_5=$(usex tbb)
			-DTHREADING=$(usex tbb "TBB" $(usex openmp "OMP" "SEQ"))
		)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
