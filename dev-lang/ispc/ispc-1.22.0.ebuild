# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# For the version, see
# https://github.com/ispc/ispc/blob/main/common/version.h

CMAKE_MAKEFILE_GENERATOR="emake"
PYTHON_COMPAT=( python3_{10..11} )
LLVM_MAX_SLOT=18
LLVM_SLOTS=( 18 17 16 15 14 ) # See https://github.com/ispc/ispc/blob/v1.22.0/src/ispc_version.h
UOPTS_SUPPORT_EBOLT=0
UOPTS_SUPPORT_EPGO=0
UOPTS_SUPPORT_TBOLT=1
UOPTS_SUPPORT_TPGO=1
inherit cmake flag-o-matic python-any-r1 llvm toolchain-funcs uopts

if [[ ${PV} =~ 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ispc/ispc.git"
	IUSE+=" fallback-commit"
else
	BENCHMARK_COMMIT="e991355c02b93fe17713efe04cbc2e278e00fdbd"
	GTEST_COMMIT="bf0701daa9f5b30e5882e2f8f9a5280bcba87e77"
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
SLOT="0"
IUSE+="
${LLVM_SLOTS[@]/#/llvm-}
+cpu +examples -fast-math lto +openmp pthread tbb test +video_cards_intel -xe
r1
"
REQUIRED_USE+="
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
			${LLVM_SLOTS[@]/#/llvm-}
		)
	)
	^^ (
		${LLVM_SLOTS[@]/#/llvm-}
	)
	|| (
		cpu
		video_cards_intel
		xe
	)
"
RESTRICT="
	!test? (
		test
	)
"

gen_llvm_depends() {
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
		llvm-${s}? (
			sys-devel/clang:${s}=
			lto? (
				sys-devel/lld:${s}
			)
			openmp? (
				sys-libs/libomp:${s}
			)
		)
		"
	done
}

gen_omp_depends() {
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
		(
			sys-devel/clang:${s}=
			sys-libs/libomp:${s}
		)
		"
	done
}

# Some versions obtained from CI.
# U 22.04
RDEPEND="
	>=sys-libs/ncurses-6.3
	>=sys-libs/zlib-1.2.11
	openmp? (
		|| (
			$(gen_omp_depends)
			>=sys-devel/gcc-11.3[openmp]
		)
	)
	tbb? (
		>=dev-cpp/tbb-2021.5.0:0
	)
	video_cards_intel? (
		>=dev-libs/level-zero-1.10.0
	)
	|| (
		$(gen_llvm_depends)
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${PYTHON_DEPS}
	>=sys-devel/bison-3.8.2
	>=sys-devel/flex-2.6.4
	video_cards_intel? (
		>=dev-util/spirv-llvm-translator-15
		>=dev-libs/intel-vc-intrinsics-0.12
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-1.20.0-llvm.patch"
	"${FILESDIR}/${PN}-1.22.0-curses-cmake.patch"
)

CMAKE_BUILD_TYPE="RelWithDebInfo"

pkg_setup() {
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		if use llvm-${s} ; then
			export LLVM_MAX_SLOT=${s}
			break
		fi
	done

	llvm_pkg_setup
	python-any-r1_pkg_setup
	uopts_setup
}

src_unpack() {
	if [[ ${PV} =~ 9999 ]]; then
		use fallback-commit && export EGIT_COMMIT="14bd04aa7e68cd33eb1d96b33058cb64d7ef76f4" # May 5, 2023
		git-r3_fetch
		git-r3_checkout
		cd "${S}" || die
		local actual_pv=$(grep -r -e "ISPC_VERSION " common/version.h \
			| sed -e "s|dev||g" \
			| cut -f 2 -d '"')
		local expected_pv=$(ver_cut 1-3 ${PV})
		if ver_test "${actual_pv}" -ne "${expected_pv}" ; then
eerror
eerror "Version mismatch detected that might result in broken patches or"
eerror "incompatible *DEPENDs."
eerror
eerror "Expected version:\t${expected_pv}"
eerror "Actual version:\t${actual_pv}"
eerror
eerror "Use the fallback-commit USE flag to continue."
eerror
			die
		fi
	else
		unpack "${P}.tar.gz"
		if use bolt || use pgo ; then
			unpack "benchmark-${BENCHMARK_COMMIT:0:7}.tar.gz"
			unpack "gtest-${GTEST_COMMIT:0:7}.tar.gz"
			local d

			d="${S}/benchmarks/vendor/google/benchmark"
			mkdir -p "${d}" || die
			mv "benchmark-${BENCHMARK_COMMIT}/"* "${d}" || die
			ln -s "${S}/benchmarks" "${S}/benchmarks/benchmarks" || die

			d="${S}/ispcrt/tests/vendor/google/googletest"
			mkdir -p "${d}" || die
			mv "googletest-${GTEST_COMMIT}/"* "${d}" || die
		fi
	fi
}

src_prepare() {
	if use amd64; then
		# On amd64 systems, build system enables x86/i686 build too.
		# This ebuild doesn't even have multilib support, nor need it.
		# https://bugs.gentoo.org/730062
		ewarn "Removing auto-x86 build on amd64"
		sed -i -e 's:set(target_arch "i686"):return():' cmake/GenerateBuiltins.cmake || die
	fi

	cmake_src_prepare
	uopts_src_prepare
}

src_configure() { :; }

_src_configure() {
	local wants_llvm=0
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		if use llvm-${s} ; then
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
	if ! has_version "sys-devel/llvm:${LLVM_SLOT}=[dump(+)]" ; then
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
		if ! is-flagq '-O3' ; then
ewarn "PGO has -O3 in CFLAGS as default ON upstream but not currently as a per-package CFLAGS."
		fi
	else
		if ! is-flagq '-O3' ; then
ewarn "PGO has -O3 in CFLAGS as default ON upstream for release builds but not currently as a per-package CFLAGS."
		fi
	fi
	if use pgo || use bolt ; then
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
			if ! has_version "sys-libs/libomp:$(clang-major-version)" ; then
eerror
eerror "You need to either switch to GCC or rebuild as"
eerror "sys-libs/libomp:$(clang-major-version)"
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
	# Inject path to prevent using system ispc
	PATH="${BUILD_DIR}/bin:${PATH}" ${EPYTHON} ./run_tests.py || die "Testing failed under ${EPYTHON}"
}

src_install() {
	dobin "${BUILD_DIR}"/bin/ispc
	einstalldocs

	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples
	fi
	uopts_src_install
}

pkg_postinst() {
	uopts_pkg_postinst
}
