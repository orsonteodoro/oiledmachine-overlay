# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="AssimpNet is a C# language binding to the Assimp library"
HOMEPAGE="https://github.com/assimp/assimp-net"
LICENSE="BSD MIT ASSIMPNET"
KEYWORDS="~amd64 ~arm64 ~x86"
USE_DOTNET="net20 net452"
IUSE="${USE_DOTNET} debug doc gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac? ( net452 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
inherit dotnet eutils nupkg
COMMIT="9002f2b5eb2d096b880c61714c26a3924254489e"
SRC_URI="https://github.com/assimp/assimp-net/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
inherit gac
SLOT="0"
S="${WORKDIR}/assimp-net-${COMMIT}"
RESTRICT="mirror"

src_prepare() {
	default

	eapply "${FILESDIR}/assimpnet-3.3.1-call-interop-generator-with-mono.patch"

	dotnet_copy_sources

	prepare_impl() {
		sed -i -e "s|\"Assimp32.so\"|\"libassimp.so\"|g" AssimpNet/Unmanaged/AssimpLibrary.cs || die
		sed -i -e "s|\"Assimp64.so\"|\"libassimp.so\"|g" AssimpNet/Unmanaged/AssimpLibrary.cs || die
		enuget_restore "AssimpNet.sln"
	}

	dotnet_foreach_impl prepare_impl
}

_use_flag_to_configuration() {
	local moniker="$1"
	local mydebug
	if use debug ; then
		mydebug="Debug"
	else
		mydebug="Release"
	fi
	case ${moniker} in
		net20) echo "Net20-${mydebug}" ;;
		net452) echo "Net45-${mydebug}" ;;
	esac
}

src_compile() {
	compile_impl() {
		local c=$(_use_flag_to_configuration "${EDOTNET}")
		exbuild /p:Configuration=${c} ${STRONG_ARGS_NETFX}"${BUILD_DIR}/AssimpNet/AssimpKey.snk" AssimpNet.Interop.Generator/AssimpNet.Interop.Generator.csproj || die
		exbuild /p:Configuration=${c} ${STRONG_ARGS_NETFX}"${BUILD_DIR}/AssimpNet/AssimpKey.snk" AssimpNet/AssimpNet.csproj || die
	}

	dotnet_foreach_impl compile_impl
}

src_install() {
	install_impl() {
		dotnet_install_loc
		local c=$(_use_flag_to_configuration "${EDOTNET}")

		doins AssimpNet/bin/${c}/AssimpNet.dll
		use developer && doins AssimpNet/bin/${c}/AssimpNet.XML

		local loc=$(dotnet_netfx_install_loc ${EDOTNET})

                egacinstall "AssimpNet/bin/${c}/AssimpNet.dll"
	}

	dotnet_foreach_impl install_impl

	dodoc "${S}/AssimpNet/AssimpLicense.txt"
	use doc && dodoc -r "${S}/Docs"/*

	dotnet_multilib_comply
}
