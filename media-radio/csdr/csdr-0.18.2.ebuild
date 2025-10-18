# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# D11, U22

CXX_STANDARD=11

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX11[@]}
)

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_STDCXX11[@]/llvm_slot_}
)

CMAKE_MAKEFILE_GENERATOR="emake"

inherit cmake libcxx-slot libstdcxx-slot

KEYWORDS="~amd64"
SRC_URI="
https://github.com/jketterl/csdr/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="A simple DSP library and command-line tool for Software Defined Radio."
HOMEPAGE="https://github.com/jketterl/csdr"
LICENSE="
	BSD
	GPL-3+
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
RDEPEND+="
	>=media-libs/libsamplerate-0.1.8
	>=sci-libs/fftw-3.3:=
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-build/cmake-3.0
"
DOCS=( "README.md" )

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}
