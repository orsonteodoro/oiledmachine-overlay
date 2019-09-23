# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils flag-o-matic linux-info toolchain-funcs

DESCRIPTION="Collection of high-performance ray tracing kernels"
HOMEPAGE="https://github.com/embree/embree"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
SRC_URI="https://github.com/embree/embree/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SLOT="3"
X86_CPU_FLAGS=( sse2:sse2 sse4_2:sse4_2 avx:avx avx2:avx2 avx512knl:avx512knl avx512skx:avx512skx )
CPU_FLAGS=( ${X86_CPU_FLAGS[@]/#/cpu_flags_x86_} )
IUSE="clang ispc raymask -ssp +tbb tutorial static-libs ${CPU_FLAGS[@]%:*}"
REQUIRED_USE="clang? ( !tutorial )"
BDEPEND="clang? ( sys-devel/clang )
	 virtual/pkgconfig"
RDEPEND="ispc? ( dev-lang/ispc )
	 >=media-libs/glfw-3.2.1
	 tbb? ( dev-cpp/tbb )
	 tutorial? ( >=media-libs/libpng-1.6.34:0=
		     >=media-libs/openimageio-1.8.7
		       virtual/jpeg:0 )
	 virtual/opengl"
DEPEND="${RDEPEND}"
DOCS=( CHANGELOG.md README.md readme.pdf )
CMAKE_BUILD_TYPE=Release

pkg_setup() {
	CONFIG_CHECK="~TRANSPARENT_HUGEPAGE"
	WARNING_TRANSPARENT_HUGEPAGE="Not enabling Transparent Hugepages (CONFIG_TRANSPARENT_HUGEPAGE) will impact rendering performance."
	linux-info_pkg_setup

	if ! ( cat /proc/cpuinfo | grep sse2 > /dev/null ) ; then
		die "You need a CPU with at least sse2 support"
	fi
}

src_prepare() {
	cmake-utils_src_prepare

	# disable RPM package building
	sed -e 's|CPACK_RPM_PACKAGE_RELEASE 1|CPACK_RPM_PACKAGE_RELEASE 0|' \
		-i CMakeLists.txt || die
	# change -O3 settings for various compilers
	sed -e 's|-O3|-O2|' -i "${S}"/common/cmake/{clang,gnu,intel,ispc}.cmake || die
}

src_configure() {
	if use clang; then
		export CC=clang
		export CXX=clang++
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
#		-DCMAKE_C_COMPILER=$(tc-getCC)
#		-DCMAKE_CXX_COMPILER=$(tc-getCXX)
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
		-DEMBREE_TUTORIALS=$(usex tutorial) )

	if use tutorial; then
		mycmakeargs+=(
			-DEMBREE_ISPC_ADDRESSING:STRING="64"
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

src_install() {
	cmake-utils_src_install

	doenvd "${FILESDIR}"/99${PN}${SLOT}
}
