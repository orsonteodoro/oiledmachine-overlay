# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+="
		fallback-commit
	"
fi

inherit llvm-ebuilds

_llvm_set_globals() {
	if [[ "${USE}" =~ "fallback-commit" && "${PV}" =~ "9999" ]] ; then
llvm_ebuilds_message "${PV%%.*}" "_llvm_set_globals"
		EGIT_OVERRIDE_COMMIT_LLVM_LLVM_PROJECT="${LLVM_EBUILDS_LLVM19_FALLBACK_COMMIT}"
		EGIT_BRANCH="${LLVM_EBUILDS_LLVM19_BRANCH}"
	fi
}
_llvm_set_globals
unset -f _llvm_set_globals

FLAG_O_MATIC_FILTER_LTO=1
LLVM_SLOT=${PV%%.*}
PYTHON_COMPAT=( "python3_12" )

inherit flag-o-matic cmake-multilib linux-info llvm llvm.org
inherit python-single-r1 toolchain-funcs

KEYWORDS="
~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x64-macos
"

DESCRIPTION="Multi Level Intermediate Representation for LLVM"
HOMEPAGE="https://openmp.llvm.org"
LICENSE="
	Apache-2.0-with-LLVM-exceptions
	|| (
		MIT
		UoI-NCSA
	)
"
SLOT="${LLVM_MAJOR}/${LLVM_SOABI}"
IUSE+="
	debug test
	ebuild_revision_4
${LLVM_EBUILDS_LLVM19_REVISION}
"
REQUIRED_USE="
"
RDEPEND="
	llvm-core/clang:${SLOT}
	llvm-core/llvm:${SLOT}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	llvm-core/clang:${SLOT}
	llvm-core/llvm:${SLOT}
"
RESTRICT="
"
LLVM_COMPONENTS=(
	"mlir"
	"cmake"
	"llvm/include"
)
LLVM_USE_TARGETS="llvm"
llvm.org_set_globals
PATCHES=(
)

python_check_deps() {
	python_has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	python-single-r1_pkg_setup
	llvm_pkg_setup
}

src_prepare() {
	cmake_src_prepare
}

multilib_src_configure() {
	# Disallow newer clangs versions when producing .o files.
	einfo "LLVM_SLOT=${LLVM_SLOT}"
	einfo "PATH=${PATH} (before)"
	export PATH=$(echo "${PATH}" \
		| tr ":" "\n" \
		| sed -E -e "/llvm\/[0-9]+/d" \
		| tr "\n" ":" \
		| sed -e "s|/opt/bin|/opt/bin:/usr/lib/llvm/${LLVM_SLOT}/bin|g")
	einfo "PATH=${PATH} (after)"

	if ! [[ -e "/usr/lib/llvm/${LLVM_MAJOR}/$(get_libdir)/libLLVMCodeGenTypes.a" ]] ; then
eerror
eerror "Missing libLLVMCodeGenTypes.a.  It requires that llvm-${PV} be modded install it."
eerror
		die
	fi
	# LTO causes issues in other packages building, #870127
	filter-lto

	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"

	local libdir="$(get_libdir)"
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}"
		-DLLVM_BUILD_TOOLS=ON
		-DLLVM_BUILD_UTILS=ON
		-DLLVM_INSTALL_UTILS=ON
		-DLLVM_LINK_LLVM_DYLIB=ON
		-DMLIR_LINK_MLIR_DYLIB=ON
	)

	cmake_src_configure
}

multilib_src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1

	cmake_build check-mlir
}

multilib_src_install() {
	cmake_src_install
	sed -i \
		-e "s|\"mlir-tblgen\"|\"/usr/lib/llvm/${LLVM_MAJOR}/bin/mlir-tblgen\"|g" \
		"${ED}/usr/lib/llvm/${LLVM_MAJOR}/$(get_libdir)/cmake/mlir/MLIRConfig.cmake" \
		|| die
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
