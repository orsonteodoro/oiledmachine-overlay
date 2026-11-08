# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild contains AI generated edits/suggestions and synthetic data.

#
# Live and latest release is only supported on oiledmachine-overlay.  Reasons:
#
# * For miscompilation mitigation and version alignment with ROCm/llvm-project
# * For ROCm/amdgpu (aka out of tree kernel driver's) version alignment and
#   for security mitigation.
# * To simplify packaging with monolithic ebuild with 50+ vendored packages.
# * To prevent the distro gstreamer ebuild scenario, where there is a long run
#   unpatched vulnerabilities caused by many split ebuilds due to the wrong design
#   choice, laziness, testing excuses, slave labor menial human labor preference
#   over rule based automation or AI.  More ebuilds creates more maintenance
#   debt and more code review rejection excuses by insider threats that prevent
#   remediation.
#

# The following commit is chosen if all are true:
# "TheRock Multi-Arch CI ASAN Nightly" passed in rocm-systems, rocm-libraries
# >= 170/200 checks passed

# CI: U22, U24

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CXX_STANDARD=20 # Most default to 17 but some default to 20
LLVM_SLOT=24
PYTHON_COMPAT=( "python3_"{11..15} )
ROCM_SLOT=$(ver_cut "1-2" "${PV}")

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX20[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	#"${LIBCXX_COMPAT_STDCXX20[@]}" # 21-23
	24 # Align with HIP-Clang
)

inherit ccache-changes cflags-hardened check-compiler-switch cmake dep-prepare flag-o-matic git-r3 libcxx-slot libstdcxx-slot python-r1 secure-version rocm-r1

if [[ "${PV}" == *"9999" ]] ; then
	EGIT_REPO_URI="https://github.com/ROCm/TheRock.git"

	FALLBACK_BRANCH_ROCM_THEROCK="main"
	FALLBACK_COMMIT_ROCM_THEROCK="ac008259bb0d7be08d4a2ce36dab2e46383c9e63" # Oct 16, 2026 217/258

	FALLBACK_BRANCH_ROCM_LIBRARIES="develop"
	FALLBACK_COMMIT_ROCM_LIBRARIES="1702865a2f3950fba359989c74ca90263d245003" # Nov 6, 2026 163/210

	FALLBACK_BRANCH_ROCM_SYSTEMS="develop"
	FALLBACK_COMMIT_ROCM_SYSTEMS="704b5fd969e19a073d26859afb54db8085479e22" # Nov 5, 2026 171/203

	FALLBACK_BRANCH_ROCM_LLVM_PROJECT="amd-staging"
	FALLBACK_COMMIT_ROCM_LLVM_PROJECT="f8774c12732b96eec64050d1ea61dec531bdbde5" # Nov 8, 2026 59/97

	if [[ "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	# For TheRock
	AMD_MESA_COMMIT="29299f8d651b9e1c9ce5f7256b3cdcd492c6f4f3"
	HALF_COMMIT="207ee58595a64b5c4a70df221f1e6e704b807811"
	HIPIFY_COMMIT="0e051929fe80ccc0af6dc194ddb990aa82eec97d"
	LIBHIPCXX_COMMIT="4b8124417170bfb869d7ab84f380479cec15d04a"
	LLVM_PROJECT_COMMIT="d6f6cb691863e9258034ab48c1dfce21689d5606"
	ROCM_CMAKE_COMMIT="10155d7272ea1bf79f6b5a9dbc339657af1aa372"
	ROCM_DOCS_COMMIT="0682a17b3aabea3e447c969c8e28ab5f199a0e3c"
	ROCM_LIBRARIES_COMMIT="39d8d60365d2272a5366f76ccb3bfba24b219eaf"
	ROCM_SYSTEMS_COMMIT="7da43026e4f2ef7600433c38c820732f7a205d22"
	ROCGDB_COMMIT="7e541ef6fe7d5ad8172cf227656103f22f975226"
	SPIRV_LLVM_TRANSLATOR_COMMIT="4fd57e737272d1a9077a7ff874961bbc82af2024"

	# For rocm-libraries
	FFTS_COMMIT="b22d839b61c5bd8a993e24ae3e01f39d9b5084fb"
	GOOGLETEST_COMMIT_4="e2239ee6043f73722e7aa812a459f54a28552929"
	MIFIN_COMMIT="06650bddfe40c47294b0414e4262691333b788dd"

	# For rocm-systems
	ABSEIL_CPP_COMMIT="255c84dadd029fd8ad25c5efb5933e47beaa00c7"
	CEREAL_COMMIT="40a30defcb8874270a04836d316502b08904b2bc"
	DOXYGEN_AWESOME_CSS_COMMIT="df83fbf22cfff76b875c13d324baf584c74e96d0"
	DYNINST_COMMIT="d5adcef5fb64965beee445d16ce2a6f2c08c2496"
	ELFIO_COMMIT="575bfdb12cd90fa8913660295103549f151d116a"
	FILESYSTEM_COMMIT_1="8a2edd6d92ed820521d42c94d179462bf06b5ed3"
	FILESYSTEM_COMMIT_2="8a2edd6d92ed820521d42c94d179462bf06b5ed3"
	FMT_COMMIT_1="407c905e45ad75fc29bf0f9bb7c5c2fd3475976f"
	FMT_COMMIT_2="123913715afeb8a437e6388b4473fcc4753e1c9a"
	FMT_COMMIT_3="1be298e1bd68957e4cd352e1f676f00e07dcfb57"
	FMT_COMMIT_4="407c905e45ad75fc29bf0f9bb7c5c2fd3475976f"
	GLOG_COMMIT="7b134a5c82c0c0b5698bb6bf7a835b230c5638e4"
	GOOGLETEST_COMMIT_1="46db91ef6ffcc128b2d5f31118ae1108109e3400"
	GOOGLETEST_COMMIT_2="6ec14dfd8c409d05fba94e18e3a02df35b874353"
	GOOGLETEST_COMMIT_3="52eb8108c5bdec04579160ae17225d66034bd723"
	GOTCHA_COMMIT="b944da10ff9b3364ef2e4b12e02cb2464e05dd48"
	#JSON_COMMIT_1="" # Removed in 5ffe6a3
	JSON_COMMIT_2="e41905fcb0938a7502d25ea5242c6b41396e21b0"
	JSON_COMMIT_3="55f93686c01528224f448c19128836e7df245f72"
	JSON_COMMIT_4="98386eb08b609c172f9f4bf3e74c8d18c5ad583c"
	KOKKOS_COMMIT="1a0c2ff6daf1068c65529ec04c2c046177847869"
	#MSCCLPP_COMMIT="" # Removed in 5ffe6a3
	ONETBB_COMMIT="f1862f38f83568d96e814e469ab61f88336cc595"
	OPENCODE_COMMIT="a35b8a95c27d28e979a3826e1289d7ee87f40251"
	PAPI_COMMIT="c27003e1642f1c151c9b18ef9e7610072b3c852d"
	PERFETTO_COMMIT_1="eb5ef24c58d13cec289d733d03f0f3f0ed321b12"
	PERFETTO_COMMIT_2="eb5ef24c58d13cec289d733d03f0f3f0ed321b12"
	PERFETTO_COMMIT_3="35b3d9845c2f4017865c4dc93fafcf6d202f1651"
	PTL_COMMIT="48df41625430d27ce43cf197fd467a8dda87cb45"
	PYBIND11_COMMIT_1="914c06fb252b6cc3727d0eedab6736e88a3fcb01"
	PYBIND11_COMMIT_2="1a917f1852eb7819b671fc3fa862840f4c491a07"
	PYYAML_COMMIT="49790e73684bebad1df05ef8d828fa12f685bffb"
	SPDLOG_COMMIT="79524ddd08a4ec981b7fea76afd08ee05f83755d"
	SQLITE_COMMIT="f5fb820c0f4781337faf02ed871be68d13a83d94"
	TIMEMORY_COMMIT="0bd2e58a3543f0535aceb4a88804b7f343937b89"
	YAML_CPP_COMMIT="7b469b4220f96fb3d036cf68cd7bd30bd39e61d2"

	KEYWORDS="~amd64"
	S="${WORKDIR}/rocm-systems-${PV}"
	SRC_URI="

https://github.com/ROCm/TheRock/archive/refs/tags/therock-${PV}.tar.gz
	-> TheRock-${PV}.tar.gz

https://github.com/ROCm/rocm-systems/archive/${ROCM_SYSTEMS_COMMIT}.tar.gz
	-> rocm-systems-${ROCM_SYSTEMS_COMMIT:0:7}.tar.gz
https://github.com/ROCm/rocm-docs/archive/${ROCM_DOCS_COMMIT}.tar.gz
	-> rocm-docs-${ROCM_DOCS_COMMIT:0:7}.tar.gz
https://github.com/ROCm/rocm-libraries/archive/${ROCM_LIBRARIES_COMMIT}.tar.gz
	-> rocm-libraries-${ROCM_LIBRARIES_COMMIT:0:7}.tar.gz

https://github.com/ROCm/MIFin/archive/${MIFIN_COMMIT}.tar.gz
	-> MIFin-${MIFIN_COMMIT:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_4}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_4:0:7}.tar.gz
https://github.com/anthonix/ffts/archive/${FFTS_COMMIT}.tar.gz
	-> ffts-${FFTS_COMMIT:0:7}.tar.gz

https://github.com/abseil/abseil-cpp/archive/${ABSEIL_CPP_COMMIT}.tar.gz
	-> abseil-cpp-${ABSEIL_CPP_COMMIT:0:7}.tar.gz
https://github.com/fmtlib/fmt/archive/${FMT_COMMIT_1}.tar.gz
	-> fmt-${FMT_COMMIT_1:0:7}.tar.gz
https://github.com/fmtlib/fmt/archive/${FMT_COMMIT_2}.tar.gz
	-> fmt-${FMT_COMMIT_2:0:7}.tar.gz
https://github.com/fmtlib/fmt/archive/${FMT_COMMIT_3}.tar.gz
	-> fmt-${FMT_COMMIT_3:0:7}.tar.gz
https://github.com/fmtlib/fmt/archive/${FMT_COMMIT_4}.tar.gz
	-> fmt-${FMT_COMMIT_4:0:7}.tar.gz
https://github.com/gabime/spdlog/archive/${SPDLOG_COMMIT}.tar.gz
	-> spdlog-${SPDLOG_COMMIT:0:7}.tar.gz
https://github.com/google/glog/archive/${GLOG_COMMIT}.tar.gz
	-> glog-${GLOG_COMMIT:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_1}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_1:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_2}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_2:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_3}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_3:0:7}.tar.gz
https://github.com/google/perfetto/archive/${PERFETTO_COMMIT_1}.tar.gz
	-> perfetto-${PERFETTO_COMMIT_1:0:7}.tar.gz
https://github.com/google/perfetto/archive/${PERFETTO_COMMIT_2}.tar.gz
	-> perfetto-${PERFETTO_COMMIT_2:0:7}.tar.gz
https://github.com/google/perfetto/archive/${PERFETTO_COMMIT_3}.tar.gz
	-> perfetto-${PERFETTO_COMMIT_3:0:7}.tar.gz
https://github.com/gulrak/filesystem/archive/${FILESYSTEM_COMMIT_1}.tar.gz
	-> gulrak-filesystem-${FILESYSTEM_COMMIT_1:0:7}.tar.gz
https://github.com/gulrak/filesystem/archive/${FILESYSTEM_COMMIT_2}.tar.gz
	-> gulrak-filesystem-${FILESYSTEM_COMMIT_2:0:7}.tar.gz
https://github.com/icl-utk-edu/papi/archive/${PAPI_COMMIT}.tar.gz
	-> papi-${PAPI_COMMIT:0:7}.tar.gz
https://github.com/jbeder/yaml-cpp/archive/${YAML_CPP_COMMIT}.tar.gz
	-> jbeder-yaml-cpp-${YAML_CPP_COMMIT:0:7}.tar.gz
https://github.com/jothepro/doxygen-awesome-css/archive/${DOXYGEN_AWESOME_CSS_COMMIT}.tar.gz
	-> doxygen-awesome-css-${DOXYGEN_AWESOME_CSS_COMMIT:0:7}.tar.gz
https://github.com/jrmadsen/cereal/archive/${CEREAL_COMMIT}.tar.gz
	-> cereal-${CEREAL_COMMIT:0:7}.tar.gz
https://github.com/jrmadsen/PTL/archive/${PTL_COMMIT}.tar.gz
	-> PTL-${PTL_COMMIT:0:7}.tar.gz
https://github.com/kokkos/kokkos/archive/${KOKKOS_COMMIT}.tar.gz
	-> kokkos-${KOKKOS_COMMIT:0:7}.tar.gz
https://github.com/nlohmann/json/archive/${JSON_COMMIT_2}.tar.gz
	-> nlohmann-json-${JSON_COMMIT_2:0:7}.tar.gz
https://github.com/nlohmann/json/archive/${JSON_COMMIT_3}.tar.gz
	-> nlohmann-json-${JSON_COMMIT_3:0:7}.tar.gz
https://github.com/nlohmann/json/archive/${JSON_COMMIT_4}.tar.gz
	-> nlohmann-json-${JSON_COMMIT_4:0:7}.tar.gz
https://github.com/pybind/pybind11/archive/${PYBIND11_COMMIT_1}.tar.gz
	-> pybind11-${PYBIND11_COMMIT_1:0:7}.tar.gz
https://github.com/pybind/pybind11/archive/${PYBIND11_COMMIT_2}.tar.gz
	-> pybind11-${PYBIND11_COMMIT_2:0:7}.tar.gz
https://github.com/ROCm/dyninst/archive/${DYNINST_COMMIT}.tar.gz
	-> dyninst-${DYNINST_COMMIT:0:7}.tar.gz
https://github.com/ROCm/GOTCHA/archive/${GOTCHA_COMMIT}.tar.gz
	-> GOTCHA-${GOTCHA_COMMIT:0:7}.tar.gz
https://github.com/ROCm/timemory/archive/${TIMEMORY_COMMIT}.tar.gz
	-> timemory-${TIMEMORY_COMMIT:0:7}.tar.gz
https://github.com/serge1/ELFIO/archive/${ELFIO_COMMIT}.tar.gz
	-> ELFIO-${ELFIO_COMMIT:0:7}.tar.gz
https://github.com/sqlite/sqlite/archive/${SQLITE_COMMIT}.tar.gz
	-> sqlite-${SQLITE_COMMIT:0:7}.tar.gz
https://github.com/sst/opencode/archive/${OPENCODE_COMMIT}.tar.gz
	-> opencode-${OPENCODE_COMMIT:0:7}.tar.gz
https://github.com/uxlfoundation/oneTBB/archive/${ONETBB_COMMIT}.tar.gz
	-> oneTBB-${ONETBB_COMMIT:0:7}.tar.gz
https://github.com/yaml/pyyaml/archive/${PYYAML_COMMIT}.tar.gz
	-> pyyaml-${PYYAML_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="The HIP Environment and ROCm Kit - A lightweight open source build system for HIP and ROCm"
HOMEPAGE="
	https://github.com/ROCm/TheRock
	https://github.com/ROCm/rocm-docs
	https://github.com/ROCm/rocm-libraries
	https://github.com/ROCm/rocm-systems
"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
	(
		(
			all-rights-reserved
			Apache-2.0
		)
		Apache-2.0
		BSD
		BSD-2
		custom
	)
	Apache-2.0
	Apache-2.0-with-LLVM-exceptions
	BSD
	BSD-2
	custom
	GPL-2
	LGPL-2.1
	LGPL-2.1+
	MIT
	public-domain
	PSF-2
	UoI-NCSA
"
# (all-rights-reserved Apache-2.0), Apache-2.0, BSD, BSD-2, custom - perfetto
# (all-rights-reserved MIT), Apache-2.0-with-LLVM-exceptions, UoI-NCSA, MIT - hipthreads
# all-rights-reserved, MIT - rocwmma
# Apache-2.0, BSD-2, MIT, public-domain - miopen
# Apache-2.0-with-LLVM-exceptions - ROCm/llvm-project
# BSD, MIT - hipblas
# BSD, MIT, PSF-2 - rocprofiler-compute
# custom, LGPL-2.1 - GOTCHA
# custom, MIT - rocdecode
# GPL-2 - ROCgdb
# LGPL-2.1+, LGPL-2.1+ public-domain (sha1.C) - dyninst
# MIT - TheRock
# public-domain - sqlite
# The distro does not have a Apache-2.0 license template with all rights reserved.
# The distro does not have a MIT license template with all rights reserved.
# The distro does have a BSD license template with all rights reserved.
RESTRICT="mirror" # Prevent snooping and speed up downloads
SLOT="0/${ROCM_SLOT}"
IUSE+=" test
ebuild_revision_0
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"
BANNED_RDEPEND="
	!dev-build/rocm-cmake
	!dev-libs/rocm-comgr
	!dev-libs/rocm-opencl-runtime
	!dev-util/HIPIFY
	!dev-util/hipify-clang
	!dev-util/ROCgdb
	!sys-devel/llvm-roc
	!sys-devel/llvm-roc-symlinks
	!sys-devel/llvm-roc-libomp

	!dev-util/Tensile
	!sci-libs/composable-kernel
	!sci-libs/hipBLAS
	!sci-libs/hipBLASLt
	!sci-libs/hipCUB
	!sci-libs/hipFFT
	!sci-libs/hipRAND
	!sci-libs/hipSOLVER
	!sci-libs/hipSPARSE
	!sci-libs/hipSPARSELt
	!sci-libs/hipTensor
	!sci-libs/miopen
	!sci-libs/rocALUTION
	!sci-libs/rocBLAS
	!sci-libs/rocFFT
	!sci-libs/rocPRIM
	!sci-libs/rocRAND
	!sci-libs/rocSOLVER
	!sci-libs/rocSPARSE
	!sci-libs/rocThrust
	!sci-libs/rocWMMA
	!sci-libs/rpp

	!dev-libs/hipother
	!dev-libs/ROCdbgapi
	!dev-libs/rocm-core
	!dev-libs/rocm-debug-agent
	!dev-libs/rocr-runtime
	!dev-libs/rocprofiler-register
	!dev-libs/hsa-amd-aqlprofile
	!dev-util/hip
	!dev-util/amd-smi
	!dev-util/rocm-smi
	!dev-util/rocminfo
	!dev-util/rocprofiler-compute
	!dev-util/rocprofiler-systems
	!dev-util/roctracer
	!media-libs/rocJPEG
	!sci-libs/rocDecode
	!sys-apps/cuid
	!sys-cluster/rdc
	!sys-cluster/rocSHMEM
"
THE_ROCK_PYTHON_DEPEND="
	>=dev-python/cppheaderparser-2.7.4[${PYTHON_USEDEP}]
	>=dev-python/build-1.2.2[${PYTHON_USEDEP}]
	>=dev-python/meson-1.7.0[${PYTHON_USEDEP}]
	~dev-python/packaging-25.0[${PYTHON_USEDEP}]
	>=dev-python/pre-commit-4.3.0[${PYTHON_USEDEP}]
	>=dev-python/python-magic-0.4.27[${PYTHON_USEDEP}]
	~dev-python/pyyaml-6.0.2[${PYTHON_USEDEP}]
	>=dev-python/pyzstd-0.16.0[${PYTHON_USEDEP}]
	>=dev-python/zlib-ng-1.0.0[${PYTHON_USEDEP}]

	>=dev-python/setuptools-80.9.0[${PYTHON_USEDEP}]
	<dev-python/setuptools-82.0.0[${PYTHON_USEDEP}]

	~dev-python/pytest-cmake-0.13.0[${PYTHON_USEDEP}]
	>=dev-python/mako-1.1.3[${PYTHON_USEDEP}]
	>=dev-python/jinja2-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/pyelftools-0.29[${PYTHON_USEDEP}]

	>=dev-python/boto3-1.42.79[${PYTHON_USEDEP}]
	<dev-python/boto3-1.42.85[${PYTHON_USEDEP}]

	>=dev-python/joblib-1.4.2[${PYTHON_USEDEP}]
	>=dev-python/msgpack-1.1.0[${PYTHON_USEDEP}]

	>=dev-python/zstandard-0.19.0[${PYTHON_USEDEP}]

	~dev-python/lit-18.1.8[${PYTHON_USEDEP}]

	~dev-python/psutil-7.1.3[${PYTHON_USEDEP}]

	>=dev-python/cxxheaderparser-1.3.1[${PYTHON_USEDEP}]
"
RDEPEND="
	${BANNED_RDEPEND}
	${THE_ROCK_PYTHON_DEPEND}
	${PYTHON_DEPS}
	sys-apps/hwdata:=
	~virtual/kfd-${PV}:=

"
THEROCK_TEST_DEPEND="
	~dev-python/boto3-1.39.15[${PYTHON_USEDEP}]
	~dev-python/pytest-9.0.3[${PYTHON_USEDEP}]
	~dev-python/pytest-check-2.5.3[${PYTHON_USEDEP}]
	~dev-python/pytest-cov-6.0.0[${PYTHON_USEDEP}]
	~dev-python/pytest-timeout-2.4.0[${PYTHON_USEDEP}]
	~dev-python/perfetto-0.7.0[${PYTHON_USEDEP}]
	~dev-python/pyyaml-6.0.2[${PYTHON_USEDEP}]
	>=dev-python/pyzstd-0.16.0[${PYTHON_USEDEP}]
	>=dev-python/zlib-ng-1.0.0[${PYTHON_USEDEP}]
	~dev-python/prettytable-3.12.0[${PYTHON_USEDEP}]
	~dev-python/requests-2.33.0[${PYTHON_USEDEP}]
	~dev-python/packaging-25.0[${PYTHON_USEDEP}]
	~dev-python/python-debian-1.1.1[${PYTHON_USEDEP}]

	>=dev-python/setuptools-80.9.0[${PYTHON_USEDEP}]
	<dev-python/setuptools-82.0.0[${PYTHON_USEDEP}]

	~dev-python/python-magic-0.4.27[${PYTHON_USEDEP}]

	~dev-python/psutil-7.1.3[${PYTHON_USEDEP}]

	>=dev-python/toml-0.10.2[${PYTHON_USEDEP}]

	~dev-python/cmake-parser-0.9.2[${PYTHON_USEDEP}]
"
BDEPEND="
	${ROCM_GCC_DEPEND}
	>=dev-build/cmake-3.16.8
	dev-util/ccache
	dev-util/patchelf
	virtual/pkgconfig
	test? (
		${THEROCK_TEST_DEPEND}
	)
"
#PATCHES=(
#)

pkg_setup() {
	check-compiler-switch_start
	python_setup
	rocm-r1_pkg_setup
	libstdcxx-slot_verify
	libcxx-slot_verify
einfo "FEATURES:  ${FEATURES}"
	# Chromium: 39-41 MLOC, 1-3 days to build
	# ROCm:  25-30 MLOC, 2+ days to build
	# TensorFlow:  4 MLOC, 2-3 days to build
	# MLOC = Millions Lines of Code
	# The ROCm MLOC estimate is based on ROCm/llvm-projects + rocm-systems + rocm-libraries.
	ccache-changes_yes_ccache "For reducing the rebuild time cost for 50+ heavy packages in this monolithic ebuild."
}

src_unpack() {
	if [[ "${PV}" == *"9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_OVERRIDE_BRANCH_ROCM_THEROCK="${FALLBACK_BRANCH_ROCM_THEROCK}"
			EGIT_OVERRIDE_COMMIT_ROCM_THEROCK="${FALLBACK_COMMIT_ROCM_THEROCK}"

			EGIT_OVERRIDE_BRANCH_ROCM_LIBRARIES="${FALLBACK_BRANCH_ROCM_LIBRARIES}"
			EGIT_OVERRIDE_COMMIT_ROCM_LIBRARIES="${FALLBACK_COMMIT_ROCM_LIBRARIES}"

			EGIT_OVERRIDE_BRANCH_ROCM_SYSTEMS="${FALLBACK_BRANCH_ROCM_SYSTEMS}"
			EGIT_OVERRIDE_COMMIT_ROCM_SYSTEMS="${FALLBACK_COMMIT_ROCM_SYSTEMS}"

			EGIT_OVERRIDE_BRANCH_ROCM_LLVM_PROJECT="${FALLBACK_BRANCH_ROCM_LLVM_PROJECT}"
			EGIT_OVERRIDE_COMMIT_ROCM_LLVM_PROJECT="${FALLBACK_COMMIT_ROCM_LLVM_PROJECT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_prepare() {
	if ! [[ "${PV}" =~ "9999" ]] ; then

		dep_prepare_mv "${WORKDIR}/half-${HALF_COMMIT}" "${S}/base/half"
		dep_prepare_mv "${WORKDIR}/HIPIFY-${HIPIFY_COMMIT}" "${S}/compiler/hipify"
		dep_prepare_mv "${WORKDIR}/llvm-project-${LLVM_PROJECT_COMMIT}" "${S}/compiler/amd-llvm"
		dep_prepare_mv "${WORKDIR}/rocm-cmake-${ROCM_CMAKE_COMMIT}" "${S}/base/rocm-cmake"
		dep_prepare_mv "${WORKDIR}/SPIRV-LLVM-Translator-${SPIRV_LLVM_TRANSLATOR_COMMIT}" "${S}/compiler/spirv-llvm-translator"
		dep_prepare_mv "${WORKDIR}/mesa-fork-${AMD_MESA_COMMIT}" "${S}/third-party/sysdeps/common/mesa-fork"
		dep_prepare_mv "${WORKDIR}/libhipcxx-${LIBHIPCXX_COMMIT}" "${S}/math-libs/libhipcxx"
		dep_prepare_mv "${WORKDIR}/rocgdb-${ROCGDB_COMMIT}" "${S}/debug-tools/rocgdb/source"

		dep_prepare_mv "${WORKDIR}/rocm-docs-${ROCM_DOCS_COMMIT}" "${S}/rocm-docs"
		dep_prepare_mv "${WORKDIR}/rocm-libraries-${ROCM_LIBRARIES_COMMIT}" "${S}/rocm-libraries"
		dep_prepare_mv "${WORKDIR}/rocm-systems-${ROCM_SYSTEMS_COMMIT}" "${S}/rocm-systems"

		dep_prepare_mv "${WORKDIR}/fin-${MIFIN_COMMIT}" "${S}/rocm-libraries/projects/miopen/fin"
		dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_4}" "${S}/rocm-libraries/shared/tensile/HostLibraryTests/googletest"
		dep_prepare_mv "${WORKDIR}/ffts-${FFTS_COMMIT}" "${S}/rocm-libraries/projects/rpp/third_party/ffts"

		dep_prepare_mv "${WORKDIR}/opencode-${OPENCODE_COMMIT}" "${S}/rocm-systems/experimental/python/perfxpert/opencode"
		#dep_prepare_mv "${WORKDIR}/mscclpp-${MSCCLPP_COMMIT}" "${S}/rocm-systems/projects/rccl/ext-src/mscclpp" # Removed in 5ffe6a3
		#dep_prepare_mv "${WORKDIR}/json-${JSON_COMMIT_1}" "${S}/rocm-systems/projects/rccl/ext-src/json" # Removed in 5ffe6a3
		dep_prepare_mv "${WORKDIR}/perfetto-${PERFETTO_COMMIT_1}" "${S}/rocm-systems/projects/rocprofiler/plugin/perfetto/perfetto"
		dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_1}" "${S}/rocm-systems/projects/rocprofiler-sdk/external/googletest"
		dep_prepare_mv "${WORKDIR}/glog-${GLOG_COMMIT}" "${S}/rocm-systems/projects/rocprofiler-register/external/glog"
		dep_prepare_mv "${WORKDIR}/fmt-${FMT_COMMIT_1}" "${S}/rocm-systems/projects/rocprofiler-sdk/external/fmt"
		dep_prepare_mv "${WORKDIR}/fmt-${FMT_COMMIT_2}" "${S}/rocm-systems/projects/rocprofiler-register/external/fmt"
		dep_prepare_mv "${WORKDIR}/doxygen-awesome-css-${DOXYGEN_AWESOME_CSS_COMMIT}" "${S}/rocm-systems/projects/rocprofiler-sdk/external/doxygen-awesome-css"
		dep_prepare_mv "${WORKDIR}/PTL-${PTL_COMMIT}" "${S}/rocm-systems/projects/rocprofiler-sdk/external/ptl"
		dep_prepare_mv "${WORKDIR}/cereal-${CEREAL_COMMIT}" "${S}/rocm-systems/projects/rocprofiler-sdk/external/cereal"
		dep_prepare_mv "${WORKDIR}/filesystem-${FILESYSTEM_COMMIT_1}" "${S}/rocm-systems/projects/rocprofiler-sdk/external/filesystem"
		dep_prepare_mv "${WORKDIR}/perfetto-${PERFETTO_COMMIT_2}" "${S}/rocm-systems/projects/rocprofiler-sdk/external/perfetto"
		dep_prepare_mv "${WORKDIR}/ELFIO-${ELFIO_COMMIT}" "${S}/rocm-systems/projects/rocprofiler-sdk/external/elfio"
		dep_prepare_mv "${WORKDIR}/yaml-cpp-${YAML_CPP_COMMIT}" "${S}/rocm-systems/projects/rocprofiler-sdk/external/yaml-cpp"
		dep_prepare_mv "${WORKDIR}/json-${JSON_COMMIT_2}" "${S}/rocm-systems/projects/rocprofiler-sdk/external/json"
		dep_prepare_mv "${WORKDIR}/sqlite-${SQLITE_COMMIT}" "${S}/rocm-systems/projects/rocprofiler-sdk/external/sqlite"
		dep_prepare_mv "${WORKDIR}/pybind11-${PYBIND11_COMMIT_1}" "${S}/rocm-systems/projects/rocprofiler-sdk/external/pybind11"
		dep_prepare_mv "${WORKDIR}/GOTCHA-${GOTCHA_COMMIT}" "${S}/rocm-systems/projects/rocprofiler-sdk/external/gotcha"
		dep_prepare_mv "${WORKDIR}/timemory-${TIMEMORY_COMMIT}" "${S}/rocm-systems/projects/rocprofiler-systems/external/timemory"
		dep_prepare_mv "${WORKDIR}/perfetto-${PERFETTO_COMMIT_3}" "${S}/rocm-systems/projects/rocprofiler-systems/external/perfetto"
		dep_prepare_mv "${WORKDIR}/dyninst-${DYNINST_COMMIT}" "${S}/rocm-systems/projects/rocprofiler-systems/external/dyninst"
		dep_prepare_mv "${WORKDIR}/kokkos-${KOKKOS_COMMIT}" "${S}/rocm-systems/projects/rocprofiler-systems/examples/lulesh/external/kokkos"
		dep_prepare_mv "${WORKDIR}/papi-${PAPI_COMMIT}" "${S}/rocm-systems/projects/rocprofiler-systems/external/papi"
		dep_prepare_mv "${WORKDIR}/pybind11-${PYBIND11_COMMIT_2}" "${S}/rocm-systems/projects/rocprofiler-systems/external/pybind11"
		dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_2}" "${S}/rocm-systems/projects/rocprofiler-systems/external/googletest"
		dep_prepare_mv "${WORKDIR}/filesystem-${FILESYSTEM_COMMIT_2}" "${S}/rocm-systems/projects/rocprofiler-systems/external/filesystem"
		dep_prepare_mv "${WORKDIR}/spdlog-${SPDLOG_COMMIT}" "${S}/rocm-systems/projects/rocprofiler-systems/external/spdlog"
		dep_prepare_mv "${WORKDIR}/fmt-${FMT_COMMIT_3}" "${S}/rocm-systems/projects/rocprofiler-systems/external/fmt"
		dep_prepare_mv "${WORKDIR}/json-${JSON_COMMIT_3}" "${S}/rocm-systems/projects/rocprofiler-systems/external/json"
		dep_prepare_mv "${WORKDIR}/pyyaml-${PYYAML_COMMIT}" "${S}/rocm-systems/projects/rocprofiler-compute/src/vendored/pyyaml"
		dep_prepare_mv "${WORKDIR}/oneTBB-${ONETBB_COMMIT}" "${S}/rocm-systems/projects/rocprofiler-systems/external/onetbb"
		dep_prepare_mv "${WORKDIR}/abseil-cpp-${ABSEIL_CPP_COMMIT}" "${S}/rocm-systems/projects/rocprofiler-sdk/external/abseil-cpp"
		dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_3}" "${S}/rocm-systems/projects/rocprofiler-compute/src/lib/external/googletest"
		dep_prepare_mv "${WORKDIR}/fmt-${FMT_COMMIT_4}" "${S}/rocm-systems/projects/rocprofiler-compute/src/lib/external/fmt"
		dep_prepare_mv "${WORKDIR}/json-${JSON_COMMIT_4}" "${S}/rocm-systems/projects/rocprofiler-compute/src/lib/external/json"
	fi
	cmake_src_prepare
}

src_configure() {
	rocm-r1_set_default_gcc

	cflags-hardened_append

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if ! check-compiler-switch_is_system_flavor ; then
einfo "Detected GPU compiler switch.  Disabling LTO."
		filter-lto
	fi

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${ROCM_PATH}"
	)

	if [[ -n "${ROCM_TARGETS}" ]] ; then
		mycmakeargs+=(
			# Force the unified build system to only generate code for gfx908
			-DAMDGPU_TARGETS="${ROCM_TARGETS}"
			-DGPU_TARGETS="${ROCM_TARGETS}"

			# Additional optimization flag used by internal components (like hipBLAS / rocBLAS)
			-DROCM_GPU_TARGETS="${ROCM_TARGETS}"
		)
	fi

	mycmakeargs+=(
		# Optional: Disable heavyweight expansion suites you don't need
		#-DBUILD_HPC_SDK=OFF
		#-DBUILD_VISION_SDK=OFF
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
}
