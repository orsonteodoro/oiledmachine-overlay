# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake eutils flag-o-matic

DESCRIPTION="A lightweight GPU friendly version of VDB initially targeting \
rendering applications."
HOMEPAGE=\
"https://github.com/AcademySoftwareFoundation/openvdb/tree/feature/nanovdb/nanovdb"
LICENSE="MPL-2.0"
# For versioning, see
# https://github.com/AcademySoftwareFoundation/openvdb/blob/e62f7a0bf1e27397223c61ddeaaf57edf111b77f/nanovdb/nanovdb/NanoVDB.h#L68
SLOT="$(ver_cut 1 ${PV})/${PV}"
# Live ebuilds do not get keyworded.
# cuda, optix, allow-fetchcontent are enabled upstream by default but
# are disabled
IUSE+=" +benchmark +blosc cuda -doc -egl +examples \
-imgui +interactive-renderer -native-file-dialog +opencl optix \
+opengl +openvdb system-glfw system-gtest +tbb +test +tools +zlib"
REQUIRED_USE+="
	interactive-renderer? ( tools )
	native-file-dialog? ( imgui tools )
	benchmark? ( openvdb )
	openvdb? ( tbb zlib )"
# For dependencies, see
# https://github.com/AcademySoftwareFoundation/openvdb/blob/e62f7a0bf1e27397223c61ddeaaf57edf111b77f/doc/dependencies.txt
# openvdb should be 7.1.1 but downgraded to minor.  No 7.1.1 release either.
ONETBB_SLOT="12"
DEPEND_GTEST=" system-gtest? ( >=dev-cpp/gtest-1.10 )"

# Not ready yet:
#			(
#				>=dev-cpp/tbb-2021:${ONETBB_SLOT}=
#			)


DEPEND+="  benchmark? ( ${DEPEND_GTEST} )
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
		>=dev-libs/boost-1.61
		>=media-libs/ilmbase-2.2
		>=media-gfx/openvdb-7.1[abi7-compat]
	)
	optix? (
		>=dev-libs/optix-7
	)
	tbb? (
		|| (
			(
				>=dev-cpp/tbb-2017.6:0=
				<dev-cpp/tbb-2021:0=
			)
		)
	)
	tools? (
		egl? (
			media-libs/mesa[egl?]
			>=media-libs/glfw-3.3
		)
		interactive-renderer? (
			system-glfw? ( >=media-libs/glfw-3.1 )
			native-file-dialog? (
				>=x11-libs/gtk+-3:3
			)
		)
	)
	zlib? ( >=sys-libs/zlib-1.2.7 )"
RDEPEND+=" ${DEPEND}"
BDEPEND+="
	|| (
		>=sys-devel/clang-3.8
		>=sys-devel/gcc-6.3.1
		>=dev-lang/icc-17
	)
	>=dev-util/cmake-3.11.4
	doc? ( >=app-doc/doxygen-1.8.8 )
	test? ( ${DEPEND_GTEST} )"
GH_ORG_URI="https://github.com/AcademySoftwareFoundation"
EGIT_COMMIT="e62f7a0bf1e27397223c61ddeaaf57edf111b77f"
EGIT_COMMIT_IMGUI="124c2608f1bf708b3abf039c93d16d704f76a815" # 20201012
EGIT_COMMIT_NFD="67345b80ebb429ecc2aeda94c478b3bcc5f7888e" # 20190930
GLFW_V="3.3"
GTEST_V="1.10.0"
GLFW_DFN="glfw-${GLFW_V}.tar.gz"
NFD_DFN="nativefiledialog-${EGIT_COMMIT_NFD:0:7}.tar.gz"
IMGUI_DFN="imgui-${EGIT_COMMIT_IMGUI:0:7}.tar.gz"
GTEST_DFN="release-${GTEST_V}.tar.gz"
SRC_URI=\
"${GH_ORG_URI}/openvdb/archive/${EGIT_COMMIT}.tar.gz
	-> ${PN}-${PV}-${EGIT_COMMIT:0:7}.tar.gz
https://github.com/glfw/glfw/archive/refs/tags/${GLFW_V}.tar.gz \
	-> ${GLFW_DFN}
https://github.com/ocornut/imgui/archive/${EGIT_COMMIT_IMGUI}.tar.gz \
	-> ${IMGUI_DFN}
https://github.com/mlabbe/nativefiledialog/archive/${EGIT_COMMIT_NFD}.tar.gz \
	-> ${NFD_DFN}
https://github.com/google/googletest/archive/refs/tags/release-${GTEST_V}.tar.gz \
	-> ${GTEST_DFN}"
S="${WORKDIR}/openvdb-${EGIT_COMMIT}/${PN}"
S_IMGUI="${WORKDIR}/imgui-${EGIT_COMMIT_IMGUI}"
S_GLFW="${WORKDIR}/glfw-${GLFW_V}"
S_NFD="${WORKDIR}/nativefiledialog-${EGIT_COMMIT_NFD}"
S_GTEST="${WORKDIR}/googletest-${GTEST_V}"
RESTRICT="mirror"
CMAKE_BUILD_TYPE=Release
PATCHES_=(
	"${FILESDIR}/${PN}-25.0.0_pre20200924-cmake-use-tarballs.patch"
	"${FILESDIR}/${PN}-25.0.0_pre20200924-opencl-version-120.patch"
	"${FILESDIR}/${PN}-25.0.0_pre20200924-change-examples-destdir.patch"
	"${FILESDIR}/${PN}-25.0.0_pre20200924-change-header-destdir.patch"
)

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
}

src_prepare()
{
	eapply ${PATCHES_[@]}
	if false && use tbb && has_version "dev-cpp/tbb:${ONETBB_SLOT}" ; then
		eapply "${FILESDIR}/${PN}-25.0.0_pre20200924-findtbb-onetbb-changes.patch"
	fi
	cmake_src_prepare
}

src_configure()
{
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
		-DNANOVDB_USE_BLOSC=$(usex blosc)
		-DNANOVDB_USE_CUDA=$(usex cuda)
		-DNANOVDB_USE_OPENCL=$(usex opencl)
		-DNANOVDB_USE_OPENGL=$(usex opengl)
		-DNANOVDB_USE_OPENVDB=$(usex openvdb)
		-DNANOVDB_USE_OPTIX=$(usex optix)
		-DNANOVDB_USE_TBB=$(usex tbb)
		-DNANOVDB_USE_ZLIB=$(usex zlib)
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
	-DNANOVDB_USE_EGL=$(usex egl)
	-DNANOVDB_USE_NATIVEFILEDIALOG=$(usex native-file-dialog)
		)
	fi

	if use benchmark || use test ; then
		mycmakeargs+=(
	-DEGOOGLETEST_SOURCE_DIR="${S_GTEST}"
	-DEGOOGLETEST_BINARY_DIR="${WORKDIR}/googletest-${GTEST_V}-${ABI}_build"
	-DNANOVDB_USE_INTERNAL_GTEST=$(use !system-gtest)
		)
	fi

	if false && use tbb && has_version "dev-cpp/tbb:${ONETBB_SLOT}" ; then
		mycmakeargs+=(
			-DTBB_INCLUDEDIR=/usr/include/oneTBB/${ONETBB_SLOT}
			-DTBB_LIBRARYDIR=/usr/$(get_libdir)/oneTBB/${ONETBB_SLOT}
		)
	fi

	cmake_src_configure
}

src_install()
{
	cmake_src_install
	cd "${S}" || die
	docinto Readme.md
	cd "${S}/.." || die
	docinto licenses
	dodoc LICENSE
	if false && use tbb && has_version "dev-cpp/tbb:${ONETBB_SLOT}" ; then
		for f in $(find "${ED}") ; do
			test -L "${f}" && continue
			if ldd "${f}" 2>/dev/null | grep -q -F -e "libtbb" ; then
				einfo "Old rpath for ${f}:"
				patchelf --print-rpath "${f}" || die
				einfo "Setting rpath for ${f}"
				patchelf --set-rpath "/usr/$(get_libdir)/oneTBB/${ONETBB_SLOT}" \
					"${f}" || die
			fi
		done
	fi
}
