# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

#broken

LLVM_MAX_SLOT=16
PYTHON_COMPAT=( python3_{10..11} )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"

inherit cmake flag-o-matic llvm prefix python-any-r1 rocm

SRC_URI="
https://github.com/ROCm-Developer-Tools/roctracer/archive/rocm-${PV}.tar.gz
	-> rocm-tracer-${PV}.tar.gz
"

DESCRIPTION="Callback/Activity Library for Performance tracing AMD GPU's"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/roctracer.git"
LICENSE="MIT"
SLOT="${ROCM_SLOT}/${PV}"
KEYWORDS="~amd64"
IUSE=" system-llvm test r1"
CDEPEND="
	sys-devel/clang:${LLVM_MAX_SLOT}
	sys-devel/gcc:12
	sys-devel/llvm:${LLVM_MAX_SLOT}
"
RDEPEND="
	!dev-util/roctracer:0
	${CDEPEND}
	~dev-libs/rocm-comgr-${PV}:${ROCM_SLOT}
	~dev-libs/rocr-runtime-${PV}:${ROCM_SLOT}
	~dev-util/hip-${PV}:${ROCM_SLOT}
	dev-util/rocm-compiler[system-llvm=]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	$(python_gen_any_dep '
		dev-python/CppHeaderParser[${PYTHON_USEDEP}]
		dev-python/ply[${PYTHON_USEDEP}]
	')
	${CDEPEND}
	>=dev-util/cmake-3.18.0
	test? (
		dev-util/rocm-compiler[system-llvm=]
	)
"
RESTRICT="
	!test? (
		test
	)
"
S="${WORKDIR}/roctracer-rocm-${PV}"
PATCHES=(
	"${FILESDIR}/${PN}-5.3.3-do-not-install-test-files.patch"
	"${FILESDIR}/${PN}-5.3.3-Werror.patch"
	"${FILESDIR}/${PN}-5.5.1-path-changes.patch"
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
	hprefixify script/*.py
	rocm_src_prepare
}

src_configure() {
	export CC="${HIP_CC:-gcc-12}"
	export CXX="${HIP_CXX:-g++-12}"

	hipconfig --help >/dev/null || die
	export HIP_PLATFORM="amd"
	local mycmakeargs=(
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DCMAKE_MODULE_PATH="${ESYSROOT}${EROCM_PATH}/$(get_libdir)/cmake/hip"
		-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DHIP_COMPILER="clang"
		-DHIP_PLATFORM="amd"
		-DHIP_RUNTIME="rocclr"
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
	ROCM_RPATH_LIST=(
		"${EPREFIX}/${EROCM_PATH}/$(get_libdir)/libhip_stats.so"
		"${EPREFIX}/${EROCM_PATH}/$(get_libdir)/libroctracer_tool.so"
	)
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
