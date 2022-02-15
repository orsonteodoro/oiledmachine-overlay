# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit cmake llvm.org multilib-minimal pax-utils python-any-r1 \
	toolchain-funcs

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
IUSE="debug doc -dump exegesis +gold libedit +libffi ncurses test xar xml z3
	kernel_Darwin ${ALL_LLVM_TARGETS[*]} r1"
IUSE+=" souper"
REQUIRED_USE="|| ( ${ALL_LLVM_TARGETS[*]} )"
REQUIRED_USE+="
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
	test? ( souper? ( dev-util/ccache ) )
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

_configure() {
	use souper && einfo "wo=${wo} ph=${ph} (${s_idx}/7)"
	local ffi_cflags ffi_ldflags
	if use libffi; then
		ffi_cflags=$($(tc-getPKG_CONFIG) --cflags-only-I libffi)
		ffi_ldflags=$($(tc-getPKG_CONFIG) --libs-only-L libffi)
	fi

	local libdir=$(get_libdir)
	local mycmakeargs=(
		# disable appending VCS revision to the version to improve
		# direct cache hit ratio
		-DLLVM_APPEND_VC_REV=OFF
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${SLOT}"
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
	cmake_src_configure

	multilib_is_native_abi && check_distribution_components
}

_compile() {
	cmake_build distribution

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

	if ! has_version "sys-devel/clang:${SLOT}[$(get_m_abi)]" ; then
eerror
eerror "sys-devel/clang:${SLOT}[$(get_m_abi)] must be installed for testing the disable-peepholes patch."
eerror
		die
	fi

	CFLAGS_BAK="${CFLAGS}"
	CXXFLAGS_BAK="${CXXFLAGS}"
	LDFLAGS_BAK="${LDFLAGS}"

	# Force gcc to skip a LLVM rebuild without the disabled-peepholes patch.
	# If you use clang at this point, you must use a LLVM without the disabled-peepholes patch.
	export CC=gcc
	export CXX=g++

	# Speed up build times
	replace-flags '-O*' '-O1'
	strip-flags

	autofix_flags # translate retpoline, strip unsupported flags during switch
	filter-flags '-f*aggressive-loop-optimizations'
	append-flags -fno-aggressive-loop-optimizations # This is mentioned in section 2.11 of the academic paper.
	append-ldflags -fno-aggressive-loop-optimizations

	wo=0
	ph=0
	s_idx=1
	_configure
	_compile
	_install
	_test

	export CC=clang-${SLOT}
	export CXX=clang++-${SLOT}
	autofix_flags # translate retpoline, strip unsupported flags during switch
	filter-flags -fno-aggressive-loop-optimizations

	# The goal here is to test recompilation using the (re)built llvm
	# with different configurations.
	export LD_LIBRARY_PATH="${ED}/usr/lib/llvm/${SLOT}/$(get_libdir)"

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

	export CFLAGS="${CFLAGS_BAK}"
	export CXXFLAGS="${CXXFLAGS_BAK}"
	export LDFLAGS="${LDFLAGS_BAK}"
}

_build_abi() {
	if use souper ; then
		# A:(wo=0, ph=0) # Configuration set
		# B:(wo=1, ph=0)
		# C:(wo=1, ph=1)
		# A > A > B > A > C > A # Build transition between configuration sets, x_(i-1) builds x_i
		local wo
		local ph
		local s_idx

		if use test ; then
			_souper_test
		fi

		if use bootstrap ; then
			# Build against vanilla unpatched.
			export CC=gcc
			export CXX=g++
			autofix_flags # translate retpoline, strip unsupported flags during switch
			filter-flags '-f*aggressive-loop-optimizations'
			append-flags -fno-aggressive-loop-optimizations # This is mentioned in section 2.11 of the academic paper.
			append-ldflags -fno-aggressive-loop-optimizations
		fi

		# Build with build_deps.sh settings
		unset LD_LIBRARY_PATH
		wo=1
		ph=0
		s_idx=7
		_configure
		_compile
		_install
		_test
	else
		if use bootstrap ; then
			# Build against vanilla unpatched.
			export CC=gcc
			export CXX=g++
			autofix_flags # translate retpoline, strip unsupported flags during switch
		fi
		_configure
		_compile
		use test && _test
	fi
}

get_m_abi() {
	local r
	for r in ${_MULTILIB_FLAGS[@]} ; do
		local m_abi=$"${r%:*}"
		local m_flag="${r#*:}"
		local a
		for a in $(echo ${m_flag} | tar "," " ") ; do
			if [[ "${m_flag}" == "${ABI}" ]] ; then
				echo "${m_abi}"
				return
			fi
		done
	done
}

src_compile() {
	_compile_abi() {
		export BUILD_DIR="${WORKDIR}/${P}_build-$(get_m_abi).${ABI}"
		_build_abi
	}
	multilib_foreach_abi _compile_abi
}

src_test() { :; }

_test() {
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
		#	1	0	fail on undefined behavior tests (souper default)
		#	0	1	? [guestimated fail for peephole tests]
		#	1	1	fail on peephole-like tests [and possibly undefined behavior tests]
		local results_path="${T}/test_results_${s_idx}_${ABI}.txt"
		"${CMAKE_MAKEFILE_GENERATOR}" check 2&>1 > "${results_path}" || true # non fatal because failures are expected

		if (( ${s_idx} == 6 )) ; then
			for i in $(seq 1 6) ; do
				if grep -q -e "Failed Tests" \
	                                "${T}/test_results_${i}_${ABI}.txt" ; then
					ewarn "Test FAILED in run ${i} (${ABI})"
				else
					einfo "Test PASSED in run ${i} (${ABI})"
				fi
			done
			grep -q -e "Failed Tests" \
				"${T}/test_results_2_${ABI}.txt" \
				"${T}/test_results_4_${ABI}.txt" \
				"${T}/test_results_6_${ABI}.txt" \
			|| die "At least one failure must be present (wo == 1 || ph == 1) (${ABI})"
			grep -q -e "Failed Tests" \
				"${T}/test_results_2_${ABI}.txt" \
				&& die "The LLVM defaults (s_idx=2, wo=0, ph=0) should not fail. (${ABI})"
			grep -q -e "Failed Tests" \
				"${T}/test_results_4_${ABI}.txt" \
				&& ewarn "The undefined behavior tests (s_idx=2, wo=1, ph=0) should have failed. (${ABI})"
			grep -q -e "Failed Tests" \
				"${T}/test_results_6_${ABI}.txt" \
				&& ewarn "The undefined behavior and peephole tests (s_idx=2, wo=1, ph=1) should have failed. (${ABI})"
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
}
