# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# For the version, see
# https://github.com/ispc/ispc/blob/main/common/version.h

PYTHON_COMPAT=( python3_{8..10} )
LLVM_MAX_SLOT=15
LLVM_SLOTS=( 15 14 13 ) # See https://github.com/ispc/ispc/blob/v1.19.0/src/ispc_version.h
inherit cmake flag-o-matic python-any-r1 llvm toolchain-funcs

if [[ ${PV} =~ 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ispc/ispc.git"
	IUSE+=" fallback-commit"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
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
	+cpu +examples -fast-math +gpu +openmp pthread tbb test -xe
"
REQUIRED_USE+="
	kernel_Darwin? (
		|| (
			pthread
			openmp
			tbb
		)
	)
	kernel_linux? (
		|| (
			openmp
			pthread
			tbb
		)
	)
	^^ (
		${LLVM_SLOTS[@]/#/llvm-}
	)
	^^ (
		cpu
		gpu
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
			openmp? (
				=sys-libs/libomp-${s}*
			)
		)
		"
	done
}

# U 22.04
RDEPEND="
	>=sys-libs/ncurses-6.3
	>=sys-libs/zlib-1.2.11
	gpu? (
		>=dev-libs/level-zero-1.9.4
	)
	openmp? (
		|| (
			sys-devel/gcc[openmp]
			sys-libs/libomp
		)
	)
	tbb? (
		>=dev-cpp/tbb-2021.5.0:0
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
"

PATCHES=(
	"${FILESDIR}/${PN}-1.19.0-llvm.patch"
	"${FILESDIR}/${PN}-1.18.1-curses-cmake.patch"
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
}

src_unpack() {
	if [[ ${PV} =~ 9999 ]]; then
		use fallback-commit && export EGIT_COMMIT="09bae5fa6c03cc379c549d52f3660bdaa1b53b8c" # Dec 16, 2022
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
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
}

src_configure() {
	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	local mycmakeargs=(
		-DARM_ENABLED=$(usex arm)
		-DBUILD_GPU=$(usex gpu)
		-DCMAKE_SKIP_RPATH=ON
		-DISPC_INCLUDE_EXAMPLES=OFF
		-DISPC_INCLUDE_RT=ON
		-DISPC_INCLUDE_TESTS=$(usex test)
		-DISPC_NO_DUMPS=ON
		-DISPCRT_BUILD_CPU=$(usex cpu)
		-DISPCRT_BUILD_GPU=$(usex gpu)
		-DISPCRT_BUILD_TESTS=$(usex test)
	)
	if is-flagq '-ffast-math' || is-flagq '-Ofast' || use fast-math ; then
		mycmakeargs+=(
			-DISPC_FAST_MATH=ON
		)
	fi
	if use tbb ; then
		mycmakeargs+=(
			-DISPCRT_BUILD_TASK_MODEL="TBB"
		)
	elif use openmp ; then
		if tc-is-clang ; then
			if ! has_version "=sys-libs/libomp-$(clang-major-version)" ; then
eerror
eerror "You need to either switch to GCC or rebuild as"
eerror "=sys-libs/libomp-$(clang-major-version)*"
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
}
