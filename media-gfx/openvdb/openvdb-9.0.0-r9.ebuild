# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Based on openvdb-7.1.0-r1.ebuild from the gentoo overlay

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit cmake flag-o-matic python-single-r1

DESCRIPTION="Library for the efficient manipulation of volumetric data"
LICENSE="MPL-2.0"
HOMEPAGE="https://www.openvdb.org"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
SLOT="0"
OPENVDB_ABIS=( 10 9 8 7 6 )
OPENVDB_ABIS_=( ${OPENVDB_ABIS[@]/#/abi} )
OPENVDB_ABIS_=( ${OPENVDB_ABIS_[@]/%/-compat} )
X86_CPU_FLAGS=( avx sse4_2 )
IUSE+="
${X86_CPU_FLAGS[@]/#/cpu_flags_x86_}
${OPENVDB_ABIS_[@]} +abi$(ver_cut 1 ${PV})-compat
ax +blosc cuda doc -imath-half +jemalloc -log4cplus -numpy -python +static-libs
-tbbmalloc nanovdb -no-concurrent-malloc -openexr test -vdb_lod +vdb_print
-vdb_render -vdb_view
"
VDB_UTILS="
	vdb_lod
	vdb_print
	vdb_render
	vdb_view
"
# For abi versions, see https://github.com/AcademySoftwareFoundation/openvdb/blob/v9.0.0/CMakeLists.txt#L256
REQUIRED_USE+="
	^^ (
		${OPENVDB_ABIS_[@]}
	)
	^^ (
		jemalloc
		tbbmalloc
		no-concurrent-malloc
	)
	jemalloc? (
		|| (
			${VDB_UTILS}
			test
		)
	)
	numpy? (
		python
	)
	python? (
		${PYTHON_REQUIRED_USE}
	)
"

# See
# https://github.com/AcademySoftwareFoundation/openvdb/blob/v9.0.0/doc/dependencies.txt
# https://github.com/AcademySoftwareFoundation/openvdb/blob/v9.0.0/ci/install.sh
LEGACY_TBB_SLOT="2"
OPENEXR_V2_PV="2.5.8 2.5.7"
OPENEXR_V3_PV="3.1.7 3.1.5 3.1.4"
ONETBB_SLOT="0"

gen_openexr_pairs() {
	local pv
	for pv in ${OPENEXR_V2_PV} ; do
		echo "
			(
				openexr? (
					~media-libs/openexr-${pv}:=
				)
				imath-half? (
					~media-libs/ilmbase-${pv}:=
				)
			)
		"
	done
	for pv in ${OPENEXR_V3_PV} ; do
		echo "
			(
				openexr? (
					~media-libs/openexr-${pv}:=
				)
				imath-half? (
					~dev-libs/imath-${pv}:=
				)
			)
		"
	done
}

DEPEND+="
	|| (
                $(gen_openexr_pairs)
                !openexr? (
			!imath-half? (
				virtual/libc
			)
		)
        )
	|| (
		(
			!<dev-cpp/tbb-2021:0=
			<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}=
			>=dev-cpp/tbb-2018.0:${LEGACY_TBB_SLOT}=
		)
		(
			>=dev-cpp/tbb-2021:${ONETBB_SLOT}=
		)
	)
	>=dev-libs/boost-1.66:=
	>=sys-libs/zlib-1.2.7:=
	ax? (
		<sys-devel/llvm-15:=
	)
	blosc? (
		>=dev-libs/c-blosc-1.17:=
	)
	jemalloc? (
		dev-libs/jemalloc:=
	)
	log4cplus? (
		>=dev-libs/log4cplus-1.1.2:=
	)
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			>=dev-libs/boost-1.68:=[numpy?,python?,${PYTHON_USEDEP}]
			numpy? (
				>=dev-python/numpy-1.14[${PYTHON_USEDEP}]
			)
		')
	)
	vdb_view? (
		>=media-libs/glfw-3.1
		>=media-libs/glfw-3.3
		media-libs/glu
		media-libs/mesa[egl(+)]
		virtual/opengl
		x11-libs/libX11
		x11-libs/libXcursor
		x11-libs/libXi
		x11-libs/libXinerama
		x11-libs/libXrandr
		x11-libs/libXxf86vm
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=dev-util/cmake-3.16.2-r1
	>=sys-devel/bison-3
	>=sys-devel/flex-2.6
	dev-util/patchelf
	virtual/pkgconfig
	doc? (
		>=app-doc/doxygen-1.8.8
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
	test? (
		>=dev-cpp/gtest-1.10
		>=dev-util/cppunit-1.10
	)
	|| (
		>=sys-devel/gcc-6.3.1
		(
			<sys-devel/clang-15
			>=sys-devel/clang-3.8
		)
		>=dev-lang/icc-17
	)
"
PDEPEND="
	nanovdb? (
		~media-gfx/nanovdb-32.3.3_p20211029[cuda?,openvdb]
	)
"
SRC_URI="
https://github.com/AcademySoftwareFoundation/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
"
PATCHES=(
	"${FILESDIR}/${PN}-8.1.0-glfw-libdir.patch"
	"${FILESDIR}/${PN}-9.0.0-fix-atomic.patch"
	"${FILESDIR}/${PN}-9.0.0-numpy.patch"
	"${FILESDIR}/${PN}-9.0.0-unconditionally-search-Python-interpreter.patch"
)
RESTRICT="!test? ( test )"

is_crosscompile() {
	[[ ${CHOST} != ${CTARGET} ]]
}

pkg_setup() {
	use python && python-single-r1_pkg_setup
	if ! is_crosscompile && which jemalloc-confg ; then
		if jemalloc-config --cflags | grep -q -e "cfi" ; then
			ewarn "jemalloc may need rebuild if vdb_print -version stalls."
		fi
	fi
	use ax && llvm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	sed -i -e "s|lib/cmake|$(get_libdir)/cmake|g" \
		cmake/OpenVDBGLFW3Setup.cmake || die
#	if has_version ">=dev-cpp/tbb-2021:${ONETBB_SLOT}" ; then
		eapply "${FILESDIR}/extra-patches/${PN}-8.1.0-findtbb-more-debug-messages.patch"
		eapply "${FILESDIR}/extra-patches/${PN}-8.1.0-prioritize-onetbb.patch"
#	fi
}

check_clang() {
	local found=0
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		if has_version "sys-devel/clang:${s}" ; then
			found=1
			export CC="${CHOST}-clang-${s}"
			export CXX="${CHOST}-clang++-${s}"
			break
		fi
	done
	if (( ${found} == 0 )) ; then
eerror
eerror "${PN} requires either clang ${LLVM_SLOTS[@]}"
eerror
eerror "Either use GCC or install and use one of those clang slots."
eerror
		die
	fi
	clang --version || die
}

src_configure() {
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	tc-is-clang && check_clang
	export MAKEOPTS="-j1" # prevent stall

	local version
	for s in ${OPENVDB_ABIS[@]} ; do
		if use "abi${s}-compat" ; then
			version=${s}
		fi
	done

	local mycmakeargs=(
		-DCHOST="${CHOST}"
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}/"
		-DCONCURRENT_MALLOC=$(usex jemalloc "Jemalloc" \
					$(usex tbbmalloc "Tbbmalloc" "None")\
				     )
		-DOPENVDB_ABI_VERSION_NUMBER="${version}"
		-DOPENVDB_BUILD_BINARIES=$(usex vdb_lod ON \
						$(usex vdb_print ON \
							$(usex vdb_render ON \
								$(usex vdb_view ON OFF))\
						)\
					)
		-DOPENVDB_BUILD_DOCS=$(usex doc)
		-DOPENVDB_BUILD_PYTHON_MODULE=$(usex python)
		-DOPENVDB_BUILD_UNITTESTS=$(usex test)
		-DOPENVDB_BUILD_VDB_LOD=$(usex vdb_lod)
		-DOPENVDB_BUILD_VDB_PRINT=$(usex vdb_print)
		-DOPENVDB_BUILD_VDB_RENDER=$(usex vdb_render)
		-DOPENVDB_BUILD_VDB_VIEW=$(usex vdb_view)
		-DOPENVDB_CORE_SHARED=ON
		-DOPENVDB_CORE_STATIC=$(usex static-libs)
		-DOPENVDB_ENABLE_RPATH=OFF
		-DUSE_BLOSC=$(usex blosc)
		-DUSE_CCACHE=OFF
		-DUSE_COLORED_OUTPUT=ON
		-DUSE_EXR=$(usex openexr)
		-DUSE_IMATH_HALF=$(usex imath-half)
		-DUSE_LOG4CPLUS=$(usex log4cplus)
	)

	if use ax; then
		mycmakeargs+=(
			-DOPENVDB_AX_STATIC=$(usex static-libs)

	# FIXME: log4cplus init and other errors
			-DOPENVDB_BUILD_AX_UNITTESTS=OFF
		)
	fi

	if use python; then
		mycmakeargs+=(
			-DPYOPENVDB_INSTALL_DIRECTORY="$(python_get_sitedir)"
			-DPython_EXECUTABLE="${PYTHON}"
			-DPython_INCLUDE_DIR="$(python_get_includedir)"
			-DUSE_NUMPY=$(usex numpy)
		)
	fi

	if use cpu_flags_x86_avx; then
		mycmakeargs+=( -DOPENVDB_SIMD=AVX )
	elif use cpu_flags_x86_sse4_2; then
		mycmakeargs+=( -DOPENVDB_SIMD=SSE42 )
	fi

	if has_version ">=dev-cpp/tbb-2021:${ONETBB_SLOT}" ; then
		einfo "Using oneTBB"
		mycmakeargs+=(
			-DUSE_PKGCONFIG=ON
			-DTbb_INCLUDE_DIR="${ESYSROOT}/usr/include"
			-DTBB_LIBRARYDIR="${ESYSROOT}/usr/$(get_libdir)"
			-DTBB_FORCE_ONETBB=ON
			-DTBB_SLOT=""
		)
	elif has_version "<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}" ; then
		einfo "Legacy TBB"
		mycmakeargs+=(
			-DUSE_PKGCONFIG=ON
			-DTbb_INCLUDE_DIR="${ESYSROOT}/usr/include/tbb/${LEGACY_TBB_SLOT}"
			-DTBB_LIBRARYDIR="${ESYSROOT}/usr/$(get_libdir)/tbb/${LEGACY_TBB_SLOT}"
			-DTBB_FORCE_ONETBB=OFF
			-DTBB_SLOT="-${LEGACY_TBB_SLOT}"
		)
	fi

	cmake_src_configure
}

src_install()
{
	cmake_src_install
	dodoc README.md
	docinto licenses
	dodoc LICENSE openvdb/openvdb/COPYRIGHT
	if has_version ">=dev-cpp/tbb-2021:${ONETBB_SLOT}" ; then
		:;
	elif has_version "<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}" ; then
		for f in $(find "${ED}") ; do
			if readelf -h "${f}" 2>/dev/null 1>/dev/null && test -x "${f}" ; then
				einfo "Setting rpath for ${f}"
				patchelf --set-rpath "${EPREFIX}/usr/$(get_libdir)/tbb/${LEGACY_TBB_SLOT}" \
					"${f}" || die
			fi
		done
	fi

	if ! is_crosscompile && which "${ED}/usr/bin/vdb_print" ; then
		if ! timeout 1 "${ED}/usr/bin/vdb_print" -version \
			| grep -q -e "OpenVDB library version:" ; then
# Possible CFI problems
eerror
eerror "Detected vdb_print stall.  Re-emerge jemalloc and openvdb packages."
eerror "or emerge openvdb with the no-concurrent-malloc USE flag."
eerror
			die
		fi
	fi
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  link-to-multislot-tbb
