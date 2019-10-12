# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Farseer Physics Engine is a collision detection system with realistic physics responses."
HOMEPAGE="https://archive.codeplex.com/?p=farseerphysics"
PROJECT_NAME="Farseer Physics Engine"
LICENSE="Ms-PL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net40"
PROJECT_FEATURES="monogame standalone"
IUSE="${USE_DOTNET} debug +gac hello-world samples test ${PROJECT_FEATURES}"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac gac? ( net40 ) || ( ${PROJECT_FEATURES} )"
RDEPEND="monogame? ( dev-dotnet/monogame )"
DEPEND="${RDEPEND}"
inherit dotnet eutils mono unpacker
SRC_URI="https://codeplexarchive.blob.core.windows.net/archive/projects/FarseerPhysics/FarseerPhysics.zip -> ${P}.zip"
inherit gac
RESTRICT="mirror"
S="${WORKDIR}/engine/${PROJECT_NAME} ${PV}"
S_HELLO_WORLD="${WORKDIR}/hello_world/${PROJECT_NAME} ${PV} HelloWorld"
S_SAMPLES="${WORKDIR}/samples/${PROJECT_NAME} ${PV} Samples"
S_TESTBED="${WORKDIR}/testbed/${PROJECT_NAME} ${PV} Testbed"

pkg_setup() {
	dotnet_pkg_setup
}

src_unpack() {
	unpack_zip "${DISTFILES}/${P}.zip"

	# engine
	mkdir -p "${WORKDIR}/engine" || die
	pushd "${WORKDIR}/engine" || die
		mv "${WORKDIR}/releases/24/ed22b532-11d9-405b-b6c9-5e29f81e049e"{,.zip}
		unpack "${WORKDIR}/releases/24/ed22b532-11d9-405b-b6c9-5e29f81e049e.zip"
	popd
	if use test ; then
		# testbed
		mkdir -p "${WORKDIR}/testbed" || die
		pushd "${WORKDIR}/testbed" || die
			mv "${WORKDIR}/releases/24/d03768cc-c5f0-426c-81f8-85e36199c04b"{,.zip}
			unpack "${WORKDIR}/releases/24/d03768cc-c5f0-426c-81f8-85e36199c04b.zip"
		popd
	fi
	if use hello-world ; then
		# hello world
		mkdir -p "${WORKDIR}/hello_world" || die
		pushd "${WORKDIR}/hello_world" || die
			mv "${WORKDIR}/releases/24/3962ccc9-4e44-4d26-8a9c-0e4c7fb59c0e"{,.zip}
			unpack "${WORKDIR}/releases/24/3962ccc9-4e44-4d26-8a9c-0e4c7fb59c0e.zip"
		popd
	fi
	if use samples ; then
		# samples
		mkdir -p "${WORKDIR}/samples" || die
		pushd "${WORKDIR}/samples" || die
			mv "${WORKDIR}/releases/24/79f71d45-73f5-433f-b79b-3d0ad4425bf9"{,.zip}
			unpack "${WORKDIR}/releases/24/79f71d45-73f5-433f-b79b-3d0ad4425bf9.zip"
		popd
	fi
}

src_prepare() {
	default
	eapply "${FILESDIR}/farseer-physics-engine-3.5-refs.patch"
	sed -i -r -e "s|<TargetFrameworkProfile>Client</TargetFrameworkProfile>||g" 'Farseer Physics MonoGame.csproj' || die
}

src_compile() {
	local mydebug=$(usex debug "debug" "release")
	if use standalone ; then
	        exbuild /p:Configuration=${mydebug} ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" 'Farseer Physics.csproj' || die
	fi
	if use monogame ; then
	        exbuild /p:Configuration=${mydebug} ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" 'Farseer Physics MonoGame.csproj' || die
	fi
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")

	ebegin "Installing dlls into the GAC"

	for x in ${USE_DOTNET} ; do
		FW_UPPER=${x:3:1}
		FW_LOWER=${x:4:1}
		if use standalone ; then
			egacinstall "bin/${mydebug}/FarseerPhysics.dll"
			insinto "/usr/$(get_libdir)/mono/${PN}"
			use developer && doins "bin/${mydebug}"/{FarseerPhysics.dll.mdb,FarseerPhysics.XML}
		fi
		if use monogame ; then
			egacinstall "bin/WindowsGL/${mydebug}/FarseerPhysics MonoGame.dll"
			insinto "/usr/$(get_libdir)/mono/${PN}"
			use developer && doins "bin/WindowsGL/${mydebug}/FarseerPhysics MonoGame.dll.mdb"
		fi
	done

	eend

	if use samples ; then
		insinto /usr/share/${PN}-${PV}/samples
		doins -r "${S_SAMPLES}"/*
		einfo "The samples has been installed in /usr/share/${PN}-${PV}/samples"
	fi
	if use hello-world ; then
		insinto /usr/share/${PN}-${PV}/hello-world
		doins -r "${S_HELLO_WORLD}"/*
		einfo "The hello-world has been installed in /usr/share/${PN}-${PV}/hello-world"
	fi

	dotnet_multilib_comply
}
