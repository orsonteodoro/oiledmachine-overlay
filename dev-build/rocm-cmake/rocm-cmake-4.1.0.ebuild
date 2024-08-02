# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
LLVM_SLOT=12
PYTHON_COMPAT=( "python3_"{10..11} )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake python-r1 rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/rocm-cmake/"
	inherit git-r3
else
	SRC_URI="
https://github.com/RadeonOpenCompute/rocm-cmake/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/rocm-cmake-rocm-${PV}"
fi

DESCRIPTION="Radeon Open Compute CMake Modules"
HOMEPAGE="https://github.com/RadeonOpenCompute/rocm-cmake"
LICENSE="MIT"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="ebuild-revision-4"
RDEPEND="
"
BDEPEND="
	>=dev-build/cmake-3.5
"
RESTRICT="test"
PATCHES=(
	"${FILESDIR}/${PN}-5.1.3-hardcoded-paths.patch"
)

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	local new_site_dirs=$(realpath "${EPREFIX}/usr/$(get_libdir)/python"*"/site-packages" \
		| tr "\n" ";" \
		| sed -e "s|;$||g")
	sed \
		-i \
		-e "s|@PYTHON_SITEDIRS@|${new_site_dirs}|g" \
		"${S}/share/rocm/cmake/ROCMCreatePackage.cmake" \
		|| die
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
