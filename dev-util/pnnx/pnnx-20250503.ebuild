# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

CMAKE_MAKEFILE_GENERATOR="emake"
#DISTUTILS_OPTIONAL=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{11..13} )
TORCH_TO_VISION=(
#pytorch:torchvision
	"2.5:0.20.1"
	"2.4:0.19.1"
	"2.3:0.18.1"
	"2.2:0.17.2"
	"2.1:0.16.2"
	"2.0:0.15.2"
)

inherit abseil-cpp cmake distutils-r1 protobuf pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/ncnn-${PV}"
	EGIT_REPO_URI="https://github.com/Tencent/ncnn.git"
	FALLBACK_COMMIT="305837fd4a722ebc47c5d72e72d8ec9ae970e932" # May 3, 2025
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
IUSE+="
onnxruntime protobuf torchvision
ebuild_revision_1
"
gen_torch_rdepend() {
	local row
	for row in ${TORCH_TO_VISION[@]} ; do
		local torch_pv="${row%:*}"
		local vision_pv="${row#*:}"
		echo "
			(
				=sci-ml/pytorch-${torch_pv}*[${PYTHON_SINGLE_USEDEP}]
				torchvision? (
					>=sci-ml/torchvision-${vision_pv}[${PYTHON_SINGLE_USEDEP}]
				)
			)
		"
	done
}
RDEPEND+="
	|| (
		$(gen_torch_rdepend)
	)
	onnxruntime? (
		sci-ml/onnxruntime[${PYTHON_SINGLE_USEDEP},python]
	)
	protobuf? (
		$(python_gen_cond_dep '
			dev-python/protobuf:4.21[${PYTHON_USEDEP}]
		')
		dev-python/protobuf:=
		dev-libs/protobuf:3/3.21
		dev-libs/protobuf:=
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
	if use protobuf ; then
		ABSEIL_CPP_SLOT="20220623"
		PROTOBUF_CPP_SLOT="3"
		abseil-cpp_src_configure
		protobuf_src_configure
	fi

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
