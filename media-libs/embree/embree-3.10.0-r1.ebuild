# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils flag-o-matic linux-info toolchain-funcs

DESCRIPTION="Collection of high-performance ray tracing kernels"
HOMEPAGE="https://github.com/embree/embree"
LICENSE="Apache-2.0
	 tutorials? ( Apache-2.0 MIT )
	 static-libs? ( BSD BZIP2 MIT ZLIB )"
KEYWORDS="~amd64 ~x86"
SRC_URI="https://github.com/embree/embree/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SLOT="3"
X86_CPU_FLAGS=( sse2:sse2 sse4_2:sse4_2 avx:avx avx2:avx2 avx512knl:avx512knl \
avx512skx:avx512skx )
CPU_FLAGS=( ${X86_CPU_FLAGS[@]/#/cpu_flags_x86_} )
IUSE="clang debug doc doc-docfiles doc-html doc-images doc-man gcc icc ispc \
raymask -ssp static-libs +tbb tutorials ${CPU_FLAGS[@]%:*}"
REQUIRED_USE="^^ ( clang gcc icc )"
MIN_CLANG_V="3.3" # for c++11
MIN_CLANG_V_AVX512KNL="3.4" # for -march=knl
MIN_CLANG_V_AVX512SKX="3.6" # for -march=skx
MIN_GCC_V="4.8.1" # for c++11
MIN_GCC_V_AVX512KNL="4.9.1" # for -mavx512er
MIN_GCC_V_AVX512SKX="5.1.0" # for -mavx512vl
MIN_ICC_V="15.0" # for c++11
MIN_ICC_V_AVX512KNL="14.0.1" # for -xMIC-AVX512
MIN_ICC_V_AVX512SKX="15.0.1" # for -xCORE-AVX512
# 15.0.1 -xCOMMON-AVX512
BDEPEND="clang? (
		>=sys-devel/clang-${MIN_CLANG_V}
		cpu_flags_x86_avx512knl? (
			>=sys-devel/clang-${MIN_CLANG_V_AVX512KNL}
		)
		cpu_flags_x86_avx512skx? (
			>=sys-devel/clang-${MIN_CLANG_V_AVX512SKX}
		)
	 )
	 gcc? (
		>=sys-devel/gcc-${MIN_GCC_V}
		cpu_flags_x86_avx512knl? (
			>=sys-devel/gcc-${MIN_GCC_V_AVX512KNL}
		)
		cpu_flags_x86_avx512skx? (
			>=sys-devel/gcc-${MIN_GCC_V_AVX512SKX}
		)
	 )
	 icc? (
		>=sys-devel/icc-${MIN_ICC_V}
		cpu_flags_x86_avx512knl? (
			>=sys-devel/icc-${MIN_ICC_V_AVX512KNL}
		)
		cpu_flags_x86_avx512skx? (
			>=sys-devel/icc-${MIN_ICC_V_AVX512SKX}
		)
	 )
	 doc? (
		app-text/pandoc
		dev-texlive/texlive-xetex
	 )
	 doc-html? (
		app-text/pandoc
		media-gfx/imagemagick[jpeg]
	 )
	 doc-images? (
		media-gfx/imagemagick[jpeg]
		media-gfx/xfig
	 )
	 virtual/pkgconfig"
RDEPEND=">=dev-util/cmake-3.1.0
	 ispc? ( >=dev-lang/ispc-1.8.2 )
	 media-libs/glfw
	 tbb? ( dev-cpp/tbb )
	 tutorials? ( media-libs/libpng:0=
		     media-libs/openimageio
		     virtual/jpeg:0 )
	 virtual/opengl"
DEPEND="${RDEPEND}"
DOCS=( CHANGELOG.md README.md readme.pdf )
CMAKE_BUILD_TYPE=Release
PATCHES=( "${FILESDIR}/${PN}-3.10.0-tutorials-oiio-unique_ptr-to-auto.patch" )

pkg_setup() {
	export CMAKE_BUILD_TYPE=$(usex debug "RelWithDebInfo" "Release")
	CONFIG_CHECK="~TRANSPARENT_HUGEPAGE"
	WARNING_TRANSPARENT_HUGEPAGE=\
"Not enabling Transparent Hugepages (CONFIG_TRANSPARENT_HUGEPAGE) will \n\
impact rendering performance."
	linux-info_pkg_setup

	if ! ( cat /proc/cpuinfo | grep sse2 > /dev/null ) ; then
		die "You need a CPU with at least sse2 support"
	fi

	# This resolves multiple installed compilers or multiple version scenario.
	if use clang ; then
		export CC=clang
		export CXX=clang++
		local cc_v=$(clang-fullversion)
		if ver_test ${cc_v} -lt ${MIN_CLANG_V} ; then
			die \
"You need to switch your Clang compiler to at least ${MIN_CLANG_V} or higher \n\
for c++11 support."
		fi
		if ver_test ${cc_v} -lt ${MIN_CLANG_V_AVX512KNL} \
			&& use cpu_flags_x86_avx512knl ; then
			die \
"You need to switch your Clang compiler to at least ${MIN_CLANG_V_AVX512KNL} \n\
or higher for AVX512-KNL support."
		fi
		if ver_test ${cc_v} -lt ${MIN_CLANG_V_AVX512SKX} \
			&& use cpu_flags_x86_avx512skx ; then
			die \
"You need to switch your Clang compiler to at least ${MIN_CLANG_V_AVX512SKX} \n\
or higher for AVX512-SKX support."
		fi
	elif use icc ; then
		export CC=icc
		export CXX=icpc
		local cc_v=$(icpc --version | head -n 1 | cut -f 3 -d " ")
		if ver_test ${cc_v} -lt ${MIN_ICC_V} ; then
			die \
"You need to switch your icc compiler to at least ${MIN_ICC_V} or higher \n\
for c++11 support."
		fi
		if ver_test ${cc_v} -lt ${MIN_ICC_V_AVX512KNL} \
			&& use cpu_flags_x86_avx512knl ; then
			die \
"You need to switch your icc compiler to at least ${MIN_ICC_V_AVX512KNL} or \n\
higher for AVX512-KNL support."
		fi
		if ver_test ${cc_v} -lt ${MIN_ICC_V_AVX512SKX} \
			&& use cpu_flags_x86_avx512skx ; then
			die \
"You need to switch your icc compiler to at least ${MIN_ICC_V_AVX512SKX} or \n\
higher for AVX512-SKX support."
		fi
	else
		export CC=${CC_ALT:-gcc}
		export CXX=${CXX_ALT:-g++}
		if tc-is-gcc ; then
			local cc_v=$(gcc-fullversion)
			if ver_test ${cc_v} -lt ${MIN_GCC_V} ; then
				die \
"You need to switch your GCC compiler to at least ${MIN_GCC_V} or higher \n\
for c++11 support."
			fi
			if ver_test ${cc_v} -lt ${MIN_GCC_V_AVX512KNL} \
				&& use cpu_flags_x86_avx512knl ; then
				die \
"You need to switch your GCC compiler to at least ${MIN_GCC_V_AVX512KNL} or \n\
higher for AVX512-KNL support."
			fi
			if ver_test ${cc_v} -lt ${MIN_GCC_V_AVX512SKX} \
				&& use cpu_flags_x86_avx512skx ; then
				die \
"You need to switch your GCC compiler to at least ${MIN_GCC_V_AVX512SKX} or \n\
higher for AVX512-SKL support."
			fi
		else
			ewarn "Unrecognized compiler"
			ewarn "CC=${CC}"
			ewarn "CXX=${CXX}"
		fi
	fi

	if use doc-html ; then
		if has network-sandbox $FEATURES ; then
			die \
"${PN} requires network-sandbox to be disabled in FEATURES to be able to use\n\
MathJax for math rendering."
		fi
		ewarn \
"Building package may exhibit random failures with doc-html USE flag.  Emerge\n\
and try again."
	fi
}

src_prepare() {
	cmake-utils_src_prepare

	# disable RPM package building
	sed -e 's|CPACK_RPM_PACKAGE_RELEASE 1|CPACK_RPM_PACKAGE_RELEASE 0|' \
		-i CMakeLists.txt || die
	# change -O3 settings for various compilers
	sed -e 's|-O3|-O2|' -i \
		"${S}"/common/cmake/{clang,gnu,intel,ispc}.cmake || die
}

src_configure() {
	if use clang; then
		strip-flags
		filter-flags "-frecord-gcc-switches"
		filter-ldflags "-Wl,--as-needed"
		filter-ldflags "-Wl,-O1"
		filter-ldflags "-Wl,--defsym=__gentoo_check_ldflags__=0"
	fi

# FIXME:
#	any option with a comment # default at the end of the line is
#	currently set to use default value. Some of them could probably
#	be turned into USE flags.
#
#	EMBREE_CURVE_SELF_INTERSECTION_AVOIDANCE_FACTOR: leave it at 2.0f for now
#		0.0f disables self intersection avoidance.
#
# The build currently only works with their own C{,XX}FLAGS,
# not respecting user flags.
#		-DEMBREE_IGNORE_CMAKE_CXX_FLAGS=OFF
	local mycmakeargs=(
		-DBUILD_TESTING:BOOL=OFF
		-DCMAKE_C_COMPILER=${CC}
		-DCMAKE_CXX_COMPILER=${CXX}
		-DCMAKE_SKIP_INSTALL_RPATH:BOOL=ON
		-DEMBREE_BACKFACE_CULLING=OFF			# default
		-DEMBREE_FILTER_FUNCTION=ON			# default
		-DEMBREE_GEOMETRY_CURVE=ON			# default
		-DEMBREE_GEOMETRY_GRID=ON			# default
		-DEMBREE_GEOMETRY_INSTANCE=ON			# default
		-DEMBREE_GEOMETRY_POINT=ON			# default
		-DEMBREE_GEOMETRY_QUAD=ON			# default
		-DEMBREE_GEOMETRY_SUBDIVISION=ON		# default
		-DEMBREE_GEOMETRY_TRIANGLE=ON			# default
		-DEMBREE_GEOMETRY_USER=ON			# default
		-DEMBREE_IGNORE_INVALID_RAYS=OFF		# default
		-DEMBREE_ISPC_SUPPORT=$(usex ispc)
		-DEMBREE_RAY_MASK=$(usex raymask)
		-DEMBREE_RAY_PACKETS=ON				# default
		-DEMBREE_STACK_PROTECTOR=$(usex ssp)
		-DEMBREE_STATIC_LIB=$(usex static-libs)
		-DEMBREE_STAT_COUNTERS=OFF
		-DEMBREE_TASKING_SYSTEM:STRING=$(usex tbb "TBB" "INTERNAL")
		-DEMBREE_TUTORIALS=$(usex tutorials) )

	if use tutorials; then
		use ispc && \
		mycmakeargs+=( -DEMBREE_ISPC_ADDRESSING:STRING="64" )
		mycmakeargs+=(
			-DEMBREE_TUTORIALS_LIBJPEG=ON
			-DEMBREE_TUTORIALS_LIBPNG=ON
			-DEMBREE_TUTORIALS_OPENIMAGEIO=ON )
	fi

	if use cpu_flags_x86_avx512skx ; then
		mycmakeargs+=( -DEMBREE_MAX_ISA:STRING="AVX512SKX" )
	elif use cpu_flags_x86_avx512knl ; then
		mycmakeargs+=( -DEMBREE_MAX_ISA:STRING="AVX512KNL" )
	elif use cpu_flags_x86_avx2 ; then
		mycmakeargs+=( -DEMBREE_MAX_ISA:STRING="AVX2" )
	elif use cpu_flags_x86_avx ; then
		mycmakeargs+=( -DEMBREE_MAX_ISA:STRING="AVX" )
	elif use cpu_flags_x86_sse4_2 ; then
		mycmakeargs+=( -DEMBREE_MAX_ISA:STRING="SSE4.2" )
	elif use cpu_flags_x86_sse2 ; then
		mycmakeargs+=( -DEMBREE_MAX_ISA:STRING="SSE2" )
	else
		mycmakeargs+=( -DEMBREE_MAX_ISA:STRING="NONE" )
	fi

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	if use doc ; then
		pushd doc || die
			if use doc-images ; then
				einfo "Building doc/images"
				emake images
			fi
			if use doc-docfiles ; then
				einfo "Building doc/doc"
				emake doc
			fi
			if use doc-html ; then
				einfo "Building doc/www"
				emake images www
			fi
			if use doc-man ; then
				einfo "Building doc/man"
				emake man
			fi
		popd || die
	fi
}

src_install() {
	cmake-utils_src_install

	doenvd "${FILESDIR}"/99${PN}${SLOT}

	docinto docs
	if use doc ; then
		dodoc readme.pdf
		doman man/man3/*
		dodoc CHANGELOG.md README.md
	fi
	if use doc-docfiles ; then
		dodoc -r doc/doc
	fi
	if use doc-images ; then
		dodoc -r doc/images
	fi
	if use doc-man ; then
		dodoc -r doc/man/man3
	fi
	if use doc-html ; then
		dodoc -r doc/www
	fi
	if use tutorials ; then
		insinto /usr/share/${PN}/tutorials
		doins -r tutorials/*
	fi
	docinto licenses
	dodoc LICENSE.txt third-party-programs-TBB.txt \
		third-party-programs.txt
}

pkg_postinst() {
	if use tutorials ; then
		einfo \
"The tutorial sources have been installed at /usr/share/${PN}/tutorials"
	fi
}
