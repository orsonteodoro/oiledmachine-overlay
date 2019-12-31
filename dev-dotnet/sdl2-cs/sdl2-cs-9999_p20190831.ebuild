# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="SDL2-CS is a C# wrapper for SDL2"
HOMEPAGE="https://github.com/flibitijibibo/SDL2-CS"
LICENSE="zlib"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"
USE_DOTNET="net461 netstandard20"
IUSE="${USE_DOTNET} debug gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac? ( net461 )"
RDEPEND=">=media-libs/libsdl2-2.0.7
         media-libs/sdl2-ttf
         media-libs/sdl2-mixer"
DEPEND="${RDEPEND}"
inherit dotnet eutils mono
PROJECT_NAME="${PN^^}"
EGIT_COMMIT="499ad108b93f28c7a8aa2f357206ddc98980614e"
SRC_URI="\
https://github.com/flibitijibibo/${PROJECT_NAME}/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
inherit gac
RESTRICT="mirror"
S="${WORKDIR}/${PROJECT_NAME}-${EGIT_COMMIT}"

src_prepare() {
	default
	dotnet_copy_sources
}

src_compile() {
	local mydebug=$(usex debug "debug" "release")
	compile_impl() {
		if [[ "${EDOTNET}" =~ netcore \
			|| "${EDOTNET}" =~ netstandard ]] ; then
		        exbuild ${STRONG_ARGS_NETCORE}"${DISTDIR}/mono.snk" \
			  -p:Configuration=${mydebug} \
			  ${PROJECT_NAME}.Core.csproj || die
		else
		        exbuild ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" \
			  /p:Configuration=${mydebug} \
			  ${PROJECT_NAME}.csproj || die
		fi
		dotnet_copy_dllmap_config \
			"${FILESDIR}/${PROJECT_NAME}.dll.config"
	}
	dotnet_foreach_impl compile_impl
}

src_install() {
	install_impl() {
		local mydebug=$(usex debug "Debug" "Release")
		if [[ "${EDOTNET}" =~ netstandard ]] ; then
			mydebug="${mydebug,,}"
		fi
		dotnet_install_loc
		if [[ "${EDOTNET}" =~ netstandard ]] ; then
			local pnc=\
	"bin/${mydebug}/$(dotnet_use_flag_moniker_to_ms_moniker ${ENETCORE})"
			doins ${pnc}/${PROJECT_NAME}.dll
			doins ${PROJECT_NAME}.dll.config
			doins ${pnc}/${PROJECT_NAME}.deps.json
			doins ${pnc}/${PROJECT_NAME}.pdb
		elif dotnet_is_netfx "${EDOTNET}" ; then
			estrong_resign "bin/${mydebug}/${PROJECT_NAME}.dll" \
				"${DISTDIR}/mono.snk"
			doins ${PROJECT_NAME}.dll.config
			doins bin/${mydebug}/${PROJECT_NAME}.dll
			egacinstall "bin/${mydebug}/${PROJECT_NAME}.dll"
			dotnet_distribute_file_matching_dll_in_gac \
				"bin/${mydebug}/${PROJECT_NAME}.dll" \
				"${PROJECT_NAME}.dll.config"
		fi
	}
	dotnet_foreach_impl install_impl
	dotnet_multilib_comply
}
