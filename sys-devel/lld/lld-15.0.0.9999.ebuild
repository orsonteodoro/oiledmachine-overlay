# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EBOLT_DISABLE_BDEPEND=1
PYTHON_COMPAT=( python3_{8..11} )
inherit cmake ebolt epgo flag-o-matic llvm llvm.org python-any-r1

DESCRIPTION="The LLVM linker (link editor)"
HOMEPAGE="https://llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA"
SLOT="0"
KEYWORDS=""
IUSE="debug test"
IUSE+=" hardened"
REQUIRED_USE+=" hardened? ( !test )"
PROPERTIES="live"
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
llvm.org_set_globals
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
	epgo_setup
	ebolt_setup
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
	epgo_src_prepare
	ebolt_src_prepare
}

src_configure() {
	PGO_PHASE=$(epgo_get_phase)
	BOLT_PHASE=$(ebolt_get_phase)
	epgo_src_configure
	ebolt_src_configure
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

src_test() {
	local -x LIT_PRESERVES_TMP=1
	cmake_build check-lld
}

src_install() {
	BOLT_PHASE=$(ebolt_get_phase)
	cmake_src_install
	epgo_src_install
	ebolt_src_install
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-MOD-TYPE:  patches, hardened, full-relo, versioning-mod, pgo, bolt
