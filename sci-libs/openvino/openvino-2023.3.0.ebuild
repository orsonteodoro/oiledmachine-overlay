# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# D9, U18, U20, U22

# TODO package:
# kornia
# natten
# paddlepaddle
# pytest-dependency
# pytest-html
# test-generator

CPU_FLAGS_X86=(
	"cpu_flags_x86_avx2"
	"cpu_flags_x86_avx512f"
	"cpu_flags_x86_sse4_2"
)
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..11} ) # Based on https://github.com/openvinotoolkit/openvino/blob/2023.3.0/docs/dev/build_linux.md#software-requirements

inherit cmake distutils-r1

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
# OpenCL-CLHPP (4a1) has .gitmodules cmock (7cc), Unity (7d2)
# cmock (7cc) has .gitmodules c_exception (dce), unity (031)
# c_exception (dce) has .gitmodules unity (2c7)

SRC_URI="
https://github.com/openvinotoolkit/openvino/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
$(_gen_gh_uri opencv ade 0e8a2ccdd34f29dba55894f5f3c5179809888b9e)
$(_gen_gh_uri herumi xbyak 740dff2e866f3ae1a70dd42d6e8836847ed95cc2)
$(_gen_gh_uri openvinotoolkit open_model_zoo e8fb4cd86a516ce5765290e9665f8afe87b79b2e)
!system-pugixml? (
	$(_gen_gh_uri zeux pugixml 2e357d19a3228c0a301727aac6bea6fecd982d21)
)
!system-snappy? (
	$(_gen_gh_uri google snappy dc05e026488865bc69313a68bcc03ef2e4ea8e83)
	$(_gen_gh_uri google benchmark bf585a2789e30585b4e3ce6baf11ef2750b54677)
	$(_gen_gh_uri google googletest 18f8200e3079b0e54fa00cb7ac55d4c39dcf6da6)
)
$(_gen_gh_uri openvinotoolkit telemetry 58e16c257a512ec7f451c9fccf9ff455065b285b)
$(_gen_gh_uri herumi xbyak 740dff2e866f3ae1a70dd42d6e8836847ed95cc2)
$(_gen_gh_uri ARM-software ComputeLibrary 874e0c7b3fe93a6764ecb2d8cfad924af19a9d25)
$(_gen_gh_uri openvinotoolkit mlas 7a35e48a723944972088627be1a8b60841e8f6a5)
$(_gen_gh_uri openvinotoolkit oneDNN cb3060bbf4694e46a1359a3d4dfe70500818f72d)
$(_gen_gh_uri madler zlib 04f42ceca40f73e2978b50e93806c2a18c1281fc)
!system-protobuf? (
	$(_gen_gh_uri protocolbuffers protobuf fe271ab76f2ad2b2b28c10443865d2af21e27e0e)
	$(_gen_gh_uri google benchmark 5b7683f49e1e9223cf9927b24f6fd3d6bd82e3f8)
	$(_gen_gh_uri google googletest 5ec7f0c4a113e2f18ac2c6cc7df51ad6afc24081)
)
$(_gen_gh_uri onnx onnx b86cc54efce19530fb953e4b21f57e6b3888534c)
!system-opencl? (
	$(_gen_gh_uri KhronosGroup OpenCL-Headers 4c82e9cfaaad18c340f48af3cf5d09ff33e8c1b7)
	$(_gen_gh_uri KhronosGroup OpenCL-CLHPP 4a1157466afe72a87e8abc59537ef577534ccadf)
	$(_gen_gh_uri KhronosGroup OpenCL-ICD-Loader 2cde5d09953a041786d1cfdcb1c08704a82cb904)
	$(_gen_gh_uri ThrowTheSwitch CMock 7cc41ddfdd07dc5eb8359d278f439f14031d64ad)
	$(_gen_gh_uri ThrowTheSwitch Unity 7d2bf62b7e6afaf38153041a9d53c21aeeca9a25)
	$(_gen_gh_uri throwtheswitch cexception dce9e8b26f2179439002e02d691429e81a32b6c0)
	$(_gen_gh_uri throwtheswitch unity 2c7629a0ae90ffe991b5fd08e4db8672f72ed64c)
	$(_gen_gh_uri throwtheswitch unity 031f3bbe45f8adf504ca3d13e6f093869920b091)
)
$(_gen_gh_uri nlohmann json 9cca280a4d0ccf0c08f47a99aa71d1b0e52f8d03)
$(_gen_gh_uri intel ittapi 69dd04030d3a2cf4c32e649ac1f2a628d5af6b46)
$(_gen_gh_uri openvinotoolkit googletest d269d902e4c3cd02f3e731e1e2ff8307352817a4)
$(_gen_gh_uri gflags gflags e171aa2d15ed9eb17054558e0b3a6a413bb01067)
$(_gen_gh_uri gflags gflags 8411df715cf522606e3b1aca386ddfc0b63d34b4 gflags-doc)
!system-flatbuffers? (
	$(_gen_gh_uri google flatbuffers 01834de25e4bf3975a9a00e816292b1ad0fe184b)
)
$(_gen_gh_uri pybind pybind11 2965fa8de3cf9e82c789f906a525a76197b186c1)
$(_gen_gh_uri nithinn ncc 63e59ed312ba7a946779596e86124c1633f67607)
$(_gen_gh_uri oneapi-src oneDNN cb77937ffcf5e83b5d1cf2940c94e8b508d8f7b4)
$(_gen_gh_uri google benchmark 5b7683f49e1e9223cf9927b24f6fd3d6bd82e3f8)
$(_gen_gh_uri google googletest 18f8200e3079b0e54fa00cb7ac55d4c39dcf6da6)
gna? (
	https://storage.openvinotoolkit.org/dependencies/gna/gna_03.05.00.2116.zip
)
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
			https://storage.openvinotoolkit.org/dependencies/thirdparty/linux/oneapi-tbb-2021.2.1-lin-arm64-20231012.tgz
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
	development-tools doc gna -lto +mlas -openmp runtime +samples
	-system-flatbuffers system-opencl system-protobuf system-pugixml
	system-snappy system-tbb test +tbb video_cards_intel
	ebuild-revision-2
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
	mlas? (
		>=sci-libs/mlas-20231105
	)
	system-flatbuffers? (
		>=dev-libs/flatbuffers-23.3.3
	)
	system-opencl? (
		dev-cpp/clhpp
		dev-libs/opencl-icd-loader
		dev-util/opencl-headers
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
BDEPEND_CONSTRAINTS="
	$(python_gen_cond_dep '
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
	$(python_gen_cond_dep '
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
	$(python_gen_cond_dep '
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
	$(python_gen_cond_dep '
		dev-python/natten[${PYTHON_USEDEP}]
	')
"
# tests/time_tests/test_runner/requirements.txt \
BDEPEND_TIME_TESTS_TEST_RUNNER="
	${BDEPEND_CONSTRAINTS}
	$(python_gen_cond_dep '
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
	$(python_gen_cond_dep '
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
	$(python_gen_cond_dep '
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
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/onnxruntime[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/torch[${PYTHON_USEDEP}]
		dev-python/torchvision[${PYTHON_USEDEP}]
		dev-python/transformers[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		kernel_linux? (
			amd64? (
				dev-python/jax[${PYTHON_USEDEP}]
				dev-python/jaxlib[${PYTHON_USEDEP}]
			)
		)
	')
	$(python_gen_cond_dep '
		dev-python/tensorflow-addons[${PYTHON_USEDEP}]
	' python3_10)
"
# tests/time_tests/scripts/requirements.txt \
BDEPEND_TIME_TESTS_SCRIPTS="
	${BDEPEND_CONSTRAINTS}
	$(python_gen_cond_dep '
		dev-python/pyyaml[${PYTHON_USEDEP}]
	')
"
# time_tests/test_runner/requirements.txt \
BDEPEND_TIME_TESTS_TEST_RUNNER="
	${BDEPEND_CONSTRAINTS}
	$(python_gen_cond_dep '
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
	$(python_gen_cond_dep '
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
	$(python_gen_cond_dep '
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
	$(python_gen_cond_dep '
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
		$(python_gen_cond_dep '
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
_PATCHES=(
	"${FILESDIR}/${PN}-2024.1.0-offline-install.patch"
	"${FILESDIR}/${PN}-2024.1.0-dont-delete-archives.patch"
	"A${FILESDIR}/${PN}-2023.3.0-install-paths.patch"
	"${FILESDIR}/${PN}-2024.1.0-set-python-tag.patch"
)

#distutils_enable_sphinx "docs"

pkg_setup() {
	python_setup
}

_unpack_gh() {
	local dest="${1}"
	local org="${2}"
	local project_name="${3}"
	local commit="${4}"
	local alt_name="${5}"
	rm -rf "${dest}"
	mkdir -p "${dest}"
	if [[ -n "${alt_name}" ]] ; then
		cp -aT \
			"${WORKDIR}/${alt_name}-${commit}" \
			"${S}/${dest}" \
			|| die
	else
		cp -aT \
			"${WORKDIR}/${project_name}-${commit}" \
			"${S}/${dest}" \
			|| die
	fi
}

_unpack_gh_dupe() {
	local dupe_path="${1}"
	local dest="${2}"
	rm -rf "${dest}"
	mkdir -p "${dest}"
	cp -aT \
		"${dupe_path}" \
		"${S}/${dest}" \
		|| die
}

precache_resolved_dep() {
	local dest="${1}"
	local filename="${2}"
	local new_name="${3}"
	mkdir -p "${S}/${dest}"
	if [[ -n "${new_name}" ]] ; then
		cp -a $(realpath "${DISTDIR}/${filename}") "${S}/${dest}" || die
	else
		cp -a $(realpath "${DISTDIR}/${filename}") "${S}/${dest}" || die
	fi
}

src_unpack() {
	unpack ${A}
	_unpack_gh "thirdparty/ade" opencv ade 0e8a2ccdd34f29dba55894f5f3c5179809888b9e
	_unpack_gh "thirdparty/xbyak" herumi xbyak 740dff2e866f3ae1a70dd42d6e8836847ed95cc2
	_unpack_gh "thirdparty/open_model_zoo" openvinotoolkit open_model_zoo e8fb4cd86a516ce5765290e9665f8afe87b79b2e
	if ! use system-pugixml ; then
		_unpack_gh "thirdparty/pugixml" zeux pugixml 2e357d19a3228c0a301727aac6bea6fecd982d21
	fi
	if ! use system-snappy ; then
		_unpack_gh "thirdparty/snappy" google snappy dc05e026488865bc69313a68bcc03ef2e4ea8e83
		_unpack_gh "thirdparty/snappy/third_party/benchmark" google benchmark bf585a2789e30585b4e3ce6baf11ef2750b54677
		_unpack_gh "thirdparty/snappy/third_party/googletest" google googletest 18f8200e3079b0e54fa00cb7ac55d4c39dcf6da6
	fi
	_unpack_gh "thirdparty/telemetry" openvinotoolkit telemetry 58e16c257a512ec7f451c9fccf9ff455065b285b
	_unpack_gh "src/plugins/intel_cpu/thirdparty/ComputeLibrary" ARM-software ComputeLibrary 874e0c7b3fe93a6764ecb2d8cfad924af19a9d25
	_unpack_gh "src/plugins/intel_cpu/thirdparty/mlas" openvinotoolkit mlas 7a35e48a723944972088627be1a8b60841e8f6a5
	_unpack_gh "src/plugins/intel_cpu/thirdparty/onednn" openvinotoolkit oneDNN cb3060bbf4694e46a1359a3d4dfe70500818f72d
	_unpack_gh "thirdparty/zlib/zlib" madler zlib 04f42ceca40f73e2978b50e93806c2a18c1281fc
	if ! use system-protobuf ; then
		_unpack_gh "thirdparty/protobuf/protobuf" protocolbuffers protobuf fe271ab76f2ad2b2b28c10443865d2af21e27e0e
		_unpack_gh "thirdparty/protobuf/protobuf/third_party/benchmark" google benchmark 5b7683f49e1e9223cf9927b24f6fd3d6bd82e3f8
		_unpack_gh "thirdparty/protobuf/protobuf/third_party/googletest" google googletest 5ec7f0c4a113e2f18ac2c6cc7df51ad6afc24081
	fi
	_unpack_gh "thirdparty/onnx/onnx" onnx onnx b86cc54efce19530fb953e4b21f57e6b3888534c
	if ! use system-opencl ; then
		_unpack_gh "thirdparty/ocl/cl_headers" KhronosGroup OpenCL-Headers 4c82e9cfaaad18c340f48af3cf5d09ff33e8c1b7
		_unpack_gh "thirdparty/ocl/clhpp_headers" KhronosGroup OpenCL-CLHPP 4a1157466afe72a87e8abc59537ef577534ccadf
		_unpack_gh "thirdparty/ocl/icd_loader" KhronosGroup OpenCL-ICD-Loader 2cde5d09953a041786d1cfdcb1c08704a82cb904
		_unpack_gh "thirdparty/ocl/clhpp_headers/external/CMock" ThrowTheSwitch CMock 7cc41ddfdd07dc5eb8359d278f439f14031d64ad
		_unpack_gh "thirdparty/ocl/clhpp_headers/external/Unity" ThrowTheSwitch Unity 7d2bf62b7e6afaf38153041a9d53c21aeeca9a25 Unity
		_unpack_gh "thirdparty/ocl/clhpp_headers/external/CMock/vendor/c_exception" throwtheswitch cexception dce9e8b26f2179439002e02d691429e81a32b6c0 CException
		_unpack_gh "thirdparty/ocl/clhpp_headers/external/CMock/vendor/c_exception/vendor/unity" throwtheswitch unity 2c7629a0ae90ffe991b5fd08e4db8672f72ed64c Unity
		_unpack_gh "thirdparty/ocl/clhpp_headers/external/CMock/vendor/unity" throwtheswitch unity 031f3bbe45f8adf504ca3d13e6f093869920b091 Unity
	fi
	_unpack_gh "thirdparty/json/nlohmann_json" nlohmann json 9cca280a4d0ccf0c08f47a99aa71d1b0e52f8d03
	_unpack_gh "thirdparty/ittapi/ittapi" intel ittapi 69dd04030d3a2cf4c32e649ac1f2a628d5af6b46
	_unpack_gh "thirdparty/gtest/gtest" openvinotoolkit googletest d269d902e4c3cd02f3e731e1e2ff8307352817a4
	_unpack_gh_dupe "${WORKDIR}/gflags-e171aa2d15ed9eb17054558e0b3a6a413bb01067" "thirdparty/gflags/gflags"
	_unpack_gh_dupe "${WORKDIR}/gflags-8411df715cf522606e3b1aca386ddfc0b63d34b4" "thirdparty/gflags/gflags/doc"
	_unpack_gh "thirdparty/open_model_zoo/demos/thirdparty/gflags" gflags gflags e171aa2d15ed9eb17054558e0b3a6a413bb01067
	_unpack_gh "thirdparty/open_model_zoo/demos/thirdparty/gflags/doc" gflags gflags 8411df715cf522606e3b1aca386ddfc0b63d34b4
	if ! use system-flatbuffers ; then
		_unpack_gh "thirdparty/flatbuffers/flatbuffers" google flatbuffers 01834de25e4bf3975a9a00e816292b1ad0fe184b
	fi
	_unpack_gh "src/bindings/python/thirdparty/pybind11" pybind pybind11 2965fa8de3cf9e82c789f906a525a76197b186c1
	_unpack_gh "cmake/developer_package/ncc_naming_style/ncc" nithinn ncc 63e59ed312ba7a946779596e86124c1633f67607
	_unpack_gh "src/plugins/intel_gpu/thirdparty/onednn_gpu" oneapi-src oneDNN cb77937ffcf5e83b5d1cf2940c94e8b508d8f7b4

	if use tbb ; then
		if use kernel_linux && [[ "${ABI}" == "amd64" ]] ; then
			precache_resolved_dep "temp/download" "tbbbind_2_5_static_lin_v4.tgz" # prebuilt
		fi
	fi
	if use gna ; then
		precache_resolved_dep "temp/download" "gna_03.05.00.2116.zip"
	fi
	if use openmp ; then
		if [[ "${ABI}" == "amd64" ]] ; then
			precache_resolved_dep "temp/download" "iomp-x86-64-7832b16.tgz" "iomp.tgz"
		fi
	fi
	if use tbb && use system-tbb ; then
		if [[ "${ABI}" == "amd64" ]] ; then
			precache_resolved_dep "temp/download" "oneapi-tbb-2021.2.4-lin.tgz"
		elif [[ "${ABI}" == "arm64" ]] ; then
			precache_resolved_dep "temp/download" "oneapi-tbb-2021.2.1-lin-arm64-20231012.tgz"
		fi
	fi
}

python_prepare_all() {
	eapply ${_PATCHES[@]}
	cmake_src_prepare
	distutils-r1_python_prepare_all
}

src_configure() {
	local mycmakeargs
	local _mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
#		-DCI_BUILD_NUMBER="2023.3.0-000--"
		-DCMAKE_COMPILE_WARNING_AS_ERROR=OFF
		-DCMAKE_INSTALL_PREFIX="${PYTHON_SITEDIR}"
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
		-DENABLE_GAPI_PREPROCESSING=ON
		-DENABLE_GPU_DEBUG_CAPS=OFF
		-DENABLE_HETERO=ON
		-DENABLE_INTEGRITYCHECK=OFF
		-DENABLE_INTEL_CPU=ON
		-DENABLE_INTEL_GNA=$(usex gna)
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
		-DENABLE_V7_SERIALIZE=OFF
		-DGAPI_TEST_PERF=OFF
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
	# Native
	mycmakeargs=(
		${_mycmakeargs[@]}
		-DCMAKE_INSTALL_PREFIX="/usr"
		-DENABLE_CPP_API=ON
		-DENABLE_PYTHON_API=OFF
		-DENABLE_PYTHON=OFF
		-DENABLE_SAMPLES=$(usex samples)
		-DENABLE_WHEEL=OFF
	)

einfo "Configuring native support"
	cmake_src_configure

	configure_python_impl() {
einfo "PYTHON_SITEDIR:  $(python_get_sitedir)"
		local python_tag="${EPYTHON/python/}"
		python_tag="cp${python_tag/./}"
		export PYTHON_TAG="${python_tag}"
		mycmakeargs=(
			${_mycmakeargs[@]}
			-DCMAKE_INSTALL_PREFIX="$(python_get_sitedir)"
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

src_install() {
	export LIBDIR=$(get_libdir)
	cmake_src_install
	install_python_impl() {
		local python_tag="${EPYTHON/python/}"
		python_tag="cp${python_tag/./}"
		export PYTHON_TAG="${python_tag}"
		cmake_src_install
		local sitedir="$(python_get_sitedir)"

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
	}
	python_foreach_impl install_python_impl
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
