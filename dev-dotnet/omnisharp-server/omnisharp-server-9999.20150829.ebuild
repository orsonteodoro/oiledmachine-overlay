# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils mono gac

DESCRIPTION="HTTP wrapper around NRefactory allowing C# editor plugins to be written in any language. "
HOMEPAGE="http://www.omnisharp.net"
PROJECT_NAME="omnisharp-server"
COMMIT="e1902915c6790bcec00b8d551199c8a3537d33c9"
SRC_URI="https://github.com/OmniSharp/omnisharp-server/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"

RDEPEND=">=dev-lang/mono-4
         dev-dotnet/cecil
         dev-dotnet/icsharpcode-nrefactory"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
"

S="${WORKDIR}/${PROJECT_NAME}-${COMMIT}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_prepare() {
	eapply "${FILESDIR}/${PN}-9999.20150829-refs.patch"

	egenkey

	eapply_user
}

src_compile() {
	cd "${S}/OmniSharp"

        einfo "Building solution"
        exbuild "OmniSharp.csproj" || die
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	esavekey

       	insinto "/usr/$(get_libdir)/mono/${PN}"
	doins ./OmniSharp/bin/${mydebug}/OmniSharp.exe
	doins ./OmniSharp/bin/${mydebug}/Microsoft.Build.Evaluation.dll
	doins ./OmniSharp/bin/${mydebug}/Nancy.Swagger.dll
	doins ./OmniSharp/bin/${mydebug}/monodoc.dll
	doins ./OmniSharp/bin/${mydebug}/Swagger.ObjectModel.dll
	doins ./OmniSharp/bin/${mydebug}/Nancy.Hosting.Self.dll
	doins ./OmniSharp/bin/${mydebug}/Nancy.Metadata.Module.dll
	doins ./OmniSharp/bin/${mydebug}/Nancy.dll
	doins ./OmniSharp/bin/${mydebug}/System.IO.Abstractions.dll
	doins ./OmniSharp/bin/${mydebug}/config.json

	dotnet_multilib_comply
}
