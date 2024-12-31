# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Cross-platform FreeType bindings for .NET"
HOMEPAGE="https://github.com/Robmaister/SharpFont"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac gac? ( net45 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
SLOT="0/$(ver_cut 1-2 ${PV})"
inherit dotnet eutils mono
SRC_URI="https://github.com/Robmaister/SharpFont/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
inherit gac
S="${WORKDIR}/SharpFont-${PV}"

src_prepare() {
	default
	dotnet_copy_sources
}

src_compile() {
	compile_impl() {
		cd Source/SharpFont
		exbuild ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" \
			SharpFont.csproj || die
	}
	dotnet_foreach_impl compile_impl
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")
	install_impl() {
		dotnet_install_loc
                egacinstall Binaries/SharpFont/${mydebug}/SharpFont.dll
		dotnet_distribute_file_matching_dll_in_gac \
			"Binaries/SharpFont/${mydebug}/SharpFont.dll" \
			"Binaries/SharpFont/${mydebug}/SharpFont.dll.config"
		doins Binaries/SharpFont/${mydebug}/SharpFont.dll.config
		if use developer ; then
			dotnet_distribute_file_matching_dll_in_gac \
			  "Binaries/SharpFont/${mydebug}/SharpFont.dll" \
			  "Binaries/SharpFont/${mydebug}/SharpFont.dll.mdb"
			doins Binaries/SharpFont/${mydebug}/SharpFont.dll.mdb
		fi
	}
	dotnet_foreach_impl install_impl
	dodoc README.md "LICENSE"
	dotnet_multilib_comply
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
