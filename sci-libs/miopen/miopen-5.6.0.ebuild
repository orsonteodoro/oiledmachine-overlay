# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="${PV%.*}" # For /opt/rocm-5.6

AMDGPU_TARGETS_OVERRIDE=(
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
	gfx1100
	gfx1101
	gfx1102
)
ROCM_VERSION="${PV}"
LLVM_MAX_SLOT=16
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
IUSE="kernels debug test r1"
RDEPEND="
	>=dev-db/sqlite-3.17
	>=dev-libs/boost-1.72
	>=sci-libs/composable_kernel-1.0.0[rocm_5_6]
	app-arch/bzip2
	~dev-libs/rocm-comgr-${PV}:${SLOT}
	~dev-util/hip-${PV}:${SLOT}
	~sci-libs/rocBLAS-${PV}:${SLOT}[${ROCM_USEDEP}]
	kernels? (
		~sci-libs/miopenkernels-${PV}
	)
"
DEPEND="
	${RDEPEND}
	dev-cpp/eigen
	dev-cpp/frugally-deep
"
BDEPEND="
	>=dev-cpp/nlohmann_json-3.10.4
	dev-libs/half:0/1
	virtual/pkgconfig
	~dev-util/rocm-cmake-${PV}:${SLOT}
"
RESTRICT="
	!test? (
		test
	)
"
S="${WORKDIR}/MIOpen-rocm-${PV}"
PATCHES=(
	"${FILESDIR}/${PN}-4.2.0-disable-no-inline-boost.patch"
	"${FILESDIR}/${PN}-5.6.0-strip-xnack-in-flags.patch"
	"${FILESDIR}/${PN}-4.3.0-fix-interface-include-in-HIP_COMPILER_FLAGS.patch"
	"${FILESDIR}/${PN}-5.3.3-enable-test.patch"
#	"${FILESDIR}/${PN}-5.1.3-gfx1031.patch" # Already added upstream but some parts missing
	"${FILESDIR}/${PN}-5.1.3-no-strip.patch"
	"${FILESDIR}/${PN}-5.1.3-include-array.patch"
#	"${FILESDIR}/${PN}-5.1.3-avoid-metadata-error-for-vanilla-clang.patch" # Fixed in pr #1830
)

pkg_setup() {
	llvm_pkg_setup # For LLVM_SLOT init.  Must be explicitly called or it is blank.
}

src_prepare() {
	cmake_src_prepare

	export HIP_CLANG_PATH=$(get_llvm_prefix ${LLVM_SLOT})"/bin"
	einfo "HIP_CLANG_PATH=${HIP_CLANG_PATH}"

	# Disallow newer clangs versions when producing .o files.
	einfo "LLVM_SLOT=${LLVM_SLOT}"
	einfo "PATH=${PATH} (before)"
	export PATH=$(echo "${PATH}" \
		| tr ":" "\n" \
		| sed -E -e "/llvm\/[0-9]+/d" \
		| tr "\n" ":" \
		| sed -e "s|/opt/bin|/opt/bin:/usr/lib/llvm/${LLVM_SLOT}/bin|g")
	einfo "PATH=${PATH} (after)"

	hipconfig --help >/dev/null || die
	sed \
		-e "s:/opt/rocm/llvm:$(get_llvm_prefix ${LLVM_MAX_SLOT}) NO_DEFAULT_PATH:" \
		-e "s:/opt/rocm/hip:$(hipconfig -p) NO_DEFAULT_PATH:" \
		-e '/set( MIOPEN_INSTALL_DIR/s:miopen:${CMAKE_INSTALL_PREFIX}:' \
		-e '/MIOPEN_TIDY_ERRORS ALL/d' \
		-i CMakeLists.txt \
		|| die

	sed \
		-e "/rocm_install_symlink_subdir(\${MIOPEN_INSTALL_DIR})/d" \
		-i src/CMakeLists.txt \
		|| die
	sed \
		-e "/add_test/s:--build \${CMAKE_CURRENT_BINARY_DIR}:--build ${BUILD_DIR}:" \
		-i test/CMakeLists.txt \
		|| die

	sed \
		-e "s:\${AMD_DEVICE_LIBS_PREFIX}/lib:${EPREFIX}/usr/lib/amdgcn/bitcode:" \
		-i cmake/hip-config.cmake \
		|| die

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
			cp -av "${ma}"*".kdb.bz2" "${S}/src/kernels" || die
		done
	fi
}

filter_test_gpus() {
	if use "${gpu_target}" && [[ "${gputarget}" =~ "gfx103" ]] ; then
		echo "-DMIOPEN_TEST_GFX103x=ON"
	elif use "${gpu_target}" && [[ "${gputarget}" =~ "gfx110" ]] ; then
		echo "-DMIOPEN_TEST_GFX110X=ON"
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
		-DMIOPEN_USE_MLIR=OFF
		-DMIOPEN_TEST_ALL=$(usex test ON OFF)
	)

	if use test; then
		for gpu_target in ${AMDGPU_TARGETS} ; do
			mycmakeargs+=(
				$(filter_test_gpus)
			)
		done
	fi

	addpredict /dev/kfd
	addpredict /dev/dri/
	append-cxxflags "--rocm-path=$(hipconfig -R)"
	append-cxxflags "--hip-device-lib-path=${EPREFIX}/usr/lib/amdgcn/bitcode"

	# Fix for both
	# lld: error: undefined symbol: __stack_chk_fail ; if fail try append-flags "-fno-stack-protector"
	# lld: error: undefined hidden symbol: free
	replace-flags '-O0' '-O1'

	CXX="$(get_llvm_prefix ${LLVM_MAX_SLOT})/bin/clang++" \
	cmake_src_configure
}

src_test() {
	check_amdgpu
	export LD_LIBRARY_PATH="${BUILD_DIR}/lib"

	MAKEOPTS="-j1" \
	cmake_src_test
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
