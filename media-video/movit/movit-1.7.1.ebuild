# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# For RESTRICT="test", there's no sane way to use OpenGL from within tests?

CXX_STANDARD=14
GTEST_PV="1.8.1"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX14[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX14[@]/llvm_slot_}"
)

inherit libcxx-slot libstdcxx-slot

# Tests need gtest sources, makefile unconditionally builds tests, so ... yey!
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv x86"
SRC_URI="
https://movit.sesse.net/${P}.tar.gz
https://github.com/google/googletest/archive/refs/tags/release-${GTEST_PV}.tar.gz
	-> ${PN}-googletest-${GTEST_PV}.tar.gz
"

DESCRIPTION="High-performance, high-quality video filters for the GPU"
HOMEPAGE="https://movit.sesse.net/"
LICENSE="GPL-2+"
SLOT="0"
RESTRICT="test"
RDEPEND="
	>=sci-libs/fftw-3
	sci-libs/fftw:=
	media-libs/mesa[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},X(+)]
	media-libs/mesa:=
	media-libs/libepoxy[egl(+),X]
	media-libs/libsdl2
"
DEPEND="
	${RDEPEND}
	>=dev-cpp/eigen-3.2.0:3
	dev-cpp/eigen:=
"
BDEPEND="
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}/${PN}-1.6.3-gcc12.patch"
)

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_compile() {
	GTEST_DIR="${WORKDIR}/googletest-release-${GTEST_PV}/googletest" emake
}

src_test() {
	GTEST_DIR="${WORKDIR}/googletest-release-${GTEST_PV}/googletest" emake check
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
