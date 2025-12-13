# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="CastXML-${PV}"

CXX_STANDARD=17
CFLAGS_HARDENED_USE_CASES="untrusted-data"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

inherit cflags-hardened cmake libcxx-slot libstdcxx-slot llvm-r1

KEYWORDS="amd64 ~arm ~riscv ~x86"
S="${WORKDIR}/${MY_P}"
SRC_URI="
https://github.com/CastXML/CastXML/archive/v${PV}.tar.gz
	-> ${MY_P}.tar.gz
"

DESCRIPTION="C-family abstract syntax tree XML output tool"
HOMEPAGE="https://github.com/CastXML/CastXML"
LICENSE="Apache-2.0"
RESTRICT="
	!test? (
		test
	)
"
SLOT="0"
IUSE="
+man test
ebuild_revision_4
"
DEPEND="
	$(llvm_gen_dep "
		llvm-core/clang:\${LLVM_SLOT}[${LIBSTDCXX_USEDEP}]
		llvm-core/clang:=
	")
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	man? (
		dev-python/sphinx
	)
"

pkg_setup() {
	llvm-r1_pkg_setup
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_configure() {
	cflags-hardened_append
	local mycmakeargs=(
		-DCastXML_INSTALL_DOC_DIR="share/doc/${PF}"
		-DCastXML_INSTALL_MAN_DIR="share/man"
		-DSPHINX_MAN="$(usex man)"
		-DSPHINX_HTML=OFF
		-DBUILD_TESTING="$(usex test)"
	)
	cmake_src_configure
}

src_test() {
	local CMAKE_SKIP_TESTS=(
		# Regex doesn't match the full build path
		"cmd.input-missing"
		"cmd.rsp-missing"

		# Gets confused by extra #defines we set for hardening etc (bug #891813)
		"cmd.cc-gnu-src-cxx-E"
		"cmd.cc-gnu-src-cxx-cmd"
		"cmd.cc-gnu-c-src-c-E"
		"cmd.cc-gnu-c-src-c-cmd"
		"cmd.cc-gnu-tgt-i386-opt-E"
		"cmd.cc-gnu-c-tgt-i386-opt-E"
	)

	cmake_src_test
}
