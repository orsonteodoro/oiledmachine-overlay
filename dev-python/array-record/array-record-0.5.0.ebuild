# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-/_}"

ABSEIL_PY_COMMIT="127c98870edf5f03395ce9cf886266fa5f24455e"			# https://github.com/google/array_record/blob/v0.5.0/WORKSPACE#L19
ABSEIL_CPP_PV="20230125.0"							# https://github.com/google/array_record/blob/v0.5.0/WORKSPACE#L12
BAZEL_SKYLIB_PV="1.0.2"								# https://github.com/protocolbuffers/protobuf/blob/v21.12/protobuf_deps.bzl#L34
BAZEL_SLOT="5.4"								# https://github.com/google/array_record/blob/v0.5.0/oss/build_whl.sh#L43C28-L43C33
BROTLI_COMMIT="3914999fcc1fda92e750ef9190aa6db9bf7bdb07"			# https://github.com/google/array_record/blob/v0.5.0/WORKSPACE#L26
COVERAGE_OUTPUT_GENERATOR_PV="2.5"						# https://github.com/bazelbuild/bazel/blob/5.4.1/distdir_deps.bzl#L274
DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
EIGEN_PV="3.4.0"								# https://github.com/google/array_record/blob/v0.5.0/WORKSPACE#L41
GOOGLETEST_COMMIT="9bb354fa8325fa31faa1e12627b25ab445e6eed3"			# Based on committer-date:<=2023-10-20 gh search   https://github.com/google/array_record/blob/v0.5.0/WORKSPACE#L31
HIGHWAYHASH_COMMIT="a7f68e2f95fac08b24327d74747521cf634d5aff"			# https://github.com/google/array_record/blob/v0.5.0/WORKSPACE#L136
JAVA_TOOLS_PV="11.7.1"								# https://github.com/bazelbuild/bazel/blob/5.4.1/distdir_deps.bzl#L290
PROTOBUF_PV="21.12"								# https://github.com/google/array_record/blob/v0.5.0/WORKSPACE#L81
PYBIND11_BAZEL_COMMIT="5f458fa53870223a0de7eeb60480dd278b442698"		# https://github.com/google/array_record/blob/v0.5.0/WORKSPACE#L60
PYBIND11_PV="2.10.3"								# https://github.com/google/array_record/blob/v0.5.0/WORKSPACE#L68
PYTHON_COMPAT=( "python3_"{10..11} )						# Upstream list only up to 3.11
RIEGELI_COMMIT="40e3dc7969036966dd3bb1d499dc09845d00dc81"			# Based on committer-date:<=2023-10-20 gh search   https://github.com/google/array_record/blob/v0.5.0/WORKSPACE#L92
RULES_CC_COMMIT="818289e5613731ae410efb54218a4077fb9dbb03"			# https://github.com/protocolbuffers/protobuf/blob/v21.12/protobuf_deps.bzl#L63
RULES_JAVA_COMMIT="981f06c3d2bd10225e85209904090eb7b5fb26bd"			# https://github.com/protocolbuffers/protobuf/blob/v21.12/protobuf_deps.bzl#L71
RULES_PKG_PV="0.7.0"								# https://github.com/protocolbuffers/protobuf/blob/v21.12/protobuf_deps.bzl#L103
RULES_PROTO_COMMIT="f7a30f6f80006b591fa7c437fe5a951eb10bcbcf"			# https://github.com/protocolbuffers/protobuf/blob/v21.12/protobuf_deps.bzl#L79
RULES_PYTHON_PV="0.8.0"								# https://github.com/protocolbuffers/protobuf/blob/v21.12/protobuf_deps.bzl#L87
SNAPPY_PV="1.1.8"								# https://github.com/google/array_record/blob/v0.5.0/WORKSPACE#L115
TENSORFLOW_PV="2.12.1"								# https://github.com/google/array_record/blob/v0.5.0/WORKSPACE#L144
ZLIB_PV="1.2.11"								# https://github.com/google/array_record/blob/v0.5.0/WORKSPACE#L129
ZSTD_PV="1.4.5"									# https://github.com/google/array_record/blob/v0.5.0/WORKSPACE#L101
ZULU_VER="11.50.19-ca-jdk11.0.12"						# https://github.com/bazelbuild/bazel/blob/5.4.1/WORKSPACE.bzlmod#L79

inherit bazel distutils-r1 flag-o-matic pypi

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_PN}-${PV}"
	EGIT_REPO_URI="https://github.com/google/array_record.git"
	FALLBACK_COMMIT="b1403b579135671a364278bcefa2b36f3ba31fbf" # Oct 20, 2023
	inherit git-r3
else
bazel_external_uris="
https://github.com/abseil/abseil-cpp/archive/refs/tags/${ABSEIL_CPP_PV}.tar.gz -> abseil-cpp-${ABSEIL_CPP_PV}.tar.gz
https://github.com/abseil/abseil-py/archive/${ABSEIL_PY_COMMIT}.zip -> abseil-py-${ABSEIL_PY_COMMIT}.zip
https://github.com/bazelbuild/bazel-skylib/releases/download/${BAZEL_SKYLIB_PV}/bazel-skylib-${BAZEL_SKYLIB_PV}.tar.gz -> bazel-skyline-${BAZEL_SKYLIB_PV}.tar.gz
https://github.com/bazelbuild/java_tools/releases/download/java_v${JAVA_TOOLS_PV}/java_tools-v${JAVA_TOOLS_PV}.zip -> java_tools-${JAVA_TOOLS_PV}.zip
https://github.com/bazelbuild/java_tools/releases/download/java_v${JAVA_TOOLS_PV}/java_tools_linux-v${JAVA_TOOLS_PV}.zip -> java_tools_linux-${JAVA_TOOLS_PV}.zip
https://github.com/bazelbuild/rules_cc/archive/${RULES_CC_COMMIT}.zip -> rules_cc-${RULES_CC_COMMIT}.zip
https://github.com/bazelbuild/rules_java/archive/${RULES_JAVA_COMMIT}.zip -> rules_java-${RULES_JAVA_COMMIT}.zip
https://github.com/bazelbuild/rules_pkg/releases/download/${RULES_PKG_PV}/rules_pkg-${RULES_PKG_PV}.tar.gz -> rules_pkg-${RULES_PKG_PV}.tar.gz
https://github.com/bazelbuild/rules_python/archive/refs/tags/${RULES_PYTHON_PV}.tar.gz -> rules_python-${RULES_PYTHON_PV}.tar.gz
https://github.com/bazelbuild/rules_proto/archive/${RULES_PROTO_COMMIT}.zip -> rules_proto-${RULES_PROTO_COMMIT}.zip
https://github.com/facebook/zstd/archive/v${ZSTD_PV}.zip -> zstd-${ZSTD_PV}.zip
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT}.zip -> googletest-${GOOGLETEST_COMMIT}.zip
https://github.com/google/riegeli/archive/${RIEGELI_COMMIT}.zip -> riegeli-${RIEGELI_COMMIT}.zip
https://github.com/protocolbuffers/protobuf/archive/v${PROTOBUF_PV}.tar.gz -> protobuf-${PROTOBUF_PV}.tar.gz
https://github.com/pybind/pybind11/archive/refs/tags/v${PYBIND11_PV}.zip -> pybind11-${PYBIND11_PV}.zip
https://github.com/pybind/pybind11_bazel/archive/${PYBIND11_BAZEL_COMMIT}.tar.gz -> pybind11_bazel-${PYBIND11_BAZEL_COMMIT}.tar.gz
https://github.com/tensorflow/tensorflow/archive/v${TENSORFLOW_PV}.zip -> tensorflow-${TENSORFLOW_PV}.zip
https://github.com/google/brotli/archive/${BROTLI_COMMIT}.zip -> brotli-${BROTLI_COMMIT}.zip
https://github.com/google/highwayhash/archive/${HIGHWAYHASH_COMMIT}.zip -> highwayhash-${HIGHWAYHASH_COMMIT}.zip
https://github.com/google/snappy/archive/${SNAPPY_PV}.zip -> snappy-${SNAPPY_PV}.zip
https://gitlab.com/libeigen/eigen/-/archive/${EIGEN_PV}/eigen-${EIGEN_PV}.tar.bz2 -> eigen-${EIGEN_PV}.tar.bz2
https://mirror.bazel.build/bazel_coverage_output_generator/releases/coverage_output_generator-v${COVERAGE_OUTPUT_GENERATOR_PV}.zip -> coverage_output_generator-${COVERAGE_OUTPUT_GENERATOR_PV}.zip
https://mirror.bazel.build/openjdk/azul-zulu${ZULU_VER}/zulu${ZULU_VER}-linux_x64.tar.gz -> zulu${ZULU_VER}-linux_x64.tar.gz
http://zlib.net/fossils/zlib-${ZLIB_PV}.tar.gz -> zlib-${ZLIB_PV}.tar.gz
"
	KEYWORDS="~amd64"
	SRC_URI="
	${bazel_external_uris}
https://github.com/google/array_record/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi
S="${WORKDIR}/${MY_PN}-${PV}"
PATCHES=(
	"${FILESDIR}/${MY_PN}-0.5.0-pin-versions.patch"
	"${FILESDIR}/${MY_PN}-0.5.0-abseil-py-tarball.patch"
)

DESCRIPTION="A file format that achieves a new frontier of IO efficiency"
HOMEPAGE="
	https://github.com/google/array_record
	https://pypi.org/project/array-record
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" beam"
RDEPEND+="
	$(python_gen_cond_dep '
		dev-python/absl-py[${PYTHON_USEDEP}]
		beam? (
			>=dev-db/apache-beam-2.50.0[${PYTHON_USEDEP},gcp]
			>=dev-python/google-cloud-storage-2.11.0[${PYTHON_USEDEP}]
		)
	')
	dev-python/etils[${PYTHON_SINGLE_USEDEP},epath]
	beam? (
		>=sci-ml/tensorflow-2.14.0[${PYTHON_SINGLE_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
		net-misc/rsync
	')
	>=dev-build/bazel-5.4.0:${BAZEL_SLOT}
"
DOCS=( "README.md" )

pkg_setup() {
	python-single-r1_pkg_setup
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "version='0.5.0'," "${S}/setup.py" \
			|| die "QA:  Bump version"
	else
		unpack ${A}
	fi

	mkdir -p "${WORKDIR}/bin" || die
	export PATH="${WORKDIR}/bin:${PATH}"
	ln -s "/usr/bin/bazel-${BAZEL_SLOT}" "${WORKDIR}/bin/bazel" || die
	bazel --version | grep -q "bazel ${BAZEL_SLOT}" || die "dev-build/bazel:${BAZEL_SLOT} is not installed"
	bazel_load_distfiles "${bazel_external_uris}"
}

src_prepare() {
	# Prevent sandbox error
	export PATH=$(echo "${PATH}" \
		| tr ":" "\n" \
		| sed -E -e "/ccache/d" \
		| tr "\n" ":")

	replace-flags -O0 -O1 # For protobuf and _FORTIFY_SOURCE
	bazel_setup_bazelrc
	cat "${T}/bazelrc" > "${S}/.bazelrc"

	echo "build -c opt" >> "${S}/.bazelrc"
	echo "build --cxxopt=-std=c++17" >> "${S}/.bazelrc"
	echo "build --host_cxxopt=-std=c++17" >> "${S}/.bazelrc"
	echo "build --linkopt=\"-lrt -lm\"" >> "${S}/.bazelrc"
	echo "build --experimental_repo_remote_exec" >> "${S}/.bazelrc"
	echo "build --python_path=\"${PYTHON}\"" >> "${S}/.bazelrc"
	default
	python_copy_sources
}

python_compile() {
	export JAVA_HOME=$(java-config --jre-home)
	pushd "${WORKDIR}/${P}-${EPYTHON/./_}/" >/dev/null 2>&1 || die
		ebazel build ...
		ebazel shutdown

		mkdir -p "${T}/out-${EPYTHON/./_}" || die

		pushd "${WORKDIR}/${MY_PN}-${PV}-${EPYTHON/./_}-bazel-base/execroot/array_record/" >/dev/null 2>&1 || die
			cp -L "setup.py" "${T}/out-${EPYTHON/./_}"
			cp -L "LICENSE" "${T}/out-${EPYTHON/./_}"

			rsync \
				-avm \
				-L  \
				--exclude="bazel-*/" \
				. \
				"${T}/out-${EPYTHON/./_}/array_record" \
				|| die

			rsync \
				-avm \
				-L \
				--include="*.so" \
				--include="*_pb2.py" \
				--exclude="*.runfiles" \
				--exclude="*_obj" \
				--include="*/" \
				--exclude="*" \
				bazel-out/k8-opt/bin/cpp \
				"${T}/out-${EPYTHON/./_}/array_record" \
				|| die

			rsync \
				-avm \
				-L \
				--include="*.so" \
				--include="*_pb2.py" \
				--exclude="*.runfiles" \
				--exclude="*_obj" \
				--include="*/" \
				--exclude="*" \
				bazel-out/k8-opt/bin/python \
				"${T}/out-${EPYTHON/./_}/array_record" \
				|| die
		popd >/dev/null 2>&1 || die

		pushd "${T}/out-${EPYTHON/./_}" >/dev/null 2>&1 || die
			distutils-r1_python_compile
		popd >/dev/null 2>&1 || die

		local d="${WORKDIR}/${MY_PN}-${PV}_${EPYTHON}/install"
		local wheel_path=$(realpath "${WORKDIR}/${MY_PN}-${PV}-${EPYTHON/./_}/wheel/array_record-"*".whl")
		distutils_wheel_install "${d}" \
			"${wheel_path}"

	popd >/dev/null 2>&1 || die
}


src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
