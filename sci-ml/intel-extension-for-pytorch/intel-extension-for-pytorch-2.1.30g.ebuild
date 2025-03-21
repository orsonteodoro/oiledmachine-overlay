# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package:
# expecttest
# types-dataclasses

MY_PV="${PV/g/}+xpu"
MY_P="${PN}-${MY_PV}"

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
FMT_COMMIT="e69e5f977d458f2650bb346dadf2ad30c5320281"
GOOGLETEST_COMMIT="e2239ee6043f73722e7aa812a459f54a28552929"
IDEEP_COMMIT="ad79d0e1fa6b80db3c79a788896b9630d4e93940"
LIBXSMM_COMMIT="63cd57d36807ce029e55d9b1c99b51c9feddfe1e"
MKL_DNN_COMMIT="08fea71aff4c273e34579e86396405f95d34aa74"
ONEDNN_COMMIT="d5ddbc851aa75e36ed9f651e01185443bfa903ff"
PTI_GPU_COMMIT="c5fa0b9d2bf6f33ff376bc305b10b5b6e00d1372"
PYTHON_COMPAT=( "python3_"{10..12} ) # Upstream listed up to 3.7
SPDLOG_COMMIT="76fb40d95455f249bd70824ecfcae7a8f0930fa3"

inherit dep-prepare distutils-r1 pypi

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
https://github.com/oneapi-src/oneDNN/archive/${MKL_DNN_COMMIT}.tar.gz
	-> mkl-dnn-${MKL_DNN_COMMIT:0:7}.tar.gz
https://github.com/oneapi-src/oneDNN/archive/${ONEDNN_COMMIT}.tar.gz
	-> oneDNN-${ONEDNN_COMMIT:0:7}.tar.gz
https://github.com/intel/pti-gpu/archive/${PTI_GPU_COMMIT}.tar.gz
	-> pti-gpu-${PTI_GPU_COMMIT:0:7}.tar.gz
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
		MIT
	)
	Apache-2.0
	Boost-1.0
	BSD
	PSF-3.3.0
	MIT
"
# Boost-1.0 - ./intel-extension-for-pytorch-2.1.30-xpu/third_party/spdlog/tests/catch.license
# BSD - intel-extension-for-pytorch-2.1.30-xpu/third_party/oneDNN/tests/gtests/gtest/LICENSE
# custom MIT - intel-extension-for-pytorch-2.1.30-xpu/third_party/spdlog/include/spdlog/fmt/bundled/fmt.license.rst
# custom MIT - intel-extension-for-pytorch-2.1.30-xpu/third_party/spdlog/LICENSE
# PSF-3.3.0 - intel-extension-for-pytorch-2.1.30-xpu/third_party/fmt/doc/python-license.txt
# MIT - intel-extension-for-pytorch-2.1.30-xpu/third_party/fmt/LICENSE
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2)-gpu" # TODO:  recheck if we can multislot
IUSE+=" test"
RDEPEND+="
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pydantic[${PYTHON_USEDEP}]
	')
	=sci-ml/pytorch-2.1*[${PYTHON_SINGLE_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/wheel-0.36[${PYTHON_USEDEP}]
		>=dev-python/setuptools-50.0[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		test? (
			>=dev-python/expecttest-0.1.6[${PYTHON_USEDEP}]
			dev-python/hypothesis[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/scipy[${PYTHON_USEDEP}]
			dev-python/types-dataclasses[${PYTHON_USEDEP}]
			dev-python/typing-extensions[${PYTHON_USEDEP}]
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
	dep_prepare_mv "${WORKDIR}/fmt-${FMT_COMMIT}" "${S}/third_party/fmt"
	dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_COMMIT}" "${S}/third_party/googletest"
	dep_prepare_mv "${WORKDIR}/ideep-${IDEEP_COMMIT}" "${S}/third_party/ideep"
	dep_prepare_mv "${WORKDIR}/oneDNN-${MKL_DNN_COMMIT}" "${S}/third_party/ideep/mkl-dnn"
	dep_prepare_mv "${WORKDIR}/libxsmm-${LIBXSMM_COMMIT}" "${S}/third_party/libxsmm"
	dep_prepare_mv "${WORKDIR}/oneDNN-${ONEDNN_COMMIT}" "${S}/third_party/oneDNN"
	dep_prepare_mv "${WORKDIR}/pti-gpu-${PTI_GPU_COMMIT}" "${S}/third_party/pti-gpu"
	dep_prepare_mv "${WORKDIR}/spdlog-${SPDLOG_COMMIT}" "${S}/third_party/spdlog"
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
