# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( "python3_"{8..11} )

inherit check-reqs cmake flag-o-matic linux-info llvm llvm.org python-any-r1
inherit llvm-ebuilds

LLVM_MAX_SLOT=${LLVM_MAJOR}
KEYWORDS="amd64 arm arm64 ppc64 ~riscv x86 ~amd64-linux ~ppc-macos ~x64-macos"

DESCRIPTION="Compiler runtime libraries for clang (sanitizers & xray)"
HOMEPAGE="https://llvm.org/"
LICENSE="
	Apache-2.0-with-LLVM-exceptions
	|| (
		MIT
		UoI-NCSA
	)
"
SLOT="$(ver_cut 1-3)"
IUSE+="
+abi_x86_32 abi_x86_64 +clang debug +libfuzzer +memprof +orc +profile test +xray
ebuild-revision-4
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
# See also https://github.com/llvm/llvm-project/blob/llvmorg-13.0.1/compiler-rt/cmake/config-ix.cmake
SANITIZER_REQUIRED_USE="
	asan? (
		|| (
			amd64
			arm
			arm64
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
		)
	)
	profile? (
		|| (
			amd64
			arm
			arm64
			ppc
			ppc64
			mips
			s390
			sparc
			x86
		)
	)
	safestack? (
		|| (
			amd64
			arm64
			mips
			x86
		)
	)
	scudo? (
		|| (
			amd64
			arm
			arm64
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
DEPEND="
	llvm-core/llvm:${LLVM_MAJOR}
	virtual/libcrypt[abi_x86_32(-)?,abi_x86_64(-)?]
"
BDEPEND="
	>=dev-build/cmake-3.16
	clang? (
		llvm-core/clang
	)
	elibc_glibc? (
		net-libs/libtirpc
	)
	test? (
		!!<sys-apps/sandbox-2.13
		$(python_gen_any_dep "
			>=dev-python/lit-5[\${PYTHON_USEDEP}]
		")
		=llvm-runtimes/compiler-rt-${LLVM_VERSION}*:=
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
)
LLVM_TEST_COMPONENTS=(
	"llvm/lib/Testing/Support"
	"llvm/utils/unittest"
)
LLVM_PATCHSET="${PV/_/-}"
llvm.org_set_globals

python_check_deps() {
	use test || return 0
	python_has_version ">=dev-python/lit-5[${PYTHON_USEDEP}]"
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
	if use scudo ; then
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
		WARNING_RELOCATABLE="CONFIG_RELOCATABLE is required by Scudo."
		WARNING_RANDOMIZE_BASE="CONFIG_RANDOMIZE_BASE (KASLR) is required by Scudo."
		WARNING_RANDOMIZE_MEMORY="CONFIG_RANDOMIZE_MEMORY is required by Scudo."
		check_extra_config
	fi
	check_space
	llvm_pkg_setup
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
	llvm-ebuilds_fix_toolchain
	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"

	# pre-set since we need to pass it to cmake
	BUILD_DIR=${WORKDIR}/compiler-rt_build

	if use clang; then
		local -x CC=${CHOST}-clang
		local -x CXX=${CHOST}-clang++
		strip-unsupported-flags
		append-cppflags -I"${ESYSROOT}"/usr/lib/clang/${LLVM_VERSION}/include
ewarn
ewarn "Disable the clang USE flag if \"Assumed value of MB_LEN_MAX wrong\" pops up."
ewarn
	fi

	local flag want_sanitizer=OFF
	for flag in "${SANITIZER_FLAGS[@]}"; do
		if use "${flag}"; then
			want_sanitizer=ON
			break
		fi
	done

	local mycmakeargs=(
		-DCOMPILER_RT_INSTALL_PATH="${EPREFIX}/usr/lib/clang/${SLOT}"
		# use a build dir structure consistent with install
		# this makes it possible to easily deploy test-friendly clang
		-DCOMPILER_RT_OUTPUT_DIR="${BUILD_DIR}/lib/clang/${SLOT}"

		-DCOMPILER_RT_INCLUDE_TESTS=$(usex test)
		# builtins & crt installed by llvm-runtimes/compiler-rt
		-DCOMPILER_RT_BUILD_BUILTINS=OFF
		-DCOMPILER_RT_BUILD_CRT=OFF
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
			-DLLVM_MAIN_SRC_DIR="${WORKDIR}/llvm"
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
		strip-unsupported-flags
	fi

	if use prefix && [[ "${CHOST}" == *-darwin* ]] ; then
		mycmakeargs+=(
			# setting -isysroot is disabled with compiler-rt-prefix-paths.patch
			# this allows adding arm64 support using SDK in EPREFIX
			-DDARWIN_macosx_CACHED_SYSROOT="${EPREFIX}/MacOSX.sdk"
			# Set version based on the SDK in EPREFIX
			# This disables i386 for SDK >= 10.15
			# Will error if has_use tsan and SDK < 10.12
			-DDARWIN_macosx_OVERRIDE_SDK_VERSION="$(realpath ${EPREFIX}/MacOSX.sdk | sed -e 's/.*MacOSX\(.*\)\.sdk/\1/')"
			# Use our libtool instead of looking it up with xcrun
			-DCMAKE_LIBTOOL="${EPREFIX}/usr/bin/${CHOST}-libtool"
		)
	fi

	cmake_src_configure

	if use test; then
		local sys_dir=( "${EPREFIX}"/usr/lib/clang/${SLOT}/lib/* )
		[[ -e ${sys_dir} ]] || die "Unable to find ${sys_dir}"
		[[ ${#sys_dir[@]} -eq 1 ]] || die "Non-deterministic compiler-rt install: ${sys_dir[*]}"

		# copy clang over since resource_dir is located relatively to binary
		# therefore, we can put our new libraries in it
		mkdir -p "${BUILD_DIR}"/lib/{llvm/${LLVM_MAJOR}/{bin,$(get_libdir)},clang/${SLOT}/include} || die
		cp "${EPREFIX}"/usr/lib/llvm/${LLVM_MAJOR}/bin/clang{,++} \
			"${BUILD_DIR}"/lib/llvm/${LLVM_MAJOR}/bin/ || die
		cp "${EPREFIX}"/usr/lib/clang/${SLOT}/include/*.h \
			"${BUILD_DIR}"/lib/clang/${SLOT}/include/ || die
		cp "${sys_dir}"/*builtins*.a \
			"${BUILD_DIR}/lib/clang/${SLOT}/lib/${sys_dir##*/}/" || die
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

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  ebuild, hardening
