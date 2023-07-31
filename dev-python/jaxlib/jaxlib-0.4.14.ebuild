# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MAINTAINER_MODE=1
MY_PN="jax"

AMDGPU_TARGETS_OVERRIDE=(
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx1030
)
DISTUTILS_USE_PEP517="standalone"
GCC_SLOTS=( 12 11 10 9 )
JAVA_SLOT="11"
LLVM_MAX_SLOT=16
LLVM_SLOTS=( 16 ) # Limited by rocm
PYTHON_COMPAT=( python3_{10..11} )
CUDA_TARGETS=(
	sm_52
	sm_60
	sm_70
	sm_80
	compute_90
)

inherit bazel cuda distutils-r1 flag-o-matic git-r3 java-pkg-opt-2 rocm \
toolchain-funcs

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
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
${CUDA_TARGETS[@]/#/cuda_targets_}
clang custom-optimization-level cpu cuda hardened portable rocm r1
"
# We don't add tpu because licensing issue with libtpu_nightly.
REQUIRED_USE+="
	rocm? (
		${ROCM_REQUIRED_USE}
	)
	cuda? (
		|| (
			${CUDA_TARGETS[@]/#/cuda_targets_}
		)
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
# The container uses 5.5.0
	"5.5.1" # For llvm 16
)
gen_rocm_depends() {
	local pv
	for pv in ${ROCM_SLOTS[@]} ; do
		local s="0/"$(ver_cut 1-2 ${pv})
		# Direct dependencies
		echo "
			~dev-libs/rccl-${pv}:${s}
			~dev-libs/rocm-device-libs-${pv}:${s}
			~dev-util/hip-${pv}:${s}
			~dev-util/roctracer-${pv}:${s}
			~sci-libs/hipBLAS-${pv}:${s}
			~sci-libs/hipFFT-${pv}:${s}
			~sci-libs/hipSPARSE-${pv}:${s}
			~sci-libs/miopen-${pv}:${s}
			~sci-libs/rocFFT-${pv}:${s}
			~sci-libs/rocRAND-${pv}:${s}
		"

		# Indirect dependencies
		echo "
			~dev-libs/rocm-comgr-${pv}:${s}
			~dev-libs/rocr-runtime-${pv}:${s}
			~dev-libs/roct-thunk-interface-${pv}:${s}
			~dev-util/rocm-cmake-${pv}:${s}
			~dev-util/rocm-smi-${pv}:${s}
			~dev-util/rocminfo-${pv}:${s}
			~dev-util/Tensile-${pv}:${s}
			~sci-libs/rocBLAS-${pv}:${s}
		"
	done
}
#	>=dev-cpp/abseil-cpp-20220623:0/20220623
#	dev-libs/protobuf:=
RDEPEND+="
	!dev-python/jaxlib-bin
	>=app-arch/snappy-1.1.10
	>=dev-libs/double-conversion-3.2.0
	>=dev-libs/nsync-1.25.0
	>=dev-python/numpy-1.20[${PYTHON_USEDEP}]
	>=dev-python/pybind11-2.10.0[${PYTHON_USEDEP}]
	>=net-libs/grpc-1.27_p9999:=
	>=sys-libs/zlib-1.2.13
	virtual/jre:${JAVA_SLOT}
	cuda? (
		=dev-util/nvidia-cuda-toolkit-11.8*
		=dev-libs/cudnn-8*
	)
	rocm? (
		$(gen_rocm_depends)
	)
"
# We cannot use cuda 12 (which the project supports) until cudnn ebuild allows
# for it.
DEPEND+="
	${RDEPEND}
	virtual/jdk:${JAVA_SLOT}
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
BDEPEND+="
	>=dev-util/bazel-6.1.2
	clang? (
		|| (
			$(gen_llvm_bdepend)
		)
	)
	|| (
		>=sys-devel/gcc-12:12
		>=sys-devel/gcc-11.3.1_p20230120-r1:11
		>=sys-devel/gcc-10:10
		>=sys-devel/gcc-9.3.0:9
		$(gen_llvm_bdepend)
	)
"

# DO NOT HARD WRAP
# DO NOT CHANGE TARBALL FILE EXT
# Do not use GH urls if .gitmodules exists in that project
# All hashes and URIs obtained with MAINTAINER_MODE=1 and from console logs with
# FEATURES=-network-sandbox.

APPLE_SUPPORT_PV="1.1.0"
BAZEL_SKYLIB_PV="1.3.0"
CUDNN_FRONTEND_PV="0.9"
CURL_PV="8.1.2"
FLATBUFFERS_PV="2.0.6"
JSONCPP_PV="1.9.5"
NCCL_PV="2.16.5-1"
ONEDNN_PV="3.2"
PLATFORMS_PV="0.0.6"
PROTOBUF_PV="3.21.9"
PYBIND_PV="2.10.0"
RULES_ANDROID_PV="0.1.1"
RULES_APPLE_PV="1.0.1"
RULES_PKG_PV="0.7.1"
RULES_PYTHON_PV="0.0.1"
RULES_SWIFT_PV="1.0.0"

EGIT_ABSEIL_CPP_COMMIT="b971ac5250ea8de900eae9f95e06548d14cd95fe"
EGIT_BAZEL_TOOLCHAINS_COMMIT="8c717f8258cd5f6c7a45b97d974292755852b658"
EGIT_BORINGSSL_COMMIT="c00d7ca810e93780bd0c8ee4eea28f4f2ea4bcdc"
EGIT_DLPACK_COMMIT="9351cf542ab478499294864ff3acfdab5c8c5f3d"
EGIT_DUCC_COMMIT="356d619a4b5f6f8940d15913c14a043355ef23be"
EGIT_EIGEN_COMMIT="0b51f763cbbd0ed08168f88972724329f0375498"
EGIT_FARMHASH_COMMIT="0d859a811870d10f53a594927d0d0b97573ad06d"
EGIT_LLVM_COMMIT="4706251a3186c34da0ee8fd894f7e6b095da8fdc"
EGIT_ML_DTYPES_COMMIT="5b9fc9ad978757654843f4a8d899715dbea30e88"
EGIT_PYBIND11_BAZEL_COMMIT="72cbbf1fbc830e487e3012862b7b720001b70672"
EGIT_PYBIND11_ABSEIL_COMMIT="2c4932ed6f6204f1656e245838f4f5eae69d2e29"
EGIT_RE2_COMMIT="03da4fc0857c285e3a26782f6bc8931c4c950df4"
EGIT_RULES_CC_COMMIT="081771d4a0e9d7d3aa0eed2ef389fa4700dfb23e"
EGIT_RULES_CLOSURE_COMMIT="308b05b2419edb5c8ee0471b67a40403df940149"
EGIT_RULES_JAVA_COMMIT="7cf3cefd652008d0a64a419c34c13bdca6c8f178"
EGIT_RULES_PROTO_COMMIT="11bf7c25e666dd7ddacbcd4d4c4a9de7a25175f8"
EGIT_SNAPPY_COMMIT="984b191f0fefdeb17050b42a90b7625999c13b8d"
EGIT_STABLEHLO_COMMIT="8816d0581d9a5fb7d212affef858e991a349ad6b"
EGIT_TENSORFLOW_RUNTIME_COMMIT="3bf6c17968a52aea580c5398bbcfc0cf0e069dc5"
EGIT_XLA_COMMIT="9f26b9390f5a5c565a13925731de749be8a760be"

TRITON_ID="cl546794996"

bazel_external_uris="
https://github.com/abseil/abseil-cpp/archive/${EGIT_ABSEIL_CPP_COMMIT}.tar.gz -> abseil-cpp-${EGIT_ABSEIL_CPP_COMMIT}.tar.gz
https://github.com/bazelbuild/apple_support/releases/download/${APPLE_SUPPORT_PV}/apple_support.${APPLE_SUPPORT_PV}.tar.gz -> apple_support-${APPLE_SUPPORT_PV}.tar.gz
https://github.com/bazelbuild/bazel-skylib/releases/download/${BAZEL_SKYLIB_PV}/bazel-skylib-${BAZEL_SKYLIB_PV}.tar.gz -> bazel-skylib-${BAZEL_SKYLIB_PV}.tar.gz
https://github.com/bazelbuild/bazel-toolchains/archive/${EGIT_BAZEL_TOOLCHAINS_COMMIT}.tar.gz -> bazel-toolchains-${EGIT_BAZEL_TOOLCHAINS_COMMIT}.tar.gz
https://github.com/bazelbuild/platforms/releases/download/${PLATFORMS_PV}/platforms-${PLATFORMS_PV}.tar.gz
https://github.com/bazelbuild/rules_android/archive/v${RULES_ANDROID_PV}.zip -> rules_android-${RULES_ANDROID_PV}.zip
https://github.com/bazelbuild/rules_apple/releases/download/${RULES_APPLE_PV}/rules_apple.${RULES_APPLE_PV}.tar.gz -> rules_apple-${RULES_APPLE_PV}.tar.gz
https://github.com/bazelbuild/rules_cc/archive/${EGIT_RULES_CC_COMMIT}.tar.gz -> rules_cc-${EGIT_RULES_CC_COMMIT}.tar.gz
https://github.com/bazelbuild/rules_closure/archive/${EGIT_RULES_CLOSURE_COMMIT}.tar.gz -> rules_closure-${EGIT_RULES_CLOSURE_COMMIT}.tar.gz
https://github.com/bazelbuild/rules_java/archive/${EGIT_RULES_JAVA_COMMIT}.zip -> rules_java-${EGIT_RULES_JAVA_COMMIT}.zip
https://github.com/bazelbuild/rules_pkg/releases/download/${RULES_PKG_PV}/rules_pkg-${RULES_PKG_PV}.tar.gz
https://github.com/bazelbuild/rules_proto/archive/${EGIT_RULES_PROTO_COMMIT}.tar.gz -> rules_proto-${EGIT_RULES_PROTO_COMMIT}.tar.gz
https://github.com/bazelbuild/rules_python/releases/download/${RULES_PYTHON_PV}/rules_python-0.0.1.tar.gz -> rules_python-${RULES_PYTHON_PV}.tar.gz
https://github.com/bazelbuild/rules_swift/releases/download/${RULES_SWIFT_PV}/rules_swift.${RULES_SWIFT_PV}.tar.gz -> rules_swift-${RULES_SWIFT_PV}.tar.gz
https://github.com/dmlc/dlpack/archive/${EGIT_DLPACK_COMMIT}.tar.gz -> dlpack-${EGIT_DLPACK_COMMIT}.tar.gz
https://github.com/google/farmhash/archive/${EGIT_FARMHASH_COMMIT}.tar.gz -> farmhash-${EGIT_FARMHASH_COMMIT}.tar.gz
https://github.com/google/flatbuffers/archive/v${FLATBUFFERS_PV}.tar.gz -> flatbuffers-${FLATBUFFERS_PV}.tar.gz
https://github.com/google/re2/archive/${EGIT_RE2_COMMIT}.tar.gz -> re2-${EGIT_RE2_COMMIT}.tar.gz
https://github.com/llvm/llvm-project/archive/${EGIT_LLVM_COMMIT}.tar.gz -> llvm-${EGIT_LLVM_COMMIT}.tar.gz
https://github.com/mreineck/ducc/archive/${EGIT_DUCC_COMMIT}.tar.gz -> ducc-${EGIT_DUCC_COMMIT}.tar.gz
https://github.com/oneapi-src/oneDNN/archive/refs/tags/v3.2.tar.gz -> oneDNN-${ONEDNN_PV}.tar.gz
https://github.com/open-source-parsers/jsoncpp/archive/${JSONCPP_PV}.tar.gz -> jsoncpp-${JSONCPP_PV}.tar.gz
https://github.com/openxla/stablehlo/archive/${EGIT_STABLEHLO_COMMIT}.zip -> stablehlo-${EGIT_STABLEHLO_COMMIT}.zip
https://github.com/openxla/xla/archive/${EGIT_XLA_COMMIT}.tar.gz -> openxla-xla-${EGIT_XLA_COMMIT}.tar.gz
https://github.com/pybind/pybind11/archive/v${PYBIND_PV}.tar.gz -> pybind11-${PYBIND_PV}.tar.gz
https://github.com/pybind/pybind11_abseil/archive/${EGIT_PYBIND11_ABSEIL_COMMIT}.tar.gz -> pybind11_abseil-${EGIT_PYBIND11_ABSEIL_COMMIT}.tar.gz
https://github.com/tensorflow/runtime/archive/${EGIT_TENSORFLOW_RUNTIME_COMMIT}.tar.gz -> tensorflow-runtime-${EGIT_TENSORFLOW_RUNTIME_COMMIT}.tar.gz
https://gitlab.com/libeigen/eigen/-/archive/${EGIT_EIGEN_COMMIT}/eigen-${EGIT_EIGEN_COMMIT}.tar.gz -> eigen-${EGIT_EIGEN_COMMIT}.tar.gz
https://storage.googleapis.com/mirror.tensorflow.org/github.com/jax-ml/ml_dtypes/archive/${EGIT_ML_DTYPES_COMMIT}/ml_dtypes-${EGIT_ML_DTYPES_COMMIT}.tar.gz
https://storage.googleapis.com/mirror.tensorflow.org/github.com/google/snappy/archive/${EGIT_SNAPPY_COMMIT}.tar.gz -> snappy-${EGIT_SNAPPY_COMMIT}.tar.gz
https://storage.googleapis.com/mirror.tensorflow.org/github.com/protocolbuffers/protobuf/archive/v${PROTOBUF_PV}.zip -> protobuf-${PROTOBUF_PV}.zip
https://storage.googleapis.com/mirror.tensorflow.org/github.com/pybind/pybind11_bazel/archive/${EGIT_PYBIND11_BAZEL_COMMIT}.tar.gz -> pybind11_bazel-${EGIT_PYBIND11_BAZEL_COMMIT}.tar.gz
cuda? (
https://curl.haxx.se/download/curl-${CURL_PV}.tar.gz
https://github.com/google/boringssl/archive/${EGIT_BORINGSSL_COMMIT}.tar.gz -> boringssl-${EGIT_BORINGSSL_COMMIT}.tar.gz
https://github.com/NVIDIA/cudnn-frontend/archive/refs/tags/v${CUDNN_FRONTEND_PV}.zip -> cudnn-frontend-${CUDNN_FRONTEND_PV}.zip
https://github.com/nvidia/nccl/archive/v${NCCL_PV}.tar.gz -> nccl-${NCCL_PV}.tar.gz
https://github.com/openxla/triton/archive/${TRITON_ID}.tar.gz -> openxla-triton-${TRITON_ID}.tar.gz
)
"
# Has .gitmodules:
# triton
# https://storage.googleapis.com/mirror.tensorflow.org/github.com/openxla/triton/archive/${TRITON_ID}.tar.gz -> openxla-triton-${TRITON_ID}.tar.gz # host error

# xla timestamp Jul 27, 2023 (9f26b9390f5a5c565a13925731de749be8a760be) found in https://github.com/google/jax/blob/jaxlib-v0.4.14/WORKSPACE#L13C49-L13C89
# rocm fork of xla should be >= to that one above.
EGIT_ROCM_TENSORFLOW_UPSTREAM_COMMIT="abc5674e36a61f2ad9fb59929f14c2762f96ca07" # Jul 28, 2023
SRC_URI="
	${bazel_external_uris}
https://github.com/google/jax/archive/refs/tags/${PN}-v${PV}.tar.gz
	-> ${MY_PN}-${PV}.tar.gz
"
S="${WORKDIR}/jax-jax-v${PV}"
RESTRICT="mirror"
DOCS=( CHANGELOG.md CITATION.bib README.md )

distutils_enable_tests "pytest"

check_network_sandbox_permissions() {
	if has network-sandbox $FEATURES ; then
eerror
eerror "FEATURES=\"\${FEATURES} -network-sandbox\" must be added per-package"
eerror "env to be able to download micropackages."
eerror
		die
	fi
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
einfo "Using mold (TESTING)"
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
		export CC="${CHOST}-gcc-${symlink_ver}"
		export CXX="${CHOST}-g++-${symlink_ver}"
		export CPP="${CHOST}-g++-${symlink_ver} -E"
		if ${CC} --version 2>/dev/null 1>/dev/null ; then
einfo "Switched to gcc:${s}"
			found=1
			break
		fi
	done
	if (( ${found} != 1 )) ; then
		local slots_desc=$(echo "${GCC_SLOTS[@]}" \
			| tr " " "\n" \
			| tac \
			| tr "\n" " " \
			| sed -e "s| |, |g" -e "s|, $||g")
eerror
eerror "Use only gcc slots ${slots_desc}"
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
	if (( ${s} == 10 || ${s} == 11 || ${s} == 14 || ${s} == 15 )) ; then
		:;
	else
ewarn "Using ${s} is not supported upstream.  This compiler slot is in testing."
	fi
	LLVM_MAX_SLOT=${s}
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
}

pkg_setup() {
	setup_tc

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

#	check_network_sandbox_permissions
}

src_unpack() {
	unpack "${MY_PN}-${PV}.tar.gz"
	mkdir -p "${WORKDIR}/tarballs" || die
	mkdir -p "${WORKDIR}/patches" || die
	if [[ "${MAINTAINER_MODE}" != "1" ]] ; then
		cp -a \
			$(realpath "${DISTDIR}/tensorflow-${EGIT_TENSORFLOW_COMMIT}.tar.gz") \
			"${WORKDIR}/tarballs" \
			|| die
	fi
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
prepare_tensorflow() {
	load_env
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
}

python_prepare_all() {
	cuda_src_prepare
	distutils-r1_python_prepare_all
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

python_configure() {
	load_env
	local args=()

	prepare_tensorflow

	bazel_setup_bazelrc

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
	export TF_SYSTEM_LIBS=$(echo "${SYSLIBS[@]}" | tr " " ",")

	# The default is release which forces avx by default.
	if is-flagq '-march=native' ; then
		args+=(
			--target_cpu_features=native
		)
	elif is-flagq '-march=generic' ; then
		args+=(
			--target_cpu_features=default
		)
	elif ! [[ "${CFLAGS}" =~ "-march=" ]] ; then
		args+=(
			--target_cpu_features=default
		)
	else
ewarn
ewarn "Downgrading -march=* to generic."
ewarn "Use -march=native to optimize."
ewarn
		args+=(
			--target_cpu_features=default
		)
	fi

	export TF_NEED_CUDA=$(usex cuda "1" "0")
	export TF_NEED_ROCM=$(usex rocm "1" "0")
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
		)
	fi
	if use rocm ; then
		local rocm_version=$(best_version "dev-util/hip" \
			| sed -e "s|dev-util/hip-||g")
		rocm_version=$(ver_cut 1-3 "rocm_version")
		export JAX_ROCM_VERSION="${rocm_version//./}"
		export ROCM_PATH="${ESYSROOT}/usr"
		export TF_ROCM_AMDGPU_TARGETS=$(get_amdgpu_flags \
			| tr ";" ",")
		local rocm_pv=$(best_version "sci-libs/rocFFT" \
			| sed -e "s|sci-libs/rocFFT-||")
	# See
	# https://jax.readthedocs.io/en/latest/developer.html#additional-notes-for-building-a-rocm-jaxlib-for-amd-gpus
	# https://github.com/google/jax/blob/jaxlib-v0.4.14/build/rocm/build_rocm.sh
		args+=(
			--enable_rocm
			--rocm_amdgpu_targets="${TF_ROCM_AMDGPU_TARGETS}"
			--rocm_path="${ESYSROOT}/usr"
		)
	# The docs hasn't been updated, but latest point release of jax/jaxlib
	# is the same source for xla.  No override needed.
	fi
	${EPYTHON} build/build.py \
		--configure_only \
		${args[@]} \
		|| die

	# Merge
	cat ".jax_configure.bazelrc" > "${T}/bazelrc_merged" || die
	cat "${T}/bazelrc" >> "${T}/bazelrc_merged" || die

	echo 'build --noshow_progress' >> "${T}/bazelrc_merged" || die # Disable high CPU usage on xfce4-terminal
	echo 'build --subcommands' >> "${T}/bazelrc_merged" || die # Increase verbosity

	echo "build --action_env=TF_SYSTEM_LIBS=\"${TF_SYSTEM_LIBS}\"" >> "${T}/bazelrc_merged" || die
	echo "build --host_action_env=TF_SYSTEM_LIBS=\"${TF_SYSTEM_LIBS}\"" >> "${T}/bazelrc_merged" || die

	if [[ "${FEATURES}" =~ "ccache" ]] && has_version "dev-util/ccache" ; then
		local ccache_dir=$(ccache -sv \
			| grep "Cache directory" \
			| cut -f 2 -d ":" \
			| sed -r -e "s|^[ ]+||g")
		echo "${ccache_dir}" > "${WORKDIR}/.ccache_dir_val" || die
einfo "Adding build --sandbox_writable_path=\"${ccache_dir}\" to ${T}/bazelrc_merged"
		echo "build --action_env=CCACHE_DIR=\"${ccache_dir}\"" >> "${T}/bazelrc_merged" || die
		echo "build --host_action_env=CCACHE_DIR=\"${ccache_dir}\"" >> "${T}/bazelrc_merged" || die
		echo "build --sandbox_writable_path=${ccache_dir}" >> "${T}/bazelrc_merged" || die
	fi

	mv "${T}/bazelrc_merged" "${S}/build/.jax_configure.bazelrc" || die
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
	bazel_setup_bazelrc

	# Use different build folders for each multibuild variant.
	local output_base="${BUILD_DIR:-${S}}"
	output_base="${output_base%/}-bazel-base"
	mkdir -p "${output_base}" || die

	set -- bazel \
		--bazelrc="${S}/build/.jax_configure.bazelrc" \
		--output_base="${output_base}" \
		${@}
	echo "${*}" >&2
	"${@}" || die "ebazel failed"
}

python_compile() {
	load_env
	[[ -e ".jax_configure.bazelrc" ]] || die "Missing file"
einfo "Building for EPYTHON=${EPYTHON} PYTHON=${PYTHON}"
	cd "${S}/build" || die
	export PYTHON_BIN_PATH="${PYTHON}"

	sed -i -r \
		-e "s|python[0-9]\.[0-9]+|${EPYTHON}|g" \
		"${S}/build/.jax_configure.bazelrc" \
		|| die

	# Keep in sync with
	# https://github.com/google/jax/blob/jaxlib-v0.4.14/build/build.py#L546
	_ebazel run \
		--verbose_failures=true \
		"//jaxlib/tools:build_wheel" \
		-- \
		--output_path=$(pwd)/dist \
		--cpu=$(get_host)
	_ebazel shutdown

	local python_pv="${EPYTHON}"
	python_pv="${python_pv/python}"
	python_pv="${python_pv/./}"
	IFS=$'\n'
	local wheel_paths=$(
		find "${S}/build/dist" -name "*.whl"
	)
	local wheel_path
	for wheel_path in ${wheel_paths[@]} ; do
einfo "Installing ${wheel_path}"
		distutils_wheel_install "${BUILD_DIR}/install" \
			"${wheel_path}"
	done
	IFS=$' \t\n'
}

src_install() {
	load_env
	distutils-r1_src_install
	docinto licenses
	dodoc AUTHORS LICENSE
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
