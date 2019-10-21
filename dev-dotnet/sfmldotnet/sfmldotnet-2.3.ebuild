# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="SFML.Net is a C# language binding for SFML"
HOMEPAGE="http://www.sfml-dev.org"
LICENSE="zlib"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac abi_x86_64 abi_x86_32 developer"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"
RDEPEND="media-libs/libsfml:0"
DEPEND="${RDEPEND}"
inherit dotnet eutils multilib-minimal
GIT_USER="SFML"
PROJECT_NAME="SFML.Net"
SRC_URI="https://github.com/${GIT_USER}/${PROJECT_NAME}/archive/${PV}.tar.gz \
		-> ${P}.tar.gz"
inherit gac
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/${PROJECT_NAME}-${PV}"
RESTRICT="mirror"

src_prepare() {
	default
	cd "${WORKDIR}"
	FILES=$(grep -l -r -e "DllImport")
	for f in $FILES
	do
		einfo "Editing $f..."
		sed -i -e "s|csfml-graphics-2|libsfml-graphics.dll|g" "$f" \
			|| die
		sed -i -e "s|csfml-audio-2|libsfml-audio.dll|g" "$f" \
			|| die
		sed -i -e "s|csfml-system-2|libsfml-system.dll|g" "$f" \
			|| die
		sed -i -e "s|csfml-window-2|libsfml-window.dll|g" "$f" \
			|| die
		sed -i -e "s|sfmlnet-graphics-2|libsfml-graphics.dll|g" "$f" \
			|| die
		sed -i -e "s|sfmlnet-audio-2|libsfml-audio.dll|g" "$f" \
			|| die
		sed -i -e "s|sfmlnet-system-2|libsfml-system.dll|g" "$f" \
			|| die
		sed -i -e "s|sfmlnet-window-2|libsfml-window.dll|g" "$f" \
			|| die
	done
	multilib_copy_sources
	ml_prepare_impl() {
		dotnet_copy_sources
	}
	multlib_foreach_abi ml_prepare_impl
}

src_compile() {
	local mydebug=$(usex debug "debug" "release")
	ml_compile_impl() {
		local myarch
		if [[ "${ABI}" == "amd64" ]] ; then
			myarch="x64"
		elif [[ "${ABI}" == "x86" ]] ; then
			myarch="x86"
		else
			die "ABI is not supported"
		fi
		dll_compile_impl() {
			cd build/vc2008
			exbuild /p:Configuration=${mydebug} \
				/p:Platform=${myarch} \
				${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" \
				SFML.net.sln || die
		}
		dotnet_foreach_impl dll_compile_impl
	}
	multilib_foreach_impl ml_compile_impl
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")
	ml_install_impl() {
		local myarch
		if [[ "${ABI}" == "amd64" ]] ; then
			myarch="x64"
		elif [[ "${ABI}" == "x86" ]] ; then
			myarch="x86"
		else
			die "ABI is not supported"
		fi
		dll_install_impl() {
			dotnet_install_loc
	                egacinstall lib/${myarch}/sfmlnet-audio-2.dll
	                egacinstall lib/${myarch}/sfmlnet-graphics-2.dll
	                egacinstall lib/${myarch}/sfmlnet-system-2.dll
	                egacinstall lib/${myarch}/sfmlnet-window-2.dll
			if use developer ; then
				doins lib/${myarch}/sfmlnet-audio-2.dll.mdb
				doins lib/${myarch}/sfmlnet-graphics-2.dll.mdb
				doins lib/${myarch}/sfmlnet-system-2.dll.mdb
				doins lib/${myarch}/sfmlnet-window-2.dll.mdb
				dotnet_distribute_file_matching_dll_in_gac \
					"lib/${myarch}/sfmlnet-audio-2.dll" \
					"lib/${myarch}/sfmlnet-audio-2.dll.mdb"
				dotnet_distribute_file_matching_dll_in_gac \
				  "lib/${myarch}/sfmlnet-graphics-2.dll" \
				  "lib/${myarch}/sfmlnet-graphics-2.dll.mdb"
				dotnet_distribute_file_matching_dll_in_gac \
					"lib/${myarch}/sfmlnet-system-2.dll" \
					"lib/${myarch}/sfmlnet-system-2.dll.mdb"
				dotnet_distribute_file_matching_dll_in_gac \
					"lib/${myarch}/sfmlnet-window-2.dll" \
					"lib/${myarch}/sfmlnet-window-2.dll.mdb"
			fi

			dotnet_distribute_file_matching_dll_in_gac \
				"lib/${myarch}/sfmlnet-audio-2.dll"
				"${FILESDIR}/sfmlnet-audio-2.dll.config"
			dotnet_distribute_file_matching_dll_in_gac \
				"lib/${myarch}/sfmlnet-graphics-2.dll"
				"${FILESDIR}/sfmlnet-graphics-2.dll.config"
			dotnet_distribute_file_matching_dll_in_gac \
				"lib/${myarch}/sfmlnet-system-2.dll" \
				"${FILESDIR}/sfmlnet-system-2.dll.config"
			dotnet_distribute_file_matching_dll_in_gac \
				"lib/${myarch}/sfmlnet-window-2.dll" \
				"${FILESDIR}/sfmlnet-window-2.dll.config"
		}
		dotnet_foreach_impl dll_install_impl
	}
	multlib_foreach_impl ml_install_impl
	dotnet_multilib_comply
}
