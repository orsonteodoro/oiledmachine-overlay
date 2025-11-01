# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{11..14} )
ROCM_SKIP_GLOBALS=1

inherit cuda distutils-r1 multiprocessing rocm

KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/vision-${PV}"
SRC_URI="
https://github.com/pytorch/vision/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Datasets, transforms and models to specific to computer vision"
HOMEPAGE="
	https://github.com/pytorch/vision
	https://pypi.org/project/torchvision/
"
LICENSE="BSD"
SLOT="0"
IUSE="cuda gdown rocm scipy test"
REQUIRED_USE="
	?? (
		cuda
		rocm
	)
"
RESTRICT="
	!test? (
		test
	)
"
RDEPEND="
	$(python_gen_cond_dep '
		!=virtual/pillow-8.3*
		dev-python/numpy[${PYTHON_USEDEP}]
		gdown? (
			>=dev-python/gdown-4.7.3[${PYTHON_USEDEP}]
		)
		scipy? (
			dev-python/scipy[${PYTHON_USEDEP}]
		)
		>=virtual/pillow-5.3[${PYTHON_USEDEP}]
	')
	media-video/ffmpeg:=
	sci-ml/caffe2[cuda?,rocm?]
	=sci-ml/pytorch-2.9*[${PYTHON_SINGLE_USEDEP}]
	sci-ml/pytorch:=
"
DEPEND="
	${RDEPEND}
"
distutils_enable_tests "pytest"

src_compile()
{
	export MAX_JOBS="$(makeopts_jobs)" # Let ninja respect MAKEOPTS
	# Ensure some ext_module sources are compiled before linking
	export MAKEOPTS="-j1"
	use cuda && export NVCC_FLAGS="$(cuda_gccdir -f | tr -d \")"
	use rocm && addpredict /dev/kfd
	distutils-r1_src_compile
}

python_test() {
	use rocm && check_amdgpu
	# https://projects.gentoo.org/python/guide/test.html#importerrors-for-c-extensions
	rm -rf "torchvision" || die
	epytest
}
