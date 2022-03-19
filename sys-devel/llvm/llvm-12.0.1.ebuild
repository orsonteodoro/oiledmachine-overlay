# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit cmake llvm.org multilib-minimal pax-utils python-any-r1 \
	toolchain-funcs
inherit flag-o-matic git-r3 ninja-utils

DESCRIPTION="Low Level Virtual Machine"
HOMEPAGE="https://llvm.org/"

# Those are in lib/Targets, without explicit CMakeLists.txt mention
ALL_LLVM_EXPERIMENTAL_TARGETS=( ARC CSKY VE )
# Keep in sync with CMakeLists.txt
ALL_LLVM_TARGETS=( AArch64 AMDGPU ARM AVR BPF Hexagon Lanai Mips MSP430
	NVPTX PowerPC RISCV Sparc SystemZ WebAssembly X86 XCore
	"${ALL_LLVM_EXPERIMENTAL_TARGETS[@]}" )
ALL_LLVM_TARGETS=( "${ALL_LLVM_TARGETS[@]/#/llvm_targets_}" )

# Additional licenses:
# 1. OpenBSD regex: Henry Spencer's license ('rc' in Gentoo) + BSD.
# 2. xxhash: BSD.
# 3. MD5 code: public-domain.
# 4. ConvertUTF.h: TODO.

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA BSD public-domain rc"
SLOT="$(ver_cut 1)"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~ppc-macos ~x64-macos"
IUSE="debug doc exegesis +gold libedit +libffi ncurses test xar xml z3 ${ALL_LLVM_TARGETS[*]}"
IUSE+=" +bootstrap -dump lto pgo pgo_trainer_build_self pgo_trainer_test_suite souper r3"
REQUIRED_USE="|| ( ${ALL_LLVM_TARGETS[*]} )"
REQUIRED_USE+="
	bootstrap? ( !souper )
	pgo? ( || ( pgo_trainer_build_self pgo_trainer_test_suite ) )
	pgo_trainer_build_self? ( pgo )
	pgo_trainer_test_suite? ( pgo )
	souper? (
		!z3
		test? ( debug )
	)
"
RESTRICT="!test? ( test )"

RDEPEND="
	sys-libs/zlib:0=[${MULTILIB_USEDEP}]
	exegesis? ( dev-libs/libpfm:= )
	gold? ( >=sys-devel/binutils-2.31.1-r4:*[plugins] )
	libedit? ( dev-libs/libedit:0=[${MULTILIB_USEDEP}] )
	libffi? ( >=dev-libs/libffi-3.0.13-r1:0=[${MULTILIB_USEDEP}] )
	ncurses? ( >=sys-libs/ncurses-5.9-r3:0=[${MULTILIB_USEDEP}] )
	xar? ( app-arch/xar )
	xml? ( dev-libs/libxml2:2=[${MULTILIB_USEDEP}] )
	z3? ( >=sci-mathematics/z3-4.7.1:0=[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	gold? ( sys-libs/binutils-libs )"
BDEPEND="
	dev-lang/perl
	>=dev-util/cmake-3.16
	sys-devel/gnuconfig
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
	gold? ( >=sys-devel/llvmgold-${SLOT} )
	souper? ( sys-devel/souper[llvm-${SLOT}] )
"
PATCHES=(
	"${FILESDIR}/llvm-12.0.1-stop-triple-spam.patch"
)

LLVM_COMPONENTS=( llvm )
LLVM_MANPAGES=pregenerated
LLVM_PATCHSET=12.0.1
llvm.org_set_globals
#if [[ ${PV} == *.9999 ]] ; then
EGIT_REPO_URI_LLVM_TEST_SUITE="https://github.com/llvm/llvm-test-suite.git"
EGIT_BRANCH_LLVM_TEST_SUITE="release/${SLOT}.x"
EGIT_COMMIT_LLVM_TEST_SUITE="${EGIT_COMMIT_LLVM_TEST_SUITE:-llvmorg-${PV/_/-}}"
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
	if use test ; then
		if use souper && ! has_version ">=sys-devel/clang-${SLOT}:${SLOT}[${MULTILIB_USEDEP}]" ; then
			local abi_pairs=($(multilib_get_enabled_abi_pairs))
			abi_pairs=${abi_pairs[@]%.*}
			abi_pairs=${abi_pairs// /,}
eerror "Testing with souper requires >=sys-devel/clang-${SLOT}:${SLOT}[${abi_pairs}]"
			die
		fi
	fi
	use pgo && ewarn "The pgo USE flag is a Work In Progress (WIP)"
	use pgo_trainer_build_self && ewarn "The pgo_trainer_build_self USE flag has not been tested."
	use pgo_trainer_test_suite && ewarn "The pgo_trainer_test_suite USE flag has not been tested."
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
	# reorder
	all_targets=( "${prod_targets[@]}" "${exp_targets[@]}" )

	if [[ ${exp_targets[*]} != ${ALL_LLVM_EXPERIMENTAL_TARGETS[*]} ]]; then
		eqawarn "ALL_LLVM_EXPERIMENTAL_TARGETS is outdated!"
		eqawarn "    Have: ${ALL_LLVM_EXPERIMENTAL_TARGETS[*]}"
		eqawarn "Expected: ${exp_targets[*]}"
		eqawarn
	fi

	if [[ ${all_targets[*]} != ${ALL_LLVM_TARGETS[*]#llvm_targets_} ]]; then
		eqawarn "ALL_LLVM_TARGETS is outdated!"
		eqawarn "    Have: ${ALL_LLVM_TARGETS[*]#llvm_targets_}"
		eqawarn "Expected: ${all_targets[*]}"
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

	if use souper ; then
		cd "${WORKDIR}" || die
		eapply "${FILESDIR}/disable-peepholes-v07.diff"
	fi

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
			llvm-diff
			llvm-dis
			llvm-dlltool
			llvm-dwarfdump
			llvm-dwp
			llvm-elfabi
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
			llvm-pdbutil
			llvm-profdata
			llvm-profgen
			llvm-ranlib
			llvm-rc
			llvm-readelf
			llvm-readobj
			llvm-reduce
			llvm-rtdyld
			llvm-size
			llvm-split
			llvm-stress
			llvm-strings
			llvm-strip
			llvm-symbolizer
			llvm-undname
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

		use gold && out+=(
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
	if use test && use souper && (( ${s_idx} != 7 )) ; then
		# Speed up build times
		replace-flags '-O*' '-O1'
		strip-flags

		# Prevent possibility of generating undefined behavior (UB) that can interfere with testing UB.
		append-flags -fno-aggressive-loop-optimizations
		append-ldflags -fno-aggressive-loop-optimizations
	fi
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
	if use pgo && ! has_version ">=sys-devel/clang-${PV}:${SLOT}[$(get_m_abi)]" ; then
		eerror
		eerror "PGO requires >=sys-devel/clang-${PV}:${SLOT}[$(get_m_abi)]"
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
	if use souper ; then
		einfo "wo=${wo} ph=${ph} (${s_idx}/7)"
		if use test ; then
			(( ${s_idx} > 1 )) && _cmake_clean
			if (( ${s_idx} == 7 )) ; then
				rm -rf "${ED}" || true
				export PATH="${PATH_ORIG}"
			else
				# Use clang + previous llvm to build current llvm
				local parity=$((${s_idx} % 2))
				local prev_parity=$(((${s_idx} + 1) % 2))
				rm -rf "${ED}/usr/lib/llvm/${parity}" || true # remove this
				if [[ -e "${ED}/usr/lib/llvm/${prev_parity}/$(get_libdir ${DEFAULT_ABI})/libLLVM.so" ]] ; then
					export PATH="${ED}/usr/lib/llvm/${prev_parity}/bin:${PATH_ORIG}"
					export LD_LIBRARY_PATH="${ED}/usr/lib/llvm/${prev_parity}/$(get_libdir)"
					export CCACHE_EXTRAFILES=\
"${CCACHE_EXTRAFILES}:"$(readlink -f "${ED}/usr/lib/llvm/${prev_parity}/$(get_libdir ${DEFAULT_ABI})/libLLVM.so" 2>/dev/null)
				fi
			fi
			if use bootstrap ; then
				setup_gcc # Build with a reliable vanilla compiler.
			else
				setup_clang # Rebuild with the (patched disable-peephole) LLVM lib.
			fi
		fi
		einfo "CC=${CC}"
		einfo "CXX=${CXX}"
		(( ${s_idx} == 7 )) && unset LD_LIBRARY_PATH
	fi
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
		'-flto*' \
		'-fuse-ld*'

	if use souper && (( ${s_idx} != 7 )) ; then
		:;
	elif [[ "${PGO_PHASE}" == "pg0" ]] ; then
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
		-DHAVE_LIBXAR=$(multilib_native_usex xar 1 0)

		-DPython3_EXECUTABLE="${PYTHON}"

		# disable OCaml bindings (now in dev-ml/llvm-ocaml)
		-DOCAMLFIND=NO
	)

	local slot=""
	if use pgo ; then
		if use souper ; then
			if (( ${s_idx} == 7 )) ; then
				if [[ "${PGO_PHASE}" =~ ("pgo"|"pg0") ]] ; then
					slot="${SLOT}"
				else
					slot="${PGO_PHASE}"
				fi
			else
				local parity=$((${s_idx} % 2))
				slot="${parity}"
			fi
		else
			if [[ "${PGO_PHASE}" =~ ("pgo"|"pg0") ]] ; then
				slot="${SLOT}"
			else
				slot="${PGO_PHASE}"
			fi
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

	if use souper ; then
		filter-flags \
			'-DDISABLE_WRONG_OPTIMIZATIONS_DEFAULT_VALUE*' \
			'-DDISABLE_PEEPHOLES_DEFAULT_VALUE*'
		# Setting DISABLE_WRONG_OPTIMIZATIONS_DEFAULT_VALUE=false and running the souper pass can cause miscompile in other programs.
		# See 2.10-2.11 section in academic paper.
		# To match the LLVM defaults, set WO=false and PH=false.
		append-cppflags -DDISABLE_WRONG_OPTIMIZATIONS_DEFAULT_VALUE=$(bool_trans ${wo}) -DDISABLE_PEEPHOLES_DEFAULT_VALUE=$(bool_trans ${ph})
		mycmakeargs+=(
			-DLLVM_FORCE_ENABLE_STATS=$(use test)
		)
	fi

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
		use gold && mycmakeargs+=(
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
		append-ldflags -Wl,--emit-relocs
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

_souper_test() {
	# This can be completed in a day
	if [[ ! ( "${FEATURES}" =~ "ccache" ) ]] || ! which ccache 2>/dev/null 1>/dev/null ; then
eerror
eerror "It could take 7 days to test without ccache.  Please emerge ccache and"
eerror "enable it."
eerror
		die
	fi

	# Required to avoid missing symbols problem
	if ! has_version ">=sys-devel/clang-${PV}:${SLOT}[$(get_m_abi)]" ; then
eerror
eerror ">=sys-devel/clang-${PV}:${SLOT}[$(get_m_abi)] must be installed for testing the disable-peepholes patch."
eerror
		die
	fi

	CFLAGS_BAK="${CFLAGS}"
	CXXFLAGS_BAK="${CXXFLAGS}"
	LDFLAGS_BAK="${LDFLAGS}"
	PATH_ORIG="${PATH}"

	# Configuration set
	# A:  (wo=0, ph=0)
	# B:  (wo=1, ph=0)
	# C:  (wo=1, ph=1)
	# A > A > B > A > C > A # Build transition between configuration sets as 1 based index
	#   x_i builds with non llvm default configuration when i is even and i >= 2
	# else
	#   x_i builds with vanilla toolchain and llvm default configuration when i is odd and i >= 1

	wo=0
	ph=0
	s_idx=1
	_configure
	_compile
	_install
	_test

	wo=0
	ph=0
	s_idx=2
	_configure
	_compile
	_install
	_test

	wo=1
	ph=0
	s_idx=3
	_configure
	_compile
	_install
	_test

	wo=0
	ph=0
	s_idx=4
	_configure
	_compile
	_install
	_test

	wo=1
	ph=1
	s_idx=5
	_configure
	_compile
	_install
	_test

	wo=0
	ph=0
	s_idx=6
	_configure
	_compile
	_install
	_test

	export PATH="${PATH_ORIG}"
	export CFLAGS="${CFLAGS_BAK}"
	export CXXFLAGS="${CXXFLAGS_BAK}"
	export LDFLAGS="${LDFLAGS_BAK}"
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
		! use souper && use test && _test
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
	if use souper ; then
		use test && _souper_test
	fi
	_build_final
}

get_m_abi() {
	local r
	for r in ${_MULTILIB_FLAGS[@]} ; do
		local m_abi=$"${r%:*}"
		local m_flag="${r#*:}"
		local a
		OIFS="${IFS}"
		IFS=','
		for a in ${m_flag} ; do
			if [[ "${a}" == "${ABI}" ]] ; then
				echo "${m_abi}"
				return
			fi
		done
		IFS="${OIFS}"
	done
}

src_compile() {
	_compile_abi() {
		export BUILD_DIR="${WORKDIR}/${P}_build-$(get_m_abi).${ABI}"
		mkdir -p "${BUILD_DIR}" || die
		cd "${BUILD_DIR}" || die
		_build_abi
	}
	multilib_foreach_abi _compile_abi
}

src_test() { :; }

# Testing DISABLE_PEEPHOLES=0 DISABLE_WRONG_OPTIMIZATIONS=0
#Testing Time: 3410.52s
#  Unsupported      : 14773
#  Passed           : 27320
#  Expectedly Failed:    75
#  Failed           :     1 (0.00237100 %)
EXPECTED_FAILS_1_X86=(
ExecutionEngine/MCJIT/remote/test-common-symbols-remote.ll
)

# Testing DISABLE_PEEPHOLES=0 DISABLE_WRONG_OPTIMIZATIONS=0
#Testing Time: 3580.67s
#  Unsupported      : 14773
#  Passed           : 27320
#  Expectedly Failed:    75
#  Failed           :     1 (0.00237100 %)
EXPECTED_FAILS_2_X86=(
ExecutionEngine/MCJIT/remote/test-common-symbols-remote.ll
)

# Testing DISABLE_PEEPHOLES=0 DISABLE_WRONG_OPTIMIZATIONS=1
#Testing Time: 3595.97s
#  Unsupported      : 14773
#  Passed           : 27222
#  Expectedly Failed:    75
#  Failed           :    99 (0.23476900 %)
EXPECTED_FAILS_3_X86=(
ExecutionEngine/MCJIT/remote/test-common-symbols-remote.ll
Other/new-pm-defaults.ll
Other/new-pm-thinlto-defaults.ll
Other/new-pm-thinlto-postlink-pgo-defaults.ll
Other/new-pm-thinlto-postlink-samplepgo-defaults.ll
Other/new-pm-thinlto-prelink-pgo-defaults.ll
Other/new-pm-thinlto-prelink-samplepgo-defaults.ll
Transforms/InstCombine/2006-12-15-Range-Test.ll
Transforms/InstCombine/2007-03-13-CompareMerge.ll
Transforms/InstCombine/2007-05-10-icmp-or.ll
Transforms/InstCombine/2007-11-15-CompareMiscomp.ll
Transforms/InstCombine/2008-01-13-AndCmpCmp.ll
Transforms/InstCombine/2008-02-28-OrFCmpCrash.ll
Transforms/InstCombine/2008-06-21-CompareMiscomp.ll
Transforms/InstCombine/2008-08-05-And.ll
Transforms/InstCombine/2012-02-28-ICmp.ll
Transforms/InstCombine/2012-03-10-InstCombine.ll
Transforms/InstCombine/JavaCompare.ll
Transforms/InstCombine/add.ll
Transforms/InstCombine/and-fcmp.ll
Transforms/InstCombine/and-or-icmp-nullptr.ll
Transforms/InstCombine/and-or-icmp-min-max.ll
Transforms/InstCombine/and-or-icmps.ll
Transforms/InstCombine/and.ll
Transforms/InstCombine/and2.ll
Transforms/InstCombine/apint-select.ll
Transforms/InstCombine/apint-shift.ll
Transforms/InstCombine/bit-checks.ll
Transforms/InstCombine/canonicalize-clamp-with-select-of-constant-threshold-pattern.ll
Transforms/InstCombine/cast.ll
Transforms/InstCombine/demorgan.ll
Transforms/InstCombine/dont-distribute-phi.ll
Transforms/InstCombine/icmp-custom-dl.ll
Transforms/InstCombine/icmp-div-constant.ll
Transforms/InstCombine/icmp-logical.ll
Transforms/InstCombine/icmp.ll
Transforms/InstCombine/ispow2.ll
Transforms/InstCombine/logical-select-inseltpoison.ll
Transforms/InstCombine/logical-select.ll
Transforms/InstCombine/merge-icmp.ll
Transforms/InstCombine/minmax-fold.ll
Transforms/InstCombine/onehot_merge.ll
Transforms/InstCombine/or-fcmp.ll
Transforms/InstCombine/or.ll
Transforms/InstCombine/prevent-cmp-merge.ll
Transforms/InstCombine/range-check.ll
Transforms/InstCombine/result-of-add-of-negative-is-non-zero-and-no-underflow.ll
Transforms/InstCombine/result-of-add-of-negative-or-zero-is-non-zero-and-no-underflow.ll
Transforms/InstCombine/result-of-usub-is-non-zero-and-no-overflow.ll
Transforms/InstCombine/select-and-or.ll
Transforms/InstCombine/select-cmp-br.ll
Transforms/InstCombine/select-bitext.ll
Transforms/InstCombine/select-ctlz-to-cttz.ll
Transforms/InstCombine/select-imm-canon.ll
Transforms/InstCombine/select-safe-transforms.ll
Transforms/InstCombine/select.ll
Transforms/InstCombine/select_meta.ll
Transforms/InstCombine/set.ll
Transforms/InstCombine/shift.ll
Transforms/InstCombine/sign-test-and-or.ll
Transforms/InstCombine/signed-truncation-check.ll
Transforms/InstCombine/sink_to_unreachable.ll
Transforms/InstCombine/umul-sign-check.ll
Transforms/InstCombine/unsigned_saturated_sub.ll
Transforms/InstCombine/usub-overflow-known-by-implied-cond.ll
Transforms/InstCombine/widenable-conditions.ll
Transforms/InstCombine/zext-bool-add-sub.ll
Transforms/InstCombine/zext-or-icmp.ll
Transforms/LoopUnroll/opt-levels.ll
Transforms/LoopVectorize/X86/x86-interleaved-accesses-masked-group.ll
Transforms/LoopVectorize/if-conversion-nest.ll
Transforms/LoopVectorize/phi-cost.ll
Transforms/LoopVectorize/reduction-inloop.ll
Transforms/LoopVectorize/reduction-inloop-pred.ll
Transforms/PGOProfile/chr.ll
Transforms/PhaseOrdering/X86/vector-reductions.ll
Transforms/PhaseOrdering/unsigned-multiply-overflow-check.ll
Transforms/SimpleLoopUnswitch/LIV-loop-condtion.ll
Transforms/SimpleLoopUnswitch/basictest-profmd.ll
Transforms/SimpleLoopUnswitch/copy-metadata.ll
Transforms/SimpleLoopUnswitch/delete-dead-blocks.ll
Transforms/SimpleLoopUnswitch/exponential-nontrivial-unswitch-nested.ll
Transforms/SimpleLoopUnswitch/exponential-nontrivial-unswitch-nested2.ll
Transforms/SimpleLoopUnswitch/exponential-nontrivial-unswitch.ll
Transforms/SimpleLoopUnswitch/exponential-switch-unswitch.ll
Transforms/SimpleLoopUnswitch/guards.ll
Transforms/SimpleLoopUnswitch/implicit-null-checks.ll
Transforms/SimpleLoopUnswitch/infinite-loop.ll
Transforms/SimpleLoopUnswitch/msan.ll
Transforms/SimpleLoopUnswitch/nontrivial-unswitch-cost.ll
Transforms/SimpleLoopUnswitch/pipeline.ll
Transforms/SimpleLoopUnswitch/pr37888.ll
Transforms/SimpleLoopUnswitch/nontrivial-unswitch.ll
Transforms/SimpleLoopUnswitch/preserve-scev-exiting-multiple-loops.ll
Transforms/SimpleLoopUnswitch/trivial-unswitch-iteration.ll
Transforms/SimpleLoopUnswitch/trivial-unswitch-profmd.ll
Transforms/SimpleLoopUnswitch/update-scev.ll
Transforms/SimpleLoopUnswitch/trivial-unswitch.ll
Transforms/SimplifyCFG/merge-cond-stores.ll
)

# Testing DISABLE_PEEPHOLES=0 DISABLE_WRONG_OPTIMIZATIONS=0
#Testing Time: 3953.71s
#  Unsupported      : 14773
#  Passed           : 27320
#  Expectedly Failed:    75
#  Failed           :     1 (0.00237100 %)
EXPECTED_FAILS_4_X86=(
ExecutionEngine/MCJIT/remote/test-common-symbols-remote.ll
)

# Testing DISABLE_PEEPHOLES=1 DISABLE_WRONG_OPTIMIZATIONS=1
#Testing Time: 3717.22s
#  Unsupported      : 14773
#  Passed           : 25525
#  Expectedly Failed:    75
#  Failed           :  1796 (4.25905200 %)
EXPECTED_FAILS_5_X86=(
Analysis/BasicAA/2003-09-19-LocalArgument.ll
Analysis/BasicAA/2007-08-05-GetOverloadedModRef.ll
Analysis/BasicAA/2009-10-13-AtomicModRef.ll
Analysis/BasicAA/cas.ll
Analysis/BasicAA/featuretest.ll
Analysis/BasicAA/full-store-partial-alias.ll
Analysis/BasicAA/gcsetest.ll
Analysis/BasicAA/gep-alias.ll
Analysis/BasicAA/global-size.ll
Analysis/BasicAA/modref.ll
Analysis/BasicAA/nocapture.ll
Analysis/BasicAA/tailcall-modref.ll
Analysis/CFLAliasAnalysis/Steensgaard/full-store-partial-alias.ll
Analysis/GlobalsModRef/dead-uses.ll
Analysis/GlobalsModRef/indirect-global.ll
Analysis/GlobalsModRef/memset-escape.ll
Analysis/GlobalsModRef/pr35899-dbg-value.ll
Analysis/GlobalsModRef/purecse.ll
Analysis/MemoryDependenceAnalysis/InvariantLoad.ll
Analysis/MemorySSA/nondeterminism.ll
Analysis/MemorySSA/phi-translation.ll
Analysis/ScalarEvolution/2012-03-26-LoadConstant.ll
Analysis/TypeBasedAliasAnalysis/memcpyopt.ll
Analysis/ValueTracking/aarch64.irg.ll
Analysis/ValueTracking/assume-queries-counter.ll
Analysis/ValueTracking/assume.ll
Analysis/ValueTracking/gep-negative-issue.ll
Analysis/ValueTracking/get-pointer-base-with-const-off.ll
Analysis/ValueTracking/invariant.group.ll
Analysis/ValueTracking/known-bits-from-range-md.ll
Analysis/ValueTracking/known-non-equal.ll
Analysis/ValueTracking/known-nonnull-at.ll
Analysis/ValueTracking/knownzero-shift.ll
Analysis/ValueTracking/monotonic-phi.ll
Analysis/ValueTracking/non-negative-phi-bits.ll
Analysis/ValueTracking/numsignbits-from-assume.ll
Analysis/ValueTracking/select-pattern.ll
Analysis/ValueTracking/signbits-extract-elt.ll
Assembler/2003-08-20-ConstantExprGEP-Fold.ll
Bitcode/value-with-long-name.ll
CodeGen/AMDGPU/GlobalISel/ashr.ll
CodeGen/AMDGPU/GlobalISel/llvm.powi.ll
CodeGen/AMDGPU/GlobalISel/lshr.ll
CodeGen/AMDGPU/GlobalISel/shl.ll
CodeGen/AMDGPU/GlobalISel/udiv.i64.ll
CodeGen/AMDGPU/GlobalISel/urem.i64.ll
CodeGen/AMDGPU/aa-points-to-constant-memory.ll
CodeGen/AMDGPU/amdgpu-codegenprepare-idiv.ll
CodeGen/AMDGPU/branch-relaxation.ll
CodeGen/AMDGPU/bypass-div.ll
CodeGen/AMDGPU/chain-hi-to-lo.ll
CodeGen/AMDGPU/cndmask-no-def-vcc.ll
CodeGen/AMDGPU/dagcombine-setcc-select.ll
CodeGen/AMDGPU/debug-value.ll
CodeGen/AMDGPU/ds_write2.ll
CodeGen/AMDGPU/fdiv32-to-rcp-folding.ll
CodeGen/AMDGPU/global-variable-relocs.ll
CodeGen/AMDGPU/idiv-licm.ll
CodeGen/AMDGPU/imm.ll
CodeGen/AMDGPU/loop_exit_with_xor.ll
CodeGen/AMDGPU/memory_clause.ll
CodeGen/AMDGPU/nested-loop-conditions.ll
CodeGen/AMDGPU/propagate-attributes-single-set.ll
CodeGen/AMDGPU/reqd-work-group-size.ll
CodeGen/AMDGPU/sdiv64.ll
CodeGen/AMDGPU/setcc-opt.ll
CodeGen/AMDGPU/simplify-libcalls.ll
CodeGen/AMDGPU/skip-if-dead.ll
CodeGen/AMDGPU/splitkit-getsubrangeformask.ll
CodeGen/AMDGPU/srem64.ll
CodeGen/AMDGPU/sroa-before-unroll.ll
CodeGen/AMDGPU/sub.v2i16.ll
CodeGen/AMDGPU/udiv64.ll
CodeGen/AMDGPU/unroll.ll
CodeGen/AMDGPU/urem64.ll
CodeGen/AMDGPU/vector-alloca-atomic.ll
CodeGen/AMDGPU/vector-alloca-bitcast.ll
CodeGen/AMDGPU/vector-alloca.ll
CodeGen/BPF/adjust-opt-icmp1.ll
CodeGen/BPF/adjust-opt-icmp2.ll
CodeGen/BPF/adjust-opt-speculative1.ll
CodeGen/BPF/adjust-opt-speculative2.ll
CodeGen/BPF/simplifycfg.ll
CodeGen/NVPTX/call-with-alloca-buffer.ll
CodeGen/X86/and-or-fold.ll
CodeGen/X86/memcmp-constant.ll
CodeGen/X86/memcmp.ll
CodeGen/X86/no-plt-libcalls.ll
CodeGen/X86/pr38762.ll
CodeGen/X86/pr38763.ll
DebugInfo/Generic/dbg-value-lower-linenos.ll
DebugInfo/Generic/instcombine-phi.ll
DebugInfo/Generic/simplifycfg_sink_last_inst.ll
DebugInfo/Generic/store-tail-merge.ll
DebugInfo/X86/dbg-value-dropped-instcombine.ll
DebugInfo/X86/formal_parameter.ll
DebugInfo/X86/instcombine-demanded-bits-salvage.ll
DebugInfo/X86/instcombine-instrinsics.ll
ExecutionEngine/MCJIT/remote/test-common-symbols-remote.ll
Feature/OperandBundles/basic-aa-argmemonly.ll
Feature/optnone-opt.ll
LTO/X86/tli-nobuiltin.ll
LTO/X86/triple-init.ll
Other/2008-06-04-FieldSizeInPacked.ll
Other/cgscc-devirt-iteration.ll
Other/cgscc-disconnected-invalidation.ll
Other/cgscc-iterate-function-mutation.ll
Other/cgscc-libcall-update.ll
Other/constant-fold-gep.ll
Other/debugcounter-newgvn.ll
Other/devirtualization-undef.ll
Other/lint.ll
Other/new-pm-defaults.ll
Other/new-pm-lto-defaults.ll
Other/new-pm-pgo-preinline.ll
Other/new-pm-thinlto-postlink-pgo-defaults.ll
Other/new-pm-thinlto-defaults.ll
Other/new-pm-thinlto-postlink-samplepgo-defaults.ll
Other/new-pm-thinlto-prelink-pgo-defaults.ll
Other/new-pm-thinlto-prelink-samplepgo-defaults.ll
Other/print-debug-counter.ll
Other/size-remarks.ll
ThinLTO/X86/cfi-devirt.ll
ThinLTO/X86/cfi-unsat.ll
ThinLTO/X86/devirt_external_comdat_same_guid.ll
ThinLTO/X86/devirt_promote_legacy.ll
ThinLTO/X86/devirt_promote.ll
ThinLTO/X86/tli-nobuiltin.ll
Transforms/AggressiveInstCombine/funnel.ll
Transforms/AggressiveInstCombine/masked-cmp.ll
Transforms/AggressiveInstCombine/popcount.ll
Transforms/AggressiveInstCombine/rotate.ll
Transforms/AggressiveInstCombine/trunc_const_expr.ll
Transforms/AggressiveInstCombine/trunc_multi_uses.ll
Transforms/AggressiveInstCombine/trunc_select.ll
Transforms/AggressiveInstCombine/trunc_select_cmp.ll
Transforms/BDCE/basic.ll
Transforms/CallSiteSplitting/callsite-split.ll
Transforms/CallSiteSplitting/split-loop.ll
Transforms/CodeGenPrepare/X86/widenable-condition.ll
Transforms/Coroutines/ArgAddr.ll
Transforms/Coroutines/coro-alloca-01.ll
Transforms/Coroutines/coro-alloca-04.ll
Transforms/Coroutines/coro-alloca-05.ll
Transforms/Coroutines/coro-catchswitch-cleanuppad.ll
Transforms/Coroutines/coro-catchswitch.ll
Transforms/Coroutines/coro-async.ll
Transforms/Coroutines/coro-frame-arrayalloca.ll
Transforms/Coroutines/coro-frame.ll
Transforms/Coroutines/coro-heap-elide.ll
Transforms/Coroutines/coro-padding.ll
Transforms/Coroutines/coro-param-copy.ll
Transforms/Coroutines/coro-retcon-alloca.ll
Transforms/Coroutines/coro-retcon-once-value.ll
Transforms/Coroutines/coro-retcon-once-value2.ll
Transforms/Coroutines/coro-retcon-resume-values2.ll
Transforms/Coroutines/coro-retcon-resume-values.ll
Transforms/Coroutines/coro-retcon-unreachable.ll
Transforms/Coroutines/coro-retcon-value.ll
Transforms/Coroutines/coro-retcon.ll
Transforms/Coroutines/coro-spill-after-phi.ll
Transforms/Coroutines/coro-spill-defs-before-corobegin.ll
Transforms/Coroutines/coro-split-02.ll
Transforms/Coroutines/coro-split-01.ll
Transforms/Coroutines/coro-split-eh-00.ll
Transforms/Coroutines/coro-split-eh-01.ll
Transforms/Coroutines/coro-split-sink-lifetime-01.ll
Transforms/Coroutines/coro-split-sink-lifetime-03.ll
Transforms/Coroutines/coro-split-sink-lifetime-04.ll
Transforms/Coroutines/coro-swifterror.ll
Transforms/Coroutines/ex0.ll
Transforms/Coroutines/ex1.ll
Transforms/Coroutines/ex2.ll
Transforms/Coroutines/ex3.ll
Transforms/Coroutines/ex4.ll
Transforms/Coroutines/ex5.ll
Transforms/Coroutines/no-suspend.ll
Transforms/CorrelatedValuePropagation/overflows.ll
Transforms/DeadArgElim/multdeadretval.ll
Transforms/EarlyCSE/and_or.ll
Transforms/EarlyCSE/atomics.ll
Transforms/EarlyCSE/basic.ll
Transforms/EarlyCSE/commute.ll
Transforms/EarlyCSE/const-speculation.ll
Transforms/EarlyCSE/debuginfo-dce.ll
Transforms/EarlyCSE/floatingpoint.ll
Transforms/EarlyCSE/gc_relocate.ll
Transforms/EarlyCSE/guards.ll
Transforms/EarlyCSE/invariant.start.ll
Transforms/EarlyCSE/memoryssa.ll
Transforms/GVN/2010-11-13-Simplify.ll
Transforms/GVN/PRE/2017-06-28-pre-load-dbgloc.ll
Transforms/GVN/PRE/2018-06-08-pre-load-dbgloc-no-null-opt.ll
Transforms/GVN/PRE/atomic.ll
Transforms/GVN/PRE/invariant-load.ll
Transforms/GVN/PRE/load-pre-licm.ll
Transforms/GVN/PRE/pre-gep-load.ll
Transforms/GVN/PRE/rle.ll
Transforms/GVN/PRE/volatile.ll
Transforms/GVN/assume-equal.ll
Transforms/GVN/big-endian.ll
Transforms/GVN/calls-nonlocal.ll
Transforms/GVN/calls-readonly.ll
Transforms/GVN/commute.ll
Transforms/GVN/cond_br.ll
Transforms/GVN/condprop.ll
Transforms/GVN/cond_br2.ll
Transforms/GVN/constexpr-vector-constainsundef-crash-inseltpoison.ll
Transforms/GVN/constexpr-vector-constainsundef-crash.ll
Transforms/GVN/critical-edge-split-indbr-pred-in-loop.ll
Transforms/GVN/edge.ll
Transforms/GVN/fence.ll
Transforms/GVN/fold-const-expr.ll
Transforms/GVN/freeze.ll
Transforms/GVN/invariant.group.ll
Transforms/GVN/load-constant-mem.ll
Transforms/GVN/loadpre-missed-opportunity.ll
Transforms/GVN/masked-load-store-vn-crash.ll
Transforms/GVN/pr14166.ll
Transforms/GVN/preserve-memoryssa.ll
Transforms/GVN/tbaa.ll
Transforms/GVN/vscale.ll
Transforms/GVNSink/indirect-call.ll
Transforms/GVNSink/sink-common-code.ll
Transforms/GlobalDCE/deadblockaddr.ll
Transforms/GlobalOpt/constantexpr-dangle.ll
Transforms/GlobalOpt/evaluate-bitcast.ll
Transforms/GlobalOpt/evaluate-call.ll
Transforms/GlobalOpt/evaluate-constfold-call.ll
Transforms/GlobalOpt/integer-bool.ll
Transforms/IndVarSimplify/2014-06-21-congruent-constant.ll
Transforms/IndVarSimplify/X86/2009-04-15-shorten-iv-vars-2.ll
Transforms/IndVarSimplify/X86/pr45360.ll
Transforms/IndVarSimplify/exit_value_tests.ll
Transforms/IndVarSimplify/loop_evaluate_1.ll
Transforms/IndVarSimplify/rewrite-loop-exit-value.ll
Transforms/Inline/byval-tail-call.ll
Transforms/Inline/cgscc-cycle.ll
Transforms/Inline/devirtualize-3.ll
Transforms/Inline/devirtualize-4.ll
Transforms/Inline/devirtualize-5.ll
Transforms/Inline/devirtualize.ll
Transforms/Inline/inline-constexpr-addrspacecast-argument.ll
Transforms/Inline/inline_cleanup.ll
Transforms/Inline/inline_constprop.ll
Transforms/Inline/invoke_test-2.ll
Transforms/Inline/pr50270.ll
Transforms/Inline/ptr-diff.ll
Transforms/Inline/recursive.ll
Transforms/InstCombine/2003-05-26-CastMiscompile.ll
Transforms/InstCombine/2003-08-12-AllocaNonNull.ll
Transforms/InstCombine/2004-08-10-BoolSetCC.ll
Transforms/InstCombine/2004-09-20-BadLoadCombine.ll
Transforms/InstCombine/2004-11-22-Missed-and-fold.ll
Transforms/InstCombine/2004-11-27-SetCCForCastLargerAndConstant.ll
Transforms/InstCombine/2006-04-28-ShiftShiftLongLong.ll
Transforms/InstCombine/2006-10-19-SignedToUnsignedCastAndConst-2.ll
Transforms/InstCombine/2006-10-26-VectorReassoc.ll
Transforms/InstCombine/2006-12-15-Range-Test.ll
Transforms/InstCombine/2007-01-13-ExtCompareMiscompile.ll
Transforms/InstCombine/2007-03-13-CompareMerge.ll
Transforms/InstCombine/2007-03-19-BadTruncChangePR1261.ll
Transforms/InstCombine/2007-03-21-SignedRangeTest.ll
Transforms/InstCombine/2007-03-25-BadShiftMask.ll
Transforms/InstCombine/2007-03-25-DoubleShift.ll
Transforms/InstCombine/2007-03-26-BadShiftMask.ll
Transforms/InstCombine/2007-05-10-icmp-or.ll
Transforms/InstCombine/2007-06-21-DivCompareMiscomp.ll
Transforms/InstCombine/2007-10-10-EliminateMemCpy.ll
Transforms/InstCombine/2007-11-15-CompareMiscomp.ll
Transforms/InstCombine/2007-12-16-AsmNoUnwind.ll
Transforms/InstCombine/2007-12-18-AddSelCmpSub.ll
Transforms/InstCombine/2007-12-28-IcmpSub2.ll
Transforms/InstCombine/2008-01-06-BitCastAttributes.ll
Transforms/InstCombine/2008-01-13-AndCmpCmp.ll
Transforms/InstCombine/2008-01-21-MismatchedCastAndCompare.ll
Transforms/InstCombine/2008-01-21-MulTrunc.ll
Transforms/InstCombine/2008-02-16-SDivOverflow2.ll
Transforms/InstCombine/2008-02-23-MulSub.ll
Transforms/InstCombine/2008-02-28-OrFCmpCrash.ll
Transforms/InstCombine/2008-05-08-StrLenSink.ll
Transforms/InstCombine/2008-05-18-FoldIntToPtr.ll
Transforms/InstCombine/2008-05-31-AddBool.ll
Transforms/InstCombine/2008-05-23-CompareFold.ll
Transforms/InstCombine/2008-05-31-Bools.ll
Transforms/InstCombine/2008-06-21-CompareMiscomp.ll
Transforms/InstCombine/2008-07-08-ShiftOneAndOne.ll
Transforms/InstCombine/2008-07-10-CastSextBool.ll
Transforms/InstCombine/2008-07-11-RemAnd.ll
Transforms/InstCombine/2008-07-13-DivZero.ll
Transforms/InstCombine/2008-08-05-And.ll
Transforms/InstCombine/2008-10-11-DivCompareFold.ll
Transforms/InstCombine/2008-11-01-SRemDemandedBits.ll
Transforms/InstCombine/2008-11-08-FCmp.ll
Transforms/InstCombine/2008-11-27-IDivVector.ll
Transforms/InstCombine/2008-11-27-MultiplyIntVec.ll
Transforms/InstCombine/2008-12-17-SRemNegConstVec.ll
Transforms/InstCombine/2009-01-08-AlignAlloca.ll
Transforms/InstCombine/2009-01-19-fmod-constant-float.ll
Transforms/InstCombine/2009-01-19-fmod-constant-float-specials.ll
Transforms/InstCombine/2009-02-21-LoadCST.ll
Transforms/InstCombine/2009-05-23-FCmpToICmp.ll
Transforms/InstCombine/2009-12-17-CmpSelectNull.ll
Transforms/InstCombine/2010-03-03-ExtElim.ll
Transforms/InstCombine/2010-05-30-memcpy-Struct.ll
Transforms/InstCombine/2010-11-01-lshr-mask.ll
Transforms/InstCombine/2010-11-21-SizeZeroTypeGEP.ll
Transforms/InstCombine/2010-11-23-Distributed.ll
Transforms/InstCombine/2011-03-08-SRemMinusOneBadOpt.ll
Transforms/InstCombine/2011-05-28-swapmulsub.ll
Transforms/InstCombine/2011-06-13-nsw-alloca.ll
Transforms/InstCombine/2011-10-07-AlignPromotion.ll
Transforms/InstCombine/2011-09-03-Trampoline.ll
Transforms/InstCombine/2012-02-13-FCmp.ll
Transforms/InstCombine/2012-02-28-ICmp.ll
Transforms/InstCombine/2012-03-10-InstCombine.ll
Transforms/InstCombine/2012-04-24-vselect.ll
Transforms/InstCombine/2012-07-25-LoadPart.ll
Transforms/InstCombine/2012-08-28-udiv_ashl.ll
Transforms/InstCombine/2012-09-17-ZeroSizedAlloca.ll
Transforms/InstCombine/AMDGPU/amdgcn-demanded-vector-elts.ll
Transforms/InstCombine/AMDGPU/amdgcn-demanded-vector-elts-inseltpoison.ll
Transforms/InstCombine/AMDGPU/fma_legacy.ll
Transforms/InstCombine/AMDGPU/fmul_legacy.ll
Transforms/InstCombine/AMDGPU/ldexp.ll
Transforms/InstCombine/AMDGPU/memcpy-from-constant.ll
Transforms/InstCombine/AddOverFlow.ll
Transforms/InstCombine/CPP_min_max.ll
Transforms/InstCombine/ExtractCast.ll
Transforms/InstCombine/JavaCompare.ll
Transforms/InstCombine/LandingPadClauses.ll
Transforms/InstCombine/NVPTX/nvvm-intrins.ll
Transforms/InstCombine/OverlappingInsertvalues.ll
Transforms/InstCombine/PR30597.ll
Transforms/InstCombine/X86/2009-03-23-i80-fp80.ll
Transforms/InstCombine/X86/addcarry.ll
Transforms/InstCombine/X86/blend_x86.ll
Transforms/InstCombine/X86/clmulqdq.ll
Transforms/InstCombine/X86/x86-addsub-inseltpoison.ll
Transforms/InstCombine/X86/x86-addsub.ll
Transforms/InstCombine/X86/x86-avx2-inseltpoison.ll
Transforms/InstCombine/X86/x86-avx2.ll
Transforms/InstCombine/AMDGPU/amdgcn-intrinsics.ll
Transforms/InstCombine/X86/x86-avx512-inseltpoison.ll
Transforms/InstCombine/X86/x86-bmi-tbm.ll
Transforms/InstCombine/X86/x86-crc32-demanded.ll
Transforms/InstCombine/X86/x86-f16c-inseltpoison.ll
Transforms/InstCombine/X86/x86-f16c.ll
Transforms/InstCombine/X86/x86-fma.ll
Transforms/InstCombine/X86/x86-insertps.ll
Transforms/InstCombine/X86/x86-masked-memops.ll
Transforms/InstCombine/X86/x86-movmsk.ll
Transforms/InstCombine/X86/x86-muldq-inseltpoison.ll
Transforms/InstCombine/X86/x86-muldq.ll
Transforms/InstCombine/X86/x86-avx512.ll
Transforms/InstCombine/X86/x86-pack-inseltpoison.ll
Transforms/InstCombine/X86/x86-pack.ll
Transforms/InstCombine/X86/x86-pshufb-inseltpoison.ll
Transforms/InstCombine/X86/x86-sse-inseltpoison.ll
Transforms/InstCombine/X86/x86-pshufb.ll
Transforms/InstCombine/X86/x86-sse2-inseltpoison.ll
Transforms/InstCombine/X86/x86-sse.ll
Transforms/InstCombine/X86/x86-sse41-inseltpoison.ll
Transforms/InstCombine/X86/x86-sse2.ll
Transforms/InstCombine/X86/x86-sse41.ll
Transforms/InstCombine/X86/x86-sse4a-inseltpoison.ll
Transforms/InstCombine/X86/x86-sse4a.ll
Transforms/InstCombine/X86/x86-vec_demanded_elts-inseltpoison.ll
Transforms/InstCombine/X86/x86-vec_demanded_elts.ll
Transforms/InstCombine/X86/x86-vector-shifts-inseltpoison.ll
Transforms/InstCombine/X86/x86-vector-shifts.ll
Transforms/InstCombine/X86/x86-vpermil-inseltpoison.ll
Transforms/InstCombine/X86/x86-xop-inseltpoison.ll
Transforms/InstCombine/X86/x86-xop.ll
Transforms/InstCombine/X86/x86-vpermil.ll
Transforms/InstCombine/abs-1.ll
Transforms/InstCombine/abs-intrinsic.ll
Transforms/InstCombine/add-shl-sdiv-to-srem.ll
Transforms/InstCombine/add-sitofp.ll
Transforms/InstCombine/abs_abs.ll
Transforms/InstCombine/add.ll
Transforms/InstCombine/add2.ll
Transforms/InstCombine/add4.ll
Transforms/InstCombine/addnegneg.ll
Transforms/InstCombine/addrspacecast.ll
Transforms/InstCombine/addsub-constant-folding.ll
Transforms/InstCombine/adjust-for-minmax.ll
Transforms/InstCombine/aggregate-reconstruction.ll
Transforms/InstCombine/align-2d-gep.ll
Transforms/InstCombine/align-attr.ll
Transforms/InstCombine/align-addr.ll
Transforms/InstCombine/align-external.ll
Transforms/InstCombine/all-bits-shift.ll
Transforms/InstCombine/alloca-big.ll
Transforms/InstCombine/alloca-cast-debuginfo.ll
Transforms/InstCombine/allocsize-32.ll
Transforms/InstCombine/alloca.ll
Transforms/InstCombine/allocsize.ll
Transforms/InstCombine/and-compare.ll
Transforms/InstCombine/and-narrow.ll
Transforms/InstCombine/and-or-and.ll
Transforms/InstCombine/and-fcmp.ll
Transforms/InstCombine/and-or-icmp-min-max.ll
Transforms/InstCombine/and-or-icmp-nullptr.ll
Transforms/InstCombine/and-or-icmps.ll
Transforms/InstCombine/and-or.ll
Transforms/InstCombine/and-or-not.ll
Transforms/InstCombine/and-xor-merge.ll
Transforms/InstCombine/and-xor-or.ll
Transforms/InstCombine/and2.ll
Transforms/InstCombine/and.ll
Transforms/InstCombine/annotations.ll
Transforms/InstCombine/apint-add.ll
Transforms/InstCombine/apint-and-compare.ll
Transforms/InstCombine/apint-and-or-and.ll
Transforms/InstCombine/apint-and-xor-merge.ll
Transforms/InstCombine/apint-and.ll
Transforms/InstCombine/apint-call-cast-target.ll
Transforms/InstCombine/apint-cast-and-cast.ll
Transforms/InstCombine/apint-cast-cast-to-and.ll
Transforms/InstCombine/apint-cast.ll
Transforms/InstCombine/apint-div1.ll
Transforms/InstCombine/apint-div2.ll
Transforms/InstCombine/apint-mul1.ll
Transforms/InstCombine/apint-mul2.ll
Transforms/InstCombine/apint-not.ll
Transforms/InstCombine/apint-or.ll
Transforms/InstCombine/apint-rem1.ll
Transforms/InstCombine/apint-rem2.ll
Transforms/InstCombine/apint-select.ll
Transforms/InstCombine/apint-shift-simplify.ll
Transforms/InstCombine/apint-shl-trunc.ll
Transforms/InstCombine/apint-shift.ll
Transforms/InstCombine/apint-sub.ll
Transforms/InstCombine/apint-xor1.ll
Transforms/InstCombine/apint-xor2.ll
Transforms/InstCombine/ashr-lshr.ll
Transforms/InstCombine/ashr-or-mul-abs.ll
Transforms/InstCombine/assoc-cast-assoc.ll
Transforms/InstCombine/assume-align.ll
Transforms/InstCombine/assume-loop-align.ll
Transforms/InstCombine/assume-redundant.ll
Transforms/InstCombine/assume2.ll
Transforms/InstCombine/assume.ll
Transforms/InstCombine/assume_inevitable.ll
Transforms/InstCombine/atomic.ll
Transforms/InstCombine/atomicrmw.ll
Transforms/InstCombine/badmalloc.ll
Transforms/InstCombine/bcmp-1.ll
Transforms/InstCombine/bcopy.ll
Transforms/InstCombine/bitcast-bigendian.ll
Transforms/InstCombine/bit-checks.ll
Transforms/InstCombine/bitcast-bitcast.ll
Transforms/InstCombine/bitcast-function.ll
Transforms/InstCombine/bitcast-phi-uselistorder.ll
Transforms/InstCombine/bitcast-inseltpoison.ll
Transforms/InstCombine/bitcast-store.ll
Transforms/InstCombine/bitcast-vec-canon-inseltpoison.ll
Transforms/InstCombine/bitcast-vec-canon.ll
Transforms/InstCombine/bitcast.ll
Transforms/InstCombine/bitreverse-known-bits.ll
Transforms/InstCombine/bitreverse.ll
Transforms/InstCombine/bittest.ll
Transforms/InstCombine/branch.ll
Transforms/InstCombine/broadcast-inseltpoison.ll
Transforms/InstCombine/broadcast.ll
Transforms/InstCombine/bswap-fold.ll
Transforms/InstCombine/bswap-inseltpoison.ll
Transforms/InstCombine/bswap-known-bits.ll
Transforms/InstCombine/builtin-dynamic-object-size.ll
Transforms/InstCombine/builtin-object-size-custom-dl.ll
Transforms/InstCombine/bswap.ll
Transforms/InstCombine/builtin-object-size-offset.ll
Transforms/InstCombine/builtin-object-size-ptr.ll
Transforms/InstCombine/byval.ll
Transforms/InstCombine/cabs-array.ll
Transforms/InstCombine/cabs-discrete.ll
Transforms/InstCombine/call-callconv.ll
Transforms/InstCombine/call-cast-attrs.ll
Transforms/InstCombine/call-cast-target.ll
Transforms/InstCombine/call-guard.ll
Transforms/InstCombine/call-returned.ll
Transforms/InstCombine/call.ll
Transforms/InstCombine/call_nonnull_arg.ll
Transforms/InstCombine/callsite_nonnull_args_through_casts.ll
Transforms/InstCombine/canonicalize-ashr-shl-to-masking.ll
Transforms/InstCombine/canonicalize-clamp-like-pattern-between-negative-and-positive-thresholds.ll
Transforms/InstCombine/canonicalize-clamp-with-select-of-constant-threshold-pattern.ll
Transforms/InstCombine/canonicalize-clamp-like-pattern-between-zero-and-positive-threshold.ll
Transforms/InstCombine/canonicalize-constant-low-bit-mask-and-icmp-ne-to-icmp-ugt.ll
Transforms/InstCombine/canonicalize-constant-low-bit-mask-and-icmp-eq-to-icmp-ule.ll
Transforms/InstCombine/canonicalize-constant-low-bit-mask-and-icmp-sge-to-icmp-sle.ll
Transforms/InstCombine/canonicalize-constant-low-bit-mask-and-icmp-sgt-to-icmp-sgt.ll
Transforms/InstCombine/canonicalize-constant-low-bit-mask-and-icmp-sle-to-icmp-sle.ll
Transforms/InstCombine/canonicalize-constant-low-bit-mask-and-icmp-slt-to-icmp-sgt.ll
Transforms/InstCombine/canonicalize-constant-low-bit-mask-and-icmp-uge-to-icmp-ule.ll
Transforms/InstCombine/canonicalize-constant-low-bit-mask-and-icmp-ugt-to-icmp-ugt.ll
Transforms/InstCombine/canonicalize-constant-low-bit-mask-and-icmp-ult-to-icmp-ugt.ll
Transforms/InstCombine/canonicalize-constant-low-bit-mask-and-icmp-ule-to-icmp-ule.ll
Transforms/InstCombine/canonicalize-low-bit-mask-and-icmp-eq-to-icmp-ule.ll
Transforms/InstCombine/canonicalize-lack-of-signed-truncation-check.ll
Transforms/InstCombine/canonicalize-low-bit-mask-and-icmp-ne-to-icmp-ugt.ll
Transforms/InstCombine/canonicalize-low-bit-mask-v2-and-icmp-eq-to-icmp-ule.ll
Transforms/InstCombine/canonicalize-low-bit-mask-v3-and-icmp-eq-to-icmp-ule.ll
Transforms/InstCombine/canonicalize-low-bit-mask-v2-and-icmp-ne-to-icmp-ugt.ll
Transforms/InstCombine/canonicalize-low-bit-mask-v4-and-icmp-eq-to-icmp-ule.ll
Transforms/InstCombine/canonicalize-low-bit-mask-v3-and-icmp-ne-to-icmp-ugt.ll
Transforms/InstCombine/canonicalize-low-bit-mask-v4-and-icmp-ne-to-icmp-ugt.ll
Transforms/InstCombine/canonicalize-lshr-shl-to-masking.ll
Transforms/InstCombine/canonicalize-selects-icmp-condition-bittest.ll
Transforms/InstCombine/canonicalize-shl-lshr-to-masking.ll
Transforms/InstCombine/canonicalize-signed-truncation-check.ll
Transforms/InstCombine/canonicalize-vector-extract.ll
Transforms/InstCombine/canonicalize-vector-insert.ll
Transforms/InstCombine/canonicalize_branch.ll
Transforms/InstCombine/cast-call-combine-prof.ll
Transforms/InstCombine/cast-call-combine.ll
Transforms/InstCombine/cast-callee-deopt-bundles.ll
Transforms/InstCombine/cast-int-fcmp-eq-0.ll
Transforms/InstCombine/cast-int-icmp-eq-0.ll
Transforms/InstCombine/cast-mul-select.ll
Transforms/InstCombine/cast-select.ll
Transforms/InstCombine/cast-set-preserve-signed-dbg-val.ll
Transforms/InstCombine/cast-set.ll
Transforms/InstCombine/cast-unsigned-icmp-eqcmp-0.ll
Transforms/InstCombine/cast_phi.ll
Transforms/InstCombine/cast_ptr.ll
Transforms/InstCombine/cast.ll
Transforms/InstCombine/ceil.ll
Transforms/InstCombine/clamp-to-minmax.ll
Transforms/InstCombine/cmp-x-vs-neg-x.ll
Transforms/InstCombine/cmp-intrinsic.ll
Transforms/InstCombine/commutative-intrinsics.ll
Transforms/InstCombine/compare-3way.ll
Transforms/InstCombine/compare-alloca.ll
Transforms/InstCombine/compare-signs.ll
Transforms/InstCombine/compare-udiv.ll
Transforms/InstCombine/compare-unescaped.ll
Transforms/InstCombine/consecutive-fences.ll
Transforms/InstCombine/constant-expr-datalayout.ll
Transforms/InstCombine/conditional-variable-length-signext-after-high-bit-extract.ll
Transforms/InstCombine/constant-fold-alias.ll
Transforms/InstCombine/constant-fold-address-space-pointer.ll
Transforms/InstCombine/constant-fold-compare.ll
Transforms/InstCombine/constant-fold-iteration.ll
Transforms/InstCombine/constant-fold-libfunc.ll
Transforms/InstCombine/constant-fold-gep.ll
Transforms/InstCombine/constant-fold-math.ll
Transforms/InstCombine/constant-fold-shifts.ll
Transforms/InstCombine/convergent.ll
Transforms/InstCombine/cos-1.ll
Transforms/InstCombine/copysign.ll
Transforms/InstCombine/cos-sin-intrinsic.ll
Transforms/InstCombine/ctlz-cttz-bitreverse.ll
Transforms/InstCombine/ctpop-bswap-bitreverse.ll
Transforms/InstCombine/ctpop-cttz.ll
Transforms/InstCombine/ctpop.ll
Transforms/InstCombine/cttz-negative.ll
Transforms/InstCombine/cttz-abs.ll
Transforms/InstCombine/deadcode.ll
Transforms/InstCombine/dce-iterate.ll
Transforms/InstCombine/debug-line.ll
Transforms/InstCombine/debuginfo-dce.ll
Transforms/InstCombine/debuginfo-dce2.ll
Transforms/InstCombine/debuginfo-sink.ll
Transforms/InstCombine/debuginfo-skip.ll
Transforms/InstCombine/debuginfo.ll
Transforms/InstCombine/debuginfo-variables.ll
Transforms/InstCombine/debuginfo_add.ll
Transforms/InstCombine/demand_shrink_nsw.ll
Transforms/InstCombine/demorgan-sink-not-into-xor.ll
Transforms/InstCombine/demorgan.ll
Transforms/InstCombine/deref-alloc-fns.ll
Transforms/InstCombine/distribute.ll
Transforms/InstCombine/div-shift.ll
Transforms/InstCombine/do-not-clone-dbg-declare.ll
Transforms/InstCombine/div.ll
Transforms/InstCombine/dont-distribute-phi.ll
Transforms/InstCombine/double-float-shrink-1.ll
Transforms/InstCombine/early_constfold_changes_IR.ll
Transforms/InstCombine/double-float-shrink-2.ll
Transforms/InstCombine/erase-dbg-values-at-dead-alloc-site.ll
Transforms/InstCombine/element-atomic-memintrins.ll
Transforms/InstCombine/err-rep-cold.ll
Transforms/InstCombine/exact.ll
Transforms/InstCombine/exp2-1.ll
Transforms/InstCombine/extractelement-inseltpoison.ll
Transforms/InstCombine/extractelement.ll
Transforms/InstCombine/extractinsert-tbaa.ll
Transforms/InstCombine/extractvalue.ll
Transforms/InstCombine/fabs-copysign.ll
Transforms/InstCombine/fabs-libcall.ll
Transforms/InstCombine/fadd-fsub-factor.ll
Transforms/InstCombine/fadd.ll
Transforms/InstCombine/fabs.ll
Transforms/InstCombine/fcmp-select.ll
Transforms/InstCombine/fast-math.ll
Transforms/InstCombine/fcmp-special.ll
Transforms/InstCombine/fdiv-cos-sin.ll
Transforms/InstCombine/fcmp.ll
Transforms/InstCombine/fdiv-sin-cos.ll
Transforms/InstCombine/ffs-1.ll
Transforms/InstCombine/fdiv.ll
Transforms/InstCombine/fls.ll
Transforms/InstCombine/float-shrink-compare.ll
Transforms/InstCombine/fmul-exp.ll
Transforms/InstCombine/fmul-exp2.ll
Transforms/InstCombine/fmul-inseltpoison.ll
Transforms/InstCombine/fmul-pow.ll
Transforms/InstCombine/fmul-sqrt.ll
Transforms/InstCombine/fma.ll
Transforms/InstCombine/fmul.ll
Transforms/InstCombine/fneg.ll
Transforms/InstCombine/fold-calls.ll
Transforms/InstCombine/fold-bin-operand.ll
Transforms/InstCombine/fold-fops-into-selects.ll
Transforms/InstCombine/fold-inc-of-add-of-not-x-and-y-to-sub-x-from-y.ll
Transforms/InstCombine/fold-phi-load-metadata.ll
Transforms/InstCombine/fold-sub-of-not-to-inc-of-add.ll
Transforms/InstCombine/fold-vector-select.ll
Transforms/InstCombine/fold-vector-zero-inseltpoison.ll
Transforms/InstCombine/fold-vector-zero.ll
Transforms/InstCombine/fpcast.ll
Transforms/InstCombine/fpextend.ll
Transforms/InstCombine/fpextend_x86.ll
Transforms/InstCombine/fortify-folding.ll
Transforms/InstCombine/fprintf-1.ll
Transforms/InstCombine/fptrunc.ll
Transforms/InstCombine/fputs-1.ll
Transforms/InstCombine/freeze-phi.ll
Transforms/InstCombine/freeze.ll
Transforms/InstCombine/fputs-opt-size.ll
Transforms/InstCombine/fsub.ll
Transforms/InstCombine/fsh.ll
Transforms/InstCombine/fwrite-1.ll
Transforms/InstCombine/funnel.ll
Transforms/InstCombine/gc.relocate.ll
Transforms/InstCombine/gep-addrspace.ll
Transforms/InstCombine/gep-combine-loop-invariant.ll
Transforms/InstCombine/gep-inbounds-null.ll
Transforms/InstCombine/gep-custom-dl.ll
Transforms/InstCombine/gep-sext.ll
Transforms/InstCombine/gep-vector.ll
Transforms/InstCombine/gepphigep.ll
Transforms/InstCombine/high-bit-signmask-with-trunc.ll
Transforms/InstCombine/high-bit-signmask.ll
Transforms/InstCombine/hoist-negation-out-of-bias-calculation-with-constant.ll
Transforms/InstCombine/hoist-negation-out-of-bias-calculation.ll
Transforms/InstCombine/hoist-xor-by-constant-from-xor-by-value.ll
Transforms/InstCombine/hoist_instr.ll
Transforms/InstCombine/getelementptr.ll
Transforms/InstCombine/icmp-bc-vec-inseltpoison.ll
Transforms/InstCombine/icmp-add.ll
Transforms/InstCombine/icmp-bitcast-glob.ll
Transforms/InstCombine/icmp-bc-vec.ll
Transforms/InstCombine/icmp-constant-phi.ll
Transforms/InstCombine/icmp-custom-dl.ll
Transforms/InstCombine/icmp-div-constant.ll
Transforms/InstCombine/icmp-dom.ll
Transforms/InstCombine/icmp-mul-zext.ll
Transforms/InstCombine/icmp-logical.ll
Transforms/InstCombine/icmp-mul.ll
Transforms/InstCombine/icmp-or.ll
Transforms/InstCombine/icmp-range.ll
Transforms/InstCombine/icmp-shl-nsw.ll
Transforms/InstCombine/icmp-shl-nuw.ll
Transforms/InstCombine/icmp-shr.ll
Transforms/InstCombine/icmp-shr-lt-gt.ll
Transforms/InstCombine/icmp-sub.ll
Transforms/InstCombine/icmp-uge-of-add-of-shl-one-by-bits-to-allones-and-val-to-icmp-eq-of-lshr-val-by-bits-and-0.ll
Transforms/InstCombine/icmp-uge-of-not-of-shl-allones-by-bits-and-val-to-icmp-eq-of-lshr-val-by-bits-and-0.ll
Transforms/InstCombine/icmp-ugt-of-shl-1-by-bits-and-val-to-icmp-eq-of-lshr-val-by-bits-and-0.ll
Transforms/InstCombine/icmp-ule-of-shl-1-by-bits-and-val-to-icmp-ne-of-lshr-val-by-bits-and-0.ll
Transforms/InstCombine/icmp-ult-of-add-of-shl-one-by-bits-to-allones-and-val-to-icmp-ne-of-lshr-val-by-bits-and-0.ll
Transforms/InstCombine/icmp-ult-of-not-of-shl-allones-by-bits-and-val-to-icmp-ne-of-lshr-val-by-bits-and-0.ll
Transforms/InstCombine/icmp-vec.ll
Transforms/InstCombine/icmp-vec-inseltpoison.ll
Transforms/InstCombine/icmp-xor-signbit.ll
Transforms/InstCombine/icmp_sdiv_with_and_without_range.ll
Transforms/InstCombine/idioms.ll
Transforms/InstCombine/indexed-gep-compares.ll
Transforms/InstCombine/icmp.ll
Transforms/InstCombine/inline-intrinsic-assert.ll
Transforms/InstCombine/inselt-binop-inseltpoison.ll
Transforms/InstCombine/inselt-binop.ll
Transforms/InstCombine/insert-const-shuf.ll
Transforms/InstCombine/insert-extract-shuffle-inseltpoison.ll
Transforms/InstCombine/insert-val-extract-elem.ll
Transforms/InstCombine/insert-extract-shuffle.ll
Transforms/InstCombine/int_sideeffect.ll
Transforms/InstCombine/insertelement-bitcast.ll
Transforms/InstCombine/intersect-accessgroup.ll
Transforms/InstCombine/intptr1.ll
Transforms/InstCombine/intptr2.ll
Transforms/InstCombine/intptr3.ll
Transforms/InstCombine/intptr4.ll
Transforms/InstCombine/intptr5.ll
Transforms/InstCombine/intptr7.ll
Transforms/InstCombine/invariant.group.ll
Transforms/InstCombine/intrinsics.ll
Transforms/InstCombine/invert-variable-mask-in-masked-merge-scalar.ll
Transforms/InstCombine/invert-variable-mask-in-masked-merge-vector.ll
Transforms/InstCombine/invoke.ll
Transforms/InstCombine/isascii-1.ll
Transforms/InstCombine/isdigit-1.ll
Transforms/InstCombine/known-bits.ll
Transforms/InstCombine/known-never-nan.ll
Transforms/InstCombine/ispow2.ll
Transforms/InstCombine/known-signbit-shift.ll
Transforms/InstCombine/known-non-zero.ll
Transforms/InstCombine/lifetime-no-null-opt.ll
Transforms/InstCombine/lifetime.ll
Transforms/InstCombine/load-bitcast-select.ll
Transforms/InstCombine/load-bitcast-vec.ll
Transforms/InstCombine/load-bitcast32.ll
Transforms/InstCombine/load-bitcast64.ll
Transforms/InstCombine/load-cmp.ll
Transforms/InstCombine/load-combine-metadata-dominance.ll
Transforms/InstCombine/load-combine-metadata.ll
Transforms/InstCombine/load-insert-store.ll
Transforms/InstCombine/load-select.ll
Transforms/InstCombine/load.ll
Transforms/InstCombine/load3.ll
Transforms/InstCombine/load_combine_aa.ll
Transforms/InstCombine/loadstore-alignment.ll
Transforms/InstCombine/loadstore-metadata.ll
Transforms/InstCombine/log-pow.ll
Transforms/InstCombine/logical-select-inseltpoison.ll
Transforms/InstCombine/logical-select.ll
Transforms/InstCombine/lower-dbg-declare.ll
Transforms/InstCombine/lshr-and-negC-icmpeq-zero.ll
Transforms/InstCombine/lshr-phi.ll
Transforms/InstCombine/lshr-and-signbit-icmpeq-zero.ll
Transforms/InstCombine/lshr.ll
Transforms/InstCombine/malloc-free-delete.ll
Transforms/InstCombine/masked-merge-and-of-ors.ll
Transforms/InstCombine/masked-merge-add.ll
Transforms/InstCombine/masked-merge-or.ll
Transforms/InstCombine/masked-merge-xor.ll
Transforms/InstCombine/masked_intrinsics-inseltpoison.ll
Transforms/InstCombine/masked_intrinsics.ll
Transforms/InstCombine/max_known_bits.ll
Transforms/InstCombine/max-of-nots.ll
Transforms/InstCombine/maxnum.ll
Transforms/InstCombine/maximum.ll
Transforms/InstCombine/mem-deref-bytes-addrspaces.ll
Transforms/InstCombine/mem-gep-zidx.ll
Transforms/InstCombine/mem-deref-bytes.ll
Transforms/InstCombine/mem-par-metadata-memcpy.ll
Transforms/InstCombine/memchr.ll
Transforms/InstCombine/memccpy.ll
Transforms/InstCombine/memcmp-1.ll
Transforms/InstCombine/memcmp-constant-fold.ll
Transforms/InstCombine/memcpy-1.ll
Transforms/InstCombine/memcpy-addrspace.ll
Transforms/InstCombine/memcpy-to-load.ll
Transforms/InstCombine/memcpy.ll
Transforms/InstCombine/memcpy_chk-1.ll
Transforms/InstCombine/memcpy-from-global.ll
Transforms/InstCombine/memcpy_chk-2.ll
Transforms/InstCombine/memmove-1.ll
Transforms/InstCombine/memmove.ll
Transforms/InstCombine/memmove_chk-1.ll
Transforms/InstCombine/memmove_chk-2.ll
Transforms/InstCombine/mempcpy.ll
Transforms/InstCombine/memset-1.ll
Transforms/InstCombine/memset.ll
Transforms/InstCombine/memset2.ll
Transforms/InstCombine/memset_chk-1.ll
Transforms/InstCombine/memset_chk-2.ll
Transforms/InstCombine/merge-icmp.ll
Transforms/InstCombine/merging-multiple-stores-into-successor.ll
Transforms/InstCombine/min-positive.ll
Transforms/InstCombine/minmax-demandbits.ll
Transforms/InstCombine/minimum.ll
Transforms/InstCombine/minmax-fp.ll
Transforms/InstCombine/minmax-fold.ll
Transforms/InstCombine/minmax-intrinsics.ll
Transforms/InstCombine/minmax-of-minmax.ll
Transforms/InstCombine/misc-2002.ll
Transforms/InstCombine/minnum.ll
Transforms/InstCombine/mul-masked-bits.ll
Transforms/InstCombine/mul-inseltpoison.ll
Transforms/InstCombine/multi-size-address-space-pointer.ll
Transforms/InstCombine/mul.ll
Transforms/InstCombine/multi-use-or.ll
Transforms/InstCombine/multiple-uses-load-bitcast-select.ll
Transforms/InstCombine/narrow-math.ll
Transforms/InstCombine/narrow-switch.ll
Transforms/InstCombine/narrow.ll
Transforms/InstCombine/no_cgscc_assert.ll
Transforms/InstCombine/noalias-scope-decl.ll
Transforms/InstCombine/non-integral-pointers.ll
Transforms/InstCombine/nonnull-attribute.ll
Transforms/InstCombine/not-add.ll
Transforms/InstCombine/not.ll
Transforms/InstCombine/nothrow.ll
Transforms/InstCombine/nsw-inseltpoison.ll
Transforms/InstCombine/obfuscated_splat-inseltpoison.ll
Transforms/InstCombine/nsw.ll
Transforms/InstCombine/obfuscated_splat.ll
Transforms/InstCombine/objsize-address-space.ll
Transforms/InstCombine/objsize-64.ll
Transforms/InstCombine/objsize-noverify.ll
Transforms/InstCombine/odr-linkage.ll
Transforms/InstCombine/objsize.ll
Transforms/InstCombine/omit-urem-of-power-of-two-or-zero-when-comparing-with-zero.ll
Transforms/InstCombine/onehot_merge.ll
Transforms/InstCombine/operand-complexity.ll
Transforms/InstCombine/or-concat.ll
Transforms/InstCombine/or-shifted-masks.ll
Transforms/InstCombine/or-xor.ll
Transforms/InstCombine/or-fcmp.ll
Transforms/InstCombine/osx-names.ll
Transforms/InstCombine/out-of-bounds-indexes.ll
Transforms/InstCombine/or.ll
Transforms/InstCombine/overflow.ll
Transforms/InstCombine/overflow-mul.ll
Transforms/InstCombine/partally-redundant-left-shift-input-masking-after-truncation-variant-a.ll
Transforms/InstCombine/overflow_to_sat.ll
Transforms/InstCombine/partally-redundant-left-shift-input-masking-after-truncation-variant-b.ll
Transforms/InstCombine/partally-redundant-left-shift-input-masking-after-truncation-variant-c.ll
Transforms/InstCombine/partally-redundant-left-shift-input-masking-after-truncation-variant-d.ll
Transforms/InstCombine/partally-redundant-left-shift-input-masking-after-truncation-variant-e.ll
Transforms/InstCombine/partally-redundant-left-shift-input-masking-variant-a.ll
Transforms/InstCombine/partally-redundant-left-shift-input-masking-variant-b.ll
Transforms/InstCombine/partally-redundant-left-shift-input-masking-variant-c.ll
Transforms/InstCombine/partally-redundant-left-shift-input-masking-variant-d.ll
Transforms/InstCombine/partally-redundant-left-shift-input-masking-variant-e.ll
Transforms/InstCombine/phi-aware-aggregate-reconstruction.ll
Transforms/InstCombine/phi-cse.ll
Transforms/InstCombine/phi-known-bits-operand-order.ll
Transforms/InstCombine/phi-equal-incoming-pointers.ll
Transforms/InstCombine/phi-load-metadata-2.ll
Transforms/InstCombine/phi-load-metadata-3.ll
Transforms/InstCombine/phi-load-metadata.ll
Transforms/InstCombine/phi-merge-gep.ll
Transforms/InstCombine/phi-of-extractvalues.ll
Transforms/InstCombine/phi-of-insertvalues.ll
Transforms/InstCombine/phi-preserve-ir-flags.ll
Transforms/InstCombine/phi-shifts.ll
Transforms/InstCombine/phi-select-constant.ll
Transforms/InstCombine/phi-timeout.ll
Transforms/InstCombine/pow-0.ll
Transforms/InstCombine/phi.ll
Transforms/InstCombine/pow-3.ll
Transforms/InstCombine/pow-1.ll
Transforms/InstCombine/pow-4.ll
Transforms/InstCombine/pow-exp.ll
Transforms/InstCombine/pow-sqrt.ll
Transforms/InstCombine/pr12251.ll
Transforms/InstCombine/pow_fp_int.ll
Transforms/InstCombine/pr14365.ll
Transforms/InstCombine/pr17827.ll
Transforms/InstCombine/pr19420.ll
Transforms/InstCombine/pr20678.ll
Transforms/InstCombine/pr21199.ll
Transforms/InstCombine/pr21651.ll
Transforms/InstCombine/pr24605.ll
Transforms/InstCombine/pr25342.ll
Transforms/InstCombine/pr2645-0.ll
Transforms/InstCombine/pr2645-0-inseltpoison.ll
Transforms/InstCombine/pr26992.ll
Transforms/InstCombine/pr27236.ll
Transforms/InstCombine/pr27332.ll
Transforms/InstCombine/pr27343.ll
Transforms/InstCombine/pr27996.ll
Transforms/InstCombine/pr28725.ll
Transforms/InstCombine/pr31990_wrong_memcpy.ll
Transforms/InstCombine/pr32686.ll
Transforms/InstCombine/pr33689_same_bitwidth.ll
Transforms/InstCombine/pr33453.ll
Transforms/InstCombine/pr34349.ll
Transforms/InstCombine/pr34627.ll
Transforms/InstCombine/pr38677.ll
Transforms/InstCombine/pr38897.ll
Transforms/InstCombine/pr38915.ll
Transforms/InstCombine/pr38984-inseltpoison.ll
Transforms/InstCombine/pr38984.ll
Transforms/InstCombine/pr39177.ll
Transforms/InstCombine/pr39908.ll
Transforms/InstCombine/pr41164.ll
Transforms/InstCombine/pr43376-getFlippedStrictnessPredicateAndConstant-assert.ll
Transforms/InstCombine/pr43893.ll
Transforms/InstCombine/pr44242.ll
Transforms/InstCombine/pr44541.ll
Transforms/InstCombine/pr44245.ll
Transforms/InstCombine/pr44552.ll
Transforms/InstCombine/pr44835.ll
Transforms/InstCombine/pr46680.ll
Transforms/InstCombine/prefetch-load.ll
Transforms/InstCombine/prevent-cmp-merge.ll
Transforms/InstCombine/printf-2.ll
Transforms/InstCombine/printf-1.ll
Transforms/InstCombine/printf-3.ll
Transforms/InstCombine/ptr-int-cast.ll
Transforms/InstCombine/pull-binop-through-shift.ll
Transforms/InstCombine/pull-conditional-binop-through-shift.ll
Transforms/InstCombine/puts-1.ll
Transforms/InstCombine/range-check.ll
Transforms/InstCombine/realloc.ll
Transforms/InstCombine/reassociate-nuw.ll
Transforms/InstCombine/redundant-left-shift-input-masking-after-truncation-variant-a.ll
Transforms/InstCombine/redundant-left-shift-input-masking-after-truncation-variant-b.ll
Transforms/InstCombine/redundant-left-shift-input-masking-after-truncation-variant-c.ll
Transforms/InstCombine/redundant-left-shift-input-masking-after-truncation-variant-d.ll
Transforms/InstCombine/redundant-left-shift-input-masking-after-truncation-variant-e.ll
Transforms/InstCombine/redundant-left-shift-input-masking-after-truncation-variant-f.ll
Transforms/InstCombine/redundant-left-shift-input-masking-variant-a.ll
Transforms/InstCombine/redundant-left-shift-input-masking-variant-b.ll
Transforms/InstCombine/redundant-left-shift-input-masking-variant-c.ll
Transforms/InstCombine/redundant-left-shift-input-masking-variant-d.ll
Transforms/InstCombine/redundant-left-shift-input-masking-variant-e.ll
Transforms/InstCombine/redundant-left-shift-input-masking-variant-f.ll
Transforms/InstCombine/rem.ll
Transforms/InstCombine/result-of-add-of-negative-is-non-zero-and-no-underflow.ll
Transforms/InstCombine/result-of-add-of-negative-or-zero-is-non-zero-and-no-underflow.ll
Transforms/InstCombine/result-of-usub-is-non-zero-and-no-overflow.ll
Transforms/InstCombine/reuse-constant-from-select-in-icmp.ll
Transforms/InstCombine/sadd-with-overflow.ll
Transforms/InstCombine/rotate.ll
Transforms/InstCombine/salvage-dbg-declare.ll
Transforms/InstCombine/sadd_sat.ll
Transforms/InstCombine/scalarization-inseltpoison.ll
Transforms/InstCombine/scalarization.ll
Transforms/InstCombine/saturating-add-sub.ll
Transforms/InstCombine/sdiv-1.ll
Transforms/InstCombine/sdiv-canonicalize.ll
Transforms/InstCombine/sdiv-exact-by-negative-power-of-two.ll
Transforms/InstCombine/sdiv-exact-by-power-of-two.ll
Transforms/InstCombine/sdiv-guard.ll
Transforms/InstCombine/sdiv-of-non-negative-by-negative-power-of-two.ll
Transforms/InstCombine/select-2.ll
Transforms/InstCombine/select-and-or.ll
Transforms/InstCombine/select-bitext-bitwise-ops.ll
Transforms/InstCombine/select-binop-cmp.ll
Transforms/InstCombine/select-cmp-br.ll
Transforms/InstCombine/select-bitext.ll
Transforms/InstCombine/select-cmpxchg.ll
Transforms/InstCombine/select-crash-noverify.ll
Transforms/InstCombine/select-crash.ll
Transforms/InstCombine/select-cmp-cttz-ctlz.ll
Transforms/InstCombine/select-ctlz-to-cttz.ll
Transforms/InstCombine/select-extractelement-inseltpoison.ll
Transforms/InstCombine/select-gep.ll
Transforms/InstCombine/select-extractelement.ll
Transforms/InstCombine/select-imm-canon.ll
Transforms/InstCombine/select-icmp-and.ll
Transforms/InstCombine/select-load-call.ll
Transforms/InstCombine/select-obo-peo-ops.ll
Transforms/InstCombine/select-of-bittest.ll
Transforms/InstCombine/select-pr39595.ll
Transforms/InstCombine/select-safe-transforms.ll
Transforms/InstCombine/select-select.ll
Transforms/InstCombine/select-with-bitwise-ops.ll
Transforms/InstCombine/select_arithmetic.ll
Transforms/InstCombine/select.ll
Transforms/InstCombine/select_meta.ll
Transforms/InstCombine/set-lowbits-mask-canonicalize.ll
Transforms/InstCombine/set.ll
Transforms/InstCombine/setcc-strength-reduce.ll
Transforms/InstCombine/sext.ll
Transforms/InstCombine/shift-add-inseltpoison.ll
Transforms/InstCombine/shift-add.ll
Transforms/InstCombine/shift-amount-reassociation-in-bittest-with-truncation-shl.ll
Transforms/InstCombine/shift-amount-reassociation-in-bittest-with-truncation-lshr.ll
Transforms/InstCombine/shift-amount-reassociation-with-truncation-ashr.ll
Transforms/InstCombine/shift-amount-reassociation-in-bittest.ll
Transforms/InstCombine/shift-amount-reassociation-with-truncation-lshr.ll
Transforms/InstCombine/shift-amount-reassociation-with-truncation-shl.ll
Transforms/InstCombine/shift-amount-reassociation.ll
Transforms/InstCombine/shift-by-signext.ll
Transforms/InstCombine/shift-direction-in-bit-test.ll
Transforms/InstCombine/shift-logic.ll
Transforms/InstCombine/shift-shift.ll
Transforms/InstCombine/shift-sra.ll
Transforms/InstCombine/shl-and-negC-icmpeq-zero.ll
Transforms/InstCombine/shl-and-signbit-icmpeq-zero.ll
Transforms/InstCombine/shift.ll
Transforms/InstCombine/shl-factor.ll
Transforms/InstCombine/shl-sub.ll
Transforms/InstCombine/shl-unsigned-cmp-const.ll
Transforms/InstCombine/should-change-type.ll
Transforms/InstCombine/shuffle-cast-inseltpoison.ll
Transforms/InstCombine/shuffle-cast.ll
Transforms/InstCombine/shuffle-select-narrow.ll
Transforms/InstCombine/shuffle-select-narrow-inseltpoison.ll
Transforms/InstCombine/shuffle_select-inseltpoison.ll
Transforms/InstCombine/shuffle_select.ll
Transforms/InstCombine/shufflevec-bitcast-inseltpoison.ll
Transforms/InstCombine/shufflevec-bitcast.ll
Transforms/InstCombine/shufflevec-constant-inseltpoison.ll
Transforms/InstCombine/shufflevec-constant.ll
Transforms/InstCombine/shufflevector-div-rem-inseltpoison.ll
Transforms/InstCombine/shufflevector-div-rem.ll
Transforms/InstCombine/sign-bit-test-via-right-shifting-all-other-bits.ll
Transforms/InstCombine/sign-test-and-or.ll
Transforms/InstCombine/signbit-lshr-and-icmpeq-zero.ll
Transforms/InstCombine/signed-comparison.ll
Transforms/InstCombine/signext.ll
Transforms/InstCombine/signed-truncation-check.ll
Transforms/InstCombine/signmask-of-sext-vs-of-shl-of-zext.ll
Transforms/InstCombine/simple_phi_condition.ll
Transforms/InstCombine/simplify-libcalls-erased.ll
Transforms/InstCombine/simplify-libcalls.ll
Transforms/InstCombine/sincospi.ll
Transforms/InstCombine/sink-alloca.ll
Transforms/InstCombine/sink-not-into-another-hand-of-and.ll
Transforms/InstCombine/sink-not-into-another-hand-of-or.ll
Transforms/InstCombine/sink_instruction.ll
Transforms/InstCombine/sink_to_unreachable.ll
Transforms/InstCombine/sitofp.ll
Transforms/InstCombine/smax-icmp.ll
Transforms/InstCombine/smin-icmp.ll
Transforms/InstCombine/sprintf-1.ll
Transforms/InstCombine/snprintf.ll
Transforms/InstCombine/sprintf-void.ll
Transforms/InstCombine/sqrt-nofast.ll
Transforms/InstCombine/sqrt.ll
Transforms/InstCombine/srem-canonicalize.ll
Transforms/InstCombine/srem-simplify-bug.ll
Transforms/InstCombine/ssub-with-overflow.ll
Transforms/InstCombine/stacksave-debuginfo.ll
Transforms/InstCombine/stacksaverestore.ll
Transforms/InstCombine/statepoint-iter.ll
Transforms/InstCombine/statepoint.ll
Transforms/InstCombine/stdio-custom-dl.ll
Transforms/InstCombine/store-load-unaliased-gep.ll
Transforms/InstCombine/store.ll
Transforms/InstCombine/statepoint-cleanup.ll
Transforms/InstCombine/storemerge-dbg.ll
Transforms/InstCombine/stpcpy-1.ll
Transforms/InstCombine/stpcpy_chk-2.ll
Transforms/InstCombine/stpcpy_chk-1.ll
Transforms/InstCombine/str-int-2.ll
Transforms/InstCombine/strcat-1.ll
Transforms/InstCombine/str-int.ll
Transforms/InstCombine/strcat-2.ll
Transforms/InstCombine/strchr-1.ll
Transforms/InstCombine/strcmp-1.ll
Transforms/InstCombine/strcpy-1.ll
Transforms/InstCombine/strcpy_chk-1.ll
Transforms/InstCombine/strcpy_chk-2.ll
Transforms/InstCombine/strcpy_chk-64.ll
Transforms/InstCombine/strcspn-1.ll
Transforms/InstCombine/strcmp-memcmp.ll
Transforms/InstCombine/strcspn-2.ll
Transforms/InstCombine/strict-sub-underflow-check-to-comparison-of-sub-operands.ll
Transforms/InstCombine/strlen-1.ll
Transforms/InstCombine/strlen-2.ll
Transforms/InstCombine/strlen_chk.ll
Transforms/InstCombine/strncat-1.ll
Transforms/InstCombine/strncat-3.ll
Transforms/InstCombine/strncat-2.ll
Transforms/InstCombine/strncmp-1.ll
Transforms/InstCombine/strncmp-2.ll
Transforms/InstCombine/strncpy-2.ll
Transforms/InstCombine/strncpy-1.ll
Transforms/InstCombine/strncpy-3.ll
Transforms/InstCombine/strncpy_chk-2.ll
Transforms/InstCombine/strncpy_chk-1.ll
Transforms/InstCombine/strndup.ll
Transforms/InstCombine/strpbrk-1.ll
Transforms/InstCombine/strpbrk-2.ll
Transforms/InstCombine/strrchr-1.ll
Transforms/InstCombine/strspn-1.ll
Transforms/InstCombine/strstr-1.ll
Transforms/InstCombine/strstr-2.ll
Transforms/InstCombine/strto-1.ll
Transforms/InstCombine/struct-assign-tbaa-new.ll
Transforms/InstCombine/struct-assign-tbaa.ll
Transforms/InstCombine/sub-and-or-neg-xor.ll
Transforms/InstCombine/sub-ashr-and-to-icmp-select.ll
Transforms/InstCombine/sub-ashr-or-to-icmp-select.ll
Transforms/InstCombine/sub-gep.ll
Transforms/InstCombine/sub-minmax.ll
Transforms/InstCombine/sub-not.ll
Transforms/InstCombine/sub-of-negatible-inseltpoison.ll
Transforms/InstCombine/sub-of-negatible.ll
Transforms/InstCombine/sub-or-and-xor.ll
Transforms/InstCombine/sub-xor-or-neg-and.ll
Transforms/InstCombine/sub-xor.ll
Transforms/InstCombine/subtract-from-one-hand-of-select.ll
Transforms/InstCombine/subtract-of-one-hand-of-select.ll
Transforms/InstCombine/sub.ll
Transforms/InstCombine/switch-constant-expr.ll
Transforms/InstCombine/tan.ll
Transforms/InstCombine/tbaa-store-to-load.ll
Transforms/InstCombine/toascii-1.ll
Transforms/InstCombine/trunc-extractelement-inseltpoison.ll
Transforms/InstCombine/trunc-binop-ext.ll
Transforms/InstCombine/trunc-extractelement.ll
Transforms/InstCombine/trunc-inseltpoison.ll
Transforms/InstCombine/trunc-shift-trunc.ll
Transforms/InstCombine/type_pun-inseltpoison.ll
Transforms/InstCombine/trunc.ll
Transforms/InstCombine/type_pun.ll
Transforms/InstCombine/uadd-with-overflow.ll
Transforms/InstCombine/uaddo.ll
Transforms/InstCombine/udiv-pow2-vscale-inseltpoison.ll
Transforms/InstCombine/udiv-pow2-vscale.ll
Transforms/InstCombine/udiv-simplify.ll
Transforms/InstCombine/udiv_select_to_select_shift.ll
Transforms/InstCombine/udivrem-change-width.ll
Transforms/InstCombine/umax-icmp.ll
Transforms/InstCombine/umin-icmp.ll
Transforms/InstCombine/umul-sign-check.ll
Transforms/InstCombine/unfold-masked-merge-with-const-mask-scalar.ll
Transforms/InstCombine/unfold-masked-merge-with-const-mask-vector.ll
Transforms/InstCombine/unordered-fcmp-select.ll
Transforms/InstCombine/unavailable-debug.ll
Transforms/InstCombine/unreachable-dbg-info-modified.ll
Transforms/InstCombine/unpack-fca.ll
Transforms/InstCombine/unsigned-add-lack-of-overflow-check-via-add.ll
Transforms/InstCombine/unrecognized_three-way-comparison.ll
Transforms/InstCombine/unsigned-add-lack-of-overflow-check.ll
Transforms/InstCombine/unsigned-add-overflow-check-via-add.ll
Transforms/InstCombine/unsigned-add-overflow-check.ll
Transforms/InstCombine/unsigned-mul-lack-of-overflow-check-via-mul-udiv.ll
Transforms/InstCombine/unsigned-mul-lack-of-overflow-check-via-udiv-of-allones.ll
Transforms/InstCombine/unsigned-mul-overflow-check-via-mul-udiv.ll
Transforms/InstCombine/unsigned-mul-overflow-check-via-udiv-of-allones.ll
Transforms/InstCombine/unsigned-sub-lack-of-overflow-check.ll
Transforms/InstCombine/unsigned-sub-overflow-check.ll
Transforms/InstCombine/unsigned_saturated_sub.ll
Transforms/InstCombine/unused-nonnull.ll
Transforms/InstCombine/urem-simplify-bug.ll
Transforms/InstCombine/vararg.ll
Transforms/InstCombine/usub-overflow-known-by-implied-cond.ll
Transforms/InstCombine/variable-signext-of-variable-high-bit-extraction.ll
Transforms/InstCombine/vec-binop-select-inseltpoison.ll
Transforms/InstCombine/vec-binop-select.ll
Transforms/InstCombine/vec_demanded_elts-inseltpoison.ll
Transforms/InstCombine/vec_extract_2elts.ll
Transforms/InstCombine/vec_extract_var_elt-inseltpoison.ll
Transforms/InstCombine/vec_demanded_elts.ll
Transforms/InstCombine/vec_extract_var_elt.ll
Transforms/InstCombine/vec_gep_scalar_arg-inseltpoison.ll
Transforms/InstCombine/vec_gep_scalar_arg.ll
Transforms/InstCombine/vec_phi_extract-inseltpoison.ll
Transforms/InstCombine/vec_phi_extract.ll
Transforms/InstCombine/vec_sext.ll
Transforms/InstCombine/vec_shuffle-inseltpoison.ll
Transforms/InstCombine/vec_shuffle.ll
Transforms/InstCombine/vec_udiv_to_shift.ll
Transforms/InstCombine/vector-casts-inseltpoison.ll
Transforms/InstCombine/vector-casts.ll
Transforms/InstCombine/vector-concat-binop-inseltpoison.ll
Transforms/InstCombine/vector-concat-binop.ll
Transforms/InstCombine/vector-mul.ll
Transforms/InstCombine/vector-reductions.ll
Transforms/InstCombine/vector-udiv.ll
Transforms/InstCombine/vector-urem.ll
Transforms/InstCombine/vector-xor.ll
Transforms/InstCombine/vector_gep1-inseltpoison.ll
Transforms/InstCombine/vector_gep2.ll
Transforms/InstCombine/vector_gep1.ll
Transforms/InstCombine/vector_insertelt_shuffle-inseltpoison.ll
Transforms/InstCombine/vector_insertelt_shuffle.ll
Transforms/InstCombine/vscale_alloca.ll
Transforms/InstCombine/vscale_cmp.ll
Transforms/InstCombine/vscale_extractelement-inseltpoison.ll
Transforms/InstCombine/vscale_extractelement.ll
Transforms/InstCombine/vscale_gep.ll
Transforms/InstCombine/vscale_insertelement-inseltpoison.ll
Transforms/InstCombine/vscale_insertelement.ll
Transforms/InstCombine/wcslen-1.ll
Transforms/InstCombine/wcslen-2.ll
Transforms/InstCombine/wcslen-3.ll
Transforms/InstCombine/wcslen-4.ll
Transforms/InstCombine/weak-symbols.ll
Transforms/InstCombine/widenable-conditions.ll
Transforms/InstCombine/win-math.ll
Transforms/InstCombine/xor-icmps.ll
Transforms/InstCombine/xor-of-icmps-with-extra-uses.ll
Transforms/InstCombine/xor-undef.ll
Transforms/InstCombine/with_overflow.ll
Transforms/InstCombine/xor2.ll
Transforms/InstCombine/zero-point-zero-add.ll
Transforms/InstCombine/xor.ll
Transforms/InstCombine/zeroext-and-reduce.ll
Transforms/InstCombine/zext-bool-add-sub.ll
Transforms/InstCombine/zext-fold.ll
Transforms/InstCombine/zext-or-icmp.ll
Transforms/InstCombine/zext-phi.ll
Transforms/InstCombine/zext.ll
Transforms/InstSimplify/2010-12-20-Boolean.ll
Transforms/InstSimplify/2011-01-14-Thread.ll
Transforms/InstSimplify/2011-02-01-Vector.ll
Transforms/InstSimplify/2011-09-05-InsertExtractValue.ll
Transforms/InstSimplify/AndOrXor.ll
Transforms/InstSimplify/ConstProp/2006-12-01-TruncBoolBug.ll
Transforms/InstSimplify/ConstProp/AMDGPU/cubeid.ll
Transforms/InstSimplify/ConstProp/AMDGPU/cos.ll
Transforms/InstSimplify/ConstProp/AMDGPU/cubesc.ll
Transforms/InstSimplify/ConstProp/AMDGPU/cubema.ll
Transforms/InstSimplify/ConstProp/AMDGPU/cubetc.ll
Transforms/InstSimplify/ConstProp/AMDGPU/fma_legacy.ll
Transforms/InstSimplify/ConstProp/AMDGPU/fmul_legacy.ll
Transforms/InstSimplify/ConstProp/AMDGPU/fract.ll
Transforms/InstSimplify/ConstProp/AMDGPU/sin.ll
Transforms/InstSimplify/ConstProp/WebAssembly/trunc.ll
Transforms/InstSimplify/ConstProp/WebAssembly/trunc_saturate.ll
Transforms/InstSimplify/ConstProp/abs.ll
Transforms/InstSimplify/ConstProp/active-lane-mask.ll
Transforms/InstSimplify/ConstProp/avx512.ll
Transforms/InstSimplify/ConstProp/bitcount.ll
Transforms/InstSimplify/ConstProp/bswap.ll
Transforms/InstSimplify/ConstProp/calls-math-finite.ll
Transforms/InstSimplify/ConstProp/calls.ll
Transforms/InstSimplify/ConstProp/cast-vector.ll
Transforms/InstSimplify/ConstProp/convert-from-fp16.ll
Transforms/InstSimplify/ConstProp/div-zero.ll
Transforms/InstSimplify/ConstProp/copysign.ll
Transforms/InstSimplify/ConstProp/fma.ll
Transforms/InstSimplify/ConstProp/freeze.ll
Transforms/InstSimplify/ConstProp/fp-undef.ll
Transforms/InstSimplify/ConstProp/funnel-shift.ll
Transforms/InstSimplify/ConstProp/gep-zeroinit-vector.ll
Transforms/InstSimplify/ConstProp/gep.ll
Transforms/InstSimplify/ConstProp/gep-constanfolding-error.ll
Transforms/InstSimplify/ConstProp/insertvalue.ll
Transforms/InstSimplify/ConstProp/loads.ll
Transforms/InstSimplify/ConstProp/math-2.ll
Transforms/InstSimplify/ConstProp/math-1.ll
Transforms/InstSimplify/ConstProp/overflow-ops.ll
Transforms/InstSimplify/ConstProp/min-max.ll
Transforms/InstSimplify/ConstProp/poison.ll
Transforms/InstSimplify/ConstProp/remtest.ll
Transforms/InstSimplify/ConstProp/rint.ll
Transforms/InstSimplify/ConstProp/round.ll
Transforms/InstSimplify/ConstProp/shift.ll
Transforms/InstSimplify/ConstProp/saturating-add-sub.ll
Transforms/InstSimplify/ConstProp/smul-fix-sat.ll
Transforms/InstSimplify/ConstProp/smul-fix.ll
Transforms/InstSimplify/ConstProp/sse.ll
Transforms/InstSimplify/ConstProp/trunc.ll
Transforms/InstSimplify/ConstProp/vector-undef-elts-inseltpoison.ll
Transforms/InstSimplify/ConstProp/vecreduce.ll
Transforms/InstSimplify/ConstProp/vector-undef-elts.ll
Transforms/InstSimplify/ConstProp/vscale-getelementptr.ll
Transforms/InstSimplify/ConstProp/vscale-inseltpoison.ll
Transforms/InstSimplify/ConstProp/vectorgep-crash.ll
Transforms/InstSimplify/ConstProp/vscale-shufflevector-inseltpoison.ll
Transforms/InstSimplify/ConstProp/vscale-shufflevector.ll
Transforms/InstSimplify/abs_intrinsic.ll
Transforms/InstSimplify/ConstProp/vscale.ll
Transforms/InstSimplify/add-mask.ll
Transforms/InstSimplify/add.ll
Transforms/InstSimplify/addsub.ll
Transforms/InstSimplify/and-icmps-same-ops.ll
Transforms/InstSimplify/and-or-icmp-min-max.ll
Transforms/InstSimplify/and-or-icmp-nullptr.ll
Transforms/InstSimplify/and.ll
Transforms/InstSimplify/and-or-icmp-zero.ll
Transforms/InstSimplify/assume_icmp.ll
Transforms/InstSimplify/assume-non-zero.ll
Transforms/InstSimplify/bitreverse-fold.ll
Transforms/InstSimplify/bitreverse.ll
Transforms/InstSimplify/bswap.ll
Transforms/InstSimplify/cast-unsigned-icmp-cmp-0.ll
Transforms/InstSimplify/cast.ll
Transforms/InstSimplify/call.ll
Transforms/InstSimplify/cmp_ext.ll
Transforms/InstSimplify/cmp_of_min_max.ll
Transforms/InstSimplify/constantfold-add-nuw-allones-to-allones.ll
Transforms/InstSimplify/constantfold-shl-nuw-C-to-C.ll
Transforms/InstSimplify/constfold-constrained.ll
Transforms/InstSimplify/compare.ll
Transforms/InstSimplify/distribute.ll
Transforms/InstSimplify/div-by-0-guard-before-smul_ov-not.ll
Transforms/InstSimplify/div-by-0-guard-before-smul_ov.ll
Transforms/InstSimplify/div-by-0-guard-before-umul_ov.ll
Transforms/InstSimplify/div-by-0-guard-before-umul_ov-not.ll
Transforms/InstSimplify/div.ll
Transforms/InstSimplify/exact-nsw-nuw.ll
Transforms/InstSimplify/extract-element.ll
Transforms/InstSimplify/fast-math.ll
Transforms/InstSimplify/fcmp-select.ll
Transforms/InstSimplify/fcmp.ll
Transforms/InstSimplify/fdiv.ll
Transforms/InstSimplify/floating-point-arithmetic.ll
Transforms/InstSimplify/floating-point-compare.ll
Transforms/InstSimplify/fold-intrinsics.ll
Transforms/InstSimplify/fp-nan.ll
Transforms/InstSimplify/fminmax-folds.ll
Transforms/InstSimplify/fp-undef-poison.ll
Transforms/InstSimplify/freeze-noundef.ll
Transforms/InstSimplify/fptoi-sat.ll
Transforms/InstSimplify/freeze.ll
Transforms/InstSimplify/gep.ll
Transforms/InstSimplify/icmp-bool-constant.ll
Transforms/InstSimplify/icmp-abs-nabs.ll
Transforms/InstSimplify/icmp-constant.ll
Transforms/InstSimplify/icmp.ll
Transforms/InstSimplify/icmp-ranges.ll
Transforms/InstSimplify/implies.ll
Transforms/InstSimplify/insertelement.ll
Transforms/InstSimplify/insertvalue.ll
Transforms/InstSimplify/known-non-zero.ll
Transforms/InstSimplify/known-never-nan.ll
Transforms/InstSimplify/load-relative-32.ll
Transforms/InstSimplify/load-relative.ll
Transforms/InstSimplify/log-exp-intrinsic.ll
Transforms/InstSimplify/log10-pow10-intrinsic.ll
Transforms/InstSimplify/log2-pow2-intrinsic.ll
Transforms/InstSimplify/logic-of-fcmps.ll
Transforms/InstSimplify/maxmin.ll
Transforms/InstSimplify/mul.ll
Transforms/InstSimplify/negate.ll
Transforms/InstSimplify/noalias-ptr.ll
Transforms/InstSimplify/maxmin_intrinsics.ll
Transforms/InstSimplify/null-ptr-is-valid-attribute.ll
Transforms/InstSimplify/null-ptr-is-valid.ll
Transforms/InstSimplify/or-icmps-same-ops.ll
Transforms/InstSimplify/or.ll
Transforms/InstSimplify/past-the-end.ll
Transforms/InstSimplify/pr33957.ll
Transforms/InstSimplify/ptr_diff.ll
Transforms/InstSimplify/reassociate.ll
Transforms/InstSimplify/redundant-null-check-in-uadd_with_overflow-of-nonnull-ptr.ll
Transforms/InstSimplify/rem.ll
Transforms/InstSimplify/result-of-usub-by-nonzero-is-non-zero-and-no-overflow.ll
Transforms/InstSimplify/returned.ll
Transforms/InstSimplify/result-of-usub-is-non-zero-and-no-overflow.ll
Transforms/InstSimplify/round-intrinsics.ll
Transforms/InstSimplify/sdiv.ll
Transforms/InstSimplify/saturating-add-sub.ll
Transforms/InstSimplify/select-and-cmp.ll
Transforms/InstSimplify/select-implied.ll
Transforms/InstSimplify/select-or-cmp.ll
Transforms/InstSimplify/select-inseltpoison.ll
Transforms/InstSimplify/select.ll
Transforms/InstSimplify/shift-knownbits.ll
Transforms/InstSimplify/shift.ll
Transforms/InstSimplify/shr-scalar-vector-consistency.ll
Transforms/InstSimplify/shr-nop.ll
Transforms/InstSimplify/shufflevector-inseltpoison.ll
Transforms/InstSimplify/shufflevector.ll
Transforms/InstSimplify/signed-div-rem.ll
Transforms/InstSimplify/srem.ll
Transforms/InstSimplify/sub.ll
Transforms/InstSimplify/undef.ll
Transforms/InstSimplify/vec-cmp.ll
Transforms/InstSimplify/vector_gep.ll
Transforms/InstSimplify/vscale-inseltpoison.ll
Transforms/InstSimplify/vscale.ll
Transforms/InstSimplify/xor.ll
Transforms/InstSimplify/simplify-nested-bitcast.ll
Transforms/JumpThreading/and-and-cond.ll
Transforms/JumpThreading/and-cond.ll
Transforms/JumpThreading/basic.ll
Transforms/JumpThreading/branch-no-const.ll
Transforms/JumpThreading/lvi-tristate.ll
Transforms/JumpThreading/no-irreducible-loops.ll
Transforms/JumpThreading/phi-known.ll
Transforms/LICM/2003-02-27-PreheaderProblem.ll
Transforms/LICM/hoist-mustexec.ll
Transforms/LoopDeletion/dcetest.ll
Transforms/LoopDeletion/simplify-then-delete.ll
Transforms/LoopInstSimplify/basic.ll
Transforms/LoopRotate/multiple-deopt-exits.ll
Transforms/LoopSimplify/do-preheader-dbg-inseltpoison.ll
Transforms/LoopSimplify/do-preheader-dbg.ll
Transforms/LoopSimplify/for-preheader-dbg.ll
Transforms/LoopUnroll/2011-10-01-NoopTrunc.ll
Transforms/LoopUnroll/AMDGPU/unroll-analyze-small-loops.ll
Transforms/LoopUnroll/complete_unroll_profitability_with_assume.ll
Transforms/LoopUnroll/debug-info.ll
Transforms/LoopUnroll/full-unroll-heuristics-cmp.ll
Transforms/LoopUnroll/full-unroll-heuristics-dce.ll
Transforms/LoopUnroll/full-unroll-heuristics.ll
Transforms/LoopUnroll/noalias.ll
Transforms/LoopUnroll/opt-levels.ll
Transforms/LoopUnroll/peel-loop-inner.ll
Transforms/LoopUnroll/peel-loop-noalias-scope-decl.ll
Transforms/LoopUnroll/peel-loop.ll
Transforms/LoopUnroll/pr45939-peel-count-and-complete-unroll.ll
Transforms/LoopUnroll/runtime-loop-multiple-exits.ll
Transforms/LoopUnroll/runtime-loop4.ll
Transforms/LoopUnroll/runtime-multiexit-heuristic.ll
Transforms/LoopUnroll/runtime-unroll-remainder.ll
Transforms/LoopUnroll/unroll-after-peel.ll
Transforms/LoopUnroll/unroll-cleanup.ll
Transforms/LoopUnroll/unroll-header-exiting-with-phis.ll
Transforms/LoopUnroll/unroll-opt-attribute.ll
Transforms/LoopUnroll/unroll-unconditional-latch.ll
Transforms/LoopUnroll/wrong_assert_in_peeling.ll
Transforms/LoopUnswitch/2015-06-17-Metadata.ll
Transforms/LoopUnswitch/AMDGPU/divergent-unswitch.ll
Transforms/LoopUnswitch/infinite-loop.ll
Transforms/LoopVectorize/AMDGPU/packed-math.ll
Transforms/LoopVectorize/X86/consecutive-ptr-uniforms.ll
Transforms/LoopVectorize/X86/float-induction-x86.ll
Transforms/LoopVectorize/X86/gather_scatter.ll
Transforms/LoopVectorize/X86/interleaving.ll
Transforms/LoopVectorize/X86/invariant-load-gather.ll
Transforms/LoopVectorize/X86/intrinsiccost.ll
Transforms/LoopVectorize/X86/invariant-store-vectorization.ll
Transforms/LoopVectorize/X86/metadata-enable.ll
Transforms/LoopVectorize/X86/pr23997.ll
Transforms/LoopVectorize/X86/pr42674.ll
Transforms/LoopVectorize/X86/small-size.ll
Transforms/LoopVectorize/X86/x86-interleaved-accesses-masked-group.ll
Transforms/LoopVectorize/consec_no_gep.ll
Transforms/LoopVectorize/consecutive-ptr-uniforms.ll
Transforms/LoopVectorize/first-order-recurrence.ll
Transforms/LoopVectorize/float-induction.ll
Transforms/LoopVectorize/gep_with_bitcast.ll
Transforms/LoopVectorize/if-conversion-nest.ll
Transforms/LoopVectorize/if-conversion.ll
Transforms/LoopVectorize/if-pred-stores.ll
Transforms/LoopVectorize/induction.ll
Transforms/LoopVectorize/interleaved-accesses-pred-stores.ll
Transforms/LoopVectorize/invariant-store-vectorization.ll
Transforms/LoopVectorize/interleaved-accesses.ll
Transforms/LoopVectorize/loop-scalars.ll
Transforms/LoopVectorize/phi-cost.ll
Transforms/LoopVectorize/reduction-inloop-uf4.ll
Transforms/LoopVectorize/reduction-inloop.ll
Transforms/LoopVectorize/reduction-inloop-pred.ll
Transforms/LoopVectorize/reduction-predselect.ll
Transforms/LoopVectorize/runtime-check-readonly.ll
Transforms/LoopVectorize/runtime-check.ll
Transforms/LoopVectorize/scalable-loop-unpredicated-body-scalar-tail.ll
Transforms/LoopVectorize/scalar_after_vectorization.ll
Transforms/LoopVectorize/store-shuffle-bug.ll
Transforms/LoopVectorize/tbaa-nodep.ll
Transforms/LoopVectorize/vector-geps.ll
Transforms/MemCpyOpt/lifetime.ll
Transforms/MemCpyOpt/memcpy-to-memset-with-lifetimes.ll
Transforms/MemCpyOpt/pr29105.ll
Transforms/NaryReassociate/NVPTX/nary-gep.ll
Transforms/NaryReassociate/NVPTX/nary-slsr.ll
Transforms/NaryReassociate/nary-add.ll
Transforms/NaryReassociate/nary-mul.ll
Transforms/NaryReassociate/pr24301.ll
Transforms/NaryReassociate/pr37539.ll
Transforms/NewGVN/2010-11-13-Simplify.ll
Transforms/NewGVN/addrspacecast.ll
Transforms/NewGVN/basic-cyclic-opt.ll
Transforms/NewGVN/basic.ll
Transforms/NewGVN/bitcast-of-call.ll
Transforms/NewGVN/calls-readonly.ll
Transforms/NewGVN/cond_br.ll
Transforms/NewGVN/completeness.ll
Transforms/NewGVN/condprop.ll
Transforms/NewGVN/edge.ll
Transforms/NewGVN/fold-const-expr.ll
Transforms/NewGVN/load-constant-mem.ll
Transforms/NewGVN/loadforward.ll
Transforms/NewGVN/pair_jumpthread.ll
Transforms/NewGVN/phi-of-ops-move-block.ll
Transforms/NewGVN/pr32836.ll
Transforms/NewGVN/pr33196.ll
Transforms/NewGVN/pr33461.ll
Transforms/NewGVN/pr33720.ll
Transforms/NewGVN/pr34452.ll
Transforms/NewGVN/pr35074.ll
Transforms/NewGVN/pr35125.ll
Transforms/NewGVN/refine-stores.ll
Transforms/NewGVN/simp-to-self.ll
Transforms/NewGVN/tbaa.ll
Transforms/NewGVN/todo-pr36335-phi-undef.ll
Transforms/OpenMP/parallel_deletion_cg_update.ll
Transforms/PGOProfile/chr.ll
Transforms/PGOProfile/cspgo_profile_summary.ll
Transforms/PhaseOrdering/X86/SROA-after-loop-unrolling.ll
Transforms/PhaseOrdering/X86/addsub-inseltpoison.ll
Transforms/PhaseOrdering/X86/addsub.ll
Transforms/PhaseOrdering/X86/horiz-math-inseltpoison.ll
Transforms/PhaseOrdering/X86/horiz-math.ll
Transforms/PhaseOrdering/X86/loop-idiom-vs-indvars.ll
Transforms/PhaseOrdering/X86/masked-memory-ops.ll
Transforms/PhaseOrdering/X86/peel-before-lv-to-enable-vectorization.ll
Transforms/PhaseOrdering/X86/pr48844-br-to-switch-vectorization.ll
Transforms/PhaseOrdering/X86/scalarization-inseltpoison.ll
Transforms/PhaseOrdering/X86/scalarization.ll
Transforms/PhaseOrdering/X86/shuffle-inseltpoison.ll
Transforms/PhaseOrdering/X86/shuffle.ll
Transforms/PhaseOrdering/X86/vdiv.ll
Transforms/PhaseOrdering/X86/vector-reductions-expanded.ll
Transforms/PhaseOrdering/X86/vector-reductions.ll
Transforms/PhaseOrdering/basic.ll
Transforms/PhaseOrdering/bitfield-bittests.ll
Transforms/PhaseOrdering/d83507-knowledge-retention-bug.ll
Transforms/PhaseOrdering/inlining-alignment-assumptions.ll
Transforms/PhaseOrdering/instcombine-sroa-inttoptr.ll
Transforms/PhaseOrdering/loop-rotation-vs-common-code-hoisting.ll
Transforms/PhaseOrdering/min-max-abs-cse.ll
Transforms/PhaseOrdering/minmax.ll
Transforms/PhaseOrdering/pr39282.ll
Transforms/PhaseOrdering/pr44461-br-to-switch-rotate.ll
Transforms/PhaseOrdering/rotate.ll
Transforms/PhaseOrdering/simplifycfg-options.ll
Transforms/PhaseOrdering/unsigned-multiply-overflow-check.ll
Transforms/PhaseOrdering/vector-trunc-inseltpoison.ll
Transforms/PhaseOrdering/vector-trunc.ll
Transforms/PruneEH/looptest.ll
Transforms/PruneEH/operand-bundles.ll
Transforms/PruneEH/pr26263.ll
Transforms/PruneEH/recursivetest.ll
Transforms/PruneEH/simplenoreturntest.ll
Transforms/Reassociate/2002-05-15-AgressiveSubMove.ll
Transforms/PruneEH/simpletest.ll
Transforms/Reassociate/2002-05-15-MissedTree.ll
Transforms/Reassociate/2002-05-15-SubReassociate.ll
Transforms/Reassociate/2006-04-27-ReassociateVector.ll
Transforms/Reassociate/2005-09-01-ArrayOutOfBounds.ll
Transforms/Reassociate/2019-08-22-FNegAssert.ll
Transforms/Reassociate/absorption.ll
Transforms/Reassociate/add-like-or.ll
Transforms/Reassociate/add_across_block_crash.ll
Transforms/Reassociate/basictest.ll
Transforms/Reassociate/binop-identity.ll
Transforms/Reassociate/commute.ll
Transforms/Reassociate/canonicalize-neg-const.ll
Transforms/Reassociate/cse-pairs.ll
Transforms/Reassociate/crash2.ll
Transforms/Reassociate/erase_inst_made_change.ll
Transforms/Reassociate/factorize-again.ll
Transforms/Reassociate/fast-AgressiveSubMove.ll
Transforms/Reassociate/fast-ArrayOutOfBounds.ll
Transforms/Reassociate/fast-MissedTree.ll
Transforms/Reassociate/fast-SubReassociate.ll
Transforms/Reassociate/fast-ReassociateVector.ll
Transforms/Reassociate/fast-basictest.ll
Transforms/Reassociate/fast-fp-commute.ll
Transforms/Reassociate/fast-multistep.ll
Transforms/Reassociate/fp-commute.ll
Transforms/Reassociate/fp-expr.ll
Transforms/Reassociate/infloop-deadphi.ll
Transforms/Reassociate/inverses.ll
Transforms/Reassociate/keep-debug-loc.ll
Transforms/Reassociate/load-combine-like-or.ll
Transforms/Reassociate/long-chains.ll
Transforms/Reassociate/looptest.ll
Transforms/Reassociate/matching-binops.ll
Transforms/Reassociate/mixed-fast-nonfast-fp.ll
Transforms/Reassociate/mulfactor.ll
Transforms/Reassociate/multistep.ll
Transforms/Reassociate/negation.ll
Transforms/Reassociate/negation1.ll
Transforms/Reassociate/no-op.ll
Transforms/Reassociate/optional-flags.ll
Transforms/Reassociate/otherops.ll
Transforms/Reassociate/pointer-collision-non-determinism.ll
Transforms/Reassociate/pr42349.ll
Transforms/Reassociate/propagate-flags.ll
Transforms/Reassociate/reassoc-intermediate-fnegs.ll
Transforms/Reassociate/reassociate-deadinst.ll
Transforms/Reassociate/reassociate_dbgvalue_discard.ll
Transforms/Reassociate/reassociate_salvages_debug_info.ll
Transforms/Reassociate/repeats.ll
Transforms/Reassociate/secondary.ll
Transforms/Reassociate/shifttest.ll
Transforms/Reassociate/shift-factor.ll
Transforms/Reassociate/subtest.ll
Transforms/Reassociate/vaarg_movable.ll
Transforms/Reassociate/undef_intrinsics_when_deleting_instructions.ll
Transforms/Reassociate/wrap-flags.ll
Transforms/Reassociate/xor_reassoc.ll
Transforms/SCCP/2003-06-24-OverdefinedPHIValue.ll
Transforms/SCCP/calltest.ll
Transforms/SCCP/float-nan-simplification.ll
Transforms/RewriteStatepointsForGC/unordered-atomic-memcpy.ll
Transforms/SCCP/vector-bitcast.ll
Transforms/SLPVectorizer/AMDGPU/add_sub_sat-inseltpoison.ll
Transforms/SLPVectorizer/AMDGPU/add_sub_sat.ll
Transforms/SLPVectorizer/WebAssembly/no-vectorize-rotate.ll
Transforms/SLPVectorizer/X86/alternate-cast-inseltpoison.ll
Transforms/SLPVectorizer/X86/alternate-cast.ll
Transforms/SLPVectorizer/X86/alternate-fp-inseltpoison.ll
Transforms/SLPVectorizer/X86/alternate-fp.ll
Transforms/SLPVectorizer/X86/alternate-int-inseltpoison.ll
Transforms/SLPVectorizer/X86/alternate-int.ll
Transforms/SLPVectorizer/X86/blending-shuffle-inseltpoison.ll
Transforms/SLPVectorizer/X86/blending-shuffle.ll
Transforms/SLPVectorizer/X86/cmp_commute-inseltpoison.ll
Transforms/SLPVectorizer/X86/cmp_commute.ll
Transforms/SLPVectorizer/X86/hadd-inseltpoison.ll
Transforms/SLPVectorizer/X86/hadd.ll
Transforms/SLPVectorizer/X86/hsub-inseltpoison.ll
Transforms/SLPVectorizer/X86/hsub.ll
Transforms/SLPVectorizer/X86/minimum-sizes.ll
Transforms/SLPVectorizer/X86/operandorder.ll
Transforms/SLPVectorizer/X86/pr46983.ll
Transforms/SLPVectorizer/X86/pr47629-inseltpoison.ll
Transforms/SLPVectorizer/X86/pr47629.ll
Transforms/SampleProfile/calls.ll
Transforms/SampleProfile/cov-zero-samples.ll
Transforms/SampleProfile/inline-combine.ll
Transforms/SampleProfile/inline-coverage.ll
Transforms/SampleProfile/pseudo-probe-instcombine.ll
Transforms/SimpleLoopUnswitch/LIV-loop-condtion.ll
Transforms/SimpleLoopUnswitch/basictest-profmd.ll
Transforms/SimpleLoopUnswitch/copy-metadata.ll
Transforms/SimpleLoopUnswitch/delete-dead-blocks.ll
Transforms/SimpleLoopUnswitch/exponential-nontrivial-unswitch-nested.ll
Transforms/SimpleLoopUnswitch/exponential-nontrivial-unswitch-nested2.ll
Transforms/SimpleLoopUnswitch/exponential-nontrivial-unswitch.ll
Transforms/SimpleLoopUnswitch/exponential-switch-unswitch.ll
Transforms/SimpleLoopUnswitch/guards.ll
Transforms/SimpleLoopUnswitch/implicit-null-checks.ll
Transforms/SimpleLoopUnswitch/infinite-loop.ll
Transforms/SimpleLoopUnswitch/msan.ll
Transforms/SimpleLoopUnswitch/nontrivial-unswitch-cost.ll
Transforms/SimpleLoopUnswitch/pipeline.ll
Transforms/SimpleLoopUnswitch/pr37888.ll
Transforms/SimpleLoopUnswitch/nontrivial-unswitch.ll
Transforms/SimpleLoopUnswitch/preserve-scev-exiting-multiple-loops.ll
Transforms/SimpleLoopUnswitch/trivial-unswitch-iteration.ll
Transforms/SimpleLoopUnswitch/trivial-unswitch-profmd.ll
Transforms/SimpleLoopUnswitch/update-scev.ll
Transforms/SimpleLoopUnswitch/trivial-unswitch.ll
Transforms/SimplifyCFG/2003-08-17-BranchFold.ll
Transforms/SimplifyCFG/2003-08-17-BranchFoldOrdering.ll
Transforms/SimplifyCFG/2003-08-17-FoldSwitch-dbg.ll
Transforms/SimplifyCFG/2003-08-17-FoldSwitch.ll
Transforms/SimplifyCFG/2007-11-22-InvokeNoUnwind.ll
Transforms/SimplifyCFG/2008-05-16-PHIBlockMerge.ll
Transforms/SimplifyCFG/2008-07-13-InfLoopMiscompile.ll
Transforms/SimplifyCFG/2008-12-16-DCECond.ll
Transforms/SimplifyCFG/2011-03-08-UnreachableUse.ll
Transforms/SimplifyCFG/2011-09-05-TrivialLPad.ll
Transforms/SimplifyCFG/AMDGPU/cttz-ctlz.ll
Transforms/SimplifyCFG/BrUnwind.ll
Transforms/SimplifyCFG/ConditionalTrappingConstantExpr.ll
Transforms/SimplifyCFG/DeadSetCC.ll
Transforms/SimplifyCFG/EqualPHIEdgeBlockMerge.ll
Transforms/SimplifyCFG/FoldValueComparisonIntoPredecessors-domtree-preservation-edgecase-2.ll
Transforms/SimplifyCFG/FoldValueComparisonIntoPredecessors-domtree-preservation-edgecase.ll
Transforms/SimplifyCFG/FoldValueComparisonIntoPredecessors-no-new-successors.ll
Transforms/SimplifyCFG/ForwardSwitchConditionToPHI.ll
Transforms/SimplifyCFG/HoistCode.ll
Transforms/SimplifyCFG/PHINode.ll
Transforms/SimplifyCFG/PR16069.ll
Transforms/SimplifyCFG/PR25267.ll
Transforms/SimplifyCFG/PR17073.ll
Transforms/SimplifyCFG/PR27615-simplify-cond-br.ll
Transforms/SimplifyCFG/PhiBlockMerge.ll
Transforms/SimplifyCFG/PhiBlockMerge2.ll
Transforms/SimplifyCFG/PhiEliminate.ll
Transforms/SimplifyCFG/PhiEliminate2.ll
Transforms/SimplifyCFG/PhiEliminate3.ll
Transforms/SimplifyCFG/SimplifyEqualityComparisonWithOnlyPredecessor-domtree-preservation-edgecase.ll
Transforms/SimplifyCFG/SimplifyTerminatorOnSelect-domtree-preservation-edgecase.ll
Transforms/SimplifyCFG/UncondBranchToHeader.ll
Transforms/SimplifyCFG/UncondBranchToReturn.ll
Transforms/SimplifyCFG/UnreachableEliminate.ll
Transforms/SimplifyCFG/X86/CoveredLookupTable.ll
Transforms/SimplifyCFG/X86/MagicPointer.ll
Transforms/SimplifyCFG/X86/PR29163.ll
Transforms/SimplifyCFG/X86/PR30210.ll
Transforms/SimplifyCFG/X86/SpeculativeExec.ll
Transforms/SimplifyCFG/X86/bug-25299.ll
Transforms/SimplifyCFG/X86/critedge-assume.ll
Transforms/SimplifyCFG/X86/disable-lookup-table.ll
Transforms/SimplifyCFG/X86/empty-cleanuppad.ll
Transforms/SimplifyCFG/X86/merge-cleanuppads.ll
Transforms/SimplifyCFG/X86/remove-debug-2.ll
Transforms/SimplifyCFG/X86/pr39187-g.ll
Transforms/SimplifyCFG/X86/remove-debug.ll
Transforms/SimplifyCFG/X86/safe-low-bit-extract.ll
Transforms/SimplifyCFG/X86/speculate-cttz-ctlz.ll
Transforms/SimplifyCFG/X86/switch-covered-bug.ll
Transforms/SimplifyCFG/X86/switch-table-bug.ll
Transforms/SimplifyCFG/annotations.ll
Transforms/SimplifyCFG/X86/switch_to_lookup_table.ll
Transforms/SimplifyCFG/assume.ll
Transforms/SimplifyCFG/basictest.ll
Transforms/SimplifyCFG/bbi-23595.ll
Transforms/SimplifyCFG/branch-cond-merge.ll
Transforms/SimplifyCFG/branch-cond-prop.ll
Transforms/SimplifyCFG/branch-fold-dbg.ll
Transforms/SimplifyCFG/branch-fold-test.ll
Transforms/SimplifyCFG/branch-fold-threshold.ll
Transforms/SimplifyCFG/branch-fold.ll
Transforms/SimplifyCFG/branch-phi-thread.ll
Transforms/SimplifyCFG/change-to-unreachable-matching-successor.ll
Transforms/SimplifyCFG/clamp.ll
Transforms/SimplifyCFG/common-code-hoisting.ll
Transforms/SimplifyCFG/common-dest-folding.ll
Transforms/SimplifyCFG/dbginfo.ll
Transforms/SimplifyCFG/dce-cond-after-folding-terminator.ll
Transforms/SimplifyCFG/debug-info-thread-phi.ll
Transforms/SimplifyCFG/drop-debug-loc-when-speculating.ll
Transforms/SimplifyCFG/duplicate-landingpad.ll
Transforms/SimplifyCFG/duplicate-phis.ll
Transforms/SimplifyCFG/duplicate-ret-into-uncond-br.ll
Transforms/SimplifyCFG/empty-catchpad.ll
Transforms/SimplifyCFG/extract-cost.ll
Transforms/SimplifyCFG/fold-debug-info.ll
Transforms/SimplifyCFG/fold-branch-to-common-dest.ll
Transforms/SimplifyCFG/fold-debug-location.ll
Transforms/SimplifyCFG/guards.ll
Transforms/SimplifyCFG/hoist-common-code.ll
Transforms/SimplifyCFG/hoist-dbgvalue-inlined.ll
Transforms/SimplifyCFG/hoist-with-range.ll
Transforms/SimplifyCFG/implied-and-or.ll
Transforms/SimplifyCFG/implied-cond-matching-false-dest.ll
Transforms/SimplifyCFG/implied-cond-matching-imm.ll
Transforms/SimplifyCFG/implied-cond.ll
Transforms/SimplifyCFG/implied-cond-matching.ll
Transforms/SimplifyCFG/indirectbr.ll
Transforms/SimplifyCFG/invoke.ll
Transforms/SimplifyCFG/invoke_unwind.ll
Transforms/SimplifyCFG/invoke_unwind_lifetime.ll
Transforms/SimplifyCFG/iterative-simplify.ll
Transforms/SimplifyCFG/lifetime-landingpad.ll
Transforms/SimplifyCFG/merge-cond-stores-2.ll
Transforms/SimplifyCFG/merge-cond-stores.ll
Transforms/SimplifyCFG/merge-default.ll
Transforms/SimplifyCFG/merge-duplicate-conditional-ret-val.ll
Transforms/SimplifyCFG/merge-empty-return-blocks.ll
Transforms/SimplifyCFG/multiple-phis.ll
Transforms/SimplifyCFG/no-md-sink.ll
Transforms/SimplifyCFG/no_speculative_loads_with_asan.ll
Transforms/SimplifyCFG/no_speculative_loads_with_tsan.ll
Transforms/SimplifyCFG/noreturn-call.ll
Transforms/SimplifyCFG/opt-for-fuzzing.ll
Transforms/SimplifyCFG/phi-to-select-constexpr-icmp.ll
Transforms/SimplifyCFG/phi-undef-loadstore.ll
Transforms/SimplifyCFG/poison-merge.ll
Transforms/SimplifyCFG/pr39807.ll
Transforms/SimplifyCFG/pr46638.ll
Transforms/SimplifyCFG/pr48778-sdiv-speculation.ll
Transforms/SimplifyCFG/preserve-branchweights-switch-create.ll
Transforms/SimplifyCFG/preserve-branchweights.ll
Transforms/SimplifyCFG/preserve-llvm-loop-metadata.ll
Transforms/SimplifyCFG/preserve-load-metadata-2.ll
Transforms/SimplifyCFG/preserve-load-metadata-3.ll
Transforms/SimplifyCFG/preserve-load-metadata.ll
Transforms/SimplifyCFG/preserve-make-implicit-on-switch-to-br.ll
Transforms/SimplifyCFG/preserve-store-alignment.ll
Transforms/SimplifyCFG/rangereduce.ll
Transforms/SimplifyCFG/return-merge.ll
Transforms/SimplifyCFG/safe-abs.ll
Transforms/SimplifyCFG/select-gep.ll
Transforms/SimplifyCFG/signbit-like-value-extension.ll
Transforms/SimplifyCFG/simplifyUnreachable-degenerate-conditional-branch-with-matching-destinations.ll
Transforms/SimplifyCFG/sink-common-code.ll
Transforms/SimplifyCFG/speculate-call.ll
Transforms/SimplifyCFG/speculate-dbgvalue.ll
Transforms/SimplifyCFG/speculate-math.ll
Transforms/SimplifyCFG/speculate-store.ll
Transforms/SimplifyCFG/speculate-vector-ops-inseltpoison.ll
Transforms/SimplifyCFG/speculate-vector-ops.ll
Transforms/SimplifyCFG/speculate-with-offset.ll
Transforms/SimplifyCFG/suppress-zero-branch-weights.ll
Transforms/SimplifyCFG/switch-dead-default.ll
Transforms/SimplifyCFG/switch-masked-bits.ll
Transforms/SimplifyCFG/switch-on-const-select.ll
Transforms/SimplifyCFG/switch-profmd.ll
Transforms/SimplifyCFG/switch-range-to-icmp.ll
Transforms/SimplifyCFG/switch-to-br.ll
Transforms/SimplifyCFG/switch-to-icmp.ll
Transforms/SimplifyCFG/switch-to-select-multiple-edge-per-block-phi.ll
Transforms/SimplifyCFG/switch-to-select-two-case.ll
Transforms/SimplifyCFG/switchToSelect-domtree-preservation-edgecase.ll
Transforms/SimplifyCFG/switch_create-custom-dl.ll
Transforms/SimplifyCFG/switch_create.ll
Transforms/SimplifyCFG/switch_msan.ll
Transforms/SimplifyCFG/switch_switch_fold.ll
Transforms/SimplifyCFG/switch_thread.ll
Transforms/SimplifyCFG/switch_undef.ll
Transforms/SimplifyCFG/trap-debugloc.ll
Transforms/SimplifyCFG/trapping-load-unreachable.ll
Transforms/SimplifyCFG/two-entry-phi-return.ll
Transforms/SimplifyCFG/two-entry-phi-fold-crash.ll
Transforms/SimplifyCFG/unprofitable-pr.ll
Transforms/SimplifyCFG/unreachable-cleanuppad.ll
Transforms/SimplifyCFG/unreachable_assume.ll
Transforms/SimplifyCFG/unsigned-multiplication-will-overflow.ll
Transforms/SimplifyCFG/wc-widen-block.ll
Transforms/SimplifyCFG/wineh-unreachable.ll
Transforms/Util/dbg-call-bitcast.ll
Transforms/Util/libcalls-opt-remarks.ll
Transforms/Util/strip-gc-relocates.ll
Transforms/VectorCombine/AMDGPU/as-transition.ll
Transforms/VectorCombine/AMDGPU/as-transition-inseltpoison.ll
Transforms/VectorCombine/X86/extract-binop-inseltpoison.ll
Transforms/VectorCombine/X86/extract-binop.ll
Transforms/VectorCombine/X86/extract-cmp-binop.ll
Transforms/VectorCombine/X86/extract-cmp.ll
Transforms/VectorCombine/X86/insert-binop-inseltpoison.ll
Transforms/VectorCombine/X86/insert-binop-with-constant-inseltpoison.ll
Transforms/VectorCombine/X86/insert-binop-with-constant.ll
Transforms/VectorCombine/X86/insert-binop.ll
Transforms/VectorCombine/X86/load-inseltpoison.ll
Transforms/VectorCombine/X86/load.ll
Transforms/VectorCombine/X86/scalarize-cmp-inseltpoison.ll
Transforms/VectorCombine/X86/scalarize-cmp.ll
Transforms/VectorCombine/X86/shuffle-inseltpoison.ll
Transforms/VectorCombine/X86/shuffle.ll
tools/UpdateTestChecks/update_test_checks/basic.test
)

# DISABLE_PEEPHOLES=0 DISABLE_WRONG_OPTIMIZATIONS=0
#Testing Time: 4148.62s
#  Unsupported      : 14773
#  Passed           : 27320
#  Expectedly Failed:    75
#  Failed           :     1
EXPECTED_FAILS_6_X86=(
ExecutionEngine/MCJIT/remote/test-common-symbols-remote.ll
)

# DISABLE_PEEPHOLES=0 DISABLE_WRONG_OPTIMIZATIONS=1
#Testing Time: 3999.71s
#  Unsupported      : 14773
#  Passed           : 27222
#  Expectedly Failed:    75
#  Failed           :    99
EXPECTED_FAILS_7_X86=(
ExecutionEngine/MCJIT/remote/test-common-symbols-remote.ll
Other/new-pm-defaults.ll
Other/new-pm-thinlto-defaults.ll
Other/new-pm-thinlto-postlink-pgo-defaults.ll
Other/new-pm-thinlto-postlink-samplepgo-defaults.ll
Other/new-pm-thinlto-prelink-pgo-defaults.ll
Other/new-pm-thinlto-prelink-samplepgo-defaults.ll
Transforms/InstCombine/2006-12-15-Range-Test.ll
Transforms/InstCombine/2007-03-13-CompareMerge.ll
Transforms/InstCombine/2007-05-10-icmp-or.ll
Transforms/InstCombine/2007-11-15-CompareMiscomp.ll
Transforms/InstCombine/2008-01-13-AndCmpCmp.ll
Transforms/InstCombine/2008-02-28-OrFCmpCrash.ll
Transforms/InstCombine/2008-06-21-CompareMiscomp.ll
Transforms/InstCombine/2008-08-05-And.ll
Transforms/InstCombine/2012-02-28-ICmp.ll
Transforms/InstCombine/2012-03-10-InstCombine.ll
Transforms/InstCombine/JavaCompare.ll
Transforms/InstCombine/add.ll
Transforms/InstCombine/and-fcmp.ll
Transforms/InstCombine/and-or-icmp-nullptr.ll
Transforms/InstCombine/and-or-icmp-min-max.ll
Transforms/InstCombine/and-or-icmps.ll
Transforms/InstCombine/and2.ll
Transforms/InstCombine/and.ll
Transforms/InstCombine/apint-select.ll
Transforms/InstCombine/apint-shift.ll
Transforms/InstCombine/bit-checks.ll
Transforms/InstCombine/canonicalize-clamp-with-select-of-constant-threshold-pattern.ll
Transforms/InstCombine/cast.ll
Transforms/InstCombine/demorgan.ll
Transforms/InstCombine/dont-distribute-phi.ll
Transforms/InstCombine/icmp-custom-dl.ll
Transforms/InstCombine/icmp-div-constant.ll
Transforms/InstCombine/icmp-logical.ll
Transforms/InstCombine/icmp.ll
Transforms/InstCombine/ispow2.ll
Transforms/InstCombine/logical-select-inseltpoison.ll
Transforms/InstCombine/logical-select.ll
Transforms/InstCombine/merge-icmp.ll
Transforms/InstCombine/minmax-fold.ll
Transforms/InstCombine/onehot_merge.ll
Transforms/InstCombine/or-fcmp.ll
Transforms/InstCombine/or.ll
Transforms/InstCombine/prevent-cmp-merge.ll
Transforms/InstCombine/range-check.ll
Transforms/InstCombine/result-of-add-of-negative-is-non-zero-and-no-underflow.ll
Transforms/InstCombine/result-of-add-of-negative-or-zero-is-non-zero-and-no-underflow.ll
Transforms/InstCombine/result-of-usub-is-non-zero-and-no-overflow.ll
Transforms/InstCombine/select-and-or.ll
Transforms/InstCombine/select-cmp-br.ll
Transforms/InstCombine/select-bitext.ll
Transforms/InstCombine/select-ctlz-to-cttz.ll
Transforms/InstCombine/select-imm-canon.ll
Transforms/InstCombine/select-safe-transforms.ll
Transforms/InstCombine/select.ll
Transforms/InstCombine/select_meta.ll
Transforms/InstCombine/set.ll
Transforms/InstCombine/shift.ll
Transforms/InstCombine/sign-test-and-or.ll
Transforms/InstCombine/signed-truncation-check.ll
Transforms/InstCombine/sink_to_unreachable.ll
Transforms/InstCombine/umul-sign-check.ll
Transforms/InstCombine/unsigned_saturated_sub.ll
Transforms/InstCombine/usub-overflow-known-by-implied-cond.ll
Transforms/InstCombine/widenable-conditions.ll
Transforms/InstCombine/zext-bool-add-sub.ll
Transforms/InstCombine/zext-or-icmp.ll
Transforms/LoopUnroll/opt-levels.ll
Transforms/LoopVectorize/X86/x86-interleaved-accesses-masked-group.ll
Transforms/LoopVectorize/if-conversion-nest.ll
Transforms/LoopVectorize/phi-cost.ll
Transforms/LoopVectorize/reduction-inloop.ll
Transforms/LoopVectorize/reduction-inloop-pred.ll
Transforms/PGOProfile/chr.ll
Transforms/PhaseOrdering/X86/vector-reductions.ll
Transforms/PhaseOrdering/unsigned-multiply-overflow-check.ll
Transforms/SimpleLoopUnswitch/LIV-loop-condtion.ll
Transforms/SimpleLoopUnswitch/basictest-profmd.ll
Transforms/SimpleLoopUnswitch/copy-metadata.ll
Transforms/SimpleLoopUnswitch/delete-dead-blocks.ll
Transforms/SimpleLoopUnswitch/exponential-nontrivial-unswitch-nested.ll
Transforms/SimpleLoopUnswitch/exponential-nontrivial-unswitch-nested2.ll
Transforms/SimpleLoopUnswitch/exponential-nontrivial-unswitch.ll
Transforms/SimpleLoopUnswitch/exponential-switch-unswitch.ll
Transforms/SimpleLoopUnswitch/guards.ll
Transforms/SimpleLoopUnswitch/implicit-null-checks.ll
Transforms/SimpleLoopUnswitch/infinite-loop.ll
Transforms/SimpleLoopUnswitch/msan.ll
Transforms/SimpleLoopUnswitch/nontrivial-unswitch-cost.ll
Transforms/SimpleLoopUnswitch/pipeline.ll
Transforms/SimpleLoopUnswitch/pr37888.ll
Transforms/SimpleLoopUnswitch/nontrivial-unswitch.ll
Transforms/SimpleLoopUnswitch/preserve-scev-exiting-multiple-loops.ll
Transforms/SimpleLoopUnswitch/trivial-unswitch-iteration.ll
Transforms/SimpleLoopUnswitch/trivial-unswitch-profmd.ll
Transforms/SimpleLoopUnswitch/update-scev.ll
Transforms/SimpleLoopUnswitch/trivial-unswitch.ll
Transforms/SimplifyCFG/merge-cond-stores.ll
)

# DISABLE_PEEPHOLES=0 DISABLE_WRONG_OPTIMIZATIONS=0
#Testing Time: 3434.31s
#  Unsupported      : 14674
#  Passed           : 27427
#  Expectedly Failed:    68
EXPECTED_FAILS_1_AMD64=(
)

# DISABLE_PEEPHOLES=0 DISABLE_WRONG_OPTIMIZATIONS=0
# Testing Time: 3198.39s
#  Unsupported      : 14674
#  Passed           : 27427
#  Expectedly Failed:    68
EXPECTED_FAILS_2_AMD64=(
)

# DISABLE_PEEPHOLES=0 DISABLE_WRONG_OPTIMIZATIONS=1
#Testing Time: 3670.75s
#  Unsupported      : 14674
#  Passed           : 27329
#  Expectedly Failed:    68
#  Failed           :    98
EXPECTED_FAILS_3_AMD64=(
Other/new-pm-defaults.ll
Other/new-pm-thinlto-defaults.ll
Other/new-pm-thinlto-postlink-pgo-defaults.ll
Other/new-pm-thinlto-postlink-samplepgo-defaults.ll
Other/new-pm-thinlto-prelink-samplepgo-defaults.ll
Other/new-pm-thinlto-prelink-pgo-defaults.ll
Transforms/InstCombine/2006-12-15-Range-Test.ll
Transforms/InstCombine/2007-03-13-CompareMerge.ll
Transforms/InstCombine/2007-05-10-icmp-or.ll
Transforms/InstCombine/2007-11-15-CompareMiscomp.ll
Transforms/InstCombine/2008-01-13-AndCmpCmp.ll
Transforms/InstCombine/2008-02-28-OrFCmpCrash.ll
Transforms/InstCombine/2008-06-21-CompareMiscomp.ll
Transforms/InstCombine/2008-08-05-And.ll
Transforms/InstCombine/2012-02-28-ICmp.ll
Transforms/InstCombine/2012-03-10-InstCombine.ll
Transforms/InstCombine/JavaCompare.ll
Transforms/InstCombine/add.ll
Transforms/InstCombine/and-fcmp.ll
Transforms/InstCombine/and-or-icmp-nullptr.ll
Transforms/InstCombine/and-or-icmp-min-max.ll
Transforms/InstCombine/and-or-icmps.ll
Transforms/InstCombine/and2.ll
Transforms/InstCombine/and.ll
Transforms/InstCombine/apint-select.ll
Transforms/InstCombine/apint-shift.ll
Transforms/InstCombine/bit-checks.ll
Transforms/InstCombine/canonicalize-clamp-with-select-of-constant-threshold-pattern.ll
Transforms/InstCombine/cast.ll
Transforms/InstCombine/demorgan.ll
Transforms/InstCombine/dont-distribute-phi.ll
Transforms/InstCombine/icmp-custom-dl.ll
Transforms/InstCombine/icmp-div-constant.ll
Transforms/InstCombine/icmp-logical.ll
Transforms/InstCombine/icmp.ll
Transforms/InstCombine/ispow2.ll
Transforms/InstCombine/logical-select-inseltpoison.ll
Transforms/InstCombine/logical-select.ll
Transforms/InstCombine/merge-icmp.ll
Transforms/InstCombine/minmax-fold.ll
Transforms/InstCombine/onehot_merge.ll
Transforms/InstCombine/or-fcmp.ll
Transforms/InstCombine/or.ll
Transforms/InstCombine/prevent-cmp-merge.ll
Transforms/InstCombine/range-check.ll
Transforms/InstCombine/result-of-add-of-negative-is-non-zero-and-no-underflow.ll
Transforms/InstCombine/result-of-add-of-negative-or-zero-is-non-zero-and-no-underflow.ll
Transforms/InstCombine/result-of-usub-is-non-zero-and-no-overflow.ll
Transforms/InstCombine/select-and-or.ll
Transforms/InstCombine/select-cmp-br.ll
Transforms/InstCombine/select-bitext.ll
Transforms/InstCombine/select-ctlz-to-cttz.ll
Transforms/InstCombine/select-imm-canon.ll
Transforms/InstCombine/select-safe-transforms.ll
Transforms/InstCombine/select.ll
Transforms/InstCombine/select_meta.ll
Transforms/InstCombine/set.ll
Transforms/InstCombine/shift.ll
Transforms/InstCombine/sign-test-and-or.ll
Transforms/InstCombine/signed-truncation-check.ll
Transforms/InstCombine/sink_to_unreachable.ll
Transforms/InstCombine/umul-sign-check.ll
Transforms/InstCombine/unsigned_saturated_sub.ll
Transforms/InstCombine/usub-overflow-known-by-implied-cond.ll
Transforms/InstCombine/widenable-conditions.ll
Transforms/InstCombine/zext-bool-add-sub.ll
Transforms/InstCombine/zext-or-icmp.ll
Transforms/LoopUnroll/opt-levels.ll
Transforms/LoopVectorize/X86/x86-interleaved-accesses-masked-group.ll
Transforms/LoopVectorize/if-conversion-nest.ll
Transforms/LoopVectorize/phi-cost.ll
Transforms/LoopVectorize/reduction-inloop.ll
Transforms/LoopVectorize/reduction-inloop-pred.ll
Transforms/PGOProfile/chr.ll
Transforms/PhaseOrdering/X86/vector-reductions.ll
Transforms/PhaseOrdering/unsigned-multiply-overflow-check.ll
Transforms/SimpleLoopUnswitch/LIV-loop-condtion.ll
Transforms/SimpleLoopUnswitch/basictest-profmd.ll
Transforms/SimpleLoopUnswitch/copy-metadata.ll
Transforms/SimpleLoopUnswitch/delete-dead-blocks.ll
Transforms/SimpleLoopUnswitch/exponential-nontrivial-unswitch-nested.ll
Transforms/SimpleLoopUnswitch/exponential-nontrivial-unswitch-nested2.ll
Transforms/SimpleLoopUnswitch/exponential-nontrivial-unswitch.ll
Transforms/SimpleLoopUnswitch/exponential-switch-unswitch.ll
Transforms/SimpleLoopUnswitch/guards.ll
Transforms/SimpleLoopUnswitch/implicit-null-checks.ll
Transforms/SimpleLoopUnswitch/infinite-loop.ll
Transforms/SimpleLoopUnswitch/msan.ll
Transforms/SimpleLoopUnswitch/nontrivial-unswitch-cost.ll
Transforms/SimpleLoopUnswitch/pipeline.ll
Transforms/SimpleLoopUnswitch/pr37888.ll
Transforms/SimpleLoopUnswitch/nontrivial-unswitch.ll
Transforms/SimpleLoopUnswitch/preserve-scev-exiting-multiple-loops.ll
Transforms/SimpleLoopUnswitch/trivial-unswitch-iteration.ll
Transforms/SimpleLoopUnswitch/trivial-unswitch-profmd.ll
Transforms/SimpleLoopUnswitch/update-scev.ll
Transforms/SimpleLoopUnswitch/trivial-unswitch.ll
Transforms/SimplifyCFG/merge-cond-stores.ll
)

# Testing DISABLE_PEEPHOLES=0 DISABLE_WRONG_OPTIMIZATIONS=0
#Testing Time: 3378.44s
#  Unsupported      : 14674
#  Passed           : 27427
#  Expectedly Failed:    68
EXPECTED_FAILS_4_AMD64=(
)

# Testing DISABLE_PEEPHOLES=1 DISABLE_WRONG_OPTIMIZATIONS=1
#Testing Time: 3002.88s
#  Unsupported      : 14674
#  Passed           : 25631
#  Expectedly Failed:    68
#  Failed           :  1796
EXPECTED_FAILS_5_AMD64=(
Analysis/BasicAA/2003-09-19-LocalArgument.ll
Analysis/BasicAA/2007-08-05-GetOverloadedModRef.ll
Analysis/BasicAA/2009-10-13-AtomicModRef.ll
Analysis/BasicAA/cas.ll
Analysis/BasicAA/featuretest.ll
Analysis/BasicAA/full-store-partial-alias.ll
Analysis/BasicAA/gcsetest.ll
Analysis/BasicAA/gep-alias.ll
Analysis/BasicAA/global-size.ll
Analysis/BasicAA/modref.ll
Analysis/BasicAA/nocapture.ll
Analysis/BasicAA/tailcall-modref.ll
Analysis/CFLAliasAnalysis/Steensgaard/full-store-partial-alias.ll
Analysis/GlobalsModRef/dead-uses.ll
Analysis/GlobalsModRef/indirect-global.ll
Analysis/GlobalsModRef/memset-escape.ll
Analysis/GlobalsModRef/pr35899-dbg-value.ll
Analysis/GlobalsModRef/purecse.ll
Analysis/MemoryDependenceAnalysis/InvariantLoad.ll
Analysis/MemorySSA/nondeterminism.ll
Analysis/MemorySSA/phi-translation.ll
Analysis/ScalarEvolution/2012-03-26-LoadConstant.ll
Analysis/TypeBasedAliasAnalysis/memcpyopt.ll
Analysis/ValueTracking/aarch64.irg.ll
Analysis/ValueTracking/assume-queries-counter.ll
Analysis/ValueTracking/assume.ll
Analysis/ValueTracking/gep-negative-issue.ll
Analysis/ValueTracking/get-pointer-base-with-const-off.ll
Analysis/ValueTracking/invariant.group.ll
Analysis/ValueTracking/known-bits-from-range-md.ll
Analysis/ValueTracking/known-non-equal.ll
Analysis/ValueTracking/known-nonnull-at.ll
Analysis/ValueTracking/knownzero-shift.ll
Analysis/ValueTracking/monotonic-phi.ll
Analysis/ValueTracking/non-negative-phi-bits.ll
Analysis/ValueTracking/numsignbits-from-assume.ll
Analysis/ValueTracking/select-pattern.ll
Analysis/ValueTracking/signbits-extract-elt.ll
Assembler/2003-08-20-ConstantExprGEP-Fold.ll
Bitcode/value-with-long-name.ll
CodeGen/AMDGPU/GlobalISel/ashr.ll
CodeGen/AMDGPU/GlobalISel/llvm.powi.ll
CodeGen/AMDGPU/GlobalISel/lshr.ll
CodeGen/AMDGPU/GlobalISel/shl.ll
CodeGen/AMDGPU/GlobalISel/udiv.i64.ll
CodeGen/AMDGPU/GlobalISel/urem.i64.ll
CodeGen/AMDGPU/aa-points-to-constant-memory.ll
CodeGen/AMDGPU/amdgpu-codegenprepare-idiv.ll
CodeGen/AMDGPU/branch-relaxation.ll
CodeGen/AMDGPU/bypass-div.ll
CodeGen/AMDGPU/chain-hi-to-lo.ll
CodeGen/AMDGPU/cndmask-no-def-vcc.ll
CodeGen/AMDGPU/dagcombine-setcc-select.ll
CodeGen/AMDGPU/debug-value.ll
CodeGen/AMDGPU/ds_write2.ll
CodeGen/AMDGPU/fdiv32-to-rcp-folding.ll
CodeGen/AMDGPU/global-variable-relocs.ll
CodeGen/AMDGPU/idiv-licm.ll
CodeGen/AMDGPU/imm.ll
CodeGen/AMDGPU/loop_exit_with_xor.ll
CodeGen/AMDGPU/memory_clause.ll
CodeGen/AMDGPU/nested-loop-conditions.ll
CodeGen/AMDGPU/propagate-attributes-single-set.ll
CodeGen/AMDGPU/reqd-work-group-size.ll
CodeGen/AMDGPU/sdiv64.ll
CodeGen/AMDGPU/setcc-opt.ll
CodeGen/AMDGPU/simplify-libcalls.ll
CodeGen/AMDGPU/skip-if-dead.ll
CodeGen/AMDGPU/splitkit-getsubrangeformask.ll
CodeGen/AMDGPU/srem64.ll
CodeGen/AMDGPU/sroa-before-unroll.ll
CodeGen/AMDGPU/sub.v2i16.ll
CodeGen/AMDGPU/udiv64.ll
CodeGen/AMDGPU/unroll.ll
CodeGen/AMDGPU/urem64.ll
CodeGen/AMDGPU/vector-alloca-atomic.ll
CodeGen/AMDGPU/vector-alloca-bitcast.ll
CodeGen/AMDGPU/vector-alloca.ll
CodeGen/BPF/adjust-opt-icmp1.ll
CodeGen/BPF/adjust-opt-icmp2.ll
CodeGen/BPF/adjust-opt-speculative1.ll
CodeGen/BPF/adjust-opt-speculative2.ll
CodeGen/BPF/simplifycfg.ll
CodeGen/NVPTX/call-with-alloca-buffer.ll
CodeGen/X86/and-or-fold.ll
CodeGen/X86/memcmp-constant.ll
CodeGen/X86/memcmp.ll
CodeGen/X86/no-plt-libcalls.ll
CodeGen/X86/pr38762.ll
CodeGen/X86/pr38763.ll
DebugInfo/Generic/dbg-value-lower-linenos.ll
DebugInfo/Generic/instcombine-phi.ll
DebugInfo/Generic/simplifycfg_sink_last_inst.ll
DebugInfo/Generic/store-tail-merge.ll
DebugInfo/X86/dbg-value-dropped-instcombine.ll
DebugInfo/X86/formal_parameter.ll
DebugInfo/X86/instcombine-demanded-bits-salvage.ll
DebugInfo/X86/instcombine-instrinsics.ll
Feature/OperandBundles/basic-aa-argmemonly.ll
Feature/optnone-opt.ll
LTO/X86/tli-nobuiltin.ll
LTO/X86/triple-init.ll
Other/2008-06-04-FieldSizeInPacked.ll
Other/cgscc-devirt-iteration.ll
Other/cgscc-disconnected-invalidation.ll
Other/cgscc-iterate-function-mutation.ll
Other/cgscc-libcall-update.ll
Other/constant-fold-gep.ll
Other/debugcounter-newgvn.ll
Other/devirtualization-undef.ll
Other/lint.ll
Other/new-pm-defaults.ll
Other/new-pm-lto-defaults.ll
Other/new-pm-pgo-preinline.ll
Other/new-pm-thinlto-defaults.ll
Other/new-pm-thinlto-postlink-pgo-defaults.ll
Other/new-pm-thinlto-postlink-samplepgo-defaults.ll
Other/new-pm-thinlto-prelink-pgo-defaults.ll
Other/new-pm-thinlto-prelink-samplepgo-defaults.ll
Other/print-debug-counter.ll
Other/size-remarks.ll
ThinLTO/X86/cfi-devirt.ll
ThinLTO/X86/cfi-unsat.ll
ThinLTO/X86/devirt_external_comdat_same_guid.ll
ThinLTO/X86/devirt_promote.ll
ThinLTO/X86/devirt_promote_legacy.ll
ThinLTO/X86/tli-nobuiltin.ll
Transforms/AggressiveInstCombine/funnel.ll
Transforms/AggressiveInstCombine/masked-cmp.ll
Transforms/AggressiveInstCombine/popcount.ll
Transforms/AggressiveInstCombine/rotate.ll
Transforms/AggressiveInstCombine/trunc_const_expr.ll
Transforms/AggressiveInstCombine/trunc_multi_uses.ll
Transforms/AggressiveInstCombine/trunc_select.ll
Transforms/AggressiveInstCombine/trunc_select_cmp.ll
Transforms/BDCE/basic.ll
Transforms/CallSiteSplitting/callsite-split.ll
Transforms/CallSiteSplitting/split-loop.ll
Transforms/CodeGenPrepare/X86/widenable-condition.ll
Transforms/Coroutines/ArgAddr.ll
Transforms/Coroutines/coro-alloca-01.ll
Transforms/Coroutines/coro-alloca-05.ll
Transforms/Coroutines/coro-alloca-04.ll
Transforms/Coroutines/coro-catchswitch-cleanuppad.ll
Transforms/Coroutines/coro-async.ll
Transforms/Coroutines/coro-catchswitch.ll
Transforms/Coroutines/coro-frame-arrayalloca.ll
Transforms/Coroutines/coro-frame.ll
Transforms/Coroutines/coro-heap-elide.ll
Transforms/Coroutines/coro-padding.ll
Transforms/Coroutines/coro-param-copy.ll
Transforms/Coroutines/coro-retcon-alloca.ll
Transforms/Coroutines/coro-retcon-once-value.ll
Transforms/Coroutines/coro-retcon-once-value2.ll
Transforms/Coroutines/coro-retcon-resume-values.ll
Transforms/Coroutines/coro-retcon-resume-values2.ll
Transforms/Coroutines/coro-retcon-unreachable.ll
Transforms/Coroutines/coro-retcon-value.ll
Transforms/Coroutines/coro-retcon.ll
Transforms/Coroutines/coro-spill-after-phi.ll
Transforms/Coroutines/coro-spill-defs-before-corobegin.ll
Transforms/Coroutines/coro-split-02.ll
Transforms/Coroutines/coro-split-01.ll
Transforms/Coroutines/coro-split-eh-00.ll
Transforms/Coroutines/coro-split-eh-01.ll
Transforms/Coroutines/coro-split-sink-lifetime-01.ll
Transforms/Coroutines/coro-split-sink-lifetime-03.ll
Transforms/Coroutines/coro-split-sink-lifetime-04.ll
Transforms/Coroutines/coro-swifterror.ll
Transforms/Coroutines/ex0.ll
Transforms/Coroutines/ex1.ll
Transforms/Coroutines/ex2.ll
Transforms/Coroutines/ex3.ll
Transforms/Coroutines/ex4.ll
Transforms/Coroutines/ex5.ll
Transforms/Coroutines/no-suspend.ll
Transforms/CorrelatedValuePropagation/overflows.ll
Transforms/DeadArgElim/multdeadretval.ll
Transforms/EarlyCSE/and_or.ll
Transforms/EarlyCSE/atomics.ll
Transforms/EarlyCSE/basic.ll
Transforms/EarlyCSE/commute.ll
Transforms/EarlyCSE/const-speculation.ll
Transforms/EarlyCSE/debuginfo-dce.ll
Transforms/EarlyCSE/floatingpoint.ll
Transforms/EarlyCSE/gc_relocate.ll
Transforms/EarlyCSE/guards.ll
Transforms/EarlyCSE/invariant.start.ll
Transforms/EarlyCSE/memoryssa.ll
Transforms/GVN/2010-11-13-Simplify.ll
Transforms/GVN/PRE/2017-06-28-pre-load-dbgloc.ll
Transforms/GVN/PRE/atomic.ll
Transforms/GVN/PRE/2018-06-08-pre-load-dbgloc-no-null-opt.ll
Transforms/GVN/PRE/invariant-load.ll
Transforms/GVN/PRE/load-pre-licm.ll
Transforms/GVN/PRE/pre-gep-load.ll
Transforms/GVN/PRE/rle.ll
Transforms/GVN/PRE/volatile.ll
Transforms/GVN/assume-equal.ll
Transforms/GVN/big-endian.ll
Transforms/GVN/calls-nonlocal.ll
Transforms/GVN/calls-readonly.ll
Transforms/GVN/commute.ll
Transforms/GVN/cond_br.ll
Transforms/GVN/cond_br2.ll
Transforms/GVN/condprop.ll
Transforms/GVN/constexpr-vector-constainsundef-crash-inseltpoison.ll
Transforms/GVN/constexpr-vector-constainsundef-crash.ll
Transforms/GVN/critical-edge-split-indbr-pred-in-loop.ll
Transforms/GVN/edge.ll
Transforms/GVN/fence.ll
Transforms/GVN/fold-const-expr.ll
Transforms/GVN/freeze.ll
Transforms/GVN/invariant.group.ll
Transforms/GVN/load-constant-mem.ll
Transforms/GVN/loadpre-missed-opportunity.ll
Transforms/GVN/masked-load-store-vn-crash.ll
Transforms/GVN/pr14166.ll
Transforms/GVN/preserve-memoryssa.ll
Transforms/GVN/tbaa.ll
Transforms/GVN/vscale.ll
Transforms/GVNSink/indirect-call.ll
Transforms/GVNSink/sink-common-code.ll
Transforms/GlobalDCE/deadblockaddr.ll
Transforms/GlobalOpt/constantexpr-dangle.ll
Transforms/GlobalOpt/evaluate-bitcast.ll
Transforms/GlobalOpt/evaluate-call.ll
Transforms/GlobalOpt/evaluate-constfold-call.ll
Transforms/GlobalOpt/integer-bool.ll
Transforms/IndVarSimplify/2014-06-21-congruent-constant.ll
Transforms/IndVarSimplify/X86/2009-04-15-shorten-iv-vars-2.ll
Transforms/IndVarSimplify/X86/pr45360.ll
Transforms/IndVarSimplify/exit_value_tests.ll
Transforms/IndVarSimplify/loop_evaluate_1.ll
Transforms/IndVarSimplify/rewrite-loop-exit-value.ll
Transforms/Inline/byval-tail-call.ll
Transforms/Inline/cgscc-cycle.ll
Transforms/Inline/devirtualize-3.ll
Transforms/Inline/devirtualize-5.ll
Transforms/Inline/devirtualize-4.ll
Transforms/Inline/devirtualize.ll
Transforms/Inline/inline-constexpr-addrspacecast-argument.ll
Transforms/Inline/inline_cleanup.ll
Transforms/Inline/inline_constprop.ll
Transforms/Inline/invoke_test-2.ll
Transforms/Inline/pr50270.ll
Transforms/Inline/ptr-diff.ll
Transforms/Inline/recursive.ll
Transforms/InstCombine/2003-05-26-CastMiscompile.ll
Transforms/InstCombine/2003-08-12-AllocaNonNull.ll
Transforms/InstCombine/2004-08-10-BoolSetCC.ll
Transforms/InstCombine/2004-09-20-BadLoadCombine.ll
Transforms/InstCombine/2004-11-22-Missed-and-fold.ll
Transforms/InstCombine/2004-11-27-SetCCForCastLargerAndConstant.ll
Transforms/InstCombine/2006-04-28-ShiftShiftLongLong.ll
Transforms/InstCombine/2006-10-19-SignedToUnsignedCastAndConst-2.ll
Transforms/InstCombine/2006-10-26-VectorReassoc.ll
Transforms/InstCombine/2006-12-15-Range-Test.ll
Transforms/InstCombine/2007-01-13-ExtCompareMiscompile.ll
Transforms/InstCombine/2007-03-13-CompareMerge.ll
Transforms/InstCombine/2007-03-19-BadTruncChangePR1261.ll
Transforms/InstCombine/2007-03-21-SignedRangeTest.ll
Transforms/InstCombine/2007-03-25-BadShiftMask.ll
Transforms/InstCombine/2007-03-25-DoubleShift.ll
Transforms/InstCombine/2007-03-26-BadShiftMask.ll
Transforms/InstCombine/2007-05-10-icmp-or.ll
Transforms/InstCombine/2007-06-21-DivCompareMiscomp.ll
Transforms/InstCombine/2007-10-10-EliminateMemCpy.ll
Transforms/InstCombine/2007-11-15-CompareMiscomp.ll
Transforms/InstCombine/2007-12-16-AsmNoUnwind.ll
Transforms/InstCombine/2007-12-18-AddSelCmpSub.ll
Transforms/InstCombine/2007-12-28-IcmpSub2.ll
Transforms/InstCombine/2008-01-06-BitCastAttributes.ll
Transforms/InstCombine/2008-01-13-AndCmpCmp.ll
Transforms/InstCombine/2008-01-21-MismatchedCastAndCompare.ll
Transforms/InstCombine/2008-01-21-MulTrunc.ll
Transforms/InstCombine/2008-02-16-SDivOverflow2.ll
Transforms/InstCombine/2008-02-23-MulSub.ll
Transforms/InstCombine/2008-02-28-OrFCmpCrash.ll
Transforms/InstCombine/2008-05-08-StrLenSink.ll
Transforms/InstCombine/2008-05-18-FoldIntToPtr.ll
Transforms/InstCombine/2008-05-23-CompareFold.ll
Transforms/InstCombine/2008-05-31-AddBool.ll
Transforms/InstCombine/2008-05-31-Bools.ll
Transforms/InstCombine/2008-06-21-CompareMiscomp.ll
Transforms/InstCombine/2008-07-08-ShiftOneAndOne.ll
Transforms/InstCombine/2008-07-10-CastSextBool.ll
Transforms/InstCombine/2008-07-11-RemAnd.ll
Transforms/InstCombine/2008-07-13-DivZero.ll
Transforms/InstCombine/2008-08-05-And.ll
Transforms/InstCombine/2008-10-11-DivCompareFold.ll
Transforms/InstCombine/2008-11-01-SRemDemandedBits.ll
Transforms/InstCombine/2008-11-08-FCmp.ll
Transforms/InstCombine/2008-11-27-IDivVector.ll
Transforms/InstCombine/2008-11-27-MultiplyIntVec.ll
Transforms/InstCombine/2008-12-17-SRemNegConstVec.ll
Transforms/InstCombine/2009-01-08-AlignAlloca.ll
Transforms/InstCombine/2009-01-19-fmod-constant-float-specials.ll
Transforms/InstCombine/2009-01-19-fmod-constant-float.ll
Transforms/InstCombine/2009-02-21-LoadCST.ll
Transforms/InstCombine/2009-05-23-FCmpToICmp.ll
Transforms/InstCombine/2009-12-17-CmpSelectNull.ll
Transforms/InstCombine/2010-05-30-memcpy-Struct.ll
Transforms/InstCombine/2010-03-03-ExtElim.ll
Transforms/InstCombine/2010-11-21-SizeZeroTypeGEP.ll
Transforms/InstCombine/2010-11-01-lshr-mask.ll
Transforms/InstCombine/2010-11-23-Distributed.ll
Transforms/InstCombine/2011-03-08-SRemMinusOneBadOpt.ll
Transforms/InstCombine/2011-05-28-swapmulsub.ll
Transforms/InstCombine/2011-06-13-nsw-alloca.ll
Transforms/InstCombine/2011-09-03-Trampoline.ll
Transforms/InstCombine/2011-10-07-AlignPromotion.ll
Transforms/InstCombine/2012-02-13-FCmp.ll
Transforms/InstCombine/2012-02-28-ICmp.ll
Transforms/InstCombine/2012-03-10-InstCombine.ll
Transforms/InstCombine/2012-04-24-vselect.ll
Transforms/InstCombine/2012-07-25-LoadPart.ll
Transforms/InstCombine/2012-08-28-udiv_ashl.ll
Transforms/InstCombine/2012-09-17-ZeroSizedAlloca.ll
Transforms/InstCombine/AMDGPU/amdgcn-demanded-vector-elts.ll
Transforms/InstCombine/AMDGPU/amdgcn-demanded-vector-elts-inseltpoison.ll
Transforms/InstCombine/AMDGPU/fma_legacy.ll
Transforms/InstCombine/AMDGPU/fmul_legacy.ll
Transforms/InstCombine/AMDGPU/ldexp.ll
Transforms/InstCombine/AMDGPU/memcpy-from-constant.ll
Transforms/InstCombine/AddOverFlow.ll
Transforms/InstCombine/CPP_min_max.ll
Transforms/InstCombine/ExtractCast.ll
Transforms/InstCombine/JavaCompare.ll
Transforms/InstCombine/LandingPadClauses.ll
Transforms/InstCombine/NVPTX/nvvm-intrins.ll
Transforms/InstCombine/OverlappingInsertvalues.ll
Transforms/InstCombine/PR30597.ll
Transforms/InstCombine/X86/2009-03-23-i80-fp80.ll
Transforms/InstCombine/X86/addcarry.ll
Transforms/InstCombine/X86/blend_x86.ll
Transforms/InstCombine/X86/clmulqdq.ll
Transforms/InstCombine/X86/x86-addsub-inseltpoison.ll
Transforms/InstCombine/X86/x86-addsub.ll
Transforms/InstCombine/X86/x86-avx2-inseltpoison.ll
Transforms/InstCombine/X86/x86-avx2.ll
Transforms/InstCombine/AMDGPU/amdgcn-intrinsics.ll
Transforms/InstCombine/X86/x86-avx512-inseltpoison.ll
Transforms/InstCombine/X86/x86-bmi-tbm.ll
Transforms/InstCombine/X86/x86-crc32-demanded.ll
Transforms/InstCombine/X86/x86-f16c-inseltpoison.ll
Transforms/InstCombine/X86/x86-f16c.ll
Transforms/InstCombine/X86/x86-fma.ll
Transforms/InstCombine/X86/x86-insertps.ll
Transforms/InstCombine/X86/x86-masked-memops.ll
Transforms/InstCombine/X86/x86-movmsk.ll
Transforms/InstCombine/X86/x86-avx512.ll
Transforms/InstCombine/X86/x86-muldq-inseltpoison.ll
Transforms/InstCombine/X86/x86-muldq.ll
Transforms/InstCombine/X86/x86-pack-inseltpoison.ll
Transforms/InstCombine/X86/x86-pack.ll
Transforms/InstCombine/X86/x86-pshufb-inseltpoison.ll
Transforms/InstCombine/X86/x86-pshufb.ll
Transforms/InstCombine/X86/x86-sse-inseltpoison.ll
Transforms/InstCombine/X86/x86-sse.ll
Transforms/InstCombine/X86/x86-sse2-inseltpoison.ll
Transforms/InstCombine/X86/x86-sse41-inseltpoison.ll
Transforms/InstCombine/X86/x86-sse2.ll
Transforms/InstCombine/X86/x86-sse41.ll
Transforms/InstCombine/X86/x86-sse4a-inseltpoison.ll
Transforms/InstCombine/X86/x86-sse4a.ll
Transforms/InstCombine/X86/x86-vec_demanded_elts-inseltpoison.ll
Transforms/InstCombine/X86/x86-vec_demanded_elts.ll
Transforms/InstCombine/X86/x86-vector-shifts.ll
Transforms/InstCombine/X86/x86-vector-shifts-inseltpoison.ll
Transforms/InstCombine/X86/x86-vpermil-inseltpoison.ll
Transforms/InstCombine/X86/x86-vpermil.ll
Transforms/InstCombine/X86/x86-xop-inseltpoison.ll
Transforms/InstCombine/X86/x86-xop.ll
Transforms/InstCombine/abs-1.ll
Transforms/InstCombine/abs-intrinsic.ll
Transforms/InstCombine/add-shl-sdiv-to-srem.ll
Transforms/InstCombine/add-sitofp.ll
Transforms/InstCombine/abs_abs.ll
Transforms/InstCombine/add.ll
Transforms/InstCombine/add2.ll
Transforms/InstCombine/add4.ll
Transforms/InstCombine/addnegneg.ll
Transforms/InstCombine/addrspacecast.ll
Transforms/InstCombine/addsub-constant-folding.ll
Transforms/InstCombine/adjust-for-minmax.ll
Transforms/InstCombine/aggregate-reconstruction.ll
Transforms/InstCombine/align-2d-gep.ll
Transforms/InstCombine/align-attr.ll
Transforms/InstCombine/align-addr.ll
Transforms/InstCombine/align-external.ll
Transforms/InstCombine/all-bits-shift.ll
Transforms/InstCombine/alloca-big.ll
Transforms/InstCombine/alloca-cast-debuginfo.ll
Transforms/InstCombine/alloca.ll
Transforms/InstCombine/allocsize-32.ll
Transforms/InstCombine/allocsize.ll
Transforms/InstCombine/and-compare.ll
Transforms/InstCombine/and-narrow.ll
Transforms/InstCombine/and-or-and.ll
Transforms/InstCombine/and-fcmp.ll
Transforms/InstCombine/and-or-icmp-min-max.ll
Transforms/InstCombine/and-or-icmp-nullptr.ll
Transforms/InstCombine/and-or-icmps.ll
Transforms/InstCombine/and-or-not.ll
Transforms/InstCombine/and-or.ll
Transforms/InstCombine/and-xor-merge.ll
Transforms/InstCombine/and-xor-or.ll
Transforms/InstCombine/and2.ll
Transforms/InstCombine/and.ll
Transforms/InstCombine/apint-add.ll
Transforms/InstCombine/annotations.ll
Transforms/InstCombine/apint-and-compare.ll
Transforms/InstCombine/apint-and-or-and.ll
Transforms/InstCombine/apint-and-xor-merge.ll
Transforms/InstCombine/apint-and.ll
Transforms/InstCombine/apint-call-cast-target.ll
Transforms/InstCombine/apint-cast-and-cast.ll
Transforms/InstCombine/apint-cast-cast-to-and.ll
Transforms/InstCombine/apint-cast.ll
Transforms/InstCombine/apint-div1.ll
Transforms/InstCombine/apint-div2.ll
Transforms/InstCombine/apint-mul1.ll
Transforms/InstCombine/apint-mul2.ll
Transforms/InstCombine/apint-not.ll
Transforms/InstCombine/apint-or.ll
Transforms/InstCombine/apint-rem1.ll
Transforms/InstCombine/apint-rem2.ll
Transforms/InstCombine/apint-select.ll
Transforms/InstCombine/apint-shift-simplify.ll
Transforms/InstCombine/apint-shl-trunc.ll
Transforms/InstCombine/apint-shift.ll
Transforms/InstCombine/apint-sub.ll
Transforms/InstCombine/apint-xor1.ll
Transforms/InstCombine/apint-xor2.ll
Transforms/InstCombine/ashr-lshr.ll
Transforms/InstCombine/ashr-or-mul-abs.ll
Transforms/InstCombine/assoc-cast-assoc.ll
Transforms/InstCombine/assume-align.ll
Transforms/InstCombine/assume-loop-align.ll
Transforms/InstCombine/assume-redundant.ll
Transforms/InstCombine/assume2.ll
Transforms/InstCombine/assume.ll
Transforms/InstCombine/assume_inevitable.ll
Transforms/InstCombine/atomic.ll
Transforms/InstCombine/badmalloc.ll
Transforms/InstCombine/atomicrmw.ll
Transforms/InstCombine/bcopy.ll
Transforms/InstCombine/bcmp-1.ll
Transforms/InstCombine/bitcast-bigendian.ll
Transforms/InstCombine/bit-checks.ll
Transforms/InstCombine/bitcast-bitcast.ll
Transforms/InstCombine/bitcast-function.ll
Transforms/InstCombine/bitcast-phi-uselistorder.ll
Transforms/InstCombine/bitcast-inseltpoison.ll
Transforms/InstCombine/bitcast-store.ll
Transforms/InstCombine/bitcast-vec-canon-inseltpoison.ll
Transforms/InstCombine/bitcast-vec-canon.ll
Transforms/InstCombine/bitcast.ll
Transforms/InstCombine/bitreverse-known-bits.ll
Transforms/InstCombine/bittest.ll
Transforms/InstCombine/bitreverse.ll
Transforms/InstCombine/branch.ll
Transforms/InstCombine/broadcast-inseltpoison.ll
Transforms/InstCombine/broadcast.ll
Transforms/InstCombine/bswap-fold.ll
Transforms/InstCombine/bswap-inseltpoison.ll
Transforms/InstCombine/bswap-known-bits.ll
Transforms/InstCombine/builtin-dynamic-object-size.ll
Transforms/InstCombine/builtin-object-size-custom-dl.ll
Transforms/InstCombine/bswap.ll
Transforms/InstCombine/builtin-object-size-offset.ll
Transforms/InstCombine/builtin-object-size-ptr.ll
Transforms/InstCombine/byval.ll
Transforms/InstCombine/cabs-array.ll
Transforms/InstCombine/cabs-discrete.ll
Transforms/InstCombine/call-callconv.ll
Transforms/InstCombine/call-cast-attrs.ll
Transforms/InstCombine/call-cast-target.ll
Transforms/InstCombine/call-guard.ll
Transforms/InstCombine/call-returned.ll
Transforms/InstCombine/call.ll
Transforms/InstCombine/call_nonnull_arg.ll
Transforms/InstCombine/callsite_nonnull_args_through_casts.ll
Transforms/InstCombine/canonicalize-ashr-shl-to-masking.ll
Transforms/InstCombine/canonicalize-clamp-like-pattern-between-negative-and-positive-thresholds.ll
Transforms/InstCombine/canonicalize-clamp-like-pattern-between-zero-and-positive-threshold.ll
Transforms/InstCombine/canonicalize-clamp-with-select-of-constant-threshold-pattern.ll
Transforms/InstCombine/canonicalize-constant-low-bit-mask-and-icmp-eq-to-icmp-ule.ll
Transforms/InstCombine/canonicalize-constant-low-bit-mask-and-icmp-ne-to-icmp-ugt.ll
Transforms/InstCombine/canonicalize-constant-low-bit-mask-and-icmp-sge-to-icmp-sle.ll
Transforms/InstCombine/canonicalize-constant-low-bit-mask-and-icmp-sgt-to-icmp-sgt.ll
Transforms/InstCombine/canonicalize-constant-low-bit-mask-and-icmp-sle-to-icmp-sle.ll
Transforms/InstCombine/canonicalize-constant-low-bit-mask-and-icmp-slt-to-icmp-sgt.ll
Transforms/InstCombine/canonicalize-constant-low-bit-mask-and-icmp-uge-to-icmp-ule.ll
Transforms/InstCombine/canonicalize-constant-low-bit-mask-and-icmp-ugt-to-icmp-ugt.ll
Transforms/InstCombine/canonicalize-constant-low-bit-mask-and-icmp-ule-to-icmp-ule.ll
Transforms/InstCombine/canonicalize-constant-low-bit-mask-and-icmp-ult-to-icmp-ugt.ll
Transforms/InstCombine/canonicalize-low-bit-mask-and-icmp-eq-to-icmp-ule.ll
Transforms/InstCombine/canonicalize-lack-of-signed-truncation-check.ll
Transforms/InstCombine/canonicalize-low-bit-mask-and-icmp-ne-to-icmp-ugt.ll
Transforms/InstCombine/canonicalize-low-bit-mask-v2-and-icmp-eq-to-icmp-ule.ll
Transforms/InstCombine/canonicalize-low-bit-mask-v2-and-icmp-ne-to-icmp-ugt.ll
Transforms/InstCombine/canonicalize-low-bit-mask-v3-and-icmp-eq-to-icmp-ule.ll
Transforms/InstCombine/canonicalize-low-bit-mask-v3-and-icmp-ne-to-icmp-ugt.ll
Transforms/InstCombine/canonicalize-low-bit-mask-v4-and-icmp-eq-to-icmp-ule.ll
Transforms/InstCombine/canonicalize-low-bit-mask-v4-and-icmp-ne-to-icmp-ugt.ll
Transforms/InstCombine/canonicalize-lshr-shl-to-masking.ll
Transforms/InstCombine/canonicalize-selects-icmp-condition-bittest.ll
Transforms/InstCombine/canonicalize-shl-lshr-to-masking.ll
Transforms/InstCombine/canonicalize-signed-truncation-check.ll
Transforms/InstCombine/canonicalize-vector-extract.ll
Transforms/InstCombine/canonicalize-vector-insert.ll
Transforms/InstCombine/canonicalize_branch.ll
Transforms/InstCombine/cast-call-combine-prof.ll
Transforms/InstCombine/cast-call-combine.ll
Transforms/InstCombine/cast-callee-deopt-bundles.ll
Transforms/InstCombine/cast-int-fcmp-eq-0.ll
Transforms/InstCombine/cast-int-icmp-eq-0.ll
Transforms/InstCombine/cast-mul-select.ll
Transforms/InstCombine/cast-select.ll
Transforms/InstCombine/cast-set-preserve-signed-dbg-val.ll
Transforms/InstCombine/cast-set.ll
Transforms/InstCombine/cast-unsigned-icmp-eqcmp-0.ll
Transforms/InstCombine/cast_phi.ll
Transforms/InstCombine/cast_ptr.ll
Transforms/InstCombine/cast.ll
Transforms/InstCombine/ceil.ll
Transforms/InstCombine/clamp-to-minmax.ll
Transforms/InstCombine/cmp-intrinsic.ll
Transforms/InstCombine/cmp-x-vs-neg-x.ll
Transforms/InstCombine/commutative-intrinsics.ll
Transforms/InstCombine/compare-3way.ll
Transforms/InstCombine/compare-alloca.ll
Transforms/InstCombine/compare-signs.ll
Transforms/InstCombine/compare-udiv.ll
Transforms/InstCombine/compare-unescaped.ll
Transforms/InstCombine/consecutive-fences.ll
Transforms/InstCombine/constant-expr-datalayout.ll
Transforms/InstCombine/conditional-variable-length-signext-after-high-bit-extract.ll
Transforms/InstCombine/constant-fold-alias.ll
Transforms/InstCombine/constant-fold-address-space-pointer.ll
Transforms/InstCombine/constant-fold-compare.ll
Transforms/InstCombine/constant-fold-iteration.ll
Transforms/InstCombine/constant-fold-libfunc.ll
Transforms/InstCombine/constant-fold-gep.ll
Transforms/InstCombine/constant-fold-shifts.ll
Transforms/InstCombine/constant-fold-math.ll
Transforms/InstCombine/convergent.ll
Transforms/InstCombine/copysign.ll
Transforms/InstCombine/cos-1.ll
Transforms/InstCombine/cos-sin-intrinsic.ll
Transforms/InstCombine/ctpop-bswap-bitreverse.ll
Transforms/InstCombine/ctlz-cttz-bitreverse.ll
Transforms/InstCombine/ctpop-cttz.ll
Transforms/InstCombine/ctpop.ll
Transforms/InstCombine/cttz-negative.ll
Transforms/InstCombine/cttz-abs.ll
Transforms/InstCombine/dce-iterate.ll
Transforms/InstCombine/deadcode.ll
Transforms/InstCombine/debug-line.ll
Transforms/InstCombine/debuginfo-dce.ll
Transforms/InstCombine/debuginfo-dce2.ll
Transforms/InstCombine/debuginfo-sink.ll
Transforms/InstCombine/debuginfo-skip.ll
Transforms/InstCombine/debuginfo.ll
Transforms/InstCombine/debuginfo-variables.ll
Transforms/InstCombine/debuginfo_add.ll
Transforms/InstCombine/demand_shrink_nsw.ll
Transforms/InstCombine/demorgan-sink-not-into-xor.ll
Transforms/InstCombine/demorgan.ll
Transforms/InstCombine/deref-alloc-fns.ll
Transforms/InstCombine/distribute.ll
Transforms/InstCombine/div-shift.ll
Transforms/InstCombine/div.ll
Transforms/InstCombine/do-not-clone-dbg-declare.ll
Transforms/InstCombine/dont-distribute-phi.ll
Transforms/InstCombine/double-float-shrink-1.ll
Transforms/InstCombine/early_constfold_changes_IR.ll
Transforms/InstCombine/double-float-shrink-2.ll
Transforms/InstCombine/erase-dbg-values-at-dead-alloc-site.ll
Transforms/InstCombine/err-rep-cold.ll
Transforms/InstCombine/element-atomic-memintrins.ll
Transforms/InstCombine/exp2-1.ll
Transforms/InstCombine/exact.ll
Transforms/InstCombine/extractelement-inseltpoison.ll
Transforms/InstCombine/extractelement.ll
Transforms/InstCombine/extractinsert-tbaa.ll
Transforms/InstCombine/extractvalue.ll
Transforms/InstCombine/fabs-copysign.ll
Transforms/InstCombine/fabs-libcall.ll
Transforms/InstCombine/fadd-fsub-factor.ll
Transforms/InstCombine/fabs.ll
Transforms/InstCombine/fadd.ll
Transforms/InstCombine/fcmp-select.ll
Transforms/InstCombine/fast-math.ll
Transforms/InstCombine/fcmp-special.ll
Transforms/InstCombine/fcmp.ll
Transforms/InstCombine/fdiv-cos-sin.ll
Transforms/InstCombine/fdiv-sin-cos.ll
Transforms/InstCombine/fdiv.ll
Transforms/InstCombine/ffs-1.ll
Transforms/InstCombine/fls.ll
Transforms/InstCombine/float-shrink-compare.ll
Transforms/InstCombine/fmul-exp.ll
Transforms/InstCombine/fmul-exp2.ll
Transforms/InstCombine/fmul-inseltpoison.ll
Transforms/InstCombine/fmul-pow.ll
Transforms/InstCombine/fma.ll
Transforms/InstCombine/fmul-sqrt.ll
Transforms/InstCombine/fmul.ll
Transforms/InstCombine/fneg.ll
Transforms/InstCombine/fold-calls.ll
Transforms/InstCombine/fold-bin-operand.ll
Transforms/InstCombine/fold-fops-into-selects.ll
Transforms/InstCombine/fold-inc-of-add-of-not-x-and-y-to-sub-x-from-y.ll
Transforms/InstCombine/fold-phi-load-metadata.ll
Transforms/InstCombine/fold-sub-of-not-to-inc-of-add.ll
Transforms/InstCombine/fold-vector-select.ll
Transforms/InstCombine/fold-vector-zero-inseltpoison.ll
Transforms/InstCombine/fold-vector-zero.ll
Transforms/InstCombine/fpcast.ll
Transforms/InstCombine/fpextend.ll
Transforms/InstCombine/fpextend_x86.ll
Transforms/InstCombine/fortify-folding.ll
Transforms/InstCombine/fptrunc.ll
Transforms/InstCombine/fprintf-1.ll
Transforms/InstCombine/fputs-1.ll
Transforms/InstCombine/freeze-phi.ll
Transforms/InstCombine/freeze.ll
Transforms/InstCombine/fputs-opt-size.ll
Transforms/InstCombine/fsub.ll
Transforms/InstCombine/fsh.ll
Transforms/InstCombine/fwrite-1.ll
Transforms/InstCombine/funnel.ll
Transforms/InstCombine/gc.relocate.ll
Transforms/InstCombine/gep-addrspace.ll
Transforms/InstCombine/gep-combine-loop-invariant.ll
Transforms/InstCombine/gep-inbounds-null.ll
Transforms/InstCombine/gep-custom-dl.ll
Transforms/InstCombine/gep-sext.ll
Transforms/InstCombine/gep-vector.ll
Transforms/InstCombine/gepphigep.ll
Transforms/InstCombine/high-bit-signmask-with-trunc.ll
Transforms/InstCombine/high-bit-signmask.ll
Transforms/InstCombine/hoist-negation-out-of-bias-calculation-with-constant.ll
Transforms/InstCombine/hoist-negation-out-of-bias-calculation.ll
Transforms/InstCombine/hoist-xor-by-constant-from-xor-by-value.ll
Transforms/InstCombine/getelementptr.ll
Transforms/InstCombine/hoist_instr.ll
Transforms/InstCombine/icmp-add.ll
Transforms/InstCombine/icmp-bc-vec-inseltpoison.ll
Transforms/InstCombine/icmp-bitcast-glob.ll
Transforms/InstCombine/icmp-bc-vec.ll
Transforms/InstCombine/icmp-constant-phi.ll
Transforms/InstCombine/icmp-custom-dl.ll
Transforms/InstCombine/icmp-div-constant.ll
Transforms/InstCombine/icmp-dom.ll
Transforms/InstCombine/icmp-mul-zext.ll
Transforms/InstCombine/icmp-logical.ll
Transforms/InstCombine/icmp-mul.ll
Transforms/InstCombine/icmp-or.ll
Transforms/InstCombine/icmp-range.ll
Transforms/InstCombine/icmp-shl-nsw.ll
Transforms/InstCombine/icmp-shl-nuw.ll
Transforms/InstCombine/icmp-shr.ll
Transforms/InstCombine/icmp-sub.ll
Transforms/InstCombine/icmp-shr-lt-gt.ll
Transforms/InstCombine/icmp-uge-of-add-of-shl-one-by-bits-to-allones-and-val-to-icmp-eq-of-lshr-val-by-bits-and-0.ll
Transforms/InstCombine/icmp-uge-of-not-of-shl-allones-by-bits-and-val-to-icmp-eq-of-lshr-val-by-bits-and-0.ll
Transforms/InstCombine/icmp-ugt-of-shl-1-by-bits-and-val-to-icmp-eq-of-lshr-val-by-bits-and-0.ll
Transforms/InstCombine/icmp-ule-of-shl-1-by-bits-and-val-to-icmp-ne-of-lshr-val-by-bits-and-0.ll
Transforms/InstCombine/icmp-ult-of-add-of-shl-one-by-bits-to-allones-and-val-to-icmp-ne-of-lshr-val-by-bits-and-0.ll
Transforms/InstCombine/icmp-ult-of-not-of-shl-allones-by-bits-and-val-to-icmp-ne-of-lshr-val-by-bits-and-0.ll
Transforms/InstCombine/icmp-vec-inseltpoison.ll
Transforms/InstCombine/icmp-vec.ll
Transforms/InstCombine/icmp-xor-signbit.ll
Transforms/InstCombine/icmp_sdiv_with_and_without_range.ll
Transforms/InstCombine/idioms.ll
Transforms/InstCombine/indexed-gep-compares.ll
Transforms/InstCombine/icmp.ll
Transforms/InstCombine/inline-intrinsic-assert.ll
Transforms/InstCombine/inselt-binop-inseltpoison.ll
Transforms/InstCombine/inselt-binop.ll
Transforms/InstCombine/insert-const-shuf.ll
Transforms/InstCombine/insert-extract-shuffle-inseltpoison.ll
Transforms/InstCombine/insert-val-extract-elem.ll
Transforms/InstCombine/insertelement-bitcast.ll
Transforms/InstCombine/insert-extract-shuffle.ll
Transforms/InstCombine/int_sideeffect.ll
Transforms/InstCombine/intersect-accessgroup.ll
Transforms/InstCombine/intptr1.ll
Transforms/InstCombine/intptr2.ll
Transforms/InstCombine/intptr3.ll
Transforms/InstCombine/intptr4.ll
Transforms/InstCombine/intptr5.ll
Transforms/InstCombine/intptr7.ll
Transforms/InstCombine/invariant.group.ll
Transforms/InstCombine/intrinsics.ll
Transforms/InstCombine/invert-variable-mask-in-masked-merge-scalar.ll
Transforms/InstCombine/invert-variable-mask-in-masked-merge-vector.ll
Transforms/InstCombine/invoke.ll
Transforms/InstCombine/isascii-1.ll
Transforms/InstCombine/isdigit-1.ll
Transforms/InstCombine/known-bits.ll
Transforms/InstCombine/ispow2.ll
Transforms/InstCombine/known-never-nan.ll
Transforms/InstCombine/known-signbit-shift.ll
Transforms/InstCombine/known-non-zero.ll
Transforms/InstCombine/lifetime-no-null-opt.ll
Transforms/InstCombine/lifetime.ll
Transforms/InstCombine/load-bitcast-select.ll
Transforms/InstCombine/load-bitcast-vec.ll
Transforms/InstCombine/load-bitcast32.ll
Transforms/InstCombine/load-bitcast64.ll
Transforms/InstCombine/load-cmp.ll
Transforms/InstCombine/load-combine-metadata-dominance.ll
Transforms/InstCombine/load-combine-metadata.ll
Transforms/InstCombine/load-select.ll
Transforms/InstCombine/load-insert-store.ll
Transforms/InstCombine/load3.ll
Transforms/InstCombine/load.ll
Transforms/InstCombine/load_combine_aa.ll
Transforms/InstCombine/loadstore-alignment.ll
Transforms/InstCombine/loadstore-metadata.ll
Transforms/InstCombine/log-pow.ll
Transforms/InstCombine/logical-select-inseltpoison.ll
Transforms/InstCombine/logical-select.ll
Transforms/InstCombine/lower-dbg-declare.ll
Transforms/InstCombine/lshr-and-negC-icmpeq-zero.ll
Transforms/InstCombine/lshr-phi.ll
Transforms/InstCombine/lshr-and-signbit-icmpeq-zero.ll
Transforms/InstCombine/lshr.ll
Transforms/InstCombine/malloc-free-delete.ll
Transforms/InstCombine/masked-merge-add.ll
Transforms/InstCombine/masked-merge-and-of-ors.ll
Transforms/InstCombine/masked-merge-or.ll
Transforms/InstCombine/masked-merge-xor.ll
Transforms/InstCombine/masked_intrinsics-inseltpoison.ll
Transforms/InstCombine/masked_intrinsics.ll
Transforms/InstCombine/max_known_bits.ll
Transforms/InstCombine/max-of-nots.ll
Transforms/InstCombine/maximum.ll
Transforms/InstCombine/maxnum.ll
Transforms/InstCombine/mem-deref-bytes-addrspaces.ll
Transforms/InstCombine/mem-gep-zidx.ll
Transforms/InstCombine/mem-deref-bytes.ll
Transforms/InstCombine/mem-par-metadata-memcpy.ll
Transforms/InstCombine/memchr.ll
Transforms/InstCombine/memccpy.ll
Transforms/InstCombine/memcmp-1.ll
Transforms/InstCombine/memcmp-constant-fold.ll
Transforms/InstCombine/memcpy-1.ll
Transforms/InstCombine/memcpy-addrspace.ll
Transforms/InstCombine/memcpy-to-load.ll
Transforms/InstCombine/memcpy.ll
Transforms/InstCombine/memcpy_chk-1.ll
Transforms/InstCombine/memcpy-from-global.ll
Transforms/InstCombine/memcpy_chk-2.ll
Transforms/InstCombine/memmove-1.ll
Transforms/InstCombine/memmove.ll
Transforms/InstCombine/memmove_chk-1.ll
Transforms/InstCombine/memmove_chk-2.ll
Transforms/InstCombine/mempcpy.ll
Transforms/InstCombine/memset-1.ll
Transforms/InstCombine/memset.ll
Transforms/InstCombine/memset2.ll
Transforms/InstCombine/memset_chk-2.ll
Transforms/InstCombine/memset_chk-1.ll
Transforms/InstCombine/merge-icmp.ll
Transforms/InstCombine/merging-multiple-stores-into-successor.ll
Transforms/InstCombine/min-positive.ll
Transforms/InstCombine/minmax-demandbits.ll
Transforms/InstCombine/minimum.ll
Transforms/InstCombine/minmax-fp.ll
Transforms/InstCombine/minmax-fold.ll
Transforms/InstCombine/minmax-intrinsics.ll
Transforms/InstCombine/minmax-of-minmax.ll
Transforms/InstCombine/misc-2002.ll
Transforms/InstCombine/minnum.ll
Transforms/InstCombine/mul-masked-bits.ll
Transforms/InstCombine/mul-inseltpoison.ll
Transforms/InstCombine/multi-size-address-space-pointer.ll
Transforms/InstCombine/mul.ll
Transforms/InstCombine/multi-use-or.ll
Transforms/InstCombine/multiple-uses-load-bitcast-select.ll
Transforms/InstCombine/narrow-math.ll
Transforms/InstCombine/narrow-switch.ll
Transforms/InstCombine/narrow.ll
Transforms/InstCombine/no_cgscc_assert.ll
Transforms/InstCombine/noalias-scope-decl.ll
Transforms/InstCombine/non-integral-pointers.ll
Transforms/InstCombine/nonnull-attribute.ll
Transforms/InstCombine/not-add.ll
Transforms/InstCombine/nothrow.ll
Transforms/InstCombine/not.ll
Transforms/InstCombine/nsw-inseltpoison.ll
Transforms/InstCombine/nsw.ll
Transforms/InstCombine/obfuscated_splat-inseltpoison.ll
Transforms/InstCombine/obfuscated_splat.ll
Transforms/InstCombine/objsize-64.ll
Transforms/InstCombine/objsize-address-space.ll
Transforms/InstCombine/objsize-noverify.ll
Transforms/InstCombine/odr-linkage.ll
Transforms/InstCombine/omit-urem-of-power-of-two-or-zero-when-comparing-with-zero.ll
Transforms/InstCombine/objsize.ll
Transforms/InstCombine/onehot_merge.ll
Transforms/InstCombine/operand-complexity.ll
Transforms/InstCombine/or-concat.ll
Transforms/InstCombine/or-shifted-masks.ll
Transforms/InstCombine/or-xor.ll
Transforms/InstCombine/or-fcmp.ll
Transforms/InstCombine/osx-names.ll
Transforms/InstCombine/out-of-bounds-indexes.ll
Transforms/InstCombine/or.ll
Transforms/InstCombine/overflow-mul.ll
Transforms/InstCombine/overflow.ll
Transforms/InstCombine/partally-redundant-left-shift-input-masking-after-truncation-variant-a.ll
Transforms/InstCombine/overflow_to_sat.ll
Transforms/InstCombine/partally-redundant-left-shift-input-masking-after-truncation-variant-b.ll
Transforms/InstCombine/partally-redundant-left-shift-input-masking-after-truncation-variant-c.ll
Transforms/InstCombine/partally-redundant-left-shift-input-masking-after-truncation-variant-d.ll
Transforms/InstCombine/partally-redundant-left-shift-input-masking-after-truncation-variant-e.ll
Transforms/InstCombine/partally-redundant-left-shift-input-masking-variant-a.ll
Transforms/InstCombine/partally-redundant-left-shift-input-masking-variant-b.ll
Transforms/InstCombine/partally-redundant-left-shift-input-masking-variant-c.ll
Transforms/InstCombine/partally-redundant-left-shift-input-masking-variant-d.ll
Transforms/InstCombine/partally-redundant-left-shift-input-masking-variant-e.ll
Transforms/InstCombine/phi-aware-aggregate-reconstruction.ll
Transforms/InstCombine/phi-cse.ll
Transforms/InstCombine/phi-equal-incoming-pointers.ll
Transforms/InstCombine/phi-known-bits-operand-order.ll
Transforms/InstCombine/phi-load-metadata-3.ll
Transforms/InstCombine/phi-load-metadata-2.ll
Transforms/InstCombine/phi-load-metadata.ll
Transforms/InstCombine/phi-merge-gep.ll
Transforms/InstCombine/phi-of-extractvalues.ll
Transforms/InstCombine/phi-preserve-ir-flags.ll
Transforms/InstCombine/phi-of-insertvalues.ll
Transforms/InstCombine/phi-shifts.ll
Transforms/InstCombine/phi-select-constant.ll
Transforms/InstCombine/phi-timeout.ll
Transforms/InstCombine/phi.ll
Transforms/InstCombine/pow-0.ll
Transforms/InstCombine/pow-3.ll
Transforms/InstCombine/pow-1.ll
Transforms/InstCombine/pow-4.ll
Transforms/InstCombine/pow-exp.ll
Transforms/InstCombine/pow-sqrt.ll
Transforms/InstCombine/pr12251.ll
Transforms/InstCombine/pow_fp_int.ll
Transforms/InstCombine/pr14365.ll
Transforms/InstCombine/pr17827.ll
Transforms/InstCombine/pr19420.ll
Transforms/InstCombine/pr20678.ll
Transforms/InstCombine/pr21199.ll
Transforms/InstCombine/pr21651.ll
Transforms/InstCombine/pr24605.ll
Transforms/InstCombine/pr25342.ll
Transforms/InstCombine/pr2645-0-inseltpoison.ll
Transforms/InstCombine/pr2645-0.ll
Transforms/InstCombine/pr26992.ll
Transforms/InstCombine/pr27236.ll
Transforms/InstCombine/pr27332.ll
Transforms/InstCombine/pr27343.ll
Transforms/InstCombine/pr27996.ll
Transforms/InstCombine/pr28725.ll
Transforms/InstCombine/pr31990_wrong_memcpy.ll
Transforms/InstCombine/pr32686.ll
Transforms/InstCombine/pr33689_same_bitwidth.ll
Transforms/InstCombine/pr33453.ll
Transforms/InstCombine/pr34349.ll
Transforms/InstCombine/pr34627.ll
Transforms/InstCombine/pr38677.ll
Transforms/InstCombine/pr38897.ll
Transforms/InstCombine/pr38915.ll
Transforms/InstCombine/pr38984-inseltpoison.ll
Transforms/InstCombine/pr38984.ll
Transforms/InstCombine/pr39177.ll
Transforms/InstCombine/pr41164.ll
Transforms/InstCombine/pr39908.ll
Transforms/InstCombine/pr43376-getFlippedStrictnessPredicateAndConstant-assert.ll
Transforms/InstCombine/pr44242.ll
Transforms/InstCombine/pr43893.ll
Transforms/InstCombine/pr44541.ll
Transforms/InstCombine/pr44245.ll
Transforms/InstCombine/pr44552.ll
Transforms/InstCombine/pr44835.ll
Transforms/InstCombine/pr46680.ll
Transforms/InstCombine/prefetch-load.ll
Transforms/InstCombine/prevent-cmp-merge.ll
Transforms/InstCombine/printf-2.ll
Transforms/InstCombine/printf-1.ll
Transforms/InstCombine/printf-3.ll
Transforms/InstCombine/ptr-int-cast.ll
Transforms/InstCombine/pull-binop-through-shift.ll
Transforms/InstCombine/pull-conditional-binop-through-shift.ll
Transforms/InstCombine/puts-1.ll
Transforms/InstCombine/range-check.ll
Transforms/InstCombine/realloc.ll
Transforms/InstCombine/reassociate-nuw.ll
Transforms/InstCombine/redundant-left-shift-input-masking-after-truncation-variant-a.ll
Transforms/InstCombine/redundant-left-shift-input-masking-after-truncation-variant-b.ll
Transforms/InstCombine/redundant-left-shift-input-masking-after-truncation-variant-c.ll
Transforms/InstCombine/redundant-left-shift-input-masking-after-truncation-variant-d.ll
Transforms/InstCombine/redundant-left-shift-input-masking-after-truncation-variant-e.ll
Transforms/InstCombine/redundant-left-shift-input-masking-after-truncation-variant-f.ll
Transforms/InstCombine/redundant-left-shift-input-masking-variant-a.ll
Transforms/InstCombine/redundant-left-shift-input-masking-variant-b.ll
Transforms/InstCombine/redundant-left-shift-input-masking-variant-c.ll
Transforms/InstCombine/redundant-left-shift-input-masking-variant-d.ll
Transforms/InstCombine/redundant-left-shift-input-masking-variant-e.ll
Transforms/InstCombine/redundant-left-shift-input-masking-variant-f.ll
Transforms/InstCombine/rem.ll
Transforms/InstCombine/result-of-add-of-negative-is-non-zero-and-no-underflow.ll
Transforms/InstCombine/result-of-add-of-negative-or-zero-is-non-zero-and-no-underflow.ll
Transforms/InstCombine/result-of-usub-is-non-zero-and-no-overflow.ll
Transforms/InstCombine/reuse-constant-from-select-in-icmp.ll
Transforms/InstCombine/sadd-with-overflow.ll
Transforms/InstCombine/rotate.ll
Transforms/InstCombine/salvage-dbg-declare.ll
Transforms/InstCombine/sadd_sat.ll
Transforms/InstCombine/scalarization-inseltpoison.ll
Transforms/InstCombine/scalarization.ll
Transforms/InstCombine/saturating-add-sub.ll
Transforms/InstCombine/sdiv-1.ll
Transforms/InstCombine/sdiv-canonicalize.ll
Transforms/InstCombine/sdiv-exact-by-negative-power-of-two.ll
Transforms/InstCombine/sdiv-exact-by-power-of-two.ll
Transforms/InstCombine/sdiv-guard.ll
Transforms/InstCombine/sdiv-of-non-negative-by-negative-power-of-two.ll
Transforms/InstCombine/select-2.ll
Transforms/InstCombine/select-and-or.ll
Transforms/InstCombine/select-bitext-bitwise-ops.ll
Transforms/InstCombine/select-binop-cmp.ll
Transforms/InstCombine/select-cmp-br.ll
Transforms/InstCombine/select-bitext.ll
Transforms/InstCombine/select-cmpxchg.ll
Transforms/InstCombine/select-crash-noverify.ll
Transforms/InstCombine/select-cmp-cttz-ctlz.ll
Transforms/InstCombine/select-crash.ll
Transforms/InstCombine/select-ctlz-to-cttz.ll
Transforms/InstCombine/select-extractelement-inseltpoison.ll
Transforms/InstCombine/select-extractelement.ll
Transforms/InstCombine/select-gep.ll
Transforms/InstCombine/select-imm-canon.ll
Transforms/InstCombine/select-icmp-and.ll
Transforms/InstCombine/select-load-call.ll
Transforms/InstCombine/select-obo-peo-ops.ll
Transforms/InstCombine/select-of-bittest.ll
Transforms/InstCombine/select-pr39595.ll
Transforms/InstCombine/select-safe-transforms.ll
Transforms/InstCombine/select-select.ll
Transforms/InstCombine/select-with-bitwise-ops.ll
Transforms/InstCombine/select_arithmetic.ll
Transforms/InstCombine/select.ll
Transforms/InstCombine/select_meta.ll
Transforms/InstCombine/set-lowbits-mask-canonicalize.ll
Transforms/InstCombine/set.ll
Transforms/InstCombine/setcc-strength-reduce.ll
Transforms/InstCombine/sext.ll
Transforms/InstCombine/shift-add-inseltpoison.ll
Transforms/InstCombine/shift-add.ll
Transforms/InstCombine/shift-amount-reassociation-in-bittest-with-truncation-lshr.ll
Transforms/InstCombine/shift-amount-reassociation-in-bittest-with-truncation-shl.ll
Transforms/InstCombine/shift-amount-reassociation-with-truncation-ashr.ll
Transforms/InstCombine/shift-amount-reassociation-in-bittest.ll
Transforms/InstCombine/shift-amount-reassociation-with-truncation-lshr.ll
Transforms/InstCombine/shift-amount-reassociation-with-truncation-shl.ll
Transforms/InstCombine/shift-by-signext.ll
Transforms/InstCombine/shift-amount-reassociation.ll
Transforms/InstCombine/shift-direction-in-bit-test.ll
Transforms/InstCombine/shift-logic.ll
Transforms/InstCombine/shift-shift.ll
Transforms/InstCombine/shift-sra.ll
Transforms/InstCombine/shl-and-negC-icmpeq-zero.ll
Transforms/InstCombine/shift.ll
Transforms/InstCombine/shl-and-signbit-icmpeq-zero.ll
Transforms/InstCombine/shl-factor.ll
Transforms/InstCombine/shl-sub.ll
Transforms/InstCombine/should-change-type.ll
Transforms/InstCombine/shl-unsigned-cmp-const.ll
Transforms/InstCombine/shuffle-cast-inseltpoison.ll
Transforms/InstCombine/shuffle-cast.ll
Transforms/InstCombine/shuffle-select-narrow-inseltpoison.ll
Transforms/InstCombine/shuffle-select-narrow.ll
Transforms/InstCombine/shuffle_select-inseltpoison.ll
Transforms/InstCombine/shuffle_select.ll
Transforms/InstCombine/shufflevec-bitcast-inseltpoison.ll
Transforms/InstCombine/shufflevec-bitcast.ll
Transforms/InstCombine/shufflevec-constant-inseltpoison.ll
Transforms/InstCombine/shufflevec-constant.ll
Transforms/InstCombine/shufflevector-div-rem-inseltpoison.ll
Transforms/InstCombine/shufflevector-div-rem.ll
Transforms/InstCombine/sign-bit-test-via-right-shifting-all-other-bits.ll
Transforms/InstCombine/sign-test-and-or.ll
Transforms/InstCombine/signbit-lshr-and-icmpeq-zero.ll
Transforms/InstCombine/signed-comparison.ll
Transforms/InstCombine/signed-truncation-check.ll
Transforms/InstCombine/signext.ll
Transforms/InstCombine/signmask-of-sext-vs-of-shl-of-zext.ll
Transforms/InstCombine/simple_phi_condition.ll
Transforms/InstCombine/simplify-libcalls-erased.ll
Transforms/InstCombine/simplify-libcalls.ll
Transforms/InstCombine/sincospi.ll
Transforms/InstCombine/sink-alloca.ll
Transforms/InstCombine/sink-not-into-another-hand-of-and.ll
Transforms/InstCombine/sink-not-into-another-hand-of-or.ll
Transforms/InstCombine/sink_instruction.ll
Transforms/InstCombine/sink_to_unreachable.ll
Transforms/InstCombine/sitofp.ll
Transforms/InstCombine/smax-icmp.ll
Transforms/InstCombine/smin-icmp.ll
Transforms/InstCombine/snprintf.ll
Transforms/InstCombine/sprintf-1.ll
Transforms/InstCombine/sprintf-void.ll
Transforms/InstCombine/sqrt-nofast.ll
Transforms/InstCombine/sqrt.ll
Transforms/InstCombine/srem-canonicalize.ll
Transforms/InstCombine/srem-simplify-bug.ll
Transforms/InstCombine/ssub-with-overflow.ll
Transforms/InstCombine/stacksave-debuginfo.ll
Transforms/InstCombine/stacksaverestore.ll
Transforms/InstCombine/statepoint-iter.ll
Transforms/InstCombine/statepoint.ll
Transforms/InstCombine/stdio-custom-dl.ll
Transforms/InstCombine/store-load-unaliased-gep.ll
Transforms/InstCombine/statepoint-cleanup.ll
Transforms/InstCombine/store.ll
Transforms/InstCombine/storemerge-dbg.ll
Transforms/InstCombine/stpcpy-1.ll
Transforms/InstCombine/stpcpy_chk-2.ll
Transforms/InstCombine/stpcpy_chk-1.ll
Transforms/InstCombine/str-int-2.ll
Transforms/InstCombine/strcat-1.ll
Transforms/InstCombine/str-int.ll
Transforms/InstCombine/strcat-2.ll
Transforms/InstCombine/strchr-1.ll
Transforms/InstCombine/strcmp-1.ll
Transforms/InstCombine/strcpy-1.ll
Transforms/InstCombine/strcpy_chk-1.ll
Transforms/InstCombine/strcpy_chk-2.ll
Transforms/InstCombine/strcmp-memcmp.ll
Transforms/InstCombine/strcpy_chk-64.ll
Transforms/InstCombine/strcspn-1.ll
Transforms/InstCombine/strcspn-2.ll
Transforms/InstCombine/strict-sub-underflow-check-to-comparison-of-sub-operands.ll
Transforms/InstCombine/strlen-2.ll
Transforms/InstCombine/strlen-1.ll
Transforms/InstCombine/strlen_chk.ll
Transforms/InstCombine/strncat-1.ll
Transforms/InstCombine/strncat-2.ll
Transforms/InstCombine/strncat-3.ll
Transforms/InstCombine/strncmp-1.ll
Transforms/InstCombine/strncmp-2.ll
Transforms/InstCombine/strncpy-2.ll
Transforms/InstCombine/strncpy-1.ll
Transforms/InstCombine/strncpy-3.ll
Transforms/InstCombine/strncpy_chk-1.ll
Transforms/InstCombine/strncpy_chk-2.ll
Transforms/InstCombine/strndup.ll
Transforms/InstCombine/strpbrk-1.ll
Transforms/InstCombine/strpbrk-2.ll
Transforms/InstCombine/strrchr-1.ll
Transforms/InstCombine/strspn-1.ll
Transforms/InstCombine/strstr-1.ll
Transforms/InstCombine/strstr-2.ll
Transforms/InstCombine/strto-1.ll
Transforms/InstCombine/struct-assign-tbaa-new.ll
Transforms/InstCombine/struct-assign-tbaa.ll
Transforms/InstCombine/sub-and-or-neg-xor.ll
Transforms/InstCombine/sub-ashr-and-to-icmp-select.ll
Transforms/InstCombine/sub-ashr-or-to-icmp-select.ll
Transforms/InstCombine/sub-gep.ll
Transforms/InstCombine/sub-minmax.ll
Transforms/InstCombine/sub-not.ll
Transforms/InstCombine/sub-of-negatible-inseltpoison.ll
Transforms/InstCombine/sub-of-negatible.ll
Transforms/InstCombine/sub-or-and-xor.ll
Transforms/InstCombine/sub-xor-or-neg-and.ll
Transforms/InstCombine/sub-xor.ll
Transforms/InstCombine/subtract-from-one-hand-of-select.ll
Transforms/InstCombine/subtract-of-one-hand-of-select.ll
Transforms/InstCombine/sub.ll
Transforms/InstCombine/switch-constant-expr.ll
Transforms/InstCombine/tan.ll
Transforms/InstCombine/tbaa-store-to-load.ll
Transforms/InstCombine/toascii-1.ll
Transforms/InstCombine/trunc-binop-ext.ll
Transforms/InstCombine/trunc-extractelement-inseltpoison.ll
Transforms/InstCombine/trunc-extractelement.ll
Transforms/InstCombine/trunc-inseltpoison.ll
Transforms/InstCombine/trunc-shift-trunc.ll
Transforms/InstCombine/type_pun-inseltpoison.ll
Transforms/InstCombine/trunc.ll
Transforms/InstCombine/type_pun.ll
Transforms/InstCombine/uadd-with-overflow.ll
Transforms/InstCombine/uaddo.ll
Transforms/InstCombine/udiv-pow2-vscale-inseltpoison.ll
Transforms/InstCombine/udiv-pow2-vscale.ll
Transforms/InstCombine/udiv-simplify.ll
Transforms/InstCombine/udiv_select_to_select_shift.ll
Transforms/InstCombine/udivrem-change-width.ll
Transforms/InstCombine/umax-icmp.ll
Transforms/InstCombine/umin-icmp.ll
Transforms/InstCombine/umul-sign-check.ll
Transforms/InstCombine/unfold-masked-merge-with-const-mask-scalar.ll
Transforms/InstCombine/unfold-masked-merge-with-const-mask-vector.ll
Transforms/InstCombine/unavailable-debug.ll
Transforms/InstCombine/unordered-fcmp-select.ll
Transforms/InstCombine/unreachable-dbg-info-modified.ll
Transforms/InstCombine/unpack-fca.ll
Transforms/InstCombine/unsigned-add-lack-of-overflow-check-via-add.ll
Transforms/InstCombine/unrecognized_three-way-comparison.ll
Transforms/InstCombine/unsigned-add-lack-of-overflow-check.ll
Transforms/InstCombine/unsigned-add-overflow-check-via-add.ll
Transforms/InstCombine/unsigned-add-overflow-check.ll
Transforms/InstCombine/unsigned-mul-lack-of-overflow-check-via-mul-udiv.ll
Transforms/InstCombine/unsigned-mul-lack-of-overflow-check-via-udiv-of-allones.ll
Transforms/InstCombine/unsigned-mul-overflow-check-via-mul-udiv.ll
Transforms/InstCombine/unsigned-mul-overflow-check-via-udiv-of-allones.ll
Transforms/InstCombine/unsigned-sub-lack-of-overflow-check.ll
Transforms/InstCombine/unsigned-sub-overflow-check.ll
Transforms/InstCombine/unsigned_saturated_sub.ll
Transforms/InstCombine/unused-nonnull.ll
Transforms/InstCombine/urem-simplify-bug.ll
Transforms/InstCombine/vararg.ll
Transforms/InstCombine/usub-overflow-known-by-implied-cond.ll
Transforms/InstCombine/variable-signext-of-variable-high-bit-extraction.ll
Transforms/InstCombine/vec-binop-select-inseltpoison.ll
Transforms/InstCombine/vec-binop-select.ll
Transforms/InstCombine/vec_demanded_elts-inseltpoison.ll
Transforms/InstCombine/vec_extract_2elts.ll
Transforms/InstCombine/vec_demanded_elts.ll
Transforms/InstCombine/vec_extract_var_elt-inseltpoison.ll
Transforms/InstCombine/vec_extract_var_elt.ll
Transforms/InstCombine/vec_gep_scalar_arg-inseltpoison.ll
Transforms/InstCombine/vec_gep_scalar_arg.ll
Transforms/InstCombine/vec_phi_extract-inseltpoison.ll
Transforms/InstCombine/vec_phi_extract.ll
Transforms/InstCombine/vec_sext.ll
Transforms/InstCombine/vec_shuffle-inseltpoison.ll
Transforms/InstCombine/vec_shuffle.ll
Transforms/InstCombine/vec_udiv_to_shift.ll
Transforms/InstCombine/vector-casts-inseltpoison.ll
Transforms/InstCombine/vector-casts.ll
Transforms/InstCombine/vector-concat-binop-inseltpoison.ll
Transforms/InstCombine/vector-concat-binop.ll
Transforms/InstCombine/vector-mul.ll
Transforms/InstCombine/vector-reductions.ll
Transforms/InstCombine/vector-udiv.ll
Transforms/InstCombine/vector-urem.ll
Transforms/InstCombine/vector_gep1-inseltpoison.ll
Transforms/InstCombine/vector-xor.ll
Transforms/InstCombine/vector_gep2.ll
Transforms/InstCombine/vector_gep1.ll
Transforms/InstCombine/vector_insertelt_shuffle-inseltpoison.ll
Transforms/InstCombine/vector_insertelt_shuffle.ll
Transforms/InstCombine/vscale_alloca.ll
Transforms/InstCombine/vscale_cmp.ll
Transforms/InstCombine/vscale_extractelement-inseltpoison.ll
Transforms/InstCombine/vscale_extractelement.ll
Transforms/InstCombine/vscale_gep.ll
Transforms/InstCombine/vscale_insertelement-inseltpoison.ll
Transforms/InstCombine/vscale_insertelement.ll
Transforms/InstCombine/wcslen-1.ll
Transforms/InstCombine/wcslen-2.ll
Transforms/InstCombine/wcslen-3.ll
Transforms/InstCombine/wcslen-4.ll
Transforms/InstCombine/weak-symbols.ll
Transforms/InstCombine/widenable-conditions.ll
Transforms/InstCombine/win-math.ll
Transforms/InstCombine/xor-icmps.ll
Transforms/InstCombine/xor-of-icmps-with-extra-uses.ll
Transforms/InstCombine/with_overflow.ll
Transforms/InstCombine/xor-undef.ll
Transforms/InstCombine/xor2.ll
Transforms/InstCombine/xor.ll
Transforms/InstCombine/zero-point-zero-add.ll
Transforms/InstCombine/zeroext-and-reduce.ll
Transforms/InstCombine/zext-fold.ll
Transforms/InstCombine/zext-bool-add-sub.ll
Transforms/InstCombine/zext-or-icmp.ll
Transforms/InstCombine/zext-phi.ll
Transforms/InstCombine/zext.ll
Transforms/InstSimplify/2010-12-20-Boolean.ll
Transforms/InstSimplify/2011-02-01-Vector.ll
Transforms/InstSimplify/2011-01-14-Thread.ll
Transforms/InstSimplify/2011-09-05-InsertExtractValue.ll
Transforms/InstSimplify/AndOrXor.ll
Transforms/InstSimplify/ConstProp/2006-12-01-TruncBoolBug.ll
Transforms/InstSimplify/ConstProp/AMDGPU/cubeid.ll
Transforms/InstSimplify/ConstProp/AMDGPU/cos.ll
Transforms/InstSimplify/ConstProp/AMDGPU/cubema.ll
Transforms/InstSimplify/ConstProp/AMDGPU/cubesc.ll
Transforms/InstSimplify/ConstProp/AMDGPU/cubetc.ll
Transforms/InstSimplify/ConstProp/AMDGPU/fma_legacy.ll
Transforms/InstSimplify/ConstProp/AMDGPU/fmul_legacy.ll
Transforms/InstSimplify/ConstProp/AMDGPU/fract.ll
Transforms/InstSimplify/ConstProp/AMDGPU/sin.ll
Transforms/InstSimplify/ConstProp/WebAssembly/trunc.ll
Transforms/InstSimplify/ConstProp/WebAssembly/trunc_saturate.ll
Transforms/InstSimplify/ConstProp/abs.ll
Transforms/InstSimplify/ConstProp/active-lane-mask.ll
Transforms/InstSimplify/ConstProp/avx512.ll
Transforms/InstSimplify/ConstProp/bswap.ll
Transforms/InstSimplify/ConstProp/bitcount.ll
Transforms/InstSimplify/ConstProp/calls.ll
Transforms/InstSimplify/ConstProp/calls-math-finite.ll
Transforms/InstSimplify/ConstProp/cast-vector.ll
Transforms/InstSimplify/ConstProp/convert-from-fp16.ll
Transforms/InstSimplify/ConstProp/copysign.ll
Transforms/InstSimplify/ConstProp/div-zero.ll
Transforms/InstSimplify/ConstProp/fma.ll
Transforms/InstSimplify/ConstProp/freeze.ll
Transforms/InstSimplify/ConstProp/fp-undef.ll
Transforms/InstSimplify/ConstProp/funnel-shift.ll
Transforms/InstSimplify/ConstProp/gep-zeroinit-vector.ll
Transforms/InstSimplify/ConstProp/gep.ll
Transforms/InstSimplify/ConstProp/gep-constanfolding-error.ll
Transforms/InstSimplify/ConstProp/insertvalue.ll
Transforms/InstSimplify/ConstProp/loads.ll
Transforms/InstSimplify/ConstProp/math-1.ll
Transforms/InstSimplify/ConstProp/math-2.ll
Transforms/InstSimplify/ConstProp/overflow-ops.ll
Transforms/InstSimplify/ConstProp/min-max.ll
Transforms/InstSimplify/ConstProp/remtest.ll
Transforms/InstSimplify/ConstProp/poison.ll
Transforms/InstSimplify/ConstProp/rint.ll
Transforms/InstSimplify/ConstProp/round.ll
Transforms/InstSimplify/ConstProp/shift.ll
Transforms/InstSimplify/ConstProp/saturating-add-sub.ll
Transforms/InstSimplify/ConstProp/smul-fix-sat.ll
Transforms/InstSimplify/ConstProp/smul-fix.ll
Transforms/InstSimplify/ConstProp/sse.ll
Transforms/InstSimplify/ConstProp/trunc.ll
Transforms/InstSimplify/ConstProp/vector-undef-elts-inseltpoison.ll
Transforms/InstSimplify/ConstProp/vecreduce.ll
Transforms/InstSimplify/ConstProp/vector-undef-elts.ll
Transforms/InstSimplify/ConstProp/vscale-getelementptr.ll
Transforms/InstSimplify/ConstProp/vectorgep-crash.ll
Transforms/InstSimplify/ConstProp/vscale-inseltpoison.ll
Transforms/InstSimplify/ConstProp/vscale-shufflevector-inseltpoison.ll
Transforms/InstSimplify/ConstProp/vscale-shufflevector.ll
Transforms/InstSimplify/ConstProp/vscale.ll
Transforms/InstSimplify/abs_intrinsic.ll
Transforms/InstSimplify/add-mask.ll
Transforms/InstSimplify/add.ll
Transforms/InstSimplify/addsub.ll
Transforms/InstSimplify/and-icmps-same-ops.ll
Transforms/InstSimplify/and-or-icmp-min-max.ll
Transforms/InstSimplify/and-or-icmp-nullptr.ll
Transforms/InstSimplify/and-or-icmp-zero.ll
Transforms/InstSimplify/and.ll
Transforms/InstSimplify/assume-non-zero.ll
Transforms/InstSimplify/assume_icmp.ll
Transforms/InstSimplify/bitreverse-fold.ll
Transforms/InstSimplify/bitreverse.ll
Transforms/InstSimplify/bswap.ll
Transforms/InstSimplify/cast-unsigned-icmp-cmp-0.ll
Transforms/InstSimplify/cast.ll
Transforms/InstSimplify/call.ll
Transforms/InstSimplify/cmp_ext.ll
Transforms/InstSimplify/cmp_of_min_max.ll
Transforms/InstSimplify/constantfold-add-nuw-allones-to-allones.ll
Transforms/InstSimplify/constantfold-shl-nuw-C-to-C.ll
Transforms/InstSimplify/compare.ll
Transforms/InstSimplify/constfold-constrained.ll
Transforms/InstSimplify/distribute.ll
Transforms/InstSimplify/div-by-0-guard-before-smul_ov-not.ll
Transforms/InstSimplify/div-by-0-guard-before-smul_ov.ll
Transforms/InstSimplify/div-by-0-guard-before-umul_ov-not.ll
Transforms/InstSimplify/div-by-0-guard-before-umul_ov.ll
Transforms/InstSimplify/div.ll
Transforms/InstSimplify/exact-nsw-nuw.ll
Transforms/InstSimplify/extract-element.ll
Transforms/InstSimplify/fast-math.ll
Transforms/InstSimplify/fcmp-select.ll
Transforms/InstSimplify/fcmp.ll
Transforms/InstSimplify/fdiv.ll
Transforms/InstSimplify/floating-point-arithmetic.ll
Transforms/InstSimplify/floating-point-compare.ll
Transforms/InstSimplify/fold-intrinsics.ll
Transforms/InstSimplify/fp-nan.ll
Transforms/InstSimplify/fminmax-folds.ll
Transforms/InstSimplify/fp-undef-poison.ll
Transforms/InstSimplify/freeze-noundef.ll
Transforms/InstSimplify/fptoi-sat.ll
Transforms/InstSimplify/freeze.ll
Transforms/InstSimplify/gep.ll
Transforms/InstSimplify/icmp-abs-nabs.ll
Transforms/InstSimplify/icmp-bool-constant.ll
Transforms/InstSimplify/icmp-constant.ll
Transforms/InstSimplify/icmp.ll
Transforms/InstSimplify/icmp-ranges.ll
Transforms/InstSimplify/implies.ll
Transforms/InstSimplify/insertvalue.ll
Transforms/InstSimplify/insertelement.ll
Transforms/InstSimplify/known-never-nan.ll
Transforms/InstSimplify/known-non-zero.ll
Transforms/InstSimplify/load-relative-32.ll
Transforms/InstSimplify/load-relative.ll
Transforms/InstSimplify/log-exp-intrinsic.ll
Transforms/InstSimplify/log10-pow10-intrinsic.ll
Transforms/InstSimplify/log2-pow2-intrinsic.ll
Transforms/InstSimplify/logic-of-fcmps.ll
Transforms/InstSimplify/maxmin.ll
Transforms/InstSimplify/mul.ll
Transforms/InstSimplify/negate.ll
Transforms/InstSimplify/maxmin_intrinsics.ll
Transforms/InstSimplify/noalias-ptr.ll
Transforms/InstSimplify/null-ptr-is-valid-attribute.ll
Transforms/InstSimplify/null-ptr-is-valid.ll
Transforms/InstSimplify/or-icmps-same-ops.ll
Transforms/InstSimplify/or.ll
Transforms/InstSimplify/past-the-end.ll
Transforms/InstSimplify/pr33957.ll
Transforms/InstSimplify/ptr_diff.ll
Transforms/InstSimplify/reassociate.ll
Transforms/InstSimplify/redundant-null-check-in-uadd_with_overflow-of-nonnull-ptr.ll
Transforms/InstSimplify/rem.ll
Transforms/InstSimplify/result-of-usub-by-nonzero-is-non-zero-and-no-overflow.ll
Transforms/InstSimplify/result-of-usub-is-non-zero-and-no-overflow.ll
Transforms/InstSimplify/returned.ll
Transforms/InstSimplify/round-intrinsics.ll
Transforms/InstSimplify/saturating-add-sub.ll
Transforms/InstSimplify/sdiv.ll
Transforms/InstSimplify/select-and-cmp.ll
Transforms/InstSimplify/select-implied.ll
Transforms/InstSimplify/select-or-cmp.ll
Transforms/InstSimplify/select-inseltpoison.ll
Transforms/InstSimplify/select.ll
Transforms/InstSimplify/shift-knownbits.ll
Transforms/InstSimplify/shift.ll
Transforms/InstSimplify/shr-scalar-vector-consistency.ll
Transforms/InstSimplify/shr-nop.ll
Transforms/InstSimplify/shufflevector-inseltpoison.ll
Transforms/InstSimplify/shufflevector.ll
Transforms/InstSimplify/signed-div-rem.ll
Transforms/InstSimplify/srem.ll
Transforms/InstSimplify/sub.ll
Transforms/InstSimplify/undef.ll
Transforms/InstSimplify/vec-cmp.ll
Transforms/InstSimplify/vector_gep.ll
Transforms/InstSimplify/vscale-inseltpoison.ll
Transforms/InstSimplify/simplify-nested-bitcast.ll
Transforms/InstSimplify/xor.ll
Transforms/InstSimplify/vscale.ll
Transforms/JumpThreading/and-and-cond.ll
Transforms/JumpThreading/and-cond.ll
Transforms/JumpThreading/basic.ll
Transforms/JumpThreading/branch-no-const.ll
Transforms/JumpThreading/lvi-tristate.ll
Transforms/JumpThreading/no-irreducible-loops.ll
Transforms/JumpThreading/phi-known.ll
Transforms/LICM/2003-02-27-PreheaderProblem.ll
Transforms/LICM/hoist-mustexec.ll
Transforms/LoopDeletion/dcetest.ll
Transforms/LoopDeletion/simplify-then-delete.ll
Transforms/LoopInstSimplify/basic.ll
Transforms/LoopRotate/multiple-deopt-exits.ll
Transforms/LoopSimplify/do-preheader-dbg-inseltpoison.ll
Transforms/LoopSimplify/do-preheader-dbg.ll
Transforms/LoopSimplify/for-preheader-dbg.ll
Transforms/LoopUnroll/2011-10-01-NoopTrunc.ll
Transforms/LoopUnroll/AMDGPU/unroll-analyze-small-loops.ll
Transforms/LoopUnroll/complete_unroll_profitability_with_assume.ll
Transforms/LoopUnroll/debug-info.ll
Transforms/LoopUnroll/full-unroll-heuristics-cmp.ll
Transforms/LoopUnroll/full-unroll-heuristics-dce.ll
Transforms/LoopUnroll/full-unroll-heuristics.ll
Transforms/LoopUnroll/noalias.ll
Transforms/LoopUnroll/opt-levels.ll
Transforms/LoopUnroll/peel-loop-inner.ll
Transforms/LoopUnroll/peel-loop-noalias-scope-decl.ll
Transforms/LoopUnroll/peel-loop.ll
Transforms/LoopUnroll/pr45939-peel-count-and-complete-unroll.ll
Transforms/LoopUnroll/runtime-loop-multiple-exits.ll
Transforms/LoopUnroll/runtime-loop4.ll
Transforms/LoopUnroll/runtime-multiexit-heuristic.ll
Transforms/LoopUnroll/runtime-unroll-remainder.ll
Transforms/LoopUnroll/unroll-after-peel.ll
Transforms/LoopUnroll/unroll-cleanup.ll
Transforms/LoopUnroll/unroll-header-exiting-with-phis.ll
Transforms/LoopUnroll/unroll-opt-attribute.ll
Transforms/LoopUnroll/unroll-unconditional-latch.ll
Transforms/LoopUnroll/wrong_assert_in_peeling.ll
Transforms/LoopUnswitch/2015-06-17-Metadata.ll
Transforms/LoopUnswitch/AMDGPU/divergent-unswitch.ll
Transforms/LoopUnswitch/infinite-loop.ll
Transforms/LoopVectorize/AMDGPU/packed-math.ll
Transforms/LoopVectorize/X86/consecutive-ptr-uniforms.ll
Transforms/LoopVectorize/X86/float-induction-x86.ll
Transforms/LoopVectorize/X86/gather_scatter.ll
Transforms/LoopVectorize/X86/interleaving.ll
Transforms/LoopVectorize/X86/intrinsiccost.ll
Transforms/LoopVectorize/X86/invariant-load-gather.ll
Transforms/LoopVectorize/X86/invariant-store-vectorization.ll
Transforms/LoopVectorize/X86/metadata-enable.ll
Transforms/LoopVectorize/X86/pr23997.ll
Transforms/LoopVectorize/X86/pr42674.ll
Transforms/LoopVectorize/X86/small-size.ll
Transforms/LoopVectorize/X86/x86-interleaved-accesses-masked-group.ll
Transforms/LoopVectorize/consec_no_gep.ll
Transforms/LoopVectorize/consecutive-ptr-uniforms.ll
Transforms/LoopVectorize/first-order-recurrence.ll
Transforms/LoopVectorize/float-induction.ll
Transforms/LoopVectorize/gep_with_bitcast.ll
Transforms/LoopVectorize/if-conversion-nest.ll
Transforms/LoopVectorize/if-conversion.ll
Transforms/LoopVectorize/if-pred-stores.ll
Transforms/LoopVectorize/induction.ll
Transforms/LoopVectorize/interleaved-accesses-pred-stores.ll
Transforms/LoopVectorize/interleaved-accesses.ll
Transforms/LoopVectorize/invariant-store-vectorization.ll
Transforms/LoopVectorize/loop-scalars.ll
Transforms/LoopVectorize/phi-cost.ll
Transforms/LoopVectorize/reduction-inloop-uf4.ll
Transforms/LoopVectorize/reduction-inloop.ll
Transforms/LoopVectorize/reduction-inloop-pred.ll
Transforms/LoopVectorize/reduction-predselect.ll
Transforms/LoopVectorize/runtime-check-readonly.ll
Transforms/LoopVectorize/runtime-check.ll
Transforms/LoopVectorize/scalable-loop-unpredicated-body-scalar-tail.ll
Transforms/LoopVectorize/scalar_after_vectorization.ll
Transforms/LoopVectorize/store-shuffle-bug.ll
Transforms/LoopVectorize/tbaa-nodep.ll
Transforms/LoopVectorize/vector-geps.ll
Transforms/MemCpyOpt/lifetime.ll
Transforms/MemCpyOpt/memcpy-to-memset-with-lifetimes.ll
Transforms/MemCpyOpt/pr29105.ll
Transforms/NaryReassociate/NVPTX/nary-gep.ll
Transforms/NaryReassociate/NVPTX/nary-slsr.ll
Transforms/NaryReassociate/nary-add.ll
Transforms/NaryReassociate/nary-mul.ll
Transforms/NaryReassociate/pr24301.ll
Transforms/NaryReassociate/pr37539.ll
Transforms/NewGVN/2010-11-13-Simplify.ll
Transforms/NewGVN/addrspacecast.ll
Transforms/NewGVN/basic-cyclic-opt.ll
Transforms/NewGVN/basic.ll
Transforms/NewGVN/bitcast-of-call.ll
Transforms/NewGVN/calls-readonly.ll
Transforms/NewGVN/completeness.ll
Transforms/NewGVN/cond_br.ll
Transforms/NewGVN/condprop.ll
Transforms/NewGVN/edge.ll
Transforms/NewGVN/fold-const-expr.ll
Transforms/NewGVN/load-constant-mem.ll
Transforms/NewGVN/loadforward.ll
Transforms/NewGVN/pair_jumpthread.ll
Transforms/NewGVN/phi-of-ops-move-block.ll
Transforms/NewGVN/pr32836.ll
Transforms/NewGVN/pr33196.ll
Transforms/NewGVN/pr33461.ll
Transforms/NewGVN/pr33720.ll
Transforms/NewGVN/pr34452.ll
Transforms/NewGVN/pr35074.ll
Transforms/NewGVN/pr35125.ll
Transforms/NewGVN/refine-stores.ll
Transforms/NewGVN/simp-to-self.ll
Transforms/NewGVN/tbaa.ll
Transforms/NewGVN/todo-pr36335-phi-undef.ll
Transforms/OpenMP/parallel_deletion_cg_update.ll
Transforms/PGOProfile/chr.ll
Transforms/PGOProfile/cspgo_profile_summary.ll
Transforms/PhaseOrdering/X86/SROA-after-loop-unrolling.ll
Transforms/PhaseOrdering/X86/addsub-inseltpoison.ll
Transforms/PhaseOrdering/X86/addsub.ll
Transforms/PhaseOrdering/X86/horiz-math-inseltpoison.ll
Transforms/PhaseOrdering/X86/horiz-math.ll
Transforms/PhaseOrdering/X86/loop-idiom-vs-indvars.ll
Transforms/PhaseOrdering/X86/masked-memory-ops.ll
Transforms/PhaseOrdering/X86/peel-before-lv-to-enable-vectorization.ll
Transforms/PhaseOrdering/X86/pr48844-br-to-switch-vectorization.ll
Transforms/PhaseOrdering/X86/scalarization-inseltpoison.ll
Transforms/PhaseOrdering/X86/scalarization.ll
Transforms/PhaseOrdering/X86/shuffle-inseltpoison.ll
Transforms/PhaseOrdering/X86/shuffle.ll
Transforms/PhaseOrdering/X86/vdiv.ll
Transforms/PhaseOrdering/X86/vector-reductions-expanded.ll
Transforms/PhaseOrdering/X86/vector-reductions.ll
Transforms/PhaseOrdering/basic.ll
Transforms/PhaseOrdering/bitfield-bittests.ll
Transforms/PhaseOrdering/d83507-knowledge-retention-bug.ll
Transforms/PhaseOrdering/inlining-alignment-assumptions.ll
Transforms/PhaseOrdering/instcombine-sroa-inttoptr.ll
Transforms/PhaseOrdering/loop-rotation-vs-common-code-hoisting.ll
Transforms/PhaseOrdering/min-max-abs-cse.ll
Transforms/PhaseOrdering/minmax.ll
Transforms/PhaseOrdering/pr39282.ll
Transforms/PhaseOrdering/pr44461-br-to-switch-rotate.ll
Transforms/PhaseOrdering/rotate.ll
Transforms/PhaseOrdering/simplifycfg-options.ll
Transforms/PhaseOrdering/unsigned-multiply-overflow-check.ll
Transforms/PhaseOrdering/vector-trunc-inseltpoison.ll
Transforms/PhaseOrdering/vector-trunc.ll
Transforms/PruneEH/looptest.ll
Transforms/PruneEH/operand-bundles.ll
Transforms/PruneEH/recursivetest.ll
Transforms/PruneEH/pr26263.ll
Transforms/PruneEH/simplenoreturntest.ll
Transforms/PruneEH/simpletest.ll
Transforms/Reassociate/2002-05-15-AgressiveSubMove.ll
Transforms/Reassociate/2002-05-15-MissedTree.ll
Transforms/Reassociate/2002-05-15-SubReassociate.ll
Transforms/Reassociate/2005-09-01-ArrayOutOfBounds.ll
Transforms/Reassociate/2006-04-27-ReassociateVector.ll
Transforms/Reassociate/2019-08-22-FNegAssert.ll
Transforms/Reassociate/absorption.ll
Transforms/Reassociate/add-like-or.ll
Transforms/Reassociate/add_across_block_crash.ll
Transforms/Reassociate/binop-identity.ll
Transforms/Reassociate/basictest.ll
Transforms/Reassociate/commute.ll
Transforms/Reassociate/canonicalize-neg-const.ll
Transforms/Reassociate/crash2.ll
Transforms/Reassociate/cse-pairs.ll
Transforms/Reassociate/erase_inst_made_change.ll
Transforms/Reassociate/factorize-again.ll
Transforms/Reassociate/fast-AgressiveSubMove.ll
Transforms/Reassociate/fast-ArrayOutOfBounds.ll
Transforms/Reassociate/fast-MissedTree.ll
Transforms/Reassociate/fast-SubReassociate.ll
Transforms/Reassociate/fast-ReassociateVector.ll
Transforms/Reassociate/fast-basictest.ll
Transforms/Reassociate/fast-fp-commute.ll
Transforms/Reassociate/fast-multistep.ll
Transforms/Reassociate/fp-commute.ll
Transforms/Reassociate/fp-expr.ll
Transforms/Reassociate/infloop-deadphi.ll
Transforms/Reassociate/inverses.ll
Transforms/Reassociate/keep-debug-loc.ll
Transforms/Reassociate/load-combine-like-or.ll
Transforms/Reassociate/long-chains.ll
Transforms/Reassociate/looptest.ll
Transforms/Reassociate/matching-binops.ll
Transforms/Reassociate/mixed-fast-nonfast-fp.ll
Transforms/Reassociate/mulfactor.ll
Transforms/Reassociate/multistep.ll
Transforms/Reassociate/negation.ll
Transforms/Reassociate/negation1.ll
Transforms/Reassociate/no-op.ll
Transforms/Reassociate/optional-flags.ll
Transforms/Reassociate/otherops.ll
Transforms/Reassociate/pointer-collision-non-determinism.ll
Transforms/Reassociate/pr42349.ll
Transforms/Reassociate/propagate-flags.ll
Transforms/Reassociate/reassoc-intermediate-fnegs.ll
Transforms/Reassociate/reassociate-deadinst.ll
Transforms/Reassociate/reassociate_dbgvalue_discard.ll
Transforms/Reassociate/reassociate_salvages_debug_info.ll
Transforms/Reassociate/repeats.ll
Transforms/Reassociate/secondary.ll
Transforms/Reassociate/shift-factor.ll
Transforms/Reassociate/shifttest.ll
Transforms/Reassociate/subtest.ll
Transforms/Reassociate/vaarg_movable.ll
Transforms/Reassociate/undef_intrinsics_when_deleting_instructions.ll
Transforms/Reassociate/wrap-flags.ll
Transforms/Reassociate/xor_reassoc.ll
Transforms/SCCP/2003-06-24-OverdefinedPHIValue.ll
Transforms/SCCP/calltest.ll
Transforms/RewriteStatepointsForGC/unordered-atomic-memcpy.ll
Transforms/SCCP/float-nan-simplification.ll
Transforms/SCCP/vector-bitcast.ll
Transforms/SLPVectorizer/AMDGPU/add_sub_sat-inseltpoison.ll
Transforms/SLPVectorizer/AMDGPU/add_sub_sat.ll
Transforms/SLPVectorizer/WebAssembly/no-vectorize-rotate.ll
Transforms/SLPVectorizer/X86/alternate-cast-inseltpoison.ll
Transforms/SLPVectorizer/X86/alternate-cast.ll
Transforms/SLPVectorizer/X86/alternate-fp-inseltpoison.ll
Transforms/SLPVectorizer/X86/alternate-fp.ll
Transforms/SLPVectorizer/X86/alternate-int-inseltpoison.ll
Transforms/SLPVectorizer/X86/alternate-int.ll
Transforms/SLPVectorizer/X86/blending-shuffle-inseltpoison.ll
Transforms/SLPVectorizer/X86/blending-shuffle.ll
Transforms/SLPVectorizer/X86/cmp_commute-inseltpoison.ll
Transforms/SLPVectorizer/X86/cmp_commute.ll
Transforms/SLPVectorizer/X86/hadd-inseltpoison.ll
Transforms/SLPVectorizer/X86/hadd.ll
Transforms/SLPVectorizer/X86/hsub-inseltpoison.ll
Transforms/SLPVectorizer/X86/hsub.ll
Transforms/SLPVectorizer/X86/minimum-sizes.ll
Transforms/SLPVectorizer/X86/operandorder.ll
Transforms/SLPVectorizer/X86/pr46983.ll
Transforms/SLPVectorizer/X86/pr47629-inseltpoison.ll
Transforms/SLPVectorizer/X86/pr47629.ll
Transforms/SampleProfile/calls.ll
Transforms/SampleProfile/cov-zero-samples.ll
Transforms/SampleProfile/inline-combine.ll
Transforms/SampleProfile/inline-coverage.ll
Transforms/SampleProfile/pseudo-probe-instcombine.ll
Transforms/SimpleLoopUnswitch/LIV-loop-condtion.ll
Transforms/SimpleLoopUnswitch/basictest-profmd.ll
Transforms/SimpleLoopUnswitch/copy-metadata.ll
Transforms/SimpleLoopUnswitch/delete-dead-blocks.ll
Transforms/SimpleLoopUnswitch/exponential-nontrivial-unswitch-nested.ll
Transforms/SimpleLoopUnswitch/exponential-nontrivial-unswitch-nested2.ll
Transforms/SimpleLoopUnswitch/exponential-nontrivial-unswitch.ll
Transforms/SimpleLoopUnswitch/exponential-switch-unswitch.ll
Transforms/SimpleLoopUnswitch/guards.ll
Transforms/SimpleLoopUnswitch/implicit-null-checks.ll
Transforms/SimpleLoopUnswitch/infinite-loop.ll
Transforms/SimpleLoopUnswitch/msan.ll
Transforms/SimpleLoopUnswitch/nontrivial-unswitch-cost.ll
Transforms/SimpleLoopUnswitch/pipeline.ll
Transforms/SimpleLoopUnswitch/pr37888.ll
Transforms/SimpleLoopUnswitch/nontrivial-unswitch.ll
Transforms/SimpleLoopUnswitch/preserve-scev-exiting-multiple-loops.ll
Transforms/SimpleLoopUnswitch/trivial-unswitch-profmd.ll
Transforms/SimpleLoopUnswitch/trivial-unswitch-iteration.ll
Transforms/SimpleLoopUnswitch/update-scev.ll
Transforms/SimpleLoopUnswitch/trivial-unswitch.ll
Transforms/SimplifyCFG/2003-08-17-BranchFold.ll
Transforms/SimplifyCFG/2003-08-17-BranchFoldOrdering.ll
Transforms/SimplifyCFG/2003-08-17-FoldSwitch-dbg.ll
Transforms/SimplifyCFG/2003-08-17-FoldSwitch.ll
Transforms/SimplifyCFG/2007-11-22-InvokeNoUnwind.ll
Transforms/SimplifyCFG/2008-05-16-PHIBlockMerge.ll
Transforms/SimplifyCFG/2008-07-13-InfLoopMiscompile.ll
Transforms/SimplifyCFG/2008-12-16-DCECond.ll
Transforms/SimplifyCFG/2011-03-08-UnreachableUse.ll
Transforms/SimplifyCFG/2011-09-05-TrivialLPad.ll
Transforms/SimplifyCFG/BrUnwind.ll
Transforms/SimplifyCFG/AMDGPU/cttz-ctlz.ll
Transforms/SimplifyCFG/ConditionalTrappingConstantExpr.ll
Transforms/SimplifyCFG/DeadSetCC.ll
Transforms/SimplifyCFG/EqualPHIEdgeBlockMerge.ll
Transforms/SimplifyCFG/FoldValueComparisonIntoPredecessors-domtree-preservation-edgecase-2.ll
Transforms/SimplifyCFG/FoldValueComparisonIntoPredecessors-domtree-preservation-edgecase.ll
Transforms/SimplifyCFG/FoldValueComparisonIntoPredecessors-no-new-successors.ll
Transforms/SimplifyCFG/ForwardSwitchConditionToPHI.ll
Transforms/SimplifyCFG/HoistCode.ll
Transforms/SimplifyCFG/PHINode.ll
Transforms/SimplifyCFG/PR16069.ll
Transforms/SimplifyCFG/PR25267.ll
Transforms/SimplifyCFG/PR17073.ll
Transforms/SimplifyCFG/PR27615-simplify-cond-br.ll
Transforms/SimplifyCFG/PhiBlockMerge.ll
Transforms/SimplifyCFG/PhiBlockMerge2.ll
Transforms/SimplifyCFG/PhiEliminate.ll
Transforms/SimplifyCFG/PhiEliminate2.ll
Transforms/SimplifyCFG/PhiEliminate3.ll
Transforms/SimplifyCFG/SimplifyEqualityComparisonWithOnlyPredecessor-domtree-preservation-edgecase.ll
Transforms/SimplifyCFG/SimplifyTerminatorOnSelect-domtree-preservation-edgecase.ll
Transforms/SimplifyCFG/UncondBranchToHeader.ll
Transforms/SimplifyCFG/UncondBranchToReturn.ll
Transforms/SimplifyCFG/UnreachableEliminate.ll
Transforms/SimplifyCFG/X86/CoveredLookupTable.ll
Transforms/SimplifyCFG/X86/MagicPointer.ll
Transforms/SimplifyCFG/X86/PR29163.ll
Transforms/SimplifyCFG/X86/PR30210.ll
Transforms/SimplifyCFG/X86/SpeculativeExec.ll
Transforms/SimplifyCFG/X86/bug-25299.ll
Transforms/SimplifyCFG/X86/critedge-assume.ll
Transforms/SimplifyCFG/X86/disable-lookup-table.ll
Transforms/SimplifyCFG/X86/empty-cleanuppad.ll
Transforms/SimplifyCFG/X86/merge-cleanuppads.ll
Transforms/SimplifyCFG/X86/remove-debug-2.ll
Transforms/SimplifyCFG/X86/pr39187-g.ll
Transforms/SimplifyCFG/X86/safe-low-bit-extract.ll
Transforms/SimplifyCFG/X86/remove-debug.ll
Transforms/SimplifyCFG/X86/switch-covered-bug.ll
Transforms/SimplifyCFG/X86/speculate-cttz-ctlz.ll
Transforms/SimplifyCFG/X86/switch-table-bug.ll
Transforms/SimplifyCFG/annotations.ll
Transforms/SimplifyCFG/X86/switch_to_lookup_table.ll
Transforms/SimplifyCFG/assume.ll
Transforms/SimplifyCFG/basictest.ll
Transforms/SimplifyCFG/bbi-23595.ll
Transforms/SimplifyCFG/branch-cond-merge.ll
Transforms/SimplifyCFG/branch-cond-prop.ll
Transforms/SimplifyCFG/branch-fold-dbg.ll
Transforms/SimplifyCFG/branch-fold-test.ll
Transforms/SimplifyCFG/branch-fold.ll
Transforms/SimplifyCFG/branch-fold-threshold.ll
Transforms/SimplifyCFG/branch-phi-thread.ll
Transforms/SimplifyCFG/change-to-unreachable-matching-successor.ll
Transforms/SimplifyCFG/clamp.ll
Transforms/SimplifyCFG/common-code-hoisting.ll
Transforms/SimplifyCFG/common-dest-folding.ll
Transforms/SimplifyCFG/dbginfo.ll
Transforms/SimplifyCFG/dce-cond-after-folding-terminator.ll
Transforms/SimplifyCFG/debug-info-thread-phi.ll
Transforms/SimplifyCFG/drop-debug-loc-when-speculating.ll
Transforms/SimplifyCFG/duplicate-phis.ll
Transforms/SimplifyCFG/duplicate-landingpad.ll
Transforms/SimplifyCFG/duplicate-ret-into-uncond-br.ll
Transforms/SimplifyCFG/empty-catchpad.ll
Transforms/SimplifyCFG/extract-cost.ll
Transforms/SimplifyCFG/fold-branch-to-common-dest.ll
Transforms/SimplifyCFG/fold-debug-info.ll
Transforms/SimplifyCFG/fold-debug-location.ll
Transforms/SimplifyCFG/guards.ll
Transforms/SimplifyCFG/hoist-common-code.ll
Transforms/SimplifyCFG/hoist-dbgvalue-inlined.ll
Transforms/SimplifyCFG/hoist-with-range.ll
Transforms/SimplifyCFG/implied-and-or.ll
Transforms/SimplifyCFG/implied-cond-matching-false-dest.ll
Transforms/SimplifyCFG/implied-cond-matching-imm.ll
Transforms/SimplifyCFG/implied-cond-matching.ll
Transforms/SimplifyCFG/implied-cond.ll
Transforms/SimplifyCFG/indirectbr.ll
Transforms/SimplifyCFG/invoke.ll
Transforms/SimplifyCFG/invoke_unwind.ll
Transforms/SimplifyCFG/invoke_unwind_lifetime.ll
Transforms/SimplifyCFG/iterative-simplify.ll
Transforms/SimplifyCFG/lifetime-landingpad.ll
Transforms/SimplifyCFG/merge-cond-stores-2.ll
Transforms/SimplifyCFG/merge-cond-stores.ll
Transforms/SimplifyCFG/merge-default.ll
Transforms/SimplifyCFG/merge-duplicate-conditional-ret-val.ll
Transforms/SimplifyCFG/merge-empty-return-blocks.ll
Transforms/SimplifyCFG/multiple-phis.ll
Transforms/SimplifyCFG/no-md-sink.ll
Transforms/SimplifyCFG/no_speculative_loads_with_asan.ll
Transforms/SimplifyCFG/no_speculative_loads_with_tsan.ll
Transforms/SimplifyCFG/noreturn-call.ll
Transforms/SimplifyCFG/opt-for-fuzzing.ll
Transforms/SimplifyCFG/phi-to-select-constexpr-icmp.ll
Transforms/SimplifyCFG/phi-undef-loadstore.ll
Transforms/SimplifyCFG/poison-merge.ll
Transforms/SimplifyCFG/pr39807.ll
Transforms/SimplifyCFG/pr46638.ll
Transforms/SimplifyCFG/pr48778-sdiv-speculation.ll
Transforms/SimplifyCFG/preserve-branchweights-switch-create.ll
Transforms/SimplifyCFG/preserve-branchweights.ll
Transforms/SimplifyCFG/preserve-llvm-loop-metadata.ll
Transforms/SimplifyCFG/preserve-load-metadata-2.ll
Transforms/SimplifyCFG/preserve-load-metadata-3.ll
Transforms/SimplifyCFG/preserve-load-metadata.ll
Transforms/SimplifyCFG/preserve-make-implicit-on-switch-to-br.ll
Transforms/SimplifyCFG/rangereduce.ll
Transforms/SimplifyCFG/preserve-store-alignment.ll
Transforms/SimplifyCFG/return-merge.ll
Transforms/SimplifyCFG/safe-abs.ll
Transforms/SimplifyCFG/select-gep.ll
Transforms/SimplifyCFG/signbit-like-value-extension.ll
Transforms/SimplifyCFG/simplifyUnreachable-degenerate-conditional-branch-with-matching-destinations.ll
Transforms/SimplifyCFG/sink-common-code.ll
Transforms/SimplifyCFG/speculate-call.ll
Transforms/SimplifyCFG/speculate-dbgvalue.ll
Transforms/SimplifyCFG/speculate-math.ll
Transforms/SimplifyCFG/speculate-store.ll
Transforms/SimplifyCFG/speculate-vector-ops-inseltpoison.ll
Transforms/SimplifyCFG/speculate-vector-ops.ll
Transforms/SimplifyCFG/speculate-with-offset.ll
Transforms/SimplifyCFG/suppress-zero-branch-weights.ll
Transforms/SimplifyCFG/switch-dead-default.ll
Transforms/SimplifyCFG/switch-masked-bits.ll
Transforms/SimplifyCFG/switch-on-const-select.ll
Transforms/SimplifyCFG/switch-profmd.ll
Transforms/SimplifyCFG/switch-range-to-icmp.ll
Transforms/SimplifyCFG/switch-to-br.ll
Transforms/SimplifyCFG/switch-to-icmp.ll
Transforms/SimplifyCFG/switch-to-select-multiple-edge-per-block-phi.ll
Transforms/SimplifyCFG/switch-to-select-two-case.ll
Transforms/SimplifyCFG/switchToSelect-domtree-preservation-edgecase.ll
Transforms/SimplifyCFG/switch_create-custom-dl.ll
Transforms/SimplifyCFG/switch_create.ll
Transforms/SimplifyCFG/switch_msan.ll
Transforms/SimplifyCFG/switch_switch_fold.ll
Transforms/SimplifyCFG/switch_thread.ll
Transforms/SimplifyCFG/switch_undef.ll
Transforms/SimplifyCFG/trap-debugloc.ll
Transforms/SimplifyCFG/trapping-load-unreachable.ll
Transforms/SimplifyCFG/two-entry-phi-return.ll
Transforms/SimplifyCFG/two-entry-phi-fold-crash.ll
Transforms/SimplifyCFG/unprofitable-pr.ll
Transforms/SimplifyCFG/unreachable-cleanuppad.ll
Transforms/SimplifyCFG/unreachable_assume.ll
Transforms/SimplifyCFG/unsigned-multiplication-will-overflow.ll
Transforms/SimplifyCFG/wc-widen-block.ll
Transforms/SimplifyCFG/wineh-unreachable.ll
Transforms/Util/dbg-call-bitcast.ll
Transforms/Util/libcalls-opt-remarks.ll
Transforms/Util/strip-gc-relocates.ll
Transforms/VectorCombine/AMDGPU/as-transition-inseltpoison.ll
Transforms/VectorCombine/AMDGPU/as-transition.ll
Transforms/VectorCombine/X86/extract-binop-inseltpoison.ll
Transforms/VectorCombine/X86/extract-binop.ll
Transforms/VectorCombine/X86/extract-cmp-binop.ll
Transforms/VectorCombine/X86/extract-cmp.ll
Transforms/VectorCombine/X86/insert-binop-inseltpoison.ll
Transforms/VectorCombine/X86/insert-binop-with-constant-inseltpoison.ll
Transforms/VectorCombine/X86/insert-binop-with-constant.ll
Transforms/VectorCombine/X86/insert-binop.ll
Transforms/VectorCombine/X86/load-inseltpoison.ll
Transforms/VectorCombine/X86/load.ll
Transforms/VectorCombine/X86/scalarize-cmp-inseltpoison.ll
Transforms/VectorCombine/X86/scalarize-cmp.ll
Transforms/VectorCombine/X86/shuffle-inseltpoison.ll
Transforms/VectorCombine/X86/shuffle.ll
tools/UpdateTestChecks/update_test_checks/basic.test
tools/gold/X86/opt-level.ll
)

# DISABLE_PEEPHOLES=0 DISABLE_WRONG_OPTIMIZATIONS=0
EXPECTED_FAILS_6_AMD64=(
)


_test() {
	einfo "Called _test()"
	cd "${BUILD_DIR}" || die
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	if use souper ; then
		einfo "Testing DISABLE_PEEPHOLES=${ph} DISABLE_WRONG_OPTIMIZATIONS=${wo}"
		# Behavior wo meaning
		#	0	possible undefined behavior allowed in LLVM lib [llvm default]
		#	1	possible undefined behavior disallowed in LLVM lib [souper default]
		# The undefined behavior described within LLVM is discussed in the academic paper 2.10-2.11 sections.

		# Behavior ph meaning
		#	0	allow llvm peepholes implementation [llvm default, souper default]
		#	1	disallow llvm peepholes implementation

		# Correctness table expectations based on test-disable-peepholes.sh comments
		#	wo	ph	expected result
		#	0	0	pass (llvm default)
		#	0	1	? [guestimated fail for peephole tests]
		#	1	0	fail on undefined behavior tests (souper default)
		#	1	1	fail on peephole-like tests [and possibly undefined behavior tests]
		# Did not observe ph test failures in llvm 12.x that were expected
		cd "${BUILD_DIR}" || die
		unset LD_LIBRARY_PATH # Use the lit generated LD_LIBRARY_PATH.
		local results_path="${T}/test_results_${s_idx}_${ABI}.txt"
		"${CMAKE_MAKEFILE_GENERATOR}" check 2>&1 | tee "${results_path}" || true # non fatal because failures are expected

		local expected_fails="EXPECTED_FAILS_${s_idx}_${ABI^^}[@]"

		local nfail=0
		for l in ${!expected_fails} ; do
			if ! grep -e "^FAIL: LLVM :: ${l}" "${results_path}" ; then
				nfail=$((${nfail}+1))
			fi
		done
		if (( ${nfail} > 0 )) ; then
			eerror "Expected 0 missed FAIL.  s_idx = ${s_idx}, nfail = ${nfail}"
			die
		fi

		if (( ${s_idx} == 3 || ${s_idx} == 5 )) ; then
			# Checks immediately after building
			grep -q -e "Failed Tests" \
				"${T}/test_results_${s_idx}_${ABI}.txt" \
				|| die "At least one failure must be present (wo == 1 || ph == 1) (${ABI})"
		fi

		if (( ${s_idx} == 6 )) ; then
			for i in $(seq 1 6) ; do
				if grep -q -e "Failed Tests" \
	                                "${T}/test_results_${i}_${ABI}.txt" ; then
					ewarn "Test FAILED in run ${i} (${ABI})"
				else
					einfo "Test PASSED in run ${i} (${ABI})"
				fi
			done
			if ! use bootstrap ; then
				# Checks when clang utilizes the just built patched libLLVM.so library.
				grep -q -e "Failed Tests" \
					"${T}/test_results_2_${ABI}.txt" \
					"${T}/test_results_4_${ABI}.txt" \
					"${T}/test_results_6_${ABI}.txt" \
					|| die "At least one failure must be present (prev_wo == 1 || prev_ph == 1) (${ABI})"
				grep -q -e "Failed Tests" \
					"${T}/test_results_4_${ABI}.txt" \
					&& ewarn "The undefined behavior tests (s_idx=4, prev_wo=1, prev_ph=0) should have failed. (${ABI})"
				grep -q -e "Failed Tests" \
					"${T}/test_results_6_${ABI}.txt" \
					&& ewarn "The undefined behavior and peephole tests (s_idx=6, prev_wo=1, prev_ph=1) should have failed. (${ABI})"
			fi
			local total_tests=$(grep -o -E -e "of [0-9]+)" "${results_path}" | uniq | grep -E -o "[0-9]+") # 42k in 12.x
			[[ -z "${total_tests}" ]] && die "total_tests cannot be empty"
			local n_failed=$(grep -o -E -e "Failed Tests.*" "${results_path}"  | grep -o -E -e "[0-9]+")
			[[ -z "${n_failed}" ]] && n_failed=0
			local one_percent=$(${EPYTHON} -c "print(${total_tests}*0.01)" | cut -f 1 -d ".")
			# Test the llvm library with unpatched equivalent configuration.
			# Out of 42169 tests
			# 1% fail (or 421) is still a lot compared to the actual number of fails which is 3.
			grep -q -e "Failed Tests" \
				"${T}/test_results_2_${ABI}.txt" \
				&& (( ${n_failed} > 42 )) && die "The LLVM defaults (s_idx=2, wo=0, ph=0) failure should be <= 42 cutoff. (${ABI})"
			# 42 is used because we didn't test all the features.  Ideally, this number is 0.
			# Slack is given because in reality, unit tests can be broken.
			# TODO:  Find tests that trigger UB FAIL and Peephole FAIL below
		fi
	else
		cmake_build check
	fi
}

src_install() {
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
	if use souper ; then
		if (( ${s_idx} == 7 )) ; then
			mv "${ED}"/usr/lib/llvm/${SLOT}/include "${ED}"/usr/include || die
			LLVM_LDPATHS+=( "${EPREFIX}/usr/lib/llvm/${SLOT}/$(get_libdir)" )
		else
			local parity=$((${s_idx} % 2))
			mv "${ED}"/usr/lib/llvm/${parity}/include "${ED}"/usr/include || die
		fi
	else
		mv "${ED}"/usr/lib/llvm/${SLOT}/include "${ED}"/usr/include || die
		LLVM_LDPATHS+=( "${EPREFIX}/usr/lib/llvm/${SLOT}/$(get_libdir)" )
	fi
}

multilib_src_install() {
	use souper && s_idx=7
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
}
