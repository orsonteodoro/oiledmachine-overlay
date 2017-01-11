# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils mono gac

DESCRIPTION="BulletSharp .NET wrapper for the Bullet physics library using Platform Invoke"
HOMEPAGE=""
PROJECT_NAME="BulletSharpPInvoke"
SRC_URI="https://github.com/AndresTraks/${PROJECT_NAME}/archive/0.9.tar.gz -> ${P}.tar.gz"

LICENSE="zlib"
SLOT="0"
KEYWORDS="~amd64"
USE_DOTNET="net45"
PACKAGE_FEATURES="MonoGame Generic OpenTK"
PACKAGE_FEATURES_L="monogame generic opentk"
IUSE="${USE_DOTNET} debug +gac ${PACKAGE_FEATURES_L}"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac || ( ${PACKAGE_FEATURES_L} )"

RDEPEND=">=dev-lang/mono-4
         sci-physics/bullet
         dev-dotnet/clangsharp"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
"

S="${WORKDIR}/${PROJECT_NAME}-${PV}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_prepare() {
	egenkey

	eapply_user
}

src_compile() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi
	cd "${S}/BulletSharpPInvoke"

        einfo "Building solution"
	myplatform="Any CPU"
        exbuild_strong /p:Configuration="${mydebug}" /p:Platform="$myplatform" ${PROJECT_NAME}.sln || die
	cd "${S}/BulletSharpGen"
        exbuild_strong /p:Configuration="${mydebug}" /p:Platform="$myplatform" BulletSharpGen.sln || die
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
