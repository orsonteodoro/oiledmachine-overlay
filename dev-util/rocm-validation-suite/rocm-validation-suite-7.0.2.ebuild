# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GCC_COMPAT=(
	"gcc_slot_12_5" # Equivalent to GLIBCXX 3.4.30 in prebuilt binary for U22
	"gcc_slot_13_4" # Equivalent to GLIBCXX 3.4.32 in prebuilt binary for U24
)
LLVM_SLOT=19
MY_PN="ROCmValidationSuite"
ROCM_SLOT="$(ver_cut 1-2 ${PV})"
ROCM_VERSION="${PV}"

inherit check-compiler-switch flag-o-matic cmake libstdcxx-slot rocm

if [[ ${PV} == *"9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/ROCm/ROCmValidationSuite.git"
	FALLBACK_COMMIT="rocm-6.2.4"
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
SLOT="0/${ROCM_SLOT}"
IUSE+=" doc test ebuild_revision_3"
RDEPEND="
	dev-cpp/yaml-cpp[${LIBSTDCXX_USEDEP}]
	dev-cpp/yaml-cpp:=
	sys-apps/pciutils
	>=dev-util/hip-${PV}:${SLOT}[${LIBSTDCXX_USEDEP}]
	dev-util/hip:=
	>=dev-libs/rocr-runtime-${PV}:${SLOT}[${LIBSTDCXX_USEDEP}]
	dev-libs/rocr-runtime:=
	>=dev-util/rocm-smi-${PV}:${SLOT}[${LIBSTDCXX_USEDEP}]
	dev-util/rocm-smi:=
	>=sci-libs/rocBLAS-${PV}:${SLOT}
	sci-libs/rocBLAS:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${ROCM_GCC_DEPEND}
	>=dev-build/cmake-3.5.0
	doc? (
		app-text/doxygen
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-6.0.2-hardcoded-paths.patch"
)

pkg_setup() {
	check-compiler-switch_start
	rocm_pkg_setup
	libstdcxx-slot_verify
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	rocm_set_default_gcc

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
	pushd "${WORKDIR}/${MY_PN}-rocm-${PV}_build" >/dev/null 2>&1 || die
		exeinto "${EROCM_PATH}/lib"
		doexe "bin/librvslib.so"
	popd >/dev/null 2>&1 || die
	rocm_mv_docs
	rocm_fix_rpath
ewarn "RCQT (ROCm Configuration Qualification Tool) does not support portage."
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
