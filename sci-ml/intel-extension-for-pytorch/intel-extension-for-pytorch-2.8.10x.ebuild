# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# expecttest
# types-dataclasses

MY_PV="${PV/x/}+xpu"
MY_P="${PN}-${MY_PV}"

CXX_STANDARD=17
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
FMT_COMMIT="e69e5f977d458f2650bb346dadf2ad30c5320281"
GOOGLETEST_COMMIT="b514bdc898e2951020cbdca1304b75f5950d1f59"
IDEEP_COMMIT="bd0681de27d3b3ea104e526a8c4d273537eed592"
LIBXSMM_COMMIT="54707b52939c9d04dc760ac44fc17c82a1bd4e80"
MKL_DNN_COMMIT="dfce0a11226353967a54a318d86daa588c28c668" # ideep dep
ONECCL_COMMIT="1ca90126d8167a5f94e1f38b58b483c516f7a62d"
ONEDNN_COMMIT="38d761b1c630a117078ebdd3952b97736f33fe61"
PYTHON_COMPAT=( "python3_"{10..12} ) # Upstream listed up to 3.7
SLEEF_COMMIT="36907bbee89c569458b5bbac028ed79e4640e859"
SPDLOG_COMMIT="76fb40d95455f249bd70824ecfcae7a8f0930fa3"

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX17[@]}
)

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}
)

inherit dep-prepare distutils-r1 libcxx-slot libstdcxx-slot pypi

#KEYWORDS="~amd64" # Needs install test and slot re-evaluation
S="${WORKDIR}/${MY_P}"
SRC_URI="
https://github.com/fmtlib/fmt/archive/${FMT_COMMIT}.tar.gz
	-> fmt-${FMT_COMMIT:0:7}.tar.gz
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
https://github.com/uxlfoundation/oneDNN/archive/${ONEDNN_COMMIT}.tar.gz
	-> oneDNN-${ONEDNN_COMMIT:0:7}.tar.gz
https://github.com/oneapi-src/oneDNN/archive/${MKL_DNN_COMMIT}.tar.gz
	-> mkl-dnn-${MKL_DNN_COMMIT:0:7}.tar.gz
https://github.com/shibatch/sleef/archive/${SLEEF_COMMIT}.tar.gz
	-> sleef-${SLEEF_COMMIT:0:7}.tar.gz
https://github.com/gabime/spdlog/archive/${SPDLOG_COMMIT}.tar.gz
	-> spdlog-${SPDLOG_COMMIT:0:7}.tar.gz
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
SLOT="0/$(ver_cut 1-2)-xpu" # TODO:  recheck if we can multislot
IUSE+=" dev test"
RDEPEND+="
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
	')
	=sci-ml/pytorch-${PV%.*}*[${PYTHON_SINGLE_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/wheel-0.36[${PYTHON_USEDEP}]
		>=dev-python/setuptools-50.0[${PYTHON_USEDEP}]
		dev? (
			>=dev-python/expecttest-0.3.0[${PYTHON_USEDEP}]
			>=dev-python/scipy-1.8.0[${PYTHON_USEDEP}]
			>=dev-python/setuptools-72.1.1[${PYTHON_USEDEP}]
			dev-python/hypothesis[${PYTHON_USEDEP}]
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/psutil[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pyyaml[${PYTHON_USEDEP}]
			dev-python/types-dataclasses[${PYTHON_USEDEP}]
			dev-python/typing-extensions[${PYTHON_USEDEP}]
		)
		test? (
			dev-python/expecttest[${PYTHON_USEDEP}]
			dev-python/hypothesis[${PYTHON_USEDEP}]
		)
	')
	>=dev-build/cmake-3.13.0
	dev-build/ninja
"
DOCS=( "README.md" )

pkg_setup() {
	python-single-r1_pkg_setup
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	unpack ${A}
	dep_prepare_mv "${WORKDIR}/fmt-${FMT_COMMIT}" "${S}/third_party/fmt"
	dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_COMMIT}" "${S}/third_party/googletest"
	dep_prepare_mv "${WORKDIR}/ideep-${IDEEP_COMMIT}" "${S}/third_party/ideep"
	dep_prepare_mv "${WORKDIR}/oneDNN-${MKL_DNN_COMMIT}" "${S}/third_party/ideep/mkl-dnn"
	dep_prepare_mv "${WORKDIR}/libxsmm-${LIBXSMM_COMMIT}" "${S}/third_party/libxsmm"
	dep_prepare_mv "${WORKDIR}/oneCCL-${ONECCL_COMMIT}" "${S}/third_party/oneCCL"
	dep_prepare_mv "${WORKDIR}/oneDNN-${ONEDNN_COMMIT}" "${S}/third_party/oneDNN"
	dep_prepare_mv "${WORKDIR}/sleef-${SLEEF_COMMIT}" "${S}/third_party/sleef"
	dep_prepare_mv "${WORKDIR}/spdlog-${SPDLOG_COMMIT}" "${S}/third_party/spdlog"
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
