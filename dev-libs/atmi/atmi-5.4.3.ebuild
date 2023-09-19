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
debug
r1
"
RDEPEND="
	sys-devel/llvm:${LLVM_MAX_SLOT}
	virtual/libelf
	~dev-libs/rocm-comgr-${PV}:${ROCM_SLOT}
	~dev-libs/rocm-device-libs-${PV}:${ROCM_SLOT}
	~dev-libs/rocr-runtime-${PV}:${ROCM_SLOT}
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
)
S="${WORKDIR}/atmi-rocm-${PV}/src"

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	if use debug ; then
		CMAKE_BUILD_TYPE="Debug"
	else
		CMAKE_BUILD_TYPE="Release"
	fi
	export GFXLIST=$(get_amdgpu_flags)
	local rocm_path="/usr/$(get_libdir)/rocm/${ROCM_SLOT}"
	export ROC_DIR="${rocm_path}"
	export ROCR_DIR="${rocm_path}"
	local mycmakeargs=(
		-DAMD_DEVICE_LIBS_PREFIX="${ESYSROOT}${rocm_path}"
		-DATMI_C_EXTENSION=OFF
		-DATMI_DEVICE_RUNTIME=ON
		-DATMI_HSA_INTEROP=ON
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${rocm_path}"
		-DDEVICE_LIB_DIR="${ESYSROOT}${rocm_path}"
		-DHSA_DIR="${ESYSROOT}${rocm_path}"
		-DLLVM_DIR="${ESYSROOT}/usr/lib/llvm/${LLVM_MAX_SLOT}/"
		-DROCM_VERSION="${PV}"
	)
	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
