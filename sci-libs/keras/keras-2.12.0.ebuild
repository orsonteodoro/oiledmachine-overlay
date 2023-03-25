# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit bazel distutils-r1

DESCRIPTION="Deep Learning for humans"
HOMEPAGE="
https://keras.io/
https://github.com/keras-team/keras
"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=" test"

# Versions and hashes are obtained by console and removing items below.
# They do not appear in the tarball.
bazel_external_uris="
	https://github.com/bazelbuild/rules_cc/archive/refs/tags/0.0.2.tar.gz -> bazelbuild-rules_cc-0.0.2.tar.gz
	https://github.com/bazelbuild/rules_java/archive/7cf3cefd652008d0a64a419c34c13bdca6c8f178.zip -> bazelbuild-rules_java-7cf3cefd652008d0a64a419c34c13bdca6c8f178.zip
"
SRC_URI="
	${bazel_external_uris}
https://github.com/keras-team/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
"
# https://github.com/keras-team/keras/blob/v2.12.0/requirements.txt
# https://github.com/keras-team/keras/blob/v2.12.0/WORKSPACE
PROTOBUF_PV="3.21.9"
# TODO: Fix sci-libs/keras-applications, sci-libs/keras-preprocessing
# These have moved in this package.
#	>=sci-libs/keras-applications-1.0.8[${PYTHON_USEDEP}]
#	>=sci-libs/keras-preprocessing-1.1.2[${PYTHON_USEDEP}]
RDEPEND="
	$(python_gen_cond_dep '>=dev-python/numpy-1.22[${PYTHON_USEDEP}]' python3_{9..10})
	$(python_gen_cond_dep '>=dev-python/numpy-1.23[${PYTHON_USEDEP}]' python3_11)
	(
		<sci-libs/tensorflow-2.12[${PYTHON_USEDEP},python]
		>=sci-libs/tensorflow-2.11[${PYTHON_USEDEP},python]
	)
	>=dev-libs/protobuf-${PROTOBUF_PV}:=
	>=dev-python/protobuf-python-${PROTOBUF_PV}[${PYTHON_USEDEP}]
	>=dev-python/six-1.16.0[${PYTHON_USEDEP}]
	>=sys-libs/zlib-1.2.13
	dev-python/absl-py[${PYTHON_USEDEP}]
	dev-python/h5py[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-libs/protobuf-${PROTOBUF_PV}
	>=dev-util/bazel-4.2.2
	app-arch/unzip
	dev-java/java-config
"
# Bazel tests not pytest, also want GPU access
RESTRICT=""
DOCS=( CONTRIBUTING.md README.md )
PATCHES=(
	"${FILESDIR}/keras-2.12.0-0001-bazel-Use-system-protobuf.patch"
)

src_unpack() {
	unpack "${P}.tar.gz"
	bazel_load_distfiles "${bazel_external_uris}"
}

src_prepare() {
	bazel_setup_bazelrc
	default
	python_copy_sources
}

python_compile() {
	pushd "${BUILD_DIR}" >/dev/null || die
		ebazel build //keras/tools/pip_package:build_pip_package
		ebazel shutdown
		local srcdir="${T}/src-${EPYTHON/./_}"
		mkdir -p "${srcdir}" || die
		bazel-bin/keras/tools/pip_package/build_pip_package --src "${srcdir}" || die
	popd || die
}

src_compile() {
	export JAVA_HOME=$(java-config --jre-home)
	distutils-r1_src_compile
}

python_install() {
	pushd "${T}/src-${EPYTHON/./_}" >/dev/null || die
		esetup.py install
		python_optimize
	popd || die
}
