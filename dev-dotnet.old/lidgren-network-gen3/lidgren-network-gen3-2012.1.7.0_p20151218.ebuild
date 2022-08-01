# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Lidgren Network Library"
HOMEPAGE="https://github.com/lidgren/lidgren-network-gen3"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
USE_DOTNET="net451"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac? ( net451 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
inherit dotnet eutils
EGIT_COMMIT="8c7b5fb7754af3a283040e56656762f73b0a943e"
SRC_URI="\
https://github.com/lidgren/lidgren-network-gen3/archive/${EGIT_COMMIT}.tar.gz
		-> ${P}.tar.gz"
inherit gac
RESTRICT="mirror"
S="${WORKDIR}/${PN}-${PV}"

src_prepare() {
	default
	dotnet_copy_sources
}

src_compile() {
	compile_impl() {
		exbuild ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" \
			Lidgren.Network.sln
	}
	dotnet_foreach_impl compile_impl
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")
	install_impl() {
		dotnet_install_loc
		egacinstall "Lidgren.Network/bin/${mydebug}/Lidgren.Network.dll"
		doins Lidgren.Network/bin/${mydebug}/Lidgren.Network.dll
		if use developer ; then
		  doins \
			  Lidgren.Network/bin/${mydebug}/Lidgren.Network.dll.mdb
		  dotnet_distribute_file_matching_dll_in_gac \
			"Lidgren.Network/bin/${mydebug}/Lidgren.Network.dll"
			"Lidgren.Network/bin/${mydebug}/Lidgren.Network.dll.mdb"
		fi
		monodocer \
		 -assembly:"Lidgren.Network/bin/${mydebug}/Lidgren.Network.dll"\
		 -path:en -pretty
		 # todo install doc
	}
	dodoc README.md "LICENSE"
	dotnet_foreach_impl install_impl
        mono_multilib_comply
}
