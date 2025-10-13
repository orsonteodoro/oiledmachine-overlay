# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="Release"
GCC_COMPAT=(
	"gcc_slot_12_5" # Equivalent to GLIBCXX 3.4.30 in prebuilt binary for U22
	"gcc_slot_13_4" # Equivalent to GLIBCXX 3.4.32 in prebuilt binary for U24
)
LLVM_SLOT=19 # See https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-7.0.2/llvm/CMakeLists.txt
ROCM_SLOT="$(ver_cut 1-2 ${PV})"

inherit check-compiler-switch cmake flag-o-matic libstdcxx-slot prefix rocm

if [[ "${PV}" == *"9999" ]] ; then
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
SLOT="0/${ROCM_SLOT}"
IUSE="test ebuild_revision_17"
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
#	"${FILESDIR}/${PN}-6.1.2-rpath.patch"
	"${FILESDIR}/${PN}-6.1.2-disable-header.patch"
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
