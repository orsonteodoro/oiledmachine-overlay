# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="OpenAl# is a C# wrapper for OpenAL"
HOMEPAGE="https://github.com/flibitijibibo/OpenAL-CS"
LICENSE="zlib"
KEYWORDS="~amd64 ~x86"
PROJECT_NAME="OpenAL-CS"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"
RDEPEND=">=dev-lang/mono-4
         media-libs/openal"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4"
inherit dotnet eutils mono
EGIT_COMMIT="381275db51451260d08cdd3fa0152f46aa1727c4"
SRC_URI="https://github.com/flibitijibibo/${PROJECT_NAME}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
inherit gac
SLOT="0"
S="${WORKDIR}/${PROJECT_NAME}-${EGIT_COMMIT}"
RESTRICT="mirror"

src_compile() {
	cd "${S}"
        exbuild /p:Configuration=$(usex debug "debug" "release") STRONG_ARGS_NETFX"${DISTDIR}/mono.snk" ${PROJECT_NAME}.sln || die
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

        ebegin "Installing dlls into the GAC"

	for x in ${USE_DOTNET} ; do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
                egacinstall "${S}/bin/${mydebug}/${PROJECT_NAME}.dll"
        done

	if use developer ; then
		insinto "/usr/$(get_libdir)/mono/${PN}"
		doins bin/Release/OpenAL-CS.dll.mdb
	fi

	eend

	insinto "/usr/$(get_libdir)/mono/${PN}"
	doins "bin/${mydebug}/OpenAL-CS.dll.config"

	dotnet_multilib_comply
}
