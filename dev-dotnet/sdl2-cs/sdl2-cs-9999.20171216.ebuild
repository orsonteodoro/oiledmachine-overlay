# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_DOTNET="net461 netstandard20"

RDEPEND=">=media-libs/libsdl2-2.0.7
         media-libs/sdl2-ttf
         media-libs/sdl2-mixer"
DEPEND="${RDEPEND}"
IUSE="${USE_DOTNET} debug gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac? ( net461 )"

inherit dotnet eutils mono

DESCRIPTION="SDL2-CS is a C# wrapper for SDL2"
HOMEPAGE="https://github.com/flibitijibibo/SDL2-CS"
PROJECT_NAME="SDL2-CS"
COMMIT="ed4838b75dadbdfcef4c23edb0c607c38d7237a2"
SRC_URI="https://github.com/flibitijibibo/${PROJECT_NAME}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

inherit gac

LICENSE="zlib"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${PROJECT_NAME}-${COMMIT}"

src_prepare() {
	default
	dotnet_copy_sources
}

src_compile() {
	mydebug="release"
	if use debug; then
		mydebug="debug"
	fi

	compile_impl() {
		if [[ "${EDOTNET}" =~ netcore || "${EDOTNET}" =~ netstandard ]] ; then
		        exbuild ${STRONG_ARGS_NETCORE}"${DISTDIR}/mono.snk" -p:Configuration=${mydebug} SDL2-CS.Core.csproj || die
		else
		        exbuild ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" /p:Configuration=${mydebug} SDL2-CS.csproj || die
		fi

		dotnet_copy_dllmap_config "${FILESDIR}/SDL2-CS.dll.config"
	}

	dotnet_foreach_impl compile_impl
}

src_install() {
	install_impl() {
		mydebug="Release"
		if use debug; then
			mydebug="Debug"
		fi

		if [[ "${EDOTNET}" =~ netstandard ]] ; then
			mydebug="${mydebug,,}"
		fi

		dotnet_install_loc

		if [[ "${EDOTNET}" =~ netstandard ]] ; then
			doins bin/${mydebug}/$(dotnet_use_flag_moniker_to_ms_moniker ${ENETCORE})/SDL2-CS.dll
			doins SDL2-CS.dll.config
			doins bin/${mydebug}/$(dotnet_use_flag_moniker_to_ms_moniker ${ENETCORE})/SDL2-CS.deps.json
			doins bin/${mydebug}/$(dotnet_use_flag_moniker_to_ms_moniker ${ENETCORE})/SDL2-CS.pdb
		elif dotnet_is_netfx "${EDOTNET}" ; then
			estrong_resign "bin/${mydebug}/${PROJECT_NAME}.dll" "${DISTDIR}/mono.snk"
			doins SDL2-CS.dll.config
			doins bin/${mydebug}/SDL2-CS.dll
			egacinstall "bin/${mydebug}/${PROJECT_NAME}.dll"
			dotnet_distribute_dllmap_config "${PROJECT_NAME}.dll"
		fi
	}

	dotnet_foreach_impl install_impl

	dotnet_multilib_comply
}
