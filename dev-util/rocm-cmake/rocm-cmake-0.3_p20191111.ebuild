# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Rocm cmake modules"
HOMEPAGE="https://github.com/RadeonOpenCompute/rocm-cmake"
LICENSE="MIT"
KEYWORDS="~amd64"
inherit cmake-utils
SLOT="0/$(ver_cut 1-2)"
EGIT_COMMIT="ac2b6c1b9e94cdee419026c82938e12eb4bc8419"
SRC_URI=\
"https://github.com/RadeonOpenCompute/rocm-cmake/archive/${EGIT_COMMIT}.tar.gz \
	-> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

01234567890123456789012345678901234567890123456789012345678901234567890123456789
src_prepare() {
	sed -e "s:set(ROCM_INSTALL_LIBDIR lib):set(ROCM_INSTALL_LIBDIR $(get_libdir)):" \
		-i "${S}/share/rocm/cmake/ROCMInstallTargets.cmake" || die
	cmake-utils_src_prepare
}
