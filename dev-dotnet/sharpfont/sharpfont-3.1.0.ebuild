# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils mono gac

DESCRIPTION="SharpFont"
HOMEPAGE="https://github.com/Robmaister/SharpFont"
SRC_URI="https://github.com/Robmaister/SharpFont/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"

RDEPEND=">=dev-lang/mono-4"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
	virtual/pkgconfig
"

S="${WORKDIR}/SharpFont-${PV}"

src_prepare() {
	egenkey

	eapply_user
}

src_compile() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi
	cd "${S}/Source/SharpFont"
	xbuild SharpFont.csproj /p:Configuration=${mydebug} /p:SignAssembly=true /p:AssemblyOriginatorKeyFile="${S}/${PN}-keypair.snk" || die
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

        ebegin "Installing dlls into the GAC"

	if use developer ; then
		esavekey
               	insinto "/usr/$(get_libdir)/mono/${PN}"
		doins Source/SharpFont/SharpFont.snk
	fi

	for x in ${USE_DOTNET} ; do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
                egacinstall "${S}/Binaries/SharpFont/${mydebug}/SharpFont.dll"
               	insinto "/usr/$(get_libdir)/mono/${PN}"
		use developer && doins "${S}/Binaries/SharpFont/${mydebug}/SharpFont.dll.mdb"
        done

	eend

       	insinto "/usr/$(get_libdir)/mono/${PN}"
	doins Binaries/SharpFont/${mydebug}/SharpFont.dll.config

	cd "${S}"
	dodoc README.md "LICENSE"

	dotnet_multilib_comply
}
