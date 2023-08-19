# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SRC_URI="
https://github.com/ROCmSoftwarePlatform/hipfort/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
"

inherit cmake llvm

DESCRIPTION="Fortran interfaces for ROCm libraries"
HOMEPAGE="
https://rocm.docs.amd.com/projects/hipfort/en/latest/
https://github.com/ROCmSoftwarePlatform/hipfort
"
KEYWORDS="~amd64"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE="debug r1"
RDEPEND="
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
	"${FILESDIR}/${PN}-5.6.0-path-changes.patch"
)

pkg_setup() {
	llvm_pkg_setup
}

src_prepare() {
	sed \
		-e "s:ADD_SUBDIRECTORY(\${CMAKE_SOURCE_DIR}/test):#ADD_SUBDIRECTORY(\${CMAKE_SOURCE_DIR}/test):" \
		-i \
		"${S}/CMakeLists.txt" \
		|| die
	sed \
		-e "s|@LLVM_SLOT@|${LLVM_SLOT}|g" \
		-i \
		"bin/hipfc" \
		|| die
	sed \
		-e "s|@EPREFIX@|${EPREFIX}|g" \
		-i \
		"bin/hipfc" \
		|| die
	cmake_src_prepare
}

src_configure() {
        local mycmakeargs=(
                -DCMAKE_BUILD_TYPE=$(usex debug "DEBUG" "RELEASE")
        )
        cmake_src_configure
}

src_install() {
        cmake_src_install
	dodoc LICENSE
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
