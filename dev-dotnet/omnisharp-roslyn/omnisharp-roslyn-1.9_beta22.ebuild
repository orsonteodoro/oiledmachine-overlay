# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils mono

DESCRIPTION="OmniSharp based on roslyn workspaces"
HOMEPAGE="http://www.omnisharp.net"
PROJECT_NAME="omnisharp-roslyn"
SRC_URI="https://github.com/OmniSharp/omnisharp-roslyn/archive/${PV//_/-}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
USE_DOTNET="net46"
IUSE="${USE_DOTNET} netcore10 debug"
REQUIRED_USE="|| ( ${USE_DOTNET} )"
EBF="4.6"
FRAMEWORK="${EBF}"
DIST="debian.8-x64"

RDEPEND=">=dev-lang/mono-4
         dev-dotnet/cecil
         dev-dotnet/icsharpcode-nrefactory
         sys-libs/libunwind
         dev-libs/openssl
         net-misc/curl
         dev-libs/icu"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
"

S="${WORKDIR}/${PROJECT_NAME}-${PV//_/-}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

pkg_setup() {
	if [[ "${FEATURES}" =~ "usersandbox" ]] ; then
		die "You need to add FEATURES=\"-usersandbox\" to your per-package package.env for the dotnet command to work properly.  See https://wiki.gentoo.org/wiki//etc/portage/package.env ."
	else
		true
	fi

	dotnet_pkg_setup
}

src_prepare() {
	mydebug="release"
	if use debug; then
		mydebug="debug"
	fi

	#egenkey

	sed -i -e "s|\"Microsoft.NETCore.App\": \"1.0.1\"|\"Microsoft.NETCore.App\": {\"version\":\"1.0.1\"}|g" src/OmniSharp/project.json

	eapply_user
}

src_compile() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	#should belong in src_unpack but the sandbox erases stuff
	dotnet restore

	cd "${S}/src/OmniSharp"
	if use netcore10 ; then
		dotnet publish --framework netcoreapp1.0 --configuration ${mydebug} --runtime ${DIST}
	fi
	if use net46 ; then
		dotnet publish --framework net46 --configuration ${mydebug} --runtime ${DIST}
	fi
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	#esavekey

	mkdir -p "${D}/usr/$(get_libdir)/mono/${PN}"
	if use netcore10 ; then
		FW="netcoreapp1.0"
		mkdir -p "${D}/usr/$(get_libdir)/mono/${PN}/${FW}"
		cp -a src/OmniSharp/bin/Release/${FW}/${DIST}/publish/* "${D}/usr/$(get_libdir)/mono/${PN}/${FW}"
		chmod +x "${D}/usr/$(get_libdir)/mono/${PN}/${FW}/OmniSharp"
	fi
	if use net46 ; then
		FW="net46"
		mkdir -p "${D}/usr/$(get_libdir)/mono/${PN}/${FW}"
		cp -a src/OmniSharp/bin/Release/${FW}/${DIST}/publish/* "${D}/usr/$(get_libdir)/mono/${PN}/${FW}"
		chmod +x "${D}/usr/$(get_libdir)/mono/${PN}/${FW}/OmniSharp.exe"
	fi

	dotnet_multilib_comply
}
