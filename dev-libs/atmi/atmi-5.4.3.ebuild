# Copyright 1999-2019,2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AMDGPU_TARGETS_COMPAT=(
# Based on:
# for x in $(ls /opt/rocm-5.4.3/amdgcn/bitcode/oclc_isa_version_*.bc | grep -E -o -e "oclc_isa_version_[0-9]+.bc" | cut -f 4 -d "_" | cut -f 1 -d ".") ; do echo -e "\tgfx${x}" ; done | sort -r
	gfx940
	gfx909
	gfx908
	gfx906
	gfx904
	gfx902
	gfx900
	gfx810
	gfx805
	gfx803
	gfx802
	gfx801
	gfx705
	gfx704
	gfx703
	gfx702
	gfx701
	gfx700
	gfx602
	gfx601
	gfx600
	gfx1103
	gfx1102
	gfx1101
	gfx1100
	gfx1036
	gfx1035
	gfx1034
	gfx1033
	gfx1032
	gfx1031
	gfx1030
	gfx1013
	gfx1012
	gfx1011
	gfx1010
)
CMAKE_MAKEFILE_GENERATOR="emake"
LLVM_SLOT=15
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
ebuild-revision-6
"
RDEPEND="
	${ROCM_CLANG_DEPEND}
	virtual/libelf
	~dev-libs/rocm-comgr-${PV}:${ROCM_SLOT}
	~dev-libs/rocm-device-libs-${PV}:${ROCM_SLOT}
	~dev-libs/rocr-runtime-${PV}:${ROCM_SLOT}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${ROCM_CLANG_DEPEND}
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
		eapply "${FILESDIR}/atmi-5.3.3-hardcoded-paths.patch"
	popd >/dev/null 2>&1 || die

	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	rocm_set_default_clang
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
	rocm_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
