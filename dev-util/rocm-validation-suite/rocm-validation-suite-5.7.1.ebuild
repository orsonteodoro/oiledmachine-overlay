# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_SLOT=17
MY_PN="ROCmValidationSuite"
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"

inherit check-glibcxx-ver cmake rocm

if [[ ${PV} == *"9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/ROCm/ROCmValidationSuite.git"
	FALLBACK_COMMIT="rocm-5.7.1"
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-rocm-${PV}"
	SRC_URI="
https://github.com/ROCm/ROCmValidationSuite/archive/refs/tags/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="The ROCm Validation Suite is a system administrator’s and cluster \
manager's tool for detecting and troubleshooting common problems affecting AMD \
GPU(s) running in a high-performance computing environment."
HOMEPAGE="https://github.com/ROCm/ROCmValidationSuite"
LICENSE="
	(
		all-rights-reserved
		MIT
	)
	MIT
	UoI-NCSA
"
# all-rights-reserved MIT - gpup.so/CMakeLists.txt
# MIT - rvs/src/rvsoptions.cpp
# UoI-NCSA - babel.so/include/rvs_memkernel.h
# The distro's MIT license template does not contain all rights reserved.
RESTRICT="test" # Needs SRC_URI changes for offline install.
SLOT="${ROCM_SLOT}/${PV}"
IUSE+=" doc test ebuild-revision-1"
RDEPEND="
	dev-cpp/yaml-cpp
	sys-apps/pciutils
	~dev-util/hip-${PV}:${ROCM_SLOT}
	~dev-libs/rocr-runtime-${PV}:${ROCM_SLOT}
	~dev-libs/roct-thunk-interface-${PV}:${ROCM_SLOT}
	~dev-util/rocm-smi-${PV}:${ROCM_SLOT}
	~sci-libs/rocBLAS-${PV}:${ROCM_SLOT}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${ROCM_GCC_DEPEND}
	>=dev-build/cmake-3.5.0
"
PATCHES=(
	"${FILESDIR}/${PN}-5.7.1-hardcoded-paths.patch"
)

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	rocm_set_default_gcc

# Prevent:
# ld.bfd: /opt/rocm-5.7.1/lib/libhsa-runtime64.so: undefined reference to `hsaKmtReplaceAsanHeaderPage'
# ld.bfd: /opt/rocm-5.7.1/lib/libhsa-runtime64.so: undefined reference to `hsaKmtWaitOnMultipleEvents_Ext'
	filter-flags '-fuse-ld=*'
	append-ldflags '-fuse-ld=lld'

# Prevent:
# ld.bfd: /usr/lib/gcc/x86_64-pc-linux-gnu/12/../../../../lib64/libyaml-cpp.so: undefined reference to `std::ios_base_library_init()@GLIBCXX_3.4.32'
	check_pkg_glibcxx "dev-cpp/yaml-cpp" "/usr/$(get_libdir)/libyaml-cpp.so" "${HIP_5_7_GCC_SLOT}"

	local mycmakeargs=(
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DHIPCC_PATH="${ESYSROOT}${EROCM_PATH}"
		-DRVS_BUILD_TESTS=$(usex test)
		-DRVS_GTEST=0
		-DRVS_ROCBLAS=0
		-DRVS_ROCMSMI=0
		-DRVS_YAML_CPP=0
	)
	rocm_src_configure
}

src_install() {
	cmake_src_install
	# Fix missing ldd rows
	insinto "${EROCM_PATH}"
	doexe "rvslib/librvslib.so"
	doexe "rvs/librvshelper.so"
	rocm_mv_docs
	rocm_fix_rpath
ewarn "RCQT (ROCm Configuration Qualification Tool) does not support portage."
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
