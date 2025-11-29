# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=17 # Compiler default

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

inherit autotools libcxx-slot libstdcxx-slot toolchain-funcs

DESCRIPTION="Simplified Wrapper and Interface Generator"
HOMEPAGE="http://www.swig.org/ https://github.com/swig/swig"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-3+ BSD BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="ccache doc pcre test"
RESTRICT="
	!test? (
		test
	)
"
RDEPEND="
	pcre? (
		dev-libs/libpcre2
	)
	ccache? (
		virtual/zlib:=
	)
"
DEPEND="
	${RDEPEND}
	test? (
		dev-libs/boost[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
		dev-libs/boost:=
	)
"
BDEPEND="
	virtual/pkgconfig
"
DOCS=( "ANNOUNCE" "CHANGES" "CHANGES.current" "README" "TODO" )

PATCHES=(
	"${FILESDIR}/${PN}-4.1.1-ccache-configure-clang16.patch"
)

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_prepare() {
	default
	# Only needed for Clang 16 patch
	ln -s "${S}/Tools" "CCache/" || die
	AT_M4DIR="Tools/config" eautoreconf
}

src_configure() {
	econf \
		PKGCONFIG="$(tc-getPKG_CONFIG)" \
		$(use_enable ccache) \
		$(use_with pcre)
}

src_test() {
	# The tests won't get run w/o an explicit call, broken Makefiles?
	emake check
}

src_install() {
	default
	if use doc; then
		docinto "html"
		dodoc -r "Doc/"{"Devel","Manual"}
	fi
}
