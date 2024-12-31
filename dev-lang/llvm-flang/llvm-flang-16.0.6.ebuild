# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=${PV%%.*}
PYTHON_COMPAT=( "python3_"{10..11} )

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
IUSE="
offload test
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
#FAILED: lib/Lower/CMakeFiles/obj.FortranLower.dir/ConvertCall.cpp.o
#/usr/lib/ccache/bin/x86_64-pc-linux-gnu-g++ -DFLANG_LITTLE_ENDIAN=1 -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -I/var/tmp/portage/dev-lang/llvm-flang-16.0.6/work/flang/include -I/var/tmp/portage/dev-lang/llvm-flang-16.0.6/work/flang_build/include -isystem /usr/lib/llvm/16/include  -O0 -pipe -fPIC -fno-semantic-interposition -fvisibility-inlines-hidden -Werror=date-time -Wall -Wextra -Wno-unused-parameter -Wwrite-strings -Wcast-qual -Wno-missing-field-initializers -pedantic -Wno-long-long -Wimplicit-fallthrough -Wno-maybe-uninitialized -Wno-class-memaccess -Wno-redundant-move -Wno-pessimizing-move -Wno-noexcept-type -Wdelete-non-virtual-dtor -Wsuggest-override -Wno-comment -Wno-misleading-indentation -Wctad-maybe-unsupported -fdiagnostics-color -ffunction-sections -fdata-sections -Werror -Wno-deprecated-copy -Wno-ctad-maybe-unsupported -fno-strict-aliasing -fno-semantic-interposition -std=c++17   -D_GNU_SOURCE -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -MD -MT lib/Lower/CMakeFiles/obj.FortranLower.dir/ConvertCall.cpp.o -MF lib/Lower/CMakeFiles/obj.FortranLower.dir/ConvertCall.cpp.o.d -o lib/Lower/CMakeFiles/obj.FortranLower.dir/ConvertCall.cpp.o -c /var/tmp/portage/dev-lang/llvm-flang-16.0.6/work/flang/lib/Lower/ConvertCall.cpp
#/var/tmp/portage/dev-lang/llvm-flang-16.0.6/work/flang/lib/Lower/ConvertCall.cpp: In member function 'bool {anonymous}::ElementalUserCallBuilder::canLoadActualArgumentBeforeLoop(unsigned int) const':
#/var/tmp/portage/dev-lang/llvm-flang-16.0.6/work/flang/lib/Lower/ConvertCall.cpp:902:17: error: possibly dangling reference to a temporary [-Werror=dangling-reference]
#  902 |     const auto &arg = caller.getPassedArguments()[argIdx];
#      |                 ^~~
#/var/tmp/portage/dev-lang/llvm-flang-16.0.6/work/flang/lib/Lower/ConvertCall.cpp:902:57: note: the temporary was destroyed at the end of the full expression '(&((const {anonymous}::ElementalUserCallBuilder*)this)->{anonymous}::ElementalUserCallBuilder::caller)->Fortran::lower::CallerInterface::<anonymous>.Fortran::lower::CallInterface<Fortran::lower::CallerInterface>::getPassedArguments().llvm::ArrayRef<Fortran::lower::CallInterface<Fortran::lower::CallerInterface>::PassedEntity>::operator[](((size_t)argIdx))'
#  902 |     const auto &arg = caller.getPassedArguments()[argIdx];
#      |                                                         ^
#cc1plus: all warnings being treated as errors
#ninja: build stopped: subcommand failed.

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

# OILEDMACHINE-OVERLAY-STATUS:  passed (16.0.6; 20240305)
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  YES

# Testing:
#cat <<EOF > "hello.f90"
#program hello
#  print *, "hello world"
#end program
#EOF
#/usr/lib/llvm-flang/16/bin/flang-new hello.f90 -L/usr/lib/llvm-flang/16/lib64 -o hello.exe
#LD_LIBRARY_PATH="/usr/lib/llvm-flang/16/lib64" ./hello.exe
