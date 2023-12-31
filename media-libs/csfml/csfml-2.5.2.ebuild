# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# TODO delete exlibs and replace with external libraries

EAPI=8

inherit cmake multilib-build

SRC_URI="
https://github.com/SFML/CSFML/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/CSFML-${PV}"

DESCRIPTION="Official binding of SFML for C"
HOMEPAGE="https://www.sfml-dev.org/ https://github.com/SFML/CSFML/"
LICENSE="ZLIB"
KEYWORDS="~arm ~arm64 ~amd64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
static-libs
"
IUSE+=" "
REQUIRED_USE+=""
RDEPEND+="
	=media-libs/libsfml-$(ver_cut 1-2 ${PV})*[audio,graphics,network]
"
DEPEND="
	${RDEPEND}
"
# U 22.04
BDEPEND+="
	>=dev-util/cmake-3.7.2
	>=sys-devel/gcc-11.2.0
"
DOCS=( readme.txt )
PATCHES=(
)

_get_lib_types() {
	echo "shared"
	use static-libs && echo "static-libs"
}

src_configure() {
	local lib_type
	configure_abi() {
		local lib_type
		for lib_type in $(_get_lib_types) ; do
			local mycmakeargs=()
			if [[ "${lib_type}" == "static" ]] ; then
				mycmakeargs+=(
					-DBUILD_SHARED_LIBS=FALSE
				)
			elif [[ "${lib_type}" == "shared" ]] ; then
				mycmakeargs+=(
					-DBUILD_SHARED_LIBS=FALSE
				)
			fi
			export CMAKE_USE_DIR="${S}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			cmake_src_configure
		done
	}
	multilib_foreach_abi configure_abi
}

src_compile() {
	local lib_type
	configure_abi() {
		local lib_type
		for lib_type in $(_get_lib_types) ; do
			export CMAKE_USE_DIR="${S}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			cd "${BUILD_DIR}" || die
			cmake_src_compile
		done
	}
	multilib_foreach_abi compile_abi
}

src_install() {
	local lib_type
	install_abi() {
		local lib_type
		for lib_type in $(_get_lib_types) ; do
			export CMAKE_USE_DIR="${S}"
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}"
			cd "${BUILD_DIR}" || die
			cmake_src_install
		done
		multilib_check_headers
	}
	multilib_foreach_abi install_abi
	multilib_src_install_all
}

multilib_src_install_all() {
	cd "${S}" || die
	dodoc license.txt
}
