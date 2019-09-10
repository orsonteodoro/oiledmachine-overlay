# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_DOTNET="net40"

RDEPEND=">=media-libs/libsdl2-2.0.5
         media-libs/sdl2-ttf
         media-libs/sdl2-mixer"
DEPEND="${RDEPEND}"
IUSE="${USE_DOTNET} debug gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac? ( net40 )"

inherit dotnet eutils mono

DESCRIPTION="SDL2-CS is a C# wrapper for SDL2"
HOMEPAGE="https://github.com/flibitijibibo/SDL2-CS"
PROJECT_NAME="SDL2-CS"
COMMIT="4ec65bc5a00049f7211b506ed85033f1c72c60af"
SRC_URI="https://github.com/flibitijibibo/${PROJECT_NAME}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

inherit gac

LICENSE="zlib"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${PROJECT_NAME}-${COMMIT}"

src_prepare() {
	default
	cp -a "${FILESDIR}/SDL2-CS.dll.config" "${S}"
	dotnet_copy_sources
}

src_compile() {
	mydebug="release"
	if use debug; then
		mydebug="debug"
	fi

	compile_impl() {
	        exbuild ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" /p:Configuration=${mydebug} SDL2-CS.csproj || die

		local wordsize
		wordsize="$(get_libdir)"
		wordsize="${wordsize//lib/}"
		wordsize="${wordsize//[on]/}"

		sed -i -e "s|wordsize=\"[0-9]+\"|wordsize=\"${wordsize}\"|g" "${f}" || die
		sed -i -e "s|lib64|$(get_libdir)|g" "${f}" || die
	}

	dotnet_foreach_impl compile_impl
}

src_install() {
	install_impl() {
		mydebug="Release"
		if use debug; then
			mydebug="Debug"
		fi

		local d
		d=$(dotnet_netfx_install_loc ${EDOTNET})
		insinto "${d}"
		if use gac ; then
			estrong_resign "bin/${mydebug}/${PROJECT_NAME}.dll" "${DISTDIR}/mono.snk"
		fi
		doins bin/${mydebug}/SDL2-CS.dll
		doins SDL2-CS.dll.config
		if use gac ; then
			egacinstall "bin/${mydebug}/${PROJECT_NAME}.dll"
			d=$(find "${D}"/usr/$(get_libdir)/mono/gac/${PROJECT_NAME}/ -maxdepth 1 -name "[0-9.]*__[0-9a-z]*")
			d=$(echo "${d}" | sed -e "s|${D}||")
			dosym "$(dotnet_netfx_install_loc ${EDOTNET})/${PROJECT_NAME}.dll.config" "${d}/${PROJECT_NAME}.dll.config"
		fi
	}

	dotnet_foreach_impl install_impl

	dotnet_multilib_comply
}

pkg_postrm() {
	if use gac; then
		einfo "Removing from GAC"
		gacutil -u ${PROJECT_NAME}
	fi
}
