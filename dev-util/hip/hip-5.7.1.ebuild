# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
DOCS_BUILDER="doxygen"
DOCS_CONFIG_NAME="doxy.cfg"
DOCS_DEPEND="media-gfx/graphviz"
HIP_SUPPORT_CUDA=1
LLVM_SLOT=17 # See https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-5.7.1/llvm/CMakeLists.txt
PYTHON_COMPAT=( "python3_"{10..11} )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake docs flag-o-matic prefix python-any-r1 rocm

KEYWORDS="~amd64"
S="${WORKDIR}/clr-rocm-${PV}/hipamd"
CLR_S="${WORKDIR}/clr-rocm-${PV}"
HIP_S="${WORKDIR}/HIP-rocm-${PV}"
HIPCC_S="${WORKDIR}/HIPCC-rocm-${PV}"
OCL_S="${WORKDIR}/clr-rocm-${PV}/opencl"
ROCCLR_S="${WORKDIR}/clr-rocm-${PV}/rocclr"
RTC_S="${WORKDIR}/roctracer-rocm-${PV}"
DOCS_DIR="${HIP_S}/docs/doxygen-input"
SRC_URI="
https://github.com/ROCm-Developer-Tools/clr/archive/refs/tags/rocm-${PV}.tar.gz
	-> rocm-clr-${PV}.tar.gz
https://github.com/ROCm-Developer-Tools/HIP/archive/rocm-${PV}.tar.gz
	-> rocm-hip-${PV}.tar.gz
https://github.com/ROCm-Developer-Tools/HIPCC/archive/refs/tags/rocm-${PV}.tar.gz
	-> rocm-hipcc-${PV}.tar.gz
"

DESCRIPTION="C++ Heterogeneous-Compute Interface for Portability"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/hipamd"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
	Apache-2.0
	custom
	MIT
"
# all-rights-reserved MIT - clr-rocm-5.7.1/CMakeLists.txt
# Apache-2.0 - clr-rocm-5.7.1/opencl/khronos/icd/LICENSE
# custom - clr-rocm-5.7.1/opencl/khronos/icd/LICENSE.txt
# custom - clr-rocm-5.7.1/opencl/khronos/headers/opencl2.2/LICENSE
# MIT - clr-rocm-5.7.1/rocclr/LICENSE.txt
RESTRICT="strip"
SLOT="$(ver_cut 1-2)/${PV}"
IUSE="cuda debug +hsa -hsail +lc -pal numa +rocm test ebuild_revision_39"
REQUIRED_USE="
	hsa? (
		rocm
	)
	hsail? (
		rocm
	)
	lc? (
		rocm
	)
	numa? (
		hsa
	)
	pal? (
		rocm
	)
	rocm? (
		|| (
			hsail
			lc
		)
		|| (
			hsa
			pal
		)
	)
	test? (
		rocm? (
			hsa
			lc
		)
	)
	^^ (
		cuda
		rocm
	)
"
# ROCclr uses clang -print-libgcc-file-name which may output a static-lib to link to.
RDEPEND="
	>=dev-perl/URI-Encode-1.1.1
	app-eselect/eselect-rocm
	virtual/opengl
	cuda? (
		${HIP_CUDA_DEPEND}
	)
	lc? (
		~dev-libs/rocm-comgr-${PV}:${ROCM_SLOT}
	)
	numa? (
		sys-process/numactl
	)
	rocm? (
		${ROCM_CLANG_DEPEND}
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
	test? (
		rocm? (
			~dev-util/rocminfo-${PV}:${ROCM_SLOT}
		)
	)
"
CLR_PATCHES=(
	"${FILESDIR}/rocclr-5.7.0-include-path.patch"
#	"${FILESDIR}/rocclr-5.7.0-opencl-header.patch"
)
ROCCLR_PATCHES=(
)
HIP_PATCHES=(
)
HIPAMD_PATCHES=(
	"${FILESDIR}/${PN}-5.7.0-DisableTest.patch"
	"${FILESDIR}/${PN}-5.0.1-hip_vector_types.patch"
	"${FILESDIR}/${PN}-5.0.2-set-build-id.patch"
	"${FILESDIR}/${PN}-5.7.0-remove-cmake-doxygen-commands.patch"
	"${FILESDIR}/${PN}-5.5.1-disable-Werror.patch"
	"${FILESDIR}/${PN}-5.7.0-hip-config-not-cuda.patch"
	"${FILESDIR}/${PN}-5.7.0-hip-host-not-cuda.patch"
	"${FILESDIR}/hipamd-5.7.1-unwrap-line.patch"
	"${FILESDIR}/hipamd-5.7.0-hip_fatbin-header.patch"
	"${FILESDIR}/hipamd-5.7.0-hiprtc-includes-path.patch"
	"${FILESDIR}/hipamd-5.7.0-hiprtc-header.patch"
	"${FILESDIR}/hipamd-5.7.0-fix-install-cmake-files.patch"
	"${FILESDIR}/hipamd-5.7.1-link-hsa-runtime64.patch"
)
HIPCC_PATCHES=(
	"${FILESDIR}/hipcc-5.6.0-fno-stack-protector.patch"
)
OCL_PATCHES=(
)

pkg_setup() {
	if use rocm ; then
ewarn
ewarn "The lc USE flag may be required."
ewarn
	fi
	python-any-r1_pkg_setup
	rocm_pkg_setup

	# Ignore QA FLAGS check for library compiled from assembly sources
	QA_FLAGS_IGNORED="/opt/rocm-${PV}/$(rocm_get_libdir)/libhiprtc-builtins.so.$(ver_cut 1-2)"
}

src_prepare() {
	cmake_src_prepare
	eapply "${HIPAMD_PATCHES[@]}"
	eapply_user

	# Use the ebuild slot number, otherwise git hash is attempted in vain.
	sed \
		-e "/set (HIP_LIB_VERSION_STRING/cset (HIP_LIB_VERSION_STRING ${SLOT#*/})" \
		-i \
		"CMakeLists.txt" \
		|| die

	sed \
		-e "/\.hip/d" \
		-i \
		"packaging/CMakeLists.txt" \
		|| die

	pushd "${HIPCC_S}" >/dev/null 2>&1 || die
		eapply "${HIPCC_PATCHES[@]}"
		cp \
			$(prefixify_ro "${FILESDIR}/hipvars-5.3.3.pm") \
			"${HIPCC_S}/bin/hipvars.pm" \
			|| die "failed to replace hipvars.pm"
		if use cuda ; then
			sed \
				-e "s,@HIP_COMPILER@,nvcc," \
				-e "s,@HIP_PLATFORM@,nvidia," \
				-e "s,@HIP_RUNTIME@,cuda," \
				-i \
				"${HIPCC_S}/bin/hipvars.pm" \
				|| die
		elif use rocm ; then
			sed \
				-e "s,@HIP_COMPILER@,clang," \
				-e "s,@HIP_PLATFORM@,amd," \
				-e "s,@HIP_RUNTIME@,rocclr," \
				-i \
				"${HIPCC_S}/bin/hipvars.pm" \
				|| die
		fi
		sed \
			-e "s,@HIP_BASE_VERSION_MAJOR@,$(ver_cut 1)," \
			-e "s,@HIP_BASE_VERSION_MINOR@,$(ver_cut 2)," \
			-e "s,@HIP_VERSION_PATCH@,$(ver_cut 3)," \
			-i \
			"${HIPCC_S}/bin/hipvars.pm" \
			|| die
	popd >/dev/null 2>&1 || die

	pushd "${HIP_S}" >/dev/null 2>&1 || die
		#eapply "${HIP_PATCHES[@]}"
		hprefixify $(grep \
			-rl \
			--exclude-dir="build/" \
			--exclude="hipcc.pl" \
			"/usr" \
			"${HIP_S}")
	popd >/dev/null 2>&1 || die

	if use rocm ; then
		pushd "${OCL_S}" >/dev/null 2>&1 || die
			#eapply "${OCL_PATCHES[@]}"
		popd >/dev/null 2>&1 || die
		pushd "${ROCCLR_S}" >/dev/null 2>&1 || die
			#eapply "${ROCCLR_PATCHES[@]}"
		popd >/dev/null 2>&1 || die
		pushd "${CLR_S}" >/dev/null 2>&1 || die
			eapply "${CLR_PATCHES[@]}"
		popd >/dev/null 2>&1 || die
	fi

	pushd "${WORKDIR}" >/dev/null 2>&1 || die
		eapply "${FILESDIR}/${PN}-5.7.1-hardcoded-paths.patch"
	popd >/dev/null 2>&1 || die

	rocm_src_prepare
}

src_configure() {
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
		-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DHIP_COMMON_DIR="${HIP_S}"
		-DHIPCC_BIN_DIR="${WORKDIR}/HIPCC-rocm-${PV}/bin"
		-DROCM_PATH="${EPREFIX}${EROCM_PATH}"
		-DUSE_PROF_API=0
		-DUSE_SYSTEM_LLVM=OFF
	)

	if use cuda ; then
		export CUDA_PATH="${ESYSROOT}/opt/cuda"
		export HIP_PLATFORM="nvidia"
		mycmakeargs+=(
			-DHIP_COMPILER="nvcc"
			-DHIP_PLATFORM="nvidia"
			-DHIP_RUNTIME="cuda" # There's a typo in the HIP faq.
		)
		if ! has_version "llvm-core/clang:${LLVM_SLOT}" ; then
			mycmakeargs+=(
				-D__HIP_ENABLE_PCH=OFF
			)
		fi
	elif use rocm ; then
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DAMD_OPENCL_PATH="${OCL_S}"
			-DCLR_PATH="${CLR_S}"
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
			-DROCCLR_ENABLE_LC=$(usex lc ON OFF)
			-DROCCLR_ENABLE_HSA=$(usex hsa ON OFF)
			-DROCCLR_ENABLE_HSAIL=$(usex hsail ON OFF)
			-DROCCLR_ENABLE_PAL=$(usex pal ON OFF)
			-DROCCLR_PATH="${ROCCLR_S}"
			-DUSE_COMGR_LIBRARY=$(usex lc ON OFF)
		)
	fi

	pushd "${ROCCLR_S}" >/dev/null 2>&1 || die
		CMAKE_USE_DIR="${ROCCLR_S}" \
		BUILD_DIR="${ROCCLR_S}_build" \
		rocm_src_configure
	popd >/dev/null 2>&1 || die

	rocm_src_configure

	pushd "${HIPCC_S}" >/dev/null 2>&1 || die
		CMAKE_USE_DIR="${HIPCC_S}" \
		BUILD_DIR="${HIPCC_S}_build" \
		rocm_src_configure
	popd >/dev/null 2>&1 || die
}

src_compile() {
	pushd "${ROCCLR_S}" >/dev/null 2>&1 || die
		CMAKE_USE_DIR="${ROCCLR_S}" \
		BUILD_DIR="${ROCCLR_S}_build" \
		cmake_src_compile
	popd >/dev/null 2>&1 || die

	HIP_PATH="${HIP_S}" \
	docs_compile
	cmake_src_compile


	pushd "${HIPCC_S}_build" >/dev/null 2>&1 || die
		CMAKE_USE_DIR="${HIPCC_S}" \
		BUILD_DIR="${HIPCC_S}_build" \
		cmake_src_compile
	popd >/dev/null 2>&1 || die
}

src_install() {
	# Quiet error
	mkdir -p "${HIP_S}/samples" || die

	cmake_src_install

	pushd "${HIPCC_S}_build" >/dev/null 2>&1 || die
		CMAKE_USE_DIR="${HIPCC_S}" \
		BUILD_DIR="${HIPCC_S}_build" \
		cmake_src_install
	popd >/dev/null 2>&1 || die

	rm "${ED}${EROCM_PATH}/include/hip/hcc_detail" || die

	# Don't install .hipInfo and .hipVersion to bin/lib
#	rm "${ED}${EROCM_PATH}/bin/.hipVersion" || die
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
