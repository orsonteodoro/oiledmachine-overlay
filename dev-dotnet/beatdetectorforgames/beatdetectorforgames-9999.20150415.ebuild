# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="BeatDetectorForGames is a A C++ and C# Beat Detector to be used in Video Games."
HOMEPAGE="https://github.com/Terracorrupt/BeatDetectorForGames"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac c++ static"
REQUIRED_USE="|| ( ${USE_DOTNET} ) || ( gac c++ ) gac? ( net45 )"
RDEPEND="media-libs/fmod"
DEPEND="${RDEPEND}
        dev-util/premake:5"
inherit dotnet eutils mono toolchain-funcs
PROJECT_NAME="BeatDetectorForGames"
EGIT_COMMIT="e3143cbde1261a9bfa566633377d282ac46a7750"
SRC_URI="https://github.com/Terracorrupt/BeatDetectorForGames/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
inherit gac
SLOT="0"
S="${WORKDIR}/${PROJECT_NAME}-${EGIT_COMMIT}"
RESTRICT="mirror"

src_prepare() {
	default
	eapply "${FILESDIR}/beatdetectorforgames-9999.20150415-cpp-header-fixes.patch"

	cp "${FILESDIR}/buildcpp.lua" "${S}/BeatDetector/BeatDetectorC++Version/Detector" || die
	cp "${FILESDIR}/buildcs.lua" "${S}/BeatDetector/BeatDetectorC#Version" || die

        if (( $(gcc-major-version) >= 6 )) ; then
		sed -i -e 's|std=c++11|std=c++14|g' BeatDetector/BeatDetectorC++Version/Detector/buildcpp.lua || die
	fi

	cd "${S}/BeatDetector/BeatDetectorC++Version/Detector" || die
	premake5 --file=buildcpp.lua gmake || die

	cd "${S}/BeatDetector/BeatDetectorC#Version" || die
	sed -i -r -e "s|@DISTDIR@|${DISTDIR}|g" buildcs.lua || die
	premake5 --file=buildcs.lua gmake || die

	#use the system fmod
	rm -rf "${S}"/BeatDetector/BeatDetectorC++Version/Detector/{inc,*.dll,lib} || die

	sed -i -r -e 's|"fmodex64"|"fmodex.dll"|g' "${S}/BeatDetector/BeatDetectorC#Version/fmod.cs" || die
	sed -i -r -e 's|"fmodex"|"fmodex.dll"|g' "${S}/BeatDetector/BeatDetectorC#Version/fmod.cs" || die
	sed -i -r -e 's|"fmodex64"|"fmodex.dll"|g' "${S}/BeatDetector/BeatDetectorC++Version/FMOD/csharp/fmod.cs" || die
	sed -i -r -e 's|"fmodex"|"fmodex.dll"|g' "${S}/BeatDetector/BeatDetectorC++Version/FMOD/csharp/fmod.cs" || die
}

src_compile() {
	local mydebug=$(usex debug "debug" "release")
	local mystatic=$(usex static "static" "shared")

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
	local mydebug=$(usex debug "Debug" "Release")
	local mystatic=$(usex static "Static" "Shared")

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

