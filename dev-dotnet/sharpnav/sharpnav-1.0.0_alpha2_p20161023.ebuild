# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="SharpNav is advanced pathfinding for C#"
HOMEPAGE="http://sharpnav.com"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
PROJECT_NAME="SharpNav"
EGIT_COMMIT="fd2b70e25a8d30a94e1a64629e42a1de8809c431"
USE_DOTNET="net45"
PACKAGE_FEATURES="monogame opentk standalone"
IUSE="${USE_DOTNET} debug +gac ${PACKAGE_FEATURES} tests developer extras"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac gac? ( net45 ) || ( ${PACKAGE_FEATURES} )"
SLOT="0"
RDEPEND="dev-dotnet/gwen-dotnet
	 monogame? ( dev-dotnet/monogame
		     dev-dotnet/nvorbis
                     dev-dotnet/opentk )
         dev-dotnet/newtonsoft-json
	 dev-dotnet/yamldotnet
         dev-util/nunit:3"
DEPEND="${RDEPEND}"
inherit dotnet eutils mono
SRC_URI="https://github.com/Robmaister/${PROJECT_NAME}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
inherit gac
S="${WORKDIR}/${PROJECT_NAME}-${EGIT_COMMIT}"
RESTRICT="mirror"

src_prepare() {
	default
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

	#inject public key into assembly
        public_key=$(sn -tp "${DISTDIR}/mono.snk" | tail -n 7 | head -n 5 | tr -d '\n')
        echo "pk is: ${public_key}"
        cd "${S}" || die
	sed -i -r -e "s|\[assembly\: InternalsVisibleTo\(\"SharpNav.Tests\"\)\]|\[assembly: InternalsVisibleTo(\"SharpNav.Tests, PublicKey=${public_key}\")\]|" Source/SharpNav/Properties/AssemblyInfo.cs || die
}

src_compile() {
	cd "${S}/Source"

        einfo "Building solutions"
	if use opentk ; then
	        exbuild /p:Configuration="OpenTk" ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" ${PROJECT_NAME}.sln || die
		#save it before it cleans it out
		cp -a "${S}/Binaries/SharpNav/OpenTK" "${WORKDIR}"/
	fi
	if use monogame ; then
	        exbuild /p:Configuration="MonoGame" ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" ${PROJECT_NAME}.sln || die
		#save it before it cleans it out
		cp -a "${S}/Binaries/SharpNav/MonoGame" "${WORKDIR}"/
	fi
	if use standalone ; then
	        exbuild /p:Configuration="Standalone" ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" ${PROJECT_NAME}.sln || die
		#save it before it cleans it out
		cp -a "${S}/Binaries/SharpNav/Standalone" "${WORKDIR}"/
	fi
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")

        ebegin "Installing dlls into the GAC"

	for x in ${USE_DOTNET} ; do
		FW_UPPER=${x:3:1}
		FW_LOWER=${x:4:1}
		insinto "/usr/$(get_libdir)/mono/${PN}"
		if use standalone ; then
	                egacinstall "${WORKDIR}/Standalone/SharpNav.dll" "${PN}/Standalone"
			use developer && doins "${WORKDIR}/Standalone/SharpNav.dll.mdb"
			use developer && doins "${WORKDIR}/Standalone/SharpNav.XML"
		fi
		#they override the dll in the gac so standalone is the default gac
		if use opentk ; then
			egacinstall "${WORKDIR}/OpenTK/SharpNav.dll" "${PN}/OpenTK"
			use developer && doins "${WORKDIR}/OpenTK/SharpNav.dll.mdb"
			use developer && doins "${WORKDIR}/OpenTK/SharpNav.XML"
		fi
		if use monogame ; then
			egacinstall "${WORKDIR}/MonoGame/SharpNav.dll" "${PN}/MonoGame"
			use developer && doins "${WORKDIR}/MonoGame/SharpNav.dll.mdb"
			use developer && doins "${WORKDIR}/MonoGame/SharpNav.XML"
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
