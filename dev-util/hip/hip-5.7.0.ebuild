# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_DEPEND="media-gfx/graphviz"
LLVM_MAX_SLOT=17 # See https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-5.7.0/llvm/CMakeLists.txt
PYTHON_COMPAT=( python3_{10..11} )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake docs llvm prefix python-any-r1 rocm

SRC_URI="
https://github.com/ROCm-Developer-Tools/clr/archive/refs/tags/rocm-5.7.0.tar.gz
	-> rocm-clr-${PV}.tar.gz
https://github.com/ROCm-Developer-Tools/HIP/archive/rocm-${PV}.tar.gz
	-> rocm-hip-${PV}.tar.gz
https://github.com/ROCm-Developer-Tools/HIPCC/archive/refs/tags/rocm-${PV}.tar.gz
	-> rocm-hipcc-${PV}.tar.gz
"

DESCRIPTION="C++ Heterogeneous-Compute Interface for Portability"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/hipamd"
KEYWORDS="~amd64"
LICENSE="MIT"
SLOT="$(ver_cut 1-2)/${PV}"
IUSE="cuda debug +hsa -hsail +lc -pal numa +rocm system-llvm test r20"
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
			=sys-libs/compiler-rt-${LLVM_MAX_SLOT}*:=
		)
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-util/cmake-3.16.8
	test? (
		rocm? (
			~dev-util/rocminfo-${PV}:${SLOT}
		)
	)
"
CLR_PATCHES=(
	"${FILESDIR}/rocclr-5.7.0-path-changes.patch"
)
HIP_PATCHES=(
	"${FILESDIR}/${PN}-5.6.0-path-changes.patch"
)
HIPAMD_PATCHES=(
	"${FILESDIR}/${PN}-5.7.0-DisableTest.patch"
	"${FILESDIR}/${PN}-5.0.1-hip_vector_types.patch"
	"${FILESDIR}/${PN}-5.0.2-set-build-id.patch"
	"${FILESDIR}/${PN}-5.7.0-remove-cmake-doxygen-commands.patch"
	"${FILESDIR}/${PN}-5.5.1-disable-Werror.patch"
	"${FILESDIR}/${PN}-5.7.0-hip-config-not-cuda.patch"
	"${FILESDIR}/${PN}-5.7.0-hip-host-not-cuda.patch"
	"${FILESDIR}/hipamd-5.7.0-path-changes.patch"
)
HIPCC_PATCHES=(
	"${FILESDIR}/hipcc-5.6.0-fno-stack-protector.patch"
	"${FILESDIR}/hipcc-5.7.0-path-changes.patch"
)
OCL_PATCHES=(
	"${FILESDIR}/rocm-opencl-runtime-5.3.3-path-changes.patch"
)
S="${WORKDIR}/clr-rocm-${PV}/hipamd"
CLR_S="${WORKDIR}/clr-rocm-${PV}"
HIP_S="${WORKDIR}/HIP-rocm-${PV}"
HIPCC_S="${WORKDIR}/HIPCC-rocm-${PV}"
OCL_S="${WORKDIR}/clr-rocm-${PV}/opencl"
ROCCLR_S="${WORKDIR}/clr-rocm-${PV}/rocclr"
RTC_S="${WORKDIR}/roctracer-rocm-${PV}"
DOCS_DIR="${HIP_S}/docs/doxygen-input"
DOCS_CONFIG_NAME="doxy.cfg"

pkg_setup() {
	# Ignore QA FLAGS check for library compiled from assembly sources
	QA_FLAGS_IGNORED="/usr/$(get_libdir)/libhiprtc-builtins.so.$(ver_cut 1-2)"
	llvm_pkg_setup
	python-any-r1_pkg_setup
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	eapply "${HIPAMD_PATCHES[@]}"

	eapply_user

	# Use the ebuild slot number, otherwise git hash is attempted in vain.
	sed \
		-e "/set (HIP_LIB_VERSION_STRING/cset (HIP_LIB_VERSION_STRING ${SLOT#*/})" \
		-i \
		CMakeLists.txt \
		|| die

	sed \
		-e "/\.hip/d" \
		-e "/CPACK_RESOURCE_FILE_LICENSE/d" \
		-i \
		packaging/CMakeLists.txt \
		|| die

	pushd "${HIPCC_S}" || die
		eapply "${HIPCC_PATCHES[@]}"
		cp \
			$(prefixify_ro "${FILESDIR}/hipvars-5.3.3.pm") \
			"${HIPCC_S}/bin/hipvars.pm" \
			|| die "failed to replace hipvars.pm"
		sed \
			-e "s,@HIP_BASE_VERSION_MAJOR@,$(ver_cut 1)," \
			-e "s,@HIP_BASE_VERSION_MINOR@,$(ver_cut 2)," \
			-e "s,@HIP_VERSION_PATCH@,$(ver_cut 3)," \
			-i \
			"${HIPCC_S}/bin/hipvars.pm" \
			|| die
	popd || die

	pushd "${HIP_S}" || die
		eapply "${HIP_PATCHES[@]}"
		hprefixify $(grep \
			-rl \
			--exclude-dir="build/" \
			--exclude="hipcc.pl" \
			"/usr" \
			"${HIP_S}")
	popd || die

	if use rocm ; then
		pushd "${OCL_S}" || die
			eapply "${OCL_PATCHES[@]}"
		popd || die
		pushd "${ROCCLR_S}" || die
			eapply "${CLR_PATCHES[@]}"
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
		-DCMAKE_PREFIX_PATH="${ESYSROOT}${ROCM_LLVM_PATH}"
		-DCMAKE_SKIP_RPATH=ON
		-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DHIP_COMMON_DIR="${HIP_S}"
		-DROCM_PATH="${EPREFIX}${EROCM_PATH}"
		-DUSE_PROF_API=0
		-DUSE_SYSTEM_LLVM=$(usex system-llvm)
	)

	if use cuda ; then
		export CUDA_PATH="${ESYSROOT}/opt/cuda"
		export HIP_PLATFORM="nvidia"
		mycmakeargs+=(
			-DHIP_COMPILER="nvcc"
			-DHIP_PLATFORM="nvidia"
			-DHIP_RUNTIME="cuda" # There's a typo in the HIP faq.
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
			-DROCCLR_PATH="${ROCCLR_S}"
		)
	fi

	cmake_src_configure

	pushd "${HIPCC_S}" || die
		CMAKE_USE_DIR="${HIPCC_S}" \
		BUILD_DIR="${HIPCC_S}_build" \
		cmake_src_configure
	popd
}

src_compile() {
	HIP_PATH="${HIP_S}" \
	docs_compile
	cmake_src_compile

	pushd "${HIPCC_S}_build" || die
		CMAKE_USE_DIR="${HIPCC_S}" \
		BUILD_DIR="${HIPCC_S}_build" \
		cmake_src_compile
	popd
}

src_install() {
	# Quiet error
	mkdir -p "${HIP_S}/samples" || die

	cmake_src_install

	pushd "${HIPCC_S}_build" || die
		CMAKE_USE_DIR="${HIPCC_S}" \
		BUILD_DIR="${HIPCC_S}_build" \
		cmake_src_install
	popd

	rm "${ED}/usr/include/hip/hcc_detail" || die

	# Don't install .hipInfo and .hipVersion to bin/lib
	rm "${ED}/usr/bin/.hipVersion" || die
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
