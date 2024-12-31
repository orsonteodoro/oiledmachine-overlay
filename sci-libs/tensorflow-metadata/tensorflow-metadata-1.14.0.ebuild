# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="metadata"
MY_P="${MY_PN}-${PV}"

BAZEL_SKYLIB_PV="1.0.2"							# https://github.com/tensorflow/metadata/blob/v1.14.0/WORKSPACE#L9
BAZEL_SLOT="5.3"							# https://github.com/tensorflow/metadata/blob/v1.14.0/WORKSPACE#L52
DISTUTILS_USE_PEP517="setuptools"
PROTOBUF_PV="3.21.9"							# https://github.com/tensorflow/metadata/blob/v1.14.0/WORKSPACE#L14
PYTHON_COMPAT=( "python3_"{10..12} ) # 3.9 listed only
RULES_CC_COMMIT="818289e5613731ae410efb54218a4077fb9dbb03"		# https://github.com/protocolbuffers/protobuf/blob/v3.21.9/protobuf_deps.bzl#L63
RULES_JAVA_COMMIT="981f06c3d2bd10225e85209904090eb7b5fb26bd"		# https://github.com/protocolbuffers/protobuf/blob/v3.21.9/protobuf_deps.bzl#L71
RULES_PKG_PV="0.7.0"							# https://github.com/protocolbuffers/protobuf/blob/v3.21.9/protobuf_deps.bzl#L103
RULES_PROTO_COMMIT="f7a30f6f80006b591fa7c437fe5a951eb10bcbcf"		# https://github.com/protocolbuffers/protobuf/blob/v3.21.9/protobuf_deps.bzl#L79
RULES_PYTHON_PV="0.8.0"							# https://github.com/protocolbuffers/protobuf/blob/v3.21.9/protobuf_deps.bzl#L88
ZLIB_PV="1.2.12"							# https://github.com/tensorflow/metadata/blob/v1.14.0/WORKSPACE#L31

inherit bazel distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+=" fallback-commit"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}-${PV}"
	EGIT_REPO_URI="https://github.com/tensorflow/metadata.git"
	FALLBACK_COMMIT="7073f7452d6cecbb5279781451f7c3144c924367" # Aug 9, 2023
	inherit git-r3
else
	KEYWORDS="~amd64"
bazel_external_uris="
https://storage.googleapis.com/mirror.tensorflow.org/github.com/protocolbuffers/protobuf/archive/v${PROTOBUF_PV}.zip -> protobuf-${PROTOBUF_PV}.zip
https://github.com/bazelbuild/bazel-skylib/releases/download/${BAZEL_SKYLIB_PV}/bazel-skylib-${BAZEL_SKYLIB_PV}.tar.gz -> bazel-skylib-${BAZEL_SKYLIB_PV}.tar.gz
https://github.com/bazelbuild/rules_proto/archive/${RULES_PROTO_COMMIT}.zip -> rules_proto-${RULES_PROTO_COMMIT}.zip
https://github.com/bazelbuild/rules_cc/archive/${RULES_CC_COMMIT}.zip -> rules-cc-${RULES_CC_COMMIT}.zip
https://github.com/bazelbuild/rules_python/archive/refs/tags/${RULES_PYTHON_PV}.tar.gz -> rules_python-${RULES_PYTHON_PV}.tar.gz
https://github.com/bazelbuild/rules_pkg/releases/download/${RULES_PKG_PV}/rules_pkg-${RULES_PKG_PV}.tar.gz -> rules_pkg-${RULES_PKG_PV}.tar.gz
https://github.com/bazelbuild/rules_java/archive/${RULES_JAVA_COMMIT}.zip -> rules_java-${RULES_JAVA_COMMIT}.zip
https://github.com/madler/zlib/archive/v${ZLIB_PV}.tar.gz -> zlib-${ZLIB_PV}.tar.gz
"
	SRC_URI="
	${bazel_external_uris}
https://github.com/tensorflow/metadata/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="Utilities for passing TensorFlow related metadata between tools"
HOMEPAGE="
	https://github.com/tensorflow/metadata
	https://pypi.org/project/tensorflow-metadata
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	(
		>=dev-python/absl-py-0.9[${PYTHON_USEDEP}]
		<dev-python/absl-py-2.0.0[${PYTHON_USEDEP}]
	)
	(
		>=dev-python/googleapis-common-protos-1.52.0[${PYTHON_USEDEP}]
		<dev-python/googleapis-common-protos-2[${PYTHON_USEDEP}]
	)
	>=dev-python/protobuf-3.20.3:0/3.21[${PYTHON_USEDEP}]
	>=dev-build/bazel-5.3.0:${BAZEL_SLOT}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
DOCS=( "README.md" "RELEASE.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "__version__ = '1.14.0'" "${S}/tensorflow_metadata/version.py" \
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
	pushd "${WORKDIR}/${MY_P}-${EPYTHON/./_}/" >/dev/null 2>&1 || die
		distutils-r1_python_compile
	popd >/dev/null 2>&1 || die
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
