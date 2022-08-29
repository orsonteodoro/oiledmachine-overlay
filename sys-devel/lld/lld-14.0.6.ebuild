# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
UOPTS_BOLT_DISABLE_BDEPEND=1
UOPTS_SUPPORT_TBOLT=0
UOPTS_SUPPORT_TPGO=0
inherit cmake flag-o-matic llvm llvm.org python-any-r1 uopts
inherit llvm-ebuilds

DESCRIPTION="The LLVM linker (link editor)"
HOMEPAGE="https://llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="debug test"
IUSE+=" hardened"
REQUIRED_USE+=" hardened? ( !test )"
RESTRICT="!test? ( test )"

RDEPEND="~sys-devel/llvm-${PV}"
DEPEND="${RDEPEND}"
BDEPEND="
	ebolt? (
		>=sys-devel/llvm-14[bolt]
	)
	test? (
		>=dev-util/cmake-3.16
		$(python_gen_any_dep "~dev-python/lit-${PV}[\${PYTHON_USEDEP}]")
	)
"

LLVM_COMPONENTS=( lld cmake libunwind/include/mach-o )
LLVM_TEST_COMPONENTS=( llvm/utils/{lit,unittest} )
LLVM_USE_TARGETS=llvm
llvm.org_set_globals

REQUIRED_USE+="
	amd64? ( llvm_targets_X86 )
	arm? ( llvm_targets_ARM )
	arm64? ( llvm_targets_AArch64 )
	m68k? ( llvm_targets_M68k )
	mips? ( llvm_targets_Mips )
	ppc? ( llvm_targets_PowerPC )
	ppc64? ( llvm_targets_PowerPC )
	riscv? ( llvm_targets_RISCV )
	sparc? ( llvm_targets_Sparc )
	x86? ( llvm_targets_X86 )
"

gen_rdepend() {
	local f
	for f in ${ALL_LLVM_TARGET_FLAGS[@]} ; do
		echo  "
			~sys-devel/llvm-${PV}:$(ver_cut 1 ${PV})=[${f}=]
		"
	done
}
RDEPEND+=" "$(gen_rdepend)

HARDENED_PATCHES=(
	"${FILESDIR}/clang-12.0.1-enable-full-relro-by-default.patch"
	"${FILESDIR}/clang-12.0.1-version-info.patch"
)

python_check_deps() {
	has_version -b "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	LLVM_MAX_SLOT=${PV%%.*} llvm_pkg_setup
	use test && python-any-r1_pkg_setup
	uopts_setup

# See https://bugs.gentoo.org/767700
einfo
einfo "To remove the hard USE mask for llvm_targets_*, do:"
einfo
	local t
	for t in ${ALL_LLVM_TARGET_FLAGS[@]} ; do
einfo "echo \"${CATEGORY}/${PN} -${t}\" >> ${EROOT}/etc/portage/profile/package.use.force"
	done
	for t in ${ALL_LLVM_EXPERIMENTAL_TARGETS[@]/#/llvm_targets_} ; do
einfo "echo \"${CATEGORY}/${PN} -${t}\" >> ${EROOT}/etc/portage/profile/package.use.mask"
	done
einfo
einfo "However, some packages still need some or all of these.  Some are"
einfo "mentioned in bug #767700."
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

src_prepare() {
	llvm.org_src_prepare
	if use hardened ; then
		ewarn "The hardened USE flag and Full RELRO default ON patch is in testing."
		eapply ${HARDENED_PATCHES[@]}
	fi
	uopts_src_prepare
}

_src_configure() {
	llvm-ebuilds_fix_toolchain
	uopts_src_configure
	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"

	use elibc_musl && append-ldflags -Wl,-z,stack-size=2097152

	local mycmakeargs=(
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
	uopts_src_compile
}

src_test() {
	local -x LIT_PRESERVES_TMP=1
	cmake_build check-lld
}

src_install() {
	cmake_src_install
	uopts_src_install
}

pkg_postinst() {
	uopts_pkg_postinst
einfo
einfo "See metadata.xml or \`epkginfo -x =${CATEGORY}/${P}::oiledmachine-overlay\`"
einfo "for a possible PGO+BOLT trainer script"
einfo
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-MOD-TYPE:  patches, hardened, full-relo, versioning-mod, pgo, bolt
