# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
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
		EGIT_OVERRIDE_COMMIT_LLVM_LLVM_PROJECT="${LLVM_EBUILDS_LLVM20_FALLBACK_COMMIT}"
		EGIT_BRANCH="${LLVM_EBUILDS_LLVM20_BRANCH}"
	fi
}
_llvm_set_globals
unset -f _llvm_set_globals

CMAKE_ECLASS="cmake"
FLAG_O_MATIC_STRIP_UNSUPPORTED_FLAGS=1
GCC_SLOT=13
LLVM_MAX_SLOT=${LLVM_MAJOR}
PYTHON_COMPAT=( "python3_12" )

inherit check-compiler-switch cmake-multilib flag-o-matic llvm.org llvm-utils python-any-r1 toolchain-funcs

SRC_URI+="
"

DESCRIPTION="Parallel STL is an implementation of the C++ standard library algorithms with support for execution policies"
HOMEPAGE="https://github.com/llvm/llvm-project/tree/main/pstl"
LICENSE="
	Apache-2.0-with-LLVM-exceptions
	|| (
		MIT
		UoI-NCSA
	)
"
RESTRICT="
	!test? (
		test
	)
"
SLOT="${PV%%.*}"
IUSE+="
${LLVM_EBUILDS_LLVM20_REVISION}
-openmp -tbb test
ebuild_revision_2
"
RDEPEND="
	openmp? (
		llvm-runtimes/openmp:${LLVM_MAJOR}
	)
	tbb? (
		dev-cpp/tbb
	)
"
DEPEND="
	${RDEPEND}
	llvm-core/llvm:${LLVM_MAJOR}
"
BDEPEND+="
	>=dev-build/cmake-3.20.0
	>=sys-devel/gcc-${GCC_SLOT}
	test? (
		$(python_gen_any_dep '
			dev-python/lit[${PYTHON_USEDEP}]
		')
		>=llvm-core/clang-3.9.0
	)
"
PATCHES=(
)
LLVM_COMPONENTS=(
	"pstl"
	"cmake"
)
llvm.org_set_globals

python_check_deps() {
	use test || return 0
	python_has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

get_lib_types() {
	echo "shared"
}

pkg_setup() {
	check-compiler-switch_start
	python-any-r1_pkg_setup
}

src_prepare() {
	llvm.org_src_prepare
}

src_configure() {
	llvm_prepend_path "${LLVM_MAJOR}"

	configure_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			_configure_abi
		done
	}
	multilib_foreach_abi configure_abi
}

_configure_abi() {
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export CPP=$(tc-getCPP)

	if tc-is-clang ; then
		if ! has_version "llvm-core/clang:${SLOT_MAJOR}" ; then
eerror
eerror "You must emerge clang:${SLOT_MAJOR} to build with clang."
eerror
		fi
		export CC="${CHOST}-clang-${SLOT_MAJOR}"
		export CXX="${CHOST}-clang++-${SLOT_MAJOR}"
		export CPP="${CC} -E"
		strip-unsupported-flags
	fi

	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

einfo "CC:\t${CC}"
einfo "CXX:\t${CXX}"

	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DCMAKE_CXX_COMPILER_TARGET="${CHOST}"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}"
		-DCMAKE_SHARED_LINKER_FLAGS="${LDFLAGS}"
		-DPython3_EXECUTABLE="${PYTHON}"
		-DLLVM_INCLUDE_TESTS=OFF
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
		-DPSTL_PARALLEL_BACKEND=$(usex tbb "tbb" $(usex openmp "omp" "serial"))
	)

	if use test; then
		local clang_path=$(type -P "${CHOST:+${CHOST}-}clang" 2>/dev/null)
		[[ -n ${clang_path} ]] || die "Unable to find ${CHOST}-clang for tests"

		mycmakeargs+=(
			-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
			-DLLVM_LIT_ARGS="$(get_lit_flags)"
			-DPython3_EXECUTABLE="${PYTHON}"
		)
	fi
	cmake_src_configure
}

src_compile() {
	compile_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${BUILD_DIR}" || die
			cmake_src_compile
		done
	}
	multilib_foreach_abi compile_abi
}

src_test() {
	test_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${BUILD_DIR}" || die
			local -x LIT_PRESERVES_TMP=1
			cmake_build check-pstl
		done
	}
	multilib_foreach_abi test_abi
}

src_install() {
	install_abi() {
		local lib_type
		for lib_type in $(get_lib_types) ; do
			export BUILD_DIR="${S}-${MULTILIB_ABI_FLAG}.${ABI}_${lib_type}_build"
			cd "${BUILD_DIR}" || die
			cmake_src_install
		done
		multilib_check_headers
	}
	multilib_foreach_abi install_abi
}

pkg_postinst() {
	:
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  ebuild, hardened-flags-patch
