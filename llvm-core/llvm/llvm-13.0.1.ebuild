# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( "python3_"{8..11} )

inherit cmake dhms llvm.org multilib-minimal pax-utils python-any-r1 toolchain-funcs
inherit flag-o-matic git-r3 ninja-utils
inherit llvm-ebuilds

KEYWORDS="
amd64 arm arm64 ~ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~ppc-macos ~x64-macos
"

DESCRIPTION="Low Level Virtual Machine"
HOMEPAGE="https://llvm.org/"
LICENSE="
	Apache-2.0-with-LLVM-exceptions
	BSD
	public-domain
	rc
	UoI-NCSA
"
# Additional licenses:
# 1. OpenBSD regex: Henry Spencer's license ('rc' in Gentoo) + BSD.
# 2. xxhash: BSD.
# 3. MD5 code: public-domain.
# 4. ConvertUTF.h: TODO.
SLOT="${LLVM_MAJOR}/${LLVM_SOABI}"
IUSE+="
+binutils-plugin debug doc -dump exegesis libedit +libffi ncurses test xar xml
z3
ebuild-revision-5
"
REQUIRED_USE+="
	amd64? (
		llvm_targets_X86
	)
	arm? (
		llvm_targets_ARM
	)
	arm64? (
		llvm_targets_AArch64
	)
	m68k? (
		llvm_targets_M68k
	)
	mips? (
		llvm_targets_Mips
	)
	ppc? (
		llvm_targets_PowerPC
	)
	ppc64? (
		llvm_targets_PowerPC
	)
	riscv? (
		llvm_targets_RISCV
	)
	sparc? (
		llvm_targets_Sparc
	)
	x86? (
		llvm_targets_X86
	)
"
RDEPEND="
	sys-libs/zlib:0=[${MULTILIB_USEDEP}]
	binutils-plugin? (
		>=sys-devel/binutils-2.31.1-r4:*[plugins]
	)
	exegesis? (
		dev-libs/libpfm:=
	)
	libedit? (
		dev-libs/libedit:0=[${MULTILIB_USEDEP}]
	)
	libffi? (
		>=dev-libs/libffi-3.0.13-r1:0=[${MULTILIB_USEDEP}]
	)
	ncurses? (
		>=sys-libs/ncurses-5.9-r3:0=[${MULTILIB_USEDEP}]
	)
	xar? (
		app-arch/xar
	)
	xml? (
		dev-libs/libxml2:2=[${MULTILIB_USEDEP}]
	)
	z3? (
		>=sci-mathematics/z3-4.7.1:0=[${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
	binutils-plugin? (
		sys-libs/binutils-libs
	)
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-build/cmake-3.16
	dev-lang/perl
	sys-devel/gnuconfig
	doc? (
		$(python_gen_any_dep '
			dev-python/recommonmark[${PYTHON_USEDEP}]
			dev-python/sphinx[${PYTHON_USEDEP}]
		')
	)
	kernel_Darwin? (
		<llvm-runtimes/libcxx-${LLVM_VERSION}.9999
		>=sys-devel/binutils-apple-5.1
	)
	libffi? (
		>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	)
"
# There are no file collisions between these versions but having :0
# installed means llvm-config there will take precedence.
RDEPEND="
	${RDEPEND}
	!llvm-core/llvm:0
"
PDEPEND="
	llvm-core/llvm-common
	binutils-plugin? (
		>=llvm-core/llvmgold-${LLVM_MAJOR}
	)
"
RESTRICT="
	!test? (
		test
	)
"
PATCHES=(
	"${FILESDIR}/llvm-12.0.1-stop-triple-spam.patch"
)
LLVM_COMPONENTS=(
	"llvm"
)
LLVM_MANPAGES=1
LLVM_PATCHSET="${PV/_/-}-r1"
LLVM_USE_TARGETS="provide"
llvm.org_set_globals

pkg_setup() {
	dhms_start
	python_setup
ewarn
ewarn "To avoid long linking delays, close programs that produce unexpectedly"
ewarn "high disk activity (web browsers) and possibly switch to -j1."
ewarn

# See https://bugs.gentoo.org/767700
einfo
einfo "To remove the hard USE mask for llvm_targets_*, do:"
einfo
	local t
	for t in ${ALL_LLVM_TARGET_FLAGS[@]} ; do
echo "echo \"${CATEGORY}/${PN} -${t}\" >> ${EROOT}/etc/portage/profile/package.use.force"
	done
	for t in ${ALL_LLVM_EXPERIMENTAL_TARGETS[@]/#/llvm_targets_} ; do
echo "echo \"${CATEGORY}/${PN} -${t}\" >> ${EROOT}/etc/portage/profile/package.use.mask"
	done
einfo
einfo "However, some packages still need some or all of these.  Some are"
einfo "mentioned in bug #767700."
einfo

	if ! use llvm_targets_AMDGPU ; then
ewarn
ewarn "There is a high rebuild cost if llvm_targets_AMDGPU is not enabled now"
ewarn "before building sys-libs/libomp[offload,llvm_targets_AMDGPU]."
ewarn "Plus, the libomp does not do proper USE flag checks for this flag."
ewarn
	fi
	if ! use llvm_targets_NVPTX ; then
ewarn
ewarn "There is a high rebuild cost if llvm_targets_NVPTX is not enabled now"
ewarn "before building sys-libs/libomp[cuda,offload,llvm_targets_NVPTX]."
ewarn "Plus, the libomp ebuild does not do proper USE flag checks for this"
ewarn "flag."
ewarn
	fi
	if ! use llvm_targets_WebAssembly ; then
ewarn
ewarn "There is a high rebuild cost if llvm_targets_WebAssembly is not enabled"
ewarn "now before building dev-util/emscripten."
ewarn
	fi

einfo
einfo "See llvm-core/clang/metadata.xml for details on PGO/BOLT optimization."
einfo
}

python_check_deps() {
	use doc || return 0

	python_has_version "dev-python/recommonmark[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/sphinx[${PYTHON_USEDEP}]"
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
eqawarn
eqawarn "ALL_LLVM_EXPERIMENTAL_TARGETS is outdated!"
eqawarn "    Have: ${ALL_LLVM_EXPERIMENTAL_TARGETS[*]}"
eqawarn "Expected: ${exp_targets[*]}"
eqawarn
	fi

	if [[ ${prod_targets[*]} != ${ALL_LLVM_PRODUCTION_TARGETS[*]} ]]; then
eqawarn
eqawarn "ALL_LLVM_PRODUCTION_TARGETS is outdated!"
eqawarn "    Have: ${ALL_LLVM_PRODUCTION_TARGETS[*]}"
eqawarn "Expected: ${prod_targets[*]}"
eqawarn
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
		done < <(${NINJA} -t targets all)

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
eqawarn
eqawarn "get_distribution_components() is outdated!"
eqawarn "   Add: ${add[*]}"
eqawarn "Remove: ${remove[*]}"
eqawarn
		fi
		cd - >/dev/null || die
	fi
}

src_unpack() {
	llvm.org_src_unpack
}

src_prepare() {
	# disable use of SDK on OSX, bug #568758
	sed -i -e 's/xcrun/false/' "utils/lit/lit/util.py" || die

	# Update config.guess to support more systems
	cp "${BROOT}/usr/share/gnuconfig/config.guess" "cmake/" || die

	# Verify that the live ebuild is up-to-date
	check_live_ebuild

	llvm.org_src_prepare
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
			llvm-rtdyld
			llvm-sim
			llvm-size
			llvm-split
			llvm-stress
			llvm-strings
			llvm-strip
			llvm-symbolizer
			llvm-tapi-diff
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

src_configure() {
	:
}

_src_configure_compiler() {
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export CPP=$(tc-getCPP)
	llvm-ebuilds_fix_toolchain
}

_src_configure() {
	mkdir -p "${BUILD_DIR}" || die # strange?
	cd "${BUILD_DIR}" || die
	local ffi_cflags ffi_ldflags
	if use libffi; then
		ffi_cflags=$($(tc-getPKG_CONFIG) --cflags-only-I libffi)
		ffi_ldflags=$($(tc-getPKG_CONFIG) --libs-only-L libffi)
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

	# Fix longer than usual build times when building webkit-gtk.
	# Fix longer than usual build times when building rocm ebuilds in sci-libs.
	# -O3 may cause random segfaults/ICE.
	replace-flags '-O*' '-O2'

	# Remove unused flag.  Reduce systemwide vulnerability backlog with older hardware.
	filter-flags '-flto*'

	filter-flags -m32 -m64 -mx32 -m31 '-mabi=*'
	[[ ${CHOST} =~ "risc" ]] && filter-flags '-march=*'
	export CFLAGS="$(get_abi_CFLAGS ${ABI}) ${CFLAGS}"
	export CXXFLAGS="$(get_abi_CFLAGS ${ABI}) ${CXXFLAGS}"
einfo
einfo "CFLAGS=${CFLAGS}"
einfo "CXXFLAGS=${CXXFLAGS}"
einfo

	local libdir=$(get_libdir)
	local mycmakeargs=(
		# disable appending VCS revision to the version to improve
		# direct cache hit ratio
		-DLLVM_APPEND_VC_REV=OFF
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}"
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

	if [[ $(tc-get-cxx-stdlib) == libc++ ]]; then
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

	use test && mycmakeargs+=(
		-DLLVM_LIT_ARGS="$(get_lit_flags)"
	)

	if multilib_is_native_abi; then
		local build_docs=OFF
		if llvm_are_manpages_built; then
			build_docs=ON
			mycmakeargs+=(
				-DCMAKE_INSTALL_MANDIR="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/share/man"
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
		local tblgen="${BROOT}/usr/lib/llvm/${LLVM_MAJOR}/bin/llvm-tblgen"
		[[ -x "${tblgen}" ]] \
			|| die "${tblgen} not found or usable"
		mycmakeargs+=(
			-DCMAKE_CROSSCOMPILING=ON
			-DLLVM_TABLEGEN="${tblgen}"
		)
	fi

	mycmakeargs+=(
		-DCMAKE_C_COMPILER="${CC}"
		-DCMAKE_CXX_COMPILER="${CXX}"
		-DCMAKE_ASM_COMPILER="${CC}"
	)

	cmake_src_configure

	multilib_is_native_abi && check_distribution_components
}

_src_compile() {
	cd "${BUILD_DIR}" || die
	cmake_build distribution
	use test && cmake_build test-depends

	pax-mark m "${BUILD_DIR}"/bin/llvm-rtdyld
	pax-mark m "${BUILD_DIR}"/bin/lli
	pax-mark m "${BUILD_DIR}"/bin/lli-child-target

	if use test; then
		pax-mark m "${BUILD_DIR}"/unittests/ExecutionEngine/Orc/OrcJITTests
		pax-mark m "${BUILD_DIR}"/unittests/ExecutionEngine/MCJIT/MCJITTests
		pax-mark m "${BUILD_DIR}"/unittests/Support/SupportTests
	fi
}

src_compile() {
	_compile_abi() {
		export BUILD_DIR="${WORKDIR}/${PN}_build-${MULTILIB_ABI_FLAG}.${ABI}"
		_src_configure_compiler
		_src_configure
		_src_compile
	}
	multilib_foreach_abi _compile_abi
}

src_test() {
	cd "${BUILD_DIR}" || die
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	cmake_build check
}

src_install() {
	local MULTILIB_CHOST_TOOLS=(
		/usr/lib/llvm/${LLVM_MAJOR}/bin/llvm-config
	)

	local MULTILIB_WRAPPED_HEADERS=(
		/usr/include/llvm/Config/llvm-config.h
	)

	local LLVM_LDPATHS=()
	multilib-minimal_src_install

	# move wrapped headers back
	mv "${ED}"/usr/include "${ED}"/usr/lib/llvm/${LLVM_MAJOR}/include || die
}

multilib_src_install() {
	cd "${BUILD_DIR}" || die
	DESTDIR=${D} cmake_build install-distribution

	# move headers to /usr/include for wrapping
	rm -rf "${ED}"/usr/include || die
	mv "${ED}"/usr/lib/llvm/${LLVM_MAJOR}/include "${ED}"/usr/include || die

	LLVM_LDPATHS+=( "${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/$(get_libdir)" )
}

multilib_src_install_all() {
	local revord=$(( 9999 - ${LLVM_MAJOR} ))
	newenvd - "60llvm-${revord}" <<-_EOF_
		PATH="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/bin"
		# we need to duplicate it in ROOTPATH for Portage to respect...
		ROOTPATH="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/bin"
		MANPATH="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/share/man"
		LDPATH="$( IFS=:; echo "${LLVM_LDPATHS[*]}" )"
	_EOF_

	docompress "/usr/lib/llvm/${LLVM_MAJOR}/share/man"
	llvm_install_manpages
}

pkg_postinst() {
	dhms_end
einfo
einfo "You can find additional opt-viewer utility scripts in:"
einfo
einfo "  ${EROOT}/usr/lib/llvm/${LLVM_MAJOR}/share/opt-viewer"
einfo
einfo "To use these scripts, you will need Python along with the following"
einfo "packages:"
einfo
einfo "  dev-python/pygments (for opt-viewer)"
einfo "  dev-python/pyyaml (for all of them)"
einfo
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-MOD-TYPE:  patch, stop-compile-spam
# OILEDMACHINE-OVERLAY-META-WIP:  bolt, pgo
