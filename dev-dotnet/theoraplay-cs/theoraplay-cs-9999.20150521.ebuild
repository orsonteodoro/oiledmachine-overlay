# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="TheoraPlay# - C# Wrapper for TheoraPlay"
HOMEPAGE="https://github.com/flibitijibibo/TheoraPlay-CS"
LICENSE="zlib"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) gac"
RDEPEND="media-libs/theoraplay"
DEPEND="${RDEPEND}"
SLOT="0"
inherit dotnet eutils mono gac
PROJECT_NAME="TheoraPlay-CS"
EGIT_COMMIT="d5bae691e56d0a4b7334206d6b92b4ff3cb2cd04"
SRC_URI="https://github.com/flibitijibibo/${PROJECT_NAME}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PROJECT_NAME}-${EGIT_COMMIT}"
RESTRICT="mirror"

src_compile() {
	cd "${S}"
        exbuild /p:Configuration=$(usex debug "debug" "release") ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" ${PROJECT_NAME}.sln || die
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

	eend

	if use developer ; then
		insinto "/usr/$(get_libdir)/mono/${PN}"
		doins bin/Release/TheoraPlay-CS.dll.mdb
	fi

	insinto "/usr/$(get_libdir)/mono/${PN}"
	doins bin/Release/TheoraPlay-CS.dll.config

	dotnet_multilib_comply
}

