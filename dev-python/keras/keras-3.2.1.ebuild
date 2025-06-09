# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# For dep versions, see
# https://github.com/keras-team/keras/blob/v3.1.0/requirements.txt
# https://github.com/keras-team/keras/blob/v3.1.0/WORKSPACE

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_11" )
TENSORFLOW_PV="2.16.1"

inherit distutils-r1 protobuf-ver

SRC_URI="
https://github.com/keras-team/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
"

DESCRIPTION="Deep Learning for humans"
HOMEPAGE="
https://keras.io/
https://github.com/keras-team/keras
"
LICENSE="Apache-2.0"
# Bazel tests, not pytest, want GPU access
RESTRICT=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=" cpu cuda jax pytorch tensorflow test ebuild_revision_3"
REQUIRED_USE="
	cpu? (
		jax
		pytorch
		tensorflow
	)
"
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
	$(python_gen_cond_dep '
		>=dev-python/six-1.16.0[${PYTHON_USEDEP}]
		>=sys-libs/zlib-1.2.13
		dev-python/absl-py[${PYTHON_USEDEP}]
		dev-python/h5py[${PYTHON_USEDEP}]
		dev-python/namex[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/pydot[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/rich[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/ml-dtypes[${PYTHON_USEDEP}]
		virtual/pillow[${PYTHON_USEDEP}]
	')
	>=sci-ml/tensorflow-${TENSORFLOW_PV}[${PYTHON_SINGLE_USEDEP},python]
	dev-python/optree[${PYTHON_SINGLE_USEDEP},jax?,pytorch?]
	sci-visualization/tensorboard-plugin-profile[${PYTHON_SINGLE_USEDEP}]
	|| (
		$(gen_rdepend_protobuf)
	)
	dev-libs/protobuf:=
	dev-python/protobuf:=
"
DEPEND="
	${RDEPEND}
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	$(python_gen_cond_dep '
		app-arch/unzip
		dev-java/java-config
		dev-python/build[${PYTHON_USEDEP}]
		test? (
			>=dev-python/black-22[${PYTHON_USEDEP}]
			dev-python/flake8[${PYTHON_USEDEP}]
			dev-python/isort[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pytest-cov[${PYTHON_USEDEP}]
		)
	')
"
# Possible circular depends:
# Upstream uses jax-0.4.23 for cuda but we corrected for >=jax-0.4.26 for cuda12
# =dev-util/nvidia-cuda-toolkit-12* required for some USE flags.
# temp removed cuda from cuda? ( pytorch? (...) ) due to lack of >=cuda-12.3 support-release in project
PDEPEND="
	cpu? (
		jax? (
			dev-python/jax[${PYTHON_SINGLE_USEDEP}]
		)
		pytorch? (
			>=sci-ml/pytorch-2.1.0[${PYTHON_SINGLE_USEDEP}]
			>=sci-ml/torchvision-0.16.0[${PYTHON_SINGLE_USEDEP}]
		)
		tensorflow? (
			>=sci-ml/tensorflow-${TENSORFLOW_PV}[${PYTHON_SINGLE_USEDEP},python]
		)
	)
	cuda? (
		jax? (
			>=dev-python/jax-0.4.26[${PYTHON_SINGLE_USEDEP},cuda]
			test? (
				dev-python/flax[${PYTHON_SINGLE_USEDEP}]
				>=sci-ml/pytorch-2.1.0[${PYTHON_SINGLE_USEDEP}]
				>=sci-ml/tensorflow-${TENSORFLOW_PV}[${PYTHON_SINGLE_USEDEP},python]
				>=sci-ml/torchvision-0.16.0[${PYTHON_SINGLE_USEDEP}]
			)
		)
		tensorflow? (
			>=sci-ml/tensorflow-${TENSORFLOW_PV}[${PYTHON_SINGLE_USEDEP},cuda,python]
			test? (
				>=sci-ml/pytorch-2.1.0[${PYTHON_SINGLE_USEDEP}]
				>=sci-ml/torchvision-0.16.0[${PYTHON_SINGLE_USEDEP}]
				dev-python/jax[${PYTHON_SINGLE_USEDEP},cpu]
			)
		)
		pytorch? (
			>=sci-ml/pytorch-2.2.1[${PYTHON_SINGLE_USEDEP}]
			>=sci-ml/torchvision-0.17.1[${PYTHON_SINGLE_USEDEP}]
			test? (
				>=sci-ml/tensorflow-${TENSORFLOW_PV}[${PYTHON_SINGLE_USEDEP},python]
				dev-python/jax[${PYTHON_SINGLE_USEDEP},cpu]
			)
		)
	)
"
DOCS=( "README.md" )
PATCHES=(
)

src_unpack() {
	unpack "${P}.tar.gz"
}

src_prepare() {
	default
	python_copy_sources
}

python_compile() {
	export JAVA_HOME=$(java-config --jre-home)
	distutils-r1_python_compile
}

python_install() {
	pushd "${WORKDIR}/${P}-${EPYTHON/./_}" >/dev/null 2>&1 || die
		esetup.py install
		python_optimize
	popd >/dev/null 2>&1 || die
	delete_benchmark() {
		local path=$(python_get_sitedir)
		rm -rf "${ED}/${path}/benchmarks" || die
	}
	python_foreach_impl delete_benchmark
}
