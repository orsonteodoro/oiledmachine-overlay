# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
# https://github.com/ROCm/MIOpen/blob/rocm-5.3.3/test/CMakeLists.txt#L99
	gfx803
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx1030
	gfx1031
)
AMDGPU_UNTESTED_TARGETS=(
	gfx803
)
MIOPENKERNELS_TARGETS_COMPAT=(
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx1030
)
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"
LLVM_SLOT=15
inherit cmake flag-o-matic rocm

KEYWORDS="~amd64"
S="${WORKDIR}/MIOpen-rocm-${PV}"
SRC_URI="
https://github.com/ROCmSoftwarePlatform/MIOpen/archive/rocm-${PV}.tar.gz
	-> MIOpen-${PV}.tar.gz
"

DESCRIPTION="AMD's Machine Intelligence Library"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/MIOpen"
LICENSE="MIT"
RESTRICT="
	!test? (
		test
	)
"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="comgr debug hiprtc kernels mlir opencl +rocm test ebuild-revision-5"
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
	)
	^^ (
		rocm
		opencl
	)
"
gen_miopenkernels_depends() {
	local g
	local list=""
	for g in ${MIOPENKERNELS_TARGETS_COMPAT[@]} ; do
		list="${list},amdgpu_targets_${g}?"
	done
	list="${list:1}"
	echo "
		~sci-libs/miopenkernels-${PV}:${ROCM_SLOT}[${list}]
	"
}
RDEPEND="
	>=dev-db/sqlite-3.17
	>=dev-libs/boost-1.72
	app-alternatives/bzip2
	~dev-util/hip-${PV}:${ROCM_SLOT}
	comgr? (
		~dev-libs/rocm-comgr-${PV}:${ROCM_SLOT}
	)
	kernels? (
		$(gen_miopenkernels_depends)
	)
	opencl? (
		sys-devel/clang
		virtual/opencl
		~sci-libs/miopengemm-${PV}:${ROCM_SLOT}
	)
	rocm? (
		~dev-util/hip-${PV}:${ROCM_SLOT}[rocm]
		~sci-libs/rocBLAS-${PV}:${ROCM_SLOT}[${ROCM_USEDEP},rocm]
	)
"
DEPEND="
	${RDEPEND}
	>=dev-libs/half-1.12.0:=
	>=dev-cpp/nlohmann_json-3.10.4:=
"
BDEPEND="
	sys-devel/binutils[gold,plugins]
	virtual/pkgconfig
	~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
	mlir? (
		~sci-libs/rocMLIR-${PV}:${ROCM_SLOT}[fat-librockcompiler(+)]
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-4.2.0-disable-no-inline-boost.patch"
	"${FILESDIR}/${PN}-4.2.0-gcc11-numeric_limits.patch"
	"${FILESDIR}/${PN}-5.6.0-strip-xnack-in-flags.patch"
	"${FILESDIR}/${PN}-4.3.0-fix-interface-include-in-HIP_COMPILER_FLAGS.patch"
	"${FILESDIR}/${PN}-5.3.3-enable-test.patch"
	"${FILESDIR}/${PN}-5.3.3-deprecate-clang-ocl.patch"
	"${FILESDIR}/${PN}-5.1.3-no-strip.patch"
	"${FILESDIR}/${PN}-5.1.3-include-array.patch"
	"${FILESDIR}/${PN}-5.1.3-avoid-metadata-error-for-vanilla-clang.patch" # See also pr #1830
	"${FILESDIR}/${PN}-5.3.3-hardcoded-paths.patch"
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
	rocm_pkg_setup
	warn_untested_gpu
}

src_prepare() {
ewarn "Please wait... Patching may take longer than usual."
	cmake_src_prepare

	hipconfig --help >/dev/null || die
	sed \
		-e '/MIOPEN_TIDY_ERRORS ALL/d' \
		-i "CMakeLists.txt" \
		|| die

        # Speed up symbol replacmenet for @...@ by reducing the search space
        # Generated from below one liner ran in the same folder as this file:
        # grep -F -r -e "+++" | cut -f 2 -d " " | cut -f 1 -d $'\t' | sort | uniq | cut -f 2- -d $'/' | sort | uniq
	PATCH_PATHS=(
		"${S}/CMakeLists.txt"
		"${S}/cmake/ClangTidy.cmake"
		"${S}/cmake/CppCheck.cmake"
		"${S}/cmake/FindOpenCL.cmake"
		"${S}/cmake/rocm-path.cmake"
		"${S}/fin/CMakeLists.txt"
		"${S}/fin/cmake/ClangTidy.cmake"
		"${S}/fin/cmake/CppCheck.cmake"
		"${S}/fin/cmake/FindOpenCL.cmake"
		"${S}/fin/cmake/rocm-path.cmake"
		"${S}/fin/install_deps.cmake"
		"${S}/fin/src/CMakeLists.txt"
		"${S}/install_deps.cmake"
		"${S}/src/composable_kernel/cmake/ClangTidy.cmake"
		"${S}/src/composable_kernel/cmake/CppCheck.cmake"
		"${S}/test/CMakeLists.txt"
	)
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
		cd "${ESYSROOT}/opt/rocm-${PV}/share/miopen/db" || die
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
	elif use "amdgpu_targets_${gpu_target}" ; then
		echo "-DMIOPEN_TEST_${gpu_target^^}=ON"
	fi
}

src_configure() {
	# Prevent linking error:
	# libhsa-runtime64.so: undefined reference to `hsaKmtReplaceAsanHeaderPage'
	append-flags -Wl,-fuse-ld=gold
	append-ldflags -fuse-ld=gold
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
		-DBUILD_TESTS=$(usex test ON OFF)
	# Removed double slash (//) to fix error "file called with network path DESTINATION."
		-DCMAKE_INSTALL_PREFIX=$(realpath -m "${EPREFIX}/${EROCM_PATH}")
		-DCMAKE_SKIP_RPATH=ON
		-DMIOPEN_BACKEND=HIP
		-DMIOPEN_TEST_ALL=$(usex test ON OFF)
		-DMIOPEN_USE_COMGR=$(usex comgr ON OFF)
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

	addpredict /dev/kfd
	addpredict /dev/dri/
	append-cxxflags "--rocm-path=${ESYSROOT}${EROCM_PATH}"
	append-cxxflags "--hip-device-lib-path=${ESYSROOT}${EROCM_PATH}/$(rocm_get_libdir)/amdgcn/bitcode"

	# Fix for both
	# lld: error: undefined symbol: __stack_chk_fail ; if fail try append-flags "-fno-stack-protector"
	# lld: error: undefined hidden symbol: free
	replace-flags '-O0' '-O1'

	export CC="clang"
	export CXX="clang++"
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

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
