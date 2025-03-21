# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# expecttest

MY_PV="${PV/c/}+cpu"
MY_P="${PN}-${MY_PV}"

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
GOOGLETEST_COMMIT="e2239ee6043f73722e7aa812a459f54a28552929"
IDEEP_COMMIT="d64f9a991dbaf02149ef892a938b552065bccdf9"
LIBXSMM_COMMIT="54707b52939c9d04dc760ac44fc17c82a1bd4e80"
MKL_DNN_COMMIT="f5ff0a6de16c130053bec1a1aec3a9b826c66f78" # ideep dep
ONECCL_COMMIT="796b7ef54cd77bd181fc0d8881385b81222a7a36"
PYTHON_COMPAT=( "python3_"{10..12} ) # Upstream listed up to 3.7
SLEEF_COMMIT="36907bbee89c569458b5bbac028ed79e4640e859"

inherit dep-prepare distutils-r1 pypi

#KEYWORDS="~amd64" # Needs install test and slot re-evaluation
S="${WORKDIR}/${MY_P}"
SRC_URI="
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT:0:7}.tar.gz
https://github.com/intel/ideep/archive/${IDEEP_COMMIT}.tar.gz
	-> ideep-${IDEEP_COMMIT:0:7}.tar.gz
https://github.com/intel/intel-extension-for-pytorch/archive/refs/tags/v${MY_PV}.tar.gz
	-> ${MY_P}.tar.gz
https://github.com/libxsmm/libxsmm/archive/${LIBXSMM_COMMIT}.tar.gz
	-> libxsmm-${LIBXSMM_COMMIT:0:7}.tar.gz
https://github.com/oneapi-src/oneCCL/archive/${ONECCL_COMMIT}.tar.gz
	-> oneccl-${ONECCL_COMMIT:0:7}.tar.gz
https://github.com/oneapi-src/oneDNN/archive/${MKL_DNN_COMMIT}.tar.gz
	-> mkl-dnn-${MKL_DNN_COMMIT:0:7}.tar.gz
https://github.com/shibatch/sleef/archive/${SLEEF_COMMIT}.tar.gz
	-> sleef-${SLEEF_COMMIT:0:7}.tar.gz
"

DESCRIPTION="A Python package for extending the official PyTorch that can \
easily obtain performance on Intel platform"
HOMEPAGE="
	https://github.com/intel/intel-extension-for-pytorch
"
LICENSE="
	(
		custom
		Apache-2.0
	)
	Apache-2.0
	Boost-1.0
	BSD
	custom
	MIT
"
# Apache-2.0 - docs/tutorials/license.md
# Boost-1.0 - third_party/sleef/LICENSE.txt
# BSD - third_party/googletest/LICENSE
# custom Apache-2.0 - third_party/oneCCL/LICENSE
# custom ISSL-Oct-2022 - third_party/oneCCL/deps/mpi/licensing/license.txt
# MIT - third_party/ideep/LICENSE
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2)-cpu" # TODO:  recheck if we can multislot
IUSE+=" test"
RDEPEND+="
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
	')
	=sci-ml/pytorch-2.3*[${PYTHON_SINGLE_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/wheel-0.36[${PYTHON_USEDEP}]
		>=dev-python/setuptools-50.0[${PYTHON_USEDEP}]
		test? (
			dev-python/expecttest[${PYTHON_USEDEP}]
			dev-python/hypothesis[${PYTHON_USEDEP}]
		)
	')
	>=dev-build/cmake-3.13.0
	>=sys-devel/gcc-12.3.0:12
	>=llvm-core/llvm-16.0.6:16
	dev-build/ninja
"
DOCS=( "README.md" )

src_unpack() {
	unpack ${A}
	dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_COMMIT}" "${S}/third_party/googletest"
	dep_prepare_mv "${WORKDIR}/ideep-${IDEEP_COMMIT}" "${S}/third_party/ideep"
	dep_prepare_mv "${WORKDIR}/oneDNN-${MKL_DNN_COMMIT}" "${S}/third_party/ideep/mkl-dnn"
	dep_prepare_mv "${WORKDIR}/libxsmm-${LIBXSMM_COMMIT}" "${S}/third_party/libxsmm"
	dep_prepare_mv "${WORKDIR}/oneCCL-${ONECCL_COMMIT}" "${S}/third_party/oneCCL"
	dep_prepare_mv "${WORKDIR}/sleef-${SLEEF_COMMIT}" "${S}/third_party/sleef"
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
