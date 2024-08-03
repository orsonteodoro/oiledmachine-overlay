# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{8..11} )

inherit distutils-r1

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/KhronosGroup/NNEF-Tools.git"
	FALLBACK_COMMIT="c1aac758ad155d8c132e9b5166d9490b73f70811"
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}/nnef_tools-pyproject"
else
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
	S="${WORKDIR}/NNEF-Tools-nnef-v${PV}/nnef_tools-pyproject"
	SRC_URI="
https://github.com/KhronosGroup/NNEF-Tools/archive/refs/tags/nnef-v${PV}.tar.gz
	"
fi

DESCRIPTION="NNEF Tools"
HOMEPAGE="https://github.com/KhronosGroup/NNEF-Tools"
LICENSE="
	Apache-2.0
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" caffe full models onnx tensorflow-lite tensorflow-protobuf test visualization"
REQUIRED_USE="
	full? (
		caffe
		onnx
		tensorflow-lite
		visualization
	)
"
RDEPEND+="
	dev-python/future[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/typing[${PYTHON_USEDEP}]
	sci-libs/nnef-parser[${PYTHON_USEDEP}]
	caffe? (
		dev-python/protobuf-python:0/3.21[${PYTHON_USEDEP}]
		$(python_gen_any_dep '
			sci-libs/pytorch[${PYTHON_SINGLE_USEDEP}]
		')
	)
	onnx? (
		dev-python/protobuf-python:0/3.21[${PYTHON_USEDEP}]
		sci-libs/onnxruntime[${PYTHON_USEDEP}]
		sci-libs/onnx-simplifier[${PYTHON_USEDEP}]
	)
	tensorflow-lite? (
		dev-python/flatbuffers[${PYTHON_USEDEP}]
		sci-libs/tensorflow[${PYTHON_USEDEP}]
	)
	tensorflow-protobuf? (
		sci-libs/tensorflow[${PYTHON_USEDEP}]
	)
	visualization? (
		media-gfx/graphviz[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
DOCS=( "README.md" )
PATCHES=(
)

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
