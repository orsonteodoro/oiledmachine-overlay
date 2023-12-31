# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_DOTNET="net40"
CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake-multilib dotnet lcnr

DESCRIPTION="FAudio - Accuracy-focused XAudio reimplementation for open platforms"
HOMEPAGE="http://fna-xna.github.io/"
LICENSE="ZLIB"
KEYWORDS="~amd64 ~x86"
IUSE="${USE_DOTNET}"
REQUIRED_USE="|| ( ${USE_DOTNET} )"
RDEPEND="
	>=media-libs/libsdl2-2.24[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
SLOT="0/$(ver_cut 1-2 ${PV})"
SRC_URI="
https://github.com/FNA-XNA/FAudio/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/FAudio-${PV}"
RESTRICT="mirror"

_build_libs() {
	cmake-multilib_src_compile
}

_build_assembly() {
	cd csharp || die
	exbuild FAudio-CS.csproj
}

src_compile() {
	_build_libs
	_build_assembly
}

_install_libs() {
	cmake-multilib_src_install
	docinto readmes
	dodoc README
}

_install_assembly() {
	local configuration="Release"
	exeinto "/usr/lib/mono/${FRAMEWORK}"
	insinto "/usr/lib/mono/${FRAMEWORK}"
	doexe csharp/bin/${configuration}/FAudio-CS.dll
	doins csharp/bin/${configuration}/FAudio-CS.dll.config
	docinto readmes/csharp
	dodoc csharp/README
}

src_install() {
	_install_libs
	_install_assembly

	if [[ -e "${HOME}/.nuget" ]] ; then
		LCNR_SOURCE="${HOME}/.nuget"
		LCNR_TAG="third_party"
		lcnr_install_files
	fi

	LCNR_SOURCE="${S}"
	LCNR_TAG="sources"
	lcnr_install_files
}
