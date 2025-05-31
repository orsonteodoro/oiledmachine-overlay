# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ABSEIL_CPP_COMMIT="b971ac5250ea8de900eae9f95e06548d14cd95fe"		# https://github.com/tensorflow/tensorflow/blob/v2.15.0/third_party/absl/workspace.bzl#L10
APPLE_SUPPORT_PV="1.6.0"						# https://github.com/tensorflow/tensorflow/blob/v2.15.0/tensorflow/workspace2.bzl#L742
BAZEL_PV="6.1.0"							# https://github.com/tensorflow/tensorflow/blob/v2.15.0/.bazelversion
BAZEL_SKYLIB_PV="1.3.0"							# https://github.com/tensorflow/tensorflow/blob/v2.15.0/tensorflow/workspace3.bzl#L26
BAZEL_TOOLCHAINS_COMMIT="8c717f8258cd5f6c7a45b97d974292755852b658"	# https://github.com/tensorflow/tensorflow/blob/v2.15.0/tensorflow/workspace1.bzl#L30
BENCHMARK_COMMIT="f7547e29ccaed7b64ef4f7495ecfff1c9f6f3d03"		# https://github.com/tensorflow/tensorflow/blob/v2.15.0/third_party/benchmark/workspace.bzl#L7
CPPITERTOOLS_PV="2.0"							# https://github.com/tensorflow/text/blob/v2.15.0/WORKSPACE#L32
DARTS_CLONE_COMMIT="e40ce4627526985a7767444b6ed6893ab6ff8983"		# https://github.com/tensorflow/text/blob/v2.15.0/WORKSPACE#L43
DATA_PLANE_API_COMMIT="c83ed7ea9eb5fb3b93d1ad52b59750f1958b8bde"	# https://github.com/grpc/grpc/blob/b54a5b338637f92bfcf4b0bc05e0f57a5fd8fadd/bazel/grpc_deps.bzl#L239
DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="no"
DOUBLE_CONVERSION_PV="3.2.0"						# https://github.com/tensorflow/tensorflow/blob/v2.15.0/tensorflow/workspace2.bzl#L634
EIGEN_COMMIT="66e8f38891841bf88ee976a316c0c78a52f0cee5"			# https://github.com/tensorflow/tensorflow/blob/v2.15.0/third_party/eigen3/workspace.bzl#L10
FARMHASH_COMMIT="0d859a811870d10f53a594927d0d0b97573ad06d"		# https://github.com/tensorflow/tensorflow/blob/v2.15.0/third_party/farmhash/workspace.bzl#L10
FLATBUFFERS_PV="23.5.26"						# https://github.com/tensorflow/tensorflow/blob/v2.15.0/third_party/flatbuffers/workspace.bzl#L10
GCC_COMPAT=( {12..9} )
GIFLIB_PV="5.2.1"							# https://github.com/tensorflow/tensorflow/blob/v2.15.0/tensorflow/workspace2.bzl#L341
GOOGLEAPIS_COMMIT="6b3fdcea8bc5398be4e7e9930c693f0ea09316a0"		# https://github.com/tensorflow/tensorflow/blob/v2.15.0/tensorflow/workspace2.bzl#L309
GRPC_COMMIT="b54a5b338637f92bfcf4b0bc05e0f57a5fd8fadd"			# https://github.com/tensorflow/tensorflow/blob/v2.15.0/tensorflow/workspace2.bzl#L438
HIGHWAYHASH_COMMIT="c13d28517a4db259d738ea4886b1f00352a3cc33"		# https://github.com/tensorflow/tensorflow/blob/v2.15.0/third_party/highwayhash/workspace.bzl#L8
ICU_PV="64-2"								# https://github.com/tensorflow/text/blob/v2.15.0/WORKSPACE#L11
LIBJPEG_TURBO_PV="2.1.4"						# https://github.com/tensorflow/tensorflow/blob/v2.15.0/third_party/jpeg/workspace.bzl#L8
LLVM_COMMIT="49cb1595c1b3ae1de3684fea6148363c15bae12a"			# https://github.com/tensorflow/tensorflow/blob/v2.15.0/third_party/llvm/workspace.bzl#L7
ML_DTYPES_COMMIT="2ca30a2b3c0744625ae3d6988f5596740080bbd0"		# https://github.com/tensorflow/tensorflow/blob/v2.15.0/third_party/py/ml_dtypes/workspace.bzl#L10
NASM_PV="2.14.02"							# https://github.com/tensorflow/tensorflow/blob/v2.15.0/third_party/nasm/workspace.bzl#L11
NSYNC_PV="1.25.0"							# https://github.com/tensorflow/tensorflow/blob/v2.15.0/tensorflow/workspace2.bzl#L386
OOURAFFT_PV="1.0"							# https://github.com/tensorflow/tensorflow/blob/v2.15.0/tensorflow/workspace2.bzl#L502
PLATFORMS_PV="0.0.6"							# https://github.com/tensorflow/runtime/blob/70637966e2ec9afccc2cf4d51ed2391172b1b9c5/third_party/rules_cuda/cuda/dependencies.bzl#L67
PROTOBUF_PV="3.21.9"							# https://github.com/tensorflow/tensorflow/blob/v2.15.0/tensorflow/workspace2.bzl#L377
PYBIND11_BAZEL_COMMIT="72cbbf1fbc830e487e3012862b7b720001b70672"	# https://github.com/tensorflow/tensorflow/blob/v2.15.0/third_party/pybind11_bazel/workspace.bzl#L9
PYBIND11_PV="2.10.0"							# https://github.com/tensorflow/text/blob/v2.15.0/WORKSPACE#L95
PYTHON_COMPAT=( "python3_11" )
RE2_COMMIT="03da4fc0857c285e3a26782f6bc8931c4c950df4"			# https://github.com/tensorflow/tensorflow/blob/v2.15.0/tensorflow/workspace2.bzl#L271
RUY_COMMIT="3286a34cc8de6149ac6844107dfdffac91531e72"			# https://github.com/tensorflow/tensorflow/blob/v2.15.0/third_party/ruy/workspace.bzl#L11
RULES_ANDROID_PV="0.1.1"						# https://github.com/tensorflow/tensorflow/blob/v2.15.0/tensorflow/workspace2.bzl#L723
RULES_APPLE_PV="2.3.0"							# https://github.com/tensorflow/tensorflow/blob/v2.15.0/tensorflow/workspace2.bzl#L728
RULES_CC_COMMIT="081771d4a0e9d7d3aa0eed2ef389fa4700dfb23e"		# https://github.com/tensorflow/runtime/blob/70637966e2ec9afccc2cf4d51ed2391172b1b9c5/third_party/rules_cuda/cuda/dependencies.bzl#L42
RULES_CC_PV="0.0.2"							# https://github.com/bazelbuild/bazel/blob/6.1.0/distdir_deps.bzl#L57
RULES_CLOSURE_COMMIT="308b05b2419edb5c8ee0471b67a40403df940149"		# https://github.com/tensorflow/tensorflow/blob/v2.15.0/tensorflow/workspace3.bzl#L18
RULES_FOREIGN_CC_PV="0.7.1"						# https://github.com/google/benchmark/blob/f7547e29ccaed7b64ef4f7495ecfff1c9f6f3d03/bazel/benchmark_deps.bzl#L22
RULES_GO_PV="0.34.0"							# https://github.com/tensorflow/tensorflow/blob/v2.15.0/tensorflow/workspace2.bzl#L799
RULES_JAVA_COMMIT="7cf3cefd652008d0a64a419c34c13bdca6c8f178"		# https://github.com/bazelbuild/bazel/blob/6.1.2/distdir_deps.bzl#L69
RULES_JVM_EXTERNAL_PV="4.3"						# https://github.com/tensorflow/tensorflow/blob/v2.15.0/tensorflow/workspace3.bzl#L53
RULES_LICENSE_PV="0.0.4"						# https://github.com/tensorflow/tensorflow/blob/v2.15.0/tensorflow/workspace3.bzl#L38
RULES_PKG_PV="0.7.1"							# https://github.com/tensorflow/tensorflow/blob/v2.15.0/tensorflow/workspace3.bzl#L47
RULES_PROTO_COMMIT="11bf7c25e666dd7ddacbcd4d4c4a9de7a25175f8"		# https://github.com/tensorflow/tensorflow/blob/v2.15.0/tensorflow/workspace0.bzl#L120
RULES_PYTHON_PV="0.1.0"							# https://github.com/llvm/llvm-project/blob/49cb1595c1b3ae1de3684fea6148363c15bae12a/third-party/benchmark/WORKSPACE#L35
RULES_SWIFT_PV="1.5.0"							# https://github.com/tensorflow/tensorflow/blob/v2.15.0/tensorflow/workspace2.bzl#L735
SENTENCEPIECE_PV="0.1.96"						# https://github.com/tensorflow/text/blob/v2.15.0/WORKSPACE#L23
TENSORFLOW_HUB_COMMIT="c83a2362abdad2baae67508aa17efb42bf7c7dd6"	# https://github.com/tensorflow/text/blob/v2.15.0/WORKSPACE#L67
TENSORFLOW_PV="2.15.0"							# https://github.com/tensorflow/text/blob/v2.15.0/WORKSPACE#L78
TENSORFLOW_RUNTIME_COMMIT="70637966e2ec9afccc2cf4d51ed2391172b1b9c5"	# https://github.com/tensorflow/tensorflow/blob/v2.15.0/third_party/tf_runtime/workspace.bzl#L9
UPB_COMMIT="9effcbcb27f0a665f9f345030188c0b291e32482"			# https://github.com/tensorflow/tensorflow/blob/v2.15.0/tensorflow/workspace2.bzl#L807
ZLIB_PV="1.2.13"							# https://github.com/tensorflow/tensorflow/blob/v2.15.0/tensorflow/workspace2.bzl#L484

inherit bazel check-compiler-switch distutils-r1 flag-o-matic

KEYWORDS="~amd64"
S="${WORKDIR}/text-${PV}"
bazel_external_uris="
https://github.com/abseil/abseil-cpp/archive/${ABSEIL_CPP_COMMIT}.tar.gz -> abseil-cpp-${ABSEIL_CPP_COMMIT}.tar.gz
https://github.com/bazelbuild/apple_support/releases/download/${APPLE_SUPPORT_PV}/apple_support.${APPLE_SUPPORT_PV}.tar.gz
https://github.com/bazelbuild/bazel-skylib/releases/download/${BAZEL_SKYLIB_PV}/bazel-skylib-${BAZEL_SKYLIB_PV}.tar.gz
https://github.com/bazelbuild/platforms/releases/download/${PLATFORMS_PV}/platforms-${PLATFORMS_PV}.tar.gz -> platforms-${PLATFORMS_PV}.tar.gz
https://github.com/bazelbuild/rules_android/archive/v${RULES_ANDROID_PV}.zip -> rules_android-${RULES_ANDROID_PV}.zip
https://github.com/bazelbuild/rules_cc/releases/download/${RULES_CC_PV}/rules_cc-${RULES_CC_PV}.tar.gz
https://github.com/bazelbuild/rules_cc/archive/${RULES_CC_COMMIT}.tar.gz -> rules_cc-${RULES_CC_COMMIT}.tar.gz
https://github.com/bazelbuild/rules_closure/archive/${RULES_CLOSURE_COMMIT}.tar.gz -> rules_closure-${RULES_CLOSURE_COMMIT}.tar.gz
https://github.com/bazelbuild/rules_apple/releases/download/${RULES_APPLE_PV}/rules_apple.${RULES_APPLE_PV}.tar.gz
https://github.com/bazelbuild/rules_foreign_cc/archive/${RULES_FOREIGN_CC_PV}.tar.gz -> rules_foreign_cc-${RULES_FOREIGN_CC_PV}.tar.gz
https://github.com/bazelbuild/rules_go/releases/download/v${RULES_GO_PV}/rules_go-v${RULES_GO_PV}.zip
https://github.com/bazelbuild/rules_java/archive/${RULES_JAVA_COMMIT}.zip -> rules_java-${RULES_JAVA_COMMIT}.zip
https://github.com/bazelbuild/rules_jvm_external/archive/${RULES_JVM_EXTERNAL_PV}.zip -> rules_jvm_external-${RULES_JVM_EXTERNAL_PV}.zip
https://github.com/bazelbuild/rules_license/releases/download/${RULES_LICENSE_PV}/rules_license-${RULES_LICENSE_PV}.tar.gz -> rules_license-${RULES_LICENSE_PV}.tar.gz
https://github.com/bazelbuild/rules_pkg/releases/download/${RULES_PKG_PV}/rules_pkg-${RULES_PKG_PV}.tar.gz
https://github.com/bazelbuild/rules_python/releases/download/${RULES_PYTHON_PV}/rules_python-${RULES_PYTHON_PV}.tar.gz -> rules_python-${RULES_PYTHON_PV}.tar.gz
https://github.com/bazelbuild/rules_proto/archive/${RULES_PROTO_COMMIT}.tar.gz -> rules_proto-${RULES_PROTO_COMMIT}.tar.gz
https://github.com/bazelbuild/rules_swift/releases/download/${RULES_SWIFT_PV}/rules_swift.${RULES_SWIFT_PV}.tar.gz
https://github.com/bazelbuild/bazel-toolchains/archive/${BAZEL_TOOLCHAINS_COMMIT}.tar.gz -> bazel-toolchains-${BAZEL_TOOLCHAINS_COMMIT}.tar.gz
https://github.com/envoyproxy/data-plane-api/archive/${DATA_PLANE_API_COMMIT}.tar.gz -> data-plane-api-${DATA_PLANE_API_COMMIT}.tar.gz
https://github.com/google/benchmark/archive/${BENCHMARK_COMMIT}.tar.gz -> google-benchmark-${BENCHMARK_COMMIT}.tar.gz
https://github.com/google/double-conversion/archive/v${DOUBLE_CONVERSION_PV}.tar.gz -> double-conversion-${DOUBLE_CONVERSION_PV}.tar.gz
https://github.com/google/farmhash/archive/${FARMHASH_COMMIT}.tar.gz -> farmhash-${FARMHASH_COMMIT}.tar.gz
https://github.com/google/flatbuffers/archive/v${FLATBUFFERS_PV}.tar.gz -> flatbuffers-${FLATBUFFERS_PV}.tar.gz
https://github.com/google/highwayhash/archive/${HIGHWAYHASH_COMMIT}.tar.gz -> highwayhash-${HIGHWAYHASH_COMMIT}.tar.gz
https://github.com/google/re2/archive/${RE2_COMMIT}.tar.gz -> re2-${RE2_COMMIT}.tar.gz
https://github.com/google/sentencepiece/archive/refs/tags/v${SENTENCEPIECE_PV}.zip -> sentencepiece-${SENTENCEPIECE_PV}.zip
https://github.com/googleapis/googleapis/archive/${GOOGLEAPIS_COMMIT}.tar.gz -> googleapis-${GOOGLEAPIS_COMMIT}.tar.gz
https://github.com/llvm/llvm-project/archive/${LLVM_COMMIT}.tar.gz -> llvm-${LLVM_COMMIT}.tar.gz
https://github.com/petewarden/OouraFFT/archive/v${OOURAFFT_PV}.tar.gz -> oourafft-${OOURAFFT_PV}.tar.gz
https://github.com/pybind/pybind11/archive/v${PYBIND11_PV}.tar.gz -> pybind11-${PYBIND11_PV}.tar.gz
https://github.com/pybind/pybind11_bazel/archive/${PYBIND11_BAZEL_COMMIT}.tar.gz -> pybind11_bazel-${PYBIND11_BAZEL_COMMIT}.tar.gz
https://github.com/ryanhaining/cppitertools/archive/refs/tags/v${CPPITERTOOLS_PV}.zip -> cppitertools-${CPPITERTOOLS_PV}.zip
https://github.com/s-yata/darts-clone/archive/${DARTS_CLONE_COMMIT}.zip -> darts-clone-${DARTS_CLONE_COMMIT}.zip
https://github.com/tensorflow/hub/archive/${TENSORFLOW_HUB_COMMIT}.zip -> tensorflow-hub-${TENSORFLOW_HUB_COMMIT}.zip
https://github.com/tensorflow/runtime/archive/${TENSORFLOW_RUNTIME_COMMIT}.tar.gz -> tensorflow-runtime-${TENSORFLOW_RUNTIME_COMMIT}.tar.gz
https://github.com/tensorflow/tensorflow/archive/v${TENSORFLOW_PV}.zip -> tensorflow-${TENSORFLOW_PV}.zip
https://gitlab.com/libeigen/eigen/-/archive/${EIGEN_COMMIT}/eigen-${EIGEN_COMMIT}.tar.gz
https://pilotfiber.dl.sourceforge.net/project/giflib/giflib-${GIFLIB_PV}.tar.gz -> giflib-${GIFLIB_PV}.tar.gz
https://storage.googleapis.com/mirror.tensorflow.org/github.com/google/nsync/archive/${NSYNC_PV}.tar.gz -> nsync-${NSYNC_PV}.tar.gz
https://storage.googleapis.com/mirror.tensorflow.org/github.com/google/ruy/archive/${RUY_COMMIT}.zip -> ruy-${RUY_COMMIT}.zip
https://storage.googleapis.com/mirror.tensorflow.org/github.com/grpc/grpc/archive/${GRPC_COMMIT}.tar.gz -> grpc-${GRPC_COMMIT}.tar.gz
https://storage.googleapis.com/mirror.tensorflow.org/github.com/jax-ml/ml_dtypes/archive/${ML_DTYPES_COMMIT}/ml_dtypes-${ML_DTYPES_COMMIT}.tar.gz
https://storage.googleapis.com/mirror.tensorflow.org/github.com/libjpeg-turbo/libjpeg-turbo/archive/refs/tags/${LIBJPEG_TURBO_PV}.tar.gz -> libjpeg-turbo-${LIBJPEG_TURBO_PV}.tar.gz
https://storage.googleapis.com/mirror.tensorflow.org/github.com/protocolbuffers/protobuf/archive/v${PROTOBUF_PV}.zip -> protobuf-${PROTOBUF_PV}.zip
https://storage.googleapis.com/mirror.tensorflow.org/github.com/protocolbuffers/upb/archive/${UPB_COMMIT}.tar.gz -> upb-${UPB_COMMIT}.tar.gz
https://storage.googleapis.com/mirror.tensorflow.org/github.com/unicode-org/icu/archive/release-${ICU_PV}.zip -> icu-${ICU_PV}.zip
https://www.nasm.us/pub/nasm/releasebuilds/${NASM_PV}/nasm-${NASM_PV}.tar.bz2 -> nasm-${NASM_PV}.tar.bz2
https://zlib.net/fossils/zlib-${ZLIB_PV}.tar.gz -> zlib-${ZLIB_PV}.tar.gz
"
SRC_URI="
	${bazel_external_uris}
https://github.com/tensorflow/text/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Text processing in TensorFlow"
HOMEPAGE="
	https://github.com/tensorflow/text
	https://pypi.org/project/tensorflow-text/
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
big-endian doc python test
ebuild_revision_4
"
REQUIRED_USE+="
"
RDEPEND_PROTOBUF_3_21="
	|| (
		(
			!big-endian? (
				$(python_gen_cond_dep '
					=net-libs/grpc-1.53*[${PYTHON_USEDEP},python]
				')
			)
			big-endian? (
				=net-libs/grpc-1.53*[-python]
			)
		)
		(
			!big-endian? (
				$(python_gen_cond_dep '
					=net-libs/grpc-1.54*[${PYTHON_USEDEP},python]
				')
			)
			big-endian? (
				=net-libs/grpc-1.54*[-python]
			)
		)
	)
	net-libs/grpc:=
"
RDEPEND+="
	${RDEPEND_PROTOBUF_3_21}
	=sci-ml/tensorflow-${PV%.*}*[${PYTHON_SINGLE_USEDEP},big-endian=,python=]
"
DEPEND+="
	${RDEPEND}
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
	>=dev-build/bazel-${BAZEL_PV}:${BAZEL_PV%.*}
	sys-devel/binutils[gold,plugins]
	|| (
		$(gen_gcc_bdepend)
	)
"
DOCS=( "README.md" )
PATCHES=(
	"${FILESDIR}/tensorflow-text-2.16.1-fix-bazel-bin-detect.patch"
)

pkg_setup() {
	check-compiler-switch_start
	python_setup
	# Building with clang is broken.
	local s
	local GCC_SLOT="-1"
	for s in ${GCC_COMPAT[@]} ; do
		if has_version "sys-devel/gcc:${s}" ; then
			GCC_SLOT=${s}
			export CC="${CHOST}-gcc-${GCC_SLOT}"
			export CXX="${CHOST}-g++-${GCC_SLOT}"
			export CPP="${CC} -E"
			strip-unsupported-flags
			break
		fi
	done
	if (( ${GCC_SLOT} == -1 )) ; then
eerror "You need slot 9-12 for sys-devel/gcc."
		die
	fi
	export GCC_HOST_COMPILER_PATH="${EPREFIX}/usr/${CHOST}/gcc-bin/${gcc_slot}/${CHOST}-gcc-${GCC_SLOT}"
	export HOST_C_COMPILER="${EPREFIX}/usr/bin/${CC}"
	export HOST_CXX_COMPILER="${EPREFIX}/usr/bin/${CXX}"

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi
}

src_unpack() {
	mkdir -p "${WORKDIR}/bin" || die
	export PATH="${WORKDIR}/bin:${PATH}"
	ln -s "/usr/bin/bazel-${BAZEL_PV%.*}" "${WORKDIR}/bin/bazel" || die
	bazel --version | grep -q "bazel ${BAZEL_PV%.*}" || die "dev-build/bazel:${BAZEL_PV%.*} is not installed"
	unpack ${A}
	bazel_load_distfiles "${bazel_external_uris}"
	cat "${FILESDIR}/${PV}/.bazelrc" > "${S}/.bazelrc" || die
	cat "${FILESDIR}/${PV}/.bazelversion" > "${S}/.bazelversion" || die
}

src_prepare() {
	echo 'build --noshow_progress' >> "${S}/.bazelrc" || die # Disable high CPU usage on xfce4-terminal
	echo 'build --subcommands' >> "${S}/.bazelrc" || die # Increase verbosity
	replace-flags '-O0' '-O1'
	filter-flags '-fuse-ld=*'
	append-ldflags -fuse-ld=gold
	BUILD_LDFLAGS+=" -fuse-ld=gold"
	bazel_setup_bazelrc
	cat "${T}/bazelrc" >> "${S}/.bazelrc"

	echo "build:manylinux2010 --config=release_cpu_linux" >> "${S}/.bazelrc"
	echo "build:manylinux2014 --config=release_cpu_linux" >> "${S}/.bazelrc"

	default
	python_copy_sources
}

set_envvars() {
	export TF_PYTHON_VERSION="${EPYTHON/python/}"
	if use python ; then
		export PYTHON_BIN_PATH="${PYTHON}"
		export PYTHON_LIB_PATH="$(python_get_sitedir)"
		HERMETIC_PYTHON_VERSION=$("${PYTHON}" -c "import sys; print('.'.join(map(str, sys.version_info[:2])))")
		export HERMETIC_PYTHON_VERSION
	else
		export PYTHON_BIN_PATH="$(which python)"
		export PYTHON_LIB_PATH="$(python -c 'from distutils.sysconfig import *; print(get_python_lib())')"
		HERMETIC_PYTHON_VERSION=$("$(which python)" -c "import sys; print('.'.join(map(str, sys.version_info[:2])))")
		export HERMETIC_PYTHON_VERSION
	fi
	export TF_NEED_CLANG=0
}

src_configure() {
	local SYSLIBS=(
# Prevent pulling go and fix:
# Error in download: java.io.IOException: Error downloading [https://golang.org/dl/?mode=json&include=all, https://golang.google.cn/dl/?mode=json&include=all] to [...]
		com_github_grpc_grpc
	)
	export TF_SYSTEM_LIBS=$(echo "${SYSLIBS[@]}")
	do_configure() {
		set_envvars

		local local python_path
		if use python ; then
			python_path="${PYTHON}"
		else
			python_path=$(which python)
		fi

		TF_LFLAGS_2=( $(${python_path} -c "import tensorflow as tf; print(' '.join(tf.sysconfig.get_link_flags()))" | awk '{print $2}') )
		TF_ABIFLAG=$(${python_path} -c "import tensorflow as tf; print(tf.sysconfig.CXX11_ABI_FLAG)")

		HEADER_DIR="/usr/include/tensorflow"
		SHARED_LIBRARY_DIR="/usr/$(get_libdir)"
		SHARED_LIBRARY_NAME=$(echo ${TF_LFLAGS_2} | rev | cut -d ":" -f1 | rev)

		export TF_HEADER_DIR="${HEADER_DIR}"
		export TF_SHARED_LIBRARY_DIR="${SHARED_LIBRARY_DIR}"
		export TF_SHARED_LIBRARY_NAME="${SHARED_LIBRARY_NAME}"
		export TF_CXX11_ABI_FLAG="${TF_ABIFLAG}"

		export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${SHARED_LIBRARY_DIR}"

		echo "build --action_env=TF_HEADER_DIR=\"${HEADER_DIR}\"" >> ".bazelrc"
		echo "build --action_env=TF_SHARED_LIBRARY_DIR=\"${SHARED_LIBRARY_DIR}\"" >> ".bazelrc"
		echo "build --action_env=TF_SHARED_LIBRARY_NAME=\"${SHARED_LIBRARY_NAME}\"" >> ".bazelrc"
		echo "build --action_env=TF_CXX11_ABI_FLAG=\"${TF_ABIFLAG}\"" >> ".bazelrc"

		echo "build --host_action_env=TF_HEADER_DIR=\"${HEADER_DIR}\"" >> ".bazelrc"
		echo "build --host_action_env=TF_SHARED_LIBRARY_DIR=\"${SHARED_LIBRARY_DIR}\"" >> ".bazelrc"
		echo "build --host_action_env=TF_SHARED_LIBRARY_NAME=\"${SHARED_LIBRARY_NAME}\"" >> ".bazelrc"
		echo "build --host_action_env=TF_CXX11_ABI_FLAG=\"${TF_ABIFLAG}\"" >> ".bazelrc"
	}
	if use python; then
		python_foreach_impl run_in_build_dir do_configure
        else
		do_configure
        fi
}

do_compile() {
einfo "Building for ${EPYTHON}"
	export JAVA_HOME=$(java-config --jre-home)
	pushd "${WORKDIR}/text-${PV}-${EPYTHON/./_}/" >/dev/null 2>&1 || die
		set_envvars

		bazel run \
			--enable_runfiles \
			//oss_scripts/pip_package:build_pip_package \
			-- \
			"${WORKDIR}/text-${PV}-${EPYTHON/./_}" \
			|| die
		bazel shutdown || die

		local out="${T}/out-${EPYTHON}"
		mkdir -p "${out}" || die
		local src=$(realpath "${HOME}/.cache/bazel/_bazel_portage/"*"/execroot/org_tensorflow_text/bazel-out/k8-opt/bin/oss_scripts/pip_package/build_pip_package.runfiles")
		cp -L \
			"${src}/org_tensorflow_text/oss_scripts/pip_package/setup.py" \
			"${src}/org_tensorflow_text/oss_scripts/pip_package/LICENSE" \
			"${src}/org_tensorflow_text/oss_scripts/pip_package/MANIFEST.in" \
			"${out}" \
			|| die
		cp -L -R \
			"${src}/org_tensorflow_text/tensorflow_text" \
			"${out}" \
			|| die

		pushd "${out}" >/dev/null 2>&1 || die
			distutils-r1_python_compile
		popd >/dev/null 2>&1 || die

		local pypv="${EPYTHON}"
		pypv="${pypv/./}"
		pypv="${pypv/python/}"
		local wheel_path=$(realpath "${WORKDIR}/text-${PV}-${EPYTHON/./_}/tensorflow_text-${PV}-cp${pypv}-cp${pypv}-"*".whl")
		einfo "wheel_path=${wheel_path}"
		local d="${WORKDIR}/text-${PV}-${EPYTHON/./_}/install"
		distutils_wheel_install "${d}" \
			"${wheel_path}"

		# Unbreak die check
		mkdir -p "${d}/usr/bin"
		touch "${d}/usr/bin/"{"${EPYTHON}","python3","python","pyvenv.cfg"}
	popd >/dev/null 2>&1 || die
}

src_compile() {
	if use python; then
		python_foreach_impl run_in_build_dir do_compile
        else
		do_compile
        fi
}

_DEFAULT_PYTHON=""
python_install() {
	if ! use python ; then
		[[ $(${EPYTHON} --version) != "${_DEFAULT_PYTHON}" ]] && return
	fi
	distutils-r1_python_install
}

src_install() {
	if ! use python; then
		_DEFAULT_PYTHON=$(python --version)
        fi

	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
