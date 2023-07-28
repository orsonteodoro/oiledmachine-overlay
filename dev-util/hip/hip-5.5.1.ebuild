# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_DEPEND="media-gfx/graphviz"
LLVM_MAX_SLOT=16 # See https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-5.5.1/llvm/CMakeLists.txt
PYTHON_COMPAT=( python3_{9..11} )
inherit cmake docs llvm prefix python-any-r1

DESCRIPTION="C++ Heterogeneous-Compute Interface for Portability"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/hipamd"
SRC_URI="
https://github.com/ROCm-Developer-Tools/hipamd/archive/rocm-${PV}.tar.gz
	-> rocm-hipamd-${PV}.tar.gz
https://github.com/ROCm-Developer-Tools/HIP/archive/rocm-${PV}.tar.gz
	-> rocm-hip-${PV}.tar.gz
https://github.com/ROCm-Developer-Tools/ROCclr/archive/rocm-${PV}.tar.gz
	-> rocclr-${PV}.tar.gz
https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/archive/rocm-${PV}.tar.gz
	-> rocm-opencl-runtime-${PV}.tar.gz
"
KEYWORDS="~amd64"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
IUSE="debug"
DEPEND="
	sys-devel/clang:${LLVM_MAX_SLOT}
	virtual/opengl
	~dev-libs/rocm-comgr-${PV}:${SLOT}
	~dev-util/rocminfo-${PV}:${SLOT}
"
RDEPEND="
	${DEPEND}
	=sys-devel/clang-runtime-${LLVM_MAX_SLOT}*:=
	>=dev-perl/URI-Encode-1.1.1
	~dev-libs/roct-thunk-interface-${PV}:${SLOT}
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-util/cmake-3.16.8
"
PATCHES=(
	"${FILESDIR}/${PN}-5.0.1-DisableTest.patch"
	"${FILESDIR}/${PN}-5.0.1-hip_vector_types.patch"
	"${FILESDIR}/${PN}-5.0.2-set-build-id.patch"
	"${FILESDIR}/${PN}-5.3.3-remove-cmake-doxygen-commands.patch"
	"${FILESDIR}/${PN}-5.5.1-disable-Werror.patch"
#	"${FILESDIR}/0001-SWDEV-352878-LLVM-pkg-search-directly-using-find_dep.patch"
)
S="${WORKDIR}/hipamd-rocm-${PV}"
HIP_S="${WORKDIR}/HIP-rocm-${PV}"
OCL_S="${WORKDIR}/ROCm-OpenCL-Runtime-rocm-${PV}"
CLR_S="${WORKDIR}/ROCclr-rocm-${PV}"
RTC_S="${WORKDIR}/roctracer-rocm-${PV}"
DOCS_DIR="${HIP_S}/docs/doxygen-input"
DOCS_CONFIG_NAME="doxy.cfg"

pkg_setup() {
	# Ignore QA FLAGS check for library compiled from assembly sources
	QA_FLAGS_IGNORED="/usr/$(get_libdir)/libhiprtc-builtins.so.$(ver_cut 1-2)"
	llvm_pkg_setup
	python-any-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	eapply_user

	# Use Gentoo slot number, otherwise git hash is attempted in vain.
	sed \
		-e "/set (HIP_LIB_VERSION_STRING/cset (HIP_LIB_VERSION_STRING ${SLOT#*/})" \
		-i \
		CMakeLists.txt \
		|| die

	# correctly find HIP_CLANG_INCLUDE_PATH using cmake
	local LLVM_PREFIX="$(get_llvm_prefix "${LLVM_MAX_SLOT}")"
	sed \
		-e "/set(HIP_CLANG_ROOT/s:\"\${ROCM_PATH}/llvm\":${LLVM_PREFIX}:" \
		-i \
		hip-config.cmake.in \
		|| die

	# correct libs and cmake install dir
	sed \
		-e "/\${HIP_COMMON_DIR}/s:cmake DESTINATION .):cmake/ DESTINATION share/cmake/Modules):" \
		-i \
		CMakeLists.txt \
		|| die

	sed \
		-e "/\.hip/d" \
		-e "/CPACK_RESOURCE_FILE_LICENSE/d" \
		-i \
		packaging/CMakeLists.txt \
		|| die

	pushd "${HIP_S}" || die
	eapply "${FILESDIR}/${PN}-5.1.3-rocm-path.patch"
	eapply "${FILESDIR}/${PN}-5.1.3-fno-stack-protector.patch"
#	eapply "${FILESDIR}/${PN}-5.4.3-correct-ldflag.patch"
#	eapply "${FILESDIR}/${PN}-5.4.3-clang-version.patch"
#	eapply "${FILESDIR}/${PN}-5.4.3-clang-include.patch"
#	eapply "${FILESDIR}/0003-SWDEV-352878-Removed-relative-path-based-CLANG-inclu.patch"
	eapply "${FILESDIR}/${PN}-5.4.3-fix-HIP_CLANG_PATH-detection.patch"

	# Setting HSA_PATH to "/usr" results in setting "-isystem /usr/include"
	# which makes "stdlib.h" not found when using "#include_next" in header files;
	sed \
		-e "/FLAGS .= \" -isystem \$HSA_PATH/d" \
		-e "/HIP.*FLAGS.*isystem.*HIP_INCLUDE_PATH/d" \
		-e "s:\$ENV{'DEVICE_LIB_PATH'}:'${EPREFIX}/usr/lib/amdgcn/bitcode':" \
		-e "s:\$ENV{'HIP_LIB_PATH'}:'${EPREFIX}/usr/$(get_libdir)':" \
		-e "/rpath/s,--rpath=[^ ]*,," \
		-i \
		bin/hipcc.pl \
		|| die

	# Changed --hip-device-lib-path to "/usr/lib/amdgcn/bitcode".
	# It must align with "dev-libs/rocm-device-libs".
	sed \
		-e "s:\${AMD_DEVICE_LIBS_PREFIX}/lib:${EPREFIX}/usr/lib/amdgcn/bitcode:" \
		-i \
		"${S}/hip-config.cmake.in" \
		|| die

	einfo "prefixing hipcc and its utils..."
	hprefixify $(grep \
		-rl \
		--exclude-dir="build/" \
		--exclude="hip-config.cmake.in" \
		"/usr" \
		"${S}")
	hprefixify $(grep \
		-rl \
		--exclude-dir="build/" \
		--exclude="hipcc.pl" \
		"/usr" \
		"${HIP_S}")

	cp \
		$(prefixify_ro "${FILESDIR}/hipvars-5.3.3.pm") \
		"bin/hipvars.pm" \
		|| die "failed to replace hipvars.pm"
	sed \
		-e "s,@HIP_BASE_VERSION_MAJOR@,$(ver_cut 1)," \
		-e "s,@HIP_BASE_VERSION_MINOR@,$(ver_cut 2)," \
		-e "s,@HIP_VERSION_PATCH@,$(ver_cut 3)," \
		-e "s,@CLANG_PATH@,${LLVM_PREFIX}/bin," \
		-i \
		bin/hipvars.pm \
		|| die
	popd || die

	cd "${CLR_S}" || die
	eapply "${FILESDIR}/rocclr-5.3.3-gcc13.patch"
}

src_configure() {
	use debug && CMAKE_BUILD_TYPE="Debug"

	# TODO: Currently a GENTOO configuration is build,
	# this is also used in the cmake configuration files
	# which will be installed to find HIP;
	# Other ROCm packages expect a "RELEASE" configuration,
	# see "hipBLAS"
	local mycmakeargs=(
		-DAMD_OPENCL_PATH="${OCL_S}"
		-DBUILD_HIPIFY_CLANG=OFF
		-DCMAKE_BUILD_TYPE=${buildtype}
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCMAKE_PREFIX_PATH="$(get_llvm_prefix ${LLVM_MAX_SLOT})"
		-DCMAKE_SKIP_RPATH=ON
		-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DHIP_COMMON_DIR="${HIP_S}"
		-DHIP_COMPILER=clang
		-DHIP_PLATFORM=amd
		-DROCCLR_PATH="${CLR_S}"
		-DROCM_PATH="${EPREFIX}/usr"
		-DUSE_PROF_API=0
	)

	cmake_src_configure
}

src_compile() {
	HIP_PATH="${HIP_S}" docs_compile
	cmake_src_compile
}

src_install() {
	cmake_src_install

	rm "${ED}/usr/include/hip/hcc_detail" || die

	# Don't install .hipInfo and .hipVersion to bin/lib
	rm "${ED}/usr/bin/.hipVersion" || die
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
