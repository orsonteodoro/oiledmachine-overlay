# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# For dep versions, see
# https://github.com/keras-team/keras/blob/v2.14.0/requirements.txt
# https://github.com/keras-team/keras/blob/v2.14.0/WORKSPACE
# https://github.com/keras-team/keras/blob/v2.14.0/.bazelversion

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_11" )

inherit bazel distutils-r1 protobuf-ver

# Versions and hashes are obtained by console and removing items below.
# They do not appear in the tarball.
BAZEL_PV="5.4.0"
EGIT_RULES_JAVA_COMMIT="7cf3cefd652008d0a64a419c34c13bdca6c8f178"	# https://github.com/bazelbuild/bazel/blob/5.4.1/distdir_deps.bzl#L68
RULES_CC_COMMIT="b1c40e1de81913a3c40e5948f78719c28152486d"		# https://github.com/bazelbuild/bazel/blob/5.4.1/distdir_deps.bzl#L55
bazel_external_uris="
	https://github.com/bazelbuild/rules_cc/archive/${RULES_CC_COMMIT}.zip -> rules_cc-${RULES_CC_COMMIT}.zip
	https://github.com/bazelbuild/rules_java/archive/${EGIT_RULES_JAVA_COMMIT}.zip -> bazelbuild-rules_java-${EGIT_RULES_JAVA_COMMIT}.zip
"
SRC_URI="
	${bazel_external_uris}
https://github.com/keras-team/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
"

DESCRIPTION="Deep Learning for humans"
HOMEPAGE="
https://keras.io/
https://github.com/keras-team/keras
"
LICENSE="Apache-2.0"
RESTRICT=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=" test ebuild_revision_3"
# TensorFlow needs numpy 1.x
gen_rdepend_protobuf() {
	local s
	for s in ${PROTOBUF_SLOTS[@]} ; do
		local impl
		for impl in ${PYTHON_COMPAT[@]} ; do
			echo  "
				(
					python_single_target_${impl}? (
						dev-libs/protobuf:0/${s}
						dev-python/protobuf:0/${s}[python_targets_${impl}(-)]
					)
				)
			"
		done
	done
}
RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/numpy-1.24.3[${PYTHON_USEDEP}]
			<dev-python/numpy-2[${PYTHON_USEDEP}]
		)
		>=dev-python/scipy-1.9.2[${PYTHON_USEDEP}]
		>=dev-python/six-1.16.0[${PYTHON_USEDEP}]
		>=sys-libs/zlib-1.2.13
		dev-python/absl-py[${PYTHON_USEDEP}]
		dev-python/h5py[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/pydot[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/protobuf:=
		virtual/pillow[${PYTHON_USEDEP}]
	')
	>=dev-python/keras-preprocessing-1.1.2[${PYTHON_SINGLE_USEDEP}]
	=sci-ml/tensorflow-${PV%.*}*[${PYTHON_SINGLE_USEDEP},python]
	|| (
		$(gen_rdepend_protobuf)
	)
	dev-libs/protobuf:=
"
DEPEND="
	${RDEPEND}
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	$(python_gen_cond_dep '
		>=dev-build/bazel-${BAZEL_PV}:${BAZEL_PV%.*}
		app-arch/unzip
		dev-java/java-config
		test? (
			>=dev-python/black-22.3.0[${PYTHON_USEDEP}]
			>=dev-python/flake8-4.0.1[${PYTHON_USEDEP}]
			>=dev-python/isort-5.10.1[${PYTHON_USEDEP}]
			dev-python/portpicker[${PYTHON_USEDEP}]
		)
	')
"
# Bazel tests not pytest, also want GPU access
DOCS=( "README.md" )
PATCHES=(
	"${FILESDIR}/keras-2.12.0-0001-bazel-Use-system-protobuf.patch"
)

src_unpack() {
	mkdir -p "${WORKDIR}/bin" || die
	export PATH="${WORKDIR}/bin:${PATH}"
	ln -s "/usr/bin/bazel-${BAZEL_PV%.*}" "${WORKDIR}/bin/bazel" || die
	bazel --version | grep -q "bazel ${BAZEL_PV%.*}" || die "dev-build/bazel:${BAZEL_PV%.*} is not installed"
	unpack "${P}.tar.gz"
	bazel_load_distfiles "${bazel_external_uris}"
}

src_prepare() {
	bazel_setup_bazelrc
	default
	python_copy_sources
}

python_compile() {
	export JAVA_HOME=$(java-config --jre-home)
	pushd "${WORKDIR}/${P}-${EPYTHON/./_}/keras/tools/pip_package" >/dev/null 2>&1 || die
		distutils-r1_python_compile
		ebazel build //keras/tools/pip_package:build_pip_package
		ebazel shutdown
		local srcdir="${T}/src-${EPYTHON/./_}"
		mkdir -p "${srcdir}" || die
		pushd "${WORKDIR}/${P}-${EPYTHON/./_}" >/dev/null 2>&1 || die
			"${WORKDIR}/${P}-${EPYTHON/./_}-bazel-base/execroot/org_keras/bazel-out/k8-opt/bin/keras/tools/pip_package/build_pip_package" --src "${srcdir}" || die
		popd >/dev/null 2>&1 || die
	popd >/dev/null 2>&1 || die
}

python_install() {
	pushd "${T}/src-${EPYTHON/./_}" >/dev/null 2>&1 || die
		esetup.py install
		python_optimize
	popd >/dev/null 2>&1 || die
	delete_benchmark() {
		local path=$(python_get_sitedir)
		rm -rf "${ED}/${path}/benchmarks" || die
	}
	python_foreach_impl delete_benchmark
}
