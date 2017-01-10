# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils mono gac

DESCRIPTION="YamlDotNet is a .NET library for YAML"
HOMEPAGE="http://aaubry.net/pages/yamldotnet.html"
PROJECT_NAME="YamlDotNet"
SRC_URI="https://github.com/aaubry/YamlDotNet/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"

RDEPEND=">=dev-lang/mono-4"
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
	mydebug="Release-Signed"
	if use debug; then
		mydebug="Debug"
	fi
	cd "${S}"

        einfo "Building solution"
        exbuild_strong /p:Configuration="${mydebug}" ${PROJECT_NAME}.sln || die
}

src_install() {
	mydebug="Release-Signed"
	if use debug; then
		mydebug="Debug"
	fi

	esavekey

        ebegin "Installing dlls into the GAC"

	for x in ${USE_DOTNET} ; do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
                egacinstall "${S}/${PROJECT_NAME}/bin/${mydebug}/${PROJECT_NAME}.dll"
        done

	eend

	if use developer ; then
               	insinto "/usr/$(get_libdir)/mono/${PN}"
		doins YamlDotNet.snk
		doins YamlDotNet/bin/Release-Signed/YamlDotNet.dll.mdb
		doins YamlDotNet/bin/Release-Signed/YamlDotNet.xml
	fi

	dotnet_multilib_comply
}
