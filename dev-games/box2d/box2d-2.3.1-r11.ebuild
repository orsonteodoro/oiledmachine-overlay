# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake multilib-build

DESCRIPTION="Box2D is a 2D physics engine for games"
HOMEPAGE="http://box2d.org/"
LICENSE="ZLIB"
KEYWORDS="~amd64 ~x86"
SLOT_MAJ="$(ver_cut 1-2 ${PV})"
SLOT="${SLOT_MAJ}/${PV}"
IUSE+=" doc examples static-libs test"
REQUIRED_USE+=" test? ( examples )"
DEPEND+="
	virtual/libc
	examples? (
		media-libs/freeglut:=[${MULTILIB_USEDEP},static-libs]
		media-libs/glew[${MULTILIB_USEDEP}]
		media-libs/glfw[${MULTILIB_USEDEP}]
		media-libs/glui[${MULTILIB_USEDEP}]
	)
"
RDEPEND+=" ${DEPEND}"
BDEPEND+=" >=dev-util/cmake-2.6"
SRC_URI="
https://github.com/erincatto/Box2D/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${P}/Box2D"
RESTRICT="mirror"
PATCHES=(
	"${FILESDIR}/box2d-2.3.1-cmake-fixes.patch"
)
CMAKE_BUILD_TYPE="Release"
MY_PN="Box2D"

get_lib_types() {
	if use static-libs ; then
		echo "static"
	fi
	echo "shared"
}

_configure() {
	local mycmakeargs=(
		-DDOC_DEST_DIR=${PN}-${PVR}
		-DBOX2D_INSTALL_DOC=$(usex doc)
		-DBOX2D_BUILD_EXAMPLES=$(usex examples)
	)
	if [[ "${lib_type}" == "shared" ]] ; then
		mycmakeargs+=( -DBOX2D_BUILD_SHARED=ON )
	else
		mycmakeargs+=( -DBOX2D_BUILD_STATIC=ON )
	fi
	cmake_src_configure

}

src_configure() {
	configure_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export CMAKE_USE_DIR="${S}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${CMAKE_USE_DIR}" || die
			_configure
		done
	}
	multilib_foreach_abi configure_abi
}

src_compile() {
	compile_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export CMAKE_USE_DIR="${S}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${BUILD_DIR}" || die
			cmake_src_compile
		done
	}
	multilib_foreach_abi compile_abi
}

src_test() {
	test_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export CMAKE_USE_DIR="${S}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${BUILD_DIR}" || die
			if [[ -x HelloWorld/HelloWorld ]] ; then
				./HelloWorld/HelloWorld || die
			else
				die "No unit test exist for ABI=${ABI} lib_type=${lib_type}"
			fi
		done
	}
	multilib_foreach_abi test_abi
}

src_install() {
	install_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export CMAKE_USE_DIR="${S}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${BUILD_DIR}" || die
			cmake_src_install
			if use examples ; then
				exeinto /usr/share/${PN}/Testbed
				doexe Testbed/Testbed

				exeinto /usr/share/${PN}/HelloWorld
				doexe HelloWorld/HelloWorld
			fi
		done
	}
	multilib_foreach_abi install_abi

	if use examples ; then
		cd "${S}"
		insinto /usr/share/${PN}/HelloWorld
		doins -r HelloWorld/*
	fi
}

pkg_postinst() {
	ewarn "This was the last major.minor version released in 2014 and is no longer receiving updates."
}

# OILEDMACHINE-OVERLAY-META-MOD-TYPE:  ebuild
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  multilib-support, static-libs
