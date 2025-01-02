# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="Release"
LLVM_SLOT=18 # See https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-6.2.4/llvm/CMakeLists.txt
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit cmake flag-o-matic prefix rocm

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCm-CompilerSupport/"
	S="${WORKDIR}/${P}/lib/comgr"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/llvm-project-rocm-${PV}/amd/comgr"
	SRC_URI="
https://github.com/RadeonOpenCompute/llvm-project/archive/rocm-${PV}.tar.gz
	-> llvm-project-rocm-${PV}.tar.gz
	"
fi

DESCRIPTION="Radeon Open Compute Code Object Manager"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-CompilerSupport"
TARBALL_LICENSES="
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
	NCSA-AMD
	SunPro
	UoI-NCSA
"
LICENSE="
	${TARBALL_LICENSES}
	(
		all-rights-reserved
		MIT
	)
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
# CC0-1.0 - llvm/lib/Support/BLAKE3/LICENSE
# custom - clang-tools-extra/clang-tidy/cert/LICENSE.TXT
# ISC - lldb/third_party/Python/module/pexpect-4.6/LICENSE
# MIT - llvm/test/YAMLParser/LICENSE.txt
# SunPro - amd/device-libs/ocml/src/erfcF.cl
# NCSA-AMD - amd/device-libs/ockl/inc/hsa.h
# UoI-NCSA - amd/device-libs/LICENSE.TXT
# The distro's MIT license template does not contain all rights reserved.
# strip - Prevent missing symbols
RESTRICT="
	strip
	!test? (
		test
	)
"
SLOT="${ROCM_SLOT}/${PV}"
IUSE="test ebuild_revision_15"
RDEPEND="
	${ROCM_CLANG_DEPEND}
	!dev-libs/rocm-comgr:0
	~dev-libs/rocm-device-libs-${PV}:${ROCM_SLOT}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${ROCM_CLANG_DEPEND}
	>=dev-build/cmake-3.13.4
	~dev-build/rocm-cmake-${PV}:${ROCM_SLOT}
"
PATCHES=(
	"${FILESDIR}/${PN}-5.1.3-clang-fix-include.patch"
#	"${FILESDIR}/${PN}-5.3.3-fix-tests.patch"
	"${FILESDIR}/${PN}-5.3.3-fno-stack-protector.patch"
	"${FILESDIR}/${PN}-5.6.1-llvm-not-dylib-add-libs.patch"
	"${FILESDIR}/${PN}-6.1.2-rpath.patch"
	"${FILESDIR}/${PN}-6.1.2-disable-header.patch"
)

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	# Speed up symbol replacmenet for @...@ by reducing the search space
	# Generated from below one liner ran in the same folder as this file:
	# grep -F -r -e "+++" | cut -f 2 -d " " | cut -f 1 -d $'\t' | sort | uniq | cut -f 2- -d $'/' | sort | uniq
	PATCH_PATHS=(
		"${WORKDIR}/llvm-project-rocm-${PV}/amd/comgr/CMakeLists.txt"
		"${WORKDIR}/llvm-project-rocm-${PV}/amd/comgr/src/comgr-objdump.cpp"
		"${WORKDIR}/llvm-project-rocm-${PV}/amd/comgr/src/comgr-compiler.cpp"
		"${WORKDIR}/llvm-project-rocm-${PV}/amd/comgr/src/comgr-env.cpp"
		"${WORKDIR}/llvm-project-rocm-${PV}/amd/comgr/src/comgr-env.h"
		"${WORKDIR}/llvm-project-rocm-${PV}/amd/comgr/src/comgr-objdump.cpp"
		"${WORKDIR}/llvm-project-rocm-${PV}/amd/comgr/test/source1.cl"
	)

	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	rocm_set_default_clang

	export COMGR="${S}/amd/comgr"
	export DEVICE_LIBS="${S}/amd/device-libs"
	export LLVM_PROJECT="${S}"

	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test ON OFF)
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${EROCM_PATH}"
	# Disable stripping defined at lib/comgr/CMakeLists.txt:58
		-DCMAKE_STRIP=""
		-DLLVM_DIR="${ESYSROOT}${EROCM_LLVM_PATH}"
		-DLLVM_LINK_LLVM_DYLIB=OFF
	)
	rocm_src_configure
}

src_install() {
	cmake_src_install
	rocm_mv_docs
}

# OILEDMACHINE-OVERLAY-STATUS:  ebuild needs test
