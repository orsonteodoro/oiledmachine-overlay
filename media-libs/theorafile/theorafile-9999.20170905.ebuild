# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils multilib-minimal multilib-build dotnet mono gac

DESCRIPTION="Theorafile"
HOMEPAGE=""
COMMIT="eb65cf7d4881dd3ca0bfd71e8ec2c54c71ffe4d2"
PROJECT_NAME="Theorafile"
SRC_URI="https://github.com/FNA-XNA/${PROJECT_NAME}/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="zlib"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static debug"
USE_DOTNET="net45"
IUSE+=" ${USE_DOTNET} debug +gac"

RDEPEND="media-libs/libtheora
         media-libs/libvorbis
         media-libs/libogg
	 >=dev-lang/mono-4"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PROJECT_NAME}-${COMMIT}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_prepare() {
	egenkey

	eapply_user

	multilib_copy_sources
}

multilib_src_compile() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	#build native library
	emake || die

	#build c# wrapper
	cd csharp
        einfo "Building solution"
        exbuild_strong /p:Configuration=${mydebug} Theorafile-CS.sln || die
}

multilib_src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	esavekey

        ebegin "Installing dlls into the GAC"

	for x in ${USE_DOTNET} ; do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
                egacinstall "csharp/bin/${mydebug}/Theorafile-CS.dll"
        done

	eend

	dotnet_multilib_comply

	if use developer ; then
		pwd
                insinto "/usr/$(get_libdir)/mono/${PN}"
		doins csharp/bin/${mydebug}/Theorafile-CS.dll.mdb
	fi

        insinto "/usr/$(get_libdir)/mono/${PN}"
	doins csharp/bin/${mydebug}/Theorafile-CS.dll.config

	mkdir -p "${D}/usr/$(get_libdir)"
	cp libtheorafile.so "${D}"/usr/$(get_libdir)/
}
