# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit mono-env eutils mono git-r3 gac

DESCRIPTION="NVorbis is a C# vorbis decoder"
HOMEPAGE=""
SRC_URI="https://github.com/naudio/NAudio/archive/NAudio_${PV}_Release.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug abi_x86_64 abi_x86_32 abi_x86_x32 +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} )"

RDEPEND=">=dev-lang/mono-4"
DEPEND="${RDEPEND}
"

S="${WORKDIR}/${PN}-${PV}"

src_unpack() {
        #EGIT_CHECKOUT_DIR="${WORKDIR}"
        EGIT_REPO_URI="https://github.com/naudio/NAudio.git"
        EGIT_BRANCH="master"
        EGIT_COMMIT="892df9e82723e12678d2786441697ee52bb6bdd0"
        git-r3_fetch
        git-r3_checkout
}

src_prepare() {
	eapply "${FILESDIR}/naudio-1.8-skip-missing-files.patch"

	FILES=$(grep -l -r -e "<TargetFrameworkVersion>v3.5</TargetFrameworkVersion>")
	for f in $FILES
	do
		einfo "Patching $f..."
		sed -i -e "s|<TargetFrameworkVersion>v3.5</TargetFrameworkVersion>|<TargetFrameworkVersion>v4.5</TargetFrameworkVersion>|g" $f
	done
	sed -i -e "s|\"System\"|\"System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089\"|g" NAudio/NAudio.csproj

	eapply_user
}

src_compile() {
	mydebug="release"
	if use debug; then
		mydebug="debug"
	fi
	cd "${S}"

	myabi="x64"
	if use abi_x86_32; then
		myabi="x32"
	elif use abi_x86_64; then
		myabi="x64"
	fi

        einfo "Building solution"
        xbuild /p:Configuration=${mydebug} /p:SignAssembly=true /p:AssemblyOriginatorKeyFile="${S}/${PN}-keypair.snk"  NAudio.sln || die
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	myabi="x64"
	if use abi_x86_32; then
		myabi="x32"
	elif use abi_x86_64; then
		myabi="x64"
	fi

        ebegin "Installing dlls into the GAC"

	savekey

	#fixme
	cd "${S}/build/gmake/lib/${mydebug}_${myabi}/"
	for FILE in $(ls *.dll)
	do
		for x in ${USE_DOTNET} ; do
        	        FW_UPPER=${x:3:1}
	                FW_LOWER=${x:4:1}
	                egacinstall "${S}/build/gmake/lib/${mydebug}_${myabi}/${FILE}"
	        done
	done

	eend
}

function genkey() {
        einfo "Generating Key Pair"
        cd "${S}"
        sn -k "${PN}-keypair.snk"
}

function savekey() {
	mkdir -p "${D}/usr/share/${PN}/"
	cp "${PN}-keypair.snk" "${D}/usr/share/${PN}/"
}
