# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LLVM_MAX_SLOT=${PV%%.*}
PYTHON_COMPAT=( python3_{9..10} )

inherit flag-o-matic cmake-multilib linux-info llvm llvm.org python-any-r1

DESCRIPTION="Multi Level Intermediate Representation for LLVM"
HOMEPAGE="https://openmp.llvm.org"
LICENSE="
	Apache-2.0-with-LLVM-exceptions
	|| (
		UoI-NCSA
		MIT
	)
"
SLOT="${LLVM_MAJOR}/${LLVM_SOABI}"
KEYWORDS="
~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x64-macos
"
IUSE="
	debug test
"
REQUIRED_USE="
"
RDEPEND="
	sys-devel/clang:${SLOT}
	sys-devel/llvm:${SLOT}
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	sys-devel/clang:${SLOT}
	sys-devel/llvm:${SLOT}
"
RESTRICT="
	test
"
LLVM_COMPONENTS=(
	"mlir"
	"llvm/include"
)
#LLVM_PATCHSET="${PV/_/-}"
LLVM_USE_TARGETS="llvm"
llvm.org_set_globals

python_check_deps() {
	python_has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	llvm_pkg_setup # Init LLVM_SLOT
	use test && python-any-r1_pkg_setup
}

multilib_src_configure() {
	# Disallow newer clangs versions when producing .o files.
	einfo "LLVM_SLOT=${LLVM_SLOT}"
	einfo "PATH=${PATH} (before)"
	export PATH=$(echo "${PATH}" \
		| tr ":" "\n" \
		| sed -E -e "/llvm\/[0-9]+/d" \
		| tr "\n" ":" \
		| sed -e "s|/opt/bin|/opt/bin:/usr/lib/llvm/${LLVM_SLOT}/bin|g")
	einfo "PATH=${PATH} (after)"

	# LTO causes issues in other packages building, #870127
	filter-lto

	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"

	append-cppflags -I"${WORKDIR}/llvm/include"

	local libdir="$(get_libdir)"
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}"
		-DLLVM_LINK_LLVM_DYLIB=ON
		-DMLIR_LINK_MLIR_DYLIB=ON
	)

	cmake_src_configure
}

multilib_src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1

	cmake_build check-mlir
}

# OILEDMACHINE-OVERLAY-STATUS:  build-needs-test
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
