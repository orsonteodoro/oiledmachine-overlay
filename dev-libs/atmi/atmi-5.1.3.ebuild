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
LLVM_MAX_SLOT=14
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
SLOT="0/$(ver_cut 1-2)"
IUSE="
debug
"
RDEPEND="
	sys-devel/llvm:${LLVM_MAX_SLOT}
	virtual/libelf
	~dev-libs/rocm-comgr-${PV}:${SLOT}
	~dev-libs/rocm-device-libs-${PV}:${SLOT}
	~dev-libs/rocr-runtime-${PV}:${SLOT}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.16.8
	~dev-util/rocm-cmake-${PV}:${SLOT}
"
PATCHES=(
	"${FILESDIR}/atmi-5.1.3-cmake_library_hint.patch"
)
S="${WORKDIR}/atmi-rocm-${PV}/src"

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	sed \
		-e "s:DESTINATION lib COMPONENT device_runtime:DESTINATION $(get_libdir) COMPONENT device_runtime:" \
		-i \
		"${S}/device_runtime/CMakeLists.txt" \
		|| die
	sed \
		-e "s:TARGETS atmi_runtime LIBRARY DESTINATION \"lib\" COMPONENT runtime:TARGETS atmi_runtime LIBRARY DESTINATION \"$(get_libdir)\" COMPONENT runtime:" \
		-i \
		"${S}/runtime/core/CMakeLists.txt" \
		|| die

	cmake_src_prepare
	IFS=$'\n'
	sed \
		-i \
		-e "s|}/lib/amdgcn/bitcode|}/$(get_libdir)/amdgcn/bitcode|g" \
		$(grep -l -F -r -e "}/lib/amdgcn/bitcode" "${WORKDIR}") \
		|| true
	sed \
		-i \
		-e "s|{ROCM_DEVICE_PATH}/amdgcn/bitcode|{ROCM_DEVICE_PATH}/$(get_libdir)/amdgcn/bitcode|g" \
		$(grep -l -F -r -e "{ROCM_DEVICE_PATH}/amdgcn/bitcode" "${WORKDIR}") \
		|| true
	sed \
		-i \
		-e "s|-target|--rocm-device-lib-path=\"${ESYSROOT}/usr/$(get_libdir)/amdgcn/bitcode\" -target|g" \
		$(grep -l -F -r -e "-target" "${WORKDIR}") \
		|| die
	IFS=$' \t\n'
	rocm_src_prepare
}

src_configure() {
	if use debug ; then
		CMAKE_BUILD_TYPE="Debug"
	else
		CMAKE_BUILD_TYPE="Release"
	fi
	export GFXLIST=$(get_amdgpu_flags)
	export ROC_DIR="/usr"
	export ROCR_DIR="/usr"
	local mycmakeargs=(
		-DAMD_DEVICE_LIBS_PREFIX="${ESYSROOT}/usr"
		-DATMI_C_EXTENSION=OFF
		-DATMI_DEVICE_RUNTIME=ON
		-DATMI_HSA_INTEROP=ON
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/"
		-DDEVICE_LIB_DIR="${ESYSROOT}/usr"
		-DHSA_DIR="${ESYSROOT}/usr"
		-DLLVM_DIR="${ESYSROOT}/usr/lib/llvm/${LLVM_MAX_SLOT}/"
		-DROCM_VERSION="${PV}"
	)
	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  ON
