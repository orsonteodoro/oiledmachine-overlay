# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="AMDMIGraphX"
MY_P="${CATEGORY}/${MY_PN}-${PV}"

AMDGPU_TARGETS_COMPAT=(
	gfx900
	gfx906
	gfx908
	gfx1030
)
LLVM_MAX_SLOT=15
PYTHON_COMPAT=( python3_{10..11} )

inherit cmake llvm python-r1

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/AMDMIGraphX/"
	inherit git-r3
else
	SRC_URI="
https://github.com/ROCmSoftwarePlatform/AMDMIGraphX/archive/rocm-${PV}.tar.gz
	-> ${MY_PN}-${PV}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-rocm-${PV}"
fi

DESCRIPTION="AMD's graph optimization engine"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/AMDMIGraphX"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"
# protobuf is relaxed
RDEPEND="
	>=dev-db/sqlite-3.17
	>=dev-cpp/msgpack-cxx-3.3.0
	>=dev-cpp/nlohmann_json-3.8.0
	>=dev-libs/half-1.12.0
	>=sys-libs/libomp-${LLVM_MAX_SLOT}
	>=dev-python/pybind11-2.6.0[${PYTHON_USEDEP}]
	dev-libs/msgpack
	dev-libs/oneDNN
	dev-libs/protobuf:0/32
	~sci-libs/miopen-${PV}:${SLOT}
	~sci-libs/rocBLAS-${PV}:${SLOT}
"
DEPEND="
	${RDEPEND}
	>=dev-cpp/blaze-3.8:=
"
BDEPEND="
	>=dev-util/cmake-3.5
	~dev-util/rocm-cmake-${PV}:${SLOT}
"
PATCHES=(
)

pkg_setup() {
	python_setup
}

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
	)
	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
