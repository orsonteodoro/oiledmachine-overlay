# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="${PV}" # For /opt/rocm-5.4.3

AMDGPU_TARGETS_COMPAT=(
#	 gfx800
#	 gfx802
	gfx803
#	 gfx804
	gfx900
#	 gfx904
	gfx906
	gfx908
	gfx90a
	gfx1011
	gfx1012
	gfx1030
	gfx1031
)
ROCM_VERSION="${PV}"
LLVM_MAX_SLOT=15
inherit cmake flag-o-matic llvm rocm

SRC_URI="
https://github.com/ROCmSoftwarePlatform/MIOpen/archive/rocm-${PV}.tar.gz
	-> MIOpen-${PV}.tar.gz
"

DESCRIPTION="AMD's Machine Intelligence Library"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/MIOpen"
LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE="comgr composable-kernel debug hiprtc kernels mlir opencl +rocm test r1"
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
		rocm
	)
	hiprtc? (
		comgr
		rocm
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
	>=dev-db/sqlite-3.17
	>=dev-libs/boost-1.72
	app-arch/bzip2
	~dev-util/hip-${PV}:${SLOT}
	comgr? (
		~dev-libs/rocm-comgr-${PV}:${SLOT}
	)
	composable-kernel? (
		>=sci-libs/composable_kernel-1.0.0
	)
	kernels? (
		~sci-libs/miopenkernels-${PV}:${SLOT}
	)
	opencl? (
		sys-devel/clang
		virtual/opencl
		~sci-libs/miopengemm-${PV}:${SLOT}
	)
	rocm? (
		~dev-util/hip-${PV}:${SLOT}[rocm]
		~sci-libs/rocBLAS-${PV}:${SLOT}[${ROCM_USEDEP},rocm]
	)
"
DEPEND="
	${RDEPEND}
	>=dev-libs/half-1.12.0:=
	>=dev-cpp/nlohmann_json-3.10.4:=
"
BDEPEND="
	virtual/pkgconfig
	~dev-util/rocm-cmake-${PV}:${SLOT}
	mlir? (
		~sci-libs/rocMLIR-${PV}:${SLOT}[fat-librockcompiler(+)]
	)
"
RESTRICT="
	!test? (
		test
	)
"
S="${WORKDIR}/MIOpen-rocm-${PV}"
PATCHES=(
	"${FILESDIR}/${PN}-4.2.0-disable-no-inline-boost.patch"
	"${FILESDIR}/${PN}-4.2.0-gcc11-numeric_limits.patch"
	"${FILESDIR}/${PN}-5.6.0-strip-xnack-in-flags.patch"
	"${FILESDIR}/${PN}-4.3.0-fix-interface-include-in-HIP_COMPILER_FLAGS.patch"
	"${FILESDIR}/${PN}-5.3.3-enable-test.patch"
#	"${FILESDIR}/${PN}-5.1.3-gfx1031.patch" # Already added upstream but some parts missing
	"${FILESDIR}/${PN}-5.1.3-no-strip.patch"
	"${FILESDIR}/${PN}-5.1.3-include-array.patch"
	"${FILESDIR}/${PN}-5.1.3-avoid-metadata-error-for-vanilla-clang.patch" # See also pr #1830
	"${FILESDIR}/${PN}-5.4.3-path-changes.patch"
)

pkg_setup() {
	llvm_pkg_setup # For LLVM_SLOT init.  Must be explicitly called or it is blank.
	rocm_pkg_setup
}

src_prepare() {
ewarn "Please wait... Patching may take longer than usual."
	cmake_src_prepare

	hipconfig --help >/dev/null || die
	sed \
		-e '/MIOPEN_TIDY_ERRORS ALL/d' \
		-i CMakeLists.txt \
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
		cd "${ESYSROOT}/opt/rocm-${MY_PV}/share/miopen/db" || die
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
	elif [[ "${gpu_target}" =~ ("gfx900"|"gfx906"|"gfx908"|"gfx90a") ]] ; then
		echo "-DMIOPEN_TEST_${gpu_target^^}=ON"
	fi
}

src_configure() {
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
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCMAKE_SKIP_RPATH=ON
		-DMIOPEN_BACKEND=HIP
		-DMIOPEN_TEST_ALL=$(usex test ON OFF)
		-DMIOPEN_USE_COMGR=$(usex comgr ON OFF)
		-DMIOPEN_USE_COMPOSABLEKERNEL=$(usex composable-kernel ON OFF)
		-DMIOPEN_USE_HIPRTC=$(usex hiprtc ON OFF)
		-DMIOPEN_USE_MLIR=$(usex mlir ON OFF)
	)

	if use mlir ; then
		mycmakeargs+=(
			-DCMAKE_MODULE_PATH="${ESYSROOT}/usr/$(get_libdir)/cmake/rocMLIR"
		)
	fi

	if use test ; then
		local gpu_target
		for gpu_target in ${AMDGPU_TARGETS} ; do
			mycmakeargs+=(
				$(filter_test_gpus)
			)
		done
	fi

	addpredict /dev/kfd
	addpredict /dev/dri/
	append-cxxflags "--rocm-path=$(hipconfig -R)"
	append-cxxflags "--hip-device-lib-path=${EPREFIX}/usr/$(get_libdir)/amdgcn/bitcode"

	# Fix for both
	# lld: error: undefined symbol: __stack_chk_fail ; if fail try append-flags "-fno-stack-protector"
	# lld: error: undefined hidden symbol: free
	replace-flags '-O0' '-O1'

	export CC="${CHOST}-clang-${LLVM_MAX_SLOT}"
	export CXX="${CHOST}-clang++${LLVM_MAX_SLOT}"
	cmake_src_configure
}

src_test() {
	check_amdgpu
	export LD_LIBRARY_PATH="${BUILD_DIR}/lib"

	MAKEOPTS="-j1" \
	cmake_src_test
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
