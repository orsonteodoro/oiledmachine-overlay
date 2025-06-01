# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
CMAKE_BUILD_TYPE="Release"

inherit bash-completion-r1 check-compiler-switch cmake flag-o-matic optfeature qmake-utils toolchain-funcs

S="${WORKDIR}/${PN}-v.${PV}"
SRC_URI="
https://github.com/GreycLab/gmic/archive/v.${PV}.tar.gz
	-> ${P}.tar.gz
https://gmic.eu/gmic_stdlib_community$(ver_rs 1- '').h
"

DESCRIPTION="GREYC's Magic for Image Computing:  A full-featured open-source framework for image processing"
HOMEPAGE="
	http://gmic.eu/
	https://github.com/GreycLab/gmic
	https://framagit.org/dtschump/gmic
"
LICENSE="
	CeCILL-2
	GPL-3
"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# Upstream has static-libs default ON
IUSE="
+bash-completion +cli +curl +ffmpeg +fftw +graphicsmagick +jpeg -lto -opencv
+openexr +openmp +png static-libs +tiff wayland +X +zlib
ebuild_revision_5
"
REQUIRED_USE="
"

COMMON_DEPEND="
	media-libs/cimg:0/$(ver_cut 1-2 ${PV})
	curl? (
		net-misc/curl
	)
	fftw? (
		sci-libs/fftw:3.0[threads]
		sci-libs/fftw:=
	)
	graphicsmagick? (
		media-gfx/graphicsmagick:0
		media-gfx/graphicsmagick:=
	)
	jpeg? (
		media-libs/libjpeg-turbo:0
	)
	opencv? (
		>=media-libs/opencv-2.3.1a-r1:0
		media-libs/opencv:=
	)
	openexr? (
		dev-libs/imath:=
		media-libs/openexr:0
		media-libs/openexr:=
	)
	png? (
		media-libs/libpng:0
		media-libs/libpng:=
	)
	tiff? (
		media-libs/tiff:0
	)
	X? (
		x11-libs/libX11
		x11-libs/libXext
	)
	zlib? (
		sys-libs/zlib:0
		sys-libs/zlib:=
	)
"
RDEPEND="
	${COMMON_DEPEND}
	ffmpeg? (
		media-video/ffmpeg:0
		media-video/ffmpeg:=
	)
"
DEPEND="
	${COMMON_DEPEND}
	virtual/pkgconfig
"
BDEPEND="
	>=dev-build/cmake-3.14.0
	openmp? (
		sys-devel/gcc[openmp]
	)
"

pkg_setup() {
	check-compiler-switch_start
}

src_prepare() {
	cp -a \
		"${DISTDIR}/gmic_stdlib_community$(ver_rs 1- '').h" \
		"src/gmic_stdlib_community.h" \
		|| die
	cmake_src_prepare
}

src_configure() {
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

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	local mycmakeargs=(
		-DBUILD_CLI=$(usex cli ON OFF)
		-DBUILD_LIB=ON
		-DBUILD_LIB_STATIC=$(usex static-libs ON OFF)
		-DBUILD_MAN=$(usex cli ON OFF)
		-DBUILD_BASH_COMPLETION=$(usex cli $(usex bash-completion ON OFF) OFF)
		-DCUSTOM_CFLAGS=ON
		-DENABLE_CURL=$(usex curl)
		-DENABLE_DYNAMIC_LINKING=ON
		-DENABLE_FFMPEG=$(usex ffmpeg ON OFF)
		-DENABLE_FFTW=$(usex fftw ON OFF)
		-DENABLE_GRAPHICSMAGICK=$(usex graphicsmagick ON OFF)
		-DENABLE_JPEG=$(usex jpeg ON OFF)
		-DENABLE_OPENCV=$(usex opencv ON OFF)
		-DENABLE_OPENEXR=$(usex openexr ON OFF)
		-DENABLE_OPENMP=$(usex openmp ON OFF)
		-DENABLE_PNG=$(usex png ON OFF)
		-DENABLE_TIFF=$(usex tiff ON OFF)
		-DENABLE_ZLIB=ON
		-DENABLE_X=$(usex X ON OFF)
		-DUSE_SYSTEM_CIMG=ON
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	dodoc "README"

	# - The Gimp plugin dir is also searched by non-Gimp tools, and it's
	#   hardcoded in "gmic_stdlib.gmic"
	# - Using the GMIC_SYSTEM_PATH env var to specify another system dir
	#   here might mean that this big file will be automatically downloaded
	#   in "~/.config/gmic/" when the user runs a tool before updating and
	#   sourcing the new environment.
	local PLUGIN_DIR
	if has_version "media-gfx/gimp:0/2" ; then
		PLUGIN_DIR="/usr/$(get_libdir)/gimp/2.0/plug-ins/gmic_gimp_qt"
	elif has_version "media-gfx/gimp:0/3" ; then
		PLUGIN_DIR="/usr/$(get_libdir)/gimp/2.99/plug-ins/gmic_gimp_qt"
	fi
	mkdir -p "${ED}/${PLUGIN_DIR}" || die
	insinto "${PLUGIN_DIR}"	|| die
	if [[ -e "resources/gmic_cluts.gmz" ]] ; then
einfo "Adding gmic_cluts.gmz"
		doins "resources/gmic_cluts.gmz" || die
	else
einfo "Skipping gmic_cluts.gmz"
	fi

	cmake_src_install

	# By default, "gmic.cpp" includes "gmic.h" which defines "cimg_plugin"
	# to "gmic.cpp" and then includes "CImg.h" which includes "cimg_plugin"
	# which is "gmic.cpp", of course.
	#
	# Yes, upstream is bad and they should feel bad. Undo this madness so we
	# can build media-gfx/zart using the installed "gmic.h".
	sed -i -e '/^#define cimg.*_plugin/d' "${ED}/usr/include/gmic.h" || die "sed failed"

	if use cli && use bash-completion ; then
		newbashcomp \
			"${WORKDIR}/${PN}-v.${PV}_build/resources/${PN}_bashcompletion.sh" \
			"${PN}"
	fi
}

pkg_postinst() {
	optfeature_header "Install optional packages:"
	optfeature "GIMP plugin or standalone GUI support" "media-gfx/gmic-qt"
}
