# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=14 # See https://github.com/RadeonOpenCompute/llvm-project/blob/rocm-5.1.3/llvm/CMakeLists.txt

inherit cmake llvm prefix rocm

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
IUSE=" r1"
RDEPEND="
	~dev-libs/rocm-device-libs-${PV}:${SLOT}
	=sys-devel/clang-runtime-${LLVM_MAX_SLOT}*:=
	sys-devel/clang:${LLVM_MAX_SLOT}=
	sys-devel/lld:${LLVM_MAX_SLOT}=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/cmake-3.13.4
	~dev-util/rocm-cmake-${PV}:${SLOT}
"
PATCHES=(
	"${FILESDIR}/${PN}-4.5.2-dependencies.patch"
	"${FILESDIR}/${PN}-5.1.3-Find-CLANG_RESOURCE_DIR.patch"
	"${FILESDIR}/${PN}-5.1.3-clang-link.patch"
	"${FILESDIR}/${PN}-5.1.3-clang-fix-include.patch"
	"${FILESDIR}/${PN}-5.1.3-rocm-path.patch"
	"${FILESDIR}/0001-COMGR-changes-needed-for-upstream-llvm.patch"
#	"${FILESDIR}/${PN}-5.1.3-llvm-15-remove-zlib-gnu"
#	"${FILESDIR}/${PN}-5.1.3-llvm-15-args-changed"
	"${FILESDIR}/${PN}-5.3.3-fno-stack-protector.patch"
)
CMAKE_BUILD_TYPE="Release"

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	sed \
		-e '/sys::path::append(HIPPath/s,"hip","",' \
		-i \
		"src/comgr-env.cpp" \
		|| die
	local llvm_prefix=$(get_llvm_prefix ${LLVM_MAX_SLOT})
	sed \
		-e "/return LLVMPath;/s,LLVMPath,llvm::SmallString<128>(\"${llvm_prefix}\")," \
		-i \
		"src/comgr-env.cpp" \
		|| die
	sed \
		-e '/Args.push_back(HIPIncludePath/,+1d' \
		-i \
		"src/comgr-compiler.cpp" \
		|| die

	# ROCM and HIPIncludePath is now in /usr, which disturbs the include
	# order.
	sed \
		-e '/Args.push_back(ROCMIncludePath/,+1d' \
		-i \
		"src/comgr-compiler.cpp" \
		|| die

	eapply $(prefixify_ro "${FILESDIR}/${PN}-5.0-rocm_path.patch")
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	if has_version "dev-util/hip" ; then
eerror
eerror "You must uninstall dev-util/hip first before emerging this version of"
eerror "the package."
eerror
		die
	fi
	local mycmakeargs=(
	# Disable stripping defined at lib/comgr/CMakeLists.txt:58
		-DCMAKE_STRIP=""
		-DLLVM_DIR="$(get_llvm_prefix ${LLVM_MAX_SLOT})"
	)
	cmake_src_configure
}

# OILEDMACHINE-OVERLAY-STATUS:  builds-without-problems
