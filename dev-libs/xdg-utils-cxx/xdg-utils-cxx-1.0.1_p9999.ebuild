# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Implementation of the FreeDesktop specifications to be used in \
c++ projects"
HOMEPAGE="https://github.com/azubieta/xdg-utils-cxx"
LICENSE="MIT" # The project's default license.
LICENSE+=" BSD" # code_coverage_utils.cmake is BSD
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
IUSE+=" static-libs"
if [[ ${PV} =~ 9999 ]] ; then
	IUSE+=" fallback-commit"
else
	SRC_URI="
https://github.com/azubieta/xdg-utils-cxx/archive/v${PV}.tar.gz
	 -> ${P}.tar.gz
	"
fi
S="${WORKDIR}/${P}"
RESTRICT="mirror"

get_lib_types() {
	if use static-libs ; then
		echo "static"
	fi
	echo "shared"
}

src_unpack() {
	if [[ ${PV} =~ 9999 ]] ; then
		use fallback-commit && EGIT_COMMIT="80c611c39b2fd8fffb850ba803254c081cfcb9a8"
		EGIT_REPO_URI="https://github.com/azubieta/xdg-utils-cxx.git"
		EGIT_BRANCH="master"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_configure() {
	local lib_type
	for lib_type in $(get_lib_types) ; do
		export CMAKE_USE_DIR="${S}"
		export BUILD_DIR="${S}-${lib_type}_build"
		cd "${CMAKE_USE_DIR}" || die
		local mycmakeargs=(
			-DXDG_UTILS_TESTS=OFF
			-DXDG_UTILS_CODE_COVERAGE=OFF
		)
		if [[ "${lib_type}" == "static" ]] ; then
			mycmakeargs+=( -DXDG_UTILS_SHARED=OFF )
		else
			mycmakeargs+=( -DXDG_UTILS_SHARED=ON )
		fi
		cmake_src_configure
	done
}

src_compile() {
	local lib_type
	for lib_type in $(get_lib_types) ; do
		export CMAKE_USE_DIR="${S}"
		export BUILD_DIR="${S}-${lib_type}_build"
		cd "${BUILD_DIR}" || die
		cmake_src_compile
	done
}

src_install() {
	local lib_type
	for lib_type in $(get_lib_types) ; do
		export CMAKE_USE_DIR="${S}"
		export BUILD_DIR="${S}-${lib_type}_build"
		cd "${BUILD_DIR}" || die
		cmake_src_install
	done
	cd "${S}" || die
	docinto licenses
	dodoc LICENSE
cat <<-EOF > "${T}"/99${P} || die
LDPATH="/usr/$(get_libdir)/XdgUtils"
EOF
	doenvd "${T}"/99${P}
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  static-libs
# OILEDMACHINE-OVERLAY-META-REVDEP:  libappimage, appimaged
