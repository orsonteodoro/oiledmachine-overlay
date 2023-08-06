# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} =~ 9999 ]] ; then
IUSE+="
	fallback-commit
"
fi

inherit llvm-ebuilds

_llvm_set_globals() {
	if [[ "${USE}" =~ "fallback-commit" && ${PV} =~ 9999 ]] ; then
einfo "Using fallback commit"
		EGIT_OVERRIDE_COMMIT_LLVM_LLVM_PROJECT="${FALLBACK_LLVM17_COMMIT}"
	fi
}
_llvm_set_globals
unset -f _llvm_set_globals

LLVM_MAX_SLOT=${PV%%.*}
PYTHON_COMPAT=( python3_{10..12} )

inherit flag-o-matic cmake-multilib linux-info llvm llvm.org
inherit python-single-r1 toolchain-funcs

DESCRIPTION="Multi Level Intermediate Representation for LLVM"
HOMEPAGE="https://openmp.llvm.org"
LICENSE="
	Apache-2.0-with-LLVM-exceptions
	|| (
		UoI-NCSA
		MIT
	)
"
SLOT="${LLVM_MAJOR}/${LLVM_SOABI}"
KEYWORDS=""
IUSE+="
	debug test
"
REQUIRED_USE="
"
RDEPEND="
	sys-devel/clang:${SLOT}
	sys-devel/llvm:${SLOT}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	sys-devel/clang:${SLOT}
	sys-devel/llvm:${SLOT}
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

python_check_deps() {
	python_has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	llvm_pkg_setup # Init LLVM_SLOT
	if use test; then
		python-single-r1_pkg_setup
	fi
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

	if ! [[ -e "/usr/lib/llvm/${PV%%.*}/$(get_libdir)/libLLVMCodeGenTypes.a" ]] ; then
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

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
