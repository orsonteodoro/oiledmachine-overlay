# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
CMAKE_BUILD_TYPE="Release"
GMIC_QT_DIR="gmic-qt-v.${PV}"

inherit check-compiler-switch cmake flag-o-matic qmake-utils toolchain-funcs

S="${WORKDIR}/${PN}-v.${PV}"
SRC_URI="
https://github.com/c-koi/gmic-qt/archive/v.${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="G'MIC-Qt is a versatile frontend to the image processing framework G'MIC"
HOMEPAGE="
	https://github.com/c-koi/gmic-qt
"
LICENSE="
	GPL-3+
"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="
+curl +fftw gimp2 gimp3 lto openmp qt5 qt6 standalone
ebuild_revision_5
"
REQUIRED_USE="
	?? (
		gimp2
		gimp3
	)
	|| (
		gimp2
		gimp3
		standalone
	)
	|| (
		qt5
		qt6
	)
"

QT5_DEPS="
	dev-qt/qtcore:5
	dev-qt/qtcore:=
	dev-qt/qtgui:5[X]
	dev-qt/qtgui:=
	dev-qt/qtnetwork:5
	dev-qt/qtnetwork:=
	dev-qt/qtwidgets:5[X]
	dev-qt/qtwidgets:=
"
QT6_DEPS="
	dev-qt/qtbase:6[gui,network,widgets,X]
	dev-qt/qtbase:=
"
COMMON_DEPEND="
	media-libs/libpng
	media-gfx/gmic[fftw,png,X]
	sys-libs/zlib
	x11-libs/libX11
	curl? (
		net-misc/curl
	)
	fftw? (
		sci-libs/fftw:3.0[threads]
		sci-libs/fftw:=
	)
	gimp2? (
		>=media-gfx/gimp-2.8.0
	)
	gimp3? (
		~media-gfx/gimp-2.99.18
	)
	qt5? (
		${QT5_DEPS}
	)
	qt6? (
		${QT6_DEPS}
	)
"
RDEPEND="
	${COMMON_DEPEND}
"
DEPEND="
	${COMMON_DEPEND}
	openmp? (
		sys-devel/gcc[openmp]
	)
	qt5? (
		dev-qt/linguist-tools:5
	)
	qt6? (
		dev-qt/qttools:6[linguist]
	)
	virtual/pkgconfig
"

check_cxxabi() {
	local gcc_current_profile=$(gcc-config -c)
	local gcc_current_profile_slot=${gcc_current_profile##*-}
	local libstdcxx_cxxabi_ver=$(strings "/usr/lib/gcc/${CHOST}/${gcc_current_profile_slot}/libstdc++.so" \
		| grep CXXABI \
		| sort -V \
		| grep -E -e "CXXABI_[0-9]+" \
		| tail -n 1 \
		| cut -f 2 -d "_")
	local libstdcxx_glibcxx_ver=$(strings "/usr/lib/gcc/${CHOST}/${gcc_current_profile_slot}/libstdc++.so" \
		| grep GLIBCXX \
		| sort -V \
		| grep -E -e "GLIBCXX_[0-9]+" \
		| tail -n 1 \
		| cut -f 2 -d "_")
	local qt6core_cxxabi_ver=$(strings "/usr/lib64/libQt6Core.so" \
		| grep CXXABI \
		| sort -V \
		| grep -E -e "CXXABI_[0-9]+" \
		| tail -n 1 \
		| cut -f 2 -d "_")
	local qt6core_glibcxx_ver=$(strings "/usr/lib64/libQt6Core.so" \
		| grep GLIBCXX \
		| sort -V \
		| grep -E -e "GLIBCXX_[0-9]+" \
		| tail -n 1 \
		| cut -f 2 -d "_")
	if ver_test ${libstdcxx_cxxabi_ver} -lt ${qt6core_cxxabi_ver} ; then
eerror
eerror "Detected CXXABI missing symbol."
eerror
eerror "Ensure that the qt6core was build with the same gcc version as the"
eerror "currently selected compiler."
eerror
eerror "libstdcxx CXXABI  - ${libstdcxx_cxxabi_ver} (GCC slot ${gcc_current_profile_slot})"
eerror "libstdcxx GLIBCXX - ${libstdcxx_glibcxx_ver} (GCC slot ${gcc_current_profile_slot})"
eerror "qt6core CXXABI    - ${qt6core_cxxabi_ver}"
eerror "qt6core GLIBCXX   - ${qt6core_glibcxx_ver}"
eerror
eerror "See https://gcc.gnu.org/onlinedocs/libstdc++/manual/abi.html for details"
eerror
		die
	fi
}

pkg_setup() {
	check-compiler-switch_start
}

src_prepare() {
	cd "${S}" || die
	patch -p1 -i "${FILESDIR}/gmic-3.1.6-stripping.patch" || die
	patch -p1 -i "${FILESDIR}/gmic-3.2.0-system-gmic.patch" || die
	if use gimp3 ; then
		patch -p1 -i "${FILESDIR}/gimp-3-functions.patch"
		pushd "${WORKDIR}"
			patch -p1 -i "${FILESDIR}/gimp-3-setup.patch"
		popd
	fi
	cd -
	cmake_src_prepare
}

src_configure() {
	check_cxxabi

	if use openmp ; then
einfo "GCC version:  "$(gcc-fullversion)
	# Simplify OpenMP
		export CC="${CHOST}-gcc"
		export CXX="${CHOST}-g++"
		export CPP="${CC} -E"
		local gcc_slot=$(gcc-major-version)
		if has_version "sys-devel/gcc:${gcc_slot}[-openmp]" ; then
ewarn "Rebuild GCC ${gcc_slot} with USE=openmp"
		fi
		tc-check-openmp
	fi

	if ! test-flag-CXX -std=c++11 ; then
eerror
eerror "You need at least GCC 4.7.x or Clang >= 3.3 for C++11-specific compiler"
eerror "flags"
eerror
		die
	fi

	lto_option=()
	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		lto_option=(
			-DENABLE_LTO=OFF
		)
	else
		lto_option=(
			-DENABLE_LTO=$(usex lto)
		)
	fi
	filter-lto

	# For "lrelease"
	if use qt5 ; then
		PATH="$(qt5_get_bindir):${PATH}"
	fi
	if use qt6 ; then
		PATH="$(qt6_get_bindir):${PATH}"
	fi

	local CMAKE_USE_DIR="${WORKDIR}/${GMIC_QT_DIR}"
	mycmakeargs=(
		${lto_option[@]}
		-DBUILD_WITH_QT6=$(usex qt6)
		-DENABLE_FFTW3=$(usex fftw)
		-DENABLE_DYNAMIC_LINKING=ON
		-DENABLE_SYSTEM_GMIC=ON
		-DGMIC_LIB_PATH="${WORKDIR}/gmic-v.${PV}_build"
	)

	local BUILD_DIR
	if use gimp2 ; then
		BUILD_DIR="${WORKDIR}/gimp_build"
		mycmakeargs+=(
			-DGMIC_QT_HOST="gimp"
		)
		cmake_src_configure
	fi
	if use gimp3 ; then
		BUILD_DIR="${WORKDIR}/gimp_build"
		mycmakeargs+=(
			-DGMIC_QT_HOST="gimp3"
		)
		cmake_src_configure
	fi
	if use standalone ; then
		BUILD_DIR="${WORKDIR}/standalone_build"
		mycmakeargs+=(
			-DGMIC_QT_HOST="none"
		)
		cmake_src_configure
	fi
}

src_compile() {
	local BUILD_DIR
	if use gimp2 || use gimp3 ; then
		BUILD_DIR="${WORKDIR}/gimp_build"
		cmake_src_compile
	fi
	if use standalone ; then
		BUILD_DIR="${WORKDIR}/standalone_build"
		cmake_src_compile
	fi
}

src_install() {
	dodoc "README.md"
	if use gimp2 || use gimp3 ; then
		exeinto "${PLUGIN_DIR}"
		doexe "${WORKDIR}/gimp_build/gmic_gimp_qt"
	fi
	if use standalone ; then
		exeinto "/usr/bin"
		doexe "${WORKDIR}/standalone_build/gmic_qt"
	fi
}

pkg_postinst() {
	if use gimp2 || use gimp3 ; then
ewarn
ewarn "Currently, gmic_qt does NOT support Wayland.  As a result of this, it is"
ewarn "required to launch GIMP with GDK_BACKEND=x11."
ewarn
	fi
}
