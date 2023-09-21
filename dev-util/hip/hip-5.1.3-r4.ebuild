# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_DEPEND="media-gfx/graphviz"
LLVM_MAX_SLOT=14 # See https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-5.1.3/llvm/CMakeLists.txt
PYTHON_COMPAT=( python3_{10..11} )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake docs llvm prefix python-any-r1 rocm

SRC_URI="
https://github.com/ROCm-Developer-Tools/hipamd/archive/rocm-${PV}.tar.gz
	-> rocm-hipamd-${PV}.tar.gz
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
KEYWORDS="~amd64"
LICENSE="MIT"
SLOT="$(ver_cut 1-2)/${PV}"
IUSE="cuda debug +hsa -hsail +lc numa -pal profile +rocm system-llvm test r20"
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
	profile? (
		!cuda
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
RDEPEND="
	>=dev-perl/URI-Encode-1.1.1
	dev-util/hip-compiler[system-llvm=]
	virtual/opengl
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
		sys-devel/gcc:11
	)
	lc? (
		~dev-libs/rocm-comgr-${PV}:${SLOT}
	)
	numa? (
		sys-process/numactl
	)
	rocm? (
		!system-llvm? (
			sys-devel/llvm-roc:=
			~sys-devel/llvm-roc-${PV}:${ROCM_SLOT}
		)
		dev-util/rocm-compiler[system-llvm=]
		~dev-libs/rocr-runtime-${PV}:${SLOT}
		~dev-util/rocminfo-${PV}:${SLOT}
		system-llvm? (
			=sys-devel/clang-${LLVM_MAX_SLOT}*:=
			=sys-devel/clang-runtime-${LLVM_MAX_SLOT}*:=
		)
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	profile? (
		$(python_gen_any_dep '
			dev-python/CppHeaderParser[${PYTHON_USEDEP}]
		')
	)
	test? (
		rocm? (
			~dev-util/rocminfo-${PV}:${SLOT}
		)
	)
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-util/cmake-3.16.8
"
CLR_PATCHES=(
	"${FILESDIR}/rocclr-5.1.3-path-changes.patch"
)
HIP_PATCHES=(
	"${FILESDIR}/${PN}-5.1.3-fno-stack-protector.patch"
	"${FILESDIR}/${PN}-5.1.3-path-changes.patch"
)
HIPAMD_PATCHES=(
	"${FILESDIR}/${PN}-5.0.1-DisableTest.patch"
	"${FILESDIR}/${PN}-5.0.1-hip_vector_types.patch"
	"${FILESDIR}/${PN}-4.2.0-cancel-hcc-header-removal.patch"
	"${FILESDIR}/${PN}-5.0.2-set-build-id.patch"
	"${FILESDIR}/${PN}-5.1.3-fix-hip_prof_gen.patch"
	"${FILESDIR}/${PN}-5.1.3-remove-cmake-doxygen-commands.patch"
	"${FILESDIR}/0001-SWDEV-316128-HIP-surface-API-support.patch"
	"${FILESDIR}/${PN}-5.1.3-llvm-15-noinline-keyword.patch"
	"${FILESDIR}/${PN}-5.6.0-hip-config-not-cuda.patch"
	"${FILESDIR}/${PN}-5.6.0-hip-host-not-cuda.patch"
	"${FILESDIR}/hipamd-5.1.3-path-changes.patch"
)
OCL_PATCHES=(
	"${FILESDIR}/rocm-opencl-runtime-5.1.3-path-changes.patch"
)
RTC_PATCHES=(
	"${FILESDIR}/roctracer-5.1.3-path-changes.patch"
)
S="${WORKDIR}/hipamd-rocm-${PV}"
HIP_S="${WORKDIR}/HIP-rocm-${PV}"
OCL_S="${WORKDIR}/ROCm-OpenCL-Runtime-rocm-${PV}"
CLR_S="${WORKDIR}/ROCclr-rocm-${PV}"
RTC_S="${WORKDIR}/roctracer-rocm-${PV}"
DOCS_DIR="${HIP_S}/docs/doxygen-input"
DOCS_CONFIG_NAME="doxy.cfg"

python_check_deps() {
	if use profile; then
		python_has_version "dev-python/CppHeaderParser[${PYTHON_USEDEP}]"
	fi
}

pkg_setup() {
	llvm_pkg_setup
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
		CMakeLists.txt \
		|| die

	# Disable PCH, because it results in a build error in ROCm 4.0.0.
	sed \
		-e "s:option(__HIP_ENABLE_PCH:#option(__HIP_ENABLE_PCH:" \
		-i \
		CMakeLists.txt \
		|| die

	sed \
		-e "/\.hip/d" \
		-e "/cmake DESTINATION/d" \
		-e "/CPACK_RESOURCE_FILE_LICENSE/d" \
		-i \
		packaging/CMakeLists.txt \
		|| die

	pushd "${HIP_S}" || die
		eapply "${HIP_PATCHES[@]}"
		cp \
			$(prefixify_ro "${FILESDIR}/hipvars-5.1.3.pm") \
			"${HIP_S}/bin/hipvars.pm" \
			|| die "failed to replace hipvars.pm"
		sed \
			-e "s,@HIP_BASE_VERSION_MAJOR@,$(ver_cut 1)," \
			-e "s,@HIP_BASE_VERSION_MINOR@,$(ver_cut 2)," \
			-e "s,@HIP_VERSION_PATCH@,$(ver_cut 3)," \
			-i \
			"${HIP_S}/bin/hipvars.pm" \
			|| die
	popd || die

	if use rocm ; then
		pushd "${OCL_S}" || die
			eapply "${OCL_PATCHES[@]}"
		popd || die
		pushd "${CLR_S}" || die
			eapply "${CLR_PATCHES[@]}"
		popd || die
	fi

	if use profile ; then
		pushd "${RTC_S}" || die
			eapply "${RTC_PATCHES[@]}"
		popd || die
	fi
	rocm_src_prepare
}

src_configure() {
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
		-DUSE_SYSTEM_LLVM=$(usex system-llvm)
	)

	if use cuda ; then
		export CUDA_PATH="${ESYSROOT}/opt/cuda"
		export HIP_PLATFORM="nvidia"
		mycmakeargs+=(
			-DHIP_COMPILER="nvcc"
			-DHIP_PLATFORM="nvidia"
			-DHIP_RUNTIME="cuda"
		)
		if ! has_version "sys-devel/clang:${LLVM_MAX_SLOT}" ; then
			mycmakeargs+=(
				-D__HIP_ENABLE_PCH=OFF
			)
		fi
	elif use rocm ; then
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
			-DAMD_OPENCL_PATH="${OCL_S}"
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
			-DROCCLR_ENABLE_LC=$(usex lc ON OFF)
			-DROCCLR_ENABLE_HSA=$(usex hsa ON OFF)
			-DROCCLR_ENABLE_HSAIL=$(usex hsail ON OFF)
			-DROCCLR_ENABLE_PAL=$(usex pal ON OFF)
			-DROCCLR_PATH="${CLR_S}"
		)
	fi

	use profile && mycmakeargs+=(
		-DPROF_API_HEADER_PATH="${RTC_S}/inc/ext"
	)

	cmake_src_configure
}

src_compile() {
	HIP_PATH="${HIP_S}" \
	docs_compile
	cmake_src_compile
}

src_install() {
	cmake_src_install

	rm "${ED}/usr/include/hip/hcc_detail" || die

	# Don't install .hipInfo and .hipVersion to bin/lib
	rm "${ED}/usr/lib/.hipInfo" "${ED}/usr/bin/.hipVersion" || die
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without problems
