# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="FNA - Accuracy-focused XNA4 reimplementation for open platforms"
HOMEPAGE="http://fna-xna.github.io/"
LICENSE="Ms-PL MIT GPL-2 LGPL-2.1"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net461 netstandard20"
IUSE="${USE_DOTNET} debug +gac mojoshader openal sdl2 theoraplay vorbis"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac? ( net461 )"
RDEPEND="mojoshader? ( media-gfx/mojoshader )
	openal? ( media-libs/openal )
	sdl2? ( >=media-libs/libsdl2-2.0.7
		media-libs/sdl2-mixer
		media-libs/sdl2-ttf )
	vorbis? ( media-libs/libvorbis )
	theoraplay? ( media-libs/theoraplay )"
DEPEND="${RDEPEND}"
SLOT="0/${PV}"
inherit dotnet eutils git-r3 mono multilib-build
inherit gac
S="${WORKDIR}/fna-${PV}"
RESTRICT="mirror"
EGIT_COMMIT="${PV}" # the head of this tag
EGIT_REPO_URI="https://github.com/FNA-XNA/FNA.git"
EGIT_SUBMODULES=( '*' )
LAST_COMMIT_TIMESTAMP="Wed 01 Jan 2020 08:13:00 AM PST"
EGIT_OVERRIDE_COMMIT_DATE_FNA_XNA_FNA="${LAST_COMMIT_TIMESTAMP}"
EGIT_OVERRIDE_COMMIT_DATE_FLIBITIJIBIBO_SDL2_CS="${LAST_COMMIT_TIMESTAMP}"
EGIT_OVERRIDE_COMMIT_DATE_FNA_XNA_FAUDIO="${LAST_COMMIT_TIMESTAMP}"
EGIT_OVERRIDE_COMMIT_DATE_FNA_XNA_MOJOSHADER="${LAST_COMMIT_TIMESTAMP}"
EGIT_OVERRIDE_COMMIT_DATE_FNA_XNA_THEORAFILE="${LAST_COMMIT_TIMESTAMP}"

src_prepare() {
	ewarn "This ebuild is a Work In Progress (WIP) and unfinished."
	default
	estrong_assembly_info2 "MonoGame.Framework.Content.Pipeline" \
		"${DISTDIR}/mono.snk" "src/Properties/AssemblyInfo.cs"
	estrong_assembly_info2 "MonoGame.Framework.Net" \
		"${DISTDIR}/mono.snk" "src/Properties/AssemblyInfo.cs"
	dotnet_copy_sources
}

src_compile() {
	compile_impl() {
		exbuild ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" \
			/t:Build FNA.sln || die
	}
	dotnet_foreach_impl compile_impl
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")
	install_impl() {
		dotnet_install_loc
		if dotnet_is_netfx ; then
	                egacinstall bin/${mydebug}/FNA.dll
			dotnet_distribute_file_matching_dll_in_gac \
				"bin/${mydebug}/FNA.dll"
				"bin/${mydebug}/FNA.dll.config"
		fi
		doins bin/${mydebug}/FNA.dll
		doins bin/${mydebug}/FNA.dll.config
		if use developer ; then
			doins bin/${mydebug}/FNA.dll.mdb
			dotnet_distribute_file_matching_dll_in_gac \
				"bin/${mydebug}/FNA.dll"
				"bin/${mydebug}/FNA.dll.mdb"
		fi
	}
	dotnet_foreach_impl install_impl
	dotnet_multilib_comply
}
