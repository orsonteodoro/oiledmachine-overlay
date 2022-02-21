# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit cmake llvm llvm.org multilib multilib-minimal \
	prefix python-single-r1 toolchain-funcs
inherit flag-o-matic git-r3 ninja-utils

DESCRIPTION="C language family frontend for LLVM"
HOMEPAGE="https://llvm.org/"

# MSVCSetupApi.h: MIT
# sorttable.js: MIT

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA MIT"
SLOT="$(ver_cut 1)"
#KEYWORDS=""  # The hardened default ON patches are in testing.
IUSE="debug default-compiler-rt default-libcxx default-lld
	doc llvm-libunwind +static-analyzer test xml kernel_FreeBSD"
IUSE+=" bolt +bootstrap experimental hardened jemalloc lto pgo pgo_trainer_build_self pgo_trainer_test_suite tcmalloc r5"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
REQUIRED_USE+="
	?? ( jemalloc tcmalloc )
	bolt? ( pgo )
	hardened? ( !test )
	jemalloc? ( bolt )
	pgo? ( || ( pgo_trainer_build_self pgo_trainer_test_suite ) )
	tcmalloc? ( bolt )
"
RESTRICT="!test? ( test )"

RDEPEND="
	~sys-devel/llvm-${PV}:${SLOT}=[debug=,${MULTILIB_USEDEP}]
	bolt? ( ~sys-devel/llvm-${PV}:${SLOT}=[bolt,debug=,${MULTILIB_USEDEP}] )
	static-analyzer? ( dev-lang/perl:* )
	xml? ( dev-libs/libxml2:2=[${MULTILIB_USEDEP}] )
	${PYTHON_DEPS}"

DEPEND="${RDEPEND}
	bolt? (
		jemalloc? ( dev-libs/jemalloc )
		tcmalloc? ( dev-util/google-perftools )
	)
"
BDEPEND="
	>=dev-util/cmake-3.16
	bolt? (
		>=dev-util/perf-4.5
		sys-devel/lld
	)
	doc? ( dev-python/sphinx )
	lto? ( sys-devel/lld )
	pgo? ( sys-devel/lld )
	xml? ( >=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)] )
	${PYTHON_DEPS}"
PDEPEND="
	sys-devel/clang-common
	~sys-devel/clang-runtime-${PV}
	default-compiler-rt? (
		=sys-libs/compiler-rt-${PV%_*}*
		llvm-libunwind? ( sys-libs/llvm-libunwind )
		!llvm-libunwind? ( sys-libs/libunwind )
	)
	default-libcxx? ( >=sys-libs/libcxx-${PV} )
	default-lld? ( sys-devel/lld )"

LLVM_COMPONENTS=( clang clang-tools-extra cmake )
LLVM_MANPAGES=build
LLVM_TEST_COMPONENTS=(
	llvm/lib/Testing/Support
	llvm/lib/Transforms/Hello
	llvm/utils/{lit,llvm-lit,unittest}
	llvm/utils/{UpdateTestChecks,update_cc_test_checks.py}
)
LLVM_PATCHSET=9999-r3
PATCHES_HARDENED=(
	"${FILESDIR}/clang-12.0.1-enable-SSP-by-default.patch"
	"${FILESDIR}/clang-13.0.0_rc2-change-SSP-buffer-size-to-4.patch"
	"${FILESDIR}/clang-14.0.0.9999-set-_FORTIFY_SOURCE-to-2-by-default.patch"
	"${FILESDIR}/clang-12.0.1-enable-full-relro-by-default.patch"
	"${FILESDIR}/clang-12.0.1-version-info.patch"
)
LLVM_USE_TARGETS=llvm
llvm.org_set_globals
#if [[ ${PV} == *.9999 ]] ; then
EGIT_REPO_URI_LLVM_TEST_SUITE="https://github.com/llvm/llvm-test-suite.git"
EGIT_BRANCH_LLVM_TEST_SUITE="release/${SLOT}.x"
EGIT_COMMIT_LLVM_TEST_SUITE="${EGIT_COMMIT_LLVM_TEST_SUITE:-HEAD}"
#else
#SRC_URI+="
#pgo_trainer_test_suite? (
#https://github.com/llvm/llvm-test-suite/archive/refs/tags/llvmorg-${PV/_/-}.tar.gz
#	-> llvm-test-suite-${PV/_/-}.tar.gz
#)
#"
#fi
# llvm-test-suite tarball is disabled until download problems are resolved.

# Multilib notes:
# 1. ABI_* flags control ABIs libclang* is built for only.
# 2. clang is always capable of compiling code for all ABIs for enabled
#    target. However, you will need appropriate crt* files (installed
#    e.g. by sys-devel/gcc and sys-libs/glibc).
# 3. ${CHOST}-clang wrappers are always installed for all ABIs included
#    in the current profile (i.e. alike supported by sys-devel/gcc).
#
# Therefore: use sys-devel/clang[${MULTILIB_USEDEP}] only if you need
# multilib clang* libraries (not runtime, not wrappers).

pkg_setup() {
ewarn
ewarn "This is the experimental modded ebuild."
ewarn
ewarn "For the stable modded ebuild use the ${PN}-${PV}-r2 instead."
ewarn "It is a Work In Progress (WIP) and incomplete."
ewarn
	LLVM_MAX_SLOT=${SLOT} llvm_pkg_setup
	python-single-r1_pkg_setup
	if ! use bootstrap && ! has_version "clang:${SLOT}" ; then
eerror
eerror "Disabling the bootstrap USE flag requires a previous install of"
eerror "clang:${SLOT}.  Enable the bootstrap USE flag to fix this problem."
eerror
		die
	fi
	if tc-is-gcc ; then
		local gcc_slot=$(best_version "sys-devel/gcc" | cut -f 3- -d "-")
		gcc_slot=$(ver_cut 1-3 ${gcc_slot})
		if (( $(ver_cut 1 ${gcc_slot}) != $(gcc-major-version) )) ; then
# Prevent: undefined reference to `std::__throw_bad_array_new_length()'
ewarn
ewarn "Detected not using latest gcc."
ewarn
ewarn "Build may break if highest gcc version not chosen and profile not"
ewarn "sourced.  To fix do the following:"
ewarn
ewarn "  gcc-config -l"
ewarn "  gcc-config ${CHOST}-${gcc_slot}  # must match at least one row from \ "
ewarn "                                   # the above list"
ewarn "  source /etc/profile"
ewarn
		fi
	fi

	if [[ -n "${MAKEOPTS}" ]] ; then
		local nmakeopts=$(echo "${MAKEOPTS}" \
			| grep -o -E -e "-j[ ]*[0-9]+( |$)" \
			| sed -e "s|-j||g" -e "s|[ ]*||")
		if [[ -n "${nmakeopts}" ]] && (( ${nmakeopts} > 1 )) ; then
ewarn
ewarn "MAKEOPTS=-jN should be -j1 if linking with BFD or <= 4 GiB RAM or"
ewarn "<= 3 GiB per core."
ewarn "Adjust your per-package package.env to avoid very long linking times."
ewarn
		fi
	fi

ewarn
ewarn "If you encounter the following during the build:"
ewarn
ewarn "FAILED: lib/Tooling/ASTNodeAPI.json"
ewarn
ewarn "Build ~clang-${PV} with only gcc and ~llvm-${PV} without LTO."
ewarn
ewarn
ewarn "To avoid missing symbols, both clang-${PV} and llvm-${PV} should be"
ewarn "built with the same commit."
ewarn "See \`epkginfo -x sys-devel/clang::oiledmachine-overlay\` or the"
ewarn "metadata.xml to see how to accomplish this."
ewarn

	if [[ "${CC}" == "clang" ]] ; then
		local clang_path="clang-${SLOT}"
		if which "${clang_path}" 2>/dev/null 1>/dev/null && "${clang_path}" --help \
			| grep "symbol lookup error" ; then
eerror
eerror "The bootstrap USE flag must be used or set CC=gcc and CXX=g++"
eerror
			die
		fi
	fi
	if [[ -z "${CC}" || "${CC}" == "gcc" ]] && use pgo && ! use bootstrap; then
eerror
eerror "PGO with bootstrap disable requires clang."
eerror
eerror "Enable the bootstrap USE flag to continue or disable"
eerror "the pgo USE flag."
eerror
		die
	fi

	use pgo && ewarn "The pgo USE flag is a Work In Progress (WIP)"
	use pgo_trainer_build_self && ewarn "The pgo_trainer_build_self has not been tested or is in development."
	use pgo_trainer_test_suite && ewarn "The pgo_trainer_test_suite has not been tested or is in development."
	use bolt && ewarn "The bolt USE flag has not been tested and is in development in the ebuild level.  DO NOT USE."
}

src_unpack() {
	llvm.org_src_unpack
#	if use pgo_trainer_test_suite && [[ ${PV} == *.9999 ]] ; then
	if use pgo_trainer_test_suite ; then
		EGIT_REPO_URI="${EGIT_REPO_URI_LLVM_TEST_SUITE}" \
		EGIT_BRANCH="${EGIT_BRANCH_LLVM_TEST_SUITE}" \
		EGIT_COMMIT="${EGIT_COMMIT_LLVM_TEST_SUITE}" \
		git-r3_fetch
		EGIT_REPO_URI="${EGIT_REPO_URI_LLVM_TEST_SUITE}" \
		EGIT_BRANCH="${EGIT_BRANCH_LLVM_TEST_SUITE}" \
		EGIT_COMMIT="${EGIT_COMMIT_LLVM_TEST_SUITE}" \
		EGIT_CHECKOUT_DIR="${WORKDIR}/test-suite" \
		git-r3_checkout
	fi
}

src_prepare() {
	# create extra parent dir for relative CLANG_RESOURCE_DIR access
	mkdir -p x/y || die
	BUILD_DIR=${WORKDIR}/x/y/clang

	llvm.org_src_prepare
	if use hardened ; then
		ewarn "The hardened USE flag and associated patches are still in testing."
		eapply ${PATCHES_HARDENED[@]}
		if use experimental ; then
			ewarn "The experimental USE flag may break your system."
			ewarn "Patches are totally not recommended if you are not a developer or expert."
			eapply "${FILESDIR}/clang-14.0.0.9999-cross-dso-cfi-link-with-shared.patch"
		fi
		local hardened_features="PIE, SSP, _FORITIFY_SOURCE=2, Full RELRO"
		if use x86 || use amd64 ; then
			eapply "${FILESDIR}/clang-12.0.1-enable-FCP-by-default.patch"
			hardened_features+=", SCP"
		elif use arm64 ; then
			ewarn "arm64 -fstack-clash-protection is not default on.  The feature is still"
			ewarn "in development."
		fi
		ewarn "The Full RELRO default on is in testing."
		sed -i -e "s|__HARDENED_FEATURES__|${hardened_features}|g" \
			lib/Driver/Driver.cpp || die
	fi

	# add Gentoo Portage Prefix for Darwin (see prefix-dirs.patch)
	eprefixify \
		lib/Lex/InitHeaderSearch.cpp \
		lib/Driver/ToolChains/Darwin.cpp || die
}

check_distribution_components() {
	if [[ ${CMAKE_MAKEFILE_GENERATOR} == ninja ]]; then
		local all_targets=() my_targets=() l
		cd "${BUILD_DIR}" || die

		while read -r l; do
			if [[ ${l} == install-*-stripped:* ]]; then
				l=${l#install-}
				l=${l%%-stripped*}

				case ${l} in
					# meta-targets
					clang-libraries|distribution)
						continue
						;;
					# headers for clang-tidy static library
					clang-tidy-headers)
						continue
						;;
					# tools
					clang|clangd|clang-*)
						;;
					# static libraries
					clang*|findAllSymbols)
						continue
						;;
					# conditional to USE=doc
					docs-clang-html|docs-clang-tools-html)
						use doc || continue
						;;
				esac

				all_targets+=( "${l}" )
			fi
		done < <(ninja -t targets all)

		while read -r l; do
			my_targets+=( "${l}" )
		done < <(get_distribution_components $"\n")

		local add=() remove=()
		for l in "${all_targets[@]}"; do
			if ! has "${l}" "${my_targets[@]}"; then
				add+=( "${l}" )
			fi
		done
		for l in "${my_targets[@]}"; do
			if ! has "${l}" "${all_targets[@]}"; then
				remove+=( "${l}" )
			fi
		done

		if [[ ${#add[@]} -gt 0 || ${#remove[@]} -gt 0 ]]; then
			eqawarn "get_distribution_components() is outdated!"
			eqawarn "   Add: ${add[*]}"
			eqawarn "Remove: ${remove[*]}"
		fi
		cd - >/dev/null || die
	fi
}

get_distribution_components() {
	local sep=${1-;}

	local out=(
		# common stuff
		clang-cmake-exports
		clang-headers
		clang-resource-headers
		libclang-headers

		# libs
		clang-cpp
		libclang
	)

	if multilib_is_native_abi; then
		out+=(
			# common stuff
			bash-autocomplete
			libclang-python-bindings

			# tools
			c-index-test
			clang
			clang-format
			clang-offload-bundler
			clang-offload-wrapper
			clang-refactor
			clang-repl
			clang-rename
			clang-scan-deps
			diagtool
			hmaptool

			# extra tools
			clang-apply-replacements
			clang-change-namespace
			clang-doc
			clang-include-fixer
			clang-move
			clang-query
			clang-reorder-fields
			clang-tidy
			clangd
			find-all-symbols
			modularize
			pp-trace
		)

		if llvm_are_manpages_built; then
			out+=(
				# manpages
				docs-clang-man
				docs-clang-tools-man
			)
		fi

		use doc && out+=(
			docs-clang-html
			docs-clang-tools-html
		)

		use static-analyzer && out+=(
			clang-check
			clang-extdef-mapping
			scan-build
			scan-build-py
			scan-view
		)
	fi

	printf "%s${sep}" "${out[@]}"
}

is_late_stage() {
	if [[ "${PGO_PHASE}" =~ ("pgo"|"pg0") ]] ; then
		return 0
	fi
	return 1
}

_cmake_clean() {
	[[ ! -d "${BUILD_DIR}" ]] && return
	cd "${BUILD_DIR}" || die
	if [[ ${CMAKE_MAKEFILE_GENERATOR} == ninja ]]; then
		[[ -e "build.ninja" ]] && eninja -t clean
	else
		[[ -e "Makefile" ]] && emake clean
	fi
}

setup_gcc() {
	# Force gcc to skip a LLVM rebuild without the disabled-peepholes patch.
	export CC=gcc
	export CXX=g++
	autofix_flags # translate retpoline, strip unsupported flags during switch
}

setup_clang() {
	export CC=clang-${SLOT}
	export CXX=clang++-${SLOT}
	autofix_flags # translate retpoline, strip unsupported flags during switch
}

src_configure() { :; }

_configure() {
	einfo "Called _configure()"
	use pgo && einfo "PGO_PHASE=${PGO_PHASE}"
	_cmake_clean
	local llvm_version=$(llvm-config --version) || die
	local clang_version=$(ver_cut 1-3 "${llvm_version}")

	# TODO:  Add GCC-10 and below checks to add exceptions to -O* flag downgrading.
	# Leave a note if you know the commit that fixes the internal compiler error below.
	if tc-is-gcc && ( \
		( ver_test $(gcc-fullversion) -lt 11.2.1_p20220112 ) \
	)
	then
		# Build time bug with gcc 10.3.0, 11.2.0:
		# internal compiler error: maximum number of LRA assignment passes is achieved (30)
		if [[ "${PGO_PHASE}" =~ ("pgv"|"pg0") ]] ; then
			# Apply if using GCC
			ewarn "Detected <=sys-devel/gcc-11.2.1_p20220112.  Downgrading to -Os to avoid bug."
			ewarn "Re-emerge >=sys-devel/gcc-11.2.1_p20220112 for a more optimized build with >= -O2."
			replace-flags '-O3' '-Os'
			replace-flags '-O2' '-Os'
		fi
	fi

	if [[ "${PGO_PHASE}" == "pgv" ]] || tc-is-cross-compiler ; then
		strip-flags
	else
		einfo "Restoring *FLAGS"
		export CFLAGS="${CFLAGS_BAK}"
		export CXXFLAGS="${CXXFLAGS_BAK}"
		export LDFLAGS="${LDFLAGS_BAK}"
	fi

	filter-flags \
		'-flto*' \
		'-fuse-ld*' \
		'-f*reorder-blocks-and-partition' \
		'-Wl,--emit-relocs' \
		'-Wl,-q'

	if [[ "${PGO_PHASE}" == "pg0" ]] ; then
		if use bootstrap ; then
			setup_gcc
		elif [[ "${CC}" == "clang" ]] ; then
			setup_clang
		else
			setup_gcc
		fi
	elif [[ "${PGO_PHASE}" == "pgv" ]] ; then
		setup_gcc
	elif [[ "${PGO_PHASE}" =~ ("pgi"|"pgt"|"pgo"|"bolt") ]] ; then
		setup_clang
	fi

	if use bolt ; then
		append-flags -fno-reorder-blocks-and-partition
		append-ldflags -fno-reorder-blocks-and-partition
	fi

	# LLVM can have very high memory consumption while linking,
	# exhausting the limit on 32-bit linker executable
	use x86 && local -x LDFLAGS="${LDFLAGS} -Wl,--no-keep-memory"

	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"

	filter-flags -m32 -m64 -mx32 -m31 '-mabi=*'
	[[ ${CHOST} =~ "risc" ]] && filter-flags '-march=*'
	export CFLAGS="$(get_abi_CFLAGS ${ABI}) ${CFLAGS}"
	export CXXFLAGS="$(get_abi_CFLAGS ${ABI}) ${CXXFLAGS}"

	einfo
	einfo "*FLAGS for ${ABI}:"
	einfo
	einfo "  CFLAGS=${CFLAGS}"
	einfo "  CXXFLAGS=${CXXFLAGS}"
	einfo "  LDFLAGS=${LDFLAGS}"
	if tc-is-cross-compiler ; then
		einfo "  IS_CROSS_COMPILE=True"
	else
		einfo "  IS_CROSS_COMPILE=False"
	fi
	einfo

	local mycmakeargs=(
		# relative to bindir
		-DCLANG_RESOURCE_DIR="../../../../lib/clang/${clang_version}"

		-DBUILD_SHARED_LIBS=OFF
		-DCLANG_LINK_CLANG_DYLIB=ON
		-DLLVM_DISTRIBUTION_COMPONENTS=$(get_distribution_components)

		-DLLVM_TARGETS_TO_BUILD="${LLVM_TARGETS// /;}"
		-DLLVM_BUILD_TESTS=$(usex test)

		# these are not propagated reliably, so redefine them
		-DLLVM_ENABLE_EH=ON
		-DLLVM_ENABLE_RTTI=ON

		-DCMAKE_DISABLE_FIND_PACKAGE_LibXml2=$(usex !xml)
		# libgomp support fails to find headers without explicit -I
		# furthermore, it provides only syntax checking
		-DCLANG_DEFAULT_OPENMP_RUNTIME=libomp

		# disable using CUDA to autodetect GPU, just build for all
		-DCMAKE_DISABLE_FIND_PACKAGE_CUDA=ON

		# override default stdlib and rtlib
		-DCLANG_DEFAULT_CXX_STDLIB=$(usex default-libcxx libc++ "")
		-DCLANG_DEFAULT_RTLIB=$(usex default-compiler-rt compiler-rt "")
		-DCLANG_DEFAULT_LINKER=$(usex default-lld lld "")
		-DCLANG_DEFAULT_UNWINDLIB=$(usex default-compiler-rt libunwind "")

		-DCLANG_ENABLE_ARCMT=$(usex static-analyzer)
		-DCLANG_ENABLE_STATIC_ANALYZER=$(usex static-analyzer)

		-DPython3_EXECUTABLE="${PYTHON}"
		-DCLANG_DEFAULT_PIE_ON_LINUX=$(usex hardened)
	)
	use test && mycmakeargs+=(
		-DLLVM_MAIN_SRC_DIR="${WORKDIR}/llvm"
		-DLLVM_EXTERNAL_LIT="${BUILD_DIR}/bin/llvm-lit"
		-DLLVM_LIT_ARGS="$(get_lit_flags)"
	)

	if multilib_is_native_abi; then
		local build_docs=OFF
		if llvm_are_manpages_built; then
			build_docs=ON
			mycmakeargs+=(
				-DLLVM_BUILD_DOCS=ON
				-DLLVM_ENABLE_SPHINX=ON
				-DCLANG_INSTALL_SPHINX_HTML_DIR="${EPREFIX}/usr/share/doc/${PF}/html"
				-DCLANG-TOOLS_INSTALL_SPHINX_HTML_DIR="${EPREFIX}/usr/share/doc/${PF}/tools-extra"
				-DSPHINX_WARNINGS_AS_ERRORS=OFF
			)
		fi
		mycmakeargs+=(
			-DLLVM_EXTERNAL_CLANG_TOOLS_EXTRA_SOURCE_DIR="${WORKDIR}"/clang-tools-extra
			-DCLANG_INCLUDE_DOCS=${build_docs}
			-DCLANG_TOOLS_EXTRA_INCLUDE_DOCS=${build_docs}
		)
	else
		mycmakeargs+=(
			-DLLVM_TOOL_CLANG_TOOLS_EXTRA_BUILD=OFF
		)
	fi

	if [[ -n ${EPREFIX} ]]; then
		mycmakeargs+=(
			-DGCC_INSTALL_PREFIX="${EPREFIX}/usr"
		)
	fi

	if tc-is-cross-compiler; then
		[[ -x "/usr/bin/clang-tblgen" ]] \
			|| die "/usr/bin/clang-tblgen not found or usable"
		mycmakeargs+=(
			-DCMAKE_CROSSCOMPILING=ON
			-DCLANG_TABLEGEN=/usr/bin/clang-tblgen
		)
	fi

	local slot=""
	if use pgo ; then
		if [[ "${PGO_PHASE}" =~ ("pgo"|"pg0") ]] ; then
			slot="${SLOT}"
		else
			slot="${PGO_PHASE}"
		fi
	else
		slot="${SLOT}"
	fi
	mycmakeargs+=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${slot}"
		-DCMAKE_INSTALL_MANDIR="${EPREFIX}/usr/lib/llvm/${slot}/share/man"
		-DLLVM_CMAKE_PATH="${EPREFIX}/usr/lib/llvm/${slot}/$(get_libdir)/cmake/llvm"
	)

	if [[ "${PGO_PHASE}" == "pgv" ]] ; then
		mycmakeargs+=(
			-DCMAKE_C_COMPILER=gcc
			-DCMAKE_CXX_COMPILER=g++
			-DCMAKE_ASM_COMPILER=gcc
			-DCOMPILER_RT_BUILD_LIBFUZZER=OFF
			-DCOMPILER_RT_BUILD_SANITIZERS=OFF
			-DCOMPILER_RT_BUILD_XRAY=OFF
			-DLLVM_BUILD_INSTRUMENTED=OFF
			-DLLVM_ENABLE_LTO=Off
		)
	elif [[ "${PGO_PHASE}" == "pgi" ]] ; then
		mycmakeargs+=(
			-DLLVM_BUILD_INSTRUMENTED=ON
			-DLLVM_ENABLE_LTO=Off
			-DLLVM_USE_LINKER=lld
		)
		if use bootstrap ; then
			mycmakeargs+=(
				-DCMAKE_C_COMPILER="${D}/${EPREFIX}/usr/lib/llvm/pgv/bin/clang"
				-DCMAKE_CXX_COMPILER="${D}/${EPREFIX}/usr/lib/llvm/pgv/bin/clang++"
			)
		else
			# Clang PGO flags only
			mycmakeargs+=(
				-DCMAKE_C_COMPILER="clang"
				-DCMAKE_CXX_COMPILER="clang++"
			)
		fi
	elif [[ "${PGO_PHASE}" == "pgt_build_self" ]] ; then
		# Use the package itself as the asset for training.
		mycmakeargs+=(
			-DCMAKE_C_COMPILER="${D}/${EPREFIX}/usr/lib/llvm/pgi/bin/clang"
			-DCMAKE_CXX_COMPILER="${D}/${EPREFIX}/usr/lib/llvm/pgi/bin/clang++"
			-DLLVM_BUILD_INSTRUMENTED=OFF
			-DLLVM_ENABLE_LTO=Off
			-DLLVM_USE_LINKER=lld
		)
	elif [[ "${PGO_PHASE}" =~ ("pgt_test_suite_inst"|"bolt_train_test_suite_inst") ]] ; then
		if [[ "${PGO_PHASE}" == "pgt_test_suite_inst" ]] ; then
			mycmakeargs+=(
				-DCMAKE_C_COMPILER="${D}/${EPREFIX}/usr/lib/llvm/pgi/bin/clang"
				-DCMAKE_CXX_COMPILER="${D}/${EPREFIX}/usr/lib/llvm/pgi/bin/clang++"
			)
		elif [[ "${PGO_PHASE}" == "bolt_train_test_suite_inst" ]] ; then
			mycmakeargs+=(
				-DCMAKE_C_COMPILER="${D}/${EPREFIX}/usr/lib/llvm/pgo/bin/clang"
				-DCMAKE_CXX_COMPILER="${D}/${EPREFIX}/usr/lib/llvm/pgo/bin/clang++"
			)
		fi
		mycmakeargs+=(
			-DLLVM_BUILD_INSTRUMENTED=OFF
			-DLLVM_ENABLE_LTO=Off
			-DLLVM_USE_LINKER=lld
			-DTEST_SUITE_BENCHMARKING_ONLY=ON
			-DTEST_SUITE_PROFILE_GENERATE=ON
			-DTEST_SUITE_RUN_TYPE=Train
		)
	elif [[ "${PGO_PHASE}" =~ ("pgt_test_suite_opt"|"bolt_train_test_suite_opt") ]] ; then
		if [[ "${PGO_PHASE}" == "pgt_test_suite_opt" ]] ; then
			mycmakeargs+=(
				-DCMAKE_C_COMPILER="${D}/${EPREFIX}/usr/lib/llvm/pgi/bin/clang"
				-DCMAKE_CXX_COMPILER="${D}/${EPREFIX}/usr/lib/llvm/pgi/bin/clang++"
			)
		elif [[ "${PGO_PHASE}" == "bolt_train_test_suite_opt" ]] ; then
			mycmakeargs+=(
				-DCMAKE_C_COMPILER="${D}/${EPREFIX}/usr/lib/llvm/pgo/bin/clang"
				-DCMAKE_CXX_COMPILER="${D}/${EPREFIX}/usr/lib/llvm/pgo/bin/clang++"
			)
		fi
		mycmakeargs+=(
			-DLLVM_BUILD_INSTRUMENTED=OFF
			-DLLVM_ENABLE_LTO=Off
			-DLLVM_USE_LINKER=lld
			-DTEST_SUITE_PROFILE_GENERATE=OFF
			-DTEST_SUITE_PROFILE_USE=ON
			-DTEST_SUITE_RUN_TYPE=ref
		)
	elif [[ "${PGO_PHASE}" == "pgo" ]] ; then
		einfo "Merging .profraw -> .profdata"
		if use bootstrap ; then
			"${D}/${EPREFIX}/usr/lib/llvm/pgv/bin/llvm-profdata" merge \
				-output="${T}/pgo-custom.profdata" "${T}/pgt/profiles/"*
			mycmakeargs+=(
				-DCMAKE_C_COMPILER="${D}/${EPREFIX}/usr/lib/llvm/pgv/bin/clang"
				-DCMAKE_CXX_COMPILER="${D}/${EPREFIX}/usr/lib/llvm/pgv/bin/clang++"
			)
		else
			llvm-profdata merge -output="${T}/pgo-custom.profdata" "${T}/pgt/profiles/"*
			mycmakeargs+=(
				-DCMAKE_C_COMPILER="clang"
				-DCMAKE_CXX_COMPILER="clang++"
			)
		fi
		append-ldflags -Wl,--emit-relocs
		mycmakeargs+=(
			-DLLVM_BUILD_INSTRUMENTED=OFF
			-DLLVM_ENABLE_LTO=$(usex lto "Thin" "Off")
			-DLLVM_PROFDATA_FILE="${T}/pgo-custom.profdata"
			-DLLVM_USE_LINKER=lld
		)
	elif [[ "${PGO_PHASE}" == "bolt_train_build_self" ]] ; then
		mycmakeargs+=(
			-DCMAKE_C_COMPILER="${D}/${EPREFIX}/usr/lib/llvm/pgo/bin/clang"
			-DCMAKE_CXX_COMPILER="${D}/${EPREFIX}/usr/lib/llvm/pgo/bin/clang++"
			-DLLVM_BUILD_INSTRUMENTED=OFF
			-DLLVM_ENABLE_LTO=$(usex lto "Thin" "Off")
			-DLLVM_USE_LINKER=lld
		)
	elif [[ "${PGO_PHASE}" == "pg0" ]] ; then
		if [[ "${CC}" =~ "clang" ]] ; then
			mycmakeargs+=(
				-DLLVM_ENABLE_LTO=$(usex lto "Thin" "Off")
				-DLLVM_USE_LINKER=lld
			)
		elif [[ -z "${CC}" || "${CC}" =~ "gcc" ]] ; then
			mycmakeargs+=(
				-DLLVM_ENABLE_LTO=$(usex lto "On" "Off")
			)
		fi
	fi

	if [[ "${PGO_PHASE}" =~ "pgt_test_suite" ]] ; then
		CMAKE_USE_DIR="${WORKDIR}/test-suite"
		BUILD_DIR_BAK="${BUILD_DIR}"
		BUILD_DIR="${WORKDIR}/test-suite_build_${ABI}"
		mkdir -p "${BUILD_DIR}" || die
		cd "${BUILD_DIR}" || die
		[[ "${PGO_PHASE}" == "pgt_test_suite_opt" ]] && _cmake_clean
		cmake_src_configure
		CMAKE_USE_DIR="${WORKDIR}/llvm"
		BUILD_DIR="${BUILD_DIR_BAK}"
		cd "${BUILD_DIR}" || die
	fi

	cmake_src_configure

	multilib_is_native_abi && check_distribution_components
}

_bolt_train_build_self() {
	einfo "Called _bolt_train_build_self()"
	# Use the package itself as the asset for training.
	einfo "Running BOLT trainer to build self"
	mkdir -p "${T}/bolt-profile" || die
	perf record -e cycles:u -j any,u -o "${T}/bolt-profile/clang-${SLOT}_build_self.perfdata" -- ninja clang || die
}

_bolt_train_test_suite() {
	local tag="${1}"
	shift
	einfo "Called _bolt_train_test_suite()"
	# Use the package itself as the asset for training.
	einfo "Running BOLT trainer to build test suite (tag: ${tag}, ninja args: ${@})"
	mkdir -p "${T}/bolt-profile" || die
	perf record -e cycles:u -j any,u -o "${T}/bolt-profile/clang-${SLOT}_test_suite_${tag}.perfdata" -- ninja ${@} || die
}

_bolt_profile_generator_build_self() {
	einfo "Called _bolt_profile_generator_build_self()"
	einfo "perf profile -> bolt profile"
	perf2bolt "${D}/${EPREFIX}/usr/lib/llvm/pgo/bin/clang-${SLOT}" \
		-p "${T}/bolt-profile/clang-${SLOT}_build_self.perfdata" \
		-o "${T}/bolt-profile/clang-${SLOT}_build_self.fdata" \
		-w "${T}/bolt-profile/clang-${SLOT}_build_self.yaml" || die
}

_bolt_profile_generator_test_suite() {
	local tag="${1}"
	einfo "Called _bolt_profile_generator_test_suite()"
	einfo "perf profile -> bolt profile"
	perf2bolt "${D}/${EPREFIX}/usr/lib/llvm/pgo/bin/clang-${SLOT}" \
		-p "${T}/bolt-profile/clang-${SLOT}_test_suite_${tag}.perfdata" \
		-o "${T}/bolt-profile/clang-${SLOT}_test_suite_${tag}.fdata" \
		-w "${T}/bolt-profile/clang-${SLOT}_test_suite_${tag}.yaml" || die
}

_bolt_merge_profiles() {
	local abis=($(multilib_get_enabled_abi_pairs))
	local ABI
	for ABI in ${abis[@]#*.} ; do
		# For LLVM lib
		merge-fdata "${T}/bolt-profile/"*${ABI}*.fdata > "${T}/bolt-profile/clang-${SLOT}-merged-${ABI}.fdata" || die
	done
	# For DEFAULT_ABI clang{,++}
	merge-fdata "${T}/bolt-profile/clang-${SLOT}-merged-"*.fdata > "${T}/bolt-profile/clang-${SLOT}-merged-all.fdata" || die
}

_bolt_optimize_file() {
	local f="${1}"
	einfo "Called _bolt_optimize_file() for ${f}"

	local args=(
		"${f}"
		-o "${f}.bolt"
		-reorder-blocks=cache+
		-reorder-functions=hfsort+
		-split-functions=3
		-split-all-cold
		-dyno-stats
		-icf=1
		-use-gnu-stack
	)

	# Find the ABI.
	local ABI=""
	if [[ "${f}" == "/bin/" ]] ; then
		ABI="${DEFAULT_ABI}"
	else
		local abis=($(multilib_get_enabled_abi_pairs))
		local found_abi=
		for ABI in ${abis[@]#*.} ; do
			[[ "${f}" =~ "/${SLOT}/$(get_libdir)/" ]] && break
		done
	fi

	[[ -z "${ABI}" ]] && return

	if [[ "${f}" =~ "/${SLOT}/$(get_libdir)/" ]] ; then
		args+=(
			-data="${T}/bolt-profile/clang-${SLOT}-merged-${ABI}.fdata"
		)
	elif [[ "${f}" =~ "/bin/" ]] ; then
		# It can be -all or -${ABI} but /bin/* is DEFAULT_ABI.
		args+=(
			-data="${T}/bolt-profile/clang-${SLOT}-merged-all.fdata"
		)
	else
		ewarn "${f} is not part of lib* or bin.  Skipping."
		return
	fi

	if use jemalloc ; then
		LD_PRELOAD="/usr/$(get_libdir ${DEFAULT_ABI})/libjemalloc.so" llvm-bolt ${args[@]} || die
	elif use tcmalloc ; then
		if [[ -e "/usr/$(get_libdir ${DEFAULT_ABI})/libtcmalloc_minimal.so" ]] ; then
			LD_PRELOAD="/usr/$(get_libdir ${DEFAULT_ABI})/libtcmalloc_minimal.so" llvm-bolt ${args[@]} || die
		else
			LD_PRELOAD="/usr/$(get_libdir ${DEFAULT_ABI})/libtcmalloc.so" llvm-bolt ${args[@]} || die
		fi
	else
		llvm-bolt ${args[@]} || true
	fi

	[[ -e "${f}.bolt" ]] && mv "${f}{.bolt,}" || die
}

_cleanup() {
	einfo "Called _cleanup()"
	for PGO_PHASE in \
		"pgv" \
		"pgi" \
		"pgt_build_self" \
		"pgt_test_suite_inst" \
		"pgt_test_suite_train" \
		"pgt_test_suite_opt" ; do
		rm -rf "${D}/usr/lib/llvm/${PGO_PHASE}" || die
	done
}

declare -Ax EMESSAGE_COMPILE=(
	[pgv]="Building vanilla ${PN}"
	[pgi]="Building instrumented ${PN}"
	[pgt_build_self]="Running PGO trainer:  Build itself"
	[pgt_test_suite_inst]="Running PGO trainer:   test-suite instrumenting"
	[pgt_test_suite_train]="Running PGO trainer:   test-suite training"
	[pgt_test_suite_opt]="Running PGO trainer:   test-suite optimization"
	[pgo]="Building PGOed ${PN}"
	[bolt]="Running BOLT trainer"
)

_compile() {
	einfo "Called _compile()"
	cd "${BUILD_DIR}" || die
	if [[ "${PGO_PHASE}" =~ ("pgv"|"pgi"|"pgt_"|"pgo"|"bolt") ]] ; then
		use pgo && einfo "${EMESSAGE_COMPILE[${PGO_PHASE}]} for ${ABI}"
	fi
	if [[ "${PGO_PHASE}" == "bolt_train_build_self" ]] ; then
		_bolt_train_build_self
		_bolt_profile_generator_build_self
	elif [[ "${PGO_PHASE}" =~ ("pgt_test_suite_inst"|"bolt_train_test_suite_inst") ]] ; then
		CMAKE_USE_DIR="${WORKDIR}/test-suite"
		BUILD_DIR_BAK="${BUILD_DIR}"
		BUILD_DIR="${WORKDIR}/test-suite_build_${ABI}"
		cd "${BUILD_DIR}" || die
		# Profile the PGI step
		if [[ "${PGO_PHASE}" == "pgt_test_suite_inst" ]] ; then
			cmake_build
		else
			_bolt_train_test_suite "bolt_train_test_suite_inst_${ABI}"
		fi
		BUILD_DIR="${BUILD_DIR_BAK}"
		cd "${BUILD_DIR}" || die
	elif [[ "${PGO_PHASE}" =~ ("pgt_test_suite_train"|"bolt_train_test_suite_train") ]] ; then
		CMAKE_USE_DIR="${WORKDIR}/test-suite"
		BUILD_DIR_BAK="${BUILD_DIR}"
		BUILD_DIR="${WORKDIR}/test-suite_build_${ABI}"
		cd "${BUILD_DIR}" || die
		if [[ "${PGO_PHASE}" == "pgt_test_suite_train" ]] ; then
			cmake_build check-lit
			"${BUILD_DIR_BAK}/bin/llvm-lit" .
		else
			_bolt_train_test_suite "bolt_train_test_suite_train_${ABI}_check_lit" check_list
			"${BUILD_DIR_BAK}/bin/llvm-lit" .
		fi
		BUILD_DIR="${BUILD_DIR_BAK}"
		cd "${BUILD_DIR}" || die
	elif [[ "${PGO_PHASE}" =~ ("pgt_test_suite_opt"|"bolt_train_test_suite_opt") ]] ; then
		CMAKE_USE_DIR="${WORKDIR}/test-suite"
		BUILD_DIR_BAK="${BUILD_DIR}"
		BUILD_DIR="${WORKDIR}/test-suite_build_${ABI}"
		cd "${BUILD_DIR}" || die
		# Profile the PGO step
		if [[ "${PGO_PHASE}" == "pgt_test_suite_opt" ]] ; then
			cmake_build
			cmake_build check-lit
			"${BUILD_DIR_BAK}/bin/llvm-lit" -o result.json .
		else
			_bolt_train_test_suite "bolt_train_test_suite_opt_${ABI}"
			_bolt_train_test_suite "bolt_train_test_suite_opt_${ABI}_check_lit" check_list
			"${BUILD_DIR_BAK}/bin/llvm-lit" -o result.json .
		fi
		BUILD_DIR="${BUILD_DIR_BAK}"
		cd "${BUILD_DIR}" || die
	else
		# Includes pgt_build_self
		cmake_build distribution
	fi

	# provide a symlink for tests
	if [[ ! -L ${WORKDIR}/lib/clang ]]; then
		mkdir -p "${WORKDIR}"/lib || die
		ln -s "${BUILD_DIR}/$(get_libdir)/clang" "${WORKDIR}"/lib/clang || die
	fi
}

# Modularize for variable scoping
_pgo_train() {
	local abis=($(multilib_get_enabled_abi_pairs))
	local ABI
	for ABI in ${abis[@]#*.} ; do
		if use pgt_trainer_build_self && multilib_is_native_abi ; then
			PGO_PHASE="pgt_build_self" # S2 upstream says without lto
			_configure
			_compile
		fi
		if use pgt_trainer_test_suite ; then
			PGO_PHASE="pgt_test_suite_inst"
			_configure
			_compile
			PGO_PHASE="pgt_test_suite_train"
			_configure
			_compile
			PGO_PHASE="pgt_test_suite_opt"
			_configure
			_compile
		fi
	done
}

# Modularize for variable scoping
_bolt_train() {
	local abis=($(multilib_get_enabled_abi_pairs))
	if use bolt ; then
		local ABI
		for ABI in ${abis[@]#*.} ; do
			if use pgt_trainer_build_self && multilib_is_native_abi ; then
				PGO_PHASE="bolt_train_build_self" # S3
				_configure
				_compile
			fi
			if use pgt_trainer_test_suite ; then
				PGO_PHASE="bolt_train_test_suite_inst"
				_configure
				_compile
				PGO_PHASE="bolt_train_test_suite_train"
				_configure
				_compile
				PGO_PHASE="bolt_train_test_suite_opt"
				_configure
				_compile
			fi
		done
	fi
}

src_compile() {
	export CFLAGS_BAK="${CFLAGS}"
	export CXXFLAGS_BAK="${CXXFLAGS}"
	export LDFLAGS_BAK="${LDFLAGS}"
	compile_abi() {
		# See https://github.com/llvm/llvm-project/blob/main/bolt/docs/OptimizingClang.md#bootstrapping-clang-7-with-pgo-and-lto
		if use pgo || use bolt ; then
			if multilib_is_native_abi ; then
				if use bootstrap ; then
					PGO_PHASE="pgv" # S1
					_configure
					_compile
					_install
				fi
				PGO_PHASE="pgi" # S2
				_configure
				_compile
				_install
				_pgo_train
				PGO_PHASE="pgo" # S2 upstream says with lto
				_configure
				_compile
				_install
				_bolt_train
			else
				PGO_PHASE="pg0" # N0 PGO
				_configure
				_compile
			fi
			_cleanup
		else
			PGO_PHASE="pg0" # N0 PGO
			_configure
			_compile
		fi
	}
	multilib_foreach_abi compile_abi
	unset PGO_PHASE
}

multilib_src_test() {
	if use hardened ; then
ewarn "Tests are broken with the enable-SSP-and-PIE-by-default.patch"
	fi
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	cmake_build check-clang
	multilib_is_native_abi &&
		cmake_build check-clang-tools check-clangd
}

src_install() {
	MULTILIB_WRAPPED_HEADERS=(
		/usr/include/clang/Config/config.h
	)

	if use bolt ; then
		# Complete optimization
		_bolt_merge_profiles
		# All binaries involved in building down the process tree should be added.
		local f
		for f in $(find "${ED}") ; do
			f=$(readlink -f "${f}")
			local is_exe=0
			local is_so=0
			file "${f}" 2>/dev/null | grep -q -E -e "ELF.*executable" && is_exe=1
			file "${f}" 2>/dev/null | grep -q -E -e "ELF.*shared object" && is_so=1
			if (( ${is_exe} == 1 || ${is_so} == 1 )) ; then
				if grep -q -e $(basename "${f}") "${T}/bolt-profile" ; then
					_bolt_optimize_file "${f}"
				else
					einfo "Skipping "$(basename "${f}")" because it was not BOLT profiled."
				fi
			fi
		done
	fi

	multilib-minimal_src_install

	# Move runtime headers to /usr/lib/clang, where they belong
	mv "${ED}"/usr/include/clangrt "${ED}"/usr/lib/clang || die
	# move (remaining) wrapped headers back
	mv "${ED}"/usr/include "${ED}"/usr/lib/llvm/${SLOT}/include || die

	# Apply CHOST and version suffix to clang tools
	# note: we use two version components here (vs 3 in runtime path)
	local llvm_version=$(llvm-config --version) || die
	local clang_version=$(ver_cut 1 "${llvm_version}")
	local clang_full_version=$(ver_cut 1-3 "${llvm_version}")
	local clang_tools=( clang clang++ clang-cl clang-cpp )
	local abi i

	# cmake gives us:
	# - clang-X
	# - clang -> clang-X
	# - clang++, clang-cl, clang-cpp -> clang
	# we want to have:
	# - clang-X
	# - clang++-X, clang-cl-X, clang-cpp-X -> clang-X
	# - clang, clang++, clang-cl, clang-cpp -> clang*-X
	# also in CHOST variant
	for i in "${clang_tools[@]:1}"; do
		rm "${ED}/usr/lib/llvm/${SLOT}/bin/${i}" || die
		dosym "clang-${clang_version}" "/usr/lib/llvm/${SLOT}/bin/${i}-${clang_version}"
		dosym "${i}-${clang_version}" "/usr/lib/llvm/${SLOT}/bin/${i}"
	done

	# now create target symlinks for all supported ABIs
	for abi in $(get_all_abis); do
		local abi_chost=$(get_abi_CHOST "${abi}")
		for i in "${clang_tools[@]}"; do
			dosym "${i}-${clang_version}" \
				"/usr/lib/llvm/${SLOT}/bin/${abi_chost}-${i}-${clang_version}"
			dosym "${abi_chost}-${i}-${clang_version}" \
				"/usr/lib/llvm/${SLOT}/bin/${abi_chost}-${i}"
		done
	done
}

declare -Ax EMESSAGE_INSTALL=(
	[pgv]="vanilla ${PN}"
	[pgi]="instrumented ${PN}"
	[pgo]="PGOed ${PN}"
)

_install() {
	einfo "Called _install()"
	cd "${BUILD_DIR}" || die
	DESTDIR=${D} cmake_build install-distribution

	local slot
	if [[ "${PGO_PHASE}" =~ ("pgv"|"pgi") ]] ; then
		einfo "Installing sandboxed image of ${EMESSAGE_INSTALL[${PGO_PHASE}]} for ${ABI}"
		slot="${PGO_PHASE}"
	elif [[ "${PGO_PHASE}" =~ ("pgo") ]] ; then
		einfo "Installing sandboxed image of ${EMESSAGE_INSTALL[${PGO_PHASE}]} for ${ABI}"
		slot="${SLOT}"
	else
		einfo "Installing final image for ${ABI}"
		slot="${SLOT}"
	fi

	# move headers to /usr/include for wrapping & ABI mismatch checks
	# (also drop the version suffix from runtime headers)
	rm -rf "${ED}"/usr/include || die
	mv "${ED}"/usr/lib/llvm/${slot}/include "${ED}"/usr/include || die
	mv "${ED}"/usr/lib/llvm/${slot}/$(get_libdir)/clang "${ED}"/usr/include/clangrt || die
}

multilib_src_install() {
	_install
}

multilib_src_install_all() {
	python_fix_shebang "${ED}"
	if use static-analyzer; then
		python_optimize "${ED}"/usr/lib/llvm/${SLOT}/share/scan-view
	fi

	docompress "/usr/lib/llvm/${SLOT}/share/man"
	llvm_install_manpages
	# match 'html' non-compression
	use doc && docompress -x "/usr/share/doc/${PF}/tools-extra"
	# +x for some reason; TODO: investigate
	use static-analyzer && fperms a-x "/usr/lib/llvm/${SLOT}/share/man/man1/scan-build.1"

	if use bolt ; then
		# Save the BOLT profile to BOLT optimize the libraries in the sys-devel/llvm package.
		local bolt_profile_dir="/usr/share/${PN}/${SLOT}"
		dodir "${bolt_profile_dir}"
		doins -r "${T}/bolt-profile"

		# Fingerprint the llvm library
		local llvm_so_path=$(readlink -f "${D}/${EPREFIX}/usr/lib/llvm/${SLOT}/$(get_libdir)/libLLVM.so")
		[[ -e "${llvm_so_path}" ]] || die
		local llvm_so_sha256=$(sha256sum "${llvm_so_path}" | cut -f 1 -d " ")
		echo "${llvm_so_sha256}" \
			> "${D}/${EPREFIX}${bolt_profile_dir}/llvm-fingerprint-${llvm_so_sha256:0:7}" || die
		local llvm_best_version=$(best_version "sys-devel/llvm:${SLOT}")
		echo "${llvm_best_version}" | sed -e "s|sys-devel/llvm-||g" \
			> "${D}/${EPREFIX}${bolt_profile_dir}/llvm-version" || die
		if [[ "${llvm_best_version}" =~ ".9999" ]] ; then
			local commit_id=$(bzcat $(realpath /var/db/pkg/${llvm_best_version}/environment.bz2) \
				| grep -e "-x EGIT_VERSION" | cut -f 2 -d "\"")
			echo "${commit_id}" > "${D}/${EPREFIX}${bolt_profile_dir}/llvm-commit" || die
		fi
	fi
}

pkg_postinst() {
	if [[ -z ${ROOT} && -f ${EPREFIX}/usr/share/eselect/modules/compiler-shadow.eselect ]] ; then
		eselect compiler-shadow update all
	fi

	elog "You can find additional utility scripts in:"
	elog "  ${EROOT}/usr/lib/llvm/${SLOT}/share/clang"
	elog "Some of them are vim integration scripts (with instructions inside)."
	elog "The run-clang-tidy.py script requires the following additional package:"
	elog "  dev-python/pyyaml"
}

pkg_postrm() {
	if [[ -z ${ROOT} && -f ${EPREFIX}/usr/share/eselect/modules/compiler-shadow.eselect ]] ; then
		eselect compiler-shadow clean all
	fi
}
