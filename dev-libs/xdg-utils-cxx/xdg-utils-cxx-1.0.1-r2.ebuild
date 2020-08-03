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
inherit cmake-static-libs cmake-utils

src_prepare() {
	cmake-utils_src_prepare
	cmake-static-libs_copy_sources
}

src_configure() {
	configure_impl() {
		local mycmakeargs=(
			-DXDG_UTILS_TESTS=OFF
			-DXDG_UTILS_CODE_COVERAGE=OFF
		)
		if [[ "${ECMAKE_LIB_TYPE}" == "static-libs" ]] ; then
			mycmakeargs+=( -DXDG_UTILS_SHARED=OFF )
		elif [[ "${ECMAKE_LIB_TYPE}" == "shared" ]] ; then
			mycmakeargs+=( -DXDG_UTILS_SHARED=ON )
		fi
		S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
		cmake-utils_src_configure
	}
	cmake-static-libs_foreach_impl configure_impl
}

src_compile() {
	compile_impl() {
		S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
		cmake-utils_src_compile
	}
	cmake-static-libs_foreach_impl compile_impl
}

src_install() {
	install_impl() {
		S="${BUILD_DIR}" CMAKE_USE_DIR="${BUILD_DIR}" \
		cmake-utils_src_install
	}
	cmake-static-libs_foreach_impl install_impl
	docinto licenses
	dodoc LICENSE
	cat <<-EOF > "${T}"/99${P}
		LDPATH=\
"/usr/lib64/XdgUtils"
	EOF
	doenvd "${T}"/99${P}
}
