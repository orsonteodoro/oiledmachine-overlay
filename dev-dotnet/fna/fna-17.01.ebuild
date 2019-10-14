# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="FNA is open source XNA4"
HOMEPAGE="http://fna-xna.github.io/"
LICENSE="Ms-PL MIT GPL-2 LGPL-2.1"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"
RDEPEND="  dev-dotnet/mojoshader-cs
           dev-dotnet/openal-cs
         >=dev-dotnet/sdl2-cs-9999.20161111
	  <dev-dotnet/sdl2-cs-9999.20171216
           dev-dotnet/theoraplay-cs
         >=dev-dotnet/vorbisfile-cs-9999.20151108
          <dev-dotnet/vorbisfile-cs-9999.20170415"
DEPEND="${RDEPEND}"
SLOT="0"
inherit dotnet eutils mono multilib-build
SRC_URI="https://github.com/FNA-XNA/FNA/archive/${PV}.tar.gz -> ${P}.tar.gz"
inherit gac
S="${WORKDIR}/FNA-${PV}"
RESTRICT="mirror"

src_prepare() {
	default
	eapply "${FILESDIR}/fna-17.01-no-compile-libs.patch"
	eapply "${FILESDIR}/fna-17.01-refs.patch"
	estrong_assembly_info2 "MonoGame.Framework.Content.Pipeline" "${DISTDIR}/mono.snk" "src/Properties/AssemblyInfo.cs"
	estrong_assembly_info2 "MonoGame.Framework.Net" "${DISTDIR}/mono.snk" "src/Properties/AssemblyInfo.cs"
	dotnet_copy_sources
}

src_compile() {
	compile_impl() {
		exbuild ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" /t:Build FNA.sln || die
	}
	dotnet_foreach_impl compile_impl
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")
	install_impl() {
		dotnet_install_loc

		if dotnet_is_netfx ; then
	                egacinstall bin/${mydebug}/FNA.dll
		fi

		doins bin/${mydebug}/FNA.dll

		if use developer ; then
			doins bin/${mydebug}/FNA.dll.mdb
		fi

		doins bin/${mydebug}/FNA.dll.config
	}
	dotnet_foreach_impl install_impl
	dotnet_multilib_comply
}
