# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
CMAKE_BUILD_TYPE=Release
CMAKE_MAKEFILE_GENERATOR=ninja
inherit cmake llvm python-any-r1

DESCRIPTION="A superoptimizer for LLVM IR"
HOMEPAGE="https://github.com/google/souper"
LICENSE="Apache-2.0
	BSD
	MIT
	UoI-NCSA
"
# Third party licenses:
# klee - UoI-NCSA, BSD
# alive2 - MIT
# llvm-project-disable-peepholes (see llvm ebuilds) - Apache-2.0-with-LLVM-exceptions

# No KEYWORDS for live ebuilds (or snapshotted ones)

SLOT="0"
IUSE+=" doxygen gdb support-tools test"
# U 20.04
# See also
# https://github.com/google/souper/blob/69536e134478ae1d44c912c90c3db96ad06437c1/Dockerfile
# https://github.com/google/souper/blob/69536e134478ae1d44c912c90c3db96ad06437c1/build_deps.sh
LLVM_SLOTS=(15 14 13 12)
gen_iuse() {
	local s
	local o
	for s in ${LLVM_SLOTS[@]} ; do
		o+="
			llvm-${s}
		"
	done
	echo "${o}"
}
IUSE+=" $(gen_iuse)"
# Both assertions (debug) and dump are default ON upstream,
# but in the distro, both are OFF for the llvm package by default.
IUSE+=" -debug -dump +redis r1"
REQUIRED_USE+="
	|| ( $(gen_iuse) )
	support-tools? ( redis )
"
gen_rdepends() {
	local s
	local o
	for s in ${LLVM_SLOTS[@]} ; do
		o+="
			llvm-${s}? (
				sys-devel/clang:${s}
				sys-devel/llvm:${s}[debug?,dump?,souper]
				>=sys-devel/lld-${s}
			)
		"
	done
	echo "${o}"
}
RDEPEND+="
	|| ( $(gen_rdepends) )
	>=dev-lang/perl-5.30.0
	>=dev-libs/gmp-6.2.0
	>=dev-util/re2c-1.3
	>=sci-mathematics/z3-4.8.11.0
	gdb? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'sys-devel/gdb[${PYTHON_USEDEP}]')
	)
	redis? (
		>=dev-libs/hiredis-1.0.1[static-libs]
		>=dev-db/redis-5.0.7
	)
"
DEPEND+="
	${DEPEND}
"
# Referenced packages but not used
# >=app-misc/ca-certificates-20210119
# >=dev-vcs/git-2.25.1
# >=dev-vcs/subversion-1.13.0
BDEPEND+="
	|| ( $(gen_rdepends) )
	>=dev-util/cmake-3.16.3
	>=dev-util/ninja-1.1.0
	>=sys-devel/autoconf-2.69
	>=sys-devel/automake-1.16.1
	>=sys-devel/libtool-2.4.6
	>=sys-devel/gcc-10.3.0
	>=sys-devel/make-4.2.1
	virtual/libc
	doxygen? ( >=app-doc/doxygen-1.8.17 )
	test? (
		${PYTHON_DEPS}
		>=dev-cpp/gtest-1.10.0
		>=dev-lang/perl-5.30.0
		>=dev-lang/python-3.8.2
		>=dev-python/lit-10
		>=dev-util/valgrind-3.15.0
	)
"
EGIT_COMMIT="69536e134478ae1d44c912c90c3db96ad06437c1"
EGIT_COMMIT_KLEE="0ba95edbad26fe70c8132f0731778d94f9609874" # HEAD (Jan 7, 2022) as obtained from Feb 8, 2022.
ALIVE2_PV="2"
# Prefetch tarballs to speed up rebuilds
# Track
# https://github.com/rsas/klee/commits/pure-bv-qf-llvm-7.0
# for newer pure-bv-qf-llvm-7.0
SRC_URI="
https://github.com/google/souper/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}-${EGIT_COMMIT:0:7}.tar.gz
https://github.com/klee/klee/archive/0ba95edbad26fe70c8132f0731778d94f9609874.tar.gz
	-> klee-${EGIT_COMMIT_KLEE:0:7}.tar.gz
https://github.com/manasij7479/alive2/archive/refs/tags/v${ALIVE2_PV}.tar.gz
	-> alive2-v${ALIVE2_PV}.tar.gz
"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
PATCHES=(
	"${FILESDIR}/${PN}-9999_pre20210629-use-system-packages.patch"
	"${FILESDIR}/${PN}-9999_pre20210629-install.patch"
	"${FILESDIR}/${PN}-9999_pre20210629-klee-header-paths-for-klee-0ba95ed.patch"
	"${FILESDIR}/${PN}-9999_pre20210629-llvm13-compat.patch"
	"${FILESDIR}/${PN}-9999_pre20210629-disable-llvm-version-change.patch"
	"${FILESDIR}/${PN}-9999_pre20210629-constraintmanager-klee-0ba95ed.patch"
	"${FILESDIR}/${PN}-9999_pre20210629-KLEEBuilder-use-arraycache.patch"
	#"${FILESDIR}/temp-disable.patch"							# didn't build llvm with disable-peephole patch yet
	"${FILESDIR}/${PN}-9999_pre20210629-optional-redis.patch"
	"${FILESDIR}/alive2-v2-disable-unused-variables.patch"
	"${FILESDIR}/${PN}-9999_pre20210629-llvm-version-get-and-define.patch"
	"${FILESDIR}/${PN}-9999_pre20210629-llvm-dump-optional.patch"
	"${FILESDIR}/${PN}-9999_pre20210629-use-clang-monolithic-lib.patch"
	"${FILESDIR}/${PN}-9999_pre20210629-report_fatal_error-changes-llvm14rc1.patch"
	"${FILESDIR}/${PN}-9999_pre20210629-optimizationlevel-llvm14rc1.patch"
	"${FILESDIR}/${PN}-9999_pre20210629-check-stdcxx20-flag.patch"
	"${FILESDIR}/${PN}-9999_pre20210629-custom-docs-prefix.patch"
)
MIN_CXX="20"

pkg_setup()
{
	ewarn "This ebuild is a Work In Progress (WIP) and is incomplete."
	if use llvm-15 ; then
		ewarn "LLVM 15 has not been compile time tested."
	fi
	if use test ; then
		ewarn "The test USE flag has not been tested."
	fi
	ewarn "This package with compatibility patches has not been unit tested yet."
	python-any-r1_pkg_setup
}

src_unpack() {
	unpack ${A}
	mkdir -p "${S}/third_party" || die
	mv "${WORKDIR}/klee-${EGIT_COMMIT_KLEE}" "${S}/third_party/klee" || die
	mv "${WORKDIR}/alive2-${ALIVE2_PV}" "${S}/third_party/alive2" || die
}

src_prepare() {
	cmake_src_prepare
	pushd "${S}/third_party/klee" || die
		# Most commits have been upstreamed or a better commit provided.
		local KLEE_RSAS_PURE_BV_QF=(
			"${FILESDIR}/0000_klee_rsas_pure-bv-qf-llvm-7.0.patch"
		)
		eapply ${KLEE_RSAS_PURE_BV_QF[@]}
	popd
	if ! use redis ; then
		sed -i -e "s|USE_EXTERNAL_CACHE=1|USE_EXTERNAL_CACHE=0|g" \
			"${S}/utils/sclang.in" || die
	fi
}

src_configure() { :; }

_configure_compiler() {
	# Make sure the bitcode is the same or highest especially if LTOing.
	local clang_v_maj=$(ver_cut 1 $(best_version "sys-devel/clang:${s}" | sed -e "s|sys-devel/clang-||"))
	local lld_v_maj=$(ver_cut 1 $(best_version "sys-devel/lld" | sed -e "s|sys-devel/lld-||"))
	export CC="clang-${s}"
	export CXX="clang++-${s}"
	einfo "CC=${CC}"
	einfo "CXX=${CXX}"
	"${CXX}" --version || die
	v_major_lld=$(ver_cut 1 "${v_major_lld}")
	PATH=$(echo "${PATH}" | tr ":" "\n" | sed -e "/llvm/d" | tr "\n" ":" | sed -e 's|:$||')
	export PATH="${PATH}:$(get_llvm_prefix ${clang_v_maj})/bin:$(get_llvm_prefix ${lld_v_maj})/bin"
	einfo "PATH=${PATH}"
	test-flags-CXX "-std=c++${MIN_CXX}" 2>/dev/null 1>/dev/null \
		|| die "You cannot use the llvm-${s} USE flag because ${CXX} is not c++${MIN_CXX} compatible."
}

_configure_souper() {
	if (( ${s} != 12 )) ; then
ewarn
ewarn "Compatibility with LLVM ${s} is experimental.  Use the llvm-12 USE flag"
ewarn "to match the upstream supported LLVM version."
ewarn
	fi
	local mycmakeargs=(
		-DBUILD_DOCUMENTATION=$(usex doxygen)
		-DCLANG_INCLUDE_DIR="/usr/lib/llvm/${s}/include/clang"
		-DCMAKE_INSTALL_BINDIR="bin"
		-DCMAKE_INSTALL_DATAROOTDIR="/usr/share"
		-DCMAKE_INSTALL_LIBDIR="$(get_libdir)"
		-DCMAKE_INSTALL_PREFIX="/usr/lib/souper/${s}"
		-DCMAKE_INSTALL_DOCS="/usr/share/doc/${P}"
		-DCMAKE_INSTALL_RUNSTATEDIR="/var/run"
		-DFEATURE_EXTERNAL_CACHE=$(usex redis)
		-DINSTALL_GDB_PRETTY_PRINT=$(usex gdb)
		-DINSTALL_SUPPORT_TOOLS=$(usex support-tools)
		-DLLVM_CONFIG_PATH="/usr/lib/llvm/${s}/bin/llvm-config"
		-DTEST_SYNTHESIS=$(usex test)
	)
	cmake_src_configure
}

build_alive2() {
	einfo "Building internal dep alive"
	local mycmakeargs=(
		-DZ3_INCLUDE_DIR="/usr/include"
		-DZ3_LIBRARIES="/usr/$(get_libdir)/libz3.so"
	)
	export CMAKE_USE_DIR="${S}/third_party/alive2"
	export BUILD_DIR="${S}/third_party/alive2-build"
	pushd "${CMAKE_USE_DIR}" || die
		git init || die
		touch dummy.txt || die
		git config --local user.email "you@example.com"
		git config --local user.name "John Doe"
		git add dummy.txt || die
		git commit -m "alive2 v${ALIVE2_PV}" || die
		git tag v${ALIVE2_PV} || die
	popd
	cmake_src_configure
	cmake_src_compile
}

src_compile() {
	for s in ${LLVM_SLOTS[@]} ; do
		if use "llvm-${s}" ; then
			_configure_compiler
			build_alive2
			export CMAKE_USE_DIR="${S}"
			export BUILD_DIR="${WORKDIR}/${P}_llvm${s}_build"
			_configure_souper
			cmake_src_compile
		fi
	done
}

src_install() {
	for s in ${LLVM_SLOTS[@]} ; do
		if use "llvm-${s}" ; then
			export BUILD_DIR="${WORKDIR}/${P}_llvm${s}_build"
			cmake_src_install
		fi
	done

	if ! use redis ; then
		cat <<-EOF > "${T}"/50${P}-redis
			SOUPER_NO_EXTERNAL_CACHE=1
		EOF
		doenvd "${T}"/50${P}-redis
	fi
	dodoc LICENSE
}

src_test() {
	cd "${BUILD_DIR}" || die
	./run_lit || die
}

pkg_postinst() {
	env-update
	if use redis ; then
ewarn
ewarn "The redis cache must stopped and dumped each time this package"
ewarn "bumped to a newer version or commit."
ewarn
ewarn
ewarn "The redis server should be listening in port 6379."
ewarn
	fi
}
