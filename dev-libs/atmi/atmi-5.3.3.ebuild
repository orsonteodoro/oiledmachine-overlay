# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
        gfx803
	gfx900
        gfx906
        gfx908
        gfx90a
        gfx1030
        gfx1100
        gfx1101
        gfx1102
)
CMAKE_MAKEFILE_GENERATOR="emake"
LLVM_MAX_SLOT=15
ROCM_SLOT="$(ver_cut 1-2)"
VERBOSE=1

inherit cmake flag-o-matic rocm

SRC_URI="
https://github.com/RadeonOpenCompute/atmi/archive/refs/tags/rocm-${PV}.tar.gz
	-> rocm-atmi-${PV}.tar.gz
"

DESCRIPTION="ATMI is a runtime framework for efficient task management in \
heterogeneous CPU-GPU systems"
HOMEPAGE="https://github.com/RadeonOpenCompute/atmi"
LICENSE="
	MIT
	custom
"
# custom - bin/mymcpu
KEYWORDS="~amd64"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
debug system-llvm
r1
"
RDEPEND="
	!system-llvm? (
		sys-devel/llvm-roc:=
		~sys-devel/llvm-roc-${PV}:${ROCM_SLOT}
	)
	dev-util/rocm-compiler[system-llvm=]
	sys-devel/llvm:${LLVM_MAX_SLOT}
	virtual/libelf
	~dev-libs/rocm-comgr-${PV}:${ROCM_SLOT}
	~dev-libs/rocm-device-libs-${PV}:${ROCM_SLOT}
	~dev-libs/rocr-runtime-${PV}:${ROCM_SLOT}
	system-llvm? (
		>=sys-devel/llvm-${LLVM_MAX_SLOT}:${LLVM_MAX_SLOT}
		sys-devel/llvm:=
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.16.8
	~dev-util/rocm-cmake-${PV}:${ROCM_SLOT}
"
PATCHES=(
	"${FILESDIR}/atmi-5.3.3-path-changes.patch"
	"${FILESDIR}/atmi-5.5.1-headers.patch"
)
S="${WORKDIR}/atmi-rocm-${PV}/src"

pkg_setup() {
ewarn "The ebuild is under construction."
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	if has_version "dev-util/HIPIFY:${ROCM_SLOT}" ; then
# Avoid header problem:
# cstdint:48:11: error: no member named 'int16_t' in the global namespace
eerror
eerror "dev-util/HIPIFY:${ROCM_SLOT} must be unemerged temporarily before emerging this package."
eerror
		die
	fi
	if use debug ; then
		CMAKE_BUILD_TYPE="Debug"
	else
		CMAKE_BUILD_TYPE="Release"
	fi
	export GFXLIST=$(get_amdgpu_flags)

	export ROC_DIR="${ESYSROOT}${EROCM_PATH}"
	export ROCR_DIR="${ESYSROOT}${EROCM_PATH}"
	local mycmakeargs=(
		-DAMD_DEVICE_LIBS_PREFIX="${ESYSROOT}${EROCM_PATH}"
		-DATMI_C_EXTENSION=OFF
		-DATMI_DEVICE_RUNTIME=ON
		-DATMI_HSA_INTEROP=ON
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DDEVICE_LIB_DIR="${ESYSROOT}${EROCM_PATH}"
		-DHSA_DIR="${ESYSROOT}${EROCM_PATH}"
		-DLLVM_DIR="${ESYSROOT}${EROCM_LLVM_PATH}"
		-DROCM_VERSION="${PV}"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
