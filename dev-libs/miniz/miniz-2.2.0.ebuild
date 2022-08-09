# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A lossless, high performance data compression library"
HOMEPAGE="https://github.com/richgel999/miniz"
SRC_URI="https://github.com/richgel999/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DOCS=( ChangeLog.md readme.md )

get_lib_type() {
	use static-libs && echo "static"
	echo "shared"
}

src_configure() {
	CMAKE_BUILD_TYPE=Release

	local lib_type
	for lib_type in $(get_lib_type) ; do
		local mycmakeargs=(
			-DBUILD_EXAMPLES=OFF
		)

		if [[ "${lib_type}" == "shared" ]] ; then
			mycmakeargs+=( -DBUILD_SHARED_LIBS=ON )
		else
			mycmakeargs+=( -DBUILD_SHARED_LIBS=OFF )
		fi

		export CMAKE_USE_DIR="${S}"
		export BUILD_DIR="${S}_${lib_type}_build"
		cd "${CMAKE_USE_DIR}" || die
		cmake_src_configure
	done

}

src_compile() {
	local lib_type
	for lib_type in $(get_lib_type) ; do
		export CMAKE_USE_DIR="${S}"
		export BUILD_DIR="${S}_${lib_type}_build"
		cd "${BUILD_DIR}" || die
		cmake_src_compile
	done
}

src_install() {
	local lib_type
	for lib_type in $(get_lib_type) ; do
		export CMAKE_USE_DIR="${S}"
		export BUILD_DIR="${S}_${lib_type}_build"
		cd "${BUILD_DIR}" || die
		cmake_src_install
	done
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES: static-libs-support
