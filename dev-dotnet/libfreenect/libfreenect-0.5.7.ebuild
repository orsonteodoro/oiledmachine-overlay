# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

USE_DOTNET="net35 net45"
RDEPEND="=dev-libs/libfreenect-${PV}"
DEPEND="${RDEPEND}"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac? ( net45 )"

inherit dotnet multilib

DESCRIPTION="Drivers and libraries for the Xbox Kinect device on Windows, Linux, and OS X"
HOMEPAGE="https://github.com/OpenKinect/libfreenect"
LICENSE="|| ( Apache-2.0 GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
SRC_URI="https://github.com/OpenKinect/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

inherit gac

PYTHON_DEPEND="!bindist? 2"
S="${WORKDIR}/${PN}-${PV}"

src_prepare() {
	default

	sed -i -e "s|\"freenect\"|\"libfreenect.dll\"|g" wrappers/csharp/src/lib/KinectNative.cs || die

	estrong_assembly_info "using System.Runtime.CompilerServices;" "${DISTDIR}/mono.snk" "wrappers/csharp/src/test/ConsoleTest/AssemblyInfo.cs"
	estrong_assembly_info "using System.Runtime.CompilerServices;" "${DISTDIR}/mono.snk" "wrappers/csharp/src/lib/AssemblyInfo.cs"

	dotnet_copy_sources
}

src_compile() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	compile_impl() {
		dotnet_copy_dllmap_config "freenectdotnet.dll.config"

		cd "wrappers/csharp/src/lib/VS2010"

	        einfo "Building solution"
	        exbuild /p:Configuration=${mydebug} "freenectdotnet.sln" || die
	}

	dotnet_foreach_impl compile_impl
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	install_impl() {
		dotnet_install_loc
		use developer && doins "wrappers/csharp/bin/freenectdotnet.dll.mdb"

		local wordsize
		wordsize="$(get_libdir)"
		wordsize="${wordsize//lib/}"
		wordsize="${wordsize//[on]/}"

		sed -i -e "s|wordsize=\"[0-9]+\"|wordsize=\"${wordsize}\"|g" freenectdotnet.dll.config || die

                doins freenectdotnet.dll.config
		doins wrappers/csharp/bin/freenectdotnet.dll

		if [[ "${EDOTNET}" == net45 ]]; then
			if use gac ; then
		                egacinstall "wrappers/csharp/bin/freenectdotnet.dll"
			fi
		fi
		dotnet_distribute_dllmap_config "freenectdotnet.dll"
	}

	dotnet_foreach_impl install_impl

	dotnet_multilib_comply
}
