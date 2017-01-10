# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils mono gac multilib-build multilib-minimal

DESCRIPTION="SFML.Net is a C# language binding for SFML"
HOMEPAGE=""
GIT_USER="SFML"
PROJECT_NAME="SFML.Net"
SRC_URI="https://github.com/${GIT_USER}/${PROJECT_NAME}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="zlib"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac abi_x86_64 abi_x86_32 developer"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"

RDEPEND=">=dev-lang/mono-4
         media-libs/libsfml:0
        "
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
"

S="${WORKDIR}/${PROJECT_NAME}-${PV}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_prepare() {
	egenkey

	eapply_user

	multilib_copy_sources
}

multilib_src_compile() {
	mydebug="release"
	if use debug; then
		mydebug="debug"
	fi

	cd "${S}/build/vc2008"

	myarch="x64"
	if use abi_x86_64 ; then
		myarch="x64"
	fi
	if use abi_x86_32 ; then
		myarch="x86"
	fi

        einfo "Building solution"
        exbuild_strong /p:Configuration=${mydebug} /p:Platform=${myarch} SFML.net.sln || die
}

multilib_src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	myarch="x64"
	if use abi_x86_64 ; then
		myarch="x64"
	fi
	if use abi_x86_32 ; then
		myarch="x86"
	fi

	esavekey

        ebegin "Installing dlls into the GAC"

	for x in ${USE_DOTNET} ; do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
                egacinstall "${S}/lib/${myarch}/sfmlnet-audio-2.dll"
                egacinstall "${S}/lib/${myarch}/sfmlnet-graphics-2.dll"
                egacinstall "${S}/lib/${myarch}/sfmlnet-system-2.dll"
                egacinstall "${S}/lib/${myarch}/sfmlnet-window-2.dll"
		if use developer ; then
			mkdir -p /usr/$(get_libdir)/mono/sfmldotnet/
			insinto /usr/$(get_libdir)/mono/sfmldotnet/
			doins "${S}/lib/${myarch}/sfmlnet-audio-2.dll.mdb"
			doins "${S}/lib/${myarch}/sfmlnet-graphics-2.dll.mdb"
			doins "${S}/lib/${myarch}/sfmlnet-system-2.dll.mdb"
			doins "${S}/lib/${myarch}/sfmlnet-window-2.dll.mdb"
		fi
        done

	eend

	dotnet_multilib_comply
}
