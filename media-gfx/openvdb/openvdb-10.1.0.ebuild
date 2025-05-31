# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Based on openvdb-7.1.0-r1.ebuild from the distro overlay
# For abi versions, see https://github.com/AcademySoftwareFoundation/openvdb/blob/v10.1.0/CMakeLists.txt#L256
# For deps versioning, see https://github.com/AcademySoftwareFoundation/openvdb/blob/v10.1.0/doc/dependencies.txt

EAPI=8

LEGACY_TBB_SLOT="2"
LLVM_COMPAT=( {15..10} ) # Max limit for Blender
LLVM_COMPAT_AX=( {14..10} )
LLVM_MAX_SLOT="${LLVM_COMPAT[0]}"
ONETBB_SLOT="0"
OPENEXR_V2_PV=(
	# openexr:imath
	"2.5.11:2.5.11"
	"2.5.10:2.5.10"
	"2.5.9:2.5.9"
	"2.5.8:2.5.8"
	"2.5.7:2.5.7"
	"2.5.6:2.5.6"
	"2.5.5:2.5.5"
	"2.5.4:2.5.4"
	"2.5.3:2.5.3"
	"2.5.2:2.5.2"
	"2.5.0:2.5.0"
	"2.4.3:2.4.3"
	"2.4.2:2.4.2"
	"2.4.1:2.4.1"
	"2.4.0:2.4.0"
)
OPENEXR_V3_PV=(
	# openexr:imath
	"3.3.2:3.1.12"
	"3.3.1:3.1.12"
	"3.3.0:3.1.11"
	"3.2.4:3.1.10"
	"3.2.3:3.1.10"
	"3.2.2:3.1.9"
	"3.2.1:3.1.9"
	"3.2.0:3.1.9"
	"3.1.13:3.1.9"
	"3.1.12:3.1.9"
	"3.1.11:3.1.9"
	"3.1.10:3.1.9"
	"3.1.9:3.1.9"
	"3.1.8:3.1.8"
	"3.1.7:3.1.7"
	"3.1.6:3.1.5"
	"3.1.5:3.1.5"
	"3.1.4:3.1.4"
	"3.1.3:3.1.0"
	"3.1.2:3.1.0"
	"3.1.0:3.1.0"
)
OPENVDB_ABIS=( 10 9 8 )
OPENVDB_ABIS_=( ${OPENVDB_ABIS[@]/#/abi} )
OPENVDB_ABIS_=( ${OPENVDB_ABIS_[@]/%/-compat} )
PYTHON_COMPAT=( python3_{8..11} )
VDB_UTILS="
	vdb_lod
	vdb_print
	vdb_render
	vdb_view
"
X86_CPU_FLAGS=( avx sse4_2 )

inherit check-compiler-switch cmake flag-o-matic llvm python-single-r1 toolchain-funcs

KEYWORDS="~amd64"
SRC_URI="
https://github.com/AcademySoftwareFoundation/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Library for the efficient manipulation of volumetric data"
LICENSE="MPL-2.0"
HOMEPAGE="
	https://www.openvdb.org
	https://github.com/AcademySoftwareFoundation/openvdb
"
RESTRICT="
	!test? (
		test
	)
"
SLOT="0"
IUSE+="
${LLVM_COMPAT[@]/#/llvm_slot_}
${OPENVDB_ABIS_[@]} +abi$(ver_cut 1 ${PV})-compat
${X86_CPU_FLAGS[@]/#/cpu_flags_x86_}
-alembic ax +blosc cuda doc -imath-half +jemalloc -jpeg -log4cplus -numpy
-python +static-libs -tbbmalloc nanovdb -no-concurrent-malloc -openexr -png test
-vdb_lod +vdb_print -vdb_render -vdb_view
ebuild_revision_4
"
REQUIRED_USE+="
	^^ (
		${OPENVDB_ABIS_[@]}
	)
	^^ (
		jemalloc
		tbbmalloc
		no-concurrent-malloc
	)
	ax? (
		^^ (
			${LLVM_COMPAT_AX[@]/#/llvm_slot_}
		)
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
gen_openexr_pairs() {
	local row
	for row in ${OPENEXR_V2_PV[@]} ; do
		local ilmbase_pv="${row#*:}"
		local openexr_pv="${row%:*}"
		echo "
			(
				openexr? (
					~media-libs/openexr-${openexr_pv}:=
				)
				imath-half? (
					~media-libs/ilmbase-${ilmbase_pv}:=
				)
			)
		"
	done
	for row in ${OPENEXR_V3_PV[@]} ; do
		local imath_pv="${row#*:}"
		local openexr_pv="${row%:*}"
		echo "
			(
				openexr? (
					~media-libs/openexr-${openexr_pv}:=
				)
				imath-half? (
					~dev-libs/imath-${imath_pv}:=
				)
			)
		"
	done
}
gen_ax_depend() {
	local s
	for s in ${LLVM_COMPAT_AX[@]} ; do
		local imath_pv="${row#*:}"
		local openexr_pv="${row%:*}"
		echo "
			llvm_slot_${s}? (
				=llvm-core/clang-${s}*
				=llvm-core/llvm-${s}*
			)
		"
	done
}
RDEPEND+="
	>=dev-libs/boost-1.73:=
	>=sys-libs/zlib-1.2.7:=
	ax? (
		$(gen_ax_depend)
	)
	blosc? (
		>=dev-libs/c-blosc-1.17.0:=
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
			>=dev-python/pybind11-2.10.0[${PYTHON_USEDEP}]
			numpy? (
				>=dev-python/numpy-1.19.0[${PYTHON_USEDEP}]
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
		png? (
			media-libs/libpng
		)
	)
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
			>=dev-cpp/tbb-2020.2:${LEGACY_TBB_SLOT}=
		)
		(
			>=dev-cpp/tbb-2021:${ONETBB_SLOT}=
		)
	)
"
DEPEND+="
	${RDEPEND}
"
gen_llvm_bdepend() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				=llvm-core/clang-${s}*
				=llvm-core/llvm-${s}*
			)
		"
	done
}
BDEPEND+="
	>=dev-build/cmake-3.18
	>=sys-devel/bison-3.0.0
	>=sys-devel/flex-2.6.0
	dev-util/patchelf
	virtual/pkgconfig
	doc? (
		>=app-text/doxygen-1.8.8
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
		$(gen_llvm_bdepend)
		>=sys-devel/gcc-9.3.1
		>=dev-lang/icc-19
	)
"
PDEPEND="
	nanovdb? (
		~media-gfx/nanovdb-32.4.2_p20231004[cuda?,openvdb]
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-8.1.0-glfw-libdir.patch"
	"${FILESDIR}/${PN}-9.0.0-fix-atomic.patch"
	"${FILESDIR}/${PN}-10.0.1-fix-linking-of-vdb_tool-with-OpenEXR.patch"
	"${FILESDIR}/${PN}-10.0.1-drop-failing-tests.patch"
	"${FILESDIR}/${PN}-10.0.1-log4cplus-version.patch"
)

is_crosscompile() {
	[[ "${CHOST}" != "${CTARGET}" ]]
}

pkg_setup() {
	check-compiler-switch_start
	python-single-r1_pkg_setup
	if ! is_crosscompile && which jemalloc-confg ; then
		if jemalloc-config --cflags | grep -q -e "cfi" ; then
			ewarn "jemalloc may need rebuild if vdb_print -version stalls."
		fi
	fi
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		if use "llvm_slot_${s}" ; then
			LLVM_MAX_SLOT="${s}"
			llvm_pkg_setup
			break
		fi
	done
}

src_prepare() {
	cmake_src_prepare
	sed -i -e "s|lib/cmake|$(get_libdir)/cmake|g" \
		cmake/OpenVDBGLFW3Setup.cmake || die
#	if has_version ">=dev-cpp/tbb-2021:${ONETBB_SLOT}" ; then
		eapply "${FILESDIR}/extra-patches/${PN}-10.1.0-findtbb-more-debug-messages.patch"
		eapply "${FILESDIR}/extra-patches/${PN}-10.0.1-prioritize-onetbb.patch"
#	fi
}

check_clang() {
	local found=0
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		if has_version "llvm-core/clang:${s}" ; then
			found=1
			export CC="${CHOST}-clang-${s}"
			export CXX="${CHOST}-clang++-${s}"
			export CPP="${CC} -E"
			strip-unsupported-flags
			break
		fi
	done

	if (( ${found} == 0 )) ; then
eerror
eerror "${PN} requires either clang ${LLVM_COMPAT[@]}"
eerror
eerror "Either use GCC or install and use one of those clang slots."
eerror
		die
	fi

	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	clang --version || die
}

src_configure() {
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export CPP=$(tc-getCPP)
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

	if (( ${version} < ${PV%%.*} )) ; then
		mycmakeargs+=(
			-DOPENVDB_USE_DEPRECATED_ABI_${version}=ON
		)
	fi

	if use ax; then
		mycmakeargs+=(
			-DOPENVDB_AX_STATIC=$(usex static-libs)

	# FIXME: log4cplus init and other errors
			-DOPENVDB_BUILD_AX_UNITTESTS=OFF

			-DOPENVDB_BUILD_VDB_AX=$(usex utils)
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
ewarn
ewarn "If the following similar error is encountered, manually delete the file listed"
ewarn "KeyError: [...] (/usr/lib64/libopenvdb.so.<SO_VERSION>) not in object list'"
ewarn
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  link-to-multislot-tbb
