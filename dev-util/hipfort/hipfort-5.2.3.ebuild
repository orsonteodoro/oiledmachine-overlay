# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=14
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake llvm rocm

SRC_URI="
https://github.com/ROCmSoftwarePlatform/hipfort/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Fortran interfaces for ROCm libraries"
HOMEPAGE="
https://rocm.docs.amd.com/projects/hipfort/en/latest/
https://github.com/ROCmSoftwarePlatform/hipfort
"
KEYWORDS="~amd64"
LICENSE="MIT"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="debug r4"
RDEPEND="
	!dev-util/hipfort:0
	|| (
		>=sys-devel/gcc-7.5.0[fortran]
		dev-lang/flang
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/cmake-2.8.12
	>=sys-devel/gcc-7.5.0[fortran]
	~dev-util/rocm-cmake-${PV}
"
RESTRICT="test"
S="${WORKDIR}/${PN}-rocm-${PV}"
DOCS=( README.md )
CMAKE_BUILD_TYPE="RELEASE"
PATCHES=(
	"${FILESDIR}/${PN}-5.2.3-path-changes.patch"
)

pkg_setup() {
	llvm_pkg_setup
	rocm_pkg_setup
}

src_prepare() {
	sed \
		-e "s:ADD_SUBDIRECTORY(\${CMAKE_SOURCE_DIR}/test):#ADD_SUBDIRECTORY(\${CMAKE_SOURCE_DIR}/test):" \
		-i \
		"${S}/CMakeLists.txt" \
		|| die
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
        local mycmakeargs=(
                -DCMAKE_BUILD_TYPE=$(usex debug "DEBUG" "RELEASE")
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
        )
        cmake_src_configure
}

src_install() {
        cmake_src_install
	dodoc LICENSE
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
