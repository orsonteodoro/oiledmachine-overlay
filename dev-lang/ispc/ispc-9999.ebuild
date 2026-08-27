# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U18, U20, U22, F39

# For the version, see
# https://github.com/ispc/ispc/blob/main/common/version.h

CFLAGS_HARDENED_ASSEMBLERS="inline"
CFLAGS_HARDENED_CI_SANITIZERS="asan"
CFLAGS_HARDENED_CI_SANITIZERS_CLANG_COMPAT="16"
CFLAGS_HARDENED_LANGS="asm c-lang cxx"
CFLAGS_HARDENED_USE_CASES="untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="PE"
CMAKE_BUILD_TYPE="RelWithDebInfo"
CMAKE_MAKEFILE_GENERATOR="emake"
CXX_STANDARD=17
LLVM_MAX_SLOT="23" # Upstream tests with LLVM 23 on U22
PYTHON_COMPAT=( "python3_"{10..14} ) # Relaxed
UOPTS_SUPPORT_EBOLT=0
UOPTS_SUPPORT_EPGO=0
UOPTS_SUPPORT_TBOLT=1
UOPTS_SUPPORT_TPGO=1

inherit libcxx-compat
LLVM_COMPAT=(
	{20..23}
) # For supported LLVM, see https://github.com/ispc/ispc/blob/main/src/ispc_version.h#L36

inherit check-compiler-switch cflags-hardened cmake flag-o-matic libcxx-slot python-any-r1 llvm secure-version toolchain-funcs uopts

if [[ "${PV}" =~ "9999" ]]; then
	INTERNAL_VERSION="1.32.0"
	SOVER=$(ver_cut "1" "${INTERNAL_VERSION}")
	FALLBACK_COMMIT=""
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/ispc/ispc.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SOVER=$(ver_cut "1" "${PV}")
	BENCHMARK_COMMIT="a6ad7fbbdc2e14fab82bb8a6d27760d700198cbf"
	GTEST_COMMIT="f8d7d77c06936315286eb55f8de22cd23c188571"
	SRC_URI="
		https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
		bolt? (
			https://github.com/google/benchmark/archive/${BENCHMARK_COMMIT}.tar.gz
				-> benchmark-${BENCHMARK_COMMIT:0:7}.tar.gz
			https://github.com/google/googletest/archive/${GTEST_COMMIT}.tar.gz
				-> gtest-${GTEST_COMMIT:0:7}.tar.gz
		)
		pgo? (
			https://github.com/google/benchmark/archive/${BENCHMARK_COMMIT}.tar.gz
				-> benchmark-${BENCHMARK_COMMIT:0:7}.tar.gz
			https://github.com/google/googletest/archive/${GTEST_COMMIT}.tar.gz
				-> gtest-${GTEST_COMMIT:0:7}.tar.gz
		)
	"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
fi

DESCRIPTION="Intel® SPMD Program Compiler"
HOMEPAGE="https://ispc.github.io/"
LICENSE="
	BSD
	BSD-2
	UoI-NCSA
"
RESTRICT="
	!test? (
		test
	)
"
SLOT="0/${SOVER}"
IUSE+="
${LLVM_COMPAT[@]/#/llvm_slot_}
clang +cpu +examples -fast-math gcc lto +openmp pthread tbb test
+video_cards_intel -xe
ebuild_revision_25
"
REQUIRED_USE+="
	^^ (
		clang
		gcc
	)
	kernel_Darwin? (
		^^ (
			pthread
			openmp
			tbb
		)
	)
	kernel_linux? (
		^^ (
			openmp
			pthread
			tbb
		)
	)
	lto? (
		|| (
			${LLVM_COMPAT[@]/#/llvm_slot_}
		)
	)
	^^ (
		${LLVM_COMPAT[@]/#/llvm_slot_}
	)
	|| (
		cpu
		video_cards_intel
		xe
	)
"

gen_llvm_depends() {
	local s
	for s in "${LLVM_COMPAT[@]}" ; do
		echo "
			llvm_slot_${s}? (
				llvm-core/clang:${s}=
				llvm-core/llvm:${s}=
				lto? (
					llvm-core/lld:${s}=
				)
				openmp? (
					>=llvm-runtimes/openmp-${s}:=
				)
				video_cards_intel? (
					>=dev-util/spirv-llvm-translator-${s}:${s}=
				)
			)
		"
	done
}

gen_omp_depends() {
	local s
	for s in "${LLVM_COMPAT[@]}" ; do
		echo "
			llvm_slot_${s}? (
				llvm-core/clang:${s}=
				llvm-core/llvm:${s}=
				>=llvm-runtimes/openmp-${s}:=
			)
		"
	done
}
RDEPEND="
	$(gen_llvm_depends)
	>=virtual/zlib-${ZLIB_PV}:=
	openmp? (
		clang? (
			$(gen_omp_depends)
		)
		gcc? (
			>=sys-devel/gcc-12:=[openmp]
		)
	)
	tbb? (
		>=dev-cpp/tbb-${TBB_PV}:=
	)
	video_cards_intel? (
		>=dev-libs/level-zero-1.20.2:=
	)
"
DEPEND="
	${RDEPEND}
"
# intel-vc-intrinsics should be live but relaxed
BDEPEND="
	${PYTHON_DEPS}
	>=sys-devel/bison-3.8.2
	>=sys-devel/flex-2.6.4
	video_cards_intel? (
		>=dev-util/spirv-llvm-translator-23.1.0
		>=dev-libs/intel-vc-intrinsics-0.25
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-1.28.2-llvm-v2.patch"
)

pkg_setup() {
	check-compiler-switch_start
	local s
	for s in "${LLVM_COMPAT[@]}" ; do
		if use "llvm_slot_${s}" ; then
			export LLVM_MAX_SLOT=${s}
			break
		fi
	done

	llvm_pkg_setup
	python-any-r1_pkg_setup
	uopts_setup
	libcxx-slot_verify
	if tc-is-clang ; then
		use clang || die "Enable the clang USE flag"
	fi
	if tc-is-gcc ; then
		use gcc || die "Enable the gcc USE flag"
	fi
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]]; then
		if in_iuse fallback-commit && use fallback-commit ; then
			export EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
		cd "${S}" || die
		local actual_pv=$(grep -r -e "ISPC_VERSION " "common/version.h" \
			| sed -e "s|dev||g" \
			| cut -f 2 -d '"')
	else
		unpack "${P}.tar.gz"
		if use bolt || use pgo ; then
			unpack "benchmark-${BENCHMARK_COMMIT:0:7}.tar.gz"
			unpack "gtest-${GTEST_COMMIT:0:7}.tar.gz"
			local d

			d="${S}/benchmarks/vendor/google/benchmark"
			mkdir -p "${d}" || die
			mv \
				"benchmark-${BENCHMARK_COMMIT}/"* \
				"${d}" \
				|| die
			ln -s \
				"${S}/benchmarks" \
				"${S}/benchmarks/benchmarks" \
				|| die

			d="${S}/ispcrt/tests/vendor/google/googletest"
			mkdir -p "${d}" || die
			mv \
				"googletest-${GTEST_COMMIT}/"* \
				"${d}" \
				|| die
		fi
	fi
	local actual_sover=$(grep -E -e "ISPC_VERSION_MAJOR" "${S}/common/version.h" | cut -f 3 -d " ")
	local expected_sover="${SOVER}"
	if ver_test "${actual_sover}" -ne "${expected_sover}" ; then
eerror "QA:  Update SOVER, INTERNAL_VERSION, or PV"
eerror "Actual SOVER:  ${actual_sover}"
eerror "Expected SOVER:  ${expected_sover}"
		die
	fi
}

src_prepare() {
	if use amd64; then
		# On amd64 systems, build system enables x86/i686 build too.
		# This ebuild doesn't even have multilib support, nor need it.
		# https://bugs.gentoo.org/730062
		ewarn "Removing auto-x86 build on amd64"
		sed -i \
			-e 's:set(target_arch "i686"):return():' \
			"cmake/GenerateBuiltins.cmake" \
			|| die
	fi

	cmake_src_prepare
	uopts_src_prepare
}

src_configure() { :; }

_src_configure_compiler() {
	local wants_llvm=0
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		if use "llvm_slot_${s}" ; then
			wants_llvm=1
			break
		fi
	done
	if use lto || (( ${wants_llvm} == 1 )) ; then
		export CC="${CHOST}-clang-${LLVM_SLOT}"
		export CXX="${CHOST}-clang++-${LLVM_SLOT}"
		export CPP="${CC} -E"
	else
		export CC=$(tc-getCC)
		export CXX=$(tc-getCXX)
		export CPP=$(tc-getCPP)
	fi
	strip-unsupported-flags
}

_src_configure() {
	local wants_llvm=0
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		if use "llvm_slot_${s}" ; then
			wants_llvm=1
			break
		fi
	done
	if use lto || (( ${wants_llvm} == 1 )) ; then
		export CC="${CHOST}-clang-${LLVM_SLOT}"
		export CXX="${CHOST}-clang++-${LLVM_SLOT}"
	else
		export CC=$(tc-getCC)
		export CXX=$(tc-getCXX)
	fi
	unset LD
	strip-unsupported-flags
	if ! has_version "llvm-core/llvm:${LLVM_SLOT}=[dump(+)]" ; then
		append-cppflags -DNDEBUG
	fi
einfo "CC:  ${CC}"
einfo "CXX:  ${CXX}"
	uopts_src_configure
	if use lto ; then
		filter-flags \
			'-flto=*' \
			'-fuse-ld=*' \
			'-Wl,-O3' \
			'-Wl,--lto-O3' \
			'-Wl,--icf=all'
		append-flags \
			'-flto=thin' \
			'-fuse-ld=lld'
		append-ldflags \
			'-Wl,-O3' \
			'-Wl,--lto-O3' \
			'-Wl,--icf=all'
	fi

	if use pgo && tc-is-clang ; then
		append-flags -mllvm -vp-counters-per-site=8
	fi

	check-compiler-switch_end
	if check-compiler-switch_is_flavor_slot_changed ; then
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi

	cflags-hardened_append

	local mycmakeargs=(
		-DARM_ENABLED=$(usex arm)
		-DBUILD_GPU=$(usex video_cards_intel)
		-DCMAKE_SKIP_RPATH=ON
		-DISPC_INCLUDE_EXAMPLES=OFF
		-DISPC_INCLUDE_RT=ON
		-DISPC_INCLUDE_TESTS=$(usex test)
		-DISPC_NO_DUMPS=ON
		-DISPCRT_BUILD_CPU=$(usex cpu)
		-DISPCRT_BUILD_GPU=$(usex video_cards_intel)
		-DISPCRT_BUILD_TESTS=$(usex test)
	)
	if is-flagq '-ffast-math' || is-flagq '-Ofast' || use fast-math ; then
		mycmakeargs+=(
			-DISPC_FAST_MATH=ON
		)
	fi

	if use pgo || use bolt ; then
		# These will need to be built in PGO phase for BOLT.
		mycmakeargs+=(
			-DISPC_INCLUDE_BENCHMARKS=ON
			-DBENCHMARK_ENABLE_INSTALL=ON
			-DISPC_INCLUDE_TESTS=ON
		)
	fi
	if use tbb ; then
		mycmakeargs+=(
			-DISPCRT_BUILD_TASK_MODEL="TBB"
		)
	elif use openmp ; then
		if tc-is-clang ; then
			if ! has_version "llvm-runtimes/openmp:$(clang-major-version)" ; then
eerror
eerror "You need to either switch to GCC or rebuild as"
eerror "llvm-runtimes/openmp:$(clang-major-version)"
eerror
				die
			fi
		fi
		tc-check-openmp
		mycmakeargs+=(
			-DISPCRT_BUILD_TASK_MODEL="OpenMP"
		)
	else
		mycmakeargs+=(
			-DISPCRT_BUILD_TASK_MODEL="Threads"
		)
	fi
	cmake_src_configure
}

_src_compile() {
einfo "BUILD_DIR:  ${BUILD_DIR}"
	cmake_src_compile
}

src_compile() {
	uopts_src_compile
}

train_trainer_custom() {
	local OPATH="${PATH}"
	export PATH="${S}_build:${PATH}" # The instrumented ispc is here.
	pushd "${S}_build" || die
		make check-all || true
		make ispc_benchmarks || true
		make test || true
	popd
	export PATH="${OPATH}"
}

src_test() {
	# Set the path to prevent using the already installed ispc.
	PATH="${BUILD_DIR}/bin:${PATH}" \
	"${EPYTHON}" ./run_tests.py \
		|| die "Testing failed under ${EPYTHON}"
}

src_install() {
	dobin "${BUILD_DIR}/bin/ispc"
	einstalldocs

	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		dodoc -r "examples"
	fi
	uopts_src_install
}

pkg_postinst() {
	uopts_pkg_postinst
}
