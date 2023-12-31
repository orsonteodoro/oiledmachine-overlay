# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_DOTNET="net45"
inherit dotnet

DESCRIPTION="FNA - Accuracy-focused XNA4 reimplementation for open platforms"
HOMEPAGE="http://fna-xna.github.io/"
LICENSE="Ms-PL MIT LGPL-2.1"
KEYWORDS="~amd64 ~x86"
IUSE="${USE_DOTNET} mojoshader openal sdl2 theoraplay vorbis"
REQUIRED_USE="|| ( ${USE_DOTNET} )"
RDEPEND="
	~media-gfx/mojoshader-9999
	>=dev-dotnet/faudio-22.09.01[net40]
	>=dev-dotnet/fna3d-22.09
	>=dev-dotnet/sdl2-cs-22.09[net40]
	~dev-dotnet/theorafile-9999[net40]
"
DEPEND="${RDEPEND}"
SLOT="0/$(ver_cut 1-2 ${PV})"
SRC_URI="
https://github.com/FNA-XNA/FNA/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/FNA-${PV}"
RESTRICT="mirror"
PATCHES=(
	"${FILESDIR}/${PN}-22.09.01-assembly-references.patch"
)

src_compile() {
	exbuild \
		/t:Build \
		/p:SDL2CSPath="${EPREFIX}/usr/lib/mono/4.0/SDL2-CS.dll" \
		/p:FAudioCSPath="${EPREFIX}/usr/lib/mono/4.0/FAudio-CS.dll" \
		/p:TheorafileCSPath="${EPREFIX}/usr/lib/mono/4.0/Theorafile-CS.dll" \
		FNA.csproj \
		|| die
}

src_install() {
	local configuration="Release"
	exeinto "/usr/lib/mono/${FRAMEWORK}"
	insinto "/usr/lib/mono/${FRAMEWORK}"
	doexe bin/${configuration}/FNA.dll
	doins bin/${configuration}/FNA.dll.config
	dodoc README
	docinto licenses
	dodoc licenses/*
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
