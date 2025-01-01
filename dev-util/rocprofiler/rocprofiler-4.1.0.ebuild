# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
# From Readme.txt
	gfx803
	gfx900
# From:  grep -o -E -r -e "gfx[0-9a]+" ./ | cut -f 2 -d ":" | sort | uniq | grep -E -e "gfx[0-9a]{3,4}"
	gfx906
	gfx908
	gfx90a
)
AMDGPU_UNTESTED_TARGETS=(
)
CMAKE_BUILD_TYPE="Debug"
LLVM_SLOT=12
PYTHON_COMPAT=( "python3_"{9..10} )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake flag-o-matic python-any-r1 rocm

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-rocm-${PV}"
SRC_URI="
https://github.com/ROCm-Developer-Tools/${PN}/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="The ROC profiler library for profiling with perf-counters and derived metrics"
HOMEPAGE="https://github.com/ROCm/rocprofiler"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
	BSD-2
	MIT
"
# BSD-2 - test/util/hsa_rsrc_factory.h
SLOT="${ROCM_SLOT}/${PV}"
IUSE=" test ebuild_revision_16"
REQUIRED_USE="
	${ROCM_REQUIRED_USE}
"
RDEPEND="
	!dev-util/rocprofiler:0
	~dev-libs/hsa-amd-aqlprofile-${PV}:${ROCM_SLOT}
	~dev-libs/rocr-runtime-${PV}:${ROCM_SLOT}
	~dev-util/roctracer-${PV}:${ROCM_SLOT}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${ROCM_CLANG_DEPEND}
	$(python_gen_any_dep '
		dev-python/CppHeaderParser[${PYTHON_USEDEP}]
	')
	>=dev-build/cmake-2.8.12
	~sys-devel/llvm-roc-symlinks-${PV}:${ROCM_SLOT}
	test? (
		sys-devel/gcc[sanitize]
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-4.3.0-nostrip.patch"
	"${FILESDIR}/${PN}-5.1.3-remove-Werror.patch"
	"${FILESDIR}/${PN}-4.5.2-hardcoded-paths.patch"
	"${FILESDIR}/${PN}-4.5.2-includes-test_kernel-header.patch"
	"${FILESDIR}/${PN}-4.1.0-append-cxxflags.patch"
)

python_check_deps() {
	python_has_version "dev-python/CppHeaderParser[${PYTHON_USEDEP}]"
}

warn_untested_gpu() {
	local gpu
	for gpu in ${AMDGPU_UNTESTED_TARGETS[@]} ; do
		if use "amdgpu_targets_${gpu}" ; then
ewarn "${gpu} is not CI tested upstream."
		fi
	done
}

pkg_setup() {
	python-any-r1_pkg_setup
	rocm_pkg_setup
	warn_untested_gpu
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	# Fixes for libhsa-runtime64.so.1.12.0: undefined reference to `hsaKmtGetAMDGPUDeviceHandle'
	rocm_set_default_clang

	[[ -e "${ESYSROOT}/opt/rocm-${PV}/$(rocm_get_libdir)/libhsa-amd-aqlprofile64.so" ]] \
		|| die "Missing" # For 071379b
	append-ldflags -Wl,-rpath="${EPREFIX}/opt/rocm-${PV}/$(rocm_get_libdir)"

	local gpu_targets=$(get_amdgpu_flags \
		| tr ";" " ")
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DCMAKE_MODULE_PATH="${ESYSROOT}${EROCM_PATH}/$(rocm_get_libdir)/cmake/hip"
		-DCMAKE_PREFIX_PATH="${EPREFIX}${EROCM_PATH}/include/hsa"
		-DGPU_TARGETS="${gpu_targets}"
		-DPROF_API_HEADER_PATH="${ESYSROOT}${EROCM_PATH}/include/roctracer/ext"
		-DUSE_PROF_API=1
	)
	rocm_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
