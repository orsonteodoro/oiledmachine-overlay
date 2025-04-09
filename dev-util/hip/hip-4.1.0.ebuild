# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
DOCS_BUILDER="doxygen"
DOCS_CONFIG_NAME="doxy.cfg"
DOCS_DEPEND="media-gfx/graphviz"
HIP_SUPPORT_CUDA=1
LLVM_SLOT=12 # See https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-4.5.2/llvm/CMakeLists.txt
PYTHON_COMPAT=( "python3_"{10..11} )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake docs prefix python-any-r1 rocm

KEYWORDS="~amd64"
#S="${WORKDIR}/hipamd-rocm-${PV}"
HIP_S="${WORKDIR}/HIP-rocm-${PV}"
S="${WORKDIR}/HIP-rocm-${PV}"
OCL_S="${WORKDIR}/ROCm-OpenCL-Runtime-rocm-${PV}"
ROCCLR_S="${WORKDIR}/ROCclr-rocm-${PV}"
# HIP-rocm-4.1.0/rocclr
RTC_S="${WORKDIR}/roctracer-rocm-${PV}"
DOCS_DIR="${HIP_S}/docs/doxygen-input"
SRC_URI="
https://github.com/ROCm-Developer-Tools/HIP/archive/rocm-${PV}.tar.gz
	-> rocm-hip-${PV}.tar.gz
	profile? (
https://github.com/ROCm-Developer-Tools/roctracer/archive/refs/tags/rocm-${PV}.tar.gz
	-> rocm-tracer-${PV}.tar.gz
https://github.com/ROCm-Developer-Tools/hipamd/files/8991181/hip_prof_str_diff.gz
	-> ${P}-update-header.patch.gz
	)
	rocm? (
https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/archive/rocm-${PV}.tar.gz
	-> rocm-opencl-runtime-${PV}.tar.gz
https://github.com/ROCm-Developer-Tools/ROCclr/archive/rocm-${PV}.tar.gz
	-> rocclr-${PV}.tar.gz
	)
"

DESCRIPTION="C++ Heterogeneous-Compute Interface for Portability"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/hipamd"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
	Apache-2.0
	Boost-1.0
	BSD
	BSD-2
	custom
	MIT
"
# all-rights-reserved MIT - hipamd-rocm-4.5.2/CMakeLists.txt
# Apache-2.0 - ROCm-OpenCL-Runtime-rocm-4.5.2/khronos/icd/LICENSE
# Boost-1.0 - HIP-rocm-4.5.2/tests/catch/external/Catch2/LICENSE.txt
# BSD - HIP-rocm-4.5.2/samples/1_Utils/hipBusBandwidth/LICENSE.txt
# BSD-2 - HIP-rocm-4.5.2/tests/catch/external/picojson/LICENSE
# custom - ROCm-OpenCL-Runtime-rocm-4.5.2/khronos/icd/LICENSE.txt
# custom - ROCm-OpenCL-Runtime-rocm-4.5.2/khronos/headers/opencl2.2/LICENSE
# custom - ROCm-OpenCL-Runtime-rocm-4.5.2/khronos/headers/opencl2.2/LICENSE.txt
# MIT - HIP-rocm-4.5.2/LICENSE.txt
# MIT - hipamd-rocm-4.5.2/LICENSE.txt

SLOT="$(ver_cut 1-2)/${PV}"
IUSE="cuda debug numa -pal profile +rocm test ebuild_revision_40"
REQUIRED_USE="
	pal? (
		rocm
	)
	profile? (
		!cuda
		rocm
	)
	^^ (
		cuda
		rocm
	)
"
RDEPEND="
	>=dev-perl/URI-Encode-1.1.1
	app-eselect/eselect-rocm
	virtual/opengl
	cuda? (
		${HIP_CUDA_DEPEND}
	)
	numa? (
		sys-process/numactl
	)
	rocm? (
		${ROCM_CLANG_DEPEND}
		~dev-libs/rocm-comgr-${PV}:${ROCM_SLOT}
		~dev-libs/rocr-runtime-${PV}:${ROCM_SLOT}
		~dev-util/rocminfo-${PV}:${ROCM_SLOT}
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${PYTHON_DEPS}
	${ROCM_GCC_DEPEND}
	>=dev-build/cmake-3.16.8
	profile? (
		$(python_gen_any_dep '
			dev-python/CppHeaderParser[${PYTHON_USEDEP}]
		')
	)
	test? (
		rocm? (
			~dev-util/rocminfo-${PV}:${ROCM_SLOT}
		)
	)
"
CLR_PATCHES=(
)
HIP_PATCHES=(
	"${FILESDIR}/${PN}-4.5.2-fno-stack-protector.patch"
)
HIPAMD_PATCHES=(
#	"${FILESDIR}/${PN}-4.5.2-DisableTest.patch"
#	"${FILESDIR}/${PN}-5.0.1-hip_vector_types.patch"
#	"${FILESDIR}/${PN}-4.2.0-cancel-hcc-header-removal.patch"
	"${FILESDIR}/${PN}-4.1.0-set-build-id.patch"
	"${FILESDIR}/${PN}-4.1.0-fix-hip_prof_gen.patch"
	"${FILESDIR}/${PN}-4.1.0-llvm-15-noinline-keyword.patch"
	"${FILESDIR}/${PN}-4.1.0-hip-config-not-cuda.patch"
	"${FILESDIR}/${PN}-4.1.0-hip-host-not-cuda.patch"
#	"${FILESDIR}/hipamd-5.1.3-link-hsa-runtime64.patch"
	"${FILESDIR}/hipamd-4.1.0-fix-hip-lang-device-interface-path.patch"
	"${FILESDIR}/hipamd-4.5.2-fix-hip-clang-root.patch"
	"${FILESDIR}/hip-4.1.0-hip-architectures.patch"
)
OCL_PATCHES=(
)
RTC_PATCHES=(
)

python_check_deps() {
	if use profile; then
		python_has_version "dev-python/CppHeaderParser[${PYTHON_USEDEP}]"
	fi
}

pkg_setup() {
ewarn "The 4.1.x series may require a compiler switch to gcc:12"
	python-any-r1_pkg_setup
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	eapply "${HIPAMD_PATCHES[@]}"
	use profile && eapply "${WORKDIR}/${P}-update-header.patch"
	eapply_user

	# Use the ebuild slot number, otherwise git hash is attempted in vain.
	sed \
		-e "/set (HIP_LIB_VERSION_STRING/cset (HIP_LIB_VERSION_STRING ${SLOT#*/})" \
		-i \
		"CMakeLists.txt" \
		|| die

	# Disable PCH, because it results in a build error in ROCm 4.0.0.
	sed \
		-e "s:option(__HIP_ENABLE_PCH:#option(__HIP_ENABLE_PCH:" \
		-i \
		"CMakeLists.txt" \
		|| die

#	sed \
#		-e "/\.hip/d" \
#		-e "/cmake DESTINATION/d" \
#		-i \
#		"packaging/CMakeLists.txt" \
#		|| die

	pushd "${HIP_S}" >/dev/null 2>&1 || die
		eapply "${HIP_PATCHES[@]}"
		cp \
			$(prefixify_ro "${FILESDIR}/hipvars-5.1.3.pm") \
			"${HIP_S}/bin/hipvars.pm" \
			|| die "failed to replace hipvars.pm"
		if use cuda ; then
			sed \
				-e "s,@HIP_COMPILER@,nvcc," \
				-e "s,@HIP_PLATFORM@,nvidia," \
				-e "s,@HIP_RUNTIME@,cuda," \
				-i \
				"${HIP_S}/bin/hipvars.pm" \
				|| die
		elif use rocm ; then
			sed \
				-e "s,@HIP_COMPILER@,clang," \
				-e "s,@HIP_PLATFORM@,amd," \
				-e "s,@HIP_RUNTIME@,rocclr," \
				-i \
				"${HIP_S}/bin/hipvars.pm" \
				|| die
		fi
		sed \
			-e "s,@HIP_BASE_VERSION_MAJOR@,$(ver_cut 1)," \
			-e "s,@HIP_BASE_VERSION_MINOR@,$(ver_cut 2)," \
			-e "s,@HIP_VERSION_PATCH@,$(ver_cut 3)," \
			-i \
			"${HIP_S}/bin/hipvars.pm" \
			|| die
	popd >/dev/null 2>&1 || die

	if use rocm ; then
		pushd "${OCL_S}" >/dev/null 2>&1 || die
			#eapply "${OCL_PATCHES[@]}"
		popd >/dev/null 2>&1 || die
		pushd "${ROCCLR_S}" >/dev/null 2>&1 || die
			#eapply "${CLR_PATCHES[@]}"
		popd >/dev/null 2>&1 || die
	fi

	if use profile ; then
		pushd "${RTC_S}" >/dev/null 2>&1 || die
			#eapply "${RTC_PATCHES[@]}"
		popd >/dev/null 2>&1 || die
	fi

	pushd "${WORKDIR}" >/dev/null 2>&1 || die
		eapply "${FILESDIR}/${PN}-4.1.0-hardcoded-paths.patch"
	popd >/dev/null 2>&1 || die

	rocm_src_prepare

	# Fix for:
	# python3: no python-exec wrapped executable found in /opt/rocm-4.1.0/lib/python-exec.
	sed -i -e "/PYTHON_EXECUTABLE/d" "${WORKDIR}/ROCclr-rocm-${PV}/device/pal/CMakeLists.txt" || die
}

src_configure() {
	:
}

src_compile() {
	rocm_set_default_gcc
	use debug && CMAKE_BUILD_TYPE="Debug"

	# TODO: Currently the distro configuration is to build.
	# This is also used in the cmake configuration files
	# which will be installed to find HIP.
	# Other ROCm packages expect a "RELEASE" configuration.
	# See "hipBLAS".
	local mycmakeargs=(
		-DBUILD_HIPIFY_CLANG=OFF
		-DCMAKE_BUILD_TYPE="${buildtype}"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DCMAKE_PREFIX_PATH="${ESYSROOT}${EROCM_LLVM_PATH}"
		-DCMAKE_SKIP_RPATH=ON
		-DHIP_COMMON_DIR="${HIP_S}"
		-DROCM_PATH="${EPREFIX}${EROCM_PATH}"
		-DUSE_PROF_API=$(usex profile 1 0)
		-DUSE_SYSTEM_LLVM=OFF

	# Fix for:
	# python3: no python-exec wrapped executable found in /opt/rocm-4.1.0/lib/python-exec.
		-DPython_EXECUTABLE="${PYTHON}"
		-DPYTHON_EXECUTABLE="${PYTHON}"
	)

	if use cuda ; then
		export CUDA_PATH="${ESYSROOT}/opt/cuda"
		export HIP_PLATFORM="nvidia"
		mycmakeargs+=(
			-DHIP_COMPILER="nvcc"
			-DHIP_PLATFORM="nvidia"
			-DHIP_RUNTIME="cuda"
			-DUSE_COMGR_LIBRARY=OFF
		)
		if ! has_version "llvm-core/clang:${LLVM_SLOT}" ; then
			mycmakeargs+=(
				-D__HIP_ENABLE_PCH=OFF
			)
		fi
	elif use rocm ; then
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
			-DOPENCL_DIR="${OCL_S}"
#			-DROCclr_DIR="${ROCCLR_S}_build/lib/cmake/rocclr"
			-DROCclr_DIR="${ROCCLR_S}"
			-DBUILD_PAL=$(usex pal ON OFF)
			-DROCCLR_PATH="${ROCCLR_S}"
			-DUSE_COMGR_LIBRARY=ON
		)
	fi

	use profile && mycmakeargs+=(
		-DPROF_API_HEADER_PATH="${RTC_S}/inc/ext"
	)

	einfo "Building ROCClr"
	pushd "${ROCCLR_S}" >/dev/null 2>&1 || die
		CMAKE_USE_DIR="${ROCCLR_S}" \
		BUILD_DIR="${ROCCLR_S}_build" \
		rocm_src_configure

		CMAKE_USE_DIR="${ROCCLR_S}" \
		BUILD_DIR="${ROCCLR_S}_build" \
		cmake_src_compile
	popd >/dev/null 2>&1 || die

	if use rocm ; then
		mycmakeargs+=(
			-DROCclr_DIR="${WORKDIR}/ROCclr-rocm-4.1.0_build/lib/cmake/rocclr"
		)
	fi

	einfo "Building HIP"
	pushd "${S}" >/dev/null 2>&1 || die
		CMAKE_USE_DIR="${S}" \
		BUILD_DIR="${S}_build" \
		rocm_src_configure

		HIP_PATH="${HIP_S}" \
		docs_compile

		CMAKE_USE_DIR="${S}" \
		BUILD_DIR="${S}_build" \
		cmake_src_compile
	popd >/dev/null 2>&1 || die
}

src_install() {
	pushd "${ROCCLR_S}" >/dev/null 2>&1 || die
		CMAKE_USE_DIR="${ROCCLR_S}" \
		BUILD_DIR="${ROCCLR_S}_build" \
		cmake_src_install
	popd >/dev/null 2>&1 || die

	cmake_src_install

	# Don't install .hipInfo and .hipVersion to bin/lib
#	rm "${ED}${EROCM_PATH}/lib/.hipInfo" "${ED}/usr/bin/.hipVersion" || die
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
