# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

BAZEL_PV="5.4.0"
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
JAVA_SLOT=11
PYTHON_COMPAT=( "python3_"{10..12} )

inherit bazel distutils-r1 java-pkg-opt-2 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/keras-team/tf-keras.git"
	FALLBACK_COMMIT="4fa8b74c860182ca6f20fa26347c4fbcac883217" # Nov 8, 2023
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/keras-team/tf-keras/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

BAZEL_SKYLIB_PV="1.3.0"
PROTOBUF_PV="3.21.9"
RULES_CC_COMMIT="818289e5613731ae410efb54218a4077fb9dbb03"
RULES_PYTHON_PV="0.8.0"
RULES_PROTO_COMMIT="f7a30f6f80006b591fa7c437fe5a951eb10bcbcf"
RULES_PKG_PV="0.7.0"
RULES_JAVA_COMMIT="981f06c3d2bd10225e85209904090eb7b5fb26bd"
ZLIB_PV="1.2.13"

bazel_external_uris="
https://github.com/bazelbuild/bazel-skylib/releases/download/${BAZEL_SKYLIB_PV}/bazel-skylib-${BAZEL_SKYLIB_PV}.tar.gz
https://github.com/protocolbuffers/protobuf/archive/v${PROTOBUF_PV}.zip -> protobuf-${PROTOBUF_PV}.zip
https://github.com/bazelbuild/rules_cc/archive/${RULES_CC_COMMIT}.zip -> rules_cc-${RULES_CC_COMMIT}.zip
https://github.com/bazelbuild/rules_python/archive/refs/tags/${RULES_PYTHON_PV}.tar.gz -> rules_python-${RULES_PYTHON_PV}.tar.gz
https://github.com/bazelbuild/rules_proto/archive/${RULES_PROTO_COMMIT}.zip -> rules_proto-${RULES_PROTO_COMMIT}.zip
https://github.com/bazelbuild/rules_pkg/releases/download/${RULES_PKG_PV}/rules_pkg-${RULES_PKG_PV}.tar.gz -> rules_pkg-${RULES_PKG_PV}.tar.gz
https://github.com/bazelbuild/rules_java/archive/${RULES_JAVA_COMMIT}.zip -> rules_java-${RULES_JAVA_COMMIT}.zip
https://zlib.net/zlib-${ZLIB_PV}.tar.gz
"
SRC_URI+="
	${bazel_external_uris}
"


DESCRIPTION="The TensorFlow-specific implementation of the Keras API"
HOMEPAGE="
	https://github.com/keras-team/tf-keras
	https://pypi.org/project/tf-keras
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
# protobuf requirement relaxed
RDEPEND+="
	$(python_gen_cond_dep '
		(
			>=dev-python/numpy-1.24.3[${PYTHON_USEDEP}]
			<dev-python/numpy-2.1.0[${PYTHON_USEDEP}]
		)
		>=dev-python/protobuf-3.20.3[${PYTHON_USEDEP}]
		dev-python/protobuf:=
		>=dev-python/black-22.3.0[${PYTHON_USEDEP}]
		>=dev-python/isort-5.10.1[${PYTHON_USEDEP}]
		>=dev-python/flake8-4.0.1[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.9.2[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/portpicker[${PYTHON_USEDEP}]
		dev-python/pydot[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		virtual/pillow[${PYTHON_USEDEP}]
	')
	=sci-ml/tensorflow-${PV%.*}*[${PYTHON_SINGLE_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "README.md" )
PATCHES+=(
	"${FILESDIR}/${PN}-2.18.0-updated-pip-excluded-files.patch"
)

pkg_setup() {
	java-pkg-opt-2_pkg_setup
	java-pkg_ensure-vm-version-eq ${JAVA_SLOT}
	javac --version || die
	python-single-r1_pkg_setup
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi

	mkdir -p "${WORKDIR}/bin" || die
	export PATH="${WORKDIR}/bin:${PATH}"
	ln -s "/usr/bin/bazel-${BAZEL_PV%.*}" "${WORKDIR}/bin/bazel" || die
	bazel --version | grep -q "bazel ${BAZEL_PV%.*}" || die "dev-build/bazel:${BAZEL_PV%.*} is not installed"
	bazel_load_distfiles "${bazel_external_uris}"
}

src_prepare() {
	bazel_setup_bazelrc
	default
	python_copy_sources
}

src_configure() {
einfo "Disabling ccache"
	export PATH=$(echo "${PATH}" \
		| tr ":" "\n" \
		| sed -E -e "/ccache/d" \
		| tr "\n" ":")
}

add_sandbox_rules() {
	local L=(
		"/usr/lib/${EPYTHON}/site-packages"
		"/usr/lib/${EPYTHON}/site-packages/__pycache__"
		"/usr/lib/${EPYTHON}/site-packages/Cython/__pycache__"
		"/usr/lib/${EPYTHON}/site-packages/Cython/Compiler/__pycache__"
	)
einfo "Adding sandbox rules"
	local path
	for path in "${L[@]}" ; do
einfo "addpredict ${path}" # Recursive
		addpredict "${path}"
	done
}

python_compile() {
	add_sandbox_rules
	export JAVA_HOME=$(java-config --jre-home)
	pushd "${WORKDIR}/${P}-${EPYTHON/./_}/tf_keras/tools/pip_package" >/dev/null 2>&1 || die
		distutils-r1_python_compile
	popd >/dev/null 2>&1 || die
	pushd "${WORKDIR}/${P}-${EPYTHON/./_}" >/dev/null 2>&1 || die
		ebazel build //tf_keras/tools/pip_package:build_pip_package
		ebazel shutdown
		local srcdir="${T}/src-${EPYTHON/./_}"
		mkdir -p "${srcdir}" || die
		pushd "${WORKDIR}/${P}-${EPYTHON/./_}" >/dev/null 2>&1 || die
			"${WORKDIR}/${P}-${EPYTHON/./_}-bazel-base/execroot/org_keras/bazel-out/k8-opt/bin/tf_keras/tools/pip_package/build_pip_package.runfiles/org_keras/tf_keras/tools/pip_package/build_pip_package" \
				--src "${srcdir}" \
				--dst "${T}/out" \
				|| die
		popd >/dev/null 2>&1 || die
	popd >/dev/null 2>&1 || die

	local d="${WORKDIR}/${PN}-${PV}_${EPYTHON}/install"
	local wheel_path=$(realpath "${T}/out/"*".whl")
	distutils_wheel_install "${d}" \
		"${wheel_path}"
}

src_install() {
	install_impl() {
		# Install is broken.
		local d="${WORKDIR}/${PN}-${PV}_${EPYTHON}/install"
		multibuild_merge_root "${d}" "${D%/}"
	}
	_distutils-r1_run_foreach_impl install_impl

	cd "${S}" || die
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD

