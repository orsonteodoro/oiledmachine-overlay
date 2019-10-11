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
inherit dotnet eutils mono multilib-minimal
GIT_USER="SFML"
PROJECT_NAME="SFML.Net"
SRC_URI="https://github.com/${GIT_USER}/${PROJECT_NAME}/archive/${PV}.tar.gz -> ${P}.tar.gz"
inherit gac
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/${PROJECT_NAME}-${PV}"
RESTRICT="mirror"

src_prepare() {
	cd "${WORKDIR}"
	FILES=$(grep -l -r -e "DllImport")
	for f in $FILES
	do
		einfo "Editing $f..."
		sed -i -e "s|csfml-graphics-2|libsfml-graphics.dll|g" "$f" || die
		sed -i -e "s|csfml-audio-2|libsfml-audio.dll|g" "$f" || die
		sed -i -e "s|csfml-system-2|libsfml-system.dll|g" "$f" || die
		sed -i -e "s|csfml-window-2|libsfml-window.dll|g" "$f" || die

		sed -i -e "s|sfmlnet-graphics-2|libsfml-graphics.dll|g" "$f" || die
		sed -i -e "s|sfmlnet-audio-2|libsfml-audio.dll|g" "$f" || die
		sed -i -e "s|sfmlnet-system-2|libsfml-system.dll|g" "$f" || die
		sed -i -e "s|sfmlnet-window-2|libsfml-window.dll|g" "$f" || die
	done

	eapply_user

	multilib_copy_sources
}

multilib_src_compile() {
	mydebug="release"
	if use debug; then
		mydebug="debug"
	fi

	cd "${S}/build/vc2008"

	myarch="x64"
	if use abi_x86_64 ; then
		myarch="x64"
	fi
	if use abi_x86_32 ; then
		myarch="x86"
	fi

        einfo "Building solution"
        exbuild /p:Configuration=${mydebug} /p:Platform=${myarch} ${STRONG_ARGS_NETFX}"${DISTDIR}/mono.snk" SFML.net.sln || die
}

multilib_src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	myarch="x64"
	if use abi_x86_64 ; then
		myarch="x64"
	fi
	if use abi_x86_32 ; then
		myarch="x86"
	fi

        ebegin "Installing dlls into the GAC"

	for x in ${USE_DOTNET} ; do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
                egacinstall "${S}/lib/${myarch}/sfmlnet-audio-2.dll"
                egacinstall "${S}/lib/${myarch}/sfmlnet-graphics-2.dll"
                egacinstall "${S}/lib/${myarch}/sfmlnet-system-2.dll"
                egacinstall "${S}/lib/${myarch}/sfmlnet-window-2.dll"
		if use developer ; then
			mkdir -p /usr/$(get_libdir)/mono/sfmldotnet/
			insinto /usr/$(get_libdir)/mono/sfmldotnet/
			doins "${S}/lib/${myarch}/sfmlnet-audio-2.dll.mdb"
			doins "${S}/lib/${myarch}/sfmlnet-graphics-2.dll.mdb"
			doins "${S}/lib/${myarch}/sfmlnet-system-2.dll.mdb"
			doins "${S}/lib/${myarch}/sfmlnet-window-2.dll.mdb"
		fi
        done

	eend

        FILES=$(find "${D}" -name "sfmlnet-audio-2.dll")
        for f in $FILES
        do
                cp -a "${FILESDIR}/sfmlnet-audio-2.dll.config" "$(dirname $f)"
        done

        FILES=$(find "${D}" -name "sfmlnet-graphics-2.dll")
        for f in $FILES
        do
                cp -a "${FILESDIR}/sfmlnet-graphics-2.dll.config" "$(dirname $f)"
        done

        FILES=$(find "${D}" -name "sfmlnet-system-2.dll")
        for f in $FILES
        do
                cp -a "${FILESDIR}/sfmlnet-system-2.dll.config" "$(dirname $f)"
        done

        FILES=$(find "${D}" -name "sfmlnet-window-2.dll")
        for f in $FILES
        do
                cp -a "${FILESDIR}/sfmlnet-window-2.dll.config" "$(dirname $f)"
        done

	dotnet_multilib_comply
}
