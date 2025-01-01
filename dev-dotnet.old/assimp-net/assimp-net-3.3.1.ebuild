# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="AssimpNet is a C# language binding to the Assimp library"
HOMEPAGE="https://github.com/assimp/assimp-net"
LICENSE="BSD MIT ASSIMPNET"
KEYWORDS="~amd64 ~arm64 ~x86"
USE_DOTNET="net20 net45"
IUSE="${USE_DOTNET} debug doc gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac? ( net45 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
inherit dotnet
SRC_URI="https://github.com/assimp/assimp-net/archive/${PV}.tar.gz \
		-> ${P}.tar.gz"
inherit gac
SLOT="0/$(ver_cut 1-2 ${PV})"
S="${WORKDIR}/assimp-net-${PV}"
RESTRICT="mirror"

src_prepare() {
	default
	eapply "${FILESDIR}/assimpnet-3.3.1-call-interop-generator-with-mono.patch"
	dotnet_copy_sources
	prepare_impl() {
		sed -i -e "s|\"Assimp32.so\"|\"libassimp.so\"|g" \
			AssimpNet/Unmanaged/AssimpLibrary.cs || die
		sed -i -e "s|\"Assimp64.so\"|\"libassimp.so\"|g" \
			AssimpNet/Unmanaged/AssimpLibrary.cs || die
	}
	dotnet_foreach_impl prepare_impl
}

_use_flag_to_configuration() {
	local moniker="$1"
	local mydebug=$(usex debug "Debug" "Release")
	case ${moniker} in
		net20) echo "Net20-${mydebug}" ;;
		net45) echo "Net45-${mydebug}" ;;
	esac
}

src_compile() {
	compile_impl() {
		exbuild \
		  ${STRONG_ARGS_NETFX}"${BUILD_DIR}/AssimpNet/AssimpKey.snk" \
	  AssimpNet.Interop.Generator/AssimpNet.Interop.Generator.csproj || die
		exbuild \
		  ${STRONG_ARGS_NETFX}"${BUILD_DIR}/AssimpNet/AssimpKey.snk" \
		  AssimpNet/AssimpNet.csproj || die
	}
	dotnet_foreach_impl compile_impl
}

src_install() {
	install_impl() {
		dotnet_install_loc
		local c=$(_use_flag_to_configuration "${EDOTNET}")
                egacinstall "AssimpNet/bin/${c}/AssimpNet.dll"
		doins AssimpNet/bin/${c}/AssimpNet.dll
		if use developer ; then
			doins AssimpNet/bin/${c}/AssimpNet.XML
			dotnet_distribute_file_matching_dll_in_gac \
				"AssimpNet/bin/${c}/AssimpNet.dll"
				"AssimpNet/bin/${c}/AssimpNet.XML"
		fi
	}
	dotnet_foreach_impl install_impl
	dodoc AssimpNet/AssimpLicense.txt
	use doc && dodoc -r Docs/*
	dotnet_multilib_comply
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
