# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils mono gac

DESCRIPTION="Farseer Physics Engine is a collision detection system with realistic physics responses."
HOMEPAGE=""
PROJECT_NAME="Farseer Physics Engine"
SRC_URI=""

LICENSE="Ms-PL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
PROJECT_FEATURES="monogame standalone"
IUSE="${USE_DOTNET} debug +gac ${PROJECT_FEATURES}"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac || ( ${PROJECT_FEATURES} )"

RDEPEND=">=dev-lang/mono-4
         monogame? ( games-engines/monogame )"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
"

S="${WORKDIR}/${PN}-${PV}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

pkg_setup() {
	wget --continue --user-agent="Mozilla/5.0 (X11; Linux i686 on x86_64; rv:45.0) Gecko/20100101 Firefox/45.0" -O "${DISTDIR}/${P}.zip" "http://download-codeplex.sec.s-msft.com/Download/Release?ProjectName=farseerphysics&DownloadId=722118&FileTime=130220195642030000&Build=21031"
	dotnet_pkg_setup
}

src_unpack() {
	cd "${WORKDIR}"
	cp "${DISTDIR}/${P}.zip" "${WORKDIR}"
	unzip "${P}.zip"
	mv 'Farseer Physics Engine 3.5' "${PN}-${PV}"
}

src_prepare() {
	eapply "${FILESDIR}/farseer-physics-engine-3.5-refs.patch"
	sed -i -r -e "s|<TargetFrameworkProfile>Client</TargetFrameworkProfile>||g" 'Farseer Physics MonoGame.csproj' || die

	egenkey

	eapply_user
}

src_compile() {
	mydebug="release"
	if use debug; then
		mydebug="debug"
	fi
	cd "${S}"

        einfo "Building solution"
	if use standalone ; then
	        exbuild_strong /p:Configuration=${mydebug} 'Farseer Physics.csproj' || die
	fi
	if use monogame ; then
	        exbuild_strong /p:Configuration=${mydebug} 'Farseer Physics MonoGame.csproj' || die
	fi
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
		if use standalone ; then
	                egacinstall "${S}/bin/Release/FarseerPhysics.dll"
	               	insinto "/usr/$(get_libdir)/mono/${PN}"
			use developer && doins "${S}/bin/Release"/{FarseerPhysics.dll.mdb,FarseerPhysics.XML}
		fi
		if use monogame ; then
	                egacinstall "${S}/bin/WindowsGL/Release/FarseerPhysics MonoGame.dll"
	               	insinto "/usr/$(get_libdir)/mono/${PN}"
			use developer && doins "${S}/bin/WindowsGL/Release/FarseerPhysics MonoGame.dll.mdb"
		fi
        done

	eend

	dotnet_multilib_comply
}
