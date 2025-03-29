# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

CMAKE_MAKEFILE_GENERATOR="emake"
#DISTUTILS_OPTIONAL=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..1} )

inherit cmake distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/ncnn-${PV}"
	EGIT_REPO_URI="https://github.com/Tencent/ncnn.git"
	FALLBACK_COMMIT="a6d3ef5a0bb59fb496c553c3ef54d141642b4fc5" # Aug 19, 2024
	IUSE+=" fallback-commit"
	S="${WORKDIR}/ncnn-${PV}/tools/pnnx"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/ncnn-${PV}/tools/pnnx"
	SRC_URI="
https://github.com/Tencent/ncnn/archive/refs/tags/${PV}.tar.gz
        -> ncnn-${PV}.tar.gz
	"
fi

DESCRIPTION="pnnx is an open standard for PyTorch model interoperability"
HOMEPAGE="
	https://github.com/Tencent/ncnn/tree/master/tools/pnnx
	https://github.com/Tencent/ncnn
	https://pypi.org/project/pnnx
"
LICENSE="
	BSD
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" onnxruntime protobuf torchvision"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/protobuf-3.12.4[${PYTHON_USEDEP}]
	')
	>=sci-ml/pytorch-1.8.1[${PYTHON_SINGLE_USEDEP}]
	onnxruntime? (
		sci-ml/onnxruntime[${PYTHON_SINGLE_USEDEP},python]
	)
	protobuf? (
		dev-libs/protobuf:=
	)
	torchvision? (
		>=sci-ml/torchvision-0.8.2[${PYTHON_SINGLE_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "README.md" )
PATCHES=(
	"${FILESDIR}/${PN}-20240820-force-system-protobuf.patch"
	"${FILESDIR}/${PN}-20240820-optionalize-features.patch"
)

pkg_setup() {
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
}

src_prepare() {
	cmake_src_prepare

	if has_version ">=sci-ml/pytorch-2" ; then
		# -std=gnu++14 Breaks pytorch's c10
		sed -i \
			-e "s|CMAKE_CXX_STANDARD 14|CMAKE_CXX_STANDARD 17|g" \
			"${WORKDIR}/ncnn-${PV}/tools/pnnx/CMakeLists.txt" \
			|| die
	fi
}

src_configure() {
	export MAKEOPTS="-j1"
	local mycmakeargs=(
		-DPython3_EXECUTABLE="${PYTHON}"
		-Donnxruntime_INSTALL_DIR="/usr"
		-DUSE_ONNXRUNTIME=$(usex onnxruntime)
		-DUSE_PROTOBUF=$(usex protobuf)
		-DUSE_TORCHVISION=$(usex torchvision)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
