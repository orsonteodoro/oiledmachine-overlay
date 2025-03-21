# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

BENCHMARK_COMMIT="2dd015dfef425c866d9a43f2c67d8b52d709acb6"
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
MY_PN="optimizer"
MY_P="${MY_PN}-${PV}"
ONNX_COMMIT="736dc0854b5222db2a337be3b4b92dcd3a6c3738"
PROTOBUF_COMMIT="21027a27c4c2ec1000859ccbcfff46d83b16e1ed"
PYBIND11_COMMIT="5b0a6fc2017fcc176545afe3e09c9f9885283242"
PYTHON_COMPAT=( "python3_"{10..11} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/onnx/optimizer.git"
	FALLBACK_COMMIT="b3a4611861734e0731bbcc2bed1f080139e4988b" # Mar 3, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_P}"
	SRC_URI="
https://github.com/onnx/optimizer/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/pybind/pybind11/archive/${PYBIND11_COMMIT}.tar.gz
	-> pybind11-${PYBIND11_COMMIT:0:7}.tar.gz
https://github.com/daquexian/onnx/archive/${ONNX_COMMIT}.tar.gz
	-> onnx-${ONNX_COMMIT:0:7}.tar.gz
https://github.com/protocolbuffers/protobuf/archive/${PROTOBUF_COMMIT}.tar.gz
	-> protobuf-${PROTOBUF_COMMIT:0:7}.tar.gz
https://github.com/google/benchmark/archive/${BENCHMARK_COMMIT}.tar.gz
	-> benchmark-${BENCHMARK_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="A C++ library for performing arbitrary optimizations on ONNX models"
HOMEPAGE="
	https://github.com/onnx/optimizer
"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
RDEPEND+="
	sci-ml/onnx[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-build/cmake-3.22
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	test? (
		>=dev-python/mypy-0.600[${PYTHON_USEDEP}]
		dev-python/pytest-runner[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "0.3.19" "${S}/VERSION_NUMBER" \
			|| die "QA:  Bump version"
	else
		unpack ${A}
		rm -rf \
			"${S}/third_party/onnx" \
			"${S}/third_party/protobuf" \
			|| die
		mv \
			"${WORKDIR}/onnx-${ONNX_COMMIT}" \
			"${S}/third_party/onnx" \
			|| die
		mv \
			"${WORKDIR}/protobuf-${PROTOBUF_COMMIT}" \
			"${S}/third_party/protobuf" \
			|| die
		rm -rf \
			"${S}/third_party/onnx/third_party/pybind11" \
			"${S}/third_party/onnx/third_party/benchmark" \
			|| die
		mv \
			"${WORKDIR}/pybind11-${PYBIND11_COMMIT}" \
			"${S}/third_party/onnx/third_party/pybind11" \
			|| die
		mv \
			"${WORKDIR}/benchmark-${BENCHMARK_COMMIT}" \
			"${S}/third_party/onnx/third_party/benchmark" \
			|| die
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
