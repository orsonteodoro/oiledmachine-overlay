# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="Release"
LLVM_SLOT=19 # See https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-6.4.4/llvm/CMakeLists.txt
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit check-compiler-switch cmake flag-o-matic rocm

if [[ "${PV}" == *"9999" ]] ; then
	EGIT_REPO_URI="https://github.com/ROCm/llvm-project.git"
	S="${WORKDIR}/${P}/src"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/llvm-project-rocm-${PV}/amd/device-libs"
	SRC_URI="
https://github.com/ROCm/llvm-project/archive/refs/tags/rocm-${PV}.tar.gz
	-> llvm-project-rocm-${PV}.tar.gz
	"
fi

DESCRIPTION="Radeon Open Compute Device Libraries"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-Device-Libs"
TARBALL_LICENSES="
	(
		all-rights-reserved
		MIT
	)
	(
		Apache-2.0-with-LLVM-exceptions
		UoI-NCSA
	)
	(
		Apache-2.0-with-LLVM-exceptions
		BSD
		MIT
	)
	(
		Apache-2.0-with-LLVM-exceptions
		UoI-NCSA
	)
	(
		Apache-2.0-with-LLVM-exceptions
		custom
		MIT
		UoI-NCSA
	)
	Apache-2.0
	BSD
	CC0-1.0
	custom
	ISC
	MIT
	rc
	UoI-NCSA
"
LICENSE="
	${TARBALL_LICENSES}
	NCSA-AMD
	SunPro
	UoI-NCSA
"
# all-rights-reserved MIT - amd/comgr/comgr-backward-compat.cmake
# Apache-2.0 - third-party/benchmark/LICENSE
# Apache-2.0-with-LLVM-exceptions - mlir/LICENSE.TXT
# Apache-2.0-with-LLVM-exceptions BSD MIT - libclc/LICENSE.TXT
# Apache-2.0-with-LLVM-exceptions custom MIT UoI-NCSA - openmp/LICENSE.TXT
# Apache-2.0-with-LLVM-exceptions UoI-NCSA - lldb/LICENSE.TXT
# Apache-2.0-with-LLVM-exceptions UoI-NCSA - clang-tools-extra/LICENSE.TXT
# BSD - third-party/unittest/googlemock/LICENSE.txt
# BSD - openmp/runtime/src/thirdparty/ittnotify/LICENSE.txt
# BSD - amd/comgr/LICENSE.txt
# BSD rc - llvm/lib/Support/COPYRIGHT.regex
# CC0-1.0 - llvm/lib/Support/BLAKE3/LICENSE
# custom - clang-tools-extra/clang-tidy/cert/LICENSE.TXT
# ISC - lldb/third_party/Python/module/pexpect-4.6/LICENSE
# MIT - llvm/test/YAMLParser/LICENSE.txt
# NCSA-AMD - amd/device-libs/ockl/inc/hsa.h
# SunPro - amd/device-libs/ocml/src/erfcF.cl
# UoI-NCSA - amd/device-libs/LICENSE.TXT
# UoI-NCSA - amd/device-libs/LICENSE.TXT
# The distro's MIT license template does not contain all rights reserved.
RESTRICT="
	!test? (
		test
	)
"
SLOT="0/${ROCM_SLOT}"
IUSE="test ebuild_revision_14"
RDEPEND="
	${ROCM_CLANG_DEPEND}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${ROCM_CLANG_DEPEND}
	>=dev-build/cmake-3.13.4
	>=dev-build/rocm-cmake-${PV}:${SLOT}
	dev-build/rocm-cmake:=
"
PATCHES=(
	"${FILESDIR}/${PN}-6.2.4.patch"
)

pkg_setup() {
	check-compiler-switch_start
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	export LD_LIBRARY_PATH="${EROCM_PATH}/llvm/$(rocm_get_libdir):${LD_LIBRARY_PATH}"
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

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
		-DLLVM_DIR="${ESYSROOT}${EROCM_LLVM_PATH}"
	)
	rocm_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
