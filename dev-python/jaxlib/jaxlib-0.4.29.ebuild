# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Build/install only progress for 0.4.29:
# CPU - testing
# GPU (rocm) - testing/in-development
# GPU (cuda) - testing/in-development

# FIXME:  fix floating point exception for CPU only for examples
# https://en.wikipedia.org/wiki/Google_JAX#grad
# https://jax.readthedocs.io/en/latest/quickstart.html#jax-as-numpy

# Error of the above problem with https://en.wikipedia.org/wiki/Google_JAX#grad
#Thread 1 "python3.11" received signal SIGFPE, Arithmetic exception.
#0x00007fffebfcc15b in Xbyak::util::Cpu::setCacheHierarchy() () from /usr/lib/python3.11/site-packages/jaxlib/xla_extension.so
#(gdb) bt
#0  0x00007fffebfcc15b in Xbyak::util::Cpu::setCacheHierarchy() () from /usr/lib/python3.11/site-packages/jaxlib/xla_extension.so
#1  0x00007fffec31be7f in dnnl::impl::cpu::platform::get_max_threads_to_use() () from /usr/lib/python3.11/site-packages/jaxlib/xla_extension.so
#2  0x00007fffebfb0f2d in dnnl::impl::threadpool_utils::get_threadlocal_max_concurrency() () from /usr/lib/python3.11/site-packages/jaxlib/xla_extension.so
#3  0x00007fffebf84ed0 in dnnl_threadpool_interop_set_max_concurrency () from /usr/lib/python3.11/site-packages/jaxlib/xla_extension.so
#4  0x00007fffeb395321 in xla::cpu::OneDnnMatMulRewriter::Run(xla::HloModule*, absl::lts_20230802::flat_hash_set<std::basic_string_view<char, std::char_traits<char> >, absl::lts_20230802::container_internal::StringHash, absl::lts_20230802::container_internal::StringEq, std::allocator<std::basic_string_view<char, std::char_traits<char> > > > const&) () from /usr/lib/python3.11/site-packages/jaxlib/xla_extension.so
#5  0x00007fffeb5b3979 in absl::lts_20230802::StatusOr<bool> xla::HloPassPipeline::RunPassesInternal<xla::HloModule>(xla::HloModule*, xla::DebugOptions const&, absl::lts_20230802::flat_hash_set<std::basic_string_view<char, std::char_traits<char> >, absl::lts_20230802::container_internal::StringHash, absl::lts_20230802::container_internal::StringEq, std::allocator<std::basic_string_view<char, std::char_traits<char> > > > const&) () from /usr/lib/python3.11/site-packages/jaxlib/xla_extension.so


# With clang-17 as host compiler:
# FIXME:
#external/boringssl/src/crypto/refcount_c11.c:37:23: error: address argument to atomic operation must be a pointer to a trivially-copyable type ('_Atomic(CRYPTO_refcount_t) *' invalid)
#   37 |   uint32_t expected = atomic_load(count);
#      |                       ^~~~~~~~~~~~~~~~~~
# The current workaround for this is to use gcc and disable the clang USE flag.

# CUDA version:  https://github.com/google/jax/blob/jaxlib-v0.4.29/docs/installation.md?plain=1#L116
# ROCm version:  https://github.com/google/jax/blob/jaxlib-v0.4.29/build/rocm/ci_build.sh#L52

MY_PN="jax"

MAINTAINER_MODE=0

AMDGPU_TARGETS_COMPAT=(
# See https://github.com/google/jax/blob/jaxlib-v0.4.29/.bazelrc#L119
# See https://github.com/google/jax/blob/jaxlib-v0.4.29/build/rocm/Dockerfile.ms#L7C53-L7C89
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx940
	gfx941
	gfx942
	gfx1030
	gfx1100
)
BAZEL_PV="6.5.0"
CFLAGS_HARDENED_USE_CASES="untrusted-data"
CPU_FLAGS_X86_64=(
	cpu_flags_x86_avx
)
CUDA_TARGETS_COMPAT=(
# See https://github.com/google/jax/blob/jaxlib-v0.4.29/.bazelrc#L68
	sm_50
	sm_60
	sm_70
	sm_80
	compute_90
)
DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="standalone"
EGIT_COMMIT="9e62994bce7c7fcbb2f6a50c9ef89526cd2c2be6"
EROCM_SKIP_EXCLUSIVE_LLVM_SLOT_IN_PATH=1
FLAG_O_MATIC_STRIP_UNSUPPORTED_FLAGS=1
GCC_COMPAT=( {11..9} ) # Based on U22, U20
JAVA_SLOT="11"
LLVM_COMPAT=( 17 ) # From .bazelrc
LLVM_MAX_SLOT="${LLVM_COMPAT[0]}"
PYTHON_COMPAT=( "python3_"{11..12} ) # Limited by Flax CI

inherit bazel cflags-hardened check-compiler-switch cuda distutils-r1 dhms flag-o-matic git-r3 hip-versions java-pkg-opt-2
inherit llvm pypi rocm sandbox-changes toolchain-funcs

# DO NOT HARD WRAP
# DO NOT CHANGE TARBALL FILE EXT
# Do not use GH urls if .gitmodules exists in that project
# All hashes and URIs obtained with MAINTAINER_MODE=1 and from console logs with
# FEATURES=-network-sandbox.

# To update:
# Search and replace old PV with new PV
# Search and replace old EGIT_XLA_COMMIT with new EGIT_XLA_COMMIT

APPLE_SUPPORT_PV="1.1.0"	# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/tsl/workspace2.bzl#L534
BAZEL_SKYLIB_PV="1.3.0"		# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/tsl/workspace3.bzl#L23
CPYTHON_X86_64_3_10_PV="20231002:3.10.13+20231002"	# From https://github.com/bazelbuild/rules_python/blob/0.26.0/python/versions.bzl#L285
CPYTHON_X86_64_3_11_PV="20231002:3.11.6+20231002"	# From https://github.com/bazelbuild/rules_python/blob/0.26.0/python/versions.bzl#L285
CPYTHON_X86_64_3_12_PV="20231002:3.12.0+20231002"	# From https://github.com/bazelbuild/rules_python/blob/0.26.0/python/versions.bzl#L285
CUDNN_FRONTEND_PV="1.3.0"	# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/workspace2.bzl#L53
CURL_PV="8.4.0"			# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/tsl/workspace2.bzl#L333
FLATBUFFERS_PV="23.5.26"	# From https://github.com/google/jax/blob/jaxlib-v0.4.29/third_party/flatbuffers/workspace.bzl
JSONCPP_PV="1.9.5"		# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/tsl/workspace2.bzl#L375
NANOBIND_PV="1.9.2"		# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/nanobind/workspace.bzl#L10
NCCL_PV="2.19.3-1"		# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/tsl/workspace2.bzl#L402
ONEDNN_PV="3.2"			# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/tsl/workspace2.bzl#L158
PLATFORMS_PV="0.0.6"		# Delete?
PROTOBUF_PV="3.21.9"		# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/tsl/workspace2.bzl#L294
PYBIND11_PV="2.10.0"		# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/tsl/workspace2.bzl#L563
ROBIN_MAP_PV="1.3.0"		# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/robin_map/workspace.bzl
RULES_ANDROID_PV="0.1.1"	# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/tsl/workspace2.bzl#L512
RULES_APPLE_PV="1.0.1"		# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/tsl/workspace2.bzl#L520
RULES_CC_PV="0.0.2"		# From https://github.com/bazelbuild/bazel/blob/6.5.0/distdir_deps.bzl#L57
RULES_JAVA_PV="5.5.1"		# From https://github.com/bazelbuild/bazel/blob/6.5.0/distdir_deps.bzl#L69
RULES_PKG_PV="0.7.1"		# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/tsl/workspace3.bzl#L34
RULES_PYTHON_PV="0.26.0"	# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/py/python_init_rules.bzl#L10
RULES_SWIFT_PV="1.0.0"		# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/tsl/workspace2.bzl#L533
TRITON_TAG="cl640084124"	# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/triton/workspace.bzl

BUILD_PV="58/91/17b00d5fac63d3dca605f1b8269ba3c65e98059e1fd99d00283e42a454f0:0.10.0"			# From https://github.com/bazelbuild/rules_python/blob/0.26.0/python/pip_install/repositories.bzl#L26
CLICK_PV="00/2e/d53fa4befbf2cfa713304affc7ca780ce4fc1fd8710527771b58311a3229:8.1.7"			# From https://github.com/bazelbuild/rules_python/blob/0.26.0/python/pip_install/repositories.bzl#L31
COLORAMA_PV="d1/d6/3965ed04c63042e047cb6a3e6ed1a63a35087b6a609aa3a15ed8ac56c221:0.4.6"			# From https://github.com/bazelbuild/rules_python/blob/0.26.0/python/pip_install/repositories.bzl#L36
IMPORTLIB_METADATA_PV="cc/37/db7ba97e676af155f5fcb1a35466f446eadc9104e25b83366e8088c9c926:6.8.0"	# From https://github.com/bazelbuild/rules_python/blob/0.26.0/python/pip_install/repositories.bzl#L41
INSTALLER_PV="e5/ca/1172b6638d52f2d6caa2dd262ec4c811ba59eee96d54a7701930726bce18:0.7.0"			# From https://github.com/bazelbuild/rules_python/blob/0.26.0/python/pip_install/repositories.bzl#L46
MORE_ITERTOOLS_PV="5a/cb/6dce742ea14e47d6f565589e859ad225f2a5de576d7696e0623b784e226b:10.1.0"		# From https://github.com/bazelbuild/rules_python/blob/0.26.0/python/pip_install/repositories.bzl#L51
PACKAGING_PV="ab/c3/57f0601a2d4fe15de7a553c00adbc901425661bf048f2a22dfc500caf121:23.1"			# From https://github.com/bazelbuild/rules_python/blob/0.26.0/python/pip_install/repositories.bzl#L56
PEP517_PV="ee/2f/ef63e64e9429111e73d3d6cbee80591672d16f2725e648ebc52096f3d323:0.13.0"			# From https://github.com/bazelbuild/rules_python/blob/0.26.0/python/pip_install/repositories.bzl#L61
PIP_PV="50/c2/e06851e8cc28dcad7c155f4753da8833ac06a5c704c109313b8d5a62968a:23.2.1"			# From https://github.com/bazelbuild/rules_python/blob/0.26.0/python/pip_install/repositories.bzl#L66
PIP_TOOLS_PV="e8/df/47e6267c6b5cdae867adbdd84b437393e6202ce4322de0a5e0b92960e1d6:7.3.0"			# From https://github.com/bazelbuild/rules_python/blob/0.26.0/python/pip_install/repositories.bzl#L71
PYPROJECT_HOOKS_PV="d5/ea/9ae603de7fbb3df820b23a70f6aff92bf8c7770043254ad8d2dc9d6bcba4:1.0.0"		# From https://github.com/bazelbuild/rules_python/blob/0.26.0/python/pip_install/repositories.bzl#L76
SETUPTOOLS_PV="4f/ab/0bcfebdfc3bfa8554b2b2c97a555569c4c1ebc74ea288741ea8326c51906:68.1.2"		# From https://github.com/bazelbuild/rules_python/blob/0.26.0/python/pip_install/repositories.bzl#L81
TOMLI_PV="97/75/10a9ebee3fd790d20926a90a2547f0bf78f371b2f13aa822c759680ca7b9:2.0.1"			# From https://github.com/bazelbuild/rules_python/blob/0.26.0/python/pip_install/repositories.bzl#L86
WHEEL_PV="b8/8b/31273bf66016be6ad22bb7345c37ff350276cfd46e389a0c2ac5da9d9073:0.41.2"			# From https://github.com/bazelbuild/rules_python/blob/0.26.0/python/pip_install/repositories.bzl#L91
ZIPP_PV="8c/08/d3006317aefe25ea79d3b76c9650afabaf6d63d1c8443b236e7405447503:3.16.2"			# From https://github.com/bazelbuild/rules_python/blob/0.26.0/python/pip_install/repositories.bzl#L96

EGIT_ABSEIL_CPP_COMMIT="fb3621f4f897824c0dbe0615fa94543df6192f30"		# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/tsl/third_party/absl/workspace.bzl
EGIT_BAZEL_TOOLCHAINS_COMMIT="8c717f8258cd5f6c7a45b97d974292755852b658"		# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/tsl/workspace1.bzl#L26
EGIT_BORINGSSL_COMMIT="c00d7ca810e93780bd0c8ee4eea28f4f2ea4bcdc"		# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/workspace2.bzl#L55
EGIT_DLPACK_COMMIT="2a7e9f1256ddc48186c86dff7a00e189b47e5310"			# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/dlpack/workspace.bzl
EGIT_DUCC_COMMIT="aa46a4c21e440b3d416c16eca3c96df19c74f316"			# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/tsl/third_party/ducc/workspace.bzl
EGIT_EIGEN_COMMIT="c1d637433e3b3f9012b226c2c9125c494b470ae6"			# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/tsl/third_party/eigen3/workspace.bzl
EGIT_FARMHASH_COMMIT="0d859a811870d10f53a594927d0d0b97573ad06d"			# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/tsl/third_party/farmhash/workspace.bzl
EGIT_GLOO_COMMIT="5354032ea08eadd7fc4456477f7f7c6308818509"			# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/gloo/workspace.bzl
EGIT_LLVM_COMMIT="6f2c61071c274a1b5e212e6ad4114641ec7c7fc3"			# llvm 19 ; From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/llvm/workspace.bzl https://github.com/llvm/llvm-project/blob/6f2c61071c274a1b5e212e6ad4114641ec7c7fc3/cmake/Modules/LLVMVersion.cmake#L4
EGIT_ML_DTYPES_COMMIT="24084d9ed2c3d45bf83b7a9bff833aa185bf9172"		# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/py/ml_dtypes/workspace.bzl
EGIT_MPITRAMPOLINE_COMMIT="25efb0f7a4cd00ed82bafb8b1a6285fc50d297ed"		# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/mpitrampoline/workspace.bzl#L8
EGIT_PYBIND11_ABSEIL_COMMIT="2c4932ed6f6204f1656e245838f4f5eae69d2e29"		# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/tsl/third_party/pybind11_abseil/workspace.bzl
EGIT_PYBIND11_BAZEL_COMMIT="72cbbf1fbc830e487e3012862b7b720001b70672"		# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/tsl/third_party/pybind11_bazel/workspace.bzl
EGIT_RE2_COMMIT="03da4fc0857c285e3a26782f6bc8931c4c950df4"			# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/tsl/workspace2.bzl#L227
EGIT_RULES_CLOSURE_COMMIT="308b05b2419edb5c8ee0471b67a40403df940149"		# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/tsl/workspace3.bzl#L14
EGIT_RULES_PROTO_COMMIT="11bf7c25e666dd7ddacbcd4d4c4a9de7a25175f8"		# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/tsl/workspace0.bzl#L117
EGIT_SNAPPY_COMMIT="984b191f0fefdeb17050b42a90b7625999c13b8d"			# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/tsl/workspace2.bzl#L393
EGIT_STABLEHLO_COMMIT="14e2323f0ee3d308c1384fdb806dc6d0c98b16ca"		# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/stablehlo/workspace.bzl#L7
EGIT_TENSORFLOW_RUNTIME_COMMIT="4662f7552dc2e420ee20361c077b7aeb334a1087"	# From https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/tsl/third_party/tf_runtime/workspace.bzl#L9
EGIT_XLA_COMMIT="32ba408c0e2b7ef5f5821c0781601ba17d467076"			# From https://github.com/google/jax/blob/jaxlib-v0.4.29/third_party/xla/workspace.bzl#L23

#colorama==0.4.6
_PYPI_PACKAGES=(
absl-py==2.1.0
attrs==23.2.0
build==1.2.1
cloudpickle==3.0.0
contourpy==1.2.1
cycler==0.12.1
exceptiongroup==1.2.1
execnet==2.1.1
flatbuffers==24.3.25
fonttools==4.51.0
fsspec==2024.5.0
hypothesis==6.102.4
importlib-resources==6.4.0
iniconfig==2.0.0
kiwisolver==1.4.5
markdown-it-py==3.0.0
matplotlib==3.9.0
mdurl==0.1.2
ml-dtypes==0.4.0
mpmath==1.4.0a1
numpy==2.0.0rc2
opt-einsum==3.3.0
packaging==24.0
pillow==10.3.0
pluggy==1.5.0
portpicker==1.6.0
psutil==5.9.8
pygments==2.18.0
pyparsing==3.1.2
pyproject-hooks==1.1.0
pytest-xdist==3.6.1
pytest==8.2.0
python-dateutil==2.9.0.post0
rich==13.7.1
scipy==1.13.0
setuptools==58.2.0
setuptools==69.5.1
six==1.16.0
sortedcontainers==2.4.0
typing-extensions==4.12.0rc1
wheel==0.43.0
zipp==3.18.2
zstandard==0.22.0
)
#tomli==2.0.1

_PYPI_URLS=""
gen_pypi_uris() {
	local pkg
	for pkg in ${_PYPI_PACKAGES[@]} ; do
		local name="${pkg%%=*}"
		local version="${pkg##*=}"
		local abi
		local platform
		if [[ "${name}" =~ "psutil" ]] ; then
			abi="cp36"
			platform="abi3-manylinux_2_12_x86_64.manylinux2010_x86_64.manylinux_2_17_x86_64.manylinux2014_x86_64"
			_PYPI_URLS+=" $(pypi_wheel_url ${name} ${version} ${abi} ${platform})"
		elif [[ "${name}" =~ ("kiwisolver") ]] ; then
			abi="cp311"
			platform="${abi}-manylinux_2_17_x86_64.manylinux2014_x86_64"
			_PYPI_URLS+=" $(pypi_wheel_url ${name} ${version} ${abi} ${platform})"

			abi="cp312"
			platform="${abi}-manylinux_2_17_x86_64.manylinux2014_x86_64"
			_PYPI_URLS+=" $(pypi_wheel_url ${name} ${version} ${abi} ${platform})"
		elif [[ "${name}" =~ ("contourpy"|"matplotlib"|"ml-dtypes"|"numpy"|"pillow"|"scipy"|"zstandard") ]] ; then
			abi="cp310"
			platform="${abi}-manylinux_2_17_x86_64.manylinux2014_x86_64"
			_PYPI_URLS+=" $(pypi_wheel_url ${name} ${version} ${abi} ${platform})"

			abi="cp311"
			platform="${abi}-manylinux_2_17_x86_64.manylinux2014_x86_64"
			_PYPI_URLS+=" $(pypi_wheel_url ${name} ${version} ${abi} ${platform})"

			abi="cp312"
			platform="${abi}-manylinux_2_17_x86_64.manylinux2014_x86_64"
			_PYPI_URLS+=" $(pypi_wheel_url ${name} ${version} ${abi} ${platform})"
		elif [[ "${name}" =~ ("colorama"|"flatbuffers"|"python-dateutil"|"six"|"sortedcontainers") ]] ; then
			_PYPI_URLS+=" $(pypi_wheel_url ${name} ${version} py2.py3)"
		else
			_PYPI_URLS+=" $(pypi_wheel_url ${name} ${version})"
		fi
	done
}
gen_pypi_uris

bazel_external_uris="
https://curl.haxx.se/download/curl-${CURL_PV}.tar.gz
https://github.com/abseil/abseil-cpp/archive/${EGIT_ABSEIL_CPP_COMMIT}.tar.gz -> abseil-cpp-${EGIT_ABSEIL_CPP_COMMIT}.tar.gz
https://github.com/bazelbuild/apple_support/releases/download/${APPLE_SUPPORT_PV}/apple_support.${APPLE_SUPPORT_PV}.tar.gz -> apple_support-${APPLE_SUPPORT_PV}.tar.gz
https://github.com/bazelbuild/bazel-skylib/releases/download/${BAZEL_SKYLIB_PV}/bazel-skylib-${BAZEL_SKYLIB_PV}.tar.gz -> bazel-skylib-${BAZEL_SKYLIB_PV}.tar.gz
https://github.com/bazelbuild/bazel-toolchains/archive/${EGIT_BAZEL_TOOLCHAINS_COMMIT}.tar.gz -> bazel-toolchains-${EGIT_BAZEL_TOOLCHAINS_COMMIT}.tar.gz
https://github.com/bazelbuild/platforms/releases/download/${PLATFORMS_PV}/platforms-${PLATFORMS_PV}.tar.gz
https://github.com/bazelbuild/rules_android/archive/v${RULES_ANDROID_PV}.zip -> rules_android-${RULES_ANDROID_PV}.zip
https://github.com/bazelbuild/rules_apple/releases/download/${RULES_APPLE_PV}/rules_apple.${RULES_APPLE_PV}.tar.gz -> rules_apple-${RULES_APPLE_PV}.tar.gz
https://github.com/bazelbuild/rules_cc/releases/download/${RULES_CC_PV}/rules_cc-${RULES_CC_PV}.tar.gz -> rules_cc-${RULES_CC_PV}.tar.gz
https://github.com/bazelbuild/rules_closure/archive/${EGIT_RULES_CLOSURE_COMMIT}.tar.gz -> rules_closure-${EGIT_RULES_CLOSURE_COMMIT}.tar.gz
https://github.com/bazelbuild/rules_java/releases/download/${RULES_JAVA_PV}/rules_java-${RULES_JAVA_PV}.tar.gz -> rules_java-${RULES_JAVA_PV}.tar.gz
https://github.com/bazelbuild/rules_pkg/releases/download/${RULES_PKG_PV}/rules_pkg-${RULES_PKG_PV}.tar.gz
https://github.com/bazelbuild/rules_proto/archive/${EGIT_RULES_PROTO_COMMIT}.tar.gz -> rules_proto-${EGIT_RULES_PROTO_COMMIT}.tar.gz
https://github.com/bazelbuild/rules_python/releases/download/${RULES_PYTHON_PV}/rules_python-${RULES_PYTHON_PV}.tar.gz -> rules_python-${RULES_PYTHON_PV}.tar.gz
https://github.com/bazelbuild/rules_swift/releases/download/${RULES_SWIFT_PV}/rules_swift.${RULES_SWIFT_PV}.tar.gz -> rules_swift-${RULES_SWIFT_PV}.tar.gz
https://github.com/dmlc/dlpack/archive/${EGIT_DLPACK_COMMIT}.tar.gz -> dlpack-${EGIT_DLPACK_COMMIT}.tar.gz
https://github.com/eschnett/mpitrampoline/archive/${EGIT_MPITRAMPOLINE_COMMIT}.tar.gz -> mpitrampoline-${EGIT_MPITRAMPOLINE_COMMIT}.tar.gz
https://github.com/google/boringssl/archive/${EGIT_BORINGSSL_COMMIT}.tar.gz -> boringssl-${EGIT_BORINGSSL_COMMIT}.tar.gz
https://github.com/google/farmhash/archive/${EGIT_FARMHASH_COMMIT}.tar.gz -> farmhash-${EGIT_FARMHASH_COMMIT}.tar.gz
https://github.com/google/flatbuffers/archive/v${FLATBUFFERS_PV}.tar.gz -> flatbuffers-${FLATBUFFERS_PV}.tar.gz
https://github.com/google/re2/archive/${EGIT_RE2_COMMIT}.tar.gz -> re2-${EGIT_RE2_COMMIT}.tar.gz
https://github.com/llvm/llvm-project/archive/${EGIT_LLVM_COMMIT}.tar.gz -> llvm-${EGIT_LLVM_COMMIT}.tar.gz
https://github.com/oneapi-src/oneDNN/archive/refs/tags/v${ONEDNN_PV}.tar.gz -> oneDNN-${ONEDNN_PV}.tar.gz
https://github.com/open-source-parsers/jsoncpp/archive/${JSONCPP_PV}.tar.gz -> jsoncpp-${JSONCPP_PV}.tar.gz
https://github.com/openxla/stablehlo/archive/${EGIT_STABLEHLO_COMMIT}.zip -> stablehlo-${EGIT_STABLEHLO_COMMIT}.zip
https://github.com/openxla/xla/archive/${EGIT_XLA_COMMIT}.tar.gz -> openxla-xla-${EGIT_XLA_COMMIT}.tar.gz
https://github.com/pybind/pybind11/archive/v${PYBIND11_PV}.tar.gz -> pybind11-${PYBIND11_PV}.tar.gz
https://github.com/pybind/pybind11_abseil/archive/${EGIT_PYBIND11_ABSEIL_COMMIT}.tar.gz -> pybind11_abseil-${EGIT_PYBIND11_ABSEIL_COMMIT}.tar.gz
https://github.com/tensorflow/runtime/archive/${EGIT_TENSORFLOW_RUNTIME_COMMIT}.tar.gz -> tensorflow-runtime-${EGIT_TENSORFLOW_RUNTIME_COMMIT}.tar.gz
https://github.com/Tessil/robin-map/archive/refs/tags/v${ROBIN_MAP_PV}.tar.gz -> robin-map-${ROBIN_MAP_PV}.tar.gz
https://gitlab.com/libeigen/eigen/-/archive/${EGIT_EIGEN_COMMIT}/eigen-${EGIT_EIGEN_COMMIT}.tar.gz -> eigen-${EGIT_EIGEN_COMMIT}.tar.gz
https://storage.googleapis.com/mirror.tensorflow.org/github.com/facebookincubator/gloo/archive/${EGIT_GLOO_COMMIT}.tar.gz -> gloo-${EGIT_GLOO_COMMIT}.tar.gz
https://storage.googleapis.com/mirror.tensorflow.org/github.com/google/snappy/archive/${EGIT_SNAPPY_COMMIT}.tar.gz -> snappy-${EGIT_SNAPPY_COMMIT}.tar.gz
https://storage.googleapis.com/mirror.tensorflow.org/github.com/jax-ml/ml_dtypes/archive/${EGIT_ML_DTYPES_COMMIT}/ml_dtypes-${EGIT_ML_DTYPES_COMMIT}.tar.gz
https://storage.googleapis.com/mirror.tensorflow.org/github.com/protocolbuffers/protobuf/archive/v${PROTOBUF_PV}.zip -> protobuf-${PROTOBUF_PV}.zip
https://storage.googleapis.com/mirror.tensorflow.org/github.com/pybind/pybind11_bazel/archive/${EGIT_PYBIND11_BAZEL_COMMIT}.tar.gz -> pybind11_bazel-${EGIT_PYBIND11_BAZEL_COMMIT}.tar.gz
https://storage.googleapis.com/mirror.tensorflow.org/github.com/openxla/triton/archive/${TRITON_TAG}.tar.gz -> triton-${TRITON_TAG}.tar.gz
https://storage.googleapis.com/mirror.tensorflow.org/github.com/wjakob/nanobind/archive/refs/tags/v${NANOBIND_PV}.tar.gz -> nanobind-${NANOBIND_PV}.tar.gz
https://storage.googleapis.com/mirror.tensorflow.org/gitlab.mpcdf.mpg.de/mtr/ducc/-/archive/${EGIT_DUCC_COMMIT}/ducc-${EGIT_DUCC_COMMIT}.tar.gz -> ducc-${EGIT_DUCC_COMMIT}.tar.gz
cuda? (
https://github.com/NVIDIA/cudnn-frontend/archive/refs/tags/v${CUDNN_FRONTEND_PV}.zip -> cudnn-frontend-${CUDNN_FRONTEND_PV}.zip
https://github.com/nvidia/nccl/archive/v${NCCL_PV}.tar.gz -> nccl-${NCCL_PV}.tar.gz
)

https://github.com/indygreg/python-build-standalone/releases/download/${CPYTHON_X86_64_3_10_PV%:*}/cpython-${CPYTHON_X86_64_3_10_PV#*:}-x86_64-unknown-linux-gnu-install_only.tar.gz
https://github.com/indygreg/python-build-standalone/releases/download/${CPYTHON_X86_64_3_11_PV%:*}/cpython-${CPYTHON_X86_64_3_11_PV#*:}-x86_64-unknown-linux-gnu-install_only.tar.gz
https://github.com/indygreg/python-build-standalone/releases/download/${CPYTHON_X86_64_3_12_PV%:*}/cpython-${CPYTHON_X86_64_3_12_PV#*:}-x86_64-unknown-linux-gnu-install_only.tar.gz

https://files.pythonhosted.org/packages/${BUILD_PV%:*}/build-${BUILD_PV#*:}-py3-none-any.whl
https://files.pythonhosted.org/packages/${CLICK_PV%:*}/click-${CLICK_PV#*:}-py3-none-any.whl
https://files.pythonhosted.org/packages/${COLORAMA_PV%:*}/colorama-${COLORAMA_PV#*:}-py2.py3-none-any.whl
https://files.pythonhosted.org/packages/${IMPORTLIB_METADATA_PV%:*}/importlib_metadata-${IMPORTLIB_METADATA_PV#*:}-py3-none-any.whl
https://files.pythonhosted.org/packages/${INSTALLER_PV%:*}/installer-${INSTALLER_PV#*:}-py3-none-any.whl
https://files.pythonhosted.org/packages/${MORE_ITERTOOLS_PV%:*}/more_itertools-${MORE_ITERTOOLS_PV#*:}-py3-none-any.whl
https://files.pythonhosted.org/packages/${PACKAGING_PV%:*}/packaging-${PACKAGING_PV#*:}-py3-none-any.whl
https://files.pythonhosted.org/packages/${PEP517_PV%:*}/pep517-${PEP517_PV#*:}-py3-none-any.whl
https://files.pythonhosted.org/packages/${PIP_PV%:*}/pip-${PIP_PV#*:}-py3-none-any.whl
https://files.pythonhosted.org/packages/${PIP_TOOLS_PV%:*}/pip_tools-${PIP_TOOLS_PV#*:}-py3-none-any.whl
https://files.pythonhosted.org/packages/${PYPROJECT_HOOKS_PV%:*}/pyproject_hooks-${PYPROJECT_HOOKS_PV#*:}-py3-none-any.whl
https://files.pythonhosted.org/packages/${SETUPTOOLS_PV%:*}/setuptools-${SETUPTOOLS_PV#*:}-py3-none-any.whl
https://files.pythonhosted.org/packages/${TOMLI_PV%:*}/tomli-${TOMLI_PV#*:}-py3-none-any.whl
https://files.pythonhosted.org/packages/${WHEEL_PV%:*}/wheel-${WHEEL_PV#*:}-py3-none-any.whl
https://files.pythonhosted.org/packages/${ZIPP_PV%:*}/zipp-${ZIPP_PV#*:}-py3-none-any.whl

${_PYPI_URLS}
"
# Has .gitmodules:
# triton

SRC_URI="
	${bazel_external_uris}
https://github.com/google/jax/archive/refs/tags/${PN}-v${PV}.tar.gz
	-> ${MY_PN}-${PV}.tar.gz
https://github.com/openxla/xla/archive/${EGIT_XLA_COMMIT}.zip
	-> openxla-xla-${EGIT_XLA_COMMIT}.zip
"

DESCRIPTION="Support library for JAX"
HOMEPAGE="
https://github.com/google/jax/tree/main/jaxlib
"
LICENSE="
	Apache-2.0
	rocm? (
		custom
		all-rights-reserved
		Apache-2.0
		BSD-2
	)
"
KEYWORDS="~amd64 ~arm64 ~ppc64"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
${ROCM_IUSE}
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${CPU_FLAGS_X86_64[@]}
${LLVM_COMPAT[@]/#/llvm_slot_}
clang cpu cuda debug rocm rocm_6_0
ebuild_revision_12
"
# We don't add tpu because licensing issue with libtpu_nightly.

gen_cuda_required_use() {
	local x
	for x in ${CUDA_TARGETS_COMPAT[@]} ; do
		echo  "
			cuda_targets_${x}? (
				cuda
			)
		"
	done
}

gen_rocm_required_use() {
	local x
	for x in ${AMDGPU_TARGETS_COMPAT[@]} ; do
		echo  "
			amdgpu_targets_${x}? (
				rocm
			)
		"
	done
}

gen_llvm_slot_required_use() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				clang
			)
		"
	done
}

REQUIRED_USE+="
	$(gen_cuda_required_use)
	$(gen_rocm_required_use)
	$(gen_llvm_slot_required_use)
	clang? (
		^^ (
			${LLVM_COMPAT[@]/#/llvm_slot_}
		)
	)
	cuda? (
		!clang
		!rocm
		|| (
			${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
		)
	)
	rocm? (
		!cuda
		${ROCM_REQUIRED_USE}
		^^ (
			rocm_6_0
		)
	)
	rocm_6_0? (
		llvm_slot_17
	)
	|| (
		cpu
		cuda
		rocm
	)
"
# Missing
# hipsolver

ROCM_SLOTS=(
# See https://github.com/google/jax/blob/jaxlib-v0.4.29/build/rocm/Dockerfile.ms
	"${HIP_6_0_VERSION}" # For llvm 17, relaxed, upstream uses 6.0.0
)

declare -A LLD_SLOT=(
	["${HIP_6_0_VERSION}"]="${HIP_6_0_LLVM_SLOT}"
)

gen_rocm_depends() {
	local pv
	for pv in ${ROCM_SLOTS[@]} ; do
		local s=$(ver_cut 1-2 ${pv})
		local u="${s}"
		u="${u/./_}"
		# Direct dependencies
		echo "
			rocm_${u}? (
				~dev-libs/rccl-${pv}:${s}
				~dev-libs/rocm-device-libs-${pv}:${s}
				~dev-util/hip-${pv}:${s}[rocm]
				~dev-util/roctracer-${pv}:${s}
				~sci-libs/hipBLAS-${pv}:${s}[rocm]
				~sci-libs/hipFFT-${pv}:${s}$(get_rocm_usedep HIPFFT)
				~sci-libs/hipSPARSE-${pv}:${s}[rocm]
				~sci-libs/miopen-${pv}:${s}$(get_rocm_usedep MIOPEN)
				~sci-libs/rocFFT-${pv}:${s}$(get_rocm_usedep ROCFFT)
				~sci-libs/rocRAND-${pv}:${s}$(get_rocm_usedep ROCRAND)

				llvm-core/lld:${LLD_SLOT[${pv}]}
		"

		if ver_test "${s}" -ge "5.5" ; then
			echo "
				rocm_${u}? (
					~dev-libs/rocm-core-${pv}:${s}
					amdgpu_targets_gfx90a? (
						~sci-libs/hipBLASLt-${pv}:${s}$(get_rocm_usedep HIPBLASLT)
					)
				)
			"
		fi

		if ver_test "${s}" -ge "5.7" ; then
			echo "
				rocm_${u}? (
					amdgpu_targets_gfx940? (
						~sci-libs/hipBLASLt-${pv}:${s}$(get_rocm_usedep HIPBLASLT)
					)
					amdgpu_targets_gfx941? (
						~sci-libs/hipBLASLt-${pv}:${s}$(get_rocm_usedep HIPBLASLT)
					)
					amdgpu_targets_gfx942? (
						~sci-libs/hipBLASLt-${pv}:${s}$(get_rocm_usedep HIPBLASLT)
					)
				)
			"
		fi

		# Indirect dependencies
		echo "
				~dev-libs/rocm-comgr-${pv}:${s}
				~dev-libs/rocr-runtime-${pv}:${s}
				~dev-libs/roct-thunk-interface-${pv}:${s}
				~dev-build/rocm-cmake-${pv}:${s}
				~dev-util/rocm-smi-${pv}:${s}
				~dev-util/rocminfo-${pv}:${s}
				~dev-util/Tensile-${pv}:${s}$(get_rocm_usedep TENSILE)
				~sci-libs/rocBLAS-${pv}:${s}$(get_rocm_usedep ROCBLAS)
			)
		"
	done
}
#	>=dev-cpp/abseil-cpp-20220623:0/20220623
#	>=dev-libs/protobuf-${PROTOBUF_PV}:0/3.21
RDEPEND+="
	!dev-python/jaxlib-bin
	!sci-libs/jaxlib-bin
	$(python_gen_cond_dep '
		>=dev-python/numpy-1.20[${PYTHON_USEDEP}]
		>=dev-python/pybind11-2.10.0[${PYTHON_USEDEP}]
	')
	>=app-arch/snappy-1.1.10
	>=dev-libs/double-conversion-3.2.0
	>=dev-libs/nsync-1.25.0
	>=sys-libs/zlib-1.2.13
	virtual/jre:${JAVA_SLOT}
	cuda? (
		=dev-util/nvidia-cuda-toolkit-12*:=
		=dev-libs/cudnn-8.8*
	)
	rocm? (
		$(gen_rocm_depends)
		dev-util/hip:=
	)
	|| (
		=net-libs/grpc-1.49*
		=net-libs/grpc-1.52*
		=net-libs/grpc-1.53*
		=net-libs/grpc-1.54*
	)
	net-libs/grpc:=
"
# Originally >=net-libs/grpc-1.27_p9999:=
# We cannot use cuda 12 (which the project supports) until cudnn ebuild allows
# for it.
DEPEND+="
	${RDEPEND}
	virtual/jdk:${JAVA_SLOT}
"
gen_llvm_bdepend() {
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				llvm-core/clang:${s}
				llvm-core/llvm:${s}
				llvm-core/lld:${s}
			)
		"
	done
}
BDEPEND+="
	$(python_gen_cond_dep '
		dev-python/build[${PYTHON_USEDEP}]
	')
	>=dev-build/bazel-${BAZEL_PV}:${BAZEL_PV%.*}
	clang? (
		$(gen_llvm_bdepend)
	)
	rocm? (
		rocm_6_0? (
			sys-devel/gcc:${HIP_6_0_GCC_SLOT}
		)
		sys-devel/gcc:=
	)
	|| (
		>=sys-devel/gcc-12:12
		>=sys-devel/gcc-11.3.1_p20230120-r1:11
		>=sys-devel/gcc-10:10
		>=sys-devel/gcc-9.3.0:9
		$(gen_llvm_bdepend)
	)
"

S="${WORKDIR}/jax-jax-v${PV}"
RESTRICT="mirror"
DOCS=( "CHANGELOG.md" "CITATION.bib" "README.md" )
ROCM_PATCHES=(
	"0050-fix-rocm-build-scripts.patch"
	"0050-fix-rocm-source-code.patch"
	"0050-fix-rocm-support.patch"
	"0050-toolchain-prefix.patch"
)

distutils_enable_tests "pytest"

setup_linker() {
	if use rocm ; then
		return
	fi

	# The package likes to use lld with gcc which is disallowed.
	LLD="ld.lld"
einfo "PATH:\t${PATH}"
	local lld_pv=-1
	if tc-is-clang \
		&& ${LLD} --version 2>/dev/null 1>/dev/null ; then
		lld_pv=$(${LLD} --version \
			| awk '{print $2}')
	fi
	if is-flagq '-fuse-ld=mold' \
		&& test-flag-CCLD '-fuse-ld=mold' \
		&& has_version "sys-devel/mold" ; then
		# Explicit -fuse-ld=mold because of license of the linker.
einfo "Using mold (TESTING)"
		ld.mold --version || die
		filter-flags '-fuse-ld=*'
		append-ldflags -fuse-ld=mold
		BUILD_LDFLAGS+=" -fuse-ld=mold"
	elif \
		tc-is-clang \
			&& \
		( \
			! is-flagq '-fuse-ld=gold' \
				&& \
			! is-flagq '-fuse-ld=bfd' \
		) \
			&& \
		( \
			( \
				has_version "sys_devel/lld:$(clang-major-version)" \
			) \
				|| \
			( \
				ver_test $(clang-major-version) -lt "13" \
					&& \
				ver_test "${lld_pv}" -ge $(clang-major-version) \
			) \
				|| \
			( \
				has_version "llvm-core/clang-common[default-lld]" \
			) \
		) \
	then
einfo "Using LLD (TESTING)"
		${LLD} --version || die
		filter-flags '-fuse-ld=*'
		append-ldflags -fuse-ld=lld
		BUILD_LDFLAGS+=" -fuse-ld=lld"
	elif has_version "sys-devel/binutils[gold]" ; then
		# Linking takes 15 hours will the first .so and has linker lag issues.
ewarn "Using gold.  Expect linking times more than 30 hrs on older machines."
ewarn "Consider using -fuse-ld=mold or -fuse-ld=lld."
		ld.gold --version || die
		filter-flags '-fuse-ld=*'
		append-ldflags -fuse-ld=gold
		BUILD_LDFLAGS+=" -fuse-ld=gold"
		# The build scripts will use gold if it detects it.
		# Gold can hit ~9.01 GiB without flags.
		# Gold uses --no-threads by default.
		if ! is-flagq '-Wl,--thread-count,*' ; then
			# Gold doesn't use threading by default.
			local ncpus=$(lscpu \
				| grep -F "CPU(s)" \
				| head -n 1 \
				| awk '{print $2}')
			local tpc=$(lscpu \
				| grep -F "Thread(s) per core:" \
				| head -n 1 \
				| cut -f 2 -d ":" \
				| sed -r -e "s|[ ]+||g")
			local nthreads=$(( ${ncpus} * ${tpc} ))
ewarn "Link times may worsen if -Wl,--thread-count,${nthreads} is not specified in LDFLAGS"
		fi
		filter-flags '-Wl,--thread-count,*'
		append-ldflags -Wl,--thread-count,${nthreads}
		BUILD_LDFLAGS+=" -Wl,--thread-count,${nthreads}"
	else
ewarn "Using BFD.  Expect linking times more than 45 hrs on older machines."
ewarn "Consider using -fuse-ld=mold or -fuse-ld=lld."
		ld.bfd --version || die
		append-ldflags -fuse-ld=bfd
		BUILD_LDFLAGS+=" -fuse-ld=bfd"
		# No threading flags
	fi

	strip-unsupported-flags # Filter LDFLAGS after switch
}

# Modified tc_use_major_version_only() from toolchain.eclass
gcc_symlink_ver() {
	local slot="${1}"
	local ncomponents=3

	local pv=$(best_version "sys-devel/gcc:${slot}" \
		| sed -e "s|sys-devel/gcc-||g")
	if [[ -z "${pv}" ]] ; then
		return
	fi

	if ver_test "${pv}" -lt "10" ; then
		ncomponents=3
	elif [[ "${slot}" -eq "10" ]] && ver_test "${pv}" -ge "10.4.1_p20220929" ; then
		ncomponents=1
	elif [[ "${slot}" -eq "11" ]] && ver_test "${pv}" -ge "11.3.1_p20220930" ; then
		ncomponents=1
	elif [[ "${slot}" -eq "12" ]] && ver_test "${pv}" -ge "12.2.1_p20221001" ; then
		ncomponents=1
	elif [[ "${slot}" -eq "13" ]] && ver_test "${pv}" -ge "13.0.0_pre20221002" ; then
		ncomponents=1
	elif [[ "${slot}" -gt "13" ]] ; then
		ncomponents=1
	fi

	if (( ${ncomponents} == 1 )) ; then
		ver_cut 1 "${pv}"
		return
	fi

	ver_cut 1-3 "${pv}"
}

_remove_llvm_from_path() {
	export PATH=$(echo "${PATH}" \
		| tr ":" "\n" \
		| sed -e "\|/usr/lib/llvm|d" \
		| tr "\n" ":")
einfo "PATH:\t${PATH}"
}

use_gcc() {
	_remove_llvm_from_path
	local found=0
	local s
	for s in ${GCC_COMPAT[@]} ; do
		symlink_ver=$(gcc_symlink_ver ${s})
		export CC="${CHOST}-gcc-${symlink_ver}"
		export CXX="${CHOST}-g++-${symlink_ver}"
		export CPP="${CC} -E"
		strip-unsupported-flags
		if ${CC} --version 2>/dev/null 1>/dev/null ; then
einfo "Switched to gcc:${s}"
			found=1
			break
		fi
	done
	local found2=0
	local s_valid
	for s_valid in ${GCC_COMPAT[@]} ; do
		if (( ${s} == ${s_valid} )) ; then
			found2=1
			break
		fi
	done
	if (( ${found} != 1 )) ; then
		local slots_desc=$(echo "${GCC_COMPAT[@]}" \
			| tr " " "\n" \
			| tac \
			| tr "\n" " " \
			| sed -e "s| |, |g" -e "s|, $||g")
eerror
eerror "Use only gcc slots ${slots_desc}"
eerror
		die
	fi
	if (( ${found2} == 1 )) ; then
		:
	else
ewarn
ewarn "Using ${s} is not supported upstream.  This compiler slot is in testing."
ewarn
einfo
einfo "  Build time success on 2.11.0:"
einfo
einfo "    =sys-devel/gcc-11.3.1_p20230120-r1 with gold"
einfo "    =sys-devel/gcc-12.2.1_p20230121-r1 with mold"
einfo
	fi

	# Required for CUDA builds
	if use cuda ; then
		has_version "sys-devel/gcc:11" || die "Reinstall gcc:11"
		local s=11 # Slot
		export GCC_HOST_COMPILER_PATH="${EPREFIX}/usr/${CHOST}/gcc-bin/${s}/${CHOST}-gcc-${s}"
	fi

	${CC} --version || die
	strip-unsupported-flags
}

use_clang() {
	if [[ "${FEATURES}" =~ "ccache" ]] ; then
eerror
eerror "For this package, ccache cannot be combined with clang."
eerror "Disable ccache or use GCC with ccache."
eerror
		die
	fi

einfo "FORCE_LLVM_SLOT may be specified."
	local _LLVM_COMPAT=(${LLVM_COMPAT[@]})
	if [[ -n "${FORCE_LLVM_SLOT}" ]] ; then
		_LLVM_COMPAT=( ${FORCE_LLVM_SLOT} )
	fi

	local found=0
	local s
	for s in ${_LLVM_COMPAT[@]} ; do
		which "${CHOST}-clang-${s}" || continue
		export CC="${CHOST}-clang-${s}"
		export CXX="${CHOST}-clang++-${s}"
		export CPP="${CC} -E"
		strip-unsupported-flags
		if ${CC} --version 2>/dev/null 1>/dev/null ; then
einfo "Switched to clang:${s}"
			found=1
			break
		fi
	done
	local found2=0
	local s_valid
	for s_valid in ${_LLVM_COMPAT[@]} ; do
		if (( ${s} == ${s_valid} )) ; then
			found2=1
			break
		fi
	done
	if (( ${found} != 1 )) ; then
eerror
eerror "Use only clang slots ${LLVM_COMPAT[@]}"
eerror
		die
	fi
	if (( ${found2} == 1 )) ; then
		:
	else
ewarn "Using ${s} is not supported upstream.  This compiler slot is in testing."
	fi
	LLVM_SLOT=${s}
	llvm_pkg_setup
	${CC} --version || die
	strip-unsupported-flags
}

setup_tc() {
	export CC=$(tc-getCC)
	export CXX=$(tc-getCC)
einfo "CC:\t\t${CC}"
einfo "CXX:\t\t${CXX}"
einfo "CFLAGS:\t${CFLAGS}"
einfo "CXXFLAGS:\t${CXXFLAGS}"
einfo "LDFLAGS:\t${LDFLAGS}"
einfo "PATH:\t${PATH}"
	if use rocm ; then
ewarn "ROCm support is a Work In Progress (WIP)"
		_remove_llvm_from_path

		# Build with GCC but initialize LLVM_SLOT.
		if has rocm_6_0 ${IUSE_EFFECTIVE} && use rocm_6_0 ; then
			LLVM_SLOT=17
			ROCM_SLOT="6.0"
			ROCM_VERSION="${HIP_6_0_VERSION}"
		fi
	elif tc-is-clang || use clang ; then
		use_clang
	elif tc-is-gcc ; then
		use_gcc
	else
einfo
einfo "Use only GCC or Clang.  This package (CC=${CC}) also might not be"
einfo "completely installed."
einfo
		die
	fi
	if use rocm ; then
		rocm_pkg_setup

		local libs=(
			"amd_comgr:dev-libs/rocm-comgr"
			"amdhip64:dev-util/hip"
			"hipblas:sci-libs/hipBLAS"
			"hsa-runtime64:dev-libs/rocr-runtime"
			"rocblas:sci-libs/rocBLAS"
			"rocm_smi64:dev-util/rocm-smi"
			"roctracer64:dev-util/roctracer"
		)
		local glibcxx_ver="HIP_${ROCM_SLOT/./_}_GLIBCXX"
	# Avoid missing versioned symbols
	# # ld: /opt/rocm-6.1.2/lib/librocblas.so: undefined reference to `std::ios_base_library_init()@GLIBCXX_3.4.32'
		rocm_verify_glibcxx "${!glibcxx_ver}" ${libs[@]}

	#else
	#	llvm_pkg_setup is called in use_clang
	fi
}

pkg_setup() {
	dhms_start
	check-compiler-switch_start
	python_setup
	setup_tc

	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if ! [[ "${BAZEL_LD_PRELOAD_IGNORED_RISKS}" =~ ("allow"|"accept") ]] ; then
	# A reaction to "WARNING: ignoring LD_PRELOAD in environment" maybe
	# reported by Bazel.
eerror
eerror "Precaution taken..."
eerror
eerror "LD_PRELOAD gets ignored by a build tool which could bypass the"
eerror "ebuild sandbox.  Set one of the following as a per-package"
eerror "environment variable:"
eerror
eerror "BAZEL_LD_PRELOAD_IGNORED_RISKS=\"allow\"     # to continue and consent to accepting risks"
eerror "BAZEL_LD_PRELOAD_IGNORED_RISKS=\"deny\"      # to stop (default)"
eerror
		die
	fi

	java-pkg-opt-2_pkg_setup
	java-pkg_ensure-vm-version-eq ${JAVA_SLOT}

	# Required because rules_python/pip cannot do offline easily.
	# sandbox-changes_no_network_sandbox "To download micropackages"
}

src_unpack() {
        mkdir -p "${WORKDIR}/bin" || die
        export PATH="${WORKDIR}/bin:${PATH}"
        ln -s "/usr/bin/bazel-${BAZEL_PV%.*}" "${WORKDIR}/bin/bazel" || die
	bazel --version | grep -q "bazel ${BAZEL_PV%.*}" || die "dev-build/bazel:${BAZEL_PV%.*} not installed"

	unpack "${MY_PN}-${PV}.tar.gz"
	unpack "openxla-xla-${EGIT_XLA_COMMIT}.zip"
	mkdir -p "${WORKDIR}/tarballs" || die
	mkdir -p "${WORKDIR}/patches" || die
	bazel_load_distfiles "${bazel_external_uris}"
}

load_env() {
	export JAVA_HOME=$(java-config --jre-home) # so keepwork works
	if [[ -e "${WORKDIR}/.ccache_dir_val" && "${FEATURES}" =~ "ccache" ]] \
		&& has_version "dev-util/ccache" ; then
		export CCACHE_DIR=$(cat "${WORKDIR}/.ccache_dir_val")
einfo "CCACHE_DIR:\t${CCACHE_DIR}"
	fi
}

# Keep in sync with tensorflow ebuild
prepare_jaxlib() {
	load_env
	setup_linker

	# Upstream uses a mix of -O3 and -O2.
	# In some contexts -Os causes a stall.
	# Make _FORTIFY_SOURCE work.
	# Prevent warning as error
	replace-flags '-O*' '-O2' # Prevent possible runtime breakage with llvm parts.
}

gen_gcc_ar(){
	local gcc_slot=$(gcc-major-version)
	local dir
	dir="${WORKDIR}/jax-jax-${PV}-${EPYTHON/./_}-bazel-base/execroot/org_tensorflow"
cat <<-EOF > "${T}/gcc-ar.sh"
#!/usr/bin/env bash
GCC_AR_PATH="${EPREFIX}/usr/${CHOST}/gcc-bin/${gcc_slot}"
ARGS="\${1}"
shift
DEST="\${1}"
shift
cd "${dir}"
"\${GCC_AR_PATH}/gcc-ar" "\${ARGS}" "\${DEST}" "\${@}"
EOF
	chmod +x "${T}/gcc-ar.sh" || die
}

python_prepare_all() {
	distutils-r1_python_prepare_all
	cuda_src_prepare
	cd "${S}" || die

ewarn
ewarn "If build failure, use MAKEOPTS=\"-j1\".  Expect memory use to be 6-11"
ewarn "GiB per process."
ewarn

	cd "${WORKDIR}/xla-${EGIT_XLA_COMMIT}" || die
	if use rocm ; then
		local f
		for f in ${ROCM_PATCHES[@]} ; do
			eapply -p1 "${FILESDIR}/${PV}/xla/${f}"
		done
	fi

	# Speed up symbol replacement for @...@ by reducing search space.
	XLA_S="${WORKDIR}/xla-${EGIT_XLA_COMMIT}"
	PATCH_PATHS=(
	# Generated in this folder from:
	# grep -F -r -e "+++" files/0.4.29/xla | cut -f 2 -d " " | cut -f 1 -d $'\t' | sort | uniq | cut -f 2- -d $'/' | sort | uniq
		"${XLA_S}/third_party/tsl/third_party/gpus/crosstool/cc_toolchain_config.bzl.tpl"
		"${XLA_S}/third_party/tsl/third_party/gpus/crosstool/clang/bin/crosstool_wrapper_driver_rocm.tpl"
		"${XLA_S}/third_party/tsl/third_party/gpus/crosstool/hipcc_cc_toolchain_config.bzl.tpl"
		"${XLA_S}/third_party/tsl/third_party/gpus/rocm_configure.bzl"
		"${XLA_S}/third_party/tsl/tsl/platform/default/rocm_rocdl_path.cc"
		"${XLA_S}/xla/service/gpu/llvm_gpu_backend/gpu_backend_lib.cc"
		"${XLA_S}/xla/stream_executor/gpu/asm_compiler.cc"

	# Generated in this folder from:
	# grep -F -r -e "+++" files/0.4.29/*.patch | cut -f 2 -d " " | cut -f 1 -d $'\t' | sort | uniq | cut -f 2- -d $'/' | sort | uniq
	)

	if use rocm ; then
		rocm_src_prepare
	fi

	cd "${XLA_S}" || die

	local L=(
		"third_party/tsl/third_party/gpus"
	)

	if use rocm ; then
		local dirpath
		for dirpath in ${L[@]} ; do
			rm -f "${dirpath}/find_rocm_config.py.gz.base64"
			pushd "${dirpath}" || die
				pigz -z -k find_rocm_config.py || die
				mv find_rocm_config.py.zz find_rocm_config.py.gz || die
				base64 --wrap=0 \
					find_rocm_config.py.gz \
					> \
					find_rocm_config.py.gz.base64 \
					|| die
			popd
		done

		sed -i -e "s|@JAXLIB_PV@|${PV}|g" \
			"third_party/tsl/third_party/gpus/crosstool/cc_toolchain_config.bzl.tpl" \
			"third_party/tsl/third_party/gpus/crosstool/hipcc_cc_toolchain_config.bzl.tpl" \
			|| die
	fi

	gen_gcc_ar

	if [[ "${FEATURES}" =~ "ccache" ]] && has_version "dev-util/ccache" ; then
		sed -i -e "s|LLVM_CCACHE_BUILD OFF|LLVM_CCACHE_BUILD ON|g" \
			"xla/mlir_hlo/CMakeLists.txt" \
			|| die
	fi
}

src_prepare() {
# DO NOT REMOVE.
# Must be explictly called.
	distutils-r1_src_prepare
}

get_cuda_targets() {
	local targets
	local target
	for target in ${CUDA_TARGETS_COMPAT[@]} ; do
		if use "cuda_targets_${target}" ; then
			targets+=",${target}"
		fi
	done
	echo "${targets}" | sed -e "s|^,||g"
}

get_host() {
	# See https://github.com/bazelbuild/bazel/blob/master/src/main/java/com/google/devtools/build/lib/bazel/repository/LocalConfigPlatformFunction.java#L106
	if use arm ; then
		echo "arm"
	elif use arm64 && use elibc_Darwin ; then
		echo "arm64"
	elif use arm64 ; then
		echo "aarch64"
	elif use amd64 ; then
		echo "x86_64"
	elif use mips && [[ "${CHOST}" =~ "mips64" ]] ; then
		echo "mips64"
	elif use ppc64 && [[ "${CHOST}" =~ "powerpc64le" ]] ; then
		echo "ppc64le"
	elif use ppc ; then
		echo "ppc"
	elif use riscv ; then
		echo "riscv64"
	elif use s390 && [[ "${CHOST}" =~ "s390x" ]] ; then
		echo "s390x"
	elif use x86 ; then
		echo "x86_32"
	else
eerror
eerror "Your arch is not supported"
eerror
eerror "ARCH:\t${ARCH}"
eerror "CHOST:\t${CHOST}"
eerror
		die
	fi
}

# From bazel.eclass
_ebazel() {
	bazel_setup_bazelrc # Save CFLAGS.  Ignored.

	# Use different build folders for each multibuild variant.
	local output_base="${BUILD_DIR:-${S}}"
	output_base="${output_base%/}-bazel-base"
	mkdir -p "${output_base}" || die
	set -- bazel \
		--output_base="${output_base}" \
		${@}
	echo "${*}" >&2
	"${@}" || die "ebazel failed"
}

python_configure() { :; }

python_compile() {
	load_env
	local args=()

	prepare_jaxlib

	if use rocm ; then
		rocm_set_default_gcc
		filter-flags '-fuse-ld=*'
		append-ldflags -fuse-ld=lld
		BUILD_LDFLAGS+=" -fuse-ld=lld"
		strip-unsupported-flags # Filter LDFLAGS after switch
	fi
	cflags-hardened_append
	BUILD_CXXFLAGS+=" ${CFLAGS_HARDENED_CXXFLAGS}"
	BUILD_LDFLAGS+=" ${CFLAGS_HARDENED_LDFLAGS}"
	bazel_setup_bazelrc # Save CFLAGS

	if is-flagq '-march=native' ; then
# Autodetect
		args+=(
			--target_cpu_features=native
		)
	elif is-flagq '-march=generic' ; then
# Strips -march=*
		args+=(
			--target_cpu_features=default
		)
	elif [[ "${CFLAGS}" =~ "-march=" ]] ; then
# Autodetect
		args+=(
			--target_cpu_features=native
		)
	elif use cpu_flags_x86_avx ; then
# Package default
# Adds -mavx without -march=
		args+=(
			--target_cpu_features=release
		)
	else
# Strips -march=*
		args+=(
			--target_cpu_features=default
		)
	fi

# See https://github.com/openxla/xla/blob/32ba408c0e2b7ef5f5821c0781601ba17d467076/third_party/tsl/third_party/systemlibs/syslibs_configure.bzl#L11
	local SYSLIBS=(
#		absl_py
#		astor_archive
#		astunparse_archive
#		boringssl
#		com_github_googlecloudplatform_google_cloud_cpp
		com_github_grpc_grpc

## tensorflow/compiler/xla/stream_executor/BUILD:527:11: no such target
## '@com_google_absl//absl/functional:any_invocable': target 'any_invocable' not
## declared in package 'absl/functional' defined by
## [...]/external/com_google_absl/absl/functional/BUILD.bazel and referenced by
## '@org_tensorflow//tensorflow/compiler/xla/stream_executor:timer'
#		com_google_absl # broken?

## com_google_protobuf/BUILD.bazel:50:8: in cmd attribute of genrule rule
## @com_google_protobuf//:link_proto_files: $(PROTOBUF_INCLUDE_PATH) not defined
#		com_google_protobuf # broken?

#		curl
#		cython
#		dill_archive
		double_conversion
#		flatbuffers
#		functools32_archive
#		gast_archive
#		gif
#		hwloc
#		icu
#		jsoncpp_git
#		libjpeg_turbo
#		lmdb
#		nasm
		nsync
#		opt_einsum_archive
#		org_sqlite
#		pasta
#		png
#		pybind11
#		six_archive

## tensorflow/tsl/platform/default/port.cc:328:11: error: 'RawCompressFromIOVec'
## is not a member of 'snappy'; did you mean 'RawUncompressToIOVec'?
##  328 |   snappy::RawCompressFromIOVec(iov, uncompressed_length, &(*output)[0],
##      |           ^~~~~~~~~~~~~~~~~~~~
##      |           RawUncompressToIOVec
#		snappy # broken?


#		tblib_archive
#		termcolor_archive
#		typing_extensions_archive
#		wrapt
		zlib
	)
	export TF_ENABLE_XLA=1
	export TF_NEED_CUDA=$(usex cuda "1" "0")
	export TF_NEED_ROCM=$(usex rocm "1" "0")
	export TF_SYSTEM_LIBS=$(echo "${SYSLIBS[@]}" | tr " " ",")
	if use cuda ; then
	# See https://jax.readthedocs.io/en/latest/developer.html#additional-notes-for-building-jaxlib-from-source-on-windows
		export JAX_CUDA_VERSION="$(cuda_toolkit_version)"
		export JAX_CUDNN_VERSION="$(cuda_cudnn_version)"
		export TF_CUDA_COMPUTE_CAPABILITIES="$(get_cuda_targets)"
		args+=(
			--enable_cuda
			--cuda_path="${ESYSROOT}/opt/cuda"
			--cudnn_path="${ESYSROOT}/opt/cuda"
			--cuda_version="$(cuda_toolkit_version)"
			--cudnn_version="$(cuda_cudnn_version)"
			--gpu_plugin_cuda_version=12
		)
	fi
	if use rocm ; then
		local gcc_slot=$(gcc-major-version)
		local rocm_pv=$(best_version "sci-libs/rocFFT" \
			| sed -e "s|sci-libs/rocFFT-||")
		local rocm_version=$(best_version "dev-util/hip" \
			| sed -e "s|dev-util/hip-||g")
		rocm_version=$(ver_cut 1-3 "${rocm_version}")

		export GCC_HOST_COMPILER_PATH="${EPREFIX}/usr/${CHOST}/gcc-bin/${gcc_slot}/${CHOST}-gcc-${gcc_slot}"
		export HIP_PATH="${EPREFIX}/usr"
		export HOST_C_COMPILER="${EPREFIX}/usr/bin/${CC}"
		export HOST_CXX_COMPILER="${EPREFIX}/usr/bin/${CXX}"
		export JAX_ROCM_VERSION="${rocm_version//./}"
		export ROCM_PATH="${ESYSROOT}/usr"
		export TF_ROCM_AMDGPU_TARGETS=$(get_amdgpu_flags \
			| tr ";" ",")
einfo "GCC_HOST_COMPILER_PATH:  ${GCC_HOST_COMPILER_PATH}"
einfo "HIP_PATH:  ${HIP_PATH}"
einfo "HOST_C_COMPILER:  ${HOST_C_COMPILER}"
einfo "HOST_CXX_COMPILER:  ${HOST_CXX_COMPILER}"
einfo "JAX_ROCM_VERSION:  ${JAX_ROCM_VERSION}"
einfo "ROCM_PATH:  ${ROCM_PATH}"
einfo "TF_ROCM_AMDGPU_TARGETS:  ${TF_ROCM_AMDGPU_TARGETS}"

	# The docs hasn't been updated, but latest point release of jax/jaxlib
	# is the same source for xla.  No override needed.

	# See
	# https://jax.readthedocs.io/en/latest/developer.html#additional-notes-for-building-a-rocm-jaxlib-for-amd-gpus
	# https://github.com/google/jax/blob/jaxlib-v0.4.29/build/rocm/build_rocm.sh
		args+=(
			--bazel_options="--override_repository=xla=${WORKDIR}/xla-${EGIT_XLA_COMMIT}"
			--enable_rocm
			--rocm_amdgpu_targets="${TF_ROCM_AMDGPU_TARGETS}"
			--rocm_path="${ESYSROOT}/usr"
		)
	fi

	if tc-is-clang ; then
		args+=(
			--use_clang=True
			--clang_path="/usr/lib/llvm/${LLVM_SLOT}/bin/clang"
		)
	fi

	if use debug ; then
# For showing gdb function names
		echo 'build --config=debug_symbols' >> ".bazelrc.user" || die
	fi

	# Generate to fix python version in .jax_configure.bazelrc
einfo "Running:  ${EPYTHON} build/build.py --configure_only ${args[@]}"
	${EPYTHON} build/build.py \
		--configure_only \
		${args[@]} \
		|| die

	# Merge custom config
	cat /dev/null > ".bazelrc.user" || die
	cat "${T}/bazelrc" >> ".bazelrc.user" || die

	echo 'build --noshow_progress' >> ".bazelrc.user" || die # Disable high CPU usage on xfce4-terminal
	echo 'build --subcommands --verbose_failures' >> ".bazelrc.user" || die # Increase verbosity

	echo "build --action_env=TF_SYSTEM_LIBS=\"${TF_SYSTEM_LIBS}\"" >> ".bazelrc.user" || die
	echo "build --host_action_env=TF_SYSTEM_LIBS=\"${TF_SYSTEM_LIBS}\"" >> ".bazelrc.user" || die

	if has_version "dev-java/openjdk-bin:11" ; then
		local jdk_path=$(realpath "/opt/openjdk-bin-11")
		export JAVA_HOME_11="${jdk_path}"
	elif has_version "dev-java/openjdk:11" ; then
		local jdk_path=$(realpath "/usr/$(get_libdir)/openjdk-11")
		export JAVA_HOME_11="${jdk_path}"
	else
eerror "Emerge dev-java/openjdk-bin:11 to continue."
		die
	fi

        echo "startup --server_javabase=${JAVA_HOME_11}" >> ".bazelrc.user" || die

	if [[ "${FEATURES}" =~ "ccache" ]] && has_version "dev-util/ccache" ; then
		local ccache_dir=$(ccache -sv \
			| grep "Cache directory" \
			| cut -f 2 -d ":" \
			| sed -r -e "s|^[ ]+||g")
		echo "${ccache_dir}" > "${WORKDIR}/.ccache_dir_val" || die
einfo "Adding build --sandbox_writable_path=\"${ccache_dir}\" to .bazelrc.user"
		echo "build --action_env=CCACHE_DIR=\"${ccache_dir}\"" >> ".bazelrc.user" || die
		echo "build --host_action_env=CCACHE_DIR=\"${ccache_dir}\"" >> ".bazelrc.user" || die
		echo "build --sandbox_writable_path=${ccache_dir}" >> ".bazelrc.user" || die
	fi

	if use cuda ; then
		sed -i \
			-e "s|sm_52,sm_60,sm_70,sm_80,compute_90|${TF_CUDA_COMPUTE_CAPABILITIES}|g" \
			".bazelrc" \
			".bazelrc.user" \
			|| die
	fi

	if use rocm ; then
		sed -i \
			-e "s|gfx900,gfx906,gfx908,gfx90a,gfx1030|${TF_ROCM_AMDGPU_TARGETS}|g" \
			".bazelrc" \
			".bazelrc.user" \
			|| die
	fi

einfo "Done generating .bazelrc.user"

	[[ -e ".jax_configure.bazelrc" ]] || die "Missing .jax_configure.bazelrc"
	[[ -e ".bazelrc.user" ]] || die "Missing .bazelrc.user"

einfo "Building wheel for EPYTHON=${EPYTHON} PYTHON=${PYTHON}"

	export PYTHON_BIN_PATH="${PYTHON}"

	sed -i -r \
		-e "s|python[0-9]\.[0-9]+|${EPYTHON}|g" \
		".jax_configure.bazelrc" \
		|| die

	# Keep in sync with
	# https://github.com/google/jax/blob/jaxlib-v0.4.29/build/build.py#L546
	_ebazel run \
		--verbose_failures=true \
		-s \
		"//jaxlib/tools:build_wheel" \
		-- \
		--output_path="${PWD}/dist" \
		--cpu=$(get_host) \
		--jaxlib_git_hash=${EGIT_COMMIT}
	_ebazel shutdown

	local python_pv="${EPYTHON}"
	python_pv="${python_pv/python}"
	python_pv="${python_pv/./}"
	IFS=$'\n'
	local wheel_paths=$(
		find "${S}/dist" -name "*.whl"
	)
	local wheel_path
	for wheel_path in ${wheel_paths[@]} ; do
einfo "Installing ${wheel_path}"
		distutils_wheel_install \
			"${BUILD_DIR}/install" \
			"${wheel_path}"
	done
	IFS=$' \t\n'
}

src_install() {
	load_env
	distutils-r1_src_install
	docinto "licenses"
	dodoc "AUTHORS" "LICENSE"
	dhms_end
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
