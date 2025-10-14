# Copyright 2023-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
# From README.md
	gfx803
# From:  grep -o -E -r -e "gfx[0-9a]+" ./ | cut -f 2 -d ":" | sort | uniq | grep -E -e "gfx[0-9a]{3,4}"
	gfx900
	gfx906
	gfx908
	gfx90a
	gfx940
	gfx941
	gfx942
	gfx1010
	gfx1011
	gfx1012
	gfx1030
	gfx1031
	gfx1032
	gfx1100
	gfx1101
	gfx1102
)
AMDGPU_UNTESTED_TARGETS=(
	gfx803
	gfx940
	gfx941
	gfx942
	gfx1010
	gfx1011
	gfx1012
	gfx1031
	gfx1032
	gfx1101
	gfx1102
)
CMAKE_BUILD_TYPE="Debug"
CMAKE_MAKEFILE_GENERATOR="emake"
LLVM_SLOT=19
PYTHON_COMPAT=( "python3_12" )
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit check-compiler-switch cmake flag-o-matic python-any-r1 rocm

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-rocm-${PV}"
SRC_URI="
https://github.com/ROCm/rocprofiler/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="The ROC profiler library for profiling with perf-counters and derived metrics"
HOMEPAGE="https://github.com/ROCm/rocprofiler"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
	Apache-2.0
	BSD-2
"
# Apache-2.0 - plugin/perfetto/perfetto_sdk/sdk/perfetto.cc
# BSD-2 - test/util/hsa_rsrc_factory.h
# The distro's MIT license template does not contain all rights reserved.
RESTRICT="test"
SLOT="0/${ROCM_SLOT}"
IUSE=" plugins samples test ebuild_revision_18"
REQUIRED_USE="
	${ROCM_REQUIRED_USE}
"
RDEPEND="
	$(python_gen_any_dep '
		dev-python/barectf[${PYTHON_USEDEP}]
	')
	!dev-util/rocprofiler:0
	>=dev-libs/hsa-amd-aqlprofile-${PV}:${SLOT}
	dev-libs/hsa-amd-aqlprofile:=
	>=dev-libs/rocm-comgr-${PV}:${SLOT}
	dev-libs/rocm-comgr:=
	>=dev-libs/rocm-core-${PV}:${SLOT}
	dev-libs/rocm-core:=
	>=dev-libs/rocr-runtime-${PV}:${SLOT}
	dev-libs/rocr-runtime:=
	>=dev-util/hip-${PV}:${SLOT}
	dev-util/hip:=
	>=dev-util/roctracer-${PV}:${SLOT}
	dev-util/roctracer:=
	plugins? (
		sys-apps/systemd
	)
	samples? (
		sys-apps/systemd
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${ROCM_CLANG_DEPEND}
	$(python_gen_any_dep '
		dev-python/cppheaderparser[${PYTHON_USEDEP}]
	')
	>=dev-build/cmake-3.18.0
	>=sys-devel/llvm-roc-symlinks-${PV}:${SLOT}
	sys-devel/llvm-roc-symlinks:=
	test? (
		sys-devel/gcc[sanitize]
		>=dev-libs/ROCdbgapi-${PV}:${SLOT}
		dev-libs/ROCdbgapi:=
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-6.0.2-tests-as-cmake-options.patch"
)

python_check_deps() {
	python_has_version "dev-python/cppheaderparser[${PYTHON_USEDEP}]"
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
	check-compiler-switch_start
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

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if ! check-compiler-switch_is_system_flavor ; then
einfo "Detected GPU compiler switch.  Disabling LTO."
		filter-lto
	fi

	[[ -e "${ESYSROOT}/opt/rocm/$(rocm_get_libdir)/hsa-amd-aqlprofile/librocprofv2_att.so" ]] \
		|| die "Missing" # For e80f7cb
	[[ -e "${ESYSROOT}/opt/rocm/$(rocm_get_libdir)/libhsa-amd-aqlprofile64.so" ]] \
		|| die "Missing" # For 071379b
	append-ldflags -Wl,-rpath="${EPREFIX}/opt/rocm/$(rocm_get_libdir)"

	export HIP_PLATFORM="amd"
	local gpu_targets=$(get_amdgpu_flags \
		| tr ";" " ")
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DCMAKE_MODULE_PATH="${ESYSROOT}${EROCM_PATH}/$(rocm_get_libdir)/cmake/hip"
		-DCMAKE_PREFIX_PATH="${EPREFIX}${EROCM_PATH}/include/hsa"
		-DCMAKE_SKIP_RPATH=ON
		-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DGPU_TARGETS="${gpu_targets}"
		-DHIP_COMPILER="clang"
		-DHIP_PLATFORM="amd"
		-DHIP_ROOT_DIR="${ESYSROOT}${EROCM_PATH}"
		-DHIP_RUNTIME="rocclr"
		-DPROF_API_HEADER_PATH="${ESYSROOT}${EROCM_PATH}/include/roctracer/ext"
		-DROCPROFILER_BUILD_CI=$(usex test)
		-DROCPROFILER_BUILD_PLUGIN_ATT=$(usex plugins)
		-DROCPROFILER_BUILD_PLUGIN_CTF=$(usex plugins)
		-DROCPROFILER_BUILD_PLUGIN_PERFETTO=$(usex plugins)
		-DROCPROFILER_BUILD_TESTS=$(usex test)
		-DROCPROFILER_BUILD_SAMPLES=$(usex samples)
		-DUSE_PROF_API=1
		-DAQLPROFILE=ON
		-DPython3_EXECUTABLE="${PYTHON}"
	)
	rocm_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
	rocm_fix_rpath
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs test
