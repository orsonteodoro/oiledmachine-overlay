# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils mono gac

DESCRIPTION=""
HOMEPAGE="Dynamic Mocking Framework for .NET"
PROJECT_NAME="rhino-mocks"
COMMIT="b1bd7bed0d17a9422e1f993163764637c5023dda"
SRC_URI="https://github.com/ayende/rhino-mocks/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="BSD-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"

RDEPEND=">=dev-lang/mono-4"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
"

S="${WORKDIR}/${PROJECT_NAME}-${COMMIT}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_prepare() {
	mkdir -p {Rhino.Mocks,Rhino.Mocks.GettingStarted,Rhino.Mocks.Tests,Rhino.Mocks.Tests.Model}/Properties/

	VERSION="3.6.0.0"
	cat "${FILESDIR}"/AssemblyInfo.cs.Rhino.Mocks | sed -r -e "s|@VERSION@|${VERSION}|g" -e "s|@COMMIT@|${COMMIT}|g" > Rhino.Mocks/Properties/AssemblyInfo.cs || die
	cat "${FILESDIR}"/AssemblyInfo.cs.Rhino.Mocks.GettingStarted | sed -r -e "s|@VERSION@|${VERSION}|g" -e "s|@COMMIT@|${COMMIT}|g" > Rhino.Mocks.GettingStarted/Properties/AssemblyInfo.cs || die
	cat "${FILESDIR}"/AssemblyInfo.cs.Rhino.Mocks.Tests | sed -r -e "s|@VERSION@|${VERSION}|g" -e "s|@COMMIT@|${COMMIT}|g" > Rhino.Mocks.Tests/Properties/AssemblyInfo.cs || die
	cat "${FILESDIR}"/AssemblyInfo.cs.Rhino.Mocks.Tests.Model | sed -r -e "s|@VERSION@|${VERSION}|g"  -e "s|@COMMIT@|${COMMIT}|g" > Rhino.Mocks.Tests.Model/Properties/AssemblyInfo.cs || die
	sed -i -r -e "s|<TreatWarningsAsErrors>true</TreatWarningsAsErrors>|<TreatWarningsAsErrors>false</TreatWarningsAsErrors>|g" Rhino.Mocks/Rhino.Mocks.csproj

	egenkey

	eapply_user
}

src_compile() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi
	cd "${S}"

        einfo "Building solution"
        exbuild_strong /p:Configuration=${mydebug} Rhino.Mocks.sln || die
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	esavekey

        ebegin "Installing dlls into the GAC"

	for x in ${USE_DOTNET} ; do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
                egacinstall "${S}/bin/${mydebug}/${PROJECT_NAME}.dll"
        done

	eend

	if use developer ; then
               	insinto "/usr/$(get_libdir)/mono/${PN}"
		doins bin/Release/TheoraPlay-CS.dll.mdb
	fi

       	insinto "/usr/$(get_libdir)/mono/${PN}"
	doins bin/Release/TheoraPlay-CS.dll.config

	dotnet_multilib_comply
}
