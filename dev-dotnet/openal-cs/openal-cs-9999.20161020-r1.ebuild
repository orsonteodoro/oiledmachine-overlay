# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="OpenAl# is a C# wrapper for OpenAL"
HOMEPAGE="https://github.com/flibitijibibo/OpenAL-CS"
LICENSE="zlib"
KEYWORDS="~amd64 ~x86"
PROJECT_NAME="OpenAL-CS"
USE_DOTNET="net40"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac? ( net40 )"
RDEPEND="media-libs/openal"
DEPEND="${RDEPEND}"
inherit dotnet eutils
EGIT_COMMIT="16b00102f4dbd0b3a0f2ce31f7fa6f5d1eb0d1ed"
SRC_URI=\
"https://github.com/flibitijibibo/${PROJECT_NAME}/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
inherit gac
SLOT="0/${PV}"
S="${WORKDIR}/${PROJECT_NAME}-${EGIT_COMMIT}"
RESTRICT="mirror"

src_prepare() {
	default
	dotnet_copy_sources
}

src_compile() {
	compile_impl() {
	        exbuild /p:Configuration=$(usex debug "debug" "release") \
			${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" \
			${PROJECT_NAME}.sln || die
	}
	dotnet_foreach_impl compile_impl
}

src_install() {
	local mydebug=$(usex dotnet "Debug" "Release")
	install_impl() {
		dotnet_install_loc
		if [[ "${EDOTNET}" =~ net40 ]] ; then
	                egacinstall "bin/${mydebug}/${PROJECT_NAME}.dll"
		fi
		doins bin/${mydebug}/${PROJECT_NAME}.dll
		if use developer ; then
			doins bin/${mydebug}/${PROJECT_NAME}.dll.mdb
			dotnet_distribute_file_matching_dll_in_gac \
				"bin/${mydebug}/${PROJECT_NAME}.dll"
				"bin/Release/OpenAL-CS.dll.mdb"
		fi
		doins bin/${mydebug}/${PROJECT_NAME}.dll.config
		dotnet_distribute_file_matching_dll_in_gac \
			"bin/${mydebug}/${PROJECT_NAME}.dll"
			"bin/${mydebug}/${PROJECT_NAME}.dll.config"
	}
	dotnet_foreach_impl install_impl
	dotnet_multilib_comply
}
