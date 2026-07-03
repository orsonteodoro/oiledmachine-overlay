# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=17
PYTHON_COMPAT=( python3_{11..14} )

# Align libstdcxx to avoid symbol issues
inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit cmake libstdcxx-slot llvm.org python-any-r1

DESCRIPTION="OpenCL C library"
HOMEPAGE="https://libclc.llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions || ( MIT BSD )"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ~riscv x86"
IUSE="
+spirv video_cards_nvidia video_cards_r600 video_cards_radeonsi
ebuild_revision_1
"

BDEPEND="
	${PYTHON_DEPS}
	llvm-core/clang:${LLVM_MAJOR}[${LIBSTDCXX_USEDEP}]
	llvm-core/clang:=
	spirv? (
		dev-util/spirv-llvm-translator:22[${LIBSTDCXX_USEDEP}]
		dev-util/spirv-llvm-translator:=
	)
"

LLVM_COMPONENTS=( libclc )
llvm.org_set_globals

pkg_setup() {
	libstdcxx-slot_verify
}

src_configure() {
	local libclc_targets=(
		"clspv--"
		"clspv64--"
	)

	use spirv && libclc_targets+=(
		"spirv-mesa3d-"
		"spirv64-mesa3d-"
	)
	use video_cards_nvidia && libclc_targets+=(
		"nvptx64--"
		"nvptx64--nvidiacl"
		"nvptx64-nvidia-cuda"
	)
	use video_cards_r600 && libclc_targets+=(
		"r600--"
	)
	use video_cards_radeonsi && libclc_targets+=(
		"amdgcn--"
		"amdgcn-amd-amdhsa"
		"amdgcn-mesa-mesa3d"
	)

	libclc_targets=${libclc_targets[*]}
	local mycmakeargs=(
		-DLLVM_ROOT="${ESYSROOT}/usr/lib/llvm/${LLVM_MAJOR}"
		-DLIBCLC_TARGETS_TO_BUILD="${libclc_targets// /;}"
	)
	cmake_src_configure
}
