# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO:
# Check if bindings uses the correct python.

# For requirements, see
# https://github.com/ROCm/omnitrace/blob/rocm-6.2.4/source/docs/installation.md

BINUTILS_PV="2.40"
CALIPER_COMMIT="7e66987f0d9af19dcaa13fb78197cdc8437d8a3f"
DYNINST_COMMIT_1="d3ab0a71e925bd01b20c6362f14006d34ece7112"
DYNINST_COMMIT_2="076d8bdef4f22639d16ca65cda9b909b6c726047"
DYNINST_TESTSUITE_COMMIT="3a5c5794dcf38ad5452816046b39c0c2528d86f5"
ELFIO_COMMIT="d00cc32f8b1ed85d22309fac10576a1baf8a4736"
GOOGLETEST_COMMIT="4174e1703ba8412e84b2959c1cf57433d144b32d"
GOTCHA_COMMIT="5aff8260e0756d7c182812ef6b92453374265e28"
HATCHET_COMMIT="a1f13410b0bf2334459bf07fee767cda81794cad"
LIBUNWIND_COMMIT="501d8d5e6a06236b87d10a2b1b85008fde3fcbcc"
LLVM_OPENMP_COMMIT="998ea02399846927f3e329b6cc9fe387a8d39947"
LINE_PROFILER_COMMIT="794adeb01ea1353f713a030f6cbd5e0e5780cb21"
LLVM_SLOT=18
PAPI_COMMIT="effd1ef4e0fd4b80e36546791277215a2d6b9eba"
PERFETTO_COMMIT_1="99ead408d98eaa25b7819c7e059734bea42fa148"
PERFETTO_COMMIT_2="dd1f2f378fe2f292f78af922828f93a9f101d373"
PTL_COMMIT_1="f0205c1935f14861b05152378b7ac1c9234cddc0"
PTL_COMMIT_2="2275ff374d2e469c0e632e86d8319127349ec301"
PYBIND11_COMMIT_1="1a917f1852eb7819b671fc3fa862840f4c491a07"
PYTHON_COMPAT=( "python3_12" )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"
LEGACY_TBB_SLOT=2
TIMEMORY_COMMIT="2a1bcba0cad46efd4421c0c7a145e83b161fb934"
YAML_CPP_COMMIT="1b50109f7bea60bd382d8ea7befce3d2bd67da5f"

inherit check-compiler-switch cmake dep-prepare flag-o-matic python-single-r1 rocm

if [[ ${PV} == *"9999" ]] ; then
	EGIT_REPO_URI="https://github.com/ROCm/omnitrace/"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-rocm-${PV}"
	SRC_URI="
https://github.com/jrmadsen/Caliper/archive/${CALIPER_COMMIT}.tar.gz
	-> jrmadsen-Caliper-${CALIPER_COMMIT:0:7}.tar.gz
https://github.com/jrmadsen/dyninst/archive/${DYNINST_COMMIT_1}.tar.gz
	-> jrmadsen-dyninst-${DYNINST_COMMIT_1:0:7}.tar.gz
https://github.com/jrmadsen/dyninst/archive/${DYNINST_COMMIT_2}.tar.gz
	-> jrmadsen-dyninst-${DYNINST_COMMIT_2:0:7}.tar.gz
https://github.com/jrmadsen/googletest/archive/${GOOGLETEST_COMMIT}.tar.gz
	-> jrmadsen-google-test-${GOOGLETEST_COMMIT:0:7}.tar.gz
https://github.com/jrmadsen/GOTCHA/archive/${GOTCHA_COMMIT}.tar.gz
	-> jrmadsen-GOTCHA-${GOTCHA_COMMIT:0:7}.tar.gz
https://github.com/jrmadsen/hatchet/archive/${HATCHET_COMMIT}.tar.gz
	-> jrmadsen-hatchet-${HATCHET_COMMIT:0:7}.tar.gz
https://github.com/jrmadsen/line_profiler/archive/${LINE_PROFILER_COMMIT}.tar.gz
	-> jrmadsen-line_profiler-${LINE_PROFILER_COMMIT:0:7}.tar.gz
https://github.com/jrmadsen/pybind11/archive/${PYBIND11_COMMIT_1}.tar.gz
	-> jrmadsen-pybind11-${PYBIND11_COMMIT_1:0:7}.tar.gz
https://github.com/jrmadsen/ELFIO/archive/${ELFIO_COMMIT}.tar.gz
	-> jrmadsen-ELFIO-${ELFIO_COMMIT:0:7}.tar.gz
https://github.com/jrmadsen/libunwind/archive/${LIBUNWIND_COMMIT}.tar.gz
	-> jrmadsen-libunwind-${LIBUNWIND_COMMIT:0:7}.tar.gz
https://github.com/jrmadsen/PTL/archive/${PTL_COMMIT_1}.tar.gz
	-> jrmadsen-ptl-${PTL_COMMIT_1:0:7}.tar.gz
https://github.com/jrmadsen/PTL/archive/${PTL_COMMIT_2}.tar.gz
	-> jrmadsen-ptl-${PTL_COMMIT_2:0:7}.tar.gz
https://github.com/jrmadsen/yaml-cpp/archive/${YAML_CPP_COMMIT}.tar.gz
	-> jrmadsen-yaml-cpp-${YAML_CPP_COMMIT:0:7}.tar.gz
https://github.com/NERSC/LLVM-openmp/archive/${LLVM_OPENMP_COMMIT}.tar.gz
	-> NERSC-LLVM-openmp-${LLVM_OPENMP_COMMIT:0:7}.tar.gz
https://github.com/NERSC/timemory/archive/${TIMEMORY_COMMIT}.tar.gz
	-> NERSC-timemory-${TIMEMORY_COMMIT:0:7}.tar.gz
https://github.com/ROCm/omnitrace/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
https://github.com/icl-utk-edu/papi/archive/${PAPI_COMMIT}.tar.gz
	-> papi-${PAPI_COMMIT:0:7}.tar.gz
https://android.googlesource.com/platform/external/perfetto/+archive/${PERFETTO_COMMIT_1}.tar.gz
	-> perfetto-${PERFETTO_COMMIT_1:0:7}.tar.gz
https://android.googlesource.com/platform/external/perfetto/+archive/${PERFETTO_COMMIT_2}.tar.gz
	-> perfetto-${PERFETTO_COMMIT_2:0:7}.tar.gz
https://github.com/dyninst/testsuite/archive/${DYNINST_TESTSUITE_COMMIT}.tar.gz
	-> dyninst-testsuite-${DYNINST_TESTSUITE_COMMIT:0:7}.tar.gz
http://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_PV}.tar.gz
	"
fi

DESCRIPTION="Omnitrace: Application Profiling, Tracing, and Analysis"
HOMEPAGE="
	https://rocm.docs.amd.com/projects/omnitrace/en/latest/
	https://github.com/ROCm/omnitrace
"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
"
RESTRICT="test"
# The distro's MIT license template does not contain all rights reserved.
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
-debuginfod examples -mpi +openmp +papi -python +rccl +rocprofiler
+roctracer test system-dyninst system-libunwind system-papi +rocm-smi
ebuild_revision_1
"
# The vendored dyninst is build-time broken.
REQUIRED_USE="
	system-dyninst
"
RDEPEND="
	~dev-libs/rocm-core-${PV}:${ROCM_SLOT}
	~dev-util/hip-${PV}:${ROCM_SLOT}
	!system-dyninst? (
		=dev-cpp/tbb-2019*:2
		sys-devel/gcc[openmp?]
		>=dev-libs/elfutils-0.178
		>=dev-libs/boost-1.67.0
	)
	mpi? (
		virtual/mpi
	)
	papi? (
		system-papi? (
			dev-libs/papi
		)
	)
	rccl? (
		~dev-libs/rccl-${PV}:${ROCM_SLOT}
	)
	rocm-smi? (
		~dev-util/rocm-smi-${PV}:${ROCM_SLOT}
	)
	rocprofiler? (
		~dev-util/rocprofiler-${PV}:${ROCM_SLOT}
	)
	roctracer? (
		~dev-util/roctracer-${PV}:${ROCM_SLOT}
	)
	system-dyninst? (
		>=dev-util/dyninst-12.0[openmp?]
	)
	system-libunwind? (
		sys-libs/libunwind
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.16
	$(python_gen_cond_dep '
		>=dev-python/setuptools-40.0.4[${PYTHON_USEDEP}]
		>=dev-python/setuptools-scm-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/wheel-0.29.0[${PYTHON_USEDEP}]
	')
	${ROCM_GCC_DEPEND}
"
PATCHES=(
	"${FILESDIR}/${PN}-6.2.0-hardcoded-paths.patch"
	"${FILESDIR}/${PN}-6.2.0-offline-install.patch"
	"${FILESDIR}/${PN}-6.2.0-tbb.patch"
)

pkg_setup() {
	check-compiler-switch_start
	python_setup
	rocm_pkg_setup
}

src_unpack() {
	local x
	for x in ${A} ; do
		if [[ "${x}" =~ "perfetto-${PERFETTO_COMMIT_1:0:7}" ]] ; then
			mkdir -p "${WORKDIR}/perfetto-${PERFETTO_COMMIT_1}"
			pushd "${WORKDIR}/perfetto-${PERFETTO_COMMIT_1}" >/dev/null 2>&1 || die
				unpack "${x}"
			popd >/dev/null 2>&1 || die
		elif [[ "${x}" =~ "perfetto-${PERFETTO_COMMIT_2:0:7}" ]] ; then
			mkdir -p "${WORKDIR}/perfetto-${PERFETTO_COMMIT_2}"
			pushd "${WORKDIR}/perfetto-${PERFETTO_COMMIT_2}" >/dev/null 2>&1 || die
				unpack "${x}"
			popd >/dev/null 2>&1 || die
		else
			unpack "${x}"
		fi
	done
	dep_prepare_mv "${WORKDIR}/dyninst-${DYNINST_COMMIT_1}" "${S}/external/dyninst"
	dep_prepare_cp "${WORKDIR}/testsuite-${DYNINST_TESTSUITE_COMMIT}" "${S}/external/dyninst/testsuite"
	dep_prepare_mv "${WORKDIR}/ELFIO-${ELFIO_COMMIT}" "${S}/external/elfio"
	dep_prepare_mv "${WORKDIR}/papi-${PAPI_COMMIT}" "${S}/external/papi"
	dep_prepare_mv "${WORKDIR}/PTL-${PTL_COMMIT_1}" "${S}/external/PTL"
	dep_prepare_cp "${WORKDIR}/pybind11-${PYBIND11_COMMIT_1}" "${S}/external/pybind11"
	dep_prepare_mv "${WORKDIR}/timemory-${TIMEMORY_COMMIT}" "${S}/external/timemory"
	dep_prepare_mv "${WORKDIR}/Caliper-${CALIPER_COMMIT}" "${S}/external/timemory/external/caliper"
	dep_prepare_mv "${WORKDIR}/dyninst-${DYNINST_COMMIT_2}" "${S}/external/timemory/external/dyninst"
	dep_prepare_mv "${WORKDIR}/googletest-${GOOGLETEST_COMMIT}" "${S}/external/timemory/external/google-test"
	dep_prepare_mv "${WORKDIR}/GOTCHA-${GOTCHA_COMMIT}" "${S}/external/timemory/external/gotcha"
	dep_prepare_mv "${WORKDIR}/hatchet-${HATCHET_COMMIT}" "${S}/external/timemory/external/hatchet"
	dep_prepare_mv "${WORKDIR}/libunwind-${LIBUNWIND_COMMIT}" "${S}/external/timemory/external/libunwind"
	dep_prepare_mv "${WORKDIR}/line_profiler-${LINE_PROFILER_COMMIT}" "${S}/external/timemory/external/line-profiler"
	dep_prepare_mv "${WORKDIR}/LLVM-openmp-${LLVM_OPENMP_COMMIT}" "${S}/external/timemory/external/llvm-ompt"
	dep_prepare_mv "${WORKDIR}/perfetto-${PERFETTO_COMMIT_1}" "${S}/external/perfetto"
	dep_prepare_mv "${WORKDIR}/perfetto-${PERFETTO_COMMIT_2}" "${S}/external/timemory/external/perfetto"
	dep_prepare_mv "${WORKDIR}/PTL-${PTL_COMMIT_2}" "${S}/external/timemory/external/ptl"
	dep_prepare_cp "${WORKDIR}/pybind11-${PYBIND11_COMMIT_1}" "${S}/external/timemory/external/pybind11"
	dep_prepare_cp "${WORKDIR}/testsuite-${DYNINST_TESTSUITE_COMMIT}" "${S}/external/timemory/external/dyninst/testsuite"
	dep_prepare_mv "${WORKDIR}/yaml-cpp-${YAML_CPP_COMMIT}" "${S}/external/timemory/external/yaml-cpp"
	dep_prepare_mv "${WORKDIR}/binutils-${BINUTILS_PV}" "${S}/external/binutils"
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
	if has_version ">=dev-util/dyninst-13" ; then
		eapply "${FILESDIR}/${PN}-6.2.0-dyninst-13-compat.patch"
	fi
}

src_configure() {
	rocm_set_default_gcc

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

	if ! check-compiler-switch_is_system_flavor ; then
einfo "Detected GPU compiler switch.  Disabling LTO."
		filter-lto
	fi

	if use system-dyninst ; then
		append-cppflags -I"${ESYSROOT}/usr/include/dyninst"
	fi
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DENABLE_DEBUGINFOD=$(usex debuginfod)
		-DOMNITRACE_USE_BFD=ON
		-DOMNITRACE_USE_HIP=ON
		-DOMNITRACE_USE_MPI=$(usex mpi)
		-DOMNITRACE_USE_RCCL=$(usex rccl)
		-DOMNITRACE_USE_ROCPROFILER=$(usex rocprofiler)
		-DOMNITRACE_USE_ROCTRACER=$(usex roctracer)
		-DOMNITRACE_USE_PAPI=$(usex papi)
		-DOMNITRACE_USE_PYTHON=$(usex python)
		-DOMNITRACE_USE_ROCM_SMI=$(usex rocm-smi)
		-DOMNITRACE_BUILD_EXAMPLES=$(usex examples)
		-DOMNITRACE_BUILD_DYNINST=$(usex !system-dyninst)
		-DOMNITRACE_BUILD_LIBUNWIND=$(usex !system-libunwind)
		-DOMNITRACE_BUILD_PAPI=$(usex !system-papi)
		-DOMNITRACE_BUILD_TESTING=$(usex test)
		-DOMNITRACE_INSTALL_PERFETTO_TOOLS=OFF
		-DUSE_OpenMP=$(usex openmp)
		-DSTERILE_BUILD=ON
	)

	if use openmp && use hip-clang ; then
		append-flags -I"${ESYSROOT}${EROCM_LLVM_PATH}/include" -fopenmp=libomp
		append-flags -Wl,-L"${ESYSROOT}${EROCM_LLVM_PATH}/lib"
	fi

	replace-flags '-O*' '-O2'

	if ! use system-dyninst ; then
		mycmakeargs+=(
	# The vendored version has a build time failure on 2020.3, 2021.12, 2019.7, 2018.6.
	# It is obviously bugged.  In the issues, they admit it is outdated.
			-DBUILD_TBB=ON
		)
		if has_version "dev-cpp/tbb:0" ; then
einfo "Using TBB:0 (current)"
			mycmakeargs+=(
				-DTBB_INCLUDE_DIR="${ESYSROOT}/usr/include"
				-DTBB_LIBRARY="${ESYSROOT}/usr/$(get_libdir)"
			)
		else
einfo "Using TBB:2 (legacy)"
			mycmakeargs+=(
				-DTBB_INCLUDE_DIR="${ESYSROOT}/usr/include/tbb/${LEGACY_TBB_SLOT}"
				-DTBB_LIBRARY="${ESYSROOT}/usr/$(get_libdir)/tbb/${LEGACY_TBB_SLOT}"
			)
		fi
	else
		mycmakeargs+=(
			-DBUILD_TBB=OFF
		)
	fi
	rocm_src_configure
}

src_install() {
	cmake_src_install
	docinto "licenses"
	dodoc "LICENSE"
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
# USE="system-dyninst -debuginfod -ebuild-revision-0 -examples -mpi -openmp -papi -python -rccl -rocm-smi -rocprofiler -roctracer -system-libunwind -system-papi -test (-gcc%*) (-hip-clang%)" PYTHON_SINGLE_TARGET="python3_10 -python3_11"
