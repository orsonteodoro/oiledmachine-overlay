# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CXX_STANDARD=20

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX20[@]}
)

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_STDCXX20[@]/llvm_slot_}
)

inherit cmake libcxx-slot libstdcxx-slot toolchain-funcs

KEYWORDS="amd64 ~arm arm64 ~loong ~ppc ppc64 ~riscv x86"
S="${WORKDIR}/muparser-${PV}"
SRC_URI="https://github.com/beltoforion/muparser/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="Library for parsing mathematical expressions"
HOMEPAGE="https://beltoforion.de/en/muparser/"
LICENSE="MIT"
RESTRICT="
	!test? (
		test
	)
"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+="
doc openmp test
"

pkg_pretend() {
	[[ "${MERGE_TYPE}" != "binary" ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ "${MERGE_TYPE}" != "binary" ]] && use openmp && tc-check-openmp
}

src_prepare() {
	rm -vr samples/example3 || die # unused, causing bug #951718
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DENABLE_OPENMP=$(usex openmp)
	)
	cmake_src_configure
}

pkg_setup() {
	libcxx-slot_verify
	libstdcxx-slot_verify
}
