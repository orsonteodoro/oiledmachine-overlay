# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A C++ and C# Beat Detector to be used in Video Games. Can take "
DESCRIPTION+=" in a song and detect where beats occur"
HOMEPAGE="https://github.com/Terracorrupt/BeatDetectorForGames"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug +gac c++ static"
REQUIRED_USE="|| ( ${USE_DOTNET} ) || ( net45 c++ ) gac? ( net45 )"
RDEPEND=">=media-libs/fmod-4.44.50"
DEPEND="${RDEPEND}
        dev-util/premake:5"
inherit dotnet eutils mono toolchain-funcs
PROJECT_NAME="BeatDetectorForGames"
EGIT_COMMIT="e3143cbde1261a9bfa566633377d282ac46a7750"
SRC_URI="
https://github.com/Terracorrupt/BeatDetectorForGames/archive/${EGIT_COMMIT}.tar.gz
		-> ${P}.tar.gz"
inherit gac
SLOT="0/${PV}"
S="${WORKDIR}/${PROJECT_NAME}-${EGIT_COMMIT}"
RESTRICT="mirror"

src_prepare() {
	default
	eapply \
"${FILESDIR}/beatdetectorforgames-9999.20150415-cpp-header-fixes.patch"

	cp "${FILESDIR}/buildcpp.lua" \
		BeatDetector/BeatDetectorC++Version/Detector || die
	cp "${FILESDIR}/buildcs.lua" \
		BeatDetector/BeatDetectorC#Version || die

	cd "${S}/BeatDetector/BeatDetectorC++Version/Detector" || die
	premake5 --file=buildcpp.lua gmake || die

	cd "${S}/BeatDetector/BeatDetectorC#Version" || die
	sed -i -r -e "s|@DISTDIR@|${DISTDIR}|g" buildcs.lua || die
	premake5 --file=buildcs.lua gmake || die

	# Use the system's fmod
	rm -rf BeatDetector/BeatDetectorC++Version/Detector/{inc,*.dll,lib} \
		|| die
	sed -i -r -e 's|"fmodex64"|"fmodex.dll"|g' \
		BeatDetector/BeatDetectorC#Version/fmod.cs || die
	sed -i -r -e 's|"fmodex"|"fmodex.dll"|g' \
		BeatDetector/BeatDetectorC#Version/fmod.cs || die
	sed -i -r -e 's|"fmodex64"|"fmodex.dll"|g' \
		BeatDetector/BeatDetectorC++Version/FMOD/csharp/fmod.cs \
		|| die
	sed -i -r -e 's|"fmodex"|"fmodex.dll"|g' \
		BeatDetector/BeatDetectorC++Version/FMOD/csharp/fmod.cs \
		|| die
}

src_compile() {
	local mydebug=$(usex debug "debug" "release")
	local mystatic=$(usex static "static" "shared")
	if use c++ ; then
		einfo "Building C++ library..."
		cd BeatDetector/BeatDetectorC++Version/Detector/build
		make config=${mydebug}${mystatic}lib
	fi
	compile_impl() {
		einfo "Building C# library..."
		cd BeatDetector/BeatDetectorC#Version/build
		make config=${mydebug}${mystatic}lib
	}
	dotnet_foreach_impl compile_impl
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")
	local mystatic=$(usex static "Static" "Shared")
	install_impl() {
		dotnet_install_loc
		local dll_path=\
"BeatDetector/BeatDetectorC#Version/build/bin/${mydebug}SharedLib/"
		egacinstall \
			${dll_path}/BeatDetectorForGames.dll
		if use developer ; then
			doins ${dll_path}/BeatDetectorForGames.dll.mdb
			dotnet_distribute_file_matching_dll_in_gac \
			  "${dll_path}/BeatDetectorForGames.dl" \
			  "${dll_path}/BeatDetectorForGames.dll.mdb"
		fi
		if use c++ ; then
			dolib.so ${dll_path/C#/C++}/libBeatDetectorForGames.so
		fi
		dotnet_distribute_file_matching_dll_in_gac \
			"${dll_path}/BeatDetectorForGames.dll" \
			"BeatDetectorForGames.dll.config"
	}
	dotnet_foreach_impl install_impl
	dotnet_multilib_comply
}

