# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Last update:  2024-06-23

# For CUDA version see, https://github.com/llvm/llvm-project/blob/llvmorg-19.1.7/clang/include/clang/Basic/Cuda.h
GCC_COMPAT=(
	# Pruned non-GPU slots to simplify GPU offload support.
        "gcc_slot_13_4" # CUDA-12.3 (FC), CUDA-12.4 (PS), CUDA-12.5 (PS), ROCm-6.4 (U24), ROCm-7.0 (U24), U24.04 (GCC default)
        "gcc_slot_12_5" # ROCm-6.2 (U22), ROCm-6.4 (U22)
        "gcc_slot_11_5" # CY2025 is GCC 11.2.1, CUDA-11.8, U22 (GCC default)
)
# FC = Feature Complete
# PS = Partial Support
PYTHON_COMPAT=( "python3_12" )

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

KEYWORDS="
amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux
~arm64-macos ~x64-macos
"

inherit check-compiler-switch cmake dhms flag-o-matic git-r3 hip-versions libstdcxx-slot llvm.org multilib
inherit multilib-minimal ninja-utils prefix python-single-r1 toolchain-funcs

DESCRIPTION="C language family frontend for LLVM"
HOMEPAGE="https://llvm.org/"
LICENSE="
	Apache-2.0-with-LLVM-exceptions
	MIT
	UoI-NCSA
"
# MSVCSetupApi.h: MIT
# sorttable.js: MIT
SLOT="${LLVM_MAJOR}/${LLVM_SOABI}"
IUSE+="
${LLVM_EBUILDS_LLVM19_REVISION}
cet debug default-fortify-source-2 default-fortify-source-3 default-full-relro
default-partial-relro default-ssp-buffer-size-4 default-stack-clash-protection
doc +extra hardened hardened-compat ieee-long-double +pie ssp +static-analyzer
test xml
ebuild_revision_11
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}

	amd64? (
		llvm_targets_X86
	)
	arm? (
		llvm_targets_ARM
	)
	arm64? (
		llvm_targets_AArch64
	)
	loong? (
		llvm_targets_LoongArch
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

	default-fortify-source-2? (
		!default-fortify-source-3
		!test
	)
	default-fortify-source-3? (
		!default-fortify-source-2
		!test
	)
	default-full-relro? (
		!default-partial-relro
		!test
	)
	default-partial-relro? (
		!default-full-relro
		!test
	)
	default-stack-clash-protection? (
		!test
	)
	hardened? (
		!test
		default-fortify-source-3
		default-full-relro
		default-ssp-buffer-size-4
		default-stack-clash-protection
		pie
		ssp
	)
	ssp? (
		!test
	)
"
RDEPEND+="
	${PYTHON_DEPS}
	>=llvm-core/clang-common-${PV}
	static-analyzer? (
		dev-lang/perl:*
	)
	xml? (
		dev-libs/libxml2:2=[${MULTILIB_USEDEP}]
	)
	~llvm-core/llvm-${PV}:${LLVM_MAJOR}[${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP},debug=]
	llvm-core/llvm:=
"

DEPEND="
	${RDEPEND}
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-build/cmake-3.16
	test? (
		~llvm-core/lld-${PV}[${LIBSTDCXX_USEDEP}]
		llvm-core/lld:=
	)
	xml? (
		>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	)
"
PDEPEND+="
	llvm-core/clang-toolchain-symlinks:${LLVM_MAJOR}
	~llvm-runtimes/clang-runtime-${PV}
"
RESTRICT="
	!test? (
		test
	)
"
LLVM_COMPONENTS=(
	"clang"
	"clang-tools-extra"
	"cmake"
)
LLVM_MANPAGES=1
LLVM_TEST_COMPONENTS=(
	"llvm/utils"
)
LLVM_USE_TARGETS="llvm"
llvm.org_set_globals
[[ -n ${LLVM_MANPAGE_DIST} ]] && BDEPEND+=" doc? ( "
BDEPEND+="
	$(python_gen_cond_dep '
		dev-python/myst-parser[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	')
"
[[ -n ${LLVM_MANPAGE_DIST} ]] && BDEPEND+=" ) "

SRC_URI+="
https://github.com/llvm/llvm-project/commit/71a9b8833231a285b4d8d5587c699ed45881624b.patch
	-> ${PN}-71a9b88.patch
"

gen_rdepend() {
	local f
	for f in ${ALL_LLVM_TARGET_FLAGS[@]} ; do
		echo  "
			~llvm-core/llvm-${PV}:${LLVM_MAJOR}=[${f}=]
		"
	done
}
RDEPEND+=" "$(gen_rdepend)

gen_pdepend() {
	local f
	for f in ${ALL_LLVM_TARGET_FLAGS[@]} ; do
		echo  "
			>=llvm-core/lld-${LLVM_MAJOR}:${LLVM_MAJOR}[${f}=]
		"
	done
}
PDEPEND+=" "$(gen_pdepend)

# Multilib notes:
# 1. ABI_* flags control ABIs libclang* is built for only.
# 2. clang is always capable of compiling code for all ABIs for enabled
#    target. However, you will need appropriate crt* files (installed
#    e.g. by sys-devel/gcc and sys-libs/glibc).
# 3. ${CHOST}-clang wrappers are always installed for all ABIs included
#    in the current profile (i.e. alike supported by sys-devel/gcc).
#
# Therefore: use llvm-core/clang[${MULTILIB_USEDEP}] only if you need
# multilib clang* libraries (not runtime, not wrappers).

pkg_setup() {
	dhms_start
	check-compiler-switch_start
	python-single-r1_pkg_setup
	if tc-is-gcc ; then
		local gcc_slot=$(best_version "sys-devel/gcc" \
			| sed -e "s|sys-devel/gcc-||g")
		gcc_slot=$(ver_cut 1-3 ${gcc_slot})
		# gcc-major-version is broken with gcc hardened 11.2.1_p20220115
		if (( $(ver_cut 1 ${gcc_slot}) != $(ver_cut 1 $(_gcc_fullversion)) )) ; then
# Prevent: undefined reference to `std::__throw_bad_array_new_length()'
ewarn
ewarn "Detected not using latest gcc."
ewarn
ewarn "Build may break if highest gcc version not chosen and profile not"
ewarn "sourced.  To fix do the following:"
ewarn
ewarn "  gcc-config -l"
ewarn "  gcc-config ${CHOST}-${gcc_slot}	# It must match at least one row from \ "
ewarn "						# the above list."
ewarn "  source /etc/profile"
ewarn
		fi
	fi

	if [[ -n "${MAKEOPTS}" ]] ; then
		local nmakeopts=$(echo "${MAKEOPTS}" \
			| grep -o -E -e "-j[ ]*[0-9]+( |$)" \
			| sed -e "s|-j||g" -e "s|[ ]*||" \
			| tail -n 1)
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
ewarn "See \`epkginfo -x llvm-core/clang::oiledmachine-overlay\` or the"
ewarn "metadata.xml to see how to accomplish this."
ewarn

	if [[ "${CC}" == "clang" ]] ; then
		local clang_path="clang-${LLVM_MAJOR}"
		if which "${clang_path}" 2>/dev/null 1>/dev/null && "${clang_path}" --help \
			| grep "symbol lookup error" ; then
eerror
eerror "The entire slot should be uninstalled and set CC=gcc and CXX=g++"
eerror
			die
		fi
	fi

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

einfo
einfo "See the metadata.xml for details about using the PGO/BOLT optimizer"
einfo "script (optimize.sh)"
einfo
	libstdcxx-slot_verify
}

src_unpack() {
	llvm.org_src_unpack
}

eapply_hardened() {
ewarn
ewarn "The hardened USE flag and associated patches via default_* are still in"
ewarn "testing."
ewarn
	local hardened_features=""
	local patches_hardened=()
	if use pie ; then
		hardened_features+="PIE, "
	fi
	if use ssp ; then
		patches_hardened+=(
			"${FILESDIR}/clang-12.0.1-enable-SSP-by-default.patch"
		)
		hardened_features+="SSP, "
	fi
	if use default-ssp-buffer-size-4 ; then
		patches_hardened+=(
			"${FILESDIR}/clang-16.0.0.9999-change-SSP-buffer-size-to-4.patch"
		)
	fi
	if use default-fortify-source-2 ; then
		patches_hardened+=(
			"${FILESDIR}/clang-14.0.0.9999-set-_FORTIFY_SOURCE-to-2-by-default.patch"
		)
		hardened_features+="_FORITIFY_SOURCE=2, "
	fi
	if use default-fortify-source-3 ; then
		patches_hardened+=(
			"${FILESDIR}/clang-14.0.0.9999-set-_FORTIFY_SOURCE-to-3-by-default.patch"
		)
		hardened_features+="_FORITIFY_SOURCE=3, "
ewarn "The _FORITIFY_SOURCE=3 is in testing."
	fi
	if use default-full-relro ; then
		patches_hardened+=(
			"${FILESDIR}/clang-12.0.1-enable-full-relro-by-default.patch"
		)
		hardened_features+="Full RELRO, "
ewarn "The Full RELRO is in testing."
	fi
	if use default-partial-relro ; then
		patches_hardened+=(
			"${FILESDIR}/clang-12.0.1-enable-partial-relro-by-default.patch"
		)
		hardened_features+="Partial RELRO, "
ewarn "The Partial RELRO is in testing."
	fi
	if use default-stack-clash-protection ; then
		if use x86 || use amd64 ; then
			patches_hardened+=(
				"${FILESDIR}/clang-18.0.0.9999-2b033a3-enable-SCP-by-default.patch"
			)
			hardened_features+="SCP, "
		elif use arm64 ; then
ewarn
ewarn "arm64 -fstack-clash-protection is not default ON.  The feature is still"
ewarn "in development."
ewarn
		fi
	fi
	if use hardened || use hardened-compat ; then
		patches_hardened+=(
			"${FILESDIR}/clang-12.0.1-version-info.patch"
		)
	fi
	if use cet ; then
		patches_hardened+=(
			"${FILESDIR}/clang-17.0.0.9999-enable-cf-protection-full-by-default.patch"
		)
		hardened_features+="CET, "
ewarn "The CET as default is in testing."
	fi
	patches_hardened+=(
		"${FILESDIR}/clang-18.0.0.9999-cross-dso-cfi-link-with-shared.patch"
	)
	eapply ${patches_hardened[@]}

	if use hardened || use hardened-compat ; then
		hardened_features=$(echo "${hardened_features}" \
			| sed -e "s|, $||g")
		sed -i -e "s|__HARDENED_FEATURES__|${hardened_features}|g" \
			lib/Driver/Driver.cpp || die
	fi
}

src_prepare() {
	# Create an extra parent dir for relative CLANG_RESOURCE_DIR access.
	mkdir -p "${WORKDIR}/x/y" || die
	BUILD_DIR="${WORKDIR}/x/y/clang"

	llvm.org_src_prepare

	eapply -p2 "${FILESDIR}/${PN}-17.0.0.9999-stdatomic-force.patch"

	#use pgo && \
	eapply "${FILESDIR}/clang-16.0.0.9999-add-include-path.patch"

	eapply_hardened

	# Add Gentoo Portage Prefix for Darwin.  See prefix-dirs.patch.
	eprefixify \
		lib/Lex/InitHeaderSearch.cpp \
		lib/Driver/ToolChains/Darwin.cpp || die

	if ! use prefix-guest && [[ -n ${EPREFIX} ]]; then
		sed -i "/LibDir.*Loader/s@return \"\/\"@return \"${EPREFIX}/\"@" \
			lib/Driver/ToolChains/Linux.cpp \
			|| die
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
					# meta-targets
					clang-libraries|distribution)
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

get_distribution_components() {
	local sep=${1-;}

	local out=(
		# common stuff
		clang-cmake-exports
		clang-headers
		clang-resource-headers
		libclang-headers

		aarch64-resource-headers
		arm-common-resource-headers
		arm-resource-headers
		core-resource-headers
		cuda-resource-headers
		hexagon-resource-headers
		hip-resource-headers
		hlsl-resource-headers
		mips-resource-headers
		opencl-resource-headers
		openmp-resource-headers
		ppc-htm-resource-headers
		ppc-resource-headers
		riscv-resource-headers
		systemz-resource-headers
		utility-resource-headers
		ve-resource-headers
		webassembly-resource-headers
		windows-resource-headers
		x86-resource-headers

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
			amdgpu-arch
			c-index-test
			clang
			clang-format
			clang-installapi
			clang-linker-wrapper
			clang-nvlink-wrapper
			clang-offload-bundler
			clang-offload-packager
			clang-refactor
			clang-repl
			clang-rename
			clang-scan-deps
			diagtool
			hmaptool
			nvptx-arch

			# needed for cross-compiling Clang
			clang-tblgen
		)

		if use extra; then
			out+=(
				# extra tools
				clang-apply-replacements
				clang-change-namespace
				clang-doc
				clang-include-cleaner
				clang-include-fixer
				clang-move
				clang-pseudo
				clang-query
				clang-reorder-fields
				clang-tidy
				clang-tidy-headers
				clangd
				find-all-symbols
				modularize
				pp-trace
			)
		fi

		if llvm_are_manpages_built; then
			out+=( docs-clang-man )
			use extra && out+=( docs-clang-tools-man )
		fi

		if use doc; then
			out+=( docs-clang-html )
			use extra && out+=( docs-clang-tools-html )
		fi

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

src_configure() { :; }

_gcc_fullversion() {
	gcc --version | head -n 1 | grep -o -E -e "[0-9_p.]+" | head -n 1
}

_src_configure_compiler() {
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export CPP=$(tc-getCPP)
	llvm-ebuilds_fix_toolchain # Compiler switch
}

_src_configure() {
	llvm-ebuilds_fix_toolchain # Compiler switch

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	# LLVM can have very high memory consumption while linking,
	# exhausting the limit on 32-bit linker executable
	use x86 && local -x LDFLAGS="${LDFLAGS} -Wl,--no-keep-memory"

	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"

	# Fix longer than usual build times when building webkit-gtk.
	# Fix longer than usual build times when building rocm ebuilds in sci-libs.
	# -O3 may cause random segfaults during build like in rocSPARSE.
	replace-flags '-O*' '-O2'

	# Not used.  Disabled to reduce systemwide vulnerability backlog on older hardware.
	filter-flags '-flto*'

	# For PGO
	if tc-is-gcc ; then
# error: number of counters in profile data for function '...' does not match its profile data (counter 'arcs', expected 7 and have 13) [-Werror=coverage-mismatch]
# The PGO profiles are isolated.  The Code is the same.
		append-flags -Wno-error=coverage-mismatch
	fi

	filter-flags -m32 -m64 -mx32 -m31 '-mabi=*'
	[[ ${CHOST} =~ "risc" ]] && filter-flags '-march=*'
	export CFLAGS="$(get_abi_CFLAGS ${ABI}) ${CFLAGS}"
	export CXXFLAGS="$(get_abi_CFLAGS ${ABI}) ${CXXFLAGS}"

	# [Err 8]: control flow integrity check for type '.*' failed during non-virtual call (vtable address 0x[0-9a-z]+)
	# [Err 5]: runtime error: control flow integrity check for type '.*' failed during cast to unrelated type (vtable address 0x[0-9a-z]+)
	# llvm-core/clang no-cfi-nvcall.conf no-cfi-cast.conf # Build time failures: [Err 8] with llvm header, [Err 5] with gcc header
	if tc-is-clang ; then
		if is-flagq "-fsanitize=*cfi" ; then
ewarn
ewarn "Using -fsanitize=cfi without"
ewarn "-fno-sanitize=cfi-nvcall,cfi-derived-cast,cfi-unrelated-cast"
ewarn "may break build."
ewarn
		fi
		if is-flagq "-fsanitize=*cfi-nvcall" ; then
ewarn
ewarn "Using -fsanitize=cfi-nvcall may break build."
ewarn
		fi
		if is-flagq "-fsanitize=*cfi-derived-cast" ; then
ewarn
ewarn "Using -fsanitize=cfi-derived-cast may break build."
ewarn
		fi
		if is-flagq "-fsanitize=*cfi-unrelated-cast" ; then
ewarn
ewarn "Using -fsanitize=cfi-unrelated-cast may break build."
ewarn
		fi
	fi

einfo
einfo "*FLAGS for ${ABI}:"
einfo
einfo "  CFLAGS=${CFLAGS}"
einfo "  CXXFLAGS=${CXXFLAGS}"
einfo "  LDFLAGS=${LDFLAGS}"
einfo "  PATH=${PATH}"
	if tc-is-cross-compiler ; then
einfo "  IS_CROSS_COMPILE=True"
	else
einfo "  IS_CROSS_COMPILE=False"
	fi
einfo

	local mycmakeargs=(
		-DDEFAULT_SYSROOT=$(usex prefix-guest "" "${EPREFIX}")
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}"
		-DCMAKE_INSTALL_MANDIR="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/share/man"
		-DLLVM_ROOT="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}"
		-DCLANG_CONFIG_FILE_SYSTEM_DIR="${EPREFIX}/etc/clang"
		-DCLANG_CONFIG_FILE_USER_DIR="~/.config/clang"

		# This is relative to bindir.
		-DCLANG_RESOURCE_DIR="../../../../lib/clang/${LLVM_MAJOR}"

		-DBUILD_SHARED_LIBS=OFF
		-DCLANG_LINK_CLANG_DYLIB=ON
		-DLLVM_DISTRIBUTION_COMPONENTS=$(get_distribution_components)
		-DCLANG_INCLUDE_TESTS=$(usex test)

		-DLLVM_TARGETS_TO_BUILD="${LLVM_TARGETS// /;}"

		# These are not propagated reliably, so redefine them.
		-DLLVM_ENABLE_EH=ON
		-DLLVM_ENABLE_RTTI=ON

		# libgomp support fails to find headers without explicit -I
		# furthermore, it provides only syntax checking
		-DCLANG_DEFAULT_OPENMP_RUNTIME=libomp

		-DCLANG_DEFAULT_PIE_ON_LINUX=$(usex pie)

		-DCLANG_ENABLE_LIBXML2=$(usex xml)
		-DCLANG_ENABLE_ARCMT=$(usex static-analyzer)
		-DCLANG_ENABLE_STATIC_ANALYZER=$(usex static-analyzer)
		# TODO: CLANG_ENABLE_HLSL?

		-DPython3_EXECUTABLE="${PYTHON}"
	)

	if ! use elibc_musl; then
		mycmakeargs+=(
			-DPPC_LINUX_DEFAULT_IEEELONGDOUBLE=$(usex ieee-long-double)
		)
	fi

	use test && mycmakeargs+=(
		-DLLVM_BUILD_TESTS=ON
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
				-DSPHINX_WARNINGS_AS_ERRORS=OFF
			)
			if use extra; then
				mycmakeargs+=(
					-DCLANG-TOOLS_INSTALL_SPHINX_HTML_DIR="${EPREFIX}/usr/share/doc/${PF}/tools-extra"
				)
			fi
		fi
		mycmakeargs+=(
			-DCLANG_INCLUDE_DOCS=${build_docs}
		)
	fi
	if multilib_native_use extra; then
		mycmakeargs+=(
			-DLLVM_EXTERNAL_CLANG_TOOLS_EXTRA_SOURCE_DIR="${WORKDIR}"/clang-tools-extra
			-DCLANG_TOOLS_EXTRA_INCLUDE_DOCS=${build_docs}
		)
	else
		mycmakeargs+=(
			-DLLVM_TOOL_CLANG_TOOLS_EXTRA_BUILD=OFF
		)
	fi

	if tc-is-cross-compiler; then
		has_version -b llvm-core/clang:${LLVM_MAJOR} ||
			die "llvm-core/clang:${LLVM_MAJOR} is required on the build host."
		local tools_bin=${BROOT}/usr/lib/llvm/${LLVM_MAJOR}/bin
		mycmakeargs+=(
			-DLLVM_TOOLS_BINARY_DIR="${tools_bin}"
			-DCLANG_TABLEGEN="${tools_bin}"/clang-tblgen
		)
	fi

	CMAKE_USE_DIR="${WORKDIR}/clang"
	BUILD_DIR="${WORKDIR}/x/y/clang-${MULTILIB_ABI_FLAG}.${ABI}"

	mycmakeargs+=(
		-DCMAKE_C_COMPILER="${CC}"
		-DCMAKE_CXX_COMPILER="${CXX}"
		-DCMAKE_ASM_COMPILER="${CC}"
	)

	mkdir -p "${BUILD_DIR}" || die
	cd "${BUILD_DIR}" || die
	cmake_src_configure

	multilib_is_native_abi && check_distribution_components
}

_src_compile() {
	cd "${BUILD_DIR}" || die

	# Includes pgt_build_self
	cmake_build distribution
}

src_compile() {
	compile_abi() {
		_src_configure_compiler
		_src_configure
		_src_compile
	}
	multilib_foreach_abi compile_abi
}

multilib_src_test() {
	if use hardened ; then
ewarn
ewarn "Tests are broken with the enable-SSP-and-PIE-by-default.patch"
ewarn
	fi
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	local test_targets=( check-clang )
	if multilib_native_use extra; then
		test_targets+=(
			check-clang-tools
			check-clangd
		)
	fi
	cmake_build "${test_targets[@]}"
}

src_install() {
	MULTILIB_WRAPPED_HEADERS=(
		/usr/include/clang/Config/config.h
	)

	multilib-minimal_src_install

	# Move runtime headers to /usr/lib/clang, where they belong
	mv "${ED}"/usr/include/clangrt "${ED}"/usr/lib/clang || die
	# move (remaining) wrapped headers back
	if use extra; then
		mv "${T}"/clang-tidy "${ED}"/usr/include/ || die
	fi
	mv "${ED}"/usr/include "${ED}"/usr/lib/llvm/${LLVM_MAJOR}/include || die

	# Apply CHOST and version suffix to clang tools
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
		rm "${ED}/usr/lib/llvm/${LLVM_MAJOR}/bin/${i}" || die
		dosym "clang-${LLVM_MAJOR}" "/usr/lib/llvm/${LLVM_MAJOR}/bin/${i}-${LLVM_MAJOR}"
		dosym "${i}-${LLVM_MAJOR}" "/usr/lib/llvm/${LLVM_MAJOR}/bin/${i}"
	done

	# now create target symlinks for all supported ABIs
	for abi in $(get_all_abis); do
		local abi_chost=$(get_abi_CHOST "${abi}")
		for i in "${clang_tools[@]}"; do
			dosym "${i}-${LLVM_MAJOR}" \
				"/usr/lib/llvm/${LLVM_MAJOR}/bin/${abi_chost}-${i}-${LLVM_MAJOR}"
			dosym "${abi_chost}-${i}-${LLVM_MAJOR}" \
				"/usr/lib/llvm/${LLVM_MAJOR}/bin/${abi_chost}-${i}"
		done
	done
}

multilib_src_install() {
	BUILD_DIR="${WORKDIR}/x/y/clang-${MULTILIB_ABI_FLAG}.${ABI}"

	cd "${BUILD_DIR}" || die
	DESTDIR=${D} cmake_build install-distribution

	# Move headers to /usr/include for wrapping & ABI mismatch checks.
	# (Also, drop the version suffix from runtime headers.)
	rm -rf "${ED}"/usr/include || die
	if [[ -e "${ED}"/usr/lib/llvm/${LLVM_MAJOR}/include ]] ; then
		mv \
			"${ED}"/usr/lib/llvm/${LLVM_MAJOR}/include \
			"${ED}"/usr/include \
			|| die
	fi
	if [[ -e "${ED}"/usr/lib/clang ]] ; then
		mv \
			"${ED}"/usr/lib/clang \
			"${ED}"/usr/include/clangrt \
			|| die
	fi
	if multilib_native_use extra && [[ -e "${ED}"/usr/include/clang-tidy ]] ; then
		# Don't wrap clang-tidy headers; the list is too long.
		# (They're fine for non-native ABI but enabling the targets is problematic.)
		mkdir -p "${T}/clang-tidy" || die
		cp -aT "${ED}"/usr/include/clang-tidy "${T}/" || die
		rm -rf "${ED}"/usr/include/clang-tidy || die
	fi
}

multilib_src_install_all() {
	python_fix_shebang "${ED}"
	if use static-analyzer; then
		python_optimize "${ED}"/usr/lib/llvm/${LLVM_MAJOR}/share/scan-view
	fi

	docompress "/usr/lib/llvm/${LLVM_MAJOR}/share/man"
	llvm_install_manpages
	# match 'html' non-compression
	use doc && docompress -x "/usr/share/doc/${PF}/tools-extra"
	# +x for some reason; TODO: investigate
	use static-analyzer && fperms a-x "/usr/lib/llvm/${LLVM_MAJOR}/share/man/man1/scan-build.1"
}

pkg_postinst() {
	dhms_end
	if [[ -z "${ROOT}" && -f "${EPREFIX}"/usr/share/eselect/modules/compiler-shadow.eselect ]] ; then
		eselect compiler-shadow update all
	fi

einfo
einfo "You can find additional utility scripts in:"
einfo
einfo "  ${EROOT}/usr/lib/llvm/${LLVM_MAJOR}/share/clang"
einfo
	if use extra ; then
einfo
einfo "Some of them are vim integration scripts (with instructions inside)."
einfo "The run-clang-tidy.py script requires the following additional package:"
einfo
einfo "  dev-python/pyyaml"
einfo
	fi
}

pkg_postrm() {
	if [[ -z "${ROOT}" && -f "${EPREFIX}"/usr/share/eselect/modules/compiler-shadow.eselect ]] ; then
		eselect compiler-shadow clean all
	fi
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-MOD-TYPE:  ebuild, patch, hardened-clang
# OILEDMACHINE-OVERLAY-META-WIP:  bolt, pgo
