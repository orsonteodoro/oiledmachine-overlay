# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="OmniSharp based on roslyn workspaces"
HOMEPAGE="http://www.omnisharp.net"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm64"
USE_DOTNET="net472 netcoreapp21 netstandard20"
IUSE="${USE_DOTNET} netcore10 debug"
REQUIRED_USE="|| ( ${USE_DOTNET} )"
SLOT="0"
DIST="debian.8-x64"
#todo pull as internal
#         dev-dotnet/icsharpcode-nrefactory
RDEPEND="dev-dotnet/cecil
         dev-libs/openssl
         dev-libs/icu
         net-misc/curl
         sys-libs/libunwind"
DEPEND="${RDEPEND}
	|| ( dev-dotnet/cli-tools:2.1.105 =dev-dotnet/dotnetcore-sdk-bin-2.1.105 )"
inherit dotnet eutils mono
SRC_URI="https://github.com/OmniSharp/omnisharp-roslyn/archive/v1.34.2.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"
S="${WORKDIR}/${PN}-${PV}"

src_prepare() {
	default
	ewarn "This ebuild is still in development and may not even compile at all."
	sed -i -e "s|\"Microsoft.NETCore.App\": \"1.0.1\"|\"Microsoft.NETCore.App\": {\"version\":\"1.0.1\"}|g" src/OmniSharp/project.json || die
	dotnet_copy_sources
}

src_compile() {
	local mydebug=$(usex debug "Debug" "Release")

	compile_impl() {
		# sandbox erases it between phases
		erestore

		cd "src/OmniSharp"
		if [[ "${EDOTNET}" =~ netcoreapp || "${EDOTNET}" =~ netstandard ]] ; then
			exbuild --configuration ${mydebug} --runtime ${DIST}
		fi
		if [[ "${EDOTNET}" == "net46" ]] ; then
			exbuild --configuration ${mydebug} --runtime ${DIST}
		fi
	}

	dotnet_foreach_impl compile_impl
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")

	install_impl() {
		local d
		if [[ "${EDOTNET}" =~ netcoreapp ]] ; then
			d=$(dotnet_netcore_install_loc ${EDOTNET})
		elif dotnet_is_netfx "${EDOTNET}" ; then
			d=$(dotnet_netfx_install_loc ${EDOTNET})
		fi
		insinto "${d}"

		if [[ "${EDOTNET}" == "netcoreapp10" ]] ; then
			FW="netcoreapp1.0"
			mkdir -p "${D}/usr/$(get_libdir)/mono/${PN}/${FW}"
			cp -a src/OmniSharp/bin/Release/${FW}/${DIST}/publish/* "${D}/usr/$(get_libdir)/mono/${PN}/${FW}"
			chmod +x "${D}/usr/$(get_libdir)/mono/${PN}/${FW}/OmniSharp"
		fi
		if [[ "${EDOTNET}" == "net46" ]] ; then
			FW="net46"
			mkdir -p "${D}/usr/$(get_libdir)/mono/${PN}/${FW}"
			cp -a src/OmniSharp/bin/Release/${FW}/${DIST}/publish/* "${D}/usr/$(get_libdir)/mono/${PN}/${FW}"
			chmod +x "${D}/usr/$(get_libdir)/mono/${PN}/${FW}/OmniSharp.exe"
		fi
	}

	dotnet_foreach_impl install_impl

	dotnet_multilib_comply
}
