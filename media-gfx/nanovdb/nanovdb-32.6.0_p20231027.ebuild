# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This version corresponds to OpenVDB 11.0.0.

# For versioning, see
# https://github.com/AcademySoftwareFoundation/openvdb/blob/v11.0.0/nanovdb/nanovdb/NanoVDB.h#L104
# For dependencies, see
# https://github.com/AcademySoftwareFoundation/openvdb/blob/v11.0.0/doc/dependencies.txt
CMAKE_BUILD_TYPE="Release"
CUDA_TARGETS_COMPAT=(
	sm_75
)
EGIT_COMMIT="77f28d16114949dfbe2937aa2dae1379f6d2b653"
GH_ORG_URI="https://github.com/AcademySoftwareFoundation"
GTEST_PV="1.10.0"
LEGACY_TBB_SLOT="2"
OGT_COMMIT="e1743d37cf7a8128568769cf71cf598166c2cd30"
OGT_DFN="ogt-${OGT_COMMIT:0:7}.tar.gz"
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

inherit cmake cuda flag-o-matic

# Live ebuilds do not get keyworded.
S_OGT="${WORKDIR}/ogt-${OGT_COMMIT}"
S="${WORKDIR}/openvdb-${EGIT_COMMIT}/${PN}/${PN}"
SRC_URI="
${GH_ORG_URI}/openvdb/archive/${EGIT_COMMIT}.tar.gz
	-> ${PN}-${PV}-${EGIT_COMMIT:0:7}.tar.gz
https://github.com/jpaver/opengametools/archive/${OGT_COMMIT}.tar.gz
	-> ${OGT_DFN}
"

DESCRIPTION="A lightweight GPU friendly version of VDB initially targeting \
rendering applications."
HOMEPAGE="https://github.com/AcademySoftwareFoundation/openvdb/tree/feature/nanovdb/nanovdb"
LICENSE="MPL-2.0"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
# cuda, optix, allow-fetchcontent are enabled upstream by default but
# are disabled
IUSE+="
${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
+benchmark +blosc cuda -doc +examples +interactive-renderer -log4cplus
-magicavoxel +opencl optix +opengl -openexr +openvdb system-glfw +tbb +test
test-renderer +tools +zlib
"
REQUIRED_USE+="
	benchmark? (
		openvdb
	)
	blosc? (
		openvdb
	)
	cuda? (
		^^ (
			${CUDA_TARGETS_COMPAT[@]/#/cuda_targets_}
		)
	)
	cuda_targets_sm_75? (
		cuda
	)
	interactive-renderer? (
		tools
	)
	log4cplus? (
		openvdb
	)
	magicavoxel? (
		examples
	)
	openexr? (
		openvdb
	)
	openvdb? (
		tbb
		zlib
	)
	test? (
		openvdb
		tbb
	)
	test-renderer? (
		test
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
					~media-libs/openexr-${openexr_pv}:=[blosc?,log4cplus?,openexr?]
				)
				~media-libs/ilmbase-${ilmbase_pv}:=
			)
		"
	done
	for row in ${OPENEXR_V3_PV[@]} ; do
		local imath_pv="${row#*:}"
		local openexr_pv="${row%:*}"
		echo "
			(
				openexr? (
					~media-libs/openexr-${openexr_pv}:=[blosc?,log4cplus?,openexr?]
				)
				~dev-libs/imath-${imath_pv}:=
			)
		"
	done
}
DEPEND_GTEST="
	>=dev-cpp/gtest-${GTEST_PV}
"
DEPEND+="
	benchmark? (
		${DEPEND_GTEST}
	)
	blosc? (
		>=dev-libs/c-blosc-1.17
	)
	cuda? (
		|| (
			=dev-util/nvidia-cuda-toolkit-11*:=
			=dev-util/nvidia-cuda-toolkit-12*:=
		)
	)
	opencl? (
		virtual/opencl
	)
	opengl? (
		virtual/opengl
	)
	openvdb? (
		>=dev-libs/boost-1.73
		>=media-gfx/openvdb-11.0.0
		|| (
			$(gen_openexr_pairs)
		)
	)
	optix? (
		>=dev-libs/optix-7
	)
	tbb? (
		|| (
			(
				>=dev-cpp/tbb-2020.2:${LEGACY_TBB_SLOT}=
				<dev-cpp/tbb-2021:${LEGACY_TBB_SLOT}=
				!<dev-cpp/tbb-2021:0=
			)
			(
				>=dev-cpp/tbb-2021:${ONETBB_SLOT}=
			)
		)
	)
	tools? (
		>=media-libs/glfw-3.3
		media-libs/mesa[egl(+)]
		interactive-renderer? (
			system-glfw? (
				>=media-libs/glfw-3.1
			)
		)
	)
	zlib? (
		>=sys-libs/zlib-1.2.7
	)
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	>=dev-build/cmake-3.18
	doc? (
		>=app-text/doxygen-1.8.8
	)
	test? (
		${DEPEND_GTEST}
		test-renderer? (
			media-gfx/imagemagick[png]
		)
	)
	|| (
		>=sys-devel/gcc-9.3.1
		>=llvm-core/clang-5.0
		>=dev-lang/icc-19
	)
"
PATCHES_=(
	"${FILESDIR}/${PN}-32.3.3_p20211029-cmake-use-tarballs.patch"
#	"${FILESDIR}/${PN}-25.0.0_pre20200924-opencl-version-120.patch"
#	"${FILESDIR}/${PN}-25.0.0_pre20200924-change-examples-destdir.patch"
#	"${FILESDIR}/${PN}-25.0.0_pre20200924-change-header-destdir.patch"
)

is_crosscompile() {
	[[ ${CHOST} != ${CTARGET} ]]
}

pkg_setup()
{
	if use cuda ; then
		if [[ -z "${CUDA_TOOLKIT_ROOT_DIR}" ]] ; then
eerror
eerror "CUDA_TOOLKIT_ROOT_DIR should be set as a per-package environmental variable"
eerror
			die
		else
			if [[ ! -d "${CUDA_TOOLKIT_ROOT_DIR}/lib64" ]] ; then
eerror
eerror "${CUDA_TOOLKIT_ROOT_DIR}/lib64 is unreachable.  Fix CUDA_TOOLKIT_ROOT_DIR"
eerror
				die
			fi
		fi
	fi

	if use optix ; then
		if [[ -z "${OptiX_ROOT}" ]] ; then
eerror
eerror "OptiX_ROOT should be set as a per-package environmental variable"
eerror
			die
		else
			if [[ ! -f "${OptiX_ROOT}/include/optix.h" ]] ; then
eerror
eerror "${OptiX_ROOT}/include/optix.h is unreachable.  Fix OptiX_ROOT"
eerror
				die
			fi
		fi
		if [[ -z "${OptiX_INSTALL_DIR}" ]] ; then
eerror
eerror "OptiX_INSTALL_DIR should be set as a per-package environmental variable"
eerror
			die
		else
			if [[ ! -d "${OptiX_INSTALL_DIR}/include" ]] ; then
eerror
eerror "${OptiX_INSTALL_DIR}/include is unreachable.  Fix OptiX_INSTALL_DIR"
eerror
				die
			fi
		fi
	fi

	if use test ; then
		if use opencl ; then
			if [[ "${FEATURES}" =~ "usersandbox" ]] ; then
eerror
eerror 'You must add FEATURES="-usersandbox" to run pass the opencl test'
eerror
				die
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
#		eapply "${FILESDIR}/${PN}-25.0.0_pre20200924-findtbb-onetbb-changes.patch"
		eapply "${FILESDIR}/${PN}-32.3.3_p20211029-onetbb-split-header-location.patch"
		sed -i -e "s|__NANOVDB_USE_ONETBB__|1|g" "${S}/nanovdb/util/Range.h" || die
	fi
	cmake_src_prepare
	if use cuda ; then
		cuda_add_sandbox -w
		cuda_src_prepare
	fi
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
		-DNANOVDB_USE_MAGICAVOXEL=$(use magicavoxel)
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

	if use cuda ; then
		if [[ -n "${NANOVDB_CUDA_ARCHITECTURES}" ]] ; then
			# Example override, NANOVDB_CUDA_ARCHITECTURES="75" an as environment variable.
			-DCMAKE_CUDA_ARCHITECTURES="${NANOVDB_CUDA_ARCHITECTURES}"
		fi
	fi

	if use magicavoxel ; then
		mycmakeargs+=(
			-DEOGT_SOURCE_DIR="${S_OGT}"
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
                [[ -s "${d}" ]] && addpredict "${d}"
        done
}

render_tests()
{
einfo "Running render tests"
	# keep in sync with nanovdb/ci/test_render.sh
	# make gold image.
	local out_path="$(pwd)/out"
	mkdir -p "${out_path}" || die
	cmd/nanovdb_viewer -b -o "${out_path}/gold" -p host-mt --count 1 --turntable || die
	mogrify -format png "${out_path}/gold.0000.pfm" || die

	video_card_sandbox_predict
	if use cuda ; then
		cmd="$(pwd)/cmd/nanovdb_viewer -b --gold ${out_path}/gold -o ${out_path}/test-cuda -p cuda -n 1 --turntable"
einfo "Running ${cmd}"
		${cmd} || die
	fi
	cmd="cmd/nanovdb_viewer -b --gold ${out_path}/gold -o ${out_path}/test-c99 -p host-c99 -n 1 --turntable"
einfo "Running ${cmd}"
	${cmd} || die
	if false && use opengl ; then
		# opengl is not accessible
		cmd="$(pwd)/cmd/nanovdb_viewer -b --gold ${out_path}/gold -o ${out_path}/test-glsl -p glsl -n 1 --turntable"
einfo "Running ${cmd}"
		${cmd} || die
	fi
	# No platform TBB for viewer
	if use opencl ; then
		cmd="$(pwd)/cmd/nanovdb_viewer -b --gold ${out_path}/gold -o ${out_path}/test-opencl -p opencl -n 1 --turntable"
einfo "Running ${cmd}"
		${cmd} || die
	fi
	if use optix ; then
		cmd="$(pwd)/cmd/nanovdb_viewer -b --gold ${out_path}/gold -o ${out_path}/test-optix -p optix -n 1 --turntable"
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
	cd "${S}/../.." || die
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
