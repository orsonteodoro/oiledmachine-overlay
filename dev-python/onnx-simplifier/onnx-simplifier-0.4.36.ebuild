# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

BENCHMARK_COMMIT_1="5b7683f49e1e9223cf9927b24f6fd3d6bd82e3f8" # protobuf dep
BENCHMARK_COMMIT_2="2dd015dfef425c866d9a43f2c67d8b52d709acb6" # onnx dep
BENCHMARK_COMMIT_3="7d0d9061d83b663ce05d9de5da3d5865a3845b79" # onnxruntime dep
BENCHMARK_COMMIT_4="e776aa0275e293707b6a0901e0e8d8a8a3679508" # onnx dep
BENCHMARK_COMMIT_5="0d98dba29d66e93259db7daa53a9327df767a415" # onnx
CUB_COMMIT="c3cceac115c072fb63df1836ff46d8c60d9eb304" # onnxruntime dep
CXXOPTS_COMMIT="3c73d91c0b04e2b59462f0a741be8c07024c1bc0" # onnxruntime dep
DATE_COMMIT="e7e1482087f58913b80a20b04d5c58d9d6d90155" # onnxruntime dep
DISTUTILS_EXT=1
DLPACK_COMMIT="277508879878e0a5b5b43599b1bea11f66eb3c6c" # onnxruntime dep
EIGEN_COMMIT="d10b27fe37736d2944630ecd7557cefa95cf87c9" # onnxruntime dep
FLATBUFFERS_COMMIT="6df40a2471737b27271bdd9b900ab5f3aec746c7" # onnxruntime dep
GOOGLETEST_COMMIT_1="5ec7f0c4a113e2f18ac2c6cc7df51ad6afc24081" # protobuf dep
GOOGLETEST_COMMIT_2="53495a2a7d6ba7e0691a7f3602e9a5324bba6e45" # onnxruntime dep
DISTUTILS_USE_PEP517="setuptools"
EMSDK_COMMIT="fc645b7626ebf86530dbd82fbece74d457e7ae07" # onnxruntime dep
LIBPROTOBUF_MUTATOR_COMMIT="7a2ed51a6b682a83e345ff49fc4cfd7ca47550db" # onnxoptimizer dep
MIMALLOC_COMMIT="f412df7a2b64421e1f1d61fde6055a6ea288e8f5" # onnxruntime dep
MP11_COMMIT="21cace4e574180ba64d9307a5e4ea9e5e94d3e8d" # onnxruntime dep
NLOHMANN_JSON_COMMIT="db78ac1d7716f56fc9f1b030b715f872f93964e4" # onnxruntime dep
NSYNC_COMMIT="436617053d0f39a1019a371c3a9aa599b3cb2cea" # onnxruntime dep
ONNX_COMMIT_1="736dc0854b5222db2a337be3b4b92dcd3a6c3738" # onnxoptimizer dep
ONNX_COMMIT_2="994c6181247d7b419b28889fc57d5817e2089419" # onnx-tensorrt dep
ONNX_COMMIT_3="6475c2f9b7a7112aa5bd65734223e6db556ccb11" # onnxruntime dep
ONNX_TENSORRT="f42daeee49f2517a954c5601f0f76bef9ed94b62" # onnxruntime dep
ONNXOPTIMIZER_COMMIT="b3a4611861734e0731bbcc2bed1f080139e4988b" # onnx-simplifier dep
ONNXRUNTIME_COMMIT="c93d0ae7ec1cd4a8c3f6f2184cd213e0d9f7ea04" # onnx-simplifier dep
ONNXRUNTIME_EXTENSIONS_COMMIT="d4b2aff0c890ae38bad87c20f5731333db2a2cc1" # onnxruntime dep
PROTOBUF_COMMIT_1="21027a27c4c2ec1000859ccbcfff46d83b16e1ed" # onnxoptimizer dep
PROTOBUF_COMMIT_2="0dab03ba7bc438d7ba3eac2b2c1eb39ed520f928" # onnxruntime dep
PYBIND11_COMMIT_1="914c06fb252b6cc3727d0eedab6736e88a3fcb01" # onnx-simplifier dep
PYBIND11_COMMIT_2="5b0a6fc2017fcc176545afe3e09c9f9885283242" # onnx dep
PYBIND11_COMMIT_3="59a2ac2745d8a57ac94c6accced73620d59fb844" # onnx dep
PYBIND11_COMMIT_4="ffa346860b306c9bbfb341aed9c14c067751feb8" # onnx dep
PYTHON_COMPAT=( "python3_"{10..11} )
PYTORCH_CPUINFO="5916273f79a21551890fd3d56fc5375a78d1598d" # onnxruntime dep
RE2_COMMIT="4244cd1cb492fa1d10986ec67f862964c073f844" # onnx dep
TENSORBOARD_COMMIT="373eb09e4c5d2b3cc2493f0949dc4be6b6a45e81" # onnxruntime dep
WIL_COMMIT="e8c599bca6c56c44b6730ad93f6abbc9ecd60fc1" # onnxruntime dep


inherit distutils-r1 dep-prepare pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/daquexian/onnx-simplifier.git"
	FALLBACK_COMMIT="fbf1ca8e26ba29200f6572194391b148c0695254" # Mar 3, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/daquexian/onnx-simplifier/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/daquexian/onnx/archive/${ONNX_COMMIT_1}.tar.gz
	-> onnx-${ONNX_COMMIT_1:0:7}.tar.gz
https://github.com/daquexian/onnx/archive/${ONNX_COMMIT_2}.tar.gz
	-> onnx-${ONNX_COMMIT_2:0:7}.tar.gz
https://github.com/daquexian/onnx/archive/${ONNX_COMMIT_3}.tar.gz
	-> onnx-${ONNX_COMMIT_3:0:7}.tar.gz
https://github.com/emscripten-core/emsdk/archive/${EMSDK_COMMIT}.tar.gz
	-> emsdk-${EMSDK_COMMIT:0:7}.tar.gz
https://github.com/google/benchmark/archive/${BENCHMARK_COMMIT_1}.tar.gz
	-> benchmark-${BENCHMARK_COMMIT_1:0:7}.tar.gz
https://github.com/google/benchmark/archive/${BENCHMARK_COMMIT_2}.tar.gz
	-> benchmark-${BENCHMARK_COMMIT_2:0:7}.tar.gz
https://github.com/google/benchmark/archive/${BENCHMARK_COMMIT_3}.tar.gz
	-> benchmark-${BENCHMARK_COMMIT_3:0:7}.tar.gz
https://github.com/google/benchmark/archive/${BENCHMARK_COMMIT_4}.tar.gz
	-> benchmark-${BENCHMARK_COMMIT_4:0:7}.tar.gz
https://github.com/google/benchmark/archive/${BENCHMARK_COMMIT_5}.tar.gz
	-> benchmark-${BENCHMARK_COMMIT_5:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_1}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_1:0:7}.tar.gz
https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT_2}.tar.gz
	-> googletest-${GOOGLETEST_COMMIT_2:0:7}.tar.gz
https://github.com/jarro2783/cxxopts/archive/${CXXOPTS_COMMIT}.tar.gz
	-> cxxopts-${CXXOPTS_COMMIT:0:7}.tar.gz
https://github.com/microsoft/mimalloc/archive/${MIMALLOC_COMMIT}.tar.gz
	-> mimalloc-${MIMALLOC_COMMIT:0:7}.tar.gz
https://github.com/boostorg/mp11/archive/${MP11_COMMIT}.tar.gz
	-> mp11-${MP11_COMMIT:0:7}.tar.gz
https://github.com/dmlc/dlpack/archive/${DLPACK_COMMIT}.tar.gz
	-> dlpack-${DLPACK_COMMIT:0:7}.tar.gz
https://github.com/google/flatbuffers/archive/${FLATBUFFERS_COMMIT}.tar.gz
	-> flatbuffers-${FLATBUFFERS_COMMIT:0:7}.tar.gz
https://github.com/google/nsync/archive/${NSYNC_COMMIT}.tar.gz
	-> nsync-${NSYNC_COMMIT:0:7}.tar.gz
https://github.com/google/libprotobuf-mutator/archive/${LIBPROTOBUF_MUTATOR_COMMIT}.tar.gz
	-> libprotobuf-mutator-${LIBPROTOBUF_MUTATOR_COMMIT:0:7}.tar.gz
https://github.com/google/re2/archive/${RE2_COMMIT}.tar.gz
	-> re2-${RE2_COMMIT:0:7}.tar.gz
https://github.com/HowardHinnant/date/archive/${DATE_COMMIT}.tar.gz
	-> HowardHinnant-date-${DATE_COMMIT:0:7}.tar.gz
https://gitlab.com/libeigen/eigen/-/archive/${EIGEN_COMMIT}/eigen-${EIGEN_COMMIT}.tar.gz
	-> eigen-${EIGEN_COMMIT:0:7}.tar.gz
https://github.com/microsoft/onnxruntime/archive/${ONNXRUNTIME_COMMIT}.tar.gz
	-> onnxruntime-${ONNXRUNTIME_COMMIT:0:7}.tar.gz
https://github.com/microsoft/onnxruntime-extensions/archive/${ONNXRUNTIME_EXTENSIONS_COMMIT}.tar.gz
	-> onnxruntime-extensions-${ONNXRUNTIME_EXTENSIONS_COMMIT:0:7}.tar.gz
https://github.com/microsoft/wil/archive/${WIL_COMMIT}.tar.gz
	-> wil-${WIL_COMMIT:0:7}.tar.gz
https://github.com/nlohmann/json/archive/${NLOHMANN_JSON_COMMIT}.tar.gz
	-> nlohmann-json-${NLOHMANN_JSON_COMMIT:0:7}.tar.gz
https://github.com/NVlabs/cub/archive/${CUB_COMMIT}.tar.gz
	-> cub-${CUB_COMMIT:0:7}.tar.gz
https://github.com/onnx/onnx-tensorrt/archive/${ONNX_TENSORRT}.tar.gz
	-> onnx-tensorrt-${ONNX_TENSORRT:0:7}.tar.gz
https://github.com/onnx/optimizer/archive/${ONNXOPTIMIZER_COMMIT}.tar.gz
	-> onnxoptimizer-${ONNXOPTIMIZER_COMMIT:0:7}.tar.gz
https://github.com/protocolbuffers/protobuf/archive/${PROTOBUF_COMMIT_1}.tar.gz
	-> protobuf-${PROTOBUF_COMMIT_1:0:7}.tar.gz
https://github.com/protocolbuffers/protobuf/archive/${PROTOBUF_COMMIT_2}.tar.gz
	-> protobuf-${PROTOBUF_COMMIT_2:0:7}.tar.gz
https://github.com/pybind/pybind11/archive/${PYBIND11_COMMIT_1}.tar.gz
	-> pybind11-${PYBIND11_COMMIT_1:0:7}.tar.gz
https://github.com/pybind/pybind11/archive/${PYBIND11_COMMIT_2}.tar.gz
	-> pybind11-${PYBIND11_COMMIT_2:0:7}.tar.gz
https://github.com/pybind/pybind11/archive/${PYBIND11_COMMIT_3}.tar.gz
	-> pybind11-${PYBIND11_COMMIT_3:0:7}.tar.gz
https://github.com/pybind/pybind11/archive/${PYBIND11_COMMIT_4}.tar.gz
	-> pybind11-${PYBIND11_COMMIT_4:0:7}.tar.gz
https://github.com/pytorch/cpuinfo/archive/${PYTORCH_CPUINFO}.tar.gz
	-> pytorch-cpuinfo-${PYTORCH_CPUINFO:0:7}.tar.gz
https://github.com/tensorflow/tensorboard/archive/${TENSORBOARD_COMMIT}.tar.gz
	-> tensorboard-${TENSORBOARD_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="Simplify your ONNX model"
HOMEPAGE="
	https://github.com/daquexian/onnx-simplifier
"
LICENSE="
	(
		all-rights-reserved
		Apache-2.0
	)
	(
		(
			all-rights-reserved
			Apache-2.0
		)
		(
			all-rights-reserved
			MIT
		)
		(
			BSD-2
			custom
		)
		Apache-2.0
		Boost-1.0
		BSD
		custom
		ISC
		ISSL
		MIT
		MPL-2.0
		public-domain
		Unlicense
		UoI-NCSA
		ZLIB
	)
	(
		all-rights-reserved
		MIT
	)
	Apache-2.0
	Boost-1.0
	BSD
	BSD-2
	CC0-1.0
	CC-BY-3.0
	CC-BY-4.0
	custom
	MIT
	|| (
		LGPL-3+
		GPL-2+
	)
"
# ( all-rights-reserved Apache-2.0 ) ( all-rights-reserved MIT ) ( BSD-2 custom ) Apache-2.0 Boost-1.0 BSD custom ISC ISSL MIT MPL-2.0 public-domain Unlicense UoI-NCSA ZLIB - third_party/onnxruntime/ThirdPartyNotices.txt
# all-rights-reserved MIT - third_party/onnxruntime/cmake/external/wil/LICENSE
# all-rights-reserve Apache-2.0 - third_party/onnxruntime/cmake/external/tensorboard/tensorboard/tools/license_test.sh
# all-rights-reserve Apache-2.0 - third_party/onnxruntime/cmake/external/tensorboard/tensorboard/pip_package/LICENSE.tensorflow
# Apache-2.0 - ./third_party/onnxruntime/cmake/external/dlpack/LICENSE
# Apache-2.0-with-LLVM-exceptions - third_party/onnxruntime/cmake/external/re2/re2/fuzzing/compiler-rt/LICENSE
# Boost-1.0 custom MIT - third_party/onnxruntime/cmake/external/wil/ThirdPartyNotices.txt
# BSD - third_party/pybind11/LICENSE
# BSD BSD-2 - third_party/onnxruntime/winml/test/collateral/models/LICENSE.md
# CC-BY-3.0 CC-BY-4.0 - third_party/onnxruntime/winml/test/collateral/images/LICENSE.md
# custom - third_party/onnxruntime/dockerfiles/LICENSE-IMAGE.txt
# MIT - third_party/onnxruntime/winml/test/scenario/models/LICENSE.md
# MIT CC0-1.0 - ./third_party/onnxruntime/cmake/external/json/doc/mkdocs/docs/home/license.md
# || ( LGPL-3+ GPL-2+ ) - third_party/onnxruntime/cmake/external/eigen/scripts/relicense.py
# The distro's Apache-2.0 license template does not contain all rights reserved.
# The distro's MIT license template does not contain all rights reserved.
RESTRICT="mirror test" # Untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
RDEPEND+="
	!~dev-python/rich-12.1.0
	$(python_gen_any_dep '
		>=sci-ml/onnxruntime-1.6.0[${PYTHON_SINGLE_USEDEP},python]
	')
	>=dev-python/onnxoptimizer-0.2.5[${PYTHON_USEDEP}]
	>=dev-python/protobuf-3.7.0[${PYTHON_USEDEP}]
	dev-python/protobuf:=
	dev-python/rich[${PYTHON_USEDEP}]
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
		dev-python/pytest-runner[${PYTHON_USEDEP}]
	)
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
		grep -q -e "0.4.36" "${S}/VERSION" \
			|| die "QA:  Bump version"
	else
		unpack ${A}

		dep_prepare_mv "${WORKDIR}/optimizer-${ONNXOPTIMIZER_COMMIT}" "${S}/third_party/onnx-optimizer"

		dep_prepare_mv "${WORKDIR}/onnx-${ONNX_COMMIT_1}" "${S}/third_party/onnx-optimizer/third_party/onnx"
		dep_prepare_mv "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_2}" "${S}/third_party/onnx-optimizer/third_party/onnx/third_party/benchmark"
		dep_prepare_mv "${WORKDIR}/pybind11-${PYBIND11_COMMIT_2}" "${S}/third_party/onnx-optimizer/third_party/onnx/third_party/pybind"

		dep_prepare_mv "${WORKDIR}/protobuf-${PROTOBUF_COMMIT_1}" "${S}/third_party/onnx-optimizer/third_party/protobuf"
		dep_prepare_cp "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_1}" "${S}/third_party/onnx-optimizer/third_party/protobuf/third_party/benchmark"
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_1}" "${S}/third_party/onnx-optimizer/third_party/protobuf/third_party/googletest"

		dep_prepare_mv "${WORKDIR}/onnxruntime-${ONNXRUNTIME_COMMIT}" "${S}/third_party/onnxruntime"
		dep_prepare_mv "${WORKDIR}/cub-${CUB_COMMIT}" "${S}/third_party/onnxruntime/cmake/external/cub"
		dep_prepare_mv "${WORKDIR}/cxxopts-${CXXOPTS_COMMIT}" "${S}/third_party/onnxruntime/cmake/external/cxxopts"
		dep_prepare_mv "${WORKDIR}/date-${DATE_COMMIT}" "${S}/third_party/onnxruntime/cmake/external/date"
		dep_prepare_mv "${WORKDIR}/dlpack-${DLPACK_COMMIT}" "${S}/third_party/onnxruntime/cmake/external/dlpack"
		dep_prepare_mv "${WORKDIR}/eigen-${EIGEN_COMMIT}" "${S}/third_party/onnxruntime/cmake/external/eigen"
		dep_prepare_mv "${WORKDIR}/emsdk-${EMSDK_COMMIT}" "${S}/third_party/onnxruntime/cmake/external/emsdk"
		dep_prepare_mv "${WORKDIR}/flatbuffers-${FLATBUFFERS_COMMIT}" "${S}/third_party/onnxruntime/cmake/external/flatbuffers"
		dep_prepare_mv "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_3}" "${S}/third_party/onnxruntime/cmake/external/googlebenchmark"
		dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_2}" "${S}/third_party/onnxruntime/cmake/external/googletest"
		dep_prepare_mv "${WORKDIR}/json-${NLOHMANN_JSON_COMMIT}" "${S}/third_party/onnxruntime/cmake/external/json"
		dep_prepare_mv "${WORKDIR}/libprotobuf-mutator-${LIBPROTOBUF_MUTATOR_COMMIT}" "${S}/third_party/onnxruntime/cmake/external/libprotobuf-mutator"
		dep_prepare_mv "${WORKDIR}/mimalloc-${MIMALLOC_COMMIT}" "${S}/third_party/onnxruntime/cmake/external/mimalloc"
		dep_prepare_mv "${WORKDIR}/mp11-${MP11_COMMIT}" "${S}/third_party/onnxruntime/cmake/external/mp11"
		dep_prepare_mv "${WORKDIR}/nsync-${NSYNC_COMMIT}" "${S}/third_party/onnxruntime/cmake/external/nsync"

		dep_prepare_mv "${WORKDIR}/onnx-${ONNX_COMMIT_3}" "${S}/third_party/onnxruntime/cmake/external/onnx"
		dep_prepare_mv "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_5}" "${S}/third_party/onnxruntime/cmake/external/onnx/third_party/benchmark"
		dep_prepare_mv "${WORKDIR}/pybind11-${PYBIND11_COMMIT_4}" "${S}/third_party/onnxruntime/cmake/external/onnx/third_party/pybind11"

		dep_prepare_mv "${WORKDIR}/onnx-tensorrt-${ONNX_TENSORRT}" "${S}/third_party/onnxruntime/cmake/external/onnx-tensorrt"
		dep_prepare_mv "${WORKDIR}/onnx-${ONNX_COMMIT_2}" "${S}/third_party/onnxruntime/cmake/external/onnx-tensorrt/third_party/onnx"
		dep_prepare_mv "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_4}" "${S}/third_party/onnxruntime/cmake/external/onnx-tensorrt/third_party/onnx/third_party/benchmark"
		dep_prepare_mv "${WORKDIR}/pybind11-${PYBIND11_COMMIT_3}" "${S}/third_party/onnxruntime/cmake/external/onnx-tensorrt/third_party/onnx/third_party/pybind11"

		dep_prepare_mv "${WORKDIR}/onnxruntime-extensions-${ONNXRUNTIME_EXTENSIONS_COMMIT}" "${S}/third_party/onnxruntime/cmake/external/onnxruntime-extensions"
		dep_prepare_mv "${WORKDIR}/protobuf-${PROTOBUF_COMMIT_2}" "${S}/third_party/onnxruntime/cmake/external/protobuf"
		dep_prepare_cp "${WORKDIR}/benchmark-${BENCHMARK_COMMIT_1}" "${S}/third_party/onnxruntime/cmake/external/protobuf/benchmark"
		dep_prepare_cp "${WORKDIR}/googletest-${GOOGLETEST_COMMIT_1}" "${S}/third_party/onnxruntime/cmake/external/protobuf/googletest"

		dep_prepare_mv "${WORKDIR}/cpuinfo-${PYTORCH_CPUINFO}" "${S}/third_party/onnxruntime/cmake/external/pytorch_cpuinfo"
		dep_prepare_mv "${WORKDIR}/re2-${RE2_COMMIT}" "${S}/third_party/onnxruntime/cmake/external/re2"
		dep_prepare_mv "${WORKDIR}/tensorboard-${TENSORBOARD_COMMIT}" "${S}/third_party/onnxruntime/cmake/external/tensorboard"
		dep_prepare_mv "${WORKDIR}/wil-${WIL_COMMIT}" "${S}/third_party/onnxruntime/cmake/external/wil"

		dep_prepare_mv "${WORKDIR}/pybind11-${PYBIND11_COMMIT_1}" "${S}/third_party/pybind11"
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
