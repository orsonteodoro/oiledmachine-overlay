# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="TheoraPlay# - C# Wrapper for TheoraPlay"
HOMEPAGE="https://github.com/flibitijibibo/TheoraPlay-CS"
LICENSE="zlib"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac? ( net45 )"
RDEPEND="media-libs/theoraplay"
DEPEND="${RDEPEND}"
SLOT="0/${PV}"
inherit dotnet eutils
PROJECT_NAME="TheoraPlay-CS"
EGIT_COMMIT="d5bae691e56d0a4b7334206d6b92b4ff3cb2cd04"
SRC_URI=\
"https://github.com/flibitijibibo/${PROJECT_NAME}/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
inherit gac
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
			${PROJECT_NAME}.sln \
			|| die
	}
	dotnet_foreach_impl compile_impl
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")
	install_impl() {
		dotnet_install_loc
		egacinstall "bin/${mydebug}/${PROJECT_NAME}.dll"
		doins bin/${mydebug}/${PROJECT_NAME}.dll
		if use developer ; then
			doins bin/${mydebug}/${PROJECT_NAME}.dll.mdb
			dotnet_distribute_file_matching_dll_in_gac \
				"bin/${mydebug}/${PROJECT_NAME}.dll"
				"bin/${mydebug}/${PROJECT_NAME}.dll.mdb"
		fi
		doins bin/Release/${PROJECT_NAME}.dll.config
		dotnet_distribute_file_matching_dll_in_gac \
			"bin/${mydebug}/${PROJECT_NAME}.dll"
			"bin/${mydebug}/${PROJECT_NAME}.dll.config"
	}
	dotnet_foreach_impl install_impl
	dotnet_multilib_comply
}

