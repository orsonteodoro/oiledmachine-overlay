# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# SECURITY:  Bump every minor version.  Several CVEs announced:
# https://github.com/tensorflow/tensorflow/releases/tag/v2.11.1

EAPI=8

MY_PV=${PV/_rc/-rc}
MY_P=${PN}-${MY_PV}
DEP_VER="$(ver_cut 1-2)"
DEP_VER_MAX="${DEP_VER%%.*}.$(( $(ver_cut 2 ${DEP_VER}) + 1 ))"

AMDGPU_TARGETS_OVERRIDE=(
        gfx803
	gfx900
	gfx906
	gfx908
	gfx1030
)
DISTUTILS_OPTIONAL=1
CHECKREQS_MEMORY="10G" # Gold uses above 9.0 GiB
CHECKREQS_DISK_BUILD="19G"
CHECKREQS_DISK_USR="5G"
CUDA_TARGETS=(
	sm_35
	sm_50
	sm_60
	sm_70
	sm_75
	compute_80
)
GCC_SLOTS=( 12 11 10 9 )
LLVM_MAX_SLOT=14
LLVM_SLOTS=( 14 13 12 11 10 )
PYTHON_COMPAT=( python3_10 )
# PYTHON_COMPAT limited by gast-4.0[python_targets_python3_9]

inherit bazel check-reqs cuda distutils-r1 flag-o-matic lcnr llvm prefix
inherit rocm toolchain-funcs

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


KEYWORDS="~amd64"
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
${CUDA_TARGETS[@]/#/cuda_targets_}
alt-ssl clang cuda custom-optimization-level +hardened hip mpi +python
test xla
"
gen_required_use_cuda_targets() {
	local x
	for x in ${CUDA_TARGETS[@]} ; do
		echo "
			cuda_targets_${x}? (
				cuda
			)
		"
	done
}
REQUIRED_USE="
	$(gen_required_use_cuda_targets)
	cuda? (
		|| (
			${CUDA_TARGETS[@]/#/cuda_targets_}
		)
	)
	python? (
		${PYTHON_REQUIRED_USE}
	)
	test? (
		python
	)
" # The test USE flag is limited by the dev-python/gast package.

# For deps versioning, see
# https://www.tensorflow.org/install/source#linux
# https://github.com/google/boringssl/blob/f9eff21461cf79556a0fb8ca9b1bf60c3b283ce8/src/include/openssl/crypto.h#L99
# https://github.com/tensorflow/runtime/blob/4ce3e4da2e21ae4dfcee9366415e55f408c884ec/third_party/rules_cuda/cuda/dependencies.bzl#L41   # cc_rules
# https://github.com/tensorflow/runtime/blob/4ce3e4da2e21ae4dfcee9366415e55f408c884ec/third_party/rules_cuda/cuda/dependencies.bzl#L66   # platforms
# https://github.com/tensorflow/tensorflow/blob/v2.11.0/tensorflow/tools/toolchains/remote_config/configs.bzl#L318                       # tested llvm
# https://github.com/tensorflow/tensorflow/blob/v2.11.0/configure.py#L33                                                        # cuda version
# https://github.com/tensorflow/tensorflow/blob/v2.11.0/tensorflow/lite/tools/cmake/modules/eigen.cmake                         # cuda/cudnn major versions
# https://github.com/tensorflow/tensorflow/blob/v2.11.0/tensorflow/tools/dockerfiles/partials/ubuntu/nvidia.partial.Dockerfile  # cuda major.minor version
# https://github.com/tensorflow/tensorflow/blob/v2.11.0/tensorflow/tools/pip_package/setup.py					# primary
# https://github.com/tensorflow/tensorflow/blob/v2.11.0/tensorflow/tools/pip_package/setup.py#L349                              # python versions
# https://github.com/tensorflow/tensorflow/blob/v2.11.0/tensorflow/tools/tf_sig_build_dockerfiles/devel.requirements.txt	# fallback
# https://github.com/tensorflow/tensorflow/blob/v2.11.0/tensorflow/tools/toolchains/archives.bzl
# https://github.com/tensorflow/tensorflow/blob/v2.11.0/tensorflow/workspace0.bzl
# https://github.com/tensorflow/tensorflow/blob/v2.11.0/tensorflow/workspace2.bzl
# https://github.com/tensorflow/tensorflow/blob/v2.11.0/tensorflow/workspace3.bzl
# https://github.com/tensorflow/tensorflow/blob/v2.11.0/tensorflow/workspace2.bzl#L567                # boringssl commit for above
# https://github.com/tensorflow/tensorflow/blob/v2.11.0/tensorflow/workspace2.bzl#L542                # openmp
# https://github.com/tensorflow/tensorflow/blob/v2.11.0/third_party/absl/workspace.bzl                # abseil-cpp
# https://github.com/tensorflow/tensorflow/blob/v2.11.0/third_party/dlpack/workspace.bzl
# https://github.com/tensorflow/tensorflow/blob/v2.11.0/third_party/farmhash/workspace.bzl
# https://github.com/tensorflow/tensorflow/blob/v2.11.0/third_party/flatbuffers/workspace.bzl
# https://github.com/tensorflow/tensorflow/blob/v2.11.0/third_party/FP16/workspace.bzl
# https://github.com/tensorflow/tensorflow/blob/v2.11.0/third_party/gpus/rocm_configure.bzl#L191      # llvms supported for rocm
# https://github.com/tensorflow/tensorflow/blob/v2.11.0/third_party/highwayhash/workspace.bzl
# https://github.com/tensorflow/tensorflow/blob/v2.11.0/third_party/gemmlowp/workspace.bzl
# https://github.com/tensorflow/tensorflow/blob/v2.11.0/third_party/hwloc/workspace.bzl
# https://github.com/tensorflow/tensorflow/blob/v2.11.0/third_party/icu/workspace.bzl
# https://github.com/tensorflow/tensorflow/blob/v2.11.0/third_party/jpeg/workspace.bzl
# https://github.com/tensorflow/tensorflow/blob/v2.11.0/third_party/kissfft/workspace.bzl
# https://github.com/tensorflow/tensorflow/blob/v2.11.0/third_party/llvm/workspace.bzl
# https://github.com/tensorflow/tensorflow/blob/v2.11.0/third_party/llvm_openmp/openmp.bzl
# https://github.com/tensorflow/tensorflow/blob/v2.11.0/third_party/pasta/workspace.bzl
# https://github.com/tensorflow/tensorflow/blob/v2.11.0/third_party/ruy/workspace.bzl
# https://github.com/tensorflow/tensorflow/blob/v2.11.0/third_party/sobol_data/workspace.bzl
# https://github.com/tensorflow/tensorflow/blob/v2.11.0/third_party/stablehlo/workspace.bzl
# https://github.com/tensorflow/tensorflow/blob/v2.11.0/third_party/tf_runtime/workspace.bzl          # tfrt

# distfiles that bazel uses for the workspace, will be copied to basel-distdir
# pkgcheck complains but do NOT change the .zip to .tar.gz, bazel requires the exact tarball (basename and sha256).
# the build will fail if different archives are used.

APPLE_SUPPORT_PV="1.1.0"
CUDA_PV="11.2"
BAZEL_SKYLIB_PV="1.3.0"
CUB_PV="1.9.9"
CUDNN_FRONTEND_PV="0.7.1"
GRPC_PV="1.48"
GRPCIO_PV="1.24.3"
GRPCIO_PV_MAX="1.49"			# < (Exclusive) ; Upstream is wrong
KISSFFT_PV="131.1.0"
NCCL_PV="2.13.4-1"
ONEDNN_PV="2.7.1" # mkl_dnn_v1
OOURA_FFT_PV="1.0"
OPENMP_PV="10.0.1"
PLATFORMS_PV="0.0.5"
PROTOBUF_SLOT="0/30"
RULES_ANDROID_PV="0.1.1"
RULES_APPLE_PV="1.0.1"
RULES_PKG_PV="0.7.0"
RULES_PYTHON_PV="0.0.1"
RULES_SWIFT_PV="1.0.0"
# RULES_DOCKER dumped?

EGIT_COMMIT_ARM_NEON_2_X86_SSE="a15b489e1222b2087007546b4912e21293ea86ff"
EGIT_COMMIT_BAZEL_TOOLCHAINS="8c717f8258cd5f6c7a45b97d974292755852b658"
EGIT_COMMIT_CPUINFO="5e63739504f0f8e18e941bd63b2d6d42536c7d90"
EGIT_COMMIT_DLPACK="9351cf542ab478499294864ff3acfdab5c8c5f3d"
EGIT_COMMIT_FARMHASH="0d859a811870d10f53a594927d0d0b97573ad06d"
EGIT_COMMIT_FP16="4dfe081cf6bcd15db339cf2680b9281b8451eeb3"
EGIT_COMMIT_FXDIV="63058eff77e11aa15bf531df5dd34395ec3017c8"
EGIT_COMMIT_GEMMLOWP="e844ffd17118c1e17d94e1ba4354c075a4577b88"
EGIT_COMMIT_HIGHWAYHASH="c13d28517a4db259d738ea4886b1f00352a3cc33"
EGIT_COMMIT_LIBEIGEN="3bb6a48d8c171cf20b5f8e48bfb4e424fbd4f79e"
EGIT_COMMIT_LLVM="d8415b02a519f222ecf71b069c96cc85ac635de3"
EGIT_COMMIT_PTHREADPOOL="b8374f80e42010941bda6c85b0e3f1a1bd77a1e0"
EGIT_COMMIT_RE2="a276a8c738735a0fe45a6ee590fe2df69bcf4502"
EGIT_COMMIT_RULES_CC="081771d4a0e9d7d3aa0eed2ef389fa4700dfb23e"
EGIT_COMMIT_RULES_CLOSURE="308b05b2419edb5c8ee0471b67a40403df940149"
EGIT_COMMIT_RULES_JAVA="7cf3cefd652008d0a64a419c34c13bdca6c8f178"
EGIT_COMMIT_RULES_PROTO="11bf7c25e666dd7ddacbcd4d4c4a9de7a25175f8"
EGIT_COMMIT_RUY="841ea4172ba904fe3536789497f9565f2ef64129"
EGIT_COMMIT_SOBOL_DATA="835a7d7b1ee3bc83e575e302a985c66ec4b65249"
EGIT_COMMIT_STABLEHLO="fdd47908468488cbbb386bb7fc723dc19321cb83"
EGIT_COMMIT_TF_RUNTIME="4ce3e4da2e21ae4dfcee9366415e55f408c884ec"
EGIT_COMMIT_XNNPACK="e8f74a9763aa36559980a0c2f37f587794995622"

# rules_docker references from repo by upstream probably obtained from logs or download output
RULES_DOCKER_PV="0.10.0" # unknown sourcing

#https://github.com/bazelbuild/rules_docker/releases/download/v${RULES_DOCKER_PV}/rules_docker-v${RULES_DOCKER_PV}.tar.gz -> bazelbuild-rules_docker-v${RULES_DOCKER_PV}.tar.gz

# WARN: DO NOT HARDWRAP
bazel_external_uris="
	${bazel_external_uris_unknown}
https://github.com/bazelbuild/apple_support/releases/download/${APPLE_SUPPORT_PV}/apple_support.${APPLE_SUPPORT_PV}.tar.gz
https://github.com/bazelbuild/bazel-skylib/releases/download/${BAZEL_SKYLIB_PV}/bazel-skylib-${BAZEL_SKYLIB_PV}.tar.gz
https://github.com/bazelbuild/bazel-toolchains/archive/${EGIT_COMMIT_BAZEL_TOOLCHAINS}.tar.gz -> bazel-toolchains-${EGIT_COMMIT_BAZEL_TOOLCHAINS}.tar.gz
https://github.com/bazelbuild/platforms/releases/download/${PLATFORMS_PV}/platforms-${PLATFORMS_PV}.tar.gz -> bazelbuild-platforms-${PLATFORMS_PV}.tar.gz
https://github.com/bazelbuild/rules_android/archive/v${RULES_ANDROID_PV}.zip -> bazelbuild-rules_android-v${RULES_ANDROID_PV}.zip
https://github.com/bazelbuild/rules_apple/releases/download/${RULES_APPLE_PV}/rules_apple.${RULES_APPLE_PV}.tar.gz
https://github.com/bazelbuild/rules_cc/archive/${EGIT_COMMIT_RULES_CC}.tar.gz -> bazelbuild-rules_cc-${EGIT_COMMIT_RULES_CC}.tar.gz
https://github.com/bazelbuild/rules_closure/archive/${EGIT_COMMIT_RULES_CLOSURE}.tar.gz -> bazelbuild-rules_closure-${EGIT_COMMIT_RULES_CLOSURE}.tar.gz
https://github.com/bazelbuild/rules_java/archive/${EGIT_COMMIT_RULES_JAVA}.zip -> bazelbuild-rules_java-${EGIT_COMMIT_RULES_JAVA}.zip
https://github.com/bazelbuild/rules_pkg/releases/download/${RULES_PKG_PV}/rules_pkg-${RULES_PKG_PV}.tar.gz -> bazelbuild-rules_pkg-${RULES_PKG_PV}.tar.gz
https://github.com/bazelbuild/rules_proto/archive/${EGIT_COMMIT_RULES_PROTO}.tar.gz -> bazelbuild-rules_proto-${EGIT_COMMIT_RULES_PROTO}.tar.gz
https://github.com/bazelbuild/rules_python/releases/download/${RULES_PYTHON_PV}/rules_python-${RULES_PYTHON_PV}.tar.gz -> bazelbuild-rules_python-${RULES_PYTHON_PV}.tar.gz
https://github.com/bazelbuild/rules_swift/releases/download/${RULES_SWIFT_PV}/rules_swift.${RULES_SWIFT_PV}.tar.gz -> bazelbuild-rules_swift.${RULES_SWIFT_PV}.tar.gz
https://github.com/dmlc/dlpack/archive/${EGIT_COMMIT_DLPACK}.tar.gz -> dlpack-${EGIT_COMMIT_DLPACK}.tar.gz
https://github.com/google/farmhash/archive/${EGIT_COMMIT_FARMHASH}.tar.gz -> farmhash-${EGIT_COMMIT_FARMHASH}.tar.gz
https://github.com/google/gemmlowp/archive/${EGIT_COMMIT_GEMMLOWP}.zip -> gemmlowp-${EGIT_COMMIT_GEMMLOWP}.zip
https://github.com/google/highwayhash/archive/${EGIT_COMMIT_HIGHWAYHASH}.tar.gz -> highwayhash-${EGIT_COMMIT_HIGHWAYHASH}.tar.gz
https://github.com/google/re2/archive/${EGIT_COMMIT_RE2}.tar.gz -> re2-${EGIT_COMMIT_RE2}.tar.gz
https://github.com/google/ruy/archive/${EGIT_COMMIT_RUY}.zip -> ruy-${EGIT_COMMIT_RUY}.zip
https://github.com/joe-kuo/sobol_data/archive/${EGIT_COMMIT_SOBOL_DATA}.tar.gz -> sobol_data-${EGIT_COMMIT_SOBOL_DATA}.tar.gz
https://github.com/llvm/llvm-project/archive/${EGIT_COMMIT_LLVM}.tar.gz -> llvm-project-${EGIT_COMMIT_LLVM}.tar.gz
https://github.com/llvm/llvm-project/releases/download/llvmorg-${OPENMP_PV}/openmp-${OPENMP_PV}.src.tar.xz -> llvmorg-${OPENMP_PV}-openmp-${OPENMP_PV}.src.tar.xz
https://github.com/mborgerding/kissfft/archive/${KISSFFT_PV}.tar.gz -> kissfft-${KISSFFT_PV}.tar.gz
https://github.com/oneapi-src/oneDNN/archive/refs/tags/v${ONEDNN_PV}.tar.gz -> oneDNN-v${ONEDNN_PV}.tar.gz
https://github.com/openxla/stablehlo/archive/${EGIT_COMMIT_STABLEHLO}.zip -> openxla-stablehlo-${EGIT_COMMIT_STABLEHLO}.zip
https://github.com/petewarden/OouraFFT/archive/v${OOURA_FFT_PV}.tar.gz -> OouraFFT-v${OOURA_FFT_PV}.tar.gz
https://github.com/pytorch/cpuinfo/archive/${EGIT_COMMIT_CPUINFO}.tar.gz -> pytorch-cpuinfo-${EGIT_COMMIT_CPUINFO}.tar.gz
https://github.com/tensorflow/runtime/archive/${EGIT_COMMIT_TF_RUNTIME}.tar.gz -> tensorflow-runtime-${EGIT_COMMIT_TF_RUNTIME}.tar.gz
https://gitlab.com/libeigen/eigen/-/archive/${EGIT_COMMIT_LIBEIGEN}/eigen-${EGIT_COMMIT_LIBEIGEN}.tar.gz -> eigen-${EGIT_COMMIT_LIBEIGEN}.tar.gz
https://github.com/google/XNNPACK/archive/${EGIT_COMMIT_XNNPACK}.zip -> XNNPACK-${EGIT_COMMIT_XNNPACK}.zip
https://github.com/Maratyszcza/pthreadpool/archive/${EGIT_COMMIT_PTHREADPOOL}.zip -> pthreadpool-${EGIT_COMMIT_PTHREADPOOL}.zip
https://github.com/Maratyszcza/FP16/archive/${EGIT_COMMIT_FP16}.zip -> FP16-${EGIT_COMMIT_FP16}.zip
https://github.com/Maratyszcza/FXdiv/archive/${EGIT_COMMIT_FXDIV}.zip -> FXdiv-${EGIT_COMMIT_FXDIV}.zip
	cuda? (
https://github.com/NVIDIA/cudnn-frontend/archive/refs/tags/v${CUDNN_FRONTEND_PV}.zip -> cudnn-frontend-v${CUDNN_FRONTEND_PV}.zip
https://github.com/NVlabs/cub/archive/${CUB_PV}.zip -> cub-${CUB_PV}.zip
https://github.com/nvidia/nccl/archive/v${NCCL_PV}.tar.gz -> nvidia-nccl-v${NCCL_PV}.tar.gz
	)
	python? (
https://github.com/intel/ARM_NEON_2_x86_SSE/archive/${EGIT_COMMIT_ARM_NEON_2_X86_SSE}.tar.gz -> ARM_NEON_2_x86_SSE-${EGIT_COMMIT_ARM_NEON_2_X86_SSE}.tar.gz
https://storage.googleapis.com/mirror.tensorflow.org/docs.python.org/2.7/_sources/license.rst.txt -> tensorflow-1.15.0-python-license.rst.txt
	)
"

SRC_URI="
${bazel_external_uris}
https://github.com/${PN}/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
https://dev.gentoo.org/~perfinion/patches/tensorflow-patches-${PVR}.tar.bz2
"

# abseil-cpp-20211102.0-r0 does not work with NVCC
# >=grpc-1.27 and >=1.24.3 is upstream minimal but incorrect
# >=grpc-1.48 is the correct for compatibility with abseil-cpp 20220623 lts
# grpcio version should match grpc
# Apache-2.0 is only license compatible with >=openssl-3
# protobuf-python has a max limit <3.20 upstream, but distro only supports 4.21.9
# The distro only has 11.7, 11.8, 12 for cuda.  The exact version preferred due
# to binary compatibility.
CUDA_CDEPEND="
	(
		<dev-util/nvidia-cuda-toolkit-$(( $(ver_cut 1 ${CUDA_PV}) +1 )):=[profiler]
		>=dev-util/nvidia-cuda-toolkit-${CUDA_PV}:=[profiler]
	)
"

HIP_SLOTS=(
	"5.1.3"
)

gen_rocm_rdepend() {
	local pv
	for pv in ${HIP_SLOTS[@]} ; do
		local s=$(ver_cut 1-2 ${pv})
		echo "
		(
			~dev-libs/rccl-${pv}:${s}
			~dev-libs/rocm-device-libs-${pv}:${s}
			~dev-util/hip-${pv}:${s}
			~dev-util/roctracer-${pv}:${s}
			~sci-libs/hipSPARSE-${pv}:${s}
			~sci-libs/rocFFT-${pv}:${s}
			~sci-libs/rocRAND-${pv}:${s}
			~sci-libs/rocSOLVER-${pv}:${s}
			~sci-libs/miopen-${pv}:${s}
		)
		"
	done
}

# Missing extension package for TF_ENABLE_ONEDNN_OPTS=1
# The grpcio slots below are limited by protobuf:0/30.
RDEPEND="
	!alt-ssl? (
		>=dev-libs/openssl-3:0=
	)
	=net-libs/grpc-1.48*
	>=app-arch/snappy-1.1.8
	>=dev-cpp/abseil-cpp-20220623.0:0/20220623
	>=dev-db/lmdb-0.9.29
	>=dev-db/sqlite-3.39.4
	>=dev-libs/double-conversion-3.2.0
	>=dev-libs/icu-69.1:=
	>=dev-libs/jsoncpp-1.9.5:=
	>=dev-libs/nsync-1.25.0
	>=dev-libs/re2-0.2022.05.01:=
	>=media-libs/giflib-5.2.1
	>=media-libs/libjpeg-turbo-2.1.0
	>=media-libs/libpng-1.6.37:0
	>=net-misc/curl-7.85.0
	>=sys-apps/hwloc-2.7.1:=
	>=sys-libs/zlib-1.2.13
	dev-libs/protobuf:${PROTOBUF_SLOT}
	cuda? (
		${CUDA_RDEPEND}
		=dev-libs/cudnn-8*
		>=x11-drivers/nvidia-drivers-450.80.02
	)
	hip? (
		|| (
			$(gen_rocm_rdepend)
		)
	)
	mpi? (
		virtual/mpi
	)
	python? (
		$(python_gen_any_dep '
			=sci-visualization/tensorboard-'${DEP_VER}'*[${PYTHON_SINGLE_USEDEP}]
		')
		${PYTHON_DEPS}
		(
			<net-libs/google-cloud-cpp-1.41
			>=net-libs/google-cloud-cpp-1.17.1
		)
		(
			dev-python/protobuf-python:${PROTOBUF_SLOT}[${PYTHON_USEDEP}]
		)
		=dev-python/grpcio-1.48*[${PYTHON_USEDEP}]
		>=dev-libs/flatbuffers-2.0.6:=
		>=dev-python/astunparse-1.6.3[${PYTHON_USEDEP}]
		>=dev-python/termcolor-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/absl-py-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/astor-0.7.1[${PYTHON_USEDEP}]
		>=dev-python/clang-python-13.0.0[${PYTHON_USEDEP}]
		>=dev-python/dill-0.3.4[${PYTHON_USEDEP}]
		>=dev-python/flatbuffers-2.0[${PYTHON_USEDEP}]
		>=dev-python/gast-0.5.3[${PYTHON_USEDEP}]
		>=dev-python/google-pasta-0.2.0[${PYTHON_USEDEP}]
		>=dev-python/h5py-2.9.0[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.20[${PYTHON_USEDEP}]
		>=dev-python/opt-einsum-2.3.2[${PYTHON_USEDEP}]
		>=dev-python/pybind11-2.10.0[${PYTHON_USEDEP}]
		>=dev-python/six-1.16.0[${PYTHON_USEDEP}]
		>=dev-python/tblib-1.7.0[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-4.2.0[${PYTHON_USEDEP}]
		>=dev-python/wrapt-1.11.1[${PYTHON_USEDEP}]
		dev-python/protobuf-python:${PROTOBUF_SLOT}[${PYTHON_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
	python? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
	)
"
PDEPEND="
	python? (
		=sci-libs/keras-${DEP_VER}*[${PYTHON_USEDEP}]
		=sci-libs/tensorflow-estimator-${DEP_VER}*[${PYTHON_USEDEP}]
	)
"
gen_llvm_bdepend() {
	for s in ${LLVM_SLOTS[@]} ; do
		if (( ${s} >= 10 && ${s} < 13 )) ; then
			echo "
				(
					sys-devel/clang:${s}
					sys-devel/llvm:${s}
					>=sys-devel/lld-10
				)
			"
		else
			echo "
				(
					sys-devel/clang:${s}
					sys-devel/llvm:${s}
					sys-devel/lld:${s}
				)
			"
		fi
	done
}
# GCC:11 - Based on archlinux
# gcc-11.3.1_p20221209-p3 does not build
BDEPEND="
	!python? (
		dev-lang/python
	)
	>=dev-util/bazel-5.3.0
	app-arch/unzip
	dev-java/java-config
	dev-libs/protobuf:${PROTOBUF_SLOT}
	clang? (
		|| (
			$(gen_llvm_bdepend)
		)
	)
	cuda? (
		${CUDA_CDEPEND}
	)
	python? (
		=dev-python/grpcio-1.48*[${PYTHON_USEDEP}]
		=dev-python/grpcio-tools-1.48*[${PYTHON_USEDEP}]
		>=dev-python/cython-3.0.0_alpha10[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)
	|| (
		>=sys-devel/gcc-12:12
		>=sys-devel/gcc-11.3.1_p20230120-r1:11
		>=sys-devel/gcc-10:10
		>=sys-devel/gcc-9.3.0:9
		$(gen_llvm_bdepend)
	)
"
S="${WORKDIR}/${MY_P}"
DOCS=( AUTHORS CONTRIBUTING.md ISSUE_TEMPLATE.md README.md RELEASE.md )
RESTRICT="" # Tests need GPU access.  Relaxed python deps patches breaks tests.

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

use_gcc() {
	export PATH=$(echo "${PATH}" \
		| tr ":" "\n" \
		| sed -e "\|/usr/lib/llvm|d" \
		| tr "\n" ":")
einfo "PATH:\t${PATH}"
	local found=0
	local s
	for s in ${GCC_SLOTS[@]} ; do
		symlink_ver=$(gcc_symlink_ver ${s})
		export CC=${CHOST}-gcc-${symlink_ver}
		export CXX=${CHOST}-g++-${symlink_ver}
		export CPP="${CHOST}-g++-${symlink_ver} -E"
		if ${CC} --version 2>/dev/null 1>/dev/null ; then
einfo "Switched to gcc:${s}"
			found=1
			break
		fi
	done
	if (( ${found} != 1 )) ; then
eerror
eerror "Use only gcc slots 9, 10, 11"
eerror
		die
	fi
	if (( ${s} == 9 || ${s} == 11 || ${s} == 12 )) ; then
		:;
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
	local _LLVM_SLOTS=(${LLVM_SLOTS[@]})
	if [[ -n "${FORCE_LLVM_SLOT}" ]] ; then
		_LLVM_SLOTS=( ${FORCE_LLVM_SLOT} )
	fi

	local found=0
	local s
	for s in ${_LLVM_SLOTS[@]} ; do
		which "${CHOST}-clang-${s}" || continue
		export CC="${CHOST}-clang-${s}"
		export CXX="${CHOST}-clang++-${s}"
		export CPP="${CHOST}-clang++-${s} -E"
		if ${CC} --version 2>/dev/null 1>/dev/null ; then
einfo "Switched to clang:${s}"
			found=1
			break
		fi
	done
	if (( ${found} != 1 )) ; then
eerror
eerror "Use only clang slots ${LLVM_SLOTS[@]}"
eerror
		die
	fi
	if (( ${s} == 10 || ${s} == 11 || ${s} == 14 )) ; then
		:;
	else
ewarn "Using ${s} is not supported upstream.  This compiler slot is in testing."
	fi
	LLVM_MAX_SLOT=${s}
	llvm_pkg_setup
	${CC} --version || die
	strip-unsupported-flags
}

check_cython() {
	local actual_cython_pv=$(cython --version 2>&1 \
		| cut -f 3 -d " " \
		| sed -e "s|a|_alpha|g" \
		| sed -e "s|b|_beta|g")
	local expected_cython_pv="3.0.0_alpha10"
	local required_cython_major=$(ver_cut 1 ${expected_cython_pv})
	if ver_test ${actual_cython_pv} -lt ${required_cython_major} ; then
eerror
eerror "Switch cython to >= ${expected_cython_pv} via eselect-cython"
eerror
eerror "Actual cython version:\t${actual_cython_pv}"
eerror "Expected cython version\t${expected_cython_pv}"
eerror
		die
	fi
}

pkg_setup() {
	export CC=$(tc-getCC)
	export CXX=$(tc-getCC)
einfo "CC:\t\t${CC}"
einfo "CXX:\t\t${CXX}"
einfo "CFLAGS:\t${CFLAGS}"
einfo "CXXFLAGS:\t${CXXFLAGS}"
einfo "LDFLAGS:\t${LDFLAGS}"
einfo "PATH:\t${PATH}"
	if tc-is-clang || use clang ; then
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

	local num_pythons_enabled
	num_pythons_enabled=0
	count_impls() {
		num_pythons_enabled=$((${num_pythons_enabled} + 1))
	}
	use python && python_foreach_impl count_impls

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
	unpack tensorflow-patches-${PVR}.tar.bz2
	bazel_load_distfiles "${bazel_external_uris}"
}

setup_linker() {
	# The package likes to use lld with gcc which is disallowed.
	local lld_pv=-1
	if tc-is-clang \
		&& ld.lld --version 2>/dev/null 1>/dev/null ; then
		lld_pv=$(ld.lld --version \
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
			||
			(
				has_version "sys-devel/clang-common[default-lld]"
			)
		) \
	then
einfo "Using LLD (TESTING)"
		ld.lld --version || die
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

src_prepare() {
	export JAVA_HOME=$(java-config --jre-home) # so keepwork works

	# Prevent build order problems
	export MAKEOPTS="-j1"

	append-flags $(get-cpu-flags)
	append-cxxflags -std=c++17
	export BUILD_CXXFLAGS+=" -std=c++17"
	filter-flags '-fvtable-verify=@(std|preinit)'

	setup_linker

	if ! use custom-optimization-level ; then
		# Upstream uses a mix of -O3 and -O2.
		# In some contexts -Os causes a stall.
		filter-flags '-O*'
	fi

	if is-flagq '-Os' ; then
einfo "Preventing stall.  Removing -Os."
		filter-flags '-Os'
	fi

	if ! use hardened ; then
		# It has to be done this way, because we cannot edit the build
		# files before configure time because the build system
		# system generates them in compile time and doesn't unpack them
		# early.

		# SSP buffer overflow protection
		# -fstack-protector-all is <7% penalty
		BUILD_CFLAGS+=" -fno-stack-protector"
		BUILD_CXXFLAGS+=" -fno-stack-protector"
		append-flags -fno-stack-protector

		# FORTIFY_SOURCE is buffer overflow checks for string/*alloc functions
		# -FORTIFY_SOURCE=2 is <1% penalty
		BUILD_CPPFLAGS+=" -D_FORTIFY_SOURCE=0"
		append-cppflags -D_FORTIFY_SOURCE=0

		# Full RELRO is GOT protection
		# Full RELRO is <1% penalty ; <1 ms difference
		append-ldflags -Wl,-z,norelro
		append-ldflags -Wl,-z,lazy
		BUILD_LDFLAGS+=" -Wl,-z,norelro"
		BUILD_LDFLAGS+=" -Wl,-z,lazy"
	fi

	bazel_setup_bazelrc

	cp -a "${FILESDIR}/${PV}/"*".patch" "${WORKDIR}/patches" || die
	eapply "${WORKDIR}/patches/"*".patch"

	# Relax version checks in setup.py
	sed -i "/^    '/s/==/>=/g" tensorflow/tools/pip_package/setup.py || die
	sed -i "/config_googleapis/d" tensorflow/workspace0.bzl || die

	# Prefixify hard-coded command locations
	hprefixify -w /host_compiler_prefix/ third_party/gpus/cuda_configure.bzl

	default
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
	for target in ${CUDA_TARGETS[@]} ; do
		if use "cuda_targets_${target}" ; then
			targets+=",${target}"
		fi
	done
	echo "${targets}" | sed -e "s|^,||g"
}

src_configure() {
	load_env
	check_cython

	if ! use cuda && ! use hip ; then
ewarn
ewarn "You are building for CPU only.  Enable the cuda or hip USE flag to"
ewarn "support GPUs."
ewarn
	fi

	do_configure() {
		export CC_OPT_FLAGS=" "
		export TF_ENABLE_XLA=$(usex xla 1 0)
		export TF_NEED_OPENCL_SYCL=0
		export TF_NEED_OPENCL=0
		export TF_NEED_COMPUTECPP=0
		export TF_NEED_ROCM=0
		export TF_NEED_MPI=$(usex mpi 1 0)
		export TF_SET_ANDROID_WORKSPACE=0

		if use python; then
			export PYTHON_BIN_PATH="${PYTHON}"
			export PYTHON_LIB_PATH="$(python_get_sitedir)"
		else
			export PYTHON_BIN_PATH="$(which python)"
			export PYTHON_LIB_PATH="$(python -c 'from distutils.sysconfig import *; print(get_python_lib())')"
		fi

		export TF_NEED_CUDA=$(usex cuda 1 0)
		export TF_NEED_ROCM=$(usex hip 1 0)
		export TF_DOWNLOAD_CLANG=0
		export TF_CUDA_CLANG=0
		export TF_NEED_TENSORRT=0
		if use cuda; then
			export TF_CUDA_COMPUTE_CAPABILITIES=$(get_cuda_targets)
			export TF_CUDA_PATHS="${EPREFIX}/opt/cuda"
			export GCC_HOST_COMPILER_PATH="$(cuda_gccdir)/$(tc-getCC)"
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
		if use hip ; then
ewarn "HIP support is a Work In Progress (WIP) / UNFINISHED"
			export TF_ROCM_AMDGPU_TARGETS==$(get_amdgpu_flags \
				| tr ";" ",")
			export TF_ROCM_LLVM_SLOT="${LLVM_MAX_SLOT}"
			export HIP_PATH="/usr"
			export ROCM_PATH="/usr"
		fi

# com_googlesource_code_re2 weird branch using absl, doesnt work with released
# re2
		#com_github_googleapis_googleapis
		local SYSLIBS=(
			absl_py
			astor_archive
			astunparse_archive
			boringssl
			com_github_googlecloudplatform_google_cloud_cpp
			com_github_grpc_grpc
			com_google_absl
			com_google_protobuf
			curl
			cython
			dill_archive
			double_conversion
			flatbuffers
			functools32_archive
			gast_archive
			gif
			hwloc
			icu
			jsoncpp_git
			libjpeg_turbo
			lmdb
			nasm
			nsync
			opt_einsum_archive
			org_sqlite
			pasta
			png
			pybind11
			six_archive
			snappy
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
			echo "build --local_ram_resources=${BAZEL_LOCAL_RAM_RESOURCES:-2048}" >> .bazelrc || die
		fi

		echo 'build --noshow_progress' >> .bazelrc || die # Disable high CPU usage on xfce4-terminal
		echo 'build --subcommands' >> .bazelrc || die # Increase verbosity
		echo 'build --config=noaws --config=nohdfs --config=nonccl' >> .bazelrc || die
		echo 'build --define tensorflow_mkldnn_contraction_kernel=0' >> .bazelrc || die
		echo "build --action_env=KERAS_HOME=\"${T}/.keras\"" >> .bazelrc || die
		echo "build --host_action_env=KERAS_HOME=\"${T}/.keras\"" >> .bazelrc || die
		if [[ "${FEATURES}" =~ "ccache" ]] && has_version "dev-util/ccache" ; then
			local ccache_dir=$(ccache -sv \
				| grep "Cache directory" \
				| cut -f 2 -d ":" \
				| sed -r -e "s|^[ ]+||g")
			echo "${ccache_dir}" > "${WORKDIR}/.ccache_dir_val" || die
einfo "Adding build --sandbox_writable_path=\"${ccache_dir}\" to .bazelrc"
			echo "build --action_env=CCACHE_DIR=\"${ccache_dir}\"" >> .bazelrc || die
			echo "build --host_action_env=CCACHE_DIR=\"${ccache_dir}\"" >> .bazelrc || die
			echo "build --sandbox_writable_path=${ccache_dir}" >> .bazelrc || die
			export CCACHE_DIR="${ccache_dir}"
einfo "CCACHE_DIR:\t${CCACHE_DIR}"
		fi

		for cflag in $($(tc-getPKG_CONFIG) jsoncpp --cflags)
		do
			echo "build --copt=\"${cflag}\"" >> .bazelrc || die
			echo "build --host_copt=\"${cflag}\"" >> .bazelrc || die
		done
	}
	if use python; then
		python_foreach_impl run_in_build_dir do_configure
	else
		do_configure
	fi
}

add_sandbox_rules() {
	local L=(
		/usr/lib/${EPYTHON}/site-packages
		/usr/lib/${EPYTHON}/site-packages/__pycache__
		/usr/lib/${EPYTHON}/site-packages/Cython
		/usr/lib/${EPYTHON}/site-packages/Cython/__pycache__
		/usr/lib/${EPYTHON}/site-packages/Cython/Compiler
		/usr/lib/${EPYTHON}/site-packages/Cython/Compiler/__pycache__
		/usr/lib/${EPYTHON}/site-packages/Cython/Plex
		/usr/lib/${EPYTHON}/site-packages/Cython/Plex/__pycache__
		/usr/lib/${EPYTHON}/site-packages/Cython/Utility
		/usr/lib/${EPYTHON}/site-packages/Cython/Utility/__pycache__
		/usr/lib/${EPYTHON}/site-packages/Cython/Tempita
		/usr/lib/${EPYTHON}/site-packages/Cython/Tempita/__pycache__

		/usr/lib/${EPYTHON}/site-packages/Cython.3
		/usr/lib/${EPYTHON}/site-packages/Cython.3/__pycache__
		/usr/lib/${EPYTHON}/site-packages/Cython.3/Compiler
		/usr/lib/${EPYTHON}/site-packages/Cython.3/Compiler/__pycache__
		/usr/lib/${EPYTHON}/site-packages/Cython.3/Plex
		/usr/lib/${EPYTHON}/site-packages/Cython.3/Plex/__pycache__
		/usr/lib/${EPYTHON}/site-packages/Cython.3/Utility
		/usr/lib/${EPYTHON}/site-packages/Cython.3/Utility/__pycache__
		/usr/lib/${EPYTHON}/site-packages/Cython.3/Tempita
		/usr/lib/${EPYTHON}/site-packages/Cython.3/Tempita/__pycache__
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

	if has_version ">=dev-util/bazel-6" ; then
		# See https://github.com/tensorflow/tensorflow/issues/58825
		args+=( --incompatible_fix_package_group_reporoot_syntax=false )
	fi

einfo "src_compile():  Step 1"
	if use python; then
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
		rm -f "${D}/$(python_get_sitedir)"/${PN}/lib${PN}_framework.so* || die
		rm -f "${D}/$(python_get_sitedir)"/${PN}_core/lib${PN}_framework.so* || die
		python_optimize
	}

	if use python; then
		python_foreach_impl run_in_build_dir do_install

		# Symlink to python-exec scripts
		for i in "${ED}"/usr/lib/python-exec/*/*; do
			n="${i##*/}"
			if ! [[ -e "${ED}/usr/bin/${n}" ]] ; then
				dosym ../lib/python-exec/python-exec2 "/usr/bin/${n}"
			fi
		done

		python_setup
		local BUILD_DIR="${S}-${EPYTHON/./_}"
		cd "${BUILD_DIR}" || die
	fi

einfo "Installing headers"
	insinto /usr/include/${PN}/
	doins -r bazel-bin/tensorflow/include/*

einfo "Installing libs"
	# Generate a pkg-config file.
	${PN}/c/generate-pc.sh \
		--prefix="${EPREFIX}"/usr \
		--libdir=$(get_libdir) \
		--version=${MY_PV} || die
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc ${PN}_cc.pc

	local l
	for l in libtensorflow{,_framework,_cc}.so; do
		dolib.so bazel-bin/tensorflow/${l}
		dolib.so bazel-bin/tensorflow/${l}.$(ver_cut 1)
		dolib.so bazel-bin/tensorflow/${l}.$(ver_cut 1-3)
	done

	einstalldocs

	LCNR_TAG="${PN}"
	LCNR_SOURCE="${S}"
	lcnr_install_files

	# Workaround for https://bugs.gentoo.org/831927
	export MAKEOPTS="-j1"
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  80 chars, dedupe literals, *DEPENDs changes, increase [third party] LICENSE transparency, preserve copyright notices, fix ccache
