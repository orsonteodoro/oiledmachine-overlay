# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=17
LLVM_COMPAT=( {17..19} )
PYTHON_COMPAT=( python3_{11..13} )

# Align libstdcxx to avoid symbol issues
inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit cmake libstdcxx-slot llvm.org llvm-r1 python-any-r1

DESCRIPTION="OpenCL C library"
HOMEPAGE="https://libclc.llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions || ( MIT BSD )"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~riscv x86"
IUSE="
+spirv video_cards_nvidia video_cards_r600 video_cards_radeonsi
ebuild_revision_1
"

BDEPEND="
	${PYTHON_DEPS}
	llvm-core/clang:${LLVM_MAJOR}=[${LIBSTDCXX_USEDEP}]
	spirv? (
		dev-util/spirv-llvm-translator:${LLVM_MAJOR}=[${LIBSTDCXX_USEDEP}]
	)
"

LLVM_COMPONENTS=( libclc )
llvm.org_set_globals

pkg_setup() {
	llvm-r1_pkg_setup
	python-any-r1_pkg_setup
	libstdcxx-slot_verify
}

src_configure() {
	local libclc_targets=()

	use spirv && libclc_targets+=(
		"spirv-mesa3d-"
		"spirv64-mesa3d-"
	)
	use video_cards_nvidia && libclc_targets+=(
		"nvptx--"
		"nvptx64--"
		"nvptx--nvidiacl"
		"nvptx64--nvidiacl"
	)
	use video_cards_r600 && libclc_targets+=(
		"r600--"
	)
	use video_cards_radeonsi && libclc_targets+=(
		"amdgcn--"
		"amdgcn-mesa-mesa3d"
		"amdgcn--amdhsa"
	)

	libclc_targets=${libclc_targets[*]}
	local mycmakeargs=(
		-DLIBCLC_TARGETS_TO_BUILD="${libclc_targets// /;}"
	)
	cmake_src_configure
}
