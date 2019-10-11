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

src_unpack() {
	unpack "${A}"
}

src_prepare() {
	eapply "${FILESDIR}/fna-17.01-no-compile-libs.patch"
	eapply "${FILESDIR}/fna-17.01-refs.patch"

	eapply_user

	#inject public key into assembly
	public_key=$(sn -tp "${DISTDIR}/mono.snk" | tail -n 7 | head -n 5 | tr -d '\n')
	echo "pk is: ${public_key}"
	cd "${S}" || die
	sed -i -r -e "s|\[assembly\: InternalsVisibleTo\(\"MonoGame.Framework.Content.Pipeline\"\)\]|\[assembly: InternalsVisibleTo(\"MonoGame.Framework.Content.Pipeline, PublicKey=${public_key}\")\]|" src/Properties/AssemblyInfo.cs || die
	sed -i -r -e "s|\[assembly\: InternalsVisibleTo\(\"MonoGame.Framework.Net\"\)\]|\[assembly: InternalsVisibleTo(\"MonoGame.Framework.Net, PublicKey=${public_key}\")\]|" src/Properties/AssemblyInfo.cs || die
}

src_compile() {
	exbuild ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" /t:Build FNA.sln || die
}

src_install() {
	local mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

        ebegin "Installing dlls into the GAC"
	cd "${S}"

	for x in ${USE_DOTNET} ; do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
                egacinstall "${S}/bin/${mydebug}/FNA.dll"
        done
	eend

	if use developer ; then
		insinto "/usr/$(get_libdir)/mono/${PN}"
		doins bin/${mydebug}/FNA.dll.mdb
	fi

	insinto "/usr/$(get_libdir)/mono/${PN}"
	doins bin/${mydebug}/FNA.dll.config

	dotnet_multilib_comply
}
