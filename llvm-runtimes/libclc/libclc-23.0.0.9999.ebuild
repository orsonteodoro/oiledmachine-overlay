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

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+="
		fallback-commit
	"
fi

inherit llvm-ebuilds

_llvm_set_globals() {
	if [[ "${USE}" =~ "fallback-commit" && "${PV}" =~ "9999" ]] ; then
llvm_ebuilds_message "${PV%%.*}" "_llvm_set_globals"
		EGIT_OVERRIDE_COMMIT_LLVM_LLVM_PROJECT="${LLVM_EBUILDS_LLVM23_FALLBACK_COMMIT}"
		EGIT_BRANCH="${LLVM_EBUILDS_LLVM23_BRANCH}"
	fi
}
_llvm_set_globals
unset -f _llvm_set_globals

inherit cmake libstdcxx-slot llvm.org multibuild python-any-r1

DESCRIPTION="OpenCL C library"
HOMEPAGE="https://libclc.llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions || ( MIT BSD )"
SLOT="0"
IUSE+="
+spirv test video_cards_nvidia video_cards_radeonsi
ebuild_revision_1
"
RESTRICT="!test? ( test )"

BDEPEND="
	${PYTHON_DEPS}
	llvm-core/clang:${LLVM_MAJOR}=[${LIBSTDCXX_USEDEP}]
	spirv? (
		dev-util/spirv-llvm-translator:${LLVM_MAJOR}=[${LIBSTDCXX_USEDEP}]
	)
	test? (
		$(python_gen_any_dep "
			>=dev-python/lit-${LLVM_MAJOR}[\${PYTHON_USEDEP}]
		")
	)
"

LLVM_COMPONENTS=( libclc )
llvm.org_set_globals

pkg_setup() {
	libstdcxx-slot_verify
}

src_configure() {
	MULTIBUILD_VARIANTS=(
		"clspv--"
		"clspv64--"
	)

	use spirv && MULTIBUILD_VARIANTS+=(
		"spirv-mesa3d-"
		"spirv64-mesa3d-"
	)
	use video_cards_nvidia && MULTIBUILD_VARIANTS+=(
		"nvptx64-nvidia-cuda"
	)
	use video_cards_radeonsi && MULTIBUILD_VARIANTS+=(
		"amdgcn-amd-amdhsa-llvm"
	)

	multibuild_foreach_variant my_configure
}

my_configure() {
	local mycmakeargs=(
		-DLLVM_ROOT="${ESYSROOT}/usr/lib/llvm/${LLVM_MAJOR}"
		-DCMAKE_CLC_COMPILER="$(type -P clang-${LLVM_MAJOR})"
		-DLLVM_DEFAULT_TARGET_TRIPLE="${MULTIBUILD_VARIANT}"
		-DLLVM_INCLUDE_TESTS="$(usex test)"
	)

	use test && mycmakeargs+=(
		-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
		-DLLVM_LIT_ARGS="$(get_lit_flags)"
	)

	cmake_src_configure
}

src_compile() {
	multibuild_foreach_variant cmake_src_compile
}

src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	multibuild_foreach_variant cmake_build check-libclc
}

src_install() {
	multibuild_foreach_variant cmake_src_install
}
