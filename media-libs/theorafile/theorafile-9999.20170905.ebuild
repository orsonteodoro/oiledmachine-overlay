# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Theorafile - Ogg Theora Video Decoder Library"
HOMEPAGE="https://github.com/FNA-XNA/Theorafile"
LICENSE="zlib"
KEYWORDS="~amd64 ~x86"
EGIT_COMMIT="eb65cf7d4881dd3ca0bfd71e8ec2c54c71ffe4d2"
PROJECT_NAME="Theorafile"
SLOT="0"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac static"
REQUIRED_USE="gac? ( net45 )"
inherit multilib-minimal
RDEPEND="media-libs/libogg[${MULTILIB_USEDEP}]
	 media-libs/libtheora[${MULTILIB_USEDEP}]
         media-libs/libvorbis[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
inherit eutils dotnet mono
SRC_URI="https://github.com/FNA-XNA/${PROJECT_NAME}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
inherit gac
RESTRICT="mirror"
S="${WORKDIR}/${PROJECT_NAME}-${EGIT_COMMIT}"

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_compile() {
	# Build native library
	emake || die

	# Build C# wrapper
	cd csharp
	exbuild /p:Configuration=$(usex debug "Debug" "Release") ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" Theorafile-CS.sln || die
}

multilib_src_install() {
	local mydebug=$(usex debug "Debug" "Release")

	ebegin "Installing dlls into the GAC"

	for x in ${USE_DOTNET} ; do
		FW_UPPER=${x:3:1}
		FW_LOWER=${x:4:1}
		egacinstall "csharp/bin/${mydebug}/Theorafile-CS.dll"
        done

	eend

	if use developer ; then
		insinto "/usr/$(get_libdir)/mono/${PN}"
		doins csharp/bin/${mydebug}/Theorafile-CS.dll.mdb
	fi

	insinto "/usr/$(get_libdir)/mono/${PN}"
	doins csharp/bin/${mydebug}/Theorafile-CS.dll.config

	dolib.so libtheorafile.so

	dotnet_multilib_comply
}
