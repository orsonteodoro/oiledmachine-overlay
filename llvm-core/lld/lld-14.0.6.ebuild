# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( "python3_"{9..11} )

inherit cmake flag-o-matic llvm llvm.org python-any-r1 toolchain-funcs
inherit llvm-ebuilds

KEYWORDS="
amd64 arm arm64 ~ppc ppc64 ~riscv x86
"

DESCRIPTION="The LLVM linker (link editor)"
HOMEPAGE="https://llvm.org/"
LICENSE="
	Apache-2.0-with-LLVM-exceptions
	UoI-NCSA
"
SLOT="${LLVM_MAJOR}/${LLVM_SOABI}"
IUSE="
debug default-full-relro default-no-relro +default-partial-relro hardened
hardened-compat test
ebuild-revision-1
"
REQUIRED_USE+="
	^^ (
		default-full-relro
		default-no-relro
		default-partial-relro
	)

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

	default-full-relro? (
		!test
	)
	default-no-relro? (
		!test
	)
	hardened? (
		!test
		default-full-relro
	)
"
RDEPEND="
	!llvm-core/lld:0
	sys-libs/zlib:=
	~llvm-core/llvm-${PV}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	~llvm-core/llvm-${PV}
	test? (
		>=dev-build/cmake-3.16
		$(python_gen_any_dep ">=dev-python/lit-${PV}[\${PYTHON_USEDEP}]")
	)
"
RESTRICT="
	!test? (
		test
	)
"
LLVM_COMPONENTS=(
	"lld"
	"cmake"
	"libunwind/include/mach-o"
)
LLVM_TEST_COMPONENTS=(
	"llvm/utils/"{"lit","unittest"}
)
LLVM_USE_TARGETS="llvm"
llvm.org_set_globals

gen_rdepend() {
	local f
	for f in ${ALL_LLVM_TARGET_FLAGS[@]} ; do
		echo  "
			~llvm-core/llvm-${PV}:${LLVM_MAJOR}=[${f}=]
		"
	done
}
RDEPEND+=" "$(gen_rdepend)

python_check_deps() {
	python_has_version ">=dev-python/lit-${PV}[${PYTHON_USEDEP}]"
}

pkg_setup() {
	LLVM_MAX_SLOT=${LLVM_MAJOR} llvm_pkg_setup
	use test && python-any-r1_pkg_setup

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
einfo "See sys-devel/clang/metadata.xml for details on PGO/BOLT optimization."
einfo
}

src_unpack() {
	llvm.org_src_unpack

	# Directory ${WORKDIR}/llvm does not exist with USE="-test",
	# but LLVM_MAIN_SRC_DIR="${WORKDIR}/llvm" is set below,
	# and ${LLVM_MAIN_SRC_DIR}/../libunwind/include is used by build system
	# (lld/MachO/CMakeLists.txt) and is expected to be resolvable
	# to existent directory ${WORKDIR}/libunwind/include.
	mkdir -p "${WORKDIR}/llvm" || die
}

eapply_hardened() {
ewarn "The hardened USE flag and Full RELRO default ON patch is in testing."
	local hardened_flags=""
	if use default-full-relro ; then
		eapply "${FILESDIR}/clang-12.0.1-enable-full-relro-by-default.patch"
		hardened_flags="Full RELRO"
	fi
	if use default-no-relro ; then
		eapply "${FILESDIR}/clang-12.0.1-disable-relro-by-default.patch"
		hardened_flags="NO RELRO"
	fi
	if use default-partial-relro ; then
		hardened_flags="Partial RELRO"
	fi
	if use hardened || use hardened-compat ; then
		eapply "${FILESDIR}/clang-12.0.1-version-info.patch"
		sed -i -e "s|__HARDENED_FLAGS__|${hardened_flags}|g" \
			"ELF/Driver.cpp" || die
	fi
}

src_prepare() {
	llvm.org_src_prepare
	eapply_hardened
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
	# ODR violations (https://github.com/llvm/llvm-project/issues/83529, bug #922353)
	filter-lto

	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"

	use elibc_musl && append-ldflags -Wl,-z,stack-size=2097152

	# For PGO
	if tc-is-gcc ; then
# error: number of counters in profile data for function '...' does not match its profile data (counter 'arcs', expected 7 and have 13) [-Werror=coverage-mismatch]
# The PGO profiles are isolated.  The Code is the same.
		append-flags -Wno-error=coverage-mismatch
	fi

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}"
		-DBUILD_SHARED_LIBS=ON
		-DLLVM_INCLUDE_TESTS=$(usex test)
		-DLLVM_MAIN_SRC_DIR="${WORKDIR}/llvm"
	)
	use test && mycmakeargs+=(
		-DLLVM_BUILD_TESTS=ON
		-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
		-DLLVM_LIT_ARGS="$(get_lit_flags)"
		-DPython3_EXECUTABLE="${PYTHON}"
	)
	cmake_src_configure
}

_src_compile() {
	cmake_src_compile
}

src_compile() {
	_src_configure_compiler
	_src_configure
	_src_compile
}

src_test() {
	local -x LIT_PRESERVES_TMP=1
	cmake_build check-lld
}

src_install() {
	cmake_src_install
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-MOD-TYPE:  patches, hardened, full-relo, versioning-mod, pgo, bolt