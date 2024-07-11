# Copyright 1999-2019,2023 Gentoo Authors
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
LLVM_SLOT=14
ROCM_SLOT="$(ver_cut 1-2)"
VERBOSE=1

inherit cmake flag-o-matic rocm

KEYWORDS="~amd64"
S="${WORKDIR}/atmi-rocm-${PV}/src"
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
SLOT="${ROCM_SLOT}/${PV}"
IUSE="
debug
ebuild-revision-4
"
RDEPEND="
	sys-devel/llvm-roc:=
	sys-devel/llvm:${LLVM_SLOT}
	virtual/libelf
	~dev-libs/rocm-comgr-${PV}:${ROCM_SLOT}
	~dev-libs/rocm-device-libs-${PV}:${ROCM_SLOT}
	~dev-libs/rocr-runtime-${PV}:${ROCM_SLOT}
	~sys-devel/llvm-roc-${PV}:${ROCM_SLOT}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-build/cmake-3.16.8
	~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
"
_PATCHES=(
	"${FILESDIR}/atmi-5.5.1-headers.patch"
)

pkg_setup() {
ewarn "The ebuild is under construction."
	rocm_pkg_setup
}

src_prepare() {
	eapply ${_PATCHES[@]}
	pushd "${WORKDIR}/atmi-rocm-${PV}" >/dev/null 2>&1 || die
		eapply "${FILESDIR}/atmi-5.2.3-hardcoded-paths.patch"
	popd >/dev/null 2>&1 || die

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
		-DROC_DIR="${EROCM_PATH}"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
