# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# No CMAKE arg yet
_AMDGPU_TARGETS_COMPAT=(
	"gfx900"
	"gfx902"
	"gfx904"
	"gfx906"
	"gfx908"
	"gfx909"
	"gfx90a"
	"gfx90c"
	"gfx940"
	"gfx941"
	"gfx942"
	"gfx1010"
	"gfx1011"
	"gfx1012"
	"gfx1013"
	"gfx1030"
	"gfx1031"
	"gfx1032"
	"gfx1033"
	"gfx1034"
	"gfx1035"
	"gfx1036"
	"gfx1100"
	"gfx1101"
	"gfx1102"
	"gfx1103"
	"gfx1150"
	"gfx1151"
)

HIP_SUPPORT_CUDA=1
LLVM_SLOT=17
ROCM_SLOT="5.7"
inherit hip-versions
ROCM_VERSION="${HIP_5_7_VERSION}"
EGIT_COMMIT="4996b9794cdbc3852fad6e2ae0dbab1e48f2e5f0"

inherit cmake rocm

KEYWORDS="~amd64"
S="${WORKDIR}/HIPRT-${EGIT_COMMIT}"
SRC_URI="
https://github.com/GPUOpen-LibrariesAndSDKs/HIPRT/archive/${EGIT_COMMIT}.tar.gz
	-> ${PN}-${EGIT_COMMIT:0:7}.tar.gz
"

DESCRIPTION="HIP RT is a ray tracing library in HIP"
HOMEPAGE="
	https://github.com/GPUOpen-LibrariesAndSDKs/HIPRTSDK
	https://github.com/GPUOpen-LibrariesAndSDKs/HIPRT
"
REQUIRED_USE="${ROCM_REQUIRED_USE}"
LICENSE="
	Apache-2.0
	BSD
	MIT
	public-domain
	|| (
		Apache-2.0-with-LLVM-exceptions
		GPL-3
	)
"
RESTRICT="test"
SLOT="${ROCM_SLOT}/${ROCM_VERSION}"
IUSE="-bake-kernel -bitcode cuda rocm test ebuild-revision-0"
REQUIRED_USE="
	^^ (
		cuda
		rocm
	)
"
RDEPEND="
	dev-util/hip:${SLOT}
	cuda? (
		${HIP_CUDA_DEPEND}
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${HIP_CLANG_DEPEND}
	>=dev-build/cmake-3.10
"
PATCHES=(
	"${FILESDIR}/${PN}-2.3_p20240717-hardcoded-paths.patch"
	"${FILESDIR}/${PN}-2.3_p20240717-cuda-option.patch"
	"${FILESDIR}/${PN}-2.3_p20240717-install-paths.patch"
)
DOCS=( "README.md" )

pkg_setup() {
	rocm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	rocm_src_prepare
}

src_configure() {
	rocm_set_default_clang
	export HIP_PATH="/opt/rocm-${ROCM_VERSION}"
	local mycmakeargs=(
		-DBITCODE=$(usex bitcode)
		-DCMAKE_INSTALL_LIBDIR="$(rocm_get_libdir)"
		-DCMAKE_INSTALL_PREFIX="/opt/rocm-${ROCM_VERSION}"
		-DGENERATE_BAKE_KERNEL=$(usex bake-kernel)
		-DHIP_PATH="/opt/rocm-${ROCM_VERSION}"
		-DHIPRT_PREFER_HIP_5=ON
		-DNO_UNITTEST=$(usex !test)
		-DUSE_CUDA=$(usex cuda)
	)
	if use cuda ; then
		mycmakeargs+=(
			-DHIP_COMPILER="nvcc"
			-DHIP_PLATFORM="nvidia"
			-DHIP_RUNTIME="cuda"
		)
		export CC=""
	elif use rocm ; then
		export HIP_PLATFORM="amd"
		mycmakeargs+=(
#			-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
			-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
			-DHIP_COMPILER="clang"
			-DHIP_PLATFORM="amd"
			-DHIP_RUNTIME="rocclr"
			-DROCM_SYMLINK_LIBS=OFF
		)
	fi
	rocm_src_configure
}

src_install() {
	cmake_src_install
	einstalldocs
	dodoc "license.txt"
	rocm_mv_docs
}
