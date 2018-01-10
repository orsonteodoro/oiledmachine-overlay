# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit dotnet eutils mono gac

DESCRIPTION="BeatDetectorForGames is a A C++ and C# Beat Detector to be used in Video Games."
HOMEPAGE="https://github.com/Terracorrupt/BeatDetectorForGames"
PROJECT_NAME="BeatDetectorForGames"
COMMIT="e3143cbde1261a9bfa566633377d282ac46a7750"
SRC_URI="https://github.com/Terracorrupt/BeatDetectorForGames/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac c++ static"
REQUIRED_USE="|| ( ${USE_DOTNET} ) || ( gac c++ )"

RDEPEND=">=dev-lang/mono-4
         media-libs/fmod"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
        dev-util/premake:5
"

S="${WORKDIR}/${PROJECT_NAME}-${COMMIT}"
SNK_FILENAME="${S}/${PN}-keypair.snk"

src_prepare() {
	eapply "${FILESDIR}/beatdetectorforgames-9999.20150415-cpp-header-fixes.patch"

	cp "${FILESDIR}/buildcpp.lua" "${S}/BeatDetector/BeatDetectorC++Version/Detector"
	cp "${FILESDIR}/buildcs.lua" "${S}/BeatDetector/BeatDetectorC#Version"

	cd "${S}/BeatDetector/BeatDetectorC++Version/Detector"
	premake5 --file=buildcpp.lua gmake

	cd "${S}/BeatDetector/BeatDetectorC#Version"
	sed -i -r -e "s|@S@|${S}|g" buildcs.lua
	premake5 --file=buildcs.lua gmake

	#use the system fmod
	rm -rf "${S}"/BeatDetector/BeatDetectorC++Version/Detector/{inc,*.dll,lib}

	sed -i -r -e 's|"fmodex64"|"fmodex.dll"|g' "${S}/BeatDetector/BeatDetectorC#Version/fmod.cs" || die p1
	sed -i -r -e 's|"fmodex"|"fmodex.dll"|g' "${S}/BeatDetector/BeatDetectorC#Version/fmod.cs" || die p2
	sed -i -r -e 's|"fmodex64"|"fmodex.dll"|g' "${S}/BeatDetector/BeatDetectorC++Version/FMOD/csharp/fmod.cs" || die p3
	sed -i -r -e 's|"fmodex"|"fmodex.dll"|g' "${S}/BeatDetector/BeatDetectorC++Version/FMOD/csharp/fmod.cs" || die p4

	egenkey

	eapply_user
}

src_compile() {
	mydebug="release"
	if use debug; then
		mydebug="debug"
	fi
	mystatic="shared"
	if use static; then
		mystatic="static"
	fi

	cd "${S}/BeatDetector"

	if use c++ ; then
		einfo "Building C++ library..."
		cd "${S}/BeatDetector/BeatDetectorC++Version/Detector/build"
		make config=${mydebug}${mystatic}lib
	fi

	if use gac ; then
		einfo "Building C# library..."
		cd "${S}/BeatDetector/BeatDetectorC#Version/build"
		make config=${mydebug}${mystatic}lib
	fi
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi
	mystatic="Shared"
	if use static; then
		mystatic="Static"
	fi

	esavekey

        ebegin "Installing dlls into the GAC"

	for x in ${USE_DOTNET} ; do
                FW_UPPER=${x:3:1}
                FW_LOWER=${x:4:1}
                egacinstall "${S}/BeatDetector/BeatDetectorC#Version/build/bin/${mydebug}SharedLib/BeatDetectorForGames.dll"
               	insinto "/usr/$(get_libdir)/mono/${PN}"
		use debug && use gac && use developer && doins BeatDetector/BeatDetectorC#Version/build/bin/${mydebug}${mystatic}Lib/BeatDetectorForGames.dll.mdb
        done

	eend

	if use c++ ; then
		insinto /usr/$(get_libdir)
		doins BeatDetector/BeatDetectorC++Version/Detector/build/bin/${mydebug}${mystatic}Lib/libBeatDetectorForGames.so
	fi

        FILES=$(find "${D}" -name "BeatDetectorForGames.dll")
        for f in $FILES
        do
                cp -a "${FILESDIR}/BeatDetectorForGames.dll.config" "$(dirname $f)"
        done

	dotnet_multilib_comply
}

