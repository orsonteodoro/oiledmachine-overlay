# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit mono-env eutils git-r3 mono gac

DESCRIPTION="NVorbis is a C# vorbis decoder"
HOMEPAGE=""
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug opentk +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"

RDEPEND=">=dev-lang/mono-4"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
"

RESTRICT="fetch"

S="${WORKDIR}/${PN}-${PV}"

src_unpack() {
        #EGIT_CHECKOUT_DIR="${WORKDIR}"
        EGIT_REPO_URI="https://github.com/ioctlLR/NVorbis.git"
        EGIT_BRANCH="master"
        EGIT_COMMIT="0d40b48a48c4f87bb18b3593e7db0dab74dbb829"
        git-r3_fetch
        git-r3_checkout

}

src_prepare() {
	eapply "${FILESDIR}/nvorbis-9999.20160922-opentksupport.patch"
	eapply "${FILESDIR}/nvorbis-9999.20160922-nuget.patch"
	eapply "${FILESDIR}/nvorbis-9999.20160922-unittests.patch"
	eapply "${FILESDIR}/nvorbis-9999.20160922-unittests-ref.patch"
	eapply "${FILESDIR}/nvorbis-9999.20160922-testapp.patch"
	eapply "${FILESDIR}/nvorbis-9999.20160922-disable-testapp.patch"

	genkey

	eapply_user
}

src_compile() {
	mydebug="release"
	if use debug; then
		mydebug="debug"
	fi
	cd "${S}"

	sed -i -e "s|<TargetFrameworkVersion>v3.5</TargetFrameworkVersion>|<TargetFrameworkVersion>v4.5</TargetFrameworkVersion>|g" ./NVorbis/NVorbis.csproj
	sed -i -e "s|<TargetFrameworkVersion>v3.5</TargetFrameworkVersion>|<TargetFrameworkVersion>v4.5</TargetFrameworkVersion>|g" ./TestHarness/TestHarness.csproj
	sed -i -e "s|<TargetFrameworkVersion>v4.0</TargetFrameworkVersion>|<TargetFrameworkVersion>v4.0</TargetFrameworkVersion>|g" ./TestApp/TestApp.csproj
	sed -i -e "s|net40-Client|net45-Client|g" ./TestApp/packages.config

        einfo "Building solution"
        xbuild /p:Configuration=${mydebug} /p:SignAssembly=true /p:AssemblyOriginatorKeyFile="${S}/${PN}-keypair.snk" NVorbis.sln || die
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

        ebegin "Installing dlls into the GAC"

	for x in ${USE_DOTNET} ; do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
                egacinstall "${S}/bin/NVorbis.dll"
        done

	if use opentk ; then
		for x in ${USE_DOTNET} ; do
	                FW_UPPER=${x:3:1}
        	        FW_LOWER=${x:4:1}
	                egacinstall "${S}/OpenTKSupport/bin/${mydebug}/NVorbis.OpenTKSupport.dll"
	        done
	fi

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
