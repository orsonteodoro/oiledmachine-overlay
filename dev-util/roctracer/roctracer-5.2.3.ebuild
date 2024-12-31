# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=14
PYTHON_COMPAT=( "python3_"{10..11} )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"

inherit cmake flag-o-matic prefix python-any-r1 rocm

KEYWORDS="~amd64"
S="${WORKDIR}/roctracer-rocm-${PV}"
S_PROFILER="${WORKDIR}/rocprofiler"
SRC_URI="
https://github.com/ROCm-Developer-Tools/roctracer/archive/rocm-${PV}.tar.gz
	-> rocm-tracer-${PV}.tar.gz
https://github.com/ROCm-Developer-Tools/rocprofiler/archive/rocm-${PV}.tar.gz
	-> rocprofiler-${PV}.tar.gz
https://github.com/ROCm-Developer-Tools/roctracer/commit/c95d5dd96fa50a567b7b203029652bb036ecd3f4.patch
	-> roctracer-c95d5dd.patch
"
# c95d5dd - Fix a build error when compiling with clang

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
	!test? (
		test
	)
"
SLOT="${ROCM_SLOT}/${PV}"
IUSE=" test ebuild_revision_10"
CDEPEND="
	${ROCM_CLANG_DEPEND}
"
RDEPEND="
	${CDEPEND}
	!dev-util/roctracer:0
	~dev-libs/rocr-runtime-${PV}:${ROCM_SLOT}
	~dev-util/hip-${PV}:${ROCM_SLOT}
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
	>=dev-build/cmake-3.18.0
"
PATCHES=(
#	"${FILESDIR}/${PN}-5.3.3-do-not-install-test-files.patch"
	"${FILESDIR}/${PN}-5.2.3-Werror.patch"
#	"${DISTDIR}/${PN}-c95d5dd.patch"
	"${FILESDIR}/${PN}-4.5.2-python-path.patch"
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
		eapply "${FILESDIR}/roctracer-5.2.3-hardcoded-paths.patch"
	popd >/dev/null 2>&1 || die

	ln -s \
		"${WORKDIR}/rocprofiler-rocm-${PV}" \
		"${WORKDIR}/rocprofiler" \
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
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DCMAKE_MODULE_PATH="${ESYSROOT}${EROCM_PATH}/$(rocm_get_libdir)/cmake/hip"
		-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DHIP_COMPILER="clang"
		-DHIP_PLATFORM="amd"
		-DHIP_RUNTIME="rocclr"
		-DPython3_EXECUTABLE="/usr/bin/${EPYTHON}"
	)
	rocm_src_configure
}

src_test() {
	check_amdgpu
	cd "${BUILD_DIR}" || die
	# If LD_LIBRARY_PATH not set, dlopen cannot find the correct lib.
	LD_LIBRARY_PATH="${EPREFIX}/usr/$(get_libdir)" \
	bash run.sh || die
}

src_install() {
	cmake_src_install
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
