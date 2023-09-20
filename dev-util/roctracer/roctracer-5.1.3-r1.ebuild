# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=14
PYTHON_COMPAT=( python3_{9..10} )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"

inherit cmake flag-o-matic llvm prefix python-any-r1 rocm

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
SLOT="${ROCM_SLOT}/${PV}"
KEYWORDS="~amd64"
IUSE=" +aqlprofile system-llvm test"
RDEPEND="
	!dev-util/roctracer:0
	~dev-libs/rocr-runtime-${PV}:${ROCM_SLOT}
	~dev-util/hip-${PV}:${ROCM_SLOT}
	aqlprofile? (
		~dev-libs/hsa-amd-aqlprofile-${PV}:${ROCM_SLOT}
		~dev-libs/rocr-runtime-${PV}:${ROCM_SLOT}
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
	test? (
		dev-util/rocm-compiler[system-llvm=]
	)
"
RESTRICT="test"
S="${WORKDIR}/roctracer-rocm-${PV}"
S_PROFILER="${WORKDIR}/rocprofiler"
S_HSA_CLASS="${WORKDIR}/hsa-class-${HSA_CLASS_COMMIT}"
PATCHES=(
	# https://github.com/ROCm-Developer-Tools/roctracer/pull/63
	"${FILESDIR}/${PN}-4.3.0-glibc-2.34.patch"
	"${FILESDIR}/${PN}-5.0.2-Werror.patch"
	"${FILESDIR}/${PN}-5.0.2-strip-license.patch"

	"${FILESDIR}/${PN}-5.1.3-path-changes.patch"
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

	ln -s \
		"${WORKDIR}/rocprofiler-rocm-${PV}" \
		"${WORKDIR}/rocprofiler" \
		|| die

	pushd "${S_PROFILER}" || die
		eapply "${FILESDIR}/rocprofiler-5.1.3-path-changes.patch"
	popd
	pushd "${S_HSA_CLASS}" || die
		eapply "${FILESDIR}/hsa-class-5.1.3-path-changes.patch"
	popd

	if ! use aqlprofile ; then
		eapply "${FILESDIR}/${PN}-5.1.3-no-aqlprofile.patch"
	fi

	mv \
		"${WORKDIR}/hsa-class-${HSA_CLASS_COMMIT}/test/util" \
		"${S}/inc/" \
		|| die
	rm "${S}/inc/util/hsa"* || die
	cp -a \
		"${S}/src/util/hsa"* \
		"${S}/inc/util/" \
		|| die

	# Do not download additional sources via git.
	sed \
		-e "/execute_process ( COMMAND sh -xc \"if/d" \
		-e "/add_subdirectory ( \${HSA_TEST_DIR} \${PROJECT_BINARY_DIR}/d" \
		-i \
		"test/CMakeLists.txt" \
		|| die

	hprefixify script/*.py
	rocm_src_prepare
}

src_configure() {
	if use aqlprofile ; then
		[[ -e "${ESYSROOT}/opt/rocm-${PV}/lib/libhsa-amd-aqlprofile64.so" ]] || die "Missing"
	fi

	export CC="${HIP_CC:-hipcc}"
	export CXX="${HIP_CXX:-hipcc}"

	local rocm_path="/usr/$(get_libdir)/rocm/${ROCM_SLOT}"
	if [[ "${CXX}" =~ "hipcc" ]] ; then
		append-flags --rocm-path="${ESYSROOT}${rocm_path}"
	fi

	hipconfig --help >/dev/null || die
	export HIP_PLATFORM="amd"
	export HIP_PATH="$(hipconfig -p)"
	local mycmakeargs=(
		-DCMAKE_PREFIX_PATH="${ESYSROOT}${rocm_path}/include/hsa"
		-DHIP_COMPILER="clang"
		-DHIP_PLATFORM="amd"
		-DHIP_RUNTIME="rocclr"
	)
	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
