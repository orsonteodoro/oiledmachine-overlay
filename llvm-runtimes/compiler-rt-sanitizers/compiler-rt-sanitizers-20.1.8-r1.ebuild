# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Last update:  2024-09-22

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

PYTHON_COMPAT=( "python3_12" )

inherit check-compiler-switch check-reqs cmake flag-o-matic linux-info llvm.org llvm-utils python-any-r1

LLVM_MAX_SLOT=${LLVM_MAJOR}
KEYWORDS="
~amd64 ~arm ~arm64 ~loong ~mips ~ppc64 ~riscv ~x86 ~amd64-linux ~ppc-macos
~x64-macos
"

DESCRIPTION="Compiler runtime libraries for clang (sanitizers & xray)"
HOMEPAGE="https://llvm.org/"
LICENSE="
	Apache-2.0-with-LLVM-exceptions
	|| (
		MIT
		UoI-NCSA
	)
"
SLOT="${LLVM_MAJOR}"
IUSE+="
${LLVM_EBUILDS_LLVM20_REVISION}
+abi_x86_32 abi_x86_64 +clang +ctx-profile debug hexagon +libfuzzer +memprof
+orc +profile test +xray
ebuild_revision_14
"
# sanitizer targets, keep in sync with config-ix.cmake
# NB: ubsan, scudo deliberately match two entries
SANITIZER_FLAGS=(
	asan
	cfi
	dfsan
	gwp-asan
	hwasan
	lsan
	msan
	nsan
	rtsan
	safestack
	scudo
	shadowcallstack
	tsan
	ubsan
)
CPU_X86_FLAGS=(
	sse3
	sse4_2
)
IUSE+="
${CPU_X86_FLAGS[@]/#/cpu_flags_x86_}
${SANITIZER_FLAGS[@]/#/+}
"
# See also https://github.com/llvm/llvm-project/blob/main/compiler-rt/cmake/Modules/AllSupportedArchDefs.cmake
SANITIZER_REQUIRED_USE="
	amd64? (
		!shadowcallstack
	)
	asan? (
		|| (
			amd64
			arm
			arm64
			hexagon
			loong
			mips
			ppc64
			riscv
			s390
			sparc
			x86
		)
	)
	cfi? (
		|| (
			amd64
			arm
			arm64
			hexagon
			mips
			x86
		)
	)
	dfsan? (
		|| (
			amd64
			arm64
			mips
		)
	)
	gwp-asan? (
		|| (
			amd64
			arm
			arm64
			x86
		)
	)
	hwasan? (
		|| (
			amd64
			arm64
		)
	)
	libfuzzer? (
		elibc_bionic? (
			|| (
				amd64
				arm
				arm64
				x86
			)
		)
		kernel_linux? (
			|| (
				amd64
				arm
				arm64
				s390
				x86
			)
		)
		!elibc_bionic? (
			!kernel_linux? (
				|| (
					amd64
					arm64
				)
			)
		)
	)
	lsan? (
		!kernel_Darwin? (
			|| (
				amd64
				arm
				arm64
				hexagon
				mips
				ppc64
				s390
				riscv
				x86
			)
		)
		kernel_Darwin? (
			|| (
				amd64
				arm64
				mips
				x86
			)
		)
	)
	memprof? (
		|| (
			amd64
		)
	)
	msan? (
		|| (
			amd64
			arm64
			mips
			ppc64
			s390
		)
	)
	orc? (
		|| (
			amd64
			arm
			arm64
		)
	)
	profile? (
		|| (
			amd64
			arm
			arm64
			hexagon
			ppc
			ppc64
			mips
			riscv
			s390
			sparc
			x86
		)
	)
	safestack? (
		|| (
			amd64
			arm64
			hexagon
			loong
			mips
			x86
		)
	)
	scudo? (
		|| (
			amd64
			arm
			arm64
			hexagon
			loong
			mips
			ppc64
			x86
		)
	)
	shadowcallstack? (
		arm64
	)
	tsan? (
		|| (
			amd64
			arm64
			loong
			mips
			ppc64
			s390
			x86
		)
	)
	ubsan? (
		|| (
			amd64
			arm
			arm64
			hexagon
			loong
			mips
			ppc64
			riscv
			s390
			sparc
			x86
		)
	)
	xray? (
		!kernel_Darwin? (
			|| (
				amd64
				arm
				arm64
				hexagon
				mips
				ppc64
			)
		)
		kernel_Darwin? (
			amd64
		)
	)
"
REQUIRED_USE="
	${SANITIZER_REQUIRED_USE}
	test? (
		cfi? (
			ubsan
		)
		gwp-asan? (
			scudo
		)
	)
	|| (
		${SANITIZER_FLAGS[*]}
		libfuzzer
		orc
		profile
		xray
	)
"
RDEPEND="
	llvm-runtimes/compiler-rt-sanitizers-logging
"
DEPEND="
	llvm-core/llvm:${LLVM_MAJOR}
	virtual/libcrypt[abi_x86_32(-)?,abi_x86_64(-)?]
"
BDEPEND="
	>=dev-build/cmake-3.16
	clang? (
		llvm-core/clang:${LLVM_MAJOR}
		llvm-core/clang-linker-config:${LLVM_MAJOR}
		llvm-runtimes/clang-rtlib-config:${LLVM_MAJOR}
		llvm-runtimes/clang-stdlib-config:${LLVM_MAJOR}
		llvm-runtimes/compiler-rt:${LLVM_MAJOR}
	)
	elibc_glibc? (
		net-libs/libtirpc
	)
	test? (
		!!<sys-apps/sandbox-2.13
		$(python_gen_any_dep "
			>=dev-python/lit-15[\${PYTHON_USEDEP}]
		")
		=llvm-runtimes/compiler-rt-${LLVM_VERSION%%.*}*:=
		~llvm-core/clang-${LLVM_VERSION}:${LLVM_MAJOR}
	)
	!test? (
		${PYTHON_DEPS}
	)
"
RESTRICT="
	!clang? (
		test
	)
	!test? (
		test
	)
"
PATCHES=(
	"${FILESDIR}/compiler-rt-sanitizers-13.0.0-disable-cfi-assert-for-autoconf.patch"
)
LLVM_COMPONENTS=(
	"compiler-rt"
	"cmake"
	"llvm/cmake"
)
LLVM_TEST_COMPONENTS=(
	"llvm/include/llvm/ProfileData"
	"llvm/lib/Testing/Support"
	"third-party"
)
LLVM_PATCHSET="${PV}"
llvm.org_set_globals

python_check_deps() {
	use test || return 0
	python_has_version ">=dev-python/lit-15[${PYTHON_USEDEP}]"
}

check_space() {
	if use test; then
		local CHECKREQS_DISK_BUILD=11G
		check-reqs_pkg_pretend
	fi
}

pkg_pretend() {
	check_space
}

pkg_setup() {
	check-compiler-switch_start
	linux-info_pkg_setup
	# See https://llvm.org/docs/ScudoHardenedAllocator.html#randomness
	CONFIG_CHECK="
		~RELOCATABLE
		~RANDOMIZE_BASE
	"
	if [[ "${ARCH}" == "amd64" ]] ; then
		CONFIG_CHECK+="
			~RANDOMIZE_MEMORY
		"
	fi
	WARNING_RELOCATABLE="CONFIG_RELOCATABLE is required for mitigation for non-production compiler-rt-sanitizers and Scudo."
	WARNING_RANDOMIZE_BASE="CONFIG_RANDOMIZE_BASE (KASLR) is required for mitigation for hardened non-production compiler-rt-sanitizers and Scudo."
	WARNING_RANDOMIZE_MEMORY="CONFIG_RANDOMIZE_MEMORY is required for mitigiation for non-production compiler-rt-sanitizers and Scudo."
	check_extra_config
	check_space
	python-any-r1_pkg_setup
}

src_prepare() {
	sed -i -e 's:-Werror::' lib/tsan/go/buildgo.sh || die

	local flag
	for flag in "${SANITIZER_FLAGS[@]}"; do
		if ! use "${flag}"; then
			local cmake_flag=${flag/-/_}
			sed -i -e "/COMPILER_RT_HAS_${cmake_flag^^}/s:TRUE:FALSE:" \
				cmake/config-ix.cmake || die
		fi
	done

	# TODO: fix these tests to be skipped upstream
	if use asan && ! use profile; then
		rm test/asan/TestCases/asan_and_llvm_coverage_test.cpp || die
	fi
	if use ubsan && ! use cfi; then
		> test/cfi/CMakeLists.txt || die
	fi

	llvm.org_src_prepare
}

src_configure() {
	llvm_prepend_path "${LLVM_MAJOR}"
	llvm-ebuilds_fix_toolchain # Compiler switch

	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"

	# pre-set since we need to pass it to cmake
	BUILD_DIR=${WORKDIR}/compiler-rt_build

	if use clang; then
		local -x CC="${CHOST}-clang-${LLVM_MAJOR}"
		local -x CXX="${CHOST}-clang++-${LLVM_MAJOR}"
		local -x CPP="${CC} -E"
		strip-unsupported-flags

		# The full clang configuration might not be ready yet. Use the partial
		# configuration files that are guaranteed to exist even during initial
		# installations and upgrades.
		local flags=(
			--config="${ESYSROOT}/etc/clang/${LLVM_MAJOR}/gentoo-"{"rtlib","stdlib","linker"}".cfg"
		)
		local -x CFLAGS="${CFLAGS} ${flags[@]}"
		local -x CXXFLAGS="${CXXFLAGS} ${flags[@]}"
		local -x LDFLAGS="${LDFLAGS} ${flags[@]}"
	fi
ewarn "Rebuild with GCC 12 if \"Assumed value of MB_LEN_MAX wrong\" pops up."

	local flag want_sanitizer=OFF
	for flag in "${SANITIZER_FLAGS[@]}"; do
		if use "${flag}"; then
			want_sanitizer=ON
			break
		fi
	done

	local mycmakeargs=(
		-DCOMPILER_RT_INSTALL_PATH="${EPREFIX}/usr/lib/clang/${LLVM_MAJOR}"
		# use a build dir structure consistent with install
		# this makes it possible to easily deploy test-friendly clang
		-DCOMPILER_RT_OUTPUT_DIR="${BUILD_DIR}/lib/clang/${LLVM_MAJOR}"

		-DCOMPILER_RT_INCLUDE_TESTS=$(usex test)
		# builtins & crt installed by llvm-runtimes/compiler-rt
		-DCOMPILER_RT_BUILD_BUILTINS=OFF
		-DCOMPILER_RT_BUILD_CRT=OFF
		-DCOMPILER_RT_BUILD_CTX_PROFILE=$(usex ctx-profile)
		-DCOMPILER_RT_BUILD_LIBFUZZER=$(usex libfuzzer)
		-DCOMPILER_RT_BUILD_MEMPROF=$(usex memprof)
		-DCOMPILER_RT_BUILD_ORC=$(usex orc)
		-DCOMPILER_RT_BUILD_PROFILE=$(usex profile)
		-DCOMPILER_RT_BUILD_SANITIZERS="${want_sanitizer}"
		-DCOMPILER_RT_BUILD_XRAY=$(usex xray)
		-DCOMPILER_RT_HAS_MSSE3_FLAG=$(usex cpu_flags_x86_sse3)
		-DCOMPILER_RT_HAS_MSSE4_2_FLAG=$(usex cpu_flags_x86_sse4_2)

		-DPython3_EXECUTABLE="${PYTHON}"
	)

	if use amd64; then
		mycmakeargs+=(
			-DCAN_TARGET_i386=$(usex abi_x86_32)
			-DCAN_TARGET_x86_64=$(usex abi_x86_64)
		)
	fi

	if use test; then
		mycmakeargs+=(
			-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
			-DLLVM_LIT_ARGS="$(get_lit_flags)"

			# they are created during src_test()
			-DCOMPILER_RT_TEST_COMPILER="${BUILD_DIR}/lib/llvm/${LLVM_MAJOR}/bin/clang"
			-DCOMPILER_RT_TEST_CXX_COMPILER="${BUILD_DIR}/lib/llvm/${LLVM_MAJOR}/bin/clang++"
		)

		# same flags are passed for build & tests, so we need to strip
		# them down to a subset supported by clang
		CC="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/bin/clang" \
		CXX="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/bin/clang++" \
		CPP="${CC} -E" \
		strip-unsupported-flags
	fi

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	if use prefix && [[ "${CHOST}" == *-darwin* ]] ; then
		mycmakeargs+=(
			# setting -isysroot is disabled with compiler-rt-prefix-paths.patch
			# this allows adding arm64 support using SDK in EPREFIX
			-DDARWIN_macosx_CACHED_SYSROOT="${EPREFIX}/MacOSX.sdk"
			# Set version based on the SDK in EPREFIX
			# This disables i386 for SDK >= 10.15
			# Will error if has_use tsan and SDK < 10.12
			-DDARWIN_macosx_OVERRIDE_SDK_VERSION=$(realpath "${EPREFIX}/MacOSX.sdk" | sed -e 's/.*MacOSX\(.*\)\.sdk/\1/')
			# Use our libtool instead of looking it up with xcrun
			-DCMAKE_LIBTOOL="${EPREFIX}/usr/bin/${CHOST}-libtool"
		)
	fi

	cmake_src_configure

	if use test; then
		local sys_dir=( "${EPREFIX}"/usr/lib/clang/${LLVM_MAJOR}/lib/* )
		[[ -e ${sys_dir} ]] || die "Unable to find ${sys_dir}"
		[[ ${#sys_dir[@]} -eq 1 ]] || die "Non-deterministic compiler-rt install: ${sys_dir[*]}"

		# copy clang over since resource_dir is located relatively to binary
		# therefore, we can put our new libraries in it
		mkdir -p "${BUILD_DIR}"/lib/{llvm/${LLVM_MAJOR}/{bin,$(get_libdir)},clang/${LLVM_MAJOR}/include} || die
		cp "${EPREFIX}"/usr/lib/llvm/${LLVM_MAJOR}/bin/clang{,++} \
			"${BUILD_DIR}"/lib/llvm/${LLVM_MAJOR}/bin/ || die
		cp "${EPREFIX}"/usr/lib/clang/${LLVM_MAJOR}/include/*.h \
			"${BUILD_DIR}"/lib/clang/${LLVM_MAJOR}/include/ || die
		cp "${sys_dir}"/*builtins*.a \
			"${BUILD_DIR}/lib/clang/${LLVM_MAJOR}/lib/${sys_dir##*/}/" || die
		# we also need LLVMgold.so for gold-based tests
		if [[ -f "${EPREFIX}"/usr/lib/llvm/${LLVM_MAJOR}/$(get_libdir)/LLVMgold.so ]]; then
			ln -s "${EPREFIX}"/usr/lib/llvm/${LLVM_MAJOR}/$(get_libdir)/LLVMgold.so \
				"${BUILD_DIR}"/lib/llvm/${LLVM_MAJOR}/$(get_libdir)/ || die
		fi
	fi
}

src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	# disable sandbox to have it stop clobbering LD_PRELOAD
	local -x SANDBOX_ON=0
	# wipe LD_PRELOAD to make ASAN happy
	local -x LD_PRELOAD=

	cmake_build check-all
}

pkg_postinst() {
ewarn "Do not use or mix LLVM sanitizers and GCC sanitizers systemwide."
ewarn "Do not use or mix GCC LTO and LLVM LTO systemwide for systemwide LLVM CFI."
ewarn "Do not mix GCC GIMPLE IR with LLVM IR with static-libs."
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  ebuild, hardening
