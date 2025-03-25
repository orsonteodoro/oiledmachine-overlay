# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

BAZEL_SKYLIB_PV="1.2.1"							# https://github.com/tensorflow/hub/blob/v0.16.1/WORKSPACE#L66
BAZEL_SLOT="6.1"							# Undocumented version
DISTUTILS_USE_PEP517="setuptools"
PROTOBUF_PV="3.19.6"							# https://github.com/tensorflow/hub/blob/v0.16.1/WORKSPACE#L36
PYTHON_COMPAT=( "python3_10" )
RULES_CC_PV="0.0.2"							# https://github.com/bazelbuild/bazel/blob/6.1.2/distdir_deps.bzl#L57
RULES_JAVA_COMMIT="7cf3cefd652008d0a64a419c34c13bdca6c8f178"		# https://github.com/bazelbuild/bazel/blob/6.1.2/distdir_deps.bzl#L69
RULES_LICENSE_PV="0.0.4"						# https://github.com/tensorflow/hub/blob/v0.16.1/WORKSPACE#L58
RULES_PROTO_COMMIT="7e4afce6fe62dbff0a4a03450143146f9f2d7488"		# https://github.com/bazelbuild/buildtools/blob/v6.1.2/WORKSPACE
RULES_PYTHON_COMMIT="70cce26432187a60b4e950118791385e6fb3c26f"		# https://github.com/tensorflow/hub/blob/v0.16.1/WORKSPACE#L24
TENSORFLOW_PV="1.15.0"							# https://github.com/tensorflow/hub/blob/v0.16.1/tensorflow_hub/__init__.py#L73
ZLIB_PV="1.2.13"							# https://github.com/tensorflow/hub/blob/v0.16.1/WORKSPACE#L49

inherit bazel distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/tensorflow/hub.git"
	FALLBACK_COMMIT="ff72e25fef44bd67d5c14fb5328aa44e303e3404" # Jan 29, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/hub-${PV}"
bazel_external_uris="
https://github.com/bazelbuild/rules_license/releases/download/${RULES_LICENSE_PV}/rules_license-${RULES_LICENSE_PV}.tar.gz
https://github.com/bazelbuild/rules_python/archive/${RULES_PYTHON_COMMIT}.zip -> rules_python-${RULES_PYTHON_COMMIT}.zip
https://mirror.tensorflow.org/github.com/protocolbuffers/protobuf/archive/v${PROTOBUF_PV}.tar.gz -> protobuf-${PROTOBUF_PV}.tar.gz
https://github.com/bazelbuild/rules_cc/releases/download/${RULES_CC_PV}/rules_cc-${RULES_CC_PV}.tar.gz
https://github.com/bazelbuild/rules_proto/archive/${RULES_PROTO_COMMIT}.tar.gz -> rules_proto-${RULES_PROTO_COMMIT}.tar.gz
https://github.com/bazelbuild/bazel-skylib/releases/download/${BAZEL_SKYLIB_PV}/bazel-skylib-${BAZEL_SKYLIB_PV}.tar.gz
https://github.com/bazelbuild/rules_java/archive/${RULES_JAVA_COMMIT}.zip -> rules_java-${RULES_JAVA_COMMIT}.zip
https://github.com/bazelbuild/rules_java/releases/download/5.5.1/rules_java-5.5.1.tar.gz
https://zlib.net/zlib-${ZLIB_PV}.tar.gz
"
	SRC_URI="
	${bazel_external_uris}
https://github.com/tensorflow/hub/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Clean up the public namespace of your package!"
HOMEPAGE="
	https://github.com/tensorflow/hub
	https://pypi.org/project/tensorflow-hub
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
RDEPEND+="
	>=dev-python/numpy-1.12.0[${PYTHON_USEDEP}]
	>=dev-python/protobuf-3.19.6[${PYTHON_USEDEP}]
	dev-libs/protobuf:=
	>=sci-libs/tf-keras-2.14.1[${PYTHON_USEDEP}]
	>=sci-ml/tensorflow-${TENSORFLOW_PV}
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/protobuf-3.19.6[${PYTHON_USEDEP}]
	dev-libs/protobuf:=
	dev-build/bazel:${BAZEL_SLOT}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "__version__ = \"0.16.1\"" "${S}/tensorflow_hub/version.py" \
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
	bazel_setup_bazelrc
	cat "${T}/bazelrc" > "${S}/.bazelrc"
	default
	python_copy_sources
}

python_compile() {
	export JAVA_HOME=$(java-config --jre-home)
	pushd "${WORKDIR}/hub-${PV}-${EPYTHON/./_}/" >/dev/null 2>&1 || die
		bazel clean
		bazel build //tensorflow_hub/pip_package:build_pip_package || die
		bazel shutdown || die

	# Build script broken \
#		local protoc_path=$(find "${HOME}" -path "*/bin/external/com_google_protobuf/protoc")
		local protoc_path=$(which protoc)
		"${protoc_path}" -I=tensorflow_hub --python_out=tensorflow_hub "tensorflow_hub/"*".proto" || die
		ls -1 "tensorflow_hub/"*"_pb2.py" || die

		mkdir -p "${T}/out-${EPYTHON/./_}" || die

		cp -L "tensorflow_hub/pip_package/setup.py" "${T}/out-${EPYTHON/./_}" || die
		cp -L "tensorflow_hub/pip_package/setup.cfg" "${T}/out-${EPYTHON/./_}" || die
		cp -L "tensorflow_hub/LICENSE" "${T}/out-${EPYTHON/./_}/LICENSE.txt" || die
		cp -R "tensorflow_hub" "${T}/out-${EPYTHON/./_}" || die

		pushd "${T}/out-${EPYTHON/./_}/" >/dev/null 2>&1 || die
			distutils-r1_python_compile
		popd >/dev/null 2>&1 || die
	popd >/dev/null 2>&1 || die
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "tensorflow_hub/LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
