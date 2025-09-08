# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+="
		fallback-commit
	"
fi

LLVM_MAX_SLOT=${PV%%.*}
PYTHON_COMPAT=( "python3_12" )

inherit llvm-ebuilds

_llvm_set_globals() {
	if [[ "${USE}" =~ "fallback-commit" && "${PV}" =~ "9999" ]] ; then
llvm_ebuilds_message "${PV%%.*}" "_llvm_set_globals"
		EGIT_OVERRIDE_COMMIT_LLVM_LLVM_PROJECT="${LLVM_EBUILDS_LLVM20_FALLBACK_COMMIT}"
		EGIT_BRANCH="${LLVM_EBUILDS_LLVM20_BRANCH}"
	fi
}
_llvm_set_globals
unset -f _llvm_set_globals

inherit cmake flag-o-matic llvm.org python-any-r1 toolchain-funcs

KEYWORDS="~amd64"

DESCRIPTION="LLVM Flang is a continuation of F18 to replace Classic Flang"
HOMEPAGE="
https://github.com/llvm/llvm-project/tree/main/flang
"
LICENSE="
	Apache-2.0-with-LLVM-exceptions
"
SLOT="${LLVM_MAJOR}/${LLVM_SOABI}"
IUSE+="
offload test
${LLVM_EBUILDS_LLVM20_REVISION}
"
REQUIRED_USE="
"
RDEPEND="
	llvm-runtimes/openmp:${LLVM_MAJOR}[offload?]
	llvm-core/clang:${LLVM_MAJOR}
	llvm-core/llvm:${LLVM_MAJOR}
	llvm-core/mlir:${LLVM_MAJOR}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	test? (
		$(python_gen_any_dep '
			dev-python/lit[${PYTHON_USEDEP}]
		')
	)
"
RESTRICT="
	test
"
PATCHES=(
)
LLVM_COMPONENTS=(
	"flang"
	"cmake"
)
LLVM_USE_TARGETS="llvm"
llvm.org_set_globals

src_configure() {
	if tc-is-gcc && ver_test $(gcc-version) -ge "13.1" ; then
#/var/tmp/portage/dev-lang/llvm-flang-19.0.0.9999/work/flang/lib/Semantics/check-omp-structure.cpp: In member function 'void Fortran::semantics::OmpStructureChecker::ErrIfLHSAndRHSSymbolsMatch(const Fortran::parser::Variable&, const Fortran::parser::Expr&)':
#/var/tmp/portage/dev-lang/llvm-flang-19.0.0.9999/work/flang/lib/Semantics/check-omp-structure.cpp:1777:19: error: possibly dangling reference to a temporary [-Werror=dangling-reference]
# 1777 |     const Symbol &varSymbol = evaluate::GetSymbolVector(*v).front();
#      |                   ^~~~~~~~~
#/var/tmp/portage/dev-lang/llvm-flang-19.0.0.9999/work/flang/lib/Semantics/check-omp-structure.cpp:1777:67: note: the temporary was destroyed at the end of the full expression '(& Fortran::evaluate::GetSymbolVector(const A&) [with A = Expr<SomeType>; SymbolVector = std::vector<Fortran::common::Reference<const Fortran::semantics::Symbol> >]().std::vector<Fortran::common::Reference<const Fortran::semantics::Symbol> >::front())->Fortran::common::Reference<const Fortran::semantics::Symbol>::operator std::conditional_t<true, const Fortran::semantics::Symbol&, void>()'
# 1777 |     const Symbol &varSymbol = evaluate::GetSymbolVector(*v).front();
#      |                                                                   ^
#/var/tmp/portage/dev-lang/llvm-flang-19.0.0.9999/work/flang/lib/Semantics/check-omp-structure.cpp: In member function 'void Fortran::semantics::OmpStructureChecker::CheckAtomicUpdateStmt(const Fortran::parser::AssignmentStmt&)':
#/var/tmp/portage/dev-lang/llvm-flang-19.0.0.9999/work/flang/lib/Semantics/check-omp-structure.cpp:1923:19: error: possibly dangling reference to a temporary [-Werror=dangling-reference]
# 1923 |     const Symbol &varSymbol = evaluate::GetSymbolVector(*v).front();
#      |                   ^~~~~~~~~
#/var/tmp/portage/dev-lang/llvm-flang-19.0.0.9999/work/flang/lib/Semantics/check-omp-structure.cpp:1923:67: note: the temporary was destroyed at the end of the full expression '(& Fortran::evaluate::GetSymbolVector(const A&) [with A = Expr<SomeType>; SymbolVector = std::vector<Fortran::common::Reference<const Fortran::semantics::Symbol> >]().std::vector<Fortran::common::Reference<const Fortran::semantics::Symbol> >::front())->Fortran::common::Reference<const Fortran::semantics::Symbol>::operator std::conditional_t<true, const Fortran::semantics::Symbol&, void>()'
# 1923 |     const Symbol &varSymbol = evaluate::GetSymbolVector(*v).front();
#      |                                                                   ^
#cc1plus: all warnings being treated as errors

# Use gcc 12 behavior
		append-flags -Wno-error=dangling-reference
	fi
	local user_choice=$(echo "${MAKEOPTS}" \
		| grep -E -e "-j[ ]*[0-9]+" \
		| grep -E -o "[0-9]+")
	local quarter_ncpus=$(python -c "print(int($(nproc)/4))")
	(( ${quarter_ncpus} == 0 )) && quarter_ncpus=1
	if [[ "${user_choice}" != "1" ]] ; then
		MAKEOPTS="-j${quarter_ncpus}" # Heavy swap
	fi
	local mycmakeargs=(
		-DCLANG_DIR="${ESYSROOT}/usr/lib/llvm/${LLVM_MAJOR}/$(get_libdir)/cmake/clang"
		-DCMAKE_BUILD_TYPE="Release"
		-DCMAKE_CXX_STANDARD=17
		-DCMAKE_CXX_LINK_FLAGS="-Wl,-rpath,${LD_LIBRARY_PATH}"
		-DCMAKE_EXPORT_COMPILE_COMMANDS=ON
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm-flang/${LLVM_MAJOR}"
		-DFLANG_ENABLE_WERROR=ON
		-DFLANG_INCLUDE_TESTS=OFF
		-DLLVM_BUILD_MAIN_SRC_DIR="${ESYSROOT}/usr/lib/llvm/${LLVM_MAJOR}/$(get_libdir)/cmake/llvm"
		-DLLVM_DIR="${ESYSROOT}/usr/lib/llvm/${LLVM_MAJOR}/$(get_libdir)/cmake/llvm"
		-DLLVM_ENABLE_ASSERTIONS=ON
		-DLLVM_TARGETS_TO_BUILD="host"
		-DMLIR_DIR="${ESYSROOT}/usr/lib/llvm/${LLVM_MAJOR}/$(get_libdir)/cmake/mlir"
	)
	if use test ; then
		mycmakeargs+=(
			-DLLVM_EXTERNAL_LIT="${ESYSROOT}/usr/bin/lit"
			-DLLVM_LIT_ARGS="-v"
		)
	fi
	cmake_src_configure
}

pkg_postinst() {
einfo "Switching ${EROOT}/usr/lib/llvm-flang/${LLVM_MAJOR}/bin/flang-new -> ${EROOT}/usr/bin/flang"
	ln -sf \
		"${EROOT}/usr/lib/llvm-flang/${LLVM_MAJOR}/bin/flang-new" \
		"${EROOT}/usr/bin/flang" \
		|| die
}

# OILEDMACHINE-OVERLAY-STATUS:  passed (ed0aa34, 20240305)
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  YES

# Testing:
#cat <<EOF > "hello.f90"
#program hello
#  print *, "hello world"
#end program
#EOF
#/usr/lib/llvm-flang/19/bin/flang-new hello.f90 -L/usr/lib/llvm-flang/19/lib64 -o hello.exe
#LD_LIBRARY_PATH="/usr/lib/llvm-flang/19/lib64" ./hello.exe
