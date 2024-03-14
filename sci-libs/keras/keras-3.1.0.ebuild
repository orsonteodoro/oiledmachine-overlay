# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
TENSORFLOW_PV="2.16.1"

inherit distutils-r1

SRC_URI="
https://github.com/keras-team/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
"

DESCRIPTION="Deep Learning for humans"
HOMEPAGE="
https://keras.io/
https://github.com/keras-team/keras
"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=" cpu cuda jax pytorch tensorflow test r2"
REQUIRED_USE="
	cpu? (
		jax
		pytorch
		tensorflow
	)
"
# https://github.com/keras-team/keras/blob/v3.1.0/requirements.txt
# https://github.com/keras-team/keras/blob/v3.1.0/WORKSPACE
PROTOBUF_PV="3.21.9" # From WORKSPACE which differs from requirements.txt
PROTOBUF_SLOT="0/${PROTOBUF_PV%.*}"
# TODO: Fix sci-libs/keras-applications, sci-libs/keras-preprocessing
# These have moved in this package.
#	>=sci-libs/keras-applications-1.0.8[${PYTHON_USEDEP}]
#	>=sci-libs/keras-preprocessing-1.1.2[${PYTHON_USEDEP}]
# TODO: package
# namex
# portpicker
# tensorboard-plugin-profile
RDEPEND="
	$(python_gen_cond_dep '
		(
			>=dev-python/numpy-1.23.5[${PYTHON_USEDEP}]
			<dev-python/numpy-2[${PYTHON_USEDEP}]
		)
	' python3_{10,11})
	$(python_gen_cond_dep '
		(
			>=dev-python/numpy-1.26.0[${PYTHON_USEDEP}]
			<dev-python/numpy-2[${PYTHON_USEDEP}]
		)
	' python3_12)
	>=sci-libs/tensorflow-${TENSORFLOW_PV}[${PYTHON_USEDEP},python]
	>=dev-python/six-1.16.0[${PYTHON_USEDEP}]
	>=sys-libs/zlib-1.2.13
	dev-libs/protobuf:${PROTOBUF_SLOT}
	dev-python/absl-py[${PYTHON_USEDEP}]
	dev-python/h5py[${PYTHON_USEDEP}]
	dev-python/ml-dtypes[${PYTHON_USEDEP}]
	dev-python/namex[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/protobuf-python:${PROTOBUF_SLOT}[${PYTHON_USEDEP}]
	dev-python/pydot[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
BDEPEND="
	app-arch/unzip
	dev-java/java-config
	dev-libs/protobuf:${PROTOBUF_SLOT}
	dev-python/dm-tree[${PYTHON_USEDEP}]
	dev-python/build[${PYTHON_USEDEP}]
	test? (
		>=dev-python/black-22[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/isort[${PYTHON_USEDEP}]
		dev-python/portpicker[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
	)
"
# Possible circular depends:
PDEPEND="
	cpu? (
		jax? (
			dev-python/jax[${PYTHON_USEDEP}]
		)
		pytorch? (
			$(python_gen_any_dep '
				>=sci-libs/torchvision-0.16.0[${PYTHON_SINGLE_USEDEP}]
			')
			>=sci-libs/pytorch-2.1.0[${PYTHON_USEDEP}]
		)
		tensorflow? (
			>=sci-libs/tensorflow-${TENSORFLOW_PV}
		)
	)
	cuda? (
		jax? (
			>=dev-python/jax-0.4.23[${PYTHON_USEDEP},cuda]
			test? (
				$(python_gen_any_dep '
					>=sci-libs/torchvision-0.16.0[${PYTHON_SINGLE_USEDEP}]
				')
				>=sci-libs/pytorch-2.1.0[${PYTHON_USEDEP}]
				>=sci-libs/tensorflow-${TENSORFLOW_PV}
			)
		)
		tensorflow? (
			>=sci-libs/tensorflow-${TENSORFLOW_PV}[cuda]
			test? (
				$(python_gen_any_dep '
					>=sci-libs/torchvision-0.16.0[${PYTHON_SINGLE_USEDEP}]
				')
				>=sci-libs/pytorch-2.1.0[${PYTHON_USEDEP}]
				dev-python/jax[${PYTHON_USEDEP}]
			)
		)
		pytorch? (
			$(python_gen_any_dep '
				>=sci-libs/torchvision-0.17.1[${PYTHON_SINGLE_USEDEP},cuda?]
			')
			>=sci-libs/pytorch-2.2.1[${PYTHON_USEDEP},cuda]
			test? (
				>=sci-libs/tensorflow-${TENSORFLOW_PV}
				dev-python/jax[${PYTHON_USEDEP}]
			)
		)
	)
"
# Bazel tests not pytest, also want GPU access
RESTRICT=""
DOCS=( CONTRIBUTING.md README.md )
PATCHES=(
)

src_unpack() {
	unpack "${P}.tar.gz"
}

src_prepare() {
	default
	python_copy_sources
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
