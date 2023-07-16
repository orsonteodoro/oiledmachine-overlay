# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
LLVM_MAX_SLOT=14
LLVM_SLOTS=( 14 13 ) # See https://github.com/ispc/ispc/blob/v1.17.0/src/ispc_version.h
inherit cmake python-any-r1 llvm

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ispc/ispc.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~x86"
fi

DESCRIPTION="Intel SPMD Program Compiler"
HOMEPAGE="https://ispc.github.io/"
LICENSE="
	BSD
	BSD-2
	UoI-NCSA
"
SLOT="0"
IUSE+="
	${LLVM_SLOTS[@]/#/llvm-}
	examples
"
REQUIRED_USE+="
	^^ (
		${LLVM_SLOTS[@]/#/llvm-}
	)
"

gen_llvm_depends() {
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
		llvm-${s}? (
			sys-devel/clang:${s}=
		)
		"
	done
}

RDEPEND="
	|| (
		$(gen_llvm_depends)
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${PYTHON_DEPS}
	sys-devel/bison
	sys-devel/flex
"

PATCHES=(
	"${FILESDIR}/${PN}-1.18.0-llvm.patch"
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
	local mycmakeargs=(
		-DARM_ENABLED=$(usex arm)
		-DCMAKE_SKIP_RPATH=ON
		-DISPC_NO_DUMPS=ON
	)
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
