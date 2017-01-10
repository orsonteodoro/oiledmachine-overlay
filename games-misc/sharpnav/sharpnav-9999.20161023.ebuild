# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils mono gac

DESCRIPTION="SharpNav is advanced pathfinding for C#"
HOMEPAGE=""
PROJECT_NAME="SharpNav"
COMMIT="fd2b70e25a8d30a94e1a64629e42a1de8809c431"
SRC_URI="https://github.com/Robmaister/${PROJECT_NAME}/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
PACKAGE_FEATURES="opentk monogame standalone"
IUSE="${USE_DOTNET} debug +gac ${PACKAGE_FEATURES} tests developer extras"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac || ( ${PACKAGE_FEATURES} )"

RDEPEND=">=dev-lang/mono-4
         games-misc/gwen-dotnet
         dev-dotnet/yamldotnet
	 monogame? ( games-engines/monogame
                     dev-dotnet/nvorbis
                     dev-dotnet/opentk )
         dev-dotnet/newtonsoft-json
         dev-util/nunit:3
"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
"

S="${WORKDIR}/${PROJECT_NAME}-${COMMIT}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_prepare() {
	eapply "${FILESDIR}/${PN}-9999.20161023-refs-1.patch"
	eapply "${FILESDIR}/${PN}-9999.20161023-refs-2.patch"

	#disable for the unit tests
	if use tests ; then
		sed -i -r -e "s|internal|public|g" ./Source/SharpNav/MathHelper.cs
		sed -i -r -e "s|internal|public|g" ./Source/SharpNav/Geometry/Distance.cs
		sed -i -r -e "s|internal|public|g" ./Source/SharpNav/Geometry/Containment.cs
		sed -i -r -e "s|internal|public|g" ./Source/SharpNav/Geometry/Intersection.cs
		eapply "${FILESDIR}/${PN}-9999.20161023-mathhelper-pi.patch"
		eapply "${FILESDIR}/${PN}-9999.20161023-missing-nunit-ref.patch"
	else
		eapply "${FILESDIR}/${PN}-9999.20161013-no-tests.patch"
	fi

	egenkey

	if use opentk ; then
		egenkey "${PN}-opentk-keypair.snk"
	fi
	if use monogame ; then
		egenkey "${PN}-monogame-keypair.snk"
	fi
	if use standalone ; then
		egenkey "${PN}-standalone-keypair.snk"
	fi

       	#inject public key into assembly
        public_key=$(sn -tp "${S}/${PN}-keypair.snk" | tail -n 7 | head -n 5 | tr -d '\n')
        echo "pk is: ${public_key}"
        cd "${S}"
	sed -i -r -e "s|\[assembly\: InternalsVisibleTo\(\"SharpNav.Tests\"\)\]|\[assembly: InternalsVisibleTo(\"SharpNav.Tests, PublicKey=${public_key}\")\]|" Source/SharpNav/Properties/AssemblyInfo.cs

	eapply_user
}

src_compile() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	cd "${S}/Source"

        einfo "Building solutions"
	if use opentk ; then
		SNK_FILENAME="${S}/${PN}-opentk-keypair.snk" \
	        exbuild_strong /p:Configuration="OpenTk" ${PROJECT_NAME}.sln || die
		#save it before it cleans it out
		cp -a "${S}/Binaries/SharpNav/OpenTK" "${WORKDIR}"/
	fi
	if use monogame ; then
		SNK_FILENAME="${S}/${PN}-monogame-keypair.snk" \
	        exbuild_strong /p:Configuration="MonoGame" ${PROJECT_NAME}.sln || die
		#save it before it cleans it out
		cp -a "${S}/Binaries/SharpNav/MonoGame" "${WORKDIR}"/
	fi
	if use standalone ; then
		SNK_FILENAME="${S}/${PN}-standalone-keypair.snk" \
	        exbuild_strong /p:Configuration="Standalone" ${PROJECT_NAME}.sln || die
		#save it before it cleans it out
		cp -a "${S}/Binaries/SharpNav/Standalone" "${WORKDIR}"/
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
               	insinto "/usr/$(get_libdir)/mono/${PN}"
		if use standalone ; then
	                egacinstall "${WORKDIR}/Standalone/SharpNav.dll" "${PN}/Standalone"
			use developer && doins "${WORKDIR}/Standalone/SharpNav.dll.mdb"
			use developer && doins "${WORKDIR}/Standalone/SharpNav.XML"
			esavekey "${S}/${PN}-standalone-keypair.snk"
		fi
		#they override the dll in the gac so standalone is the default gac
		if use opentk ; then
			egacinstall "${WORKDIR}/OpenTK/SharpNav.dll" "${PN}/OpenTK"
			use developer && doins "${WORKDIR}/OpenTK/SharpNav.dll.mdb"
			use developer && doins "${WORKDIR}/OpenTK/SharpNav.XML"
			esavekey "${S}/${PN}-opentk-keypair.snk"
		fi
		if use monogame ; then
			egacinstall "${WORKDIR}/MonoGame/SharpNav.dll" "${PN}/MonoGame"
			use developer && doins "${WORKDIR}/MonoGame/SharpNav.dll.mdb"
			use developer && doins "${WORKDIR}/MonoGame/SharpNav.XML"
			esavekey "${S}/${PN}-monogame-keypair.snk"
		fi
        done

	eend

	if use standalone ; then
		dest="${D}/usr/$(get_libdir)/mono/${PN}/Standalone"
		mkdir -p "${dest}"
		use developer && cp "${WORKDIR}/Standalone/SharpNav.dll.mdb" "${dest}/SharpNav.dll.mdb"
		use developer && cp "${WORKDIR}/Standalone/SharpNav.XML" "${dest}/SharpNav.XML"

		if use extras ; then
			mkdir -p "${D}/usr/lib/mono/${PN}/${EBF}/"
			cp -a "Binaries/Clients/GUI/Standalone/SharpNavGUI.exe" "${D}/usr/lib/mono/${PN}/${EBF}/"
			cp -a "Binaries/Clients/CLI/Standalone/SharpNav.exe" "${D}/usr/lib/mono/${PN}/${EBF}/"
		fi
	fi
	if use opentk ; then
		dest="${D}/usr/$(get_libdir)/mono/${PN}/OpenTK"
		mkdir -p "${dest}"
		use developer && cp "${WORKDIR}/OpenTK/SharpNav.dll.mdb" "${dest}/SharpNav.dll.mdb"
		use developer && cp "${WORKDIR}/OpenTK/SharpNav.XML" "${dest}/SharpNav.XML"
	fi
	if use monogame ; then
		dest="${D}/usr/$(get_libdir)/mono/${PN}/MonoGame"
		mkdir -p "${dest}"
		use developer && cp "${WORKDIR}/MonoGame/SharpNav.dll.mdb" "${dest}/SharpNav.dll.mdb"
		use developer && cp "${WORKDIR}/MonoGame/SharpNav.XML" "${dest}/SharpNav.XML"
	fi

	if use developer ; then
               	insinto "/usr/$(get_libdir)/mono/${PN}"
		doins Source/SharpNav.GUI/SharpNav.GUI.snk
		doins Source/SharpNav/SharpNav.snk
		doins Source/SharpNav/SharpNav.OpenTK.snk
		doins Source/SharpNav.CLI/SharpNav.CLI.snk
	fi

	dotnet_multilib_comply
}

pkg_postinst() {
	einfo "The standalone dll is placed in the gac but the other (MonoGame and OpenTK) dlls have been placed outside the gac"
}
