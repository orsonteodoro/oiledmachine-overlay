# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CXX_STANDARD=17
DOCS_BUILDER="doxygen"
DOCS_DIR=""
PYTHON_COMPAT=( "python3_"{11..14} )

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]}"
)

inherit cflags-hardened cmake docs libcxx-slot libstdcxx-slot python-any-r1

DESCRIPTION="Unicode validation and transcoding at billions of characters per second"
HOMEPAGE="https://simdutf.github.io/simdutf/"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="0/25"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="
test
ebuild_revision_6
"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/libiconv
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
	doc? (
		app-text/doxygen
	)
"

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_configure(){
	cflags-hardened_append
	local mycmakeargs+=(
		-DSIMDUTF_TESTS=$(usex test)
		-DSIMDUTF_ATOMIC_BASE64_TESTS=$(usex test)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && docs_compile
}

src_install() {
	cmake_src_install
	use doc && einstalldocs
}
