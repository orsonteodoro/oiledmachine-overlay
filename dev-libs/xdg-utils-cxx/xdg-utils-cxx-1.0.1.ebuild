# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Implementation of the FreeDesktop specifications to be used in \
c++ projects"
HOMEPAGE="https://github.com/azubieta/xdg-utils-cxx"
LICENSE="MIT" # The project's default license.
LICENSE+=" BSD" # code_coverage_utils.cmake is BSD
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
SRC_URI=\
"https://github.com/azubieta/xdg-utils-cxx/archive/v${PV}.tar.gz
	 -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"
inherit cmake-utils xdg-utils-cxx

src_prepare() {
	cmake-utils_src_prepare
	xdg-utils-cxx_copy_sources
}

src_configure() {
	configure_impl() {
		local mycmakeargs=(
			-DXDG_UTILS_TESTS=OFF
			-DXDG_UTILS_CODE_COVERAGE=OFF
		)
		if [[ "${EXDG_UTILS_CXX}" == "static" ]] ; then
			if use static ; then
				mycmakeargs+=( -DXDG_UTILS_SHARED=OFF )
			fi
		elif [[ "${EXDG_UTILS_CXX}" == "shared" ]] ; then
			if use shared ; then
				mycmakeargs+=( -DXDG_UTILS_SHARED=ON )
			fi
		fi
		S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
		cmake-utils_src_configure
	}
	xdg-utils-cxx_foreach_impl configure_impl
}

src_compile() {
	compile_impl() {
		S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
		cmake-utils_src_compile
	}
	xdg-utils-cxx_foreach_impl compile_impl
}

src_install() {
	install_impl() {
		S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
		cmake-utils_src_install
	}
	xdg-utils-cxx_foreach_impl install_impl
}
