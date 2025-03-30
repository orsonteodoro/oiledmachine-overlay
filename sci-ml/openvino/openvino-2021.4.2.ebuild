# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U18, U20

# TODO package:
# facexlib
# flake8-annotations-complexity
# flake8-broken-line
# flake8-class-attributes-order
# flake8-debugger
# flake8-eradicate
# flake8-executable
# flake8-expression-complexity
# flake8-print
# flake8-pytest-style
# flake8-rst-docstrings
# flake8-string-format
# flake8-variables-names
# flake8_coding
# flake8_pep3101
# import-order
# pep8-naming
# pytest-dependency
# pytest-html
# python-decouple

# For install, see
# See https://github.com/openvinotoolkit/openvino/blob/2021.4.2/docs/install_guides/installing-openvino-linux.md#install-external-dependencies

# For driver version, see
# https://github.com/openvinotoolkit/openvino/blob/2021.4.2/scripts/install_dependencies/install_NEO_OCL_driver.sh#L24

#MKL_DNN_PV="1.6.0"

CPU_FLAGS_X86=(
	"cpu_flags_x86_avx2"
	"cpu_flags_x86_avx512f"
	"cpu_flags_x86_sse4_2"
)
DISTUTILS_USE_PEP517="setuptools"
GCC_COMPAT=( {12..7} )
PYTHON_COMPAT=( "python3_10" ) # 3.6 (U18), 3.8 (U20)

ADE_COMMIT="58b2595a1a95cc807be8bf6222f266a9a1f393a9"
GFLAGS_1_COMMIT="46f73f88b18aee341538c0dfc22b1710a6abedef"
GFLAGS_2_COMMIT="971dd2a4fadac9cdab174c523c22df79efd63aa5"
GOOGLETEST_COMMIT="9bd163b993459b2ca6ba2dc508577bbc8774c851"
ONEDNN_COMMIT="60f41b3a9988ce7b1bc85c4f1ce7f9443bc91c9d"
XBYAK_COMMIT="8d1e41b650890080fb77548372b6236bbd4079f9"
ZLIB_COMMIT="cacf7f1d4e3d44d871b605da3b647f07d718623f"

inherit cmake dep-prepare distutils-r1 flag-o-matic

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

KEYWORDS="~amd64 ~arm ~arm64"
S="${WORKDIR}/${P}"
# gflags has .gitmodules gitflags-doc (971)
SRC_URI="
https://github.com/openvinotoolkit/openvino/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
$(_gen_gh_uri herumi xbyak ${XBYAK_COMMIT})
$(_gen_gh_uri madler zlib ${ZLIB_COMMIT})
$(_gen_gh_uri opencv ade ${ADE_COMMIT})
$(_gen_gh_uri openvinotoolkit oneDNN ${ONEDNN_COMMIT})
$(_gen_gh_uri openvinotoolkit googletest ${GOOGLETEST_COMMIT})
$(_gen_gh_uri gflags gflags ${GFLAGS_1_COMMIT})
$(_gen_gh_uri gflags gflags ${GFLAGS_2_COMMIT} gflags-doc)
https://download.01.org/opencv/master/openvinotoolkit/thirdparty/unified/VPU/usb-ma2x8x/firmware_usb-ma2x8x_1875.zip
https://download.01.org/opencv/master/openvinotoolkit/thirdparty/unified/VPU/pcie-ma2x8x/firmware_pcie-ma2x8x_1875.zip
tbb? (
	kernel_linux? (
		amd64? (
			https://download.01.org/opencv/master/openvinotoolkit/thirdparty/linux/tbb2020_20200415_lin_strip.tgz
			https://download.01.org/opencv/master/openvinotoolkit/thirdparty/linux/tbbbind_2_4_static_lin_v2.tgz
		)
	)
)
https://download.01.org/opencv/master/openvinotoolkit/thirdparty/linux/opencv/opencv_4.5.2-076_ubuntu20.txz
https://github.com/onnx/onnx/archive/refs/tags/v1.8.1.tar.gz -> onnx-v1.8.1.tar.gz
https://github.com/protocolbuffers/protobuf/archive/refs/tags/v3.7.1.tar.gz -> protobuf-v3.7.1.tar.gz
https://github.com/pybind/pybind11/archive/refs/tags/v2.5.0.tar.gz -> pybind11-v2.5.0.tar.gz
https://github.com/intel/ittapi/archive/refs/tags/v3.18.6.tar.gz -> ittapi-v3.18.6.tar.gz
gna? (
	gna1? (
		https://download.01.org/opencv/master/openvinotoolkit/thirdparty/unified/GNA/gna_20181120.zip
	)
	gna1_1401? (
		https://download.01.org/opencv/master/openvinotoolkit/thirdparty/unified/GNA/GNA_01.00.00.1401.zip
	)
	gna2? (
		https://download.01.org/opencv/master/openvinotoolkit/thirdparty/unified/GNA/GNA_03.00.00.1377.zip
	)
)
"
# For downloads, grep also RESOLVE_DEPENDENCY in
# cmake/dependencies.cmake
# inference-engine/cmake/vpu_dependencies.cmake
# inference-engine/cmake/dependencies.cmake

DESCRIPTION="OpenVINO™ is an open-source toolkit for optimizing and deploying AI inference"
HOMEPAGE="https://github.com/openvinotoolkit/openvino"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror test" # Missing test dependencies
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
${CPU_FLAGS_X86[@]}
doc gna gna1 gna1_1401 gna2 -lto +mkl-dnn -openmp +samples system-pugixml test
+tbb video_cards_intel
ebuild_revision_3
"
REQUIRED_USE="
	?? (
		tbb
		openmp
	)
	gna? (
		^^ (
			gna1
			gna1_1401
			gna2
		)
	)
"
RDEPEND+="
	(
		>=dev-python/numpy-1.16.6
		<dev-python/numpy-1.20
	)
	>=app-arch/snappy-1.1.10
	>=dev-libs/pugixml-1.7
	<dev-cpp/tbb-2021
	video_cards_intel? (
		>=dev-libs/intel-compute-runtime-19.41.14441
	)
"
DEPEND+="
	${RDEPEND}
"
# tests/stress_tests/scripts/requirements.txt \
BDEPEND_STRESS_TESTS="
	<dev-python/h5py-3.0.0[${PYTHON_USEDEP}]
	dev-python/pymongo[${PYTHON_USEDEP}]
	dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
# tests/time_tests/scripts/requirements.txt \
BDEPEND_TIME_TESTS_SCRIPTS="
	>=dev-python/pyyaml-5.4.1[${PYTHON_USEDEP}]
"
# tests/time_tests/test_runner/requirements.txt \
BDEPEND_TIME_TESTS_TEST_RUNNER="
	>=dev-python/attrs-19.1.0[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-3.2.0[${PYTHON_USEDEP}]
	>=dev-python/distro-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.18.5[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.4.1[${PYTHON_USEDEP}]
	>=dev-python/pytest-4.0.1[${PYTHON_USEDEP}]
	>=dev-python/pytest-html-1.22.1[${PYTHON_USEDEP}]
	dev-python/pymongo[${PYTHON_USEDEP}]
"
# tests/conditional_compilation/requirements.txt \
BDEPEND_CONDITIONAL_COMPILATION="
	>=dev-python/pytest-dependency-0.5.1
"

gen_gcc_bdepend() {
	local s
	for s in ${GCC_COMPAT[@]} ; do
		echo "
			sys-devel/gcc:${s}
		"
	done
}

BDEPEND+="
	>=dev-build/cmake-3.13
	>=sys-devel/gcc-7.5
	dev-util/patchelf
	(
		>=dev-python/python-decouple-3.4[${PYTHON_USEDEP}]
		>=dev-python/setuptools-53.0.0[${PYTHON_USEDEP}]
		>=dev-python/wheel-0.36.2[${PYTHON_USEDEP}]
	)
	(
		>=dev-python/cython-0.29.22[${PYTHON_USEDEP}]
		<dev-python/cython-3[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-python/attrs-19.1.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-4.0.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-html-1.19.0[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/bandit[${PYTHON_USEDEP}]
		dev-python/black[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/flake8-annotations-complexity[${PYTHON_USEDEP}]
		dev-python/flake8-broken-line[${PYTHON_USEDEP}]
		dev-python/flake8-bugbear[${PYTHON_USEDEP}]
		dev-python/flake8-builtins[${PYTHON_USEDEP}]
		dev-python/flake8-class-attributes-order[${PYTHON_USEDEP}]
		dev-python/flake8-commas[${PYTHON_USEDEP}]
		dev-python/flake8-comprehensions[${PYTHON_USEDEP}]
		dev-python/flake8-debugger[${PYTHON_USEDEP}]
		dev-python/flake8-eradicate[${PYTHON_USEDEP}]
		dev-python/flake8-executable[${PYTHON_USEDEP}]
		dev-python/flake8-expression-complexity[${PYTHON_USEDEP}]
		dev-python/flake8-print[${PYTHON_USEDEP}]
		dev-python/flake8-pytest-style[${PYTHON_USEDEP}]
		dev-python/flake8-quotes[${PYTHON_USEDEP}]
		dev-python/flake8-rst-docstrings[${PYTHON_USEDEP}]
		dev-python/flake8-string-format[${PYTHON_USEDEP}]
		dev-python/flake8-variables-names[${PYTHON_USEDEP}]
		dev-python/flake8_coding[${PYTHON_USEDEP}]
		dev-python/flake8_pep3101[${PYTHON_USEDEP}]
		dev-python/import-order[${PYTHON_USEDEP}]
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-python/pep8-naming[${PYTHON_USEDEP}]
		dev-python/radon[${PYTHON_USEDEP}]
	)
	doc? (
		dev-python/alabaster[${PYTHON_USEDEP}]
		dev-python/babel[${PYTHON_USEDEP}]
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/certifi[${PYTHON_USEDEP}]
		dev-python/charset-normalizer[${PYTHON_USEDEP}]
		dev-python/docutils[${PYTHON_USEDEP}]
		dev-python/idna[${PYTHON_USEDEP}]
		dev-python/imagesize[${PYTHON_USEDEP}]
		dev-python/jinja2[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/markupsafe[${PYTHON_USEDEP}]
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
	)
	test? (
		${BDEPEND_CONDITIONAL_COMPILATION}
		${BDEPEND_STRESS_TESTS}
		${BDEPEND_TIME_TESTS_SCRIPTS}
		${BDEPEND_TIME_TESTS_TEST_RUNNER}
	)
	|| (
		$(gen_gcc_bdepend)
	)
"
PDEPEND+="
	test? (
		>=media-libs/opencv-3.4.4.19[${PYTHON_SINGLE_USEDEP},python]
	)
"
DOCS=( "README.md" )
_PATCHES=(
	"${FILESDIR}/${PN}-2024.1.0-offline-install.patch"
	"${FILESDIR}/${PN}-2024.1.0-dont-delete-archives.patch"
	"${FILESDIR}/${PN}-2021.4.2-allow-opencv-download-on-gentoo.patch"
	"${FILESDIR}/${PN}-2021.4.2-local-tarball.patch"
	"${FILESDIR}/${PN}-2021.4.2-fix-wheel.patch"
	"${FILESDIR}/${PN}-2021.4.2-fix-wheel-setup.patch"
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
	dep_prepare_cp "${WORKDIR}/zlib-${ZLIB_COMMIT}" "${S}/thirdparty/zlib/zlib"
	dep_prepare_cp "${WORKDIR}/ade-${ADE_COMMIT}" "${S}/inference-engine/thirdparty/ade"
	dep_prepare_cp "${WORKDIR}/oneDNN-${ONEDNN_COMMIT}" "${S}/inference-engine/thirdparty/mkl-dnn"
	dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_COMMIT}" "${S}/inference-engine/tests/ie_test_utils/common_test_utils/gtest"
	dep_prepare_cp "${WORKDIR}/gflags-${GFLAGS_1_COMMIT}" "${S}/inference-engine/samples/thirdparty/gflags"
	dep_prepare_cp "${WORKDIR}/gflags-${GFLAGS_2_COMMIT}" "${S}/inference-engine/samples/thirdparty/gflags/doc"
	dep_prepare_archive_cp "inference-engine/temp/download/VPU/usb-ma2x8x" "firmware_usb-ma2x8x_1875.zip"
	dep_prepare_archive_cp "inference-engine/temp/download/VPU/pcie-ma2x8x" "firmware_pcie-ma2x8x_1875.zip"
	if use tbb ; then
		if use kernel_linux && [[ "${ABI}" == "amd64" ]] ; then
			dep_prepare_archive_cp "inference-engine/temp/download" "tbb2020_20200415_lin_strip.tgz"
			dep_prepare_archive_cp "inference-engine/temp/download" "tbbbind_2_4_static_lin_v2.tgz"
		fi
	fi
	dep_prepare_archive_cp "inference-engine/temp/download/opencv" "opencv_4.5.2-076_ubuntu20.txz"
	if use gna ; then
		if use gna1 ; then
			dep_prepare_archive_cp "inference-engine/temp/download/GNA" "gna_20181120.zip"
		elif use gna1_1401 ; then
			dep_prepare_archive_cp "inference-engine/temp/download/GNA" "GNA_01.00.00.1401.zip"
		elif use gna2 ; then
			dep_prepare_archive_cp "inference-engine/temp/download/GNA" "GNA_03.00.00.1377.zip"
		fi
	fi
}

python_prepare_all() {
	eapply ${_PATCHES[@]}
	cmake_src_prepare
	distutils-r1_python_prepare_all
}

check_cython() {
	local actual_cython_pv=$(cython --version 2>&1 \
		| cut -f 3 -d " " \
		| sed -e "s|a|_alpha|g" \
		| sed -e "s|b|_beta|g" \
		| sed -e "s|rc|_rc|g")
	if [[ "${actual_cython_pv}" == "python-exec" ]] ; then
eerror
eerror "Fix your \`eselect cython\` settings."
eerror
		die
	fi
	local expected_cython_pv="3.0.0"
	local required_cython_major=$(ver_cut 1 ${expected_cython_pv})
	if ver_test ${actual_cython_pv} -ge ${required_cython_major} ; then
eerror
eerror "Switch cython to < ${expected_cython_pv} via eselect-cython"
eerror
eerror "Actual cython version:\t${actual_cython_pv}"
eerror "Expected cython version\t${expected_cython_pv}"
eerror
		die
	fi
}

src_configure() {
	check_cython
	local s
	for s in ${GCC_COMPAT[@]} ; do
		if which "${CHOST}-gcc-${s}" ; then
			export CC="${CHOST}-gcc-${s}"
			export CXX="${CHOST}-g++-${s}"
			export CPP="${CC} -E"
			break
		fi
	done
	gcc --version || die
	strip-unsupported-flags

	local mycmakeargs
	local _mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
#		-DCI_BUILD_NUMBER="custom__"
		-DCMAKE_VERBOSE_MAKEFILE=ON
		-DENABLE_AVX2=$(usex cpu_flags_x86_avx2)
		-DENABLE_AVX512F=$(usex cpu_flags_x86_avx512f)
		-DENABLE_BEH_TESTS=OFF
		-DENABLE_CLANG_FORMAT=OFF
		-DENABLE_CLDNN=OFF # inference-engine/thirdparty/clDNN/src/gpu/configuration.cpp:29:24: error: 'cldnn::custom' has not been declared
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
		-DENABLE_GNA=$(usex gna)
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
		-DENABLE_SAME_BRANCH_FOR_MODELS=OFF
		-DENABLE_SANITIZER=OFF
		-DENABLE_SPEECH_DEMO=ON
		-DENABLE_SSE42=$(usex cpu_flags_x86_sse4_2)
		-DENABLE_STRICT_DEPENDENCIES=ON
		-DENABLE_TBB_RELEASE_ONLY=ON
		-DENABLE_TEMPLATE_PLUGIN=OFF
		-DENABLE_TESTS=OFF
		-DENABLE_THREAD_SANITIZER=OFF
		-DENABLE_UNSAFE_LOCATIONS=OFF
		-DENABLE_V7_SERIALIZE=OFF
		-DENABLE_VPU=ON
		-DGAPI_TEST_PERF=OFF
		-DOFFLINE_INSTALL=ON
		-DOS_FOLDER=OFF
		-DSELECTIVE_BUILD=OFF
		-DTREAT_WARNING_AS_ERROR=OFF
		-DUSE_BUILD_TYPE_SUBFOLDER=ON
		-DUSE_LOCAL_TARBALL=ON
		-DUSE_SYSTEM_PUGIXML=$(usex system-pugixml)
		-DVERBOSE_BUILD=ON
	)

	if [[ "${ARCH}" == "x86" || "${ARCH}" == "arm" ]] ; then
		_mycmakeargs+=(
			-DTHREADING="SEQ"
		)
	elif [[ "${ARCH}" == "arm64" ]] ; then
		_mycmakeargs+=(
			-DENABLE_TBBBIND_2_5=OFF
			-DTHREADING=$(usex openmp "OMP" "SEQ")
		)
	else
		_mycmakeargs+=(
			-DTHREADING=$(usex tbb "TBB" $(usex openmp "OMP" "SEQ"))
		)
	fi

	if use gna1 ; then
		_mycmakeargs+=(
			-DGNA_LIBRARY_VERSION="GNA1"
		)
	elif use gna1_1401 ; then
		_mycmakeargs+=(
			-DGNA_LIBRARY_VERSION="GNA1_1401"
		)
	elif use gna2 ; then
		_mycmakeargs+=(
			-DGNA_LIBRARY_VERSION="GNA2"
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
	else
eerror "ABI=${ABI} is not supported"
		die
	fi
	echo "${arch}"
}

gen_envd() {
	local arch=$(get_arch)
newenvd - "60${PN}" <<-_EOF_
LDPATH="/usr/$(get_libdir)/openvino/deployment_tools/inference_engine/lib/${arch}"
_EOF_
}

fix_rpaths() {
	local arch=$(get_arch)
	# Fix runtime rpath
	local x
	for x in $(find "${ED}/usr/$(get_libdir)/openvino/deployment_tools" -name "*.so") ; do
		patchelf --add-rpath "/usr/$(get_libdir)/openvino/deployment_tools/ngraph/$(get_libdir)" "${x}" || die
	done
	for x in $(find "${ED}/usr/$(get_libdir)/openvino/deployment_tools/inference_engine/lib/${arch}" -name "*.so") ; do
		patchelf --add-rpath "/usr/$(get_libdir)/openvino/deployment_tools/inference_engine/lib/${arch}" "${x}" || die
	done

	# Fix bindings rpath
	fix_rpath_python_impl() {
		for x in $(find "${ED}/usr/$(get_libdir)/openvino/python/${EPYTHON}" -name "*.so") ; do
			patchelf --add-rpath "/usr/$(get_libdir)/openvino/python/${EPYTHON}/deployment_tools/ngraph/$(get_libdir)" "${x}" || die
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

	# It contains just metadata
		local wheel_dir="${WORKDIR}/${PN}-${PV}_build-${EPYTHON/./_}/wheels"
		wheel_path=$(realpath "${wheel_dir}/openvino-"*".whl")
		distutils_wheel_install "${d}" \
			"${wheel_path}"

		multibuild_merge_root "${d}" "${D%/}"

		local suffix=$(${EPYTHON} -c "import distutils.sysconfig;print(distutils.sysconfig.get_config_var('EXT_SUFFIX'))")

		dosym \
			"/usr/$(get_libdir)/openvino/python/${EPYTHON}/python/${EPYTHON}/_pyngraph${suffix}" \
			"/usr/lib/${EPYTHON}/site-packages/_pyngraph${suffix}"
		dosym \
			"/usr/$(get_libdir)/openvino/python/${EPYTHON}/python/${EPYTHON}/ngraph" \
			"/usr/lib/${EPYTHON}/site-packages/ngraph"
		dosym \
			"/usr/$(get_libdir)/openvino/python/${EPYTHON}/python/${EPYTHON}/openvino" \
			"/usr/lib/${EPYTHON}/site-packages/openvino"
	}
	python_foreach_impl install_python_impl
	docinto "licenses"
	dodoc "LICENSE"
	rm -rf "${ED}/var"
	gen_envd
	fix_rpaths
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
