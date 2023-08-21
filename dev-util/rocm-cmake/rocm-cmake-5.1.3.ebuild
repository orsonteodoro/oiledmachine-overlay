# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
LLVM_MAX_SLOT=14

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
SLOT="0/$(ver_cut 1-2)"
BDEPEND="
	>=dev-util/cmake-3.5
"
RESTRICT="test"
PATCHES=(
	"${FILESDIR}/${PN}-5.0.2-license.patch"
)

pkg_setup() {
	llvm_pkg_setup
}

src_prepare() {
	sed \
		-e "/ROCM_INSTALL_LIBDIR/s:lib:$(get_libdir):" \
		-i \
		"${S}/share/rocm/cmake/ROCMInstallTargets.cmake" \
		|| die
	local old_site_dirs="/usr/lib/python3/dist-packages;/usr/lib/python2.7/dist-packages"
	local new_site_dirs=$(realpath "${EPREFIX}/usr/$(get_libdir)/python"*"/site-packages" \
		| tr "\n" ";" \
		| sed -e "s|;$||g")
	sed \
		-i \
		-e "s|${old_site_dirs}|${new_site_dirs}|g" \
		"${S}/share/rocm/cmake/ROCMCreatePackage.cmake" \
		|| die
	IFS=$'\n'
	sed \
		-i \
		-e "s|{CMAKE_CURRENT_BINARY_DIR}/lib|{CMAKE_CURRENT_BINARY_DIR}/$(get_libdir)|g" \
		$(grep -r -l -F "{CMAKE_CURRENT_BINARY_DIR}/lib" "${WORKDIR}") \
		|| die
	sed \
		-i \
		-e "s|{PREFIX}/lib/|{PREFIX}/$(get_libdir)/|g" \
		$(grep -r -l -F "{PREFIX}/lib/" "${WORKDIR}") \
		|| die
	sed \
		-i \
		-e "s|\"lib\"|\"$(get_libdir)\"|" \
		"share/rocm/cmake/ROCMCreatePackage.cmake" \
		"share/rocm/cmake/ROCMInstallTargets.cmake" \
		|| die
	IFS=$' \t\n'
	cmake_src_prepare
	rocm_src_prepare
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
