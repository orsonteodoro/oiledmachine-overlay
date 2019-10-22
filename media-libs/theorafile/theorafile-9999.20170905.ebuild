# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Theorafile - Ogg Theora Video Decoder Library"
HOMEPAGE="https://github.com/FNA-XNA/Theorafile"
LICENSE="zlib"
KEYWORDS="~amd64 ~x86"
EGIT_COMMIT="eb65cf7d4881dd3ca0bfd71e8ec2c54c71ffe4d2"
PROJECT_NAME="Theorafile"
SLOT="0/${PV}"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac static"
REQUIRED_USE="gac? ( net45 )"
inherit multilib-minimal
RDEPEND="media-libs/libogg[${MULTILIB_USEDEP}]
	 media-libs/libtheora[${MULTILIB_USEDEP}]
         media-libs/libvorbis[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
inherit eutils dotnet
SRC_URI=\
"https://github.com/FNA-XNA/${PROJECT_NAME}/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
inherit gac
RESTRICT="mirror"
S="${WORKDIR}/${PROJECT_NAME}-${EGIT_COMMIT}"

src_prepare() {
	default
	multilib_copy_sources
	ml_prepare() {
		dotnet_copy_sources
	}
	multilib_foreach_abi ml_prepare
}

src_compile() {
	ml_compile() {
		emake || die
		dll_compile() {
			# Build C# wrapper
			cd csharp || die
			exbuild ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" \
				Theorafile-CS.sln || die
		}
		dotnet_foreach_impl dll_compile
	}
	multilib_foreach_abi ml_compile
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")
	ml_install() {
		dolib.so libtheorafile.so
		dll_install() {
			dotnet_install_loc
			egacinstall "csharp/bin/${mydebug}/Theorafile-CS.dll"
			doins csharp/bin/${mydebug}/Theorafile-CS.dll
			if use developer ; then
			  doins csharp/bin/${mydebug}/Theorafile-CS.dll.mdb
			  dotnet_distribute_file_matching_dll_in_gac \
			    "csharp/bin/${mydebug}/Theorafile-CS.dll" \
			    "csharp/bin/${mydebug}/Theorafile-CS.dll.mdb"
			fi
			doins csharp/bin/${mydebug}/Theorafile-CS.dll.config
			dotnet_distribute_file_matching_dll_in_gac \
				"csharp/bin/${mydebug}/Theorafile-CS.dll" \
				"csharp/bin/${mydebug}/Theorafile-CS.dll.config"
		}
		dotnet_foreach_impl dll_install
	}
	multilib_foreach_abi ml_install
	dotnet_multilib_comply
}
