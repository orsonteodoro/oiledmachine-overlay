# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

HSA_CLASS_COMMIT="f8b387043b9f510afdf2e72e38a011900360d6ab" # From https://github.com/ROCm/roctracer/blob/rocm-4.5.2/test/CMakeLists.txt#L47
LLVM_SLOT=13
PYTHON_COMPAT=( "python3_"{9..10} )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"

inherit cmake flag-o-matic prefix python-any-r1 rocm

KEYWORDS="~amd64"
S="${WORKDIR}/roctracer-rocm-${PV}"
S_HSA_CLASS="${WORKDIR}/hsa-class-${HSA_CLASS_COMMIT}"
S_PROFILER="${WORKDIR}/rocprofiler"
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
LICENSE="
	(
		all-rights-reserved
		MIT
	)
"
# The distro's MIT license template does not contain all rights reserved.
RESTRICT="
	test
"
SLOT="${ROCM_SLOT}/${PV}"
IUSE=" test ebuild_revision_10"
#	sys-devel/gcc:11
CDEPEND="
	${ROCM_CLANG_DEPEND}
"
RDEPEND="
	${CDEPEND}
	!dev-util/roctracer:0
	~dev-libs/rocr-runtime-${PV}:${ROCM_SLOT}
	~dev-util/hip-${PV}:${ROCM_SLOT}
	~dev-libs/hsa-amd-aqlprofile-${PV}:${ROCM_SLOT}
	~dev-libs/rocr-runtime-${PV}:${ROCM_SLOT}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${CDEPEND}
	$(python_gen_any_dep '
		dev-python/CppHeaderParser[${PYTHON_USEDEP}]
		dev-python/ply[${PYTHON_USEDEP}]
	')
	>=dev-build/cmake-2.8.12
"
PATCHES=(
	# https://github.com/ROCm-Developer-Tools/roctracer/pull/63
	"${FILESDIR}/${PN}-4.3.0-glibc-2.34.patch"
	"${FILESDIR}/${PN}-5.0.2-Werror.patch"
	"${FILESDIR}/${PN}-4.5.2-python-path.patch"
	"${FILESDIR}/${PN}-4.5.2-prefix-HsaRsrcFactory-with-util-namespace.patch"
)

python_check_deps() {
	python_has_version \
		"dev-python/CppHeaderParser[${PYTHON_USEDEP}]" \
		"dev-python/ply[${PYTHON_USEDEP}]"
}

pkg_setup() {
	python-any-r1_pkg_setup
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	pushd "${WORKDIR}" >/dev/null 2>&1 || die
		eapply "${FILESDIR}/roctracer-4.5.2-hardcoded-paths.patch"
	popd >/dev/null 2>&1 || die

	ln -s \
		"${WORKDIR}/rocprofiler-rocm-${PV}" \
		"${WORKDIR}/rocprofiler" \
		|| die

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

	hprefixify "script/"*".py"
	rocm_src_prepare
}

src_configure() {
	addpredict "/dev/kfd"

	rocm_set_default_clang

	hipconfig --help >/dev/null || die
	export HIP_PLATFORM="amd"
	export HIP_PATH="${ESYSROOT}${EROCM_PATH}"
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DCMAKE_PREFIX_PATH="${ESYSROOT}${EROCM_PATH}/include/hsa"
		-DHIP_COMPILER="clang"
		-DHIP_PLATFORM="amd"
		-DHIP_RUNTIME="rocclr"
		-DPython3_EXECUTABLE="/usr/bin/${EPYTHON}"
	)
	rocm_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
