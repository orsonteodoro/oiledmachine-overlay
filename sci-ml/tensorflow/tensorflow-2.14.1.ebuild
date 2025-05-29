# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
 
# TODO:
# Make protobuf internal dependency

# Build/install only progress for 2.16.1:
# CPU - testing
# GPU (rocm) - testing/in-development
# GPU (cuda) - testing/in-development

# U20, U18

# SECURITY:  Bump every minor version.  Check if CVE announced:
# https://github.com/tensorflow/tensorflow/releases/tag/v2.14.1

MY_PV="${PV/_rc/-rc}"
MY_P="${PN}-${MY_PV}"
DEP_VER="$(ver_cut 1-2)"
DEP_VER_MAX="${DEP_VER%%.*}.$(( $(ver_cut 2 ${DEP_VER}) + 1 ))"

AMDGPU_TARGETS_COMPAT=(
# See https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/compiler/xla/stream_executor/device_description.h#L175
	gfx900
	gfx906
	gfx908
	gfx90a
        gfx1030
)
BAZEL_PV="6.1.0"
DISTUTILS_OPTIONAL=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="no"
CFLAGS_HARDENED_USE_CASES="jit untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE DF SO HO IO UAF"
CHECKREQS_DISK_BUILD="19G"
CHECKREQS_DISK_USR="5G"
CHECKREQS_MEMORY="11G" # Linking goes above 10 GiB
CUDA_TARGETS_COMPAT=(
# See https://github.com/tensorflow/tensorflow/blob/v2.14.1/.bazelrc#L581  # Supported upstream
	sm_35 # Supported
	sm_50 # Supported
	sm_60 # Supported
	sm_70 # Supported
	sm_75 # Supported
	compute_80 # Supported
)
GCC_COMPAT=( {12..9} )
GCC_MAX_SLOT="${GCC_COMPAT[0]}"
GCC_MIN_SLOT="${GCC_COMPAT[-1]}"
GCC_SLOT_WITH_CUDA=11
GRPC_PROTOBUF_PAIRS=(
	"1.62:4.25"
	"1.61:4.25"
	"1.60:4.25"
	"1.59:4.24"
	"1.58:4.23"
	"1.57:4.23"
	"1.56:4.23"
	"1.55:4.23"
	"1.54:3.21"
	"1.53:3.21"
	"1.52:3.21"
	"1.49:3.21"
)
inherit hip-versions
HIP_SLOTS=(
# See also https://github.com/ROCm/tensorflow-upstream/blob/develop-upstream/rocm_docs/tensorflow-rocm-release.md?plain=1
#	"${HIP_5_7_VERSION}" # For llvm 17 # Disabled based on LLVM_COMPAT
	"${HIP_5_6_VERSION}" # For llvm 16
	"${HIP_5_5_VERSION}" # For llvm 16
	"${HIP_5_4_VERSION}" # For llvm 15
	"${HIP_5_3_VERSION}" # For llvm 15
#	"${HIP_5_2_VERSION}" # For llvm 14
#	"${HIP_5_1_VERSION}" # For llvm 14
#	"${HIP_5_0_VERSION}" # For llvm 14
)
gen_hip_slots2() {
	local pv
	for pv in ${HIP_SLOTS[@]} ; do
		local u=$(ver_cut 1-2 "${pv}")
		u="${u/./_}"
		echo "rocm_${u}"
	done
}
HIP_SLOTS2=(
	$(gen_hip_slots2)
)
declare -A LLD_SLOT=(
#	["${HIP_5_7_VERSION}"]="${HIP_5_7_LLVM_SLOT}"
	["${HIP_5_6_VERSION}"]="${HIP_5_6_LLVM_SLOT}"
	["${HIP_5_5_VERSION}"]="${HIP_5_5_LLVM_SLOT}"
	["${HIP_5_4_VERSION}"]="${HIP_5_4_LLVM_SLOT}"
	["${HIP_5_3_VERSION}"]="${HIP_5_3_LLVM_SLOT}"
#	["${HIP_5_2_VERSION}"]="${HIP_5_2_LLVM_SLOT}"
#	["${HIP_5_1_VERSION}"]="${HIP_5_1_LLVM_SLOT}"
#	["${HIP_5_0_VERSION}"]="${HIP_5_0_LLVM_SLOT}"
)

# See "deps versioning" section above for details.
# See
# https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/tools/toolchains/remote_config/configs.bzl
# https://github.com/tensorflow/tensorflow/blob/v2.14.1/third_party/gpus/rocm_configure.bzl#L200
LLVM_COMPAT=( {16..15} )
PYTHON_COMPAT=( "python3_11" ) # See https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/tools/pip_package/setup.py#L429
# Limited by jax/flax
# PYTHON_COMPAT limited by gast-4.0[python_targets_python3_9]

# *seq* can only be done in the eclass.
gen_seq_dec() {
	local max=${1}
	local min=${2}
	local c=${max}
	while (( ${c} >= ${min} )) ; do
		echo "${c}"
		c=$(( ${c} - 1 ))
	done
}

gen_seq_inc() {
	local min=${1}
	local max=${2}
	local c=${min}
	while (( ${c} <= ${max} )) ; do
		echo "${c}"
		c=$(( ${c} + 1 ))
	done
}

inherit bazel cflags-hardened check-reqs cuda distutils-r1 dhms flag-o-matic lcnr llvm prefix
inherit rocm toolchain-funcs

# For deps versioning, see
# https://www.tensorflow.org/install/source#linux
# https://github.com/abseil/abseil-cpp/blob/fb3621f4f897824c0dbe0615fa94543df6192f30/CMakeLists.txt#L49 ; Search project(absl LANGUAGES CXX VERSION
# https://github.com/google/boringssl/blob/c00d7ca810e93780bd0c8ee4eea28f4f2ea4bcdc/src/include/openssl/crypto.h#L99
# https://github.com/tensorflow/runtime/blob/769f5cc9b8732933140b09e8808d13614182b496/third_party/rules_cuda/cuda/dependencies.bzl#L41	# cc_rules
# https://github.com/tensorflow/runtime/blob/769f5cc9b8732933140b09e8808d13614182b496/third_party/rules_cuda/cuda/dependencies.bzl#L66	# platforms
# https://github.com/tensorflow/tensorflow/blob/v2.14.1/.bazelversion
# https://github.com/tensorflow/tensorflow/blob/v2.14.1/configure.py#L33							# cuda version
# https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/lite/tools/cmake/modules/eigen.cmake
# https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/tools/ci_build/Dockerfile.rbe.rocm-ubuntu18.04-manylinux2010-multipython#L19 # rocm version min
# https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/tools/ci_build/Dockerfile.rbe.rocm-ubuntu20.04-manylinux2014-multipython#L20 # rocm version max
# https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/tools/dockerfiles/partials/ubuntu/nvidia.partial.Dockerfile	# cuda/cudnn major.minor versions
# https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/tools/pip_package/setup.py#L171				# cuda version
# https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/tools/ci_build/release/requirements_common.txt		# python deps versions ; pinned
# https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/tools/ci_build/release/requirements_ubuntu.txt		# python deps versions ; pinned ; depends on requirements_common.txt
# https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/tools/pip_package/setup.py#L84				# python deps versions
# https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/tools/tf_sig_build_dockerfiles/devel.requirements.txt	# python deps versions ; pinned ; depends on requirements_common.txt
# https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/tools/toolchains/archives.bzl
# https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/tools/toolchains/remote_config/containers.bzl		# containers for testing
# https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/tools/toolchains/remote_config/configs.bzl#L318		# tested llvm

# commits/versions for
# astor, boringssl, curl, cython, dill, double-conversion, giflib, jsoncpp,
# libpng, nsync, protobuf, pybind11, snappy, sqlite, tblib,
# zlib:
# https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/workspace2.bzl#L567
# google-cloud-cpp:
# https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/workspace2.bzl#L295

# https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/workspace2.bzl#L542			# openmp
# https://github.com/tensorflow/tensorflow/blob/v2.14.1/third_party/absl/workspace.bzl			# abseil-cpp ; provides commit
# https://github.com/tensorflow/tensorflow/blob/v2.14.1/third_party/flatbuffers/workspace.bzl		# See also https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/lite/schema/schema_generated.h
# https://github.com/tensorflow/tensorflow/blob/v2.14.1/third_party/gemmlowp/workspace.bzl
# https://github.com/tensorflow/tensorflow/blob/v2.14.1/third_party/gpus/rocm_configure.bzl#L191        # llvms supported for rocm
# https://github.com/tensorflow/tensorflow/blob/v2.14.1/third_party/hwloc/workspace.bzl
# https://github.com/tensorflow/tensorflow/blob/v2.14.1/third_party/icu/workspace.bzl
# https://github.com/tensorflow/tensorflow/blob/v2.14.1/third_party/jpeg/workspace.bzl
# https://github.com/tensorflow/tensorflow/blob/v2.14.1/third_party/llvm/workspace.bzl
#   https://github.com/llvm/llvm-project/blob/49cb1595c1b3ae1de3684fea6148363c15bae12a/llvm/CMakeLists.txt#L14  # same as llvm 18.0.0git
# https://github.com/tensorflow/tensorflow/blob/v2.14.1/third_party/llvm_openmp/openmp.bzl
# https://github.com/tensorflow/tensorflow/blob/v2.14.1/third_party/pasta/workspace.bzl
# https://github.com/grpc/grpc/blob/b54a5b338637f92bfcf4b0bc05e0f57a5fd8fadd/CMakeLists.txt
# https://github.com/tensorflow/tensorflow/blob/v2.15.1/ci/official/requirements_updater/requirements.in
#   For dill, jax, keras, lit, packaging, portpicker, requests, scipy, setuptools, tblib, tensorboard, tensorboard-estimator

# distfiles that bazel uses for the workspace, will be copied to basel-distdir
# pkgcheck complains but do NOT change the .zip to .tar.gz, bazel requires the exact tarball (basename and sha256).
# the build will fail if different archives are used.

# The same results can be obtained by observing the console logs.
# URIs provided for verification and faster future updates.

inherit protobuf-ver

ABSEIL_PY_PV="1.0.0"		# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/workspace2.bzl
APPLE_SUPPORT_PV="1.6.0"	# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/workspace2.bzl
CUDA_PV="11.8"			# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/tools/pip_package/setup.py#L171
BAZEL_SKYLIB_PV="1.3.0"		# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/workspace3.bzl
CUB_PV="1.9.9"			# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/workspace2.bzl
CUDNN_FRONTEND_PV="0.9"		# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/workspace2.bzl
FLATBUFFERS_PV="23.5.26"	# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/third_party/flatbuffers/workspace.bzl
GRPC_PV="1.53.0"		# Based on the oldest grpc supporting abseil 20230125
GRPCIO_PV="1.24.3"		# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/tools/pip_package/setup.py#L84
GRPCIO_PV_MAX="1.53"		# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/tools/pip_package/setup.py#L84 ; < (Exclusive) ; Upstream is wrong
KISSFFT_PV="131.1.0"		# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/third_party/kissfft/workspace.bzl
NCCL_PV="2.16.5-1"		# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/workspace2.bzl
ONEDNN_PV="3.2.1"		# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/workspace2.bzl
OOURA_FFT_PV="1.0"		# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/workspace2.bzl
OPENMP_PV="10.0.1"		# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/workspace2.bzl
PLATFORMS_PV="0.0.6"		# From https://github.com/tensorflow/runtime/blob/769f5cc9b8732933140b09e8808d13614182b496/third_party/rules_cuda/cuda/dependencies.bzl#L66 with EGIT_COMMIT_TF_RUNTIME
PROTOBUF_PV="3.21.9"		# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/workspace2.bzl
PROTOBUF_SLOT="0/${PROTOBUF_PV%.*}"
PROTOBUF_SLOTS=(
	${PROTOBUF_3_SLOTS[@]}
	${PROTOBUF_4_SLOTS[@]}
)
RULES_ANDROID_PV="0.1.1"	# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/workspace2.bzl
RULES_APPLE_PV="2.3.0"		# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/workspace2.bzl
RULES_FOREIGN_CC_PV="0.7.1"	# From https://github.com/google/benchmark/blob/f7547e29ccaed7b64ef4f7495ecfff1c9f6f3d03/bazel/benchmark_deps.bzl#L22 with EGIT_COMMIT_BENCHMARK
RULES_JVM_PV="4.3"		# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/workspace3.bzl
RULES_PKG_PV="0.7.1"		# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/workspace3.bzl
RULES_PYTHON_PV="0.1.0"		# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/WORKSPACE#L19
RULES_SWIFT_PV="1.0.0"		# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/workspace2.bzl
# RULES_DOCKER dumped?
TRITON_TAG="cl546794996"	# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/third_party/triton/workspace.bzl#L8

EGIT_COMMIT_ABSEIL_CPP="b971ac5250ea8de900eae9f95e06548d14cd95fe"		# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/third_party/absl/workspace.bzl
EGIT_COMMIT_ARM_NEON_2_X86_SSE="a15b489e1222b2087007546b4912e21293ea86ff"	# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/workspace2.bzl
EGIT_COMMIT_BENCHMARK="f7547e29ccaed7b64ef4f7495ecfff1c9f6f3d03"		# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/third_party/benchmark/workspace.bzl
EGIT_COMMIT_BAZEL_TOOLCHAINS="8c717f8258cd5f6c7a45b97d974292755852b658"		# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/workspace1.bzl
EGIT_COMMIT_CPUINFO="87d8234510367db49a65535021af5e1838a65ac2"			# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/workspace2.bzl
EGIT_COMMIT_DLPACK="9351cf542ab478499294864ff3acfdab5c8c5f3d"			# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/third_party/dlpack/workspace.bzl
EGIT_COMMIT_FARMHASH="0d859a811870d10f53a594927d0d0b97573ad06d"			# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/third_party/farmhash/workspace.bzl
EGIT_COMMIT_FP16="4dfe081cf6bcd15db339cf2680b9281b8451eeb3"			# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/third_party/FP16/workspace.bzl
EGIT_COMMIT_FXDIV="63058eff77e11aa15bf531df5dd34395ec3017c8"			# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/workspace2.bzl
EGIT_COMMIT_GEMMLOWP="e844ffd17118c1e17d94e1ba4354c075a4577b88"			# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/third_party/gemmlowp/workspace.bzl
EGIT_COMMIT_GOOGLEAPIS="6b3fdcea8bc5398be4e7e9930c693f0ea09316a0"		# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/workspace2.bzl#L305
EGIT_COMMIT_HIGHWAYHASH="c13d28517a4db259d738ea4886b1f00352a3cc33"		# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/third_party/highwayhash/workspace.bzl
EGIT_COMMIT_LIBEIGEN="0b51f763cbbd0ed08168f88972724329f0375498"			# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/third_party/eigen3/workspace.bzl
EGIT_COMMIT_LLVM="668e33c6401abe7844691fb7d47a3cf2d2012dbc"			# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/third_party/llvm/workspace.bzl
EGIT_COMMIT_ML_DTYPES="5b9fc9ad978757654843f4a8d899715dbea30e88"		# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/third_party/py/ml_dtypes/workspace.bzl#L10
EGIT_COMMIT_PTHREADPOOL="b8374f80e42010941bda6c85b0e3f1a1bd77a1e0"		# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/workspace2.bzl
EGIT_COMMIT_PYBIND11_ABSEIL="2c4932ed6f6204f1656e245838f4f5eae69d2e29"		# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/third_party/pybind11_abseil/workspace.bzl
EGIT_COMMIT_PYBIND11_BAZEL="72cbbf1fbc830e487e3012862b7b720001b70672"		# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/third_party/pybind11_bazel/workspace.bzl
EGIT_COMMIT_PYBIND11_PROTOBUF="80f3440cd8fee124e077e2e47a8a17b78b451363"	# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/workspace2.bzl#L875
EGIT_COMMIT_RE2="03da4fc0857c285e3a26782f6bc8931c4c950df4"			# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/workspace2.bzl ; Round up to the first day of cur_month + 1
EGIT_COMMIT_RULES_CC="081771d4a0e9d7d3aa0eed2ef389fa4700dfb23e"			# From https://github.com/tensorflow/runtime/blob/769f5cc9b8732933140b09e8808d13614182b496/third_party/rules_cuda/cuda/dependencies.bzl#L41  ## needs review
EGIT_COMMIT_RULES_CLOSURE="308b05b2419edb5c8ee0471b67a40403df940149"		# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/workspace3.bzl
EGIT_COMMIT_RULES_JAVA="7cf3cefd652008d0a64a419c34c13bdca6c8f178"		# From https://github.com/bazelbuild/bazel/blob/6.1.2/distdir_deps.bzl#L69
EGIT_COMMIT_RULES_PROTO="11bf7c25e666dd7ddacbcd4d4c4a9de7a25175f8"		# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/workspace0.bzl
EGIT_COMMIT_RUY="3286a34cc8de6149ac6844107dfdffac91531e72"			# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/third_party/ruy/workspace.bzl
EGIT_COMMIT_SNAPPY="984b191f0fefdeb17050b42a90b7625999c13b8d"			# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/workspace2.bzl#L594
EGIT_COMMIT_SOBOL_DATA="835a7d7b1ee3bc83e575e302a985c66ec4b65249"		# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/third_party/sobol_data/workspace.bzl
EGIT_COMMIT_STABLEHLO="9ae6c373a6e2941ff84a8831bb3724728cb2b49a"		# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/third_party/stablehlo/workspace.bzl
EGIT_COMMIT_TF_RUNTIME="769f5cc9b8732933140b09e8808d13614182b496"		# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/third_party/tf_runtime/workspace.bzl
EGIT_COMMIT_XNNPACK="b9d4073a6913891ce9cbd8965c8d506075d2a45a"			# From https://github.com/tensorflow/tensorflow/blob/v2.14.1/tensorflow/workspace2.bzl

# WARN: DO NOT HARDWRAP
bazel_external_uris="
	${bazel_external_uris_unknown}
https://github.com/abseil/abseil-cpp/archive/${EGIT_COMMIT_ABSEIL_CPP}.tar.gz -> abseil-cpp-${EGIT_COMMIT_ABSEIL_CPP}.tar.gz
https://github.com/abseil/abseil-py/archive/refs/tags/v${ABSEIL_PY_PV}.tar.gz -> abseil-py-${ABSEIL_PY_PV}.tar.gz
https://github.com/bazelbuild/apple_support/releases/download/${APPLE_SUPPORT_PV}/apple_support.${APPLE_SUPPORT_PV}.tar.gz
https://github.com/bazelbuild/bazel-skylib/releases/download/${BAZEL_SKYLIB_PV}/bazel-skylib-${BAZEL_SKYLIB_PV}.tar.gz
https://github.com/bazelbuild/bazel-toolchains/archive/${EGIT_COMMIT_BAZEL_TOOLCHAINS}.tar.gz -> bazel-toolchains-${EGIT_COMMIT_BAZEL_TOOLCHAINS}.tar.gz
https://github.com/bazelbuild/platforms/releases/download/${PLATFORMS_PV}/platforms-${PLATFORMS_PV}.tar.gz -> bazelbuild-platforms-${PLATFORMS_PV}.tar.gz
https://github.com/bazelbuild/rules_android/archive/v${RULES_ANDROID_PV}.zip -> bazelbuild-rules_android-v${RULES_ANDROID_PV}.zip
https://github.com/bazelbuild/rules_apple/releases/download/${RULES_APPLE_PV}/rules_apple.${RULES_APPLE_PV}.tar.gz
https://github.com/bazelbuild/rules_cc/archive/${EGIT_COMMIT_RULES_CC}.tar.gz -> bazelbuild-rules_cc-${EGIT_COMMIT_RULES_CC}.tar.gz
https://github.com/bazelbuild/rules_closure/archive/${EGIT_COMMIT_RULES_CLOSURE}.tar.gz -> bazelbuild-rules_closure-${EGIT_COMMIT_RULES_CLOSURE}.tar.gz
https://github.com/bazelbuild/rules_foreign_cc/archive/${RULES_FOREIGN_CC_PV}.tar.gz -> rules_foreign_cc-${RULES_FOREIGN_CC_PV}.tar.gz
https://github.com/bazelbuild/rules_java/archive/${EGIT_COMMIT_RULES_JAVA}.zip -> ${EGIT_COMMIT_RULES_JAVA}.zip
https://github.com/bazelbuild/rules_jvm_external/archive/${RULES_JVM_PV}.zip -> rules_jvm-${RULES_JVM_PV}.zip
https://github.com/bazelbuild/rules_pkg/releases/download/${RULES_PKG_PV}/rules_pkg-${RULES_PKG_PV}.tar.gz -> bazelbuild-rules_pkg-${RULES_PKG_PV}.tar.gz
https://github.com/bazelbuild/rules_proto/archive/${EGIT_COMMIT_RULES_PROTO}.tar.gz -> bazelbuild-rules_proto-${EGIT_COMMIT_RULES_PROTO}.tar.gz
https://github.com/bazelbuild/rules_python/releases/download/${RULES_PYTHON_PV}/rules_python-${RULES_PYTHON_PV}.tar.gz -> bazelbuild-rules_python-${RULES_PYTHON_PV}.tar.gz
https://github.com/bazelbuild/rules_swift/releases/download/${RULES_SWIFT_PV}/rules_swift.${RULES_SWIFT_PV}.tar.gz -> bazelbuild-rules_swift.${RULES_SWIFT_PV}.tar.gz
https://github.com/dmlc/dlpack/archive/${EGIT_COMMIT_DLPACK}.tar.gz -> dlpack-${EGIT_COMMIT_DLPACK}.tar.gz
https://github.com/google/benchmark/archive/${EGIT_COMMIT_BENCHMARK}.tar.gz -> benchmark-${EGIT_COMMIT_FARMHASH}.tar.gz
https://github.com/google/farmhash/archive/${EGIT_COMMIT_FARMHASH}.tar.gz -> farmhash-${EGIT_COMMIT_FARMHASH}.tar.gz
https://github.com/google/gemmlowp/archive/${EGIT_COMMIT_GEMMLOWP}.zip -> gemmlowp-${EGIT_COMMIT_GEMMLOWP}.zip
https://github.com/google/highwayhash/archive/${EGIT_COMMIT_HIGHWAYHASH}.tar.gz -> highwayhash-${EGIT_COMMIT_HIGHWAYHASH}.tar.gz
https://github.com/google/re2/archive/${EGIT_COMMIT_RE2}.tar.gz -> re2-${EGIT_COMMIT_RE2}.tar.gz
https://github.com/google/ruy/archive/${EGIT_COMMIT_RUY}.zip -> ruy-${EGIT_COMMIT_RUY}.zip
https://github.com/google/snappy/archive/${EGIT_COMMIT_SNAPPY}.tar.gz -> snappy-${EGIT_COMMIT_SNAPPY}.tar.gz
https://github.com/googleapis/googleapis/archive/${EGIT_COMMIT_GOOGLEAPIS}.tar.gz -> googleapis-${EGIT_COMMIT_GOOGLEAPIS}.tar.gz
https://github.com/joe-kuo/sobol_data/archive/${EGIT_COMMIT_SOBOL_DATA}.tar.gz -> sobol_data-${EGIT_COMMIT_SOBOL_DATA}.tar.gz
https://github.com/llvm/llvm-project/archive/${EGIT_COMMIT_LLVM}.tar.gz -> llvm-project-${EGIT_COMMIT_LLVM}.tar.gz
https://github.com/llvm/llvm-project/releases/download/llvmorg-${OPENMP_PV}/openmp-${OPENMP_PV}.src.tar.xz -> llvmorg-${OPENMP_PV}-openmp-${OPENMP_PV}.src.tar.xz
https://github.com/mborgerding/kissfft/archive/${KISSFFT_PV}.tar.gz -> kissfft-${KISSFFT_PV}.tar.gz
https://github.com/oneapi-src/oneDNN/archive/refs/tags/v${ONEDNN_PV}.tar.gz -> oneDNN-v${ONEDNN_PV}.tar.gz
https://github.com/openxla/stablehlo/archive/${EGIT_COMMIT_STABLEHLO}.zip -> openxla-stablehlo-${EGIT_COMMIT_STABLEHLO}.zip
https://github.com/petewarden/OouraFFT/archive/v${OOURA_FFT_PV}.tar.gz -> OouraFFT-v${OOURA_FFT_PV}.tar.gz
https://github.com/pybind/pybind11_abseil/archive/${EGIT_COMMIT_PYBIND11_ABSEIL}.tar.gz -> pybind11_abseil-${EGIT_COMMIT_PYBIND11_ABSEIL}.tar.gz
https://github.com/pybind/pybind11_bazel/archive/${EGIT_COMMIT_PYBIND11_BAZEL}.tar.gz -> pybind11_bazel-${EGIT_COMMIT_PYBIND11_BAZEL}.tar.gz
https://github.com/pybind/pybind11_protobuf/archive/${EGIT_COMMIT_PYBIND11_PROTOBUF}.zip -> pybind11_protobuf-${EGIT_COMMIT_PYBIND11_PROTOBUF}.zip
https://github.com/pytorch/cpuinfo/archive/${EGIT_COMMIT_CPUINFO}.zip -> pytorch-cpuinfo-${EGIT_COMMIT_CPUINFO}.zip
https://github.com/tensorflow/runtime/archive/${EGIT_COMMIT_TF_RUNTIME}.tar.gz -> tensorflow-runtime-${EGIT_COMMIT_TF_RUNTIME}.tar.gz
https://github.com/google/flatbuffers/archive/v${FLATBUFFERS_PV}.tar.gz -> flatbuffers-v${FLATBUFFERS_PV}.tar.gz
https://github.com/google/XNNPACK/archive/${EGIT_COMMIT_XNNPACK}.zip -> XNNPACK-${EGIT_COMMIT_XNNPACK}.zip
https://github.com/Maratyszcza/pthreadpool/archive/${EGIT_COMMIT_PTHREADPOOL}.zip -> pthreadpool-${EGIT_COMMIT_PTHREADPOOL}.zip
https://github.com/Maratyszcza/FP16/archive/${EGIT_COMMIT_FP16}.zip -> FP16-${EGIT_COMMIT_FP16}.zip
https://github.com/Maratyszcza/FXdiv/archive/${EGIT_COMMIT_FXDIV}.zip -> FXdiv-${EGIT_COMMIT_FXDIV}.zip
https://gitlab.com/libeigen/eigen/-/archive/${EGIT_COMMIT_LIBEIGEN}/eigen-${EGIT_COMMIT_LIBEIGEN}.tar.gz -> eigen-${EGIT_COMMIT_LIBEIGEN}.tar.gz
https://storage.googleapis.com/mirror.tensorflow.org/github.com/jax-ml/ml_dtypes/archive/${EGIT_COMMIT_ML_DTYPES}/ml_dtypes-${EGIT_COMMIT_ML_DTYPES}.tar.gz -> ml_dtypes-${EGIT_COMMIT_ML_DTYPES}.tar.gz
https://storage.googleapis.com/mirror.tensorflow.org/github.com/protocolbuffers/protobuf/archive/v${PROTOBUF_PV}.zip -> protobuf-${PROTOBUF_PV}.zip
	cuda? (
https://github.com/NVIDIA/cudnn-frontend/archive/refs/tags/v${CUDNN_FRONTEND_PV}.zip -> cudnn-frontend-v${CUDNN_FRONTEND_PV}.zip
https://github.com/NVlabs/cub/archive/${CUB_PV}.zip -> cub-${CUB_PV}.zip
https://github.com/nvidia/nccl/archive/v${NCCL_PV}.tar.gz -> nvidia-nccl-v${NCCL_PV}.tar.gz
	)
	python? (
https://github.com/intel/ARM_NEON_2_x86_SSE/archive/${EGIT_COMMIT_ARM_NEON_2_X86_SSE}.tar.gz -> ARM_NEON_2_x86_SSE-${EGIT_COMMIT_ARM_NEON_2_X86_SSE}.tar.gz
https://storage.googleapis.com/mirror.tensorflow.org/docs.python.org/2.7/_sources/license.rst.txt -> tensorflow-1.15.0-python-license.rst.txt
	)
	xla? (
https://github.com/openxla/triton/archive/${TRITON_TAG}.tar.gz -> trition-${TRITON_TAG}.tar.gz
	)
"

#KEYWORDS="~amd64 ~arm64" # Needs install check
SRC_URI="
${bazel_external_uris}
https://github.com/${PN}/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Computation framework using data flow graphs for scalable machine \
learning"
HOMEPAGE="https://www.tensorflow.org/"
THIRD_PARTY_LICENSES="
	(
		all-rights-reserved
		Apache-2.0
	)
	(
		Apache-2.0
		BSD
		BSD-2
		MIT
		PSF
	)
	(
		BSD
		minpack
		MPL-2.0
	)
	(
		icu-63.2
		Unicode-DFS-2016
	)
	BSD
	ooura
"
THIRD_PARTY_LICENSES_BAZEL_EXTERNAL_DOWNLOADS="
	(
		all-rights-reserved
		Apache-2.0-with-LLVM-exceptions
		Boost-1.0
	)
	(
		MIT
		NCSA
	)
	ISC
	MIT
	Unicode-DFS-2016
	|| (
		Apache-2.0
		CC0-1.0
	)
"
LICENSE="
	${THIRD_PARTY_LICENSES}
	${THIRD_PARTY_LICENSES_BAZEL_EXTERNAL_DOWNLOADS}
	custom
	(
		all-rights-reserved
		Apache-2.0
	)
	Apache-2.0
	BSD-2
"
# From src_unpack() only
# ( all-rights-reserved Apache-2.0 ) - tools/lib_package/concat_licenses.sh ; \
#   The distro's Apache-2.0 license template does not have all rights reserved
#   in the APPENDIX section.  All rights reserved appears in the 1.1 but not in
#   the 2.0.
# BSD BSD-2 PSF Apache-2.0 MIT - third_party/py/numpy/LICENSE
#   numpy/core/src/multiarray/dragon4.c (MIT) ; This file was not found but \
#   may be included from a binary, static lib, or system header.
# Unicode-DFS-2016, icu-63.2 - third_party/icu/data/LICENSE ; See \
#   https://github.com/unicode-org/icu/blob/release-63-2/icu4j/main/shared/licenses/LICENSE
# all-rights-reserved Apache-2.0 - third_party/tensorrt/LICENSE
# ooura - third_party/fft2d/LICENSE
# BSD - third_party/nccl/LICENSE
# MPL-2.0 BSD minpack - third_party/eigen3/LICENSE
# custom Apache-2.0 BSD-2 - LICENSE
#   custom keywords:  "their specific copyright on a particular contribution"

# From bazel_external_uris and ${T}/bazel-distfiles:
# Apache-2.0-with-LLVM-exceptions all-rights-reserved Boost-1.0 - d8415b02a519f222ecf71b069c96cc85ac635de3/llvm-project-d8415b02a519f222ecf71b069c96cc85ac635de3/libcxx/src/ryu/f2s.cpp
# ISC - d8415b02a519f222ecf71b069c96cc85ac635de3/llvm-project-d8415b02a519f222ecf71b069c96cc85ac635de3/llvm/lib/Support/regstrlcpy.c
# MIT NCSA (aka UIUC) - d8415b02a519f222ecf71b069c96cc85ac635de3/llvm-project-d8415b02a519f222ecf71b069c96cc85ac635de3/libcxxabi/www/index.html
# MIT d8415b02a519f222ecf71b069c96cc85ac635de3/llvm-project-d8415b02a519f222ecf71b069c96cc85ac635de3/compiler-rt/lib/BlocksRuntime/runtime.c
# Unicode-DFS-2016 [2 clause] - d8415b02a519f222ecf71b069c96cc85ac635de3/llvm-project-d8415b02a519f222ecf71b069c96cc85ac635de3/llvm/lib/Support/UnicodeNameToCodepointGenerated.cpp
# Apache-2.0-with-LLVM-exceptions ( NCSA MIT ) custom  - ./openmp-10.0.1.src/LICENSE.txt
# custom keywords: "Software Grant License Agreement"
#                  "2. Grant of Patent License."
# || ( CC0-1.0 Apache-2.0 ) - llvm-project-d8415b02a519f222ecf71b069c96cc85ac635de3/llvm/lib/Support/BLAKE3/LICENSE

RESTRICT="" # Tests need GPU access.  Relaxed python deps patches breaks tests.
SLOT="0"
CPU_USE_FLAGS_X86=(
#	popcnt     # No preprocessor check but set in CI or some archs
	sse
	sse2
	sse3
	sse4_1
	sse4_2
	avx
	avx2
# Addresses the get-cpu-flags() request for keep flags in sync.
#	avx512f    # *
#	avx512cd   # *
#	avx512vnni # *
#	avx512bf16 # *
#	avxvnni    # *
#	amx-tile   # *
#	amx-int8   # *
#	amx-bf16   # *
	fma3
	fma4
)
# * Checks only but does no work.
IUSE="
${CPU_USE_FLAGS_X86[@]/#/cpu_flags_x86_}
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
${HIP_SLOTS2[@]}
${LLVM_COMPAT[@]/#/llvm_slot_}
alt-ssl -big-endian clang cuda models -mpi +python rocm
system-flatbuffers test +xla
ebuild_revision_10
"
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
REQUIRED_USE="
	$(gen_required_use_cuda_targets)
	$(gen_required_use_rocm_targets)
	?? (
		${LLVM_COMPAT[@]/#/llvm_slot_}
	)
	cuda? (
		|| (
			${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
		)
	)
	python? (
		${PYTHON_REQUIRED_USE}
	)
	rocm? (
		${ROCM_REQUIRED_USE}
		^^ (
			${HIP_SLOTS2[@]}
		)
	)
	rocm_5_6? (
		llvm_slot_16
	)
	rocm_5_5? (
		llvm_slot_16
	)
	rocm_5_4? (
		llvm_slot_15
	)
	rocm_5_3? (
		llvm_slot_15
	)
	test? (
		python
	)
" # The test USE flag is limited by the dev-python/gast package.

# abseil-cpp-20211102.0-r0 does not work with NVCC
# >=grpc-1.27 and >=1.24.3 is upstream minimal but incorrect
# >=grpc-1.48 is the correct for compatibility with abseil-cpp 20220623 lts
# grpcio version should match grpc
# Apache-2.0 is only license compatible with >=openssl-3
# The distro only has 11.8, 12.3 for cuda.  The exact version preferred due
# to binary compatibility.
CUDA_CDEPEND="
	(
		(
			>=dev-util/nvidia-cuda-toolkit-${CUDA_PV}:=[profiler]
			<dev-util/nvidia-cuda-toolkit-$(( $(ver_cut 1 ${CUDA_PV}) + 1 )):=[profiler]
		)
		sys-devel/gcc:${GCC_SLOT_WITH_CUDA}
	)
"

gen_rocm_rdepend() {
	local pv
	for pv in ${HIP_SLOTS[@]} ; do
		local s=$(ver_cut 1-2 ${pv})
		local u="${s}"
		u="${u/./_}"
	# Check both the direct top and indirect bottom dependencies
		echo "
			rocm_${u}? (
				~dev-libs/rccl-${pv}:${s}
				~dev-libs/rocm-device-libs-${pv}:${s}
				~dev-util/hip-${pv}:${s}[rocm]
				~dev-util/roctracer-${pv}:${s}
				~sci-libs/hipBLAS-${pv}:${s}[rocm]
				~sci-libs/hipFFT-${pv}:${s}$(get_rocm_usedep HIPFFT)
				~sci-libs/hipSOLVER-${pv}:${s}[rocm]
				~sci-libs/hipSPARSE-${pv}:${s}[rocm]
				~sci-libs/rocBLAS-${pv}:${s}$(get_rocm_usedep ROCBLAS)
				~sci-libs/rocFFT-${pv}:${s}$(get_rocm_usedep ROCFFT)
				~sci-libs/rocRAND-${pv}:${s}$(get_rocm_usedep ROCRAND)
				~sci-libs/rocSOLVER-${pv}:${s}$(get_rocm_usedep ROCSOLVER)
				~sci-libs/miopen-${pv}:${s}$(get_rocm_usedep MIOPEN)

				~dev-libs/rocm-comgr-${pv}:${s}
				~dev-libs/rocr-runtime-${pv}:${s}
				~dev-build/rocm-cmake-${pv}:${s}
				~dev-util/rocm-smi-${pv}:${s}
				~dev-util/rocminfo-${pv}:${s}
				~dev-util/Tensile-${pv}:${s}$(get_rocm_usedep TENSILE)

				llvm-core/lld:${LLD_SLOT[${pv}]}
			)
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
	done
}

GOOGLE_CLOUD_CPP_PROTOBUF_5_26="
	python? (
		|| (
			=net-libs/google-cloud-cpp-2.24*
			=net-libs/google-cloud-cpp-2.23*
		)
	)
"
GOOGLE_CLOUD_CPP_PROTOBUF_4_25="
	python? (
		|| (
			=net-libs/google-cloud-cpp-2.22*
			=net-libs/google-cloud-cpp-2.21*
			=net-libs/google-cloud-cpp-2.19*
		)
	)
"
GOOGLE_CLOUD_CPP_PROTOBUF_4_24="
	python? (
		|| (
			=net-libs/google-cloud-cpp-2.18*
			=net-libs/google-cloud-cpp-2.17*
			=net-libs/google-cloud-cpp-2.16*
			=net-libs/google-cloud-cpp-2.15*
		)
	)
"
GOOGLE_CLOUD_CPP_PROTOBUF_4_23="
	python? (
		|| (
			=net-libs/google-cloud-cpp-2.14*
			=net-libs/google-cloud-cpp-2.13*
			=net-libs/google-cloud-cpp-2.12*
			=net-libs/google-cloud-cpp-2.11*
		)
	)
"
GOOGLE_CLOUD_CPP_PROTOBUF_3_21="
	python? (
		|| (
			=net-libs/google-cloud-cpp-2.10*
			=net-libs/google-cloud-cpp-2.9*
		)
	)
"
gen_protobuf_rdepend1() {
	local row
	for row in ${GRPC_PROTOBUF_PAIRS[@]} ; do
		local grpc_pv="${row%:*}"
		local protobuf_pv="${row#*:}"
		local protobuf_name="GOOGLE_CLOUD_CPP_PROTOBUF_${protobuf_pv/./_}"
		local impl
		for impl in ${PYTHON_COMPAT[@]} ; do
			echo  "
				(
					${!protobuf_name}
					!big-endian? (
						python_single_target_${impl}? (
							=net-libs/grpc-${grpc_pv}*[python_targets_${impl}(-),python]
						)
					)
					big-endian? (
						=net-libs/grpc-${grpc_pv}*[-python]
					)
				)
			"
		done
	done
}
RDEPEND_PROTOBUF="
	|| (
		$(gen_protobuf_rdepend1)
	)
	python? (
		net-libs/google-cloud-cpp:=
	)
	net-libs/grpc:=
"

gen_grpcio_rdepend1() {
	local row
	for row in ${GRPC_PROTOBUF_PAIRS[@]} ; do
		local grpc_pv="${row%:*}"
		local protobuf_pv="${row#*:}"
		local impl
		for impl in ${PYTHON_COMPAT[@]} ; do
			echo  "
				(
					=dev-python/grpcio-${grpc_pv}*:=[python_targets_${impl}(-)]
					=dev-python/grpcio-tools-${grpc_pv}*:=[python_targets_${impl}(-)]
					=net-libs/grpc-${grpc_pv}*[python_targets_${impl}(-),python]
					dev-python/protobuf:0/${protobuf_pv}[python_targets_${impl}(-)]
				)
			"
		done
	done
}
RDEPEND_GRPCIO="
	|| (
		$(gen_grpcio_rdepend1)
	)
	dev-python/grpcio:=
	dev-python/grpcio-tools:=
	dev-python/protobuf:=
	net-libs/grpc:=
"

# Missing extension package for TF_ENABLE_ONEDNN_OPTS=1
# The grpcio slots below are limited by protobuf:0/32.
# TODO package
# dev-python/portpicker
#
# google-cloud-cpp acceptable range: [2.9.0-2.10.1] based on same major
# abseil-cpp version and same major-minor of protobuf without multiple
# slot conflict.
#
gen_protobuf_rdepend() {
	local s
	for s in ${PROTOBUF_SLOTS[@]} ; do
		local impl
		for impl in ${PYTHON_COMPAT[@]} ; do
			echo "
				(
					dev-libs/protobuf:0/${s}
					python? (
						python_single_target_${impl}? (
							dev-python/protobuf:0/${s}[python_targets_${impl}(-)]
						)
					)
				)
			"
		done
	done
}
# The abseil-cpp rdepends is handled by protobuf package.
RDEPEND="
	${RDEPEND_PROTOBUF}
	>=dev-db/sqlite-3.40.1
	>=dev-libs/double-conversion-3.2.0
	>=dev-libs/icu-69.1:=
	>=dev-libs/jsoncpp-1.9.5:=
	>=dev-libs/nsync-1.25.0
	>=dev-libs/re2-0.2023.06.01:0/11
	>=media-libs/giflib-5.2.1
	>=media-libs/libjpeg-turbo-2.1.4
	>=media-libs/libpng-1.6.39:0
	>=net-misc/curl-8.4.0
	>=sys-apps/hwloc-2.7.1:=
	>=sys-libs/zlib-1.2.13
	|| (
		$(gen_protobuf_rdepend)
	)
	dev-libs/protobuf:=
	!alt-ssl? (
		>=dev-libs/openssl-3:0=
	)
	cuda? (
		${CUDA_RDEPEND}
		=dev-libs/cudnn-8.6*
	)
	mpi? (
		virtual/mpi
	)
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			(
				>=dev-python/numpy-1.23.5[${PYTHON_USEDEP}]
				<dev-python/numpy-2[${PYTHON_USEDEP}]
			)
			(
				>=dev-python/wrapt-1.11.1[${PYTHON_USEDEP}]
				<dev-python/wrapt-1.15[${PYTHON_USEDEP}]
			)
			>=dev-python/absl-py-1.0.0[${PYTHON_USEDEP}]
			>=dev-python/astunparse-1.6.0[${PYTHON_USEDEP}]
			>=dev-python/clang-13.0.0[${PYTHON_USEDEP}]
			>=dev-python/flatbuffers-'${FLATBUFFERS_PV}'[${PYTHON_USEDEP}]
			>=dev-python/gast-0.4.0[${PYTHON_USEDEP}]
			>=dev-python/google-pasta-0.2.0[${PYTHON_USEDEP}]
			>=dev-python/h5py-2.9.0[${PYTHON_USEDEP}]

			>=dev-python/opt-einsum-3.3.0[${PYTHON_USEDEP}]
			>=dev-python/six-1.12.0[${PYTHON_USEDEP}]
			>=dev-python/termcolor-1.1.0[${PYTHON_USEDEP}]
			>=dev-python/typing-extensions-3.6.6[${PYTHON_USEDEP}]

			>=dev-python/astor-0.7.1[${PYTHON_USEDEP}]
			>=dev-python/dill-0.3.6[${PYTHON_USEDEP}]
			>=dev-python/pybind11-2.10.4[${PYTHON_USEDEP}]
			>=dev-python/tblib-1.7.0[${PYTHON_USEDEP}]
			system-flatbuffers? (
				~dev-libs/flatbuffers-'${FLATBUFFERS_PV}'
			)
		')
		!big-endian? (
			${RDEPEND_GRPCIO}
		)
		=sci-visualization/tensorboard-${DEP_VER}*[${PYTHON_SINGLE_USEDEP}]
	)
	rocm? (
		$(gen_rocm_rdepend)
		dev-util/hip:=
	)
"
DEPEND="
	${RDEPEND}
	python? (
		$(python_gen_cond_dep '
			dev-python/setuptools[${PYTHON_USEDEP}]
			test? (
				dev-python/mock[${PYTHON_USEDEP}]
			)
		')
		test? (
			>=dev-python/jax-0.4.7[${PYTHON_SINGLE_USEDEP}]
		)
	)
"
PDEPEND="
	models? (
		sci-misc/tf-models-official:0/${PV%.*}[${PYTHON_SINGLE_USEDEP}]
	)
	python? (
		$(python_gen_cond_dep '
			=sci-ml/tensorflow-io-0.35.0[${PYTHON_SINGLE_USEDEP},tensorflow-io-gcs-filesystem]
		' python3_{10,11})
		=dev-python/keras-${DEP_VER}*[${PYTHON_SINGLE_USEDEP}]
		=sci-ml/tensorflow-estimator-${DEP_VER}*[${PYTHON_SINGLE_USEDEP}]
	)
"
gen_llvm_bdepend() {
	for s in ${LLVM_COMPAT[@]} ; do
		if (( ${s} >= 16 )) ; then
			echo "
				(
					llvm-core/clang:${s}
					llvm-core/llvm:${s}
					llvm-core/lld:${s}
				)
			"
		else
			# Monoslotted at < lld-15.0.3
			echo "
				(
					llvm-core/clang:${s}
					llvm-core/llvm:${s}
					>=llvm-core/lld-${s}
				)
			"
		fi
	done
}

gen_gcc_bdepend() {
	local s
	echo "|| ("
	for s in ${GCC_COMPAT[@]} ; do
		echo "
			=sys-devel/gcc-${s}*:${s}
		"
	done
	echo ")"
}

# Did not find grpc-tools
# grpcio-tools versioning based on grpcio
# GCC:11 - Based on archlinux
# gcc-11.3.1_p20221209-p3 does not build
BDEPEND="
	>=dev-build/bazel-${BAZEL_PV}:${BAZEL_PV%.*}
	app-arch/pigz
	app-arch/unzip
	dev-java/java-config
	dev-util/patchelf
	!clang? (
		!cuda? (
			$(gen_gcc_bdepend)
		)
	)
	!cuda? (
		sys-devel/gcc:${GCC_SLOT_WITH_CUDA}
	)
	!python? (
		dev-lang/python
	)
	clang? (
		|| (
			$(gen_llvm_bdepend)
		)
	)
	cuda? (
		${CUDA_CDEPEND}
		sys-devel/gcc:${GCC_SLOT_WITH_CUDA}
	)
	python? (
		!big-endian? (
			${RDEPEND_GRPCIO}
		)
		$(python_gen_cond_dep '
			>=dev-python/cython-3.0.0_alpha11:3.0[${PYTHON_USEDEP}]
			>=dev-python/packaging-23.1[${PYTHON_USEDEP}]
			>=dev-python/requests-2.31.0[${PYTHON_USEDEP}]
			>=dev-python/setuptools-67.6.1[${PYTHON_USEDEP}]
			test? (
				>=dev-python/lit-16.0.5_p0[${PYTHON_USEDEP}]
				>=dev-python/scipy-1.10.1[${PYTHON_USEDEP}]
				dev-python/mock[${PYTHON_USEDEP}]
			)
		')
	)
	rocm? (
		rocm_5_3? (
			sys-devel/gcc:${HIP_5_3_GCC_SLOT}
		)
		rocm_5_4? (
			sys-devel/gcc:${HIP_5_4_GCC_SLOT}
		)
		rocm_5_5? (
			sys-devel/gcc:${HIP_5_5_GCC_SLOT}
		)
		rocm_5_6? (
			sys-devel/gcc:${HIP_5_6_GCC_SLOT}
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
DOCS=( "AUTHORS" "README.md" "RELEASE.md" )
PATCHES=(
	"${FILESDIR}/2.14.1/tensorflow-2.14.1-0001-WORKSPACE-add-rules-docker-http_archive-bazel-toolch.patch"
	"${FILESDIR}/2.14.1/tensorflow-2.14.1-0002-systemlib-Latest-absl-LTS-has-split-cord-libs.patch"
	"${FILESDIR}/2.14.1/tensorflow-2.14.1-0003-mkl_dnn-Must-link-against-libm-for-round-and-log2.patch"
	"${FILESDIR}/2.14.1/tensorflow-2.14.1-0004-tensorflow_cc-Add-systemlib-nsync-linkopts.patch"
	"${FILESDIR}/2.14.1/tensorflow-2.14.1-0005-systemlib-Updates-for-Abseil-20220623-LTS.patch"
	"${FILESDIR}/2.14.1/tensorflow-2.14.1-0006-systemlib-Update-targets-for-absl_py.patch"
	"${FILESDIR}/2.14.1/tensorflow-2.14.1-0007-systemlib-Add-well_known_types_py_pb2-target.patch"
	"${FILESDIR}/2.14.1/tensorflow-2.14.1-0008-Relax-setup.py-version-requirements.patch"
	"${FILESDIR}/2.14.1/tensorflow-2.14.1-0009-systemlib-update-targets-for-absl.patch"
	"${FILESDIR}/2.14.1/tensorflow-2.14.1-0010-systemlib-fix-missing-osx-in-pybind11.patch"
	"${FILESDIR}/2.14.1/tensorflow-2.14.1-0011-systemlib-fix-missing-LICENSE-in-flatbuffers.patch"
	"${FILESDIR}/2.14.1/tensorflow-2.14.1-0012-build-use-non-hermetic-python.patch"
	"${FILESDIR}/2.14.1/tensorflow-2.14.1-0013-installation-remove-cp_local_config_python.patch"
	"${FILESDIR}/2.14.1/tensorflow-2.14.1-0014-Fixing-build-issue-with-Clang-16.patch"
)
ROCM_PATCHES=(
	"0050-fix-rocm-build-scripts.patch"
	"0050-fix-rocm-headers.patch"
	"0050-fix-rocm-source-code.patch"
	"0050-fix-rocm-support.patch"
	"0050-toolchain-prefix.patch"
)

get-cpu-flags() {
	local i f=()
	# Keep this list in sync with tensorflow/core/platform/cpu_feature_guard.cc.
	for i in ${CPU_USE_FLAGS_X86[@]/fma3/} ; do
		use cpu_flags_x86_${i} && f+=( -m${i/_/.} )
	done
	use cpu_flags_x86_fma3 && f+=( -mfma )
	echo "${f[*]}"
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

	if ver_test ${pv} -lt 10 ; then
		ncomponents=3
	elif [[ ${slot} -eq 10 ]] && ver_test ${pv} -ge 10.4.1_p20220929 ; then
		ncomponents=1
	elif [[ ${slot} -eq 11 ]] && ver_test ${pv} -ge 11.3.1_p20220930 ; then
		ncomponents=1
	elif [[ ${slot} -eq 12 ]] && ver_test ${pv} -ge 12.2.1_p20221001 ; then
		ncomponents=1
	elif [[ ${slot} -eq 13 ]] && ver_test ${pv} -ge 13.0.0_pre20221002 ; then
		ncomponents=1
	elif [[ ${slot} -gt 13 ]] ; then
		ncomponents=1
	fi

	if [[ ${ncomponents} -eq 1 ]] ; then
		ver_cut 1 ${pv}
		return
	fi

	ver_cut 1-3 ${pv}
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
	use cuda && GCC_COMPAT=( ${GCC_SLOT_WITH_CUDA} )
	local s
	for s in ${GCC_COMPAT[@]} ; do
		local symlink_ver=$(gcc_symlink_ver ${s})
		export CC="${CHOST}-gcc-${symlink_ver}"
		export CXX="${CHOST}-g++-${symlink_ver}"
		export CPP="${CC} -E"
		strip-unsupported-flags
		if ${CC} --version 2>/dev/null 1>/dev/null ; then
			check_libstdcxx ${s}
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
eerror
eerror "Use only gcc slots ${GCC_COMPAT[@]}"
eerror
		die
	fi
	if (( ${found2} == 1 )) ; then
		:;
	else
ewarn
ewarn "Using ${s} is not supported upstream.  This compiler slot is in testing."
ewarn
ewarn "  Build time success on 2.11.0:"
ewarn
ewarn "    =sys-devel/gcc-11.3.1_p20230120-r1 with gold"
ewarn "    =sys-devel/gcc-12.2.1_p20230121-r1 with mold"
ewarn
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

	if use rocm ; then
		if has rocm_5_6 ${IUSE_EFFECTIVE} && use rocm_5_6 ; then
			_LLVM_COMPAT=( 16 )
		elif has rocm_5_5 ${IUSE_EFFECTIVE} && use rocm_5_5 ; then
			_LLVM_COMPAT=( 16 )
		elif has rocm_5_4 ${IUSE_EFFECTIVE} && use rocm_5_4 ; then
			_LLVM_COMPAT=( 15 )
		elif has rocm_5_3 ${IUSE_EFFECTIVE} && use rocm_5_3 ; then
			_LLVM_COMPAT=( 15 )
		elif has rocm_5_2 ${IUSE_EFFECTIVE} && use rocm_5_2 ; then
			_LLVM_COMPAT=( 14 )
		elif has rocm_5_1 ${IUSE_EFFECTIVE} && use rocm_5_1 ; then
			_LLVM_COMPAT=( 14 )
		elif has rocm_5_0 ${IUSE_EFFECTIVE} && use rocm_5_0 ; then
			_LLVM_COMPAT=( 14 )
		fi
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
		:;
	else
ewarn "Using ${s} is not supported upstream.  This compiler slot is in testing."
	fi
	LLVM_SLOT=${s}
	llvm_pkg_setup
	${CC} --version || die
	strip-unsupported-flags
}

check_cython() {
	local actual_cython_pv=$(cython --version 2>&1 \
		| cut -f 3 -d " " \
		| sed -e "s|a|_alpha|g" \
		| sed -e "s|b|_beta|g" \
		| sed -e "s|rc|_rc|g")
	local actual_cython_slot=$(ver_cut 1-2 "${actual_cython_pv}")
	local expected_cython_slot="3.0"
	if [[ "${actual_cython_pv}" == "python-exec" ]] ; then
eerror
eerror "Do \`eselect cython set ${expected_cython_slot}\` to continue."
eerror
		die
	fi
	if ver_test "${actual_cython_slot}" -ne "${expected_cython_slot}" ; then
eerror
eerror "Do \`eselect cython set ${expected_cython_slot}\` to continue."
eerror
eerror "Actual cython version:\t${actual_cython_pv}"
eerror "Expected cython version\t${expected_cython_slot}"
eerror
		die
	fi
}

check_libstdcxx() {
	local slot="${1}"
	local gcc_current_profile=$(gcc-config -c)
	local gcc_current_profile_slot=${gcc_current_profile##*-}

	if ver_test "${gcc_current_profile_slot}" -ne "${slot}" ; then
eerror
eerror "You must switch to GCC ${slot}.  Do"
eerror
eerror "  eselect gcc set ${CHOST}-${slot}"
eerror "  source /etc/profile"
eerror
eerror "This is a temporary for ${PN}:${SLOT}.  You must restore it back"
eerror "to the default immediately after this package has been merged."
eerror
		die
	fi
}

pkg_setup() {
	dhms_start
use rocm && ewarn "The rocm USE flag is currently broken"
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

		local gcc_slot
		# Build with GCC but initialize LLVM_SLOT.
		if has rocm_5_6 ${IUSE_EFFECTIVE} && use rocm_5_6 ; then
			LLVM_SLOT=16
			ROCM_SLOT="5.6"
			ROCM_VERSION="${HIP_5_6_VERSION}"
		elif has rocm_5_5 ${IUSE_EFFECTIVE} && use rocm_5_5 ; then
			LLVM_SLOT=16
			ROCM_SLOT="5.5"
			ROCM_VERSION="${HIP_5_5_VERSION}"
		elif has rocm_5_4 ${IUSE_EFFECTIVE} && use rocm_5_4 ; then
			LLVM_SLOT=15
			ROCM_SLOT="5.4"
			ROCM_VERSION="${HIP_5_4_VERSION}"
		elif has rocm_5_3 ${IUSE_EFFECTIVE} && use rocm_5_3 ; then
			LLVM_SLOT=15
			ROCM_SLOT="5.3"
			ROCM_VERSION="${HIP_5_3_VERSION}"
		elif has rocm_5_2 ${IUSE_EFFECTIVE} && use rocm_5_2 ; then
			LLVM_SLOT=14
			ROCM_SLOT="5.2"
			ROCM_VERSION="${HIP_5_2_VERSION}"
		elif has rocm_5_1 ${IUSE_EFFECTIVE} && use rocm_5_1 ; then
			LLVM_SLOT=14
			ROCM_SLOT="5.1"
			ROCM_VERSION="${HIP_5_1_VERSION}"
		elif has rocm_5_0 ${IUSE_EFFECTIVE} && use rocm_5_0 ; then
			LLVM_SLOT=14
			ROCM_SLOT="5.0"
			ROCM_VERSION="${HIP_5_0_VERSION}"
		fi
		local _gcc_slot="HIP_${ROCM_SLOT/./_}_GCC_SLOT"
		local gcc_slot="${!_gcc_slot}"
		check_libstdcxx ${gcc_slot}
	elif tc-is-clang || use clang ; then
		use_gcc
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

	if tc-is-clang ; then
		if use cuda ; then
			check_libstdcxx 11
		fi
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
			"rocsolver:sci-libs/rocSOLVER"
			"roctracer64:dev-util/roctracer"
		)
		local glibcxx_ver="HIP_${ROCM_SLOT/./_}_GLIBCXX"
	# Avoid missing versioned symbols
	# # ld: /opt/rocm-6.1.2/lib/librocblas.so: undefined reference to `std::ios_base_library_init()@GLIBCXX_3.4.32'
		rocm_verify_glibcxx "${!glibcxx_ver}" ${libs[@]}

	#else
	#	llvm_pkg_setup called in use_clang
	fi

	local num_pythons_enabled
	num_pythons_enabled=0
	count_py_impls() {
		num_pythons_enabled=$((${num_pythons_enabled} + 1))
	}
	python_setup
	python_foreach_impl count_py_impls

	# 10G to build C/C++ libs, 6G per python impl
	CHECKREQS_DISK_BUILD="$((10 + 6 * ${num_pythons_enabled}))G"
	check-reqs_pkg_setup

	if ! [[ "${BAZEL_LD_PRELOAD_IGNORED_RISKS}" =~ ("allow"|"accept") ]] ; then
# A reaction to "WARNING: ignoring LD_PRELOAD in environment" maybe reported by Bazel.
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
	if [[ "${FEATURES}" =~ "ccache" ]] ; then
ewarn "ccache support for this package is in TESTING.  Disable ccache if problematic."
	fi
}

src_unpack() {
	# Only unpack the main distfile
	unpack "${P}.tar.gz"
	mkdir -p "${WORKDIR}/bin" || die
	export PATH="${WORKDIR}/bin:${PATH}"
	ln -s "/usr/bin/bazel-${BAZEL_PV%.*}" "${WORKDIR}/bin/bazel" || die
	bazel --version | grep -q "bazel ${BAZEL_PV%.*}" || die "dev-build/bazel:${BAZEL_PV%.*} is not installed"
	bazel_load_distfiles "${bazel_external_uris}"
}

setup_linker() {
	if use rocm ; then
		return
	fi

	# The package likes to use lld with gcc which is disallowed.
	LLD="ld.lld"
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
einfo "Using mold"
		ld.mold --version || die
		filter-flags '-fuse-ld=*'
		append-ldflags -fuse-ld=mold
		BUILD_LDFLAGS+=" -fuse-ld=mold"
	elif \
		tc-is-clang \
		&& ( \
			   ! is-flagq '-fuse-ld=gold' \
			&& ! is-flagq '-fuse-ld=bfd' \
		) \
		&& \
		( \
			( \
				has_version "sys_devel/lld:$(clang-major-version)" \
			) \
			|| \
			( \
				ver_test $(clang-major-version) -lt 13 \
				&& ver_test ${lld_pv} -ge $(clang-major-version) \
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
ewarn
ewarn "Using gold.  Expect linking times more than 30 hrs on older machines."
ewarn "Consider using -fuse-ld=mold or -fuse-ld=lld."
ewarn
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
ewarn
ewarn "Using BFD.  Expect linking times more than 45 hrs on older machines."
ewarn "Consider using -fuse-ld=mold or -fuse-ld=lld."
ewarn
		ld.bfd --version || die
		append-ldflags -fuse-ld=bfd
		BUILD_LDFLAGS+=" -fuse-ld=bfd"
		# No threading flags
	fi

	strip-unsupported-flags # Filter LDFLAGS after switch
}

gen_gcc_ar(){
	local gcc_slot=$(gcc-major-version)
	local dir
	if use python ; then
		dir="${WORKDIR}/tensorflow-${PV}-${EPYTHON/./_}-bazel-base/execroot/org_tensorflow"
	else
		dir="${WORKDIR}/tensorflow-${PV}-bazel-base/execroot/org_tensorflow"
	fi
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

patch_rocm() {
	mkdir -p "${WORKDIR}/patches" || die
	cp -a "${FILESDIR}/${PV}/rocm/" "${WORKDIR}/patches" || die
	if use rocm ; then
		rm "third_party/gpus/find_rocm_config.py.gz.base64" || die
		local f
		for f in ${ROCM_PATCHES[@]} ; do
			eapply "${WORKDIR}/patches/rocm/${f}"
		done
	fi

	# Speed up symbol replacmenet for @...@ by reducing the search space
	# Generated from below one liner ran in the same folder as this file:
	# grep -F -r -e "+++" $(find files/*/rocm -name "*.patch") | cut -f 2 -d " " | cut -f 1 -d $'\t' | sort | uniq | cut -f 2- -d $'/' | sort | uniq
	PATCH_PATHS=(
		"${S}/tensorflow/compiler/mlir/tools/kernel_gen/transforms/gpu_kernel_to_blob_pass.cc"
		"${S}/tensorflow/compiler/xla/service/gpu/llvm_gpu_backend/gpu_backend_lib.cc"
		"${S}/tensorflow/compiler/xla/stream_executor/gpu/asm_compiler.cc"
		"${S}/tensorflow/core/util/gpu_solvers.h"
		"${S}/tensorflow/tools/pip_package/setup.py"
		"${S}/tensorflow/tsl/platform/default/rocm_rocdl_path.cc"
		"${S}/third_party/gpus/crosstool/cc_toolchain_config.bzl.tpl"
		"${S}/third_party/gpus/crosstool/clang/bin/crosstool_wrapper_driver_rocm.tpl"
		"${S}/third_party/gpus/crosstool/hipcc_cc_toolchain_config.bzl.tpl"
		"${S}/third_party/gpus/rocm_configure.bzl"
		"${S}/third_party/xla/third_party/tsl/tsl/platform/default/rocm_rocdl_path.cc"
		"${S}/third_party/xla/xla/service/gpu/llvm_gpu_backend/gpu_backend_lib.cc"
		"${S}/third_party/xla/xla/stream_executor/gpu/asm_compiler.cc"
	)
	if use rocm ; then
		rocm_src_prepare
	fi
	pushd "third_party/gpus" || die
		pigz -z -k "find_rocm_config.py" || die
		mv \
			"find_rocm_config.py.zz" \
			"find_rocm_config.py.gz" \
			|| die
		base64 --wrap=0 \
			"find_rocm_config.py.gz" \
			> \
			"find_rocm_config.py.gz.base64" \
			|| die
	popd || die
}

src_prepare() {
	local total_ram=$(free | grep "Mem:" | sed -E -e "s|[ ]+| |g" | cut -f 2 -d " ")
	local total_ram_gib=$(( ${total_ram} / (1024*1024) ))
	local total_swap=$(free | grep "Swap:" | sed -E -e "s|[ ]+| |g" | cut -f 2 -d " ")
	[[ -z "${total_swap}" ]] && total_swap=0
	local total_swap_gib=$(( ${total_swap} / (1024*1024) ))
	local total_mem=$(free -t | grep "Total:" | sed -E -e "s|[ ]+| |g" | cut -f 2 -d " ")
	local total_mem_gib=$(( ${total_mem} / (1024*1024) ))

	local jobs=$(get_makeopts_jobs)
	local cores=$(get_nproc)

	local minimal_gib_per_core=8
	local actual_gib_per_core=$(python -c "print(${total_mem_gib} / ${cores})")

	if (( ${actual_gib_per_core%.*} <= ${minimal_gib_per_core} || ${cores} <= 4 )) ; then
ewarn "Minimal GiB per core:  >= ${minimal_gib_per_core} GiB"
ewarn "Actual GiB per core:  ${actual_gib_per_core} GiB"
		filter-flags '-flto*'
ewarn "Disabling LTO to speed up build time."
	else
einfo "Minimal GiB per core:  >= ${minimal_gib_per_core} GiB"
einfo "Actual GiB per core:  ${actual_gib_per_core} GiB"
	fi

	export JAVA_HOME=$(java-config --jre-home) # so keepwork works
	export TF_PYTHON_VERSION="${EPYTHON/python/}"

	if use rocm ; then
		rocm_set_default_gcc
		filter-flags '-fuse-ld=*'
		append-ldflags -fuse-ld=lld
		BUILD_LDFLAGS+=" -fuse-ld=lld"
		strip-unsupported-flags # Filter linker flags
	fi

ewarn
ewarn "If build failure, use MAKEOPTS=\"-j1\".  Expect memory use to be 6-11"
ewarn "GiB per process."
ewarn

	append-flags $(get-cpu-flags)
	append-cxxflags -std=c++17
	export BUILD_CXXFLAGS+=" -std=c++17"
	filter-flags '-fvtable-verify=@(std|preinit)'

	setup_linker

	# Upstream uses a mix of -O3 and -O2.
	# -Os may cause a stall during build time.
	# >= -O1 prevents warnings related to _FORTIFY_SOURCE.
	# -O2 is forced because it uses llvm/clang parts.  Clang/llvm breaks
	# with -O3.
	replace-flags '-O*' '-O2' # Prevent possible runtime breakage with llvm parts.

	allow_lto
	cflags-hardened_append
	BUILD_CXXFLAGS+=" ${CFLAGS_HARDENED_CXXFLAGS}"
	BUILD_LDFLAGS+=" ${CFLAGS_HARDENED_LDFLAGS}"

	bazel_setup_bazelrc # Save CFLAGS

	# Relax version checks in setup.py
	sed -i "/^    '/s/==/>=/g" tensorflow/tools/pip_package/setup.py || die

	# Prefixify hard-coded command locations
	hprefixify -w /host_compiler_prefix/ third_party/gpus/cuda_configure.bzl

	gen_gcc_ar

	if [[ "${FEATURES}" =~ "ccache" ]] && has_version "dev-util/ccache" ; then
		sed -i -e "s|LLVM_CCACHE_BUILD OFF|LLVM_CCACHE_BUILD ON|g" \
			"${S}/tensorflow/compiler/xla/mlir_hlo/CMakeLists.txt" \
			|| die
	fi

	default

	patch_rocm

	if use rocm ; then
		sed -i -e "s|@TENSORFLOW_PV@|${PV}|g" \
			"${S}/third_party/gpus/crosstool/cc_toolchain_config.bzl.tpl" \
			"${S}/third_party/gpus/crosstool/hipcc_cc_toolchain_config.bzl.tpl" \
			|| die
	fi

	use python && python_copy_sources

	use cuda && cuda_add_sandbox
}

load_env() {
	export JAVA_HOME=$(java-config --jre-home) # so keepwork works
	export KERAS_HOME="${T}/.keras" # otherwise sandbox violation writing ~/.keras
	if [[ -e "${WORKDIR}/.ccache_dir_val" && "${FEATURES}" =~ "ccache" ]] \
		&& has_version "dev-util/ccache" ; then
		export CCACHE_DIR=$(cat "${WORKDIR}/.ccache_dir_val")
einfo "CCACHE_DIR:\t${CCACHE_DIR}"
	fi
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

src_configure() {
	if [[ $(tc-endian) == "big" ]] && ! use big-endian ; then
eerror
eerror "You must enable the big-endian USE flag."
eerror
		die
	fi
	load_env
	check_cython

	if ! use cuda && ! use rocm ; then
ewarn
ewarn "You are building for CPU only.  Enable the cuda or rocm USE flag to"
ewarn "support GPUs."
ewarn
	fi

	do_configure() {
		if tc-is-clang ; then
			export TF_NEED_CLANG=1
		else
			export TF_NEED_CLANG=0
		fi
		export CC_OPT_FLAGS=" "
		export TF_ENABLE_XLA=$(usex xla 1 0)
		export TF_NEED_OPENCL_SYCL=0
		export TF_NEED_OPENCL=0
		export TF_NEED_COMPUTECPP=0
		export TF_NEED_ROCM=0
		export TF_NEED_MPI=$(usex mpi 1 0)
		export TF_SET_ANDROID_WORKSPACE=0

		if use python ; then
			export PYTHON_BIN_PATH="${PYTHON}"
			export PYTHON_LIB_PATH="$(python_get_sitedir)"
		else
			export PYTHON_BIN_PATH="$(which python)"
			export PYTHON_LIB_PATH="$(python -c 'from distutils.sysconfig import *; print(get_python_lib())')"
		fi

		export TF_NEED_CUDA=$(usex cuda 1 0)
		export TF_NEED_ROCM=$(usex rocm 1 0)
		export TF_DOWNLOAD_CLANG=0
		export TF_CUDA_CLANG=0
		export TF_NEED_TENSORRT=0 # $(usex cuda 1 0)
		if use cuda ; then
			export TF_NEED_CLANG=0
			export TF_CUDA_COMPUTE_CAPABILITIES=$(get_cuda_targets)
			export TF_CUDA_PATHS="${EPREFIX}/opt/cuda"

			has_version "sys-devel/gcc:${GCC_SLOT_WITH_CUDA}" || die "Reinstall gcc:${GCC_SLOT_WITH_CUDA}"
			# The original ebuild has the bugged one
			# where it will output ${EPREFIX}/usr/${CHOST}/gcc-bin/11/${CHOST}-gcc-12
			export GCC_HOST_COMPILER_PATH="${EPREFIX}/usr/${CHOST}/gcc-bin/${GCC_SLOT_WITH_CUDA}/${CHOST}-gcc-${GCC_SLOT_WITH_CUDA}"
			export CLANG_COMPILER_PATH="/usr/lib/llvm/${LLVM_SLOT}/bin/clang"

			export TF_CUDA_VERSION="$(cuda_toolkit_version)"
			export TF_CUDNN_VERSION="$(cuda_cudnn_version)"
einfo "Setting CUDA version: $TF_CUDA_VERSION"
einfo "Setting CUDNN version: $TF_CUDNN_VERSION"

			if [[ $(cuda-config -s) != *$(gcc-version)* ]]; then
ewarn
ewarn "TensorFlow is being built with Nvidia CUDA support. Your default"
ewarn "compiler version is not supported by the currently installed CUDA."
ewarn "TensorFlow will instead be compiled using: ${GCC_HOST_COMPILER_PATH}."
ewarn "If the build fails with linker errors try rebuilding the relevant"
ewarn "dependencies using the same compiler version."
ewarn
			fi

einfo
einfo "You can look up your GPU's CUDA compute capability at"
einfo
einfo "  https://developer.nvidia.com/cuda-gpus"
einfo
einfo "or by running"
einfo
einfo "  /opt/cuda/extras/demo_suite/deviceQuery | grep 'CUDA Capability'"
einfo
		fi
		if use rocm ; then
			export TF_NEED_CLANG=1
			export TF_ROCM_AMDGPU_TARGETS=$(get_amdgpu_flags \
				| tr ";" ",")
			export TF_ROCM_LLVM_SLOT="${LLVM_SLOT}"
			export HIP_PATH="${ROCM_PATH}"
			export ROCM_PATH="${ROCM_PATH}"

	# See https://github.com/ROCm/tensorflow-upstream/blob/develop-upstream/.bazelrc#L296
			local gcc_slot=$(gcc-major-version)
			export CLANG_COMPILER_PATH="/usr/lib/llvm/${LLVM_SLOT}/bin/clang"
			export GCC_HOST_COMPILER_PATH="${EPREFIX}/usr/${CHOST}/gcc-bin/${gcc_slot}/${CHOST}-gcc-${gcc_slot}"
			export TF_ROCM_CLANG=1

			export HOST_C_COMPILER="${EPREFIX}/usr/bin/${CC}"
			export HOST_CXX_COMPILER="${EPREFIX}/usr/bin/${CXX}"

einfo
einfo "GCC Current Profile:  ${gcc_current_profile}"
einfo "GCC_HOST_COMPILER_PATH:  ${GCC_HOST_COMPILER_PATH}"
einfo "HIP_PATH:  ${HIP_PATH}"
einfo "HOST_C_COMPILER:  ${HOST_C_COMPILER}"
einfo "HOST_CXX_COMPILER:  ${HOST_CXX_COMPILER}"
einfo "LLVM_SLOT:  ${LLVM_SLOT}"
einfo "ROCM_PATH:  ${ROCM_PATH}"
einfo "TF_ROCM_AMDGPU_TARGETS:  ${TF_ROCM_AMDGPU_TARGETS}"
einfo "TF_ROCM_LLVM_SLOT:  ${TF_ROCM_LLVM_SLOT}"
einfo
		fi

	# com_googlesource_code_re2 weird branch using absl, doesnt work with released re2
	# com_google_protobuf is disabled due to https://github.com/tensorflow/tensorflow/issues/61593
	# See https://github.com/tensorflow/tensorflow/blob/v2.14.1/third_party/systemlibs/syslibs_configure.bzl
		local SYSLIBS=(
			#absl_py		# Breaks during unpack
			astor_archive
			astunparse_archive
			boringssl
			com_github_googlecloudplatform_google_cloud_cpp
			com_github_grpc_grpc
			#com_google_absl	# Breaks during unpack
			#com_google_protobuf	# Breaks during unpack
			curl
			cython
			dill_archive
			double_conversion
			$(usex system-flatbuffers "flatbuffers" "")
			functools32_archive
			gast_archive
			gif
			hwloc
			icu
			jsoncpp_git
			libjpeg_turbo
			#lmdb
			nasm
			nsync
			opt_einsum_archive
			org_sqlite
			pasta
			png
			pybind11
			six_archive
			tblib_archive
			termcolor_archive
			typing_extensions_archive
			wrapt
			zlib
		)

		export TF_SYSTEM_LIBS=$(echo "${SYSLIBS[@]}")
		export TF_IGNORE_MAX_BAZEL_VERSION=1

		# This is not autoconf
		./configure || die

		if [[ -n "${BAZEL_LOCAL_RAM_RESOURCES}" ]] ; then
			# See https://www.tensorflow.org/install/source#bazel_build_options
			echo "build --local_ram_resources=${BAZEL_LOCAL_RAM_RESOURCES:-2048}" >> ".bazelrc" || die
		fi

		echo 'build --noshow_progress' >> ".bazelrc" || die # Disable high CPU usage on xfce4-terminal
		echo 'build --subcommands' >> ".bazelrc" || die # Increase verbosity
		echo 'build --config=noaws --config=nohdfs --config=nonccl' >> ".bazelrc" || die
		echo 'build --define tensorflow_mkldnn_contraction_kernel=0' >> ".bazelrc" || die
		echo "build --action_env=KERAS_HOME=\"${T}/.keras\"" >> ".bazelrc" || die
		echo "build --host_action_env=KERAS_HOME=\"${T}/.keras\"" >> ".bazelrc" || die
		if [[ "${FEATURES}" =~ "ccache" ]] && has_version "dev-util/ccache" ; then
			local ccache_dir=$(ccache -sv \
				| grep "Cache directory" \
				| cut -f 2 -d ":" \
				| sed -r -e "s|^[ ]+||g")
			echo "${ccache_dir}" > "${WORKDIR}/.ccache_dir_val" || die
einfo "Adding build --sandbox_writable_path=\"${ccache_dir}\" to .bazelrc"
			echo "build --action_env=CCACHE_DIR=\"${ccache_dir}\"" >> ".bazelrc" || die
			echo "build --host_action_env=CCACHE_DIR=\"${ccache_dir}\"" >> ".bazelrc" || die
			echo "build --sandbox_writable_path=${ccache_dir}" >> ".bazelrc" || die
			export CCACHE_DIR="${ccache_dir}"
einfo "CCACHE_DIR:\t${CCACHE_DIR}"
		fi

		for cflag in $($(tc-getPKG_CONFIG) jsoncpp --cflags)
		do
			echo "build --copt=\"${cflag}\"" >> ".bazelrc" || die
			echo "build --host_copt=\"${cflag}\"" >> ".bazelrc" || die
		done
	}
	if use python ; then
		python_foreach_impl run_in_build_dir do_configure
	else
		do_configure
	fi
}

add_sandbox_rules() {
	local L=(
		"/usr/lib/${EPYTHON}/site-packages"
		"/usr/lib/${EPYTHON}/site-packages/__pycache__"
		"/usr/lib/${EPYTHON}/site-packages/Cython"
		"/usr/lib/${EPYTHON}/site-packages/Cython/__pycache__"
		"/usr/lib/${EPYTHON}/site-packages/Cython/Compiler"
		"/usr/lib/${EPYTHON}/site-packages/Cython/Compiler/__pycache__"
		"/usr/lib/${EPYTHON}/site-packages/Cython/Plex"
		"/usr/lib/${EPYTHON}/site-packages/Cython/Plex/__pycache__"
		"/usr/lib/${EPYTHON}/site-packages/Cython/Utility"
		"/usr/lib/${EPYTHON}/site-packages/Cython/Utility/__pycache__"
		"/usr/lib/${EPYTHON}/site-packages/Cython/Tempita"
		"/usr/lib/${EPYTHON}/site-packages/Cython/Tempita/__pycache__"

		"/usr/lib/${EPYTHON}/site-packages/Cython.0.29"
		"/usr/lib/${EPYTHON}/site-packages/Cython.0.29/__pycache__"
		"/usr/lib/${EPYTHON}/site-packages/Cython.0.29/Compiler"
		"/usr/lib/${EPYTHON}/site-packages/Cython.0.29/Compiler/__pycache__"
		"/usr/lib/${EPYTHON}/site-packages/Cython.0.29/Plex"
		"/usr/lib/${EPYTHON}/site-packages/Cython.0.29/Plex/__pycache__"
		"/usr/lib/${EPYTHON}/site-packages/Cython.0.29/Utility"
		"/usr/lib/${EPYTHON}/site-packages/Cython.0.29/Utility/__pycache__"
		"/usr/lib/${EPYTHON}/site-packages/Cython.0.29/Tempita"
		"/usr/lib/${EPYTHON}/site-packages/Cython.0.29/Tempita/__pycache__"

		"/usr/lib/${EPYTHON}/site-packages/Cython.3.0"
		"/usr/lib/${EPYTHON}/site-packages/Cython.3.0/__pycache__"
		"/usr/lib/${EPYTHON}/site-packages/Cython.3.0/Compiler"
		"/usr/lib/${EPYTHON}/site-packages/Cython.3.0/Compiler/__pycache__"
		"/usr/lib/${EPYTHON}/site-packages/Cython.3.0/Plex"
		"/usr/lib/${EPYTHON}/site-packages/Cython.3.0/Plex/__pycache__"
		"/usr/lib/${EPYTHON}/site-packages/Cython.3.0/Utility"
		"/usr/lib/${EPYTHON}/site-packages/Cython.3.0/Utility/__pycache__"
		"/usr/lib/${EPYTHON}/site-packages/Cython.3.0/Tempita"
		"/usr/lib/${EPYTHON}/site-packages/Cython.3.0/Tempita/__pycache__"

		"/usr/lib/${EPYTHON}/site-packages/Cython.3.1"
		"/usr/lib/${EPYTHON}/site-packages/Cython.3.1/__pycache__"
		"/usr/lib/${EPYTHON}/site-packages/Cython.3.1/Compiler"
		"/usr/lib/${EPYTHON}/site-packages/Cython.3.1/Compiler/__pycache__"
		"/usr/lib/${EPYTHON}/site-packages/Cython.3.1/Plex"
		"/usr/lib/${EPYTHON}/site-packages/Cython.3.1/Plex/__pycache__"
		"/usr/lib/${EPYTHON}/site-packages/Cython.3.1/Utility"
		"/usr/lib/${EPYTHON}/site-packages/Cython.3.1/Utility/__pycache__"
		"/usr/lib/${EPYTHON}/site-packages/Cython.3.1/Tempita"
		"/usr/lib/${EPYTHON}/site-packages/Cython.3.1/Tempita/__pycache__"
	)
einfo "Adding sandbox rules"
	local path
	for path in "${L[@]}" ; do
einfo "addpredict ${path}" # Recursive
		addpredict "${path}"
	done
}

src_compile() {
	load_env

	local args=()

	if has_version ">=dev-build/bazel-6" ; then
	# See https://github.com/tensorflow/tensorflow/issues/58825
		args+=(
			--incompatible_fix_package_group_reporoot_syntax=false
		)
	fi

	args+=(
		"--linkopt=-labsl_synchronization"
		"--host_linkopt=-labsl_synchronization"
	)

einfo "src_compile():  Step 1"
	if use python ; then
		python_setup

	# Some determinism problem
	# I ask it to build python_targets_python3_9 only and it causes a
	# violation with python3.10 in the path.
		local i
		for i in "${_PYTHON_ALL_IMPLS[@]}"; do
			EPYTHON="${i/_/.}" add_sandbox_rules
		done

		BUILD_DIR="${S}-${EPYTHON/./_}"
		cd "${BUILD_DIR}" || die
	fi

einfo "src_compile():  Step 2"
	ebazel build \
		${args[@]} \
		-k \
		--nobuild \
		//tensorflow:libtensorflow_framework.so \
		//tensorflow:libtensorflow.so \
		//tensorflow:libtensorflow_cc.so \
		$(usex python '//tensorflow/tools/pip_package:build_pip_package' '')

einfo "src_compile():  Step 3"
	ebazel build \
		${args[@]} \
		//tensorflow:libtensorflow_framework.so \
		//tensorflow:libtensorflow.so
einfo "src_compile():  Step 4"
	ebazel build \
		${args[@]} \
		//tensorflow:libtensorflow_cc.so
einfo "src_compile():  Step 5"
	ebazel build \
		${args[@]} \
		//tensorflow:install_headers
	ebazel shutdown

	do_compile() {
einfo "src_compile():  Step 6"
		ebazel build \
			${args[@]} \
			//tensorflow/tools/pip_package:build_pip_package
		ebazel shutdown
	}
	BUILD_DIR="${S}"
	cd "${BUILD_DIR}" || die
	use python && python_foreach_impl run_in_build_dir do_compile
}

src_install() {
	local i l n
	load_env

	do_install() {
einfo "Installing ${EPYTHON} files"
		local srcdir="${T}/src-${MULTIBUILD_VARIANT}"
		mkdir -p "${srcdir}" || die
		bazel-bin/tensorflow/tools/pip_package/build_pip_package --src "${srcdir}" || die
		cd "${srcdir}" || die
		esetup.py install

		# libtensorflow_framework.so is in /usr/lib already
		rm -f \
			"${D}/$(python_get_sitedir)/${PN}/lib${PN}_framework.so"* \
			"${D}/$(python_get_sitedir)/${PN}/lib${PN}_cc.so"* \
			|| die
		python_optimize
	}

	if use python ; then
		python_foreach_impl run_in_build_dir do_install

		# Symlink to python-exec scripts
		local i
		for i in "${ED}/usr/lib/python-exec/"*"/"* ; do
			local n="${i##*/}"
			if ! [[ -e "${ED}/usr/bin/${n}" ]] ; then
				dosym \
					"../lib/python-exec/python-exec2" \
					"/usr/bin/${n}"
			fi
		done

		python_setup
		local BUILD_DIR="${S}-${EPYTHON/./_}"
		cd "${BUILD_DIR}" || die
	fi

einfo "Installing headers"
	insinto "/usr/include/${PN}/"
	doins -r "bazel-bin/tensorflow/include/"*

einfo "Installing libs"
	# Generate a pkg-config file.
	${PN}/c/generate-pc.sh \
		--prefix="${EPREFIX}"/usr \
		--libdir=$(get_libdir) \
		--version=${MY_PV} || die
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "${PN}.pc" "${PN}_cc.pc"

	local l
	for l in libtensorflow{,_framework,_cc}.so; do
		use cuda && patchelf --add-rpath '/opt/cuda/lib64' "bazel-bin/tensorflow/${l}"
		dolib.so "bazel-bin/tensorflow/${l}"
		dolib.so "bazel-bin/tensorflow/${l}.$(ver_cut 1)"
		dolib.so "bazel-bin/tensorflow/${l}.$(ver_cut 1-3)"
	done

	einstalldocs

	LCNR_TAG="${PN}"
	LCNR_SOURCE="${S}"
	lcnr_install_files

	# Workaround for https://bugs.gentoo.org/831927
	export MAKEOPTS="-j1"

	# Prevent merge conflict
	rm -rf "${ED}/usr/bin/tensorboard"

	dhms_end
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  80 chars, dedupe literals, *DEPENDs changes, increase [third party] LICENSE transparency, preserve copyright notices, fix ccache
# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
