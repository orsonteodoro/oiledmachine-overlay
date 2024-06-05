# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U18, U20

# TODO package:
# kornia
# paddlepaddle
# pytest-dependency
# pytest-html
# test-generator

# For install see
# See https://github.com/openvinotoolkit/openvino/blob/2021.4.2/docs/install_guides/installing-openvino-linux.md#install-external-dependencies

#MKL_DNN_PV="1.6.0"

DISTUTILS_USE_PEP517="setuptools"
CPU_FLAGS_X86=(
	"cpu_flags_x86_avx2"
	"cpu_flags_x86_avx512f"
	"cpu_flags_x86_sse4_2"
)
PYTHON_COMPAT=( "python3_10" ) # 3.6 (U18), 3.8 (U20)

inherit cmake python-any-r1

# Too many deep dependencies
EGIT_BRANCH="master"
EGIT_COMMIT="${PV}"
EGIT_REPO_URI="https://github.com/openvinotoolkit/openvino.git"
inherit git-r3

#KEYWORDS="~amd64 ~arm64 ~x86"
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
	doc gna -lto +mkl-dnn -openmp test +tbb
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
	>=dev-libs/pugixml-1.7
	<dev-cpp/tbb-2021
	video_cards_intel? (
		>=dev-libs/intel-compute-runtime-21.38.21026
	)
"
DEPEND+="
	${RDEPEND}
"
# tests/stress_tests/scripts/requirements.txt \
BDEPEND_STRESS_TESTS="
	$(python_gen_any_dep '
		<dev-python/h5py-3.0.0[${PYTHON_USEDEP}]
		dev-python/pymongo[${PYTHON_USEDEP}]
		dev-python/jinja[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	')
"
# tests/time_tests/scripts/requirements.txt \
BDEPEND_TIME_TESTS_SCRIPTS="
	$(python_gen_any_dep '
		>=dev-python/pyyaml-5.4.1[${PYTHON_USEDEP}]
	')
"
# tests/time_tests/test_runner/requirements.txt \
BDEPEND_TIME_TESTS_TEST_RUNNER="
	$(python_gen_any_dep '
		>=dev-python/pytest-4.0.1[${PYTHON_USEDEP}]
		>=dev-python/attrs-19.1.0[${PYTHON_USEDEP}]
		>=dev-python/PyYAML-5.4.1[${PYTHON_USEDEP}]
		>=dev-python/jsonschema-3.2.0[${PYTHON_USEDEP}]
		>=dev-python/distro-1.5.0[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.18.5[${PYTHON_USEDEP}]
		dev-python/pymongo[${PYTHON_USEDEP}]
		>=dev-python/pytest-html-1.22.1[${PYTHON_USEDEP}]
	')
"
# tests/conditional_compilation/requirements.txt \
BDEPEND_CONDITIONAL_COMPILATION="
	$(python_gen_any_dep '
		>=dev-python/pytest-dependency-0.5.1
	')
"

BDEPEND+="
	>=dev-build/cmake-3.13
	>=sys-devel/gcc-7.5
	doc? (
		$(python_gen_any_dep '
			dev-python/alabaster[${PYTHON_USEDEP}]
			dev-python/Babel[${PYTHON_USEDEP}]
			dev-python/beautifulsoup4[${PYTHON_USEDEP}]
			dev-python/certifi[${PYTHON_USEDEP}]
			dev-python/charset-normalizer[${PYTHON_USEDEP}]
			dev-python/docutils[${PYTHON_USEDEP}]
			dev-python/idna[${PYTHON_USEDEP}]
			dev-python/imagesize[${PYTHON_USEDEP}]
			dev-python/jinja[${PYTHON_USEDEP}]
			dev-python/lxml[${PYTHON_USEDEP}]
			dev-python/MarkupSafe[${PYTHON_USEDEP}]
			dev-python/mistune[${PYTHON_USEDEP}]
			dev-python/packaging[${PYTHON_USEDEP}]
			dev-python/pydata-sphinx-theme[${PYTHON_USEDEP}]
			dev-python/pygments[${PYTHON_USEDEP}]
			dev-python/pyparsing[${PYTHON_USEDEP}]
			dev-python/pytz[${PYTHON_USEDEP}]
			dev-python/requests[${PYTHON_USEDEP}]
			dev-python/snowballstemmer[${PYTHON_USEDEP}]
			dev-python/soupsieve[${PYTHON_USEDEP}]
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx-copybutton[${PYTHON_USEDEP}]
			dev-python/sphinx-inline-tabs[${PYTHON_USEDEP}]
			dev-python/sphinxcontrib-applehelp[${PYTHON_USEDEP}]
			dev-python/sphinxcontrib-devhelp[${PYTHON_USEDEP}]
			dev-python/sphinxcontrib-htmlhelp[${PYTHON_USEDEP}]
			dev-python/sphinxcontrib-jsmath[${PYTHON_USEDEP}]
			dev-python/sphinxcontrib-qthelp[${PYTHON_USEDEP}]
			dev-python/sphinxcontrib-serializinghtml[${PYTHON_USEDEP}]
			dev-python/urllib3[${PYTHON_USEDEP}]
			dev-python/sphinx-sitemap[${PYTHON_USEDEP}]
		')
	)
	test? (
		${BDEPEND_STRESS_TESTS}
		${BDEPEND_TIME_TESTS_SCRIPTS}
		${BDEPEND_TIME_TESTS_TEST_RUNNER}
		${BDEPEND_CONDITIONAL_COMPILATION}
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
		-DCI_BUILD_NUMBER="custom__"
		-DENABLE_AVX2=$(usex cpu_flax_x86_avx2)
		-DENABLE_AVX512F=$(usex cpu_flax_x86_avx512f)
		-DENABLE_BEH_TESTS=OFF
		-DENABLE_CLANG_FORMAT=OFF
		-DENABLE_CLDNN=ON
		-DENABLE_CLDNN_TESTS=OFF
		-DENABLE_COVERAGE=OFF
		-DENABLE_CPPLINT=ON
		-DENABLE_CPPLINT_REPORT=OFF
		-DENABLE_CPU_DEBUG_CAPS=OFF
		-DENABLE_DATA=OFF
		-DENABLE_DOCS=OFF
		-DENABLE_ERROR_HIGHLIGHT=OFF
		-DENABLE_FASTER_BUILD=OFF
		-DENABLE_FUNCTIONAL_TESTS=OFF
		-DENABLE_FUZZING=OFF
		-DENABLE_GAPI_TESTS=OFF
		-DENABLE_GNA=ON
		-DENABLE_INTEGRITYCHECK=OFF
		-DENABLE_LTO=$(usex lto)
		-DENABLE_MKL_DNN=$(usex mkl-dnn)
		-DENABLE_MYRIAD=ON
		-DENABLE_MYRIAD_MVNC_TESTS=OFF
		-DENABLE_MYRIAD_NO_BOOT=OFF
		-DENABLE_OPENCV=ON
		-DENABLE_PROFILING_FILTER=ALL
		-DENABLE_PROFILING_FIRST_INFERENCE=ON
		-DENABLE_PROFILING_ITT=OFF
		-DENABLE_PYTHON=OFF
		-DENABLE_SAME_BRANCH_FOR_MODELS=OFF
		-DENABLE_SAMPLES=ON
		-DENABLE_SANITIZER=OFF
		-DENABLE_SPEECH_DEMO=ON
		-DENABLE_SSE42=$(usex cpu_flax_x86_sse4_2)
		-DENABLE_STRICT_DEPENDENCIES=ON
		-DENABLE_TBB_RELEASE_ONLY=ON
		-DENABLE_TEMPLATE_PLUGIN=OFF
		-DENABLE_TESTS=OFF
		-DENABLE_THREAD_SANITIZER=OFF
		-DENABLE_UNSAFE_LOCATIONS=OFF
		-DENABLE_V7_SERIALIZE=OFF
		-DENABLE_VPU=ON
		-DGAPI_TEST_PERF=OFF
		-DGNA_LIBRARY_VERSION=GNA2
		-DOS_FOLDER=OFF
		-DSELECTIVE_BUILD=OFF
		-DTREAT_WARNING_AS_ERROR=ON
		-DUSE_BUILD_TYPE_SUBFOLDER=ON
		-DUSE_SYSTEM_PUGIXML=ON
		-DVERBOSE_BUILD=OFF
	)

	if [[ "${ARCH}" == "x86" || "${ARCH}" == "arm" ]] ; then
		mycmakelists=(
			-DTHREADING="SEQ"
		)
	else
		mycmakelists=(
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
