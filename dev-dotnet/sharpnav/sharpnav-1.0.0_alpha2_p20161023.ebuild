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
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac? ( net45 ) || ( ${PACKAGE_FEATURES} )"
SLOT="0/${PV}"
RDEPEND="dev-dotnet/gwen-dotnet
	 monogame? ( dev-dotnet/monogame
		     dev-dotnet/nvorbis
                     dev-dotnet/opentk )
         dev-dotnet/newtonsoft-json
	 dev-dotnet/yamldotnet
         dev-util/nunit:3"
DEPEND="${RDEPEND}"
inherit dotnet eutils
SRC_URI=\
"https://github.com/Robmaister/${PROJECT_NAME}/archive/${EGIT_COMMIT}.tar.gz -> \
	 ${P}.tar.gz"
inherit gac
S="${WORKDIR}/${PROJECT_NAME}-${EGIT_COMMIT}"
RESTRICT="mirror"

src_prepare() {
	default
	eapply "${FILESDIR}/${PN}-9999.20161023-refs-1.patch"
	eapply "${FILESDIR}/${PN}-9999.20161023-refs-2.patch"

	#disable for the unit tests
	if use tests ; then
		sed -i -r -e "s|internal|public|g" \
			Source/SharpNav/MathHelper.cs
		sed -i -r -e "s|internal|public|g" \
			Source/SharpNav/Geometry/Distance.cs
		sed -i -r -e "s|internal|public|g" \
			Source/SharpNav/Geometry/Containment.cs
		sed -i -r -e "s|internal|public|g" \
			Source/SharpNav/Geometry/Intersection.cs
		eapply "${FILESDIR}/${PN}-9999.20161023-mathhelper-pi.patch"
		eapply "${FILESDIR}/${PN}-9999.20161023-missing-nunit-ref.patch"
	else
		eapply "${FILESDIR}/${PN}-9999.20161013-no-tests.patch"
	fi

	estrong_assembly_info2 "SharpNav.Tests" "${DISTDIR}/mono.snk" \
		"Source/SharpNav/Properties/AssemblyInfo.cs"
	dotnet_copy_sources
}

src_compile() {
	compile_impl() {
		cd Source
		if use opentk ; then
		        exbuild /p:Configuration="OpenTk" \
				${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" \
				${PROJECT_NAME}.sln || die
			#save it before it cleans it out
			cp -a "${S}/Binaries/SharpNav/OpenTK" "${WORKDIR}"/
		fi
		if use monogame ; then
		        exbuild /p:Configuration="MonoGame" \
				${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" \
				${PROJECT_NAME}.sln || die
			#save it before it cleans it out
			cp -a "${S}/Binaries/SharpNav/MonoGame" "${WORKDIR}"/
		fi
		if use standalone ; then
		        exbuild /p:Configuration="Standalone" \
				${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" \
				${PROJECT_NAME}.sln || die
			#save it before it cleans it out
			cp -a "${S}/Binaries/SharpNav/Standalone" "${WORKDIR}"/
		fi
	}
	dotnet_foreach_impl compile_impl
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")
	install_impl() {
		dotnet_install_loc
		insinto "/usr/$(get_libdir)/mono/${PN}"
		d_base="${d}"
		if use standalone ; then
	                egacinstall "${WORKDIR}/Standalone/SharpNav.dll" \
				"${PN}/Standalone"
			insinto "${d_base}/Standalone"
			doins "${WORKDIR}/Standalone/SharpNav.dll"
			if use developer ; then
				doins "${WORKDIR}/Standalone/SharpNav.dll.mdb"
				doins "${WORKDIR}/Standalone/SharpNav.XML"
				dotnet_distribute_file_matching_dll_in_gac \
					"${WORKDIR}/Standalone/SharpNav.dll" \
					"${WORKDIR}/Standalone/SharpNav.dll.mdb"
				dotnet_distribute_file_matching_dll_in_gac \
					"${WORKDIR}/Standalone/SharpNav.dll" \
					"${WORKDIR}/Standalone/SharpNav.XML"
			fi
			if use extras ; then
				insinto "${d_base}/bin"
				doins \
			"Binaries/Clients/GUI/Standalone/SharpNavGUI.exe"
				doins \
			"Binaries/Clients/CLI/Standalone/SharpNav.exe"
			fi
		fi
		if use opentk ; then
			egacinstall "${WORKDIR}/OpenTK/SharpNav.dll" "${PN}/OpenTK"
			insinto "${d_base}/OpenTK"
			doins "${WORKDIR}/OpenTK/SharpNav.dll"
			if use developer ; then
				doins "${WORKDIR}/OpenTK/SharpNav.dll.mdb"
				doins "${WORKDIR}/OpenTK/SharpNav.XML"
				dotnet_distribute_file_matching_dll_in_gac \
					"${WORKDIR}/OpenTK/SharpNav.dll" \
					"${WORKDIR}/OpenTK/SharpNav.dll.mdb"
				dotnet_distribute_file_matching_dll_in_gac \
					"${WORKDIR}/OpenTK/SharpNav.dll" \
					"${WORKDIR}/OpenTK/SharpNav.XML"
			fi
		fi
		if use monogame ; then
			egacinstall "${WORKDIR}/MonoGame/SharpNav.dll" "${PN}/MonoGame"
			insinto "${d_base}/MonoGame"
			doins "${WORKDIR}/MonoGame/SharpNav.dll"
			if use developer ; then
				doins "${WORKDIR}/MonoGame/SharpNav.dll.mdb"
				doins "${WORKDIR}/MonoGame/SharpNav.XML"
				dotnet_distribute_file_matching_dll_in_gac \
					"${WORKDIR}/MonoGame/SharpNav.dll" \
					"${WORKDIR}/MonoGame/SharpNav.dll.mdb"
				dotnet_distribute_file_matching_dll_in_gac \
					"${WORKDIR}/MonoGame/SharpNav.dll" \
					"${WORKDIR}/MonoGame/SharpNav.XML"
			fi
		fi
	}
	dotnet_foreach_impl install_impl
	dotnet_multilib_comply
}

pkg_postinst() {
	einfo "The standalone dll is placed in the gac but the other"
	einfo "(MonoGame and OpenTK) dlls have been placed outside the gac"
}
