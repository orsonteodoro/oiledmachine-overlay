# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="A lightweight GPU friendly version of VDB initially targeting \
rendering applications."
HOMEPAGE=\
"https://github.com/AcademySoftwareFoundation/openvdb/tree/feature/nanovdb/nanovdb"
LICENSE="MPL-2.0"
# For versioning, see
# https://github.com/AcademySoftwareFoundation/openvdb/blob/dc37d8a631922e7bef46712947dc19b755f3e841/nanovdb/nanovdb/NanoVDB.h#L68
SLOT="0/$(ver_cut 1-2 ${PV})"
# Live ebuilds do not get keyworded.
# cuda, optix, allow-fetchcontent are enabled upstream by default but
# are disabled
IUSE+=" +benchmark +blosc cuda -doc +examples -imgui +interactive-renderer
-log4cplus -native-file-dialog +opencl optix +opengl -openexr +openvdb
system-glfw +tbb +test test-renderer +tools +zlib"
REQUIRED_USE+="
	benchmark? ( openvdb )
	blosc? ( openvdb )
	interactive-renderer? ( tools )
	log4cplus? ( openvdb )
	native-file-dialog? ( imgui tools )
	openexr? ( openvdb )
	openvdb? ( tbb zlib )
	test? ( openvdb tbb )
	test-renderer? ( test )
"
# For dependencies, see
# https://github.com/AcademySoftwareFoundation/openvdb/blob/dc37d8a631922e7bef46712947dc19b755f3e841/doc/dependencies.txt
ONETBB_SLOT="0"
LEGACY_TBB_SLOT="2"
GTEST_V="1.10.0"
DEPEND_GTEST=" >=dev-cpp/gtest-${GTEST_V}"
# media-gfx/openvdb-7.1[abi7-compat] # Placed here because the constraint has be relaxed.

OPENEXR_V2="2.5.7 2.5.8"
gen_openexr_pairs() {
	local v
	for v in ${OPENEXR_V2} ; do
		echo "
			(
				openexr? ( ~media-libs/openexr-${v}:=[blosc?,log4cplus?,openexr?] )
				~media-libs/ilmbase-${v}:=
			)
		"
	done
}

DEPEND+="
	benchmark? ( ${DEPEND_GTEST} )
	blosc? ( >=dev-libs/c-blosc-1.5 )
	cuda? (
		>=x11-drivers/nvidia-drivers-352.31
		>=dev-util/nvidia-cuda-toolkit-7.5:=
	)
	opencl? (
		virtual/opencl
	)
	opengl? (
		virtual/opengl
	)
	openvdb? (
		|| ( $(gen_openexr_pairs) )
		>=dev-libs/boost-1.68
		>=media-gfx/openvdb-8
	)
	optix? (
		>=dev-libs/optix-7
	)
	tbb? (
		|| (
			(
				>=dev-cpp/tbb-2017.6:${LEGACY_TBB_SLOT}=
				 <dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}=
				!<dev-cpp/tbb-2021:0=
			)
			(
				>=dev-cpp/tbb-2021:${ONETBB_SLOT}=
			)
		)
	)
	tools? (
		media-libs/mesa[egl(+)]
		>=media-libs/glfw-3.3
		interactive-renderer? (
			system-glfw? ( >=media-libs/glfw-3.1 )
			native-file-dialog? (
				>=x11-libs/gtk+-3:3
			)
		)
	)
	zlib? ( >=sys-libs/zlib-1.2.7 )
"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	|| (
		>=sys-devel/clang-3.8
		>=sys-devel/gcc-6.3.1
		>=dev-lang/icc-17
	)
	>=dev-util/cmake-3.11.4
	doc? ( >=app-doc/doxygen-1.8.8 )
	test? (
		${DEPEND_GTEST}
		test-renderer? (
			media-gfx/imagemagick[png]
		)
	)
"
GH_ORG_URI="https://github.com/AcademySoftwareFoundation"
EGIT_COMMIT="dc37d8a631922e7bef46712947dc19b755f3e841"
EGIT_COMMIT_NFD="67345b80ebb429ecc2aeda94c478b3bcc5f7888e" # 20190930
GLFW_V="3.3"
IMGUI_V="1.79"

GLFW_DFN="glfw-${GLFW_V}.tar.gz"
GTEST_DFN="gtest-${GTEST_V}.tar.gz"
IMGUI_DFN="imgui-${IMGUI_V}.tar.gz"
NFD_DFN="nativefiledialog-${EGIT_COMMIT_NFD:0:7}.tar.gz"
SRC_URI="
${GH_ORG_URI}/openvdb/archive/${EGIT_COMMIT}.tar.gz
	-> ${PN}-${PV}-${EGIT_COMMIT:0:7}.tar.gz
https://github.com/glfw/glfw/archive/refs/tags/${GLFW_V}.tar.gz
	-> ${GLFW_DFN}
https://github.com/ocornut/imgui/archive/refs/tags/v${IMGUI_V}.tar.gz
	-> ${IMGUI_DFN}
https://github.com/mlabbe/nativefiledialog/archive/${EGIT_COMMIT_NFD}.tar.gz
	-> ${NFD_DFN}
https://github.com/google/googletest/archive/refs/tags/release-${GTEST_V}.tar.gz
	-> ${GTEST_DFN}
"
S="${WORKDIR}/openvdb-${EGIT_COMMIT}/${PN}"
S_IMGUI="${WORKDIR}/imgui-${EGIT_COMMIT_IMGUI}"
S_GLFW="${WORKDIR}/glfw-${GLFW_V}"
S_NFD="${WORKDIR}/nativefiledialog-${EGIT_COMMIT_NFD}"
S_GTEST="${WORKDIR}/googletest-${GTEST_V}"
RESTRICT="mirror"
CMAKE_BUILD_TYPE=Release
PATCHES_=(
	"${FILESDIR}/${PN}-32.3.3_pre20211001-cmake-use-tarballs.patch"
	"${FILESDIR}/${PN}-25.0.0_pre20200924-opencl-version-120.patch"
	"${FILESDIR}/${PN}-25.0.0_pre20200924-change-examples-destdir.patch"
	"${FILESDIR}/${PN}-25.0.0_pre20200924-change-header-destdir.patch"
)

is_crosscompile() {
	[[ ${CHOST} != ${CTARGET} ]]
}

pkg_setup()
{
	if use cuda ; then
		if [[ -z "${CUDA_TOOLKIT_ROOT_DIR}" ]] ; then
			die \
"CUDA_TOOLKIT_ROOT_DIR should be set as a per-package environmental variable"
		else
			if [[ ! -d "${CUDA_TOOLKIT_ROOT_DIR}/lib64" ]] ; then
				die \
"${CUDA_TOOLKIT_ROOT_DIR}/lib64 is unreachable.  Fix CUDA_TOOLKIT_ROOT_DIR"
			fi
		fi
	fi

	if use optix ; then
		if [[ -z "${OptiX_ROOT}" ]] ; then
			die \
"OptiX_ROOT should be set as a per-package environmental variable"
		else
			if [[ ! -f "${OptiX_ROOT}/include/optix.h" ]] ; then
				die \
"${OptiX_ROOT}/include/optix.h is unreachable.  Fix OptiX_ROOT"
			fi
		fi
		if [[ -z "${OptiX_INSTALL_DIR}" ]] ; then
			die \
"OptiX_INSTALL_DIR should be set as a per-package environmental variable"
		else
			if [[ ! -d "${OptiX_INSTALL_DIR}/include" ]] ; then
				die \
"${OptiX_INSTALL_DIR}/include is unreachable.  Fix OptiX_INSTALL_DIR"
			fi
		fi
	fi

	if use test ; then
		if use opencl ; then
			if [[ "${FEATURES}" =~ "usersandbox" ]] ; then
				die 'You must add FEATURES="-usersandbox" to run pass the opencl test'
			else
				einfo 'Passed: FEATURES="-usersandbox"'
			fi
		fi
	fi

	if ! is_crosscompile \
		&& which vdb_print ; then
		if ! timeout 1 vdb_print -version \
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

src_prepare()
{
	eapply ${PATCHES_[@]}
	if use tbb && has_version ">=dev-cpp/tbb-2021:${ONETBB_SLOT}" ; then
		eapply "${FILESDIR}/${PN}-25.0.0_pre20200924-findtbb-onetbb-changes.patch"
		eapply "${FILESDIR}/${PN}-25.0.0_pre20200924-onetbb-split-header-location.patch"
		sed -i -e "s|__NANOVDB_USE_ONETBB__|1|g" "${S}/nanovdb/util/Range.h" || die
	fi
	cmake_src_prepare
}

src_configure()
{
	export MAKEOPTS="-j1" # Prevent counterproductive swapping.  Observed a 3 GiB process.
	ewarn "Switch to clang + lld if it takes more than 1.5 hrs to build."
	# Completed build in 1 hr and 3 min in 32.x, but noticible stall with gcc.
	if use opencl ; then
		append-cppflags -DCL_TARGET_OPENCL_VERSION=120
	fi

	local mycmakeargs=(
		-DNANOVDB_ALLOW_FETCHCONTENT=OFF
		-DNANOVDB_BUILD_BENCHMARK=$(usex benchmark)
		-DNANOVDB_BUILD_EXAMPLES=$(usex examples)
		-DNANOVDB_BUILD_UNITTESTS=$(usex test)
		-DNANOVDB_BUILD_DOCS=$(usex doc)
		-DNANOVDB_BUILD_TOOLS=$(usex tools)
		-DNANOVDB_GTEST=$(usex test)
		-DNANOVDB_USE_BLOSC=$(usex blosc)
		-DNANOVDB_USE_CUDA=$(usex cuda)
		-DNANOVDB_USE_OPENCL=$(usex opencl)
		-DNANOVDB_USE_OPENGL=$(usex opengl)
		-DNANOVDB_USE_OPENVDB=$(usex openvdb)
		-DNANOVDB_USE_OPTIX=$(usex optix)
		-DNANOVDB_USE_TBB=$(usex tbb)
		-DNANOVDB_USE_ZLIB=$(usex zlib)
		-DUSE_BLOSC=$(usex blosc)
		-DUSE_EXR=$(usex openexr)
		-DUSE_LOG4CPLUS=$(usex log4cplus)
	)

	if use tools ; then
		mycmakeargs+=(
	-DEGLFW_SOURCE_DIR="${S_GLFW}"
	-DEGLFW_BINARY_DIR="${WORKDIR}/glfw-${GLFW_V}_${ABI}_build"
	-DEIMGUI_SOURCE_DIR="${S_IMGUI}"
	-DENFD_SOURCE_DIR="${S_NFD}"

	-DNANOVDB_BUILD_INTERACTIVE_RENDERER=$(usex interactive-renderer)
	-DNANOVDB_USE_IMGUI=$(usex imgui)
	-DNANOVDB_USE_INTERNAL_GLFW=$(usex !system-glfw)
	-DNANOVDB_USE_EGL=ON
	-DNANOVDB_USE_NATIVEFILEDIALOG=$(usex native-file-dialog)
		)
	fi

	if use benchmark || use test ; then
		mycmakeargs+=(
	-DEGOOGLETEST_SOURCE_DIR="${S_GTEST}"
	-DEGOOGLETEST_BINARY_DIR="${WORKDIR}/googletest-${GTEST_V}-${ABI}_build"
	-DNANOVDB_USE_INTERNAL_GTEST=NO
		)
	fi

	if ! use tbb ; then
		:;
	elif has_version ">=dev-cpp/tbb-2021:${ONETBB_SLOT}" ; then
		mycmakeargs+=(
			-DTBB_INCLUDEDIR="${ESYSROOT}/usr/include"
			-DTBB_LIBRARYDIR="${ESYSROOT}/usr/$(get_libdir)"
		)
	elif has_version "<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}" ; then
		mycmakeargs+=(
			-DTBB_INCLUDEDIR="${ESYSROOT}/usr/include/tbb/${LEGACY_TBB_SLOT}"
			-DTBB_LIBRARYDIR="${ESYSROOT}/usr/$(get_libdir)/tbb/${LEGACY_TBB_SLOT}"
		)
	fi

	cmake_src_configure
}

core_tests()
{
	# keep in sync with ci/test_core.sh
# Tests for nanovdb-25.0.0_pre20200924
# Date: Wed Jun 30 10:40:56 PM PDT 2021 (Unix time: 1625118056)

#testOpenVDB result:
#[==========] 17 tests from 1 test suite ran. (5545 ms total)
#[  PASSED  ] 17 tests.

#testNanoVDB results:
#[==========] 39 tests from 1 test suite ran. (1888 ms total)
#[  PASSED  ] 39 tests.

	cd "${BUILD_DIR}" || die
	einfo "Running core tests"
	cmake_src_test
	einfo "Running testOpenVDB"
	unittest/testOpenVDB || die
	echo
	einfo "Running testNanoVDB"
	unittest/testNanoVDB || die
	echo
}

video_card_sandbox_predict()
{
        local d
        for d in /dev/dri/card*; do
                [[ -s ${d} ]] && addpredict "${d}"
        done
}

render_tests()
{
	einfo "Running render tests"
	# keep in sync with nanovdb/ci/test_render.sh
	# make gold image.
	local OUT_PATH=$(pwd)/out
	mkdir -p "${OUT_PATH}" || die
	cmd/nanovdb_viewer -b -o ${OUT_PATH}/gold -p host-mt --count 1 --turntable || die
	mogrify -format png ${OUT_PATH}/gold.0000.pfm || die

	video_card_sandbox_predict
	if use cuda ; then
		cmd="$(pwd)/cmd/nanovdb_viewer -b --gold ${OUT_PATH}/gold -o ${OUT_PATH}/test-cuda -p cuda -n 1 --turntable"
		einfo "Running ${cmd}"
		${cmd} || die
	fi
	cmd="cmd/nanovdb_viewer -b --gold ${OUT_PATH}/gold -o ${OUT_PATH}/test-c99 -p host-c99 -n 1 --turntable"
	einfo "Running ${cmd}"
	${cmd} || die
	if false && use opengl ; then
		# opengl is not accessible
		cmd="$(pwd)/cmd/nanovdb_viewer -b --gold ${OUT_PATH}/gold -o ${OUT_PATH}/test-glsl -p glsl -n 1 --turntable"
		einfo "Running ${cmd}"
		${cmd} || die
	fi
	# No platform TBB for viewer
	if use opencl ; then
		cmd="$(pwd)/cmd/nanovdb_viewer -b --gold ${OUT_PATH}/gold -o ${OUT_PATH}/test-opencl -p opencl -n 1 --turntable"
		einfo "Running ${cmd}"
		${cmd} || die
	fi
	if use optix ; then
		cmd="$(pwd)/cmd/nanovdb_viewer -b --gold ${OUT_PATH}/gold -o ${OUT_PATH}/test-optix -p optix -n 1 --turntable"
		einfo "Running ${cmd}"
		${cmd} || die
	fi
}

src_test()
{
	core_tests
	use test-renderer && render_tests
}

src_install()
{
	cmake_src_install
	cd "${S}" || die
	dodoc Readme.md
	cd "${S}/.." || die
	docinto licenses
	dodoc LICENSE
	if ! use tbb ; then
		:;
	elif has_version ">=dev-cpp/tbb-2021:${ONETBB_SLOT}" ; then
		:;
	elif has_version "<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}" ; then
		for f in $(find "${ED}") ; do
			test -L "${f}" && continue
			if ldd "${f}" 2>/dev/null | grep -q -F -e "libtbb" ; then
				einfo "Old rpath for ${f}:"
				patchelf --print-rpath "${f}" || die
				einfo "Setting rpath for ${f}"
				patchelf --set-rpath "${EPREFIX}/usr/$(get_libdir)/tbb/${LEGACY_TBB_SLOT}" \
					"${f}" || die
			fi
		done
	fi
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  link-to-multislot-tbb
