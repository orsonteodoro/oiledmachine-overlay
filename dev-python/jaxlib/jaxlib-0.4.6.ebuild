# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="jax"

GCC_SLOTS=(12 11 10 9)
LLVM_MAX_SLOT=15
LLVM_SLOTS=(15 14 13 12 11 10)

DISTUTILS_USE_PEP517="standalone"
PYTHON_COMPAT=( python3_{8..11} )
inherit bazel distutils-r1 flag-o-matic git-r3 toolchain-funcs

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
IUSE+=" clang custom-optimization-level cpu cuda hardened portable rocm r1"
# We don't add tpu because licensing issue with libtpu_nightly.
REQUIRED_USE+="
	|| (
		cpu
		cuda
		rocm
	)
"
# Missing
# hipsolver

ROCM_PV="5.3.0"
ROCM_DEPEND="
	dev-libs/rccl
	dev-libs/rocm-device-libs
	dev-util/hip
	dev-util/roctracer
	sci-libs/hipBLAS
	sci-libs/hipFFT
	sci-libs/hipSPARSE
	sci-libs/miopen
	sci-libs/rocFFT
	sci-libs/rocRAND
"
ROCM_INDIRECT_DEPEND="
	dev-util/rocm-cmake
	dev-libs/rocm-comgr
	dev-libs/rocr-runtime
	dev-libs/roct-thunk-interface
	dev-util/rocm-smi
	dev-util/rocminfo
	sci-libs/rocBLAS
"
JAVA_SLOT="11"
JDK_DEPEND="
	|| (
		dev-java/openjdk-bin:${JAVA_SLOT}
		dev-java/openjdk:${JAVA_SLOT}
	)
"
JRE_DEPEND="
	|| (
		${JDK_DEPEND}
		dev-java/openjdk-jre-bin:${JAVA_SLOT}
	)
"
#	>=dev-cpp/abseil-cpp-20220623:0/20220623
#	dev-libs/protobuf:=
RDEPEND+="
	!dev-python/jaxlib-bin
	${JRE_DEPEND}
	>=app-arch/snappy-1.1.10
	>=dev-python/numpy-1.20[${PYTHON_USEDEP}]
	>=dev-libs/double-conversion-3.2.0
	>=dev-libs/nsync-1.25.0
	>=net-libs/grpc-1.27_p9999:=
	>=dev-python/pybind11-2.10.0[${PYTHON_USEDEP}]
	>=sys-libs/zlib-1.2.13
	rocm? (
		${ROCM_DEPEND}
	)
"
DEPEND+="
	${RDEPEND}
	${JDK_DEPEND}
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
	dev-util/bazel
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

# PLATFORMS_PV uses commit from tensorflow/runtime

APPLE_SUPPORT_PV="1.1.0"	# From https://github.com/tensorflow/tensorflow/blob/2aaeef25361311b21b9e81e992edff94bcb6bae3/tensorflow/workspace2.bzl
BAZEL_SKYLIB_PV="1.3.0"		# From https://github.com/tensorflow/tensorflow/blob/2aaeef25361311b21b9e81e992edff94bcb6bae3/tensorflow/workspace3.bzl
DOUBLE_CONVERSION_PV="3.2.0"	# From https://github.com/tensorflow/tensorflow/blob/2aaeef25361311b21b9e81e992edff94bcb6bae3/tensorflow/workspace2.bzl
FLATBUFFERS_PV="2.0.6"		# From https://github.com/tensorflow/tensorflow/blob/2aaeef25361311b21b9e81e992edff94bcb6bae3/third_party/flatbuffers/workspace.bzl
JSONCPP_PV="1.9.5"		# From https://github.com/tensorflow/tensorflow/blob/2aaeef25361311b21b9e81e992edff94bcb6bae3/tensorflow/workspace2.bzl
NSYNC_PV="1.25.0"		# From https://github.com/tensorflow/tensorflow/blob/2aaeef25361311b21b9e81e992edff94bcb6bae3/tensorflow/workspace2.bzl
ONEDNN_PV="2.7.3"		# From https://github.com/tensorflow/tensorflow/blob/2aaeef25361311b21b9e81e992edff94bcb6bae3/tensorflow/workspace2.bzl
PLATFORMS_PV="0.0.6"		# From https://github.com/tensorflow/runtime/blob/8016602194b2e29d6c26d40b8ddacf2929f2112c/third_party/rules_cuda/cuda/dependencies.bzl
PROTOBUF_PV="3.21.9"		# From https://github.com/tensorflow/tensorflow/blob/2aaeef25361311b21b9e81e992edff94bcb6bae3/tensorflow/workspace2.bzl
PYBIND11_PV="2.10.0"		# From https://github.com/tensorflow/tensorflow/blob/2aaeef25361311b21b9e81e992edff94bcb6bae3/tensorflow/workspace2.bzl
RULES_ANDROID_PV="0.1.1"	# From https://github.com/tensorflow/tensorflow/blob/2aaeef25361311b21b9e81e992edff94bcb6bae3/tensorflow/workspace2.bzl
RULES_APPLE_PV="1.0.1"		# From https://github.com/tensorflow/tensorflow/blob/2aaeef25361311b21b9e81e992edff94bcb6bae3/tensorflow/workspace2.bzl
RULES_JVM_EXTERNAL_PV="4.3"	# From https://github.com/tensorflow/tensorflow/blob/2aaeef25361311b21b9e81e992edff94bcb6bae3/tensorflow/workspace3.bzl
RULES_PKG_PV="0.7.1"		# From https://github.com/tensorflow/tensorflow/blob/2aaeef25361311b21b9e81e992edff94bcb6bae3/tensorflow/workspace3.bzl
RULES_PYTHON_PV="0.0.1"		# From https://github.com/tensorflow/tensorflow/blob/2aaeef25361311b21b9e81e992edff94bcb6bae3/tensorflow/workspace2.bzl
RULES_SWIFT_PV="1.0.0"		# From https://github.com/tensorflow/tensorflow/blob/2aaeef25361311b21b9e81e992edff94bcb6bae3/tensorflow/workspace2.bzl
ZLIB_PV="1.2.13"		# From https://github.com/tensorflow/tensorflow/blob/2aaeef25361311b21b9e81e992edff94bcb6bae3/tensorflow/workspace2.bzl

EGIT_ABSEIL_CPP_COMMIT="273292d1cfc0a94a65082ee350509af1d113344d"		# From https://github.com/tensorflow/tensorflow/blob/2aaeef25361311b21b9e81e992edff94bcb6bae3/third_party/absl/workspace.bzl
EGIT_BAZEL_TOOLCHAINS_COMMIT="8c717f8258cd5f6c7a45b97d974292755852b658"		# From https://github.com/tensorflow/tensorflow/blob/2aaeef25361311b21b9e81e992edff94bcb6bae3/tensorflow/workspace1.bzl
EGIT_DLPACK_COMMIT="9351cf542ab478499294864ff3acfdab5c8c5f3d"			# From https://github.com/tensorflow/tensorflow/blob/2aaeef25361311b21b9e81e992edff94bcb6bae3/third_party/dlpack/workspace.bzl
EGIT_DUCC_COMMIT="356d619a4b5f6f8940d15913c14a043355ef23be"			# From https://github.com/google/jax/blob/jaxlib-v0.4.6/third_party/ducc/workspace.bzl
EGIT_FARMHASH_COMMIT="0d859a811870d10f53a594927d0d0b97573ad06d"			# From https://github.com/tensorflow/tensorflow/blob/2aaeef25361311b21b9e81e992edff94bcb6bae3/third_party/farmhash/workspace.bzl
EGIT_EIGEN_COMMIT="2e9b945baf2901b644decf3fe48c84679d303d14"			# From https://github.com/tensorflow/tensorflow/blob/2aaeef25361311b21b9e81e992edff94bcb6bae3/third_party/eigen3/workspace.bzl
EGIT_GOOGLEAPIS_COMMIT="6b3fdcea8bc5398be4e7e9930c693f0ea09316a0"		# From https://github.com/tensorflow/tensorflow/blob/2aaeef25361311b21b9e81e992edff94bcb6bae3/tensorflow/workspace2.bzl
EGIT_GRPC_COMMIT="b54a5b338637f92bfcf4b0bc05e0f57a5fd8fadd"			# From https://github.com/tensorflow/tensorflow/blob/2aaeef25361311b21b9e81e992edff94bcb6bae3/tensorflow/workspace2.bzl
EGIT_LLVM_COMMIT="d2e0a98391e3657a679b98475d65954622c44a9e"			# From https://github.com/tensorflow/tensorflow/blob/2aaeef25361311b21b9e81e992edff94bcb6bae3/third_party/llvm/workspace.bzl
EGIT_PYBIND11_ABSEIL_COMMIT="2c4932ed6f6204f1656e245838f4f5eae69d2e29"		# From https://github.com/tensorflow/tensorflow/blob/2aaeef25361311b21b9e81e992edff94bcb6bae3/third_party/pybind11_abseil/workspace.bzl
EGIT_PYBIND11_BAZEL_COMMIT="72cbbf1fbc830e487e3012862b7b720001b70672"		# From https://github.com/tensorflow/tensorflow/blob/2aaeef25361311b21b9e81e992edff94bcb6bae3/third_party/pybind11_abseil/workspace.bzl
EGIT_RE2_COMMIT="a276a8c738735a0fe45a6ee590fe2df69bcf4502"			# From https://github.com/tensorflow/tensorflow/blob/2aaeef25361311b21b9e81e992edff94bcb6bae3/tensorflow/workspace2.bzl
EGIT_RULES_CC_COMMIT="081771d4a0e9d7d3aa0eed2ef389fa4700dfb23e"			# From https://github.com/tensorflow/runtime/blob/8016602194b2e29d6c26d40b8ddacf2929f2112c/third_party/rules_cuda/cuda/dependencies.bzl
EGIT_RULES_CLOSURE_COMMIT="308b05b2419edb5c8ee0471b67a40403df940149"		# From https://github.com/tensorflow/tensorflow/blob/2aaeef25361311b21b9e81e992edff94bcb6bae3/tensorflow/workspace3.bzl
EGIT_RULES_JAVA_COMMIT="7cf3cefd652008d0a64a419c34c13bdca6c8f178"
EGIT_RULES_PROTO_COMMIT="11bf7c25e666dd7ddacbcd4d4c4a9de7a25175f8"		# From https://github.com/tensorflow/tensorflow/blob/2aaeef25361311b21b9e81e992edff94bcb6bae3/tensorflow/workspace0.bzl
EGIT_SNAPPY_COMMIT="984b191f0fefdeb17050b42a90b7625999c13b8d"			# From https://github.com/tensorflow/tensorflow/blob/2aaeef25361311b21b9e81e992edff94bcb6bae3/tensorflow/workspace2.bzl
EGIT_STABLEHLO_COMMIT="48b32cb5126471481774244ddd8fee2f3efe66e1"		# From https://github.com/tensorflow/tensorflow/blob/2aaeef25361311b21b9e81e992edff94bcb6bae3/third_party/stablehlo/workspace.bzl
EGIT_TENSORFLOW_COMMIT="2aaeef25361311b21b9e81e992edff94bcb6bae3"		# From https://github.com/google/jax/blob/jaxlib-v0.4.6/WORKSPACE#L13
EGIT_TENSORFLOW_RUNTIME_COMMIT="8016602194b2e29d6c26d40b8ddacf2929f2112c"	# From https://github.com/tensorflow/tensorflow/blob/2aaeef25361311b21b9e81e992edff94bcb6bae3/third_party/tf_runtime/workspace.bzl
# DO NOT HARD WRAP
# DO NOT CHANGE TARBALL FILE EXT
# Do not use GH urls if .gitmodules exists in that project
bazel_external_uris="
https://github.com/abseil/abseil-cpp/archive/${EGIT_ABSEIL_CPP_COMMIT}.tar.gz -> abseil-cpp-${EGIT_ABSEIL_CPP_COMMIT}.tar.gz
https://github.com/bazelbuild/apple_support/releases/download/${APPLE_SUPPORT_PV}/apple_support.${APPLE_SUPPORT_PV}.tar.gz -> apple_support-${APPLE_SUPPORT_PV}.tar.gz
https://github.com/bazelbuild/bazel-toolchains/archive/${EGIT_BAZEL_TOOLCHAINS_COMMIT}.tar.gz -> bazel-toolchains-${EGIT_BAZEL_TOOLCHAINS_COMMIT}.tar.gz
https://github.com/bazelbuild/bazel-skylib/releases/download/${BAZEL_SKYLIB_PV}/bazel-skylib-${BAZEL_SKYLIB_PV}.tar.gz -> bazel-skylib-${BAZEL_SKYLIB_PV}.tar.gz
https://github.com/bazelbuild/platforms/releases/download/${PLATFORMS_PV}/platforms-${PLATFORMS_PV}.tar.gz -> platforms-${PLATFORMS_PV}.tar.gz
https://github.com/bazelbuild/rules_android/archive/v${RULES_ANDROID_PV}.zip -> rules_android-${RULES_ANDROID_PV}.zip
https://github.com/bazelbuild/rules_apple/releases/download/${RULES_APPLE_PV}/rules_apple.${RULES_APPLE_PV}.tar.gz
https://github.com/bazelbuild/rules_cc/archive/${EGIT_RULES_CC_COMMIT}.tar.gz -> rules_cc-${EGIT_RULES_CC_COMMIT}.tar.gz
https://github.com/bazelbuild/rules_closure/archive/${EGIT_RULES_CLOSURE_COMMIT}.tar.gz -> bazelbuild-rules_closure-${EGIT_RULES_CLOSURE_COMMIT}.tar.gz
https://github.com/bazelbuild/rules_java/archive/${EGIT_RULES_JAVA_COMMIT}.zip -> rules_java-${EGIT_RULES_JAVA_COMMIT}.zip
https://github.com/bazelbuild/rules_jvm_external/archive/${RULES_JVM_EXTERNAL_PV}.zip -> rules_jvm_external-${RULES_JVM_EXTERNAL_PV}.zip
https://github.com/bazelbuild/rules_pkg/releases/download/${RULES_PKG_PV}/rules_pkg-${RULES_PKG_PV}.tar.gz
https://github.com/bazelbuild/rules_proto/archive/${EGIT_RULES_PROTO_COMMIT}.tar.gz -> rules_proto-${EGIT_RULES_PROTO_COMMIT}.tar.gz
https://github.com/bazelbuild/rules_python/releases/download/${RULES_PYTHON_PV}/rules_python-${RULES_PYTHON_PV}.tar.gz -> rules_python-${RULES_PYTHON_PV}.tar.gz
https://github.com/bazelbuild/rules_swift/releases/download/${RULES_SWIFT_PV}/rules_swift.${RULES_SWIFT_PV}.tar.gz
https://github.com/dmlc/dlpack/archive/${EGIT_DLPACK_COMMIT}.tar.gz -> dlpack-${EGIT_DLPACK_COMMIT}.tar.gz
https://github.com/google/re2/archive/${EGIT_RE2_COMMIT}.tar.gz -> re2-${EGIT_RE2_COMMIT}.tar.gz
https://github.com/llvm/llvm-project/archive/${EGIT_LLVM_COMMIT}.tar.gz -> llvm-${EGIT_LLVM_COMMIT}.tar.gz
https://github.com/mreineck/ducc/archive/${EGIT_DUCC_COMMIT}.tar.gz -> ducc-${EGIT_DUCC_COMMIT}.tar.gz
https://github.com/oneapi-src/oneDNN/archive/refs/tags/v${ONEDNN_PV}.tar.gz -> oneDNN-${ONEDNN_PV}.tar.gz
https://github.com/open-source-parsers/jsoncpp/archive/${JSONCPP_PV}.tar.gz -> jsoncpp-${JSONCPP_PV}.tar.gz
https://github.com/pybind/pybind11_abseil/archive/${EGIT_PYBIND11_ABSEIL_COMMIT}.tar.gz -> pybind11_abseil-${EGIT_PYBIND11_ABSEIL_COMMIT}.tar.gz
https://github.com/pybind/pybind11_bazel/archive/${EGIT_PYBIND11_BAZEL_COMMIT}.tar.gz -> pybind11_bazel-${EGIT_PYBIND11_BAZEL_COMMIT}.tar.gz
https://github.com/tensorflow/runtime/archive/${EGIT_TENSORFLOW_RUNTIME_COMMIT}.tar.gz -> tensorflow-runtime-${EGIT_TENSORFLOW_RUNTIME_COMMIT}.tar.gz
https://github.com/tensorflow/tensorflow/archive/${EGIT_TENSORFLOW_COMMIT}.tar.gz -> tensorflow-${EGIT_TENSORFLOW_COMMIT}.tar.gz
https://github.com/google/farmhash/archive/${EGIT_FARMHASH_COMMIT}.tar.gz -> farmhash-${EGIT_FARMHASH_COMMIT}.tar.gz
https://github.com/google/flatbuffers/archive/v${FLATBUFFERS_PV}.tar.gz -> flatbuffers-${FLATBUFFERS_PV}.tar.gz
https://github.com/googleapis/googleapis/archive/${EGIT_GOOGLEAPIS_COMMIT}.tar.gz -> googleapis-${EGIT_GOOGLEAPIS_COMMIT}.tar.gz
https://github.com/openxla/stablehlo/archive/${EGIT_STABLEHLO_COMMIT}.zip -> stablehlo-${EGIT_STABLEHLO_COMMIT}.zip
https://gitlab.com/libeigen/eigen/-/archive/${EGIT_EIGEN_COMMIT}/eigen-${EGIT_EIGEN_COMMIT}.tar.gz -> eigen-${EGIT_EIGEN_COMMIT}.tar.gz
https://storage.googleapis.com/mirror.tensorflow.org/github.com/google/snappy/archive/${EGIT_SNAPPY_COMMIT}.tar.gz -> snappy-${EGIT_SNAPPY_COMMIT}.tar.gz

https://storage.googleapis.com/mirror.tensorflow.org/github.com/protocolbuffers/protobuf/archive/v${PROTOBUF_PV}.zip -> protobuf-${PROTOBUF_PV}.zip
"

#https://github.com/pybind/pybind11/archive/v${PYBIND11_PV}.tar.gz -> pybind11-${PYBIND11_PV}.tar.gz
#https://github.com/google/double-conversion/archive/v${DOUBLE_CONVERSION_PV}.tar.gz -> double-conversion-${DOUBLE_CONVERSION_PV}.tar.gz
#https://github.com/google/nsync/archive/${NSYNC_PV}.tar.gz -> nsync-${NSYNC_PV}.tar.gz
#https://storage.googleapis.com/mirror.tensorflow.org/github.com/grpc/grpc/archive/${EGIT_GRPC_COMMIT}.tar.gz -> grpc-${EGIT_GRPC_COMMIT}.tar.gz
#https://zlib.net/fossils/zlib-${ZLIB_PV}.tar.gz
SRC_URI="
	${bazel_external_uris}
https://github.com/google/jax/archive/refs/tags/${PN}-v${PV}.tar.gz
	-> ${MY_PN}-${PV}.tar.gz
"
S="${WORKDIR}/jax-jax-v${PV}"
RESTRICT="mirror"
DOCS=( CHANGELOG.md CITATION.bib README.md )

distutils_enable_tests "pytest"

setup_openjdk() {
	local jdk_bin_basepath
	local jdk_basepath

	if find \
		/usr/$(get_libdir)/openjdk-${JAVA_SLOT}*/ \
		-maxdepth 1 \
		-type d \
		2>/dev/null \
		1>/dev/null
	then
		export JAVA_HOME=$(find \
			/usr/$(get_libdir)/openjdk-${JAVA_SLOT}*/ \
			-maxdepth 1 \
			-type d \
			| sort -V \
			| head -n 1)
		export PATH="${JAVA_HOME}/bin:${PATH}"
	elif find \
		/opt/openjdk-bin-${JAVA_SLOT}*/ \
		-maxdepth 1 \
		-type d \
		2>/dev/null \
		1>/dev/null
	then
		export JAVA_HOME=$(find \
			/opt/openjdk-bin-${JAVA_SLOT}*/ \
			-maxdepth 1 \
			-type d \
			| sort -V \
			| head -n 1)
		export PATH="${JAVA_HOME}/bin:${PATH}"
	else
eerror
eerror "dev-java/openjdk:${JAVA_SLOT} or dev-java/openjdk-bin:${JAVA_SLOT} must be installed"
eerror
		die
	fi
}

verify_rocm() {
	# In the upstream build guide, they set /opt/rocm-<ver> for --rocm_path.
	# This indicates that interdependence is important for all in that
	# version slot.  Plus, I don't think they test each version combo in
	# this distro, so breakage may likely happen.
	local expected_pv=$(best_version "sci-libs/rocFFT" \
		| sed -e "s|sci-libs/rocFFT-||")
	expected_pv=$(ver_cut 1-3 ${expected_pv})
	local catpn
	for catpn in ${ROCM_DEPEND[@]} ${ROCM_INDIRECT_DEPEND[@]} ; do
		if ! has_version "~${catpn}-${pv}" ; then
			local actual_pv=$(best_version "${catpn}" \
				| sed -e "s|${catpn}-||g")
			actual_pv=$(ver_cut 1-3 ${actual_pv})
eerror
eerror "All ROCm direct/indirect DEPENDs must be the same version"
eerror
eerror "Package:  ${catpn}"
eerror
eerror "Expected version:\t${expected_pv}"
eerror "Actual version:\t${actual_pv}"
eerror
			die
		fi
	done
}

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

	setup_openjdk
	#check_network_sandbox_permissions

	use rocm && verify_rocm
}

src_unpack() {
	unpack ${MY_PN}-${PV}.tar.gz
	mkdir -p "${WORKDIR}/tarballs" || die
	mkdir -p "${WORKDIR}/patches" || die
	cp -a \
		$(realpath "${DISTDIR}/tensorflow-${EGIT_TENSORFLOW_COMMIT}.tar.gz") \
		"${WORKDIR}/tarballs" \
		|| die
	bazel_load_distfiles "${bazel_external_uris}"
	cd "${S}" || die
	if use rocm ; then
		EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/tensorflow-upstream.git"
		EGIT_BRANCH="develop-upstream" # Default branch
		EGIT_COMMIT="HEAD"
		EGIT_CHECKOUT_DIR="${WORKDIR}/rocm-tensorflow-upstream"
		git-r3_fetch
		git-r3_checkout
	fi
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
		pybind11
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
		args=( --target_cpu_features=native )
	elif is-flagq '-march=generic' ; then
		args=( --target_cpu_features=default )
	elif ! [[ "${CFLAGS}" =~ "-march=" ]] ; then
		args=( --target_cpu_features=default )
	else
ewarn
ewarn "Downgrading -march=* to generic."
ewarn "Use -march=native to optimize."
ewarn
		args=( --target_cpu_features=default )
	fi

	use cuda && args=( --enable_cuda )
	if use rocm ; then
		local rocm_pv=$(best_version "sci-libs/rocFFT" \
			| sed -e "s|sci-libs/rocFFT-||")
		ewarn "You may need to fork ebuild to complete implementation for rocm"
	# See https://jax.readthedocs.io/en/latest/developer.html#additional-notes-for-building-a-rocm-jaxlib-for-amd-gpus
		${EPYTHON} build/build.py \
			--enable_rocm \
			--rocm_path=/usr \
			--bazel_options=--override_repository=xla=/path/to/xla-upstream \
			--configure_only \
			${args[@]} \
			|| die
	else
		${EPYTHON} build/build.py \
			--configure_only \
			${args[@]} \
			|| die
	fi

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

	set -- bazel --bazelrc="${S}/build/.jax_configure.bazelrc" --output_base="${output_base}" ${@}
	echo "${*}" >&2
	"${@}" || die "ebazel failed"
}

python_compile() {
	load_env
	[[ -e ".jax_configure.bazelrc" ]] || die "Missing file"
einfo "Building for EPYTHON=${EPYTHON} PYTHON=${PYTHON}"
	cd "${S}/build" || die
	export PYTHON_BIN_PATH="${PYTHON}"

	sed -i -r -e "s|python[0-9].[0-9]+|${EPYTHON}|g" \
		"${S}/build/.jax_configure.bazelrc" || die

	_ebazel run \
		--verbose_failures=true \
		":build_wheel" \
		-- \
		--output_path=$(pwd)/dist \
		--cpu=$(get_host)
	_ebazel shutdown

	local python_pv="${EPYTHON}"
	python_pv="${python_pv/python}"
	python_pv="${python_pv/./}"
	local wheel_path=$(realpath "${S}/build/dist/${PN}-${PV}-cp${python_pv}-cp${python_pv}-manylinux2014_"*".whl")
	distutils_wheel_install "${BUILD_DIR}/install" \
		"${wheel_path}"
}

src_install() {
	load_env
	distutils-r1_src_install
	docinto licenses
	dodoc AUTHORS LICENSE
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
