# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit cmake llvm.org multilib-minimal pax-utils python-any-r1 \
	toolchain-funcs
inherit flag-o-matic git-r3 ninja-utils

DESCRIPTION="Low Level Virtual Machine"
HOMEPAGE="https://llvm.org/"

# Additional licenses:
# 1. OpenBSD regex: Henry Spencer's license ('rc' in Gentoo) + BSD.
# 2. xxhash: BSD.
# 3. MD5 code: public-domain.
# 4. ConvertUTF.h: TODO.

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA BSD public-domain rc"
SLOT="$(ver_cut 1)"
KEYWORDS=""
IUSE="+binutils-plugin debug doc exegesis libedit +libffi ncurses test xar xml z3"
IUSE+=" bolt bolt-prepare +bootstrap -dump jemalloc lto pgo pgo_trainer_build_self
pgo_trainer_test_suite tcmalloc r4"
REQUIRED_USE="
	bolt-prepare? ( bolt )
	jemalloc? ( bolt )
	pgo? ( || ( pgo_trainer_build_self pgo_trainer_test_suite ) )
	pgo_trainer_build_self? ( pgo )
	pgo_trainer_test_suite? ( pgo )
	tcmalloc? ( bolt )
"
PROPERTIES="live"
RESTRICT="!test? ( test )"

RDEPEND="
	sys-libs/zlib:0=[${MULTILIB_USEDEP}]
	binutils-plugin? ( >=sys-devel/binutils-2.31.1-r4:*[plugins] )
	bolt? ( >=dev-util/perf-4.5 )
	exegesis? ( dev-libs/libpfm:= )
	libedit? ( dev-libs/libedit:0=[${MULTILIB_USEDEP}] )
	libffi? ( >=dev-libs/libffi-3.0.13-r1:0=[${MULTILIB_USEDEP}] )
	ncurses? ( >=sys-libs/ncurses-5.9-r3:0=[${MULTILIB_USEDEP}] )
	xar? ( app-arch/xar )
	xml? ( dev-libs/libxml2:2=[${MULTILIB_USEDEP}] )
	z3? ( >=sci-mathematics/z3-4.7.1:0=[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	binutils-plugin? ( sys-libs/binutils-libs )
	bolt? (
		jemalloc? ( dev-libs/jemalloc )
		tcmalloc? ( dev-util/google-perftools )
	)
"
BDEPEND="
	dev-lang/perl
	>=dev-util/cmake-3.16
	sys-devel/gnuconfig
	bolt? (
		>=dev-util/perf-4.5
		sys-devel/lld
	)
	kernel_Darwin? (
		<sys-libs/libcxx-$(ver_cut 1-3).9999
		>=sys-devel/binutils-apple-5.1
	)
	doc? ( $(python_gen_any_dep '
		dev-python/recommonmark[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	') )
	libffi? ( >=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)] )
	lto? ( sys-devel/lld )
	pgo? ( sys-devel/lld )
	${PYTHON_DEPS}"
# There are no file collisions between these versions but having :0
# installed means llvm-config there will take precedence.
RDEPEND="${RDEPEND}
	!sys-devel/llvm:0"
PDEPEND="sys-devel/llvm-common
	binutils-plugin? ( >=sys-devel/llvmgold-${SLOT} )
"
PATCHES=(
	"${FILESDIR}/llvm-14.0.0.9999-stop-triple-spam.patch"
)

LLVM_COMPONENTS=( llvm bolt cmake third-party )
LLVM_MANPAGES=build
LLVM_PATCHSET=9999-r3
LLVM_USE_TARGETS=provide
llvm.org_set_globals
#if [[ ${PV} == *.9999 ]] ; then
EGIT_REPO_URI_LLVM_TEST_SUITE="https://github.com/llvm/llvm-test-suite.git"
#if [[ ${PV} == 15.* ]] ; then
EGIT_BRANCH_LLVM_TEST_SUITE="release/main"
EGIT_COMMIT_LLVM_TEST_SUITE="${EGIT_COMMIT_LLVM_TEST_SUITE:-HEAD}"
#else
#EGIT_BRANCH_LLVM_TEST_SUITE="release/${SLOT}.x"
#EGIT_COMMIT_LLVM_TEST_SUITE="${EGIT_COMMIT_LLVM_TEST_SUITE:-HEAD}"
#fi
#else
#SRC_URI+="
#pgo_trainer_test_suite? (
#https://github.com/llvm/llvm-test-suite/archive/refs/tags/llvmorg-${PV/_/-}.tar.gz
#	-> llvm-test-suite-${PV/_/-}.tar.gz
#)
#"
#fi
# llvm-test-suite tarball is disabled until download problems are resolved.

pkg_setup() {
	python_setup
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
	if use pgo ; then
		if ! has_version ">=clang-${PV}:${SLOT}" ; then
# Many of these problems (extra ebuild code, overbuilding, overchecking) would"
# have been avoided if this was a monolithic package.
eerror
eerror "PGO requires >=clang-${PV}:${SLOT} be installed because build scripts"
eerror "can only use the clang PGO only compiler flags."
eerror
			die
		fi
	fi
	use pgo && ewarn "The pgo USE flag is a Work In Progress (WIP)"
	use pgo_trainer_build_self && ewarn "The pgo_trainer_build_self USE flag has not been tested."
	use pgo_trainer_test_suite && ewarn "The pgo_trainer_test_suite USE flag has not been tested."

	if use bolt ; then
		if perf record -e cpu-clock -j any -o /dev/null -- ls \
			| grep -q -e "PMU Hardware doesn't support sampling/overflow-interrupts" ; then
eerror
eerror "Your CPU needs LBR (Last Branch Record) support.  Please disable the"
eerror "bolt USE flag."
eerror
			die
		fi
ewarn
ewarn "Ebuild development indefinitely for the bolt USE flag."
ewarn
ewarn "No support will be given for the bolt USE flag on this ebuild fork due"
ewarn "to a lack of LBR support on the CPU."
ewarn
	fi

ewarn
ewarn "To avoid long linking delays, close programs that produce unexpectedly"
ewarn "high disk activity (web browsers) and possibly switch to -j1."
ewarn
}

python_check_deps() {
	use doc || return 0

	has_version -b "dev-python/recommonmark[${PYTHON_USEDEP}]" &&
	has_version -b "dev-python/sphinx[${PYTHON_USEDEP}]"
}

check_live_ebuild() {
	local prod_targets=(
		$(sed -n -e '/set(LLVM_ALL_TARGETS/,/)/p' CMakeLists.txt \
			| tail -n +2 | head -n -1)
	)
	local all_targets=(
		lib/Target/*/
	)
	all_targets=( "${all_targets[@]#lib/Target/}" )
	all_targets=( "${all_targets[@]%/}" )

	local exp_targets=() i
	for i in "${all_targets[@]}"; do
		has "${i}" "${prod_targets[@]}" || exp_targets+=( "${i}" )
	done

	if [[ ${exp_targets[*]} != ${ALL_LLVM_EXPERIMENTAL_TARGETS[*]} ]]; then
		eqawarn "ALL_LLVM_EXPERIMENTAL_TARGETS is outdated!"
		eqawarn "    Have: ${ALL_LLVM_EXPERIMENTAL_TARGETS[*]}"
		eqawarn "Expected: ${exp_targets[*]}"
		eqawarn
	fi

	if [[ ${prod_targets[*]} != ${ALL_LLVM_PRODUCTION_TARGETS[*]} ]]; then
		eqawarn "ALL_LLVM_PRODUCTION_TARGETS is outdated!"
		eqawarn "    Have: ${ALL_LLVM_PRODUCTION_TARGETS[*]}"
		eqawarn "Expected: ${prod_targets[*]}"
	fi
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
					# shared libs
					LLVM|LLVMgold)
						;;
					# TableGen lib + deps
					LLVMDemangle|LLVMSupport|LLVMTableGen)
						;;
					# static libs
					LLVM*)
						continue
						;;
					# meta-targets
					distribution|llvm-libraries)
						continue
						;;
					# used only w/ USE=doc
					docs-llvm-html)
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
	# disable use of SDK on OSX, bug #568758
	sed -i -e 's/xcrun/false/' utils/lit/lit/util.py || die

	# Update config.guess to support more systems
	cp "${BROOT}/usr/share/gnuconfig/config.guess" cmake/ || die

	# Verify that the live ebuild is up-to-date
	check_live_ebuild

	llvm.org_src_prepare

	export CFLAGS_BAK="${CFLAGS}"
	export CXXFLAGS_BAK="${CXXFLAGS}"
	export LDFLAGS_BAK="${LDFLAGS}"
}

# Is LLVM being linked against libc++?
is_libcxx_linked() {
	local code='#include <ciso646>
#if defined(_LIBCPP_VERSION)
	HAVE_LIBCXX
#endif
'
	local out=$($(tc-getCXX) ${CXXFLAGS} ${CPPFLAGS} -x c++ -E -P - <<<"${code}") || return 1

	[[ ${out} == *HAVE_LIBCXX* ]]
}

get_distribution_components() {
	local sep=${1-;}

	local out=(
		# shared libs
		LLVM
		LTO
		Remarks

		# tools
		llvm-config

		# common stuff
		cmake-exports
		llvm-headers

		# libraries needed for clang-tblgen
		LLVMDemangle
		LLVMSupport
		LLVMTableGen
	)

	if multilib_is_native_abi; then
		out+=(
			# utilities
			llvm-tblgen
			FileCheck
			llvm-PerfectShuffle
			count
			not
			yaml-bench

			# tools
			bugpoint
			dsymutil
			llc
			lli
			lli-child-target
			llvm-addr2line
			llvm-ar
			llvm-as
			llvm-bcanalyzer
			llvm-bitcode-strip
			llvm-c-test
			llvm-cat
			llvm-cfi-verify
			llvm-config
			llvm-cov
			llvm-cvtres
			llvm-cxxdump
			llvm-cxxfilt
			llvm-cxxmap
			llvm-debuginfod-find
			llvm-diff
			llvm-dis
			llvm-dlltool
			llvm-dwarfdump
			llvm-dwp
			llvm-exegesis
			llvm-extract
			llvm-gsymutil
			llvm-ifs
			llvm-install-name-tool
			llvm-jitlink
			llvm-jitlink-executor
			llvm-lib
			llvm-libtool-darwin
			llvm-link
			llvm-lipo
			llvm-lto
			llvm-lto2
			llvm-mc
			llvm-mca
			llvm-ml
			llvm-modextract
			llvm-mt
			llvm-nm
			llvm-objcopy
			llvm-objdump
			llvm-opt-report
			llvm-otool
			llvm-pdbutil
			llvm-profdata
			llvm-profgen
			llvm-ranlib
			llvm-rc
			llvm-readelf
			llvm-readobj
			llvm-reduce
			llvm-remark-size-diff
			llvm-rtdyld
			llvm-sim
			llvm-size
			llvm-split
			llvm-stress
			llvm-strings
			llvm-strip
			llvm-symbolizer
			llvm-tapi-diff
			llvm-tli-checker
			llvm-undname
			llvm-windres
			llvm-xray
			obj2yaml
			opt
			sancov
			sanstats
			split-file
			verify-uselistorder
			yaml2obj

			# python modules
			opt-viewer
		)

		if llvm_are_manpages_built; then
			out+=(
				# manpages
				docs-dsymutil-man
				docs-llvm-dwarfdump-man
				docs-llvm-man
			)
		fi
		use doc && out+=(
			docs-llvm-html
		)

		use binutils-plugin && out+=(
			LLVMgold
		)
	fi

	printf "%s${sep}" "${out[@]}"
}

bool_trans() {
	local arg="${1}"
	if [[ "${arg}" == "1" ]] ; then
		echo "true"
	else
		echo "false"
	fi
}

src_configure() { :; }

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

	use test && filter-flags '-f*-aggressive-loop-optimizations'
	autofix_flags # translate retpoline, strip unsupported flags during switch
}

setup_clang() {
	export CC=clang-${SLOT}
	export CXX=clang++-${SLOT}
	autofix_flags # translate retpoline, strip unsupported flags during switch
}

_configure() {
	einfo "Called _configure()"
	use pgo && einfo "PGO_PHASE=${PGO_PHASE}"
	_cmake_clean
	if use pgo && ! has_version ">=sys-devel/clang-${PV}:${SLOT}[${MULTILIB_ABI_FLAG}]" ; then
		eerror
		eerror "PGO requires >=sys-devel/clang-${PV}:${SLOT}[${MULTILIB_ABI_FLAG}]"
		eerror
		eerror "For correct steps to PGOing see the metadata.xml or"
		eerror
		eerror "  \`epkginfo -x ${PN}::oiledmachine-overlay\`"
		eerror
		die
	fi

	# Two choices really for correct testing:  disable ccache or update the hash calculation correctly.
	# This is to ensure that all sibling obj files use the same libLLVM.so with the same fingerprint.
	# Also, we want to test the effects of the binary code generated homogenously throughout
	# the LLVM library not just the source code associated with a few objs that was just changed.
	export CCACHE_EXTRAFILES=$(readlink -f "/usr/lib/llvm/${SLOT}/$(get_libdir ${DEFAULT_ABI})/libLLVM.so" 2>/dev/null)
	local ffi_cflags ffi_ldflags
	if use libffi; then
		ffi_cflags=$($(tc-getPKG_CONFIG) --cflags-only-I libffi)
		ffi_ldflags=$($(tc-getPKG_CONFIG) --libs-only-L libffi)
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
		'-f*reorder-blocks-and-partition' \
		'-flto*' \
		'-fuse-ld*' \
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
	elif [[ "${PGO_PHASE}" =~ ("pgi"|"pgt"|"pgo") ]] ; then
		setup_clang
	fi

	if use bolt-prepare ; then
		append-flags -fno-reorder-blocks-and-partition
		append-ldflags -fno-reorder-blocks-and-partition
		append-ldflags -Wl,--emit-relocs
	fi

	# workaround BMI bug in gcc-7 (fixed in 7.4)
	# https://bugs.gentoo.org/649880
	# apply only to x86, https://bugs.gentoo.org/650506
	if tc-is-gcc && [[ ${MULTILIB_ABI_FLAG} == abi_x86* ]] &&
			[[ $(gcc-major-version) -eq 7 && $(gcc-minor-version) -lt 4 ]]
	then
		local CFLAGS="${CFLAGS} -mno-bmi"
		local CXXFLAGS="${CXXFLAGS} -mno-bmi"
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
	autofix_flags # translate retpoline, strip unsupported flags during switch
	einfo "CFLAGS=${CFLAGS}"
	einfo "CXXFLAGS=${CXXFLAGS}"

	local libdir=$(get_libdir)
	local mycmakeargs=(
		# disable appending VCS revision to the version to improve
		# direct cache hit ratio
		-DLLVM_APPEND_VC_REV=OFF
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}

		-DBUILD_SHARED_LIBS=OFF
		-DLLVM_BUILD_LLVM_DYLIB=ON
		-DLLVM_LINK_LLVM_DYLIB=ON
		-DLLVM_DISTRIBUTION_COMPONENTS=$(get_distribution_components)

		# cheap hack: LLVM combines both anyway, and the only difference
		# is that the former list is explicitly verified at cmake time
		-DLLVM_TARGETS_TO_BUILD=""
		-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD="${LLVM_TARGETS// /;}"
		-DLLVM_BUILD_TESTS=$(usex test)

		-DLLVM_ENABLE_DUMP=$(usex dump)
		-DLLVM_ENABLE_FFI=$(usex libffi)
		-DLLVM_ENABLE_LIBEDIT=$(usex libedit)
		-DLLVM_ENABLE_TERMINFO=$(usex ncurses)
		-DLLVM_ENABLE_LIBXML2=$(usex xml)
		-DLLVM_ENABLE_ASSERTIONS=$(usex debug)
		-DLLVM_ENABLE_LIBPFM=$(usex exegesis)
		-DLLVM_ENABLE_EH=ON
		-DLLVM_ENABLE_RTTI=ON
		-DLLVM_ENABLE_Z3_SOLVER=$(usex z3)

		-DLLVM_HOST_TRIPLE="${CHOST}"

		-DFFI_INCLUDE_DIR="${ffi_cflags#-I}"
		-DFFI_LIBRARY_DIR="${ffi_ldflags#-L}"
		# used only for llvm-objdump tool
		-DLLVM_HAVE_LIBXAR=$(multilib_native_usex xar 1 0)

		-DPython3_EXECUTABLE="${PYTHON}"

		# disable OCaml bindings (now in dev-ml/llvm-ocaml)
		-DOCAMLFIND=NO
	)

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
	)

	if is_libcxx_linked; then
		# Smart hack: alter version suffix -> SOVERSION when linking
		# against libc++. This way we won't end up mixing LLVM libc++
		# libraries with libstdc++ clang, and the other way around.
		mycmakeargs+=(
			-DLLVM_VERSION_SUFFIX="libcxx"
			-DLLVM_ENABLE_LIBCXX=ON
		)
	fi

#	Note: go bindings have no CMake rules at the moment
#	but let's kill the check in case they are introduced
#	if ! multilib_is_native_abi || ! use go; then
		mycmakeargs+=(
			-DGO_EXECUTABLE=GO_EXECUTABLE-NOTFOUND
		)
#	fi

	use bolt && mycmakeargs+=(
		-DLLVM_ENABLE_PROJECTS="bolt"
	)

	use test && mycmakeargs+=(
		-DLLVM_LIT_ARGS="$(get_lit_flags)"
	)

	if multilib_is_native_abi; then
		local build_docs=OFF
		if llvm_are_manpages_built; then
			build_docs=ON
			mycmakeargs+=(
				-DCMAKE_INSTALL_MANDIR="${EPREFIX}/usr/lib/llvm/${SLOT}/share/man"
				-DLLVM_INSTALL_SPHINX_HTML_DIR="${EPREFIX}/usr/share/doc/${PF}/html"
				-DSPHINX_WARNINGS_AS_ERRORS=OFF
			)
		fi

		mycmakeargs+=(
			-DLLVM_BUILD_DOCS=${build_docs}
			-DLLVM_ENABLE_OCAMLDOC=OFF
			-DLLVM_ENABLE_SPHINX=${build_docs}
			-DLLVM_ENABLE_DOXYGEN=OFF
			-DLLVM_INSTALL_UTILS=ON
		)
		use binutils-plugin && mycmakeargs+=(
			-DLLVM_BINUTILS_INCDIR="${EPREFIX}"/usr/include
		)
	fi

	if tc-is-cross-compiler; then
		local tblgen="${EPREFIX}/usr/lib/llvm/${SLOT}/bin/llvm-tblgen"
		[[ -x "${tblgen}" ]] \
			|| die "${tblgen} not found or usable"
		mycmakeargs+=(
			-DCMAKE_CROSSCOMPILING=ON
			-DLLVM_TABLEGEN="${tblgen}"
		)
	fi

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
			-DCMAKE_C_COMPILER="/${EPREFIX}/usr/lib/llvm/${SLOT}/bin/clang"
			-DCMAKE_CXX_COMPILER="/${EPREFIX}/usr/lib/llvm/${SLOT}/bin/clang++"
			-DLLVM_BUILD_INSTRUMENTED=ON
			-DLLVM_ENABLE_LTO=Off
			-DLLVM_USE_LINKER=lld
		)
	elif [[ "${PGO_PHASE}" == "pgt_build_self" ]] ; then
		# Use the package itself as the asset for training.
		mycmakeargs+=(
			-DCMAKE_C_COMPILER="/${EPREFIX}/usr/lib/llvm/${SLOT}/bin/clang"
			-DCMAKE_CXX_COMPILER="/${EPREFIX}/usr/lib/llvm/${SLOT}/bin/clang++"
			-DLLVM_BUILD_INSTRUMENTED=OFF
			-DLLVM_ENABLE_LTO=Off
			-DLLVM_USE_LINKER=lld
		)
	elif [[ "${PGO_PHASE}" == "pgt_test_suite_inst" ]] ; then
		mycmakeargs+=(
			-DCMAKE_C_COMPILER="/${EPREFIX}/usr/lib/llvm/${SLOT}/bin/clang"
			-DCMAKE_CXX_COMPILER="/${EPREFIX}/usr/lib/llvm/${SLOT}/bin/clang++"
			-DLLVM_BUILD_INSTRUMENTED=OFF
			-DLLVM_ENABLE_LTO=Off
			-DLLVM_USE_LINKER=lld
			-DTEST_SUITE_BENCHMARKING_ONLY=ON
			-DTEST_SUITE_PROFILE_GENERATE=ON
			-DTEST_SUITE_RUN_TYPE=Train
		)
	elif [[ "${PGO_PHASE}" == "pgt_test_suite_opt" ]] ; then
		mycmakeargs+=(
			-DCMAKE_C_COMPILER="/${EPREFIX}/usr/lib/llvm/${SLOT}/bin/clang"
			-DCMAKE_CXX_COMPILER="/${EPREFIX}/usr/lib/llvm/${SLOT}/bin/clang++"
			-DLLVM_BUILD_INSTRUMENTED=OFF
			-DLLVM_ENABLE_LTO=Off
			-DLLVM_USE_LINKER=lld
			-DTEST_SUITE_PROFILE_GENERATE=OFF
			-DTEST_SUITE_PROFILE_USE=ON
			-DTEST_SUITE_RUN_TYPE=ref
		)
	elif [[ "${PGO_PHASE}" == "pgo" ]] ; then
		einfo "Merging .profraw -> .profdata"
		"/${EPREFIX}/usr/lib/llvm/${SLOT}/bin/llvm-profdata" merge -output="${T}/pgo-custom.profdata" "${T}/pgt/profiles/"*
		mycmakeargs+=(
			-DCMAKE_C_COMPILER="/${EPREFIX}/usr/lib/llvm/${SLOT}/bin/clang"
			-DCMAKE_CXX_COMPILER="/${EPREFIX}/usr/lib/llvm/${SLOT}/bin/clang++"
			-DLLVM_BUILD_INSTRUMENTED=OFF
			-DLLVM_ENABLE_LTO=$(usex lto "Thin" "Off")
			-DLLVM_PROFDATA_FILE="${T}/pgo-custom.profdata"
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

	grep -q -E "^CMAKE_PROJECT_VERSION_MAJOR(:.*)?=$(ver_cut 1)$" \
			CMakeCache.txt ||
		die "Incorrect version, did you update _LLVM_MASTER_MAJOR?"
	multilib_is_native_abi && check_distribution_components
}

declare -Ax EMESSAGE_COMPILE=(
	[pgv]="Building vanilla ${PN}"
	[pgi]="Building instrumented ${PN}"
	[pgt_build_self]="Running PGO trainer:  Build itself"
	[pgt_test_suite_inst]="Running PGO trainer:   test-suite instrumenting"
	[pgt_test_suite_train]="Running PGO trainer:   test-suite training"
	[pgt_test_suite_opt]="Running PGO trainer:   test-suite optimization"
	[pgo]="Building PGOed ${PN}"
)

_compile() {
	einfo "Called _compile()"
	cd "${BUILD_DIR}" || die
	if [[ "${PGO_PHASE}" =~ ("pgv"|"pgi"|"pgt_"|"pgo") ]] ; then
		use pgo && einfo "${EMESSAGE_COMPILE[${PGO_PHASE}]} for ${ABI}"
	fi
	if [[ "${PGO_PHASE}" == "pgt_build_self" ]] ; then
		cmake_build distribution
	elif [[ "${PGO_PHASE}" == "pgt_test_suite_inst" ]] ; then
		CMAKE_USE_DIR="${WORKDIR}/test-suite"
		BUILD_DIR_BAK="${BUILD_DIR}"
		BUILD_DIR="${WORKDIR}/test-suite_build_${ABI}"
		cd "${BUILD_DIR}" || die
		# Profile the PGI step
		cmake_build
		BUILD_DIR="${BUILD_DIR_BAK}"
		cd "${BUILD_DIR}" || die
	elif [[ "${PGO_PHASE}" == "pgt_test_suite_train" ]] ; then
		CMAKE_USE_DIR="${WORKDIR}/test-suite"
		BUILD_DIR_BAK="${BUILD_DIR}"
		BUILD_DIR="${WORKDIR}/test-suite_build_${ABI}"
		cd "${BUILD_DIR}" || die
		cmake_build check-lit
		"${BUILD_DIR_BAK}/bin/llvm-lit" .
		BUILD_DIR="${BUILD_DIR_BAK}"
		cd "${BUILD_DIR}" || die
	elif [[ "${PGO_PHASE}" == "pgt_test_suite_opt" ]] ; then
		CMAKE_USE_DIR="${WORKDIR}/test-suite"
		BUILD_DIR_BAK="${BUILD_DIR}"
		BUILD_DIR="${WORKDIR}/test-suite_build_${ABI}"
		cd "${BUILD_DIR}" || die
		# Profile the PGO step
		cmake_build
		cmake_build check-lit
		"${BUILD_DIR_BAK}/bin/llvm-lit" -o result.json .
		BUILD_DIR="${BUILD_DIR_BAK}"
		cd "${BUILD_DIR}" || die
	else
		cmake_build distribution
		use test && cmake_build test-depends
	fi

	pax-mark m "${BUILD_DIR}"/bin/llvm-rtdyld
	pax-mark m "${BUILD_DIR}"/bin/lli
	pax-mark m "${BUILD_DIR}"/bin/lli-child-target

	if use test; then
		pax-mark m "${BUILD_DIR}"/unittests/ExecutionEngine/Orc/OrcJITTests
		pax-mark m "${BUILD_DIR}"/unittests/ExecutionEngine/MCJIT/MCJITTests
		pax-mark m "${BUILD_DIR}"/unittests/Support/SupportTests
	fi
}

_build_final() {
	wo=1
	ph=0
	s_idx=7
	if use pgo ; then
		if use bootstrap ; then
			PGO_PHASE="pgv"
			_configure
			_compile
			_install
		fi
		PGO_PHASE="pgi"
		_configure
		_compile
		_install
		if use pgo_trainer_build_self ; then
			PGO_PHASE="pgt_build_self"
			_configure
			_compile
			_install
		fi
		if use pgo_trainer_test_suite ; then
			PGO_PHASE="pgt_test_suite_inst"
			_configure
			_compile
			_install
			PGO_PHASE="pgt_test_suite_train"
			_configure
			_compile
			_install
			PGO_PHASE="pgt_test_suite_opt"
			_configure
			_compile
			_install
		fi
		PGO_PHASE="pgo"
		_configure
		_compile
		_install
		use test && _test
	else
		PGO_PHASE="pg0"
		_configure
		_compile
		_install
		use test && _test
	fi
}

_build_abi() {
	PATH_ORIG="${PATH}"
	local wo
	local ph
	local s_idx
	_build_final
}

src_compile() {
	_compile_abi() {
		export BUILD_DIR="${WORKDIR}/${P}_build-${MULTILIB_ABI_FLAG}.${ABI}"
		mkdir -p "${BUILD_DIR}" || die
		cd "${BUILD_DIR}" || die
		_build_abi
	}
	multilib_foreach_abi _compile_abi
}

src_test() { :; }

_test() {
	einfo "Called _test()"
	cd "${BUILD_DIR}" || die
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	cmake_build check
}

src_install() {
	if use bolt-prepare ; then
		# For BOLT requirements, see
# https://github.com/llvm/llvm-project/tree/main/bolt#input-binary-requirements
		export STRIP="/bin/true"
	fi
	local MULTILIB_CHOST_TOOLS=(
		/usr/lib/llvm/${SLOT}/bin/llvm-config
	)

	local MULTILIB_WRAPPED_HEADERS=(
		/usr/include/llvm/Config/llvm-config.h
	)

	local LLVM_LDPATHS=()
	multilib-minimal_src_install

	# move wrapped headers back
	mv "${ED}"/usr/include "${ED}"/usr/lib/llvm/${SLOT}/include || die
}

_install() {
	einfo "Called _install()"
	cd "${BUILD_DIR}" || die
	DESTDIR=${D} cmake_build install-distribution

	# move headers to /usr/include for wrapping
	rm -rf "${ED}"/usr/include || die
	mv "${ED}"/usr/lib/llvm/${SLOT}/include "${ED}"/usr/include || die
	LLVM_LDPATHS+=( "${EPREFIX}/usr/lib/llvm/${SLOT}/$(get_libdir)" )
}

multilib_src_install() {
	_install
}

multilib_src_install_all() {
	local revord=$(( 9999 - ${SLOT} ))
	newenvd - "60llvm-${revord}" <<-_EOF_
		PATH="${EPREFIX}/usr/lib/llvm/${SLOT}/bin"
		# we need to duplicate it in ROOTPATH for Portage to respect...
		ROOTPATH="${EPREFIX}/usr/lib/llvm/${SLOT}/bin"
		MANPATH="${EPREFIX}/usr/lib/llvm/${SLOT}/share/man"
		LDPATH="$( IFS=:; echo "${LLVM_LDPATHS[*]}" )"
	_EOF_

	docompress "/usr/lib/llvm/${SLOT}/share/man"
	llvm_install_manpages
}

pkg_postinst() {
	elog "You can find additional opt-viewer utility scripts in:"
	elog "  ${EROOT}/usr/lib/llvm/${SLOT}/share/opt-viewer"
	elog "To use these scripts, you will need Python along with the following"
	elog "packages:"
	elog "  dev-python/pygments (for opt-viewer)"
	elog "  dev-python/pyyaml (for all of them)"
	if use bolt-prepare ; then
		einfo
		einfo "Run \`emerge --config =${P}\` to bolt optimize after emerging a bolt"
		einfo "optimized clang."
		einfo
		einfo "See the metadata.xml or \`epkginfo -x ${PN}::oiledmachine-overlay\`"
		einfo "for instructions on a BOLT optimized ${PN} library."
		einfo
	fi
}

_bolt_optimize_file() {
	# From the unit test and issue 279, it should be possible to BOLT optimize .so files.
	local f="${1}"
	einfo "BOLTing ${f}"
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

	if [[ "${f}" =~ "/${SLOT}/$(get_libdir ${ABI})/" ]] ; then
		# For libs
		args+=(
			-data="${EPREFIX}/usr/share/${PN}/${SLOT}/bolt-profile/clang-${SLOT}-merged-${ABI}.fdata"
		)
	elif [[ "${f}" =~ "/bin/" ]] ; then
		# For exes
		# It is maybe -all or -${ABI} but the exe is the DEFAULT_ABI.
		args+=(
			-data="${EPREFIX}/usr/share/${PN}/${SLOT}/bolt-profile/clang-${SLOT}-merged-all.fdata"
		)
	else
		ewarn "${f} is skipped.  Not in lib* or bin"
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

strip_package() {
	if readelf -S "${EPREFIX}/usr/lib/llvm/${SLOT}/$(get_libdir)/libLLVM.so" 2>/dev/null \
		| grep -F -e ".comment" ; then
		einfo "${PN} is already stripped"
		return
	fi
	# Remove debug symbols
	local STRIP
	local RANDLIB
	if [[ "${CC}" == "clang" ]] ; then
		STRIP="llvm-strip"
		RANDLIB="llvm-ranlib"
	else
		STRIP="strip"
		RANDLIB="ranlib"
	fi
	# Keep in sync with:
	# https://github.com/gentoo/portage/blob/master/bin/estrip#L133
	local strip_args=(
		--strip-unneeded
		-N __gentoo_check_ldflags__
		-R .comment
		-R .GCC.command.line
		-R .note.gnu.gold-version
	)

	einfo "Stripping package.  Please wait."
	local f
	for f in $(cat /var/db/pkg/${CATEGORY}/${P}/CONTENTS | cut -f 2 -d " ") ; do
		f=$(readlink -f "${f}")
		local is_exe=0
		local is_so=0
		local is_a=0
		local is_o=0
		local is_writeable=0 # for prefix
		[[ ! -w "${f}" ]] && is_writeable=1 && chmod u+w "${f}"
		# Keep in sync with:
		# https://github.com/gentoo/portage/blob/master/bin/estrip#L471
		file "${f}" 2>/dev/null | grep -q -E -e "ELF.*relocatable" && is_o=1
		file "${f}" 2>/dev/null | grep -q -E -e "ELF.*executable" && is_exe=1
		file "${f}" 2>/dev/null | grep -q -E -e "ELF.*shared object" && is_so=1
		file "${f}" 2>/dev/null | grep -q -E -e "ar archive" && is_a=1
		if (( ${is_o} == 1 )) ; then
			ewarn "Found .o file:  ${f}"
		fi
		if (( ${is_exe} == 1 || ${is_so} == 1 )) ; then
			"${STRIP}" ${strip_args[@]} "${f}"
		fi
		if (( ${is_a} == 1 )) ; then
			"${STRIP}" -g "${f}" && "${RANDLIB}" "${f}"
		fi
		(( ${is_writeable} == 1 )) && chmod u-w "${f}"
	done
}

pkg_config() {
	use bolt-prepare || return
	local llvm_used_commit
	if [[ ${PV} == *.9999 ]] ; then
		llvm_used_commit=$(cat "${EPREFIX}/usr/share/${PN}/${SLOT}/bolt-profile/llvm-commit")
	fi
	if [[ "${EGIT_VERSION}" != "${llvm_used_commit}" ]] ; then
		ewarn
		ewarn "Expected EGIT_VERSION:  ${llvm_used_commit}"
		ewarn "Actual EGIT_VERSION:    ${EGIT_VERSION}"
		ewarn
	fi
	if [[ ! -d "${EPREFIX}/usr/share/${PN}/${SLOT}/bolt-profile" ]] ; then
eerror "Missing BOLT profile required for a BOLT optimized LLVM."
		die
	fi
	# All binaries involved in building down the process tree should be added.
	local f
	for f in $(cat /var/db/pkg/sys-devel/${PN}-${SLOT}*/CONTENTS | cut -f 2 -d " ") ; do
		f=$(readlink -f "${f}")
		local is_exe=0
		local is_so=0
		file "${f}" 2>/dev/null | grep -q -E -e "ELF.*executable" && is_exe=1
		file "${f}" 2>/dev/null | grep -q -E -e "ELF.*shared object" && is_so=1
		if (( ${is_exe} == 1 || ${is_so} == 1 )) ; then
			if grep -q -e $(basename "${f}") "${EPREFIX}/usr/share/${PN}/${SLOT}/bolt-profile" ; then
				_bolt_optimize_file "${f}"
			else
				einfo "Skipping "$(basename "${f}")" because it was not BOLT profiled."
			fi
		fi
	done
	strip_package
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-MOD-TYPE:  patch, stop-compile-spam
# OILEDMACHINE-OVERLAY-META-WIP:  bolt, pgo
