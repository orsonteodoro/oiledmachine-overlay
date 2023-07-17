# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=15 # See https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-5.4.3/llvm/CMakeLists.txt
inherit cmake llvm prefix

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCm-CompilerSupport/"
	inherit git-r3
	S="${WORKDIR}/${P}/lib/comgr"
else
	SRC_URI="
https://github.com/RadeonOpenCompute/ROCm-CompilerSupport/archive/rocm-${PV}.tar.gz
	-> ${P}.tar.gz
	"
	S="${WORKDIR}/ROCm-CompilerSupport-rocm-${PV}/lib/comgr"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Radeon Open Compute Code Object Manager"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-CompilerSupport"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
IUSE="test"
RDEPEND="
	~dev-libs/rocm-device-libs-${PV}
	=sys-devel/clang-runtime-${LLVM_MAX_SLOT}*:=
	sys-devel/clang:${LLVM_MAX_SLOT}=
	sys-devel/lld:${LLVM_MAX_SLOT}=
"
DEPEND="
	${RDEPEND}
"
RESTRICT="
	!test? (
		test
	)
"
BDEPEND="
	>=dev-util/cmake-3.13.4
"
PATCHES=(
	"${FILESDIR}/${PN}-5.1.3-clang-fix-include.patch"
	"${FILESDIR}/${PN}-5.1.3-rocm-path.patch"
	"${FILESDIR}/0001-Specify-clang-exe-path-in-Driver-Creation.patch"
	"${FILESDIR}/0001-Find-CLANG_RESOURCE_DIR-using-clang-print-resource-d.patch"
	"${FILESDIR}/${PN}-5.3.3-HIPIncludePath-not-needed.patch"
	"${FILESDIR}/${PN}-5.3.3-fix-tests.patch"
	"${FILESDIR}/${PN}-5.3.3-fno-stack-protector.patch"
	"${FILESDIR}/${PN}-5.3.3-remove-h-option.patch"
)
CMAKE_BUILD_TYPE="Release"

src_prepare() {
	sed \
		-e '/sys::path::append(HIPPath/s,"hip","",' \
		-i src/comgr-env.cpp \
		|| die
	local llvm_prefix=$(get_llvm_prefix ${LLVM_MAX_SLOT})
	sed \
		-e "/return LLVMPath;/s,LLVMPath,llvm::SmallString<128>(\"${llvm_prefix}\")," \
		-i src/comgr-env.cpp \
		|| die
	eapply $(prefixify_ro "${FILESDIR}/${PN}-5.0-rocm_path.patch")
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test ON OFF)
	# Disable stripping defined at lib/comgr/CMakeLists.txt:58
		-DCMAKE_STRIP=""
		-DLLVM_DIR="$(get_llvm_prefix ${LLVM_MAX_SLOT})"
	)
	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
