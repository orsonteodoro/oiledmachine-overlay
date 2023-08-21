# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=14
PYTHON_COMPAT=( python3_{9..10} )

inherit cmake llvm prefix python-any-r1 rocm

HSA_CLASS_COMMIT="f8b387043b9f510afdf2e72e38a011900360d6ab"
SRC_URI="
https://github.com/ROCm-Developer-Tools/roctracer/archive/rocm-${PV}.tar.gz
	-> rocm-tracer-${PV}.tar.gz
https://github.com/ROCm-Developer-Tools/rocprofiler/archive/rocm-${PV}.tar.gz
	-> rocprofiler-${PV}.tar.gz
https://github.com/ROCmSoftwarePlatform/hsa-class/archive/${HSA_CLASS_COMMIT}.tar.gz
	-> hsa-class-${HSA_CLASS_COMMIT:0:7}.tar.gz
"

DESCRIPTION="Callback/Activity Library for Performance tracing AMD GPU's"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/roctracer.git"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE=" +aqlprofile test"
RDEPEND="
	>=sys-devel/gcc-12
	~dev-libs/rocr-runtime-${PV}:${SLOT}
	~dev-util/hip-${PV}:${SLOT}
	aqlprofile? (
		~dev-libs/hsa-amd-aqlprofile-${PV}:${SLOT}
		~dev-libs/rocr-runtime-${PV}:${SLOT}
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	$(python_gen_any_dep '
		dev-python/CppHeaderParser[${PYTHON_USEDEP}]
		dev-python/ply[${PYTHON_USEDEP}]
	')
	>=dev-util/cmake-2.8.12
	>=sys-devel/gcc-12
	sys-devel/gcc-config
"
RESTRICT="test"
S="${WORKDIR}/roctracer-rocm-${PV}"
S_PROFILER="${WORKDIR}/rocprofiler"
S_HSA_CLASS="${WORKDIR}/hsa-class-${HSA_CLASS_COMMIT}"
PATCHES=(
	# https://github.com/ROCm-Developer-Tools/roctracer/pull/63
	"${FILESDIR}/${PN}-4.3.0-glibc-2.34.patch"
	"${FILESDIR}/${PN}-5.0.2-Werror.patch"
	"${FILESDIR}/${PN}-5.0.2-headers.patch"
	"${FILESDIR}/${PN}-5.0.2-strip-license.patch"
)

python_check_deps() {
	python_has_version \
		"dev-python/CppHeaderParser[${PYTHON_USEDEP}]" \
		"dev-python/ply[${PYTHON_USEDEP}]"
}

pkg_setup() {
	llvm_pkg_setup # For LLVM_SLOT init.  Must be explicitly called or it is blank.
	python-any-r1_pkg_setup
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	if ! use aqlprofile ; then
		eapply "${FILESDIR}/${PN}-5.1.3-no-aqlprofile.patch"
	fi

	mv \
		"${WORKDIR}/rocprofiler-rocm-${PV}" \
		"${WORKDIR}/rocprofiler" \
		|| die
	mv \
		"${WORKDIR}/hsa-class-"*"/test/util" \
		"${S}/inc/" \
		|| die
	rm "${S}/inc/util/hsa"* || die
	cp -a \
		"${S}/src/util/hsa"* \
		"${S}/inc/util/" \
		|| die

	# Change the destination for headers to include/roctracer.
	sed \
		-e "/LIBRARY DESTINATION/s,lib,$(get_libdir)," \
		-e "/DESTINATION/s,\${DEST_NAME}/include,include/roctracer," \
		-e "/install ( FILES \${PROJECT_BINARY_DIR}\/so/d" \
		-i \
		"CMakeLists.txt" \
		|| die

	# Do not download additional sources via git.
	sed \
		-e "/execute_process ( COMMAND sh -xc \"if/d" \
		-e "/add_subdirectory ( \${HSA_TEST_DIR} \${PROJECT_BINARY_DIR}/d" \
		-e "/DESTINATION/s,\${DEST_NAME}/tool,$(get_libdir),g" \
		-i \
		"test/CMakeLists.txt" \
		|| die
	sed \
		-i \
		-e "s|llvm/lib/cmake/clang|lib/llvm/@LLVM_SLOT@/$(get_libdir)/cmake/clang|g" \
		"test/CMakeLists.txt" \
		|| die
	sed \
		-i \
		-e "s|/opt/rocm/lib/|/usr/$(get_libdir)/|g" \
		"README.md" \
		|| die
	sed \
		-i \
		-e "s|\$ROCM_PATH/lib:\$ROCM_PATH/lib64|\$ROCM_PATH/$(get_libdir)|g" \
		"build_static.sh" \
		|| die
	sed \
		-i \
		-e "s|{DEST_NAME}/lib|{DEST_NAME}/$(get_libdir)|g" \
		"${S_PROFILER}/CMakeLists.txt" \
		"CMakeLists.txt" \
		|| die

	local clang_slot=$(basename $(realpath "${ESYSROOT}/usr/lib/clang/${LLVM_MAX_SLOT}"*))

	sed \
		-i \
		-r \
		-e "s;PKG_DIR/lib($|\"|/);PKG_DIR/$(get_libdir)\1;g" \
		-e "s;ROOT_DIR/lib($|\"|/);ROOT_DIR/$(get_libdir)\1;g" \
		"${S_PROFILER}/bin/rpl_run.sh" \
		|| die

	sed \
		-i \
		-e "s|/lib/|/$(get_libdir)/|g" \
		"README.md" \
		|| die

	sed \
		-i \
		-e "s|\$ROCM_PATH/lib:\$ROCM_PATH/lib64|$ROCM_PATH/$(get_libdir)|g" \
		"build.sh" \
		|| die

	sed \
		-i \
		-e "s|LLVM_DIR/lib/clang|LLVM_DIR/lib/clang/${clang_slot}|g" \
		-e "s|ROCM_DIR/lib|ROCM_DIR/$(get_libdir)|g" \
		-e "s|ROCM_DIR/llvm|ROCM_DIR/lib/llvm/${LLVM_MAX_SLOT}|g" \
		-e "s|ROCM_DIR/amdgcn/bitcode|ROCM_DIR/$(get_libdir)/amdgcn/bitcode|g" \
		"${S_HSA_CLASS}/script/build_kernel.sh" \
		"${S_PROFILER}/bin/build_kernel.sh" \
		"test/hsa/script/build_kernel.sh" \
		|| die

	sed \
		-i \
		-e "s|\$PWD:\$PWD/../../lib:/opt/rocm/lib|\$PWD:\$PWD/../../$(get_libdir):/usr/$(get_libdir)|g" \
		"${S_PROFILER}/test/run.sh" \
		|| die

	hprefixify script/*.py
	rocm_src_prepare
}

src_configure() {
	local gcc_slot=12
	local gcc_current_profile=$(gcc-config -c)
	local gcc_current_profile_slot=${gcc_current_profile##*-}
	if ver_test ${gcc_current_profile_slot} -lt ${gcc_slot} ; then
eerror
eerror "GCC ${gcc_slot}+ required.  Do"
eerror
eerror "  eselect set ${CHOST}-${gcc_slot}"
eerror "  source /etc/profile"
eerror
		die
	fi
	if use aqlprofile ; then
		[[ -e "${ESYSROOT}/opt/rocm-${PV}/lib/libhsa-amd-aqlprofile64.so" ]] || die "Missing"
	fi
	hipconfig --help >/dev/null || die
	export HIP_PLATFORM="amd"
	export HIP_PATH="$(hipconfig -p)"
	local mycmakeargs=(
		-DCMAKE_PREFIX_PATH="${EPREFIX}/usr/include/hsa"
		-DHIP_COMPILER="clang"
		-DHIP_PLATFORM="amd"
		-DHIP_RUNTIME="rocclr"
	)
	CXX="${HIP_CXX:-hipcc}" \
	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
