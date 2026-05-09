# Copyright 2012-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="OpenCL-Benchmark"
CXX_STANDARD=17

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}" # 18, 19
)

inherit libcxx-slot libstdcxx-slot

KEYWORDS="~amd64"
S="${WORKDIR}/${MY_PN}-${PV}"
SRC_URI="
https://github.com/ProjectPhysX/OpenCL-Benchmark/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="A small OpenCL benchmark program to measure peak GPU/CPU performance."
HOMEPAGE="https://github.com/ProjectPhysX/OpenCL-Benchmark"
LICENSE="ZLIB"
SLOT="0"
IUSE="ebuild_revision_1"
RDEPEND="
	virtual/opencl
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	sys-devel/gcc
"
DOCS=( "CITATION.cff" "README.md" )
PATCHES=(
	"${FILESDIR}/${PN}-2.0-disable-eager-test.patch"
	"${FILESDIR}/${PN}-2.0-agnosticize-compiler.patch"
)

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_configure() {
	if [[ -z "${CXX}" ]] ; then
		export CXX="g++"
		tc-is-clang && export CXX="clang++"
	else
		export CXX
	fi
}

src_compile() {
	"./make.sh"
}

src_install() {
	dobin "bin/${MY_PN}"
	docinto "licenses"
	dodoc "LICENSE.md"
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 2.0 (20260508)
