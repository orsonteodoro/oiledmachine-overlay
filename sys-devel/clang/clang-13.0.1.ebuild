# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EBOLT_DISABLE_BDEPEND=1
PYTHON_COMPAT=( python3_{8..11} )
inherit cmake ebolt epgo llvm llvm.org multilib multilib-minimal \
	prefix python-single-r1 toolchain-funcs
inherit flag-o-matic git-r3 ninja-utils

DESCRIPTION="C language family frontend for LLVM"
HOMEPAGE="https://llvm.org/"

# MSVCSetupApi.h: MIT
# sorttable.js: MIT

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="amd64 arm arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x64-macos"
IUSE="
debug default-compiler-rt default-libcxx default-lld doc llvm-libunwind
+static-analyzer test xml
"
IUSE+=" +bootstrap hardened r3"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
REQUIRED_USE+="
	hardened? ( !test )
"
RESTRICT="!test? ( test )"

RDEPEND="
	${PYTHON_DEPS}
	~sys-devel/llvm-${PV}:${SLOT}=[debug=,${MULTILIB_USEDEP}]
	static-analyzer? ( dev-lang/perl:* )
	xml? ( dev-libs/libxml2:2=[${MULTILIB_USEDEP}] )
"

DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-util/cmake-3.16
	doc? ( dev-python/sphinx )
	xml? ( >=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)] )
"
PDEPEND="
	sys-devel/clang-common
	~sys-devel/clang-runtime-${PV}
	default-compiler-rt? (
		=sys-libs/compiler-rt-${PV%_*}*
		llvm-libunwind? ( sys-libs/llvm-libunwind )
		!llvm-libunwind? ( sys-libs/libunwind )
	)
	default-libcxx? ( >=sys-libs/libcxx-${PV} )
	default-lld? ( sys-devel/lld )
"

LLVM_COMPONENTS=( clang clang-tools-extra )
LLVM_MANPAGES=pregenerated
LLVM_TEST_COMPONENTS=(
	llvm/lib/Testing/Support
	llvm/utils/{lit,llvm-lit,unittest}
	llvm/utils/{UpdateTestChecks,update_cc_test_checks.py}
)
LLVM_PATCHSET=${PV/_/-}
PATCHES_HARDENED=(
	"${FILESDIR}/clang-12.0.1-enable-PIE-by-default.patch"
	"${FILESDIR}/clang-12.0.1-enable-SSP-by-default.patch"
	"${FILESDIR}/clang-13.0.0_rc2-change-SSP-buffer-size-to-4.patch"
	"${FILESDIR}/clang-14.0.0.9999-set-_FORTIFY_SOURCE-to-2-by-default.patch"
	"${FILESDIR}/clang-12.0.1-enable-full-relro-by-default.patch"
	"${FILESDIR}/clang-12.0.1-version-info.patch"
)
LLVM_USE_TARGETS=llvm
llvm.org_set_globals

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
	LLVM_MAX_SLOT=${SLOT} llvm_pkg_setup
	python-single-r1_pkg_setup
	if ! use bootstrap && ! has_version "sys-devel/clang:${SLOT}" ; then
eerror
eerror "Disabling the bootstrap USE flag requires a previous install of"
eerror "clang:${SLOT}.  Enable the bootstrap USE flag to fix this problem."
eerror
		die
	fi
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
ewarn "built with the same version."
ewarn "See \`epkginfo -x sys-devel/clang::oiledmachine-overlay\` or the"
ewarn "metadata.xml to see how to accomplish this."
ewarn

ewarn
ewarn "To avoid long linking delays, close programs that produce unexpectedly"
ewarn "high disk activity (web browsers) and possibly switch to -j1."
ewarn

	if [[ "${CC}" == "clang" ]] ; then
		local clang_path="clang-${SLOT}"
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
	epgo_setup
	ebolt_setup
}

src_unpack() {
	llvm.org_src_unpack
}

src_prepare() {
	mkdir -p "${WORKDIR}/x/y" || die
	BUILD_DIR="${WORKDIR}/x/y/clang"
	llvm.org_src_prepare
	if use hardened ; then
		ewarn "The hardened USE flag and associated patches are still in testing."
		eapply ${PATCHES_HARDENED[@]}
		eapply "${FILESDIR}/clang-14.0.0.9999-cross-dso-cfi-link-with-shared.patch"
		local hardened_features="PIE, SSP, _FORITIFY_SOURCE=2, Full RELRO"
		if use x86 || use amd64 ; then
			eapply "${FILESDIR}/clang-12.0.1-enable-FCP-by-default.patch"
			hardened_features+=", SCP"
		elif use arm64 ; then
			ewarn "arm64 -fstack-clash-protection is not default ON.  The feature is still"
			ewarn "in development."
		fi
		ewarn "The Full RELRO default on is in testing."
		sed -i -e "s|__HARDENED_FEATURES__|${hardened_features}|g" \
			lib/Driver/Driver.cpp || die
	fi

	# add Gentoo Portage Prefix for Darwin (see prefix-dirs.patch)
	eprefixify \
		lib/Frontend/InitHeaderSearch.cpp \
		lib/Driver/ToolChains/Darwin.cpp || die

	prepare_abi() {
		epgo_src_prepare
		ebolt_src_prepare
	}
	multilib_foreach_abi prepare_abi
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

src_configure() { :; }

_gcc_fullversion() {
	gcc --version | head -n 1 | grep -o -E -e "[0-9_p.]+" | head -n 1
}

_configure() {
	local BOLT_PHASE=$(ebolt_get_phase)
	epgo_src_configure
	ebolt_src_configure
	local llvm_version=$(llvm-config --version) || die
	local clang_version=$(ver_cut 1-3 "${llvm_version}")

	# TODO:  Add GCC-10 and below checks to add exceptions to -O* flag downgrading.
	# Leave a note if you know the commit that fixes the internal compiler error below.
	if tc-is-gcc && ( \
		( ver_test $(_gcc_fullversion) -lt 11.2.1_p20220112 ) \
	)
	then
		# Build time bug with gcc 10.3.0, 11.2.0:
		# internal compiler error: maximum number of LRA assignment passes is achieved (30)

		ewarn "Detected <=sys-devel/gcc-11.2.1_p20220112.  Downgrading to -Os to avoid bug."
		ewarn "Re-emerge >=sys-devel/gcc-11.2.1_p20220112 for a more optimized build with >= -O2."
		replace-flags '-O3' '-Os'
		replace-flags '-O2' '-Os'
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
	einfo "  PATH=${PATH}"
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
	)
	use test && mycmakeargs+=(
		-DLLVM_MAIN_SRC_DIR="${WORKDIR}/llvm"
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
		[[ -x "${EPREFIX}/usr/bin/clang-tblgen" ]] \
			|| die "${EPREFIX}/usr/bin/clang-tblgen not found or usable"
		mycmakeargs+=(
			-DCMAKE_CROSSCOMPILING=ON
			-DCLANG_TABLEGEN="${EPREFIX}/usr/bin/clang-tblgen"
		)
	fi

	local slot="${SLOT}"
	mycmakeargs+=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${slot}"
		-DCMAKE_INSTALL_MANDIR="${EPREFIX}/usr/lib/llvm/${slot}/share/man"
		-DLLVM_CMAKE_PATH="${EPREFIX}/usr/lib/llvm/${slot}/$(get_libdir)/cmake/llvm"
	)

	CMAKE_USE_DIR="${WORKDIR}/clang"
	BUILD_DIR="${WORKDIR}/x/y/clang-${MULTILIB_ABI_FLAG}.${ABI}"

	mycmakeargs+=(
		-DCMAKE_C_COMPILER="${CHOST}-gcc"
		-DCMAKE_CXX_COMPILER="${CHOST}-g++"
		-DCMAKE_ASM_COMPILER="${CHOST}-gcc"
	)

	mkdir -p "${BUILD_DIR}" || die
	cd "${BUILD_DIR}" || die
	cmake_src_configure

	multilib_is_native_abi && check_distribution_components
}

_compile() {
	cd "${BUILD_DIR}" || die

	# Includes pgt_build_self
	cmake_build distribution

	# provide a symlink for tests
	if [[ ! -L ${WORKDIR}/lib/clang ]]; then
		mkdir -p "${WORKDIR}"/lib || die
		ln -s "${BUILD_DIR}/$(get_libdir)/clang" "${WORKDIR}"/lib/clang || die
	fi
}

src_compile() {
	compile_abi() {
		local PGO_PHASE=$(epgo_get_phase)
		_configure
		_compile
		_install
	}
	multilib_foreach_abi compile_abi
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

_install() {
	cd "${BUILD_DIR}" || die
	DESTDIR=${D} cmake_build install-distribution

	local slot="${SLOT}"

	# move headers to /usr/include for wrapping & ABI mismatch checks
	# (also drop the version suffix from runtime headers)
	rm -rf "${ED}"/usr/include || die
	if [[ -e "${ED}"/usr/lib/llvm/${slot}/include ]] ; then
		mv "${ED}"/usr/lib/llvm/${slot}/include "${ED}"/usr/include || die
	fi
	if [[ -e "${ED}"/usr/lib/llvm/${slot}/$(get_libdir)/clang ]] ; then
		mv "${ED}"/usr/lib/llvm/${slot}/$(get_libdir)/clang "${ED}"/usr/include/clangrt || die
	fi
}

multilib_src_install() {
	BUILD_DIR="${WORKDIR}/x/y/clang-${MULTILIB_ABI_FLAG}.${ABI}"
	_install
	local BOLT_PHASE=$(ebolt_get_phase)
	epgo_src_install
	ebolt_src_install
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

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-MOD-TYPE:  ebuild, patch, hardened-clang
# OILEDMACHINE-OVERLAY-META-WIP:  bolt, pgo
