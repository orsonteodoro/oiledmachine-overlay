# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils flag-o-matic linux-info toolchain-funcs

DESCRIPTION="Collection of high-performance ray tracing kernels"
HOMEPAGE="https://github.com/embree/embree"
LICENSE="Apache-2.0
	 tutorials? ( Apache-2.0 MIT )
	 static-libs? ( BSD BZIP2 MIT ZLIB )"
KEYWORDS="~amd64 ~arm64 ~x86"
SRC_URI="https://github.com/embree/embree/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SLOT_MAJ="3"
SLOT="${SLOT_MAJ}/${PV}"
X86_CPU_FLAGS=( sse2:sse2 sse4_2:sse4_2 avx:avx avx2:avx2
avx512skx:avx512skx )
ARM_CPU_FLAGS=( neon:neon )
CPU_FLAGS=( ${X86_CPU_FLAGS[@]/#/cpu_flags_x86_}
	${ARM_CPU_FLAGS[@]/#/cpu_flags_arm_} )
IUSE+=" clang custom-cflags debug doc doc-docfiles doc-html doc-images doc-man gcc icc ispc
raymask -ssp static-libs +tbb tutorials ${CPU_FLAGS[@]%:*}"
REQUIRED_USE+=" ^^ ( clang gcc icc )"
MIN_CLANG_V="3.3" # for c++11
MIN_CLANG_V_AVX512SKX="3.6" # for -march=skx
MIN_GCC_V="4.8.1" # for c++11
MIN_GCC_V_AVX512SKX="5.1.0" # for -mavx512vl
MIN_ICC_V="15.0" # for c++11
MIN_ICC_V_AVX512SKX="15.0.1" # for -xCORE-AVX512
ONETBB_SLOT="0"
LEGACY_TBB_SLOT="2"
# 15.0.1 -xCOMMON-AVX512
BDEPEND+=" >=dev-util/cmake-3.1.0
	 ispc? ( >=dev-lang/ispc-1.16.1 )
	 virtual/pkgconfig
	 clang? (
		>=sys-devel/clang-${MIN_CLANG_V}
		cpu_flags_x86_avx512skx? (
			>=sys-devel/clang-${MIN_CLANG_V_AVX512SKX}
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
	 gcc? (
		>=sys-devel/gcc-${MIN_GCC_V}
		cpu_flags_x86_avx512skx? (
			>=sys-devel/gcc-${MIN_GCC_V_AVX512SKX}
		)
	 )
	 icc? (
		>=sys-devel/icc-${MIN_ICC_V}
		cpu_flags_x86_avx512skx? (
			>=sys-devel/icc-${MIN_ICC_V_AVX512SKX}
		)
	 )"
# See .gitlab-ci.yml (track: release-linux-x64-Release)
DEPEND+=" media-libs/glfw
	 virtual/opengl
	 tbb? (
		>=dev-cpp/tbb-2021.3.0:0=
		 <dev-cpp/tbb-2021:2=
	 )
	 tutorials? ( media-libs/libpng:0=
		     media-libs/openimageio
		     virtual/jpeg:0 )"
RDEPEND+=" ${DEPEND}"
DOCS=( CHANGELOG.md README.md readme.pdf )
CMAKE_BUILD_TYPE=Release
PATCHES_=(
	"${FILESDIR}/${PN}-3.13.0-findtbb-more-debug-messages.patch"
	"${FILESDIR}/${PN}-3.13.2-glibc-2.34-catch.hpp-fix.patch"
	"${FILESDIR}/${PN}-3.13.0-findtbb-alt-lib-path.patch"
)

chcxx() {
	die \
"You need to switch your ${1} compiler to at least ${2} or higher \n\
for ${3} support."
}

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
			chcxx "Clang" "${MIN_CLANG_V}" "c++11"
		fi
		if ver_test ${cc_v} -lt ${MIN_CLANG_V_AVX512SKX} \
			&& use cpu_flags_x86_avx512skx ; then
			chcxx "Clang" "${MIN_CLANG_V_AVX512SKX}" "AVX512-SKX"
		fi
	elif use icc ; then
		export CC=icc
		export CXX=icpc
		local cc_v=$(icpc --version | head -n 1 | cut -f 3 -d " ")
		if ver_test ${cc_v} -lt ${MIN_ICC_V} ; then
			chcxx "icc" "${MIN_ICC_V}" "c++11"
		fi
		if ver_test ${cc_v} -lt ${MIN_ICC_V_AVX512SKX} \
			&& use cpu_flags_x86_avx512skx ; then
			chcxx "icc" "${MIN_ICC_V_AVX512SKX}" "AVX512-SKX"
		fi
	else
		export CC=${CC_ALT:-gcc}
		export CXX=${CXX_ALT:-g++}
		if tc-is-gcc ; then
			local cc_v=$(gcc-fullversion)
			if ver_test ${cc_v} -lt ${MIN_GCC_V} ; then
				chcxx "GCC" "${MIN_GCC_V}" "c++11"
			fi
			if ver_test ${cc_v} -lt ${MIN_GCC_V_AVX512SKX} \
				&& use cpu_flags_x86_avx512skx ; then
				chcxx "GCC" "${MIN_GCC_V_AVX512SKX}" "AVX512-SKX"
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
	eapply ${PATCHES_[@]}
	cmake-utils_src_prepare

	# disable RPM package building
	sed -e 's|CPACK_RPM_PACKAGE_RELEASE 1|CPACK_RPM_PACKAGE_RELEASE 0|' \
		-i CMakeLists.txt || die
	# change -O3 settings for various compilers
	sed -e 's|-O3|-O2|' -i \
		"${S}"/common/cmake/{clang,gnu,intel,ispc}.cmake || die
}

src_configure() {
	strip-unsupported-flags

	if tc-is-clang && ! use clang ; then
		eerror
		eerror "Enable the clang USE flag or switch to GCC."
		eerror
		die
	fi

	if ! use custom-cflags ; then
		strip-flags
		filter-flags "-frecord-gcc-switches"
		filter-ldflags "-Wl,--as-needed"
		filter-ldflags "-Wl,-O1"
		filter-ldflags "-Wl,--defsym=__gentoo_check_ldflags__=0"
	fi

	# NOTE: You can make embree accept custom CXXFLAGS by turning off
	# EMBREE_IGNORE_CMAKE_CXX_FLAGS. However, the linking will fail if you use
	# any "march" compile flags. This is because embree builds modules for the
	# different supported ISAs and picks the correct one at runtime.
	# "march" will pull in cpu instructions that shouldn't be in specific modules
	# and it fails to link properly.
	# https://github.com/embree/embree/issues/115

	filter-flags -march=*

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

	if use cpu_flags_arm_neon ; then
		mycmakeargs+=( -DEMBREE_MAX_ISA:STRING="NEON" )
	elif use cpu_flags_x86_avx512skx ; then
		mycmakeargs+=( -DEMBREE_MAX_ISA:STRING="AVX512SKX" )
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

	if use tbb && has_version ">=dev-cpp/tbb-2021:${ONETBB_SLOT}" ; then
		mycmakeargs+=(
			-DTBB_INCLUDE_DIR=/usr/include/
			-DTBB_LIBRARY_DIR=/usr/$(get_libdir)/
			-DTBB_SOVER="${ONETBB_SLOT}"
		)
	elif use tbb && has_version "=dev-cpp/tbb-2020*:2" ; then
		mycmakeargs+=(
			-DTBB_INCLUDE_DIR=/usr/include/tbb/${LEGACY_TBB_SLOT}
			-DTBB_LIBRARY_DIR=/usr/$(get_libdir)/tbb/${LEGACY_TBB_SLOT}
			-DTBB_SOVER="${LEGACY_TBB_SLOT}"
		)
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

	doenvd "${FILESDIR}"/99${PN}${SLOT_MAJ}

	docinto docs
	if use doc ; then
		einstalldocs
		doman man/man3/*
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
	if use tbb && has_version "<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}" ; then
		for f in $(find "${ED}") ; do
			test -L "${f}" && continue
			if ldd "${f}" 2>/dev/null | grep -q -F -e "libtbb" ; then
				einfo "Old rpath for ${f}:"
				patchelf --print-rpath "${f}" || die
				einfo "Setting rpath for ${f}"
				patchelf --set-rpath "/usr/$(get_libdir)/tbb/${LEGACY_TBB_SLOT}" \
					"${f}" || die
			fi
		done
	fi
}

pkg_postinst() {
	if use tutorials ; then
		einfo \
"The tutorial sources have been installed at /usr/share/${PN}/tutorials"
	fi
}
