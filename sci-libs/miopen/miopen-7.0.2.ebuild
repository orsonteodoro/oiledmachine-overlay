# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
# https://github.com/ROCm/MIOpen/blob/rocm-7.0.2/test/CMakeLists.txt#L121
	gfx803
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx942
	gfx950
	gfx1030
	gfx1031
	gfx1100
	gfx1102
	gfx1200
	gfx1201
)
AMDGPU_UNTESTED_TARGETS=(
	gfx803
)
FIN_COMMIT="77669a7a1158e336ec831c19525a66db3d2d37f1"
MIOPENKERNELS_TARGETS_COMPAT=(
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx942
	gfx1030
)
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
LLVM_SLOT=19
inherit check-compiler-switch cmake flag-o-matic rocm

KEYWORDS="~amd64"
S="${WORKDIR}/MIOpen-rocm-${PV}"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/MIOpen/archive/rocm-${PV}.tar.gz
	-> MIOpen-${PV}.tar.gz
https://github.com/ROCmSoftwarePlatform/MIFin/archive/${FIN_COMMIT}.tar.gz
	-> MIFin-${FIN_COMMIT:0:7}.tar.gz
"

DESCRIPTION="AMD's Machine Intelligence Library"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/MIOpen"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
"
# The distro's MIT license template does not contain All rights Reserved.
RESTRICT="
	!test? (
		test
	)
"
SLOT="0/${ROCM_SLOT}"
IUSE="
+ai-kernel-tuning comgr composable-kernel debug hiprtc kernels mlir opencl +rocm test
ebuild_revision_16
"
gen_amdgpu_required_use() {
	local x
	for x in ${AMDGPU_TARGETS_COMPAT[@]} ; do
		echo "
			amdgpu_targets_${x}? (
				rocm
			)
		"
	done
}
REQUIRED_USE="
	$(gen_amdgpu_required_use)
	composable-kernel? (
		!amdgpu_targets_gfx1031
		rocm
	)
	hiprtc? (
		comgr
		rocm
	)
	kernels? (
		|| (
			${MIOPENKERNELS_TARGETS_COMPAT[@]/#/amdgpu_targets_}
		)
	)
	opencl? (
		!comgr
		!composable-kernel
	)
	^^ (
		rocm
		opencl
	)
"
RDEPEND="
	>=app-arch/zstd-1.4.5
	>=dev-db/sqlite-3.43.2
	>=dev-libs/boost-1.83
	app-alternatives/bzip2
	>=dev-util/hip-${PV}:${SLOT}
	dev-util/hip:=
	ai-kernel-tuning? (
		>=dev-cpp/frugally-deep-0.15.21_p0
		>=dev-cpp/eigen-3.4.0
	)
	comgr? (
		>=dev-libs/rocm-comgr-${PV}:${SLOT}
		dev-libs/rocm-comgr:=
	)
	composable-kernel? (
		sci-libs/composable-kernel:${ROCM_SLOT}[${COMPOSABLE_KERNEL_7_0_AMDGPU_USEDEP}]
		sci-libs/composable-kernel:=
	)
	kernels? (
		>=sci-libs/miopenkernels-${PV}:${SLOT}[${MIOPENKERNELS_7_0_AMDGPU_USEDEP}]
		sci-libs/miopenkernels:=
	)
	opencl? (
		>=dev-libs/rocm-opencl-runtime-${PV}:${SLOT}[${LLVM_ROC_LIBOMP_7_0_AMDGPU_USEDEP}]
		dev-libs/rocm-opencl-runtime:=
	)
	rocm? (
		>=dev-util/hip-${PV}:${SLOT}[rocm]
		dev-util/hip:=
		>=sci-libs/rocBLAS-${PV}:${SLOT}[${ROCBLAS_7_0_AMDGPU_USEDEP},rocm]
		sci-libs/rocBLAS:=
	)
"
DEPEND="
	${RDEPEND}
	>=dev-libs/half-1.12.0:=
	>=dev-cpp/eigen-3.4.0:3=
	>=dev-cpp/frugally-deep-0.15.20:=
	>=dev-cpp/nlohmann_json-3.11.2:=
"
#	sys-devel/binutils[gold,plugins]
BDEPEND="
	${HIP_CLANG_DEPEND}
	virtual/pkgconfig
	>=dev-build/rocm-cmake-${PV}:${SLOT}
	dev-build/rocm-cmake:=
	mlir? (
		>=sci-libs/rocMLIR-${ROCM_SLOT}:${SLOT}[fat-librockcompiler(+)]
		sci-libs/rocMLIR:=
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-6.1.2-disable-no-inline-boost.patch" # Build time testing
	"${FILESDIR}/${PN}-5.6.0-strip-xnack-in-flags.patch"
	"${FILESDIR}/${PN}-6.2.0-fix-interface-include-in-HIP_COMPILER_FLAGS.patch"
	"${FILESDIR}/${PN}-7.0.2-no-strip.patch"
#	"${FILESDIR}/${PN}-5.1.3-include-array.patch"
#	"${FILESDIR}/${PN}-5.1.3-avoid-metadata-error-for-vanilla-clang.patch" # Fixed in pr #1830
#	"${FILESDIR}/${PN}-6.1.2-bzcat-path.patch"
	"${FILESDIR}/${PN}-6.2.0-filesystem_error.patch"
)

warn_untested_gpu() {
	local gpu
	for gpu in ${AMDGPU_UNTESTED_TARGETS[@]} ; do
		if use "amdgpu_targets_${gpu}" ; then
ewarn "${gpu} is not tested upstream but may still be available."
		fi
	done
}

pkg_setup() {
	check-compiler-switch_start
	rocm_pkg_setup
	warn_untested_gpu
}

src_unpack() {
	unpack ${A}
	rm -rf "${S}/fin" || true
	mv \
		"${WORKDIR}/MIFin-${FIN_COMMIT}" \
		"${S}/fin" \
		|| die
}

src_prepare() {
ewarn "Please wait... Patching may take longer than usual."
	cmake_src_prepare
	hipconfig --help >/dev/null || die
	sed \
		-e '/MIOPEN_TIDY_ERRORS ALL/d' \
		-i "CMakeLists.txt" \
		|| die

	rocm_src_prepare

	# This plus avoid-metadata-error-for-vanilla-clang.patch fix bug mentioned
	# in https://github.com/ROCmSoftwarePlatform/MIOpen/issues/1731
	find src/kernels -name "*.s" -exec \
		sed \
			-e "s/.name: n /.name: x /g" \
			-e "s/.name: y /.name: z /g" \
			-e "s/.name: y,/.name: z,/g" \
			-i {} \; \
			|| die

	if use kernels ; then
		mkdir -p "src/kernels" || die
		local MA=(
			$(get_amdgpu_flags \
				| tr ";" " ")
		)
		cd "${ESYSROOT}/opt/rocm/share/miopen/db" || die
einfo "Copying kernels"
		local ma
		for ma in ${MA[@]} ; do
			ls "${ma}"*".kdb.bz2" >/dev/null || continue
			cp -av "${ma}"*".kdb.bz2" "${S}/src/kernels" || die
		done
	fi
}

filter_test_gpus() {
	if use "${gpu_target}" && [[ "${gputarget}" =~ "gfx103" ]] ; then
		echo "-DMIOPEN_TEST_GFX103X=ON"
	elif use "${gpu_target}" && [[ "${gputarget}" =~ "gfx110" ]] ; then
		echo "-DMIOPEN_TEST_GFX110X=ON"
	elif use "${gpu_target}" && [[ "${gputarget}" =~ "gfx94" ]] ; then
		echo "-DMIOPEN_TEST_GFX94X=ON"
	elif use "amdgpu_targets_${gpu_target}" ; then
		echo "-DMIOPEN_TEST_${gpu_target^^}=ON"
	fi
}

src_configure() {
	# Prevent linking error:
	# libhsa-runtime64.so: undefined reference to `hsaKmtReplaceAsanHeaderPage'
	#append-flags -Wl,-fuse-ld=gold
	#append-ldflags -fuse-ld=gold
	filter-flags -Wl,--as-needed

	if ! use debug ; then
		append-cflags "-DNDEBUG"
		append-cxxflags "-DNDEBUG"
		CMAKE_BUILD_TYPE="Release"
	else
		CMAKE_BUILD_TYPE="Debug"
	fi

	local mycmakeargs=(
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DBoost_USE_STATIC_LIBS=OFF
		-DBUILD_TESTING=$(usex test ON OFF)
	# Removed double slash (//) to fix error "file called with network path DESTINATION."
		-DCMAKE_INSTALL_PREFIX=$(realpath -m "${EPREFIX}/${EROCM_PATH}")
		-DCMAKE_SKIP_RPATH=ON
		-DMIOPEN_BACKEND=HIP
		-DMIOPEN_ENABLE_AI_KERNEL_TUNING=$(usex ai-kernel-tuning ON OFF)
		-DMIOPEN_TEST_ALL=$(usex test ON OFF)
		-DMIOPEN_USE_COMGR=$(usex comgr ON OFF)
		-DMIOPEN_USE_COMPOSABLEKERNEL=$(usex composable-kernel ON OFF)
		-DMIOPEN_USE_HIPRTC=$(usex hiprtc ON OFF)
		-DMIOPEN_USE_MLIR=$(usex mlir ON OFF)
	)

	if use mlir ; then
		mycmakeargs+=(
			-DCMAKE_MODULE_PATH="${ESYSROOT}${EROCM_PATH}/$(rocm_get_libdir)/cmake/rocMLIR"
		)
	fi

	if use test ; then
		local gpu_target
		for gpu_target in ${AMDGPU_TARGETS_COMPAT[@]} ; do
			mycmakeargs+=(
				$(filter_test_gpus)
			)
		done
	fi

	addpredict "/dev/kfd"
	addpredict "/dev/dri/"
	append-cxxflags "--rocm-path=${ESYSROOT}${EROCM_PATH}"
	append-cxxflags "--hip-device-lib-path=${ESYSROOT}${EROCM_PATH}/$(rocm_get_libdir)/amdgcn/bitcode"

	# Fix for both
	# lld: error: undefined symbol: __stack_chk_fail ; if fail try append-flags "-fno-stack-protector"
	# lld: error: undefined hidden symbol: free
	replace-flags '-O0' '-O1'

	if has_version "dev-util/hip:0/${ROCM_SLOT}[numa]" ; then
		append-ldflags -lnuma
	fi

	rocm_set_default_clang

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

	rocm_src_configure
}

src_test() {
	check_amdgpu
	export LD_LIBRARY_PATH="${BUILD_DIR}/$(rocm_get_libdir)"

	MAKEOPTS="-j1" \
	cmake_src_test
}

src_install() {
	cmake_src_install
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs test
